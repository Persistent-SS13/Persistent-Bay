/datum/computer_file/program/newsbrowser
	filename = "newsbrowser"
	filedesc = "NTNet/ExoNet News Browser"
	extended_desc = "This program may be used to view and download news articles from the network."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	program_menu_icon = "contact"
	size = 2
	requires_ntnet = TRUE
	available_on_ntnet = TRUE
	usage_flags = PROGRAM_ALL
	nanomodule_path = /datum/nano_module/program/computer_newsbrowser/
	var/datum/NewsStory/loaded_article
	var/datum/NewsFeed/loaded_feed
	var/datum/NewsIssue/loaded_issue

/datum/computer_file/program/newsbrowser/process_tick()
	SSnano.update_uis(NM)

/datum/computer_file/program/newsbrowser/kill_program()
	..()
	requires_ntnet = 1
	loaded_article = null

/datum/computer_file/program/newsbrowser/proc/payArticle(var/obj/item/weapon/card/id/id, var/mob/user)
	if(!loaded_article) return 0
	var/transaction_amount = loaded_article.parent.parent.per_article
	var/datum/money_account/account = get_account(user.real_name)
	if(!account) return
	if(transaction_amount > account.money)
		to_chat(user, "Unable to complete transaction: insufficient funds.")
		return
	else
		var/datum/transaction/T = new("Article Access (via news browser)", "Access to [loaded_article.name] ([loaded_article.parent.parent.name])", -transaction_amount, "News Browser")
		account.do_transaction(T)
		//transfer the money
		var/datum/transaction/Te = new("[account.owner_name]", "Access to [loaded_article.name] ([loaded_article.parent.parent.name])", transaction_amount, "News Browser")
		loaded_article.parent.parent.parent.central_account.do_transaction(Te)

		loaded_article.purchased |= user.real_name
		return 1
		
/datum/computer_file/program/newsbrowser/proc/payIssue(var/obj/item/weapon/card/id/id, var/mob/user)
	if(!loaded_issue) return 0
	var/transaction_amount = loaded_issue.parent.per_issue
	var/datum/money_account/account = get_account(user.real_name)
	if(!account) return
	if(transaction_amount > account.money)
		to_chat(user, "Unable to complete transaction: insufficient funds.")
		return
	else
		var/datum/transaction/T = new("Issue Print (via news browser)", "Printed Issue [loaded_issue.name] ([loaded_issue.parent.name])", -transaction_amount, "News Browser")
		account.do_transaction(T)
		//transfer the money
		var/datum/transaction/Te = new("[account.owner_name]", "Printed Issue [loaded_issue.name] ([loaded_issue.parent.name])", transaction_amount, "News Browser")
		loaded_issue.parent.parent.central_account.do_transaction(Te)
		var/obj/item/weapon/newspaper/newspaper = new /obj/item/weapon/newspaper(computer.loc)
		newspaper.name = loaded_issue.name
		newspaper.desc = "An newspaper issue of [loaded_issue.parent.name]"
		newspaper.linked_issue = loaded_issue
		newspaper.feed_id = loaded_issue.parent.parent.name
		newspaper.issue_id = loaded_issue.uid
		playsound(computer.loc, pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 75, 1, -3)

		return 1

		
		
/datum/computer_file/program/newsbrowser/Topic(href, href_list)
	if(..())
		return 1
	. = 1
	switch(href_list["action"])
		if("selectArticle")
			loaded_article = locate(href_list["target"])
			if(loaded_article)
				loaded_feed = loaded_article.parent.parent
			loaded_article.view_story(usr)
		if("selectIssue")
			loaded_issue = locate(href_list["target"])
		if("selectFeed")
			loaded_feed = locate(href_list["target"])
		if("deselectArticle")
			loaded_article = null
		if("deselectIssue")
			loaded_issue = null
		if("deselectFeed")
			loaded_feed = null
		if("purchaseArticle")
			var/obj/item/weapon/card/id/user_id_card = usr.GetIdCard()
			if(user_id_card)
				payArticle(user_id_card, usr)
		if("purchaseIssue")
			var/obj/item/weapon/card/id/user_id_card = usr.GetIdCard()
			if(user_id_card)
				payIssue(user_id_card, usr)


	if(.)
		SSnano.update_uis(NM)


/datum/nano_module/program/computer_newsbrowser
	name = "NTNet/ExoNet News Browser"

/datum/nano_module/program/computer_newsbrowser/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/datum/world_faction/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	if(!connected_faction) return
	var/datum/computer_file/program/newsbrowser/PRG
	var/list/data = list()
	var/obj/item/weapon/card/id/user_id_card = user.GetIdCard()
	if(program)
		data = program.get_header_data()
		PRG = program
	else
		return
	if(PRG.loaded_article)
		data["name"] = "[PRG.loaded_article.name] [PRG.loaded_article.publish_date]"
		data["author"] = PRG.loaded_article.author
		data["filedata"] = imgcode2html(pencode2html(PRG.loaded_article.body), PRG.loaded_article.image1, PRG.loaded_article.image2, user)
		data["menu"] = 2
		if(user_id_card)
			data["allowed"] = PRG.loaded_article.allowed(user_id_card.registered_name)
		data["cost"] = PRG.loaded_article.parent.parent.per_article
	else if(PRG.loaded_issue)
		var/ind = 0
		var/list/formatted_articles[0]
		data["name"] = "[PRG.loaded_issue.name] [PRG.loaded_issue.publish_date]"
		for(var/datum/NewsStory/story in PRG.loaded_issue.stories)
			ind++
			if(ind > 9) break
			formatted_articles[++formatted_articles.len] = list("name" = story.name, "ref" = "\ref[story]")
		data["articles"] = formatted_articles
		data["menu"] = 3
		data["cost"] = PRG.loaded_article.parent.parent.per_issue
	else if(PRG.loaded_feed)
		var/ind = 0
		var/list/formatted_issues[0]
		var/list/formatted_articles[0]
		data["name"] = PRG.loaded_feed.name
		for(var/datum/NewsIssue/issue in PRG.loaded_feed.all_issues)
			ind++
			if(ind > 9) break
			formatted_issues[++formatted_issues.len] = list("name" = issue.name, "ref" = "\ref[issue]")
		data["issues"] = formatted_issues
		for(var/datum/NewsStory/story in PRG.loaded_feed.current_issue.stories)
			formatted_articles[++formatted_articles.len] = list("name" = "[story.name] [story.publish_date]", "ref" = "\ref[story]")
		data["articles"] = formatted_articles
		data["menu"] = 4
	else
		var/ind = 0
		var/list/formatted_feeds[0]
		for(var/datum/NewsFeed/feed in all_feeds.L)
			if(!feed.visible) continue
			ind++
			if(ind > 9) break
			formatted_feeds[++formatted_feeds.len] = list("name" = feed.name, "ref" = "\ref[feed]")
		data["feeds"] = formatted_feeds
		ind = 0
		var/list/formatted_articles[0]
		for(var/datum/NewsStory/story in reverselist(GLOB.recent_articles.Copy()))
			if(!story.parent.parent.visible) continue
			ind++
			if(ind > 9) break
			formatted_articles[++formatted_articles.len] = list("name" = "[story.name] [story.publish_date]", "ref" = "\ref[story]")
		data["articles"] = formatted_articles
		data["menu"] = 1
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "news_browser.tmpl", "News Browser", 575, 750, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

