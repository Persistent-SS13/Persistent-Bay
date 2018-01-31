
/datum/computer_file/program/faction_core
	filename = "faction_core"
	filedesc = ""
	program_icon_state = "comm"
	program_menu_icon = "flag"
	nanomodule_path = /datum/nano_module/program/faction_core
	extended_desc = "Uses a Logistic Processor to connect to and modify bluespace networks over satalite."
	required_access = access_heads
	requires_ntnet = 0
	size = 65
	usage_flags = PROGRAM_CONSOLE
	var/datum/world_faction/connected_faction
	var/connected = 0
	var/faction_uid = ""
	var/faction_password = ""
	var/attempted_password = ""
	var/authenticated = 0
	var/menu = 1 // 1 = connect to network 2 = login screen 3 = main directory
/datum/computer_file/program/faction_core/proc/try_connect()
	if(connected_faction)
		if(connected_faction.uid != faction_uid || connected_faction.password != faction_password)
			connected = 1
			return
		else
			connected = 0
			connected_faction = null
			return
	else
		connected_faction = get_faction(faction_uid)
		if(connected_faction)
			if(connected_faction.password != faction_password)
				connected = 0
				connected_faction = null
				return
			connected = 1
			return
		return
		
/datum/computer_file/program/faction_core/Topic(href, href_list)
	if(..())
		return 1
	if(!computer.logistic_processor || !computer.logistic_processor.check_functionality()) return 1
/datum/nano_module/program/faction_core
	name = "Core Logistics Program"
	available_to_ai = TRUE
	var/datum/world_faction/connected_faction
	var/connected = 0
	var/faction_uid = ""
	var/faction_password = ""
	var/attempted_password = ""
	var/authenticated = 0
	var/menu = 1 // 1 = connect to network 2 = login screen 3 = main directory

/datum/nano_module/program/faction_core/New()
	..()

/datum/nano_module/program/faction_core/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)

	var/list/data = host.initial_data()
	var/log_status = 1
	if(!program.computer.logistic_processor || !program.computer.logistic_processor.check_functionality()) log_status = 0
	data["has_log"] = log_status
	if(connected_faction)
		data["emagged"] = program.computer_emagged
		data["net_comms"] = !!program.get_signal(NTNET_COMMUNICATION) //Double !! is needed to get 1 or 0 answer
		data["net_syscont"] = !!program.get_signal(NTNET_SYSTEMCONTROL)
		if(program.computer)
			data["have_printer"] = !!program.computer.nano_printer
		else
			data["have_printer"] = 0


	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "communication.tmpl", name, 550, 420, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/faction_core/proc/is_autenthicated(var/mob/user)
	if(program)
		return program.can_run(user)
	return 1
/datum/nano_module/program/faction_core/Topic(href, href_list)
	if(..())
		return 1
