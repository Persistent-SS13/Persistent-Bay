/obj/machinery/button/remote
	name 				= "remote object control"
	desc 				= "It controls objects, remotely."
	icon_state 			= "doorctrl2"
	icon_active 		= "doorctrl"
	icon_idle 			= "doorctrl2"
	icon_unpowered 		= "doorctrl-p"
	icon_anim_act   	= "doorctrl1"
	icon_anim_deny  	= "doorctrl-denied"
	power_channel 		= ENVIRON
	anchored 			= TRUE
	use_power 			= POWER_USE_IDLE
	idle_power_usage 	= 2
	active_power_usage 	= 5

	activate_func 		= "toggle"
	id_tag 				= null
	frequency 			= DOOR_FREQ
	radio_filter_in 	= RADIO_AIRLOCK
	radio_filter_out	= RADIO_AIRLOCK

	var/desired_state 	= FALSE
	var/exposedwires 	= 0
	var/wires 			= 3 //Bitflag,	1=checkID 2=Network Access
	var/time_next_use 	= 0 //Time when the button can be used again, avoids button spam


/obj/machinery/button/remote/attack_ai(mob/user as mob)
	if(wires & 2)
		return src.attack_hand(user)
	else
		to_chat(user, SPAN_WARNING("Error, no route to host."))

/obj/machinery/button/remote/attackby(obj/item/weapon/W, mob/user as mob)
	if(!..())
		return src.attack_hand(user)

/obj/machinery/button/remote/emag_act(var/remaining_charges, var/mob/user)
	if(req_access.len || req_one_access.len)
		req_access.Cut()
		req_one_access.Cut()
		playsound(src.loc, "sparks", 100, 1)
		return 1

/obj/machinery/button/remote/attack_hand(mob/user as mob)
	if(..())
		return 1
	if(!allowed(user) && (wires & 1))
		to_chat(user, SPAN_WARNING("Access Denied"))
		flick(icon_anim_deny,src)
		return
	if(world.time >= time_next_use)
		activate(user)
		time_next_use = world.time + 1 SECOND

/obj/machinery/button/remote/send_signal(mob/user as mob)
	desired_state = !desired_state
	post_signal(list(activate_func = 1))

/*
	Blast door remote control
*/
/obj/machinery/button/remote/blast_door
	name 				= "remote blast door-control"
	desc 				= "It controls blast doors, remotely."
	icon_state 			= "blastctrl2"
	icon_active 		= "blastctrl"
	icon_idle 			= "blastctrl2"
	icon_unpowered 		= "blastctrl-p"
	icon_anim_act   	= "blastctrl1"
	icon_anim_deny  	= "blastctrl-denied"
	activate_func 		= "toggle"
	id_tag 				= null
	frequency 			= DOOR_FREQ
	radio_filter_in		= RADIO_BLAST_DOORS
	radio_filter_out	= RADIO_BLAST_DOORS
	radio_check_id 		= TRUE

/obj/machinery/button/remote/blast_door/send_signal(mob/user as mob)
	desired_state = !desired_state
	log_debug("[src]\ref[src] sent signal: command:[activate_func], activate:[desired_state]. id:[id_tag], frequency:[frequency], radio_filter_out:[radio_filter_out]")
	post_signal(list("command" = activate_func), radio_filter_out, id_tag)

/*
	Emitter remote control
*/
/obj/machinery/button/remote/emitter
	name 				= "remote emitter control"
	desc 				= "It controls emitters, remotely."
	activate_func 		= "activate"
	id_tag 				= null
	frequency 			= ENG_FREQ
	radio_filter_in		= RADIO_EMITTERS
	radio_filter_out	= RADIO_EMITTERS

/*
	Airlock remote control
*/

// Bitmasks for door switches.
#define OPEN   0x1
#define IDSCAN 0x2
#define BOLTS  0x4
#define SHOCK  0x8
#define SAFE   0x10

/obj/machinery/button/remote/airlock
	name 				= "remote door-control"
	desc 				= "It controls doors, remotely."
	id_tag 				= null
	frequency 			= DOOR_FREQ
	radio_filter_out 	= RADIO_AIRLOCK
	var/specialfunctions = 1
	/*
	Bitflag, 	1= open
				2= idscan,
				4= bolts
				8= shock
				16= door safties
	*/

/obj/machinery/button/remote/airlock/send_signal()
	desired_state = !desired_state
	var/data[0]
	if(specialfunctions & OPEN)
		data["command"] = "open"
	data["activate"] = desired_state
	if(specialfunctions & IDSCAN)
		data["command"] = "idscan"
	if(specialfunctions & BOLTS)
		data["command"] = "bolts"
	if(specialfunctions & SHOCK)
		data["command"] = "electrify_permanently"
	if(specialfunctions & SAFE)
		data["command"] ="safeties"
	post_signal(data, radio_filter_out, id_tag)

#undef OPEN
#undef IDSCAN
#undef BOLTS
#undef SHOCK
#undef SAFE

/*
	Mass driver remote control
*/
/obj/machinery/button/remote/driver
	name 			= "mass driver button"
	desc 			= "A remote control switch for a mass driver."
	icon_state 		= "launcherbtt"
	icon_active 	= "launcheract"
	icon_idle 		= "launcherbtt"
	icon_unpowered 	= "launcherbtt"
	id_tag 			= null
	frequency 		= DOOR_FREQ
	radio_filter_out= RADIO_MASSDRIVER

/obj/machinery/button/remote/driver/send_signal(mob/user as mob)
	set waitfor = 0
	desired_state = !desired_state
	
	var/data = list("command" = "open")
	post_signal(data, RADIO_BLAST_DOORS, id_tag)
	sleep(20)

	data = list("command" = "activate")
	post_signal(data, radio_filter_out, id_tag)
	sleep(50)

	data = list("command" = "close")
	post_signal(data, RADIO_BLAST_DOORS, id_tag)
