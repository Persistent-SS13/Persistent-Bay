/obj/machinery/ai_slipper
	name 					= "Foam Dispenser"
	icon 					= 'icons/obj/device.dmi'
	icon_state 				= "motion0"
	anchored 				= TRUE
	use_power 				= POWER_USE_IDLE
	idle_power_usage 		= 10
	req_access 				= list(core_access_command_programs)

	//Radio
	id_tag 					= null
	frequency 				= AI_FREQ
	radio_filter_in 		= RADIO_FOAM_DISPENSER
	radio_filter_out 		= RADIO_FOAM_DISPENSER
	radio_check_id 			= TRUE

	var/uses 				= 20
	var/disabled 			= TRUE
	var/locked 				= TRUE
	var/duration_cooldown 	= 10 SECONDS
	var/time_cooldown_end 	= 0

/obj/machinery/ai_slipper/New()
	..()
	ADD_SAVED_VAR(uses)
	ADD_SAVED_VAR(disabled)
	ADD_SAVED_VAR(locked)

/obj/machinery/ai_slipper/Initialize(mapload, d)
	. = ..()
	queue_icon_update()

/obj/machinery/ai_slipper/on_update_icon()
	if (inoperable())
		icon_state = "motion0"
	else
		icon_state = disabled ? "motion0" : "motion3"

/obj/machinery/ai_slipper/proc/setState(var/enabled, var/uses)
	src.disabled = disabled
	src.uses = uses
	src.power_change()

/obj/machinery/ai_slipper/attackby(obj/item/weapon/W, mob/user)
	if(default_wrench_floor_bolts(user, W))
		return TRUE
	if(default_deconstruction_screwdriver(user, W))
		return TRUE
	if(default_deconstruction_crowbar(user, W))
		return TRUE
	if(inoperable())
		return
	if (istype(user, /mob/living/silicon))
		return src.attack_hand(user)
	// trying to unlock the interface
	if (src.allowed(usr))
		locked = !locked
		to_chat(user, SPAN_NOTICE("You [ locked ? "lock" : "unlock"] the device."))
		if(user.machine==src)
			if (locked)
				user.unset_machine()
				close_browser(user, "window=ai_slipper")
			else
				src.attack_hand(usr)
		return TRUE
	else
		to_chat(user, SPAN_WARNING("Access denied."))
		return TRUE
	return ..()

/obj/machinery/ai_slipper/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/ai_slipper/attack_hand(mob/user as mob)
	if(inoperable())
		return
	if (!Adjacent(user) && !istype(user, /mob/living/silicon))
		to_chat(user, SPAN_WARNING("Too far away."))
		user.unset_machine()
		close_browser(user, "window=ai_slipper")
		return

	user.set_machine(src)
	var/area/area = get_area(src)
	if (!istype(area, /area))
		to_chat(user, text("[src] badly positioned - area is [area]"))
		return
	var/page = "<TT><B>AI Liquid Dispenser</B> ([area.name])<HR>"
	if(src.locked && (!istype(user, /mob/living/silicon)))
		page += "<I>(Swipe ID card to unlock control panel.)</I><BR>"
	else
		page += text("Dispenser [src.disabled?"deactivated":"activated"] - <A href='?src=\ref[src];toggleOn=1'>[src.disabled?"Enable":"Disable"]</a><br>\n")
		page += text("Uses Left: [uses].")
		if(time_cooldown_end > REALTIMEOFDAY)
			var/timeleft = (time_cooldown_end - REALTIMEOFDAY) / TICKS_IN_SECOND
			page += text("Reloading.. [timeleft]s")
		else
			page += text("<A href='?src=\ref[src];toggleUse=1'>Dispense</A>")
		page += text("<br>\n")

	show_browser(user, page, "window=computer;size=575x450")
	onclose(user, "computer")
	return

/obj/machinery/ai_slipper/OnSignal(datum/signal/signal)
	. = ..()
	if (signal.data["toggle"])
		src.disabled = !src.disabled
	if (signal.data["dispense"])
		dispense_foam()
	update_icon()

/obj/machinery/ai_slipper/OnTopic(user, href_list)
	if (href_list["toggleOn"])
		src.disabled = !src.disabled
		update_icon()
		. = TOPIC_REFRESH
	if (href_list["toggleUse"])
		dispense_foam()
		src.power_change()
	src.attack_hand(usr)
	return

/obj/machinery/ai_slipper/proc/dispense_foam()
	if(REALTIMEOFDAY < time_cooldown_end || disabled || uses <= 0)
		return
	new /obj/effect/effect/foam(src.loc)
	src.uses--
	time_cooldown_end = REALTIMEOFDAY + duration_cooldown
