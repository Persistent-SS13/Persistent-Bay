#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif
/obj/item/weapon/circuitboard/sleeper
	name = "circuit board (Sleeper)"
	build_path = /obj/machinery/sleeper
	board_type = "machine"
	origin_tech = list(TECH_MATERIAL = 3, TECH_DATA = 3, TECH_BIO = 2, TECH_ENGINEERING = 3)
	frame_desc = "Requires 1 Matter Bin, 1 Manipulator, 1 piece of cable and 2 Console Screens."
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/stack/cable_coil = 1,
							/obj/item/weapon/stock_parts/console_screen = 2)

/obj/item/weapon/circuitboard/bodyscanner
	name = "circuit board (Body Scanner)"
	build_path = /obj/machinery/bodyscanner
	board_type = "machine"
	origin_tech = list(TECH_MATERIAL = 3, TECH_DATA = 3, TECH_BIO = 2, TECH_ENGINEERING = 3)
	frame_desc = "Requires 1 Scanning Module, 2 pieces of cable and 2 Console Screens."
	req_components = list(
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/console_screen = 2)

/obj/item/weapon/circuitboard/bodyscanner_console
	name = "circuit board (Body Scanner Console)"
	build_path = /obj/machinery/body_scanconsole
	board_type = "machine"
	origin_tech = list(TECH_MATERIAL = 3, TECH_DATA = 3, TECH_BIO = 2, TECH_ENGINEERING = 3)
	frame_desc = "Requires 2 pieces of cable and 2 Console Screens."
	req_components = list(
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/console_screen = 2)

obj/item/weapon/circuitboard/cryo_cell
	name = T_BOARD("cryo cell")
	build_path = /obj/machinery/atmospherics/unary/cryo_cell
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 4, TECH_BIO = 6, TECH_DATA = 3)
	req_components = list (
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/pipe = 1)

/obj/item/weapon/circuitboard/resleever
	name = "circuit board (resleever)"
	build_path = /obj/machinery/resleever
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 5, TECH_ENGINEERING = 4)
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 3,
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/chem_dispenser
	name = "circuit board (Portable Chem Dispenser)"
	build_path = /obj/machinery/chemical_dispenser
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 2, TECH_ENGINEERING = 3)
	frame_desc = "Requires 1 Capacitor, 1 Manipulator, and 1 Console Screen, and 2 beakers."
	req_components = list(
							/obj/item/weapon/reagent_containers/glass/beaker = 2,
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/console_screen = 1,)

/obj/item/weapon/circuitboard/chem_master
	name = T_BOARD("Chem Master 2999")
	build_path = /obj/machinery/chem_master/
	board_type = "machine"
	origin_tech = list(TECH_MATERIAL = 2, TECH_DATA = 3, TECH_BIO = 2, TECH_ENGINEERING = 2)
	req_components = list(
							/obj/item/weapon/reagent_containers/glass/beaker = 2,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/diseaseanalyser
	name = T_BOARD("Disease Analyzer")
	build_path = /obj/machinery/disease2/diseaseanalyser
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	req_components = list(
							/obj/item/weapon/computer_hardware/hard_drive/portable = 1,
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/antibodyanalyser
	name = T_BOARD("Antibody Analyzer")
	build_path = /obj/machinery/disease2/antibodyanalyser
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	req_components = list(
							/obj/item/weapon/computer_hardware/hard_drive/portable = 1,
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/centrifuge
	name = T_BOARD("Centrifuge")
	build_path = /obj/machinery/centrifuge
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	req_components = list(
							/obj/item/weapon/computer_hardware/hard_drive/portable = 1,
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/stack/material/glass = 1)

/obj/item/weapon/circuitboard/incubator
	name = T_BOARD("Incubator")
	build_path = /obj/machinery/disease2/incubator
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/isolator
	name = T_BOARD("Isolator")
	build_path = /obj/machinery/disease2/isolator
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)


/obj/item/weapon/circuitboard/crematorium
	name = T_BOARD("crematorium")
	build_path = /obj/machinery/incinerator/crematorium
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 1, TECH_BIO = 1)
	req_components = list(
							/obj/item/device/assembly/igniter = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1)
