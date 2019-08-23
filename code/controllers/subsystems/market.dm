GLOBAL_DATUM_INIT(material_marketplace, /datum/material_marketplace, new)
GLOBAL_DATUM_INIT(contract_database, /datum/contract_database, new)
GLOBAL_DATUM_INIT(module_objective_manager, /datum/module_objective_manager, new)
GLOBAL_DATUM_INIT(stock_market, /datum/stock_market, new)


SUBSYSTEM_DEF(market)
	name = "Market"
	wait = 30 SECONDS
	flags = SS_NO_INIT


/datum/controller/subsystem/market/fire(resumed = FALSE)
	GLOB.material_marketplace.process()
	GLOB.contract_database.process()
	GLOB.module_objective_manager.process()
	GLOB.stock_market.process()





/datum/module_objective_manager

/datum/module_objective_manager/proc/process()
	for(var/datum/world_faction/business/faction in GLOB.all_world_factions)
		if(faction.hourly_objective)
			if(faction.hourly_objective.completed || faction.hourly_objective.check_completion())
				if((faction.hourly_assigned + 2 HOURS) < world.realtime)
					faction.assign_hourly_objective()
		else
			if((faction.hourly_assigned + 2 HOURS) < world.realtime)
				faction.assign_hourly_objective()
		if((faction.hourly_assigned + 1 DAY) < world.realtime)
			faction.hourly_assigned = world.realtime
		if(faction.module.current_level >= 2)
			if(faction.daily_objective)
				if(faction.daily_objective.completed || faction.daily_objective.check_completion())
					if((faction.daily_assigned + 1 DAY) < world.realtime)
						faction.assign_daily_objective()
			else
				if((faction.daily_assigned + 1 DAY) < world.realtime)
					faction.assign_daily_objective()
			if((faction.daily_assigned + 1 DAY) < world.realtime)
				faction.daily_assigned = world.realtime
		if(faction.module.current_level >= 3)
			if(faction.weekly_objective)
				if(faction.weekly_objective.completed || faction.weekly_objective.check_completion())
					if((faction.weekly_assigned + 7 DAY) < world.realtime)
						faction.assign_weekly_objective()
			else
				if((faction.weekly_assigned + 7 DAYS) < world.realtime)
					faction.assign_weekly_objective()
			if((faction.weekly_assigned + 7 DAYS) < world.realtime)
				faction.weekly_assigned = world.realtime






/datum/contract_database/proc/process()
	for(var/datum/recurring_contract/contract in all_contracts)
		contract.process()

/datum/contract_database/proc/get_service_desc(var/service)
	switch(service)
		if(CONTRACT_SERVICE_NONE)
			return ""
		if(CONTRACT_SERVICE_MEDICAL)
			return "The signing party will be able to call in medical emergencies through a medical-response beacon. If its health drops into a critical state, a medical emergency will trigger. For organization contracts this applies to everyone clocked in to the signing organization."
		if(CONTRACT_SERVICE_SECURITY)
			return "Areas trespasser alarms from the signing party will be forwarded to the contracted organization. The signing party will be able to call security emergencies through a security-response beacon. For organization contracts this applies to everyone clocked in to the signing organization (but not areas those employees have leased)."
		if(CONTRACT_SERVICE_LEASE)
			return "As long as this contract is in place, this contracts APC and area it controls will be considered under the control of the signing party. The trespasser alarm will respond based on the settings of the signing party."
		if(CONTRACT_SERVICE_LOAN)
			return "The signing party agrees to automatic payment at the rate specified. Once the balance reaches zero, this contract will automatically complete in good standing. This type of contract can only be cancelled by the issuer."
		if(CONTRACT_SERVICE_MEMBERSHIP)
			return "The signing party agrees to become a voluntary member in the organization. You may recieve emails related to your membership, and it can be cancelled at any time by either party."
	return ""

/datum/contract_database
	var/list/all_contracts = list()
	
/datum/contract_database/after_load()
	if(!islist(all_contracts))
		all_contracts = list()

/datum/contract_database/proc/add_contract(var/datum/recurring_contract/contract)
	var/datum/world_faction/business/faction = get_faction(contract.payee)
	if(contract.auto_pay)
		if(contract.handle_payment())
			contract.add_services()
			all_contracts |= contract
			if(istype(faction))
				faction.contract_objectives(contract.payer, contract.payer_type)
	else
		contract.add_services()
		all_contracts |= contract
		if(istype(faction))
			faction.contract_objectives(contract.payer, contract.payer_type)
/datum/contract_database/proc/get_contracts(var/uid, var/typee)
	var/list/contracts = list()
	for(var/datum/recurring_contract/contract in all_contracts)
		if((contract.payee == uid && contract.payee_type == typee && !contract.payee_clear) || (contract.payer == uid && contract.payer_type == typee && !contract.payer_clear))
			contracts |= contract
	return contracts



/datum/recurring_contract/proc/get_status()
	switch(status)
		if(CONTRACT_STATUS_CANCELLED)
			return "Cancelled"
		if(CONTRACT_STATUS_COMPLETED)
			return "Completed"
		if(CONTRACT_STATUS_OPEN)
			return "Ongoing"

/datum/recurring_contract/proc/get_paytype()
	switch(auto_pay)
		if(CONTRACT_PAY_NONE)
			return "None"
		if(CONTRACT_PAY_HOURLY)
			return "[pay_amount] Hourly"
		if(CONTRACT_PAY_DAILY)
			return "[pay_amount] Daily"
		if(CONTRACT_PAY_WEEKLY)
			return "[pay_amount] Weekly"

/datum/recurring_contract/proc/get_marked(var/uid, var/type = CONTRACT_BUSINESS)
	if(payee_type == type)
		if(uid == payee)
			if(payee_completed)
				return 1
	if(payer_type == type)
		if(uid == payer)
			if(payer_completed)
				return 1

/datum/recurring_contract/proc/handle_payment()
	var/datum/money_account/payer_account
	var/datum/money_account/payee_account
	if(payer_type == CONTRACT_BUSINESS)
		var/datum/world_faction/faction = get_faction(payer)
		if(faction)
			payer_account = faction.central_account
	else
		var/datum/computer_file/report/crew_record/R = Retrieve_Record(payer)
		if(R)
			payer_account = R.linked_account
	if(payer_account)
		if(payee_type == CONTRACT_BUSINESS)
			var/datum/world_faction/faction = get_faction(payee)
			if(faction)
				payee_account = faction.central_account
		else
			var/datum/computer_file/report/crew_record/R = Retrieve_Record(payee)
			if(R)
				payee_account = R.linked_account
		if(payee_account)
			if(payer_account.money >= pay_amount)
				var/datum/transaction/T = new("[payee] (via recurring contract)", "Contract Payment", -pay_amount, "Recurring Contract")
				payer_account.do_transaction(T)
				//transfer the money
				var/datum/transaction/Te = new("[payer] (via recurring contract)", "Contract Payment", pay_amount, "Recurring Contract")
				payee_account.do_transaction(Te)
				last_pay = world.realtime
				if(balance > 0)
					balance -= pay_amount
					if (balance < 0)
						var/datum/transaction/RT = new("[payee] (via recurring contract)", "Reconciliation", -balance, "Recurring Contract")
						payer_account.do_transaction(RT)
						var/datum/transaction/RTe = new("[payer] (via recurring contract)", "Reconciliation", balance, "Recurring Contract")
						payee_account.do_transaction(RTe)
						balance = 0
					if (balance == 0)
						payee_completed = 1
						payer_completed = 1
				return 1
	return 0

/datum/recurring_contract/proc/add_services()
	var/datum/world_faction/faction = get_faction(payee)
	if(!faction) return
	if(CONTRACT_STATUS_OPEN)
		if(func == CONTRACT_SERVICE_MEDICAL)
			if(payer_type == CONTRACT_BUSINESS)
				faction.service_medical_business |= payer
			else
				faction.service_medical_personal |= payer
		if(func == CONTRACT_SERVICE_SECURITY)
			if(payer_type == CONTRACT_BUSINESS)
				faction.service_security_business |= payer
			else
				faction.service_security_personal |= payer

/datum/recurring_contract/proc/remove_services()
	var/datum/world_faction/faction = get_faction(payee)
	if(!faction) return
	if(CONTRACT_STATUS_OPEN)
		if(func == CONTRACT_SERVICE_MEDICAL)
			if(payer_type == CONTRACT_BUSINESS)
				faction.service_medical_business -= payer
			else
				faction.service_medical_personal -= payer
		if(func == CONTRACT_SERVICE_SECURITY)
			if(payer_type == CONTRACT_BUSINESS)
				faction.service_security_business -= payer
			else
				faction.service_security_personal -= payer

/datum/recurring_contract/after_load()
	add_services()

/datum/recurring_contract/proc/update_status()
	if(CONTRACT_STATUS_OPEN)
		if(payee_completed && payer_completed)
			status = CONTRACT_STATUS_COMPLETED
		if(payee_cancelled)
			cancel_party = payee
			status = CONTRACT_STATUS_CANCELLED
			cancel_reason = "Manual Cancel"
		if(payer_cancelled)
			if (balance > 0) return
			cancel_party = payer
			status = CONTRACT_STATUS_CANCELLED
			cancel_reason = "Manual Cancel"
	if(payer_clear && payee_clear)
		GLOB.contract_database.all_contracts -= src

/datum/recurring_contract/proc/process()
	if(auto_pay == CONTRACT_PAY_HOURLY)
		if(world.realtime >= (last_pay + 1 HOUR))
			if(!handle_payment())
				if (balance <= 0)
					cancel_party = payer
					cancel_reason = "Insufficent funds for autopay"
					status = CONTRACT_STATUS_CANCELLED
					remove_services()
	if(auto_pay == CONTRACT_PAY_DAILY)
		if(world.realtime >= (last_pay + 1 DAY))
			if(!handle_payment())
				if (balance <= 0)
					cancel_party = payer
					cancel_reason = "Insufficent funds for autopay"
					status = CONTRACT_STATUS_CANCELLED
					remove_services()
	if(auto_pay == CONTRACT_PAY_WEEKLY)
		if(world.realtime >= (last_pay + 7 DAYS))
			if(!handle_payment())
				if (balance <= 0)
					cancel_party = payer
					cancel_reason = "Insufficent funds for autopay"
					status = CONTRACT_STATUS_CANCELLED
					remove_services()
	update_status()

/datum/recurring_contract
	var/name
	var/payee_type = CONTRACT_BUSINESS
	var/payer_type = CONTRACT_BUSINESS

	var/payee = ""
	var/payer = ""

	var/details = ""

	var/payee_cancelled = 0
	var/payee_completed = 0
	var/payee_clear = 0

	var/payer_cancelled = 0
	var/payer_completed = 0
	var/payer_clear = 0

	var/auto_pay = CONTRACT_PAY_NONE
	var/pay_amount = 0
	var/balance = 0

	var/last_pay = 0 // real time the payment went through

	var/func = "None"

	var/status = CONTRACT_STATUS_OPEN

	var/signer_name = ""

	var/cancel_party = ""
	var/cancel_reason = ""



/datum/stock_market
	var/takedata = 1 HOUR

/datum/stock_market/proc/process()
	if(round_duration_in_ticks > takedata)
		takedata = round_duration_in_ticks + 1 HOUR
		TakeData()
	for(var/datum/world_faction/business/faction in GLOB.all_world_factions)
		faction.verify_orders()

/datum/stock_market/proc/TakeData()
	for(var/datum/world_faction/business/faction in GLOB.all_world_factions)
		faction.stock_sales_data += "[faction.stock_sales]"
		if(faction.stock_sales_data.len > 24)
			faction.stock_sales_data.Cut(1,2)
		faction.stock_sales = 0
		
/datum/stock_order/proc/get_remaining_volume()
	return (volume - filled)
	
/datum/stock_order/proc/get_total_value()
	var/left = volume - filled
	return (price * left)

/datum/stock_order
	var/real_name
	var/price = 0
	var/volume = 0
	var/filled = 0




/datum/material_marketplace
	var/datum/material_market_entry/steel/steel
	var/datum/material_market_entry/glass/glass
	var/datum/material_market_entry/copper/copper
	var/datum/material_market_entry/gold/gold
	var/datum/material_market_entry/silver/silver
	var/datum/material_market_entry/wood/wood
	var/datum/material_market_entry/cloth/cloth
	var/datum/material_market_entry/leather/leather
	var/datum/material_market_entry/phoron/phoron
	var/datum/material_market_entry/diamond/diamond
	var/datum/material_market_entry/uranium/uranium
	var/list/all_products = list()

	var/takedata = 1 HOUR


/datum/material_marketplace/New()
	steel = new()
	glass = new()
	copper = new()
	gold = new()
	silver = new()
	wood = new()
	cloth = new()
	leather = new()
	phoron = new()
	diamond = new()
	uranium = new()
	all_products |= steel
	all_products |= glass
	all_products |= copper
	all_products |= gold
	all_products |= silver
	all_products |= wood
	all_products |= cloth
	all_products |= leather
	all_products |= phoron
	all_products |= diamond
	all_products |= uranium


/datum/material_marketplace/proc/process()
	if(round_duration_in_ticks > takedata)
		takedata = round_duration_in_ticks + 1 HOUR
		TakeData()
	for(var/datum/world_faction/faction in GLOB.all_world_factions)
		faction.rebuild_inventory()
	for(var/datum/material_market_entry/entry in all_products)
		entry.verify_orders()

/datum/material_marketplace/proc/TakeData()
	for(var/datum/material_market_entry/entry in all_products)
		entry.sales_data += "[entry.sales]"
		if(entry.sales_data.len > 24)
			entry.sales_data.Cut(1,2)
		entry.sales = 0
/datum/material_market_entry
	var/name = ""
	var/typepath = /obj/item/stack/material
	var/PriorityQueue/buyorders
	var/PriorityQueue/sellorders
	var/sales = 0 // sales this hour
	var/list/sales_data = list() // sales in the past 24 hours

/datum/material_market_entry/New()
	buyorders = new /PriorityQueue(/proc/cmp_buyorders)
	sellorders = new /PriorityQueue(/proc/cmp_sellorders)

/datum/material_market_entry/proc/get_last_hour()
	if(!sales_data.len) return 0
	return text2num(sales_data[sales_data.len])

/datum/material_market_entry/proc/get_last_24()
	var/total = 0
	for(var/x in sales_data)
		total += text2num(x)
	return total

/datum/material_market_entry/proc/get_best_buy()
	if(!buyorders.L.len) return null
	var/datum/material_order/order = buyorders.L[1]
	if(order)
		return order.price
/datum/material_market_entry/proc/get_best_sell()
	if(!sellorders.L.len) return null
	var/datum/material_order/order = sellorders.L[1]
	if(order)
		return order.price


/datum/material_market_entry/proc/fill_order(var/datum/material_order/buyorder, var/datum/material_order/sellorder)
	if(buyorder.price > sellorder.price) return
	var/buyer_name = ""
	var/seller_name = ""
	var/datum/world_faction/buyerfaction
	var/datum/world_faction/sellerfaction
	var/moving = min(buyorder.get_remaining_volume(), sellorder.get_remaining_volume())
	var/cost = moving*sellorder.price
	if(buyorder.admin_order)
		buyer_name = "Nexus Economic Module"
	else
		buyerfaction = get_faction(buyorder.faction_uid)
		if(!buyerfaction || !buyerfaction.cargo_telepads.len)
			buyorders.L -= buyorder
			return 0
		buyer_name = buyerfaction.name
	if(sellorder.admin_order)
		seller_name = "Nexus Economic Module"
	else
		sellerfaction = get_faction(sellorder.faction_uid)
		if(!sellerfaction)
			sellorders.L -= sellorder
			return 0
		seller_name = sellerfaction

	if(!buyerfaction || buyerfaction.central_account.money >= cost)
		if(!sellerfaction || sellerfaction.take_inventory(typepath, moving))
			if(buyerfaction)
				buyerfaction.give_inventory(typepath, moving)
				var/datum/transaction/T = new("[seller_name]", "Buy Order for [moving] units of [name]", -cost, "Material Marketplace")
				buyerfaction.central_account.do_transaction(T)
			if(sellerfaction)
				//transfer the money
				var/datum/transaction/Te = new("[buyer_name]", "Sell Order for [moving] units of [name]", cost, "Material Marketplace")
				sellerfaction.central_account.do_transaction(Te)
			sellorder.filled += moving
			buyorder.filled += moving
			sales += moving
			if(!sellorder.get_remaining_volume())
				sellorders.L -= sellorder
			if(!buyorder.get_remaining_volume())
				buyorders.L -= buyorder
		else
			sellorders.L -= sellorder
			return 0
	else
		buyorders.L -= buyorder
		return 0

/datum/material_market_entry/proc/cancel_order(var/datum/material_order/order)
	buyorders.L -= order
	sellorders.L -= order

/datum/material_market_entry/proc/add_buyorder(var/price, var/volume, var/faction_uid)
	var/datum/material_order/order = new()
	order.price = price
	order.volume = volume
	order.faction_uid = faction_uid
	for(var/datum/material_order/sell_order in sellorders.L)
		if(!order.get_remaining_volume()) break
		if(sell_order.price <= order.price)
			fill_order(order, sell_order)
	if(!order.get_remaining_volume()) // order filled
		return 1
	buyorders.Enqueue(order)

/datum/material_market_entry/proc/add_sellorder(var/price, var/volume, var/faction_uid)
	var/datum/material_order/order = new()
	order.price = price
	order.volume = volume
	order.faction_uid = faction_uid
	for(var/datum/material_order/buy_order in buyorders.L)
		if(!order.get_remaining_volume()) break
		if(order.price <= buy_order.price)
			fill_order(buy_order, order)
	if(!order.get_remaining_volume()) // order filled
		return 1
	sellorders.Enqueue(order)

/datum/material_market_entry/proc/get_buyvolume()
	var/volume = 0
	for(var/datum/material_order/buy_order in buyorders.L)
		volume += buy_order.volume
	return volume

/datum/material_market_entry/proc/get_sellvolume()
	var/volume = 0
	for(var/datum/material_order/sell_order in sellorders.L)
		volume += sell_order.volume
	return volume


/datum/material_market_entry/proc/get_buyprice(var/volume)
	var/final_price = 0
	var/remaining_volume = volume
	for(var/datum/material_order/sell_order in sellorders.L)
		if(!remaining_volume) break
		var/transact = min(sell_order.get_remaining_volume(), remaining_volume)
		final_price += transact*sell_order.price
		remaining_volume -= transact
	return final_price
		
		
/datum/material_market_entry/proc/verify_orders()
	for(var/datum/material_order/order in buyorders.L)
		if(order.admin_order) continue
		var/datum/world_faction/faction = get_faction(order.faction_uid)
		if(!faction || !faction.central_account)
			buyorders.L -= order
			continue
		if(faction.central_account.money < order.get_total_value())
			buyorders.L -= order
			continue
	for(var/datum/material_order/order in sellorders.L)
		if(order.admin_order) continue
		var/datum/world_faction/faction = get_faction(order.faction_uid)
		if(!faction || !faction.inventory)
			sellorders.L -= order
			continue
		if(faction.inventory.vars[name] < order.get_remaining_volume())
			sellorders.L -= order
			continue




/datum/material_market_entry/proc/add_buyorder_admin(var/price, var/volume)
	var/datum/material_order/order = new()
	order.price = price
	order.volume = volume
	order.admin_order = 1
	for(var/datum/material_order/sell_order in sellorders.L)
		if(!order.get_remaining_volume()) break
		if(sell_order.price <= order.price)
			fill_order(order, sell_order)
	if(!order.get_remaining_volume()) // order filled
		return 1
	buyorders.Enqueue(order)


	
	
/datum/material_market_entry/proc/add_sellorder_admin(var/price, var/volume)
	var/datum/material_order/order = new()
	order.price = price
	order.volume = volume
	order.admin_order = 1
	for(var/datum/material_order/buy_order in buyorders.L)
		if(!order.get_remaining_volume()) break
		if(order.price <= buy_order.price)
			fill_order(buy_order, order)
	if(!order.get_remaining_volume()) // order filled
		return 1
	sellorders.Enqueue(order)




/datum/material_market_entry/proc/quick_buy(var/volume, var/faction_uid)
	var/final_price = 0
	var/remaining_volume = volume
	for(var/datum/material_order/sell_order in sellorders.L)
		if(!remaining_volume) break
		var/transact = min(sell_order.get_remaining_volume(), remaining_volume)
		final_price += transact*sell_order.price
		remaining_volume -= transact
	add_buyorder(final_price, volume, faction_uid)

/datum/material_market_entry/proc/get_sellprice(var/volume)
	var/final_price = 0
	var/remaining_volume = volume
	for(var/datum/material_order/buy_order in buyorders.L)
		if(!remaining_volume) break
		var/transact = min(buy_order.get_remaining_volume(), remaining_volume)
		final_price += transact*buy_order.price
		remaining_volume -= transact
	return final_price

/datum/material_market_entry/proc/quick_sell(var/volume, var/faction_uid)
	var/final_price = 0
	var/remaining_volume = volume
	for(var/datum/material_order/buy_order in buyorders.L)
		if(!remaining_volume) break
		var/transact = min(buy_order.get_remaining_volume(), remaining_volume)
		final_price += transact*buy_order.price
		remaining_volume -= transact
	add_sellorder(final_price, volume, faction_uid)


/datum/material_order/proc/get_remaining_volume()
	return (volume - filled)
/datum/material_order/proc/get_total_value()
	var/left = volume - filled
	return (price * left)

/datum/material_order
	var/faction_uid
	var/price = 0
	var/volume = 0
	var/filled = 0
	var/admin_order = 0 // if this order is non-factional and should spawn materials.



/datum/material_market_entry/steel
	name = "steel"
	typepath = /obj/item/stack/material/steel

/datum/material_market_entry/glass
	name = "glass"
	typepath = /obj/item/stack/material/glass

/datum/material_market_entry/copper
	name = "copper"
	typepath = /obj/item/stack/material/copper

/datum/material_market_entry/gold
	name = "gold"
	typepath = /obj/item/stack/material/gold

/datum/material_market_entry/silver
	name = "silver"
	typepath = /obj/item/stack/material/silver

/datum/material_market_entry/wood
	name = "wood"
	typepath = /obj/item/stack/material/wood

/datum/material_market_entry/cloth
	name = "cloth"
	typepath = /obj/item/stack/material/cloth

/datum/material_market_entry/leather
	name = "leather"
	typepath = /obj/item/stack/material/leather

/datum/material_market_entry/phoron
	name = "phoron"
	typepath = /obj/item/stack/material/phoron

/datum/material_market_entry/diamond
	name = "diamond"
	typepath = /obj/item/stack/material/diamond

/datum/material_market_entry/uranium
	name = "uranium"
	typepath = /obj/item/stack/material/uranium
