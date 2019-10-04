//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/mass_driver
	name 				= "mass driver"
	desc 				= "Shoots things into space."
	icon 				= 'icons/obj/machines/massdriver.dmi'
	icon_state 			= "mass_driver"
	anchored 			= TRUE
	use_power 			= POWER_USE_IDLE
	idle_power_usage 	= 2
	active_power_usage 	= 50
	circuit_type 		= /obj/item/weapon/circuitboard/mass_driver

	//Radio
	id_tag 				= null
	frequency 			= null
	radio_filter_in 	= RADIO_MASSDRIVER
	radio_filter_out 	= RADIO_MASSDRIVER
	radio_check_id 		= TRUE

	var/power 			= 1.0
	var/code 			= 1.0
	var/drive_range 	= 50 //this is mostly irrelevant since current mass drivers throw into space, but you could make a lower-range mass driver for interstation transport or something I guess.
	var/_wifi_id
	var/datum/wifi/receiver/button/mass_driver/wifi_receiver

/obj/machinery/mass_driver/Initialize()
	. = ..()
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)

/obj/machinery/mass_driver/Destroy()
	QDEL_NULL(wifi_receiver)
	return ..()

/obj/machinery/mass_driver/OnSignal(datum/signal/signal)
	if(!has_transmitter() || !signal)
		return
	var/command = signal.data["command"]
	if(command == "activate")
		drive()

/obj/machinery/mass_driver/proc/drive(amount)
	if(inoperable())
		return
	var/total_powerload = 500 //W
	var/O_limit
	var/atom/target = get_edge_target_turf(src, dir)
	for(var/atom/movable/O in loc)
		if(!O.anchored||istype(O, /obj/mecha))//Mechs need their launch platforms.
			O_limit++
			if(O_limit >= 20)
				audible_message(SPAN_NOTICE("The mass driver lets out a screech, it mustn't be able to handle any more items."), hearing_distance = 4)
				break
			total_powerload += 500
			INVOKE_ASYNC(O, /atom/movable/.proc/throw_at, target, (drive_range * power), power)
	use_power_oneoff(total_powerload)
	flick("mass_driver1", src)
	return

/obj/machinery/mass_driver/emp_act(severity)
	if(inoperable())
		return
	drive()
	..(severity)
