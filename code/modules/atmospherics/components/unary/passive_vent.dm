/obj/machinery/atmospherics/pipe/vent
	name = "Passive Vent"
	desc = "A large passive air vent."
	icon = 'icons/obj/atmospherics/pipe_vent.dmi'
	icon_state = "intact"

	level = 1
	volume = 250
	dir = SOUTH
	initialize_directions = SOUTH
	interact_offline = TRUE
	idle_power_usage = 0
	active_power_usage = 0
	use_power = POWER_USE_OFF

	var/build_killswitch = 1

/obj/machinery/atmospherics/pipe/vent/New()
	initialize_directions = dir
	..()

/obj/machinery/atmospherics/pipe/vent/high_volume
	name = "Large Passive Vent"
	volume = 1000

/obj/machinery/atmospherics/pipe/vent/Process()
	..()
	if(!parent)
		if(build_killswitch <= 0)
			. = PROCESS_KILL
		else
			build_killswitch--
		..()
		return
	else
		parent.mingle_with_turf(loc, volume)

/obj/machinery/atmospherics/pipe/vent/Destroy()
	if(node1)
		node1.disconnect(src)
	. = ..()

/obj/machinery/atmospherics/pipe/vent/pipeline_expansion()
	return list(node1)

/obj/machinery/atmospherics/pipe/vent/update_icon()
	if(node1)
		icon_state = "intact"
		set_dir(get_dir(src, node1))
	else
		icon_state = "exposed"

/obj/machinery/atmospherics/pipe/vent/atmos_init()
	..()
	var/connect_direction = dir
	for(var/obj/machinery/atmospherics/target in get_step(src,connect_direction))
		if(target.initialize_directions & get_dir(target,src))
			if (check_connect_types(target,src))
				node1 = target
				break

	update_icon()

/obj/machinery/atmospherics/pipe/vent/disconnect(obj/machinery/atmospherics/reference)
	if(reference == node1)
		if(istype(node1, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node1 = null
	update_icon()
	return null

/obj/machinery/atmospherics/pipe/vent/hide(var/i) //to make the little pipe section invisible, the icon changes.
	if(node1)
		icon_state = "[i == 1 && istype(loc, /turf/simulated) ? "h" : "" ]intact"
		set_dir(get_dir(src, node1))
	else
		icon_state = "exposed"
