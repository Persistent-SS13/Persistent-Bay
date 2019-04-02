//===================================
//	Experimental welder tool
//===================================
/obj/item/weapon/tool/weldingtool/experimental
	name = "experimental welding tool"
	icon_state = "welder_l"
	item_state = "welder"
	desc = "This welding tool feels heavier in your possession than is normal. Uses phoron as hyper-efficient fuel."
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 4, TECH_PHORON = 3)
	matter = list(MATERIAL_STEEL = 800, MATERIAL_GLASS = 360, MATERIAL_SILVER = 200, MATERIAL_PHORON = 50 )
	tank = new /obj/item/weapon/welder_tank/experimental
	fuel_rate = 0.001 //The fuel burn rate while the welder is on
	fuel_cost_use = 0.001 //Multiplier for static fuel costs when starting a task
	welding_efficiency = 0.5 //Welds faster, for less fuel

//===================================
//	Experimental welder tool tank
//===================================
/obj/item/weapon/welder_tank/experimental
	name = "experimental welding fuel tank"
	icon_state = "fuel_x"
	w_class = ITEM_SIZE_SMALL
	tank_volume = 20
	starting_fuel = 20
	fuel_type = /datum/reagent/toxin/phoron

/obj/item/weapon/welder_tank/experimental/empty
	starting_fuel = 0
