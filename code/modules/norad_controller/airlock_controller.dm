//Just like the airlock controllers, except it doesn't use radio, and actually works.

/obj/machinery/airlock_controller_norad
	name = "Airlock Controller"
	desc = "A controller for automatic air cycling."
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_control_standby"

	var/type_frame = /obj/item/frame/airlock_controller_norad

	var/list/memory = new()
	var/list/components = new()

	var/obj/machinery/door/airlock/tag_exterior_door
	var/obj/machinery/door/airlock/tag_interior_door
	var/obj/machinery/atmospherics/unary/vent_pump/tag_airpump
	var/obj/machinery/atmospherics/unary/vent_scrubber/tag_scrubber
	var/obj/machinery/atmospherics/unary/vent_scrubber/tag_scrubber_secondary
	var/obj/machinery/airlock_sensor_norad/tag_exterior_sensor
	var/obj/machinery/airlock_sensor_norad/tag_interior_sensor
	var/tag_secure = 0

	var/state_current = NORAD_STATE_IDLE
	var/state_target = NORAD_STATE_IDLE
	var/last_cycle_type = NORAD_TARGET_INOPEN

	var/cycle_to_external_air = 0

	var/safety_lock = 1           // You can only crowbar it off if safety is off by accessing the UI.

/obj/machinery/airlock_controller_norad/New(location, ndir, source)
	..()
	memory["chamber_sensor_pressure"] = ONE_ATMOSPHERE
	memory["external_sensor_pressure"] = 0					//assume vacuum for simple airlock controller
	memory["internal_sensor_pressure"] = ONE_ATMOSPHERE
	memory["exterior_status"] = list(state = "closed", lock = "locked")		//assume closed and locked in case the doors dont report in
	memory["interior_status"] = list(state = "closed", lock = "locked")
	memory["pump_status"] = "unknown"
	memory["target_pressure"] = ONE_ATMOSPHERE
	memory["purge"] = 0
	memory["secure"] = 0
	memory["processing"] = state_current

	set_dir(ndir)

/obj/machinery/airlock_controller_norad/Initialize()
	..()
	after_load()

/obj/machinery/airlock_controller_norad/after_load()
	pixel_x = (src.dir & 3)? 0 : (src.dir == 4 ? -30 : 30)
	pixel_y = (src.dir & 3)? (src.dir ==1 ? -30 : 30) : 0

/obj/machinery/airlock_controller_norad/CanUseTopic(var/mob/user)
	if(!allowed(user))
		return min(STATUS_UPDATE, ..())
	else
		return ..()

/obj/machinery/airlock_controller_norad/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/nano_ui/master_ui = null, var/datum/topic_state/state = GLOB.default_state)

	var/err = check_for_errors()
	if (err)
		to_chat(user, "<span class='warning'>Error: [err]</span>")
		return

	memory["processing"] = state_current
	var/data[0]
	data = list(
		"chamber_pressure" = round(memory["chamber_sensor_pressure"]),
		"external_pressure" = round(memory["external_sensor_pressure"]),
		"internal_pressure" = round(memory["internal_sensor_pressure"]),
		"processing" = memory["processing"],
		"is_siphon" = (state_target == NORAD_TARGET_OUTOPEN),
		"purge" = memory["purge"],
		"secure" = safety_lock
	)

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "advanced_airlock_console_norad.tmpl", name, 480, 290, state = state)

		ui.set_initial_data(data)

		ui.open()

		ui.set_auto_update(1)

/obj/machinery/airlock_controller_norad/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)
	src.add_fingerprint(usr)

	var/clean
	switch(href_list["command"])
		if("cycle_ext")
			clean = 1
			cycle_air("ext")
		if("cycle_int")
			clean = 1
			cycle_air("int")
		if("force_ext")
			clean = 1
			cycle_doors("ext")
		if("force_int")
			clean = 1
			cycle_doors("int")
		if("abort")
			clean = 1
			state_current = NORAD_STATE_IDLE
			state_target = NORAD_STATE_IDLE
			memory["purge"] = 0
			reset_atmos()
		if("purge")
			clean = 1
			memory["purge"] = !memory["purge"]
			if (memory["purge"])
				tag_airpump.use_power = 1
				tag_airpump.pump_direction = 0

				tag_airpump.external_pressure_bound = 0
				tag_airpump.internal_pressure_bound = MAX_PUMP_PRESSURE
				tag_airpump.pressure_checks = 2
			else
				tag_airpump.pump_direction = 1

				tag_airpump.external_pressure_bound = tag_airpump.external_pressure_bound_default
				tag_airpump.internal_pressure_bound = tag_airpump.internal_pressure_bound_default
				tag_airpump.pressure_checks = tag_airpump.pressure_checks_default
			tag_airpump.update_icon()
		if("secure")
			clean = 1
			safety_lock = !safety_lock

	if (!clean)
		return


	return 1

/obj/machinery/airlock_controller_norad/Process()
	..()
	if (state_current != state_target)
		state_current = NORAD_STATE_PREPARE
	if (state_current == NORAD_STATE_IDLE || check_for_errors())
		return

	var/datum/gas_mixture/air_chamber = return_air()
	var/current_pressure = round(air_chamber.return_pressure(),0.1)
	// Updates current pressure.
	memory["chamber_sensor_pressure"] = current_pressure
	memory["external_sensor_pressure"] = get_pressure("ext")
	memory["internal_sensor_pressure"] = get_pressure("int")

	var/target_pressure
	if (state_target == NORAD_TARGET_INOPEN)
		target_pressure = get_pressure("int")
	else if (state_target == NORAD_TARGET_OUTOPEN)
		target_pressure = get_pressure("ext")

	if (target_pressure > current_pressure)
		vent("to_chamber", target_pressure)
	if (target_pressure < current_pressure)
		vent("from_chamber", target_pressure)
	if (target_pressure -2 < current_pressure && current_pressure < target_pressure +2) // Hardcoded pressure tolerance of -/+2 (4kPa difference max)
		state_current = state_target
	if (state_current == state_target) //finish the process, open the door,
		cycle_doors()
		memory["purge"] = 0
		state_current = NORAD_STATE_IDLE
		last_cycle_type = state_target
		state_target = state_current
		reset_atmos()

/obj/machinery/airlock_controller_norad/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if (isCrowbar(O) && !safety_lock)
		//PUT SOUND HERE... LATA.
		new type_frame (loc)
		for (var/obj/i in components)
			i.loc = src.loc
		qdel(src)
	else if (isMultitool(O))
		var/obj/item/device/multitool/mt = O
		if (!mt.buffer_object)
			mt.set_buffer(src)
			to_chat(user, "<span class='notice'>You add \the [src] to the buffer. </span>")
			if (!mt.buffer_object)
				to_chat(user, "<span class='warning'>ERROR: PLEASE REPORT TO THE DEVS. (buffer object not set to multitool from airlock_controller_norad)</span>")
		else
			mt.unregister_buffer(mt.get_buffer())
			to_chat(user, "<span class='notice'>You flush the buffer from your [mt]. </span>")
	else
		..()

/obj/machinery/airlock_controller_norad/attack_hand(mob/user as mob)
	if(!user.IsAdvancedToolUser())
		return 0
	src.ui_interact(user)

/obj/machinery/airlock_controller_norad/proc/check_for_errors()
	if ( tag_exterior_door && tag_interior_door && tag_airpump && (tag_scrubber || tag_scrubber_secondary) && tag_interior_sensor)
		return
	var/list/devices = new()

	if (!tag_exterior_door || QDELETED(tag_exterior_door))
		tag_exterior_door = null
		devices += "exterior airlock"
	if (!tag_interior_door || QDELETED(tag_interior_door))
		tag_interior_door = null
		devices += "interior airlock"
	if (!tag_airpump || QDELETED(tag_airpump))
		tag_airpump = null
		devices += "air vent"
	if (!tag_scrubber || QDELETED(tag_scrubber))
		tag_scrubber = null
		devices += "scrubber"
	if (!tag_interior_sensor || QDELETED(tag_interior_sensor))
		tag_interior_sensor = null
		devices += "interior sensor"

	var/output = null
	if (devices.len >= 1)
		output = "Missing device ("
		var/first = 1
		for(var/str in devices)
			if (first)
				first = 0
				output += str
			else
				output += ", " + str
		output += ")"
	return output

/obj/machinery/airlock_controller_norad/proc/vent(var/stat, var/pressure)
	reset_atmos()
	if (!tag_scrubber.use_power || !tag_airpump.use_power)
		tag_scrubber.use_power = 1
		if (tag_scrubber_secondary) tag_scrubber_secondary.use_power = 1
		tag_airpump.use_power = 1
		if (stat == "from_chamber")
			tag_scrubber.scrubbing = 0
			if (tag_scrubber_secondary) tag_scrubber_secondary.scrubbing = 0
		if (stat == "to_chamber")
			tag_scrubber.scrubbing = 1
			if (tag_scrubber_secondary) tag_scrubber_secondary.scrubbing = 1

		tag_scrubber.update_icon()
		if (tag_scrubber_secondary) tag_scrubber_secondary.update_icon()
		tag_airpump.update_icon()
		tag_airpump.external_pressure_bound = pressure

/obj/machinery/airlock_controller_norad/proc/reset_atmos()
	tag_scrubber.scrubbing = 1
	tag_scrubber.use_power = 0
	tag_scrubber.update_icon()
	if(tag_scrubber_secondary)
		tag_scrubber_secondary.scrubbing = 1
		tag_scrubber_secondary.use_power = 0
		tag_scrubber_secondary.update_icon()

	tag_airpump.pump_direction = 1
	tag_airpump.internal_pressure_bound = tag_airpump.internal_pressure_bound_default
	tag_airpump.pressure_checks = tag_airpump.pressure_checks_default
	tag_airpump.external_pressure_bound = ONE_ATMOSPHERE
	tag_airpump.use_power = 0
	tag_airpump.update_icon()

/obj/machinery/airlock_controller_norad/proc/cycle_air(var/target)
	if (!target || target == "cycle")
		if (last_cycle_type == NORAD_TARGET_INOPEN)
			state_target = NORAD_TARGET_OUTOPEN
		else if (last_cycle_type == NORAD_TARGET_OUTOPEN)
			state_target = NORAD_TARGET_INOPEN
	else if (target == "ext")
		state_target = NORAD_TARGET_OUTOPEN
	else if (target == "int")
		memory["purge"] = 0
		state_target = NORAD_TARGET_INOPEN

	tag_interior_door.locked = 0
	tag_exterior_door.locked = 0
	tag_interior_door.close()
	tag_exterior_door.close()
	tag_interior_door.locked = 1
	tag_exterior_door.locked = 1

	if (!tag_exterior_door.density || !tag_interior_door.density) //if any of the doors remains open, we won't initiate the process.
		state_target = state_current

/obj/machinery/airlock_controller_norad/proc/cycle_doors(var/door)
	if (door) //specific door toggle
		var/door_state
		if (door == "int")
			door_state = tag_interior_door.density
			if (door_state)
				tag_interior_door.locked = 0
				tag_interior_door.open()
			else
				tag_interior_door.close()
				tag_interior_door.locked = 1
		if (door == "ext")
			door_state = tag_exterior_door.density
			if (door_state)
				tag_exterior_door.locked = 0
				tag_exterior_door.open()
			else
				tag_exterior_door.close()
				tag_exterior_door.locked = 1
		return
	else
		if (state_target == NORAD_TARGET_INOPEN)
			tag_interior_door.locked = 0
			tag_interior_door.open()
		if (state_target == NORAD_TARGET_OUTOPEN)
			tag_exterior_door.locked = 0
			tag_exterior_door.open()

/obj/machinery/airlock_controller_norad/proc/get_pressure(var/target)
	var/pressure = 0
	var/datum/gas_mixture/air_interior
	var/datum/gas_mixture/air_exterior

	if (tag_interior_sensor)
		air_interior = tag_interior_sensor.return_air()
	if (tag_exterior_sensor)
		air_exterior = tag_exterior_sensor.return_air()

	if (target == "int" && air_interior) // interior sensor is MUST.
		pressure = round(air_interior.return_pressure(), 0.1)
	if (target == "ext" && tag_exterior_sensor && air_exterior) //if no exterior sensor, it'll act as if target pressure is 0kpa.
		pressure = round(air_exterior.return_pressure(), 0.1)
	return pressure
