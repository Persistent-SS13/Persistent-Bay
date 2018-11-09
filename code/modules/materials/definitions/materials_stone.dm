/material/diamond
	name = "diamond"
	stack_type = /obj/item/stack/material/diamond
	flags = MATERIAL_UNMELTABLE
	cut_delay = 60
	icon_colour = "#00ffe1"
	icon_door = "metal"
	icon_table = "metal"
	opacity = 0.4
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = 100
	brute_armor = 10
	burn_armor = 50		// Diamond walls are immune to fire, therefore it makes sense for them to be almost undamageable by burn damage type.
	stack_origin_tech = list(TECH_MATERIAL = 6)
	conductive = 0
	ore_name = "diamond"
	ore_compresses_to = "diamond"
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_scan_icon = "mineral_rare"
	xarch_source_mineral = "nitrogen"
	ore_icon_overlay = "gems"

/material/diamond/crystal
	name = "crystal"
	hardness = 80
	stack_type = null
	ore_compresses_to = null

/material/stone
	name = "sandstone"
	stack_type = /obj/item/stack/material/sandstone
	icon_colour = "#d9c179"
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_door = "stone"
	shard_type = SHARD_STONE_PIECE
	weight = 22
	hardness = 55
	brute_armor = 3
	icon_door = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	conductive = 0
	chem_products = list(
		/datum/reagent/silicon = 20
		)

/material/stone/marble
	name = "marble"
	icon_colour = "#aaaaaa"
	weight = 26
	hardness = 60
	brute_armor = 3
	integrity = 201 //hack to stop kitchen benches being flippable, todo: refactor into weight system
	stack_type = /obj/item/stack/material/marble
	chem_products = null
