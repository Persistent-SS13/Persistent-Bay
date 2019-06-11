/obj/machinery/cooker/oven
	name = "oven"
	desc = "Cookies are ready, dear."
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "oven_off"
	on_icon = "oven_on"
	off_icon = "oven_off"
	cook_type = "baked"
	cook_time = 300
	food_color = "#a34719"
	can_burn_food = 1
	circuit_type = /obj/item/weapon/circuitboard/oven

	output_options = list(
		"Personal Pizza" = /obj/item/weapon/reagent_containers/food/snacks/variable/pizza,
		"Bread" = /obj/item/weapon/reagent_containers/food/snacks/variable/bread,
		"Pie" = /obj/item/weapon/reagent_containers/food/snacks/variable/pie,
		"Small Cake" = /obj/item/weapon/reagent_containers/food/snacks/variable/cake,
		"Hot Pocket" = /obj/item/weapon/reagent_containers/food/snacks/variable/pocket,
		"Kebab" = /obj/item/weapon/reagent_containers/food/snacks/variable/kebab,
		"Waffles" = /obj/item/weapon/reagent_containers/food/snacks/variable/waffles,
		"Pancakes" = /obj/item/weapon/reagent_containers/food/snacks/variable/pancakes,
		"Cookie" = /obj/item/weapon/reagent_containers/food/snacks/variable/cookie,
		"Donut" = /obj/item/weapon/reagent_containers/food/snacks/variable/donut,
		)



// /obj/machinery/cooker/oven/New()
// 	..()
// 	component_parts = list()
// 	component_parts += new /obj/item/weapon/circuitboard/oven(null)
// 	component_parts += new /obj/item/weapon/stock_parts/micro_laser(null)
// 	component_parts += new /obj/item/weapon/stock_parts/micro_laser(null)
// 	component_parts += new /obj/item/weapon/stock_parts/console_screen(null)
// 	component_parts += new /obj/item/stack/cable_coil(null, 5)
// 	RefreshParts()

// /obj/machinery/cooker/oven/upgraded/New()
// 	..()
// 	component_parts = list()
// 	component_parts += new /obj/item/weapon/circuitboard/oven(null)
// 	component_parts += new /obj/item/weapon/stock_parts/micro_laser/ultra(null)
// 	component_parts += new /obj/item/weapon/stock_parts/micro_laser/ultra(null)
// 	component_parts += new /obj/item/weapon/stock_parts/console_screen(null)
// 	component_parts += new /obj/item/stack/cable_coil(null, 5)
// 	RefreshParts()

/obj/machinery/cooker/oven/RefreshParts()
