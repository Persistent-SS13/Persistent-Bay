/datum/computer_file/program/stockmarket
	filename = "stockmarket"
	filedesc = "Public Stockmarket"
	nanomodule_path = /datum/nano_module/program/stockmarket
	program_icon_state = "supply"
	program_menu_icon = "cart"
	extended_desc = "A program to access the stockmarket where ownership of businesses can be bought and sold."
	size = 21
	requires_ntnet = TRUE
	category = PROG_BUSINESS
	usage_flags = PROGRAM_ALL


/datum/nano_module/program/stockmarket
	name = "Public Stockmarket"
	var/menu = 1
	var/datum/world_faction/business/selected_stock
	var/selected_amount = 0
	var/selected_price = 0
	var/buy_ordering = 0

/datum/nano_module/program/stockmarket/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/datum/computer_file/report/crew_record/R = Retrieve_Record(usr.real_name)
	if(menu == 1)
		var/list/formatted_stocks[0]
		for(var/datum/world_faction/business/entry in GLOB.all_world_factions)
			if(!entry.public_stock) continue
			var/bestbuy = entry.get_best_buy()
			if(isnull(bestbuy)) bestbuy = "none"
			var/bestsell = entry.get_best_sell()
			if(isnull(bestsell)) bestsell = "none"
			formatted_stocks[++formatted_stocks.len] = list("name" = entry.name, "ref" = "\ref[entry]", "buy" = bestbuy, "sell" = bestsell, "amount" = entry.get_last_hour(), "amount24" = entry.get_last_24())
		data["stocks"] = formatted_stocks
	if(menu == 2)
		var/list/formatted_orders[0]
		var/list/formatted_holdings[0]
		for(var/datum/world_faction/business/entry in GLOB.all_world_factions)
			for(var/datum/stock_order/order in entry.buyorders.L)
				if(order.real_name == usr.real_name)
					formatted_orders[++formatted_orders.len] = list("name" = "Order to buy [order.volume] [entry.uid] at $$[order.price] per stock.", "ref" = "\ref[entry]", "ref2" = "\ref[order]")
			for(var/datum/stock_order/order in entry.sellorders.L)
				if(order.real_name == usr.real_name)
					formatted_orders[++formatted_orders.len] = list("name" = "Order to sell [order.volume] [entry.uid] at [order.price] per stock.", "ref" = "\ref[entry]", "ref2" = "\ref[order]")
			var/stock_hold = entry.get_stockholder(usr.real_name)
			if(stock_hold)
				formatted_holdings[++formatted_holdings.len] = list("name" = "[stock_hold] stocks in [entry.uid] ([entry.name])")
		data["holdings"] = formatted_holdings
		data["orders"] = formatted_orders
	if(menu == 3)
		if(!selected_stock)
			menu = 1
			return
		data["selected_stock"] = selected_stock.uid
		data["stock_name"] = selected_stock.name
		data["holdings"] = selected_stock.get_stockholder(usr.real_name)
		var/bestbuy = selected_stock.get_best_buy()
		if(isnull(bestbuy)) bestbuy = "none"
		var/bestsell = selected_stock.get_best_sell()
		if(isnull(bestsell)) bestsell = "none"
		data["buy"] = bestbuy
		data["sell"] = bestsell
		data["sold"] = selected_stock.get_last_hour()
		data["sold24"] = selected_stock.get_last_24()
		data["balance"] = R.linked_account.money
		data["buy_ordering"] = buy_ordering
		data["selected_amount"] = selected_amount
		data["selected_price"] = selected_price
		if(selected_price && selected_amount)
			data["order_value"] = selected_price*selected_amount
		else
			data["order_value"] = "none"
		if(buy_ordering)
			data["order_status"] = "buy"
		else
			data["order_status"] = "sell"
		var/list/formatted_buyorders[0]
		for(var/datum/stock_order/order in selected_stock.buyorders.L)
			formatted_buyorders[++formatted_buyorders.len] = list("price" = order.price, "volume" = order.volume)
		data["buy_orders"] = formatted_buyorders
		var/list/formatted_sellorders[0]
		for(var/datum/stock_order/order in selected_stock.sellorders.L)
			formatted_sellorders[++formatted_sellorders.len] = list("price" = order.price, "volume" = order.volume)
		data["sell_orders"] = formatted_sellorders
	if(menu == 4)
		data["selected_stock"] = selected_stock.uid
		data["stock_name"] = selected_stock.name		
		data["ceo_name"] = selected_stock.get_ceo()
		data["ceo_wage"] = selected_stock.get_ceo_wage()
		data["ceo_revenue"] = "[selected_stock.ceo_tax]%"
		data["stockholder_revenue"] = "[selected_stock.stockholder_tax]%"
		data["business_balance"] = selected_stock.central_account.money
		data["stock_listed"] = selected_stock.public_stock
	data["menu"] = menu
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "stockmarket.tmpl", name, 600, 800, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/stockmarket/Topic(href, href_list)
	if(..())
		return 1
	. = SSnano.update_uis(src)
	var/datum/computer_file/report/crew_record/R = Retrieve_Record(usr.real_name)
	switch(href_list["action"])
		if("change_menu")
			menu = text2num(href_list["menu_target"])
			selected_amount = 0
			selected_stock = null
			selected_price = 0
			buy_ordering = 0

		if("select_stock")
			selected_stock = locate(href_list["ref"])
			menu = 3

		if("change_amount")
			selected_amount = max(input(usr, "Enter the new amount", "Amount") as null|num, 0)

		if("change_price")
			selected_price = max(input(usr, "Enter the new amount", "Amount") as null|num, 0)

		if("cancel_order")
			var/datum/material_market_entry/entry = locate(href_list["ref"])
			var/datum/material_order/order = locate(href_list["ref2"])
			if(entry && order)
				entry.cancel_order(order)

		if("details")
			menu = 4
		if("back_select")
			menu = 3
		if("select_buy")
			buy_ordering = 1
		if("select_sell")
			buy_ordering = 0

		if("finalize")
			if(!selected_amount || !selected_stock || !selected_price || !selected_stock.public_stock)
				return
			if(buy_ordering)
				var/final_price = selected_amount * selected_price
				if((selected_amount + R.get_holdings()) > R.get_stock_limit())
					to_chat(usr, "This order will exceed your stock limit.")
					return
				if(final_price > R.linked_account.money)
					to_chat(usr, "There is not enough money in your account to complete this order.")
					return
				selected_stock.add_buyorder(selected_price, selected_amount, usr.real_name)
			else
				var/holding = selected_stock.get_stockholder(usr.real_name)
				if(holding < selected_amount)
					to_chat(usr, "You do not own enough stock to complete this order.")
					return
				selected_stock.add_sellorder(selected_price, selected_amount, usr.real_name)