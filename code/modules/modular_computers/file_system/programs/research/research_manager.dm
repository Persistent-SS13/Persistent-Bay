/datum/computer_file/program/research
	filename = "research"
	filedesc = "Research Management"
	program_icon_state = "comm"
	program_menu_icon = "script"
	nanomodule_path = /datum/nano_module/program/research
	extended_desc = "Used to spend research points on the network to get new tech disks for fabricators."
	requires_ntnet = 1
	size = 12


/datum/nano_module/program/research
	name = "Research Management"
	available_to_ai = TRUE
	var/menu = 1
	var/tier = 1
	var/datum/tech_entry/selected_tech
/datum/nano_module/program/research/proc/setup_techs(var/list/data)
	var/list/techs = list()
	var/list/formatted_techs[0]
	for(var/datum/tech_entry/tech in SSresearch.files.tech_entries)
		if(tech.uid && tech.category == menu && tech.tier == tier)
			techs |= tech
	for(var/datum/tech_entry/tech in techs)
		formatted_techs[++formatted_techs.len] = list("name" = tech.name, "desc" = tech.desc, "ref" = "\ref[tech]")
	data["tech_entries"] = formatted_techs
	
/datum/nano_module/program/research/proc/can_print(var/datum/world_faction/connected_faction)
	if(!selected_tech || !connected_faction) return 0
	var/printcost = round(selected_tech.points/25)
	if(connected_faction.get_tech_points() < printcost) return 0
	return 1
	
/datum/nano_module/program/research/proc/print(var/datum/world_faction/connected_faction)
	if(!selected_tech || !connected_faction) return 0
	var/printcost = round(selected_tech.points/25)
	if(connected_faction.get_tech_points() >= printcost)
		connected_faction.take_tech_points(printcost)
		var/obj/item/weapon/disk/tech_entry_disk/disk = new(get_turf(program.computer))
		disk.name = selected_tech.name
		disk.uid = selected_tech.uid
		return 1
		
/datum/nano_module/program/research/proc/unlock(var/datum/world_faction/connected_faction)
	if(!selected_tech || !connected_faction) return 0
	var/unlockcost = selected_tech.points
	if(connected_faction.get_tech_points() >= unlockcost)
		connected_faction.take_tech_points(unlockcost)
		connected_faction.unlock_tech(selected_tech.uid)
		var/obj/item/weapon/disk/tech_entry_disk/disk = new(get_turf(program.computer))
		disk.name = selected_tech.name
		disk.uid = selected_tech.uid
		return 1
		
	
/datum/nano_module/program/research/proc/can_unlock(var/datum/world_faction/connected_faction, var/mob/user)
	if(!selected_tech || !connected_faction) return 0
	if(connected_faction.get_tech_points() < selected_tech.points)
		to_chat(user, "You do not have enough tech points for this action.")
		return 0
	if(!connected_faction.meets_prereqs(selected_tech))
		to_chat(user, "You do not meet the technology requirements to unlock this.")
		return 0
	return 1
	
/datum/nano_module/program/research/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/datum/world_faction/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	if(!connected_faction)
		return 0
	var/list/data = host.initial_data()
	data["tech_points"] = connected_faction.get_tech_points()
	data["menu"] = menu
	data["tier"] = tier
	if(selected_tech)
		data["selected_tech"] = selected_tech.name
		data["desc"] = selected_tech.desc
		var/prereqs = ""
		if(selected_tech.prereqs.len)
			var/firstuid = selected_tech.prereqs[1]
			var/datum/tech_entry/tech = SSresearch.files.get_tech_entry(firstuid)
			if(tech)
				if(connected_faction.is_tech_unlocked(firstuid))
					prereqs += "<font color='green'>" + tech.name + "</font>"
				else
					prereqs += "<font color='red'>" + tech.name + "</font>"
			var/x = 0
			for(var/lateruid in selected_tech.prereqs)
				x++
				if(x == 1) continue
				var/datum/tech_entry/tech2 = SSresearch.files.get_tech_entry(lateruid)
				if(tech2)
					if(connected_faction.is_tech_unlocked(lateruid))
						prereqs += ", <font color='green'>" + tech2.name + "</font>"
					else
						prereqs += ", <font color='red'>" + tech2.name + "</font>"
			data["prereqs"] = prereqs
		else
			data["prereqs"] = "None."
		if(selected_tech.uses == -10)
			data["uses"] = "unlimited"
		else
			data["uses"] = selected_tech.uses
		if(connected_faction.is_tech_unlocked(selected_tech.uid))
			data["tech_unlocked"] = 1
			data["can_print"] = can_print(connected_faction)
			data["print_cost"] = round(selected_tech.points/25)
		else
			data["can_unlock"] = can_unlock(connected_faction)
			data["unlock_cost"] = selected_tech.points
	else
		setup_techs(data)
		
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "research.tmpl", name, 650, 550, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/research/Topic(href, href_list)
	if(..())
		return 1
	. = SSnano.update_uis(src)
	var/mob/user = usr
	var/datum/world_faction/connected_faction = program.computer.network_card.connected_network.holder
	
	switch(href_list["action"])
		if("back")
			selected_tech = null
		if("change_menu")
			menu = text2num(href_list["menu_target"])
			tier = 1
		if("change_tier")
			tier = text2num(href_list["menu_target"])
		if("print_disk")
			if(!selected_tech || !can_print(connected_faction)) return
			if(print(connected_faction))
				to_chat(user, "[selected_tech.name] Tech disk printed.")
				selected_tech = null
		if("unlock_tech")
			if(!selected_tech || !can_unlock(connected_faction)) return
			if(unlock(connected_faction))
				to_chat(user, "[selected_tech.name] unlocked.")
				selected_tech = null
		if("select_tech")
			selected_tech = locate(href_list["target"])
			