#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif




/obj/item/weapon/circuitboard/microwave
	name = "circuit board (Microwave)"
	build_path = /obj/machinery/microwave
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 1)
	req_components = list(
							/obj/item/weapon/stock_parts/micro_laser = 1,
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/oven
	name = "circuit board (Oven)"
	build_path = /obj/machinery/cooker/oven
	board_type = "machine"
	origin_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	req_components = list(
							/obj/item/weapon/stock_parts/micro_laser = 2,
							/obj/item/stack/cable_coil = 5,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/grill
	name = "circuit board (Grill)"
	build_path = /obj/machinery/cooker/grill
	board_type = "machine"
	origin_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	req_components = list(
							/obj/item/weapon/stock_parts/micro_laser = 2,
							/obj/item/stack/cable_coil = 5,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/candy_maker
	name = "circuit board (Candy Maker)"
	build_path = /obj/machinery/cooker/candy
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/stack/cable_coil = 5,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/deepfryer
	name = "circuit board (Deep Fryer)"
	build_path = /obj/machinery/cooker/fryer/
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/micro_laser = 2,
							/obj/item/stack/cable_coil = 5)

/obj/item/weapon/circuitboard/gibber
	name = "circuit board (Gibber)"
	build_path = /obj/machinery/gibber
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 1)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/manipulator = 1)

/obj/item/weapon/circuitboard/cereal
	name = "circuit board (cereal maker)"
	build_path = /obj/machinery/cooker/cereal
	board_type = "machine"
	origin_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	req_components = list(
							/obj/item/weapon/stock_parts/micro_laser = 2,
							/obj/item/stack/cable_coil = 5,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/small_incubator
	name = T_BOARD("small incubator")
	build_path = /obj/machinery/small_incubator
	board_type = "machine"
	origin_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	req_components = list(
							/obj/item/weapon/stock_parts/micro_laser = 2,
							/obj/item/stack/cable_coil = 5,
							/obj/item/weapon/reagent_containers/glass/beaker = 1,
							)
