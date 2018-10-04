GLOBAL_LIST_EMPTY(neural_laces)
/mob/var/perma_dead = 0

/mob/living/carbon/human/proc/create_stack()
	set waitfor=0
	sleep(10)
	internal_organs_by_name[BP_STACK] = new /obj/item/organ/internal/stack(src,1)
	to_chat(src, "<span class='notice'>You feel a faint sense of vertigo as your neural lace boots.</span>")

/obj/item/organ/internal/stack
	name = "neural lace"
	parent_organ = BP_HEAD
	icon_state = "cortical-stack"
	organ_tag = BP_STACK
	robotic = ORGAN_ROBOT
	vital = 1
	origin_tech = list(TECH_BIO = 4, TECH_MATERIAL = 4, TECH_MAGNET = 2, TECH_DATA = 3)
	relative_size = 10

	var/ownerckey
	var/invasive
	var/default_language
	var/save_slot
	var/list/languages = list()
	var/datum/mind/backup
	action_button_name = "Access Neural Lace UI"
	action_button_is_hands_free = 1
	var/connected_faction = ""
	var/duty_status = 0
	var/datum/world_faction/faction
	var/mob/living/carbon/lace/lacemob
	var/sensor = 0

	var/business_mode = 0
	var/connected_business = ""

/obj/item/organ/internal/stack/New()
	..()
	GLOB.neural_laces |= src
	do_backup()
	robotize()

/obj/item/organ/internal/stack/Destroy()
	if(lacemob && ((lacemob.key && lacemob.key != "") || (lacemob.key && lacemob.key != "")))
		loc = get_turf(loc)
		log_and_message_admins("Attempted to destroy an in-use neural lace!")
		return QDEL_HINT_LETMELIVE
	QDEL_NULL(lacemob)
	GLOB.neural_laces -= src
	. = ..()

/obj/item/organ/internal/stack/examine(mob/user) // -- TLE
	. = ..(user)
	if(lacemob?.key)	// Ff thar be a brain inside... the brain.
		to_chat(user, "This one looks occupied and ready for cloning, the conciousness clearly present and active.")

	else if(lacemob?.stored_ckey)
		to_chat(user, "This one appears inactive, the conciousness is resting and the transfer cannot complete until it 'wakes'.")

	else
		to_chat(user, "This one seems particularly lifeless. Perhaps it will regain some of its luster later..")

/obj/item/organ/internal/stack/ex_act(severity)
	return

/obj/item/organ/internal/stack/proc/transfer_identity(var/mob/living/carbon/H)

	if(!lacemob)
		lacemob = new(src)

	lacemob.name = H.real_name
	lacemob.real_name = H.real_name
	lacemob.dna = H.dna.Clone()
	lacemob.timeofhostdeath = H.timeofdeath
	lacemob.container = src
	if(owner && isnull(owner.gc_destroyed))
		lacemob.container2 = owner
	lacemob.spawn_loc = H.spawn_loc
	lacemob.spawn_loc_2 = H.spawn_loc_2

	if(H.mind)
		H.mind.transfer_to(lacemob)

	to_chat(lacemob, "<span class='notice'>You feel slightly disoriented. Your conciousness suddenly shifts into a neural lace.</span>")

/obj/item/organ/internal/stack/proc/get_owner_name()
	var/mob/M = get_owner()
	if(M)
		return M.real_name
	return 0

/obj/item/organ/internal/stack/proc/get_owner()
	if(lacemob)
		return lacemob
	if(istype(loc.loc, /mob/living/silicon/robot))
		return loc.loc
	if(owner)
		return owner
	return 0

/obj/item/organ/internal/stack/ui_action_click()
	if(lacemob)
		ui_interact(lacemob)
	else if(istype(loc, /obj/item/device/lmi) && istype(loc.loc, /mob/living/silicon/robot))
		ui_interact(loc.loc)	// A robot
	else if(owner)
		ui_interact(owner)
	else
		log_and_message_admins("[src] called ui_action_click without any owner!")

/obj/item/organ/internal/stack/Topic(href, href_list)
	switch (href_list["action"])
		if("clock_out")
		if("off_duty")
			duty_status = 0
		if("on_duty")
			if(try_duty())
				duty_status = 1
			else
				to_chat(usr, "Your duty signal was rejected.")
		if("disconnect")
			if(faction)
				faction.connected_laces -= src
				faction = null
				connected_faction = ""
		if("connect")
			faction = locate(href_list["selected_ref"])
			if(!faction) return 0
			connected_faction = faction.uid
			try_connect()
		if("sensor_off")
			sensor = 0
		if("sensor_on")
			sensor = 1
		if("logoff")
			var/mob/new_player/M = new /mob/new_player()
			M.loc = null
			lacemob.stored_ckey = lacemob.ckey
			M.key = lacemob.key
		if("die")
			var/choice = input(usr,"THIS WILL PERMANENTLY KILL YOUR CHARACTER! YOU WILL NOT BE ALLOWED TO REMAKE THE SAME CHARACTER.") in list("Kill my character, return to character creation", "Cancel")
			if(choice == "Kill my character, return to character creation")
				if(input("Are you SURE you want to delete [CharacterName(save_slot, lacemob.ckey)]? THIS IS PERMANENT. enter the character\'s full name to conform.", "DELETE A CHARACTER", "") == CharacterName(save_slot, lacemob.ckey))
					fdel(load_path(lacemob.ckey, "[save_slot].sav"))

				var/mob/new_player/M = new /mob/new_player()
				M.loc = null
				M.key = lacemob.key

				lacemob.perma_dead = 1
				lacemob.ckey = null
				lacemob.stored_ckey = null
				lacemob.save_slot = 0

				owner?.perma_dead = 1
				owner?.ckey = null
				owner?.stored_ckey = null
				owner?.save_slot = 0

	GLOB.nanomanager.update_uis(src)

/obj/item/organ/internal/stack/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.interactive_state)
	var/list/data = list()
	try_connect()
	if(lacemob)
		data["lacemob"] = 1
		data["sensor"] = sensor
	if(business_mode)
		var/datum/small_business/business = get_business(connected_business)
		data["business_name"] = business.name
	else if(faction)
		data["faction_name"] = faction.name
		if(duty_status == 1)
			try_duty()
		data["duty_status"] = duty_status ? "On Duty" : "Off Duty"
		data["duty_status_num"] = duty_status
	else
		var/list/potential = get_potential()
		var/list/formatted[0]
		for(var/datum/world_faction/fact in potential)
			formatted[++formatted.len] = list("name" = fact.name, "ref" = "\ref[fact]")
		data["potential"] = formatted
	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "lace.tmpl", "[name] UI", 550, 450, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/obj/item/organ/internal/stack/proc/get_potential()
	if(!owner)
		var/list/potential[0]
		if(istype(loc, /obj/item/device/lmi))
			if(istype(loc.loc, /mob/living/silicon/robot))
				var/mob/living/silicon/robot/robot = loc.loc
				for(var/datum/world_faction/fact in GLOB.all_world_factions)
					var/datum/computer_file/crew_record/record = fact.get_record(robot.real_name)
					if(record)
						potential |= fact
		return potential

	var/list/potential[0]
	for(var/datum/world_faction/fact in GLOB.all_world_factions)
		var/datum/computer_file/crew_record/record = fact.get_record(owner.real_name)
		if(record)
			potential |= fact

	return potential

/obj/item/organ/internal/stack/proc/try_duty()
	var/mob/living/silicon/robot/robot
	if(istype(loc, /obj/item/device/lmi))
		if(istype(loc.loc, /mob/living/silicon/robot))
			robot = loc.loc
	if((!owner || !faction) && !robot)
		duty_status = 0
		return
	var/datum/computer_file/crew_record/record
	if(!robot)
		record = faction.get_record(owner.real_name)
	else
		record = faction.get_record(robot.real_name)
	if(!record)
		faction = null
		duty_status = 0
		return
	var/assignment_uid = record.try_duty()
	if(assignment_uid)
		var/datum/assignment/assignment = faction.get_assignment(assignment_uid)
		if(assignment && assignment.duty_able)
			return 1
		else
			duty_status = 0
			return
	else
		duty_status = 0
		return

/obj/item/organ/internal/stack/proc/try_connect()
	if(!owner) return 0
	faction = get_faction(connected_faction)
	if(!faction) return 0
	var/datum/computer_file/crew_record/record = faction.get_record(owner.real_name)
	if(!record)
		faction = null
		return 0
	else
		faction.connected_laces |= src
/obj/item/organ/internal/stack/emp_act()
	return

/obj/item/organ/internal/stack/getToxLoss()
	return 0

/obj/item/organ/internal/stack/vox
	name = "cortical stack"
	invasive = 1
	action_button_name = "Access Cortical Stack UI"

/obj/item/organ/internal/stack/proc/do_backup()
	if(owner && owner.stat != DEAD && !is_broken() && owner.mind)
		languages = owner.languages.Copy()
		backup = owner.mind
		default_language = owner.default_language
		save_slot = owner.save_slot
		if(owner.ckey)
			ownerckey = owner.ckey ? owner.ckey : owner.stored_ckey



/obj/item/organ/internal/stack/after_load()
	..()
	try_connect()
	if(duty_status)
		try_duty()

/obj/item/organ/internal/stack/proc/backup_inviable()
	return 	(!istype(backup) || backup == owner.mind || (backup.current && backup.current.stat != DEAD))

/obj/item/organ/internal/stack/replaced(var/mob/living/carbon/human/target, var/obj/item/organ/external/affected)
	if(!..(target, affected))
		message_admins("stack replace() failed")
		return 0

	if(lacemob)
		. = overwrite()		// If overwrite returns 0, then we pass it on
		lacemob.ckey = null
		QDEL_NULL(lacemob)
		return

	if(owner && !backup_inviable())
		var/current_owner = owner
		var/response = input(find_dead_player(ownerckey, 1), "Your neural backup has been placed into a new body. Do you wish to return to life?", "Resleeving") as anything in list("Yes", "No")
		if(src && response == "Yes" && owner == current_owner)
			overwrite()
	sleep(-1)

	do_backup()

	return 1

/obj/item/organ/internal/stack/removed(var/mob/living/user, var/drop_organ=1, var/detach=1)
	do_backup()
	if(!istype(owner))
		message_admins("Removed Failed")
		return ..(user, drop_organ, detach)

	if(name == initial(name))
		name = "\the [owner.real_name]'s [initial(name)]"

	transfer_identity(owner)


	..(user, drop_organ, detach)

/obj/item/organ/internal/stack/vox/removed()
	var/obj/item/organ/external/head = owner.get_organ(parent_organ)
	owner.visible_message("<span class='danger'>\The [src] rips gaping holes in \the [owner]'s [head.name] as it is torn loose!</span>")
	head.take_damage(rand(15,20))
	for(var/obj/item/organ/O in head.contents)
		O.take_damage(rand(30,70))
	..()

/obj/item/organ/internal/stack/proc/overwrite()
	if(owner.mind && owner.ckey) //Someone is already in this body!
		owner.visible_message("<span class='danger'>\The [owner] spasms violently!</span>")
		to_chat(owner, "<span class='danger'>You fight off the invading tendrils of another mind, holding onto your own body!</span>")
		return 0	// People should not be able to overwrite someone else.
	backup.active = 1
	backup.transfer_to(owner)
	if(default_language)
		owner.default_language = default_language
	owner.languages = languages.Copy()
	owner.save_slot = save_slot
	to_chat(owner, "<span class='notice'>Consciousness slowly creeps over you as your new body awakens.</span>")
	return 1
