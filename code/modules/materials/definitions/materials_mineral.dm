/material/pitchblende
	name = MATERIAL_PITCHBLENDE
	ore_compresses_to = MATERIAL_PITCHBLENDE
	icon_colour = "#917d1a"
	ore_smelts_to = MATERIAL_URANIUM
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = MATERIAL_PITCHBLENDE
	ore_scan_icon = "mineral_uncommon"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	xarch_ages = list(
		"thousand" = 999,
		"million" = 704
		)
	xarch_source_mineral = "potassium"
	ore_icon_overlay = "nugget"
	chem_products = list(
		/datum/reagent/radium = 20,
		/datum/reagent/uranium = 40
		)
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	sale_price = 2
	ore_matter = list(MATERIAL_URANIUM = 2000)

/material/graphite
	name = MATERIAL_GRAPHITE //Aka carbon
	ignition_point= T0C + 700
	melting_point = T0C + 3500
	ore_compresses_to = MATERIAL_GRAPHITE
	stack_type = /obj/item/stack/material/carbon
	icon_colour = "#444444"
	ore_name = MATERIAL_GRAPHITE
	ore_smelts_to = MATERIAL_PLASTIC //Polyethylene(aka common plastic) is C2H4 not just carbon..
	ore_result_amount = 5
	ore_spread_chance = 25
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	chem_products = list(
		/datum/reagent/carbon = 40
		)
	sale_price = 1
	ore_matter = list(MATERIAL_GRAPHITE = 2000)
	energy_combustion = 32.7

/material/graphene
	name = MATERIAL_GRAPHENE //Aka carbon
	ignition_point= T0C + 700
	melting_point = T0C + 3500
	stack_type = /obj/item/stack/material/carbon
	icon_colour = "#141414"
	chem_products = list(
		/datum/reagent/carbon = 10,
		/datum/reagent/acetone = 10
		)
	sale_price = 1
	ore_matter = list(MATERIAL_GRAPHITE = 2000)
	energy_combustion = 32.7

/material/quartz
	name = MATERIAL_QUARTZ
	ore_compresses_to = MATERIAL_QUARTZ
	ore_name = MATERIAL_QUARTZ
	opacity = 0.5
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#effffe"
	chem_products = list(
		/datum/reagent/silicon = 20
		)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	ore_matter = list(MATERIAL_QUARTZ = 2000)
	sale_price = 2

/material/pyrite
	name = MATERIAL_PYRITE
	ore_name = MATERIAL_PYRITE
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#ccc9a3"
	chem_products = list(
		/datum/reagent/sulfur = 20,
		/datum/reagent/iron = 10,
		)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	ore_compresses_to = MATERIAL_SULFUR
	ore_matter = list(MATERIAL_SULFUR = 2000, MATERIAL_IRON = 1000)
	sale_price = 2

/material/sulfur
	name = MATERIAL_SULFUR
	icon_colour = "#edff21"
	flags = MATERIAL_BRITTLE
	conductive = 0
	hardness = 1
	weight = 10
	integrity = 5
	ignition_point= T0C + 232
	melting_point = T0C + 115
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	ore_name = "native " + MATERIAL_SULFUR
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	chem_products = list(
		/datum/reagent/sulfur = 20,
		)
	ore_compresses_to = MATERIAL_SULFUR
	ore_matter = list(MATERIAL_SULFUR = 2000)
	energy_combustion = 9.23

/material/spodumene
	name = MATERIAL_SPODUMENE //LiAl(SiO3)2
	ore_compresses_to = MATERIAL_SPODUMENE
	ore_name = MATERIAL_SPODUMENE
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#e5becb"
	chem_products = list(
		/datum/reagent/lithium = 20,
		/datum/reagent/silicon = 40,
		/datum/reagent/aluminum = 20,
		)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	ore_matter = list(MATERIAL_SPODUMENE = 2000, MATERIAL_ALUMINIUM = 500)
	energy_combustion = 43.1
	sale_price = 2

/material/cinnabar
	name = MATERIAL_CINNABAR
	ore_compresses_to = MATERIAL_CINNABAR
	ore_name = MATERIAL_CINNABAR
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#e54e4e"
	chem_products = list(
		/datum/reagent/mercury  = 20,
		/datum/reagent/toxin/bromide = 5, //Shouldn't be in cinnabar, but whatever
	)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	ore_matter = list(MATERIAL_CINNABAR = 2000)
	sale_price = 2

/material/phosphorite
	name = MATERIAL_PHOSPHORITE
	ore_compresses_to = MATERIAL_PHOSPHORITE
	ore_name = MATERIAL_PHOSPHORITE
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#acad95"
	chem_products = list(
		/datum/reagent/phosphorus = 20
	)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	ore_matter = list(MATERIAL_PHOSPHORITE = 2000)
	sale_price = 2

/material/rocksalt
	name = MATERIAL_ROCK_SALT
	stack_type = /obj/item/stack/material/salt
	ore_compresses_to = MATERIAL_ROCK_SALT
	ore_name = MATERIAL_ROCK_SALT
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#d1c0bc"
	chem_products = list(
		/datum/reagent/sodium = 20
	)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	ore_matter = list(MATERIAL_ROCK_SALT = 2000)
	energy_combustion = 9.23
	sale_price = 2

/material/potash
	name = MATERIAL_POTASH
	ore_compresses_to = MATERIAL_POTASH
	ore_name = MATERIAL_POTASH
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#b77464"
	chem_products = list(
		/datum/reagent/potassium = 20
		)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	ore_matter = list(MATERIAL_POTASH = 2000)
	sale_price = 2

/material/bauxite
	name = MATERIAL_BAUXITE
	ore_name = MATERIAL_BAUXITE
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#d8ad97"
	chem_products = list(
		/datum/reagent/aluminum = 20
		)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	door_icon_base = "stone"
	ore_compresses_to = MATERIAL_BAUXITE
	ore_smelts_to = MATERIAL_ALUMINIUM
	ore_matter = list(MATERIAL_BAUXITE = 2000)
	energy_combustion = 31
	sale_price = 1

/material/sand
	name = MATERIAL_SAND
	stack_type = null
	icon_colour = "#e2dbb5"
	ore_smelts_to = MATERIAL_GLASS
	ore_compresses_to = MATERIAL_SANDSTONE
	ore_name = MATERIAL_SAND
	ore_icon_overlay = "dust"
	chem_products = list(
		/datum/reagent/silicon = 20
		)
	ore_matter = list(MATERIAL_SAND = 2000)

/material/phoron
	name = MATERIAL_PHORON
	stack_type = /obj/item/stack/material/phoron
	ignition_point = PHORON_MINIMUM_BURN_TEMPERATURE
	icon_base = "stone"
	table_icon_base = "stone"
	icon_colour = "#e37108"
	shard_type = SHARD_SHARD
	hardness = 30
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_PHORON = 2)
	door_icon_base = "stone"
	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"
	is_fusion_fuel = 1
	chem_products = list(
		/datum/reagent/toxin/phoron = 20
		)
	construction_difficulty = 2
	ore_name = MATERIAL_PHORON
	ore_compresses_to = MATERIAL_PHORON
	ore_result_amount = 5
	ore_spread_chance = 25
	ore_scan_icon = "mineral_uncommon"
	xarch_ages = list(
		"thousand" = 999,
		"million" = 999,
		"billion" = 13,
		"billion_lower" = 10
		)
	xarch_source_mineral = MATERIAL_PHORON
	ore_icon_overlay = "gems"
	sale_price = 5
	ore_matter = list(MATERIAL_PHORON = 2000)
	energy_combustion = 150

/material/phoron/supermatter
	name = MATERIAL_SUPERMATTER
	lore_text = "Hypercrystalline supermatter is a subset of non-baryonic 'exotic' matter. It is found mostly in the heart of large stars, and features heavily in bluespace technology."
	icon_colour = "#ffff00"
	radioactivity = 20
	stack_origin_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 6, TECH_PHORON = 4)
	stack_type = null
	luminescence = 3
	ore_compresses_to = null
	sale_price = null

//Controls phoron and phoron based objects reaction to being in a turf over 200c -- Phoron's flashpoint.
/material/phoron/combustion_effect(var/turf/T, var/temperature, var/effect_multiplier)
	if(isnull(ignition_point))
		return 0
	if(temperature < ignition_point)
		return 0
	var/totalPhoron = 0
	for(var/turf/simulated/floor/target_tile in range(2,T))
		var/phoronToDeduce = (temperature/30) * effect_multiplier
		totalPhoron += phoronToDeduce
		target_tile.assume_gas(GAS_PHORON, phoronToDeduce, 200+T0C)
		spawn (0)
			target_tile.hotspot_expose(temperature, 400)
	return round(totalPhoron/100)
