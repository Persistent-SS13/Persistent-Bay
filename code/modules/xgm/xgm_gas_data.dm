/var/datum/xgm_gas_data/gas_data

/datum/xgm_gas_data
	//Simple list of all the gas IDs.
	var/list/gases = list()
	//The friendly, human-readable name for the gas.
	var/list/name = list()
	//Specific heat of the gas.  Used for calculating heat capacity.
	var/list/specific_heat = list()
	//Molar mass of the gas.  Used for calculating specific entropy.
	var/list/molar_mass = list()
	//Tile overlays.  /images, created from references to 'icons/effects/tile_effects.dmi'
	var/list/tile_overlay = list()
	//Overlay limits.  There must be at least this many moles for the overlay to appear.
	var/list/overlay_limit = list()
	//Flags.
	var/list/flags = list()
	//Products created when burned. For fuel only for now (not oxidizers)
	var/list/burn_product = list()
	//Reagent created when inhaled by lungs.
	var/breathed_product = list()
	//Ratio of the reagents that one mole of the gas is (molecularly) made of.
	var/list/component_reagents = list()

	var/list/base_boil_point = list() //stores all the gas and reagent's boiling point
	var/list/base_fusion_point = list() //stores all the gas and reagent's fusion (aka melting) point values
	var/list/generated_from_reagent = list() //consists of TRUE or FALSE values. gas_data.generated_from_reagent[gas/reagent] = 1 if the gas/reagent was generated from the reagent datums
	var/list/reagent_typeToId = list() // Contains a list of reagent types with the attributed value of their gas id
	var/list/reagent_idToType = list() // Contains a list of reagent gas id's with the attributed value of their respective reagent type (/datum/reagent/...)

	var/list/dense_product = list() //contains a list of gases associated to their condensation reagent type
	// IMPORTANT!
	// - All reagent gases have their dense product set to their respective reagent types automatically
	// - Any xgm Gas that doesn't have their dense product set will use their component reagent, by default,
	// ONLY if they have ONE, AND ONLY ONE, NOTHING LESS NOR MORE THAN ONE, component_reagents.
	// - Any gas that doesn't have a dense product won't be stored on the list for obvious reasons.

/decl/xgm_gas
	var/id = ""
	var/name = "Unnamed Gas"
	var/specific_heat = 20	// J/(mol*K)
	var/molar_mass = 0.032	// kg/mol

	var/tile_overlay = null
	var/overlay_limit = null

	var/flags = 0
	var/burn_product = "carbon_dioxide"
	var/breathed_product
	var/list/component_reagents

	var/base_boil_point = 100 //value in K (kelvins) until we don't define a boiling point specifically for each gas/reagent
	var/base_fusion_point = 10
	var/generated_from_reagent = 0 //possibly never used!
	var/dense_product

/hook/startup/proc/generateGasData()
	gas_data = new
	for(var/p in (typesof(/decl/xgm_gas) - /decl/xgm_gas))
		var/decl/xgm_gas/gas = new p //avoid initial() because of potential New() actions

		if(gas.id in gas_data.gases)
			error("Duplicate gas id `[gas.id]` in `[p]`")

		gas_data.gases += gas.id
		gas_data.name[gas.id] = gas.name
		gas_data.specific_heat[gas.id] = gas.specific_heat
		gas_data.molar_mass[gas.id] = gas.molar_mass
		if(gas.tile_overlay)
			var/image/I = image('icons/effects/tile_effects.dmi', gas.tile_overlay, FLY_LAYER)
			I.appearance_flags = RESET_COLOR
			gas_data.tile_overlay[gas.id] = I
		if(gas.overlay_limit) gas_data.overlay_limit[gas.id] = gas.overlay_limit
		gas_data.flags[gas.id] = gas.flags
		gas_data.burn_product[gas.id] = gas.burn_product
		gas_data.breathed_product[gas.id] = gas.breathed_product
		gas_data.component_reagents[gas.id] = gas.component_reagents

		gas_data.base_boil_point[gas.id] = gas.base_boil_point
		gas_data.base_fusion_point[gas.id] = gas.base_fusion_point
		gas_data.generated_from_reagent[gas.id] = 0

		gas_data.reagent_typeToId[p] =			gas.id
		gas_data.reagent_idToType[gas.id] =		p

		if (gas.dense_product)
			gas_data.dense_product[gas.id] = gas.dense_product
		else if (!gas.dense_product)
			if (gas.component_reagents && gas.component_reagents.len == 1)
				for(var/comp in gas.component_reagents)
					gas_data.dense_product[gas.id] = comp

	//Reagent gases
	for(var/r in (typesof(/datum/reagent) - /datum/reagent))
		var/datum/reagent/reagent = new r

		var/gas_id = lowertext(reagent.name)
		if(gas_id in gas_data.gases) //Prevents the creation of reagent gases that already exist IE: Phoron
			continue
		gas_data.gases +=                     gas_id					//Default values for reagent gases can be found in Chemistry-Reagents.dm
		gas_data.name[gas_id] =               reagent.name
		gas_data.specific_heat[gas_id] =      reagent.gas_specific_heat
		gas_data.molar_mass[gas_id] =         reagent.gas_molar_mass
		gas_data.overlay_limit[gas_id] =      reagent.gas_overlay_limit
		gas_data.flags[gas_id] =              reagent.gas_flags
		gas_data.burn_product[gas_id] =       reagent.gas_burn_product
		gas_data.breathed_product[gas_id] =   reagent.type
		gas_data.component_reagents[gas_id] = list(reagent.type = 1)

		gas_data.base_boil_point[gas_id] =    reagent.base_boil_point
		gas_data.base_fusion_point[gas_id] =    reagent.base_fusion_point
		gas_data.generated_from_reagent[gas_id] = 1

		gas_data.reagent_typeToId[r] =			gas_id
		gas_data.reagent_idToType[gas_id] =		r
		if(reagent.gas_overlay)
			var/image/I = image('icons/effects/tile_effects.dmi', reagent.gas_overlay, FLY_LAYER)
			I.appearance_flags = RESET_COLOR
			I.color = initial(reagent.color)
			gas_data.tile_overlay[gas_id] = I

		gas_data.dense_product[gas_id] = r

		qdel(reagent)

	return 1
