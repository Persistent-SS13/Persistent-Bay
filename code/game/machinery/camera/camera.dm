/obj/machinery/camera
	name = "security camera"
	desc = "It's used to monitor rooms."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "camera"
	use_power = POWER_USE_ACTIVE
	idle_power_usage = 5
	active_power_usage = 10
	plane = ABOVE_HUMAN_PLANE
	layer = CAMERA_LAYER
	armor =list(
		DAM_BLUNT  	= 20,
		DAM_PIERCE 	= 20,
		DAM_CUT 	= 20,
		DAM_BULLET 	= 5,
		DAM_ENERGY 	= 5,
		DAM_BURN 	= 5,
		DAM_BOMB 	= 5,
		DAM_EMP 	= 5,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue)
	max_health = 50
	break_threshold = 0.25

	var/last_emped = 0 //Keep tracks of the last time the camera was emped

	var/list/network = list(NETWORK_EXODUS)
	var/c_tag = null
	var/c_tag_order = 999
	var/number = 0 //camera number in area
	var/status = 1
	anchored = 1.0
	var/bugged = 0
	var/obj/item/weapon/camera_assembly/assembly = null

	// WIRES
	var/datum/wires/camera/wires = null // Wires datum

	//OTHER

	var/view_range = 7
	var/short_range = 2

	var/light_disabled = 0
	var/alarm_on = 0
	var/busy = 0

	var/on_open_network = 0


/obj/machinery/camera/malf_upgrade(var/mob/living/silicon/ai/user)
	..()
	malf_upgraded = 1

	upgradeEmpProof()
	upgradeXRay()

	to_chat(user, "\The [src] has been upgraded. It now has X-Ray capability and EMP resistance.")
	return 1

/obj/machinery/camera/apply_visual(mob/living/carbon/human/M)
	if(!M.client)
		return
	M.overlay_fullscreen("fishbed",/obj/screen/fullscreen/fishbed)
	M.overlay_fullscreen("scanlines",/obj/screen/fullscreen/scanline)
	M.overlay_fullscreen("whitenoise",/obj/screen/fullscreen/noise)
	M.machine_visual = src
	return 1

/obj/machinery/camera/remove_visual(mob/living/carbon/human/M)
	if(!M.client)
		return
	M.clear_fullscreen("fishbed",0)
	M.clear_fullscreen("scanlines")
	M.clear_fullscreen("whitenoise")
	M.machine_visual = null
	return 1

/obj/machinery/camera/New()
	wires = new(src)
	assembly = new(src)
	assembly.state = 4

	update_icon()

	/* // Use this to look for cameras that have the same c_tag.
	for(var/obj/machinery/camera/C in cameranet.cameras)
		var/list/tempnetwork = C.network&src.network
		if(C != src && C.c_tag == src.c_tag && tempnetwork.len)
			world.log << "[src.c_tag] [src.x] [src.y] [src.z] conflicts with [C.c_tag] [C.x] [C.y] [C.z]"
	*/
	if(!src.network || src.network.len < 1)
		if(loc)
			error("[src.name] in [get_area(src)] (x:[src.x] y:[src.y] z:[src.z] has errored. [src.network?"Empty network list":"Null network list"]")
		else
			error("[src.name] in [get_area(src)]has errored. [src.network?"Empty network list":"Null network list"]")
		ASSERT(src.network)
		ASSERT(src.network.len > 0)
	..()

/obj/machinery/camera/Initialize()
	. = ..()
	if(!c_tag)
		number = 1
		var/area/A = get_area(src)
		if(A)
			for(var/obj/machinery/camera/C in A)
				if(C == src) continue
				if(C.number)
					number = max(number, C.number+1)
			c_tag = "[A.name][number == 1 ? "" : " #[number]"]"
		invalidateCameraCache()


/obj/machinery/camera/Destroy()
	deactivate(null, 0) //kick anyone viewing out
	if(assembly)
		qdel(assembly)
		assembly = null
	qdel(wires)
	wires = null
	return ..()

/obj/machinery/camera/emp_end()
	..()
	cancelCameraAlarm()
	update_coverage()

/obj/machinery/camera/Process()
	..()
	return internal_process()

/obj/machinery/camera/proc/internal_process()
	return

/obj/machinery/camera/emp_act(severity)
	if(isEmpProof())
		return

	. = ..()
	if(isemped())
		if(last_emped)
			//Apparently we want to warn on emp if we had been emped recently
			set_light(0)
			triggerCameraAlarm()
			update_icon()
			update_coverage()
			START_PROCESSING(SSmachines, src) //Not sure why.. This was there in the original code..
		last_emped = world.time


/obj/machinery/camera/proc/setViewRange(var/num = 7)
	src.view_range = num
	cameranet.update_visibility(src, 0)

/obj/machinery/camera/attackby(obj/item/W as obj, mob/living/user as mob)
	update_coverage()
	// DECONSTRUCTION
	if(isScrewdriver(W))
		panel_open = !panel_open
		user.visible_message("<span class='warning'>[user] screws the camera's panel [panel_open ? "open" : "closed"]!</span>",
		"<span class='notice'>You screw the camera's panel [panel_open ? "open" : "closed"].</span>")
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)

	else if((isWirecutter(W) || isMultitool(W)) && panel_open)
		interact(user)

	else if(isWelder(W) && (wires.CanDeconstruct() || (stat & BROKEN)))
		if(weld(W, user))
			if(assembly)
				assembly.dropInto(loc)
				assembly.anchored = 1
				assembly.camera_name = c_tag
				assembly.camera_network = english_list(network, "Exodus", ",", ",")
				assembly.update_icon()
				assembly.dir = src.dir
				if(stat & BROKEN)
					assembly.state = 2
					to_chat(user, "<span class='notice'>You repaired \the [src] frame.</span>")
					cancelCameraAlarm()
				else
					assembly.state = 1
					to_chat(user, "<span class='notice'>You cut \the [src] free from the wall.</span>")
					new /obj/item/stack/cable_coil(src.loc, length=2)
				assembly = null //so qdel doesn't eat it.
			qdel(src)
			return

	// OTHER
	else if (can_use() && (istype(W, /obj/item/weapon/paper) && isliving(user)))
		var/mob/living/U = user
		var/obj/item/weapon/paper/X = null

		var/itemname = ""
		var/info = ""
		if(istype(W, /obj/item/weapon/paper))
			X = W
			itemname = X.name
			info = X.info
		to_chat(U, "You hold \a [itemname] up to the camera ...")
		for(var/mob/living/silicon/ai/O in GLOB.living_mob_list_)
			if(!O.client) continue
			if(U.name == "Unknown") to_chat(O, "<b>[U]</b> holds \a [itemname] up to one of your cameras ...")
			else to_chat(O, "<b><a href='byond://?src=\ref[O];track2=\ref[O];track=\ref[U];trackname=[U.name]'>[U]</a></b> holds \a [itemname] up to one of your cameras ...")
			O << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", itemname, info), text("window=[]", itemname))
	else
		..()

/obj/machinery/camera/proc/deactivate(user as mob, var/choice = 1)
	// The only way for AI to reactivate cameras are malf abilities, this gives them different messages.
	if(istype(user, /mob/living/silicon/ai))
		user = null

	if(choice != 1)
		return

	set_status(!src.status)
	if (!(src.status))
		if(user)
			visible_message("<span class='notice'> [user] has deactivated [src]!</span>")
		else
			visible_message("<span class='notice'> [src] clicks and shuts down. </span>")
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		icon_state = "[initial(icon_state)]1"
		add_hiddenprint(user)
	else
		if(user)
			visible_message("<span class='notice'> [user] has reactivated [src]!</span>")
		else
			visible_message("<span class='notice'> [src] clicks and reactivates itself. </span>")
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		icon_state = initial(icon_state)
		add_hiddenprint(user)

//Used when someone breaks a camera
/obj/machinery/camera/broken()
	wires.RandomCutAll()
	triggerCameraAlarm()
	queue_icon_update()
	update_coverage()
	..()
	//sparks
	var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
	spark_system.set_up(5, 0, loc)
	spark_system.start()
	playsound(loc, "sparks", 50, 1)

/obj/machinery/camera/proc/set_status(var/newstatus)
	if (status != newstatus)
		status = newstatus
		update_coverage()

/obj/machinery/camera/check_eye(mob/user)
	if(!can_use()) return -1
	if(isXRay()) return SEE_TURFS|SEE_MOBS|SEE_OBJS
	return 0

/obj/machinery/camera/update_icon()
	pixel_x = 0
	pixel_y = 0

	var/turf/T = get_step(get_turf(src), turn(src.dir, 180))
	if(istype(T, /turf/simulated/wall))
		if(dir == SOUTH)
			pixel_y = 21
		else if(dir == WEST)
			pixel_x = 10
		else if(dir == EAST)
			pixel_x = -10

	if (!status || isbroken())
		icon_state = "[initial(icon_state)]1"
	else if (stat & EMPED)
		icon_state = "[initial(icon_state)]emp"
	else
		icon_state = initial(icon_state)

/obj/machinery/camera/proc/triggerCameraAlarm(var/duration = 0)
	alarm_on = 1
	camera_alarm.triggerAlarm(loc, src, duration)

/obj/machinery/camera/proc/cancelCameraAlarm()
	if(wires.IsIndexCut(CAMERA_WIRE_ALARM))
		return

	alarm_on = 0
	camera_alarm.clearAlarm(loc, src)

//if false, then the camera is listed as DEACTIVATED and cannot be used
/obj/machinery/camera/proc/can_use()
	if(!status)
		return 0
	if(isbroken() || isemped())
		return 0
	return 1

/obj/machinery/camera/proc/can_see()
	var/list/see = null
	var/turf/pos = get_turf(src)
	if(!pos)
		return list()

	if(isXRay())
		see = range(view_range, pos)
	else
		see = hear(view_range, pos)
	return see

/atom/proc/auto_turn()
	//Automatically turns based on nearby walls.
	var/turf/simulated/wall/T = null
	for(var/i = 1, i <= 8; i += i)
		T = get_ranged_target_turf(src, i, 1)
		if(istype(T))
			//If someone knows a better way to do this, let me know. -Giacom
			switch(i)
				if(NORTH)
					src.set_dir(SOUTH)
				if(SOUTH)
					src.set_dir(NORTH)
				if(WEST)
					src.set_dir(EAST)
				if(EAST)
					src.set_dir(WEST)
			break

//Return a working camera that can see a given mob
//or null if none
/proc/seen_by_camera(var/mob/M)
	for(var/obj/machinery/camera/C in oview(4, M))
		if(C.can_use())	// check if camera disabled
			return C
			break
	return null

/proc/near_range_camera(var/mob/M)

	for(var/obj/machinery/camera/C in range(4, M))
		if(C.can_use())	// check if camera disabled
			return C
			break

	return null

/obj/machinery/camera/proc/weld(var/obj/item/weapon/tool/weldingtool/WT, var/mob/user)

	if(busy)
		return 0
	if(!WT.isOn())
		return 0

	// Do after stuff here
	to_chat(user, "<span class='notice'>You start to weld the [src]..</span>")
	playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
	WT.eyecheck(user)
	busy = 1
	if(do_after(user, 100, src))
		busy = 0
		if(!WT.isOn())
			return 0
		return 1
	busy = 0
	return 0

/obj/machinery/camera/interact(mob/living/user as mob)
	if(!panel_open || istype(user, /mob/living/silicon/ai))
		return

	if(isbroken())
		to_chat(user, SPAN_WARNING("\The [src] is broken."))
		return

	user.set_machine(src)
	wires.Interact(user)

/obj/machinery/camera/proc/add_network(var/network_name)
	add_networks(list(network_name))

/obj/machinery/camera/proc/remove_network(var/network_name)
	remove_networks(list(network_name))

/obj/machinery/camera/proc/add_networks(var/list/networks)
	var/network_added
	network_added = 0
	for(var/network_name in networks)
		if(!(network_name in src.network))
			network += network_name
			network_added = 1

	if(network_added)
		update_coverage(1)

/obj/machinery/camera/proc/remove_networks(var/list/networks)
	var/network_removed
	network_removed = 0
	for(var/network_name in networks)
		if(network_name in src.network)
			network -= network_name
			network_removed = 1

	if(network_removed)
		update_coverage(1)

/obj/machinery/camera/proc/replace_networks(var/list/networks)
	if(networks.len != network.len)
		network = networks
		update_coverage(1)
		return

	for(var/new_network in networks)
		if(!(new_network in network))
			network = networks
			update_coverage(1)
			return

/obj/machinery/camera/proc/clear_all_networks()
	if(network.len)
		network.Cut()
		update_coverage(1)

/obj/machinery/camera/proc/nano_structure()
	var/cam[0]
	cam["name"] = sanitize(c_tag)
	cam["deact"] = !can_use()
	cam["camera"] = "\ref[src]"
	cam["x"] = get_x(src)
	cam["y"] = get_y(src)
	cam["z"] = get_z(src)
	return cam

// Resets the camera's wires to fully operational state. Used by one of Malfunction abilities.
/obj/machinery/camera/proc/reset_wires()
	if(!wires)
		return
	set_broken(FALSE) // Fixes the camera and updates the icon.
	wires.CutAll()
	wires.MendAll()
	update_coverage()
