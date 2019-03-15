/obj/machinery/status_light
	name 				= "combustion chamber status indicator"
	desc 				= "A status indicator for a combustion chamber, based on temperature. Match with a gas sensor sharing the same ID, set to report temperature."
	icon 				= 'icons/obj/machines/doortimer.dmi'
	icon_state 			= "doortimer-p"
	frame_type 			= /obj/item/weapon/
	//Radio
	id_tag 				= null
	frequency 			= AIRALARM_FREQ
	radio_filter_in 	= RADIO_ATMOSIA
	radio_filter_out 	= RADIO_ATMOSIA
	radio_check_id 		= TRUE

	var/alert_temperature = 10000
	var/alert 			  = 1

/obj/machinery/status_light/Initialize()
	. = ..()
	update_icon()

/obj/machinery/status_light/update_icon()
	if(inoperable())
		icon_state = "doortimer-b"
		return
	icon_state = "doortimer[alert]"

/obj/machinery/status_light/OnSignal(datum/signal/signal)
	if(!..() || !signal.data["temperature"])
		return
	if(signal.data["temperature"] >= alert_temperature)
		alert = 1
	else
		alert = 2
	update_icon()
	return
