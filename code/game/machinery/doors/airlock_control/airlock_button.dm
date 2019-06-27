/obj/machinery/access_button
	name = "access button"
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "access_button_standby"
	anchored 		= TRUE
	density 		= FALSE
	power_channel 	= ENVIRON
	use_power 		= POWER_USE_IDLE
	idle_power_usage = 2

	//Radio
	id_tag 			= null
	frequency 		= AIRLOCK_FREQ
	range 			= AIRLOCK_CONTROL_RANGE
	radio_filter_in = RADIO_AIRLOCK
	radio_filter_out= RADIO_AIRLOCK
	var/command 	= "cycle"

/obj/machinery/access_button/airlock_interior
	frequency = AIRLOCK_FREQ
	command = "cycle_interior"

/obj/machinery/access_button/airlock_exterior
	frequency = AIRLOCK_FREQ
	command = "cycle_exterior"

/obj/machinery/access_button/New()
	..()
	ADD_SAVED_VAR(master_tag)

/obj/machinery/access_button/Initialize()
	. = ..()
	update_icon()

/obj/machinery/access_button/update_icon()
	switch(dir)
		if(NORTH)
			src.pixel_x = 0
			src.pixel_y = -24
		if(SOUTH)
			src.pixel_x = 0
			src.pixel_y = 24
		if(EAST)
			src.pixel_x = -24
			src.pixel_y = 0
		if(WEST)
			src.pixel_x = 24
			src.pixel_y = 0
	if(operable() && ison())
		icon_state = "access_button_standby"
	else
		icon_state = "access_button_off"

/obj/machinery/access_button/attackby(obj/item/I as obj, mob/user as mob)
	//Swiping ID on the access button
	if (istype(I, /obj/item/weapon/card/id) || istype(I, /obj/item/modular_computer/pda))
		attack_hand(user)
		return
	return ..()

/obj/machinery/access_button/attack_hand(mob/user)
	if(inoperable())
		return FALSE
	add_fingerprint(usr)
	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Access Denied"))
	else if(has_transmitter())
		post_signal(list("command" = command))
	flick("access_button_cycle", src)
