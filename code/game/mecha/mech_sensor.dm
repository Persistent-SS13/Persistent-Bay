/obj/machinery/mech_sensor
	name 			= "mechatronic sensor"
	desc 			= "Regulates mech movement."
	icon 			= 'icons/obj/airlock_machines.dmi'
	icon_state 		= "airlock_sensor_off"
	anchored 		= TRUE
	density 		= TRUE
	throwpass 		= TRUE
	use_power 		= POWER_USE_IDLE
	layer 			= ABOVE_WINDOW_LAYER
	power_channel 	= EQUIP

	//Radio
	id_tag 			= null
	frequency 		= DOOR_FREQ
	radio_filter_in = RADIO_AIRLOCK
	radio_filter_out= RADIO_AIRLOCK
	radio_check_id 	= TRUE

	var/on 			= FALSE

/obj/machinery/mech_sensor/Initialize()
	. = ..()

/obj/machinery/mech_sensor/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(!src.enabled()) 
		return TRUE
	if(air_group || (height==0)) 
		return TRUE

	if ((get_dir(loc, target) & dir) && src.is_blocked(mover))
		src.give_feedback(mover)
		return FALSE
	return TRUE

/obj/machinery/mech_sensor/proc/is_blocked(O as obj)
	if(istype(O, /obj/mecha/medical/odysseus))
		var/obj/mecha/medical/odysseus/M = O
		for(var/obj/item/mecha_parts/mecha_equipment/ME in M.equipment)
			if(istype(ME, /obj/item/mecha_parts/mecha_equipment/tool/sleeper))
				var/obj/item/mecha_parts/mecha_equipment/tool/sleeper/S = ME
				if(S.occupant != null)
					return FALSE

	return istype(O, /obj/mecha) || istype(O, /obj/vehicle)

/obj/machinery/mech_sensor/proc/give_feedback(O as obj)
	var/block_message = SPAN_WARNING("Movement control overridden. Area denial active.")
	var/feedback_timer = 0
	if(feedback_timer)
		return

	if(istype(O, /obj/mecha))
		var/obj/mecha/R = O
		if(R && R.occupant)
			to_chat(R.occupant, block_message)
	else if(istype(O, /obj/vehicle/train/cargo/engine))
		var/obj/vehicle/train/cargo/engine/E = O
		if(E && E.load && E.is_train_head())
			to_chat(E.load, block_message)

	feedback_timer = 1
	spawn(50) //Without this timer the feedback becomes horribly spamy
		feedback_timer = 0

/obj/machinery/mech_sensor/proc/enabled()
	return on && !ispowered()

/obj/machinery/mech_sensor/on_update_icon(var/safety = 0)
	if (enabled())
		icon_state = "airlock_sensor_standby"
	else
		icon_state = "airlock_sensor_off"

/obj/machinery/mech_sensor/OnSignal(datum/signal/signal)
	if(!..())
		return
	if(signal.data["command"] == "enable")
		on = TRUE
	else if (signal.data["command"] == "disable")
		on = FALSE
	update_icon()
