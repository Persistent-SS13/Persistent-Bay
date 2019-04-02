/obj/machinery/atmospherics/unary/vent_scrubber
	name 				= "Air Scrubber"
	desc 				= "Has a valve and pump attached to it."
	icon 				= 'icons/atmos/vent_scrubber.dmi'
	icon_state 			= "map_scrubber_off"
	use_power 			= POWER_USE_IDLE
	idle_power_usage 	= 150		//internal circuitry, friction losses and stuff
	power_rating 		= 7500			//7500 W ~ 10 HP
	connect_types 		= CONNECT_TYPE_REGULAR|CONNECT_TYPE_SCRUBBER //connects to regular and scrubber pipes
	level 				= 1
	//Radio
	id_tag 				= null
	frequency 			= AIRALARM_FREQ
	radio_filter_out 	= RADIO_TO_AIRALARM
	radio_filter_in 	= RADIO_FROM_AIRALARM
	radio_check_id 		= TRUE

	var/hibernate 		= FALSE 	//Do we even process?
	var/scrubbing 		= TRUE 		//0 = siphoning, 1 = scrubbing
	var/panic 			= FALSE 	//is this scrubber panicked?
	var/welded 			= FALSE
	var/area_uid
	var/area/initial_loc
	var/list/scrubbing_gas

	var/obj/machinery/airlock_controller_norad/norad_controller // For the no radio controller (code/modules/norad_controller)
	var/norad_UID

/obj/machinery/atmospherics/unary/vent_scrubber/on
	use_power = POWER_USE_IDLE
	icon_state = "map_scrubber_on"

/obj/machinery/atmospherics/unary/vent_scrubber/New()
	..()
	air_contents.volume = ATMOS_DEFAULT_VOLUME_FILTER
	icon = null
	ADD_SAVED_VAR(welded)
	ADD_SAVED_VAR(scrubbing_gas)
	ADD_SAVED_VAR(scrubbing)

/obj/machinery/atmospherics/unary/vent_scrubber/after_load()
	..()

/obj/machinery/atmospherics/unary/vent_scrubber/Initialize()
	if(loc)
		initial_loc = get_area(loc)
		area_uid = initial_loc.uid
	.=..()
	if(!id_tag)
		set_radio_id(make_loc_string_id("ASV"))
	if(!scrubbing_gas)
		scrubbing_gas = list()
		for(var/g in gas_data.gases)
			if(g != GAS_OXYGEN && g != GAS_NITROGEN && !(gas_data.flags[g] & XGM_GAS_REAGENT_GAS))
				scrubbing_gas += g
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/atmospherics/unary/vent_scrubber/LateInitialize()
	. = ..()
	if (has_transmitter())
		src.broadcast_status()

/obj/machinery/atmospherics/unary/vent_scrubber/Destroy()
	if(initial_loc)
		initial_loc.air_scrub_info -= id_tag
		initial_loc.air_scrub_names -= id_tag
	return ..()

/obj/machinery/atmospherics/unary/vent_scrubber/update_icon(var/safety = 0)
	if(!check_icon_cache())
		return
	overlays.Cut()
	var/turf/T = get_turf(src)
	if(!istype(T))
		return

	var/scrubber_icon = "scrubber"
	if(welded)
		scrubber_icon += "weld"
	else
		if(!powered())
			scrubber_icon += "off"
		else
			scrubber_icon += "[use_power ? "[scrubbing ? "on" : "in"]" : "off"]"

	overlays += icon_manager.get_atmos_icon("device", , , scrubber_icon)

/obj/machinery/atmospherics/unary/vent_scrubber/update_underlays()
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

/obj/machinery/atmospherics/unary/vent_scrubber/proc/broadcast_status()
	if(isnull(initial_loc))
		return
	var/list/data = list(
		"area"			= area_uid,
		"device"		= "AScr",
		"timestamp"		= world.time,
		"power" 		= use_power,
		"scrubbing" 	= scrubbing,
		"panic" 		= panic,
		"filter_o2" 	= (GAS_OXYGEN in scrubbing_gas),
		"filter_n2" 	= (GAS_NITROGEN in scrubbing_gas),
		"filter_co2" 	= (GAS_CO2 in scrubbing_gas),
		"filter_phoron" = (GAS_PHORON in scrubbing_gas),
		"filter_n2o" 	= (GAS_N2O in scrubbing_gas),
		"filter_reag" 	= (GAS_REAGENTS in scrubbing_gas),
		"sigtype" 		= "status"
	)
	if(!initial_loc.air_scrub_names[id_tag])
		var/new_name = "[initial_loc.name] Air Scrubber #[initial_loc.air_scrub_names.len+1]"
		initial_loc.air_scrub_names[id_tag] = new_name
		src.name = new_name
	initial_loc.air_scrub_info[id_tag] = data

	if(!id_tag) //Don't broadcast when you're not initialized!
		return
	broadcast_signal(data)
	return TRUE

/obj/machinery/atmospherics/unary/vent_scrubber/Process()
	..()
	if(isnull(loc))
		return
	if (hibernate > world.time)
		return 1

	if (!node)
		use_power = 0
	//broadcast_status()
	if(!use_power || inoperable())
		return 0
	if(welded)
		return 0

	var/datum/gas_mixture/environment = loc.return_air()

	var/power_draw = -1
	if(scrubbing)
		//limit flow rate from turfs
		var/transfer_moles = min(environment.total_moles, environment.total_moles*MAX_SCRUBBER_FLOWRATE/environment.volume)	//group_multiplier gets divided out here
		//checking what reagent gases need to be filtered
		var/list/scrubbed_gases_final
		if(GAS_REAGENTS in scrubbing_gas)
			scrubbed_gases_final = (scrubbing_gas - GAS_REAGENTS) //new list so that scrubbing_gas doesn't get flooded with reagent gases.
			for(var/g in environment.gas)
				if(gas_data.flags[g] & XGM_GAS_REAGENT_GAS)
					scrubbed_gases_final += g

		power_draw = scrub_gas(src, scrubbed_gases_final ? scrubbed_gases_final : scrubbing_gas, environment, air_contents, transfer_moles, power_rating)
	else //Just siphon all air
		//limit flow rate from turfs
		var/transfer_moles = min(environment.total_moles, environment.total_moles*MAX_SIPHON_FLOWRATE/environment.volume)	//group_multiplier gets divided out here

		power_draw = pump_gas(src, environment, air_contents, transfer_moles, power_rating)

	if(scrubbing && power_draw <= 0)	//99% of all scrubbers
		//Fucking hibernate because you ain't doing shit.
		hibernate = world.time + (rand(100,200))

	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power(power_draw)

	if(network)
		network.update = 1

	return 1

/obj/machinery/atmospherics/unary/vent_scrubber/hide(var/i) //to make the little pipe section invisible, the icon changes.
	update_icon()
	update_underlays()

/obj/machinery/atmospherics/unary/vent_scrubber/OnSignal(datum/signal/signal)
	. = ..()
	if(signal.data["sigtype"]!="command")
		return

	if(signal.data["power"] != null)
		use_power = text2num(signal.data["power"])
	if(signal.data["power_toggle"] != null)
		use_power = !use_power

	if(signal.data["panic_siphon"]) //must be before if("scrubbing" thing
		panic = text2num(signal.data["panic_siphon"])
		if(panic)
			update_use_power(POWER_USE_IDLE)
			scrubbing = FALSE
		else
			scrubbing = TRUE
	if(signal.data["toggle_panic_siphon"] != null)
		panic = !panic
		if(panic)
			update_use_power(POWER_USE_IDLE)
			scrubbing = FALSE
		else
			scrubbing = TRUE

	if(signal.data["scrubbing"] != null)
		scrubbing = text2num(signal.data["scrubbing"])
		if(scrubbing)
			panic = FALSE
	if(signal.data["toggle_scrubbing"])
		scrubbing = !scrubbing
		if(scrubbing)
			panic = FALSE

	var/list/toggle = list()

	if(!isnull(signal.data["o2_scrub"]) && text2num(signal.data["o2_scrub"]) != (GAS_OXYGEN in scrubbing_gas))
		toggle += GAS_OXYGEN
	else if(signal.data["toggle_o2_scrub"])
		toggle += GAS_OXYGEN

	if(!isnull(signal.data["n2_scrub"]) && text2num(signal.data["n2_scrub"]) != (GAS_NITROGEN in scrubbing_gas))
		toggle += GAS_NITROGEN
	else if(signal.data["toggle_n2_scrub"])
		toggle += GAS_NITROGEN

	if(!isnull(signal.data["co2_scrub"]) && text2num(signal.data["co2_scrub"]) != (GAS_CO2 in scrubbing_gas))
		toggle += GAS_CO2
	else if(signal.data["toggle_co2_scrub"])
		toggle += GAS_CO2

	if(!isnull(signal.data["tox_scrub"]) && text2num(signal.data["tox_scrub"]) != (GAS_PHORON in scrubbing_gas))
		toggle += GAS_PHORON
	else if(signal.data["toggle_tox_scrub"])
		toggle += GAS_PHORON

	if(!isnull(signal.data["n2o_scrub"]) && text2num(signal.data["n2o_scrub"]) != (GAS_N2O in scrubbing_gas))
		toggle += GAS_N2O
	else if(signal.data["toggle_n2o_scrub"])
		toggle += GAS_N2O

	if(!isnull(signal.data["reag_scrub"]) && text2num(signal.data["reag_scrub"]) != (GAS_REAGENTS in scrubbing_gas))
		toggle += GAS_REAGENTS
	else if(signal.data["toggle_reag_scrub"])
		toggle += GAS_REAGENTS

	scrubbing_gas ^= toggle

	if(signal.data["init"] != null)
		name = signal.data["init"]
		return

	if(signal.data["status"] != null)
		spawn(2)
			broadcast_status()
		return //do not update_icon

//			log_admin("DEBUG \[[world.timeofday]\]: vent_scrubber/receive_signal: unknown command \"[signal.data["command"]]\"\n[signal.debug_print()]")
	spawn(2)
		broadcast_status()
	update_icon()
	return

/obj/machinery/atmospherics/unary/vent_scrubber/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if(isWrench(W))
		if (ispowered() && !isoff())
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
		to_chat(user, SPAN_NOTICE("You begin to unfasten \the [src]..."))
		if (do_after(user, 40, src))
			user.visible_message( \
				"<span class='notice'>\The [user] unfastens \the [src].</span>", \
				"<span class='notice'>You have unfastened \the [src].</span>", \
				"You hear a ratchet.")
			new /obj/item/pipe(loc, make_from=src)
			qdel(src)
		return 1

	if(istype(W, /obj/item/weapon/tool/weldingtool))

		var/obj/item/weapon/tool/weldingtool/WT = W

		if(!WT.isOn())
			to_chat(user, "<span class='notice'>The welding tool needs to be on to start this task.</span>")
			return 1

		if(!WT.remove_fuel(0,user))
			to_chat(user, "<span class='warning'>You need more welding fuel to complete this task.</span>")
			return 1

		to_chat(user, "<span class='notice'>Now welding \the [src].</span>")
		playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)

		if(!do_after(user, 20, src))
			to_chat(user, "<span class='notice'>You must remain close to finish this task.</span>")
			return 1

		if(!src)
			return 1

		if(!WT.isOn())
			to_chat(user, "<span class='notice'>The welding tool needs to be on to finish this task.</span>")
			return 1

		welded = !welded
		update_icon()
		user.visible_message("<span class='notice'>\The [user] [welded ? "welds \the [src] shut" : "unwelds \the [src]"].</span>", \
			"<span class='notice'>You [welded ? "weld \the [src] shut" : "unweld \the [src]"].</span>", \
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
				to_chat(user, "<span class='warning'>\The [link] is too far away. Its effective range should be around [NORAD_MAX_RANGE] tiles.</span>")
				return
			//the actual (un)linkage below
			if (norad_controller && !QDELETED(norad_controller) )
				to_chat(user, "<span class='warning'>You unlink \the [src] from \the [norad_controller].</span>")
				if (norad_controller.tag_scrubber == src)
					norad_controller.tag_scrubber = null
					if (norad_controller.tag_scrubber_secondary)
						//switches secondary srubber to main, if any.
						norad_controller.tag_scrubber = norad_controller.tag_scrubber_secondary
						norad_controller.tag_scrubber_secondary = null
				// Checks for the secondary scrubber as well
				if(norad_controller.tag_scrubber_secondary == src)
					norad_controller.tag_scrubber_secondary = null
				norad_controller = null
			else
				norad_controller = link
				if (!norad_controller.tag_scrubber)
					norad_controller.tag_scrubber = src
				else if (!norad_controller.tag_scrubber_secondary)
					norad_controller.tag_scrubber_secondary = src
				else
					to_chat(user, "<span class='warning'>There is already two scrubbers linked. Unlink them before linking more scrubbers.</span>")
					return
				to_chat(user, "<span class='notice'>You link \the [src] to \the [link].</span>")
			return
		broadcast_status()
		to_chat(user, "<span class='notice'>A [name == "Air Vent" ? "red" : "green"] light appears on \the [src] as it broadcasts atmospheric data.</span>")
		flick("broadcast", src)
		return 1

	return ..()

/obj/machinery/atmospherics/unary/vent_scrubber/examine(mob/user)
	if(..(user, 1))
		to_chat(user, "A small gauge in the corner reads [round(last_flow_rate, 0.1)] L/s; [round(last_power_draw)] W")
	else
		to_chat(user, "You are too far away to read the gauge.")
	if(welded)
		to_chat(user, "It seems welded shut.")