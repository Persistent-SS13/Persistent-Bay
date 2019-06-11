/obj/machinery/atmospherics/pipe/vent
	name 					= "Passive Vent"
	desc 					= "A large passive air vent."
	icon 					= 'icons/atmos/vent_pipe.dmi'
	icon_state 				= "map"
	level 					= 1
	volume 					= 250
	dir 					= SOUTH
	initialize_directions 	= SOUTH
	interact_offline 		= TRUE
	idle_power_usage 		= 0
	active_power_usage 		= 0
	use_power 				= POWER_USE_OFF
	interact_offline 		= TRUE

	var/build_killswitch = 1

/obj/machinery/atmospherics/pipe/vent/high_volume
	name 	= "Large Passive Vent"
	volume 	= 1000

/obj/machinery/atmospherics/pipe/vent/setup_initialize_directions()
	. = ..()
	initialize_directions = dir

/obj/machinery/atmospherics/pipe/vent/Process()
	..()
	if(!parent)
		if(build_killswitch <= 0)
			. = PROCESS_KILL
		else
			build_killswitch--
		return
	else
		parent.mingle_with_turf(loc, volume)

/obj/machinery/atmospherics/pipe/vent/Destroy()
	if(node1)
		node1.disconnect(src)
	. = ..()

/obj/machinery/atmospherics/pipe/vent/pipeline_expansion()
	return list(node1)

/obj/machinery/atmospherics/pipe/vent/on_update_icon(var/safety = 0)
	if(!check_icon_cache())
		return
	overlays.Cut()

	var/vent_icon = "pvent"
	var/turf/T = get_turf(src)
	if(!istype(T))
		return
	if(!T.is_plating() && node1 && node1.level == 1 && istype(node1, /obj/machinery/atmospherics/pipe))
		vent_icon += "hintact"
	// else if(welded)
	// 	vent_icon += "weld"
	else 
		vent_icon += "intact"
	overlays += icon_manager.get_atmos_icon("device", , , vent_icon)

/obj/machinery/atmospherics/pipe/vent/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		if(!T.is_plating() && node1 && node1.level == 1 && istype(node1, /obj/machinery/atmospherics/pipe))
			return
		else
			if(node1)
				add_underlay(T, node1, dir, node1.icon_connect_type)
			else
				add_underlay(T,, dir)

/obj/machinery/atmospherics/pipe/vent/atmos_init()
	..()
	var/connect_direction = dir
	for(var/obj/machinery/atmospherics/target in get_step(src,connect_direction))
		if(target.initialize_directions & get_dir(target,src))
			if (check_connect_types(target,src))
				node1 = target
				break
	queue_icon_update()
	update_underlays()

/obj/machinery/atmospherics/pipe/vent/disconnect(obj/machinery/atmospherics/reference)
	if(reference == node1)
		if(istype(node1, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node1 = null
	queue_icon_update()
	update_underlays()
	return null

/obj/machinery/atmospherics/pipe/vent/hide(var/i) //to make the little pipe section invisible, the icon changes.
	update_icon()
	update_underlays()

/obj/machinery/atmospherics/pipe/vent/attackby(obj/item/weapon/tool/W, mob/user)
	if(isWrench(W))
		var/turf/T = src.loc
		if (node1 && node1.level==1 && isturf(T) && !T.is_plating())
			to_chat(user, SPAN_WARNING("You must remove the plating first."))
			return 1
		var/datum/gas_mixture/int_air = return_air()
		var/datum/gas_mixture/env_air = loc.return_air()
		if ((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
			to_chat(user, SPAN_WARNING("You cannot unwrench \the [src], it is too exerted due to internal pressure."))
			add_fingerprint(user)
			return 1
		to_chat(user, SPAN_WARNING("You begin to unfasten \the [src]..."))
		if (W.use_tool(user, src, 4 SECONDS))
			user.visible_message( \
				SPAN_NOTICE("\The [user] unfastens \the [src]."), \
				SPAN_NOTICE("You have unfastened \the [src]."), \
				"You hear a ratchet.")
			new /obj/item/pipe(loc, make_from=src)
			qdel(src)
		return TRUE
	return ..()