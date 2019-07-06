/datum/computer_file/program/id_management
	filename = "id_management"
	filedesc = "ID Printing & Management"
	extended_desc = "This program allows individuals to print IDs and send out a devalidation signal."
	program_icon_state = "generic"
	size = 8
	requires_ntnet = FALSE
	available_on_ntnet = TRUE
	nanomodule_path = /datum/nano_module/program/id_management
	usage_flags = PROGRAM_CONSOLE
	category = PROG_MISC
	
/datum/nano_module/program/id_management
	name = "Id Printing & Management"

/datum/nano_module/program/id_management/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/datum/world_faction/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	if(connected_faction)
		data["faction_name"] = connected_faction.name
	else
		data["faction_name"] = "Not connected to an employment network."
	if(program && program.computer)
		data["have_printer"] = !!program.computer.nano_printer
	else
		data["have_printer"] = 0

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "id_management.tmpl", name, 700, 540, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/mob/var/last_print = 0
/mob/var/last_id_devalidate = 0

/datum/computer_file/program/id_management/Topic(href, href_list)
	if(..())
		return 1
	var/datum/world_faction/connected_faction
	if(computer.network_card && computer.network_card.connected_network)
		connected_faction = computer.network_card.connected_network.holder
	switch(href_list["action"])
		if("print_card")
			if(usr.last_print > world.realtime)
				to_chat(usr, "Your card print was rejected. You have printed an ID card in the last 5 mintues.")
				return
			var/datum/computer_file/report/crew_record/record
			var/obj/item/weapon/card/id/id = new()
			for(var/datum/computer_file/report/crew_record/R in GLOB.all_crew_records)
				if(R.get_name() == usr.real_name)
					record = R
					break
			if(!record)
				record = Retrieve_Record(usr.real_name)
			if(!record)
				message_admins("NO global record found for [usr.real_name]")
				to_chat(usr, "No record found for [usr.real_name].. contact software developer.")
				return
			if(connected_faction)
				id.selected_faction = connected_faction.uid
				id.approved_factions |= connected_faction.uid
				var/datum/computer_file/report/crew_record/record2 = connected_faction.get_record(usr.real_name)
				if(record2)
					id.sync_from_record(record2)
				else
					id.sync_from_record(record)
			else
				id.sync_from_record(record)
			id.registered_name = usr.real_name
			id.validate_time = world.realtime
			if(record.linked_account)
				id.associated_account_number = record.linked_account.account_number
			id.update_name()
			usr.last_print = world.realtime + 5 MINUTES
			playsound(computer.loc, pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 75, 1, -3)
			id.forceMove(get_turf(computer))
		if("devalidate_card")
			if(usr.last_id_devalidate > world.time)
				to_chat(usr, "Your card devalidate was rejected. You have devalidated your ID card in the last 5 mintues.")
				return
			var/datum/computer_file/report/crew_record/record
			for(var/datum/computer_file/report/crew_record/R in GLOB.all_crew_records)
				if(R.get_name() == usr.real_name)
					record = R
					break
			if(!record)
				record = Retrieve_Record(usr.real_name)
			if(!record)
				message_admins("NO global record found for [usr.real_name]")
				to_chat(usr, "No record found for [usr.real_name].. contact software developer.")
				return
			record.validate_time = world.realtime
			usr.last_id_devalidate = world.realtime + 5 MINUTES
			update_ids(usr.real_name)
			to_chat(usr, "ID cards have been devalidated. You will need to print a new one.")
