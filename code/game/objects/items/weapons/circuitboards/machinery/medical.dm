/obj/item/weapon/circuitboard/sleeper
	name = "circuit board (Sleeper)"
	build_path = /obj/machinery/sleeper
	board_type = "machine"
	origin_tech = "programming=3;biotech=2;engineering=3;materials=3"
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
	origin_tech = "programming=3;biotech=2;engineering=3;materials=3"
	frame_desc = "Requires 1 Scanning Module, 2 pieces of cable and 2 Console Screens."
	req_components = list(
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/console_screen = 2)

/obj/item/weapon/circuitboard/bodyscanner_console
	name = "circuit board (Body Scanner Console)"
	build_path = /obj/machinery/body_scanconsole
	board_type = "machine"
	origin_tech = "programming=3;biotech=2;engineering=3;materials=3"
	frame_desc = "Requires 2 pieces of cable and 2 Console Screens."
	req_components = list(
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/console_screen = 2)

/obj/item/weapon/circuitboard/cryo_tube
	name = "circuit board (Cryotube)"
	build_path = /obj/machinery/atmospherics/unary/cryo_cell
	board_type = "machine"
	origin_tech = "programming=4;biotech=3;engineering=4"
	frame_desc = "Requires 1 Matter Bin, 1 piece of cable and 4 Console Screens."
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/stack/cable_coil = 1,
							/obj/item/weapon/stock_parts/console_screen = 4)

/obj/item/weapon/circuitboard/resleever
	name = "circuit board (resleever)"
	build_path = /obj/machinery/resleever
	board_type = "machine"
	origin_tech = "programming=3;biotech=4;engineering=3;materials=3"
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 3,
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/chem_dispenser
	name = "circuit board (Portable Chem Dispenser)"
	build_path = /obj/machinery/chemical_dispenser
	board_type = "machine"
	origin_tech = "materials=4;engineering=4;programming=4;plasmatech=3;biotech=3"
	frame_desc = "Requires 1 Capacitor, 1 Manipulator, and 1 Console Screen, and 2 beakers."
	req_components = list(
							/obj/item/weapon/reagent_containers/glass/beaker = 2,
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/console_screen = 1,)

/obj/item/weapon/circuitboard/chem_master
	name = T_BOARD(Chem Master 2999)
	build_path = /obj/machinery/chem_master/
	board_type = "machine"
	origin_tech = "materials=2;programming=2;biotech=1"
	req_components = list(
							/obj/item/weapon/reagent_containers/glass/beaker = 2,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)

