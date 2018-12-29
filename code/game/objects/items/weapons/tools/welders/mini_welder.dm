//===================================
//	Mini welder tool
//===================================
/obj/item/weapon/weldingtool/mini
	name = "miniature welding tool"
	icon_state = "welder_s"
	item_state = "welder"
	desc = "A smaller welder, meant for quick or emergency use."
	matter = list(MATERIAL_STEEL = 70, MATERIAL_GLASS = 30)
	w_class = ITEM_SIZE_SMALL
	tank = /obj/item/weapon/welder_tank/mini
	welding_efficiency = 0.9

/obj/item/weapon/weldingtool/mini/empty
	tank = /obj/item/weapon/welder_tank/mini/empty

//===================================
//	Mini welder tool tank
//===================================
/obj/item/weapon/welder_tank/mini
	name = "small welding fuel tank"
	icon_state = "fuel_s"
	w_class = ITEM_SIZE_TINY
	tank_volume = 15
	starting_fuel = 15
	can_remove = 0

/obj/item/weapon/welder_tank/mini/empty
	starting_fuel = 0
