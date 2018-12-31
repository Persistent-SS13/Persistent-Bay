#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif




/obj/item/weapon/circuitboard/microwave
	name = "circuit board (Microwave)"
	build_path = /obj/machinery/microwave
	board_type = "machine"
	origin_tech = "programming=1"
	frame_desc = "Requires 1 Micro Laser, 2 pieces of cable and 1 Console Screen."
	req_components = list(
							/obj/item/weapon/stock_parts/micro_laser = 1,
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/oven
	name = "circuit board (Oven)"
	build_path = /obj/machinery/cooker/oven
	board_type = "machine"
	origin_tech = "programming=1;plasmatech=1"
	frame_desc = "Requires 2 Micro Lasers, 5 pieces of cable and 1 Console Screen."
	req_components = list(
							/obj/item/weapon/stock_parts/micro_laser = 2,
							/obj/item/stack/cable_coil = 5,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/grill
	name = "circuit board (Grill)"
	build_path = /obj/machinery/cooker/grill
	board_type = "machine"
	origin_tech = "programming=1;plasmatech=1"
	frame_desc = "Requires 2 Micro Lasers, 5 pieces of cable and 1 Console Screen."
	req_components = list(
							/obj/item/weapon/stock_parts/micro_laser = 2,
							/obj/item/stack/cable_coil = 5,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/candy_maker
	name = "circuit board (Candy Maker)"
	build_path = /obj/machinery/cooker/candy
	board_type = "machine"
	origin_tech = "programming=2"
	frame_desc = "Requires 1 Manipulator, 5 pieces of cable and 1 Console Screen."
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/stack/cable_coil = 5,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/deepfryer
	name = "circuit board (Deep Fryer)"
	build_path = /obj/machinery/cooker/fryer/
	board_type = "machine"
	origin_tech = "programming=2"
	frame_desc = "Requires 2 Micro Lasers and 5 pieces of cable."
	req_components = list(
							/obj/item/weapon/stock_parts/micro_laser = 2,
							/obj/item/stack/cable_coil = 5)

/obj/item/weapon/circuitboard/gibber
	name = "circuit board (Gibber)"
	build_path = /obj/machinery/gibber
	board_type = "machine"
	origin_tech = "programming=1"
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/manipulator = 1)

/obj/item/weapon/circuitboard/cereal
	name = "circuit board (cereal maker)"
	build_path = /obj/machinery/cooker/cereal
	board_type = "machine"
	origin_tech = "programming=1;plasmatech=1"
	frame_desc = "Requires 2 Micro Lasers, 5 pieces of cable and 1 Console Screen."
	req_components = list(
							/obj/item/weapon/stock_parts/micro_laser = 2,
							/obj/item/stack/cable_coil = 5,
							/obj/item/weapon/stock_parts/console_screen = 1)
