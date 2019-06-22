/datum/preferences
	var/public_record = ""
	var/med_record = ""
	var/sec_record = ""
	var/gen_record = ""
	var/nanotrasen_relation = "Neutral"
	var/memory = ""
	var/chosen_pin = 1000
	var/chosen_password = "nopassword"
	//Some faction info	rmation.
	var/faction              //Antag faction/general associated faction.
	var/travel_reason        //Reason to move to the frontier, stored as a string

/datum/category_item/player_setup_item/background/records
	name = "Records"
	sort_order = 3

/datum/category_item/player_setup_item/background/records/load_character(var/savefile/S)
	from_file(S["public_record"],pref.public_record)
	from_file(S["med_record"],pref.med_record)
	from_file(S["sec_record"],pref.sec_record)
	from_file(S["gen_record"],pref.gen_record)
	from_file(S["memory"],pref.memory)
	from_file(S["faction"],pref.faction)
	from_file(S["nanotrasen_relation"],pref.nanotrasen_relation)
	from_file(S["travel_reason"], pref.travel_reason)

/datum/category_item/player_setup_item/background/records/save_character(var/savefile/S)
	to_file(S["public_record"],pref.public_record)
	to_file(S["med_record"],pref.med_record)
	to_file(S["sec_record"],pref.sec_record)
	to_file(S["gen_record"],pref.gen_record)
	to_file(S["memory"],pref.memory)
	to_file(S["faction"],pref.faction)
	to_file(S["nanotrasen_relation"],pref.nanotrasen_relation)
	to_file(S["travel_reason"], pref.travel_reason)

/datum/category_item/player_setup_item/background/records/content(var/mob/user)
	. = list()
	. += "<b>Persistence is a collaborative storytelling server. The rules are taken very seriously and it is your responsibility to know them before creating a character.</b><br><br>"
	. += "<a href='https://wiki.persistentss13.com/index.php/Rules'target='_blank'>View Server Rules</a><br>If you dont understand a rule, press F1 now and ask a question directly to the staff. We want everyone to understand these rules."
	. += "<b>Creating a shared space where exciting player-created events and stories can be created and played out is what Persistence is all about. Everyone has a responsibility to try their best to play consistently."
	. += "playing a consistent character and following our guidelines. You must play a reasonable character, integrate with the community and try to do things that are interesting for everyone participating.</b><br><br>"
	. += "<a href='https://wiki.persistentss13.com/index.php/Guide_to_Roleplaying'target='_blank'>View Collaborative Storytelling/In Character Guidelines</a><br>A lot of games have saved worlds, but Persistence is about creating stories, content and a community that lasts."
	. += "<br><br><br><br><br>"
	if(pref.rules_agree)
		. += "<b>The rules make sure that everyone can have good time.</b>"
	else
		. += "<a href='?src=\ref[src];rules_agree=1'>I have read the community rules of and I understand them.</a>"
	. += "<br><br><br><br>"
	if(pref.guide_agree)
		. += "<b>Working with others to create scenes, events and full storylines is what this community is made for. You dont have to be an expert, but you do have to put the effort in.</b>"
	else
		. += "<a href='?src=\ref[src];guide_agree=1'>I am prepared to participate in the player-made story with a reasonable character. I want to be a collaborative storyteller.</a>"

	/**
	var/datum/world_faction/F = get_faction(pref.faction)
	. += "<br/><b>Records</b>:<br/>"
	. += "<br><br>Starting Employer: <a href='?src=\ref[src];faction=1'>[F ? F.name : "Unset*"]</a>"
	if(F)
		. += "<br>[F.purpose]<br><br>"

	. += "<br><br>Bank Account Pin:<br>"
	. += "<a href='?src=\ref[src];set_pin=1'>[pref.chosen_pin]</a><br>"
	. += "<br><br>Email Account Password:<br>"
	. += "<a href='?src=\ref[src];set_password=1'>[pref.chosen_password]</a><br>"

	. += "General Notes (Public): "
	. += "<a href='?src=\ref[src];set_public_record=1'>[TextPreview(pref.public_record,40)]</a><br>"
	. += "Medical Records: "
	. += "<a href='?src=\ref[src];set_medical_records=1'>[TextPreview(pref.med_record,40)]</a><br>"
	. += "Employment Records: "
	. += "<a href='?src=\ref[src];set_general_records=1'>[TextPreview(pref.gen_record,40)]</a><br>"
	. += "Security Records: "
	. += "<a href='?src=\ref[src];set_security_records=1'>[TextPreview(pref.sec_record,40)]</a><br>"
	. += "Memory: "
	. += "<a href='?src=\ref[src];set_memory=1'>[TextPreview(pref.memory,40)]</a><br>"

	**/
	. = jointext(.,null)

/datum/category_item/player_setup_item/background/records/OnTopic(var/href,var/list/href_list, var/mob/user)
	if (href_list["set_public_record"])
		var/new_public = sanitize(input(user,"Enter general public record information here.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.public_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if (!isnull(new_public) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.public_record = new_public
		return TOPIC_REFRESH

	else if(href_list["set_medical_records"])
		var/new_medical = sanitize(input(user,"Enter medical information here.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.med_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(new_medical) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.med_record = new_medical
		return TOPIC_REFRESH

	else if(href_list["set_general_records"])
		var/new_general = sanitize(input(user,"Enter employment information here.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.gen_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(new_general) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.gen_record = new_general
		return TOPIC_REFRESH

	else if(href_list["set_security_records"])
		var/sec_medical = sanitize(input(user,"Enter security information here.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.sec_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(sec_medical) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.sec_record = sec_medical
		return TOPIC_REFRESH

	else if(href_list["set_memory"])
		var/memes = sanitize(input(user,"Enter memorized information here.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.memory)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(memes) && CanUseTopic(user))
			pref.memory = memes
		return TOPIC_REFRESH

	if(href_list["nt_relation"])
		var/new_relation = input(user, "Choose your relation to [GLOB.using_map.company_name]. Note that this represents what others can find out about your character by researching your background, not what your character actually thinks.", CHARACTER_PREFERENCE_INPUT_TITLE, pref.nanotrasen_relation)  as null|anything in COMPANY_ALIGNMENTS
		if(new_relation && CanUseTopic(user))
			pref.nanotrasen_relation = new_relation
			return TOPIC_REFRESH

	else if(href_list["faction"])
		var/list/joinable = list()
		for(var/obj/structure/frontier_beacon/beacon in GLOB.frontierbeacons)
			var/fac_uid = beacon.req_access_faction
			joinable |= get_faction(fac_uid)
		var/datum/world_faction/choice = input(user, "Please choose a starting organization.", CHARACTER_PREFERENCE_INPUT_TITLE, pref.faction? get_faction(pref.faction) : null) as null|anything in joinable
		if(choice)
			pref.faction = choice.uid
		return TOPIC_REFRESH

	else if(href_list["set_pin"])
		var/chose = input(user,"Enter starting bank pin (1000-9999)", CHARACTER_PREFERENCE_INPUT_TITLE) as num
		if(chose > 9999 || chose < 1000)
			to_chat(user, "Your pin must be between 1000 and 9999")
		else
			pref.chosen_pin = chose
		return TOPIC_REFRESH
	

	else if(href_list["rules_agree"])
		pref.rules_agree = 1
		return TOPIC_REFRESH
	else if(href_list["guide_agree"])
		pref.guide_agree = 1
		return TOPIC_REFRESH

	else if(href_list["set_password"])
		var/chose = sanitize(input(user, "Please enter a email password.", "Email Password")  as text|null, MAX_NAME_LEN)
		if(chose)
			pref.chosen_password = chose
		else
			to_chat(usr, "The password was invalid.")
		return TOPIC_REFRESH

	. =  ..()
