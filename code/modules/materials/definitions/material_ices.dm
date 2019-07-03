/*
	A new ore type that allows obtaining more chemicals and gases
*/
/material/ices
	name = "ERROR"
	integrity = 50
	weight = 30
	hardness = 30
	ore_result_amount = 6
	ore_spread_chance = 18
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "shiny"
	ore_smelts_to = null
	stack_type = /obj/item/stack/ore/ices

/material/ices/water
	name = MATERIAL_ICES_WATER
	ore_name = MATERIAL_ICES_WATER
	melting_point = T0C
	chem_products = list(/datum/reagent/drink/ice = 20)
	icon_colour = COLOR_BLUE_LIGHT

/material/ices/nitrogen
	name = MATERIAL_ICES_NITROGEN
	ore_name = MATERIAL_ICES_NITROGEN
	melting_point = 63 //K
	chem_products = list(/datum/reagent/nitrogen = 20)
	icon_colour = COLOR_GREEN_GRAY

/material/ices/amonia
	name = MATERIAL_ICES_AMONIA
	ore_name = MATERIAL_ICES_AMONIA
	melting_point = 195 //K
	chem_products = list(/datum/reagent/ammonia = 20)
	icon_colour = "#404030"

/material/ices/hydrogen
	name = MATERIAL_ICES_HYDROGEN
	ore_name = MATERIAL_ICES_HYDROGEN
	melting_point = 13 //K
	chem_products = list(/datum/reagent/hydrogen = 20)
	icon_colour = COLOR_BLUE_GRAY

/material/ices/sulfur_dioxide
	name = MATERIAL_ICES_SULFUR_DIOXIDE
	ore_name = MATERIAL_ICES_SULFUR_DIOXIDE
	melting_point = 201 //K
	chem_products = list(/datum/reagent/sulfur = 10, /datum/reagent/oxygen = 10)
	icon_colour = "#bf8c00"

/material/ices/carbon_dioxide
	name = MATERIAL_ICES_CARBON_DIOXIDE
	ore_name = MATERIAL_ICES_CARBON_DIOXIDE
	melting_point = 216 //K
	chem_products = list(/datum/reagent/carbon_dioxide = 20)
	icon_colour = COLOR_GRAY15

/material/ices/methane
	name = MATERIAL_ICES_METHANE
	ore_name = MATERIAL_ICES_METHANE
	melting_point = 90 //K
	chem_products = list(/datum/reagent/hydrogen = 10, /datum/reagent/carbon = 10)
	icon_colour = COLOR_BLUE_GRAY

/material/ices/acetone
	name = MATERIAL_ICES_ACETONE
	ore_name = MATERIAL_ICES_ACETONE
	melting_point = 178 //K
	chem_products = list(/datum/reagent/acetone = 20)
	icon_colour = "#23ace5"

