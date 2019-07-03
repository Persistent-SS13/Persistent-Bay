/datum/computer_file/program/ntnetrouter
	filename = "ntrouter"
	filedesc = "Network Selection"
	program_icon_state = "comm_monitor"
	program_menu_icon = "wrench"
	extended_desc = "This program allows switching between bluespace networks."
	size = 1
	requires_ntnet = FALSE
	available_on_ntnet = FALSE
	usage_flags = PROGRAM_ALL
	nanomodule_path = /datum/nano_module/program/computer_ntrouter/

/datum/nano_module/program/computer_ntrouter
	name = "Network Selection"
	available_to_ai = TRUE

/datum/nano_module/program/computer_ntrouter/proc/format_networks(var/mob/user)
	var/list/found_networks = list()
	var/obj/item/weapon/card/id/id = user.GetIdCard()
	for(var/datum/world_faction/fact in GLOB.all_world_factions)
		if(fact.network)
			if(!fact.network.invisible || (fact.get_stockholder(user.real_name)) || (id && (core_access_network_linking in id.GetAccess(fact.uid))))
				found_networks |= fact.network
	var/list/formatted = list()
	for(var/datum/ntnet/network in found_networks)
		var/connected = 0
		if(program.computer.network_card.connected)
			if(network.net_uid == program.computer.network_card.connected_to)
				connected = 1
		formatted.Add(list(list(
			"display_name" = network.name,
			"net_uid" = network.net_uid,
			"secured" = network.secured,
			"connected" = connected,
			"ref" = "\ref[network]")))

	return formatted

/datum/nano_module/program/computer_ntrouter/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	if(program.computer.network_card)
		var/has_password = 0
		if(program.computer.network_card.connected_to != "")
			has_password = 1
		data["has_password"] = has_password
		data["card_installed"] = 1
		data["networks"] = format_networks(user)
		data["connected_to"] = program.computer.network_card.connected_to
		var/regex/allregex = regex(".")
		data["display_password"] = allregex.Replace(program.computer.network_card.password, "*")
		var/datum/ntnet/network = program.computer.network_card.get_network()
		if(program.computer.network_card.connected)
			data["connected"] = 1
			data["display_name"] = network.name
			data["secured"] = network.secured
			data["locked"] = program.computer.network_card.locked
		else
			data["connected"] = 0
			var/attempted = 0
			if(program.computer.network_card.connected_to != "")
				attempted = 1
			data["attempted"] = attempted
	else
		data["card_installed"] = 0
		data["connected"] = 0

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "ntnet_router.tmpl", "Select Network", 575, 700, state = state)
		if(host.update_layout())
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/nano_module/program/computer_ntrouter/Topic(href, href_list, state)
//	var/mob/user = usr
	if(..())
		return 1
	if(!program.computer.network_card)
		return 1
	if(href_list["disconnect"])
		if(input(usr, "Are you sure you want to disconnect from the network? Network settings wont save.") in list("Confirm", "Cancel") == "Confirm")
			program.computer.network_card.disconnect()
		return 1
	if(href_list["connect"])
		if(program.computer.network_card.connected)
			if(input(usr, "Are you sure you want to connect to a different network? You will be disconnected from your current network and settings wont save.") in list("Confirm", "Cancel") != "Confirm")
				return 1
			program.computer.network_card.disconnect()
		var/datum/ntnet/network = locate(href_list["connect"])
		if(!network)
			message_admins("ntnet failed to locate")
			return 1
		program.computer.network_card.connected_to = network.net_uid
		if(network.secured)
			program.computer.network_card.password = input(usr, "This network requires a password","Enter network password","")
		program.computer.network_card.get_network()
		return 1
