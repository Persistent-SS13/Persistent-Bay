//Terribly sorry for the code doubling, but things go derpy otherwise.

/obj/vis_blocker
	mouse_opacity = 0
	should_save = 0
	opacity = 1
	anchored = 1
/obj/machinery/door/airlock/multi_tile
	airlock_type = "double"
	name = "\improper Airlock"
	icon = 'icons/obj/doors/double/door.dmi'
	icon_state = "closed"
	fill_file = 'icons/obj/doors/double/fill_steel.dmi'
	color_file = 'icons/obj/doors/double/color.dmi'
	color_fill_file = 'icons/obj/doors/double/fill_color.dmi'
	stripe_file = 'icons/obj/doors/double/stripe.dmi'
	stripe_fill_file = 'icons/obj/doors/double/fill_stripe.dmi'
	glass_file = 'icons/obj/doors/double/fill_glass.dmi'
	bolts_file = 'icons/obj/doors/double/lights_bolts.dmi'
	deny_file = 'icons/obj/doors/double/lights_deny.dmi'
	lights_file = 'icons/obj/doors/double/lights_green.dmi'
	panel_file = 'icons/obj/doors/double/panel.dmi'
	welded_file = 'icons/obj/doors/double/welded.dmi'
	emag_file = 'icons/obj/doors/double/emag.dmi'
	width = 2
	appearance_flags = 0
	opacity = TRUE
	max_health = 800
	assembly_type = /obj/structure/door_assembly/multi_tile

	var/obj/vis_blocker/blocker
	
	
/obj/machinery/door/airlock/multi_tile/New()
	..()
	SetBounds()
/obj/machinery/door/airlock/multi_tile/after_load()
	SetBounds()
	..()

/obj/machinery/door/airlock/multi_tile/should_save(var/datum/caller)
	if(caller == loc)
		return ..()
	else
		return 0
	return ..()

/obj/machinery/door/airlock/multi_tile/Initialize(mapload)
	. = ..()
	if(mapload)
		queue_icon_update()
	else
		update_icon()
	SetBounds()
/obj/machinery/door/airlock/multi_tile/Move()
	. = ..()
	SetBounds()

/obj/machinery/door/airlock/multi_tile/proc/SetBounds()
	if(dir in list(NORTH, SOUTH))
		bound_width = width * world.icon_size
		bound_height = world.icon_size
	else
		bound_width = world.icon_size
		bound_height = width * world.icon_size
	if(opacity)
		for(var/turf/T in locs)
			if(T != loc)
				if(blocker)
					qdel(blocker)
				blocker = new(T)
/obj/machinery/door/airlock/multi_tile/on_update_icon(state=0, override=0)
	..()
	//Since some of the icons are off-center, we have to align them for now
	// Would tweak the icons themselves, but dm is currently crashing when trying to edit icons at all!
	switch(dir)
		if(NORTH)
			pixel_y = -32
			pixel_x = 0
		if(SOUTH)
			pixel_y = 0
			pixel_x = 0
		if(EAST)
			pixel_y = 0
			pixel_x = -32
		if(WEST)
			pixel_y = 0
			pixel_x = 0
	
	SetBounds() //Lets just be sure

/obj/machinery/door/airlock/multi_tile/update_connections(var/propagate = 0)
	var/dirs = 0

	for(var/direction in GLOB.cardinal)
		var/turf/T = get_step(src, direction)
		var/success = 0

		if(direction in list(NORTH, EAST))
			T = get_step(T, direction)

		if( istype(T, /turf/simulated/wall))
			success = 1
			if(propagate)
				var/turf/simulated/wall/W = T
				W.update_connections()
				W.update_icon()

		else if( istype(T, /turf/simulated/shuttle/wall))
			success = 1
		else
			for(var/obj/O in T)
				for(var/b_type in blend_objects)
					if( istype(O, b_type))
						success = 1
					if(success)
						break
				if(success)
					break

		if(success)
			dirs |= direction
	connections = dirs

/obj/machinery/door/airlock/multi_tile/command
	door_color = COLOR_COMMAND_BLUE
	req_one_access = list(core_access_command_programs)

/obj/machinery/door/airlock/multi_tile/security
	door_color = COLOR_NT_RED
	req_one_access = list(core_access_security_programs)

/obj/machinery/door/airlock/multi_tile/engineering
	name = "Maintenance Hatch"
	door_color = COLOR_AMBER
	req_one_access = list(core_access_engineering_programs)

/obj/machinery/door/airlock/multi_tile/medical
	door_color = COLOR_WHITE
	stripe_color = COLOR_DEEP_SKY_BLUE
	req_one_access = list(core_access_medical_programs)

/obj/machinery/door/airlock/multi_tile/virology
	door_color = COLOR_WHITE
	stripe_color = COLOR_GREEN
	req_one_access = list(core_access_medical_programs)

/obj/machinery/door/airlock/multi_tile/mining
	name = "Mining Airlock"
	door_color = COLOR_PALE_ORANGE
	stripe_color = COLOR_BEASTY_BROWN

/obj/machinery/door/airlock/multi_tile/atmos
	door_color = COLOR_AMBER
	stripe_color = COLOR_CYAN
	req_one_access = list(core_access_engineering_programs)

/obj/machinery/door/airlock/multi_tile/research
	door_color = COLOR_WHITE
	stripe_color = COLOR_RESEARCH
	req_one_access = list(core_access_science_programs)

/obj/machinery/door/airlock/multi_tile/science
	door_color = COLOR_WHITE
	stripe_color = COLOR_VIOLET
	req_one_access = list(core_access_science_programs)

/obj/machinery/door/airlock/multi_tile/sol
	door_color = COLOR_BLUE_GRAY
	req_one_access = list(core_access_command_programs)

/obj/machinery/door/airlock/multi_tile/maintenance
	name = "Maintenance Access"
	stripe_color = COLOR_AMBER
	req_one_access = list(core_access_engineering_programs)

/obj/machinery/door/airlock/multi_tile/civilian
	stripe_color = COLOR_CIVIE_GREEN

/obj/machinery/door/airlock/multi_tile/freezer
	name = "Freezer Airlock"
	door_color = COLOR_WHITE

/obj/machinery/door/airlock/multi_tile/glass
	name = "Glass Airlock"
	glass = TRUE
	opacity = FALSE
	max_health = 600

/obj/machinery/door/airlock/multi_tile/glass/command
	door_color = COLOR_COMMAND_BLUE
	stripe_color = COLOR_SKY_BLUE
	req_one_access = list(core_access_command_programs)

/obj/machinery/door/airlock/multi_tile/glass/security
	door_color = COLOR_NT_RED
	stripe_color = COLOR_ORANGE
	req_one_access = list(core_access_security_programs)

/obj/machinery/door/airlock/multi_tile/glass/engineering
	door_color = COLOR_AMBER
	stripe_color = COLOR_RED
	req_one_access = list(core_access_engineering_programs)

/obj/machinery/door/airlock/multi_tile/glass/medical
	door_color = COLOR_WHITE
	stripe_color = COLOR_DEEP_SKY_BLUE
	req_one_access = list(core_access_medical_programs)

/obj/machinery/door/airlock/multi_tile/glass/virology
	door_color = COLOR_WHITE
	stripe_color = COLOR_GREEN
	req_one_access = list(core_access_medical_programs)

/obj/machinery/door/airlock/multi_tile/glass/mining
	door_color = COLOR_PALE_ORANGE
	stripe_color = COLOR_BEASTY_BROWN

/obj/machinery/door/airlock/multi_tile/glass/atmos
	door_color = COLOR_AMBER
	stripe_color = COLOR_CYAN
	req_one_access = list(core_access_engineering_programs)

/obj/machinery/door/airlock/multi_tile/glass/research
	door_color = COLOR_WHITE
	stripe_color = COLOR_RESEARCH
	req_one_access = list(core_access_science_programs)

/obj/machinery/door/airlock/multi_tile/glass/science
	door_color = COLOR_WHITE
	stripe_color = COLOR_VIOLET
	req_one_access = list(core_access_science_programs)

/obj/machinery/door/airlock/multi_tile/glass/sol
	door_color = COLOR_BLUE_GRAY
	stripe_color = COLOR_AMBER
	req_one_access = list(core_access_command_programs)

/obj/machinery/door/airlock/multi_tile/glass/freezer
	door_color = COLOR_WHITE

/obj/machinery/door/airlock/multi_tile/glass/maintenance
	name = "Maintenance Access"
	stripe_color = COLOR_AMBER
	req_one_access = list(core_access_engineering_programs)

/obj/machinery/door/airlock/multi_tile/glass/civilian
	stripe_color = COLOR_CIVIE_GREEN

