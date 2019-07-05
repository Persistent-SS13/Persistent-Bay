/datum/computer_file/program/news_control
	filename = "newscontrol"
	filedesc = "News Publishing"
	nanomodule_path = /datum/nano_module/program/news_control
	program_icon_state = "comm"
	program_menu_icon = "note"
	extended_desc = "Used to publish news articles and issues that can be printed as newspapers."
	requires_ntnet = TRUE
	size = 8
	required_access = core_access_security_programs
	business = 1
	required_module = /datum/business_module/media
	category = PROG_OFFICE
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP | PROGRAM_TELESCREEN
/datum/nano_module/program/news_control
	name = "News Publishing"
	var/menu = 1

	var/image/insert1
	var/image/insert2
	var/insert1_name
	var/insert2_name

	var/openfile
	var/filedata
	var/headline
	var/error
	var/is_edited

	var/article_price = 0
	var/article_announce = 0
	
	

/datum/nano_module/program/news_control/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/datum/world_faction/business/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
		
	data["connected_faction"] = connected_faction.name
	data["src"] = "\ref[src]"
	data["feed_invis"] = !connected_faction.feed.visible
	data["newsfeed_name"] = connected_faction.feed.name
	data["article_price"] = connected_faction.feed.per_article
	data["paper_price"] = connected_faction.feed.per_issue
	data["article_announcement"] = connected_faction.feed.announcement

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
	data["issue_name"] = connected_faction.feed.current_issue.name
	var/list/formatted_articles[0]
	for(var/datum/NewsStory/story in connected_faction.feed.current_issue.stories)
		formatted_articles[++formatted_articles.len] = list("name" = story.name)
	data["articles"] = formatted_articles
	data["filedata"] = imgcode2html(pencode2html(filedata), insert1, insert2, user)
	data["price"] = article_price
	data["announce"] = article_announce


	data["menu"] = menu


	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "news_control.tmpl", name, 600, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()


/datum/nano_module/program/news_control/proc/get_file(var/filename)
	var/obj/item/weapon/computer_hardware/hard_drive/HDD = program.computer.hard_drive
	if(!HDD)
		return
	var/datum/computer_file/data/F = HDD.find_file_by_name(filename)
	if(!istype(F))
		return
	return F

/datum/nano_module/program/news_control/proc/open_file(var/filename)
	var/datum/computer_file/data/F = get_file(filename)
	if(F)
		filedata = F.stored_data
		return 1

/datum/nano_module/program/news_control/proc/save_file(var/filename)
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

/datum/nano_module/program/news_control/proc/create_file(var/newname, var/data = "")
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


/datum/nano_module/program/news_control/Topic(href, href_list)
	if(..())
		return 1

	var/mob/user = usr
	var/obj/item/weapon/card/id/user_id_card = user.GetIdCard()
	var/datum/world_faction/business/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	if(!user_id_card) return
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
		if(!connected_faction.feed.visible)
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
			story.cost = article_price
			story.announce = article_announce
			connected_faction.feed.publish_story(story)
			insert1 = null
			insert1_name = null
			insert2 = null
			insert2_name = null
			headline = ""
			filedata = ""
			connected_faction.publish_article_objectives()
			
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
		if("change_menu")
			menu = text2num(href_list["target"])
		if("announce_yes")
			article_announce = 1
		if("announce_no")
			article_announce = 0
		if("feed_invis")
			connected_faction.feed.visible = 0
		if("feed_vis")
			connected_faction.feed.visible = 1

		if("feed_name")
			var/select_name = sanitizeName(input(usr,"Enter the new name of the newsfeed.","Newsfeed name", connected_faction.feed.name) as null|text, 40, 1, 0)
			if(select_name)
				connected_faction.feed.name = select_name
		if("change_price")
			var/amount = input("Enter price to charge for this article.", "Article price", article_price) as null|num
			if(!amount < 0)
				amount = 0
			article_price = amount
		if("feed_articleprice")
			var/amount = input("Enter price to charge per article.", "Article price", 0) as null|num
			if(!amount < 0)
				amount = 0
			connected_faction.feed.per_article = amount

		if("feed_paperprice")
			var/amount = input("Enter price to charge per issue.", "Issue price", 0) as null|num
			if(!amount < 0)
				amount = 0
			connected_faction.feed.per_issue = amount
		if("feed_announcement")
			var/select_name = sanitize(input(usr,"Enter the new announcement for article publishing.","Announcement", connected_faction.feed.announcement) as null|text, 40, 1, 0)
			if(select_name)
				connected_faction.feed.announcement = select_name
		if("feed_issuename")
			var/select_name = sanitizeName(input(usr,"Enter the new name of the current issue.","Issue name", connected_faction.feed.current_issue.name) as null|text, 40, 1, 0)
			if(select_name)
				connected_faction.feed.current_issue.name = select_name
		if("feed_issuepublish")
			if(!connected_faction.feed.current_issue.stories.len > 1)
				to_chat(usr, "There is not enough articles to publish this yet.")
				return
			if(!connected_faction.feed.visible)
				to_chat(usr, "The Newsfeed must be visible to publish.")
				return
			var/choice = input(usr,"This will publish [connected_faction.feed.current_issue.name], announcing it to subscribed newscasters and making it available for purchase. Are you sure?") in list("Confirm", "Cancel")
			if(choice == "Confirm")
				connected_faction.feed.current_issue.publish_date = "[stationdate2text()] [stationtime2text()]"
				connected_faction.feed.current_issue.publisher = user_id_card.registered_name
				connected_faction.feed.publish_issue()


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

	SSnano.update_uis(src)
	return 1
