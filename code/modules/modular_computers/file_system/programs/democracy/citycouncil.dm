/datum/computer_file/program/citycouncil
	filename = "citycouncil"
	filedesc = "Nexus City Council Control"
	program_icon_state = "comm"
	program_menu_icon = "flag"
	nanomodule_path = /datum/nano_module/program/citycouncil
	extended_desc = "Used by members of city council to propose and vote on new laws, including tax policy."
	requires_ntnet = TRUE
	size = 12
	democratic = 1
	category = PROG_GOVERNMENT
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP | PROGRAM_TELESCREEN

/datum/nano_module/program/citycouncil
	name = "Nexus City Council Control"
	available_to_ai = TRUE
	var/datum/council_vote/selected_vote
	var/law_type = 1 // 1 = criminal 2 = civil
	var/bill_title = ""
	var/bill_body = ""
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
/datum/nano_module/program/citycouncil/proc/sync_from_faction()
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
			
/datum/nano_module/program/citycouncil/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/datum/world_faction/democratic/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	var/list/data = host.initial_data()
	if(connected_faction.is_councillor(user.real_name))
		data["is_councillor"] = 1
		data["menu"] = menu
		if(menu == 1)
			if(selected_vote)
				var/is_sponsor = 0
				var/billtype
				if(selected_vote.bill_type == 2)
					billtype = "(Civil Law) "
				else if(selected_vote.bill_type == 1)
					billtype = "(Criminal Law) "
				else if(selected_vote.bill_type == 3)
					billtype = "(Tax Policy) "
				else if(selected_vote.bill_type == 4)
					billtype = "(Judge Removal) "
				else if(selected_vote.bill_type == 5)
					billtype = "(Judge Nomination) "
				data["selected_vote"] = "[billtype][selected_vote.name] ([selected_vote.yes_votes.len] Yea / [selected_vote.no_votes.len] Nay)"
				data["propose_time"] = time2text(selected_vote.time_started)
				data["sponsor"] = selected_vote.sponsor
				data["vote_body"] = selected_vote.body
				if(user.real_name == selected_vote.sponsor)
					data["vote_status"] = "You sponsored this bill."
					is_sponsor = 1
				else if(user.real_name in selected_vote.no_votes)
					data["vote_status"] = "You have voted Nay."
				else if(user.real_name in selected_vote.yes_votes)
					data["vote_status"] = "You have voted Yea."
				data["is_sponsor"] = is_sponsor
			else
				if(connected_faction.votes.len)
					var/list/formatted_votes[0]
					for(var/datum/council_vote/vote in connected_faction.votes)
						var/billtype
						if(vote.bill_type == 2)
							billtype = "(Civil Law) "
						else if(vote.bill_type == 1)
							billtype = "(Criminal Law) "
						else if(vote.bill_type == 3)
							billtype = "(Tax Policy) "
						else if(vote.bill_type == 4)
							billtype = "(Judge Removal) "
						else if(vote.bill_type == 5)
							billtype = "(Judge Nomination) "
						formatted_votes[++formatted_votes.len] = list("name" = "[billtype][vote.name] ([vote.yes_votes.len] Yea / [vote.no_votes.len] Nay)", "ref" = "\ref[vote]")
					data["votes"] = formatted_votes
		if(menu == 2)
			data["law_type"] = law_type
			data["bill_title"] = bill_title
			data["bill_body"] = bill_body
		if(menu == 3)
			if(!synced)
				sync_from_faction()
			data["taxee"] = taxee
			if(taxee == 2)
				data["tax"] = "Business Income Tax"
			else
				data["tax"] = "Personal Income Tax"
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
			
		if(menu == 4)
			var/list/formatted_judges[0]
			for(var/datum/democracy/judge in connected_faction.judges)
				formatted_judges[++formatted_judges.len] = list("name" = "Impeach [judge.real_name]", "ref" = "\ref[judge]")
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "citycouncil.tmpl", name, 550, 600, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/citycouncil/Topic(href, href_list)
	if(..())
		return 1
	. = SSnano.update_uis(src)	
	var/mob/user = usr
	var/datum/world_faction/democratic/connected_faction = program.computer.network_card.connected_network.holder
	if(!istype(connected_faction) || !(connected_faction.is_councillor(user.real_name)))
		return 1
		
	switch(href_list["action"])
		if("change_menu")
			menu = text2num(href_list["menu_target"])
		if("deselect_vote")
			selected_vote = null
		if("vote_yes")
			if(!selected_vote) return
			if(usr.real_name in selected_vote.no_votes) return
			connected_faction.vote_yes(selected_vote, usr)
		if("vote_no")
			if(!selected_vote) return
			if(usr.real_name in selected_vote.yes_votes) return
			connected_faction.vote_no(selected_vote, usr)
		if("vote_cancel")
			if(!selected_vote) return
			selected_vote.no_votes -= usr.real_name
			selected_vote.yes_votes -= usr.real_name
		if("withdraw")
			if(!selected_vote || selected_vote.sponsor != usr.real_name) return
			connected_faction.withdraw_vote(selected_vote)
			selected_vote = null
		if("select_vote")
			selected_vote = locate(href_list["ref"])
	
		if("select_criminal")
			law_type = 1
		if("select_civil")
			law_type = 2
		if("change_title")
			var/attempt = sanitizeName(input(usr, "Enter new Bill Title", "Bill Title", bill_title), 30, 1, 0)
			if(attempt)
				bill_title = attempt
		if("scan")
			var/obj/item/weapon/paper/paper = usr.get_active_hand()
			if(istype(paper))
				bill_body = paper.info
				to_chat(usr, "Copy completed.")
			else
				to_chat(usr, "Hold a single paper in your active hand.")
		if("finish")
			if(bill_title == "" || bill_body == "")
				to_chat(usr, "The bill details are incomplete. Check title and body.")
			else if(connected_faction.has_vote(usr.real_name))
				to_chat(usr, "You already have a bill being voted on.")
			else
				var/datum/council_vote/vote = new()
				vote.sponsor = usr.real_name
				vote.time_started = world.realtime
				vote.name = bill_title
				vote.body = bill_body
				vote.bill_type = law_type
				vote.yes_votes |= usr.real_name
				connected_faction.start_vote(vote)
				to_chat(usr, "Vote Started.")
				menu = 1
		if("change_tax")
			taxee = href_list["menu_target"]
			synced = 0
		if("select_flat")
			tax_type = 1
		if("select_prog")
			tax_type = 2
		if("change_prog1_rate")
			var/attempt = input("Enter new minimum tax rate.", "Tax rate") as num|null
			if(attempt < 0 || attempt > 99)
				to_chat(usr, "Invalid Entry.")
				return
			tax_prog1_rate = attempt
		if("change_prog2_rate")
			var/attempt = input("Enter new tax bracket 2 rate.", "Tax rate") as num|null
			if(attempt < 0 || attempt > 99)
				to_chat(usr, "Invalid Entry.")
				return
			tax_prog2_rate = attempt
		if("change_prog3_rate")
			var/attempt = input("Enter new tax bracket 3 rate.", "Tax rate") as num|null
			if(attempt < 0 || attempt > 99)
				to_chat(usr, "Invalid Entry.")
				return
			tax_prog3_rate = attempt
		if("change_prog4_rate")
			var/attempt = input("Enter new tax bracket 4 rate.", "Tax rate") as num|null
			if(attempt < 0 || attempt > 99)
				to_chat(usr, "Invalid Entry.")
				return
			tax_prog4_rate = attempt
			
			
		if("change_prog2_amount")
			var/attempt = input("Enter new tax bracket 2 qualifying amount.", "Qualifying Account Balance") as num|null
			if(attempt < 0)
				to_chat(usr, "Invalid Entry.")
				return
			tax_prog2_amount = attempt	
		
		if("change_prog3_amount")
			var/attempt = input("Enter new tax bracket 3 qualifying amount.", "Qualifying Account Balance") as num|null
			if(attempt < 0)
				to_chat(usr, "Invalid Entry.")
				return
			tax_prog3_amount = attempt	
			
		if("change_prog4_amount")
			var/attempt = input("Enter new tax bracket 4 qualifying amount.", "Qualifying Account Balance") as num|null
			if(attempt < 0)
				to_chat(usr, "Invalid Entry.")
				return
			tax_prog4_amount = attempt
			
		if("change_flat_rate")
			var/attempt = input("Enter new flat tax rate.", "Tax rate") as num|null
			if(attempt < 0 || attempt > 99)
				to_chat(usr, "Invalid Entry.")
				return
			tax_flat_rate = attempt
	
		if("propose_tax")
			if(connected_faction.has_vote(usr.real_name))
				to_chat(usr, "You already have a bill being voted on.")
				return
			if(tax_type == 2)
				if(tax_prog2_rate < tax_prog1_rate)
					to_chat(usr, "Error. Tax 1 rate greater than Tax 2.")
					return 0
				if(tax_prog3_rate < tax_prog2_rate)
					to_chat(usr, "Error. Tax 2 rate greater than Tax 3.")
					return 0
				if(tax_prog4_rate < tax_prog3_rate)
					to_chat(usr, "Error. Tax 3 rate greater than Tax 4.")
					return 0
				if(tax_prog3_amount < tax_prog2_amount)
					to_chat(usr, "Error. Tax 2 amount greater than Tax 3.")
					return 0
				if(tax_prog4_amount < tax_prog3_amount)
					to_chat(usr, "Error. Tax 3 amount greater than Tax 4.")
					return 0
				var/datum/council_vote/vote = new()
				var/taxtitle
				if(taxee == 2)
					taxtitle = "Business Income Tax"
				else
					taxtitle = "Personal Income Tax"
				vote.tax = tax_type
				vote.taxtype = 2
				vote.name = "Progressive [taxtitle] Policy"
				vote.body = "<br>"
				vote.body += "Minimum Tax Rate: [tax_prog1_rate]<br>"
				vote.body += "<br>"
				vote.body += "Bracket 2 Qualifying Amount: [tax_prog2_amount]  Rate : [tax_prog2_rate]<br>"
				vote.body += "<br>"
				vote.body += "Bracket 3 Qualifying Amount: [tax_prog3_amount]  Rate : [tax_prog3_rate]<br>"
				vote.body += "<br>"
				vote.body += "Bracket 4 Qualifying Amount: [tax_prog4_amount]  Rate : [tax_prog4_rate]<br>"
							
				vote.sponsor = usr.real_name
				vote.time_started = world.realtime
				
				vote.prograte1 = tax_prog1_rate
				vote.prograte2 = tax_prog2_rate
				vote.prograte3 = tax_prog3_rate
				vote.prograte4 = tax_prog4_rate
				
				vote.progamount2 = tax_prog2_amount
				vote.progamount3 = tax_prog3_amount
				vote.progamount4 = tax_prog4_amount
				
				vote.bill_type = 3
				
				connected_faction.start_vote(vote)
				to_chat(usr, "Vote Started.")
				menu = 1
			else
				var/datum/council_vote/vote = new()
				var/taxtitle
				if(taxee == 2)
					taxtitle = "Business Income Tax"
				else
					taxtitle = "Personal Income Tax"
				vote.tax = tax_type
				vote.taxtype = 1
				vote.name = "Flat [taxtitle] Policy"
				vote.body = "Flat Tax Rate: [tax_flat_rate]<br>"
				vote.sponsor = usr.real_name
				vote.time_started = world.realtime
				vote.flatrate = tax_flat_rate
				vote.bill_type = 3
				connected_faction.start_vote(vote)
				to_chat(usr, "Vote Started.")
				menu = 1
		if("impeach_judge")
			if(connected_faction.has_vote(usr.real_name))
				to_chat(usr, "You already have a bill being voted on.")
				return
			var/datum/democracy/judge = locate(href_list["ref"])
			if(!judge)
				return
			var/datum/council_vote/vote = new()
			vote.name = "Impeach [judge.real_name]"
			vote.body = "Impeach [judge.real_name] and remove them from office"
			vote.sponsor = usr.real_name
			vote.time_started = world.realtime
			vote.bill_type = 4
			connected_faction.start_vote(vote)
			to_chat(usr, "Vote Started.")
			menu = 1