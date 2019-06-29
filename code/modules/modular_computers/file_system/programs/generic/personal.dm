/datum/computer_file/program/personal
	filename = "personalmanagement"
	filedesc = "Personal Options"
	program_icon_state = "comm"
	program_menu_icon = "key"
	nanomodule_path = /datum/nano_module/program/personal
	extended_desc = "Used by individuals to control things about their Nexus Account and personal holdings."
	requires_ntnet = 1
	size = 12
	usage_flags = PROGRAM_ALL
/datum/nano_module/program/personal
	name = "Personal Options"
	available_to_ai = TRUE
	var/menu = 1

/datum/nano_module/program/personal/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	data["name"] = user.real_name
	data["menu"] = menu
	var/datum/computer_file/report/crew_record/R = Retrieve_Record(user.real_name)
	data["account_balance"] = R.linked_account.money
	var/datum/personal_limits/limits = R.get_limits()
	if(menu == 1)
		var/list/formatted_orgs[0]
		for(var/datum/world_faction/faction in GLOB.all_world_factions)
			var/datum/computer_file/report/crew_record/faction_record = faction.get_record(user.real_name)
			if(faction_record  || faction.get_leadername() == user.real_name)
				var/selected = 0
				if(faction.uid in R.subscribed_orgs)
					selected = 1
				formatted_orgs[++formatted_orgs.len] = list("name" = faction.name, "uid" = "[faction.uid]", "subscribed" = selected)
		data["organizations"] = formatted_orgs
	if(menu == 2)
		var/list/holdings = list()
		var/total = 0
		for(var/datum/world_faction/business/faction in GLOB.all_world_factions)
			var/holding = faction.get_stockholder(user.real_name)
			if(holding)
				total += holding
				holdings[faction] = holding
		data["stock_owned"] = total
		data["stock_limit"] = limits.stock_limit
		var/list/formatted_holdings[0]
		for(var/datum/world_faction/business/faction in holdings)
			var/holding = holdings[faction]
			formatted_holdings[++formatted_holdings.len] = list("holding" = "[holding] stocks in [faction.name]", "ref" = "\ref[faction]")
		data["holdings"] = formatted_holdings
	if(menu == 3)
		data["level"] = R.network_level
		if(R.network_level >= 4)
			data["max_level"] = 1
		data["upgrade_cost"] = R.get_upgrade_cost()
		data["upgrade_desc"] = R.get_upgrade_desc()
		data["stock_limit_used"] = R.get_holdings()
		data["stock_limit"] = limits.stock_limit
		data["shuttle_limit"] = limits.shuttle_limit
		data["shuttle_limit_used"] = 0

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "personal.tmpl", name, 750, 650, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/personal/Topic(href, href_list)
	if(..())
		return 1
	. = SSnano.update_uis(src)
	var/datum/computer_file/report/crew_record/R = Retrieve_Record(usr.real_name)
	switch(href_list["action"])
		if("change_menu")
			menu = text2num(href_list["menu_target"])
		if("select_cryo")
			usr.client.link_discord()
		if("email_on")
			R.notifications = 1
		if("email_off")
			R.notifications = 0
		if("toggle_subscribe")
			var/datum/world_faction/faction = get_faction(href_list["uid"])
			if(usr.real_name in faction.people_to_notify)
				faction.people_to_notify -= usr.real_name
			else
				faction.people_to_notify |= usr.real_name
		if("surrender")
			var/datum/world_faction/business/faction = locate(href_list["ref"])
			if(istype(faction))
				var/choice = input(usr,"This will give up all stocks you hold in [faction.name] ([faction.uid]). Are you sure you want to proceed") in list("Confirm", "Cancel")
				if(choice == "Confirm")
					faction.surrender_stocks(usr.real_name)

		if("upgrade")
			R.upgrade(usr)


