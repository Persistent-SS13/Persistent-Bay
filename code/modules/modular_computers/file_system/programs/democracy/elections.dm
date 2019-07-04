/datum/computer_file/program/election
	filename = "Elections"
	filedesc = "Nexus City Elections and Nominations"
	program_icon_state = "comm"
	program_menu_icon = "person"
	nanomodule_path = /datum/nano_module/program/election
	extended_desc = "Used to nominate yourself for election and control your nomination."
	requires_ntnet = TRUE
	size = 2
	democratic = 1
	category = PROG_GOVERNMENT
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP | PROGRAM_TELESCREEN

/datum/nano_module/program/election
	name = "Nexus City Elections and Nominations"
	available_to_ai = TRUE

	var/menu = 1
	var/datum/democracy/selected_ballot
/datum/nano_module/program/election/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/datum/world_faction/democratic/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	var/list/data = host.initial_data()
	data["menu"] = menu
	if(menu == 1)
		if(selected_ballot)
			data["selected_ballot"] = selected_ballot.title
			data["ballot_desc"] = selected_ballot.description
			var/list/formatted_candidates[0]
			if(selected_ballot.seeking_reelection && selected_ballot.real_name != "")
				formatted_candidates[++formatted_candidates.len] = list("name" = selected_ballot.real_name, "desc" = selected_ballot.election_desc)
			for(var/datum/candidate/candidate in selected_ballot.candidates)
				formatted_candidates[++formatted_candidates.len] = list("name" = candidate.real_name, "desc" = candidate.desc)
			if(formatted_candidates.len)
				data["candidates"] = formatted_candidates
		else
			if(connected_faction.current_election)
				data["upcoming_election"] = "[connected_faction.current_election.name] is on now until [connected_faction.current_election.end_hour]:00"
			else if(connected_faction.election_toggle)
				data["upcoming_election"] = "This saturday, at 10:00 AM to 10:00 PM the Governor will be elected. The Council election is next saturday."
			else
				data["upcoming_election"] = "This saturday, at 10:00 AM to 10:00 PM the Council will be elected. The Governor election is next saturday."

			var/list/formatted_ballots[0]
			var/list/all_ballots = list()
			all_ballots |= connected_faction.gov
			all_ballots |= connected_faction.city_council
			for(var/datum/democracy/ballot in all_ballots)
				formatted_ballots[++formatted_ballots.len] = list("name" = "[ballot.title] ([ballot.candidates.len])", "ref" = "\ref[ballot]")
			if(formatted_ballots.len)
				data["ballots"] = formatted_ballots
	if(menu == 2)
		var/datum/democracy/ballot = connected_faction.is_governor(user.real_name)
		if(!ballot)
			ballot = connected_faction.is_councillor(user.real_name)
		if(connected_faction.is_judge(user.real_name))
			data["judge"] = 1
		else if(ballot)
			data["elected"] = 1
			data["reelection"] = ballot.seeking_reelection
			data["elected_position"] = ballot.title
			data["candidate_desc"] = ballot.election_desc
		else
			var/list/pairing = connected_faction.is_candidate(user.real_name)
			if(pairing && pairing.len == 2)
				var/datum/candidate/candidate = pairing[1]
				ballot = pairing[2]
				if(candidate && ballot)
					data["candidate"] = 1
					data["candidate_position"] = ballot.title
					data["candidate_desc"] = candidate.desc
			else
				data["eligible"] = 1
				var/list/formatted_ballots[0]
				var/list/all_ballots = list()
				all_ballots |= connected_faction.gov
				all_ballots |= connected_faction.city_council
				for(var/datum/democracy/ballot2 in all_ballots)
					formatted_ballots[++formatted_ballots.len] = list("name" = "[ballot2.title] ([ballot2.candidates.len])", "ref" = "\ref[ballot2]")
				if(formatted_ballots.len)
					data["ballots"] = formatted_ballots
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "elections.tmpl", name, 600, 500, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/election/Topic(href, href_list)
	if(..())
		return 1
	. = SSnano.update_uis(src)
	var/mob/user = usr
	var/datum/world_faction/democratic/connected_faction = program.computer.network_card.connected_network.holder

	switch(href_list["action"])
		if("change_menu")
			menu = text2num(href_list["menu_target"])
		if("deselect_ballot")
			selected_ballot = null
		if("select_ballot")
			selected_ballot = locate(href_list["ref"])
		if("select_ballot_candidate")
			if(connected_faction.is_governor(usr.real_name) || connected_faction.is_councillor(usr.real_name) || connected_faction.is_judge(usr.real_name) || connected_faction.is_candidate(usr.real_name))
				return 0
			var/datum/democracy/ballot = locate(href_list["ref"])
			if(ballot)

				var/choice = input(usr,"Are you sure you want to pay 500$$ to enter the election for [ballot.title]?") in list("Confirm", "Cancel")
				if(choice == "Confirm")
					var/desc = sanitize(input(usr, "Enter Candidacy Description. Maximum 300 Characters", "Candidacy Description", "") as message|null, 300)
					if(!desc)
						desc = ""
					if(ballot == connected_faction.current_election)
						return 0
					var/datum/computer_file/report/crew_record/record = Retrieve_Record(usr.real_name)
					if(record && record.linked_account)
						if(record.linked_account.money < 500)
							to_chat(usr, "Insufficent Funds.")
							return 0
						var/datum/transaction/T = new("Election Fee ([ballot.title])", "Election Fee ([ballot.title])", -500, "Program")
						record.linked_account.do_transaction(T)
						var/datum/candidate/candidate = new()
						candidate.real_name = usr.real_name
						candidate.desc = desc
						ballot.candidates |= candidate

		if("candidate_cancel")
			var/list/pairing = connected_faction.is_candidate(usr.real_name)
			if(pairing && pairing.len == 2)
				var/datum/candidate/candidate = pairing[1]
				var/datum/democracy/ballot = pairing[2]
				if(ballot == connected_faction.current_election)
					return 0
				if(candidate && ballot)
					ballot.candidates -= candidate
		if("candidate_changedesc")
			var/desc = sanitize(input(usr, "Enter Candidacy Description. Maximum 300 Characters", "Candidacy Description", "") as message|null, 300)
			if(!desc)
				desc = ""
			var/list/pairing = connected_faction.is_candidate(usr.real_name)
			if(pairing && pairing.len == 2)
				var/datum/candidate/candidate = pairing[1]
				if(candidate)
					candidate.desc = desc
		if("elected_changedesc")
			var/desc = sanitize(input(usr, "Enter Candidacy Description. Maximum 300 Characters", "Candidacy Description", "") as message|null, 300)
			if(!desc)
				desc = ""
			var/list/pairing = connected_faction.is_candidate(usr.real_name)
			if(pairing && pairing.len == 2)
				var/datum/candidate/candidate = pairing[1]
				if(candidate)
					candidate.desc = desc

		if("select_reelect")
			var/datum/democracy/ballot = connected_faction.is_governor(user.real_name)
			if(!ballot)
				ballot = connected_faction.is_councillor(user.real_name)
			if(ballot && !ballot.seeking_reelection)
				ballot.seeking_reelection = 1
				var/datum/candidate/candidate = new()
				candidate.real_name = ballot.real_name
				candidate.desc = ballot.election_desc
				ballot.candidates |= candidate
		if("select_noreelect")
			var/datum/democracy/ballot = connected_faction.is_governor(user.real_name)
			if(!ballot)
				ballot = connected_faction.is_councillor(user.real_name)
			if(ballot)
				ballot.seeking_reelection = 0
				for(var/datum/candidate/candidate in ballot.candidates)
					if(candidate.real_name == ballot.real_name)
						ballot.candidates -= candidate
						break

