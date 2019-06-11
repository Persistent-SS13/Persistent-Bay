/obj/machinery/igniter
	name = "igniter"
	desc = "It's useful for igniting flammable items."
	icon = 'icons/obj/machines/igniters.dmi'
	icon_state = "igniter1"
	var/id = null
	max_health = 150
	anchored = TRUE
	use_power = POWER_USE_IDLE
	idle_power_usage = 2
	active_power_usage = 4
	var/_wifi_id
	var/datum/wifi/receiver/button/igniter/wifi_receiver
	var/time_next_spark


/obj/machinery/igniter/New()
	..()
	ADD_SAVED_VAR(_wifi_id)
	ADD_SAVED_VAR(time_next_spark)
	ADD_SKIP_EMPTY(_wifi_id)

/obj/machinery/igniter/Initialize()
	. = ..()
	queue_icon_update()
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)

/obj/machinery/igniter/before_save()
	. = ..()
	//Convert to absolute time
	if(ison() && time_next_spark)
		time_next_spark = world.time - time_next_spark

/obj/machinery/igniter/after_load()
	. = ..()
	//Convert to relative time
	if(ison() && time_next_spark)
		time_next_spark = world.time + time_next_spark

/obj/machinery/igniter/on_update_icon()
	icon_state = "igniter[ison()]"

/obj/machinery/igniter/Destroy()
	QDEL_NULL(wifi_receiver)
	return ..()

/obj/machinery/igniter/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/igniter/Process()	//ugh why is this even in process()?
	if (ison() && powered() && world.time > time_next_spark)
		time_next_spark = world.time + 1 SECONDS
		var/turf/location = src.loc
		if (isturf(location))
			location.hotspot_expose(1000,500,1)

/obj/machinery/igniter/turn_active()
	use_power_oneoff(50)
	time_next_spark = world.time + 1 SECONDS
	..()

/obj/machinery/igniter/proc/toggle()
	if(ison())
		turn_idle()
	else
		turn_active()

/obj/machinery/igniter/interact()
	toggle()

