/material/uranium
	name = MATERIAL_URANIUM
	lore_text = "A highly radioactive metal. Commonly used as fuel in fission reactors."
	mechanics_text = "Uranium ingots are used as fuel in some forms of portable generator."
	stack_type = /obj/item/stack/material/uranium
	radioactivity = 12
	icon_base = "stone"
	door_icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#007a00"
	weight = 22
	melting_point = 1405
	stack_origin_tech = list(TECH_MATERIAL = 5)
	chem_products = list(
				/datum/reagent/uranium = 20
				)
	construction_difficulty = 2
	sale_price = 2
	integrity = 50

/material/gold
	name = MATERIAL_GOLD
	lore_text = "A heavy, soft, ductile metal. Once considered valuable enough to back entire currencies, now predominantly used in corrosion-resistant electronics."
	stack_type = /obj/item/stack/material/gold
	icon_colour = "#ffcc33"
	icon_base = "metal"
	icon_reinf = "metal"
	door_icon_base = "metal"
	weight = 25
	hardness = 25
	integrity = 100
	integrity = 35
	melting_point = 1337
	stack_origin_tech = list(TECH_MATERIAL = 4)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	chem_products = list(
				/datum/reagent/gold = 20
				)
	construction_difficulty = 2
	ore_smelts_to = MATERIAL_GOLD
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
	ore_matter = list(MATERIAL_GOLD = 2000)
	sale_price = 3

/material/copper
	name = MATERIAL_COPPER
	stack_type = /obj/item/stack/material/copper
	icon_colour = "#b87333"
	weight = 15
	hardness = 30
	melting_point = 1357
	stack_origin_tech = list(TECH_MATERIAL = 2)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	chem_products = list(
		/datum/reagent/copper = 20,
		)
	construction_difficulty = 2
	sale_price = 1
	integrity = 50

/material/silver
	name = MATERIAL_SILVER
	lore_text = "A soft, white, lustrous transition metal. Has many and varied industrial uses in electronics, solar panels and mirrors."
	stack_type = /obj/item/stack/material/silver
	icon_colour = "#d1e6e3"
	icon_base = "metal"
	icon_reinf = "metal"
	door_icon_base = "metal"
	table_icon_base = "metal"
	weight = 22
	hardness = 50
	melting_point = 1234
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	chem_products = list(
				/datum/reagent/silver = 20
				)
	construction_difficulty = 2
	ore_smelts_to = MATERIAL_SILVER
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = "native silver"
	ore_scan_icon = "mineral_uncommon"
	ore_icon_overlay = "shiny"
	ore_matter = list(MATERIAL_SILVER = 1200)
	sale_price = 2
	integrity = 75

/material/steel/holographic
	name = "holo" + MATERIAL_STEEL
	display_name = MATERIAL_STEEL
	stack_type = null
	shard_type = SHARD_NONE
	conductive = 0
	alloy_materials = null
	alloy_product = FALSE
	sale_price = null
	hidden_from_codex = TRUE

/material/titanium
	name = MATERIAL_TITANIUM
	lore_text = "A light, strong, corrosion-resistant metal. Perfect for cladding high-velocity ballistic supply pods."
	brute_armor = 10
	burn_armor = 8
	integrity = 250
	melting_point = 1941
	weight = 15
	hardness = 75
	stack_type = /obj/item/stack/material/titanium
	icon_colour = "#d1e6e3"
	icon_reinf = "reinf_metal"
	construction_difficulty = 3
	alloy_materials = null
	alloy_product = FALSE
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	ore_smelts_to = MATERIAL_TITANIUM
	ore_name = "raw titanium"
	ore_scan_icon = "mineral_rare"
	ore_icon_overlay = "shiny"

/material/osmium
	name = MATERIAL_OSMIUM
	lore_text = "An extremely dense metal."
	stack_type = /obj/item/stack/material/osmium
	icon_colour = "#9999ff"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	construction_difficulty = 3
	sale_price = 3
	ore_smelts_to = MATERIAL_OSMIUM
	melting_point = 3306
	integrity = 500

/material/tritium
	name = MATERIAL_TRITIUM
	lore_text = "A radioactive isotope of hydrogen. Useful as a fusion reactor fuel material."
	mechanics_text = "Tritium is useable as a fuel in some forms of portable generator. It can also be converted into a fuel rod suitable for a R-UST fusion plant injector by clicking a stack on a fuel compressor. It fuses hotter than deuterium but is correspondingly more unstable."
	stack_type = /obj/item/stack/material/tritium
	icon_colour = "#777777"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = 1
	construction_difficulty = 2
	ore_smelts_to = MATERIAL_TRITIUM
	ore_name = "raw tritium"
	ore_scan_icon = "mineral_rare"
	ore_icon_overlay = "gems"
	melting_point = 14

/material/deuterium
	name = MATERIAL_DEUTERIUM
	lore_text = "One of the two stable isotopes of hydrogen; also known as heavy hydrogen. Useful as a chemically synthesised fusion reactor fuel material."
	mechanics_text = "Deuterium can be converted into a fuel rod suitable for a R-UST fusion plant injector by clicking a stack on a fuel compressor. It is the most 'basic' fusion fuel."
	stack_type = /obj/item/stack/material/deuterium
	icon_colour = "#999999"
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = 1
	construction_difficulty = 2
	ore_smelts_to = MATERIAL_DEUTERIUM
	ore_name = "raw deuterium"
	ore_scan_icon = "mineral_rare"
	ore_icon_overlay = "gems"
	melting_point = 14
	melting_point = 14

/material/mhydrogen
	name = MATERIAL_HYDROGEN
	lore_text = "When hydrogen is exposed to extremely high pressures and temperatures, such as at the core of gas giants like Jupiter, it can take on metallic properties and - more importantly - acts as a room temperature superconductor. Achieving solid metallic hydrogen at room temperature, though, has proven to be rather tricky."
	display_name = "metallic hydrogen"
	stack_type = /obj/item/stack/material/mhydrogen
	icon_colour = "#e6c5de"
	stack_origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 6, TECH_MAGNET = 5)
	is_fusion_fuel = 1
	chem_products = list(
				/datum/reagent/hydrazine = 20
				)
	construction_difficulty = 2
	ore_smelts_to = MATERIAL_TRITIUM
	ore_compresses_to = MATERIAL_HYDROGEN
	ore_name = "raw hydrogen"
	ore_scan_icon = "mineral_rare"
	ore_icon_overlay = "gems"
	sale_price = 5
	melting_point = 14
	energy_combustion = 141.86

/material/platinum
	name = MATERIAL_PLATINUM
	lore_text = "A very dense, unreactive, precious metal. Has many industrial uses, particularly as a catalyst."
	stack_type = /obj/item/stack/material/platinum
	icon_colour = "#deddff"
	weight = 27
	stack_origin_tech = list(TECH_MATERIAL = 2)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	construction_difficulty = 2
	ore_smelts_to = MATERIAL_PLATINUM
	ore_compresses_to = MATERIAL_OSMIUM
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = "raw platinum"
	ore_scan_icon = "mineral_rare"
	ore_icon_overlay = "shiny"
	sale_price = 5
	ore_matter = list(MATERIAL_PLATINUM = 1000)
	melting_point = 2041
	integrity = 80

/material/iron
	name = MATERIAL_IRON
	lore_text = "A ubiquitous, very common metal. The epitaph of stars and the primary ingredient in Earth's core."
	stack_type = /obj/item/stack/material/iron
	icon_reinf = "jaggy"
	icon_colour = "#5c5454"
	weight = 22
	hardness = 15
	melting_point = 1811
	integrity = 110
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	hitsound = 'sound/weapons/smash.ogg'
	construction_difficulty = 1
	chem_products = list(
				/datum/reagent/iron = 20
				)
	sale_price = 1
	energy_combustion = 5.2

/material/tungsten
	name = MATERIAL_TUNGSTEN
	stack_type = /obj/item/stack/material/tungsten
	integrity = 250 // Tungsten ain't no bitch
	melting_point = 16000 //It should actually be 3,695K, not 16,000K.. but whatever
	icon_colour = "#8888aa"
	weight = 32 // Tungsten B-Ball bats OP AF
	stack_origin_tech = list(TECH_MATERIAL = 4)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	ore_smelts_to = MATERIAL_TUNGSTEN
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = MATERIAL_TUNGSTEN
	ore_scan_icon = "mineral_uncommon"
	ore_icon_overlay = "shiny"
	chem_products = list(
				/datum/reagent/tungsten = 20
				)
	ore_matter = list(MATERIAL_TUNGSTEN = 2000)

/material/aluminum
	name = MATERIAL_ALUMINIUM
	stack_type = /obj/item/stack/material/aluminium
	integrity = 125
	melting_point = 933
	icon_colour = "#848789"
	weight = 10
	hardness = 15
	chem_products = list(
				/datum/reagent/aluminum = 20
				)
	energy_combustion = 31

/material/lead
	name = MATERIAL_LEAD
	stack_type = /obj/item/stack/material/lead
	integrity = 80
	melting_point = 600
	icon_colour = "#6d6a65"
	weight = 40
	hardness = 3
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	chem_products = list(/datum/reagent/lead = 20)

/material/tin
	name = MATERIAL_TIN
	stack_type = /obj/item/stack/material/tin
	integrity = 60
	melting_point = 505
	icon_colour = "#d3d4d5"
	weight = 22
	hardness = 10
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/material/zinc //Used in batteries, and for stopping corrosion
	name = MATERIAL_ZINC
	stack_type = /obj/item/stack/material/zinc
	integrity = 50
	melting_point = 692
	icon_colour = "#bac4c8"
	weight = 20
	hardness = 5
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	energy_combustion = 5.3

/material/boron
	name = MATERIAL_BORON
	integrity = 300
	weight = 25
	hardness = 30
	melting_point = 2349 //K
	icon_colour = COLOR_GRAY15
	ore_smelts_to = MATERIAL_BORON
	ore_result_amount = 10
	ore_spread_chance = 15
	ore_name = MATERIAL_BORON
	ore_scan_icon = "mineral_common"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	xarch_ages = list(
		"thousand" = 999,
		"million" = 999,
		"billion" = 13,
		"billion_lower" = 10
		)
	xarch_source_mineral = MATERIAL_BORON
	ore_icon_overlay = "nugget"
	chem_products = list(/datum/reagent/boron = 20)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	sale_price = 2
	ore_matter = list(MATERIAL_BORON = 2000)

//-------------------------------------
//	Alloys
//-------------------------------------
// Adminspawn only, do not let anyone get this.
/material/voxalloy
	name = MATERIAL_VOX
	display_name = "durable alloy"
	stack_type = null
	icon_colour = "#6c7364"
	integrity = 1200
	melting_point = 6000       // Hull plating.
	explosion_resistance = 200 // Hull plating.
	hardness = 500
	weight = 500
	construction_difficulty = 2
	hidden_from_codex = TRUE

// Likewise.
/material/voxalloy/elevatorium
	name = MATERIAL_ELEVATORIUM
	display_name = "elevator panelling"
	icon_colour = "#666666"
	construction_difficulty = 2
	hidden_from_codex = TRUE
	icon_base = "metal"
	icon_reinf = "metal"

/material/plasteel/ocp
	name = MATERIAL_OSMIUM_CARBIDE_PLASTEEL
	stack_type = /obj/item/stack/material/ocp
	integrity = 200
	melting_point = 12000
	icon_colour = "#9bc6f2"
	brute_armor = 4
	burn_armor = 20
	weight = 27
	stack_origin_tech = list(TECH_MATERIAL = 3)
	alloy_materials = list(MATERIAL_PLASTEEL = 7500, MATERIAL_OSMIUM = 3750)
	alloy_product = TRUE

/material/plasteel
	name = MATERIAL_PLASTEEL
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
	alloy_materials = list(MATERIAL_STEEL = 1875, MATERIAL_PLATINUM = 1875)
	alloy_product = TRUE
	ore_smelts_to = MATERIAL_PLASTEEL

/material/steel
	name = MATERIAL_STEEL
	stack_type = /obj/item/stack/material/steel
	integrity = 150
	brute_armor = 5
	melting_point = 1643
	icon_colour = "#666666"
	icon_reinf = "metal"
	door_icon_base = "metal"
	table_icon_base = "metal"
	hitsound = 'sound/weapons/smash.ogg'
	chem_products = list(
				/datum/reagent/iron = 15,
				/datum/reagent/carbon = 5
				)
	alloy_materials = list(MATERIAL_IRON = 1875, MATERIAL_GRAPHITE = 1875) //graphite is carbon
	alloy_product = TRUE
	ore_smelts_to = MATERIAL_STEEL

/material/bronze
	name = MATERIAL_BRONZE
	stack_type = /obj/item/stack/material/bronze
	weight = 20
	hardness = 40
	integrity = 120
	melting_point = 950
	icon_colour = "#cd7f32"
	ore_smelts_to = null
	ore_compresses_to = null
	alloy_materials = list(MATERIAL_TIN = 240, MATERIAL_COPPER = 1760) //Bronze is  ~12% tin
	alloy_product = TRUE

/material/brass
	name = MATERIAL_BRASS
	stack_type = /obj/item/stack/material/brass
	weight = 18
	hardness = 20
	integrity = 80
	melting_point = 900
	icon_colour = "#b5a642"
	ore_smelts_to = null
	ore_compresses_to = null
	alloy_materials = list(MATERIAL_ZINC = 600, MATERIAL_COPPER = 1400) //Brass is ~30% zinc
	alloy_product = TRUE


//-------------------------------------
//	Ores
//-------------------------------------
/material/hematite
	name = MATERIAL_HEMATITE
	stack_type = null
	icon_colour = "#aa6666"
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	ore_smelts_to = MATERIAL_IRON
	ore_result_amount = 5
	ore_spread_chance = 25
	ore_scan_icon = "mineral_common"
	ore_name = MATERIAL_HEMATITE //Fe2O3
	ore_icon_overlay = "lump"
	chem_products = list(
				/datum/reagent/iron = 60
				)
	ore_matter = list(MATERIAL_IRON = 2000)

/material/rutile
	name = MATERIAL_RUTILE
	stack_type = null
	icon_colour = "#d8ad97"
	ore_smelts_to = MATERIAL_TITANIUM
	ore_result_amount = 5
	ore_spread_chance = 15
	ore_scan_icon = "mineral_uncommon"
	ore_name = "rutile"
	ore_icon_overlay = "lump"
	ore_matter = list(MATERIAL_TITANIUM = 2000)

/material/freibergite
	name = MATERIAL_FREIBERGITE
	icon_colour = "#b87333"
	ore_smelts_to = MATERIAL_COPPER
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = MATERIAL_FREIBERGITE //(Ag,Cu,Fe)12(Sb,As)4S13
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "shiny"
	chem_products = list(
		/datum/reagent/copper = 12,
		/datum/reagent/iron = 12,
		/datum/reagent/silver = 12,
		/datum/reagent/sulfur = 14,
		)
	ore_matter = list(MATERIAL_COPPER = 1200, MATERIAL_SILVER = 1200, MATERIAL_IRON = 1200)

/material/bohmeite
	name = MATERIAL_BOHMEITE
	icon_colour = "#443832"
	ore_smelts_to = MATERIAL_COPPER
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = MATERIAL_BOHMEITE
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "shiny"
	chem_products = list(
		/datum/reagent/copper = 12,
		/datum/reagent/aluminum = 12,
		)
	ore_matter = list(MATERIAL_COPPER = 1200, MATERIAL_GOLD = 1200, MATERIAL_ALUMINIUM = 1200)

/material/tetrahedrite
	name = MATERIAL_TETRAHEDRITE
	icon_colour = "#b87333"
	ore_smelts_to = MATERIAL_COPPER
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = MATERIAL_TETRAHEDRITE //(Cu,Fe)12Sb4S13
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "shiny"
	chem_products = list(
		/datum/reagent/copper = 12,
		/datum/reagent/iron = 12,
		/datum/reagent/sulfur = 13,
		)
	ore_matter = list(MATERIAL_COPPER = 1800)

/material/ilmenite
	name = MATERIAL_ILMENITE
	icon_colour = "#d1e6e3"
	ore_smelts_to = MATERIAL_TITANIUM
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = MATERIAL_ILMENITE //iron titanium oxide, FeTiO3
	ore_scan_icon = "mineral_uncommon"
	ore_icon_overlay = "shiny"
	chem_products = list(
		/datum/reagent/iron = 10,
		)
	ore_matter = list(MATERIAL_IRON = 1000, MATERIAL_TITANIUM = 1000)

/material/galena
	name = MATERIAL_GALENA
	icon_colour = "#a0a29a"
	ore_smelts_to = MATERIAL_LEAD
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = MATERIAL_GALENA //Lead sulfide, PbS
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "shiny"
	chem_products = list(
		/datum/reagent/sulfur = 10,
		)
	ore_matter = list(MATERIAL_LEAD = 2000)

/material/cassiterite
	name = MATERIAL_CASSITERITE
	icon_colour = "#42270f"
	ore_smelts_to = MATERIAL_TIN
	ore_result_amount = 8
	ore_spread_chance = 10
	ore_name = MATERIAL_CASSITERITE //Tin oxide, SnO2
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "shiny"
	ore_matter = list(MATERIAL_TIN = 2000)

/material/sphalerite
	name = MATERIAL_SPHALERITE
	icon_colour = "#b9a85e"
	ore_smelts_to = MATERIAL_ZINC
	ore_result_amount = 8
	ore_spread_chance = 10
	ore_name = MATERIAL_SPHALERITE //Zinc oxide, (Zn,Fe)S
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "shiny"
	chem_products = list(
		/datum/reagent/sulfur = 5,
		/datum/reagent/iron = 5,
		)
	ore_matter = list(MATERIAL_ZINC = 2000)
