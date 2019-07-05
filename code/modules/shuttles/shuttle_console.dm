

/obj/machinery/computer/bridge_computer
	name = "shuttle bridge console"
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "atmos_key"
	icon_screen = "shuttle"
	circuit = /obj/item/weapon/circuitboard/bridge_computer

	var/shuttle_tag  // Used to coordinate data in shuttle controller.
	var/hacked = 0   // Has been emagged, no access restrictions.

	var/ui_template = "bridge_computer.tmpl"
	var/datum/shuttle/autodock/shuttle

	var/desired_name = ""
	var/shuttle_type = 1 // 1 = personal shuttle, 2 = faction shuttle
	var/locked_to = "" // either the real_name or the faction_uid
	var/ready = 0 // this is set to 1 to confirm construction is completed, and then the dock finalizes it
	var/obj/machinery/docking_beacon/dock

/obj/machinery/computer/bridge_computer/New()
	. = ..()
	ADD_SAVED_VAR(shuttle_tag)
	ADD_SAVED_VAR(hacked)
	ADD_SAVED_VAR(shuttle)
	ADD_SAVED_VAR(desired_name)
	ADD_SAVED_VAR(shuttle_type)
	ADD_SAVED_VAR(locked_to)
	ADD_SAVED_VAR(ready)

/obj/machinery/computer/bridge_computer/attack_hand(user as mob)
	if(..(user))
		return
	//src.add_fingerprint(user)	//shouldn't need fingerprints just for looking at it.
	if(!allowed(user))
		to_chat(user, "<span class='warning'>Access Denied.</span>")
		return 1

	ui_interact(user)

/obj/machinery/computer/bridge_computer/proc/get_ui_data()
	return 0

/obj/machinery/computer/bridge_computer/proc/handle_topic_href(var/datum/shuttle/autodock/shuttle, var/list/href_list)
	if(!istype(shuttle))
		return

	if(href_list["move"])
		if(!shuttle.next_location.is_valid(shuttle))
			to_chat(usr, "<span class='warning'>Destination zone is invalid or obstructed.</span>")
			return
		shuttle.launch(src)
	else if(href_list["force"])
		shuttle.force_launch(src)
	else if(href_list["cancel"])
		shuttle.cancel_launch(src)

/obj/machinery/computer/bridge_computer/proc/get_docks(mob/user)
	var/list/beacons = list()
	if(!shuttle) return
	for(var/obj/machinery/docking_beacon/beacon in GLOB.all_docking_beacons)
		if(beacon == dock || beacon.status != 2 || !beacon.loc || beacon.dimensions < shuttle.size)
			continue
		if(beacon.visible_mode)
			if(beacon.visible_mode == 1)
				beacons[beacon] = 1
			else
				if(beacon.allowed(user))
					beacons[beacon] = 1
				else
					beacons[beacon] = 2
		else
			if(beacon.allowed(user))
				beacons[beacon] = 1
	return beacons

/obj/machinery/computer/bridge_computer/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/list/data = list()
	if(shuttle)
		data["connected"] = 1
		if(shuttle.finalized)
			data["final"] = 1
			data["name"] = shuttle.name
			
			data["shuttle_type"] = shuttle_type
			
			switch(shuttle.moving_status)
				if(SHUTTLE_IDLE)
					data["status"] = "Idle"
				if(SHUTTLE_WARMUP)
					data["status"] = "Preparing for jump"
				else
					data["status"] = "Moving"

			if(shuttle.moving_status == SHUTTLE_IDLE)
				// add launch requirements here
				data["can_launch"] = 1
			else
				data["can_launch"] = 0

			var/list/beacons = get_docks(user)
			var/list/formatted_beacons[0]
			for(var/obj/machinery/docking_beacon/beacon in beacons)
				var/dock_status = beacons[beacon]
				var/dock_name
				if(dock_status == 2)
					dock_name = "REQUEST: [beacon.id]"
				else
					dock_name = "DOCK: [beacon.id]"
				formatted_beacons[++formatted_beacons.len] = list("name" = dock_name, "status" = dock_status, "ref" = "\ref[beacon]")
			data["beacons"] = formatted_beacons
		else
			data["desired_name"] = desired_name != "" ? desired_name : "Unset!"
			data["name_set"] = desired_name != "" ? 1 : 0
			data["shuttle_type"] = shuttle_type
			data["locked_to"] = locked_to != "" ? locked_to : "Unset!"


	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, ui_template, "[shuttle_tag] Shuttle Control", 400, 300)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


/obj/machinery/computer/bridge_computer/proc/get_valid()
	if(!desired_name || desired_name == "")
		return 0
	if(locked_to)
		if(locked_to == "")
			return 0
		if(shuttle_type == 2)
			if(!get_faction(locked_to))
				locked_to = ""
				return 0
		else
			var/datum/computer_file/report/crew_record/record = new()
			if(!record.load_from_global(locked_to))
				qdel(record)
				locked_to = ""
				return 0
			qdel(record)
		return 1
	else
		return 0


/obj/machinery/computer/bridge_computer/Topic(href, href_list)
	if(!allowed(usr))
		return 1
	if(href_list["set_name"])
		var/curr_name = desired_name
		var/select_name = sanitizeName(input(usr,"Enter the name of the vessel","Shuttle name", desired_name) as null|text, MAX_NAME_LEN, 1, 0)
		if(select_name)
			if(curr_name != desired_name)
				to_chat(usr, "Your inputs expired because someone used the terminal first.")
			else
				desired_name = select_name
		else
			desired_name = ""
	if(href_list["set_personal"])
		shuttle_type = 1
		locked_to = ""
	if(href_list["set_corporate"])
		shuttle_type = 2
		locked_to = ""
	if(href_list["set_locked"])
		var/x = usr.get_id_name("")
		if(x)
			locked_to = x
		else
			locked_to = ""
	if(href_list["set_locked_2"])
		var/x = usr.GetFaction()
		if(x)
			locked_to = x
		else
			locked_to = ""
	if(href_list["finalize"])
		if(get_valid())
			shuttle.finalized = 1
			shuttle.name = desired_name
			shuttle.ownertype = shuttle_type
			shuttle.owner = locked_to
			loc.loc.name = desired_name

			if(shuttle_type == 1)
				req_access_personal = locked_to
				req_access = list(999)
			else
				req_access_faction = locked_to
				req_access = list(core_access_shuttle_programs)
			to_chat(usr, "Shuttle finalization complete.")
		else
			to_chat(usr, "Shuttle finalization failed, check details.")
	if(href_list["select_dock"])
		if(!dock)
			for(var/obj/machinery/docking_beacon/beacon in GLOB.all_docking_beacons)
				beacon.check_shuttle()
			return
		var/obj/machinery/docking_beacon/beacon = locate(href_list["selected_ref"])
		if(beacon.dimensions < shuttle.size)
			to_chat(usr, "Dock is not big enough.")
			return 1
		beacon.status = 4
		shuttle.short_jump(beacon.get_top_turf(), dock.get_top_turf())
		dock.status = 2
		dock = beacon
		dock.status = 4
		dock.bridge = src
		dock.shuttle = shuttle
		shuttle.current_location = dock

	if(..())
		return 1

/obj/machinery/computer/bridge_computer/emag_act(var/remaining_charges, var/mob/user)
	if (!hacked)
		req_access = list()
		req_one_access = list()
		hacked = 1
		to_chat(user, "You short out the console's ID checking system. It's now available to everyone!")
		return 1

/obj/machinery/computer/bridge_computer/bullet_act(var/obj/item/projectile/Proj)
	visible_message("\The [Proj] ricochets off \the [src]!")

/obj/machinery/computer/bridge_computer/ex_act()
	return

/obj/machinery/computer/bridge_computer/emp_act()
	return

/obj/machinery/computer/shuttle_control/proc/get_ui_data(var/datum/shuttle/autodock/shuttle)
	var/shuttle_state
	switch(shuttle.moving_status)
		if(SHUTTLE_IDLE) shuttle_state = "idle"
		if(SHUTTLE_WARMUP) shuttle_state = "warmup"
		if(SHUTTLE_INTRANSIT) shuttle_state = "in_transit"

	var/shuttle_status
	switch (shuttle.process_state)
		if(IDLE_STATE)
			if (shuttle.in_use)
				shuttle_status = "Busy."
			else
				shuttle_status = "Standing-by at [shuttle.current_location]."

		if(WAIT_LAUNCH, FORCE_LAUNCH)
			shuttle_status = "Shuttle has recieved command and will depart shortly."
		if(WAIT_ARRIVE)
			shuttle_status = "Proceeding to [shuttle.next_location]."
		if(WAIT_FINISH)
			shuttle_status = "Arriving at destination now."

	return list(
		"shuttle_status" = shuttle_status,
		"shuttle_state" = shuttle_state,
		"has_docking" = shuttle.active_docking_controller? 1 : 0,
		"docking_status" = shuttle.active_docking_controller? shuttle.active_docking_controller.get_docking_status() : null,
		"docking_override" = shuttle.active_docking_controller? shuttle.active_docking_controller.override_enabled : null,
		"can_launch" = shuttle.can_launch(),
		"can_cancel" = shuttle.can_cancel(),
		"can_force" = shuttle.can_force(),
		"docking_codes" = shuttle.docking_codes
	)

/obj/machinery/computer/shuttle_control/proc/handle_topic_href(var/datum/shuttle/autodock/shuttle, var/list/href_list)
	if(!istype(shuttle))
		return

	if(href_list["move"])
		if(!shuttle.next_location.is_valid(shuttle))
			to_chat(usr, "<span class='warning'>Destination zone is invalid or obstructed.</span>")
			return
		shuttle.launch(src)
	else if(href_list["force"])
		shuttle.force_launch(src)
	else if(href_list["cancel"])
		shuttle.cancel_launch(src)


/obj/machinery/computer/bridge_computer/after_load()
	..()
	if(shuttle && loc && loc.loc)
		shuttle.shuttle_area |= loc.loc


/obj/machinery/computer/shuttle_control
	name = "shuttle control console"
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "atmos_key"
	icon_screen = "shuttle"
	circuit = null

	var/shuttle_tag  // Used to coordinate data in shuttle controller.
	var/hacked = 0   // Has been emagged, no access restrictions.

	var/ui_template = "shuttle_control_console.tmpl"


/obj/machinery/computer/shuttle_control/attack_hand(user as mob)
	if(..(user))
		return
	//src.add_fingerprint(user)	//shouldn't need fingerprints just for looking at it.
	if(!allowed(user))
		to_chat(user, "<span class='warning'>Access Denied.</span>")
		return 1

	ui_interact(user)


/obj/machinery/computer/shuttle_control/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/datum/shuttle/autodock/shuttle = SSshuttle.shuttles[shuttle_tag]
	if (!istype(shuttle))
		to_chat(usr,"<span class='warning'>Unable to establish link with the shuttle.</span>")
		return

	var/list/data = get_ui_data(shuttle)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, ui_template, "[shuttle_tag] Shuttle Control", 470, 450)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/shuttle_control/Topic(href, href_list)
	if(..())
		return 1

	handle_topic_href(SSshuttle.shuttles[shuttle_tag], href_list)

/obj/machinery/computer/shuttle_control/emag_act(var/remaining_charges, var/mob/user)
	if (!hacked)
		req_access = list()
		req_one_access = list()
		hacked = 1
		to_chat(user, "You short out the console's ID checking system. It's now available to everyone!")
		return 1

/obj/machinery/computer/shuttle_control/bullet_act(var/obj/item/projectile/Proj)
	visible_message("\The [Proj] ricochets off \the [src]!")

/obj/machinery/computer/shuttle_control/ex_act()
	return

/obj/machinery/computer/shuttle_control/emp_act()
	return
