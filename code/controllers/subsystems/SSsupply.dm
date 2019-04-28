GLOBAL_DATUM_INIT(material_marketplace, /datum/material_marketplace, new)

SUBSYSTEM_DEF(supply)
	name = "Supply"
	wait = 30 SECONDS
	flags = SS_NO_INIT


/datum/controller/subsystem/supply/fire(resumed = FALSE)
	supply_controller.process()
	GLOB.material_marketplace.process()

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
