/obj/machinery/cooker/cereal
	name = "cereal maker"
	desc = "Now with Dann O's available!"
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "cereal_off"
	cook_type = "cerealized"
	on_icon = "cereal_on"
	off_icon = "cereal_off"
	circuit_type = /obj/item/weapon/circuitboard/cereal

/obj/machinery/cooker/cereal/change_product_strings(var/obj/item/weapon/reagent_containers/food/snacks/product)
	. = ..()
	product.name = "box of [cooking_obj.name] cereal"

/obj/machinery/cooker/cereal/change_product_appearance(var/obj/item/weapon/reagent_containers/food/snacks/product)
	product.icon = 'icons/obj/food.dmi'
	product.icon_state = "cereal_box"
	product.filling_color = cooking_obj.color

	var/image/food_image = image(cooking_obj.icon, cooking_obj.icon_state)
	food_image.color = cooking_obj.color
	food_image.overlays += cooking_obj.overlays
	food_image.transform *= 0.7

	product.overlays += food_image


// /obj/machinery/cooker/cereal/New()
// 	..()
// 	component_parts = list()
// 	component_parts += new /obj/item/weapon/circuitboard/cereal(null)
// 	component_parts += new /obj/item/weapon/stock_parts/micro_laser(null)
// 	component_parts += new /obj/item/weapon/stock_parts/micro_laser(null)
// 	component_parts += new /obj/item/weapon/stock_parts/console_screen(null)
// 	component_parts += new /obj/item/stack/cable_coil(null, 5)
// 	RefreshParts()

// /obj/machinery/cooker/cereal/upgraded/New()
// 	..()
// 	component_parts = list()
// 	component_parts += new /obj/item/weapon/circuitboard/cereal(null)
// 	component_parts += new /obj/item/weapon/stock_parts/micro_laser/ultra(null)
// 	component_parts += new /obj/item/weapon/stock_parts/micro_laser/ultra(null)
// 	component_parts += new /obj/item/weapon/stock_parts/console_screen(null)
// 	component_parts += new /obj/item/stack/cable_coil(null, 5)
// 	RefreshParts()

/obj/machinery/cooker/cereal/RefreshParts()

	return