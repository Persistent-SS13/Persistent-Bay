/obj/item/frame/airlock_controller_norad // The frame (controller)
	name = "Airlock Controller"
	desc = "Used for building airlock controllers."
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_control_off"
	refund_amt = 2
	build_machine_type = /obj/machinery/airlock_controller_norad
	matter = list(DEFAULT_WALL_MATERIAL = 150,"glass" = 150)

/obj/item/frame/airlock_sensor_norad // The frame (sensor)
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_sensor_off"
	name = "airlock sensor"
	refund_amt = 2
	build_machine_type = /obj/machinery/airlock_sensor_norad
	matter = list(DEFAULT_WALL_MATERIAL = 50,"glass" = 50)
