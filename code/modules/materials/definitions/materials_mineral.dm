/material/pitchblende
	name = "pitchblende"
	ore_compresses_to = "pitchblende"
	icon_colour = "#917d1a"
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	ore_smelts_to = "uranium"
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = "pitchblende"
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
	ore_matter = list("uranium" = 2000)

/material/graphite
	name = "graphite" //Aka carbon
	ore_compresses_to = "graphite"
	icon_colour = "#444444"
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	ore_name = "graphite"
	ore_smelts_to = "plastic" //Polyethylene(aka common plastic) is C2H4 not just carbon..
	ore_result_amount = 5
	ore_spread_chance = 25
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	chem_products = list(
		/datum/reagent/carbon = 40
		)
	ore_matter = list("graphite" = 2000)

//DELETEME: Once transition is done
/material/graphite/graphene //So old graphene ore is still usable
	name = "graphene"
	ore_compresses_to = "graphene"
	ore_name = "graphene"

/material/quartz
	name = "quartz"
	ore_compresses_to = "quartz"
	ore_name = "quartz"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#effffe"
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_door = "stone"
	icon_table = "stone"
	chem_products = list(
		/datum/reagent/silicon = 20
		)
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	ore_matter = list("quartz" = 2000)


/material/pyrite
	name = "pyrite"
	ore_name = "pyrite"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#ccc9a3"
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_door = "stone"
	chem_products = list(
		/datum/reagent/sulfur = 10,
		/datum/reagent/iron = 35
		)
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	ore_compresses_to = "pyrite"
	ore_matter = list("pyrite" = 2000)

/material/spodumene
	name = "spodumene"
	ore_compresses_to = "spodumene"
	ore_name = "spodumene"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#e5becb"
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_door = "stone"
	chem_products = list(
		/datum/reagent/lithium = 20
		)
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	ore_matter = list("spodumene" = 2000)


/material/cinnabar
	name = "cinnabar"
	ore_compresses_to = "cinnabar"
	ore_name = "cinnabar"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#e54e4e"
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_door = "stone"
	chem_products = list(
		/datum/reagent/mercury  = 20
	)
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	ore_matter = list("cinnabar" = 2000)

/material/phosphorite
	name = "phosphorite"
	ore_compresses_to = "phosphorite"
	ore_name = "phosphorite"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#acad95"
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_door = "stone"
	chem_products = list(
		/datum/reagent/phosphorus = 20
	)
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	ore_matter = list("phosphorite" = 2000)

/material/rocksalt
	name = "rock salt"
	ore_compresses_to = "rock salt"
	ore_name = "rock salt"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#d1c0bc"
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_door = "stone"
	chem_products = list(
		/datum/reagent/sodium = 20
	)
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	ore_matter = list("rocksalt" = 2000)


/material/potash
	name = "potash"
	ore_compresses_to = "potash"
	ore_name = "potash"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#b77464"
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_door = "stone"
	chem_products = list(
		/datum/reagent/potassium = 20
		)
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	ore_matter = list("potash" = 2000)


/material/bauxite
	name = "bauxite"
	ore_name = "bauxite"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#d8ad97"
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_door = "stone"
	chem_products = list(
		/datum/reagent/aluminum = 20
		)
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	ore_compresses_to = "bauxite"
	ore_smelts_to = "aluminum"
	ore_matter = list("bauxite" = 2000)

/material/sand
	name = "sand"
	stack_type = null
	icon_colour = "#e2dbb5"
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	ore_smelts_to = "glass"
	ore_compresses_to = "sandstone"
	ore_name = "sand"
	ore_icon_overlay = "dust"
	chem_products = list(
		/datum/reagent/silicon = 20
		)
	ore_matter = list("sand" = 2000)

/material/phoron
	name = "phoron"
	stack_type = /obj/item/stack/material/phoron
	ignition_point = PHORON_MINIMUM_BURN_TEMPERATURE
	icon_colour = "#e37108"
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	shard_type = SHARD_SHARD
	hardness = 30
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_PHORON = 2)
	icon_door = "stone"
	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"
	is_fusion_fuel = 1
	chem_products = list(
		/datum/reagent/toxin/phoron = 20
		)
	ore_name = "phoron"
	ore_compresses_to = "phoron"
	ore_result_amount = 5
	ore_spread_chance = 25
	ore_scan_icon = "mineral_uncommon"
	xarch_ages = list(
		"thousand" = 999,
		"million" = 999,
		"billion" = 13,
		"billion_lower" = 10
		)
	xarch_source_mineral = "phoron"
	ore_icon_overlay = "gems"
	ore_matter = list("phoron" = 2000)

/material/phoron/supermatter
	name = "supermatter"
	icon_colour = "#ffff00"
	radioactivity = 20
	stack_origin_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 6, TECH_PHORON = 4)
	stack_type = null
	luminescence = 3
	ore_compresses_to = null

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
		target_tile.assume_gas("phoron", phoronToDeduce, 200+T0C)
		spawn (0)
			target_tile.hotspot_expose(temperature, 400)
	return round(totalPhoron/100)
