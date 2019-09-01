/*
FIRE ALARM
*/
/obj/machinery/firealarm
	name = "fire alarm"
	desc = "<i>\"Pull this in case of emergency\"</i>. Thus, keep pulling it forever."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "fire0"
	density = 0
	anchored = TRUE
	idle_power_usage = 2
	active_power_usage = 6
	power_channel = ENVIRON
	var/last_process = 0
	var/wiresexposed = FALSE
	var/buildstage = 2 // 2 = complete, 1 = no wires,  0 = circuit gone
	var/seclevel
	var/detecting = TRUE
	var/working = TRUE
	var/time = 10.0
	var/timing = 0.0
	var/lockdownbyai = FALSE

/obj/machinery/firealarm/New(var/loc, var/dir, atom/frame)
	..(loc)

	if(dir)
		src.set_dir(dir)

	if(istype(frame))
		buildstage = 0
		wiresexposed = TRUE
		frame.transfer_fingerprints_to(src)
	ADD_SAVED_VAR(buildstage)
	ADD_SAVED_VAR(wiresexposed)

/obj/machinery/firealarm/examine(mob/user)
	. = ..(user)
	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
	to_chat(user, "The current alert level is [security_state.current_security_level.name].")

/obj/machinery/firealarm/Initialize()
	. = ..()
	if(z in GLOB.using_map.contact_levels)
		queue_icon_update()

/obj/machinery/firealarm/on_update_icon()
	overlays.Cut()

	pixel_x = 0
	pixel_y = 0
	switch(dir)
		if(NORTH)
			pixel_y = -21
		if(SOUTH)
			pixel_y = 21
		if(EAST)
			pixel_x = -21
		if(WEST)
			pixel_x = 21

	if(wiresexposed)
		switch(buildstage)
			if(2)
				icon_state="fire_b2"
			if(1)
				icon_state="fire_b1"
			if(0)
				icon_state="fire_b0"
		set_light(0)
		return

	if(isbroken())
		icon_state = "firex"
		set_light(0)
	else if(!ispowered())
		icon_state = "firep"
		set_light(0)
	else
		if(!src.detecting)
			icon_state = "fire1"
			set_light(0.25, 0.1, 1, 2, COLOR_RED)
		else if(z in GLOB.using_map.contact_levels)
			icon_state = "fire0"
			var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
			var/decl/security_level/sl = security_state.current_security_level

			set_light(sl.light_max_bright, sl.light_inner_range, sl.light_outer_range, 2, sl.light_color_alarm)
			src.overlays += image(sl.icon, sl.overlay_alarm)

/obj/machinery/firealarm/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(src.detecting)
		if(exposed_temperature > T0C+200)
			src.alarm()			// added check of detector status here
	return

/obj/machinery/firealarm/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/firealarm/bullet_act()
	return src.alarm()

/obj/machinery/firealarm/emp_act(severity)
	if(prob(50/severity))
		alarm(rand(30/severity, 60/severity))
	..()

/obj/machinery/firealarm/attackby(obj/item/W as obj, mob/user as mob)
	if(isScrewdriver(W) && buildstage == 2)
		wiresexposed = !wiresexposed
		update_icon()
		return

	if(wiresexposed)
		switch(buildstage)
			if(2)
				if(isMultitool(W))
					src.detecting = !( src.detecting )
					if (src.detecting)
						user.visible_message("<span class='notice'>\The [user] has reconnected [src]'s detecting unit!</span>", "<span class='notice'>You have reconnected [src]'s detecting unit.</span>")
					else
						user.visible_message("<span class='notice'>\The [user] has disconnected [src]'s detecting unit!</span>", "<span class='notice'>You have disconnected [src]'s detecting unit.</span>")
				else if(isWirecutter(W))
					user.visible_message("<span class='notice'>\The [user] has cut the wires inside \the [src]!</span>", "<span class='notice'>You have cut the wires inside \the [src].</span>")
					new/obj/item/stack/cable_coil(get_turf(src), 5)
					playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
					buildstage = 1
					update_icon()
			if(1)
				if(istype(W, /obj/item/stack/cable_coil))
					var/obj/item/stack/cable_coil/C = W
					if (C.use(5))
						to_chat(user, "<span class='notice'>You wire \the [src].</span>")
						buildstage = 2
						update_icon()
						return
					else
						to_chat(user, "<span class='warning'>You need 5 pieces of cable to wire \the [src].</span>")
						return
				else if(isCrowbar(W))
					to_chat(user, "You start prying out the circuit.")
					playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
					if (do_after(user,20))
						if(buildstage == 1) //Prevents circuit duplication
							var/obj/item/weapon/firealarm_electronics/circuit = new /obj/item/weapon/firealarm_electronics()
							circuit.dropInto(user.loc)
							buildstage = 0
							update_icon()
			if(0)
				if(istype(W, /obj/item/weapon/firealarm_electronics))
					to_chat(user, "You insert the circuit!")
					qdel(W)
					buildstage = 1
					update_icon()

				else if(isWrench(W))
					to_chat(user, "You remove the fire alarm assembly from the wall!")
					new /obj/item/frame/fire_alarm(get_turf(user))
					playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
					qdel(src)
		return

	src.alarm()
	return

/obj/machinery/firealarm/Process()//Note: this processing was mostly phased out due to other code, and only runs when needed
	if(inoperable())
		return

	if(src.timing)
		if(src.time > 0)
			src.time = src.time - ((world.timeofday - last_process)/10)
		else
			src.alarm()
			src.time = 0
			src.timing = 0
			STOP_PROCESSING(SSmachines, src)
		src.updateDialog()
	last_process = world.timeofday

	if(locate(/obj/fire) in loc)
		alarm()

/obj/machinery/firealarm/attack_hand(mob/user as mob)
	if(user.stat || inoperable())
		return

	if (buildstage != 2)
		return

	user.set_machine(src)
	var/area/A = src.loc
	var/d1
	var/d2

	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
	if (istype(user, /mob/living/carbon/human) || istype(user, /mob/living/silicon))
		A = A.loc

		if (A.fire)
			d1 = text("<A href='?src=\ref[];reset=1'>Reset - Lockdown</A>", src)
		else
			d1 = text("<A href='?src=\ref[];alarm=1'>Alarm - Lockdown</A>", src)
		if (src.timing)
			d2 = text("<A href='?src=\ref[];time=0'>Stop Time Lock</A>", src)
		else
			d2 = text("<A href='?src=\ref[];time=1'>Initiate Time Lock</A>", src)
		var/second = round(src.time) % 60
		var/minute = (round(src.time) - second) / 60
		var/dat = "<HTML><HEAD></HEAD><BODY><TT><B>Fire alarm</B> [d1]\n<HR>The current alert level is <b>[security_state.current_security_level.name]</b><br><br>\nTimer System: [d2]<BR>\nTime Left: [(minute ? "[minute]:" : null)][second] <A href='?src=\ref[src];tp=-30'>-</A> <A href='?src=\ref[src];tp=-1'>-</A> <A href='?src=\ref[src];tp=1'>+</A> <A href='?src=\ref[src];tp=30'>+</A>\n</TT></BODY></HTML>"
		user << browse(dat, "window=firealarm")
		onclose(user, "firealarm")
	else
		A = A.loc
		if (A.fire)
			d1 = text("<A href='?src=\ref[];reset=1'>[]</A>", src, stars("Reset - Lockdown"))
		else
			d1 = text("<A href='?src=\ref[];alarm=1'>[]</A>", src, stars("Alarm - Lockdown"))
		if (src.timing)
			d2 = text("<A href='?src=\ref[];time=0'>[]</A>", src, stars("Stop Time Lock"))
		else
			d2 = text("<A href='?src=\ref[];time=1'>[]</A>", src, stars("Initiate Time Lock"))
		var/second = round(src.time) % 60
		var/minute = (round(src.time) - second) / 60
		var/dat = "<HTML><HEAD></HEAD><BODY><TT><B>[stars("Fire alarm")]</B> [d1]\n<HR>The current security level is <b>[security_state.current_security_level.name]</b><br><br>\nTimer System: [d2]<BR>\nTime Left: [(minute ? text("[]:", minute) : null)][second] <A href='?src=\ref[src];tp=-30'>-</A> <A href='?src=\ref[src];tp=-1'>-</A> <A href='?src=\ref[src];tp=1'>+</A> <A href='?src=\ref[src];tp=30'>+</A>\n</TT></BODY></HTML>"
		user << browse(dat, "window=firealarm")
		onclose(user, "firealarm")
	return

/obj/machinery/firealarm/CanUseTopic(user)
	if(buildstage != 2)
		return STATUS_CLOSE
	return ..()

/obj/machinery/firealarm/OnTopic(user, href_list)
	if (href_list["reset"])
		src.reset()
		. = TOPIC_REFRESH
	else if (href_list["alarm"])
		src.alarm()
		. = TOPIC_REFRESH
	else if (href_list["time"])
		src.timing = text2num(href_list["time"])
		last_process = world.timeofday
		START_PROCESSING(SSmachines, src)
		. = TOPIC_REFRESH
	else if (href_list["tp"])
		var/tp = text2num(href_list["tp"])
		src.time += tp
		src.time = min(max(round(src.time), 0), 120)
		. = TOPIC_REFRESH

	if(. == TOPIC_REFRESH)
		attack_hand(user)

/obj/machinery/firealarm/proc/reset()
	if (!( src.working ))
		return
	var/area/area = get_area(src)
	for(var/obj/machinery/firealarm/FA in area)
		fire_alarm.clearAlarm(loc, FA)
	update_icon()
	return

/obj/machinery/firealarm/proc/alarm(var/duration = 0)
	if (!( src.working))
		return
	var/area/area = get_area(src)
	for(var/obj/machinery/firealarm/FA in area)
		fire_alarm.triggerAlarm(loc, FA, duration)
	update_icon()
	playsound(src, 'sound/machines/fire_alarm.ogg', 75, 0)
	return

/*
FIRE ALARM CIRCUIT
Just a object used in constructing fire alarms
*/
/obj/item/weapon/firealarm_electronics
	name = "fire alarm electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	desc = "A circuit. It has a label on it, it says \"Can handle heat levels up to 40 degrees celsius!\"."
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50)