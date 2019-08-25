/* ----------------------------------------------------------------------------------------------------------------------------------------------------- */
/obj/machinery/airlock_sensor_norad
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_sensor_off"
	name = "airlock sensor"
	desc = "It also works as a button."

	anchored = 1
	power_channel = ENVIRON

	var/obj/machinery/airlock_controller_norad/controller
	var/sensor_type = "cycle"

	var/list/components = new()

	var/type_frame = /obj/item/frame/airlock_sensor_norad

	var/on = 1
	var/alert = 0
	var/previousPressure

	var/norad_UID

/obj/machinery/airlock_sensor_norad/New(location, ndir, source)
	set_dir(ndir)
	after_load()

/obj/machinery/airlock_sensor_norad/Initialize()
	. = ..()
	after_load()

/obj/machinery/airlock_sensor_norad/after_load()
	pixel_x = (src.dir & 3)? 0 : (src.dir == 4 ? -30 : 30)
	pixel_y = (src.dir & 3)? (src.dir ==1 ? -30 : 30) : 0

/obj/machinery/airlock_sensor_norad/Destroy()
	return ..()

/obj/machinery/airlock_sensor_norad/update_icon()
	if(on)
		if(alert)
			icon_state = "airlock_sensor_alert"
		else
			icon_state = "airlock_sensor_standby"
	else
		icon_state = "airlock_sensor_off"

/obj/machinery/airlock_sensor_norad/attack_hand(mob/user)
	//force controller cycle
	if (controller && controller.state_current == NORAD_STATE_IDLE)
		if (sensor_type == "cycle")
			controller.cycle_air("cycle",user)
		else if (sensor_type == "exterior")
			controller.cycle_air("ext",user)
		else if (sensor_type == "interior")
			controller.cycle_air("int",user)
		return

	to_chat(user, "<span class='warning'>The [src] doesn't seem to be responsive.</span>")

	if (controller && controller.check_for_errors())
		if(user.a_intent == I_HURT && do_after(user, 50, src))
			if (sensor_type == "exterior")
				controller.cycle_doors("ext",user)
			else if (sensor_type == "interior")
				controller.cycle_doors("int",user)
			else
				return //might only happen if something buggy happened or the doors were badly setup somehow.
			user.visible_message( \
				"<span class='warning'>\The [user] forces the \the [src], using the emergency override.</span>", \
				"<span class='warning'>You have forced \the [src] using the emergency override.</span>", \
				"You hear a bip.")
		else
			to_chat(user, "<span class='warning'>A small label reads \"In case of emergency, forcefully pushing the sensor (Harm intent) will force open its respective airlock.\"</span>")
			to_chat(user, "<span class='warning'>\"WARNING: USING THIS EMERGENCY OVERRIDE MIGHT LEAD TO CATASTROPHIC INCIDENTS IN THE EVENT OF A BREACH OR MALFUNCTIONING AIRLOCK CYCLING SYSTEMS.\"</span>")

/obj/machinery/airlock_sensor_norad/attackby(var/obj/item/O as obj, var/mob/user as mob)
	//attackby multitool for linkage, crowbar for deconstruct
	if (isMultitool(O))
		var/obj/item/device/multitool/mt = O
		var/obj/machinery/airlock_controller_norad/link = mt.get_buffer()
		if (!istype(link) )
			return 0
		//checks if the linked airlock_controller_norad is in range.
		if (!(link in view(NORAD_MAX_RANGE) ) )
			to_chat(user, "<span class='warning'>\The [link] is too far away. Its effective range should be around [NORAD_MAX_RANGE] tiles.</span>")
			return
		//the actual (un)linkage below
		if (controller)
			to_chat(user, "<span class='warning'>You unlink \the [src] from \the [controller].</span>")
			if (controller.tag_exterior_sensor == src)
				controller.tag_exterior_sensor = null
			else if (controller.tag_interior_sensor == src)
				controller.tag_interior_sensor = null
			controller = null
			sensor_type = "cycle"
			name = initial(name)
		else
			controller = link
			sensor_type = input("Select a sensor type.","Airlock Sensor", "cycle") in list("exterior","interior")
			if (sensor_type == "exterior")
				if (controller.tag_exterior_sensor)
					sensor_type = "cycle"
				else
					controller.tag_exterior_sensor = src
			if (sensor_type == "interior")
				if (controller.tag_interior_sensor)
					sensor_type = "cycle"
				else
					controller.tag_interior_sensor = src

			name = sensor_type + " " + initial(name)
			if (sensor_type == "cycle")
				controller = null
				name = initial(name)
				to_chat(user, "<span class='warning'>You attempted to link \the [src] to \the [link], but it failed.</span>")
				return
			to_chat(user, "<span class='notice'>You link \the [src] to \the [link].</span>")
		return

	if (isCrowbar(O))
		//PUT SOUND HERE... LATA.
		new type_frame (loc)
		for (var/obj/i in components)
			i.loc = src.loc
		qdel(src)
		return
