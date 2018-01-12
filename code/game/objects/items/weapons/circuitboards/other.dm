#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

//Stuff that doesn't fit into any category goes here

/obj/item/weapon/circuitboard/aicore
	name = T_BOARD("AI core")
	origin_tech = list(TECH_DATA = 4, TECH_BIO = 2)
	board_type = "other"

/obj/item/weapon/circuitboard/vendor
	name = "circuit board (Booze-O-Mat Vendor)"
	build_path = /obj/machinery/vending/boozeomat
	board_type = "machine"
	origin_tech = "programming=1"
	frame_desc = "Requires 3 Resupply Canisters."
	req_components = list(
							/obj/item/weapon/vending_refill/boozeomat = 3)

	var/list/names_paths = list(/obj/machinery/vending/boozeomat = "Booze-O-Mat",
							/obj/machinery/vending/coffee = "Solar's Best Hot Drinks",
							/obj/machinery/vending/snack = "Getmore Chocolate Corp",
							/obj/machinery/vending/cola = "Robust Softdrinks",
							/obj/machinery/vending/cigarette = "ShadyCigs Deluxe",
							/obj/machinery/vending/autodrobe = "AutoDrobe",)

/obj/item/weapon/circuitboard/vendor/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/screwdriver))
		set_type(pick(names_paths), user)


/obj/item/weapon/circuitboard/vendor/proc/set_type(typepath, mob/user)
		build_path = typepath
		name = "circuit board ([names_paths[build_path]] Vendor)"
		user << "<span class='notice'>You set the board to [names_paths[build_path]].</span>"
		req_components = list(text2path("/obj/item/weapon/vending_refill/[copytext("[build_path]", 24)]") = 3)



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





// Telecomms circuit boards:
/obj/item/weapon/circuitboard/telecomms/receiver
	name = "Circuit Board (Subspace Receiver)"
	build_path = /obj/machinery/telecomms/receiver
	board_type = "machine"
	origin_tech = "programming=2;engineering=2;bluespace=1"
	frame_desc = "Requires 1 Subspace Ansible, 1 Hyperwave Filter, 2 Manipulators, and 1 Micro-Laser."
	req_components = list(
							/obj/item/weapon/stock_parts/subspace/ansible = 1,
							/obj/item/weapon/stock_parts/subspace/filter = 1,
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/weapon/stock_parts/micro_laser = 1)

/obj/item/weapon/circuitboard/telecomms/hub
	name = "Circuit Board (Hub Mainframe)"
	build_path = /obj/machinery/telecomms/hub
	board_type = "machine"
	origin_tech = "programming=2;engineering=2"
	frame_desc = "Requires 2 Manipulators, 2 Cable Coil and 2 Hyperwave Filter."
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/subspace/filter = 2)

/obj/item/weapon/circuitboard/telecomms/relay
	name = "Circuit Board (Relay Mainframe)"
	build_path = /obj/machinery/telecomms/relay
	board_type = "machine"
	origin_tech = "programming=2;engineering=2;bluespace=2"
	frame_desc = "Requires 2 Manipulators, 2 Cable Coil and 2 Hyperwave Filters."
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/subspace/filter = 2)

/obj/item/weapon/circuitboard/telecomms/bus
	name = "Circuit Board (Bus Mainframe)"
	build_path = /obj/machinery/telecomms/bus
	board_type = "machine"
	origin_tech = "programming=2;engineering=2"
	frame_desc = "Requires 2 Manipulators, 1 Cable Coil and 1 Hyperwave Filter."
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/stack/cable_coil = 1,
							/obj/item/weapon/stock_parts/subspace/filter = 1)

/obj/item/weapon/circuitboard/telecomms/processor
	name = "Circuit Board (Processor Unit)"
	build_path = /obj/machinery/telecomms/processor
	board_type = "machine"
	origin_tech = "programming=2;engineering=2"
	frame_desc = "Requires 3 Manipulators, 1 Hyperwave Filter, 2 Treatment Disks, 1 Wavelength Analyzer, 2 Cable Coils and 1 Subspace Amplifier."
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 3,
							/obj/item/weapon/stock_parts/subspace/filter = 1,
							/obj/item/weapon/stock_parts/subspace/treatment = 2,
							/obj/item/weapon/stock_parts/subspace/analyzer = 1,
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/subspace/amplifier = 1)

/obj/item/weapon/circuitboard/telecomms/server
	name = "Circuit Board (Telecommunication Server)"
	build_path = /obj/machinery/telecomms/server
	board_type = "machine"
	origin_tech = "programming=2;engineering=2"
	frame_desc = "Requires 2 Manipulators, 1 Cable Coil and 1 Hyperwave Filter."
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/stack/cable_coil = 1,
							/obj/item/weapon/stock_parts/subspace/filter = 1)

/obj/item/weapon/circuitboard/telecomms/broadcaster
	name = "Circuit Board (Subspace Broadcaster)"
	build_path = /obj/machinery/telecomms/broadcaster
	board_type = "machine"
	origin_tech = "programming=2;engineering=2;bluespace=1"
	frame_desc = "Requires 2 Manipulators, 1 Cable Coil, 1 Hyperwave Filter, 1 Ansible Crystal and 2 High-Powered Micro-Lasers. "
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/stack/cable_coil = 1,
							/obj/item/weapon/stock_parts/subspace/filter = 1,
							/obj/item/weapon/stock_parts/subspace/crystal = 1,
							/obj/item/weapon/stock_parts/micro_laser/high = 2)