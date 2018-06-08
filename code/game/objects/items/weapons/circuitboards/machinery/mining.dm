#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/miningdrill
	name = T_BOARD("mining drill head")
	build_path = /obj/machinery/mining/drill
	board_type = "machine"
	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/weapon/cell = 1,
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1)

/obj/item/weapon/circuitboard/miningdrillbrace
	name = T_BOARD("mining drill brace")
	build_path = /obj/machinery/mining/brace
	board_type = "machine"
	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	req_components = list()

//Mining machines, no tech levels since they are simple machines and are essential to any station
/obj/item/weapon/circuitboard/processing_unit
	name = T_BOARD("Material Processor")
	build_path = /obj/machinery/mineral/processing_unit
	board_type = "machine"
	origin_tech = list()
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1,
							/obj/item/device/assembly/igniter = 1)

/obj/item/weapon/circuitboard/stacking_machine
	name = T_BOARD("Stacking Machine")
	build_path = /obj/machinery/mineral/stacking_machine
	board_type = "machine"
	origin_tech = list()
	req_components = list(/obj/item/stack/material/steel = 5)

/obj/item/weapon/circuitboard/unloading_machine
	name = T_BOARD("Unloading Machine")
	build_path = /obj/machinery/mineral/unloading_machine
	board_type = "machine"
	origin_tech = list()
	req_components = list(/obj/item/stack/material/steel = 5)

/obj/item/weapon/circuitboard/processing_unit_console/New()
	qdel(src)
/obj/item/weapon/circuitboard/stacking_unit_console/New()
	qdel(src)