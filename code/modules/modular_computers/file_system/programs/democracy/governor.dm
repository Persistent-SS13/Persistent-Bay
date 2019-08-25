/datum/computer_file/program/governor
	filename = "governor"
	filedesc = "Nexus City Governor Control"
	program_icon_state = "comm"
	program_menu_icon = "flag"
	nanomodule_path = /datum/nano_module/program/governor
	extended_desc = "Used by the governor to manage executive policy and sign bills put forward by the council."
	requires_ntnet = 1
	size = 12
	democratic = 1
	category = PROG_GOVERNMENT
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP | PROGRAM_TELESCREEN

/datum/nano_module/program/governor
	name = "Nexus City Governor Control"
	available_to_ai = TRUE
	var/datum/council_vote/selected_vote
	var/datum/council_vote/selected_policy
	var/bill_title = ""
	var/bill_body = ""

	var/menu = 1
	var/curr_page = 1
/datum/nano_module/program/governor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/datum/world_faction/democratic/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	var/list/data = host.initial_data()
	if(connected_faction.is_governor(user.real_name))
		data["is_governor"] = 1
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
				data["selected_vote"] = "[billtype][selected_vote.name] ([selected_vote.yes_votes.len] Yea / [selected_vote.no_votes.len] Nay)"
				data["propose_time"] = time2text(selected_vote.time_started)
				data["sponsor"] = selected_vote.sponsor
				data["vote_body"] = selected_vote.body
				data["vote_status"] = "[selected_vote.yes_votes.len] Yea / [selected_vote.no_votes.len] Nay"
				if(selected_vote.yes_votes.len >= 3)
					data["can_sign"] = 1
				if(user.real_name == selected_vote.sponsor)
					is_sponsor = 1
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

						formatted_votes[++formatted_votes.len] = list("name" = "[billtype][vote.name] ([vote.yes_votes.len] Yea / [vote.no_votes.len] Nay)", "ref" = "\ref[vote]")
					data["votes"] = formatted_votes
		if(menu == 2)
			data["bill_title"] = bill_title
			data["bill_body"] = bill_body
		if(menu == 3)
			if(selected_policy)
				data["selected_policy"] = selected_policy.name
				data["publish_time"] = selected_policy.time_signed
				data["signer"] = selected_policy.signer
				data["policy_body"] = selected_policy.body
			else
				if(connected_faction.policy.len)
					var/list/formatted_policies[0]
					for(var/datum/council_vote/vote in connected_faction.policy)

						formatted_policies[++formatted_policies.len] = list("name" = "[vote.name]", "ref" = "\ref[vote]")
					data["policies"] = formatted_policies

		if(menu == 5)
			var/list/transactions =	connected_faction.central_account.transaction_log
			var/pages = transactions.len/10
			if(pages < 1)
				pages = 1
			var/list/formatted_transactions[0]
			if(transactions.len)
				for(var/i=0; i<10; i++)
					var/minus = i+(10*(curr_page-1))
					if(minus < transactions.len)
						var/datum/transaction/T = transactions[transactions.len-minus]
						if(T && istype(T))
							formatted_transactions[++formatted_transactions.len] = list("date" = T.date, "time" = T.time, "target_name" = T.target_name, "purpose" = T.purpose, "amount" = T.amount ? T.amount : 0)
			if(formatted_transactions.len)
				data["transactions"] = formatted_transactions
			data["page"] = curr_page
			data["page_up"] = curr_page < pages
			data["page_down"] = curr_page > 1

			data["money"] = connected_faction.central_account.money

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "governor.tmpl", name, 600, 500, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/governor/Topic(href, href_list)
	if(..())
		return 1
	. = SSnano.update_uis(src)
	var/mob/user = usr
	var/datum/world_faction/democratic/connected_faction = program.computer.network_card.connected_network.holder
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

		if("deselect_vote")
			selected_vote = null
		if("sign_bill")
			if(selected_vote.yes_votes.len < 2)
				return .
			selected_vote.signer = usr.real_name
			connected_faction.pass_vote(selected_vote)
			to_chat(usr, "You sign the bill and it passes.")
			selected_vote = null
			menu = 1

		if("withdraw")
			if(!selected_vote || selected_vote.sponsor != usr.real_name) return
			connected_faction.withdraw_vote(selected_vote)
			selected_vote = null

		if("select_vote")
			selected_vote = locate(href_list["ref"])

		if("change_title")
			var/attempt = sanitize(input(usr, "Enter new Policy Title", "Policy Title", bill_title), 40)
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
				to_chat(usr, "The policy details are incomplete. Check title and body.")
			else
				var/datum/council_vote/vote = new()
				vote.sponsor = usr.real_name
				vote.signer = usr.real_name
				vote.time_signed = world.realtime
				vote.name = bill_title
				vote.body = bill_body
				connected_faction.pass_policy(vote)
				to_chat(usr, "Policy Published.")
				selected_policy = null
				menu = 3

		if("select_policy")
			selected_policy = locate(href_list["ref"])

		if("deselect_policy")
			selected_policy = null

		if("repeal_policy")
			if(!selected_policy) return
			connected_faction.repeal_policy(selected_policy)

		if("nominate_judge")
			var/attempt = input(usr, "Enter the full name of your nominee", "Nominee Name", "")
			var/datum/computer_file/report/crew_record/record = Retrieve_Record(attempt)
			if(record)
				if(connected_faction.is_governor(attempt) || connected_faction.is_councillor(attempt) || connected_faction.is_judge(attempt))
					to_chat(usr, "You cannot nominate someone who is either a govenor, a councillor or already a judge.")
					return .
				var/datum/council_vote/vote = new()
				vote.sponsor = usr.real_name
				vote.signer = usr.real_name
				vote.time_started = world.realtime
				vote.name = "Nomination of [attempt] to become a Judge"
				vote.body = "Nomination of [attempt] to become a Judge"
				vote.bill_type = 5
				vote.nominated = attempt
				connected_faction.start_vote(vote)
				to_chat(usr, "Nomination Started.")
				menu = 1

			else
				to_chat(usr, "No record found for [attempt]")
				return .


