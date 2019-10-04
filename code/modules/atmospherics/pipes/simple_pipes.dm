/obj/machinery/atmospherics/pipe/simple
	name = "pipe"
	desc = "A one meter section of regular pipe."
	icon = 'icons/atmos/pipes.dmi'
	icon_state = ""
	var/pipe_icon = "" //what kind of pipe it is and from which dmi is the icon manager getting its icons, "" for simple pipes, "hepipe" for HE pipes, "hejunction" for HE junctions
	volume = ATMOS_DEFAULT_VOLUME_PIPE
	dir = SOUTH
	initialize_directions = SOUTH|NORTH
	alert_pressure = 170*ONE_ATMOSPHERE
	maximum_pressure = 210*ONE_ATMOSPHERE
	fatigue_pressure = 170*ONE_ATMOSPHERE
	level = 1
	max_health = 30

	var/minimum_temperature_difference = 300
	var/thermal_conductivity = 0 //WALL_HEAT_TRANSFER_COEFFICIENT No
	var/time_next_fatigue_dmg = 0 //Time until applying fatigue damage again
	var/time_next_sndupdate = 0

/obj/machinery/atmospherics/pipe/simple/New()
	..()
	// Pipe colors and icon states are handled by an image cache - so color and icon should
	//  be null. For mapping purposes color is defined in the object definitions.
	icon = null
	alpha = 255

/obj/machinery/atmospherics/pipe/simple/Destroy()
	if(node1)
		node1.disconnect(src)
		node1 = null
	if(node2)
		node2.disconnect(src)
		node1 = null
	. = ..()

/obj/machinery/atmospherics/pipe/simple/setup_initialize_directions()
	switch(dir)
		if(SOUTH)
			initialize_directions = SOUTH|NORTH
		if(NORTH)
			initialize_directions = NORTH|SOUTH
		if(EAST)
			initialize_directions = EAST|WEST
		if(WEST)
			initialize_directions = WEST|EAST
		if(NORTHEAST)
			initialize_directions = NORTH|EAST
		if(NORTHWEST)
			initialize_directions = NORTH|WEST
		if(SOUTHEAST)
			initialize_directions = SOUTH|EAST
		if(SOUTHWEST)
			initialize_directions = SOUTH|WEST

/obj/machinery/atmospherics/pipe/simple/hide(var/i)
	if(istype(loc, /turf/simulated))
		set_invisibility(i ? 101 : 0)
	queue_icon_update()

/obj/machinery/atmospherics/pipe/simple/Process()
	if(QDELETED(parent)) //This should cut back on the overhead calling build_network thousands of times per cycle
		parent = null //Sometimes the pipeline stays stuck
		..()
	else if(leaking)
		parent.mingle_with_turf(loc, volume)
		if(world.time >= time_next_sndupdate) //only check every seconds at most
			if(!sound_token && parent.air && parent.air.return_pressure())
				update_sound(1)
			else if(sound_token && parent.air && !parent.air.return_pressure())
				update_sound(0)
			time_next_sndupdate = world.time + 1 SECOND
	else
		. = PROCESS_KILL

/obj/machinery/atmospherics/pipe/simple/check_pressure(var/pressure)
	// Don't ask me, it happened somehow.
	var/turf/T = get_turf(src)
	if (!istype(T))
		return 1

	var/datum/gas_mixture/environment = T.return_air()
	var/pressure_difference = pressure - environment.return_pressure()

	if(pressure_difference > maximum_pressure)
		if(prob(40))
			burst()
	if(pressure_difference > fatigue_pressure)
		if(world.time >= time_next_fatigue_dmg)
			take_damage(1, DAM_BLUNT, 100, "pressure fatigue") //Apply fatigue damage
			time_next_fatigue_dmg = world.time + 2 SECONDS //Apply 1 damage every 2 seconds
		return
	return 1

/obj/machinery/atmospherics/pipe/simple/destroyed()
	burst()

/obj/machinery/atmospherics/pipe/simple/proc/burst()
	log_warning("[src] at [x],[y],[z] bursted open!")
	ASSERT(parent)
	parent.temporarily_store_air()
	src.visible_message("<span class='danger'>\The [src] bursts!</span>");
	playsound(src.loc, 'sound/effects/bang.ogg', 25, 1)
	var/datum/effect/effect/system/smoke_spread/smoke = new
	smoke.set_up(1,0, src.loc, 0)
	smoke.start()
	qdel(src)

/obj/machinery/atmospherics/pipe/simple/proc/normalize_dir()
	if(dir == (NORTH | SOUTH))
		set_dir(NORTH)
	else if(dir == (EAST | WEST))
		set_dir(EAST)

/obj/machinery/atmospherics/pipe/simple/pipeline_expansion()
	return list(node1, node2)

/obj/machinery/atmospherics/pipe/simple/change_color(var/new_color)
	..()
	//for updating connected atmos device pipes (i.e. vents, manifolds, etc)
	if(node1)
		node1.update_underlays()
	if(node2)
		node2.update_underlays()

/obj/machinery/atmospherics/pipe/simple/on_update_icon(var/safety = 0)
	if(QDELETED(src) || QDELING(src))
		return
	if(!atmos_initalized)
		return
	if(!check_icon_cache())
		return

	alpha = 255

	overlays.Cut()

	if(!node1 && !node2)
		var/turf/T = get_turf(src)
		new /obj/item/pipe(loc, make_from=src)
		for (var/obj/machinery/meter/meter in T)
			if (meter.target == src)
				new /obj/item/pipe_meter(T)
				qdel(meter)
		log_debug("[src]([x],[y],[z]) was deleted in update_icon() because both its nodes are null!")
		qdel(src)
	else if(node1 && node2)
		overlays += icon_manager.get_atmos_icon("pipe", , pipe_color, "[pipe_icon]intact[icon_connect_type]")
		set_leaking(FALSE)
	else
		overlays += icon_manager.get_atmos_icon("pipe", , pipe_color, "[pipe_icon]exposed[node1?1:0][node2?1:0][icon_connect_type]")
		set_leaking(TRUE)

/obj/machinery/atmospherics/pipe/simple/update_underlays()
	return

/obj/machinery/atmospherics/pipe/simple/atmos_init()
	if(QDELETED(src) || QDELING(src) || !loc)
		return
	..()
	normalize_dir()
	var/node1_dir
	var/node2_dir

	for(var/direction in GLOB.cardinal)
		if(direction & initialize_directions)
			if (!node1_dir)
				node1_dir = direction
			else if (!node2_dir)
				node2_dir = direction

	for(var/obj/machinery/atmospherics/target in get_step(src,node1_dir))
		if(target.initialize_directions & get_dir(target,src))
			if (check_connect_types(target,src))
				node1 = target
				break
	for(var/obj/machinery/atmospherics/target in get_step(src,node2_dir))
		if(target.initialize_directions & get_dir(target,src))
			if (check_connect_types(target,src))
				node2 = target
				break

	if(!node1 && !node2)
		log_debug("[src]([x],[y],[z]) was deleted in atmos_init() because both its nodes are null! initialize_directions: [initialize_directions], dir: [dir], level: [level], node1_dir: [node1_dir], node2_dir: [node2_dir]")
		qdel(src)
		return

	var/turf/T = loc
	if(level == 1 && !T.is_plating()) 
		hide(1)
	queue_icon_update()

/obj/machinery/atmospherics/pipe/simple/disconnect(obj/machinery/atmospherics/reference)
	if(reference == node1)
		if(istype(node1, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node1 = null

	if(reference == node2)
		if(istype(node2, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node2 = null

	queue_icon_update()

	return null

//
//	Over-floor variant
//
/obj/machinery/atmospherics/pipe/simple/visible
	icon_state = "intact"
	level = 2

/obj/machinery/atmospherics/pipe/simple/visible/scrubbers
	name = "Scrubbers pipe"
	desc = "A one meter section of scrubbers pipe."
	icon_state = "intact-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/simple/visible/supply
	name = "Air supply pipe"
	desc = "A one meter section of supply pipe."
	icon_state = "intact-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/simple/visible/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/simple/visible/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/simple/visible/green
	color = PIPE_COLOR_GREEN

/obj/machinery/atmospherics/pipe/simple/visible/black
	color = PIPE_COLOR_BLACK

/obj/machinery/atmospherics/pipe/simple/visible/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/simple/visible/blue
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/simple/visible/fuel
	name = "Fuel pipe"
	color = PIPE_COLOR_ORANGE
	maximum_pressure = 420*ONE_ATMOSPHERE
	fatigue_pressure = 350*ONE_ATMOSPHERE
	alert_pressure = 350*ONE_ATMOSPHERE

/obj/machinery/atmospherics/pipe/simple/hidden
	icon_state = "intact"
	level = 1
	alpha = 128		//set for the benefit of mapping - this is reset to opaque when the pipe is spawned in game

/obj/machinery/atmospherics/pipe/simple/hidden/scrubbers
	name = "Scrubbers pipe"
	desc = "A one meter section of scrubbers pipe."
	icon_state = "intact-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/simple/hidden/supply
	name = "Air supply pipe"
	desc = "A one meter section of supply pipe."
	icon_state = "intact-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/simple/hidden/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/simple/hidden/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/simple/hidden/green
	color = PIPE_COLOR_GREEN

/obj/machinery/atmospherics/pipe/simple/hidden/black
	color = PIPE_COLOR_BLACK

/obj/machinery/atmospherics/pipe/simple/hidden/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/simple/hidden/blue
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/simple/hidden/fuel
	name = "Fuel pipe"
	color = PIPE_COLOR_ORANGE
	maximum_pressure = 420*ONE_ATMOSPHERE
	fatigue_pressure = 350*ONE_ATMOSPHERE
	alert_pressure = 350*ONE_ATMOSPHERE
