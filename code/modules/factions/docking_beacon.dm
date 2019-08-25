#define DOCKING_BEACON_STATUS_OFF          0
#define DOCKING_BEACON_STATUS_CLOSED       1
#define DOCKING_BEACON_STATUS_OPEN         2
#define DOCKING_BEACON_STATUS_CONSTRUCTION 3
#define DOCKING_BEACON_STATUS_OCCUPIED     4
#define DOCKING_BEACON_STATUS_OBSTRUCTED   5

#define DOCKING_BEACON_DIMENSIONS_5x8      1
#define DOCKING_BEACON_DIMENSIONS_7x8      2
#define DOCKING_BEACON_DIMENSIONS_9x10     3
#define DOCKING_BEACON_DIMENSIONS_11x12    4
#define DOCKING_BEACON_DIMENSIONS_19x20    5

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
	anchored = FALSE
	density = 1
	icon = 'icons/obj/machines/dock_beacon.dmi'
	icon_state = "unpowered2"
	use_power = POWER_USE_OFF
	var/status = DOCKING_BEACON_STATUS_OFF // 0 = unpowered, 1 = closed 2 = open 3 = contruction mode 4 = occupied 5 = obstructed
	req_access = list(core_access_shuttle_programs)
	var/dimensions = DOCKING_BEACON_DIMENSIONS_5x8 // 1 = 5*8, 2 = 7*8, 3 = 9*10, 4 = 11*12, 5 = 19*20
	var/highlighted = 0
	var/id = "docking port"
	var/visible_mode = 0 // 0 = invisible, 1 = visible, docking auth required, 2 = visible, anyone can dock
	var/datum/shuttle/shuttle
	var/obj/machinery/computer/bridge_computer/bridge
	var/dock_interior = 0 // 0 = exterior, 1 = interior
	var/shuttle_name
	var/ownership_type = 0 // 0 = organization, 1 = individual
	var/shuttle_owner

/obj/machinery/docking_beacon/New()
	..()
	ADD_SAVED_VAR(status)
	ADD_SAVED_VAR(dimensions)
	ADD_SAVED_VAR(id)
	ADD_SAVED_VAR(visible_mode)
	ADD_SAVED_VAR(dock_interior)
	ADD_SAVED_VAR(shuttle_name)
	ADD_SAVED_VAR(ownership_type)
	ADD_SAVED_VAR(shuttle_owner)
	//shuttle is loaded from the bridge computer in the shuttle itself. So no reasons to duplicate it here

/obj/machinery/docking_beacon/Initialize()
	. = ..()
	if(. != INITIALIZE_HINT_QDEL)
		GLOB.all_docking_beacons |= src //The list is initialized later on a new map
	queue_icon_update()

/obj/machinery/docking_beacon/Destroy()
	if(LAZYLEN(GLOB.all_docking_beacons))
		GLOB.all_docking_beacons -= src
	return ..()

/obj/machinery/docking_beacon/proc/get_top_turf()
	switch(dir)
		if(SOUTH)
			return loc
		if(NORTH)
			switch(dimensions)
				if(DOCKING_BEACON_DIMENSIONS_5x8)
					return locate(x, y+9, z)
				if(DOCKING_BEACON_DIMENSIONS_7x8)
					return locate(x, y+9, z)
				if(DOCKING_BEACON_DIMENSIONS_9x10)
					return locate(x, y+11, z)
				if(DOCKING_BEACON_DIMENSIONS_11x12)
					return locate(x, y+13, z)
				if(DOCKING_BEACON_DIMENSIONS_19x20)
					return locate(x, y+21, z)
		if(WEST)
			switch(dimensions)
				if(DOCKING_BEACON_DIMENSIONS_5x8)
					return locate(x-5, y+4, z)
				if(DOCKING_BEACON_DIMENSIONS_7x8)
					return locate(x-4, y+4, z)
				if(DOCKING_BEACON_DIMENSIONS_9x10)
					return locate(x-3, y+5, z)
				if(DOCKING_BEACON_DIMENSIONS_11x12)
					return locate(x-2, y+6, z)
				if(DOCKING_BEACON_DIMENSIONS_19x20)
					return locate(x-1, y+10, z)
		if(EAST)
			switch(dimensions)
				if(DOCKING_BEACON_DIMENSIONS_5x8)
					return locate(x+3, y+4, z)
				if(DOCKING_BEACON_DIMENSIONS_7x8)
					return locate(x+4, y+4, z)
				if(DOCKING_BEACON_DIMENSIONS_9x10)
					return locate(x+5, y+5, z)
				if(DOCKING_BEACON_DIMENSIONS_11x12)
					return locate(x+6, y+6, z)
				if(DOCKING_BEACON_DIMENSIONS_19x20)
					return locate(x+10, y+10, z)

/obj/machinery/docking_beacon/after_load()
	. = ..()
	update_faction()
	check_shuttle()
	stat = 0
	queue_icon_update()

/obj/machinery/docking_beacon/attack_hand(var/mob/user as mob)
	ui_interact(user)

/obj/machinery/docking_beacon/AltClick()
	rotate()

/obj/machinery/docking_beacon/attackby(var/obj/item/weapon/tool/W, var/mob/user)
	if(isWrench(W))
		if(status)
			to_chat(user, "The beacon is powered and cannot be moved.")
			return
		if(default_wrench_floor_bolts(user, W, 2 SECONDS))
			// Reset when unsecured
			shuttle = null
			faction = null
			status = DOCKING_BEACON_STATUS_OFF
			dock_interior = 0
			dimensions = DOCKING_BEACON_DIMENSIONS_5x8
			bridge = null
			id = "docking port"
			visible_mode = 0
		return
	if(istype(W, /obj/item/weapon/card/id))
		if(status == DOCKING_BEACON_STATUS_CONSTRUCTION)
			var/obj/item/weapon/card/id/id = W
			shuttle_owner = id.selected_faction
	return ..()


/obj/machinery/docking_beacon/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	if(user.stat)
		return

	// this is the data which will be sent to the ui
	var/data[0]
	update_faction()

	data["highlighted"] = highlighted
	data["visible"] = visible_mode
	if(faction)
		data["connected"] = 1
		data["name"] = faction.name
		data["id"] = id
		switch(status)
			if(DOCKING_BEACON_STATUS_OFF)
				data["unpowered"] = 1
				data["status"] = "Unpowered"
			if(DOCKING_BEACON_STATUS_CLOSED)
				data["status"] = "Closed"
			if(DOCKING_BEACON_STATUS_OPEN)
				data["status"] = "Open"
			if(DOCKING_BEACON_STATUS_CONSTRUCTION)
				data["status"] = "Shuttle Construction"
				data["construction"] = 1
			if(DOCKING_BEACON_STATUS_OCCUPIED)
				data["status"] = "Occupied"
			if(DOCKING_BEACON_STATUS_OBSTRUCTED)
				data["status"] = "Obstructed"

		if(status == DOCKING_BEACON_STATUS_CONSTRUCTION)
			if(!shuttle_name || shuttle_name == "")
				data["name"] = "*UNSET*"
			else
				data["name"] = shuttle_name
			if(!shuttle_owner || shuttle_owner == "")
				data["owner"] = "*UNSET*"
			else
				data["owner"] = shuttle_owner
			data["individual"] = ownership_type

		data["dimension"] = dimensions
		data["interior"] = dock_interior
	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "docking_beacon.tmpl", "Docking Beacon UI", 500, 550)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()


/obj/machinery/docking_beacon/update_icon()
	switch(status)
		if(DOCKING_BEACON_STATUS_OFF)
			icon_state = "unpowered2"
		if(DOCKING_BEACON_STATUS_CLOSED)
			icon_state = "red2"
		if(DOCKING_BEACON_STATUS_OPEN)
			icon_state = "green2"
		if(DOCKING_BEACON_STATUS_CONSTRUCTION)
			icon_state = "yellow2"
		if(DOCKING_BEACON_STATUS_OCCUPIED to DOCKING_BEACON_STATUS_OBSTRUCTED)
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
		status = DOCKING_BEACON_STATUS_OFF
	if(href_list["power_on"])
		if(anchored)
			if(status == DOCKING_BEACON_STATUS_OFF)
				status = DOCKING_BEACON_STATUS_CLOSED
		else
			to_chat(usr, "The beacon must be anchored first.")
	if(href_list["status_close"])
		if(check_occupied())
			status = DOCKING_BEACON_STATUS_OCCUPIED
		else if(check_obstructed())
			status = DOCKING_BEACON_STATUS_OBSTRUCTED
		else
			status = DOCKING_BEACON_STATUS_CLOSED
	if(href_list["status_open"])
		if(check_occupied())
			status = DOCKING_BEACON_STATUS_OCCUPIED
		else if(check_obstructed())
			status = DOCKING_BEACON_STATUS_OBSTRUCTED
		else
			status = DOCKING_BEACON_STATUS_OPEN
	if(href_list["status_construct"])
		if(check_occupied())
			status = DOCKING_BEACON_STATUS_OCCUPIED
		else
			status = DOCKING_BEACON_STATUS_CONSTRUCTION
	if(href_list["finalize"])
		if(!shuttle_name || shuttle_name == "")
			to_chat(usr, "The shuttle must have a name to be finalized.")
			return
		if(!shuttle_owner || shuttle_owner == "")
			to_chat(usr, "The shuttle must have an owner to be finalized.")
			return
		if(ownership_type)
			var/datum/computer_file/report/crew_record/record = Retrieve_Record(shuttle_owner)
			if(!record)
				shuttle_owner = null
				return 1
			if(record.get_shuttle_limit() <= record.shuttles.len)
				shuttle_owner = null
				return 1
		else
			var/datum/world_faction/faction = get_faction(shuttle_owner)
			if(!faction)
				shuttle_owner = null
				return 1
			if(faction.limits.limit_shuttles <= faction.limits.shuttles.len)
				shuttle_owner = null
				return 1

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
	if(href_list["set_interior"])
		dock_interior = text2num(href_list["set_interior"])
	if(href_list["change_id"])
		var/select_name = sanitize(input(usr,"Enter a new dock ID","DOCK ID") as null|text, MAX_NAME_LEN)
		if(select_name)
			id = select_name

	if(href_list["change_name"])
		var/select_name = sanitize(input(usr,"Enter a name for the new shuttle","Shuttle name") as null|text, MAX_NAME_LEN)
		if(select_name)
			shuttle_name = select_name
	if(href_list["change_owner"])
		if(!ownership_type)
			return
		var/select_name = input(usr,"Enter the full name of the new shuttle owner.","Shuttle owner")
		if(select_name)
			var/datum/computer_file/report/crew_record/record = Retrieve_Record(select_name)
			if(!record)
				to_chat(usr, "No record exists for [select_name]")
				return
			if(record.get_shuttle_limit() <= record.shuttles.len)
				to_chat(usr, "[select_name] does not have sufficent nexus account level to own this shuttle.")
				return
			shuttle_owner = select_name
	if(href_list["individual"])
		shuttle_owner = null
		ownership_type = 1
	if(href_list["organization"])
		shuttle_owner = null
		ownership_type = 0

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
		if(dock_interior)
			if(istype(T, /turf/simulated/wall))
				return 1
		else
			if(!istype(T, /turf/space) && !istype(T, /turf/simulated/open))
				return 1
	return 0


/obj/machinery/docking_beacon/proc/check_occupied()
	var/list/turfs = get_turfs()
	for(var/turf/T in turfs)
		if(dock_interior)
			if(istype(T, /turf/simulated/wall))
				return 1
		else
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
				status = DOCKING_BEACON_STATUS_OCCUPIED
				return
	return 0


/obj/machinery/docking_beacon/proc/finalize(var/mob/user)
	if(shuttle)
		return 0
	var/list/turfs = get_turfs()
	var/valid_bridge_computer_found = 0
	var/bcomps = 0
	var/list/engines = list()
	var/obj/machinery/computer/bridge_computer/bridge
	for(var/turf/T in turfs)
		if(!istype(T.loc, /area/space))
			status = DOCKING_BEACON_STATUS_OCCUPIED
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
	A.name = shuttle_name
	A.power_equip = 0
	A.power_light = 0
	A.power_environ = 0
	A.always_unpowered = 0
	A.contents.Add(turfs)
	A.shuttle = 1
	shuttle = new()
	if(ownership_type)
		bridge.req_access_personal = shuttle_owner
	else
		bridge.req_access = list(108)
		bridge.req_access_faction = shuttle_owner
	shuttle.finalized = 1
	shuttle.initial_location = src
	shuttle.name = shuttle_name
	shuttle.size = dimensions
	bridge.shuttle = shuttle
	shuttle.shuttle_area = list(A)
	shuttle.bridge = bridge
	bridge.dock = src
	shuttle.setup()
	status = DOCKING_BEACON_STATUS_OCCUPIED
	to_chat(user, "Construction complete.")


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
				if(DOCKING_BEACON_DIMENSIONS_5x8)
					return_turfs = block(locate(x-2,y-1,z), locate(x+2,y-8,z))
				if(DOCKING_BEACON_DIMENSIONS_7x8)
					return_turfs = block(locate(x-3,y-1,z), locate(x+3,y-8,z))
				if(DOCKING_BEACON_DIMENSIONS_9x10)
					return_turfs = block(locate(x-4,y-1,z), locate(x+4,y-10,z))
				if(DOCKING_BEACON_DIMENSIONS_11x12)
					return_turfs = block(locate(x-5,y-1,z), locate(x+5,y-12,z))
				if(DOCKING_BEACON_DIMENSIONS_19x20)
					return_turfs = block(locate(x-9,y-1,z), locate(x+9,y-20,z))
				else
					return_turfs = block(locate(x-2,y-1,z), locate(x+2,y-8,z))
		if(NORTH)
			switch(dimensions)
				if(DOCKING_BEACON_DIMENSIONS_5x8)
					return_turfs = block(locate(x-2,y+1,z), locate(x+2,y+8,z))
				if(DOCKING_BEACON_DIMENSIONS_7x8)
					return_turfs = block(locate(x-3,y+1,z), locate(x+3,y+8,z))
				if(DOCKING_BEACON_DIMENSIONS_9x10)
					return_turfs = block(locate(x-4,y+1,z), locate(x+4,y+10,z))
				if(DOCKING_BEACON_DIMENSIONS_11x12)
					return_turfs = block(locate(x-5,y+1,z), locate(x+5,y+12,z))
				if(DOCKING_BEACON_DIMENSIONS_19x20)
					return_turfs = block(locate(x-9,y+1,z), locate(x+9,y+20,z))
				else
					return_turfs = block(locate(x-2,y+1,z), locate(x+2,y+8,z))
		if(EAST)
			switch(dimensions)
				if(DOCKING_BEACON_DIMENSIONS_5x8)
					return_turfs = block(locate(x+1,y+3,z), locate(x+5,y-4,z))
				if(DOCKING_BEACON_DIMENSIONS_7x8)
					return_turfs = block(locate(x+1,y+3,z), locate(x+7,y-4,z))
				if(DOCKING_BEACON_DIMENSIONS_9x10)
					return_turfs = block(locate(x+1,y+4,z), locate(x+9,y-5,z))
				if(DOCKING_BEACON_DIMENSIONS_11x12)
					return_turfs = block(locate(x+1,y+5,z), locate(x+11,y-6,z))
				if(DOCKING_BEACON_DIMENSIONS_19x20)
					return_turfs = block(locate(x+1,y+9,z), locate(x+19,y-10,z))
				else
					return_turfs = block(locate(x+1,y+3,z), locate(x+5,y-4,z))
		if(WEST)
			switch(dimensions)
				if(DOCKING_BEACON_DIMENSIONS_5x8)
					return_turfs = block(locate(x-1,y+3,z), locate(x-5,y-4,z))
				if(DOCKING_BEACON_DIMENSIONS_7x8)
					return_turfs = block(locate(x-1,y+3,z), locate(x-7,y-4,z))
				if(DOCKING_BEACON_DIMENSIONS_9x10)
					return_turfs = block(locate(x-1,y+4,z), locate(x-9,y-5,z))
				if(DOCKING_BEACON_DIMENSIONS_11x12)
					return_turfs = block(locate(x-1,y+5,z), locate(x-11,y-6,z))
				if(DOCKING_BEACON_DIMENSIONS_19x20)
					return_turfs = block(locate(x-1,y+9,z), locate(x-19,y-10,z))
				else
					return_turfs = block(locate(x-1,y+3,z), locate(x-5,y-4,z))
	return return_turfs

/obj/machinery/docking_beacon/proc/update_faction()
	if(req_access_faction && req_access_faction != "" || (istype(faction, /datum/world_faction) && faction.uid != req_access_faction))
		faction = get_faction(req_access_faction)

#undef DOCKING_BEACON_STATUS_OFF
#undef DOCKING_BEACON_STATUS_OPEN
#undef DOCKING_BEACON_STATUS_CLOSED
#undef DOCKING_BEACON_STATUS_CONSTRUCTION
#undef DOCKING_BEACON_STATUS_OCCUPIED
#undef DOCKING_BEACON_STATUS_OBSTRUCTED

#undef DOCKING_BEACON_DIMENSIONS_5x8
#undef DOCKING_BEACON_DIMENSIONS_7x8
#undef DOCKING_BEACON_DIMENSIONS_9x10
#undef DOCKING_BEACON_DIMENSIONS_11x12
#undef DOCKING_BEACON_DIMENSIONS_19x20