////////////////////////////////////////
//CONTAINS: Air Alarms and Fire Alarms//
////////////////////////////////////////

#define AALARM_MODE_SCRUBBING   1
#define AALARM_MODE_REPLACEMENT 2 //like scrubbing, but faster.
#define AALARM_MODE_PANIC       3 //constantly sucks all air
#define AALARM_MODE_CYCLE       4 //sucks off all air, then refill and switches to scrubbing
#define AALARM_MODE_FILL        5 //emergency fill
#define AALARM_MODE_OFF         6 //Shuts it all down.
#define AALARM_MODE_EXCHANGE    7 //Like scrubbing, but handles oxygen rarification

#define AALARM_SCREEN_MAIN       1
#define AALARM_SCREEN_VENT       2
#define AALARM_SCREEN_SCRUB      3
#define AALARM_SCREEN_MODE       4
#define AALARM_SCREEN_SENSORS    5
#define AALARM_SCREEN_ADV_FILTER 6	//Screen for adding specific gases to specific scrubbers

#define AALARM_REPORT_TIMEOUT 100

#define RCON_NO		1
#define RCON_AUTO	2
#define RCON_YES	3

#define MAX_TEMPERATURE 90
#define MIN_TEMPERATURE -40

//all air alarms in area are connected via magic
/area
	var/obj/machinery/alarm/master_air_alarm
	var/list/air_vent_names = list()
	var/list/air_scrub_names = list()
	var/list/air_vent_info = list()
	var/list/air_scrub_info = list()

/obj/machinery/alarm
	name 				= "alarm"
	icon 				= 'icons/obj/monitors.dmi'
	icon_state 			= "alarm0"
	anchored 			= TRUE
	idle_power_usage 	= 80
	active_power_usage 	= 1 KILOWATTS //For heating/cooling rooms. 1000 joules equates to about 1 degree every 2 seconds for a single tile of air.
	power_channel 		= ENVIRON
	req_one_access 		= list(core_access_engineering_programs)
	clicksound 			= "button"
	clickvol 			= 30
	layer 				= ABOVE_WINDOW_LAYER
	
	id_tag 				= null
	frequency			= AIRALARM_FREQ
	radio_filter_in		= RADIO_TO_AIRALARM
	radio_filter_out	= RADIO_FROM_AIRALARM
	radio_check_id		= FALSE

	var/breach_detection = TRUE // Whether to use automatic breach detection or not
	var/remote_control = 0
	var/rcon_setting = 2
	var/rcon_time = 0
	var/locked = TRUE
	var/wiresexposed = FALSE // If it's been screwdrivered open.
	var/aidisabled = FALSE
	var/shorted = FALSE

	var/datum/wires/alarm/wires

	var/mode = AALARM_MODE_EXCHANGE
	var/screen = AALARM_SCREEN_MAIN
	var/area_uid
	var/area/alarm_area
	var/buildstage = 2 //2 is built, 1 is building, 0 is frame.

	var/target_temperature = T0C+20
	var/regulating_temperature = FALSE

	var/list/TLV = list()
	var/list/trace_gas = list() //list of other gases that this air alarm is able to detect

	var/danger_level = 0
	var/pressure_dangerlevel = 0
	var/oxygen_dangerlevel = 0
	var/co2_dangerlevel = 0
	var/co_dangerlevel = 0 
	var/temperature_dangerlevel = 0
	var/other_dangerlevel = 0

	var/report_danger_level = TRUE

	//
	var/filter_tweak_scrubber = null //The selected scrubber for editing advanced filter settings

/obj/machinery/alarm/cold
	target_temperature = T0C+4

/obj/machinery/alarm/nobreach
	breach_detection = FALSE

/obj/machinery/alarm/monitor
	report_danger_level = FALSE
	breach_detection = FALSE

/obj/machinery/alarm/server/New()
	..()
	req_access = list(core_access_science_programs, core_access_engineering_programs, core_access_engineering_programs)
	TLV["temperature"] =	list(T0C-26, T0C, T0C+30, T0C+40) // K
	target_temperature = T0C+10

/obj/machinery/alarm/Destroy()
	QDEL_NULL(wires)
	if(alarm_area && alarm_area.master_air_alarm == src)
		alarm_area.master_air_alarm = null
		elect_master(exclude_self = TRUE)
	filter_tweak_scrubber = null
	alarm_area = null
	return ..()

/obj/machinery/alarm/New(var/loc, var/dir, atom/frame)
	..(loc)

	if(dir)
		src.set_dir(dir)

	if(istype(frame))
		buildstage = 0
		wiresexposed = 1
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -21 : 21)
		pixel_y = (dir & 3)? (dir ==1 ? -21 : 21) : 0
		queue_icon_update()
		frame.transfer_fingerprints_to(src)
	
	ADD_SAVED_VAR(remote_control)
	ADD_SAVED_VAR(rcon_setting)
	ADD_SAVED_VAR(shorted)
	ADD_SAVED_VAR(wiresexposed)
	ADD_SAVED_VAR(aidisabled)
	ADD_SAVED_VAR(locked)
	ADD_SAVED_VAR(mode)
	ADD_SAVED_VAR(buildstage)
	ADD_SAVED_VAR(target_temperature)
	ADD_SAVED_VAR(TLV)
	ADD_SAVED_VAR(report_danger_level)
	ADD_SAVED_VAR(breach_detection)

/obj/machinery/alarm/after_load()
	. = ..()
	alarm_area = get_area(src)
	if(!alarm_area)
		log_debug(" /obj/machinery/alarm/after_load() : [src]\ref[src]'s area is null area after load!!")
		return
	area_uid = alarm_area.uid
	if(!TLV)
		log_warning(" obj/machinery/alarm/after_load(): TLV for [src]\ref[src] after loading was null!!")
		TLV = list()
// 	if (name == "alarm")
// 		name = "[alarm_area.name] Air Alarm"

// 	if(!wires)
// 		wires = new(src)

// 	set_frequency(frequency)
// 	if (!master_is_operating())
// 		elect_master()
// 	update_icon()

/obj/machinery/alarm/Initialize()
	. = ..()
	alarm_area = get_area(src)
	if(!alarm_area)
		log_debug(" /obj/machinery/alarm/Initialize() : Alarm is in null area on initialize!!")
		return
	area_uid = alarm_area.uid
	if (name == initial(name))
		SetName("[alarm_area.name] Air Alarm")

	if(!wires)
		wires = new(src)

	if(!TLV?.len)
		TLV[GAS_OXYGEN] =		list(16, 19, 135, 140) // Partial pressure, kpa
		TLV[GAS_CO2] = 			list(-1.0, -1.0, 5, 10) // Partial pressure, kpa
		TLV[GAS_CARBON_MONOXIDE] = list(-1.0, -1.0, 5, 10) // Partial pressure, kpa
		TLV[GAS_PHORON] =		list(-1.0, -1.0, 0.2, 0.5) // Partial pressure, kpa
		TLV["other"] =			list(-1.0, -1.0, 0.5, 1.0) // Partial pressure, kpa
		TLV["pressure"] =		list(ONE_ATMOSPHERE*0.80,ONE_ATMOSPHERE*0.90,ONE_ATMOSPHERE*1.10,ONE_ATMOSPHERE*1.20) /* kpa */
		TLV["temperature"] =	list(T0C-26, T0C, T0C+40, T0C+66) // K

	for(var/g in gas_data.gases)
		if(!(g in list(GAS_OXYGEN,GAS_NITROGEN,GAS_CO2,GAS_CARBON_MONOXIDE)))
			trace_gas += g

	if (!master_is_operating())
		elect_master()
	queue_icon_update()

/obj/machinery/alarm/Process()
	if(inoperable() || shorted || buildstage != 2 || isnull(loc))
		return

	var/turf/simulated/location = loc
	if(!istype(location))	return//returns if loc is not simulated

	var/datum/gas_mixture/environment = location.return_air()

	//Handle temperature adjustment here.
	if(environment.return_pressure() > ONE_ATMOSPHERE*0.05)
		handle_heating_cooling(environment)

	var/old_level = danger_level
	var/old_pressurelevel = pressure_dangerlevel
	danger_level = overall_danger_level(environment)

	if (old_level != danger_level)
		apply_danger_level(danger_level)

	if (old_pressurelevel != pressure_dangerlevel)
		if (breach_detected())
			mode = AALARM_MODE_OFF
			apply_mode()

	if (mode==AALARM_MODE_CYCLE && environment.return_pressure()<ONE_ATMOSPHERE*0.05)
		mode=AALARM_MODE_FILL
		apply_mode()

	//atmos computer remote controll stuff
	switch(rcon_setting)
		if(RCON_NO)
			remote_control = FALSE
		if(RCON_AUTO)
			if(danger_level == 2)
				remote_control = TRUE
			else
				remote_control = FALSE
		if(RCON_YES)
			remote_control = TRUE

	return

/obj/machinery/alarm/proc/handle_heating_cooling(var/datum/gas_mixture/environment)
	if (!regulating_temperature)
		//check for when we should start adjusting temperature
		if(!get_danger_level(target_temperature, TLV["temperature"]) && abs(environment.temperature - target_temperature) > 2.0)
			update_use_power(POWER_USE_ACTIVE)
			regulating_temperature = 1
			visible_message("\The [src] clicks as it starts [environment.temperature > target_temperature ? "cooling" : "heating"] the room.",\
			"You hear a click and a faint electronic hum.")
	else
		//check for when we should stop adjusting temperature
		if (get_danger_level(target_temperature, TLV["temperature"]) || abs(environment.temperature - target_temperature) <= 0.5)
			update_use_power(POWER_USE_IDLE)
			regulating_temperature = 0
			visible_message("\The [src] clicks quietly as it stops [environment.temperature > target_temperature ? "cooling" : "heating"] the room.",\
			"You hear a click as a faint electronic humming stops.")

	if (regulating_temperature)
		if(target_temperature > T0C + MAX_TEMPERATURE)
			target_temperature = T0C + MAX_TEMPERATURE

		if(target_temperature < T0C + MIN_TEMPERATURE)
			target_temperature = T0C + MIN_TEMPERATURE

		var/datum/gas_mixture/gas
		gas = environment.remove(0.25*environment.total_moles)
		if(gas)

			if (gas.temperature <= target_temperature)	//gas heating
				var/energy_used = min( gas.get_thermal_energy_change(target_temperature) , active_power_usage)

				gas.add_thermal_energy(energy_used)
			else	//gas cooling
				var/heat_transfer = min(abs(gas.get_thermal_energy_change(target_temperature)), active_power_usage)

				//Assume the heat is being pumped into the hull which is fixed at 20 C
				//none of this is really proper thermodynamics but whatever

				var/cop = gas.temperature/T20C	//coefficient of performance -> power used = heat_transfer/cop

				heat_transfer = min(heat_transfer, cop * active_power_usage)	//this ensures that we don't use more than active_power_usage amount of power

				heat_transfer = -gas.add_thermal_energy(-heat_transfer)	//get the actual heat transfer

			environment.merge(gas)

/obj/machinery/alarm/proc/overall_danger_level(var/datum/gas_mixture/environment)
	var/partial_pressure = R_IDEAL_GAS_EQUATION*environment.temperature/environment.volume
	var/environment_pressure = environment.return_pressure()

	var/other_moles = 0
	for(var/g in trace_gas)
		other_moles += environment.gas[g] //this is only going to be used in a partial pressure calc, so we don't need to worry about group_multiplier here.

	pressure_dangerlevel = get_danger_level(environment_pressure, TLV["pressure"])
	oxygen_dangerlevel = get_danger_level(environment.gas[GAS_OXYGEN]*partial_pressure, TLV[GAS_OXYGEN])
	co2_dangerlevel = get_danger_level(environment.gas[GAS_CO2]*partial_pressure, TLV[GAS_CO2])
	co_dangerlevel = get_danger_level(environment.gas[GAS_CARBON_MONOXIDE]*partial_pressure, TLV[GAS_CARBON_MONOXIDE])

	temperature_dangerlevel = get_danger_level(environment.temperature, TLV["temperature"])
	other_dangerlevel = get_danger_level(other_moles*partial_pressure, TLV["other"])

	return max(
		pressure_dangerlevel,
		oxygen_dangerlevel,
		co2_dangerlevel,
		co2_dangerlevel,
		other_dangerlevel,
		temperature_dangerlevel
		)

// Returns whether this air alarm thinks there is a breach, given the sensors that are available to it.
/obj/machinery/alarm/proc/breach_detected()
	var/turf/simulated/location = loc
	if(!istype(location) || !breach_detection)
		return FALSE
	var/datum/gas_mixture/environment = location.return_air()
	var/environment_pressure = environment.return_pressure()
	var/pressure_levels = TLV["pressure"]

	if (environment_pressure <= pressure_levels[1])		//low pressures
		if (!(mode == AALARM_MODE_PANIC || mode == AALARM_MODE_CYCLE))
			playsound(src.loc, 'sound/machines/airalarm.ogg', 25, 0, 4)
			return TRUE
	return FALSE

/obj/machinery/alarm/proc/master_is_operating()
	return alarm_area.master_air_alarm && alarm_area.master_air_alarm.operable()


/obj/machinery/alarm/proc/elect_master(exclude_self = FALSE)
	for (var/obj/machinery/alarm/AA in alarm_area)
		if(exclude_self && AA == src)
			continue
		if (!(AA.stat & (NOPOWER|BROKEN)))
			alarm_area.master_air_alarm = AA
			return 1
	return 0

/obj/machinery/alarm/proc/get_danger_level(var/current_value, var/list/danger_levels)
	if((current_value >= danger_levels[4] && danger_levels[4] > 0) || current_value <= danger_levels[1])
		return 2
	if((current_value >= danger_levels[3] && danger_levels[3] > 0) || current_value <= danger_levels[2])
		return 1
	return 0

/obj/machinery/alarm/on_update_icon()
	if(wiresexposed)
		icon_state = "alarmx"
		set_light(0)
		return
	if(inoperable() || shorted)
		icon_state = "alarmp"
		set_light(0)
		return

	var/icon_level = danger_level
	if (alarm_area && alarm_area.atmosalm)
		icon_level = max(icon_level, 1)	//if there's an atmos alarm but everything is okay locally, no need to go past yellow

	var/new_color = null
	switch(icon_level)
		if (0)
			icon_state = "alarm0"
			new_color = COLOR_LIME
		if (1)
			icon_state = "alarm2" //yes, alarm2 is yellow alarm
			new_color = COLOR_SUN
		if (2)
			icon_state = "alarm1"
			new_color = COLOR_RED_LIGHT

	pixel_x = 0
	pixel_y = 0
	var/turf/T = get_step(get_turf(src), turn(dir, 180))
	if(istype(T) && T.density)
		if(dir == NORTH)
			pixel_y = -21
		else if(dir == SOUTH)
			pixel_y = 21
		else if(dir == WEST)
			pixel_x = 21
		else if(dir == EAST)
			pixel_x = -21

	set_light(0.25, 0.1, 1, 2, new_color)

/obj/machinery/alarm/OnSignal(datum/signal/signal)
	. = ..()
	if(!alarm_area)
		log_warning("\"[src]\"(\ref[src]) ([x], [y], [z]): has invalid alarm area \"[alarm_area]\", and receiving a signal..")
		return 
	if (alarm_area.master_air_alarm != src)
		if (master_is_operating())
			return
		//elect_master()
		if (alarm_area.master_air_alarm != src)
			return

	if(id_tag == signal.data["alarm_id"] && signal.data["command"] == "shutdown")
		mode = AALARM_MODE_OFF
		apply_mode()
		return

	if (signal.data["area"] != area_uid)
		return
	if (signal.data["sigtype"] != "status")
		return

	var/sourceid = signal_source_id(signal)
	if (!sourceid)
		return
	var/dev_type = signal.data["device"]
	if(!(sourceid in alarm_area.air_scrub_names) && !(sourceid in alarm_area.air_vent_names))
		register_env_machine(sourceid, dev_type)
	if(dev_type == "AScr")
		alarm_area.air_scrub_info[sourceid] = signal.data
	else if(dev_type == "AVP")
		alarm_area.air_vent_info[sourceid] = signal.data


/obj/machinery/alarm/proc/register_env_machine(var/m_id, var/device_type)
	var/new_name
	if (device_type=="AVP")
		new_name = "[alarm_area.name] Vent Pump #[alarm_area.air_vent_names.len+1]"
		alarm_area.air_vent_names[m_id] = new_name
	else if (device_type=="AScr")
		new_name = "[alarm_area.name] Air Scrubber #[alarm_area.air_scrub_names.len+1]"
		alarm_area.air_scrub_names[m_id] = new_name
	else
		return
	spawn (10)
		send_signal(m_id, list("init" = new_name) )

/obj/machinery/alarm/proc/refresh_all()
	for(var/id_tag in alarm_area.air_vent_names)
		var/list/I = alarm_area.air_vent_info[id_tag]
		if (I && I["timestamp"]+AALARM_REPORT_TIMEOUT/2 > world.time)
			continue
		send_signal(id_tag, list("status") )
	for(var/id_tag in alarm_area.air_scrub_names)
		var/list/I = alarm_area.air_scrub_info[id_tag]
		if (I && I["timestamp"]+AALARM_REPORT_TIMEOUT/2 > world.time)
			continue
		send_signal(id_tag, list("status") )

/obj/machinery/alarm/proc/send_signal(var/target, var/list/command)//sends signal 'command' to 'target'. Returns 0 if no radio connection, 1 otherwise
	if(!has_transmitter())
		log_warning("[src]\ref[src] Has no transmitter instanciated and tried to send a signal!")
		return FALSE
	command["sigtype"] = "command"
	post_signal(command, RADIO_FROM_AIRALARM, target)
	return TRUE

/obj/machinery/alarm/proc/apply_mode()
	//propagate mode to other air alarms in the area
	//TODO: make it so that players can choose between applying the new mode to the room they are in (related area) vs the entire alarm area
	for (var/obj/machinery/alarm/AA in alarm_area)
		AA.mode = mode

	switch(mode)
		if(AALARM_MODE_SCRUBBING)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("power"= 1, "gas_scrub" = GAS_CO2, "gas_scrub_state"= 1, "scrubbing"= SCRUBBER_SCRUB, "panic_siphon"= 0) )
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("power"= 1, "checks"= "default", "set_external_pressure"= "default") )

		if(AALARM_MODE_EXCHANGE)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("power"= 1, "gas_scrub" = GAS_CO2, "gas_scrub_state"= 1, "scrubbing"= SCRUBBER_EXCHANGE, "panic_siphon"= 0) )
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("power"= 1, "checks"= "default", "set_external_pressure"= "default") )

		if(AALARM_MODE_PANIC, AALARM_MODE_CYCLE)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("power"= 1, "panic_siphon"= 1) )
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("power"= 0) )

		if(AALARM_MODE_REPLACEMENT)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("power"= 1, "panic_siphon"= 1) )
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("power"= 1, "checks"= "default", "set_external_pressure"= "default") )

		if(AALARM_MODE_FILL)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("power"= 0) )
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("power"= 1, "checks"= "default", "set_external_pressure"= "default") )

		if(AALARM_MODE_OFF)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("power"= 0) )
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("power"= 0) )

/obj/machinery/alarm/proc/apply_danger_level(var/new_danger_level)
	if (report_danger_level && alarm_area.atmosalert(new_danger_level, src))
		post_alert(new_danger_level)

	queue_icon_update()

/obj/machinery/alarm/proc/post_alert(alert_level)
	if(!has_transmitter())
		return FALSE
	var/list/data[0]
	data["zone"] = alarm_area.name
	data["type"] = "Atmospheric"
	data["alert"] = alert_level == 0? "clear" : (alert_level == 1? "minor" : "severe" )
	broadcast_signal(data, radio_filter_out, frequency)

/obj/machinery/alarm/attack_ai(mob/user)
	ui_interact(user)

/obj/machinery/alarm/attack_hand(mob/user)
	. = ..()
	if (.)
		return
	return interact(user)

/obj/machinery/alarm/interact(mob/user)
	ui_interact(user)
	wires.Interact(user)

/obj/machinery/alarm/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, var/master_ui = null, var/datum/topic_state/state = GLOB.default_state)
	var/data[0]
	var/remote_connection = 0
	var/remote_access = 0
	if(state)
		var/list/href = state.href_list(user)
		remote_connection = href["remote_connection"]	// Remote connection means we're non-adjacent/connecting from another computer
		remote_access = href["remote_access"]			// Remote access means we also have the privilege to alter the air alarm.

	data["locked"] = locked && !issilicon(user)
	data["remote_connection"] = remote_connection
	data["remote_access"] = remote_access
	data["rcon"] = rcon_setting
	data["screen"] = screen

	populate_status(data)

	if(!(locked && !remote_connection) || remote_access || issilicon(user))
		populate_controls(data)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "air_alarm.tmpl", src.name, 325, 625, master_ui = master_ui, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/alarm/proc/populate_status(var/data)
	var/turf/location = get_turf(src)
	var/datum/gas_mixture/environment = location.return_air()
	var/total = environment.total_moles

	var/list/environment_data = new
	data["has_environment"] = total
	if(total)
		var/pressure = environment.return_pressure()
		environment_data[++environment_data.len] = list("name" = "Pressure", "value" = pressure, "unit" = "kPa", "danger_level" = pressure_dangerlevel)
		environment_data[++environment_data.len] = list("name" = "oxygen", "value" = environment.gas[GAS_OXYGEN] / total * 100, "unit" = "%", "danger_level" = oxygen_dangerlevel)
		environment_data[++environment_data.len] = list("name" = "nitrogen", "value" = environment.gas[GAS_NITROGEN] / total * 100, "unit" = "%", "danger_level" = oxygen_dangerlevel)
		environment_data[++environment_data.len] = list("name" = "carbon dioxide", "value" = environment.gas[GAS_CO2] / total * 100, "unit" = "%", "danger_level" = co2_dangerlevel)
		environment_data[++environment_data.len] = list("name" = "carbon monoxide", "value" = environment.gas[GAS_CARBON_MONOXIDE] / total * 100, "unit" = "%", "danger_level" = co_dangerlevel)

		var/other_moles = 0
		for(var/g in trace_gas)
			other_moles += environment.gas[g]
		environment_data[++environment_data.len] = list("name" = "Other Gases", "value" = environment.gas["other_moles"] / total * 100, "unit" = "%", "danger_level" = other_dangerlevel)

		environment_data[++environment_data.len] = list("name" = "Temperature", "value" = environment.temperature, "unit" = "K ([round(environment.temperature - T0C, 0.1)]C)", "danger_level" = temperature_dangerlevel)
	data["total_danger"] = danger_level
	data["environment"] = environment_data
	data["atmos_alarm"] = alarm_area.atmosalm
	data["fire_alarm"] = alarm_area.fire != null
	data["target_temperature"] = "[target_temperature - T0C]C"

/obj/machinery/alarm/proc/populate_controls(var/list/data)
	switch(screen)
		if(AALARM_SCREEN_MAIN)
			data["mode"] = mode
		if(AALARM_SCREEN_VENT)
			var/vents[0]
			for(var/id_tag in alarm_area.air_vent_names)
				var/long_name = alarm_area.air_vent_names[id_tag]
				var/list/info = alarm_area.air_vent_info[id_tag]
				if(!info)
					continue
				vents[++vents.len] = list(
						"id_tag"	= id_tag,
						"long_name" = sanitize(long_name),
						"power"		= info["power"],
						"checks"	= info["checks"],
						"direction"	= info["direction"],
						"external"	= info["external"],
						"internal"  = info["internal"]
					)
			data["vents"] = vents
		if(AALARM_SCREEN_SCRUB)
			var/scrubbers[0]
			for(var/id_tag in alarm_area.air_scrub_names)
				var/long_name = alarm_area.air_scrub_names[id_tag]
				var/list/info = alarm_area.air_scrub_info[id_tag]
				if(!info)
					continue
				scrubbers[++scrubbers.len] = list(
						"id_tag"	= id_tag,
						"long_name" = sanitize(long_name),
						"power"		= info["power"],
						"scrubbing"	= info["scrubbing"],
						"panic"		= info["panic"],
						"filters"	= list()
					)
				scrubbers[scrubbers.len]["filters"] += list(list("name" = GAS_OXYGEN,				  "command" = "o2_scrub",	"val" = info["filter_o2"]))
				scrubbers[scrubbers.len]["filters"] += list(list("name" = GAS_NITROGEN,			  "command" = "n2_scrub",	"val" = info["filter_n2"]))
				scrubbers[scrubbers.len]["filters"] += list(list("name" = "Carbon Dioxide", 	  "command" = "co2_scrub","val" = info["filter_co2"]))
				scrubbers[scrubbers.len]["filters"] += list(list("name" = "Carbon Monoxide", 	  "command" = "gas_scrub", "val" = GAS_CARBON_MONOXIDE, "gas_scrub_state" = info["filter_co"] ))
				scrubbers[scrubbers.len]["filters"] += list(list("name" = "Toxin"	, 			  "command" = "tox_scrub","val" = info["filter_phoron"]))
				scrubbers[scrubbers.len]["filters"] += list(list("name" = "Nitrous Oxide",		  "command" = "n2o_scrub","val" = info["filter_n2o"]))
			data["scrubbers"] = scrubbers
		if(AALARM_SCREEN_MODE)
			var/modes[0]
			modes[++modes.len] = list("name" = "Filtering - Scrubs out contaminants", 			"mode" = AALARM_MODE_SCRUBBING,		"selected" = mode == AALARM_MODE_SCRUBBING, 	"danger" = 0)
			modes[++modes.len] = list("name" = "Exchanging - Exchange contaminants with air",	"mode" = AALARM_MODE_EXCHANGE,		"selected" = mode == AALARM_MODE_EXCHANGE, 	"danger" = 0)
			modes[++modes.len] = list("name" = "Replace Air - Siphons out air while replacing", "mode" = AALARM_MODE_REPLACEMENT,	"selected" = mode == AALARM_MODE_REPLACEMENT,	"danger" = 0)
			modes[++modes.len] = list("name" = "Panic - Siphons air out of the room", 			"mode" = AALARM_MODE_PANIC,			"selected" = mode == AALARM_MODE_PANIC, 		"danger" = 1)
			modes[++modes.len] = list("name" = "Cycle - Siphons air before replacing", 			"mode" = AALARM_MODE_CYCLE,			"selected" = mode == AALARM_MODE_CYCLE, 		"danger" = 1)
			modes[++modes.len] = list("name" = "Fill - Shuts off scrubbers and opens vents", 	"mode" = AALARM_MODE_FILL,			"selected" = mode == AALARM_MODE_FILL, 			"danger" = 0)
			modes[++modes.len] = list("name" = "Off - Shuts off vents and scrubbers", 			"mode" = AALARM_MODE_OFF,			"selected" = mode == AALARM_MODE_OFF, 			"danger" = 0)
			data["modes"] = modes
			data["mode"] = mode
		if(AALARM_SCREEN_SENSORS)
			var/list/selected
			var/thresholds[0]

			var/list/gas_names = list(
				GAS_OXYGEN		= "O<sub>2</sub>",
				GAS_CO2			= "CO<sub>2</sub>",
				GAS_CO			= "CO",
				GAS_PHORON		= "Toxin",
				"other"			= "Other")
			for (var/g in gas_names)
				thresholds[++thresholds.len] = list("name" = gas_names[g], "settings" = list())
				selected = TLV[g]
				for(var/i = 1, i <= 4, i++)
					thresholds[thresholds.len]["settings"] += list(list("env" = g, "val" = i, "selected" = selected[i]))

			selected = TLV["pressure"]
			thresholds[++thresholds.len] = list("name" = "Pressure", "settings" = list())
			for(var/i = 1, i <= 4, i++)
				thresholds[thresholds.len]["settings"] += list(list("env" = "pressure", "val" = i, "selected" = selected[i]))

			selected = TLV["temperature"]
			thresholds[++thresholds.len] = list("name" = "Temperature", "settings" = list())
			for(var/i = 1, i <= 4, i++)
				thresholds[thresholds.len]["settings"] += list(list("env" = "temperature", "val" = i, "selected" = selected[i]))

			data["thresholds"] 			= thresholds
			data["report_danger_level"] = report_danger_level
			data["breach_detection"] 	= breach_detection

		if(AALARM_SCREEN_ADV_FILTER)
			data["scrubber_name"] = alarm_area.air_scrub_names[filter_tweak_scrubber]
			data["scrubber_id_tag"] = filter_tweak_scrubber
			var/list/handled_gases[0]
			for(var/g in gas_data.gases)
				handled_gases[++handled_gases.len] = list("gas_id" = g, "name" = gas_data.name[g], "state" = (g in alarm_area.air_scrub_info[filter_tweak_scrubber]["filtered"]))
			data["gases_entries"] = handled_gases


/obj/machinery/alarm/CanUseTopic(var/mob/user, var/datum/topic_state/state, var/href_list = list())
	if(buildstage != 2)
		return STATUS_CLOSE

	if(aidisabled && isAI(user))
		to_chat(user, "<span class='warning'>AI control for \the [src] interface has been disabled.</span>")
		return STATUS_CLOSE

	. = shorted ? STATUS_DISABLED : STATUS_INTERACTIVE

	if(. == STATUS_INTERACTIVE)
		var/extra_href = state.href_list(user)
		// Prevent remote users from altering RCON settings unless they already have access
		if(href_list["rcon"] && extra_href["remote_connection"] && !extra_href["remote_access"])
			. = STATUS_UPDATE

	return min(..(), .)

/obj/machinery/alarm/OnTopic(user, href_list, var/datum/topic_state/state)
	// hrefs that can always be called -walter0o
	if(href_list["rcon"])
		var/attempted_rcon_setting = text2num(href_list["rcon"])

		switch(attempted_rcon_setting)
			if(RCON_NO)
				rcon_setting = RCON_NO
			if(RCON_AUTO)
				rcon_setting = RCON_AUTO
			if(RCON_YES)
				rcon_setting = RCON_YES
		return TOPIC_REFRESH

	if(href_list["temperature"])
		var/list/selected = TLV["temperature"]
		var/max_temperature = min(selected[3] - T0C, MAX_TEMPERATURE)
		var/min_temperature = max(selected[2] - T0C, MIN_TEMPERATURE)
		var/input_temperature = input(user, "What temperature would you like the system to mantain? (Capped between [min_temperature] and [max_temperature]C)", "Thermostat Controls", target_temperature - T0C) as num|null
		if(isnum(input_temperature) && CanUseTopic(user, state))
			if(input_temperature > max_temperature || input_temperature < min_temperature)
				to_chat(user, "Temperature must be between [min_temperature]C and [max_temperature]C")
			else
				target_temperature = input_temperature + T0C
		return TOPIC_HANDLED

	// hrefs that need the AA unlocked -walter0o
	var/extra_href = state.href_list(user)
	if(!(locked && !extra_href["remote_connection"]) || extra_href["remote_access"] || issilicon(user))
		if(href_list["command"])
			var/device_id = href_list["id_tag"]
			switch(href_list["command"])
				if("set_external_pressure")
					var/input_pressure = input(user, "What pressure you like the system to mantain?", "Pressure Controls") as num|null
					if(isnum(input_pressure) && CanUseTopic(user, state))
						send_signal(device_id, list(href_list["command"] = input_pressure))
					return TOPIC_HANDLED

				if("reset_external_pressure")
					send_signal(device_id, list(href_list["command"] = ONE_ATMOSPHERE))
					return TOPIC_HANDLED

				if("set_internal_pressure")
					var/input_pressure = input(user, "What pressure you like the system to mantain?", "Pressure Controls") as num|null
					if(isnum(input_pressure) && CanUseTopic(user, state))
						send_signal(device_id, list(href_list["command"] = input_pressure))
					return TOPIC_HANDLED

				if("reset_internal_pressure")
					send_signal(device_id, list(href_list["command"] = 0))
					return TOPIC_HANDLED

				if( "power",
					"direction",
					"adjust_external_pressure",
					"checks",
					"o2_scrub",
					"n2_scrub",
					"co2_scrub",
					"tox_scrub",
					"reag_scrub",
					"n2o_scrub",
					"panic_siphon")

					send_signal(device_id, list(href_list["command"] = text2num(href_list["val"]) ) )
					return TOPIC_REFRESH
				
				if("gas_scrub")
					send_signal(device_id, list(href_list["command"] = href_list["val"], "gas_scrub_state" = href_list["gas_scrub_state"] ))
					return TOPIC_REFRESH
				
				if("adv_filtering")
					filter_tweak_scrubber = href_list["id_tag"]
					screen = AALARM_SCREEN_ADV_FILTER
					return TOPIC_REFRESH

				if("scrubbing")
					testing("Sending signal scrubbing = [href_list["scrub_mode"]]")
					send_signal(device_id, list("scrubbing" = href_list["scrub_mode"]) )
					return TOPIC_HANDLED

				if("set_threshold")
					var/env = href_list["env"]
					var/threshold = text2num(href_list["var"])
					var/list/selected = TLV[env]
					var/list/thresholds = list("lower bound", "low warning", "high warning", "upper bound")
					var/newval = input(user, "Enter [thresholds[threshold]] for [env]", "Alarm triggers", selected[threshold]) as null|num
					if (isnull(newval) || !CanUseTopic(user, state))
						return TOPIC_HANDLED
					if (newval<0)
						selected[threshold] = -1.0
					else if (env=="temperature" && newval>5000)
						selected[threshold] = 5000
					else if (env=="pressure" && newval>50*ONE_ATMOSPHERE)
						selected[threshold] = 50*ONE_ATMOSPHERE
					else if (env!="temperature" && env!="pressure" && newval>200)
						selected[threshold] = 200
					else
						newval = round(newval,0.01)
						selected[threshold] = newval
					if(threshold == 1)
						if(selected[1] > selected[2])
							selected[2] = selected[1]
						if(selected[1] > selected[3])
							selected[3] = selected[1]
						if(selected[1] > selected[4])
							selected[4] = selected[1]
					if(threshold == 2)
						if(selected[1] > selected[2])
							selected[1] = selected[2]
						if(selected[2] > selected[3])
							selected[3] = selected[2]
						if(selected[2] > selected[4])
							selected[4] = selected[2]
					if(threshold == 3)
						if(selected[1] > selected[3])
							selected[1] = selected[3]
						if(selected[2] > selected[3])
							selected[2] = selected[3]
						if(selected[3] > selected[4])
							selected[4] = selected[3]
					if(threshold == 4)
						if(selected[1] > selected[4])
							selected[1] = selected[4]
						if(selected[2] > selected[4])
							selected[2] = selected[4]
						if(selected[3] > selected[4])
							selected[3] = selected[4]

					apply_mode()
					return TOPIC_HANDLED

		if(href_list["screen"])
			screen = text2num(href_list["screen"])
			return TOPIC_REFRESH

		if(href_list["atmos_unlock"])
			switch(href_list["atmos_unlock"])
				if("0")
					alarm_area.air_doors_close()
				if("1")
					alarm_area.air_doors_open()
			return TOPIC_REFRESH

		if(href_list["atmos_alarm"])
			if (alarm_area.atmosalert(2, src))
				apply_danger_level(2)
			update_icon()
			return TOPIC_REFRESH

		if(href_list["atmos_reset"])
			if (alarm_area.atmosalert(0, src))
				apply_danger_level(0)
			update_icon()
			return TOPIC_REFRESH

		if(href_list["mode"])
			mode = text2num(href_list["mode"])
			apply_mode()
			return TOPIC_HANDLED

		if(href_list["toggle_breach_detection"])
			breach_detection = !breach_detection
			return TOPIC_HANDLED

		if(href_list["toggle_report_danger_level"])
			report_danger_level = !report_danger_level
			return TOPIC_HANDLED

/obj/machinery/alarm/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)

	switch(buildstage)
		if(2)
			if(isScrewdriver(W))  // Opening that Air Alarm up.
				to_chat(user, "You pop the Air Alarm's maintence panel open.")
				wiresexposed = !wiresexposed
				to_chat(user, "The wires have been [wiresexposed ? "exposed" : "unexposed"]")
				update_icon()
				return

			if (wiresexposed && isWirecutter(W))
				user.visible_message("<span class='warning'>[user] has cut the wires inside \the [src]!</span>", "You have cut the wires inside \the [src].")
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
				new/obj/item/stack/cable_coil(get_turf(src), 5)
				buildstage = 1
				update_icon()
				return

			if (istype(W, /obj/item/weapon/card/id) || istype(W, /obj/item/modular_computer))// trying to unlock the interface with an ID card
				if(inoperable())
					to_chat(user, "It does nothing")
					return
				else
					if(allowed(usr) && !wires.IsIndexCut(AALARM_WIRE_IDSCAN))
						locked = !locked
						to_chat(user, "<span class='notice'>You [ locked ? "lock" : "unlock"] the Air Alarm interface.</span>")
					else
						to_chat(user, "<span class='warning'>Access denied.</span>")
			return

		if(1)
			if(isCoil(W))
				var/obj/item/stack/cable_coil/C = W
				if (C.use(5))
					to_chat(user, "<span class='notice'>You wire \the [src].</span>")
					buildstage = 2
					update_icon()
					return
				else
					to_chat(user, "<span class='warning'>You need 5 pieces of cable to do wire \the [src].</span>")
					return

			else if(isCrowbar(W))
				to_chat(user, "You start prying out the circuit.")
				playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
				if(do_after(user,20) && buildstage == 1)
					to_chat(user, "You pry out the circuit!")
					var/obj/item/weapon/airalarm_electronics/circuit = new /obj/item/weapon/airalarm_electronics()
					circuit.dropInto(user.loc)
					buildstage = 0
					update_icon()
				return
		if(0)
			if(istype(W, /obj/item/weapon/airalarm_electronics))
				to_chat(user, "You insert the circuit!")
				qdel(W)
				buildstage = 1
				update_icon()
				return

			else if(isWrench(W))
				to_chat(user, "You remove the fire alarm assembly from the wall!")
				new /obj/item/frame/air_alarm(get_turf(user))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
				qdel(src)

	return ..()

/obj/machinery/alarm/examine(mob/user)
	. = ..(user)
	if (buildstage < 2)
		to_chat(user, "It is not wired.")
	if (buildstage < 1)
		to_chat(user, "The circuit is missing.")
/*
AIR ALARM CIRCUIT
Just a object used in constructing air alarms
*/
/obj/item/weapon/airalarm_electronics
	name = "air alarm electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	desc = "Looks like a circuit. Probably is."
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50)


