/datum/computer_file/program/materialmarket
	filename = "materialmarket"
	filedesc = "Material Marketplace"
	nanomodule_path = /datum/nano_module/program/materialmarket
	program_icon_state = "supply"
	program_menu_icon = "cart"
	extended_desc = "A program to access the material marketplace where telepads can be used to buy and sell materials."
	size = 4
	requires_ntnet = TRUE
	required_access = core_access_materials
	category = PROG_BUSINESS
	usage_flags = PROGRAM_ALL
	

/datum/nano_module/program/materialmarket
	name = "Material Marketplace"
	var/menu = 1
	var/datum/material_market_entry/selected_material
	var/selected_amount = 0
	var/selected_price = 0
	var/obj/machinery/telepad_cargo/selected_telepad
	var/buy_ordering = 0


/datum/nano_module/program/materialmarket/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/datum/world_faction/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	if(menu == 1)
		var/list/formatted_materials[0]
		for(var/datum/material_market_entry/entry in GLOB.material_marketplace.all_products)
			var/bestbuy = entry.get_best_buy()
			if(isnull(bestbuy)) bestbuy = "none"
			var/bestsell = entry.get_best_sell()
			if(isnull(bestsell)) bestsell = "none"
			formatted_materials[++formatted_materials.len] = list("name" = entry.name, "ref" = "\ref[entry]", "buy" = bestbuy, "sell" = bestsell, "amount" = entry.get_last_hour(), "amount24" = entry.get_last_24())
		data["materials"] = formatted_materials
	if(menu == 2)
		data["balance"] = connected_faction.central_account.money
		data["selected_amount"] = selected_amount
		var/list/formatted_telepads[0]
		for(var/obj/machinery/telepad_cargo/telepad in connected_faction.cargo_telepads)
			var/selected = 0
			if(telepad == selected_telepad) selected = 1
			formatted_telepads[++formatted_telepads.len] = list("name" = telepad.name, "ref" = "\ref[telepad]", "selected" = selected)
		data["telepads"] = formatted_telepads
		if(selected_material)
			data["selected_material"] = selected_material.name
			data["supply"] = selected_material.get_sellvolume()
			if(selected_amount)
				data["calc_price"] = selected_material.get_buyprice(selected_amount)
			else
				data["calc_price"] = "none"

		else
			data["selected_material"] = "*NONE*"
			data["supply"] = "none"
			data["calc_price"] = "none"
	if(menu == 3)
		data["balance"] = connected_faction.central_account.money
		data["selected_amount"] = selected_amount
		var/list/formatted_telepads[0]
		for(var/obj/machinery/telepad_cargo/telepad in connected_faction.cargo_telepads)
			var/selected = 0
			if(telepad == selected_telepad) selected = 1
			formatted_telepads[++formatted_telepads.len] = list("name" = telepad.name, "ref" = "\ref[telepad]", "selected" = selected)
		data["telepads"] = formatted_telepads
		if(selected_material)
			data["selected_material"] = selected_material.name
			data["demand"] = selected_material.get_buyvolume()
			data["inventory"] = connected_faction.inventory.vars[selected_material.name]
			if(selected_amount)
				data["calc_price"] = selected_material.get_sellprice(selected_amount)
			else
				data["calc_price"] = "none"

		else
			data["selected_material"] = "*NONE*"
			data["inventory"] = "none"
			data["demand"] = "none"
			data["calc_price"] = "none"

	if(menu == 4)
		var/list/formatted_orders[0]
		for(var/datum/material_market_entry/entry in GLOB.material_marketplace.all_products)
			for(var/datum/material_order/order in entry.buyorders.L)
				if(order.faction_uid == connected_faction.uid)
					formatted_orders[++formatted_orders.len] = list("name" = "Order to buy [order.volume] [entry.name] at $$[order.price] per unit.", "ref" = "\ref[entry]", "ref2" = "\ref[order]")
			for(var/datum/material_order/order in entry.sellorders.L)
				if(order.faction_uid == connected_faction.uid)
					formatted_orders[++formatted_orders.len] = list("name" = "Order to sell [order.volume] [entry.name] at [order.price] per unit.", "ref" = "\ref[entry]", "ref2" = "\ref[order]")
		data["orders"] = formatted_orders
		var/list/formatted_telepads[0]
		for(var/obj/machinery/telepad_cargo/telepad in connected_faction.cargo_telepads)
			var/selected = 0
			if(telepad == connected_faction.default_telepad) selected = 1
			formatted_telepads[++formatted_telepads.len] = list("name" = telepad.name, "ref" = "\ref[telepad]", "selected" = selected)
		data["telepads"] = formatted_telepads
		var/list/formatted_materials[0]
		for(var/datum/material_market_entry/entry in GLOB.material_marketplace.all_products)
			var/amount = connected_faction.inventory.vars[entry.name]
			formatted_materials[++formatted_materials.len] = list("name" = "[entry.name] : [amount]")
		data["materials"] = formatted_materials
	if(menu == 5)
		if(!selected_material)
			menu = 1
			return
		data["selected_material"] = selected_material.name
		var/bestbuy = selected_material.get_best_buy()
		if(isnull(bestbuy)) bestbuy = "none"
		var/bestsell = selected_material.get_best_sell()
		if(isnull(bestsell)) bestsell = "none"
		data["buy"] = bestbuy
		data["sell"] = bestsell
		data["sold"] = selected_material.get_last_hour()
		data["sold24"] = selected_material.get_last_24()
		data["balance"] = connected_faction.central_account.money
		data["inventory"] = connected_faction.inventory.vars[selected_material.name]
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
		for(var/datum/material_order/order in selected_material.buyorders.L)
			formatted_buyorders[++formatted_buyorders.len] = list("price" = order.price, "volume" = order.volume)
		data["buy_orders"] = formatted_buyorders
		var/list/formatted_sellorders[0]
		for(var/datum/material_order/order in selected_material.sellorders.L)
			formatted_sellorders[++formatted_sellorders.len] = list("price" = order.price, "volume" = order.volume)
		data["sell_orders"] = formatted_sellorders
	
	data["menu"] = menu
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "materialmarket.tmpl", name, 600, 800, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/materialmarket/Topic(href, href_list)
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
			selected_amount = 0
			selected_material = null
			selected_telepad = null
			selected_price = 0
			buy_ordering = 0

		if("select_material")
			selected_material = locate(href_list["ref"])
			menu = 5
		if("change_material")
			var/starting_material = selected_material
			var/new_material = input(usr, "Choose material", "Material") as null|anything in GLOB.material_marketplace.all_products
			if(starting_material == selected_material)
				selected_material = new_material
			else
				to_chat(usr, "The input timed out.")

		if("change_amount")
			selected_amount = max(input(usr, "Enter the new amount", "Amount") as null|num, 0)

		if("change_price")
			selected_price = max(input(usr, "Enter the new amount", "Amount") as null|num, 0)

		if("select_telepad")
			selected_telepad = locate(href_list["ref"])

		if("quick_buy")
			if(!selected_amount || !selected_material || !selected_telepad)
				return
			if(selected_amount > selected_material.get_sellvolume())
				to_chat(usr, "There is not enough supply to buy [selected_amount] units.")
				return
			if(selected_material.get_buyprice(selected_amount) > connected_faction.central_account.money)
				to_chat(usr, "There is not enough money in the account to complete the transaction.")
				return
			var/real_default = connected_faction.default_telepad
			connected_faction.default_telepad = selected_telepad
			selected_material.quick_buy(selected_amount, connected_faction.uid)
			connected_faction.default_telepad = real_default
		if("refresh_inv")
			connected_faction.rebuild_inventory()
		if("quick_sell")
			if(!selected_amount || !selected_material)
				return
			if(selected_amount > selected_material.get_buyvolume())
				to_chat(usr, "There is not enough demand to sell [selected_amount] units.")
				return
			var/inventory = connected_faction.inventory.vars[selected_material.name]
			if(inventory < selected_amount)
				to_chat(usr, "There is not enough inventory stacked on the telepads to complete this order.")
				return
			selected_material.quick_sell(selected_amount, connected_faction.uid)

		if("cancel_order")
			var/datum/material_market_entry/entry = locate(href_list["ref"])
			var/datum/material_order/order = locate(href_list["ref2"])
			if(entry && order)
				entry.cancel_order(order)

		if("select_telepad_default")
			var/telepad = locate(href_list["ref"])
			if(telepad)
				connected_faction.default_telepad = telepad
		if("select_buy")
			buy_ordering = 1
		if("select_sell")
			buy_ordering = 0

		if("finalize")
			if(!selected_amount || !selected_material || !selected_price)
				return
			if(buy_ordering)
				var/final_price = selected_amount * selected_price
				if(final_price > connected_faction.central_account.money)
					to_chat(usr, "There is not enough money in the account to complete this order.")
					return
				selected_material.add_buyorder(selected_price, selected_amount, connected_faction.uid)
			else
				var/inventory = connected_faction.inventory.vars[selected_material.name]
				if(inventory < selected_amount)
					to_chat(usr, "There is not enough inventory stacked on the telepads to complete this order.")
					return
				selected_material.add_sellorder(selected_price, selected_amount, connected_faction.uid)