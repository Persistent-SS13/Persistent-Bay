/turf/simulated/var/surveyed

/obj/item/weapon/mining_scanner
	name = "ore detector"
	desc = "A complex device used to locate ore deep underground."
	icon = 'icons/obj/device.dmi'
	icon_state = "mining1" //GET A BETTER SPRITE. //Done
	item_state = "electronic"	//I don't know what this does, so I will just leave it
	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 150)
	var/survey_data = 0

/obj/item/weapon/mining_scanner/examine(mob/user)
	..()
	to_chat(user,"Tiny indicator shows it holds [survey_data] Good Explorer Points worth of data.")

/obj/item/weapon/mining_scanner/attack_self(mob/user as mob)
	to_chat(user, "You begin sweeping \the [src] about, scanning for metal and gas deposits.")

	if(!do_after(user, 50,src))
		return

	var/list/metals = list(
		"surface minerals" = 0,
		"precious metals" = 0,
		"nuclear fuel" = 0,
		"exotic matter" = 0
		)
	var/list/gases = list(
		"breathable gases" = 0,
		"exotic gases" = 0,
		"gaseous fuel" = 0
		)

	var/new_data = 0
	for(var/turf/simulated/T in range(2, get_turf(user)))

		if(!T.has_resources && !T.has_gas_resources)
			continue

		for(var/metal in T.resources)
			var/ore_type
			var/data_value = 1

			switch(metal)
				if(MATERIAL_SAND, MATERIAL_GRAPHITE, MATERIAL_HEMATITE, MATERIAL_TETRAHEDRITE, MATERIAL_ROCK_SALT, MATERIAL_PYRITE, MATERIAL_GALENA, MATERIAL_QUARTZ)
					ore_type = "surface minerals"
				if(MATERIAL_GOLD, MATERIAL_SILVER, MATERIAL_DIAMOND, MATERIAL_PLATINUM, MATERIAL_TUNGSTEN)
					ore_type = "precious metals"
					data_value = 2
				if(MATERIAL_PITCHBLENDE)
					ore_type = "nuclear fuel"
					data_value = 3
				if(MATERIAL_PHORON, MATERIAL_HYDROGEN)
					ore_type = "exotic matter"
					data_value = 4

			if(ore_type) metals[ore_type] += T.resources[metal]

			if(!T.surveyed)
				new_data += data_value * T.resources[metal]

		for(var/gas in T.gas_resources)
			var/gas_type
			var/data_value = 1

			switch(gas)
				if("oxygen", "nitrogen", "sleeping_agent", "carbon_dioxide")
					gas_type = "breathable gases"
				if("hydrogen", "deuterium", "tritium", "helium")
					gas_type = "gaseous fuels"
					data_value = 2
				if("phoron")
					gas_type = "exotic gases"
					data_value = 4

			if(gas_type) gases[gas_type] += T.gas_resources[gas]

			if(!T.surveyed)
				new_data += data_value * T.gas_resources[gas]

		T.surveyed = 1

	to_chat(user, "\icon[src] <span class='notice'>The scanner beeps and displays a readout.</span>")

	for(var/ore_type in metals)
		var/result = "no sign"

		switch(metals[ore_type])
			if(1 to 25) result = "trace amounts"
			if(26 to 75) result = "significant amounts"
			if(76 to INFINITY) result = "huge quantities"


		to_chat(user, "- [result] of [ore_type].")

	for(var/gas_type in gases)
		var/result = "no sign"

		switch(gases[gas_type])
			if(1 to 25) result = "trace amounts"
			if(26 to 75) result = "significant amounts"
			if(76 to INFINITY) result = "huge quantities"

		to_chat(user, "- [result] of [gas_type].")


/obj/item/weapon/disk/survey
	name = "survey data disk"
	icon = 'icons/obj/items.dmi'
	icon_state = "nucleardisk"
	var/data

/obj/item/weapon/disk/survey/examine(mob/user)
	..()
	to_chat(user,"Tiny indicator shows it holds [data] Good Explorer Points of data.")

/obj/item/weapon/disk/survey/Value()
	if(data < 10000)
		return 0.07*data
	if(data < 30000)
		return 0.1*data
	return 0.15*data
