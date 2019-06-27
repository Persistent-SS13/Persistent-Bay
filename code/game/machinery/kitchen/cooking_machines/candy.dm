/obj/machinery/cooker/candy
	name = "candy machine"
	desc = "Get yer candied cheese wheels here!"
	icon_state = "mixer_off"
	off_icon = "mixer_off"
	on_icon = "mixer_on"
	cook_type = "candied"

	output_options = list(
		"Jawbreaker" = /obj/item/weapon/reagent_containers/food/snacks/variable/jawbreaker,
		"Candy Bar" = /obj/item/weapon/reagent_containers/food/snacks/variable/candybar,
		"Sucker" = /obj/item/weapon/reagent_containers/food/snacks/variable/sucker,
		"Jelly" = /obj/item/weapon/reagent_containers/food/snacks/variable/jelly
		)
	circuit_type = /obj/item/weapon/circuitboard/candy_maker

/obj/machinery/cooker/candy/change_product_appearance(var/obj/item/weapon/reagent_containers/food/snacks/cooked/product)
	food_color = get_random_colour(1)
	. = ..()

// /obj/machinery/cooker/candy/New()
// 	..()
// 	component_parts = list()
// 	component_parts += new /obj/item/weapon/circuitboard/candy_maker(null)
// 	component_parts += new /obj/item/weapon/stock_parts/manipulator(null)
// 	component_parts += new /obj/item/weapon/stock_parts/console_screen(null)
// 	component_parts += new /obj/item/stack/cable_coil(null, 5)
// 	RefreshParts()

// /obj/machinery/cooker/candy/upgraded/New()
// 	..()
// 	component_parts = list()
// 	component_parts += new /obj/item/weapon/circuitboard/candy_maker(null)
// 	component_parts += new /obj/item/weapon/stock_parts/manipulator/pico(null)
// 	component_parts += new /obj/item/weapon/stock_parts/console_screen(null)
// 	component_parts += new /obj/item/stack/cable_coil(null, 5)
// 	RefreshParts()

/obj/machinery/cooker/candy/RefreshParts()
	return