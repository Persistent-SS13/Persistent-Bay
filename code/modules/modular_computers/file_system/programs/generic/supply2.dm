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
	var/list/selected_telepads
	var/list/selected_telepads_export = list()
/datum/nano_module/program/supply/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/datum/world_faction/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	if(!connected_faction)
		program.computer.kill_program()
	if(!selected_telepads)
		selected_telepads = connected_faction.cargo_telepads.Copy()
	var/is_admin = check_access(user, core_access_order_approval, connected_faction.uid)
	data["faction_name"] = connected_faction.name
	data["credits"] = connected_faction.central_account.money
	data["is_admin"] = is_admin
		
		
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
			data["total_credits"] = supply_controller.point_sources["total"] ? supply_controller.point_sources["total"] : 0
			data["credits_passive"] = supply_controller.point_sources["time"] ? supply_controller.point_sources["time"] : 0
			data["credits_crates"] = supply_controller.point_sources["crate"] ? supply_controller.point_sources["crate"] : 0
			data["credits_phoron"] = supply_controller.point_sources["phoron"] ? supply_controller.point_sources["phoron"] : 0
			data["credits_platinum"] = supply_controller.point_sources["platinum"] ? supply_controller.point_sources["platinum"] : 0
			data["credits_paperwork"] = supply_controller.point_sources["manifest"] ? supply_controller.point_sources["manifest"] : 0
			data["credits_virology"] = supply_controller.point_sources["virology"] ? supply_controller.point_sources["virology"] : 0
			
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
					"cost" = SO.object.cost*10,
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
				
	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
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

		if(can_print() && alert(user, "Would you like to print a confirmation receipt?", "Print receipt?", "Yes", "No") == "Yes")
			print_order(O, user)
		return 1
	if(href_list["print_export"])
		if(!can_print())
			return
		print_export(user, href_list["print_export"])
		
		return 1
	if(href_list["print_summary"])
		if(!can_print())
			return
		print_summary(user)

	// Items requiring cargo access go below this entry. Other items go above.
	if(!check_access(access_cargo))
		return 1

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
	if(href_list["launch_export"])
		var/sent = 0
		var/earned = 0
		if(!selected_telepads_export.len)
			to_chat(usr, "No telepads selected to use.")
		for(var/obj/machinery/telepad_cargo/telepad in selected_telepads_export)
			var/turf/T = telepad.loc
			if(T.density)	continue
			for(var/obj/structure/closet/closet in T.contents)
				for(var/obj/item/weapon/paper/export/export in closet.contents)
					var/earn = supply_controller.fill_order(export.export_id, closet)
					if(earn)	
						connected_faction.central_account.money += earn
						earned += earn
						sent++
					break
				break
		to_chat(usr, "Export protocol completed, [sent] orders were succesfully sent and [earned] $$ was put into the account.")
	if(href_list["launch_order"])
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
			A.name = "[SP.containername][SO.comment ? " ([SO.comment])":"" ]"
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
			//	SP.access.len
				A.req_access = list(core_access_order_approval)

			var/list/spawned = SP.spawn_contents(A)
			if(slip)
				for(var/atom/content in spawned)
					slip.info += "<li>[content.name]</li>" //add the item to the manifest
				slip.info += "</ul><br>"

		return 1

	if(href_list["approve_order"])
		var/id = text2num(href_list["approve_order"])
		for(var/datum/supply_order/SO in connected_faction.pending_orders)
			if(SO.ordernum != id)
				continue
			if(SO.object.cost*10 > connected_faction.central_account.money)
				to_chat(usr, "<span class='warning'>Not enough Ethericoin $$ to purchase \the [SO.object.name]!</span>")
				return 1
			connected_faction.pending_orders -= SO
			connected_faction.approved_orders += SO
			connected_faction.central_account.money -= SO.object.cost*10 // make transaction log here...
			break
		return 1

	if(href_list["deny_order"])
		var/id = text2num(href_list["deny_order"])
		for(var/datum/supply_order/SO in connected_faction.pending_orders)
			if(SO.ordernum == id)
				connected_faction.pending_orders -= SO
				break
		return 1

	if(href_list["cancel_order"])
		var/id = text2num(href_list["cancel_order"])
		for(var/datum/supply_order/SO in connected_faction.approved_orders)
			if(SO.ordernum == id)
				connected_faction.approved_orders -= SO
				connected_faction.central_account.money += SO.object.cost*10
				break
		return 1

/datum/nano_module/program/supply/proc/generate_categories()
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
					"cost" = spc.cost*10,
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
	t += "SUPPLIED/REQUESTED: [order.supplied]/[order.required]<br>"
	t += "<hr>"
	var/obj/item/weapon/paper/export/export = new(program.computer.loc)
	export.info = t
	export.export_id = order.id
