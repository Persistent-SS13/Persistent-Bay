/obj/machinery/cooker/grill
	name = "griddle"
	desc = "A flat, wide, and smooth cooking surface."
	icon_state = "grill_off"
	cook_type = "grilled"
	cook_time = 100
	food_color = "#a34719"
	on_icon = "grill_on"
	off_icon = "grill_off"
	can_burn_food = 1
	circuit_type = /obj/item/weapon/circuitboard/grill

// /obj/machinery/cooker/grill/New()
// 	..()
// 	component_parts = list()
// 	component_parts += new /obj/item/weapon/circuitboard/grill(null)
// 	component_parts += new /obj/item/weapon/stock_parts/micro_laser(null)
// 	component_parts += new /obj/item/weapon/stock_parts/micro_laser(null)
// 	component_parts += new /obj/item/weapon/stock_parts/console_screen(null)
// 	component_parts += new /obj/item/stack/cable_coil(null, 5)
// 	RefreshParts()

// /obj/machinery/cooker/grill/upgraded/New()
// 	..()
// 	component_parts = list()
// 	component_parts += new /obj/item/weapon/circuitboard/grill(null)
// 	component_parts += new /obj/item/weapon/stock_parts/micro_laser/ultra(null)
// 	component_parts += new /obj/item/weapon/stock_parts/micro_laser/ultra(null)
// 	component_parts += new /obj/item/weapon/stock_parts/console_screen(null)
// 	component_parts += new /obj/item/stack/cable_coil(null, 5)
// 	RefreshParts()

/obj/machinery/cooker/grill/RefreshParts()

	return