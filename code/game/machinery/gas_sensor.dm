/*
*/
/obj/machinery/air_sensor
	name 			= "Gas Sensor"
	desc 			= "A machine that constantly broadcast information on the ambient gases. Works via radio signals."
	icon 			= 'icons/obj/machines/gassensor.dmi'
	icon_state 		= "gsensor1"
	anchored 		= FALSE
	density 		= FALSE

	//Radio
	id_tag 			= null
	frequency 		= ATMOS_CONTROL_FREQ
	radio_filter_in = RADIO_ATMOSIA
	radio_filter_out= RADIO_ATMOSIA

	var/time_next_broadcast = 0
	var/on = TRUE
	var/output = 255
	//Flags:
	// 1 for pressure
	// 2 for temperature
	// Output >= 4 includes gas composition
	// 4 for oxygen concentration
	// 8 for phoron concentration
	// 16 for nitrogen concentration
	// 32 for carbon dioxide concentration
	// 64 for hydrogen concentration
	// 128 for reagent gas concentration

	//Buffer list to transmit data on each process call
	var/tmp/list/transmitted_data = list() 

/obj/machinery/air_sensor/mapped
	anchored = TRUE

/obj/machinery/air_sensor/New()
	. = ..()
	ADD_SAVED_VAR(on)
	ADD_SAVED_VAR(output)

/obj/machinery/air_sensor/update_icon()
	icon_state = "gsensor[on]"

/obj/machinery/air_sensor/Process()
	if(!has_transmitter() || !transmitter_ready() || inoperable() || isnull(loc))
		return
	
	if(on && world.time >= time_next_broadcast)
		var/datum/gas_mixture/air_sample = return_air()
		transmitted_data["timestamp"] = world.time
		if(output&1)
			transmitted_data["pressure"] = num2text(round(air_sample.return_pressure(),0.1),)
		if(output&2)
			transmitted_data["temperature"] = round(air_sample.temperature,0.1)

		if(output>4)
			var/total_moles = air_sample.total_moles
			if(total_moles > 0)
				if(output&4)
					transmitted_data[GAS_OXYGEN] = round(air_sample.gas[GAS_OXYGEN], 0.1)
				if(output&8)
					transmitted_data[GAS_PHORON] = round(air_sample.gas[GAS_PHORON], 0.1)
				if(output&16)
					transmitted_data[GAS_NITROGEN] = round(air_sample.gas[GAS_NITROGEN], 0.1)
				if(output&32)
					transmitted_data[GAS_CO2] = round(air_sample.gas[GAS_CO2], 0.1)
				if(output&64)
					transmitted_data[GAS_HYDROGEN] = round(air_sample.gas[GAS_HYDROGEN], 0.1)
				if(output&128)
					var/total_reagent_moles
					for(var/g in air_sample.gas)
						if(gas_data.flags[g] & XGM_GAS_REAGENT_GAS)
							total_reagent_moles += round(air_sample.gas[g], 0.1)
					transmitted_data["reagent"] = total_reagent_moles
			else
				transmitted_data[GAS_PHORON] = 0
				transmitted_data[GAS_OXYGEN] = 0
				transmitted_data[GAS_NITROGEN] = 0
				transmitted_data[GAS_CO2] = 0
				transmitted_data[GAS_HYDROGEN] = 0
				transmitted_data["reagent"] = 0
		transmitted_data["sigtype"]="status"
		transmitted_data["total_moles"] = air_sample.total_moles

		//log_debug("[src]\ref[src] has id_tag '[get_radio_id()]' and '[id_tag]'")
		post_signal(transmitted_data)
		time_next_broadcast = world.time + 1 SECOND
