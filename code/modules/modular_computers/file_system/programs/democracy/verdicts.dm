/datum/computer_file/program/verdicts
	filename = "verdicts"
	filedesc = "Nexus City Trials & Verdicts"
	program_icon_state = "comm"
	program_menu_icon = "note"
	nanomodule_path = /datum/nano_module/program/verdicts
	extended_desc = "Used to view all scheduled trials and rendered verdicts."
	requires_ntnet = 1
	size = 6
	democratic = 1
	category = PROG_JUSTICE
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP | PROGRAM_TELESCREEN | PROGRAM_TABLET

/datum/nano_module/program/verdicts
	name = "Nexus City Trials & Verdicts"
	available_to_ai = TRUE
	var/menu = 1
	var/datum/judge_trial/selected_trial
	var/datum/verdict/selected_verdict
/datum/nano_module/program/verdicts/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/datum/world_faction/democratic/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	var/list/data = host.initial_data()
	data["menu"] = menu
	if(menu == 1)
		if(selected_trial)
			data["selected_trial"] = selected_trial.name
			data["trial_time"] = "[selected_trial.month] [selected_trial.day] [selected_trial.hour]:00"
			data["judge"] = selected_trial.judge
			data["plaintiff"] = selected_trial.plaintiff
			data["defendant"] = selected_trial.defendant
			data["trial_body"] = selected_trial.body
		else
			if(connected_faction.scheduled_trials.len)
				var/list/formatted_trials[0]
				for(var/datum/judge_trial/trial in connected_faction.scheduled_trials)
					formatted_trials[++formatted_trials.len] = list("name" = trial.name, "ref" = "\ref[trial]")
				data["trials"] = formatted_trials
	if(menu == 2)
		if(selected_verdict)
			data["verdict_title"] = selected_verdict.name
			data["defendant_verdict"] = selected_verdict.defendant
			data["verdict_body"] = selected_verdict.body
			var/citizenship = "No changes."
			switch(selected_verdict.citizenship_change)
				if(1)
					citizenship = "[selected_verdict.defendant] Changed to Resident"
				if(2)
					citizenship = "[selected_verdict.defendant] Changed to Citizen"
				if(3)
					citizenship = "[selected_verdict.defendant] Changed to Prisoner"
			data["citizenship"] = citizenship

		else
			if(connected_faction.verdicts.len)
				var/list/formatted_verdicts[0]
				for(var/datum/verdict/verdict in connected_faction.verdicts)
					formatted_verdicts[++formatted_verdicts.len] = list("name" = verdict.name, "ref" = "\ref[verdict]")
				data["verdicts"] = formatted_verdicts

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "executive_policy.tmpl", name, 600, 500, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/verdicts/Topic(href, href_list)
	if(..())
		return 1
	. = SSnano.update_uis(src)

	switch(href_list["action"])
		if("deselect_verdict")
			selected_verdict = null
		if("select_verdict")
			selected_verdict = locate(href_list["ref"])
		if("deselect_trial")
			selected_trial = null
		if("select_trial")
			selected_trial = locate(href_list["ref"])
		if("change_menu")
			var/select_menu = text2num(href_list["menu_target"])
			menu = select_menu

		if("print")
			if(!selected_trial) return
			if(program.computer && program.computer.nano_printer) //This option should never be called if there is no printer
				if(!program.computer.nano_printer.print_text(selected_trial.body,selected_trial.name))
					to_chat(usr, "<span class='notice'>Hardware error: Printer was unable to print the file. It may be out of paper.</span>")
					return
				else
					program.computer.visible_message("<span class='notice'>\The [program.computer] prints out paper.</span>")
			else
				to_chat(usr, "<span class='notice'>Hardware error: There is no printer installed in this computer!.</span>")
				return

		if("print_verdict")
			if(!selected_verdict) return
			if(program.computer && program.computer.nano_printer) //This option should never be called if there is no printer
				if(!program.computer.nano_printer.print_text(selected_verdict.body,selected_verdict.name))
					to_chat(usr, "<span class='notice'>Hardware error: Printer was unable to print the file. It may be out of paper.</span>")
					return
				else
					program.computer.visible_message("<span class='notice'>\The [program.computer] prints out paper.</span>")
			else
				to_chat(usr, "<span class='notice'>Hardware error: There is no printer installed in this computer!.</span>")
				return
