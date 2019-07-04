/datum/computer_file/program/executive_policy
	filename = "executive_policy"
	filedesc = "Nexus City Executive Policy"
	program_icon_state = "comm"
	program_menu_icon = "note"
	nanomodule_path = /datum/nano_module/program/executive_policy
	extended_desc = "Used to view all executive policy published by the governor."
	requires_ntnet = TRUE
	size = 12
	democratic = 1
	category = PROG_GOVERNMENT
	usage_flags = PROGRAM_ALL

/datum/nano_module/program/executive_policy
	name = "Nexus City Executive Policy"
	available_to_ai = TRUE
	var/datum/council_vote/selected_vote
	
/datum/nano_module/program/executive_policy/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/datum/world_faction/democratic/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	var/list/data = host.initial_data()
	if(selected_vote)
		data["selected_vote"] = selected_vote.name
		data["sponsor"] = selected_vote.sponsor
		data["passed_date"] = time2text(selected_vote.time_signed)
		data["vote_body"] = selected_vote.body
	else
		var/list/formatted_votes[0]
		for(var/datum/council_vote/vote in reverselist(connected_faction.policy.Copy()))
			formatted_votes[++formatted_votes.len] = list("name" = vote.name, "ref" = "\ref[vote]") 
		if(formatted_votes.len)
			data["votes"] = formatted_votes
		
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "executive_policy.tmpl", name, 600, 500, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/executive_policy/Topic(href, href_list)
	if(..())
		return 1
	. = SSnano.update_uis(src)

	switch(href_list["action"])
		if("deselect_vote")
			selected_vote = null
		if("select_vote")
			selected_vote = locate(href_list["ref"])
		
		if("print")
			if(!selected_vote) return
			if(program.computer && program.computer.nano_printer) //This option should never be called if there is no printer
				if(!program.computer.nano_printer.print_text(selected_vote.body,selected_vote.name))
					to_chat(usr, "<span class='notice'>Hardware error: Printer was unable to print the file. It may be out of paper.</span>")
					return
				else
					program.computer.visible_message("<span class='notice'>\The [program.computer] prints out paper.</span>")
			else
				to_chat(usr, "<span class='notice'>Hardware error: There is no printer installed in this computer!.</span>")
				return