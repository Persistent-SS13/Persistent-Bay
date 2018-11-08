/obj/machinery/autolathe/ammo_fab
	name = "ammunition fabricator"
	desc = "Fabricates many types of ammunition, magazines and boxes."
	icon_state = "autolathe"

/obj/machinery/autolathe/ammo_fab/New()
	wires = new(src)
	//Create parts for lathe.
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/ammo_fab(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
	RefreshParts()

	machine_recipes = (autolathe_categories = "Ammunition")

