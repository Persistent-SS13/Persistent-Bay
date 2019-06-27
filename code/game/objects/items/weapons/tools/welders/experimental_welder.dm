//===================================
//	Experimental welder tool
//===================================
/obj/item/weapon/tool/weldingtool/experimental
	name = "experimental welding tool"
	icon_state = "welder_h"
	desc = "This welding tool feels heavier in your possession than is normal. Uses phoron as hyper-efficient fuel."
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 4, TECH_PHORON = 3)
	matter = list(MATERIAL_STEEL = 800, MATERIAL_GLASS = 360, MATERIAL_SILVER = 200, MATERIAL_PHORON = 50 )
	tank = new /obj/item/weapon/welder_tank/experimental
	welding_resource = /datum/reagent/toxin/phoron
	fuel_rate = 0.001 //The fuel burn rate while the welder is on
	fuel_cost_use = 0.001 //Multiplier for static fuel costs when starting a task
	welding_efficiency = 0.5 //Welds faster, for less fuel

/obj/item/weapon/tool/weldingtool/experimental/on_update_icon()
	icon_state = initial(icon_state) + (welding? 1 : "")
	item_state = welding ? "welder1" : "welder"
	update_tank_underlay()
	var/mob/M = loc
	if(istype(M))
		M.update_inv_l_hand()
		M.update_inv_r_hand()

// /obj/item/weapon/tool/weldingtool/experimental/update_tank_underlay()
// 	underlays.Cut()
// 	if(istype(tank))
// 		var/image/tank_image = image(tank.icon, icon_state = tank.icon_state)
// 		tank_image.pixel_z = 0
// 		underlays += tank_image

//===================================
//	Experimental welder tool tank
//===================================
/obj/item/weapon/welder_tank/experimental
	name = "experimental welding fuel tank"
	desc = "Uses phoron as hyper-efficient fuel."
	icon_state = "tank_experimental"
	w_class = ITEM_SIZE_SMALL
	tank_volume = 20
	starting_fuel = 20
	fuel_type = /datum/reagent/toxin/phoron

/obj/item/weapon/welder_tank/experimental/empty
	starting_fuel = 0
