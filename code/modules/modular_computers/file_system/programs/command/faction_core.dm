
/datum/computer_file/program/faction_core
	filename = "faction_core"
	filedesc = "Core Logistics Program"
	program_icon_state = "comm"
	program_menu_icon = "flag"
	nanomodule_path = /datum/nano_module/program/faction_core
	extended_desc = "Uses a Logistic Processor to connect to and modify bluespace networks over satalite."
	required_access = access_heads
	requires_ntnet = 0
	size = 65
	usage_flags = PROGRAM_CONSOLE

/datum/nano_module/program/faction_core
	name = "Core Logistics Program"
	available_to_ai = TRUE
	var/datum/world_faction/connected_faction
	var/connected = 0
	var/faction_uid = ""
	var/faction_password = ""
	var/attempted_password = ""
	var/wrong_password = 0
	var/wrong_connection = 0
	var/menu = 1 // 1 = connect to network 2 = login screen 3 = main directory

/datum/nano_module/program/faction_core/proc/try_connect()

	if(!program.computer.logistic_processor || !program.computer.logistic_processor.check_functionality())
		connected = 0
		connected_faction = null
		menu = 1
		return
	if(connected_faction)
		if(connected_faction.uid != faction_uid || connected_faction.password != faction_password)
			connected = 0
			connected_faction = null
			menu = 1
			return
		else
			connected = 1
			wrong_connection = 0
			return 1
	else
		connected_faction = get_faction(faction_uid)
		if(connected_faction)
			if(connected_faction.password != faction_password)
				connected = 0
				connected_faction = null
				menu = 1
				return
			connected = 1
			wrong_connection = 0
			return 1
		menu = 1
		return

	
/datum/nano_module/program/faction_core/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	try_connect()
	var/list/data = host.initial_data()
	var/log_status = 1
	if(!program.computer.logistic_processor || !program.computer.logistic_processor.check_functionality()) log_status = 0
	data["has_log"] = log_status
	if(connected_faction)
		if(attempted_password != connected_faction.password)
			menu = 2
		else if(menu == 1 || menu == 2)
			menu = 3
		data["faction_name"] = connected_faction.name
		data["faction_uid"] = connected_faction.uid
		if(menu == 4)			
			data["faction_abbreviation"] = connected_faction.abbreviation
			var/regex/allregex = regex(".")
			data["faction_purpose"] = connected_faction.purpose
			data["faction_password"] = allregex.Replace(connected_faction.password, "*")
		if(menu == 5)
			data["network_name"] = connected_faction.network.name
			data["network_uid"] = connected_faction.network.net_uid
			data["network_password"] = connected_faction.network.password
			data["network_visible"] = connected_faction.network.invisible ? "No" : "Yes"
		if(menu == 6)
			var/list/access_categories[0]
			for(var/datum/access_category/category in connected_faction.access_categories)
				access_categories[++access_categories.len] = list("name" = category.name, "accesses" = list(), "ref" = "\ref[category]")
				for(var/x in category.accesses)
					var/datum/access/access = category.accesses[x]
					if(!access) continue
					
					
	data["menu"] = menu
	data["wrong_connection"] = wrong_connection
	data["wrong_password"] = wrong_password
	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "faction_core.tmpl", name, 550, 420, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/faction_core/Topic(href, href_list)
	if(..())
		return 1
	if(!program.computer.logistic_processor || !program.computer.logistic_processor.check_functionality()) return 1
	if(!program.can_run(usr)) return 1
	switch (href_list["action"])
		if("connect")
			var/curr_faction_uid = faction_uid
			var/curr_faction_password = faction_password
			var/select_faction_uid = input(usr, "Enter Lognet UID")
			var/select_faction_password = input(usr, "Enter Lognet Password")
			if(curr_faction_password == faction_password && curr_faction_uid == faction_uid)
				faction_uid = select_faction_uid
				faction_password = select_faction_password
				if(!try_connect())
					wrong_connection = 1
			else
				to_chat(usr, "Your inputs expired because somemone used the terminal first.")
		if("log_in")
			var/curr_attempted_password = attempted_password
			var/select_attempted_password = input(usr, "Enter Lognet Password")
			if(curr_attempted_password == attempted_password)
				attempted_password = select_attempted_password
				if(attempted_password != connected_faction.password)
					wrong_password = 1
			else
				to_chat(usr, "Your inputs expired because somemone used the terminal first.")
		if("disconnect")
			var/curr_attempted_password = attempted_password
			var/select_attempted_password = input(usr, "Enter Lognet Password")
			if(curr_attempted_password == attempted_password)
				if(select_attempted_password != connected_faction.password)
					to_chat(usr, "Error wrong password. Contact system administrator to disconnect network.")
				else
					faction_uid = ""
					faction_password = ""
					attempted_password = ""
			else
				to_chat(usr, "Your inputs expired because somemone used the terminal first.")
		if("log_out")
			attempted_password = ""
		if("change_menu")
			var/select_menu = text2num(href_list["menu_target"])
			menu = select_menu
		if("change_name")
			var/curr_name = connected_faction.name
			var/select_name = sanitizeName(input(usr,"Enter the name of your orginization","Lognet Display Name", connected_faction.name) as null|text, MAX_NAME_LEN, 1, 0)
			if(select_name)
				if(curr_name != connected_faction.name)
					to_chat(usr, "Your inputs expired because somemone used the terminal first.")
				else
					for(var/datum/world_faction/existing_faction in GLOB.all_world_factions)
						if(existing_faction.name == select_name)
							to_chat(usr, "Error! A Lognet with that display name already exists!")
							return 1
					connected_faction.name = select_name
					to_chat(usr, "Lognet display name successfully changed.")
		if("change_abbreviation")
			var/curr_name = connected_faction.abbreviation
			var/select_name = sanitizeName(input(usr,"Enter the abbreviation of your orginization","Lognet Abbreviation", connected_faction.abbreviation) as null|text, 20, 1, 0)
			if(select_name)
				if(curr_name != connected_faction.abbreviation)
					to_chat(usr, "Your inputs expired because somemone used the terminal first.")
				else
					for(var/datum/world_faction/existing_faction in GLOB.all_world_factions)
						if(existing_faction.abbreviation == select_name)
							to_chat(usr, "Error! A Lognet with that abbreviation already exists!")
							return 1
					connected_faction.abbreviation = select_name
					to_chat(usr, "Lognet abbreviation successfully changed.")
		if("change_purpose")
			var/curr_name = connected_faction.purpose
			var/select_name = sanitize(input(usr,"Enter a description or purpose for your orginization.","Lognet Desc.", connected_faction.purpose) as null|text, 126)
			if(select_name)
				if(curr_name != connected_faction.purpose)
					to_chat(usr, "Your inputs expired because somemone used the terminal first.")
				else
					connected_faction.purpose = select_name
					to_chat(usr, "Lognet description successfully changed.")
		if("change_password")
			if(input(usr,"Enter current password","Lognet Password") != connected_faction.password) return 1
			var/curr_name = connected_faction.password
			var/select_name = sanitize(input(usr,"Enter new password. This will log this terminal out.","Lognet Password") as null|text, 20)
			if(select_name)
				var/confirm_password = input(usr,"Reenter password to confirm","Lognet Password") as null|text
				if(confirm_password != select_name)
					to_chat(usr, "Unable to confirm password")
				else
					if(curr_name != connected_faction.password)
						to_chat(usr, "Your inputs expired because somemone used the terminal first.")
					else
						connected_faction.password = select_name
						to_chat(usr, "Lognet password successfully changed.")
		if("change_networkname")
			var/curr_name = connected_faction.network.name
			var/select_name = sanitizeName(input(usr,"Enter the wireless network display name","Wireless Network Display Name", curr_name) as null|text, MAX_NAME_LEN, 1, 0)
			if(select_name)
				if(curr_name != connected_faction.network.name)
					to_chat(usr, "Your inputs expired because somemone used the terminal first.")
				else
					connected_faction.network.name = select_name
					to_chat(usr, "Wireless network display name successfully changed.")
		if("change_networkuid")
			var/curr_name = connected_faction.network.net_uid
			var/select_name = sanitizeName(input(usr,"Enter the wireless network uid. Spaces are not allowed,","Wireless Network UID", curr_name) as null|text, MAX_NAME_LEN, 1, 0,1)
			if(select_name)
				if(curr_name != connected_faction.network.net_uid)
					to_chat(usr, "Your inputs expired because somemone used the terminal first.")
				else
					for(var/datum/world_faction/existing_faction in GLOB.all_world_factions)
						if(existing_faction.network.net_uid == select_name)
							to_chat(usr, "Error! A network with that UID already exists!")
							return 1
					connected_faction.network.net_uid = select_name
					to_chat(usr, "Wireless network UID successfully changed.")
		if("change_networkpassword")
			var/curr_name = connected_faction.network.password
			var/select_name = sanitize(input(usr,"Enter new password. All connected terminals will need to update their password. Leave blank to have unsecured network.","Wireless Network Password") as null|text, 20)
			if(select_name)
				if(curr_name != connected_faction.password)
					to_chat(usr, "Your inputs expired because somemone used the terminal first.")
				else
					connected_faction.network.password = select_name
					to_chat(usr, "Wireless network password successfully changed.")
			else
				connected_faction.network.secured = 0
				connected_faction.network.password = null
		if("change_networkvisible")
			connected_faction.network.invisible = !connected_faction.network.invisible
		if("menu_back")
			menu = 3
	GLOB.nanomanager.update_uis(src)