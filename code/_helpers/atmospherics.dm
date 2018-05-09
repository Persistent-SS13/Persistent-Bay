/obj/proc/analyze_gases(var/obj/A, var/mob/user, advanced)
	user.visible_message("<span class='notice'>\The [user] has used \an [src] on \the [A].</span>")
	A.add_fingerprint(user)

	var/air_contents

	if(istype(A, /obj/machinery/atmospherics))
		var/obj/machinery/atmospherics/machine = A
		air_contents = machine.atmos_scan()
	else
		air_contents = A.return_air()
	if(!air_contents)
		to_chat(user, "<span class='warning'>Your [src] flashes a red light as it fails to analyze \the [A].</span>")
		return 0

	var/list/result = atmosanalyzer_scan(A, air_contents, advanced)
	print_atmos_analysis(user, result)
	return 1

/proc/print_atmos_analysis(user, var/list/result)
	for(var/line in result)
		to_chat(user, "<span class='notice'>[line]</span>")

/proc/atmosanalyzer_scan(var/atom/target, mixture, advanced)
	. = list()
	. += "<span class='notice'>Results of the analysis of \the [target]:</span>"
	if(!mixture)
		mixture = target.return_air()
	var/list/gasmixtures = islist(mixture) ? mixture : list(mixture) //check if there is more than one mixture,
	for(var/gm in gasmixtures)

		if(gasmixtures.len > 1)
			. += "<span class='notce'><b>Node [gasmixtures.Find(gm)]</b></span>"
		var/datum/gas_mixture/gas_contents = gm

		var/pressure = gas_contents.return_pressure()
		var/total_moles = gas_contents.get_total_moles()

		if (total_moles>0)

			if(abs(pressure - ONE_ATMOSPHERE) < 10) //is the pressure dangerous?
				. += "<span class='notice'>Pressure: [round(pressure,0.1)] kPa</span>"
			else
				. += "<span class='warning'>Pressure: [round(pressure,0.1)] kPa</span>"

			for(var/mix in gas_contents.gas)
				var/moles = round(gas_contents.gas[mix], advanced ? 0.001 : 0.1)
				var/percentage = round(gas_contents.gas[mix]/total_moles * 100, advanced ? 0.01 : 1)
				if(!percentage)
					continue
				. += "<span class='notice'>[gas_data.name[mix]]: [percentage]% ([moles] mols)</span>"
				if(advanced)
					var/list/traits = list()
					if(gas_data.flags[mix] & XGM_GAS_FUEL)
						traits += "can be used as combustion fuel"
					if(gas_data.flags[mix] & XGM_GAS_OXIDIZER)
						traits += "can be used as oxidizer"
					if(gas_data.flags[mix] & XGM_GAS_CONTAMINANT)
						traits += "contaminates clothing with toxic residue"
					if(gas_data.flags[mix] & XGM_GAS_FUSION_FUEL)
						traits += "can be used to fuel fusion reaction"
					. += "\t<span class='notice'>Specific heat: [gas_data.specific_heat[mix]] J/(mol*K), Molar mass: [gas_data.molar_mass[mix]] kg/mol.[traits.len ? "\n\tThis gas [english_list(traits)]" : ""]</span>"
			. += "<span class='notice'>Temperature: [round(gas_contents.temperature-T0C)]&deg;C / [round(gas_contents.temperature)]K</span>"
		else
			. += "<span class='warning'>This node has no gases.</span>"
