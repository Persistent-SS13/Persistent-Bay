#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/suit_storage_unit
	name = T_BOARD("suit_storage_unit")
	build_path = /obj/machinery/suit_storage_unit
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 1)
	req_components = list(
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/weapon/stock_parts/manipulator = 2)

/obj/item/weapon/circuitboard/suit_cycler
	name = T_BOARD("suit_cycler")
	build_path = /obj/machinery/suit_cycler
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 1)
	req_components = list(
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/stack/cable_coil = 1)

	var/list/names_paths = list(/obj/machinery/suit_cycler = "Command Suit Cycler",
							/obj/machinery/suit_cycler/engineering = "Engineering Suit Cycler",
							/obj/machinery/suit_cycler/mining = "Mining Suit Cycler",
							/obj/machinery/suit_cycler/science = "Science Suit Cycler",
							/obj/machinery/suit_cycler/security = "Security Suit Cycler",
							/obj/machinery/suit_cycler/medical = "Medical Suit Cycler",
							/obj/machinery/suit_cycler/pilot = "Pilot Suit Cycler",
							/obj/machinery/suit_cycler/eva = "EVA Suit Cycler")

/obj/item/weapon/circuitboard/suit_cycler/attackby(obj/item/I, mob/user, params)
	if(isScrewdriver(I))
		set_type(pick(names_paths), user)

/obj/item/weapon/circuitboard/suit_cycler/proc/set_type(typepath, mob/user)
		build_path = typepath
		name = T_BOARD("[names_paths[build_path]]")
		user << "<span class='notice'>You set the board to [names_paths[build_path]].</span>"