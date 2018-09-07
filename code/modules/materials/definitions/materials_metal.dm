/material/uranium
	name = "uranium"
	stack_type = /obj/item/stack/material/uranium
	radioactivity = 12
	icon_base = "stone"
	door_icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#007a00"
	weight = 22
	stack_origin_tech = list(TECH_MATERIAL = 5)
	chem_products = list(
				/datum/reagent/uranium = 20
				)

/material/gold
	name = "gold"
	stack_type = /obj/item/stack/material/gold
	icon_colour = "#ffcc33"
	weight = 25
	hardness = 25
	integrity = 100
	stack_origin_tech = list(TECH_MATERIAL = 4)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	chem_products = list(
				/datum/reagent/gold = 20
				)
	ore_smelts_to = "gold"
	ore_result_amount = 5
	ore_name = "native gold"
	ore_spread_chance = 10
	ore_scan_icon = "mineral_uncommon"
	xarch_ages = list(
		"thousand" = 999,
		"million" = 999,
		"billion" = 4,
		"billion_lower" = 3
		)
	ore_icon_overlay = "nugget"

/material/gold/bronze //placeholder for ashtrays
	name = "bronze"
	icon_colour = "#edd12f"
	ore_smelts_to = null
	ore_compresses_to = null

/material/copper
	name = "copper"
	icon_colour = "#b87333"
	weight = 15
	hardness = 30
	stack_origin_tech = list(TECH_MATERIAL = 2)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	chem_products = list(
		/datum/reagent/copper = 12,
		/datum/reagent/silver = 8
		)
	ore_smelts_to = "copper"
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = "tetrahedrite"
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "shiny"

/material/silver
	name = "silver"
	stack_type = /obj/item/stack/material/silver
	icon_colour = "#d1e6e3"
	weight = 22
	hardness = 50
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	chem_products = list(
				/datum/reagent/silver = 20
				)
	ore_smelts_to = "silver"
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = "native silver"
	ore_scan_icon = "mineral_uncommon"
	ore_icon_overlay = "shiny"

/material/steel
	name = DEFAULT_WALL_MATERIAL
	stack_type = /obj/item/stack/material/steel
	integrity = 150
	brute_armor = 5
	icon_colour = "#666666"
	hitsound = 'sound/weapons/smash.ogg'
	chem_products = list(
				/datum/reagent/iron = 15,
				/datum/reagent/carbon = 5
				)
	alloy_materials = list("hematite" = 1875, "graphene" = 1875)
	alloy_product = TRUE
	ore_smelts_to = "steel"

/material/steel/holographic
	name = "holo" + DEFAULT_WALL_MATERIAL
	display_name = DEFAULT_WALL_MATERIAL
	stack_type = null
	shard_type = SHARD_NONE
	conductive = 0
	alloy_materials = null
	alloy_product = FALSE

/material/plasteel
	name = "plasteel"
	stack_type = /obj/item/stack/material/plasteel
	integrity = 400
	melting_point = 6000
	icon_colour = "#777777"
	explosion_resistance = 25
	brute_armor = 6
	burn_armor = 10
	hardness = 80
	weight = 23
	stack_origin_tech = list(TECH_MATERIAL = 2)
	hitsound = 'sound/weapons/smash.ogg'
	alloy_materials = list("steel" = 2500, "platinum" = 1250)
	alloy_product = TRUE
	ore_smelts_to = "plasteel"

/material/plasteel/titanium
	name = "titanium"
	brute_armor = 10
	burn_armor = 8
	integrity = 200
	melting_point = 3000
	weight = 18
	stack_type = null
	icon_base = "metal"
	door_icon_base = "metal"
	icon_colour = "#d1e6e3"
	alloy_materials = null
	alloy_product = FALSE

/material/plasteel/ocp
	name = "osmium-carbide plasteel"
	stack_type = /obj/item/stack/material/ocp
	integrity = 200
	melting_point = 12000
	icon_colour = "#9bc6f2"
	brute_armor = 4
	burn_armor = 20
	weight = 27
	stack_origin_tech = list(TECH_MATERIAL = 3)
	alloy_materials = list("plasteel" = 7500, "osmium" = 3750)
	alloy_product = TRUE

/material/osmium
	name = "osmium"
	stack_type = /obj/item/stack/material/osmium
	icon_colour = "#9999ff"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	ore_smelts_to = "osmium"

/material/tritium
	name = "tritium"
	stack_type = /obj/item/stack/material/tritium
	icon_colour = "#777777"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = 1

/material/deuterium
	name = "deuterium"
	stack_type = /obj/item/stack/material/deuterium
	icon_colour = "#999999"
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = 1

/material/mhydrogen
	name = "mhydrogen"
	display_name = "metallic hydrogen"
	stack_type = /obj/item/stack/material/mhydrogen
	icon_colour = "#e6c5de"
	stack_origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 6, TECH_MAGNET = 5)
	is_fusion_fuel = 1
	chem_products = list(
				/datum/reagent/hydrazine = 20
				)
	ore_smelts_to = "tritium"
	ore_compresses_to = "mhydrogen"
	ore_name = "raw hydrogen"
	ore_scan_icon = "mineral_rare"
	ore_icon_overlay = "gems"

/material/platinum
	name = "platinum"
	stack_type = /obj/item/stack/material/platinum
	icon_colour = "#9999ff"
	weight = 27
	stack_origin_tech = list(TECH_MATERIAL = 2)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	ore_smelts_to = "platinum"
	ore_compresses_to = "osmium"
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = "raw platinum"
	ore_scan_icon = "mineral_rare"
	ore_icon_overlay = "shiny"

/material/iron
	name = "iron"
	stack_type = /obj/item/stack/material/iron
	icon_reinf = "jaggy"
	icon_colour = "#5c5454"
	weight = 22
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	hitsound = 'sound/weapons/smash.ogg'
	chem_products = list(
				/datum/reagent/iron = 20
				)

// Adminspawn only, do not let anyone get this.
/material/voxalloy
	name = "voxalloy"
	display_name = "durable alloy"
	stack_type = null
	icon_colour = "#6c7364"
	integrity = 1200
	melting_point = 6000       // Hull plating.
	explosion_resistance = 200 // Hull plating.
	hardness = 500
	weight = 500

// Likewise.
/material/voxalloy/elevatorium
	name = "elevatorium"
	display_name = "elevator panelling"
	icon_colour = "#666666"

/material/hematite
	name = "hematite"
	stack_type = null
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#aa6666"
	ore_smelts_to = "iron"
	ore_result_amount = 5
	ore_spread_chance = 25
	ore_scan_icon = "mineral_common"
	ore_name = "hematite"
	ore_icon_overlay = "lump"

/material/tungsten
	name = "tungsten"
	stack_type = /obj/item/stack/material/tungsten
	integrity = 250 // Tungsten ain't no bitch
	melting_point = 16000
	icon_colour = "#8888aa"
	weight = 32 // Tungsten B-Ball bats OP AF
	stack_origin_tech = list(TECH_MATERIAL = 4)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	chem_products = list(
				/datum/reagent/tungsten = 20
				)

	ore_smelts_to = "tungsten"
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = "tungsten"
	ore_scan_icon = "mineral_uncommon"
	ore_icon_overlay = "shiny"