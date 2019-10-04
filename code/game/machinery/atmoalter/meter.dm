/obj/machinery/meter
	name 			= "meter"
	desc 			= "A gas flow meter. Monitors the pipe it is attached to."
	icon 			= 'icons/obj/meter.dmi'
	icon_state 		= "meterX"
	layer = ABOVE_WINDOW_LAYER
	anchored 		= TRUE
	power_channel 	= ENVIRON
	idle_power_usage= 15

	//Radio
	id_tag 			= null
	frequency 		= null
	radio_filter_in = RADIO_ATMOSIA
	radio_filter_out= RADIO_ATMOSIA

	//#FIXME: Might be a better idea to store the thing in the pipe instead and display it as an overlay?
	var/obj/machinery/atmospherics/pipe/target = null
	var/last_pressure = -1 //The last pressure reading taken this tick

/obj/machinery/meter/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/meter/LateInitialize()
	. = ..()
	if (!target)
		set_target(locate(/obj/machinery/atmospherics/pipe) in loc)
	queue_icon_update()

/obj/machinery/meter/proc/set_target(atom/new_target)
	clear_target()
	target = new_target
	GLOB.destroyed_event.register(target, src, .proc/clear_target)

/obj/machinery/meter/proc/clear_target()
	if(target)
		GLOB.destroyed_event.unregister(target, src)
		target = null	

/obj/machinery/meter/Destroy()
	clear_target()
	. = ..()

/obj/machinery/meter/Process()
	if(!target)
		return
	var/datum/gas_mixture/pipe_air = target.return_air()
	if(!pipe_air)
		src.last_pressure = -1
	else
		src.last_pressure = pipe_air.return_pressure()

	if(has_transmitter()) 
		var/list/data = list(
			// "tag" = id,
			"device" = "AM",
			"pressure" = (last_pressure > 0)? round(last_pressure) : 0,
			"sigtype" = "status"
		)
		post_signal(data)
	queue_icon_update()

/obj/machinery/meter/on_update_icon()
	if(!target || last_pressure == -1)
		icon_state = "meterX"
		return 0
	if(inoperable())
		icon_state = "meter0"
		return 0
	
	if(last_pressure <= 0.15*ONE_ATMOSPHERE)
		icon_state = "meter0"
	else if(last_pressure <= 1.8*ONE_ATMOSPHERE)
		var/val = round(last_pressure/(ONE_ATMOSPHERE*0.3) + 0.5)
		icon_state = "meter1_[val]"
	else if(last_pressure <= 30*ONE_ATMOSPHERE)
		var/val = round(last_pressure/(ONE_ATMOSPHERE*5)-0.35) + 1
		icon_state = "meter2_[val]"
	else if(last_pressure <= 59*ONE_ATMOSPHERE)
		var/val = round(last_pressure/(ONE_ATMOSPHERE*5) - 6) + 1
		icon_state = "meter3_[val]"
	else
		icon_state = "meter4"

/obj/machinery/meter/attack_hand(mob/user)
	examine(user)

/obj/machinery/meter/examine(mob/user)
	. = ..()

	if(get_dist(user, src) > 3 && !(istype(user, /mob/living/silicon/ai) || isghost(user)))
		to_chat(user, SPAN_WARNING("You are too far away to read it."))

	else if(inoperable())
		to_chat(user, SPAN_WARNING("The display is off."))

	else if(src.target)
		var/datum/gas_mixture/environment = target.return_air()
		if(environment)
			to_chat(user, "The pressure gauge reads [round(environment.return_pressure(), 0.01)] kPa; [round(environment.temperature,0.01)]K ([round(environment.temperature-T0C,0.01)]&deg;C)")
		else
			to_chat(user, "The sensor error light is blinking.")
	else
		to_chat(user, "The connection error light is blinking.")


/obj/machinery/meter/Click()

	if(istype(usr, /mob/living/silicon/ai)) // ghosts can call ..() for examine
		usr.examinate(src)
		return 1

	return ..()

/obj/machinery/meter/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if(!isWrench(W))
		return ..()
	playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
	to_chat(user, "<span class='notice'>You begin to unfasten \the [src]...</span>")
	if (do_after(user, 40, src))
		user.visible_message( \
			"<span class='notice'>\The [user] unfastens \the [src].</span>", \
			"<span class='notice'>You have unfastened \the [src].</span>", \
			"You hear ratchet.")
		new /obj/item/pipe_meter(src.loc)
		qdel(src)

// TURF METER - REPORTS A TILE'S AIR CONTENTS

/obj/machinery/meter/turf/Initialize()
	if (!target)
		set_target(loc)
	. = ..()

/obj/machinery/meter/turf/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
