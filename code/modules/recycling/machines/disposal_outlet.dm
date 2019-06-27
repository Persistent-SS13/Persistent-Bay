// the disposal outlet machine
/obj/structure/disposaloutlet
	name = "disposal outlet"
	desc = "An outlet for the pneumatic disposal system."
	icon = 'icons/obj/pipes/disposal.dmi'
	icon_state = "outlet"
	density = TRUE
	anchored = TRUE
	atom_flags = ATOM_FLAG_CLIMBABLE
	var/active = FALSE
	var/turf/target	// this will be where the output objects are 'thrown' to.
	var/screwed = TRUE
	
/obj/structure/disposaloutlet/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/disposaloutlet/LateInitialize()
	. = ..()
	target = get_ranged_target_turf(src, dir, 10)
	var/turf/T = get_turf(src)
	if(!istype(T))
		return //Sometimes deleted shit might call this from nullspace
	var/obj/structure/disposalpipe/trunk/trunk = locate() in T
	if(trunk)
		trunk.linked = src	// link the pipe trunk to self

// expel the contents of the holder object, then delete it
// called when the holder exits the outlet
/obj/structure/disposaloutlet/proc/expel(var/obj/structure/disposalholder/H)
	flick("outlet-open", src)
	playsound(src, 'sound/machines/warning-buzzer.ogg', 50, 0, 0)
	sleep(20)	//wait until correct animation frame
	playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)

	if(H)
		for(var/atom/movable/AM in H)
			AM.forceMove(src.loc)
			AM.pipe_eject(dir)
			if(!istype(AM,/mob/living/silicon/robot/drone)) //Drones keep smashing windows from being fired out of chutes. Bad for the station. ~Z
				spawn(5)
					AM.throw_at(target, 3, 1)
		H.vent_gas(src.loc)
		qdel(H)

/obj/structure/disposaloutlet/attackby(var/obj/item/weapon/tool/T, var/mob/user)
	if(isScrewdriver(T) && T.use_tool(user, src, 1 SECOND))
		src.add_fingerprint(user)
		if(screwed)
			screwed = FALSE
			to_chat(user, "You remove the screws around the power connection.")
			return TRUE
		else if(!screwed)
			screwed = TRUE
			to_chat(user, "You attach the screws around the power connection.")
			return TRUE
	else if(istype(T,/obj/item/weapon/tool/weldingtool) && !screwed)
		src.add_fingerprint(user)
		var/obj/item/weapon/tool/weldingtool/W = T
		to_chat(user, "You start slicing the floorweld off the disposal outlet.")
		if(W.use_tool(user, src, 2 SECONDS))
			to_chat(user, "You sliced the floorweld off the disposal outlet.")
			var/obj/structure/disposalconstruct/C = new (src.loc)
			src.transfer_fingerprints_to(C)
			C.ptype = 7 // 7 =  outlet
			C.update()
			C.set_anchored(TRUE)
			C.set_density(TRUE)
			qdel(src)
			return TRUE
	return ..()