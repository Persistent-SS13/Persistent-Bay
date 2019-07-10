/material/plastic
	name = MATERIAL_PLASTIC
	lore_text = "A generic polymeric material. Probably the most flexible and useful substance ever created by human science; mostly used to make disposable cutlery."
	stack_type = /obj/item/stack/material/plastic
	flags = MATERIAL_BRITTLE
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = COLOR_WHITE
	hardness = 10
	weight = 5
	melting_point = T0C+371 //assuming heat resistant plastic
	stack_origin_tech = list(TECH_MATERIAL = 3)
	conductive = 0
	construction_difficulty = 1
	chem_products = list(
				/datum/reagent/toxin/plasticide = 20
				)
	sale_price = 1
	energy_combustion = 46.3

/material/plastic/holographic
	name = "holo" + MATERIAL_PLASTIC
	display_name = MATERIAL_PLASTIC
	stack_type = null
	shard_type = SHARD_NONE
	sale_price = null
	hidden_from_codex = TRUE

/material/cardboard
	name = MATERIAL_CARDBOARD
	lore_text = "What with the difficulties presented by growing plants in orbit, a stock of cardboard in space is probably more valuable than gold."
	stack_type = /obj/item/stack/material/cardboard
	flags = MATERIAL_BRITTLE
	integrity = 10
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#aaaaaa"
	hardness = 1
	brute_armor = 1
	weight = 1
	ignition_point = T0C+232 //"the temperature at which book-paper catches fire, and burns." close enough
	melting_point = T0C+232 //temperature at which cardboard walls would be destroyed
	stack_origin_tech = list(TECH_MATERIAL = 1)
	door_icon_base = "wood"
	destruction_desc = "crumples"
	conductive = 0
	energy_combustion = 8

//TODO PLACEHOLDERS:
/material/leather
	name = MATERIAL_LEATHER
	icon_colour = "#5c4831"
	stack_origin_tech = list(TECH_MATERIAL = 2)
	flags = MATERIAL_PADDING
	ignition_point = T0C+300
	melting_point = T0C+300
	conductive = 0
	stack_type = /obj/item/stack/material/leather
	hardness = 1
	weight = 1
	energy_combustion = 8
	hidden_from_codex = TRUE
	construction_difficulty = 1

/material/carpet
	name = MATERIAL_CARPET
	display_name = "red"
	use_name = "red upholstery"
	icon_colour = "#9d2300"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	sheet_singular_name = "tile"
	sheet_plural_name = "tiles"
	conductive = 0
	stack_type = null
	construction_difficulty = 1
	hardness = 1
	weight = 1
	energy_combustion = 8

/material/cotton
	name = MATERIAL_COTTON
	stack_origin_tech = list(TECH_MATERIAL = 2)
	door_icon_base = "wood"
	ignition_point = T0C+232
	melting_point = T0C+300
	flags = MATERIAL_PADDING
	brute_armor = 1
	conductive = 0
	stack_type = /obj/item/stack/material/cotton
	hardness = 1
	weight = 1
	energy_combustion = 8
	hidden_from_codex = TRUE
	construction_difficulty = 1

/material/cloth
	name = MATERIAL_CLOTH
	stack_origin_tech = list(TECH_MATERIAL = 2)
	display_name ="grey"
	use_name = "grey cloth"
	icon_colour = "#ffffff"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	brute_armor = 1
	conductive = 0
	stack_type = null
	hidden_from_codex = TRUE
	construction_difficulty = 1
	hardness = 1
	weight = 1
	energy_combustion = 8
	stack_type = /obj/item/stack/material/cloth

/material/cloth/carpet
	name = "carpet"
	display_name = "red"
	use_name = "red upholstery"
	icon_colour = "#9d2300"
	sheet_singular_name = "tile"
	sheet_plural_name = "tiles"

/material/cloth/yellow
	name = "yellow"
	display_name ="yellow"
	use_name = "yellow cloth"
	icon_colour = "#ffbf00"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	conductive = 0
	stack_type = null
	hardness = 1
	weight = 1

/material/cloth/teal
	name = "teal"
	display_name = "teal"
	use_name = "teal cloth"
	icon_colour = "#00e1ff"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	conductive = 0
	stack_type = null
	hardness = 1
	weight = 1

/material/cloth/black
	name = "black"
	display_name = "black"
	use_name = "black cloth"
	icon_colour = "#505050"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	conductive = 0
	stack_type = null
	hardness = 1
	weight = 1

/material/cloth/green
	name = "green"
	display_name = "green"
	use_name = "green cloth"
	icon_colour = "#b7f27d"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	conductive = 0
	stack_type = null
	hardness = 1
	weight = 1

/material/cloth/puple
	name = "purple"
	display_name = "purple"
	use_name = "purple cloth"
	icon_colour = "#9933ff"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	conductive = 0
	stack_type = null
	hardness = 1
	weight = 1

/material/cloth/blue
	name = "blue"
	display_name = "blue"
	use_name = "blue cloth"
	icon_colour = "#46698c"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	conductive = 0
	stack_type = null
	hardness = 1
	weight = 1

/material/cloth/beige
	name = "beige"
	display_name = "beige"
	use_name = "beige cloth"
	icon_colour = "#ceb689"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	conductive = 0
	stack_type = null
	hardness = 1
	weight = 1

/material/cloth/lime
	name = "lime"
	display_name = "lime"
	use_name = "lime cloth"
	icon_colour = "#62e36c"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	conductive = 0
	stack_type = null
	hardness = 1
	weight = 1

/material/pink_goo
	name = "pinkgoo"
	stack_type = /obj/item/stack/material/edible/pink_goo_slab
	icon_colour = "#ff6a6a"
	icon_base = "solid"
	integrity = 5
	explosion_resistance = 0
	hardness = 1
	brute_armor = 1
	weight = 8
	melting_point = T0C+300
	ignition_point = T0C+288
	stack_origin_tech = list(TECH_BIO = 2)
	sheet_singular_name = "slab"
	sheet_plural_name = "slabs"
	conductive = 0
	//By default don't put much chem products
	chem_products = list(
				/datum/reagent/nutriment = 10,
				/datum/reagent/nutriment/protein = 10,
				/datum/reagent/blood = 10,
				)

	
//Wax sheets, now using the material system, like everything else
/material/wax
	name = MATERIAL_BEESWAX
	sheet_singular_name = "piece"
	sheet_plural_name = "pieces"
	stack_type = /obj/item/stack/material/edible/beeswax
	icon_colour = "#fff343"
	icon_base = "puck"
	integrity = 10
	hardness = 1
	weight = 4
	explosion_resistance = 0
	brute_armor = 0
	conductive = 0
	melting_point = T0C+62
	ignition_point = T0C+204
	chem_products = list(
		/datum/reagent/beeswax = 20,
	)