/obj/structure/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'

/obj/structure/shuttle/window
	name = "shuttle window"
	icon = 'icons/obj/podwindows.dmi'
	icon_state = "1"
	density = 1
	opacity = 0
	anchored = 1

/obj/structure/shuttle/window/CanPass(atom/movable/mover, turf/target, height, air_group)
		if(!height || air_group) return 0
		else return ..()

/obj/structure/shuttle/engine
	name = "engine"
	density = 1
	anchored = 1.0

/obj/structure/shuttle/engine/heater
	name = "heater"
	icon_state = "heater"

/obj/structure/shuttle/engine/platform
	name = "platform"
	icon_state = "platform"

/obj/structure/shuttle/engine/propulsion
	name = "propulsion"
	icon_state = "propulsion"
	opacity = 1

/obj/structure/shuttle/engine/propulsion/burst
	name = "burst"

/obj/structure/shuttle/engine/propulsion/burst/left
	name = "left"
	icon_state = "burst_l"

/obj/structure/shuttle/engine/propulsion/burst/right
	name = "right"
	icon_state = "burst_r"

/obj/structure/shuttle/engine/router
	name = "router"
	icon_state = "router"

//I'll just define a new "machine" instead
/obj/machinery/shuttleengine
	name = "Thruster"
	density = TRUE
	anchored = TRUE
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "propulsion"
	opacity = 1
	circuit_type = /obj/item/weapon/circuitboard/shuttleengine
	var/permaanchor = 0

/obj/machinery/shuttleengine/CanPass(atom/movable/mover, turf/target, height, air_group)
	if(!height || air_group) 
		return 0
	else 
		return ..()

/obj/machinery/shuttleengine/attackby(var/obj/O as obj, var/mob/user as mob)
	if(isWrench(O))
		if(permaanchor)
			to_chat(user, "The engine is wired in to an active shuttle and cannot be wrenched.")
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
	if(permaanchor)
		to_chat(user, "The engine is wired in to an active shuttle and cannot be modified.")
		return
	if(default_deconstruction_screwdriver(user, O))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	..()

/obj/machinery/shuttleengine/AltClick()
	rotate()

/obj/machinery/shuttleengine/verb/rotate()
	set name = "Rotate Clockwise"
	set category = "Object"
	set src in oview(1)

	if (src.anchored || usr:stat)
		to_chat(usr, "It is fastened to the floor!")
		return 0
	src.set_dir(turn(src.dir, 270))
	return 1

/obj/machinery/shuttleengine/verb/rotateccw()
	set name = "Rotate Counter Clockwise"
	set category = "Object"
	set src in oview(1)

	if (src.anchored || usr:stat)
		to_chat(usr, "It is fastened to the floor!")
		return 0
	src.set_dir(turn(src.dir, 90))
	return 1