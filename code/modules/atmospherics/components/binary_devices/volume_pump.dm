/obj/machinery/atmospherics/binary/pump/high_power
	name 			= "high power gas pump"
	desc 			= "A pump. Has double the power rating of the standard gas pump."
	icon 			= 'icons/atmos/volume_pump.dmi'
	icon_state 		= "map_off"
	level 			= 1
	power_rating 	= 15000	//15000 W ~ 20 HP
	mass			= 15.0 //kg

/obj/machinery/atmospherics/binary/pump/high_power/on
	use_power 	= POWER_USE_IDLE
	icon_state 	= "map_on"

/obj/machinery/atmospherics/binary/pump/high_power/on_update_icon()
	if(!powered())
		icon_state = "off"
	else
		icon_state = "[use_power ? "on" : "off"]"

// For mapping purposes
/obj/machinery/atmospherics/binary/pump/high_power/on/max_pressure/
	target_pressure = MAX_PUMP_PRESSURE

// A possible variant for Atmospherics distribution feed.
/obj/machinery/atmospherics/binary/pump/high_power/on/distribution/New()
	..()
	if(!target_pressure)
		target_pressure = round(3 * ONE_ATMOSPHERE)
