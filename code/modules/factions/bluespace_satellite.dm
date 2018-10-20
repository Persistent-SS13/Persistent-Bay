GLOBAL_LIST_EMPTY(all_docking_beacons)


/obj/structure/hologram
	name = ""
	mouse_opacity = 0
	simulated = 0
	anchored = 1
	plane = LIGHTING_PLANE
	layer = LIGHTING_LAYER
	should_save = 0


/obj/structure/hologram/dockzone
	icon = 'icons/obj/machines/dock_beacon.dmi'
	icon_state = "dockzone"



/obj/machinery/docking_beacon
	name = "docking beacon"
	desc = "Can be installed to provide a landing and launch zone for shuttles, and to facilitate the construction of shuttles.."
	anchored = 0
	density = 1
	icon = 'icons/obj/machines/dock_beacon.dmi'
	icon_state = "unpowered2"
	use_power = 0			//1 = idle, 2 = active
	var/status = 0 // 0 = unpowered, 1 = closed 2 = open 3 = contruction mode 4 = occupied 5 = obstructed
	req_access = list(core_access_shuttle_programs)
	var/datum/world_faction/faction
	var/dimensions = 1 // 1 = 5*8, 2 = 7*8, 3 = 9*10 4 = 12*12 5 = 20*20
	var/highlighted = 0
	var/id = "docking port"
	var/visible_mode = 0 // 0 = invisible, 1 = visible, docking auth required, 2 = visible, anyone can dock
	var/datum/shuttle/shuttle
	var/obj/machinery/computer/bridge_computer/bridge

/obj/machinery/docking_beacon/New()
	..()
	GLOB.all_docking_beacons |= src

/obj/machinery/docking_beacon/proc/get_top_turf()
	switch(dir)
		if(SOUTH)
			return loc
		if(NORTH)
			switch(dimensions)
				if(1)
					return locate(x, y+9, z)
				if(2)
					return locate(x, y+9, z)
				if(3)
					return locate(x, y+11, z)
		if(WEST)
			switch(dimensions)
				if(1)
					return locate(x-5, y+4, z)
				if(2)
					return locate(x-4, y+4, z)
				if(3)
					return locate(x-3, y+5, z)
		if(EAST)
			switch(dimensions)
				if(1)
					return locate(x+3, y+4, z)
				if(2)
					return locate(x+4, y+4, z)
				if(3)
					return locate(x+5, y+5, z)

/obj/machinery/docking_beacon/after_load()
	if(req_access_faction && req_access_faction != "" || (faction && faction.uid != req_access_faction))
		faction = get_faction(req_access_faction)
	check_shuttle()
	stat = 0
	update_icon()
/obj/machinery/docking_beacon/attack_hand(var/mob/user as mob)
	ui_interact(user)

/obj/machinery/docking_beacon/AltClick()
	rotate()

/obj/machinery/docking_beacon/verb/rotate()
	set name = "Rotate Clockwise"
	set category = "Object"
	set src in oview(1)

	if (src.anchored || usr:stat)
		to_chat(usr, "It is fastened to the floor!")
		return 0
	src.set_dir(turn(src.dir, 270))
	return 1

/obj/machinery/docking_beacon/attackby(var/obj/item/W, var/mob/user)
	if(isWrench(W))
		if(status)
			to_chat(user, "The beacon is powered and cannot be moved.")
			return
		anchored = !anchored
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		if(anchored)
			user.visible_message("[user.name] secures [src.name] to the floor.", \
				"You secure the [src.name] to the floor.", \
				"You hear a ratchet")
		else
			user.visible_message("[user.name] unsecures [src.name] from the floor.", \
				"You unsecure the [src.name] from the floor.", \
				"You hear a ratchet")
		return

	return ..()


/obj/machinery/docking_beacon/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	if(user.stat)
		return

	// this is the data which will be sent to the ui
	var/data[0]
	if(req_access_faction && req_access_faction != "" || (faction && faction.uid != req_access_faction))
		faction = get_faction(req_access_faction)

	data["highlighted"] = highlighted
	data["visible"] = visible_mode
	if(faction)
		data["connected"] = 1
		data["name"] = faction.name
		data["id"] = id
		switch(status)
			if(0)
				data["unpowered"] = 1
				data["status"] = "Unpowered"
			if(1)
				data["status"] = "Closed"
			if(2)
				data["status"] = "Open"
			if(3)
				data["status"] = "Shuttle Construction"
				data["construction"] = 1
			if(4)
				data["status"] = "Occupied"
			if(5)
				data["status"] = "Obstructed"
		data["dimension"] = dimensions
	// update the ui if it exists, returns null if no ui is passed/found
	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "docking_beacon.tmpl", "Docking Beacon UI", 500, 550)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		message_admins("ui should be open...")


/obj/machinery/docking_beacon/update_icon()
	switch(status)
		if(0)
			icon_state = "unpowered2"
		if(1)
			icon_state = "red2"
		if(2)
			icon_state = "green2"
		if(3)
			icon_state = "yellow2"
		if(4 to 5)
			icon_state = "red2"


/obj/machinery/docking_beacon/Topic(href, href_list)
	if(stat & (NOPOWER|BROKEN))
		return 0 // don't update UIs attached to this object
	if(!allowed(usr))
		return 1
	if(href_list["change_dimension"])
		check_shuttle()
		if(shuttle)
			if(shuttle.size > text2num(href_list["change_dimension"]))
				to_chat(usr, "The dock is occupied by a shuttle that is too large for this dimension.")
				return
		dimensions = text2num(href_list["change_dimension"])
	if(href_list["disconnect"])
		if(allowed(usr))
			faction = null
			req_access_faction = ""
	if(href_list["power_off"])
		status = 0
	if(href_list["power_on"])
		if(anchored)
			if(status == 0)
				status = 1
		else
			to_chat(usr, "The beacon must be anchored first.")
	if(href_list["status_close"])
		if(check_occupied())
			status = 4
		else if(check_obstructed())
			status = 5
		else
			status = 1
	if(href_list["status_open"])
		if(check_occupied())
			status = 4
		else if(check_obstructed())
			status = 5
		else
			status = 2
	if(href_list["status_construct"])
		if(check_occupied())
			status = 4
		else
			status = 3
	if(href_list["finalize"])
		finalize(usr)
	if(href_list["highlight"])
		if(!highlighted)
			highlighted = 1
			spawn(0)
				highlight()
	if(href_list["sync"])
		faction = get_faction(usr.GetFaction())
		if(faction)
			req_access_faction = faction.uid
			if(!allowed(usr))
				faction = null
				req_access_faction = ""
			else
				req_access_faction = faction.uid
	if(href_list["set_visible"])
		visible_mode = text2num(href_list["set_visible"])
	if(href_list["change_id"])
		var/select_name = sanitizeName(input(usr,"Enter a new dock ID","DOCK ID") as null|text, MAX_NAME_LEN)
		if(select_name)
			id = select_name

	update_icon()
	add_fingerprint(usr)
	return 1 // update UIs attached to this object

/obj/machinery/docking_beacon/proc/highlight()
	var/list/turfs = get_turfs()
	var/list/holos = list()
	for(var/turf/T in turfs)
		if(1)//istype(T, /turf/space))
			var/obj/structure/hologram/dockzone/holo = new(T)
			holos |= holo
	sleep(15 SECONDS)
	highlighted = 0
	for(var/obj/holo in holos)
		holo.loc = null
		qdel(holo)


/obj/machinery/docking_beacon/proc/check_obstructed()
	var/list/turfs = get_turfs()
	for(var/turf/T in turfs)
		if(x < 7 || y < 7 || x > 193 || y > 193)
			return 1
		if(!istype(T, /turf/space) && !istype(T, /turf/simulated/open))
			return 1
	return 0


/obj/machinery/docking_beacon/proc/check_occupied()
	var/list/turfs = get_turfs()
	for(var/turf/T in turfs)
		if(!istype(T.loc, /area/space))
			return 1
	return 0


/obj/machinery/docking_beacon/proc/check_shuttle()
	var/list/turfs = get_turfs()
	for(var/turf/T in turfs)
		for(var/obj/machinery/computer/bridge_computer/comp in T.contents)
			if(comp.shuttle)
				bridge = comp
				shuttle = comp.shuttle
				bridge.dock = src
				shuttle.current_location = src
				status = 4
				return
	return 0


/obj/machinery/docking_beacon/proc/finalize(var/mob/user)
	if(shuttle)
		return 0
	var/list/turfs = get_turfs()
	var/valid_bridge_computer_found = 0
	var/bcomps = 0
	var/list/engines = list()
	var/name
	var/obj/machinery/computer/bridge_computer/bridge
	for(var/turf/T in turfs)
		if(!istype(T.loc, /area/space))
			status = 4
			return 0
		if(istype(T, /turf/space))
			turfs -= T
			continue
		for(var/obj/machinery/computer/bridge_computer/comp in T.contents)
			bcomps++
			if(bcomps > 1)
				to_chat(user, "Multiple bridge computers detected. Shuttle finalization aborted.")
				return
			bridge = comp
			valid_bridge_computer_found = 1
		for(var/obj/machinery/shuttleengine/engine in T.contents)
			if(engine.anchored)
				engines |= engine
	if(!valid_bridge_computer_found)
		to_chat(user, "No valid bridge computer found. Shuttle finalization aborted.")
		return 0
	if(!engines.len)
		to_chat(user, "No properly anchored engine found. Shuttle finalization aborted.")
		return 0
	for(var/obj/machinery/shuttleengine/engine in engines)
		engine.permaanchor = 1
	var/area/shuttle/A = new
	A.name = "shuttle"
	//var/ma
	//ma = A.master ? "[A.master]" : "(null)"
	A.power_equip = 0
	A.power_light = 0
	A.power_environ = 0
	A.always_unpowered = 0
	A.contents.Add(turfs)


	shuttle = new(name, src)
	shuttle.size = dimensions
	bridge.shuttle = shuttle
	shuttle.shuttle_area = list(A)
	shuttle.bridge = bridge
	bridge.dock = src


/obj/machinery/docking_beacon/proc/get_turfs()
	var/list/return_turfs = list()
	/**
	switch(dir)
		if(NORTH)
			return_turfs = block(locate(x-2,y+1,z), locate(x+2,y+8,z))
		if(WEST)
			return_turfs = block(locate(x+1,y+2,z), locate(x+8,y-2,z))
		if(SOUTH)
			return_turfs = block(locate(x-2,y-1,z), locate(x+2,y-8,z))
		if(EAST)
			return_turfs = block(locate(x-1,y+2,z), locate(x-8,y-2,z))
	**/
	switch(dir)
		if(SOUTH)
			switch(dimensions)
				if(1)
					return_turfs = block(locate(x-2,y-1,z), locate(x+2,y-8,z))
				if(2)
					return_turfs = block(locate(x-3,y-1,z), locate(x+3,y-8,z))
				if(3)
					return_turfs = block(locate(x-4,y-1,z), locate(x+4,y-10,z))
				else
					return_turfs = block(locate(x-2,y-1,z), locate(x+2,y-8,z))
		if(NORTH)
			switch(dimensions)
				if(1)
					return_turfs = block(locate(x-2,y+1,z), locate(x+2,y+8,z))
				if(2)
					return_turfs = block(locate(x-3,y+1,z), locate(x+3,y+8,z))
				if(3)
					return_turfs = block(locate(x-4,y+1,z), locate(x+4,y+10,z))
				else
					return_turfs = block(locate(x-2,y+1,z), locate(x+2,y+8,z))
		if(EAST)
			switch(dimensions)
				if(1)
					return_turfs = block(locate(x+1,y+3,z), locate(x+5,y-4,z))
				if(2)
					return_turfs = block(locate(x+1,y+3,z), locate(x+7,y-4,z))
				if(3)
					return_turfs = block(locate(x+1,y+4,z), locate(x+9,y-5,z))
				else
					return_turfs = block(locate(x+1,y+3,z), locate(x+5,y-4,z))
		if(WEST)
			switch(dimensions)
				if(1)
					return_turfs = block(locate(x-1,y+3,z), locate(x-5,y-4,z))
				if(2)
					return_turfs = block(locate(x-1,y+3,z), locate(x-7,y-4,z))
				if(3)
					return_turfs = block(locate(x-1,y+4,z), locate(x-9,y-5,z))
				else
					return_turfs = block(locate(x-1,y+3,z), locate(x-5,y-4,z))
	return return_turfs


/obj/machinery/bluespace_satellite
	name = "bluespace satellite"
	desc = "Can be configured and launched to create a new logistics network."
	anchored = 0
	density = 1
	icon = 'icons/obj/supplybeacon.dmi'
	icon_state = "beacon"

	use_power = 0			//1 = idle, 2 = active
	var/chosen_uid
	var/chosen_name
	var/chosen_short
	var/chosen_tag
	var/chosen_password
	var/starting_leader
	var/chosen_netuid
	var/list/pending_contracts = list()
	var/list/signed_contracts = list()

/obj/machinery/bluespace_satellite/New()
	..()

/obj/machinery/bluespace_satellite/proc/cancel_contracts()
	for(var/obj/item/weapon/paper/contract/contract in pending_contracts)
		contract.cancel()
	for(var/obj/item/weapon/paper/contract/contract in signed_contracts)
		contract.cancel()

/obj/machinery/bluespace_satellite/proc/get_contributed()
	var/contributed = 0
	for(var/obj/item/weapon/paper/contract/contract in signed_contracts)
		contributed += contract.required_cash
	return contributed

/obj/machinery/bluespace_satellite/contract_signed(var/obj/item/weapon/paper/contract/contract)
	pending_contracts -= contract
	signed_contracts |= contract
	GLOB.nanomanager.update_uis(src)
	return 1

/obj/machinery/bluespace_satellite/contract_cancelled(var/obj/item/weapon/paper/contract/contract)
	pending_contracts -= contract
	signed_contracts -= contract
	GLOB.nanomanager.update_uis(src)
	return 1



/obj/machinery/bluespace_satellite/attack_hand(var/mob/user as mob)
	ui_interact(user)


/obj/machinery/bluespace_satellite/attackby(var/obj/I as obj, var/mob/user as mob)
	if(istype(I, /obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/id = I
		starting_leader = id.registered_name
		cancel_contracts()
		loc.visible_message("The \icon[src] [src] reports that the card was successfully scanned and the leadership has been set to '[starting_leader]'.")
		GLOB.nanomanager.update_uis(src)
		return
	..()


/obj/machinery/bluespace_satellite/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)


	// this is the data which will be sent to the ui
	var/data[0]
	data["chosen_uid"] = chosen_uid ? chosen_uid : "*UNSET*"
	data["chosen_name"] = chosen_name ? chosen_name : "*UNSET*"
	data["chosen_short"] = chosen_short ? chosen_short : "*UNSET*"
	data["chosen_tag"] = chosen_tag ? chosen_tag : "*UNSET*"
	data["chosen_password"] = chosen_password ? chosen_password : "*UNSET*"
	data["chosen_netuid"] = chosen_netuid ? chosen_netuid : "*UNSET*"
	data["starting_leader"] = starting_leader ? starting_leader : "*UNSET*"

	// update the ui if it exists, returns null if no ui is passed/found
	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "bluespacesatellite.tmpl", "Bluespace Satellite Config", 650, 900)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()


/obj/machinery/bluespace_satellite/Topic(href, href_list)
	if(stat & (NOPOWER|BROKEN))
		return 0 // don't update UIs attached to this object

	if(href_list["change_uid"])
		var/select_name = sanitizeName(input(usr,"Enter a UID for the network","Lognet UID", chosen_uid) as null|text, MAX_NAME_LEN, 1, 0)
		if(select_name)
			if(get_faction(select_name))
				to_chat(usr, "That UID is already in use.")
				return
			else
				chosen_uid = select_name
				cancel_contracts()
	if(href_list["change_name"])
		var/select_name = sanitizeName(input(usr,"Enter the full name of your organization","Lognet Full Name", chosen_name) as null|text, MAX_NAME_LEN, 1, 0)
		if(select_name)
			chosen_name = select_name
			cancel_contracts()
	if(href_list["change_short"])
		var/select_name = sanitizeName(input(usr,"Enter the short name of your organization","Lognet Short Name", chosen_short) as null|text, MAX_NAME_LEN, 1, 0)
		if(select_name)
			chosen_short = select_name
	if(href_list["change_tag"])
		var/select_name = sanitizeName(input(usr,"Enter the tag of your organization","Lognet Tag Name", chosen_tag) as null|text, 4, 1, 0)
		if(select_name)
			for(var/datum/world_faction/fac in GLOB.all_world_factions)
				if(fac.short_tag == select_name)
					to_chat(usr, "That Tag is already in use.")
					return
				else
					chosen_tag = select_name
	if(href_list["change_password"])
		var/select_name = sanitizeName(input(usr,"Enter the lognet password","Lognet Password", chosen_password) as null|text, MAX_NAME_LEN, 1, 0)
		if(select_name)
			chosen_password = select_name
	if(href_list["change_netuid"])
		var/select_name = sanitizeName(input(usr,"Enter the wireless network uid. Spaces are not allowed,","Wireless Network UID", chosen_netuid) as null|text, MAX_NAME_LEN, 1, 0,1)
		if(select_name)
			for(var/datum/world_faction/existing_faction in GLOB.all_world_factions)
				if(existing_faction.network.net_uid == select_name)
					to_chat(usr, "Error! A network with that UID already exists!")
					return 1
			chosen_netuid = select_name

	if(href_list["contract"])
		if(!chosen_name || chosen_name == "")
			to_chat(usr, "A name for the network must be chosen first.")
			return
		if(!starting_leader)
			to_chat(usr, "A leader for the network must be chosen first.")
			return
		if(!chosen_uid)
			to_chat(usr, "A UID for the network must be chosen first.")
			return

		var/cost = round(input("How much ethericoin should be the funding contract be for?", "Funding", 25000-get_contributed()) as null|num)
		if(!cost || cost < 0)
			return 0
		var/choice = input(usr,"This will create a funding contract for [cost] ethericoin.") in list("Confirm", "Cancel")
		if(choice == "Confirm")
			var/obj/item/weapon/paper/contract/contract = new()
			contract.required_cash = cost
			contract.linked = src
			contract.purpose = "Funding contract for [cost]$$ to [chosen_name] ([chosen_uid]) led by [starting_leader]."
			contract.name = "[chosen_name] funding contract"
			var/t = ""
			t += "<font face='Verdana' color=blue><table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'><center></td><tr><td><H1>Investment Contract</td>"
			t += "<tr><td><br><b>For:</b>[chosen_name] ([chosen_uid]) led by [starting_leader]<br>"
			t += "<b>Cost:</b> [cost] $$ Ethericoins<br><br>"
			t += "<tr><td><h3>Status</H3>*Unsigned*<br></td></tr></table><br><table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>"
			t += "<td><font size='4'><b>Swipe ID to sign contract.</b></font></center></font>"
			contract.info = t
			contract.loc = get_turf(src)
			contract.update_icon()
			pending_contracts |= contract
			playsound(get_turf(src), pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 75, 1, -3)


	if(href_list["launch"])
		if(!chosen_uid || !chosen_name || !chosen_short || !chosen_tag || !chosen_password || !starting_leader || !chosen_netuid)
			to_chat(usr, "Network not configured correctly. Check settings.")
			return 1
		if(get_contributed() < 25000)
			to_chat(usr, "25000$ needs to be committed in order to proceed.")

		if(get_faction(chosen_uid))
			chosen_uid = null
			to_chat(usr, "Chosen UID was already in use, choose new UID.")
			return 1
		var/turf/space/T = loc
		if(!T || !istype(T))
			to_chat(usr, "The satellite can only be launched from space.")
			return 1
		for(var/obj/item/weapon/paper/contract/contract in signed_contracts)
			if(!contract.is_solvent())
				contract.cancel()
				GLOB.nanomanager.update_uis(src)
				return 0
		for(var/obj/item/weapon/paper/contract/contract in signed_contracts)
			contract.finalize()
			signed_contracts -= contract
		var/datum/world_faction/new_faction = new()
		GLOB.all_world_factions |= new_faction
		new_faction.uid = chosen_uid
		new_faction.name = chosen_name
		new_faction.abbreviation = chosen_short
		new_faction.short_tag = chosen_tag
		new_faction.password = chosen_password
		new_faction.leader_name = starting_leader
		new_faction.network.invisible = 1
		new_faction.network.net_uid = chosen_netuid
		new_faction.network.name = chosen_netuid
		cancel_contracts()
		var/obj/effect/portal/portal = new(loc)
		loc.visible_message("The \icon[src] [src] beams away!.")
		sleep(1 SECOND)
		playsound(src,'sound/effects/teleport.ogg',100,1)
		portal.loc = null
		qdel(portal)
		loc = null
		qdel(src)
	add_fingerprint(usr)
	return 1 // update UIs attached to this object

