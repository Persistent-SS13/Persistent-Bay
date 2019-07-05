//===================================
//	Upgraded welder tool
//===================================
/obj/item/weapon/tool/weldingtool/hugetank
	name = "upgraded welding tool"
	w_class = ITEM_SIZE_NORMAL
	slot_flags = null	//80 units of fuel should have a drawback
	origin_tech = list(TECH_ENGINEERING = 3)
	matter = list(MATERIAL_STEEL = 500, MATERIAL_GLASS = 200, MATERIAL_SILVER = 200)
	tank = new /obj/item/weapon/welder_tank/huge
	fuel_rate = 0.035 //The idle fuel burn rate while the welder is on
	fuel_cost_use = 0.9 //The initial fuel cost for various actions
	welding_efficiency = 0.6

/obj/item/weapon/tool/weldingtool/hugetank/empty
	tank = new /obj/item/weapon/welder_tank/huge/empty

//===================================
//	Upgraded welder tool tank
//===================================
/obj/item/weapon/welder_tank/huge
	name = "huge welding fuel tank"
	icon_state = "tank_huge"
	w_class = ITEM_SIZE_SMALL
	tank_volume = 160
	starting_fuel = 160
	matter = list(MATERIAL_STEEL = 80)

/obj/item/weapon/welder_tank/huge/empty
	starting_fuel = 0
