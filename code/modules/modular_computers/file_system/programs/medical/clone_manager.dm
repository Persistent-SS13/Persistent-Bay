/datum/computer_file/program/clone_manager
	filename = "clonermanager"
	filedesc = "Cloning Pod Management"
	nanomodule_path = /datum/nano_module/program/clone_manager
	program_icon_state = "crew"
	program_menu_icon = "heart"
	extended_desc = "This program connects to nearby cloning pods, and uses dna scanning hardware to collect DNA and transmit it to the pods."
	required_access = core_access_medical_programs
	requires_ntnet = 0
	network_destination = "cloner management"
	size = 20
	var/obj/machinery/clonepod/pod
/datum/computer_file/program/clone_manager/Topic(href, href_list)
	if(..())
		return 1
	if(!computer.dna_scanner || !computer.dna_scanner.check_functionality()) return 0
	var/datum/nano_module/program/clone_manager/cloneNM = NM
	if(href_list["connect"])
		var/found = 0
		for(var/obj/machinery/clonepod/pod in view(4,computer.loc))
			if(pod.stat || !pod.anchored) continue
			found = 1
			computer.dna_scanner.connected_pods |= pod
		if(!found)
			to_chat(usr, "No suitable cloning pods found.")
	if(href_list["select_pod"])
		if(!href_list["target"]) return 0
		if(!computer.dna_scanner.stored_dna) return 0
		pod = locate(href_list["target"])
		if(!pod) return 0
		cloneNM.menu = 2
		
	if(href_list["finish"])
		if(cloneNM.get_contributed() < 5000)
			to_chat(usr, "Not enough funding.")
		if(!pod || !computer.dna_scanner || !computer.dna_scanner.stored_dna)
			cloneNM.cancel_contracts()
			cloneNM.menu = 1
			return 1
		for(var/obj/item/weapon/paper/contract/contract in cloneNM.signed_contracts)
			if(!contract.is_solvent())
				contract.cancel()
				GLOB.nanomanager.update_uis(src)
				return 0
		if(pod.growclone(computer.dna_scanner.stored_dna))
			for(var/obj/item/weapon/paper/contract/contract in cloneNM.signed_contracts)
				contract.finalize()
				cloneNM.signed_contracts -= contract	
			to_chat(usr, "The cloning processing is beginning.")
			computer.dna_scanner.stored_dna = null
			cloneNM.menu = 2
			cloneNM.cancel_contracts()
		else
			to_chat(usr, "The cloning pod reports an error.")
	if(href_list["back"])
		var/choice = input(usr,"This will cancel all current contracts and return to the prior menu.") in list("Confirm", "Cancel")
		if(choice == "Confirm")
			cloneNM.menu = 1
			cloneNM.cancel_contracts()
	if(href_list["disconnect_pod"])
		if(!href_list["target"]) return 0
		var/obj/machinery/clonepod/pod = locate(href_list["target"])
		if(!pod) return 0
		computer.dna_scanner.connected_pods -= pod
	if(href_list["contract"])
		if(!computer.dna_scanner || !computer.dna_scanner.stored_dna)
			cloneNM.cancel_contracts()
			cloneNM.menu = 1
		var/cost = round(input("How much ethericoin should be the funding contract be for?", "Funding", 5000-cloneNM.get_contributed()) as null|num)
		if(cost > 5000-cloneNM.get_contributed())
			cost = 5000-cloneNM.get_contributed()
		if(!cost || cost < 0)
			return 0
		var/choice = input(usr,"This will create a funding contract for [cost] ethericoin.") in list("Confirm", "Cancel")
		if(choice == "Confirm")
			var/obj/item/weapon/paper/contract/contract = new()
			contract.required_cash = cost
			contract.linked = NM
			contract.purpose = "Funding contract for [cost]$$ to clone [computer.dna_scanner.stored_dna.real_name]."
			contract.name = "cloning funding contract"
			var/t = ""
			t += "<font face='Verdana' color=blue><table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'><center></td><tr><td><H1>Investment Contract</td>"
			t += "<tr><td><br><b>For:</b>clone [computer.dna_scanner.stored_dna.real_name]<br>"
			t += "<b>Cost:</b> [cost] $$ Ethericoins<br><br>"
			t += "<tr><td><h3>Status</H3>*Unsigned*<br></td></tr></table><br><table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>"
			t += "<td><font size='4'><b>Swipe ID to sign contract.</b></font></center></font>"
			contract.info = t
			contract.loc = get_turf(computer)
			contract.update_icon()
			cloneNM.pending_contracts |= contract
			playsound(get_turf(computer), pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 75, 1, -3)
	return 1

/datum/nano_module/program/clone_manager
	name = "Cloning Pod Management"
	var/menu = 1
	var/list/signed_contracts = list()
	var/list/pending_contracts = list()
	
/datum/nano_module/program/clone_manager/Destroy()
	cancel_contracts()
	. = ..()	
	
/datum/nano_module/program/clone_manager/proc/cancel_contracts()
	for(var/obj/item/weapon/paper/contract/contract in pending_contracts)
		contract.cancel()
	for(var/obj/item/weapon/paper/contract/contract in signed_contracts)
		contract.cancel()

/datum/nano_module/program/clone_manager/proc/get_contributed()
	var/contributed = 0
	for(var/obj/item/weapon/paper/contract/contract in signed_contracts)
		contributed += contract.required_cash
	return contributed

/datum/nano_module/program/clone_manager/contract_signed(var/obj/item/weapon/paper/contract/contract)
	pending_contracts -= contract
	signed_contracts |= contract
	GLOB.nanomanager.update_uis(src)
	return 1
/datum/nano_module/program/clone_manager/contract_cancelled(var/obj/item/weapon/paper/contract/contract)
	pending_contracts -= contract
	signed_contracts -= contract
	GLOB.nanomanager.update_uis(src)
	return 1

		
	
/datum/nano_module/program/clone_manager/proc/format_pods()
	if(!program.computer.dna_scanner) return 0
	var/list/formatted = list()
	for(var/obj/machinery/clonepod/pod in program.computer.dna_scanner.connected_pods)
		var/can_select = 1
		if(!program.computer.dna_scanner.stored_dna || pod.panel_open || pod.attempting || pod.occupant || pod.biomass < CLONE_BIOMASS || pod.stat)
			can_select = 0
		formatted.Add(list(list(
			"name" = pod.name,
			"attempting" = !!pod.occupant,
			"biomass" = pod.biomass,
			"status" = pod.stat + pod.panel_open,
			"can_select" = can_select,
			"pod_ref" = "\ref[pod]")))

	return formatted

/datum/nano_module/program/clone_manager/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/scanner_status = 1
	if(!program.computer.dna_scanner || !program.computer.dna_scanner.check_functionality()) scanner_status = 0
	data["has_scanner"] = scanner_status
	if(program.computer.dna_scanner)
		data["has_dna"] = !!program.computer.dna_scanner.stored_dna
		if(!!program.computer.dna_scanner.stored_dna)
			data["dna"] = program.computer.dna_scanner.stored_dna.unique_enzymes
		data["connected_pods"] = format_pods()
		data["clone_biomass"] = CLONE_BIOMASS
	data["menu"] = menu
	var/commitment = get_contributed()
	data["commitment"] = commitment
	data["finishable"] = commitment >= 5000
	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "cloning_management.tmpl", "Cloning Management", 400, 450, state = state)

		ui.set_initial_data(data)
		ui.open()

		// should make the UI auto-update; doesn't seem to?
		ui.set_auto_update(1)
