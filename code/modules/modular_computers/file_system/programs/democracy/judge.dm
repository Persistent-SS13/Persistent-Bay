/datum/computer_file/program/judge
	filename = "judge"
	filedesc = "Nexus City Judge Controls"
	program_icon_state = "comm"
	program_menu_icon = "flag"
	nanomodule_path = /datum/nano_module/program/judge
	extended_desc = "Used by judges to manage trials and render verdicts."
	requires_ntnet = 1
	size = 6
	democratic = 1
	category = PROG_JUSTICE
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP | PROGRAM_TELESCREEN | PROGRAM_TABLET

/datum/nano_module/program/judge
	name = "Nexus City Judge Controls"
	available_to_ai = TRUE

	var/menu = 1

	var/datum/judge_trial/selected_trial

	var/trial_title = ""
	var/trial_body = ""
	var/trial_month = ""
	var/trial_day = 0
	var/trial_hour = 0
	var/trial_plaintiff = ""
	var/trial_defendant = ""

	var/verdict_title = ""
	var/verdict_body = ""
	var/verdict_defendant = ""
	var/verdict_citizenship = "None"

/datum/nano_module/program/judge/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/datum/world_faction/democratic/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	var/list/data = host.initial_data()
	if(connected_faction.is_judge(user.real_name))
		data["is_judge"] = 1
		data["menu"] = menu
		if(menu == 1)
			if(selected_trial)
				var/is_presiding = 0
				data["selected_trial"] = selected_trial.name
				data["trial_time"] = "[selected_trial.month] [selected_trial.day] [selected_trial.hour]:00"
				data["judge"] = selected_trial.judge
				data["plaintiff"] = selected_trial.plaintiff
				data["defendant"] = selected_trial.defendant
				data["trial_body"] = selected_trial.body
				if(user.real_name == selected_trial.judge)
					is_presiding = 1
				data["is_presiding"] = is_presiding
			else
				if(connected_faction.scheduled_trials.len)
					var/list/formatted_trials[0]
					for(var/datum/judge_trial/trial in connected_faction.scheduled_trials)
						formatted_trials[++formatted_trials.len] = list("name" = trial.name, "ref" = "\ref[trial]")
					data["trials"] = formatted_trials
		if(menu == 2)
			data["trial_title"] = trial_title
			data["trial_body"] = trial_body
			data["month"] = trial_month
			data["day"] = trial_day
			data["hour"] = "[trial_hour]:00"
			data["plaintiff"] = trial_plaintiff
			data["defendant"] = trial_defendant

		if(menu == 3)
			data["verdict_title"] = verdict_title
			data["defendant_verdict"] = verdict_defendant
			data["verdict_body"] = verdict_body
			data["citizenship"] = verdict_citizenship

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "judge.tmpl", name, 600, 500, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/judge/Topic(href, href_list)
	if(..())
		return 1
	. = SSnano.update_uis(src)
	var/mob/user = usr
	var/datum/world_faction/democratic/connected_faction = program.computer.network_card.connected_network.holder
	if(!istype(connected_faction) || !(connected_faction.is_judge(user.real_name)))
		return 1

	switch(href_list["action"])
		if("change_menu")
			menu = text2num(href_list["menu_target"])

		if("deselect_trial")
			selected_trial = null


		if("cancel_trial")
			if(!selected_trial || selected_trial.judge != usr.real_name) return
			connected_faction.cancel_trial(selected_trial)
			selected_trial = null

		if("select_trial")
			selected_trial = locate(href_list["ref"])

		if("change_trialtitle")
			var/attempt = sanitizeName(input(usr, "Enter new Trial Title", "Trial Title", trial_title), 30, 1, 0)
			if(attempt)
				trial_title = attempt
		if("change_defendant")
			var/attempt = sanitizeName(input(usr, "Enter new defendant name", "Defendant", trial_defendant), 30, 1, 0)
			if(attempt)
				trial_defendant = attempt
		if("change_plaintiff")
			var/attempt = sanitizeName(input(usr, "Enter new plaintiff name", "Plaintiff", trial_plaintiff), 30, 1, 0)
			if(attempt)
				trial_plaintiff = attempt
		if("change_month")
			var/list/choices = list("January","February","March","April","May","June","July","August","September","October","November","December")
			var/attempt = input("Which month to hold the trial?") as null|anything in choices
			if(attempt)
				trial_month = attempt
		if("change_day")
			var/attempt = input("Which day of the month to have the trial?") as num|null
			if(attempt)
				if(attempt < 1 || attempt > 31)
					to_chat(usr, "Invalid entry.")
					return
				trial_day = attempt
		if("change_hour")
			var/attempt = input("Which hour should the trial begin?") as num|null
			if(attempt)
				if(attempt < 0 || attempt > 23)
					to_chat(usr, "Invalid entry.")
					return
				trial_hour = attempt

		if("scan_trial")
			var/obj/item/weapon/paper/paper = usr.get_active_hand()
			if(istype(paper))
				trial_body = paper.info
				to_chat(usr, "Copy completed.")
			else
				to_chat(usr, "Hold a single paper in your active hand.")



		if("finish")
			if(trial_title == "" || trial_body == "" || trial_defendant == "" || trial_plaintiff == "" || trial_month == "" || !trial_day)
				to_chat(usr, "The trial details are incomplete. Check title, body, defendant, plaintiff, month and day.")
				return
			else
				var/datum/judge_trial/trial = new()
				trial.judge = usr.real_name
				trial.month = trial_month
				trial.day = trial_day
				trial.hour = trial_hour
				trial.name = trial_title
				trial.body = trial_body
				trial.name = trial_title

				connected_faction.schedule_trial(trial)
				to_chat(usr, "Trial Scheduled.")
				selected_trial = null
				menu = 1
				trial_title = ""
				trial_body = ""
				trial_day = 0
				trial_hour = 0
				trial_month = ""

		if("change_verdicttitle")
			var/attempt = sanitizeName(input(usr, "Enter new Verdict Title", "Verdict Title", verdict_title), 30, 1, 0)
			if(attempt)
				verdict_title = attempt
		if("change_defendant_verdict")
			var/attempt = sanitizeName(input(usr, "Enter new defendant name", "Defendant", verdict_defendant), 30, 1, 0)
			if(attempt)
				verdict_defendant = attempt

		if("scan_verdict")
			var/obj/item/weapon/paper/paper = usr.get_active_hand()
			if(istype(paper))
				verdict_body = paper.info
				to_chat(usr, "Copy completed.")
			else
				to_chat(usr, "Hold a single paper in your active hand.")
		if("select_citizen")
			verdict_citizenship = href_list["type"]

		if("finish_verdict")
			if(verdict_title == "" || verdict_body == "" || verdict_defendant == "")
				to_chat(usr, "The verdict details are incomplete. Check title, body and defendant.")
				return
			else
				var/citizenship_stat = 0
				if(verdict_citizenship != "None")
					var/datum/computer_file/report/crew_record/record = Retrieve_Record(verdict_defendant)
					if(!record)
						to_chat(usr, "No record found to change citizenship. You must use the full and real name of a defendant if you want to change citizenship status.")
					switch(verdict_citizenship)
						if("Resident")
							citizenship_stat = RESIDENT
						if("Citizen")
							citizenship_stat = CITIZEN
						if("Prisoner")
							citizenship_stat = PRISONER
					record.citizenship = citizenship_stat
				var/datum/verdict/verdict = new()
				verdict.judge = usr.real_name
				verdict.body = verdict_body
				verdict.defendant = verdict_defendant
				verdict.time_rendered = world.realtime
				verdict.citizenship_change = citizenship_stat
				verdict.name = verdict_title
				connected_faction.render_verdict(verdict)
				to_chat(usr, "Verdict Rendered.")
				selected_trial = null
				verdict_body = ""
				verdict_defendant = ""
				verdict_title = ""
				menu = 1


