/datum/computer_file/program/management
	filename = "businessmanagement"
	filedesc = "Business Upper Management"
	program_icon_state = "comm"
	program_menu_icon = "flag"
	nanomodule_path = /datum/nano_module/program/management
	extended_desc = "Used by high ranking employees to control the status and other central options for the business."
	requires_ntnet = 1
	size = 12
	business = 1
	

/datum/nano_module/program/management
	name = "Business Upper Management"
	available_to_ai = TRUE
	var/menu = 1

/datum/nano_module/program/management/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/datum/world_faction/business/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	var/list/data = host.initial_data()
	data["business_name"] = connected_faction.name
	data[""]


	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "ceo.tmpl", name, 600, 500, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/management/Topic(href, href_list)
	if(..())
		return 1
	. = SSnano.update_uis(src)
	var/mob/user = usr
	var/datum/world_faction/business/connected_faction = program.computer.network_card.connected_network.holder
	if(!istype(connected_faction) || !(connected_faction.is_governor(user.real_name)))
		return .
	switch(href_list["action"])
		