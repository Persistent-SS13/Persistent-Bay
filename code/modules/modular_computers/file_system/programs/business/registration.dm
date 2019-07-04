/datum/computer_file/program/newbusiness
	filename = "businessregister"
	filedesc = "Create a new business"
	program_icon_state = "comm"
	program_menu_icon = "flag"
	nanomodule_path = /datum/nano_module/program/newbusiness
	extended_desc = "Used to register new businesses."
	requires_ntnet = 1
	size = 5
	category = PROG_BUSINESS
	usage_flags = PROGRAM_ALL

/datum/nano_module/program/newbusiness
	name = "Create a new business"
	available_to_ai = TRUE

	var/datum/business_module/selected_type
	var/datum/business_spec/selected_spec

	var/business_uid
	var/business_name
	var/ceo_name
	var/ceo_wage = 100
	var/list/signed_contracts = list()
	var/list/pending_contracts = list()



/datum/nano_module/program/newbusiness/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()

	if(selected_type)
		data["business_type"] = selected_type.name
		data["type_desc"] = selected_type.desc
		data["cost"] = selected_type.cost
		if(selected_spec)
			data["business_spec"] = selected_spec.name
			data["spec_desc"] = selected_spec.desc
			data["chose_business"] = 1
		else
			data["business_spec"] = "*NONE*"
			data["spec_desc"] = ""
	else
		data["business_type"] = "*NONE*"
		data["type_desc"] = ""
		data["business_spec"] = "*NONE*"
		data["spec_desc"] = ""

	if(business_uid)
		data["business_uid"] = business_uid
		data["chose_uid"] = 1
	else
		data["business_uid"] = "*NONE*"

	if(business_name)
		data["business_name"] = business_name
		data["chose_name"] = 1
	else
		data["business_name"] = "*NONE*"

	if(ceo_name)
		data["business_ceo"] = ceo_name
		data["chose_ceo"] = 1
	else
		data["business_ceo"] = "*NONE*"
	data["business_ceowage"] = "[ceo_wage]$$/30 minutes"
	var/list/formatted_names[0]
	for(var/obj/item/weapon/paper/contract/contract in signed_contracts)
		formatted_names[++formatted_names.len] = list("signed_contract" = "[contract.ownership] stocks for [contract.required_cash]$$ to [contract.signed_by]")
	data["signed_contracts"] = formatted_names
	var/commitment = get_contributed()
	var/signed_stocks = get_distributed()
	var/finalize = 0
	if(selected_type && selected_spec && commitment >= selected_type.cost && signed_stocks == 100 && business_uid && business_name && ceo_name) finalize = 1
	data["commitment"] = commitment
	data["signed_stocks"] = signed_stocks
	data["finish_ready"] = finalize

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "new_business.tmpl", name, 800, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()



/datum/nano_module/program/newbusiness/Topic(href, href_list)
	if(..())
		return 1
	. = SSnano.update_uis(src)
	var/mob/user = usr
	switch(href_list["action"])

		if("change_business_type")
			var/chose_type = input(user, "Select a type of business") as null|anything in SSresearch.business_modules
			if(!chose_type) return
			if(signed_contracts.len)
				var/choice = input(usr,"Changing this will cancel all pending contracts.") in list("Confirm", "Cancel")
				if(choice == "Confirm")
					cancel_contracts()
				else
					return
			selected_type = chose_type
			selected_spec = null
		if("change_business_spec")

			var/chose_type = input(user, "Select a specialization") as null|anything in selected_type.specs
			if(!chose_type) return
			if(signed_contracts.len)
				var/choice = input(usr,"Changing this will cancel all pending contracts.") in list("Confirm", "Cancel")
				if(choice == "Confirm")
					cancel_contracts()
				else
					return
			selected_spec = chose_type

		if("change_business_uid")
			var/select_name = input(usr,"Enter the UID for the business. It must be unique.","UID", business_uid) as null|text
			if(!select_name) return
			var/datum/world_faction/faction = get_faction(select_name)
			if(faction)
				to_chat(user, "Invalid UID")
				return
			if(signed_contracts.len)
				var/choice = input(usr,"Changing this will cancel all pending contracts.") in list("Confirm", "Cancel")
				if(choice == "Confirm")
					cancel_contracts()
				else
					return
			business_uid = select_name

		if("change_business_name")
			var/select_name = sanitize(input(usr,"Enter the display name for the business.","Display Name", business_name) as null|text, MAX_NAME_LEN)
			if(!select_name) return
			if(signed_contracts.len)
				var/choice = input(usr,"Changing this will cancel all pending contracts.") in list("Confirm", "Cancel")
				if(choice == "Confirm")
					cancel_contracts()
				else
					return
			business_name = select_name

		if("change_business_ceo")
			var/select_name =  sanitize(input(usr,"Enter the full name of the starting CEO.","CEO", ceo_name) as null|text)
			if(!select_name) return
			if(!Retrieve_Record(select_name))
				to_chat(user, "Record not found for [select_name].")
				return
			if(signed_contracts.len)
				var/choice = input(usr,"Changing this will cancel all pending contracts.") in list("Confirm", "Cancel")
				if(choice == "Confirm")
					cancel_contracts()
				else
					return
			ceo_name = select_name

		if("change_business_ceowage")
			var/new_pay = input("Enter wage. This wage is paid every thirty minutes.","CEO Wage") as null|num
			if(isnull(new_pay)) return
			if(new_pay < 0)
				new_pay = 0
			if(signed_contracts.len)
				var/choice = input(usr,"Changing this will cancel all pending contracts.") in list("Confirm", "Cancel")
				if(choice == "Confirm")
					cancel_contracts()
				else
					return
			ceo_wage = new_pay

		if("business_contract")
			if(!business_name || !business_uid || !ceo_name || !selected_type || !selected_spec)
				return
			var/to_be = 100 - get_distributed()
			var/amount = round(input("How many stocks is this contract worth?", "Investment", to_be) as null|num)
			if(!amount || amount < 0)
				amount = 0
			if(amount > to_be)
				to_chat(user, "Their is not that many stocks left to be distributed.")
				return
			var/cost = round(input("How much centera should be invested for the [amount] stocks?", "Price", 10*amount) as null|num)
			if(!cost || cost < 0)
				cost = 0
			var/choice = input(usr,"This will create an investment contract for [amount] stocks at [cost] Centera.") in list("Confirm", "Cancel")
			if(choice == "Confirm")
				var/obj/item/weapon/paper/contract/contract = new()
				contract.required_cash = cost
				contract.linked = src
				contract.purpose = "Investment contract for [amount] stocks at [cost]$$"
				contract.ownership = amount
				contract.name = "[business_name] investment contract"
				var/t = {"
						<font face='Verdana' color=blue>
							<table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>
								<tr>
									<td>
										<center><h1>Investment Contract for [business_name]</h1></center>
									</td>
								</tr>
								<tr>
									<td>
										<br>[selected_spec.name] [selected_type.name]<br>
									</td>
								</tr>
								<tr>
									<td>
										<br>Initial CEO [ceo_name] paid [ceo_wage] every thirty minutes.<br>
										<b>Stock Amount:</b> [amount] stocks<br>
										<b>Investment Cost:</b> [cost] $$ Centera<br><br>
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
				pending_contracts |= contract
				playsound(get_turf(program.computer), pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 75, 1, -3)


		if("business_finalize")
			if(!business_name || !business_uid || !ceo_name || !selected_type || !selected_spec)
				return
			if(get_faction(business_uid))
				business_uid = null
				return
			if(!selected_spec in selected_type.specs)
				selected_spec = null
				return
			var/commitment = get_contributed()
			var/signed_stocks = get_distributed()
			if(commitment < selected_type.cost || signed_stocks != 100)
				return
			commitment -= selected_type.cost
			for(var/obj/item/weapon/paper/contract/contract in signed_contracts)
				if(!contract.is_solvent())
					message_admins("insolvent contract")
					contract.cancel()
					SSnano.update_uis(src)
					return 0
			var/datum/world_faction/business/new_business = new()
			new_business.module = new selected_type.type()
			for(var/datum/business_spec/spec in new_business.module.specs)
				if(spec.type == selected_spec.type)
					new_business.module.spec = spec
					break
			var/datum/accesses/rank = new()
			rank.pay = ceo_wage
			new_business.CEO.accesses |= rank
			new_business.leader_name = ceo_name
			if(!new_business.get_record(ceo_name))
				var/datum/computer_file/report/crew_record/record = new()
				if(record.load_from_global(ceo_name))
					new_business.records.faction_records |= record
			new_business.name = business_name
			new_business.uid = business_uid
			new_business.network.net_uid = business_uid
			new_business.network.name = business_name
			new_business.network.invisible = 1
			if(commitment)
				new_business.central_account.money += commitment
			for(var/obj/item/weapon/paper/contract/contract in signed_contracts)
				contract.finalize()
				if(new_business.stock_holders[contract.signed_by])
					var/datum/stockholder/holder = new_business.stock_holders[contract.signed_by]
					holder.stocks += contract.ownership
				else
					var/datum/stockholder/holder = new()
					holder.real_name = contract.signed_by
					holder.stocks = contract.ownership
					new_business.stock_holders[contract.signed_by] = holder
				signed_contracts -= contract
			LAZYDISTINCTADD(GLOB.all_world_factions, new_business)
			var/obj/effect/portal/portal = new(get_turf(program.computer))
			program.computer.visible_message("A \icon[portal] [portal] appears to deposit a crate of starting equipment.")
			sleep(1 SECOND)
			playsound(get_turf(program.computer),'sound/effects/teleport.ogg',100,1)
			portal.loc = null
			var/obj/structure/closet/crate/secure/secure_closet = new(get_turf(program.computer))
			secure_closet.req_access_faction = business_uid
			secure_closet.req_access = list(101)
			secure_closet.name = "[business_name] Starting Equipment"
			for(var/x in new_business.module.starting_items)
				var/ind = new_business.module.starting_items[x]
				for(var/i in 1 to ind)
					new x(secure_closet)
			business_name = null
			business_uid = null
			ceo_name = null
			ceo_wage = 100
			selected_spec = null
			selected_type = null
			cancel_contracts()


/datum/nano_module/program/newbusiness/contract_signed(var/obj/item/weapon/paper/contract/contract)
	pending_contracts -= contract
	signed_contracts |= contract
	SSnano.update_uis(src)
	return 1

/datum/nano_module/program/newbusiness/contract_cancelled(var/obj/item/weapon/paper/contract/contract)
	pending_contracts -= contract
	signed_contracts -= contract
	SSnano.update_uis(src)
	return 1


/datum/nano_module/program/newbusiness/proc/get_contributed()
	var/contributed = 0
	for(var/obj/item/weapon/paper/contract/contract in signed_contracts)
		contributed += contract.required_cash
	return contributed

/datum/nano_module/program/newbusiness/proc/cancel_contracts()
	for(var/obj/item/weapon/paper/contract/contract in signed_contracts)
		contract.cancel()
		signed_contracts -= contract
	for(var/obj/item/weapon/paper/contract/contract in pending_contracts)
		contract.cancel()
		pending_contracts -= contract

/datum/nano_module/program/newbusiness/proc/get_distributed()
	var/distributed = 0
	for(var/obj/item/weapon/paper/contract/contract in signed_contracts)
		distributed += contract.ownership
	if(distributed > 100)
		cancel_contracts()
		return 0
	return distributed

