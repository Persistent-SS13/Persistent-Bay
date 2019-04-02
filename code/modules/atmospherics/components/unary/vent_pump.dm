#define DEFAULT_PRESSURE_DELTA 10000
#define PRESSURE_CHECK_EXTERNAL 1
#define PRESSURE_CHECK_INTERNAL 2

#define EXTERNAL_PRESSURE_BOUND ONE_ATMOSPHERE
#define INTERNAL_PRESSURE_BOUND 0
#define PRESSURE_CHECKS PRESSURE_CHECK_EXTERNAL | PRESSURE_CHECK_INTERNAL

/obj/machinery/atmospherics/unary/vent_pump
	name 				= "Air Vent"
	desc 				= "Has a valve and pump attached to it."
	icon 				= 'icons/atmos/vent_pump.dmi'
	icon_state 			= "map_vent"
	use_power 			= POWER_USE_IDLE
	idle_power_usage 	= 150		//internal circuitry, friction losses and stuff
	power_rating 		= 7500			//7500 W ~ 10 HP
	level 				= 1
	connect_types 		= CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY //connects to regular and supply pipes

	//Radio stuff
	id_tag 				= null
	frequency 			= AIRALARM_FREQ
	radio_filter_in  	= RADIO_FROM_AIRALARM
	radio_filter_out 	= RADIO_TO_AIRALARM
	radio_check_id 		= TRUE 

	var/area/initial_loc
	var/area_uid
	var/hibernate 		= 0 //Do we even process?
	var/pump_direction 	= 1 //0 = siphoning, 1 = releasing

	var/external_pressure_bound = EXTERNAL_PRESSURE_BOUND
	var/internal_pressure_bound = INTERNAL_PRESSURE_BOUND
	var/pressure_checks 		= PRESSURE_CHECKS
	//1: Do not pass external_pressure_bound
	//2: Do not pass internal_pressure_bound
	//3: Do not pass either

	// Used when handling incoming radio signals requesting default settings
	var/external_pressure_bound_default = EXTERNAL_PRESSURE_BOUND
	var/internal_pressure_bound_default = INTERNAL_PRESSURE_BOUND
	var/pressure_checks_default 		= PRESSURE_CHECKS

	var/welded = FALSE // Added for aliens -- TLE

	var/obj/machinery/airlock_controller_norad/norad_controller // For the no radio controller (code/modules/norad_controller)
	var/norad_UID

/obj/machinery/atmospherics/unary/vent_pump/on
	use_power = POWER_USE_IDLE
	icon_state = "map_vent_out"

/obj/machinery/atmospherics/unary/vent_pump/siphon
	pump_direction = 0

/obj/machinery/atmospherics/unary/vent_pump/siphon/on
	use_power = POWER_USE_IDLE
	icon_state = "map_vent_in"

/obj/machinery/atmospherics/unary/vent_pump/siphon/on/atmos
	use_power = POWER_USE_IDLE
	icon_state = "map_vent_in"
	external_pressure_bound = 0
	external_pressure_bound_default = 0
	internal_pressure_bound = MAX_PUMP_PRESSURE
	internal_pressure_bound_default = MAX_PUMP_PRESSURE
	pressure_checks = 2
	pressure_checks_default = 2

/obj/machinery/atmospherics/unary/vent_pump/New()
	..()
	air_contents.volume = ATMOS_DEFAULT_VOLUME_PUMP
	icon = null
	if(loc)
		initial_loc = get_area(loc)
		area_uid = initial_loc.uid
	ADD_SAVED_VAR(pump_direction)
	ADD_SAVED_VAR(welded)
	ADD_SAVED_VAR(external_pressure_bound)
	ADD_SAVED_VAR(internal_pressure_bound)
	ADD_SAVED_VAR(pressure_checks)

/obj/machinery/atmospherics/unary/vent_pump/Initialize()
	.=..()
	if(!id_tag)
		set_radio_id(make_loc_string_id("AVP"))
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/atmospherics/unary/vent_pump/LateInitialize()
	. = ..()
	if (has_transmitter())
		src.broadcast_status()

/obj/machinery/atmospherics/unary/vent_pump/atmos_init()
	. = ..()
	if(!node)
		update_use_power(POWER_USE_OFF) //Turn off if disconnected

/obj/machinery/atmospherics/unary/vent_pump/Destroy()
	if(initial_loc)
		initial_loc.air_vent_info -= id_tag
		initial_loc.air_vent_names -= id_tag
	. = ..()

/obj/machinery/atmospherics/unary/vent_pump/high_volume
	name = "Large Air Vent"
	power_channel = EQUIP
	power_rating = 15000	//15 kW ~ 20 HP

/obj/machinery/atmospherics/unary/vent_pump/high_volume/New()
	..()
	air_contents.volume = ATMOS_DEFAULT_VOLUME_PUMP + 800

/obj/machinery/atmospherics/unary/vent_pump/engine
	name = "Engine Core Vent"
	power_channel = ENVIRON
	power_rating = 30000	//15 kW ~ 20 HP

/obj/machinery/atmospherics/unary/vent_pump/engine/New()
	..()
	air_contents.volume = ATMOS_DEFAULT_VOLUME_PUMP + 500 //meant to match air injector

/obj/machinery/atmospherics/unary/vent_pump/disconnect(obj/machinery/atmospherics/reference)
	. = ..()
	update_use_power(POWER_USE_OFF)

/obj/machinery/atmospherics/unary/vent_pump/update_icon(var/safety = 0)
	if(!check_icon_cache())
		return
	overlays.Cut()

	var/vent_icon = "vent"

	var/turf/T = get_turf(src)
	if(!istype(T))
		return

	if(!T.is_plating() && node && node.level == 1 && istype(node, /obj/machinery/atmospherics/pipe))
		vent_icon += "h"

	if(welded)
		vent_icon += "weld"
	else if(!powered())
		vent_icon += "off"
	else
		vent_icon += "[use_power ? "[pump_direction ? "out" : "in"]" : "off"]"

	overlays += icon_manager.get_atmos_icon("device", , , vent_icon)

/obj/machinery/atmospherics/unary/vent_pump/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		if(!T.is_plating() && node && node.level == 1 && istype(node, /obj/machinery/atmospherics/pipe))
			return
		else
			if(node)
				add_underlay(T, node, dir, node.icon_connect_type)
			else
				add_underlay(T,, dir)

/obj/machinery/atmospherics/unary/vent_pump/hide()
	update_icon()
	update_underlays()

/obj/machinery/atmospherics/unary/vent_pump/proc/can_pump()
	if(inoperable())
		return FALSE
	if(isoff())
		return FALSE
	if(welded)
		return FALSE
	return TRUE

/obj/machinery/atmospherics/unary/vent_pump/Process()
	..()
	if(isnull(loc))
		return
	if (hibernate > world.time)
		return 1

	if (!node)
		update_use_power(POWER_USE_OFF) //Turn off if disconnected
	if(!can_pump())
		return 0

	var/datum/gas_mixture/environment = loc.return_air()

	var/power_draw = -1

	//Figure out the target pressure difference
	var/pressure_delta = get_pressure_delta(environment)
	//src.visible_message("DEBUG >>> [src]: pressure_delta = [pressure_delta]")

	if((environment.temperature || air_contents.temperature) && pressure_delta > 0.5)
		if(pump_direction) //internal -> external
			var/transfer_moles = calculate_transfer_moles(air_contents, environment, pressure_delta)
			power_draw = pump_gas(src, air_contents, environment, transfer_moles, power_rating)
		else //external -> internal
			var/transfer_moles = calculate_transfer_moles(environment, air_contents, pressure_delta, (network)? network.volume : 0)

			//limit flow rate from turfs
			transfer_moles = min(transfer_moles, environment.total_moles*air_contents.volume/environment.volume)	//group_multiplier gets divided out here
			power_draw = pump_gas(src, environment, air_contents, transfer_moles, power_rating)

	else
		//If we're in an area that is fucking ideal, and we don't have to do anything, chances are we won't next tick either so why redo these calculations?
		//JESUS FUCK.  THERE ARE LITERALLY 250 OF YOU MOTHERFUCKERS ON ZLEVEL ONE AND YOU DO THIS SHIT EVERY TICK WHEN VERY OFTEN THERE IS NO REASON TO
		// -shhhhhh.. its okay. Breath in man.
		if(pump_direction && pressure_checks == PRESSURE_CHECK_EXTERNAL) //99% of all vents
			hibernate = world.time + (rand(100,200))


	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power(power_draw)
		if(network)
			network.update = TRUE

	return 1

/obj/machinery/atmospherics/unary/vent_pump/proc/get_pressure_delta(datum/gas_mixture/environment)
	var/pressure_delta = DEFAULT_PRESSURE_DELTA
	var/environment_pressure = environment.return_pressure()

	if(pump_direction) //internal -> external
		if(pressure_checks & PRESSURE_CHECK_EXTERNAL)
			pressure_delta = min(pressure_delta, external_pressure_bound - environment_pressure) //increasing the pressure here
		if(pressure_checks & PRESSURE_CHECK_INTERNAL)
			pressure_delta = min(pressure_delta, air_contents.return_pressure() - internal_pressure_bound) //decreasing the pressure here
	else //external -> internal
		if(pressure_checks & PRESSURE_CHECK_EXTERNAL)
			pressure_delta = min(pressure_delta, environment_pressure - external_pressure_bound) //decreasing the pressure here
		if(pressure_checks & PRESSURE_CHECK_INTERNAL)
			pressure_delta = min(pressure_delta, internal_pressure_bound - air_contents.return_pressure()) //increasing the pressure here

	return pressure_delta

/obj/machinery/atmospherics/unary/vent_pump/proc/broadcast_status()
	if(isnull(initial_loc))
		return FALSE
	var/list/data = list(
		"area" 		= src.area_uid,
		"device" 	= "AVP",
		"power" 	= !isoff(),
		"direction" = pump_direction?("release"):("siphon"),
		"checks" 	= pressure_checks,
		"internal" 	= internal_pressure_bound,
		"external" 	= external_pressure_bound,
		"timestamp" = world.time,
		"sigtype" 	= "status",
		"power_draw"= last_power_draw,
		"flow_rate" = last_flow_rate,
	)

	if(!initial_loc.air_vent_names[id_tag])
		var/new_name = "[initial_loc.name] Vent Pump #[initial_loc.air_vent_names.len+1]"
		initial_loc.air_vent_names[id_tag] = new_name
		src.name = new_name
	initial_loc.air_vent_info[id_tag] = data

	if(!id_tag) //No points in emitting signal when no tag assigned
		return FALSE
	broadcast_signal(data)
	return TRUE

/obj/machinery/atmospherics/unary/vent_pump/OnSignal(datum/signal/signal)
	. = ..()
	hibernate = 0

	if(signal.data["purge"] != null)
		pressure_checks &= ~1
		pump_direction = 0

	if(signal.data["stabalize"] != null)
		pressure_checks |= 1
		pump_direction = 1

	if(signal.data["power"] != null)
		use_power = text2num(signal.data["power"])

	if(signal.data["power_toggle"] != null)
		use_power = !use_power

	if(signal.data["direction_toggle"] != null)
		pump_direction = !pump_direction

	if(signal.data["checks"] != null)
		if (signal.data["checks"] == "default")
			pressure_checks = pressure_checks_default
		else
			pressure_checks = text2num(signal.data["checks"])

	if(signal.data["checks_toggle"] != null)
		pressure_checks = (pressure_checks?0:3)

	if(signal.data["direction"] != null)
		pump_direction = text2num(signal.data["direction"])

	if(signal.data["set_internal_pressure"] != null)
		if (signal.data["set_internal_pressure"] == "default")
			internal_pressure_bound = internal_pressure_bound_default
		else
			internal_pressure_bound = between(
				0,
				text2num(signal.data["set_internal_pressure"]),
				ONE_ATMOSPHERE*50
			)

	if(signal.data["set_external_pressure"] != null)
		if (signal.data["set_external_pressure"] == "default")
			external_pressure_bound = external_pressure_bound_default
		else
			external_pressure_bound = between(
				0,
				text2num(signal.data["set_external_pressure"]),
				ONE_ATMOSPHERE*50
			)

	if(signal.data["adjust_internal_pressure"] != null)
		internal_pressure_bound = between(
			0,
			internal_pressure_bound + text2num(signal.data["adjust_internal_pressure"]),
			ONE_ATMOSPHERE*50
		)

	if(signal.data["adjust_external_pressure"] != null)
		external_pressure_bound = between(
			0,
			external_pressure_bound + text2num(signal.data["adjust_external_pressure"]),
			ONE_ATMOSPHERE*50
		)

	if(signal.data["init"] != null)
		name = signal.data["init"]
		return

	if(signal.data["status"] != null)
		spawn(2)
			broadcast_status()
		return //do not update_icon

		//log_admin("DEBUG \[[world.timeofday]\]: vent_pump/receive_signal: unknown command \"[signal.data["command"]]\"\n[signal.debug_print()]")
	spawn(2)
		broadcast_status()
	update_icon()
	return

/obj/machinery/atmospherics/unary/vent_pump/attackby(obj/item/W, mob/user)
	if(isWelder(W))
		var/obj/item/weapon/tool/weldingtool/WT = W
		to_chat(user, SPAN_NOTICE("Now welding \the [src]."))
		if(!WT.use_tool(user, src, 2 SECONDS))
			to_chat(user, SPAN_NOTICE("You must remain close to finish this task."))
			return 1

		// if(!src)
		// 	return 1

		if(!WT.isOn())
			to_chat(user, SPAN_NOTICE("The welding tool needs to be on to finish this task."))
			return 1

		welded = !welded
		update_icon()
		user.visible_message(SPAN_NOTICE("\The [user] [welded ? "welds \the [src] shut" : "unwelds \the [src]"]."), \
			SPAN_NOTICE("You [welded ? "weld \the [src] shut" : "unweld \the [src]"]."), \
			"You hear welding.")
		return 1

	if(isMultitool(W))
		var/obj/item/device/multitool/mt = W
		if (istype(mt.get_buffer(), /obj/machinery/airlock_controller_norad))
			var/obj/machinery/airlock_controller_norad/link = mt.get_buffer()
			if (!istype(link) )
				return 0
			//checks if the linked airlock_controller_norad is in range.
			if (!(link in view(NORAD_MAX_RANGE) ) )
				to_chat(user, SPAN_WARNING("\The [link] is too far away. Its effective range should be around [NORAD_MAX_RANGE] tiles."))
				return
			//the actual (un)linkage below
			if (norad_controller && !QDELETED(norad_controller) )
				to_chat(user, SPAN_WARNING("You unlink \the [src] from \the [norad_controller]."))
				if (norad_controller.tag_airpump == src)
					norad_controller.tag_airpump = null
				norad_controller = null
			else
				norad_controller = link
				norad_controller.tag_airpump = src
				to_chat(user, SPAN_NOTICE("You link \the [src] to \the [link]."))
			return
		broadcast_status()
		to_chat(user, SPAN_NOTICE("A [name == "Air Vent" ? "red" : "green"] light appears on \the [src] as it broadcasts atmospheric data."))
		flick("broadcast", src)
	if(isWrench(W))
		if (!(stat & NOPOWER) && use_power)
			to_chat(user, SPAN_WARNING("You cannot unwrench \the [src], turn it off first."))
			return 1
		var/turf/T = src.loc
		if (node && node.level==1 && isturf(T) && !T.is_plating())
			to_chat(user, SPAN_WARNING("You must remove the plating first."))
			return 1
		var/datum/gas_mixture/int_air = return_air()
		var/datum/gas_mixture/env_air = loc.return_air()
		if ((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
			to_chat(user, SPAN_WARNING("You cannot unwrench \the [src], it is too exerted due to internal pressure."))
			add_fingerprint(user)
			return 1
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		to_chat(user, SPAN_WARNING("You begin to unfasten \the [src]..."))
		if (do_after(user, 40, src))
			user.visible_message( \
				SPAN_NOTICE("\The [user] unfastens \the [src]."), \
				SPAN_NOTICE("You have unfastened \the [src]."), \
				"You hear a ratchet.")
			new /obj/item/pipe(loc, make_from=src)
			qdel(src)
	else
		..()

/obj/machinery/atmospherics/unary/vent_pump/examine(mob/user)
	if(..(user, 1))
		to_chat(user, "A small gauge in the corner reads [round(last_flow_rate, 0.1)] L/s; [round(last_power_draw)] W")
	else
		to_chat(user, "You are too far away to read the gauge.")
	if(welded)
		to_chat(user, "It seems welded shut.")


#undef DEFAULT_PRESSURE_DELTA

#undef EXTERNAL_PRESSURE_BOUND
#undef INTERNAL_PRESSURE_BOUND
#undef PRESSURE_CHECKS

#undef PRESSURE_CHECK_EXTERNAL
#undef PRESSURE_CHECK_INTERNAL
