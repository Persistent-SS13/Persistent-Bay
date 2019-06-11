//===================================
//	Mini welder tool
//===================================
/obj/item/weapon/tool/weldingtool/mini
	matter = list(MATERIAL_STEEL = 70, MATERIAL_GLASS = 30)
	w_class = ITEM_SIZE_SMALL
	tank = new /obj/item/weapon/welder_tank/mini
	welding_efficiency = 0.9

/obj/item/weapon/tool/weldingtool/mini/empty
	tank = new /obj/item/weapon/welder_tank/mini/empty

//===================================
//	Mini welder tool tank
//===================================
/obj/item/weapon/welder_tank/mini
	name = "small welding fuel tank"
	icon_state = "tank_small"
	w_class = ITEM_SIZE_TINY
	tank_volume = 15
	starting_fuel = 15
	can_remove = 0

/obj/item/weapon/welder_tank/mini/empty
	starting_fuel = 0
