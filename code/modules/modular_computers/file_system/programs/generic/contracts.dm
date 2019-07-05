/datum/computer_file/program/contracts
	filename = "contractmanagement"
	filedesc = "Contract Management"
	nanomodule_path = /datum/nano_module/program/contracts
	program_icon_state = "supply"
	program_menu_icon = "cart"
	extended_desc = "A program where existing contracts with the organization can be viewed and reprinted, and new contracts can be drafted."
	size = 8
	requires_ntnet = TRUE
	required_access = core_access_contracts

/datum/nano_module/program/contracts
	name = "Contract Management"
	var/menu = 1
	var/selected_title = ""
	var/selected_desc = ""
	var/selected_paytype = CONTRACT_PAY_NONE
	var/selected_pay = 0
	var/selected_service = "None"
	var/selected_type = CONTRACT_BUSINESS
	var/datum/recurring_contract/selected_contract
	var/last_print = 0

/datum/nano_module/program/contracts/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/datum/world_faction/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	data["connected_faction"] = connected_faction.name
	if(menu == 1)
		var/list/formatted_contracts[0]
		var/list/contracts = GLOB.contract_database.get_contracts(connected_faction.uid, CONTRACT_BUSINESS)
		for(var/datum/recurring_contract/contract in contracts)
			if(contract.payee == connected_faction.uid)
				formatted_contracts[++formatted_contracts.len] = list("name" = "[contract.name] ([contract.payer])", "ref" = "\ref[contract]")
			else
				formatted_contracts[++formatted_contracts.len] = list("name" = "[contract.name] ([contract.payee])", "ref" = "\ref[contract]")
		data["contracts"] = formatted_contracts
	if(menu == 2)
		if(selected_type != CONTRACT_BUSINESS)
			data["contract_personal"] = 1
		if(selected_title && selected_title != "")
			data["title"] = selected_title
		else
			data["title"] = "*NONE*"
		if(selected_desc && selected_desc != "")
			data["desc"] = selected_desc
		else
			data["desc"] = "*NONE*"
		switch(selected_paytype)
			if(CONTRACT_PAY_NONE)
				data["payment_type"] = "None"
			if(CONTRACT_PAY_DAILY)
				data["payment_type"] = "Daily"
				data["paytype"] = 1
			if(CONTRACT_PAY_WEEKLY)
				data["payment_type"] = "Weekly"
				data["paytype"] = 1
		data["pay"] = "[selected_pay]$$"
		if(selected_service && selected_service != "")
			data["service"] = selected_service
		else
			data["service"] = "None"
		data["service_desc"] = GLOB.contract_database.get_service_desc(selected_service)
	if(menu == 3)
		data["contract"] = selected_contract.name
		data["details"] = selected_contract.details
		data["contracted"] = selected_contract.payee
		data["signed"] = selected_contract.payer
		if(world.time >= last_print)
			data["can_print"] = 1
		data["contract_status"] = selected_contract.get_status()
		data["payment_type"] = selected_contract.get_paytype()
		data["pay"] = selected_contract.pay_amount
		data["paytime"] = time2text(selected_contract.last_pay+config.year_skip)
		data["service"] = selected_contract.func
		data["complete"] = selected_contract.get_marked(connected_faction.uid)
		if(selected_contract.status == CONTRACT_STATUS_OPEN)
			data["cancelable"] = 1
		else
			data["clearable"] = 1


	data["menu"] = menu
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "contracts.tmpl", name, 600, 800, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/contracts/Topic(href, href_list)
	if(..())
		return 1
	. = SSnano.update_uis(src)
	var/datum/world_faction/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	if(!connected_faction)
		return
	switch(href_list["action"])
		if("change_menu")
			menu = text2num(href_list["menu_target"])
			selected_pay = 0
			selected_contract = null
			selected_desc = ""
			selected_title = ""
			selected_paytype = CONTRACT_PAY_NONE
			selected_service = "None"

		if("select_contract")
			selected_contract = locate(href_list["ref"])
			menu = 3

		if("change_title")
			var/chosen_title = sanitize(input(usr,"Enter a title for the new contract.","CEO name", selected_title) as null|text, 30)
			if(chosen_title)
				selected_title = chosen_title
		if("change_desc")
			var/chosen_desc = sanitize(input(usr, "Enter a full description of the terms of the contract.", "Contract Description", selected_desc) as null|message, MAX_MESSAGE_LEN*2)
			if(chosen_desc)
				selected_desc = chosen_desc

		if("select_org")
			selected_type = CONTRACT_BUSINESS

		if("select_personal")
			selected_type = CONTRACT_PERSON

		if("change_payment_type")
			var/list/choices = list("No Auto Payments", "Weekly", "Daily")
			var/choice = input(usr, "Select the auto payment type.") as null|anything in choices
			if(choice)
				switch(choice)
					if("No Auto Payments")
						selected_paytype = CONTRACT_PAY_NONE
					if("Weekly")
						selected_paytype = CONTRACT_PAY_WEEKLY
					if("Daily")
						selected_paytype = CONTRACT_PAY_DAILY

		if("change_payment")
			var/chose_pay = max(0, input(usr, "Enter the auto-pay amount.", "Autopay amount", selected_pay) as null|num)
			if(!isnull(chose_pay))
				selected_pay = chose_pay

		if("change_service")
			var/list/choices = list(CONTRACT_SERVICE_NONE, CONTRACT_SERVICE_MEDICAL, CONTRACT_SERVICE_SECURITY)
			var/choice = input(usr, "Select an additional service.") as null|anything in choices
			if(choice)
				selected_service = choice
		if("finish")
			if(!selected_title || selected_title == "")
				return
			if(!selected_desc || selected_desc == "")
				return
			var/obj/item/weapon/paper/contract/recurring/contract = new()
			contract.sign_type = selected_type
			var/text_signtype
			switch(selected_type)
				if(CONTRACT_BUSINESS)
					text_signtype = "Organization"
				else
					text_signtype = "Personal"
			contract.contract_payee = connected_faction.uid
			contract.contract_desc = selected_desc
			contract.contract_title = selected_title
			contract.contract_paytype = selected_paytype
			contract.contract_pay = selected_pay
			contract.additional_function = selected_service
			contract.name = "[connected_faction.name] Contract"
			var/text_pay = ""

			switch(selected_paytype)
				if(CONTRACT_PAY_WEEKLY)
					text_pay = "[selected_pay] paid weekly"
				if(CONTRACT_PAY_DAILY)
					text_pay = "[selected_pay] paid daily"
				else
					text_pay = "No automatic payments."
			var/t = {"
					<font face='Verdana' color=blue>
						<table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>
							<tr>
								<td>
									<center><h1>[selected_title]([connected_faction.name])</h1></center>
								</td>
							</tr>
							<tr>
								<td>
									<br>[selected_desc]<br>
								</td>
							</tr>
							<tr>
								<td>
									<br><b>Payment:</b>[text_pay]<br>
									<b>Contract Type:</b>[text_signtype]<br>
									<b>Additional Service:</b> [selected_service]<br>
									[GLOB.contract_database.get_service_desc(selected_service)]
								</td>
							</tr>
							<tr>
								<td>
									<h3>Status</h3>*Unsigned*<br>
								</td>
							</tr>
						</table>
					</font>
			"}
			contract.info = t
			contract.loc = get_turf(program.computer)
			contract.update_icon()
			menu = 1
			selected_pay = 0
			selected_contract = null
			selected_desc = ""
			selected_title = ""
			selected_paytype = CONTRACT_PAY_NONE
			selected_service = "None"

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
		if("mark_complete")
			if(selected_contract.payee_type == CONTRACT_BUSINESS && selected_contract.payee == connected_faction.uid)
				selected_contract.payee_completed = 1
			if(selected_contract.payer_type == CONTRACT_BUSINESS && selected_contract.payer == connected_faction.uid)
				selected_contract.payer_completed = 1
			selected_contract.update_status()
		if("unmark_complete")
			if(selected_contract.payee_type == CONTRACT_BUSINESS && selected_contract.payee == connected_faction.uid)
				selected_contract.payee_completed = 0
			if(selected_contract.payer_type == CONTRACT_BUSINESS && selected_contract.payer == connected_faction.uid)
				selected_contract.payer_completed = 0
			selected_contract.update_status()
		if("cancel_contract")
			if(selected_contract.payee_type == CONTRACT_BUSINESS && selected_contract.payee == connected_faction.uid)
				selected_contract.payee_cancelled = 1
			if(selected_contract.payer_type == CONTRACT_BUSINESS && selected_contract.payer == connected_faction.uid)
				selected_contract.payer_cancelled = 1
			selected_contract.update_status()
		if("clear_contract")
			var/choice = input(usr,"This will clear the contract from the list and make the record inaccessible permanently.") in list("Confirm", "Cancel")
			if(choice == "Confirm")
				if(selected_contract.payee_type == CONTRACT_BUSINESS && selected_contract.payee == connected_faction.uid)
					selected_contract.payee_clear = 1
				if(selected_contract.payer_type == CONTRACT_BUSINESS && selected_contract.payer == connected_faction.uid)
					selected_contract.payer_clear = 1

