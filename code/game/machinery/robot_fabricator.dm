/obj/machinery/robotic_fabricator
	name = "Robotic Fabricator"
	icon = 'icons/obj/robotics.dmi'
	icon_state = "fab-idle"
	density = 1
	anchored = 1
	idle_power_usage = 40
	active_power_usage = 10 KILOWATTS
	circuit_type = /obj/item/weapon/circuitboard/machinery/robotic_fabricator
	var/metal_amount = 0
	var/operating = 0
	var/obj/item/robot_parts/being_built = null
	var/efficiency
	var/initial_bin_rating = 1
	var/time_finished = 0

/obj/machinery/robotic_fabricator/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if (istype(O, /obj/item/stack/material) && O.get_material_name() == MATERIAL_STEEL)
		var/obj/item/stack/M = O
		if (src.metal_amount < 150000.0)
			var/count = 0
			//src.overlays += "fab-load-metal"
			flick("fab-load-metal", src)
			spawn(15)
				if(M)
					if(!M.get_amount())
						return
					while(metal_amount < 150000 && M.use(1))
						src.metal_amount += O.matter[MATERIAL_STEEL] 
						count++

					to_chat(user, "You insert [count] metal sheet\s into the fabricator.")
					//src.overlays -= "fab-load-metal"
					updateDialog()
		else
			to_chat(user, "The robot part maker is full. Please remove metal from the robot part maker in order to insert more.")

/obj/machinery/robotic_fabricator/attack_hand(user as mob)
	var/dat
	if (..())
		return

	if (src.operating)
		dat = {"
<TT>Building [src.being_built.name].<BR>
Please wait until completion...</TT><BR>
<BR>
"}
	else
		dat = {"
<B>Metal Amount:</B> [min(150000, src.metal_amount)] cm<sup>3</sup> (MAX: 150,000)<BR><HR>
<BR>
<A href='?src=\ref[src];make=1'>Left Arm (25,000 cc metal.)<BR>
<A href='?src=\ref[src];make=2'>Right Arm (25,000 cc metal.)<BR>
<A href='?src=\ref[src];make=3'>Left Leg (25,000 cc metal.)<BR>
<A href='?src=\ref[src];make=4'>Right Leg (25,000 cc metal).<BR>
<A href='?src=\ref[src];make=5'>Chest (50,000 cc metal).<BR>
<A href='?src=\ref[src];make=6'>Head (50,000 cc metal).<BR>
<A href='?src=\ref[src];make=7'>Robot Frame (75,000 cc metal).<BR>
"}

	show_browser(user, "<HEAD><TITLE>Robotic Fabricator Control Panel</TITLE></HEAD><TT>[dat]</TT>", "window=robot_fabricator")
	onclose(user, "robot_fabricator")
	return

/obj/machinery/robotic_fabricator/Topic(href, href_list)
	if (..())
		return

	usr.set_machine(src)

	if (href_list["make"])
		if (!src.operating)
			var/part_type = text2num(href_list["make"])

			var/build_type = null
			var/build_time = 200
			var/build_cost = 25000

			switch (part_type)
				if (1)
					build_type = /obj/item/robot_parts/l_arm
					build_time = 200
					build_cost = 25000

				if (2)
					build_type = /obj/item/robot_parts/r_arm
					build_time = 200
					build_cost = 25000

				if (3)
					build_type = /obj/item/robot_parts/l_leg
					build_time = 200
					build_cost = 25000

				if (4)
					build_type = /obj/item/robot_parts/r_leg
					build_time = 200
					build_cost = 25000

				if (5)
					build_type = /obj/item/robot_parts/chest
					build_time = 350
					build_cost = 50000

				if (6)
					build_type = /obj/item/robot_parts/head
					build_time = 350
					build_cost = 50000

				if (7)
					build_type = /obj/item/robot_parts/robot_suit
					build_time = 600
					build_cost = 75000

			var/building = build_type
			if (!isnull(building))
				if (metal_amount >= build_cost)
					time_finished = world.time + build_time
					operating = 1
					update_use_power(POWER_USE_ACTIVE)
					metal_amount = max(0, src.metal_amount - build_cost)
					being_built = new building(src)
					updateUsrDialog()
					on_update_icon()
		return

	for (var/mob/M in viewers(1, src))
		if (M.client && M.machine == src)
			attack_hand(M)

/obj/machinery/robotic_fabricator/New()
	..()
	ADD_SAVED_VAR(being_built)
	ADD_SAVED_VAR(operating)
	ADD_SAVED_VAR(time_finished)
	
	ADD_SKIP_EMPTY(being_built)

/obj/machinery/robotic_fabricator/before_save()
	. = ..()
	if(operating)
		time_finished = max(time_finished - world.time, 0) //Change time left to a relative value on save

/obj/machinery/robotic_fabricator/after_save()
	. = ..()
	if(operating)
		time_finished += world.time //Change it back to absolute after we saved, so we don't mess up the game

/obj/machinery/robotic_fabricator/after_load()
	. = ..()
	if(operating)
		time_finished += world.time //Change it to absolute on load

/obj/machinery/robotic_fabricator/RefreshParts()
	var/E
	var/I
	for(var/obj/item/weapon/stock_parts/matter_bin/B in component_parts)
		E += B.rating
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		I += M.rating

	efficiency = E

/obj/machinery/robotic_fabricator/attackby(var/obj/item/O as obj, var/mob/user as mob)

	if(default_deconstruction_screwdriver(user, O))
		updateUsrDialog()
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	return ..()

/obj/machinery/robotic_fabricator/Process()
	if(operating && world.time >= time_finished)
		if (!isnull(being_built))
			being_built.dropInto(loc)
			being_built = null
		update_use_power(POWER_USE_IDLE)
		operating = FALSE
		time_finished = 0
		on_update_icon()

/obj/machinery/robotic_fabricator/on_update_icon()
	. = ..()
	overlays.Cut()
	if(operating)
		overlays += "fab-active"
	