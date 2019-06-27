/obj/machinery/atmospherics/unary/vent_scrubber
	name 				= "Air Scrubber"
	desc 				= "Has a valve and pump attached to it."
	icon 				= 'icons/atmos/vent_scrubber.dmi'
	icon_state 			= "map_scrubber_off"
	use_power 			= POWER_USE_IDLE
	idle_power_usage 	= 150		//internal circuitry, friction losses and stuff
	power_rating 		= 30000			// 30000 W ~ 40 HP
	connect_types 		= CONNECT_TYPE_REGULAR|CONNECT_TYPE_SCRUBBER //connects to regular and scrubber pipes
	level 				= 1
	//Radio
	id_tag 				= null
	frequency 			= AIRALARM_FREQ
	radio_filter_out 	= RADIO_TO_AIRALARM
	radio_filter_in 	= RADIO_FROM_AIRALARM
	radio_check_id 		= TRUE

	var/hibernate 		= FALSE 	//Do we even process?
	var/scrubbing 		= SCRUBBER_EXCHANGE
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
	ADD_SAVED_VAR(scrubbing)
	ADD_SAVED_VAR(scrubbing_gas)
	ADD_SAVED_VAR(panic)

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
			if(g != GAS_OXYGEN && g != GAS_NITROGEN)
				scrubbing_gas += g
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/atmospherics/unary/vent_scrubber/after_load()
	. = ..()
	//Check if we've got non-existent gases, or new ones
	var/list/toremove = list()
	for(var/g in scrubbing_gas)
		if(!(g in gas_data.gases))
			toremove += g
	scrubbing_gas -= toremove

/obj/machinery/atmospherics/unary/vent_scrubber/LateInitialize()
	. = ..()
	if (has_transmitter())
		src.broadcast_status()

/obj/machinery/atmospherics/unary/vent_scrubber/Destroy()
	if(initial_loc)
		initial_loc.air_scrub_info -= id_tag
		initial_loc.air_scrub_names -= id_tag
	return ..()

/obj/machinery/atmospherics/unary/vent_scrubber/on_update_icon(var/safety = 0)
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
			scrubber_icon += "[use_power ? "[scrubbing == SCRUBBER_EXCHANGE ? "on" : "in"]" : "off"]"

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
		"filter_co" 	= (GAS_CARBON_MONOXIDE in scrubbing_gas),
		"filter_phoron" = (GAS_PHORON in scrubbing_gas),
		"filter_n2o" 	= (GAS_N2O in scrubbing_gas),
		"sigtype" 		= "status"
	)

	//Add all gas scrubbed, to the advanced list
	data["filtered"] = scrubbing_gas.Copy()
	
	if(!initial_loc.air_scrub_names[id_tag])
		var/new_name = "[initial_loc.name] Air Scrubber #[initial_loc.air_scrub_names.len+1]"
		initial_loc.air_scrub_names[id_tag] = new_name
		src.SetName(new_name)
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

	if (use_power && !node)
		update_use_power(POWER_USE_OFF)
	//broadcast_status()
	if(!use_power || inoperable())
		return 0
	if(welded)
		return 0

	var/datum/gas_mixture/environment = loc.return_air()

	var/power_draw = -1
	var/transfer_moles = 0
	if(scrubbing == SCRUBBER_SIPHON) //Just siphon all air
		//limit flow rate from turfs
		transfer_moles = min(environment.total_moles, environment.total_moles*MAX_SIPHON_FLOWRATE/environment.volume)	//group_multiplier gets divided out here
		power_draw = pump_gas(src, environment, air_contents, transfer_moles, power_rating)
	else  //limit flow rate from turfs
		transfer_moles = min(environment.total_moles, environment.total_moles*MAX_SCRUBBER_FLOWRATE/environment.volume)	//group_multiplier gets divided out here
		
		//TODO: This is copying and allocation a list every single ticks its running. 
		//checking what reagent gases need to be filtered
		// var/list/scrubbed_gases_final
		// if(GAS_REAGENTS in scrubbing_gas)
		// 	scrubbed_gases_final = (scrubbing_gas - GAS_REAGENTS) //new list so that scrubbing_gas doesn't get flooded with reagent gases.
		// 	for(var/g in environment.gas)
		// 		if(gas_data.flags[g] & XGM_GAS_REAGENT_GAS)
		// 			scrubbed_gases_final += g
		// power_draw = scrub_gas(src, scrubbed_gases_final, environment, air_contents, transfer_moles, power_rating)
		power_draw = scrub_gas(src, scrubbing_gas, environment, air_contents, transfer_moles, power_rating)

	if(scrubbing != SCRUBBER_SIPHON && power_draw <= 0)	//99% of all scrubbers
		//Fucking hibernate because you ain't doing shit.
		hibernate = world.time + (rand(100,200))
	else if(scrubbing == SCRUBBER_EXCHANGE) // after sleep check so it only does an exchange if there are bad gasses that have been scrubbed
		transfer_moles = min(environment.total_moles, environment.total_moles*MAX_SCRUBBER_FLOWRATE/environment.volume)
		power_draw += pump_gas(src, environment, air_contents, transfer_moles / 4, power_rating)

	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power_oneoff(power_draw)

	if(network)
		network.update = 1

	return 1

/obj/machinery/atmospherics/unary/vent_scrubber/hide(var/i) //to make the little pipe section invisible, the icon changes.
	queue_icon_update()
	update_underlays()

/obj/machinery/atmospherics/unary/vent_scrubber/OnSignal(datum/signal/signal)
	. = ..()
	if(signal.data["sigtype"]!="command")
		return

	if(signal.data["power"] != null)
		update_use_power(sanitize_integer(text2num(signal.data["power"]), POWER_USE_OFF, POWER_USE_ACTIVE, use_power))
	if(signal.data["power_toggle"] != null)
		update_use_power(!use_power)

	if(signal.data["panic_siphon"]) //must be before if("scrubbing" thing
		panic = text2num(signal.data["panic_siphon"])
		if(panic)
			update_use_power(POWER_USE_IDLE)
			scrubbing = SCRUBBER_SIPHON
		else
			scrubbing = SCRUBBER_EXCHANGE
	if(signal.data["toggle_panic_siphon"] != null)
		panic = !panic
		if(panic)
			update_use_power(POWER_USE_IDLE)
			scrubbing = SCRUBBER_SIPHON
		else
			scrubbing = SCRUBBER_EXCHANGE

	if(signal.data["scrubbing"])
		scrubbing = signal.data["scrubbing"]
		testing("Received signal = [scrubbing]")
		if(scrubbing != SCRUBBER_SIPHON)
			panic = FALSE

	if(signal.data["toggle_scrubbing"])
		scrubbing = (scrubbing == SCRUBBER_EXCHANGE)? SCRUBBER_SIPHON : SCRUBBER_EXCHANGE
		if(scrubbing != SCRUBBER_SIPHON)
			panic = FALSE

	if(signal.data["gas_scrub"])
		var/gasname = signal.data["gas_scrub"]
		var/gasstate = between(FALSE, text2num(signal.data["gas_scrub_state"]), TRUE)
		if(gasname in gas_data.gases)
			if(gasstate)
				scrubbing_gas |= gasname
			else
				scrubbing_gas -= gasname
	else if(signal.data["toggle_gas_scrub"])
		var/gasname = signal.data["gas_scrub"]
		if(gasname in gas_data.gases) //Filter out any bullshit received from the client
			if(gasname in scrubbing_gas)
				scrubbing_gas -= gasname
			else
				scrubbing_gas |= gasname

	//Leave the defaults gas switches
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

	if(!isnull(signal.data["co_scrub"]) && text2num(signal.data["co_scrub"]) != (GAS_CARBON_MONOXIDE in scrubbing_gas))
		toggle += GAS_CARBON_MONOXIDE
	else if(signal.data["toggle_co_scrub"])
		toggle += GAS_CARBON_MONOXIDE

	if(!isnull(signal.data["tox_scrub"]) && text2num(signal.data["tox_scrub"]) != (GAS_PHORON in scrubbing_gas))
		toggle += GAS_PHORON
	else if(signal.data["toggle_tox_scrub"])
		toggle += GAS_PHORON

	if(!isnull(signal.data["n2o_scrub"]) && text2num(signal.data["n2o_scrub"]) != (GAS_N2O in scrubbing_gas))
		toggle += GAS_N2O
	else if(signal.data["toggle_n2o_scrub"])
		toggle += GAS_N2O

	scrubbing_gas ^= toggle

	if(signal.data["init"] != null)
		SetName(signal.data["init"])
		return

	if(signal.data["status"] != null)
		spawn(2)
			broadcast_status()
		return //do not update_icon

//			log_admin("DEBUG \[[world.timeofday]\]: vent_scrubber/receive_signal: unknown command \"[signal.data["command"]]\"\n[signal.debug_print()]")
	spawn(2)
		broadcast_status()
	queue_icon_update()
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


// Handles toggling gases to scrub
/obj/machinery/atmospherics/unary/vent_scrubber/proc/handle_gas_toggling(var/list/sigdata)

