#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it! 
#endif

/obj/item/weapon/circuitboard/pipe_dispenser
	name = T_BOARD("pipe dispenser")
	build_path = /obj/machinery/pipedispenser
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 1)
	req_components = list(
		/obj/item/weapon/stock_parts/matter_bin = 1,
		/obj/item/weapon/stock_parts/manipulator = 1
	)

/obj/item/weapon/circuitboard/disposal_pipe_dispenser
	name = T_BOARD("disposal pipe dispenser")
	build_path = /obj/machinery/pipedispenser/disposal
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 1)
	req_components = list(
		/obj/item/weapon/stock_parts/matter_bin = 1,
		/obj/item/weapon/stock_parts/manipulator = 1
	)

/obj/item/weapon/circuitboard/cable_layer
	name = T_BOARD("cable layer")
	build_path = /obj/machinery/cablelayer
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 1)
	req_components = list(
		/obj/item/weapon/stock_parts/manipulator = 2,
	)

/obj/item/weapon/circuitboard/pipe_layer
	name = T_BOARD("pipe layer")
	build_path = /obj/machinery/pipelayer
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 1)
	req_components = list(
		/obj/item/weapon/stock_parts/manipulator = 2,
	)
