/obj/machinery/embedded_controller
	var/datum/computer/file/embedded_program/program	//the currently executing program
	name = "Embedded Controller"
	anchored = TRUE
	use_power = POWER_USE_IDLE
	idle_power_usage = 10
	var/on = TRUE


/obj/machinery/embedded_controller/receive_signal(datum/signal/signal, receive_method, receive_param)
	if(!..())
		return

	if(program)
		program.receive_signal(signal, receive_method, receive_param)

/obj/machinery/embedded_controller/Process()
	if(program)
		program.process()

	update_icon()

/obj/machinery/embedded_controller/attack_ai(mob/user as mob)
	src.ui_interact(user)

/obj/machinery/embedded_controller/attack_hand(mob/user as mob)
	if(!user.IsAdvancedToolUser())
		return 0
	src.ui_interact(user)

/obj/machinery/embedded_controller/ui_interact()
	return

//
// Radio Controller
//
/obj/machinery/embedded_controller/radio
	icon 			= 'icons/obj/airlock_machines.dmi'
	icon_state 		= "airlock_control_standby"
	power_channel 	= ENVIRON
	density 		= FALSE
	unacidable 		= TRUE

	id_tag 			= null
	frequency 		= DOOR_FREQ
	radio_filter_in = RADIO_AIRLOCK
	radio_filter_out= RADIO_AIRLOCK
	

/obj/machinery/embedded_controller/radio/Initialize()
	. = ..()

/obj/machinery/embedded_controller/radio/update_icon()
	if(!on || !program)
		icon_state = "airlock_control_off"
	else if(program.memory["processing"])
		icon_state = "airlock_control_process"
	else
		icon_state = "airlock_control_standby"

/obj/machinery/embedded_controller/radio/post_signal(var/list/data, var/filter = null)
	if(has_transmitter())
		return post_signal(data, filter)
