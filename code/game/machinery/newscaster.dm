//##############################################
//################### NEWSCASTERS BE HERE! ####
//###-Agouri###################################

/datum/feed_message
	var/author =""
	var/body =""
	var/message_type ="Story"
	var/datum/feed_channel/parent_channel
	var/is_admin_message = 0
	var/icon/img = null
	var/icon/caption = ""
	var/time_stamp = ""
	var/backup_body = ""
	var/backup_author = ""
	var/icon/backup_img = null
	var/icon/backup_caption = ""

/datum/feed_channel
	var/channel_name=""
	var/list/datum/feed_message/messages = list()
	var/locked=0
	var/author=""
	var/backup_author=""
	var/views=0
	var/censored=0
	var/is_admin_channel=0
	var/updated = 0
	var/announcement = ""

/datum/feed_message/proc/clear()
	src.author = ""
	src.body = ""
	src.caption = ""
	src.img = null
	src.time_stamp = ""
	src.backup_body = ""
	src.backup_author = ""
	src.backup_caption = ""
	src.backup_img = null
	parent_channel.update()

/datum/feed_channel/proc/update()
	updated = world.time

/datum/feed_channel/proc/clear()
	src.channel_name = ""
	src.messages = list()
	src.locked = 0
	src.author = ""
	src.backup_author = ""
	src.censored = 0
	src.is_admin_channel = 0
	src.announcement = ""
	update()

/datum/feed_network
	var/list/datum/feed_channel/network_channels = list()
	var/datum/feed_message/wanted_issue

/datum/feed_network/New()
	CreateFeedChannel("Announcements", "SS13", 1, 1, "New Announcement Available")

/datum/feed_network/proc/CreateFeedChannel(var/channel_name, var/author, var/locked, var/adminChannel = 0, var/announcement_message)
	var/datum/feed_channel/newChannel = new /datum/feed_channel
	newChannel.channel_name = channel_name
	newChannel.author = author
	newChannel.locked = locked
	newChannel.is_admin_channel = adminChannel
	if(announcement_message)
		newChannel.announcement = announcement_message
	else
		newChannel.announcement = "Breaking news from [channel_name]!"
	network_channels += newChannel

/datum/feed_network/proc/SubmitArticle(var/msg, var/author, var/channel_name, var/obj/item/weapon/photo/photo, var/adminMessage = 0, var/message_type = "")
	var/datum/feed_message/newMsg = new /datum/feed_message
	newMsg.author = author
	newMsg.body = msg
	newMsg.time_stamp = "[stationtime2text()]"
	newMsg.is_admin_message = adminMessage
	if(message_type)
		newMsg.message_type = message_type
	if(photo)
		newMsg.img = photo.img
		newMsg.caption = photo.scribble
	for(var/datum/feed_channel/FC in network_channels)
		if(FC.channel_name == channel_name)
			insert_message_in_channel(FC, newMsg) //Adding message to the network's appropriate feed_channel
			break

/datum/feed_network/proc/insert_message_in_channel(var/datum/feed_channel/FC, var/datum/feed_message/newMsg)
	FC.messages += newMsg
	if(newMsg.img)
		register_asset("newscaster_photo_[sanitize(FC.channel_name)]_[FC.messages.len].png", newMsg.img)
	newMsg.parent_channel = FC
	FC.update()
	alert_readers(FC.announcement)

/datum/feed_network/proc/alert_readers(var/annoncement)
	for(var/obj/machinery/newscaster/NEWSCASTER in allCasters)
		NEWSCASTER.newsAlert(annoncement)
		NEWSCASTER.update_icon()

	var/list/receiving_pdas = new
	for (var/obj/item/device/pda/P in PDAs)
		if (!P.owner)
			continue
		if (P.toff)
			continue
		receiving_pdas += P

	spawn(0)	// get_receptions sleeps further down the line, spawn of elsewhere
		var/datum/receptions/receptions = get_receptions(null, receiving_pdas) // datums are not atoms, thus we have to assume the newscast network always has reception

		for(var/obj/item/device/pda/PDA in receiving_pdas)
			if(!(receptions.receiver_reception[PDA] & TELECOMMS_RECEPTION_RECEIVER))
				continue

			PDA.new_news(annoncement)

var/datum/feed_network/news_network = new /datum/feed_network     //The global news-network, which is coincidentally a global list.

var/list/obj/machinery/newscaster/allCasters = list() //Global list that will contain reference to all newscasters in existence.


/obj/machinery/newscaster
	name = "newscaster"
	desc = "A standard newsfeed handler. All the news you absolutely have no use for, in one place!"
	icon = 'icons/obj/terminals.dmi'
	icon_state = "newscaster_normal"
	var/hitstaken = 0      //Death at 3 hits from an item with force>=15
	light_range = 0
	anchored = 1
	layer = ABOVE_WINDOW_LAYER
	var/alert = 0
	
	var/datum/NewsStory/loaded_article
	var/datum/NewsFeed/loaded_feed
	var/datum/NewsIssue/loaded_issue
	var/unit_no = 0

/obj/machinery/newscaster/New(loc, dir, atom/frame, var/ndir)
	..(loc)

	if(istype(frame))
		frame.transfer_fingerprints_to(src)
	..()

	if(ndir)
		set_dir(ndir)
		pixel_x = (src.dir & 3)? 0 : (src.dir == 4 ? 30 : -30)
		pixel_y = (src.dir & 3)? (src.dir ==1 ? 30 : -30) : 0
	allCasters += src
	for(var/obj/machinery/newscaster/NEWSCASTER in allCasters) // Let's give it an appropriate unit number
		src.unit_no++
	src.update_icon() //for any custom ones on the map...
	..()                                //I just realised the newscasters weren't in the global machines list. The superconstructor call will tend to that

/obj/machinery/newscaster/Destroy()
	allCasters -= src
	..()
	
	
/obj/machinery/newscaster/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = list()
	var/obj/item/weapon/card/id/user_id_card = user.GetIdCard()
	if(loaded_article)
		data["name"] = "[loaded_article.name] [loaded_article.publish_date]"
		data["author"] = loaded_article.author
		data["filedata"] = imgcode2html(pencode2html(loaded_article.body), loaded_article.image1, loaded_article.image2, user)
		data["menu"] = 2
		if(user_id_card)
			if(loaded_article.allowed(user_id_card.registered_name))
				data["allowed"] = 1
		data["cost"] = loaded_article.parent.parent.per_article
	else if(loaded_issue)
		var/ind = 0
		var/list/formatted_articles[0]
		data["name"] = "[loaded_issue.name] [loaded_issue.publish_date]"
		for(var/datum/NewsStory/story in loaded_issue.stories)
			ind++
			if(ind > 9) break
			formatted_articles[++formatted_articles.len] = list("name" = story.name, "ref" = "\ref[story]")
		data["articles"] = formatted_articles
		data["menu"] = 3
		data["cost"] = loaded_article.parent.parent.per_issue
	else if(loaded_feed)
		var/ind = 0
		var/list/formatted_issues[0]
		var/list/formatted_articles[0]
		data["name"] = loaded_feed.name
		for(var/datum/NewsIssue/issue in loaded_feed.all_issues)
			ind++
			if(ind > 9) break
			formatted_issues[++formatted_issues.len] = list("name" = issue.name, "ref" = "\ref[issue]")
		data["issues"] = formatted_issues
		for(var/datum/NewsStory/story in loaded_feed.current_issue.stories)
			formatted_articles[++formatted_articles.len] = list("name" = story.name, "ref" = "\ref[story]")
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
			formatted_articles[++formatted_articles.len] = list("name" = story.name, "ref" = "\ref[story]")
		data["articles"] = formatted_articles
		data["menu"] = 1
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "news_browser.tmpl", "News Browser", 575, 750, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
	
	
	
	
	
	

/obj/machinery/newscaster/update_icon()
	if(inoperable())
		icon_state = "newscaster_off"
		if(stat & BROKEN) //If the thing is smashed, add crack overlay on top of the unpowered sprite.
			overlays.Cut()
			overlays += image(src.icon, "crack3")
		return

	src.overlays.Cut() //reset overlays

	if(news_network.wanted_issue) //wanted icon state, there can be no overlays on it as it's a priority message
		icon_state = "newscaster_wanted"
		return

	if(alert) //new message alert overlay
		src.overlays += "newscaster_alert"

	if(hitstaken > 0) //Cosmetic damage overlay
		src.overlays += image(src.icon, "crack[hitstaken]")

	icon_state = "newscaster_normal"
	return

/obj/machinery/newscaster/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/newscaster/attack_hand(mob/user as mob)            //########### THE MAIN BEEF IS HERE! And in the proc below this...############

	if(inoperable())
		return

	if(!user.IsAdvancedToolUser())
		return 0

	if(istype(user, /mob/living/carbon/human) || istype(user,/mob/living/silicon) )
		ui_interact(user)

/obj/machinery/newscaster/proc/payArticle(var/obj/item/weapon/card/id/id, var/mob/user)
	if(!loaded_article) return 0
	var/transaction_amount = loaded_article.parent.parent.per_article
	var/datum/money_account/account = get_account(id.associated_account_number)
	if(!account) return
	if(account.security_level != 0) //If card requires pin authentication (ie seclevel 1 or 2)
		var/attempt_pin = input("Enter pin code", "Vendor transaction") as num
		if(account.remote_access_pin != attempt_pin)
			to_chat(user, "Unable to access account: incorrect credentials.")
			return

	if(transaction_amount > account.money)
		to_chat(user, "Unable to complete transaction: insufficient funds.")
		return
	else
		var/datum/transaction/T = new("Article Access (via news browser)", "Access to [loaded_article.name] ([loaded_article.parent.parent.name])", -transaction_amount, "News Browser")
		account.do_transaction(T)
		//transfer the money
		var/datum/transaction/Te = new("[account.owner_name]", "Access to [loaded_article.name] ([loaded_article.parent.parent.name])", transaction_amount, "News Browser")
		loaded_article.parent.parent.parent.central_account.do_transaction(Te)
		
		loaded_article.purchased |= id.registered_name
		return 1
		
/obj/machinery/newscaster/proc/payIssue(var/obj/item/weapon/card/id/id, var/mob/user)
	if(!loaded_issue) return 0
	var/transaction_amount = loaded_issue.parent.per_issue
	var/datum/money_account/account = get_account(id.associated_account_number)
	if(!account) return
	if(account.security_level != 0) //If card requires pin authentication (ie seclevel 1 or 2)
		var/attempt_pin = input("Enter pin code", "Vendor transaction") as num
		if(account.remote_access_pin != attempt_pin)
			to_chat(user, "Unable to access account: incorrect credentials.")
			return

	if(transaction_amount > account.money)
		to_chat(user, "Unable to complete transaction: insufficient funds.")
		return
	else
		var/datum/transaction/T = new("Issue Print (via news browser)", "Printed Issue [loaded_issue.name] ([loaded_issue.parent.name])", -transaction_amount, "News Browser")
		account.do_transaction(T)
		//transfer the money
		var/datum/transaction/Te = new("[account.owner_name]", "Printed Issue [loaded_issue.name] ([loaded_issue.parent.name])", transaction_amount, "News Browser")
		loaded_issue.parent.parent.central_account.do_transaction(Te)
		var/obj/item/weapon/newspaper/newspaper = new /obj/item/weapon/newspaper(loc)
		newspaper.name = loaded_issue.name
		newspaper.desc = "An newspaper issue of [loaded_issue.parent.name]"
		newspaper.linked_issue = loaded_issue
		newspaper.feed_id = loaded_issue.parent.parent.name
		newspaper.issue_id = loaded_issue.uid
		playsound(loc, pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 75, 1, -3)
		
		return 1
		
		
/obj/machinery/newscaster/Topic(href, href_list)
	if(..())
		return 1
	. = 1
	switch(href_list["action"])
		if("selectArticle")
			loaded_article = locate(href_list["target"])
			if(loaded_article)
				loaded_feed = loaded_article.parent.parent
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
		SSnano.update_uis(src)




/obj/machinery/newscaster/attackby(obj/item/I as obj, mob/user as mob)
	if (stat & BROKEN)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 100, 1)
		for (var/mob/O in hearers(5, src.loc))
			O.show_message("<EM>[user.name]</EM> further abuses the shattered [src.name].")
	else
		if(istype(I, /obj/item/weapon) )
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			var/obj/item/weapon/W = I
			if(W.force <15)
				for (var/mob/O in hearers(5, src.loc))
					O.show_message("[user.name] hits the [src.name] with the [W.name] with no visible effect." )
					playsound(src.loc, 'sound/effects/Glasshit.ogg', 100, 1)
			else
				src.hitstaken++
				if(hitstaken==3)
					for (var/mob/O in hearers(5, src.loc))
						O.show_message("[user.name] smashes the [src.name]!" )
					stat |= BROKEN
					playsound(src.loc, 'sound/effects/Glassbr3.ogg', 100, 1)
				else
					for (var/mob/O in hearers(5, src.loc))
						O.show_message("[user.name] forcefully slams the [src.name] with the [I.name]!" )
					playsound(src.loc, 'sound/effects/Glasshit.ogg', 100, 1)
		else
			to_chat(user, "<span class='notice'>This does nothing.</span>")
	update_icon()

/obj/machinery/newscaster/attack_ai(mob/user as mob)
	return src.attack_hand(user) //or maybe it'll have some special functions? No idea.

//########################################################################################################################
//###################################### NEWSPAPER! ######################################################################
//########################################################################################################################

/obj/item/weapon/newspaper
	name = "newspaper"
	desc = "An newspaper issue of BLANK."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "newspaper"
	w_class = ITEM_SIZE_SMALL	//Let's make it fit in trashbags!
	attack_verb = list("bapped")
	var/curr_page = 0
	var/datum/NewsIssue/linked_issue
	var/feed_id
	var/issue_id

/obj/item/weapon/newspaper/after_load()
	var/datum/small_business/business = get_business(feed_id)
	if(business)
		for(var/datum/NewsIssue/issue in business.feed.all_issues)
			if(issue.uid == issue_id)
				linked_issue = issue
				break
	..()
	
/obj/item/weapon/newspaper/OnTopic(user, href_list)
	. = 1
	switch(href_list["action"])
		if("next")
			curr_page = min(linked_issue.stories.len, curr_page++)
		if("previous")
			curr_page = max(0, curr_page--)
	if(.)
		SSnano.update_uis(src)

	
/obj/item/weapon/newspaper/ui_interact(var/mob/user, var/ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/list/data = list()
	if(linked_issue)
		data["name"] = "[linked_issue.name] [linked_issue.publish_date]"
		if(curr_page > linked_issue.stories.len)
			curr_page = linked_issue.stories.len
		if(curr_page == linked_issue.stories.len)
			data["last_page"] = 1
		if(curr_page == 1)
			data["first_page"] = 1
		var/datum/NewsStory/story = linked_issue.stories[curr_page]
		data["headline"] = story.name
		data["filedata"] = story.body
		data["author"] = story.author
	else
		data["invalid"] = 1
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "newspaper.tmpl", "newspaper", 400, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

	
/obj/item/weapon/newspaper/attack_self(mob/user as mob)
	ui_interact(user)


/obj/machinery/newscaster/proc/newsAlert(var/news_call)   //This isn't Agouri's work, for it is ugly and vile.
	var/turf/T = get_turf(src)                      //Who the fuck uses spawn(600) anyway, jesus christ
	alert = 1
	if(news_call)
		for(var/mob/O in hearers(world.view-1, T))
			O.show_message("<span class='newscaster'><EM>[src.name]</EM> beeps, \"[news_call]\"</span>",2)
		src.update_icon()
		playsound(src.loc, 'sound/machines/twobeep.ogg', 75, 1)
	else
		for(var/mob/O in hearers(world.view-1, T))
			O.show_message("<span class='newscaster'><EM>[src.name]</EM> beeps, \"Attention! Wanted issue distributed!\"</span>",2)
		playsound(src.loc, 'sound/machines/warning-buzzer.ogg', 75, 1)
	spawn(300)
		alert = 0
		update_icon()
	return

/obj/item/frame/newscaster/try_build(turf/on_wall)
	if (get_dist(on_wall,usr)>1)
		return
	var/ndir = get_dir(usr,on_wall)
	if (!(ndir in GLOB.cardinal))
		return
	var/turf/loc = get_turf(usr)

	new /obj/machinery/newscaster(loc, 1, src, ndir)
	qdel(src)
