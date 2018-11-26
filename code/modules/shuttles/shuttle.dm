/datum/shuttle
	var/name = ""
	var/warmup_time = 10
	var/moving_status = SHUTTLE_IDLE
	var/area/shuttle_area
	var/obj/effect/shuttle_landmark/current_location
	var/initial_location
	var/arrive_time = 0	//the time at which the shuttle arrives when long jumping
	var/flags = 0
	var/process_state = IDLE_STATE //Used with SHUTTLE_FLAGS_PROCESS, as well as to store current state.
	var/category = /datum/shuttle
	var/ceiling_type = /turf/simulated/floor/plating // Turf to use as ceiling
	var/sound_takeoff = 'sound/effects/shuttle_takeoff.ogg'
	var/sound_landing = 'sound/effects/shuttle_landing.ogg'
	var/knockdown = 1 //whether shuttle downs non-buckled people when it moves
	var/defer_initialisation = FALSE //this shuttle will/won't be initialised by something after roundstart
	var/finalized = 0
	var/owner // Owner, person or faction
	var/ownertype = 1 // 1 = personal, 2 = factional
	var/obj/machinery/computer/bridge_computer/bridge // The shuttle bridge computer
	var/size = 1 // size of shuttle

/datum/shuttle/New()
	..()

/datum/shuttle/proc/setup()
	if(!islist(shuttle_area))
		if(shuttle_area)
			shuttle_area = list(shuttle_area)
		else
			shuttle_area = list()

	if(initial_location)
		current_location = initial_location
	else
		current_location = locate(current_location)

	SSshuttle.shuttles[src.name] = src
	if(flags & SHUTTLE_FLAGS_PROCESS)
		SSshuttle.process_shuttles += src

	if(flags & SHUTTLE_FLAGS_SUPPLY)
		if(supply_controller.shuttle)
			CRASH("A supply shuttle is already defined.")
		supply_controller.shuttle = src
	if(!istype(current_location))
		CRASH("Shuttle \"[name]\" could not find its starting location.")

/datum/shuttle/Destroy()
	current_location = null
	SSshuttle.shuttles -= src.name
	SSshuttle.process_shuttles -= src
	if(supply_controller.shuttle == src)
		supply_controller.shuttle = null
	. = ..()

// remove_ceiling - Removes the shuttle ceiling
// if interior and has open level above ceiling level replace with base turf (should be /turf/simulated/open)
// if interior and has no open level above ceiling level, do nothing
// if exterior, replace turfs only in space area and do not replace walls
/datum/shuttle/proc/remove_ceiling()
	for(var/area/A in shuttle_area)
		if(HasAbove(current_location.z))
			for(var/turf/TO in A.contents)
				var/turf/TA = GetAbove(TO)
				if (bridge.dock.dock_interior == 1 && get_base_turf_by_area(TA.loc))
					TA.ChangeTurf(get_base_turf_by_area(TA.loc), 1, 1)
				if (bridge.dock.dock_interior == 0)
					if (istype(TA.loc,/area/space) && !istype(TA,/turf/simulated/wall))
						TA.ChangeTurf(/turf/space, 1, 1, 1)
						for(var/atom/AT in TA.contents)
							if (istype(AT, /atom/movable/lighting_overlay)) // Remove lighting overlay on space turfs
								TA.contents -= AT
								qdel(AT)

// add_ceiling - Adds ceiling so the air doesn't leak out
// Replace ceiling if not in space and /turf/simulated/open above
// Replace ceiling if in space and there are no walls above
/datum/shuttle/proc/add_ceiling()
	if(HasAbove(current_location.z))
		for(var/area/A in shuttle_area)
			for(var/turf/TD in A.contents)
				var/turf/TA = GetAbove(TD)
				if(!istype(TA.loc,/area/space) && istype(TA,/turf/simulated/open))
					TA.ChangeTurf(ceiling_type, 1, 1)
				if(istype(TA.loc,/area/space) && !istype(TA,/turf/simulated/wall))
					TA.ChangeTurf(ceiling_type, 1, 1)

// short_jump - Perform a short shuttle jump
/datum/shuttle/proc/short_jump(var/obj/effect/shuttle_landmark/destination, var/obj/effect/shuttle_landmark/location)
	if(moving_status != SHUTTLE_IDLE) return

	moving_status = SHUTTLE_WARMUP
	playsound(current_location.loc, sound_takeoff, 100, 20, 1)
	sleep(warmup_time*10)
	if (moving_status == SHUTTLE_IDLE)
		return FALSE	//someone cancelled the launch

	if(!fuel_check()) //fuel error (probably out of fuel) occured, so cancel the launch
		var/datum/shuttle/autodock/S = src
		if(istype(S))
			S.cancel_launch(null)
		return
	moving_status = SHUTTLE_INTRANSIT //shouldn't matter but just to be safe
	attempt_move(destination, location)
	moving_status = SHUTTLE_IDLE

// long_jump - Perform a long shuttle jump
/datum/shuttle/proc/long_jump(var/obj/effect/shuttle_landmark/destination, var/obj/effect/shuttle_landmark/interim, var/travel_time)
	if(moving_status != SHUTTLE_IDLE) return

	var/obj/effect/shuttle_landmark/start_location = current_location

	moving_status = SHUTTLE_WARMUP
	if(sound_takeoff)
		playsound(current_location, sound_takeoff, 100, 20, 0.2)
	spawn(warmup_time*10)
		if(moving_status == SHUTTLE_IDLE)
			return	//someone cancelled the launch

		if(!fuel_check()) //fuel error (probably out of fuel) occured, so cancel the launch
			var/datum/shuttle/autodock/S = src
			if(istype(S))
				S.cancel_launch(null)
			return

		arrive_time = world.time + travel_time*10
		moving_status = SHUTTLE_INTRANSIT
		if(attempt_move(interim))
			var/fwooshed = 0
			while (world.time < arrive_time)
				if(!fwooshed && (arrive_time - world.time) < 100)
					fwooshed = 1
					playsound(destination, sound_landing, 100, 0, 7)
				sleep(5)
			if(!attempt_move(destination))
				attempt_move(start_location) //try to go back to where we started. If that fails, I guess we're stuck in the interim location

		moving_status = SHUTTLE_IDLE

/datum/shuttle/proc/fuel_check()
	return 1 //fuel check should always pass in non-overmap shuttles (they have magic engines)

// attempt_move - Prepare the shuttle for moving
/datum/shuttle/proc/attempt_move(var/obj/effect/shuttle_landmark/destination, var/obj/effect/shuttle_landmark/location)
	if(location) current_location = location
	if(current_location == destination)
		return FALSE

	// Remove bad areas, todo: find where they are coming from.
	for (var/area/A in shuttle_area)
		if (A.name == "Unknown")
			shuttle_area -= A
			qdel(A)

	if(istype(destination) && !destination.is_valid(src))
		return FALSE
	var/list/translation = list()
	for(var/area/A in shuttle_area)
		if(istype(A, /area/space))
			message_admins("Shuttle [src] is trying to move space area.")
			return
		if(!istype(A, /area/shuttle))
			message_admins("broken shuttle [src] with areas [english_list(shuttle_area)] trying to move.")
			return
		translation += get_turf_translation(get_turf(current_location), get_turf(destination), A.contents)
	shuttle_moved(destination, translation)
	return TRUE

/datum/shuttle/proc/get_corner_turf()
	var/list/turfs = list()
	for(var/area/A in shuttle_area)
		for(var/turf/T in A.contents)
			turfs |= T
	var/turf/corner
	for(var/turf/T in turfs)
		if(!corner || (T.x <= corner.x && T.y <= corner.y))
			corner = T
	return corner

// shuttle_moved - Move the shuttle to desired destination
/datum/shuttle/proc/shuttle_moved(var/obj/effect/shuttle_landmark/destination, var/list/turf_translation)

	for(var/turf/src_turf in turf_translation)
		var/turf/dst_turf = turf_translation[src_turf]
		if(src_turf.is_solid_structure()) //in case someone put a hole in the shuttle and you were lucky enough to be under it
			for(var/atom/movable/AM in dst_turf)
				if(1)//!AM.simulated)
					continue
				if(isliving(AM))
					var/mob/living/bug = AM
					bug.gib()
				else
					qdel(AM) //it just gets atomized I guess? TODO throw it into space somewhere, prevents people from using shuttles as an atom-smasher
	var/list/powernets = list()

	remove_ceiling()

	for(var/area/A in shuttle_area)
		if(knockdown)
			for(var/mob/M in A)
				if(M.client)
					spawn(0)
						if(M.buckled)
							to_chat(M, "<span class='warning'>Sudden acceleration presses you into your chair!</span>")
							shake_camera(M, 3, 1)
						else
							to_chat(M, "<span class='warning'>The floor lurches beneath you!</span>")
							shake_camera(M, 10, 1)
				if(istype(M, /mob/living/carbon))
					if(!M.buckled)
						M.Weaken(3)

		for(var/obj/structure/cable/C in A)
			powernets |= C.powernet

	// Move the shuttle
	message_admins("dock_interior [bridge.dock.dock_interior].")
	if(bridge.dock.dock_interior == 1)
		translate_turfs(turf_translation, get_area(current_location), /turf/simulated/floor/plating)
	else
		translate_turfs(turf_translation, locate(world.area), /turf/space)

	// Reset interior lighting
	var/obj/machinery/docking_beacon/dest_dock
	for (var/obj/machinery/docking_beacon/i in destination)
		dest_dock = i
	if (istype(bridge.dock,/obj/machinery/docking_beacon) && istype(dest_dock,/obj/machinery/docking_beacon))
		if (bridge.dock.dock_interior == 1 || dest_dock.dock_interior == 1)
			var/area/A = get_area(current_location)
			var/area/B = get_area(destination)
			spawn(0)
				if(bridge.dock.dock_interior == 1)
					A.set_lightswitch(0); sleep(10); A.set_lightswitch(1)
				if(dest_dock.dock_interior == 1)
					B.set_lightswitch(0); sleep(10); B.set_lightswitch(1)

	current_location = destination
	add_ceiling()

	// Remove all powernets that were affected, and rebuild them
	var/list/cables = list()
	for(var/datum/powernet/P in powernets)
		cables |= P.cables
		qdel(P)
	for(var/obj/structure/cable/C in cables)
		if(!C.powernet)
			var/datum/powernet/NewPN = new()
			NewPN.add_cable(C)
			propagate_network(C,C.powernet)

//returns 1 if the shuttle has a valid arrive time
/datum/shuttle/proc/has_arrive_time()
	return (moving_status == SHUTTLE_INTRANSIT)
