/datum/computer_file/program/clone_manager
	filename = "clonermanager"
	filedesc = "Cloning Pod Management"
	nanomodule_path = /datum/nano_module/program/clone_manager
	program_icon_state = "crew"
	program_menu_icon = "heart"
	extended_desc = "This program connects to nearby cloning pods, and uses dna scanning hardware to collect DNA and transmit it to the pods."
	required_access = access_medical
	requires_ntnet = 0
	network_destination = "cloner management"
	size = 20

/datum/computer_file/program/clone_manager/Topic(href, href_list)
	if(..())
		return 1
	if(!computer.dna_scanner) return 0
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
		var/obj/machinery/clonepod/pod = locate(href_list["target"])
		if(!pod) return 0
		if(!computer.dna_scanner.stored_dna) return 0
		if(pod.growclone(computer.dna_scanner.stored_dna))
			to_chat(usr, "The cloning processing is beginning.")
			computer.dna_scanner.stored_dna = null
		else
			to_chat(usr, "The cloning pod reports an error.")
	if(href_list["disconnect_pod"])
		if(!href_list["target"]) return 0
		var/obj/machinery/clonepod/pod = locate(href_list["target"])
		if(!pod) return 0
		computer.dna_scanner.connected_pods -= pod
	return 1

/datum/nano_module/program/clone_manager
	name = "Cloning Pod Management"


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
	data["has_scanner"] = !!program.computer.dna_scanner
	if(program.computer.dna_scanner)
		data["has_dna"] = !!program.computer.dna_scanner.stored_dna
		if(!!program.computer.dna_scanner.stored_dna)
			data["dna"] = program.computer.dna_scanner.stored_dna.unique_enzymes
		data["connected_pods"] = format_pods()
		data["clone_biomass"] = CLONE_BIOMASS
	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "cloning_management.tmpl", "Cloning Management", 400, 450, state = state)

		ui.set_initial_data(data)
		ui.open()

		// should make the UI auto-update; doesn't seem to?
		ui.set_auto_update(1)
