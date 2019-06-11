/obj/machinery/button
	name 				= "button"
	icon 				= 'icons/obj/machines/buttons.dmi'
	icon_state 			= "launcherbtt"
	desc 				= "A remote control switch for something."
	anchored 			= TRUE
	density 			= FALSE
	use_power 			= POWER_USE_IDLE
	idle_power_usage 	= 2
	active_power_usage 	= 4
	mass				= 0.2 //kg

	//Radio
	id_tag 				= null
	frequency 			= null
	radio_filter_in 	= null
	radio_filter_out 	= null

	//WIFI
	var/_wifi_id
	var/datum/wifi/sender/wifi_sender
	//The topic the button will trigger on the target
	var/activate_func 	= "activate"

	//Icons states
	var/icon_active 	= "launcheract"
	var/icon_idle 		= "launcherbtt"
	var/icon_unpowered 	= "launcherbtt"
	var/icon_anim_act   = null
	var/icon_anim_deny  = null
	var/sound_toggle 	= "button"

	var/active = FALSE
	var/operating = FALSE

/obj/machinery/button/New()
	. = ..()
	ADD_SAVED_VAR(_wifi_id)
	ADD_SAVED_VAR(activate_func)

/obj/machinery/button/Initialize()
	. = ..()
	if(_wifi_id && !wifi_sender)
		wifi_sender = new/datum/wifi/sender/button(_wifi_id, src)
	queue_icon_update()

/obj/machinery/button/Destroy()
	QDEL_NULL(wifi_sender)
	return..()

/obj/machinery/button/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/button/attackby(obj/item/weapon/W, mob/user as mob)
	if(default_deconstruction_screwdriver(user, W))
		return
	return ..()

/obj/machinery/button/attack_hand(mob/living/user)
	if(..())
		return TRUE
	if(istype(user, /mob/living/carbon))
		playsound(src, sound_toggle, 60)
	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Access Denied"))
		if(icon_anim_deny)
			flick(icon_anim_deny, src)
			sleep(10)
		return FALSE
	return activate(user)

/obj/machinery/button/proc/activate(mob/living/user)
	if(operating)
		return FALSE
	operating = TRUE
	active = TRUE
	use_power_oneoff(active_power_usage)
	send_signal()
	update_icon()
	if(icon_anim_act)
		flick(icon_anim_act, src)
	sleep(10)
	active = FALSE
	update_icon()
	operating = FALSE
	return TRUE

/obj/machinery/button/proc/send_signal()
	if(!istype(wifi_sender))
		return
	wifi_sender.send_topic(usr, list("[activate_func]" = 1))

/obj/machinery/button/update_icon()
	if(!ispowered() && icon_unpowered)
		icon_state = icon_unpowered
	else 
		if(active)
			icon_state = icon_active
		else
			icon_state = icon_idle
		
	//Some switches don't want to change their icons when unpowered!
	
	//First check for a wall
	//If there's no wall, just assume we're fine with pixels 0,0
	var/turf/T = get_step(get_turf(src), GLOB.reverse_dir[dir])
	if(istype(T) && T.density)
		switch(dir)
			if(NORTH)
				src.pixel_x = 0
				src.pixel_y = -20
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
	

//alternate button with the same functionality, except has a lightswitch sprite instead
/obj/machinery/button/switch
	icon 			= 'icons/obj/machines/buttons.dmi'
	icon_state 		= "light0"
	icon_active 	= "light1"
	icon_idle 		= "light0"
	icon_unpowered 	= "light-p"

//alternate button with the same functionality, except has a door control sprite instead
/obj/machinery/button/alternate
	icon_state 		= "doorctrl2"
	icon_active 	= "doorctrl"
	icon_idle 		= "doorctrl2"
	icon_unpowered 	= "doorctrl-p"
	icon_anim_act   = "doorctrl1"
	icon_anim_deny  = "doorctrl-denied"

//Toggle button with two states (on and off) and calls seperate procs for each state
/obj/machinery/button/toggle/
	var/deactivate_func = "deactivate"

/obj/machinery/button/toggle/send_signal()
	if(!istype(wifi_sender))
		return
	if(active)
		wifi_sender.send_topic(usr, list("[activate_func]" = 1))
	else
		wifi_sender.send_topic(usr, list("[deactivate_func]" = 1))

//alternate button with the same toggle functionality, except has a lightswitch sprite instead
/obj/machinery/button/toggle/switch
	icon_state 		= "light0"
	icon_active 	= "light1"
	icon_idle 		= "light0"
	icon_unpowered 	= "light0"

//alternate button with the same toggle functionality, except has a door control sprite instead
/obj/machinery/button/toggle/alternate
	icon_state 		= "doorctrl2"
	icon_active 	= "doorctrl"
	icon_idle 		= "doorctrl2"
	icon_unpowered 	= "doorctrl-p"
	icon_anim_act   = "doorctrl1"
	icon_anim_deny  = "doorctrl-denied"

/obj/machinery/button/toggle/lever
	icon_state 		= "switch-up"
	icon_active 	= "switch-down"
	icon_idle 		= "switch-up"
	icon_unpowered 	= null //levers don't have unpowered state

/obj/machinery/button/toggle/lever/dbl
	icon_state 		= "switch-dbl-up"
	icon_active 	= "switch-dbl-down"
	icon_idle 		= "switch-dbl-up"

//-------------------------------
// Mass Driver Button
//  Passes the activate call to a mass driver wifi sender
//-------------------------------
/obj/machinery/button/mass_driver
	name = "mass driver button"

/obj/machinery/button/mass_driver/Initialize()
	if(_wifi_id)
		wifi_sender = new/datum/wifi/sender/mass_driver(_wifi_id, src)
	. = ..()

//-------------------------------
// Flasher Button
//  
//-------------------------------
/obj/machinery/button/flasher
	name 			= "flasher button"
	desc 			= "A remote control switch for a mounted flasher."
	frequency 		= SEC_FREQ
	radio_filter_out= RADIO_FLASHERS
	activate_func   = "activate"

/obj/machinery/button/flasher/send_signal(mob/user as mob)
	post_signal(list(activate_func = 1), radio_filter_out, id_tag)

//-------------------------------
// Door Button
//-------------------------------

// Bitmasks for door switches.
#define OPEN   0x1
#define IDSCAN 0x2
#define BOLTS  0x4
#define SHOCK  0x8
#define SAFE   0x10

/obj/machinery/button/toggle/door
	icon_state 		= "doorctrl2"
	icon_active 	= "doorctrl"
	icon_idle 		= "doorctrl2"
	icon_unpowered 	= "doorctrl-p"
	icon_anim_act   = "doorctrl1"
	icon_anim_deny  = "doorctrl-denied"
	var/_door_functions = 1
/*	Bitflag, 	1 = open
				2 = idscan
				4 = bolts
				8 = shock
				16 = door safties  */

/obj/machinery/button/toggle/door/Initialize()
	if(_wifi_id)
		wifi_sender = new/datum/wifi/sender/door(_wifi_id, src)
	. = ..()

/obj/machinery/button/toggle/door/send_signal()
	if(active)
		if(_door_functions & IDSCAN)
			wifi_sender.activate("enable_idscan")
		if(_door_functions & SHOCK)
			wifi_sender.activate("electrify")
		if(_door_functions & SAFE)
			wifi_sender.activate("enable_safeties")
		if(_door_functions & BOLTS)
			wifi_sender.activate("unlock")
		if(_door_functions & OPEN)
			wifi_sender.activate("open")
	else
		if(_door_functions & IDSCAN)
			wifi_sender.activate("disable_idscan")
		if(_door_functions & SHOCK)
			wifi_sender.activate("unelectrify")
		if(_door_functions & SAFE)
			wifi_sender.activate("disable_safeties")
		if(_door_functions & OPEN)
			wifi_sender.activate("close")
		if(_door_functions & BOLTS)
			wifi_sender.activate("lock")

#undef OPEN
#undef IDSCAN
#undef BOLTS
#undef SHOCK
#undef SAFE

//-------------------------------
// Valve Button
//-------------------------------
/obj/machinery/button/toggle/valve
	name 				= "remote valve control"
	icon_active 		= "launcheract"
	icon_idle 			= "launcherbtt"
	icon_unpowered 		= "launcherbtt"
	frequency 			= ATMOS_CONTROL_FREQ
	radio_filter_out	= RADIO_ATMOSIA

/obj/machinery/button/toggle/valve/send_signal()
	post_signal(list("command" = "valve_toggle"), null, id_tag)

//-------------------------------
// Window Tint Button
//-------------------------------
/obj/machinery/button/windowtint
	name 			= "window tint control"
	desc 			= "A remote control switch for electrochromic windows."
	icon_state 		= "light0"
	icon_active 	= "light1"
	icon_idle 		= "light0"
	icon_unpowered 	= "light0"
	var/tintrange = 7

/obj/machinery/button/windowtint/attackby(obj/item/device/W as obj, mob/user as mob)
	if(isMultitool(W))
		to_chat(user, SPAN_NOTICE("The ID of the button: [id_tag]"))
		return 1
	return ..()

/obj/machinery/button/windowtint/send_signal()
	for(var/obj/structure/window/W in range(src, tintrange))
		if(!W.polarized)
			continue
		if(!W.id_tag || W.id_tag == src.id_tag)
			spawn(0)
				W.toggle()
				return

