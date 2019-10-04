#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/cryopod
	name = T_BOARD("Cryogenic Freezer")
	build_path = /obj/machinery/cryopod
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/cryopod/personal
	name = T_BOARD("Personal Cryogenic Freezer")
	build_path = /obj/machinery/cryopod/personal
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/cryopod/robot
	name = T_BOARD("Robotic Storage Unit")
	build_path = /obj/machinery/cryopod/robot
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)