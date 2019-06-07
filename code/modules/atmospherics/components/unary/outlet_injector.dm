//Basically a one way passive valve. If the pressure inside is greater than the environment then gas will flow passively,
//but it does not permit gas to flow back from the environment into the injector. Can be turned off to prevent any gas flow.
//When it receives the "inject" signal, it will try to pump it's entire contents into the environment regardless of pressure, using power.

/obj/machinery/atmospherics/unary/outlet_injector
	name 				= "air injector"
	desc 				= "Injects air into its surroundings. Has a valve attached to it that can control flow rate."
	icon 				= 'icons/atmos/injector.dmi'
	icon_state 			= "map_injector"
	use_power 			= POWER_USE_OFF
	idle_power_usage 	= 150		//internal circuitry, friction losses and stuff
	power_rating 		= 15000		//15000 W ~ 20 HP
	connect_types 		= CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER
	level 				= 1
	//Radio stuff
	id_tag 				= null
	frequency 			= null
	radio_filter_in 	= RADIO_ATMOSIA
	radio_filter_out 	= RADIO_ATMOSIA
	radio_check_id 		= TRUE

	var/injecting 		= FALSE
	var/volume_rate 	= 250	//flow rate limit

/obj/machinery/atmospherics/unary/outlet_injector/New()
	..()
	air_contents.volume = ATMOS_DEFAULT_VOLUME_PUMP + 500	//Give it a small reservoir for injecting. Also allows it to have a higher flow rate limit than vent pumps, to differentiate injectors a bit more.
	ADD_SAVED_VAR(injecting)
	ADD_SAVED_VAR(volume_rate)

/obj/machinery/atmospherics/unary/outlet_injector/on_update_icon()
	if(!powered())
		icon_state = "off"
	else
		icon_state = "[use_power ? "on" : "off"]"

/obj/machinery/atmospherics/unary/outlet_injector/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T, node, dir)

/obj/machinery/atmospherics/unary/outlet_injector/Process()
	..()
	last_power_draw = 0
	last_flow_rate = 0

	if(inoperable() || isoff())
		return

	var/power_draw = -1
	var/datum/gas_mixture/environment = loc.return_air()

	if(environment && air_contents.temperature > 0)
		var/transfer_moles = (volume_rate/air_contents.volume)*air_contents.total_moles //apply flow rate limit
		power_draw = pump_gas(src, air_contents, environment, transfer_moles, power_rating)

	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power_oneoff(power_draw)

		if(network)
			network.update = TRUE
	return 1

/obj/machinery/atmospherics/unary/outlet_injector/proc/inject()
	if(injecting || !ispowered())
		return 0

	var/datum/gas_mixture/environment = loc.return_air()
	if (!environment)
		return 0

	injecting = TRUE

	if(air_contents.temperature > 0)
		var/power_used = pump_gas(src, air_contents, environment, air_contents.total_moles, power_rating)
		use_power_oneoff(power_used)

		if(network)
			network.update = TRUE

	flick("inject", src)

/obj/machinery/atmospherics/unary/outlet_injector/proc/broadcast_status()
	if(!has_transmitter())
		return FALSE
	broadcast_signal(list(
		"device" = "AO",
		"power" = use_power,
		"volume_rate" = volume_rate,
		"sigtype" = "status"
	 ))
	return TRUE

/obj/machinery/atmospherics/unary/outlet_injector/OnSignal(datum/signal/signal)
	. = ..()
	return OnTopic(usr, signal.data, GLOB.default_state)

/obj/machinery/atmospherics/unary/outlet_injector/OnTopic(mob/user, href_list, datum/topic_state/state)
	. = ..()
	if(href_list["sigtype"] != "command")
		return TOPIC_NOACTION

	if(href_list["power"])
		update_use_power(sanitize_integer(text2num(href_list["power"]), POWER_USE_OFF, POWER_USE_ACTIVE, use_power))

	if(href_list["power_toggle"])
		update_use_power(!use_power)

	if(href_list["inject"])
		spawn inject()
		return

	if(href_list["set_volume_rate"])
		var/number = text2num(href_list["set_volume_rate"])
		volume_rate = between(0, number, air_contents.volume)

	if(href_list["status"])
		addtimer(CALLBACK(src, .proc/broadcast_status), 2, TIMER_UNIQUE)
		return //do not update_icon

	addtimer(CALLBACK(src, .proc/broadcast_status), 2, TIMER_UNIQUE)
	queue_icon_update()
	return TOPIC_REFRESH

/obj/machinery/atmospherics/unary/outlet_injector/hide(var/i)
	update_underlays()

/obj/machinery/atmospherics/unary/outlet_injector/attackby(var/obj/item/weapon/tool/W as obj, var/mob/user as mob)
	if(isWrench(W))
		to_chat(user, SPAN_NOTICE("You begin to unfasten \the [src]..."))
		if (W.use_tool(user, src, 4 SECONDS))
			user.visible_message( \
				SPAN_NOTICE("\The [user] unfastens \the [src]."), \
				SPAN_NOTICE("You have unfastened \the [src]."), \
				"You hear a ratchet.")
			dismantle()
	return ..()

/obj/machinery/atmospherics/unary/outlet_injector/dismantle()
	new /obj/item/pipe(loc, make_from=src)
	qdel(src)

/obj/machinery/atmospherics/unary/outlet_injector/attack_hand(mob/user)
	use_power = !use_power
	user.visible_message( \
		SPAN_NOTICE("\The [user] turns \the [src] [use_power ? "on" : "off"]."), \
		SPAN_NOTICE("You turn \the [src] [use_power ? "on" : "off"]."))
	update_icon()
