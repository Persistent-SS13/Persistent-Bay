
/material/glass
	name = MATERIAL_GLASS
	lore_text = "A brittle, transparent material made from molten silicates. It is generally not a liquid."
	stack_type = /obj/item/stack/material/glass
	flags = MATERIAL_BRITTLE
	icon_colour = GLASS_COLOR
	opacity = 0.3
	integrity = 50
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = 50
	melting_point = T0C + 100
	weight = 14
	brute_armor = 1
	burn_armor = 2
	door_icon_base = "stone"
	table_icon_base = "solid"
	destruction_desc = "shatters"
	window_options = list("One Direction" = 1, "Full Window" = 4, "Windoor" = 5)
	hitsound = 'sound/effects/Glasshit.ogg'
	conductive = 0
	sale_price = 1

/material/glass/proc/is_reinforced()
	return (integrity > 75) //todo

/material/glass/is_brittle()
	return ..() && !is_reinforced()

/material/glass/phoron
	name = MATERIAL_PHORON_GLASS
	lore_text = "An extremely heat-resistant form of glass."
	display_name = "borosilicate glass"
	stack_type = /obj/item/stack/material/glass/phoronglass
	flags = MATERIAL_BRITTLE
	integrity = 70
	brute_armor = 2
	burn_armor = 5
	melting_point = T0C + 4000
	icon_colour = GLASS_COLOR_PHORON
	stack_origin_tech = list(TECH_MATERIAL = 4)
	wire_product = null
	construction_difficulty = 2
	alloy_product = TRUE
	alloy_materials = list(MATERIAL_SAND = 2500, MATERIAL_PLATINUM = 1250)
	sale_price = 2

/material/glass/fiberglass
	name = MATERIAL_FIBERGLASS
	display_name = "fiberglass"
	stack_type = /obj/item/stack/material/glass/fiberglass
	flags = null //Fiberglass isn't very brittle
	icon_colour = "#bbbbcc"
	opacity = 0.4
	integrity = 125
	melting_point = T0C + 90 // It's slightly more susceptible to fire than normal glass
	tableslam_noise = 'sound/weapons/tablehit1.ogg'
	hitsound = 'sound/weapons/tablehit1.ogg'
	weight = 10
	brute_armor = 4 // It's very tough against brute damage though
	burn_armor = 1
	shard_type = SHARD_SPLINTER
	stack_origin_tech = list(TECH_MATERIAL = 2)
	destruction_desc = "splinters"
	window_options = list("One Direction" = 1, "Full Window" = 4)
	chem_products = list(
				/datum/reagent/silicon = 20,
				/datum/reagent/toxin/plasticide = 2
				)
