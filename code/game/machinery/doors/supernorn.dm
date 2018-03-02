/obj/machinery/door/airlock/supernorn
	icon = 'icons/obj/doors/SL_doors.dmi'
	icon_state = "generic_closed"
	icon_base = "generic"
	var/welded_base = "airlock"
	density = 1
	
/obj/machinery/door/airlock/supernorn/do_animate(animation)
	switch(animation)
		if("opening")
			flick("[icon_base]_opening", src)
		if("closing")
			flick("[icon_base]_closing", src)
		if("deny")
			flick("[icon_base]_deny", src)
		if("spark")
			flick("[icon_base]_spark", src)
	update_icon()

/obj/machinery/door/airlock/supernorn/update_icon()
	if(!density)
		icon_state =  "[icon_base]_open"
	else 
		if(p_open || welded)
			overlays = list()
			if(p_open)
				overlays += image(icon, "panel_open")
			if(welded)
				overlays += image(icon, "[welded_base]_welded")
		if(locked)
			icon_state =  "[icon_base]_locked"
		else
			icon_state =  "[icon_base]_closed"

/obj/machinery/door/airlock/supernorn/command
	name = "Command"
	req_access = list(access_heads)
	icon_base = "com"
/obj/machinery/door/airlock/supernorn/security
	name = "Security"
	req_access = list(access_security)
	icon_base = "sec"

/obj/machinery/door/airlock/supernorn/engineering
	name = "Engineering"
	req_access = list(access_engine)
	icon_base = "eng"
/*
	/obj/machinery/door/airlock/supernorn/medical
	name = "Medical"
	req_access = list(access_medical)
	icon_base = "med"
*/
/obj/machinery/door/airlock/supernorn/maintenance
	name = "Maintenance Access"
	req_access = list(access_maint_tunnels)
	icon_base = "maint"
/obj/machinery/door/airlock/supernorn/research
	name = "Research"
	req_access = list(access_research)
	icon_base = "research"
/obj/machinery/door/airlock/supernorn/maintenance
	name = "Maintenance Access"
	req_access = list(access_maint_tunnels)
	icon_base = "maint"
/obj/machinery/door/airlock/supernorn/glass
	name = "Glass Door"
	req_access = list()
	icon_base = "glass"
	door_crush_damage = DOOR_CRUSH_DAMAGE*0.75
	maxhealth = 300
	explosion_resistance = 5
	hitsound = 'sound/effects/Glasshit.ogg'
	welded_base = "glass"
	open_sound_powered = 'sound/machines/windowdoor.ogg'
	close_sound_powered = 'sound/machines/windowdoor.ogg'
	opacity = 0
	glass = 1
/obj/machinery/door/airlock/supernorn/glassengineering
	name = "Glass Engineering Door"
	req_access = list(access_engine)
	icon_base = "eng_glass"
	door_crush_damage = DOOR_CRUSH_DAMAGE*0.75
	maxhealth = 300
	explosion_resistance = 5
	hitsound = 'sound/effects/Glasshit.ogg'
	welded_base = "glass"
	open_sound_powered = 'sound/machines/windowdoor.ogg'
	close_sound_powered = 'sound/machines/windowdoor.ogg'
	opacity = 0
	glass = 1
/obj/machinery/door/airlock/supernorn/glasscommand
	name = "Glass Command Door"
	req_access = list(access_heads)
	icon_base = "com_glass"
	door_crush_damage = DOOR_CRUSH_DAMAGE*0.75
	maxhealth = 300
	explosion_resistance = 5
	hitsound = 'sound/effects/Glasshit.ogg'
	welded_base = "airlock"
	open_sound_powered = 'sound/machines/windowdoor.ogg'
	close_sound_powered = 'sound/machines/windowdoor.ogg'
	opacity = 0
	glass = 1
/obj/machinery/door/supernorn
	icon = 'icons/obj/doors/SL_doors.dmi'
	icon_state = "generic_closed"
	icon_base = "generic"
	var/locked = 0
	var/welded = 0
	var/panel = 0
	var/autoclose_delay = 150 // ugh, lets not use the autoclose built into the door type due to autoclose, for now, give doors proper functionality for this later
	density = 1
/obj/machinery/door/supernorn/wood
	name = "Wooden Door"
	req_access = list()
	icon_base = "wood"
/obj/machinery/door/supernorn/update_icon()
	if(!density)
		icon_state =  "[icon_base]_open"
	else if(locked)
		icon_state =  "[icon_base]_locked"
	else
		icon_state =  "[icon_base]_closed"

/obj/machinery/door/supernorn/open()
	if(!can_open())
		play_animation("deny")
		return
	operating = 1
	p_open = 1
	play_animation("opening")
	
	playsound(src, "sound/machines/airlock_swoosh_temp.ogg", 100, 0)
	spawn(2.5)
		density = 0 // let them through halfway through the anim
		set_opacity(0)
		update_icon()
		update_nearby_tiles()
	spawn(5)
		operating = 0
	src.layer = open_layer
	if (autoclose_delay)
		spawn(autoclose_delay)
			try_autoclose()

/obj/machinery/door/supernorn/close()
	if (!p_open || locked || operating || (stat & NOPOWER))
		return
	if (!check_safeties())
		return
	operating = 1
	p_open = 0
	play_animation("closing")
	playsound(src, "sound/machines/airlock_swoosh_temp.ogg", 100, 0)
	spawn(2.5)
		density = 1
		update_icon()
		if(!glass) set_opacity(1)
		update_nearby_tiles()
	spawn(5)
		operating = 0

/obj/machinery/door/supernorn/proc/play_animation(animation)
	switch(animation)
		if("opening")
			flick("[icon_base]_opening", src)
		if("closing")
			flick("[icon_base]_closing", src)
		if("deny")
			flick("[icon_base]_deny", src)
		if("spark")
			flick("[icon_base]_spark", src)
	update_icon()
/obj/machinery/door/supernorn/do_animate(animation)
	play_animation(animation)
/obj/machinery/door/supernorn/proc/check_safeties()
	if (locate(/mob/living) in src.loc)
		return 0
	return 1

/obj/machinery/door/supernorn/proc/try_autoclose()
	if (check_safeties())
		close()
	else
		spawn(10) // something was in the way
			try_autoclose()
