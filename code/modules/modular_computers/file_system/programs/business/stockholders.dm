/datum/computer_file/program/stockholders
	filename = "stockholders"
	filedesc = "Business Stockholders Panel"
	program_icon_state = "comm"
	program_menu_icon = "flag"
	nanomodule_path = /datum/nano_module/program/stockholders
	extended_desc = "Used by stockholders to create and vote on proposals, and create private stock sales."
	requires_ntnet = 1
	size = 2
	business = 1
	category = PROG_BUSINESS
	usage_flags = PROGRAM_ALL

/datum/nano_module/program/stockholders
	name = "Business Stockholders Panel"
	available_to_ai = TRUE
	var/menu = 1
	var/datum/stock_proposal/selected_proposal

/datum/nano_module/program/stockholders/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/datum/world_faction/business/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder

	var/list/data = host.initial_data()
	if(connected_faction.get_stockholder(user.real_name))
		data["stockholder"] = 1

		data["business_name"] = connected_faction.name
		data["menu"] = menu


		if(menu == 1)
			data["business_status"] = connected_faction.status
			var/list/formatted_proposals[0]
			for(var/datum/stock_proposal/proposal in connected_faction.proposals)
				formatted_proposals[++formatted_proposals.len] = list("name" = proposal.name, "ref" = "\ref[proposal]")
			data["proposals"] = formatted_proposals
		if(menu == 2)
			data["ceo_name"] = connected_faction.get_ceo()
			data["ceo_wage"] = connected_faction.get_ceo_wage()
			data["ceo_revenue"] = "[connected_faction.ceo_tax]%"
			data["stockholder_revenue"] = "[connected_faction.stockholder_tax]%"
			data["business_balance"] = connected_faction.central_account.money
			data["stock_listed"] = connected_faction.public_stock

		if(menu == 3)
			var/list/formatted_stockholders[0]
			for(var/x in connected_faction.stock_holders)
				var/datum/stockholder/holder = connected_faction.stock_holders[x]
				formatted_stockholders[++formatted_stockholders.len] = list("name" = "[x] holds [holder.stocks] stocks.")
			data["stockholders"] = formatted_stockholders
			var/datum/stockholder/owner = connected_faction.get_stockholder_datum(user.real_name)
			data["subscribed"] = owner.subscribed
			data["holdings"] = owner.stocks

		if(menu == 4)
			if(!selected_proposal)
				menu = 1
				return 1
			data["proposal_name"] = selected_proposal.name
			var/list/formatted_stockholders[0]
			for(var/datum/stockholder/holder in selected_proposal.supporting)
				formatted_stockholders[++formatted_stockholders.len] = list("name" = "[holder.real_name] ([holder.stocks])")
			data["stockholders"] = formatted_stockholders
			data["supporting"] = selected_proposal.get_support()
			data["required"] = selected_proposal.required
			data["supported"] = selected_proposal.is_supporting(user.real_name)
			data["proposal_owner"] = selected_proposal.is_started_by(user.real_name)
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "stockholders.tmpl", name, 600, 500, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/stockholders/Topic(href, href_list)
	if(..())
		return 1
	. = SSnano.update_uis(src)
	var/mob/user = usr
	var/datum/world_faction/business/connected_faction = program.computer.network_card.connected_network.holder
	if(!istype(connected_faction) || !connected_faction.get_stockholder(user.real_name)) return 0
	switch(href_list["action"])
		if("change_menu")
			menu = text2num(href_list["menu_target"])
			selected_proposal = null
		if("select_proposal")
			selected_proposal = locate(href_list["ref"])
			menu = 4
		if("fire_ceo")
			if(connected_faction.has_proposal(user.real_name))
				to_chat(user, "You can only have one active proposal at a time.")
				return 1
			if(connected_faction.leader_name && connected_faction.leader_name != "")
				connected_faction.create_proposal(user.real_name, STOCKPROPOSAL_CEOFIRE)
			else
				to_chat(usr, "There is currently no CEO to fire.")
		if("choose_ceo")
			var/select_name = sanitize(input(usr,"Enter the full name of the new CEO appointee.","CEO name", "") as null|text)
			if(connected_faction.has_proposal(user.real_name))
				to_chat(user, "You can only have one active proposal at a time.")
				return 1
			if(select_name)
				connected_faction.create_proposal(user.real_name, STOCKPROPOSAL_CEOREPLACE, select_name)
			else
				to_chat(usr, "Invalid Entry.")
		if("ceo_wage")
			var/new_pay = input(usr, "Enter new proposed CEO wage.","CEO Wage") as null|num
			if(!new_pay && new_pay != 0) return 1
			if(connected_faction.has_proposal(user.real_name))
				to_chat(user, "You can only have one active proposal at a time.")
				return 1
			connected_faction.create_proposal(user.real_name, STOCKPROPOSAL_CEOWAGE, new_pay)
		if("ceo_revenue")
			var/new_pay = input(usr, "Enter new proposed CEO revenue share. 30% Max","CEO Revenue Share") as null|num
			if(!new_pay && new_pay != 0 || new_pay > 30) return 1
			if(connected_faction.has_proposal(user.real_name))
				to_chat(user, "You can only have one active proposal at a time.")
				return 1
			connected_faction.create_proposal(user.real_name, STOCKPROPOSAL_CEOTAX, new_pay)
		if("stockholder_revenue")
			var/new_pay = input(usr, "Enter new proposed stockholder revenue share. 30% Max","Stockholder Revenue Share") as null|num
			if(!new_pay && new_pay != 0 || new_pay > 30) return 1
			if(connected_faction.has_proposal(user.real_name))
				to_chat(user, "You can only have one active proposal at a time.")
				return 1
			connected_faction.create_proposal(user.real_name, STOCKPROPOSAL_STOCKHOLDERTAX, new_pay)
		if("instant_dividend")
			var/new_pay = input(usr, "Enter percentage of the current account balance to divide up for the dividend.","Instant Dividend") as null|num
			if(!new_pay || new_pay > 100) return 1
			if(connected_faction.has_proposal(user.real_name))
				to_chat(user, "You can only have one active proposal at a time.")
				return 1
			connected_faction.create_proposal(user.real_name, STOCKPROPOSAL_INSTANTDIVIDEND, new_pay)
		if("list_stock")
			if(connected_faction.public_stock) return 1
			if(connected_faction.has_proposal(user.real_name))
				to_chat(user, "You can only have one active proposal at a time.")
				return 1
			connected_faction.create_proposal(user.real_name, STOCKPROPOSAL_PUBLIC)
		if("unlist_stock")
			if(!connected_faction.public_stock) return 1
			if(connected_faction.has_proposal(user.real_name))
				to_chat(user, "You can only have one active proposal at a time.")
				return 1
			connected_faction.create_proposal(user.real_name, STOCKPROPOSAL_UNPUBLIC)
		if("subscribe")
			connected_faction.subscribe_stockholder(user.real_name)
		if("unsubscribe")
			connected_faction.unsubscribe_stockholder(user.real_name)
		if("stock_contract")
			var/to_be = connected_faction.get_stockholder(user.real_name)
			var/amount = round(input("How many stocks is this contract worth?", "Stock Sell Contract", 0) as null|num)
			if(!amount || amount < 0)
				return 0
			if(amount > to_be)
				to_chat(user, "You don't have enough stocks.")
				return
			var/cost = round(input("How much centera should the contract be worth for the [amount] stocks?", "Price", 0) as null|num)
			if(!cost || cost < 0)
				cost = 0
			var/choice = input(usr,"This will create an investment contract for [amount] stocks at [cost] centera.") in list("Confirm", "Cancel")
			if(choice == "Confirm")
				var/obj/item/weapon/paper/contract/contract = new()
				contract.required_cash = cost
				contract.linked = new /datum/stock_contract()
				contract.purpose = "Stock contract for [amount] stocks at [cost]$$"
				contract.ownership = amount
				contract.created_by = usr.real_name
				contract.name = "[connected_faction.name] stock contract"
				var/t = {"
						<font face='Verdana' color=blue>
							<table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>
								<tr>
									<td>
										<center><h1>Investment Contract for [connected_faction.name]([connected_faction.uid])</h1></center>
									</td>
								</tr>
								<tr>
									<td>
										<b>Make sure you learn about the company you are investing in before signing a stock contract, some stock is worthless.</b>
										<b>Stock Amount:</b> [amount] stocks<br>
										<b>Cost:</b> [cost] $$ Centera<br><br>
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
				contract.org_uid = connected_faction.uid
				playsound(get_turf(program.computer), pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 75, 1, -3)
		if("retract")
			if(!selected_proposal || !selected_proposal.is_started_by(usr.real_name)) return
			connected_faction.proposals -= selected_proposal
			selected_proposal = null
		if("support")
			var/datum/stockholder/holder = connected_faction.get_stockholder_datum(usr.real_name)
			if(holder)
				selected_proposal.supporting |= holder
				selected_proposal.get_support()
				if(!selected_proposal in connected_faction.proposals)
					menu = 1
					
		if("unsupport")
			var/datum/stockholder/holder = connected_faction.get_stockholder_datum(usr.real_name)
			if(holder)
				selected_proposal.supporting -= holder
