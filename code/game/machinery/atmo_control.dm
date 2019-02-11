
//
//	General Air Control
//
/obj/machinery/computer/general_air_control
	name = "Sensor Console"
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "atmos_key"
	icon_screen = "tank"
	var/id_tag
	var/list/sensors = list()
	var/list/sensor_information = list()
	circuit = /obj/item/weapon/circuitboard/air_management

/obj/machinery/computer/general_air_control/New()
	..()
	ADD_SAVED_VAR(id_tag)

/obj/machinery/computer/general_air_control/Initialize()
	. = ..()
	init_radio()

/obj/machinery/computer/general_air_control/proc/init_radio()
	if(!map_storage_loaded)
		create_transmitter(src.id_tag, ATMOS_CONTROL_FREQ, RADIO_ATMOSIA)

/obj/machinery/computer/general_air_control/attack_ai(mob/user)
	. = ..()
	return attack_hand(user)

/obj/machinery/computer/general_air_control/attack_ghost(mob/ghost)
	. = ..()
	return attack_hand(ghost)

/obj/machinery/computer/general_air_control/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/master_ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data[0]
	data = write_sensor_data()
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "general_air_control.tmpl", src.name, 512, 512, master_ui = master_ui, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)

/obj/machinery/computer/general_air_control/proc/write_sensor_data(var/list/data = list())
	var/list/info = list()
	for(var/S in sensors)
		var/list/curinfo =  sensor_information[S]
		var/outputtext
		if(curinfo.len < 1)
			continue
		if(curinfo["pressure"])
			outputtext += "<DIV class='itemLabel'>Pressure: </DIV><DIV class='itemContent'>[curinfo["pressure"]] Kpa</DIV>"
		if(curinfo["temperature"])
			outputtext += "<DIV class='itemLabel'>Temperature: </DIV><DIV class='itemContent'>[curinfo["temperature"]] K</DIV>"

		//Copy gases
		for(var/G in curinfo)
			if(G == "pressure" || G == "temperature" || G == "sigtype")
				continue
			outputtext += "<DIV class='itemLabel'>[G]: </DIV><DIV class='itemContent'>[curinfo[G]]%</DIV>"
		testing("[src]\ref[src]: [outputtext]")
		info[S] = outputtext
	data["info"] = info
	return data

/obj/machinery/computer/general_air_control/receive_signal(datum/signal/signal)
	if(!signal || !has_transmitter())
		return
	var/sensortag = signal_target_id(signal)
	if(!sensors.Find(sensortag))
		return
	sensor_information[sensortag] = signal.data

//
//	Large Tank Control
//
/obj/machinery/computer/general_air_control/large_tank_control
	name = "Tank Control Computer"
	icon = 'icons/obj/computer.dmi'
	var/input_tag
	var/output_tag

	var/list/input_info
	var/list/output_info

	var/input_flow_setting = 200
	var/pressure_setting = ONE_ATMOSPHERE * 45
	circuit = /obj/item/weapon/circuitboard/air_management/tank_control

/obj/machinery/computer/general_air_control/large_tank_control/proc/refreshio()
	post_signal(list("status" = 1), null, input_tag)
	post_signal(list("status" = 1), null, output_tag)

/obj/machinery/computer/general_air_control/large_tank_control/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/master_ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data[0]
	refreshio()
	data = write_sensor_data(data)
	data["inputConnected"] = input_info? TRUE : FALSE
	if(input_info)
		data["inputState"] = input_info["power"]
		data["inputFlowRate"] = round(input_info["volume_rate"], 0.1)

	data["outputConnected"] = output_info? TRUE : FALSE
	if(output_info)
		data["outputState"] = output_info["power"]
		data["outputPumpDir"] = output_info["direction"]
		data["outputPressure"] = output_info["internal"]

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "large_tank_control.tmpl", src.name, 512, 512, master_ui = master_ui, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)

/obj/machinery/computer/general_air_control/large_tank_control/receive_signal(datum/signal/signal)
	..()
	var/id_tag = signal_target_id(signal)
	if(input_tag == id_tag)
		testing("[src]\ref[src] got input message size:[signal.data.len]")
		signal.debug_print()
		input_info = signal.data.Copy()
	else if(output_tag == id_tag)
		testing("[src]\ref[src] got output message size:[signal.data.len]")
		signal.debug_print()
		output_info = signal.data.Copy()

/obj/machinery/computer/general_air_control/large_tank_control/OnTopic(mob/user, href_list, datum/topic_state/state)
	if(..())
		return 1

	if(href_list["adj_pressure"])
		var/new_pressure = input(usr,"Enter new output pressure (0-[MAX_PUMP_PRESSURE]kPa)","Pressure control",src.pressure_setting) as num
		pressure_setting = between(0, new_pressure, MAX_PUMP_PRESSURE)
		src.updateUsrDialog()
		return 1

	if(href_list["adj_input_flow_rate"])
		var/change = text2num(href_list["adj_input_flow_rate"])
		input_flow_setting = between(0, input_flow_setting + change, ATMOS_DEFAULT_VOLUME_PUMP + 500) //default flow rate limit for air injectors
		src.updateUsrDialog()
		return 1

	if(!has_transmitter())
		return 0
	var/list/data[0]
	var/target = ""
	if(href_list["in_refresh_status"])
		input_info = null
		data = list ("status" = 1)
		target = input_tag
		testing("LTC input refresh \ref[src], target:[target]")
		. = TOPIC_REFRESH

	if(href_list["in_toggle_injector"])
		input_info = null
		data = list ("power_toggle" = 1)
		target = input_tag
		. = TOPIC_REFRESH

	if(href_list["in_set_flowrate"])
		input_info = null
		data = list ("set_volume_rate" = "[input_flow_setting]")
		target = input_tag
		. = TOPIC_REFRESH

	if(href_list["out_refresh_status"])
		output_info = null
		data = list ("status" = 1)
		target = output_tag
		testing("LTC output refresh \ref[src], target:[target]")
		. = TOPIC_REFRESH

	if(href_list["out_toggle_power"])
		output_info = null
		data = list ("power_toggle" = 1, "checks" = 3)
		target = output_tag
		. = TOPIC_REFRESH

	if(href_list["out_toggle_dir"])
		output_info = null
		data = list ("direction_toggle" = 1, "checks" = 3)
		target = output_tag
		. = TOPIC_REFRESH

	if(href_list["out_set_pressure"])
		output_info = null
		data = list ("set_internal_pressure" = "[pressure_setting]", "checks" = 3)
		target = output_tag
		. = TOPIC_REFRESH

	data["sigtype"]="command"
	post_signal(data, null, target)
	return .

//
//	Supermatter Core Control
//
/obj/machinery/computer/general_air_control/large_tank_control/supermatter_core
	name = "Supermatter Core Control Console"
	icon = 'icons/obj/computer.dmi'
	input_flow_setting = 700
	pressure_setting = 100
	circuit = /obj/item/weapon/circuitboard/air_management/supermatter_core

/obj/machinery/computer/general_air_control/large_tank_control/supermatter_core/init_radio()
	if(!map_storage_loaded)
		create_transmitter(src.id_tag, ENGINE_FREQ, RADIO_ENGI)

//
//	Fuel Injection Control
//
/obj/machinery/computer/general_air_control/fuel_injection
	name = "Fuel Injection Control Console"
	icon = 'icons/obj/computer.dmi'
	icon_screen = "alert:0"

	var/device_tag
	var/list/device_info

	var/automation = FALSE

	var/cutoff_temperature = 2000
	var/on_temperature = 1200
	circuit = /obj/item/weapon/circuitboard/air_management/injector_control

/obj/machinery/computer/general_air_control/fuel_injection/init_radio()
	if(!map_storage_loaded)
		create_transmitter(src.id_tag, ENGINE_FREQ, RADIO_ENGI)

/obj/machinery/computer/general_air_control/fuel_injection/Process()
	..()
	if(inoperable() || !has_transmitter() || !transmitter_ready())
		return
	if(automation)
		var/injecting = FALSE
		for(var/id_tag in sensor_information)
			var/list/data = sensor_information[id_tag]
			if(data["temperature"])
				if(data["temperature"] >= cutoff_temperature)
					injecting = FALSE
					break
				if(data["temperature"] <= on_temperature)
					injecting = TRUE
		post_signal(list(
			"tag" = device_tag,
			"power" = injecting,
			"sigtype"="command"
		))

/obj/machinery/computer/general_air_control/fuel_injection/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data[0]
	data = write_sensor_data(data)
	data["deviceConnected"] = device_info? TRUE : FALSE
	data["automation"] = automation? TRUE : FALSE
	if(device_info)
		data["inputState"] = device_info["power"]
		data["inputFlowRate"] = round(device_info["volume_rate"], 0.1)

	data["cutoff_temperature"] = cutoff_temperature
	data["on_temperature"] = on_temperature

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "fuel_injection_control.tmpl", src.name, 512, 512, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)

/obj/machinery/computer/general_air_control/fuel_injection/receive_signal(datum/signal/signal)
	..()
	var/id_tag = signal_target_id(signal)
	if(device_tag == id_tag)
		device_info = signal.data

/obj/machinery/computer/general_air_control/fuel_injection/OnTopic(mob/user, href_list, datum/topic_state/state)
	if((. = ..()))
		return .

	if(href_list["refresh_status"])
		device_info = null
		if(!has_transmitter())
			return TOPIC_NOACTION
		post_signal(list(
			"tag" = device_tag,
			"status" = 1,
			"sigtype"="command"
		))

	if(href_list["toggle_automation"])
		automation = !automation

	if(href_list["toggle_injector"])
		device_info = null
		if(!has_transmitter())
			return TOPIC_NOACTION
		post_signal(list(
			"tag" = device_tag,
			"power_toggle" = 1,
			"sigtype"="command"
		))

	if(href_list["injection"])
		if(!has_transmitter())
			return TOPIC_NOACTION
		post_signal(list(
			"tag" = device_tag,
			"inject" = 1,
			"sigtype"="command"
		))
	return TOPIC_REFRESH




