GLOBAL_LIST_EMPTY(all_crew_records)
GLOBAL_LIST_INIT(blood_types, list("A-", "A+", "B-", "B+", "AB-", "AB+", "O-", "O+"))
GLOBAL_LIST_INIT(physical_statuses, list("Active", "Disabled", "SSD", "Deceased", "MIA"))
GLOBAL_VAR_INIT(default_physical_status, "Active")
GLOBAL_LIST_INIT(security_statuses, list("None", "Released", "Parolled", "Incarcerated", "Arrest"))
GLOBAL_VAR_INIT(default_security_status, "None")
GLOBAL_VAR_INIT(arrest_security_status, "Arrest")
GLOBAL_VAR_INIT(default_citizenship, RESIDENT)
GLOBAL_LIST_INIT(citizenship_statuses, list(RESIDENT, CITIZEN, PRISONER))
#define GETTER_SETTER(PATH, KEY) /datum/computer_file/report/crew_record/proc/get_##KEY(){var/datum/report_field/F = locate(/datum/report_field/##PATH/##KEY) in fields; if(F) return F.get_value()} \
/datum/computer_file/report/crew_record/proc/set_##KEY(given_value){var/datum/report_field/F = locate(/datum/report_field/##PATH/##KEY) in fields; if(F) F.set_value(given_value)}
#define SETUP_FIELD(NAME, KEY, PATH, ACCESS, ACCESS_EDIT) GETTER_SETTER(PATH, KEY); /datum/report_field/##PATH/##KEY;\
/datum/computer_file/report/crew_record/generate_fields(){..(); var/datum/report_field/##KEY = add_field(/datum/report_field/##PATH/##KEY, ##NAME);\
KEY.set_access(ACCESS, ACCESS_EDIT || ACCESS || core_access_reassignment)}

// Fear not the preprocessor, for it is a friend. To add a field, use one of these, depending on value type and if you need special access to see it.
// It will also create getter/setter procs for record datum, named like /get_[key here]() /set_[key_here](value) e.g. get_name() set_name(value)
// Use getter setters to avoid errors caused by typoing the string key.
#define FIELD_SHORT(NAME, KEY, ACCESS, ACCESS_EDIT) SETUP_FIELD(NAME, KEY, simple_text/crew_record, ACCESS, ACCESS_EDIT)
#define FIELD_LONG(NAME, KEY, ACCESS, ACCESS_EDIT) SETUP_FIELD(NAME, KEY, pencode_text/crew_record, ACCESS, ACCESS_EDIT)
#define FIELD_NUM(NAME, KEY, ACCESS, ACCESS_EDIT) SETUP_FIELD(NAME, KEY, number/crew_record, ACCESS, ACCESS_EDIT)
#define FIELD_LIST(NAME, KEY, OPTIONS, ACCESS, ACCESS_EDIT) FIELD_LIST_EDIT(NAME, KEY, OPTIONS, ACCESS, ACCESS_EDIT)
#define FIELD_LIST_EDIT(NAME, KEY, OPTIONS, ACCESS, ACCESS_EDIT) SETUP_FIELD(NAME, KEY, options/crew_record, ACCESS, ACCESS_EDIT);\
/datum/report_field/options/crew_record/##KEY/get_options(){return OPTIONS}

// GENERIC RECORDS
FIELD_SHORT("Name", name, null, core_access_reassignment)
FIELD_SHORT("Formal Name", formal_name, null, core_access_reassignment)
FIELD_SHORT("Job", job, null, core_access_reassignment)
FIELD_LIST("Sex", sex, record_genders(), null, core_access_reassignment)
FIELD_NUM("Age", age, null, core_access_reassignment)
FIELD_LIST_EDIT("Status", status, GLOB.physical_statuses, null, core_access_medical_programs)
FIELD_LIST_EDIT("Citizenship", citizenship, GLOB.citizenship_statuses, null, core_access_reassignment)

FIELD_SHORT("Species",species, null, core_access_reassignment)
FIELD_LIST("Branch", branch, record_branches(), null, core_access_reassignment)
FIELD_LIST("Rank", rank, record_ranks(), null, core_access_reassignment)

FIELD_LONG("General Notes (Public)", public_record, null, core_access_reassignment)

// MEDICAL RECORDS
FIELD_LIST("Blood Type", bloodtype, GLOB.blood_types, core_access_medical_programs, core_access_medical_programs)
FIELD_LONG("Medical Record", medRecord, core_access_medical_programs, core_access_medical_programs)
FIELD_SHORT("Religion", religion, core_access_medical_programs, core_access_medical_programs)

// SECURITY RECORDS
FIELD_LIST("Criminal Status", criminalStatus, GLOB.security_statuses, core_access_security_programs, core_access_security_programs)
FIELD_LONG("Security Record", secRecord, core_access_security_programs, core_access_security_programs)
FIELD_SHORT("DNA", dna, core_access_security_programs, core_access_security_programs)
FIELD_SHORT("Fingerprint", fingerprint, core_access_security_programs, core_access_security_programs)

// EMPLOYMENT RECORDS
FIELD_LONG("Employment Record", emplRecord, core_access_reassignment, core_access_reassignment)
FIELD_SHORT("Home System", homeSystem, core_access_reassignment, core_access_reassignment)
FIELD_SHORT("Faction", faction, core_access_reassignment, core_access_reassignment)
FIELD_LONG("Qualifications", skillset, core_access_reassignment, core_access_reassignment)

// ANTAG RECORDS
FIELD_LONG("Exploitable Information", antagRecord, access_syndicate, access_syndicate)

/datum/personal_limits
	var/stock_limit = 0
	var/shuttle_limit = 0
	var/cost = 0

	
/datum/personal_limits/one
	stock_limit = 125

/datum/personal_limits/two
	stock_limit = 175
	shuttle_limit = 1
	cost = 3000

/datum/personal_limits/three
	stock_limit = 225
	shuttle_limit = 2
	cost = 6500

/datum/personal_limits/four
	stock_limit = 275
	shuttle_limit = 3
	cost = 10000


























/datum/computer_file/report/crew_record/proc/get_holdings()
	var/total = 0
	for(var/datum/world_faction/business/faction in GLOB.all_world_factions)
		var/holding = faction.get_stockholder(usr.real_name)
		if(holding)
			total += holding
	return total

/datum/computer_file/report/crew_record/proc/get_limits()
	switch(network_level)
		if(1)
			return new /datum/personal_limits/one()
		if(2)
			return new /datum/personal_limits/two()
		if(3)
			return new /datum/personal_limits/three()
		if(4)
			return new /datum/personal_limits/four()
		else
			return new /datum/personal_limits/one()


/datum/computer_file/report/crew_record/proc/upgrade(var/mob/user)
	var/cost = get_upgrade_cost()
	if(network_level >= 4) return
	if(linked_account.money < cost)
		to_chat(user, "Insufficent funds.")
		return
	var/datum/transaction/Te = new("Nexus Account Upgrade", "Nexus Account Upgrade", -cost, "Nexus Account Upgrade")
	linked_account.do_transaction(Te)
	network_level++

/datum/computer_file/report/crew_record/proc/get_stock_limit()
	switch(network_level)
		if(1)
			var/datum/personal_limits/limit = new /datum/personal_limits/one()
			return limit.stock_limit
		if(2)
			var/datum/personal_limits/limit = new /datum/personal_limits/two()
			return limit.stock_limit
		if(3)
			var/datum/personal_limits/limit = new /datum/personal_limits/three()
			return limit.stock_limit
		if(4)
			var/datum/personal_limits/limit = new /datum/personal_limits/four()
			return limit.stock_limit
		else
			var/datum/personal_limits/limit = new /datum/personal_limits/one()
			return limit.stock_limit
			
/datum/computer_file/report/crew_record/proc/get_shuttle_limit()
	switch(network_level)
		if(1)
			var/datum/personal_limits/limit = new /datum/personal_limits/one()
			return limit.shuttle_limit
		if(2)
			var/datum/personal_limits/limit = new /datum/personal_limits/two()
			return limit.shuttle_limit
		if(3)
			var/datum/personal_limits/limit = new /datum/personal_limits/three()
			return limit.shuttle_limit
		if(4)
			var/datum/personal_limits/limit = new /datum/personal_limits/four()
			return limit.shuttle_limit
		else
			var/datum/personal_limits/limit = new /datum/personal_limits/one()
			return limit.shuttle_limit
			
			
/datum/computer_file/report/crew_record/proc/get_upgrade_cost()
	switch(network_level)
		if(1)
			var/datum/personal_limits/limit = new /datum/personal_limits/two()
			return limit.cost
		if(2)
			var/datum/personal_limits/limit = new /datum/personal_limits/three()
			return limit.cost
		if(3)
			var/datum/personal_limits/limit = new /datum/personal_limits/four()
			return limit.cost

/datum/computer_file/report/crew_record/proc/get_upgrade_desc()
	switch(network_level)
		if(1)
			return "Increase stock limit to 175 and gain a personal shuttle."
		if(2)
			return "Increase stock limit to 225 and gain another personal shuttle."
		if(3)
			return "Increase stock limit to 275 and gain another personal shuttle."

// Kept as a computer file for possible future expansion into servers.
/datum/computer_file/report/crew_record
	filetype = "CDB"
	size = 2

	// String fields that can be held by this record.
	// Try to avoid manipulating the fields_ variables directly - use getters/setters below instead.
	var/icon/photo_front = null
	var/icon/photo_side = null
	var/datum/money_account/linked_account
	var/suspended = 0
	var/terminated = 0
	var/assignment_uid
	var/list/promote_votes = list()
	var/list/demote_votes = list()
	var/rank = 0
	var/custom_title
	var/assignment_data = list() // format = list(assignment_uid = rank)
	var/validate_time = 0
	var/worked = 0
	var/expenses = 0
	var/datum/computer_file/data/email_account/email
	var/citizenship = RESIDENT 
	var/ckey


	var/network_level = 1
	var/notifications = 1 // whether or not to be notified when a new email is sent
	var/list/subscribed_orgs = list()
	var/list/shuttles = list()
	var/last_health_alarm = 0
	
	var/visibility_status = 1 // whether or not to show online to social groups and friends
	
	var/list/all_friends = list() // just a list of real_names
	
	var/list/pending_friend_request = list() // list of people trying to become friends
	
/datum/computer_file/report/crew_record/New()
	..()
	for(var/T in subtypesof(/datum/report_field/))
		new T(src)
	load_from_mob(null)

	ADD_SAVED_VAR(pending_friend_request)
	ADD_SAVED_VAR(all_friends)
	ADD_SAVED_VAR(visibility_status)
	ADD_SAVED_VAR(photo_front)
	ADD_SAVED_VAR(photo_side)
	ADD_SAVED_VAR(linked_account)
	ADD_SAVED_VAR(email)
	ADD_SAVED_VAR(suspended)
	ADD_SAVED_VAR(terminated)
	ADD_SAVED_VAR(assignment_uid)
	ADD_SAVED_VAR(promote_votes)
	ADD_SAVED_VAR(demote_votes)
	ADD_SAVED_VAR(rank)
	ADD_SAVED_VAR(custom_title)
	ADD_SAVED_VAR(assignment_data)
	ADD_SAVED_VAR(validate_time)
	ADD_SAVED_VAR(worked)
	ADD_SAVED_VAR(expenses)
	ADD_SAVED_VAR(citizenship)
	ADD_SAVED_VAR(ckey)

	ADD_SKIP_EMPTY(assignment_uid)
	ADD_SKIP_EMPTY(custom_title)

/datum/computer_file/report/crew_record/Destroy()
	. = ..()
	GLOB.all_crew_records.Remove(src)

/datum/computer_file/report/crew_record/proc/try_duty()
	if(suspended > world.realtime || terminated)
		return 0
	else
		return assignment_uid

/datum/computer_file/report/crew_record/proc/check_rank_change(var/datum/world_faction/faction)
	var/list/all_promotes = list()
	var/list/three_promotes = list()
	var/list/five_promotes = list()
	var/list/all_demotes = list()
	var/list/three_demotes = list()
	var/list/five_demotes = list()
	var/datum/assignment/curr_assignment = faction.get_assignment(assignment_uid, get_name())
	if(!curr_assignment) return 0
	for(var/name in promote_votes)
		if(name == faction.get_leadername())
			five_promotes |= name
			three_promotes |= name
			all_promotes |= name
			continue
		if(name == get_name()) continue
		var/datum/computer_file/report/crew_record/record = faction.get_record(name)
		if(record)
			var/datum/assignment/assignment = faction.get_assignment(record.assignment_uid, record.get_name())
			if(assignment)
				if(assignment.parent)
					var/promoter_command = (assignment.parent.command_faction)
					var/promoter_head = (assignment.parent.head_position && assignment.parent.head_position.uid == assignment.uid)
					var/curr_command = curr_assignment.parent.command_faction
					var/curr_head = (curr_assignment.parent.head_position && curr_assignment.parent.head_position.uid == curr_assignment.uid)
					var/same_dept = (assignment.parent.name == curr_assignment.parent.name)
					if(promoter_command)
						if(curr_command)
							if(curr_head)
								if(promoter_head)
									if(record.rank <= rank)
										continue
								else
									continue
					else
						if(curr_command) continue
						if(curr_head && !promoter_head) continue
						if(!same_dept) continue
						if(promoter_head)
							if(curr_head)
								if(record.rank <= rank)
									continue
						else
							if(record.rank <= rank)
								continue

		if(record.rank <= 5)
			five_promotes |= record.get_name()
		if(record.rank <= 3)
			three_promotes |= record.get_name()
		all_promotes |= record.get_name()


	if(five_promotes.len >= faction.five_promote_req)
		rank++
		promote_votes.Cut()
		demote_votes.Cut()
		update_ids(get_name())
		return
	if(three_promotes.len >= faction.three_promote_req)
		rank++
		promote_votes.Cut()
		demote_votes.Cut()
		update_ids(get_name())
		return
	if(all_promotes.len >= faction.all_promote_req)
		rank++
		promote_votes.Cut()
		demote_votes.Cut()
		update_ids(get_name())
		return
	for(var/name in demote_votes)
		if(name == faction.get_leadername())
			five_demotes |= name
			three_demotes |= name
			all_demotes |= name
			continue
		if(name == get_name()) continue
		var/datum/computer_file/report/crew_record/record = faction.get_record(name)
		if(record)
			var/datum/assignment/assignment = faction.get_assignment(record.assignment_uid, record.get_name())
			if(assignment)
				if(assignment.parent)
					var/promoter_command = (assignment.parent.command_faction)
					var/promoter_head = (assignment.parent.head_position && assignment.parent.head_position.uid == assignment.uid)
					var/curr_command = curr_assignment.parent.command_faction
					var/curr_head = (curr_assignment.parent.head_position && curr_assignment.parent.head_position.uid == curr_assignment.uid)
					var/same_dept = (assignment.parent.name == curr_assignment.parent.name)
					if(promoter_command)
						if(curr_command)
							if(curr_head)
								if(promoter_head)
									if(record.rank <= rank)
										continue
								else
									continue
					else
						if(curr_command) continue
						if(curr_head && !promoter_head) continue
						if(!same_dept) continue
						if(promoter_head)
							if(curr_head)
								if(record.rank <= rank)
									continue
						else
							if(record.rank <= rank)
								continue

		if(record.rank <= 5)
			five_demotes |= record.get_name()
		if(record.rank <= 3)
			three_demotes |= record.get_name()
		all_demotes |= record.get_name()

	if(five_demotes.len >= faction.five_promote_req)
		rank--
		promote_votes.Cut()
		demote_votes.Cut()
		update_ids(get_name())
		return
	if(three_demotes.len >= faction.three_promote_req)
		rank--
		promote_votes.Cut()
		demote_votes.Cut()
		update_ids(get_name())
		return
	if(all_demotes.len >= faction.all_promote_req)
		rank--
		promote_votes.Cut()
		demote_votes.Cut()
		update_ids(get_name())
		return

/datum/computer_file/report/crew_record/proc/load_from_id(var/obj/item/weapon/card/id/card)
	if(!istype(card))
		return 0
	photo_front = card.front
	photo_side = card.side

	set_name(card.registered_name)
	set_job("Unset")
	set_sex(card.sex)
	set_age(card.age)
	set_status(GLOB.default_physical_status)
	set_species(card.species)
	set_citizenship(GLOB.default_citizenship)
	
	// Medical record
	set_bloodtype(card.blood_type)
	set_medRecord("No record supplied")

	// Security record
	set_criminalStatus(GLOB.default_security_status)
	set_dna(card.dna_hash)
	set_fingerprint(card.fingerprint_hash)
	set_secRecord("No record supplied")

	// Employment record
	set_emplRecord("No record supplied")
	return 1

/datum/computer_file/report/crew_record/proc/load_from_global(var/real_name)
	var/datum/computer_file/report/crew_record/record
	for(var/datum/computer_file/report/crew_record/R in GLOB.all_crew_records)
		if(R.get_name() == real_name)
			record = R
			break
	if(!record)
		record = Retrieve_Record(real_name)
	if(!record)
		return 0
	photo_front = record.photo_front
	photo_side = record.photo_side
	set_name(record.get_name())
	set_job(record.get_job())
	set_sex(record.get_sex())
	set_age(record.get_age())
	set_status(record.get_status())
	set_species(record.get_species())
	set_citizenship(record.get_citizenship())

	// Medical record
	set_bloodtype(record.get_bloodtype())
	set_medRecord("No record supplied")

	// Security record
	set_criminalStatus(GLOB.default_security_status)
	set_dna(record.get_dna())
	set_fingerprint(record.get_fingerprint())
	set_secRecord("No record supplied")

	// Employment record
	set_emplRecord("No record supplied")
	set_homeSystem(record.get_homeSystem())
	set_religion(record.get_religion())
	return 1

/datum/computer_file/report/crew_record/proc/load_from_mob(var/mob/living/carbon/human/H)
	if(istype(H))
		if(H.mind && H.mind.initial_account)
			linked_account = H.mind.initial_account
		photo_front = getFlatIcon(H, SOUTH, always_use_defdir = 1)
		photo_side = getFlatIcon(H, WEST, always_use_defdir = 1)
	else
		var/mob/living/carbon/human/dummy = new()
		photo_front = getFlatIcon(dummy, SOUTH, always_use_defdir = 1)
		photo_side = getFlatIcon(dummy, WEST, always_use_defdir = 1)
		qdel(dummy)

	if(!email && H)
		email = new()
		email.login = H.real_name
	// Add honorifics, etc.
	var/formal_name = "Unset"
	if(H)
		formal_name = H.real_name
		if(H.client && H.client.prefs)
			for(var/culturetag in H.client.prefs.cultural_info)
				var/decl/cultural_info/culture = SSculture.get_culture(H.client.prefs.cultural_info[culturetag])
				if(H.char_rank && H.char_rank.name_short)
					formal_name = "[formal_name][culture.get_formal_name_suffix()]"
				else
					formal_name = "[culture.get_formal_name_prefix()][formal_name][culture.get_formal_name_suffix()]"

	// Generic record
	set_name(H ? H.real_name : "Unset")
	set_formal_name(formal_name)
	set_job(H ? GetAssignment(H) : "Unset")
	var/gender_term = "Unset"
	if(H)
		var/datum/gender/G = gender_datums[H.get_sex()]
		if(G)
			gender_term = gender2text(G.formal_term)
	set_sex(gender_term)
	set_age(H ? H.age : 30)
	set_status(GLOB.default_physical_status)
	set_species(H ? H.get_species() : SPECIES_HUMAN)
	set_branch(H ? (H.char_branch && H.char_branch.name) : "None")
	set_rank(H ? (H.char_rank && H.char_rank.name) : "None")
	set_public_record(H && H.public_record && !jobban_isbanned(H, "Records") ? html_decode(H.public_record) : "No record supplied")
	set_citizenship(H ? H.citizenship : GLOB.default_citizenship )

	// Medical record
	set_bloodtype(H ? H.b_type : "Unset")
	set_medRecord((H && H.med_record && !jobban_isbanned(H, "Records") ? html_decode(H.med_record) : "No record supplied"))

	// Security record
	set_criminalStatus(GLOB.default_security_status)
	set_dna(H ? H.dna.unique_enzymes : "")
	set_fingerprint(H ? md5(H.dna.uni_identity) : "")
	set_secRecord(H && H.sec_record && !jobban_isbanned(H, "Records") ? html_decode(H.sec_record) : "No record supplied")

	// Employment record
	var/employment_record = "No record supplied"
	if(H)
		if(H.gen_record && !jobban_isbanned(H, "Records"))
			employment_record = html_decode(H.gen_record)
		if(H.client && H.client.prefs)
			var/list/qualifications
			for(var/culturetag in H.client.prefs.cultural_info)
				var/decl/cultural_info/culture = SSculture.get_culture(H.client.prefs.cultural_info[culturetag])
				var/extra_note = culture.get_qualifications()
				if(extra_note)
					LAZYADD(qualifications, extra_note)
			if(LAZYLEN(qualifications))
				employment_record = "[employment_record ? "[employment_record]\[br\]" : ""][jointext(qualifications, "\[br\]>")]"
	set_emplRecord(employment_record)

	// Misc cultural info.
	set_homeSystem(H ? html_decode(H.get_cultural_value(TAG_HOMEWORLD)) : "Unset")
	set_faction(H ? html_decode(H.get_cultural_value(TAG_FACTION)) : "Unset")
	set_religion(H ? html_decode(H.get_cultural_value(TAG_RELIGION)) : "Unset")

	if(H)
		var/skills = list()
		for(var/decl/hierarchy/skill/S in GLOB.skills)
			var/level = H.get_skill_value(S.type)
			if(level > SKILL_NONE && LAZYLEN(S.levels) >= level)
				skills += "[S.name], [S.levels[level]]"
			else if(LAZYLEN(S.levels) >= level)
				log_debug("crew_report.load_from_mob(): trying to access non-existent skill level '[level]' from skill '[S.name]', which has only [LAZYLEN(S.levels)] levels!")

		set_skillset(jointext(skills,"\n"))

	// Antag record
	set_antagRecord(H && H.exploit_record && !jobban_isbanned(H, "Records") ? html_decode(H.exploit_record) : "")

// Returns independent copy of this file.
/datum/computer_file/report/crew_record/clone(var/rename = 0)
	var/datum/computer_file/report/crew_record/temp = ..()
	return temp

/datum/computer_file/report/crew_record/proc/get_field(var/field_type)
	var/datum/report_field/F = locate(field_type) in fields
	if(F)
		return F.get_value()

/datum/computer_file/report/crew_record/proc/set_field(var/field_type, var/value)
	var/datum/report_field/F = locate(field_type) in fields
	if(F)
		return F.set_value(value)

// Global methods
// Used by character creation to create a record for new arrivals.
/proc/CreateModularRecord(var/mob/living/carbon/human/H)
	for(var/datum/computer_file/report/crew_record/R in GLOB.all_crew_records)
		if(R.get_name() == H.real_name)
			message_admins("[H.real_name]'s record already found heh")
			return R
	var/datum/computer_file/report/crew_record/R = Retrieve_Record(H.real_name)
	if(R) return R
	var/datum/computer_file/report/crew_record/CR = new/datum/computer_file/report/crew_record()
	GLOB.all_crew_records.Add(CR)
	CR.load_from_mob(H)
	return CR

// Gets crew records filtered by set of positions
/proc/department_crew_manifest(var/list/filter_positions, var/blacklist = FALSE)
	var/list/matches = list()
	for(var/datum/computer_file/report/crew_record/CR in GLOB.all_crew_records)
		var/rank = CR.get_job()
		if(blacklist)
			if(!(rank in filter_positions))
				matches.Add(CR)
		else
			if(rank in filter_positions)
				matches.Add(CR)
	return matches

// Simple record to HTML (for paper purposes) conversion.
// Not visually that nice, but it gets the work done, feel free to tweak it visually
/proc/record_to_html(var/datum/computer_file/report/crew_record/CR, var/access, var/faction_uid)
	var/dat = "<tt><H2>RECORD DATABASE DATA DUMP</H2><i>Generated on: [stationdate2text()] [stationtime2text()]</i><br>******************************<br>"
	dat += "<table>"
	for(var/datum/report_field/F in CR.fields)
		if(F.verify_access(access, faction_uid))
			dat += "<tr><td><b>[F.display_name()]</b>"
			if(F.needs_big_box)
				dat += "<tr>"
			dat += "<td>[F.get_value()]"
	dat += "</tt>"
	return dat

/proc/get_crewmember_record(var/name)
	for(var/datum/computer_file/report/crew_record/CR in GLOB.all_crew_records)
		if(CR.get_name() == name)
			return CR
	var/datum/computer_file/report/crew_record/R = Retrieve_Record(name)
	if(R) return R
	return null

/proc/GetAssignment(var/mob/living/carbon/human/H)
	if(!H)
		return "Unassigned"
	if(!H.mind)
		return H.job
	if(H.mind.role_alt_title)
		return H.mind.role_alt_title
	return H.mind.assigned_role


//Options builderes
/datum/report_field/options/crew_record/rank/proc/record_ranks()
	var/datum/computer_file/report/crew_record/record = owner
	var/datum/mil_branch/branch = mil_branches.get_branch(record.get_branch())
	if(!branch)
		return
	. = list()
	. |= "Unset"
	for(var/rank in branch.ranks)
		var/datum/mil_rank/RA = branch.ranks[rank]
		. |= RA.name

/datum/report_field/options/crew_record/sex/proc/record_genders()
	. = list()
	. |= "Unset"
	for(var/thing in gender_datums)
		var/datum/gender/G = gender_datums[thing]
		. |= gender2text(G.formal_term)

/datum/report_field/options/crew_record/branch/proc/record_branches()
	. = list()
	. |= "Unset"
	for(var/B in mil_branches.branches)
		var/datum/mil_branch/BR = mil_branches.branches[B]
		. |= BR.name

#undef GETTER_SETTER
#undef SETUP_FIELD
#undef FIELD_SHORT
#undef FIELD_LONG
#undef FIELD_NUM
#undef FIELD_LIST
#undef FIELD_LIST_EDIT
