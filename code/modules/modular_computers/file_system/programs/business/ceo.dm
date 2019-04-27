/datum/computer_file/program/management
	filename = "businessmanagement"
	filedesc = "Business Central Options"
	program_icon_state = "comm"
	program_menu_icon = "flag"
	nanomodule_path = /datum/nano_module/program/management
	extended_desc = "Used by high ranking employees to control the status and other central options for the business."
	requires_ntnet = 1
	size = 12
	business = 1
	required_access = core_access_command_programs

/datum/nano_module/program/management
	name = "Business Central Options"
	available_to_ai = TRUE
	var/menu = 1
	var/curr_page
/datum/nano_module/program/management/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/datum/world_faction/business/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	var/list/data = host.initial_data()
	data["business_name"] = connected_faction.name
	data["menu"] = menu
	if(menu == 1)
		data["business_status"] = connected_faction.status
	if(menu == 2)
		var/list/formatted_log[0]
		if(connected_faction.employment_log.len)
			for(var/i=0; i<10; i++)
				var/minus = i+(10*(curr_page-1))
				if(minus >= connected_faction.employment_log.len) break
				var/entry = connected_faction.employment_log[connected_faction.employment_log.len-minus]
				formatted_log[++formatted_log.len] = list("entry" = entry) 
		data["entries"] = formatted_log
		var/pages = connected_faction.employment_log.len/10
		if(pages < 1)
			pages = 1
		data["page"] = curr_page
		data["page_up"] = curr_page < pages
		data["page_down"] = curr_page > 1
	if(menu == 3)
		data["business_task"] = connected_faction.objective
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
	if(href_list["page_up"])
		curr_page++
		return 1
	if(href_list["page_down"])
		curr_page--
		return 1
	switch(href_list["action"])
		if("change_menu")
			menu = text2num(href_list["menu_target"])
		if("business_open")
			connected_faction.open_business()
		if("business_close")
			connected_faction.close_business()
		if("business_name")
			var/select_name = sanitizeName(input(usr,"Enter the new business display name.","Business Name", "") as null|text, MAX_NAME_LEN, 1, 0,1)
			if(select_name)
				connected_faction.name = select_name
		if("edit_task")
			var/newValue
			newValue = replacetext(input(usr, "Edit the message displayed to all clocked in laces. You may use HTML paper formatting tags:", "General Task", replacetext(html_decode(connected_faction.objective), "\[br\]", "\n")) as null|message, "\n", "\[br\]")
			if(newValue)
				connected_faction.objective = newValue