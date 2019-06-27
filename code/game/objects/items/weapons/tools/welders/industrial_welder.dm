//===================================
//	Industrial welder tool
//===================================
/obj/item/weapon/tool/weldingtool/largetank
	name = "industrial welding tool"
	origin_tech = list(TECH_ENGINEERING = 2)
	matter = list(MATERIAL_STEEL = 420, MATERIAL_GLASS = 180)
	w_class = ITEM_SIZE_NORMAL
	tank = new /obj/item/weapon/welder_tank/large
	fuel_rate = 0.04 //The idle fuel burn rate while the welder is on
	fuel_cost_use = 0.9 //Multiplier for initial fuel costs when starting a task
	welding_efficiency = 0.8

/obj/item/weapon/tool/weldingtool/largetank/empty
	tank = new /obj/item/weapon/welder_tank/large/empty

//===================================
//	Industrial welder tool tank
//===================================
/obj/item/weapon/welder_tank/large
	name = "large welding fuel tank"
	icon_state = "tank_large"
	w_class = ITEM_SIZE_SMALL
	tank_volume = 80
	starting_fuel = 80
	matter = list(MATERIAL_STEEL = 40)

/obj/item/weapon/welder_tank/large/empty
	starting_fuel = 0
