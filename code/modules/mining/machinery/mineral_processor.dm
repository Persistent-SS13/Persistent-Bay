#define ORE_DISABLED 0
#define ORE_SMELT    1
#define ORE_COMPRESS 2
#define ORE_ALLOY    3

/obj/machinery/mineral/processing_unit
	name = "mineral processor"
	icon_state = "furnace"
	console = /obj/machinery/computer/mining
	input_turf =  NORTH
	output_turf = SOUTH
	circuit_type = /obj/item/weapon/circuitboard/mining_processor
	active_power_usage = 2.5 KILOWATTS
	idle_power_usage = 500

	var/sheets_per_tick = 10
	var/list/materials_processing
	var/list/materials_stored
	var/report_all_ores

/obj/machinery/mineral/processing_unit/New()
	..()
	materials_processing = list()
	materials_stored = list()
	ADD_SAVED_VAR(materials_processing)
	ADD_SAVED_VAR(materials_stored)
	ADD_SAVED_VAR(report_all_ores)

/obj/machinery/mineral/processing_unit/Initialize()
	. = ..()

//Now drops its content on destruction as recyclable dust
/obj/machinery/mineral/processing_unit/destroyed(damagetype, user)
	for(var/matname in materials_stored)
		if(materials_stored[matname])
			//var/material/M = SSmaterials.get_material_by_name(matname)
			var/obj/item/stack/material_dust/pile = new(loc, matname)
			//This proc will output any extra dust to new piles automatically
			pile.add_matter_quantity(materials_stored[matname] > 1? materials_stored[matname] - 1 : 1 ) //stacks always start with 1.. so subtract it
	. = ..()

/obj/machinery/mineral/processing_unit/Process()
	if(inoperable() || !isactive())
		return

	//Grab some more ore to process this tick.
	if(input_turf)
		for(var/obj/item/stack/S in input_turf)
			// If we are deleted or are neither dust or ore, continue
			if(QDELETED(S) || (!istype(S, /obj/item/stack/material_dust) && !istype(S, /obj/item/stack/ore) && !istype(S, /obj/item/stack/material)) || !LAZYLEN(S.matter))
				continue

			// Otherwise add the matter in the stack to our stores.
			for(var/materialName in S.matter)
				// if(M) not needed, as matter would be setup incorrectly anyways in that case
				var/material/M = SSmaterials.get_material_by_name(materialName)
				materials_stored[M.name] += S.matter[materialName]
				LAZYASSOC(materials_processing, M.name)

			qdel(S)

	if(output_turf)
		var/list/attempt_to_alloy = list()
		var/max_sheets = sheets_per_tick
		var/result = 0

		for(var/materialName in materials_stored)
			if(materials_stored[materialName] < 1 || materials_processing[materialName] == ORE_DISABLED)
				continue

			if(max_sheets < 1)
				break

			var/material/M = SSmaterials.get_material_by_name(materialName)
			var/ore_mode = materials_processing[materialName]


			if(ore_mode == ORE_ALLOY && SSmaterials.alloy_components[materialName])
				LAZYSET(attempt_to_alloy, materialName, TRUE)
			else if(ore_mode == ORE_COMPRESS)
				result = attempt_compression(M, max_sheets)
			else if(ore_mode == ORE_SMELT)
				result = attempt_smelt(M, max_sheets)

			max_sheets += abs(result)
			while(result < 0)
				new /obj/item/stack/ore(output_turf, MATERIAL_SLAG)
				result++

		// Try to make any available alloys.
		if(LAZYLEN(attempt_to_alloy))

			var/list/making_alloys = list()
			for(var/thing in SSmaterials.alloy_products)
				var/material/M = thing
				var/failed = FALSE
				for(var/otherthing in M.alloy_materials)
					if(!attempt_to_alloy[otherthing] || materials_stored[otherthing] < M.alloy_materials[otherthing])
						failed = TRUE
						break
				if(!failed) making_alloys += M

			for(var/thing in making_alloys)
				if(max_sheets < 1)
					break

				var/material/M = thing
				var/making
				for(var/otherthing in M.alloy_materials)
					var/_make = Floor(materials_stored[otherthing] / M.alloy_materials[otherthing])
					if(isnull(making) || making > _make)
						making = _make
				making = min(max_sheets, making)
				for(var/otherthing in M.alloy_materials)
					materials_stored[otherthing] -= making * M.alloy_materials[otherthing]
				if(making > 0)
					M.place_sheet(output_turf, making)
					use_power_oneoff(active_power_usage)
					break

/obj/machinery/mineral/processing_unit/proc/attempt_smelt(var/material/M, var/max_result)
	var/result = Clamp(Floor(materials_stored[M.name] / M.units_per_sheet), 0, max_result)
	if(!result)
		return 0

	materials_stored[M.name] -= result * M.units_per_sheet

	use_power_oneoff(active_power_usage)

	if(M.ore_smelts_to)
		var/material/N = SSmaterials.get_material_by_name(M.ore_smelts_to)
		N.place_sheet(output_turf, result)
	else
		M.place_sheet(output_turf, result)

	return result

/obj/machinery/mineral/processing_unit/proc/attempt_compression(var/material/M, var/max_result)
	var/result = Clamp(Floor(materials_stored[M.name] / M.units_per_sheet), 0, max_result)
	if(!result)
		return 0
	materials_stored[M.name] -= (result * M.units_per_sheet)

	use_power_oneoff(active_power_usage)

	if(M.ore_compresses_to)
		var/material/N = SSmaterials.get_material_by_name(M.ore_compresses_to)
		N.place_sheet(output_turf, result)
		return result
	else
		return -result

/obj/machinery/mineral/processing_unit/get_console_data()
	. = ..() + "<h1>Mineral Processing</h1>"
	var/result = ""
	for(var/ore in materials_processing)
		if(!materials_stored[ore] && !report_all_ores) continue
		var/material/M = SSmaterials.get_material_by_name(ore)
		var/line = "[capitalize(M.display_name)]</td><td>[Floor(materials_stored[ore] / M.units_per_sheet)] ([materials_stored[ore]]u)"
		var/status_string
		if(materials_processing[ore])
			switch(materials_processing[ore])
				if(ORE_DISABLED)
					status_string = "<font color='red'>not processing</font>"
				if(ORE_SMELT)
					status_string = "<font color='orange'>smelting</font>"
				if(ORE_COMPRESS)
					status_string = "<font color='blue'>compressing</font>"
				if(ORE_ALLOY)
					status_string = "<font color='gray'>alloying</font>"
		else
			status_string = "<font color='red'>not processing</font>"
		result += "<tr><td>[line]</td><td><a href='?src=\ref[src];toggle_smelting=[ore]'>[status_string]</a></td></tr>"
	. += "<table>[result]</table>"
	. += "Currently displaying [report_all_ores ? "all ore types" : "only available ore types"]. <A href='?src=\ref[src];toggle_ores=1'>[report_all_ores ? "Show less." : "Show more."]</a>"
	. += "The ore processor is currently <A href='?src=\ref[src];toggle_power=1'>[(isactive() ? "enabled" : "disabled")].</a>"

/obj/machinery/mineral/processing_unit/Topic(href, href_list)
	if((. = ..()))
		return
	if(href_list["toggle_smelting"])
		var/choice = input("What setting do you wish to use for processing [href_list["toggle_smelting"]]?") as null|anything in list("Smelting","Compressing","Alloying","Nothing")
		if(!choice) return
		switch(choice)
			if("Nothing")     choice = ORE_DISABLED
			if("Smelting")    choice = ORE_SMELT
			if("Compressing") choice = ORE_COMPRESS
			if("Alloying")    choice = ORE_ALLOY
		materials_processing[href_list["toggle_smelting"]] = choice
		. = TRUE
	else if(href_list["toggle_power"])
		if(!isactive())
			turn_active()
		else
			turn_idle()
		. = TRUE
	else if(href_list["toggle_ores"])
		report_all_ores = !report_all_ores
		. = TRUE
	if(. && console)
		console.updateUsrDialog()

#undef ORE_DISABLED
#undef ORE_SMELT
#undef ORE_COMPRESS
#undef ORE_ALLOY
