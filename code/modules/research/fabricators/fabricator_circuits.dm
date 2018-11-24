// Unobtainable
/obj/item/weapon/circuitboard/fabricator
	name = "Circuit board (Fabricator)"
	build_path = /obj/machinery/fabricator/
	board_type = "machine"
	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 2,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/fabricator/mechfab
	name = "Circuit board (Exosuit Fabricator)"
	build_path = /obj/machinery/fabricator/mecha_part_fabricator

/datum/design/circuit/mechfab
	name = "exosuit fabricator"
	id = "mechfab"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/fabricator/mechfab
	sort_string = "FABAA"

/obj/item/weapon/circuitboard/fabricator/voidfab
	name = "Circuit board (Voidsuit Fabricator)"
	build_path = /obj/machinery/fabricator/voidsuit_fabricator

/datum/design/circuit/voidfab
	name = "voidsuit fabricator"
	id = "voidfab"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/fabricator/voidfab
	sort_string = "FABAB"

/obj/item/weapon/circuitboard/fabricator/circuitfab
	name = "Circuit board (Circuit Imprinter)"
	build_path = /obj/machinery/fabricator/circuit_fabricator
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 2,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1,
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/weapon/reagent_containers/glass/beaker = 1
							)

/datum/design/circuit/circuitfab
	name = "circuit imprinter"
	id = "circuitfab"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/fabricator/circuitfab
	sort_string = "FABAC"

/obj/item/weapon/circuitboard/fabricator/ammofab
	name = "Circuit board (Ammunition Fabricator)"
	build_path = /obj/machinery/fabricator/ammo_fabricator

/datum/design/circuit/ammofab
	name = "ammunition fabricator"
	id = "ammofab"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1, TECH_COMBAT = 1)
	build_path = /obj/item/weapon/circuitboard/fabricator/ammofab
	sort_string = "FABAD"