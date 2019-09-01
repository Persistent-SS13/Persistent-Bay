/obj/machinery/airlock_sensor
	name 			= "airlock sensor"
	icon 			= 'icons/obj/airlock_machines.dmi'
	icon_state 		= "airlock_sensor_off"
	anchored 		= TRUE
	density 		= FALSE
	use_power 		= POWER_USE_IDLE
	idle_power_usage= 2
	power_channel 	= ENVIRON
	id_tag 			= null
	frequency 		= AIRLOCK_FREQ
	range 			= AIRLOCK_CONTROL_RANGE
	radio_filter_in = RADIO_AIRLOCK
	radio_filter_out= RADIO_AIRLOCK
	var/master_tag	= null //Tag for the master airlock controller I assume?
	var/command 	= "cycle"
	var/alert 		= 0
	var/previousPressure

/obj/machinery/airlock_sensor/airlock_interior
	command = "cycle_interior"

/obj/machinery/airlock_sensor/airlock_exterior
	command = "cycle_exterior"

/obj/machinery/airlock_sensor/New()
	..()
	ADD_SAVED_VAR(master_tag)

/obj/machinery/airlock_sensor/Initialize()
	. = ..()
	queue_icon_update()

/obj/machinery/airlock_sensor/update_icon()
	switch(dir)
		if(NORTH)
			src.pixel_x = 0
			src.pixel_y = -24
		if(SOUTH)
			src.pixel_x = 0
			src.pixel_y = 24
		if(EAST)
			src.pixel_x = -24
			src.pixel_y = 0
		if(WEST)
			src.pixel_x = 24
			src.pixel_y = 0
	if(operable() && ison())
		if(alert)
			icon_state = "airlock_sensor_alert"
		else
			icon_state = "airlock_sensor_standby"
	else
		icon_state = "airlock_sensor_off"

/obj/machinery/airlock_sensor/attack_hand(mob/user)
	post_signal(list("command" = command), radio_filter_out, master_tag)
	flick("airlock_sensor_cycle", src)

/obj/machinery/airlock_sensor/Process()
	if(inoperable() || isoff())
		return
	var/datum/gas_mixture/air_sample = return_air()
	if(!air_sample)
		qdel(src)
		return
	var/pressure = round(air_sample.return_pressure(),0.1)
	if(abs(pressure - previousPressure) > 0.001 || previousPressure == null)
		post_signal(list("timestamp" = world.time, "pressure" = num2text(pressure)), radio_filter_out, id_tag)
		previousPressure = pressure
		alert = (pressure < ONE_ATMOSPHERE*0.8)
		update_icon()
