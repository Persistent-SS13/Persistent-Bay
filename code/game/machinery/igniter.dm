/obj/machinery/igniter
	name = "igniter"
	desc = "It's useful for igniting flammable items."
	icon = 'icons/obj/machines/igniters.dmi'
	icon_state = "igniter0"
	max_health = 150
	damthreshold_burn = 50
	damthreshold_brute = 10
	density = 0
	anchored = TRUE
	use_power = POWER_USE_IDLE
	idle_power_usage = 2
	active_power_usage = 4
	var/time_next_spark

	//Radio stuff
	id_tag = null
	frequency = MISC_MACHINE_FREQ
	radio_filter_in = RADIO_IGNITER
	radio_filter_out = RADIO_IGNITER
	radio_check_id = TRUE

	circuit_type = /obj/item/weapon/circuitboard/igniter

/obj/machinery/igniter/Initialize()
	. = ..()
	queue_icon_update()

/obj/machinery/igniter/ShouldInitProcess()
	return FALSE

/obj/machinery/igniter/on_update_icon()
	icon_state = "igniter[isactive()]"

/obj/machinery/igniter/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/igniter/Process()	//ugh why is this even in process()?
	if(inoperable())
		return
	if (isactive() && world.time > time_next_spark)
		time_next_spark = world.time + 1 SECONDS
		var/turf/location = src.loc
		if (isturf(location))
			location.hotspot_expose(1000,500,1)

/obj/machinery/igniter/turn_active()
	use_power_oneoff(50)
	time_next_spark = world.time + 1 SECONDS
	START_PROCESSING(SSmachines, src)
	. = ..()

/obj/machinery/igniter/turn_idle()
	STOP_PROCESSING(SSmachines, src)
	. = ..()

/obj/machinery/igniter/proc/toggle()
	if(isactive())
		turn_idle()
	else
		turn_active()

/obj/machinery/igniter/interact()
	toggle()

/obj/machinery/igniter/OnSignal(datum/signal/signal)
	if(!signal.data)
		return
	if(signal.data["activate"])
		toggle()
		return TRUE

/obj/machinery/igniter/attackby(obj/item/O, mob/user)
	if(default_deconstruction_screwdriver(O, user))
		return TRUE
	if(default_deconstruction_crowbar(O, user))
		return TRUE
	return ..()
	