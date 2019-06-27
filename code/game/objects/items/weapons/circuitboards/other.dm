#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it! 
#endif

//Stuff that doesn't fit into any category goes here

/obj/item/weapon/circuitboard/aicore
	name = T_BOARD("AI core")
	origin_tech = list(TECH_DATA = 4, TECH_BIO = 2)
	board_type = "other"

/obj/item/weapon/circuitboard/vendor
	name = T_BOARD("Booze-O-Mat Vendor")
	build_path = /obj/machinery/vending/boozeomat
	board_type = "machine"
	origin_tech = list(TECH_DATA = 1)
	req_components = list(
							/obj/item/weapon/vending_refill/boozeomat = 3)

	var/list/names_paths = list(/obj/machinery/vending/boozeomat = "Booze-O-Mat",
							/obj/machinery/vending/coffee = "Solar's Best Hot Drinks",
							/obj/machinery/vending/snack = "Getmore Chocolate Corp",
							/obj/machinery/vending/cola = "Robust Softdrinks",
							/obj/machinery/vending/cigarette = "ShadyCigs Deluxe"
							)

/obj/item/weapon/circuitboard/vendor/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/tool/screwdriver))
		set_type(pick(names_paths), user)


/obj/item/weapon/circuitboard/vendor/proc/set_type(typepath, mob/user)
		build_path = typepath
		name = T_BOARD("[names_paths[build_path]] Vendor")
		user << "<span class='notice'>You set the board to [names_paths[build_path]].</span>"
		req_components = list(text2path("/obj/item/weapon/vending_refill/[copytext("[build_path]", 24)]") = 3)
		
		
		
/obj/item/weapon/circuitboard/jukebox
	name = T_BOARD("Jukebox")
	build_path = /obj/machinery/media/jukebox
	board_type = "machine"
	origin_tech = list(TECH_DATA = 1)
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/stack/cable_coil = 1)
		

/obj/item/weapon/circuitboard/holopad
	name = T_BOARD("Holopad")
	build_path = /obj/machinery/hologram/holopad
	board_type = "machine"
	origin_tech = list(TECH_DATA = 1)
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/weapon/stock_parts/scanning_module = 1)

/obj/item/weapon/circuitboard/holopad_longrange
	name = T_BOARD("Long Range Holopad")
	build_path = /obj/machinery/hologram/holopad/longrange
	board_type = "machine"
	origin_tech = list(TECH_DATA = 1)
	req_components = list(
							/obj/item/weapon/stock_parts/subspace/ansible = 1,
							/obj/item/weapon/stock_parts/subspace/filter = 1,
							/obj/item/weapon/stock_parts/subspace/crystal = 1,
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/weapon/stock_parts/scanning_module = 1)

/obj/item/weapon/circuitboard/reagentgrinder
	name = T_BOARD("All-in-one Grinder")
	build_path = /obj/machinery/reagentgrinder
	board_type = "machine"
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 1, TECH_BIO = 1)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/weapon/stock_parts/manipulator = 1,)

/obj/item/weapon/circuitboard/photocopier
	name = T_BOARD("photocopier")
	build_path = /obj/machinery/photocopier/
	board_type = "machine"
	origin_tech = list(TECH_MATERIAL =1, TECH_DATA = 1)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 2,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/atm
	name = T_BOARD("ATM")
	build_path = /obj/machinery/atm
	origin_tech = list(TECH_DATA = 1)

/*
/obj/item/weapon/circuitboard/teleporter_hub
	name = T_BOARD(Teleporter Hub)
	build_path = /obj/machinery/teleport/hub
	board_type = "machine"
	origin_tech = "programming=3;engineering=5;bluespace=5;materials=4"
	frame_desc = "Requires 3 Bluespace Crystals and 1 Matter Bin."
	req_components = list(
							/obj/item/weapon/stock_parts/subspace/crystal = 3,
							/obj/item/weapon/stock_parts/matter_bin = 1)

/obj/item/weapon/circuitboard/teleporter_station
	name = T_BOARD(Teleporter Station)
	build_path = /obj/machinery/teleport/station
	board_type = "machine"
	origin_tech = "programming=4;engineering=4;bluespace=4"
	frame_desc = "Requires 2 Bluespace Crystals, 2 Capacitors and 1 Console Screen."
	req_components = list(
							/obj/item/weapon/stock_parts/subspace/crystal = 2,
							/obj/item/weapon/stock_parts/capacitor = 2,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/telesci_pad
	name = T_BOARD(Telepad)
	build_path = /obj/machinery/telepad
	board_type = "machine"
	origin_tech = "programming=4;engineering=3;materials=3;bluespace=4"
	frame_desc = "Requires 2 Bluespace Crystals, 1 Capacitor, 1 piece of cable and 1 Console Screen."
	req_components = list(
							/obj/item/weapon/stock_parts/subspace/crystal = 2,
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/stack/cable_coil = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)
*/

/obj/item/weapon/circuitboard/smartfridge
	name = T_BOARD("smartfridge")
	build_path = /obj/machinery/smartfridge/
	board_type = "machine"
	origin_tech = list(TECH_DATA = 1)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 3)

	var/list/names_paths = list(/obj/machinery/smartfridge/ = "Smart Fridge",
							/obj/machinery/smartfridge/seeds = "MegaSeed Servitor",
							/obj/machinery/smartfridge/secure/extract = "Slime Extract Storage",
							/obj/machinery/smartfridge/secure/medbay = "Refrigerated Medicine Storage",
							/obj/machinery/smartfridge/secure/virology = "Refrigerated Virus Storage",
							/obj/machinery/smartfridge/chemistry = "Smart Chemical Storage",
							/obj/machinery/smartfridge/chemistry/virology = "Smart Virus Storage",
							/obj/machinery/smartfridge/drinks = "Drink Showcase",
							/obj/machinery/smartfridge/drying_rack = "Drying Rack",)

/obj/item/weapon/circuitboard/smartfridge/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/tool/screwdriver))
		set_type(pick(names_paths), user)

/obj/item/weapon/circuitboard/smartfridge/proc/set_type(typepath, mob/user)
		build_path = typepath
		name = T_BOARD("[names_paths[build_path]]")
		user << "<span class='notice'>You set the board to [names_paths[build_path]].</span>"

/obj/item/weapon/circuitboard/libraryscanner
	name = T_BOARD("book scanner")
	build_path = /obj/machinery/libraryscanner
	board_type = "machine"
	origin_tech = list(TECH_MATERIAL =1, TECH_DATA = 1)
	req_components = list(
							/obj/item/weapon/computer_hardware/hard_drive/portable = 1,
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/bookbinder
	name = T_BOARD("book binder")
	build_path = /obj/machinery/bookbinder
	board_type = "machine"
	origin_tech = list(TECH_MATERIAL =1, TECH_DATA = 1)
	req_components = list(
							/obj/item/weapon/computer_hardware/nano_printer = 1,
							/obj/item/weapon/stock_parts/manipulator = 1)

/obj/item/weapon/circuitboard/shuttleengine
	name = T_BOARD("shuttle engine")
	build_path = /obj/machinery/shuttleengine
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 4)
	req_components = list(
							/obj/item/stack/cable_coil = 30,
							/obj/item/device/assembly/igniter = 1,
							/obj/item/weapon/stock_parts/capacitor = 5,
							/obj/item/stack/material/phoron = 5)
							
/obj/item/weapon/circuitboard/bridge_computer
	name = T_BOARD("bridge computer")
	build_path = /obj/machinery/computer/bridge_computer
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	board_type = "computer"
	
/obj/item/weapon/circuitboard/docking_beacon
	name = T_BOARD("docking beacon")
	build_path = /obj/machinery/docking_beacon
	board_type = "machine"
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_BLUESPACE = 4)
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/stack/cable_coil = 1,
							/obj/item/weapon/stock_parts/subspace/filter = 1)


/obj/item/weapon/circuitboard/washing_machine
	name = T_BOARD("washing machine")
	build_path = /obj/machinery/washing_machine
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 4)
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/stack/cable_coil = 20,
							/obj/item/weapon/stock_parts/capacitor = 2)

