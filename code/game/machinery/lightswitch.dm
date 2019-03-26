// the light switch
// can have multiple per area
// can also operate on non-loc area through "otherarea" var
/obj/machinery/light_switch
	name 				= "light switch"
	desc 				= "It turns lights on and off. What are you, simple?"
	icon 				= 'icons/obj/machines/buttons.dmi'
	icon_state 			= "light0"
	density 			= FALSE
	anchored 			= TRUE
	use_power 			= POWER_USE_IDLE
	idle_power_usage 	= 5
	active_power_usage 	= 20
	power_channel 		= LIGHT
	frame_type 			= /obj/item/frame/light_switch
	var/on 				= FALSE
	var/area/connected_area = null
	var/other_area 		= null
	var/image/overlay

/obj/machinery/light_switch/New(loc, dir, atom/frame)
	..(loc)
	if(dir)
		src.set_dir(dir)
	if(istype(frame))
		on = FALSE
		frame.transfer_fingerprints_to(src)
	ADD_SAVED_VAR(on)
	ADD_SAVED_VAR(other_area)

/obj/machinery/light_switch/before_save()
	. = ..()
	if(connected_area && !other_area)
		other_area = connected_area.name

/obj/machinery/light_switch/Initialize()
	. = ..()
	if(other_area)
		src.connected_area = locate(other_area)
	else
		src.connected_area = get_area(src)
	if(name == initial(name))
		name = "light switch ([connected_area.name])"

	if(!isnull(connected_area))
		connected_area.set_lightswitch(on)
	update_icon()

/obj/machinery/light_switch/update_icon()
	switch(dir)
		if(NORTH)
			src.pixel_x = 0
			src.pixel_y = -22
		if(SOUTH)
			src.pixel_x = 0
			src.pixel_y = 30
		if(EAST)
			src.pixel_x = 22
			src.pixel_y = 0
		if(WEST)
			src.pixel_x = -22
			src.pixel_y = 0

	if(!overlay)
		overlay = image(icon, "light1-overlay")
		overlay.plane = EFFECTS_ABOVE_LIGHTING_PLANE
		overlay.layer = ABOVE_LIGHTING_LAYER

	overlays.Cut()
	if(inoperable())
		icon_state = "light-p"
		set_light(0)
	else
		icon_state = "light[on]"
		overlay.icon_state = "light[on]-overlay"
		overlays += overlay
		set_light(2, 0.3, on ? "#82ff4c" : "#f86060")

/obj/machinery/light_switch/examine(mob/user)
	if(..(user, 1))
		to_chat(user, "A light switch. It is [on? "on" : "off"].")

/obj/machinery/light_switch/proc/set_state(var/newstate)
	if(on != newstate)
		on = newstate
		connected_area.set_lightswitch(on)
		update_icon()

/obj/machinery/light_switch/proc/sync_state()
	if(connected_area && on != connected_area.lightswitch)
		on = connected_area.lightswitch
		update_icon()
		return 1

/obj/machinery/light_switch/attack_hand(mob/user)
	playsound(src, "switch", 30)
	set_state(!on)
	use_power(active_power_usage)

/obj/machinery/light_switch/powered()
	. = ..(power_channel, connected_area) //tie our powered status to the connected area

/obj/machinery/light_switch/power_change()
	. = ..()
	//synch ourselves to the new state
	if(connected_area) //If an APC initializes before we do it will force a power_change() before we can get our connected area
		sync_state()

/obj/machinery/light_switch/emp_act(severity)
	if(inoperable())
		..(severity)
		return
	power_change()
	..(severity)

/obj/machinery/light_switch/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	if(istype(W, /obj/item/device/reagent_scanner))
		return FALSE
	if(isWrench(W))
		to_chat(user, SPAN_NOTICE("You detach \the [src] from the wall."))
		dismantle()
		return TRUE
	return src.attack_hand(user)
