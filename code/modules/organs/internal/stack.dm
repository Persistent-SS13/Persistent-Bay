// How long should dead lace mobs wait before being able to teleport ?
#define DEAD_LACEMOB_STORAGE_TELEPORT_DELAY	120 MINUTES

GLOBAL_LIST_EMPTY(neural_laces)
/mob/var/perma_dead = 0


/proc/notify_lace(var/real_name, var/note)
	for(var/obj/item/organ/internal/stack/stack in GLOB.neural_laces)
		var/mob/employee = stack.get_owner()
		if(!employee) continue
		if(employee.real_name == real_name)
			to_chat(employee, note)

/mob/living/carbon/human/proc/create_stack(var/faction_uid, var/silent = FALSE)
	set waitfor=0
	if(internal_organs_by_name && internal_organs_by_name[BP_STACK])
		log_debug(" /mob/living/carbon/human/proc/create_stack(): Tried adding another stack to [src]\ref[src]. Skipping..")
		return //We don't want multiple stacks
//	sleep(10)
	//testing("create_stack(): made a lace for [src]\ref[src], with faction [faction_uid]")
	var/obj/item/organ/internal/stack/stack = new species.stack_type(src, faction_uid = faction_uid)
	if(faction_uid && stack)
		stack.try_connect()
		stack.status &= ~ORGAN_CUT_AWAY
	internal_organs_by_name[BP_STACK] = stack
	update_action_buttons()
	if(!silent)
		to_chat(src, "<span class='notice'>You feel a faint sense of vertigo as your neural lace boots.</span>")

/obj/item/organ/internal/stack
	name = "neural lace"
	parent_organ = BP_HEAD
	icon = 'icons/obj/surgery.dmi'
	icon_state = "cortical-stack"
	organ_tag = BP_STACK
	status = ORGAN_ROBOTIC
	vital = 1
	origin_tech = list(TECH_BIO = 4, TECH_MATERIAL = 4, TECH_MAGNET = 2, TECH_DATA = 3)
	relative_size = 10

	var/ownerckey
	var/invasive
	var/default_language
	var/save_slot
	var/list/languages = list()
	var/datum/mind/backup
	var/prompting = FALSE // Are we waiting for a user prompt?
	default_action_type =  /datum/action/lace
	action_button_name = "Access Neural Lace UI"
	action_button_is_hands_free = 1
	action_button_icon = 'icons/obj/action_buttons/lace.dmi'
	action_button_state = "lace"
	var/connected_faction = ""
	var/duty_status = 1
	var/datum/world_faction/faction
	var/mob/living/carbon/lace/lacemob
	var/sensor = 0

	var/business_mode = 0
	var/connected_business = ""

	var/menu = 1
	var/curr_page = 1

	var/datum/computer_file/report/crew_record/record

	var/datum/democracy/selected_ballot

	var/time

/obj/item/organ/internal/stack/New(var/loc, var/faction_uid)
	..()
	LAZYDISTINCTADD(GLOB.neural_laces, src)
	if(faction_uid)
		connected_faction = faction_uid
	ADD_SAVED_VAR(ownerckey)
	ADD_SAVED_VAR(connected_business)
	ADD_SAVED_VAR(connected_faction)

/obj/item/organ/internal/stack/Initialize()
	do_backup()
	robotize()
	. = ..()
	if(owner)
		var/obj/item/organ/internal/stack/oldlace = owner.internal_organs_by_name[BP_STACK]
		if(istype(oldlace))
			log_error(" obj/item/organ/internal/stack/Initialize(): [src]\ref[src] overwrote directly the active lace [oldlace]\ref[oldlace] in [owner]\ref[owner]! Bad things will happen!")
		owner.internal_organs_by_name[BP_STACK] = src
		owner.update_action_buttons()
	try_connect()

/obj/item/organ/internal/stack/after_load()
	..()
	if(duty_status)
		try_duty()
	LAZYDISTINCTADD(GLOB.neural_laces, src)

/obj/item/organ/internal/stack/Destroy(var/clearlace = FALSE)
	if(!clearlace && lacemob && ((lacemob.key && lacemob.key != "") || (lacemob.key && lacemob.key != "")))
		loc = get_turf(loc)
		log_and_message_admins("Attempted to destroy an in-use neural lace!")
		return QDEL_HINT_LETMELIVE
	QDEL_NULL(lacemob)
	selected_ballot = null
	record = null
	faction = null
	backup = null
	languages = null
	LAZYREMOVE(GLOB.neural_laces, src)
	. = ..()

/obj/item/organ/internal/stack/examine(mob/user) // -- TLE
	. = ..(user)
	if(istype(src, /obj/item/organ/internal/stack/vat))
		to_chat(user, "These are the remnants of a small implant used to quickly train vatgrown and connect them to bluespace networks. Vatgrown can never be cloned.")
		return 0
	if(lacemob && lacemob.key)	// Ff thar be a brain inside... the brain.
		to_chat(user, "This one looks occupied and ready for cloning, the conciousness clearly present and active.")

	else if(lacemob && lacemob.stored_ckey)
		to_chat(user, "This one appears inactive, the conciousness is resting and the transfer cannot complete until it 'wakes'.")

	else
		to_chat(user, "This one seems particularly lifeless. Perhaps it will regain some of its luster later..")

/obj/item/organ/internal/stack/ex_act(severity)
	return

/obj/item/organ/internal/stack/proc/transfer_identity(var/mob/living/carbon/H)

	if(!lacemob)
		lacemob = new(src)
	lacemob.name = 				H.real_name
	lacemob.real_name = 		H.real_name
	lacemob.dna = 				H.dna.Clone()
	lacemob.timeofhostdeath = 	H.timeofdeath
	lacemob.teleport_time = 	H.timeofdeath + DEAD_LACEMOB_STORAGE_TELEPORT_DELAY
	lacemob.container = 		src
	if(owner && !QDELETED(owner))
		lacemob.container2 = owner
	lacemob.spawn_loc = 		H.spawn_loc
	lacemob.spawn_loc_2 = 		H.spawn_loc_2

	if(H.mind)
		H.mind.transfer_to(lacemob)

	to_chat(lacemob, SPAN_NOTICE("You feel slightly disoriented. Your conciousness suddenly shifts into a neural lace."))

/obj/item/organ/internal/stack/proc/get_owner_name()
	var/mob/M = get_owner()
	if(M)
		return M.real_name
	return 0

/obj/item/organ/internal/stack/proc/get_owner()
	if(lacemob)
		return lacemob
	if(istype(loc, /obj/item/device/lmi) && istype(loc.loc, /mob/living/silicon/robot))
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


/obj/item/organ/internal/stack/Topic(href, href_list)
	switch (href_list["action"])
		if("change_menu")
			menu = text2num(href_list["menu_target"])

		if("clock_out")
			if(faction)

				if(faction.employment_log.len > 100)
					faction.employment_log.Cut(1,2)
				faction.employment_log += "At [stationdate2text()] [stationtime2text()] [owner.real_name] clocked out."
				faction.connected_laces -= src
				faction = null

				connected_faction = ""

		if("connect")
			faction = locate(href_list["selected_ref"])
			if(!faction) return 0
			connected_faction = faction.uid
			try_connect()

		if("die")
			var/choice = input(usr,"THIS WILL PERMANENTLY KILL YOUR CHARACTER! YOU WILL NOT BE ALLOWED TO REMAKE THE SAME CHARACTER.") in list("Kill my character, return to character creation", "Cancel")
			if(choice == "Kill my character, return to character creation")
				var/charname = SScharacter_setup.peek_character_name(save_slot, lacemob.ckey)
				if(input("Are you SURE you want to delete [charname]? THIS IS PERMANENT. enter the character\'s full name to confirm.", "DELETE A CHARACTER", "") == charname)
					SScharacter_setup.delete_character(save_slot, lacemob.ckey)
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

		if("deselect_ballot")
			selected_ballot = null
		if("vote")
			var/datum/candidate/candidate = locate(href_list["ref"])
			if(owner && candidate && selected_ballot && !(owner.ckey in selected_ballot.voted_ckeys))
				selected_ballot.voted_ckeys |= owner.ckey
				candidate.votes |= owner.real_name
		if("select_ballot")
			selected_ballot = locate(href_list["ref"])

		if("teleport")
			var/obj/machinery/lace_storage/storage = GetLaceStorage(lacemob)
			if (storage)
				forceMove(storage)
				return 1
			else
				message_admins("Couldnt find a Lace Storage for lacemob [lacemob] (stack.dm)")
			return 0
		if("transfer")
			var/chosename = input(usr, "Enter the full name of the person you want to transfer to", "Money Transfer") as null|text
			if(chosename)
				var/datum/computer_file/report/crew_record/record = Retrieve_Record(chosename)
				if(!record)
					to_chat(usr, "An account by that name cannot be found.")
					return
				var/choseamount = input(usr, "Enter the amount you want to transfer.", "Money Transfer") as null|num
				if(choseamount && choseamount > 0)
					var/datum/computer_file/report/crew_record/record2 = Retrieve_Record(owner.real_name)
					if(record2)
						if(choseamount > record2.linked_account.money)
							to_chat(usr, "You do not have sufficent funds to make this transfer.")
							return
						if(record2.ckey == record.ckey)
							to_chat(usr, "This transfer is not allowed. View the server rules.")
							message_admins("[record.ckey] attempted to transfer money fromtwo of their own charactrs ([owner.real_name] to[chosename])")
							return
						var/datum/transaction/T = new("Money Transfer", "Money transfer from [owner.real_name]", choseamount, "Money Transfer")
						record.linked_account.do_transaction(T)
						var/datum/transaction/T2 = new("Money Transfer", "Money transfer to [chosename]", -choseamount, "Money Transfer")
						record2.linked_account.do_transaction(T2)
						notify_lace(chosename, "Your neural lace buzzes letting you know you've recieved a new money transfer.")

		if("add_friend")
			var/chosename = input(usr, "Enter the full name of the person you want to add as a friend", "Add a friend") as null|text
			if(chosename)
				var/datum/computer_file/report/crew_record/record = Retrieve_Record(chosename)
				if(!record)
					to_chat(usr, "An account by that name cannot be found.")
					return
				record.pending_friend_request |= owner.real_name
				to_chat(owner, "Friend request sent.")
		if("toggle_visible")
			var/datum/computer_file/report/crew_record/record = Retrieve_Record(owner.real_name)
			record.visibility_status = 1
		if("toggle_invisible")
			var/datum/computer_file/report/crew_record/record = Retrieve_Record(owner.real_name)
			record.visibility_status = 0
		if("accept_request")
			var/target = href_list["ref"]
			var/datum/computer_file/report/crew_record/record = Retrieve_Record(target)
			if(!record)
				to_chat(usr, "An account by that name cannot be found.")
				return
			record.all_friends |= owner.real_name
			var/datum/computer_file/report/crew_record/record2 = Retrieve_Record(owner.real_name)
			record2.all_friends |= target
		if("deny_request")
			var/target = href_list["ref"]
			var/datum/computer_file/report/crew_record/record2 = Retrieve_Record(owner.real_name)
			record2.pending_friend_request -= target
		if("remove_friend")
			var/target = href_list["ref"]
			var/choice = input(usr,"This will remove you both from each others friends list. Are you sure?") in list("Confirm", "Cancel")
			if(choice == "Confirm")
				var/datum/computer_file/report/crew_record/record = Retrieve_Record(target)
				if(!record)
					to_chat(usr, "An account by that name cannot be found.")
					return
				record.all_friends -= owner.real_name
				var/datum/computer_file/report/crew_record/record2 = Retrieve_Record(owner.real_name)
				record2.all_friends -= target
	if(href_list["page_up"])
		curr_page++
		return 1
	if(href_list["page_down"])
		curr_page--
		return 1
	SSnano.update_uis(src)

/obj/item/organ/internal/stack/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.interactive_state)
	var/list/data = list()
	try_connect()
	if(!lacemob && owner)
		data["living"] = 1
		if(menu == 1)
			load_records()
			if(record)
				var/citizenshipp
				switch(record.citizenship)
					if(RESIDENT)
						citizenshipp = "Resident"
					if(CITIZEN)
						citizenshipp = "Citizen"
					if(PRISONER)
						citizenshipp = "Prisoner"

				data["citizenship_status"] = citizenshipp


			else
				data["citizenship_status"] = "Cannot read citizenship. Contact Administrator."

			if(record && record.email)
				data["email_status"] = "You have [record.email.unread()] unread emails."
			else
				data["email_status"] = "Cannot read email account. Contact Administrator."
			if(faction)
				data["faction_name"] = faction.name
				if(duty_status == 1)
					data["work_status"] = try_duty()
				data["clock_outable"] = 1
			else
				data["work_status"] = "Not currently clocked in."
			var/list/potential = get_potential()
			var/list/formatted[0]
			for(var/datum/world_faction/fact in potential)
				var/selected = 0
				if(fact == faction)
					selected = 1
				formatted[++formatted.len] = list("name" = fact.name, "ref" = "\ref[fact]", "selected" = selected)
			data["potential"] = formatted

		if(menu == 2)
			load_records()
			if(!record || !record.linked_account)
				to_chat(owner, "Cannot retrieve account info! Contact Administrator.")
			else
				data["account_balance"] = record.linked_account.money
				var/list/transactions = record.linked_account.transaction_log
				var/pages = transactions.len/10
				if(pages < 1)
					pages = 1
				var/list/formatted_transactions[0]
				if(transactions.len)
					for(var/i=0; i<10; i++)
						var/minus = i+(10*(curr_page-1))
						if(minus >= transactions.len) break
						var/datum/transaction/T = transactions[transactions.len-minus]
						formatted_transactions[++formatted_transactions.len] = list("date" = T.date, "time" = T.time, "target_name" = T.target_name, "purpose" = T.purpose, "amount" = T.amount ? T.amount : 0)
				data["transactions"] = formatted_transactions
				data["page"] = curr_page
				data["page_up"] = curr_page < pages
				data["page_down"] = curr_page > 1

		if(menu == 3)
			var/datum/world_faction/democratic/F = get_faction(GLOB.using_map.default_faction_uid)
			if(istype(F))
				if(F.current_election)
					data["current_election"] = 1
					data["election_name"] = F.current_election.name
					if(selected_ballot)
						if(owner.ckey in selected_ballot.voted_ckeys)
							data["voted"] = 1
						data["ballot_name"] = selected_ballot.title
						var/list/formatted_candidates[0]
						for(var/datum/candidate/candidate in selected_ballot.candidates)
							formatted_candidates[++formatted_candidates.len] = list("name" = candidate.real_name,"pitch" = candidate.desc, "ref" = "\ref[candidate]")
						data["candidates"] = formatted_candidates
						data["selected_ballot"] = selected_ballot.title
					else
						var/list/formatted_ballots[0]
						for(var/datum/democracy/ballot in F.current_election.ballots)
							formatted_ballots[++formatted_ballots.len] = list("name" = ballot.title, "ref" = "\ref[ballot]")
						data["ballots"] = formatted_ballots

		if(menu == 4)
			if(!record)
				record = Retrieve_Record(owner.real_name)
			if(!record)
				menu = 1
				return

			data["visible"] = record.visibility_status
			var/list/friends = record.all_friends
			var/list/online_friends = list()
			var/list/offline_friends = list()
			var/list/friend_requests = record.pending_friend_request
			for(var/friend in friends)
				offline_friends |= friend
				for(var/client/C in GLOB.clients)
					if(C.mob && C.mob.real_name == friend)
						online_friends |= friend
						offline_friends -= friend
			var/list/formatted_online_friends[0]
			for(var/friend in online_friends)
				formatted_online_friends[++formatted_online_friends.len] = list("name" = friend)
			data["online_friends"] = formatted_online_friends
			var/list/formatted_offline_friends[0]
			for(var/friend in offline_friends)
				formatted_offline_friends[++formatted_offline_friends.len] = list("name" = friend)

			var/list/formatted_friend_requests[0]
			for(var/friend in friend_requests)
				formatted_friend_requests[++formatted_friend_requests.len] = list("name" = friend)
			data["friend_requests"] = formatted_friend_requests
		data["menu"] = menu



	else // death code
		if(lacemob)
			if(lacemob.teleport_time < world.time)
				data["can_teleport"] = 1
			else
				data["time_teleport"] = round((lacemob.teleport_time - world.time)/(1 MINUTE))
		else
			message_admins("lace UI without owner or lacemob [src] [src.loc] ([x], [y], [z])")

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
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
					var/datum/computer_file/report/crew_record/record = fact.get_record(robot.real_name)
					if(record && fact.get_assignment(record.try_duty(), record.get_name()))
						potential |= fact
		return potential

	var/list/potential[0]
	for(var/datum/world_faction/fact in GLOB.all_world_factions)
		if(owner && fact.get_leadername() == owner.real_name)
			potential |= fact
		else
			var/datum/computer_file/report/crew_record/record = fact.get_record(owner.real_name)
			if(record)
				potential |= fact

	return potential

/obj/item/organ/internal/stack/proc/try_duty()
	var/mob/living/silicon/robot/robot
	if(istype(loc, /obj/item/device/lmi))
		if(istype(loc.loc, /mob/living/silicon/robot))
			robot = loc.loc

	if((!owner || !faction) && !robot)
		return
	if(owner.real_name != faction.get_leadername())
		var/datum/computer_file/report/crew_record/records //There's a member var called records too...
		if(!robot)
			records = faction.get_record(owner.real_name)
		else
			records = faction.get_record(robot.real_name)
		if(!records)
			faction = null
			return "No record found."

		var/datum/assignment/assignment = faction.get_assignment(records.try_duty(), records.get_name())
		var/title
		var/rank = 1
		if(assignment && assignment.duty_able)
			if(record)
				title = assignment.get_title(record.rank)
				rank = record.rank
			else
				title = assignment.get_title(1)
			return "Working as [title] for [faction.name].<br>Making [assignment.get_pay(rank)]$$ for every thirty minutes clocked in."
		else
			return "No paying assignment."
	else
		var/datum/assignment/assignment = faction.get_assignment(null, owner.real_name) //This will never return not null except if the faction is a business and the person is a CEO
		var/title
		if(assignment && assignment.duty_able)
			title = assignment.get_title()
			return "Working as [title] for [faction.name].<br>Making [assignment.get_pay()]$$ for every thirty minutes clocked in."
		else
			return "No paying assignment."


/obj/item/organ/internal/stack/proc/try_connect()
	if(!owner) 
		return FALSE
	faction = get_faction(connected_faction)
	if(!faction || !faction.status) 
		return FALSE
	
	var/datum/computer_file/report/crew_record/record = faction.get_record(owner.real_name)
	if(!record)
		if(faction.get_leadername() == owner.real_name)
			faction.connected_laces |= src
			if(faction.employment_log.len > 100)
				faction.employment_log.Cut(1,2)
			faction.employment_log += "At [stationdate2text()] [stationtime2text()] [owner.real_name] clocked in."
		else
			faction = null
			return 0
	else
		var/datum/assignment/assignment = faction.get_assignment(record.try_duty(), record.get_name())
		if(assignment && assignment.duty_able)
			faction.connected_laces |= src
			if(faction.employment_log.len > 100)
				faction.employment_log.Cut(1,2)
			faction.employment_log += "At [stationdate2text()] [stationtime2text()] [owner.real_name] clocked in."
		else
			faction = null
			return 0


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


/obj/item/organ/internal/stack/proc/backup_inviable()
	return 	(!istype(backup) || backup == owner.mind || (backup.current && backup.current.stat != DEAD))

/obj/item/organ/internal/stack/replaced(var/mob/living/carbon/human/target, var/obj/item/organ/external/affected)
	if(!..(target, affected))
		message_admins("stack replace() failed")
		return 0
	if(prompting) // Don't spam the player with twenty dialogs because someone doesn't know what they're doing or panicking.
		return 0

	if(lacemob)
		. = overwrite()		// If overwrite returns 0, then we pass it on
		lacemob.ckey = null
		QDEL_NULL(lacemob)
		return

	if(owner && !backup_inviable())
		var/current_owner = owner
		prompting = TRUE
		var/response = input(find_dead_player(ownerckey, 1), "Your neural backup has been placed into a new body. Do you wish to return to life?", "Resleeving") as anything in list("Yes", "No")
		prompting = FALSE
		if(src && response == "Yes" && owner == current_owner)
			overwrite()
	sleep(-1)
	do_backup()

	return 1

//set dolace to false when you don't want the lace stuff to trigger and make a mess when you're deleting things
/obj/item/organ/internal/stack/removed(var/mob/living/user, var/drop_organ=1, var/detach=1, var/dolace=TRUE)
	if(dolace) //Dont do this when we're being deleted
		do_backup()
		if(!istype(owner))
			message_admins("Removed Failed")
			return ..(user, drop_organ, detach)
		if(name == initial(name))
			name = "\the [owner.real_name]'s [initial(name)]"
		transfer_identity(owner)
	..(user, drop_organ, detach)

//Whether the lace should still display its action button on the button bar
// Meant to be used to clear deleted laces from the UI of people still stuck with them after it was hastily replaced and etc..
/obj/item/organ/internal/stack/proc/can_delete_stack_action()
	if( (owner == null && lacemob == null) || loc == null || QDELETED(src))
		return TRUE
	return FALSE

/obj/item/organ/internal/stack/vox/removed()
	var/obj/item/organ/external/head = owner.get_organ(parent_organ)
	owner.visible_message("<span class='danger'>\The [src] rips gaping holes in \the [owner]'s [head.name] as it is torn loose!</span>")
	head.take_damage(rand(15,20))
	for(var/obj/item/organ/O in head.contents)
		O.take_damage(rand(30,70))
	..()

/obj/item/organ/internal/stack/proc/overwrite()
	if(owner.mind && owner.ckey) //Someone is already in this body!
		if(owner.mind == backup) // Oh, it's the same mind in the backup. Someone must've spammed the 'Start Procedure' button in a panic.
			return
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

/obj/item/organ/internal/stack/vat
	action_button_name = "Access Vatchip UI"
	name = "vatgrown chip"
	parent_organ = BP_HEAD
	icon = 'icons/obj/device.dmi'
	icon_state = "implant"
	w_class = ITEM_SIZE_TINY
