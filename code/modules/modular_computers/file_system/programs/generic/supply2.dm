/datum/computer_file/program/supply
	filename = "supply"
	filedesc = "Supply Management"
	nanomodule_path = /datum/nano_module/program/supply
	program_icon_state = "supply"
	program_menu_icon = "cart"
	extended_desc = "A management tool that allows for ordering of various supplies through the facility's cargo system. Some features may require additional access."
	size = 21
	available_on_ntnet = 1
	requires_ntnet = 1

/datum/computer_file/program/supply/process_tick()
	..()
	var/datum/nano_module/program/supply/SNM = NM
	if(istype(SNM))
		SNM.emagged = computer_emagged

/datum/nano_module/program/supply
	name = "Supply Management program"
	var/screen = 1		// 0: Ordering menu, 1: Statistics 2: Shuttle control, 3: Orders menu
	var/selected_category
	var/list/category_names
	var/list/category_contents
	var/emagged = FALSE	// TODO: Implement synchronisation with modular computer framework.
	var/current_security_level
	var/list/selected_telepads = list()
	var/list/selected_telepads_export = list()
	var/list/selected_telepads_revoke = list()
	var/curr_page = 1

/datum/nano_module/program/supply/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/datum/world_faction/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	if(!connected_faction)
		program.computer.kill_program()
	var/is_admin = (check_access(user, core_access_order_approval, connected_faction.uid) || check_access(user, core_access_invoicing, connected_faction.uid))
	var/is_superadmin = (check_access(user, core_access_command_programs, connected_faction.uid))

	data["faction_name"] = connected_faction.name
	data["credits"] = connected_faction.central_account.money
	data["is_admin"] = is_admin
	data["is_superadmin"] = is_superadmin


	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
	if(!category_names || !category_contents || current_security_level != security_state.current_security_level)
		generate_categories()
		current_security_level = security_state.current_security_level
	data["can_print"] = can_print()
	data["screen"] = screen
	switch(screen)
		if(1)// Main ordering menu
			data["categories"] = category_names
			if(selected_category)
				data["category"] = selected_category
				data["possible_purchases"] = category_contents[selected_category]

		if(2)// Statistics screen with credit overview

			var/list/transactions = connected_faction.central_account.transaction_log
			var/pages = transactions.len/10
			if(pages < 1)
				pages = 1
			var/list/formatted_transactions[0]
			if(transactions.len)
				for(var/i=0; i<10; i++)
					var/minus = i+(10*(curr_page-1))
					if(minus >= transactions.len) break
					var/datum/transaction/T = transactions[transactions.len-minus]
					formatted_transactions[++formatted_transactions.len] = list("date" = T.date, "time" = T.time, "target_name" = T.target_name, "purpose" = T.purpose, "amount" = T.amount ? T.amount : 0)
			data["transactions"] = formatted_transactions
			data["page"] = curr_page
			data["page_up"] = curr_page < pages
			data["page_down"] = curr_page > 1

		if(3) // order confirmation and telepad control
			var/list/telepads[0]
			for(var/obj/machinery/telepad_cargo/telepad in connected_faction.cargo_telepads)
				telepads.Add(list(list(
					"name" = telepad.name,
					"ref" = "\ref[telepad]",
					"selected" = (telepad in selected_telepads)
				)))
				data["telepads"] = telepads
		if(4)// Order processing
			var/list/cart[0]
			var/list/requests[0]
			for(var/datum/supply_order/SO in connected_faction.approved_orders)
				cart.Add(list(list(
					"id" = SO.ordernum,
					"object" = SO.object.name,
					"orderer" = SO.orderedby,
					"cost" = "[SO.object.cost*10]/[SO.object.cost*10+(SO.object.cost*10/100*connected_faction.import_profit)]",
					"reason" = SO.reason
				)))
			for(var/datum/supply_order/SO in connected_faction.pending_orders)
				requests.Add(list(list(
					"id" = SO.ordernum,
					"object" = SO.object.name,
					"orderer" = SO.orderedby,
					"cost" = SO.object.cost*10,
					"reason" = SO.reason
					)))
			data["cart"] = cart
			data["requests"] = requests
		if(5) // export view..
			var/list/exports[0]
			for(var/datum/export_order/order in supply_controller.all_exports)
				exports.Add(list(list(
					"name" = order.name,
					"required" = order.required,
					"supplied" = order.supplied,
					"id" = "\ref[order]"
				)))
			data["exports"] = exports
		if(6)
			var/list/telepads[0]
			for(var/obj/machinery/telepad_cargo/telepad in connected_faction.cargo_telepads)
				telepads.Add(list(list(
					"name" = telepad.name,
					"ref" = "\ref[telepad]",
					"selected" = (telepad in selected_telepads_export)
				)))
				data["telepads"] = telepads
		if(7) // revoke telepads
			var/list/telepads[0]
			for(var/obj/machinery/telepad_cargo/telepad in connected_faction.cargo_telepads)
				telepads.Add(list(list(
					"name" = telepad.name,
					"ref" = "\ref[telepad]",
					"selected" = (telepad in selected_telepads_revoke)
				)))
				data["telepads"] = telepads

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "supply.tmpl", name, 1050, 800, state = state)
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/supply/Topic(href, href_list)
	var/mob/user = usr
	if(..())
		return 1
	var/datum/world_faction/connected_faction
	var/obj/item/weapon/card/id/user_id_card = usr.GetIdCard()
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	if(!connected_faction)
		return 1


	if(href_list["select_category"])
		selected_category = href_list["select_category"]
		return 1

	if(href_list["set_screen"])
		screen = text2num(href_list["set_screen"])
		return 1
	if(href_list["toggle_telepad"])
		var/obj/machinery/telepad_cargo/telepad = locate(href_list["toggle_telepad"])
		if(!selected_telepads) selected_telepads = list()
		if(telepad in selected_telepads)
			selected_telepads -= telepad
		else
			selected_telepads |= telepad
		return 1
	if(href_list["toggle_telepad_export"])
		var/obj/machinery/telepad_cargo/telepad = locate(href_list["toggle_telepad_export"])
		if(telepad in selected_telepads_export)
			selected_telepads_export -= telepad
		else
			selected_telepads_export |= telepad
		return 1
	if(href_list["toggle_telepad_revoke"])
		var/obj/machinery/telepad_cargo/telepad = locate(href_list["toggle_telepad_revoke"])
		if(telepad in selected_telepads_revoke)
			selected_telepads_revoke -= telepad
		else
			selected_telepads_revoke |= telepad
		return 1
	if(href_list["order"])
		var/decl/hierarchy/supply_pack/P = locate(href_list["order"]) in supply_controller.master_supply_list
		if(!istype(P) || P.is_category())
			return 1

		if(P.hidden && !emagged)
			return 1

		var/reason = sanitize(input(user,"Reason:","Why do you require this item?","") as null|text,,0)
		if(!reason)
			return 1

		var/idname = "*None Provided*"
		var/idrank = "*None Provided*"
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			idname = H.get_authentification_name()
			idrank = H.get_assignment()
		else if(issilicon(user))
			idname = user.real_name

		supply_controller.ordernum++

		var/datum/supply_order/O = new /datum/supply_order()
		O.ordernum = supply_controller.ordernum
		O.object = P
		O.orderedby = idname
		O.reason = reason
		O.orderedrank = idrank
		O.comment = "#[O.ordernum]"
		connected_faction.pending_orders += O
		return 1
	if(href_list["print_export"])
		if(!check_access(core_access_invoicing)) return
		if(!can_print())
			return
		print_export(user, href_list["print_export"])

		return 1

	if(href_list["print_export2"])
		if(!check_access(core_access_invoicing)) return
		if(!can_print())
			return
		print_export_business(user, href_list["print_export2"])

		return 1

	if(href_list["print_summary"])
		if(!can_print())
			return
		print_summary(user)

	// Items requiring cargo access go below this entry. Other items go above.


	if(href_list["launch_shuttle"])
		var/datum/shuttle/autodock/ferry/supply/shuttle = supply_controller.shuttle
		if(!shuttle)
			to_chat(user, "<span class='warning'>Error connecting to the shuttle.</span>")
			return
		if(shuttle.at_station())
			if (shuttle.forbidden_atoms_check())
				to_chat(usr, "<span class='warning'>For safety reasons the automated supply shuttle cannot transport live organisms, classified nuclear weaponry or homing beacons.</span>")
			else
				shuttle.launch(user)
		else
			shuttle.launch(user)
			var/datum/radio_frequency/frequency = radio_controller.return_frequency(1435)
			if(!frequency)
				return

			var/datum/signal/status_signal = new
			status_signal.source = src
			status_signal.transmission_method = 1
			status_signal.data["command"] = "supply"
			frequency.post_signal(src, status_signal)
		return 1
	if(href_list["revoke_pad"])
		if(!check_access(core_access_command_programs))
			to_chat(usr, "Access Denied.")
			return 1
		var/revoked = 0
		for(var/obj/machinery/telepad_cargo/telepad in selected_telepads_revoke)
			if(connected_faction)
				connected_faction.cargo_telepads -= telepad
			telepad.connected_faction = null
			telepad.req_access_faction = null
			revoked += 1
		to_chat(usr, "Revoked network connection for " + revoked + " telepads.")
	if(href_list["launch_export"])
		if(!check_access(core_access_invoicing))
			to_chat(usr, "Access Denied.")
			return 1
		var/sent = 0
		var/earned = 0
		if(!selected_telepads_export.len)
			to_chat(usr, "No telepads selected to use.")
		for(var/obj/machinery/telepad_cargo/telepad in selected_telepads_export)
			var/turf/T = telepad.loc
			if(T.density)	continue
			for(var/obj/structure/closet/closet in T.contents)
				for(var/obj/item/weapon/paper/export/export in closet.contents)
					if(export.business_name)
						var/datum/small_business/business = get_business(export.business_name)
						if(business)
							var/earn = supply_controller.fill_order(export.export_id, closet)
							if(earn)
								var/datum/transaction/Te = new("Central Authority Exports", "Export ([export.name])", earn, 1)
								business.central_account.do_transaction(Te)
								earned += business.pay_export_tax(earn, connected_faction)
								sent++
						break
					else if(export.business_name == 0)
						var/earn = supply_controller.fill_order(export.export_id, closet)
						if(earn)
							var/datum/transaction/Te = new("Central Authority Exports", "Export ([export.name])", earn, 1)
							connected_faction.central_account.do_transaction(Te)
							earned += earn
							sent++
						break
				break
		to_chat(usr, "Export protocol completed, [sent] orders were succesfully sent and [earned] $$ was put into the account.")
	if(href_list["launch_order"])
		if(!check_access(core_access_order_approval))
			to_chat(usr, "Access Denied.")
			return 1
		if(!connected_faction.approved_orders) return
		if(!selected_telepads.len)
			to_chat(usr, "No telepads selected to use.")
		var/list/clear_turfs = list()
		for(var/obj/machinery/telepad_cargo/telepad in selected_telepads)
			var/turf/T = telepad.loc
			if(T.density)	continue
			var/contcount
			for(var/atom/A in T.contents)
				if(!A.density)
					continue
				contcount++
			if(contcount)
				continue
			clear_turfs += T
		if(!clear_turfs.len)
			to_chat(usr, "All selected telepads are obstructed. Clear telepads and try again.")
		for(var/S in connected_faction.approved_orders)
			if(!clear_turfs.len)
				to_chat(usr, "Not enough unobstructed telepads to complete the order. Clear telepads and try again to recieve the remaining shipment.")
				break
			var/i = rand(1,clear_turfs.len)
			var/turf/pickedloc = clear_turfs[i]
			clear_turfs.Cut(i,i+1)
			connected_faction.approved_orders -= S

			var/datum/supply_order/SO = S
			var/decl/hierarchy/supply_pack/SP = SO.object
			playsound(pickedloc,'sound/effects/teleport.ogg',40,1)
			var/obj/A = new SP.containertype(pickedloc)
			A.name = "[SP.containername][SO.comment ? " ([SO.comment])":"" ][SO.paidby ? "(For [SO.paidby])":""]"
			//supply manifest generation begin

			var/obj/item/weapon/paper/manifest/slip
			if(!SP.contraband)
				slip = new /obj/item/weapon/paper/manifest(A)
				slip.is_copy = 0
				slip.info = "<h3>[connected_faction.name] Shipping Manifest</h3><hr><br>"
				slip.info +="Order #[SO.ordernum]<br>"
				slip.info +="Destination: [connected_faction.name] Frontier Telepads<br>"
				slip.info +="CONTENTS:<br><ul>"

			//spawn the stuff, finish generating the manifest while you're at it
			if(A.req_access.len)
			//
				A.req_access = list(SP.access)

			var/list/spawned = SP.spawn_contents(A)
			if(slip)
				for(var/atom/content in spawned)
					slip.info += "<li>[content.name]</li>" //add the item to the manifest
				slip.info += "</ul><br>"

		return 1

	if(href_list["approve_order"])
		if(!check_access(core_access_order_approval))
			to_chat(usr, "Access Denied.")
			return 1
		if(!user_id_card) return 0
		var/datum/computer_file/crew_record/R = connected_faction.get_record(user_id_card.registered_name)
		if(!R) return 0
		var/expense_limit = 0
		var/datum/assignment/assignment = connected_faction.get_assignment(R.assignment_uid, R.get_name())
		if(assignment)
			var/datum/accesses/expenses = assignment.accesses["[R.rank]"]
			if(expenses)
				expense_limit = expenses.expense_limit
		var/id = text2num(href_list["approve_order"])
		for(var/datum/supply_order/SO in connected_faction.pending_orders)
			if(SO.ordernum != id)
				continue
			if(SO.object.cost*10 > expense_limit-R.expenses)
				to_chat(usr, "<span class='warning'>Your expense limit is too low to approve the order for \the [SO.object.name]! Either directly invoice the order or speak to command about resetting your expenses.</span>")
				return 1
			if(SO.object.cost*10 > connected_faction.central_account.money)
				to_chat(usr, "<span class='warning'>Not enough Ethericoin $$ to purchase \the [SO.object.name]!</span>")
				return 1

			R.expenses += SO.object.cost*10
			connected_faction.pending_orders -= SO
			connected_faction.approved_orders += SO
			var/datum/transaction/T = new("Central Authority Imports", "Import ([SO.object.name]) Auth: [user_id_card.registered_name]", SO.object.cost*-10, 1)
			connected_faction.central_account.do_transaction(T)
			break
		return 1

	if(href_list["invoice_order"])
		if(!check_access(core_access_invoicing) && !check_access(core_access_order_approval))
			to_chat(usr, "Access Denied.")
			return 1
		var/id = text2num(href_list["invoice_order"])
		for(var/datum/supply_order/SO in connected_faction.pending_orders)

			if(SO.ordernum != id)
				continue
			if(SO.last_print > world.time)
				to_chat(usr, "You can only print one invoice for each order, every three minutes.")
				return 0
			var/idname = "*None Provided*"
			var/idrank = "*None Provided*"
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				idname = H.get_authentification_name()
				idrank = H.get_assignment()
			else if(issilicon(user))
				idname = user.real_name
			var/reason = "Import for [SO.object.name] by [connected_faction.name]."
			var/t = ""
			var/amount = SO.object.cost*10+(SO.object.cost*10/100*connected_faction.import_profit)
			t += "<font face='Verdana' color=blue><table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'><center></td><tr><td><H1>[connected_faction.name]</td>"
			t += "<tr><td><br><b>Status:</b>*Unpaid*<br>"
			t += "<b>Total:</b> [amount] $$ Ethericoins<br><br><table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>"
			t += "<td>Authorized by:<br>[idname] [idrank]<br><td>Paid by:<br>*None*</td></tr></table><br></td>"
			t += "<tr><td><h3>Reason</H3><font size = '1'>[reason]<br></td></tr></table><br><table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>"
			t += "<td></font><font size='4'><b>Order will be approved upon payment. Swipe ID to confirm transaction.</b></font></center></font>"
			var/obj/item/weapon/paper/invoice/import/invoice = new()
			invoice.info = t
			invoice.linked_order = SO
			invoice.purpose = reason
			invoice.transaction_amount = amount
			invoice.true_amount = SO.object.cost*10
			invoice.linked_faction = connected_faction.uid
			invoice.loc = get_turf(program.computer)
			playsound(get_turf(program.computer), pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 75, 1, -3)
			invoice.name = "[connected_faction.short_tag] digital import invoice"
			SO.last_print = world.time + 3 MINUTES
			break
		return 1

	if(href_list["deny_order"])
		if(!check_access(core_access_order_approval))
			to_chat(usr, "Access Denied.")
			return 1
		var/id = text2num(href_list["deny_order"])
		for(var/datum/supply_order/SO in connected_faction.pending_orders)
			if(SO.ordernum == id)
				connected_faction.pending_orders -= SO
				break
		return 1

	if(href_list["cancel_order"])
		if(!check_access(core_access_order_approval))
			to_chat(usr, "Access Denied.")
			return 1
		var/id = text2num(href_list["cancel_order"])
		for(var/datum/supply_order/SO in connected_faction.approved_orders)
			if(SO.ordernum == id)
				connected_faction.approved_orders -= SO
				connected_faction.central_account.money += SO.object.cost*10
				break
		return 1
	if(href_list["page_up"])
		curr_page++
		return 1
	if(href_list["page_down"])
		curr_page--
		return 1
/datum/nano_module/program/supply/proc/generate_categories()
	var/datum/world_faction/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	if(!connected_faction)
		return 1
	category_names = list()
	category_contents = list()
	for(var/decl/hierarchy/supply_pack/sp in cargo_supply_pack_root.children)
		if(sp.is_category())
			category_names.Add(sp.name)
			var/list/category[0]
			for(var/decl/hierarchy/supply_pack/spc in sp.children)
				if((spc.hidden || spc.contraband || !spc.sec_available()) && !emagged)
					continue
				category.Add(list(list(
					"name" = spc.name,
					"cost" = spc.cost*10+(spc.cost*10/100*connected_faction.import_profit),
					"ref" = "\ref[spc]"
				)))
			category_contents[sp.name] = category

/datum/nano_module/program/supply/proc/get_shuttle_status()
	var/datum/shuttle/autodock/ferry/supply/shuttle = supply_controller.shuttle
	if(!istype(shuttle))
		return "No Connection"

	if(shuttle.has_arrive_time())
		return "In transit ([shuttle.eta_seconds()] s)"

	if (shuttle.can_launch())
		return "Docked"
	return "Docking/Undocking"


/datum/nano_module/program/supply/proc/can_print()
	var/obj/item/modular_computer/MC = nano_host()
	if(!istype(MC) || !istype(MC.nano_printer))
		return 0
	return 1

/datum/nano_module/program/supply/proc/print_order(var/datum/supply_order/O, var/mob/user)
	if(!O)
		return
	var/datum/world_faction/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	if(!connected_faction)
		return 1
	var/t = ""
	t += "<h3>[connected_faction.name] Supply Requisition Reciept</h3><hr>"
	t += "INDEX: #[O.ordernum]<br>"
	t += "REQUESTED BY: [O.orderedby]<br>"
	t += "RANK: [O.orderedrank]<br>"
	t += "REASON: [O.reason]<br>"
	t += "SUPPLY CRATE TYPE: [O.object.name]<br>"
	t += "ACCESS RESTRICTION: [get_access_desc(O.object.access)]<br>"
	t += "CONTENTS:<br>"
	t += O.object.manifest
	t += "<hr>"
	print_text(t, user)

/datum/nano_module/program/supply/proc/print_summary(var/mob/user)
	var/t = ""
	t += "<center><BR><b><large>[GLOB.using_map.station_name]</large></b><BR><i>[station_date]</i><BR><i>Export overview<field></i></center><hr>"
	for(var/source in point_source_descriptions)
		t += "[point_source_descriptions[source]]: [supply_controller.point_sources[source] || 0]<br>"
	print_text(t, user)
/datum/nano_module/program/supply/proc/print_export(var/mob/user, var/id)
	var/datum/world_faction/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	if(!connected_faction)
		return 1
	var/datum/export_order/order = locate(id)
	var/t = ""
	t += "<h3>[connected_faction.name] Export Manifest</h3><hr>"
	t += "EXPORT: [order.name]<br>"
	t += "PRINTED BY: [user.name]<br>"
	if(order.required)
		t += "SUPPLIED/REQUESTED: [order.supplied]/[order.required]<br>"
	t += "<hr>"
	var/obj/item/weapon/paper/export/export = new(program.computer.loc)
	export.info = t
	export.export_id = order.id

/datum/nano_module/program/supply/proc/print_export_business(var/mob/user, var/id)
	var/datum/world_faction/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	if(!connected_faction)
		return 1
	var/datum/export_order/order = locate(id)
	var/t = ""
	t += "<h3>Business Export Manifest</h3><hr>"
	t += "EXPORT: [order.name]<br>"
	t += "PRINTED BY: [user.name]<br>"
	if(order.required)
		t += "SUPPLIED/REQUESTED: [order.supplied]/[order.required]<br>"
	t += "<hr><br>"
	var/obj/item/weapon/paper/export/business/export = new(program.computer.loc)
	export.info = t
	export.export_id = order.id

