/obj/machinery/pager
	name = "departmental pager button"
	icon = 'icons/obj/machines/buttons.dmi'
	icon_state = "doorbell"
	desc = "A button used to request the presence of anyone in the department."
	anchored = TRUE
	use_power = POWER_USE_IDLE
	idle_power_usage = 2
	frame_type = /obj/item/frame/pager
	var/acknowledged = FALSE
	var/last_paged
	var/department = COM
	var/location

/obj/machinery/pager/Initialize()
	. = ..()
	if(!location)
		var/area/A = get_area(src)
		if(A)
			location = A.name
		else if(QDELETED(src) || !loc)
			return INITIALIZE_HINT_QDEL //If there's no area its in nullspace
	queue_icon_update()

/obj/machinery/pager/update_icon()
	..()
	var/turf/T = get_step(get_turf(src), GLOB.reverse_dir[dir])
	if(istype(T) && T.density)
		switch(dir)
			if(NORTH)
				src.pixel_x = 0
				src.pixel_y = -26
			if(SOUTH)
				src.pixel_x = 0
				src.pixel_y = 26
			if(EAST)
				src.pixel_x = -22
				src.pixel_y = 0
			if(WEST)
				src.pixel_x = 22
				src.pixel_y = 0
	else
		//Since we can be placed on the floor, or tables or whatever
		src.pixel_x = 0
		src.pixel_y = 0

/obj/machinery/pager/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/pager/attackby(obj/item/weapon/W, mob/user as mob)
	if(default_deconstruction_screwdriver(user,W))
		return TRUE
	else if(default_deconstruction_crowbar(user,W))
		return TRUE
	return attack_hand(user)

/obj/machinery/pager/attack_hand(mob/living/user)
	if(..()) return 1
	if(istype(user, /mob/living/carbon))
		playsound(src, "button", 60)
	flick("doorbellpressed",src)
	activate(user)

/obj/machinery/pager/proc/activate(mob/living/user)
	if(!powered())
		return
	var/obj/machinery/message_server/MS = get_message_server(z)
	if(!MS)
		return
	if(world.time < last_paged + 5 SECONDS)
		return
	last_paged = world.time
	var/paged = MS.send_to_department(department,"Department page to <b>[location]</b> received. <a href='?src=\ref[src];ack=1'>Take</a>", "*page*")
	acknowledged = 0
	if(paged)
		playsound(src, 'sound/machines/ping.ogg', 60)
		to_chat(user, SPAN_NOTICE("Page received by [paged] devices."))
	else
		to_chat(user, SPAN_WARNING("No valid destinations were found for the page."))

/obj/machinery/pager/Topic(href, href_list)
	if(..())
		return 1
	if(!powered())
		return
	if(!acknowledged && href_list["ack"])
		playsound(src, 'sound/machines/ping.ogg', 60)
		visible_message(SPAN_NOTICE("Page acknowledged."))
		acknowledged = 1
		var/obj/machinery/message_server/MS = get_message_server(z)
		if(!MS)
			return
		MS.send_to_department(department,"Page to <b>[location]</b> was acknowledged.", "*ack*")

/obj/machinery/pager/medical
	department = MED

/obj/machinery/pager/cargo //supply
	department = SUP

/obj/machinery/pager/security
	department = SEC

/obj/machinery/pager/science
	department = SCI

/obj/machinery/pager/engineering
	department = ENG

/obj/machinery/pager/command
	department = COM
