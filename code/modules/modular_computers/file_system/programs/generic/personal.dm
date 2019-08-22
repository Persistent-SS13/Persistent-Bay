/datum/computer_file/program/personal
	filename = "personalmanagement"
	filedesc = "Personal Options"
	program_icon_state = "comm"
	program_menu_icon = "key"
	nanomodule_path = /datum/nano_module/program/personal
	extended_desc = "Used by individuals to control things about their Nexus Account and personal holdings."
	requires_ntnet = 1
	size = 2
	usage_flags = PROGRAM_ALL
/datum/nano_module/program/personal
	name = "Personal Options"
	available_to_ai = TRUE
	var/menu = 1
	var/datum/recurring_contract/selected_contract
	var/last_print
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
	if(menu == 4)
		var/list/formatted_contracts[0]
		var/list/contracts = GLOB.contract_database.get_contracts(usr.real_name, CONTRACT_PERSON)
		for(var/datum/recurring_contract/contract in contracts)
			if(contract.payee == usr.real_name)
				formatted_contracts[++formatted_contracts.len] = list("name" = "[contract.name] ([contract.payer])", "ref" = "\ref[contract]")
			else
				formatted_contracts[++formatted_contracts.len] = list("name" = "[contract.name] ([contract.payee])", "ref" = "\ref[contract]")
		data["contracts"] = formatted_contracts

	if(menu == 5)
		data["contract"] = selected_contract.name
		data["details"] = selected_contract.details
		data["contracted"] = selected_contract.payee
		data["signed"] = selected_contract.payer
		if(world.time >= last_print)
			data["can_print"] = 1
		data["contract_status"] = selected_contract.get_status()
		data["payment_type"] = selected_contract.get_paytype()
		data["balance"] = selected_contract.balance
		data["pay"] = selected_contract.pay_amount
		data["paytime"] = time2text(selected_contract.last_pay+config.year_skip)
		data["service"] = selected_contract.func
		data["complete"] = selected_contract.get_marked(usr.real_name)
		if(selected_contract.status == CONTRACT_STATUS_OPEN)
			data["cancelable"] = 1
		else
			data["clearable"] = 1
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
		if("select_contract")
			selected_contract = locate(href_list["ref"])
			menu = 5
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

		if("mark_complete")
			if(selected_contract.payee_type == CONTRACT_PERSON && selected_contract.payee == usr.real_name)
				selected_contract.payee_completed = 1
			if(selected_contract.payer_type == CONTRACT_PERSON && selected_contract.payer == usr.real_name)
				selected_contract.payer_completed = 1
			selected_contract.update_status()
		if("unmark_complete")
			if(selected_contract.payee_type == CONTRACT_PERSON && selected_contract.payee == usr.real_name)
				selected_contract.payee_completed = 0
			if(selected_contract.payer_type == CONTRACT_PERSON && selected_contract.payer == usr.real_name)
				selected_contract.payer_completed = 0
			selected_contract.update_status()
		if("cancel_contract")
			if(selected_contract.payee_type == CONTRACT_PERSON && selected_contract.payee == usr.real_name)
				selected_contract.payee_cancelled = 1
			if(selected_contract.payer_type == CONTRACT_PERSON && selected_contract.payer == usr.real_name)
				selected_contract.payer_cancelled = 1
			selected_contract.update_status()
		if("clear_contract")
			var/choice = input(usr,"This will clear the contract from the list and make the record inaccessible permanently.") in list("Confirm", "Cancel")
			if(choice == "Confirm")
				if(selected_contract.payee_type == CONTRACT_PERSON && selected_contract.payee == usr.real_name)
					selected_contract.payee_clear = 1
				if(selected_contract.payer_type == CONTRACT_PERSON && selected_contract.payer == usr.real_name)
					selected_contract.payer_clear = 1
		if("print")
			if(last_print > world.time)
				to_chat(usr, "You must wait before printing.")
				return
			last_print = world.time + 10 SECONDS
			playsound(get_turf(program.computer), pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 75, 1, -3)
			var/obj/item/weapon/paper/contract/contract = new()
			var/t = {"
					<font face='Verdana' color=blue>
						<table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>
							<tr>
								<td>
									<center><h1>[selected_contract.name](Copy)</h1></center>
								</td>
							</tr>
							<tr>
								<td>
									<br>[selected_contract.details]<br>
								</td>
							</tr>
							<tr>
								<td>
									<b>Creating Party:</b>[selected_contract.payee]
									<b>Signing Party:</b>[selected_contract.payer]
									<b>Auto Pay:</b>[selected_contract.get_paytype()]
								</td>
							</tr>
							<tr>
								<td>
									<h3>Status</h3>[selected_contract.get_status()]<br>
								</td>
							</tr>
						</table>
					</font>
			"}
			contract.info = t
			contract.name = selected_contract.name
			contract.approved = 1
			contract.update_icon()
