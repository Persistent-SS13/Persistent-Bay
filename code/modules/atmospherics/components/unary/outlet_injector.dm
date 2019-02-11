//Basically a one way passive valve. If the pressure inside is greater than the environment then gas will flow passively,
//but it does not permit gas to flow back from the environment into the injector. Can be turned off to prevent any gas flow.
//When it receives the "inject" signal, it will try to pump it's entire contents into the environment regardless of pressure, using power.

/obj/machinery/atmospherics/unary/outlet_injector
	icon = 'icons/atmos/injector.dmi'
	icon_state = "map_injector"

	name = "air injector"
	desc = "Injects air into its surroundings. Has a valve attached to it that can control flow rate."

	use_power = POWER_USE_OFF
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 15000	//15000 W ~ 20 HP
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER
	var/injecting = FALSE
	var/volume_rate = 50	//flow rate limit
	var/frequency = 1441
	var/id = null
	var/radio_filter = RADIO_ATMOSIA
	//var/datum/radio_frequency/radio_connection
	level = 1

/obj/machinery/atmospherics/unary/outlet_injector/New()
	..()
	air_contents.volume = ATMOS_DEFAULT_VOLUME_PUMP + 500	//Give it a small reservoir for injecting. Also allows it to have a higher flow rate limit than vent pumps, to differentiate injectors a bit more.

/obj/machinery/atmospherics/unary/outlet_injector/Initialize()
	. = ..()
	if(!map_storage_loaded && id)
		create_transmitter(id, frequency, radio_filter)

/obj/machinery/atmospherics/unary/outlet_injector/update_icon()
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
		use_power(power_draw)

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
		use_power(power_used)

		if(network)
			network.update = TRUE

	flick("inject", src)

/obj/machinery/atmospherics/unary/outlet_injector/set_radio_frequency(var/freq as num)
	src.frequency = freq
	..()

/obj/machinery/atmospherics/unary/outlet_injector/proc/broadcast_status()
	if(!has_transmitter())
		return FALSE
	post_signal(list(
		"tag" = id,
		"device" = "AO",
		"power" = use_power,
		"volume_rate" = volume_rate,
		"sigtype" = "status"
	 ))
	return TRUE

/obj/machinery/atmospherics/unary/outlet_injector/OnTopic(mob/user, href_list, datum/topic_state/state)
	. = ..()
	if(href_list["sigtype"] != "command")
		return TOPIC_NOACTION

	if(href_list["power"])
		use_power = text2num(href_list["power"])

	if(href_list["power_toggle"])
		use_power = !use_power

	if(href_list["inject"])
		spawn inject()
		return

	if(href_list["set_volume_rate"])
		var/number = text2num(href_list["set_volume_rate"])
		volume_rate = between(0, number, air_contents.volume)

	if(href_list["status"])
		spawn(2)
			broadcast_status()
		return //do not update_icon

	spawn(2)
		broadcast_status()
	update_icon()
	return TOPIC_REFRESH

/obj/machinery/atmospherics/unary/outlet_injector/hide(var/i)
	update_underlays()

/obj/machinery/atmospherics/unary/outlet_injector/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if(!isWrench(W))
		return ..()
	if(ison())
		to_chat(user, SPAN_NOTICE("You have to turn \the [src] off before detaching it."))
	playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
	to_chat(user, SPAN_NOTICE("You begin to unfasten \the [src]..."))
	if (do_after(user, 40, src))
		user.visible_message( \
			SPAN_NOTICE("\The [user] unfastens \the [src]."), \
			SPAN_NOTICE("You have unfastened \the [src]."), \
			"You hear a ratchet.")
		new /obj/item/pipe(loc, make_from=src)
		qdel(src)

/obj/machinery/atmospherics/unary/outlet_injector/attack_hand(mob/user)
	use_power = !use_power
	user.visible_message( \
		SPAN_NOTICE("\The [user] turns \the [src] [use_power ? "on" : "off"]."), \
		SPAN_NOTICE("You turn \the [src] [use_power ? "on" : "off"]."))
	update_icon()