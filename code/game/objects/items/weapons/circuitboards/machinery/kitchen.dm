#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif





/obj/item/weapon/circuitboard/machinery/gibber
	name = "Meat Grinder (Machine Board)"
	build_path = /obj/machinery/gibber
	origin_tech = "programming=2;engineering=2"
	req_components = list(
		/obj/item/weapon/stock_parts/matter_bin = 1,
		/obj/item/weapon/stock_parts/manipulator = 1)














//Undef the macro, shouldn't be needed anywhere else
#undef T_BOARD_MECHA