

// Wall mounted remote-control igniter.
/obj/machinery/sparker
	name = "mounted igniter"
	desc = "A wall-mounted ignition device."
	icon = 'icons/obj/machines/igniters.dmi'
	icon_state = "migniter"
	anchored = TRUE
	use_power = POWER_USE_IDLE
	idle_power_usage = 2
	active_power_usage = 4
	matter = list(MATERIAL_STEEL = 4000)
	frame_type = /obj/item/frame/sparker

	//Radio
	id_tag 				= null
	frequency 			= MISC_MACHINE_FREQ
	radio_filter_in 	= RADIO_IGNITER
	radio_filter_out 	= RADIO_IGNITER
	radio_check_id 		= TRUE

	var/disable = 0
	var/last_spark = 0

/obj/machinery/sparker/Initialize()
	. = ..()
	if(!map_storage_loaded)
		get_or_create_extension(src, /datum/extension/base_icon_state, /datum/extension/base_icon_state, icon_state)

/obj/machinery/sparker/update_icon()
	if(disable)
		icon_state = "migniter-d"
	else if(powered())
		icon_state = "migniter"
	else
		icon_state = "migniter-p"

/obj/machinery/sparker/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(default_deconstruction_screwdriver(W))
		return
	if(default_deconstruction_crowbar(W))
		return
	return ..()

/obj/machinery/sparker/attack_ai()
	interact(usr)

/obj/machinery/sparker/interact(mob/user)
	if(anchored)
		spark()

/obj/machinery/sparker/proc/spark()
	if(inoperable())
		return
	if(disable || (last_spark && world.time < last_spark + 50))
		return

	flick("migniter-spark", src)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(2, 1, src)
	s.start()
	src.last_spark = world.time
	use_power_oneoff(1000)
	var/turf/location = src.loc
	if (isturf(location))
		location.hotspot_expose(1000,500,1)
	return 1

/obj/machinery/sparker/OnSignal(datum/signal/signal)
	. = ..()
	if(signal.data["activate"])
		spark()
