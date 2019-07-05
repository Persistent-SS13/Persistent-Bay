/datum/computer_file/program/tax_laws
	filename = "tax_laws"
	filedesc = "Nexus City Tax Code"
	program_icon_state = "comm"
	program_menu_icon = "note"
	nanomodule_path = /datum/nano_module/program/tax_laws
	extended_desc = "Used to view the current tax laws passed by the Council.."
	requires_ntnet = 1
	size = 5
	democratic = 1
	category = PROG_GOVERNMENT
	usage_flags = PROGRAM_ALL

/datum/nano_module/program/tax_laws
	name = "Nexus City Tax Code"
	available_to_ai = TRUE
	var/taxee = 1 // 1 = personal, 2 = business

	var/tax_type = 1 // 1 = flat, 2 = progressie
	var/tax_prog1_rate = 0
	var/tax_prog2_rate = 0
	var/tax_prog3_rate = 0
	var/tax_prog4_rate = 0

	var/tax_prog2_amount = 0
	var/tax_prog3_amount = 0
	var/tax_prog4_amount = 0

	var/tax_flat_rate = 0
	var/synced = 0
	var/menu = 1


/datum/nano_module/program/tax_laws/proc/sync_from_faction()
	var/datum/world_faction/democratic/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	if(connected_faction && istype(connected_faction))
		if(taxee == 2)
			tax_type = connected_faction.tax_type_b
			tax_prog1_rate = connected_faction.tax_bprog1_rate
			tax_prog2_rate = connected_faction.tax_bprog2_rate
			tax_prog3_rate = connected_faction.tax_bprog3_rate
			tax_prog4_rate = connected_faction.tax_bprog4_rate

			tax_prog2_amount = connected_faction.tax_bprog2_amount
			tax_prog3_amount = connected_faction.tax_bprog3_amount
			tax_prog4_amount = connected_faction.tax_bprog4_amount

			tax_flat_rate = connected_faction.tax_bflat_rate
		else
			tax_type = connected_faction.tax_type_p
			tax_prog1_rate = connected_faction.tax_pprog1_rate
			tax_prog2_rate = connected_faction.tax_pprog2_rate
			tax_prog3_rate = connected_faction.tax_pprog3_rate
			tax_prog4_rate = connected_faction.tax_pprog4_rate

			tax_prog2_amount = connected_faction.tax_pprog2_amount
			tax_prog3_amount = connected_faction.tax_pprog3_amount
			tax_prog4_amount = connected_faction.tax_pprog4_amount

			tax_flat_rate = connected_faction.tax_pflat_rate
	synced = 1



/datum/nano_module/program/tax_laws/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	// var/datum/world_faction/democratic/connected_faction
	// if(program.computer.network_card && program.computer.network_card.connected_network)
	// 	connected_faction = program.computer.network_card.connected_network.holder
	var/list/data = host.initial_data()

	if(!synced)
		sync_from_faction()
	data["taxee"] = taxee
	var/subtype = "Flat Tax"
	if(tax_type == 2)
		subtype = "Progressive Tax"
	if(taxee == 2)
		data["tax"] = "Business [subtype]"
	else
		data["tax"] = "Personal [subtype]"
	data["tax_type"] = tax_type
	if(tax_type == 2)
		data["tax_prog1_rate"] = tax_prog1_rate
		data["tax_prog2_rate"] = tax_prog2_rate
		data["tax_prog3_rate"] = tax_prog3_rate
		data["tax_prog4_rate"] = tax_prog4_rate

		data["tax_prog2_amount"] = tax_prog2_amount
		data["tax_prog3_amount"] = tax_prog3_amount
		data["tax_prog4_amount"] = tax_prog4_amount

	else
		data["tax_flat_rate"] = tax_flat_rate

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "tax_laws.tmpl", name, 600, 500, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/tax_laws/Topic(href, href_list)
	if(..())
		return 1
	. = SSnano.update_uis(src)

	switch(href_list["action"])
		if("change_tax")
			taxee = href_list["menu_target"]
			synced = 0
