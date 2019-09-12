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
	mass = 0.100
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
	//var/turf/T = get_turf(src)                      //Who the fuck uses spawn(600) anyway, jesus christ
	alert = 1
	if(news_call)
		audible_message("<span class='newscaster'><EM>[src.name]</EM> beeps, \"[news_call]\"</span>", "", hearing_distance = 5)
		// for(var/mob/O in hearers(world.view-1, T))
		// 	O.show_message("<span class='newscaster'><EM>[src.name]</EM> beeps, \"[news_call]\"</span>",2)
		src.update_icon()
		playsound(src.loc, 'sound/machines/twobeep.ogg', 75, 1)
	else
		audible_message("<span class='newscaster'><EM>[src.name]</EM> beeps, \"Attention! Wanted issue distributed!\"</span>", "", hearing_distance = 5)
		// for(var/mob/O in hearers(world.view-1, T))
		// 	O.show_message("<span class='newscaster'><EM>[src.name]</EM> beeps, \"Attention! Wanted issue distributed!\"</span>",2)
		playsound(src.loc, 'sound/machines/warning-buzzer.ogg', 75, 1)
	spawn(300)
		alert = 0
		update_icon()
	return

