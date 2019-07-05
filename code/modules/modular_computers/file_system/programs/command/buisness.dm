/datum/computer_file/program/business
	filename = "business"
	filedesc = "Business control program"
	nanomodule_path = /datum/nano_module/program/business
	program_icon_state = "id"
	program_menu_icon = "key"
	extended_desc = "Used to manage everything business related."
	requires_ntnet = TRUE
	size = 4
	category = PROG_BUSINESS
	usage_flags = PROGRAM_ALL

/datum/nano_module/program/business
	name = "Business control program"
	var/datum/small_business/viewing
	var/menu = 1
	var/submenu = 1
	var/viewing_employee = ""
	var/curr_page = 1
	var/business_name = ""
	var/list/pending_contracts = list()
	var/list/signed_contracts = list()
	var/potential_name = ""

	var/image/insert1
	var/image/insert2
	var/insert1_name
	var/insert2_name

	var/openfile
	var/filedata
	var/headline
	var/error
	var/is_edited
	var/nfmenu = 1
/datum/nano_module/program/business/Destroy()
	cancel_contracts()
	. = ..()

/datum/nano_module/program/business/proc/cancel_contracts()
	for(var/obj/item/weapon/paper/contract/contract in pending_contracts)
		contract.cancel()
	for(var/obj/item/weapon/paper/contract/contract in signed_contracts)
		contract.cancel()

/datum/nano_module/program/business/proc/get_distributed()
	var/distributed = 0
	for(var/obj/item/weapon/paper/contract/contract in signed_contracts)
		distributed += contract.ownership
	if(distributed > 100)
		cancel_contracts()
		return 0
	return distributed

/datum/nano_module/program/business/proc/get_contributed()
	var/contributed = 0
	for(var/obj/item/weapon/paper/contract/contract in signed_contracts)
		contributed += contract.required_cash
	return contributed


/datum/nano_module/program/business/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/obj/item/weapon/card/id/user_id_card = user.GetIdCard()
	if(user_id_card && !user_id_card.valid) user_id_card = null
	var/list/data = host.initial_data()
	data["src"] = "\ref[src]"
	if(!viewing && business_name)
		viewing = get_business(business_name)
		if(!viewing) business_name = ""
	if(viewing)
		submenu = 1
		data["found_business"] = 1
		data["business_name"] = viewing.name
		data["closed"] = !viewing.status
		if(user_id_card)
			data["allowed"] = viewing.is_allowed(user_id_card.registered_name)
			data["user_name"] = user_id_card.registered_name
			data["clocked_in"] = viewing.is_clocked_in(user_id_card.registered_name)
			data["clock_in"] = data["clocked_in"] ? "clocked in" : "not clocked in"
			var/datum/employee_data/employee = viewing.get_employee_data(user_id_card.registered_name)
			if(employee)
				data["current_pay"] = employee.pay_rate
			else
				data["current_pay"] = 0
		if(menu == 1)
			data["tasks"] = pencode2html(viewing.tasks)
			data["sales"] = viewing.sales_short

		if(menu == 2)
			var/sales_long = 0
			if(viewing.sales_long.len)
				for(var/num in viewing.sales_long)
					sales_long += text2num(num)
			data["sales"] = viewing.sales_short
			data["sales_long"] = sales_long
			if(user_id_card)
				data["expenses"] = viewing.get_expenses(user_id_card.registered_name)
				data["expense_limit"] = viewing.get_expense_limit(user_id_card.registered_name)

			var/list/transactions = viewing.central_account.transaction_log
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

			data["money"] = viewing.central_account.money
			data["debt"] = viewing.get_debt()

		if(menu == 3)
			var/list/formatted_names[0]
			for(var/real_name in viewing.employees)
				formatted_names[++formatted_names.len] = list("name" = real_name)
			data["employees"] = formatted_names
			if(viewing_employee && viewing_employee != "")
				var/datum/employee_data/employee = viewing.get_employee_data(viewing_employee)
				if(employee)
					data["employee_selected"] = 1
					data["employee_name"] = viewing_employee
					data["employee_title"] = employee.job_title
					data["employee_pay"] = employee.pay_rate
					data["employee_expenses"] = employee.expenses
					data["employee_expense_limit"] = employee.expense_limit
					var/list/formatted[0]
					var/list/all_access = ACCESS_BUSINESS_DEFAULT_ALL
					for(var/x in all_access)
						var/select = 0
						if(x in employee.accesses)
							select = 1
						formatted[++formatted.len] = list("access" = x, "select" = select)
					data["accesses"] = formatted
				else
					viewing_employee = ""
		if(menu == 4)
			data["tasks"] = pencode2html(viewing.tasks)
			if(viewing.tax_network && viewing.tax_network != "")
				data["taxed"] = 1
				data["tax_network"] = viewing.tax_network
		if(menu == 5)
			var/list/formatted_names[0]
			for(var/x in viewing.stock_holders)
				formatted_names[++formatted_names.len] = list("holder_name" = x, "holding" = viewing.stock_holders[x])
			data["stock_holders"] = formatted_names
			var/list/formatted_proposals[0]
			for(var/datum/proposal/proposal in viewing.proposals)
				var/supported = 0
				var/denied = 0
				var/cancel = 0
				if(user_id_card && proposal.started_by == user_id_card.registered_name) cancel = 1
				if(user_id_card && user_id_card.registered_name in proposal.supporters) supported = 1
				if(user_id_card && user_id_card.registered_name in proposal.deniers) denied = 1
				formatted_proposals[++formatted_proposals.len] = list("proposal" = "[proposal.name], Supporting: [proposal.get_support()] Against: [proposal.get_deny()]", "proposal_ref" = "\ref[proposal]", "supported" = supported, "denied" = denied, "cancel" = cancel)
			data["proposals"] = formatted_proposals
			var/list/formatted_old_proposals[0]
			for(var/x in viewing.proposals_old)
				formatted_old_proposals[++formatted_old_proposals.len] = list("recent_proposal" = x)
			data["recent_proposals"] = formatted_old_proposals
			data["ceo_name"] = viewing.ceo_name
			data["ceo_title"] = viewing.ceo_title
			data["ceo_payrate"] = viewing.ceo_payrate
			data["ceo_dividend"] = viewing.ceo_dividend
			data["holders_dividend"] = viewing.stock_holders_dividend
			if(user_id_card)
				data["personal_holding"] = viewing.get_stocks(user_id_card.registered_name)
			else
				data["personal_holding"] = 0
		if(menu == 6)
			data["nfmenu"] = nfmenu
			data["feed_invis"] = !viewing.feed.visible
			data["newsfeed_name"] = viewing.feed.name
			data["article_price"] = viewing.feed.per_article
			data["paper_price"] = viewing.feed.per_issue
			data["article_announcement"] = viewing.feed.announcement

			if(headline && headline != "")
				data["headline"] = headline
			else
				data["headline"] = "*None*"
			if(insert1_name && insert1_name != "")
				data["copied_image1"] = insert1_name
			else
				data["copied_image1"] =" *None*"
			if(insert2_name && insert2_name != "")
				data["copied_image2"] = insert2_name
			else
				data["copied_image2"] = "*None*"
			data["issue_name"] = viewing.feed.current_issue.name
			var/list/formatted_articles[0]
			for(var/datum/NewsStory/story in viewing.feed.current_issue.stories)
				formatted_articles[++formatted_articles.len] = list("name" = story.name)
			data["articles"] = formatted_articles
			data["filedata"] = imgcode2html(pencode2html(filedata), insert1, insert2, user)




	else
		data["submenu"] = submenu
		menu = 1
		if(submenu == 1)
			if(user_id_card)
				var/list/lis = get_businesses(user_id_card.registered_name)
				var/list/formatted_names[0]
				for(var/datum/small_business/business in lis)
					formatted_names[++formatted_names.len] = list("name" = business.name)
				data["businesses"] = formatted_names
		else if(submenu == 2)
			data["chosen_name"] = potential_name
			var/list/formatted_names[0]
			for(var/obj/item/weapon/paper/contract/contract in signed_contracts)
				formatted_names[++formatted_names.len] = list("signed_contract" = "[contract.ownership] stocks for [contract.required_cash]$$ to [contract.signed_by]")
			data["signed_contracts"] = formatted_names
			var/commitment = get_contributed()
			var/signed_stocks = get_distributed()
			var/finalize = 0
			if(commitment >= 5000 && signed_stocks == 100 && potential_name && potential_name != "") finalize = 1
			data["commitment"] = commitment
			data["signed_stocks"] = signed_stocks
			data["finish_ready"] = finalize


	data["menu"] = menu


	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "business_control.tmpl", name, 600, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/business/contract_signed(var/obj/item/weapon/paper/contract/contract)
	pending_contracts -= contract
	signed_contracts |= contract
	SSnano.update_uis(src)
	return 1

/datum/nano_module/program/business/contract_cancelled(var/obj/item/weapon/paper/contract/contract)
	pending_contracts -= contract
	signed_contracts -= contract
	SSnano.update_uis(src)
	return 1

/datum/nano_module/program/business/proc/get_file(var/filename)
	var/obj/item/weapon/computer_hardware/hard_drive/HDD = program.computer.hard_drive
	if(!HDD)
		return
	var/datum/computer_file/data/F = HDD.find_file_by_name(filename)
	if(!istype(F))
		return
	return F

/datum/nano_module/program/business/proc/open_file(var/filename)
	var/datum/computer_file/data/F = get_file(filename)
	if(F)
		filedata = F.stored_data
		return 1

/datum/nano_module/program/business/proc/save_file(var/filename)
	var/datum/computer_file/data/F = get_file(filename)
	if(!F) //try to make one if it doesn't exist
		F = create_file(filename, filedata)
		return !isnull(F)
	var/datum/computer_file/data/backup = F.clone()
	var/obj/item/weapon/computer_hardware/hard_drive/HDD = program.computer.hard_drive
	if(!HDD)
		return
	HDD.remove_file(F)
	F.stored_data = filedata
	F.calculate_size()
	if(!HDD.store_file(F))
		HDD.store_file(backup)
		return 0
	is_edited = 0
	return 1

/datum/nano_module/program/business/proc/create_file(var/newname, var/data = "")
	if(!newname)
		return
	var/obj/item/weapon/computer_hardware/hard_drive/HDD = program.computer.hard_drive
	if(!HDD)
		return
	if(get_file(newname))
		return
	var/datum/computer_file/data/F = new/datum/computer_file/data()
	F.filename = newname
	F.filetype = "TXT"
	F.stored_data = data
	F.calculate_size()
	if(HDD.store_file(F))
		return F


/datum/nano_module/program/business/Topic(href, href_list)
	if(..())
		return 1

	var/mob/user = usr
	var/obj/item/weapon/card/id/user_id_card = user.GetIdCard()
	var/datum/small_business/connected_business
	if(business_name && business_name != "") connected_business = get_business(business_name)
	if(!user_id_card) return
	if(href_list["page_up"])
		curr_page++
		return 1
	if(href_list["page_down"])
		curr_page--
		return 1
	if(href_list["PRG_openfile"])
		. = 1
		if(is_edited)
			if(alert("Would you like to save your changes first?",,"Yes","No") == "Yes")
				save_file("[headline] (draft)")
		if(!open_file(href_list["PRG_openfile"]))
			error = "I/O error: Unable to open file '[href_list["PRG_openfile"]]'."

	if(href_list["PRG_newfile"])
		. = 1
		if(is_edited)
			if(alert("Would you like to save your changes first?",,"Yes","No") == "Yes")
				save_file("[headline] (draft)")

		var/newname = sanitize(input(usr, "Enter headline name:", "New Headline") as text|null)
		if(!newname)
			return 1
		filedata = ""
		headline = newname
	if(href_list["PRG_editname"])
		. = 1
		var/newname = sanitize(input(usr, "Enter headline name:", "New Headline") as text|null)
		if(!newname)
			return 1
		headline = newname
	if(href_list["PRG_saveasfile"])
		. = 1
		var/newname = sanitize(input(usr, "Enter file name to save draft under:", "Save Draft") as text|null)
		if(!newname)
			return 1
		var/datum/computer_file/data/F = create_file(newname, filedata)
		if(!F)
			error = "I/O error: Unable to create file '[href_list["PRG_saveasfile"]]'."
		return 1
	if(href_list["PRG_publish"])
		if(!connected_business.has_access(user_id_card.registered_name, "Newsfeed"))
			to_chat(usr, "Access denied.")
			return
		if(!connected_business.feed.visible)
			to_chat(usr, "The Newsfeed must be visible to publish.")
			return
		if(!headline || headline == "")
			to_chat(usr, "This must have a valid headline.")
			return
		if(!filedata || filedata == "")
			to_chat(usr, "Their must be content in the article to publish it.")
			return
		var/choice = input(usr,"This will publish [headline], announcing it to subscribed newscasters and making it available for purchase. Are you sure?") in list("Confirm", "Cancel")
		if(choice == "Confirm")
			var/datum/NewsStory/story = new()
			story.name = headline
			story.image1 = insert1
			story.image2 = insert2
			story.body = filedata
			story.author = user_id_card.registered_name
			story.true_author = usr.real_name
			story.publish_date = "[stationdate2text()] [stationtime2text()]"
			story.uid = world.realtime
			connected_business.feed.publish_story(story)
			insert1 = null
			insert1_name = null
			insert2 = null
			insert2_name = null
			headline = ""
			filedata = ""
	if(href_list["PRG_editfile"])
		var/oldtext = html_decode(filedata)
		oldtext = replacetext(oldtext, "\[br\]", "\n")

		var/newtext = sanitize(replacetext(input(usr, "Editing article '[headline]'. You may use most tags used in paper formatting plus \[IMG\] and \[IMG2\]:", "Text Editor", oldtext) as message|null, "\n", "\[br\]"), MAX_TEXTFILE_LENGTH)
		if(!newtext)
			return
		filedata = newtext
		is_edited = 1
		return 1
	if(href_list["PRG_taghelp"])
		to_chat(usr, "<span class='notice'>The hologram of a googly-eyed paper clip helpfully tells you:</span>")
		var/help = {"
		\[tab\] : Indents the text.
		\[br\] : Creates a linebreak.
		\[center\] - \[/center\] : Centers the text.
		\[h1\] - \[/h1\] : First level heading.
		\[h2\] - \[/h2\] : Second level heading.
		\[h3\] - \[/h3\] : Third level heading.
		\[b\] - \[/b\] : Bold.
		\[i\] - \[/i\] : Italic.
		\[u\] - \[/u\] : Underlined.
		\[small\] - \[/small\] : Decreases the size of the text.
		\[large\] - \[/large\] : Increases the size of the text.
		\[field\] : Inserts a blank text field, which can be filled later. Useful for forms.
		\[date\] : Current station date.
		\[time\] : Current station time.
		\[list\] - \[/list\] : Begins and ends a list.
		\[*\] : A list item.
		\[hr\] : Horizontal rule.
		\[table\] - \[/table\] : Creates table using \[row\] and \[cell\] tags.
		\[grid\] - \[/grid\] : Table without visible borders, for layouts.
		\[row\] - New table row.
		\[cell\] - New table cell.
		\[logo\] - Inserts NT logo image.
		\[bluelogo\] - Inserts blue NT logo image.
		\[solcrest\] - Inserts SCG crest image.
		\[terraseal\] - Inserts TCC seal.
		\[nfrseal\] - Inserts NFR seal.
		\[IMG1\] - Inserts attached photo 1.
		\[IMG2\] - Inserts attached photo 2.
		"}

		to_chat(usr, help)
		return 1

	switch(href_list["action"])

		if("switchnfm")
			if(!connected_business.has_access(user_id_card.registered_name, "Newsfeed"))
				to_chat(usr, "Access denied.")
				return
			if(href_list["target"] == "settings")
				nfmenu = 1
			else if (href_list["target"] == "issue")
				nfmenu = 2
			else if (href_list["target"] == "article")
				nfmenu = 3
		if("feed_invis")
			if(!connected_business.has_access(user_id_card.registered_name, "Newsfeed"))
				to_chat(usr, "Access denied.")
				return
			connected_business.feed.visible = 1
		if("feed_vis")
			if(!connected_business.has_access(user_id_card.registered_name, "Newsfeed"))
				to_chat(usr, "Access denied.")
				return
			connected_business.feed.visible = 1

		if("feed_name")
			if(!connected_business.has_access(user_id_card.registered_name, "Newsfeed"))
				to_chat(usr, "Access denied.")
				return
			var/select_name = sanitizeName(input(usr,"Enter the new name of the newsfeed.","Newsfeed name", connected_business.feed.name) as null|text, 40, 1, 0)
			if(select_name)
				connected_business.feed.name = select_name
		if("feed_articleprice")
			if(!connected_business.has_access(user_id_card.registered_name, "Newsfeed"))
				to_chat(usr, "Access denied.")
				return
			var/amount = input("Enter price to charge per article.", "Article price", 0) as null|num
			if(!amount < 0)
				amount = 0
			connected_business.feed.per_article = amount

		if("feed_paperprice")
			if(!connected_business.has_access(user_id_card.registered_name, "Newsfeed"))
				to_chat(usr, "Access denied.")
				return
			var/amount = input("Enter price to charge per issue.", "Issue price", 0) as null|num
			if(!amount < 0)
				amount = 0
			connected_business.feed.per_issue = amount
		if("feed_annoucement")
			if(!connected_business.has_access(user_id_card.registered_name, "Newsfeed"))
				to_chat(usr, "Access denied.")
				return
			var/select_name = sanitizeName(input(usr,"Enter the new announcement for article publishing.","Announcement", connected_business.feed.announcement) as null|text, 40, 1, 0)
			if(select_name)
				connected_business.feed.announcement = select_name
		if("feed_issuename")
			if(!connected_business.has_access(user_id_card.registered_name, "Newsfeed"))
				to_chat(usr, "Access denied.")
				return
			var/select_name = sanitizeName(input(usr,"Enter the new name of the current issue.","Issue name", connected_business.feed.current_issue.name) as null|text, 40, 1, 0)
			if(select_name)
				connected_business.feed.current_issue.name = select_name
		if("feed_issuepublish")
			if(!connected_business.has_access(user_id_card.registered_name, "Newsfeed"))
				to_chat(usr, "Access denied.")
				return
			if(!connected_business.feed.current_issue.stories.len > 1)
				to_chat(usr, "There is not enough articles to publish this yet.")
				return
			if(!connected_business.feed.visible)
				to_chat(usr, "The Newsfeed must be visible to publish.")
				return
			var/choice = input(usr,"This will publish [connected_business.feed.current_issue.name], announcing it to subscribed newscasters and making it available for purchase. Are you sure?") in list("Confirm", "Cancel")
			if(choice == "Confirm")
				connected_business.feed.current_issue.publish_date = "[stationdate2text()] [stationtime2text()]"
				connected_business.feed.current_issue.publisher = user_id_card.registered_name
				connected_business.feed.publish_issue()

		if("sale")
			if(!connected_business) return
			if(!user_id_card) return
			if(!connected_business.status)
				to_chat(usr, "The business is closed and so you cannot create a sale.")
				return
			if(!connected_business.has_access(user_id_card.registered_name, "Sales"))
				to_chat(usr, "Access denied.")
				return

		if("copy_image1")
			var/obj/item/I = usr.get_active_hand()
			if(istype(I, /obj/item/weapon/photo))
				var/obj/item/weapon/photo/photo = I
				insert1 = image(photo.tiny.icon)
				insert1_name = photo.name

		if("delete_image1")
			insert1 = null
			insert1_name = null

		if("copy_image2")
			var/obj/item/I = usr.get_active_hand()
			if(istype(I, /obj/item/weapon/photo))
				var/obj/item/weapon/photo/photo = I
				insert2 = image(photo.tiny.icon)
				insert2_name = photo.name

		if("delete_image2")
			insert2 = null
			insert2_name = null

		if("switchm")
			if(href_list["target"] == "sale")
				menu = 1
			else if (href_list["target"] == "budget")
				if(!connected_business.has_access(user_id_card.registered_name, "Budget View"))
					to_chat(usr, "Access denied.")
					return
				menu = 2
			else if (href_list["target"] == "employee")
				if(!connected_business.has_access(user_id_card.registered_name, "Employee Control"))
					to_chat(usr, "Access denied.")
					return
				menu = 3
			else if (href_list["target"] == "management")
				if(!connected_business.has_access(user_id_card.registered_name, "Upper Management"))
					to_chat(usr, "Access denied.")
					return
				menu = 4
			else if (href_list["target"] == "news")
				if(!connected_business.has_access(user_id_card.registered_name, "Newsfeed"))
					to_chat(usr, "Access denied.")
					return
				menu = 6
			else if (href_list["target"] == "stock")

				if(!connected_business.is_stock_holder(user_id_card.registered_name))
					to_chat(usr, "Access denied.")
					return
				menu = 5

			else if (href_list["target"] == "logout")
				viewing = null
				business_name = ""
		if("paydebt")
			if(!connected_business) return
			if(!user_id_card) return
			if(!connected_business.has_access(user_id_card.registered_name, "Budget View"))
				to_chat(usr, "Access denied.")
				return
			connected_business.pay_debt()
		if("clockout")
			if(!connected_business) return
			connected_business.clock_out(user.get_stack())

		if("clockin")
			if(!connected_business) return
			if(!connected_business.status)
				to_chat(usr, "The business is closed and so you cannot clock in.")
				return
			connected_business.clock_in(user.get_stack())

		if("sale")
			if(!connected_business) return
			if(!user_id_card) return
			if(!connected_business.status)
				to_chat(usr, "The business is closed and so you cannot create a sale.")
				return
			if(!connected_business.has_access(user_id_card.registered_name, "Sales"))
				to_chat(usr, "Access denied.")
				return
			var/reason = sanitize(input(usr, "Enter the reason for the sale.", "Sale reason", "") as message|null, MAX_TEXTFILE_LENGTH)
			if(!reason)
				to_chat(usr,"Text was not valid.")
				return 1
			var/amount = input("Sale amount", "Sale amount", 0) as null|num
			if(!amount || amount < 0)
				to_chat(usr,"You cannot create a sale for nothing.")
				return 1

			var/idname = user_id_card.registered_name
			var/idrank = connected_business.get_title(user_id_card.registered_name)

			var/t = ""
			t += "<font face='Verdana' color=blue><table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'><center></td><tr><td><H1>[connected_business.name]</td>"
			t += "<tr><td><br><b>Status:</b>*Unpaid*<br>"
			t += "<b>Total:</b> [amount] $$ Ethericoins<br><br><table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>"
			t += "<td>Authorized by:<br>[idname] [idrank]<br><td>Paid by:<br>*None*</td></tr></table><br></td>"
			t += "<tr><td><h3>Reason</H3><font size = '1'>[reason]<br></td></tr></table><br><table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>"
			t += "<td></font><font size='4'><b>Swipe ID to confirm transaction.</b></font></center></font>"
			var/obj/item/weapon/paper/invoice/business/invoice = new()
			invoice.info = t
			invoice.purpose = reason
			invoice.transaction_amount = amount
			invoice.linked_business = connected_business.name
			invoice.loc = get_turf(program.computer)
			playsound(get_turf(program.computer), pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 75, 1, -3)
			invoice.name = "[connected_business.name] digital invoice"

		if("addemployee")
			if(!user_id_card) return
			if(!connected_business) return
			if(!connected_business.has_access(user_id_card.registered_name, "Employee Control"))
				to_chat(usr, "Access denied.")
				return
			var/select_name = sanitizeName(input(usr,"Enter full name of the new hire.","Add new employee", "") as null|text, MAX_NAME_LEN, 1, 0)
			if(select_name)
				if(select_name == connected_business.ceo_name)
					to_chat(usr, "[select_name] is the CEO.")
					return
				var/found = 0
				for(var/datum/computer_file/report/crew_record/R in GLOB.all_crew_records)
					if(R.get_name() == select_name)
						found = 1
						break
				if(!found)
					var/datum/computer_file/report/crew_record/L = Retrieve_Record(select_name)
					if(L) found = 1
				if(!found)
					to_chat(usr, "No record found for [select_name]. Verify Employee Identity.")
					return

				if(connected_business.add_employee(select_name))
					viewing_employee = select_name
				else
					to_chat(usr, "Employee hire failed. Either they are already hired or the name was invalid.")

		if("editemployee")
			if(!user_id_card) return
			if(!connected_business) return
			if(!connected_business.has_access(user_id_card.registered_name, "Employee Control"))
				to_chat(usr, "Access denied.")
				return
			var/select_name = sanitizeName(input(usr,"Enter full name of the employee.","Edit employee", "") as null|text, MAX_NAME_LEN, 1, 0)
			if(select_name)
				if(select_name == connected_business.ceo_name)
					to_chat(usr, "[select_name] is the CEO, only stockholders can edit.")
					return
				if(connected_business.is_employee(select_name))
					viewing_employee = select_name
				else
					to_chat(usr, "Employee not found.")
		if("employee_close")
			if(!user_id_card) return
			if(!connected_business.has_access(user_id_card.registered_name, "Employee Control"))
				to_chat(usr, "Access denied.")
				return
			viewing_employee = ""

		if("employee_fire")
			if(!user_id_card) return
			if(!connected_business.has_access(user_id_card.registered_name, "Employee Control"))
				to_chat(usr, "Access denied.")
				return
			if(!viewing_employee || viewing_employee == "") return
			var/choice = input(usr,"This will fire [viewing_employee] and remove them from the network. Are you sure?") in list("Confirm", "Cancel")
			if(choice == "Confirm")
				connected_business.employees -= viewing_employee
				viewing_employee = ""
		if("employee_print")
			if(!user_id_card) return
			if(!connected_business) return
			if(connected_business.last_id_print > world.realtime)
				to_chat(usr, "Your  print was rejected. The business has printed a nametag in the last 5 mintues.")
				return

			if(user_id_card.registered_name == connected_business.ceo_name)
				var/datum/computer_file/report/crew_record/record
				for(var/datum/computer_file/report/crew_record/R in GLOB.all_crew_records)
					if(R.get_name() == user_id_card.registered_name)
						record = R
						break
				if(!record)
					record = Retrieve_Record(user_id_card.registered_name)
				if(!record)
					message_admins("NO global record found for [usr.real_name]")
					to_chat(usr, "No record found for [usr.real_name].. contact software developer.")
					return
				var/obj/item/weapon/card/id/id = new()
				var/datum/world_faction/connected_faction
				if(program.computer.network_card && program.computer.network_card.connected_network)
					connected_faction = program.computer.network_card.connected_network.holder
				id.selected_business = connected_business.name
				if(connected_faction)
					id.approved_factions |= connected_faction.uid
				id.registered_name = user_id_card.registered_name
				id.validate_time = world.realtime
				if(record.linked_account)
					id.associated_account_number = record.linked_account.account_number
				id.rank = 2	//actual job
				connected_business.last_id_print = world.realtime + 5 MINUTES
				playsound(get_turf(program.computer), pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 75, 1, -3)
				id.forceMove(get_turf(program.computer))
				id.assignment = connected_business.ceo_title
				id.icon_state = "name_tag"
				id.update_name()
			else

				var/datum/employee_data/employee = connected_business.get_employee_data(user_id_card.registered_name)
				if(!employee)
					return
				var/datum/computer_file/report/crew_record/record
				for(var/datum/computer_file/report/crew_record/R in GLOB.all_crew_records)
					if(R.get_name() == user_id_card.registered_name)
						record = R
						break
				if(!record)
					record = Retrieve_Record(user_id_card.registered_name)
				if(!record)
					message_admins("NO global record found for [usr.real_name]")
					to_chat(usr, "No record found for [usr.real_name].. contact software developer.")
					return
				var/obj/item/weapon/card/id/id = new()
				var/datum/world_faction/connected_faction
				if(program.computer.network_card && program.computer.network_card.connected_network)
					connected_faction = program.computer.network_card.connected_network.holder
				id.selected_business = connected_business.name
				if(connected_faction)
					id.approved_factions |= connected_faction.uid
				id.registered_name = user_id_card.registered_name
				id.validate_time = world.realtime
				if(record.linked_account)
					id.associated_account_number = record.linked_account.account_number
				id.rank = 1	//actual job
				connected_business.last_id_print = world.realtime + 5 MINUTES
				playsound(get_turf(program.computer), pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 75, 1, -3)
				id.forceMove(get_turf(program.computer))
				id.assignment = employee.job_title
				id.icon_state = "name_tag"
				id.update_name()

		if("employee_title")
			if(!connected_business) return
			if(!user_id_card) return
			if(!viewing_employee || viewing_employee == "")
				return
			if(!connected_business.has_access(user_id_card.registered_name, "Employee Control"))
				to_chat(usr, "Access denied.")
				return
			var/datum/employee_data/employee = connected_business.get_employee_data(viewing_employee)
			if(!employee)
				viewing_employee = ""
				return
			var/select_title = sanitizeName(input(usr,"Enter Job Title","Edit Job title", employee.job_title) as null|text, MAX_NAME_LEN, 1, 0)
			if(select_title)
				employee.job_title = select_title
				update_ids(viewing_employee)

		if("employee_pay")
			if(!user_id_card) return
			if(!connected_business) return
			if(!viewing_employee || viewing_employee == "")
				return
			if(!connected_business.has_access(user_id_card.registered_name, "Employee Control"))
				to_chat(usr, "Access denied.")
				return
			var/datum/employee_data/employee = connected_business.get_employee_data(viewing_employee)
			if(!employee)
				viewing_employee = ""
				return
			var/amount = round(input("Edit [viewing_employee] Pay", "Edit pay", employee.pay_rate) as null|num)
			if(!amount)
				amount = 0
			employee.pay_rate = amount


		if("employee_expense_limit")
			if(!user_id_card) return
			if(!connected_business) return
			if(!viewing_employee || viewing_employee == "")
				return
			if(!connected_business.has_access(user_id_card.registered_name, "Employee Control"))
				to_chat(usr, "Access denied.")
				return
			var/datum/employee_data/employee = connected_business.get_employee_data(viewing_employee)
			if(!employee)
				viewing_employee = ""
				return
			var/amount = round(input("Edit [viewing_employee] expense limit", "Edit expenses", employee.expense_limit) as null|num)
			if(!amount)
				amount = 0
			employee.expense_limit = amount


		if("employee_expenses")
			if(!user_id_card) return
			if(!connected_business) return
			if(!viewing_employee || viewing_employee == "")
				return
			if(!connected_business.has_access(user_id_card.registered_name, "Employee Control"))
				to_chat(usr, "Access denied.")
				return
			var/datum/employee_data/employee = connected_business.get_employee_data(viewing_employee)
			if(!employee)
				viewing_employee = ""
				return
			employee.expenses = 0



		if("toggleAccess")
			if(!user_id_card) return
			if(!connected_business) return
			if(!viewing_employee || viewing_employee == "")
				return
			if(!connected_business.has_access(user_id_card.registered_name, "Employee Control"))
				to_chat(usr, "Access denied.")
				return
			var/datum/employee_data/employee = connected_business.get_employee_data(viewing_employee)
			if(!employee)
				viewing_employee = ""
				return
			var/access = href_list["target"]
			if(access in employee.accesses)
				employee.accesses -= access
			else
				employee.accesses |= access



		if("employee_select")
			if(!user_id_card) return
			if(!connected_business.has_access(user_id_card.registered_name, "Employee Control"))
				to_chat(usr, "Access denied.")
				return
			var/select_name = href_list["target"]
			if(select_name)
				if(select_name == connected_business.ceo_name)
					to_chat(usr, "[select_name] is the CEO, only stockholders can edit.")
					return
				if(connected_business.is_employee(select_name))
					viewing_employee = select_name
				else
					to_chat(usr, "Employee not found.")

		if("edit_tasks")
			if(!user_id_card) return
			if(!connected_business.has_access(user_id_card.registered_name, "Upper Management"))
				to_chat(usr, "Access denied.")
				return
			var/oldtext = html_decode(connected_business.tasks)
			oldtext = replacetext(oldtext, "\[editorbr\]", "\n")
			var/newtext = sanitize(replacetext(input(usr, "Enter the new tasks. You may use most tags from paper formatting", "Task edit", oldtext) as message|null, "\n", "\[editorbr\]"), 20000)
			if(newtext)
				connected_business.tasks = newtext




		if("close_business")
			if(!user_id_card) return
			if(!connected_business.has_access(user_id_card.registered_name, "Upper Management"))
				to_chat(usr, "Access denied.")
				return
			connected_business.close()


		if("open_business")
			if(!user_id_card) return
			if(!connected_business.has_access(user_id_card.registered_name, "Upper Management"))
				to_chat(usr, "Access denied.")
				return
			connected_business.open()

		if("expense_print")
			if(!connected_business) return
			if(connected_business.last_expense_print > world.realtime)
				to_chat(usr, "Your  print was rejected. You have printed an expense card in the last 10 minutes.")
				return
			if(!connected_business.has_access(user_id_card.registered_name, "Upper Management"))
				to_chat(usr, "Access denied.")
				return
			var/obj/item/weapon/card/expense/expense = new()
			expense.ctype = 2
			expense.linked = connected_business.name
			connected_business.last_expense_print = world.realtime + 10 MINUTES
			playsound(get_turf(program.computer), pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 75, 1, -3)
			expense.forceMove(get_turf(program.computer))

		if("expense_devalidate")
			if(!user_id_card) return
			if(!connected_business.has_access(user_id_card.registered_name, "Upper Management"))
				to_chat(usr, "Access denied.")
				return
			devalidate_expense_cards(2, connected_business.name)

		if("tax_disconnect")
			if(!user_id_card) return
			if(!connected_business.has_access(user_id_card.registered_name, "Upper Management"))
				to_chat(usr, "Access denied.")
				return
			var/choice = input(usr,"Leaving this tax network will show up on the factions records. Are you sure?") in list("Confirm", "Cancel")
			if(choice == "Confirm")
				var/datum/world_faction/connected_faction = get_faction(connected_business.tax_network)
				if(connected_faction)
					var/datum/transaction/T = new("business ([connected_business.name]) disconnects from our tax network", "TAX DISCONNECT", 0, "business Program")
					connected_faction.central_account.transaction_log |= T
				connected_business.tax_network = ""
		if("tax_connect")
			if(!user_id_card) return
			if(!connected_business.has_access(user_id_card.registered_name, "Upper Management"))
				to_chat(usr, "Access denied.")
				return
			var/select_title = sanitizeName(input(usr,"Enter Faction UID","Connet to tax network", "") as null|text, MAX_NAME_LEN, 1, 0)
			if(select_title)
				var/datum/world_faction/connected_faction = get_faction(select_title)
				if(connected_faction)
					var/datum/transaction/T = new("business ([connected_business.name]) connects to our tax network", "TAX CONNECTION", 0, "business Program")
					connected_faction.central_account.transaction_log |= T
					connected_business.tax_network = select_title
				else
					to_chat(usr, "Network not found.")
					return

		if("toggleSupport")
			if(!connected_business) return
			if(!user_id_card) return
			if(!connected_business.is_stock_holder(user_id_card.registered_name))
				to_chat(usr, "Access denied.")
				return
			var/datum/proposal/proposal = locate(href_list["target"])
			if(!proposal)
				message_admins("couldnt find proposal")
				return
			if(user_id_card.registered_name in proposal.supporters)
				proposal.remove_support(user_id_card.registered_name)
			else
				proposal.add_support(user_id_card.registered_name, connected_business.get_stocks(user_id_card.registered_name))
		if("toggleDeny")
			if(!connected_business) return
			if(!user_id_card) return
			if(!connected_business.is_stock_holder(user_id_card.registered_name))
				to_chat(usr, "Access denied.")
				return
			var/datum/proposal/proposal = locate(href_list["target"])
			if(!proposal)
				message_admins("couldnt find proposal")
				return
			if(user_id_card.registered_name in proposal.supporters)
				proposal.add_denial(user_id_card.registered_name, connected_business.get_stocks(user_id_card.registered_name))
			else
				proposal.remove_denial(user_id_card.registered_name)
		if("proposal_cancel")
			if(!connected_business) return
			if(!user_id_card) return
			if(!connected_business.is_stock_holder(user_id_card.registered_name))
				to_chat(usr, "Access denied.")
				return
			var/datum/proposal/proposal = locate(href_list["target"])
			if(!proposal)
				message_admins("couldnt find proposal")
				return
			if(user_id_card.registered_name == proposal.started_by)
				connected_business.proposal_cancelled(proposal)

		if("ceo_change")
			if(!connected_business) return
			if(!user_id_card) return
			if(!connected_business.is_stock_holder(user_id_card.registered_name))
				to_chat(usr, "Access denied.")
				return
			if(connected_business.has_proposal(user_id_card.registered_name))
				to_chat(usr, "You can only have one active proposal at a time.")
				return
			var/choice = input(usr,"This will create a proposal to appoint a new CEO. Are you sure?") in list("Confirm", "Cancel")
			if(choice == "Confirm")
				var/select_name = sanitizeName(input(usr,"Enter full name of the new CEO.","New CEO", "") as null|text, MAX_NAME_LEN, 1, 0)
				if(select_name)
					if(select_name == connected_business.ceo_name)
						to_chat(usr, "[select_name] is the current CEO.")
						return
					var/found = 0
					for(var/datum/computer_file/report/crew_record/R in GLOB.all_crew_records)
						if(R.get_name() == select_name)
							found = 1
							break
					if(!found)
						var/datum/computer_file/report/crew_record/L = Retrieve_Record(select_name)
						if(L) found = 1
					if(!found)
						to_chat(usr, "No record found for [select_name]. Verify Identity.")
						return

					var/datum/proposal/proposal = new()
					proposal.name = "Proposal to change the CEO to [select_name]"
					proposal.started_by = user_id_card.registered_name
					proposal.connected_uid = connected_business.name
					proposal.connected_type = 2
					proposal.func = 1
					proposal.change = select_name
					connected_business.proposals |= proposal
					proposal.add_support(user_id_card.registered_name, connected_business.get_stocks(user_id_card.registered_name))

		if("ceo_fire")
			if(!connected_business) return
			if(!user_id_card) return
			if(!connected_business.is_stock_holder(user_id_card.registered_name))
				to_chat(usr, "Access denied.")
				return
			if(connected_business.has_proposal(user_id_card.registered_name))
				to_chat(usr, "You can only have one active proposal at a time.")
				return
			if(!connected_business.ceo_name || connected_business.ceo_name == "") return 0
			var/choice = input(usr,"This will create a proposal to fire the current CEO, are you sure?") in list("Confirm", "Cancel")
			if(choice == "Confirm")
				var/datum/proposal/proposal = new()
				proposal.name = "Proposal to fire the CEO, [connected_business.ceo_name]"
				proposal.started_by = user_id_card.registered_name
				proposal.connected_uid = connected_business.name
				proposal.connected_type = 2
				proposal.func = 2
				connected_business.proposals |= proposal
				proposal.add_support(user_id_card.registered_name, connected_business.get_stocks(user_id_card.registered_name))

		if("ceo_title")
			if(!connected_business) return
			if(!user_id_card) return
			if(!connected_business.is_stock_holder(user_id_card.registered_name))
				to_chat(usr, "Access denied.")
				return
			if(connected_business.has_proposal(user_id_card.registered_name))
				to_chat(usr, "You can only have one active proposal at a time.")
				return

			var/select_title = sanitizeName(input(usr,"Enter CEO Job Title","Edit CEO Job title", connected_business.ceo_title) as null|text, MAX_NAME_LEN, 1, 0)
			if(select_title)
				var/datum/proposal/proposal = new()
				proposal.name = "Proposal to change title of CEO to [select_title]"
				proposal.started_by = user_id_card.registered_name
				proposal.connected_uid = connected_business.name
				proposal.connected_type = 2
				proposal.func = 3
				proposal.change = select_title
				connected_business.proposals |= proposal
				proposal.add_support(user_id_card.registered_name, connected_business.get_stocks(user_id_card.registered_name))

		if("ceo_payrate")
			if(!connected_business) return
			if(!user_id_card) return
			if(!connected_business.is_stock_holder(user_id_card.registered_name))
				to_chat(usr, "Access denied.")
				return
			if(connected_business.has_proposal(user_id_card.registered_name))
				to_chat(usr, "You can only have one active proposal at a time.")
				return

			var/amount = round(input("Edit CEO ([connected_business.ceo_name]) Hourly Pay", "Edit ceo pay", connected_business.ceo_payrate) as null|num)
			if(!amount)
				amount = 0
			var/choice = input(usr,"This will create a proposal to change the CEO hourly pay to [amount]") in list("Confirm", "Cancel")
			if(choice == "Confirm")
				var/datum/proposal/proposal = new()
				proposal.name = "Proposal to change payrate of CEO to [amount]"
				proposal.started_by = user_id_card.registered_name
				proposal.connected_uid = connected_business.name
				proposal.connected_type = 2
				proposal.func = 4
				proposal.change = amount
				connected_business.proposals |= proposal
				proposal.add_support(user_id_card.registered_name, connected_business.get_stocks(user_id_card.registered_name))


		if("ceo_dividend")
			if(!connected_business) return
			if(!user_id_card) return
			if(!connected_business.is_stock_holder(user_id_card.registered_name))
				to_chat(usr, "Access denied.")
				return
			if(connected_business.has_proposal(user_id_card.registered_name))
				to_chat(usr, "You can only have one active proposal at a time.")
				return

			var/amount = round(input("Edit [connected_business.ceo_name] Dividend", "Edit CEO Dividend", connected_business.ceo_dividend) as null|num)
			if(!amount)
				amount = 0
			if(amount > 20)
				to_chat(user, "20% is the maximum")
				return
			var/choice = input(usr,"This will create a proposal to change the CEO dividend [amount]% of hourly profit") in list("Confirm", "Cancel")
			if(choice == "Confirm")
				var/datum/proposal/proposal = new()
				proposal.name = "Proposal to change dividend of CEO to [amount]%"
				proposal.started_by = user_id_card.registered_name
				proposal.connected_uid = connected_business.name
				proposal.connected_type = 2
				proposal.func = 5
				proposal.change = amount
				connected_business.proposals |= proposal
				proposal.add_support(user_id_card.registered_name, connected_business.get_stocks(user_id_card.registered_name))

		if("holders_dividend")
			if(!connected_business) return
			if(!user_id_card) return
			if(!connected_business.is_stock_holder(user_id_card.registered_name))
				to_chat(usr, "Access denied.")
				return
			if(connected_business.has_proposal(user_id_card.registered_name))
				to_chat(usr, "You can only have one active proposal at a time.")
				return
			var/amount = round(input("Edit Stockholders Dividend", "Edit Holder Dividend", connected_business.stock_holders_dividend) as null|num)
			if(!amount)
				amount = 0
			if(amount > 10)
				to_chat(user, "10% is the maximum")
				return
			var/choice = input(usr,"This will create a proposal to change the stock holders dividend  by [amount]% of hourly profit per 10 stocks.") in list("Confirm", "Cancel")
			if(choice == "Confirm")
				var/datum/proposal/proposal = new()
				proposal.name = "Proposal to change dividend of stock holders to [amount]% per 10 stocks"
				proposal.started_by = user_id_card.registered_name
				proposal.connected_uid = connected_business.name
				proposal.connected_type = 2
				proposal.func = 6
				proposal.change = amount
				connected_business.proposals |= proposal
				proposal.add_support(user_id_card.registered_name, connected_business.get_stocks(user_id_card.registered_name))

		if("holders_sale")
			if(!connected_business) return
			if(!user_id_card) return
			if(!connected_business.is_stock_holder(user_id_card.registered_name))
				to_chat(usr, "Access denied.")
				return
			var/holding = connected_business.get_stocks(user_id_card.registered_name)
			var/amount = round(input("How many stocks do you want to sell?", "Sell stocks", holding) as null|num)
			if(!amount)
				to_chat(user, "Sale cancelled.")
				return
			if(amount > holding)
				to_chat(user, "You dont have that many stocks.")
				return
			var/cost = round(input("How much ethericoin do you want for the [amount] stocks?", "Price", 25*amount) as null|num)
			if(!cost)
				cost = 0
			var/choice = input(usr,"This will create a stock contract for [amount] stocks at [cost] ethericoin.") in list("Confirm", "Cancel")
			if(choice == "Confirm")
				var/obj/item/weapon/paper/contract/contract = new()
				contract.required_cash = cost
				contract.linked = connected_business
				contract.created_by = user_id_card.registered_name
				contract.purpose = "Stock contract for [amount] stocks at [cost]$$"
				contract.ownership = amount
				contract.name = "[connected_business.name] stock contract"
				contract.pay_to = user_id_card.registered_name
				contract.update_icon()
				var/t = ""
				t += "<font face='Verdana' color=blue><table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'><center></td><tr><td><H1>Stock Purchase Contract</td>"
				t += "<tr><td><br><b>Stock:</b>[connected_business.name] (business)<br>"
				t += "<b>Stock Owner:</b>[contract.created_by]<br>"
				t += "<b>Stock Amount:</b> [amount] stocks<br>"
				t += "<b>Cost:</b> [cost] $$ Ethericoins<br><br>"
				t += "<tr><td><h3>Status</H3>*Unsigned*<br></td></tr></table><br><table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>"
				t += "<td><font size='4'><b>Swipe ID to sign contract.</b></font></center></font>"
				contract.info = t
				contract.loc = get_turf(program.computer)
				playsound(get_turf(program.computer), pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 75, 1, -3)

		if("login")
			if(!user_id_card) return
			var/select_name =  sanitize(input(usr,"Enter the full name of the business.","Log in", "") as null|text)
			var/datum/small_business/viewing = get_business(select_name)
			if(!viewing)
				to_chat(usr, "Business not found,")
			if(viewing && viewing.is_allowed(user_id_card.registered_name))
				business_name = select_name
			else
				to_chat(usr, "Access denied.")
		if("business_select")
			if(!user_id_card) return
			var/select_name = href_list["target"]
			var/datum/small_business/viewing = get_business(select_name)
			if(!viewing)
				to_chat(usr, "business not found,")
			if(viewing && viewing.is_allowed(user_id_card.registered_name))
				business_name = select_name
			else
				to_chat(usr, "Access denied.")
		if("business_create")
			submenu = 2
		if("business_cancel")
			var/choice = input(usr,"Warning! This will cancel all pending contracts and reset the form") in list("Confirm", "Cancel")
			if(choice == "Confirm")
				submenu = 1
				cancel_contracts()
				potential_name = ""
		if("business_name")
			var/choice = input(usr,"Warning! Changing the name of the business will reset any pending contracts!") in list("Confirm", "Cancel")
			if(choice == "Confirm")
				var/select_name =  sanitize(input(usr,"Enter the full name of the new business.","business name", "") as null|text)
				var/datum/small_business/viewing = get_business(select_name)
				if(viewing)
					to_chat(usr, "That business already exists!")
					return
				if(select_name && select_name != "")
					cancel_contracts()
					potential_name = select_name
		if("business_contract")
			if(!potential_name || potential_name == "")
				to_chat(usr, "A name for the business must be chosen first.")
				return
			var/to_be = 100 - get_distributed()
			var/amount = round(input("How many stocks are being distributed", "Investment", to_be) as null|num)
			if(!amount || amount < 0)
				amount = 0
			if(amount > to_be)
				to_chat(user, "Theirs not that many stocks left to be distributed.")
				return
			var/cost = round(input("How much ethericoin should be invested for the [amount] stocks?", "Price", 25*amount) as null|num)
			if(!cost || cost < 0)
				cost = 0
			var/choice = input(usr,"This will create an investment contract for [amount] stocks at [cost] ethericoin.") in list("Confirm", "Cancel")
			if(choice == "Confirm")
				var/obj/item/weapon/paper/contract/contract = new()
				contract.required_cash = cost
				contract.linked = src
				contract.purpose = "Investment contract for [amount] stocks at [cost]$$"
				contract.ownership = amount
				contract.name = "[potential_name] investment contract"
				var/t = ""
				t += "<font face='Verdana' color=blue><table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'><center></td><tr><td><H1>Investment Contract</td>"
				t += "<tr><td><br><b>Stock:</b>[potential_name] (business)<br>"
				t += "<b>Stock Amount:</b> [amount] stocks<br>"
				t += "<b>Cost:</b> [cost] $$ Ethericoins<br><br>"
				t += "<tr><td><h3>Status</H3>*Unsigned*<br></td></tr></table><br><table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>"
				t += "<td><font size='4'><b>Swipe ID to sign contract.</b></font></center></font>"
				contract.info = t
				contract.loc = get_turf(program.computer)
				contract.update_icon()
				pending_contracts |= contract
				playsound(get_turf(program.computer), pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 75, 1, -3)

		if("business_finalize")
			var/commitment = get_contributed()
			var/signed_stocks = get_distributed()
			if(commitment < 2500 || signed_stocks != 100)
				return 0
			commitment -= 2500
			if(!potential_name || potential_name == "")
				to_chat(usr, "A name for the business must be chosen first.")
				return
			for(var/obj/item/weapon/paper/contract/contract in signed_contracts)
				if(!contract.is_solvent())
					contract.cancel()
					SSnano.update_uis(src)
					return 0
			var/datum/small_business/new_business = new()
			new_business.name = potential_name
			if(commitment)
				new_business.central_account.money += commitment
			for(var/obj/item/weapon/paper/contract/contract in signed_contracts)
				contract.finalize()
				if(new_business.stock_holders[contract.signed_by])
					new_business.stock_holders[contract.signed_by] = new_business.stock_holders[contract.signed_by]+contract.ownership
				else
					new_business.stock_holders[contract.signed_by] = contract.ownership
				signed_contracts -= contract
			if(!GLOB.all_business) GLOB.all_business = list()
			GLOB.all_business |= new_business
			business_name = potential_name
			potential_name = ""
			menu = 5
			cancel_contracts()

	SSnano.update_uis(src)
	return 1
