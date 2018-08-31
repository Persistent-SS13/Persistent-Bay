#define TOPIC_UPDATE_PREVIEW 4
#define TOPIC_REFRESH_UPDATE_PREVIEW (TOPIC_REFRESH|TOPIC_UPDATE_PREVIEW)

// PERSISTENCE EDIT
// This greatly improves the way inputs work, plus its really hard to understand/use, it fits right in with baycode
proc
	get_input(wait = 100 as num,mob/U,Message,Title,Default,Type,list/List)
		var/prompts/input/Input = new
		var/Option
		if(wait) spawn(wait) if(!Option) del Input
		Option = Input.option(U,Message,Title,Default,Type,List)
		return Option
	get_alert(wait = 100 as num,mob/U,Message,Title,Button1,Button2,Button3)
		var/prompts/alert/Alert = new
		var/Option
		if(wait) spawn(wait) if(!Option) del Alert
		Option = Alert.option(U,Message,Title,Button1,Button2,Button3)
		return Option
prompts
	input
		proc/option(mob/U,Message="",Title="",Default="",Type,list/List)
			switch(Type)
				if("text") return input(U,Message,Title,Default) as text
				if("text|null") return input(U,Message,Title,Default) as text|null
				if("password") return input(U,Message,Title,Default) as password
				if("password|null") return input(U,Message,Title,Default) as password|null
				if("command_text") return input(U,Message,Title,Default) as command_text
				if("command_text|null") return input(U,Message,Title,Default) as command_text|null
				if("icon") return input(U,Message,Title,Default) as icon
				if("icon|null") return input(U,Message,Title,Default) as icon|null
				if("sound") return input(U,Message,Title,Default) as sound
				if("sound|null") return input(U,Message,Title,Default) as sound|null
				if("num") return input(U,Message,Title,Default) as num
				if("num|null") return input(U,Message,Title,Default) as num|null
				if("message") return input(U,Message,Title,Default) as message
				if("message|null") return input(U,Message,Title,Default) as message|null
				if("mob") return input(U,Message,Title,Default) as mob in List
				if("obj") return input(U,Message,Title,Default) as obj in List
				if("turf") return input(U,Message,Title,Default) as turf in List
				if("area") return input(U,Message,Title,Default) as area in List
				if("color") return input(U,Message , Title, Default) as color|null
				else return input(U,Message,Title,Default) in List
	alert
		proc/option(mob/U,Message,Title,Button1="Ok",Button2,Button3)
			return alert(U,Message,Title,Button1,Button2,Button3)
//to use them

// PERSISTENCE EDIT ENDS HERE

/datum/category_group/player_setup_category/welcome_preferences
	name = "Welcome"
	sort_order = 1
	category_item_type = /datum/category_item/player_setup_item/welcome

/datum/category_group/player_setup_category/general_preferences
	name = "Character"
	sort_order = 2
	category_item_type = /datum/category_item/player_setup_item/general

/datum/category_group/player_setup_category/skill_preferences
	name = "Skills"
	sort_order = 3
	category_item_type = /datum/category_item/player_setup_item/skills


/datum/category_group/player_setup_category/global_preferences
	name = "Game Settings"
	sort_order = 7
	category_item_type = /datum/category_item/player_setup_item/player_global



/****************************
* Category Collection Setup *
****************************/
/datum/category_collection/player_setup_collection
	category_group_type = /datum/category_group/player_setup_category
	var/datum/preferences/preferences
	var/datum/category_group/player_setup_category/selected_category = null

/datum/category_collection/player_setup_collection/New(var/datum/preferences/preferences)
	src.preferences = preferences
	..()
	selected_category = categories[1]

/datum/category_collection/player_setup_collection/Destroy()
	preferences = null
	selected_category = null
	return ..()

/datum/category_collection/player_setup_collection/proc/sanitize_setup()
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.sanitize_setup()

/datum/category_collection/player_setup_collection/proc/load_character(var/savefile/S)
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.load_character(S)

/datum/category_collection/player_setup_collection/proc/save_character(var/savefile/S)
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.save_character(S)

/datum/category_collection/player_setup_collection/proc/load_preferences(var/savefile/S)
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.load_preferences(S)
	from_file(S["bonus_slots"],preferences.bonus_slots)
	from_file(S["bonus_notes"],preferences.bonus_notes)
/datum/category_collection/player_setup_collection/proc/save_preferences(var/savefile/S)
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.save_preferences(S)
	to_file(S["bonus_slots"],preferences.bonus_slots)
	to_file(S["bonus_notes"],preferences.bonus_notes)
	
/datum/category_collection/player_setup_collection/proc/update_setup(var/savefile/preferences, var/savefile/character)
	for(var/datum/category_group/player_setup_category/PS in categories)
		. = PS.update_setup(preferences, character) || .

/datum/category_collection/player_setup_collection/proc/header()
	var/dat = ""
	for(var/datum/category_group/player_setup_category/PS in categories)
		if(PS == selected_category)
			dat += "<b>[PS.name] </b>"	// TODO: Check how to properly mark a href/button selected in a classic browser window
		else
			dat += "<a href='?src=\ref[src];category=\ref[PS]'>[PS.name]</a> "
	return dat

/datum/category_collection/player_setup_collection/proc/content(var/mob/user)
	if(selected_category)
		return selected_category.content(user)

/datum/category_collection/player_setup_collection/Topic(var/href,var/list/href_list)
	if(..())
		return 1
	var/mob/user = usr
	if(!user.client)
		return 1

	if(href_list["category"])
		var/category = locate(href_list["category"])
		if(category && category in categories)
			selected_category = category
		. = 1

	if(.)
		user.client.prefs.ShowChoices(user)

/**************************
* Category Category Setup *
**************************/
/datum/category_group/player_setup_category
	var/sort_order = 0

/datum/category_group/player_setup_category/dd_SortValue()
	return sort_order

/datum/category_group/player_setup_category/proc/sanitize_setup()
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.sanitize_preferences()
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.sanitize_character()

/datum/category_group/player_setup_category/proc/load_character(var/savefile/S)
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.load_character(S)

/datum/category_group/player_setup_category/proc/save_character(var/savefile/S)
	// Sanitize all data, then save it
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.sanitize_character()
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.save_character(S)

/datum/category_group/player_setup_category/proc/load_preferences(var/savefile/S)
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.load_preferences(S)

/datum/category_group/player_setup_category/proc/save_preferences(var/savefile/S)
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.sanitize_preferences()
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.save_preferences(S)

/datum/category_group/player_setup_category/proc/update_setup(var/savefile/preferences, var/savefile/character)
	for(var/datum/category_item/player_setup_item/PI in items)
		. = PI.update_setup(preferences, character) || .

/datum/category_group/player_setup_category/proc/content(var/mob/user)
	. = "<table style='width:100%'><tr style='vertical-align:top'><td style='width:50%'>"
	var/current = 0
	var/halfway = items.len / 2
	for(var/datum/category_item/player_setup_item/PI in items)
		if(halfway && current++ >= halfway)
			halfway = 0
			. += "</td><td></td><td style='width:50%'>"
		. += "[PI.content(user)]<br>"
	. += "</td></tr></table>"
/datum/category_group/player_setup_category/occupation_preferences/content(var/mob/user)
	for(var/datum/category_item/player_setup_item/PI in items)
		. += "[PI.content(user)]<br>"

/**********************
* Category Item Setup *
**********************/
/datum/category_item/player_setup_item
	var/sort_order = 0
	var/datum/preferences/pref

/datum/category_item/player_setup_item/New()
	..()
	var/datum/category_collection/player_setup_collection/psc = category.collection
	pref = psc.preferences

/datum/category_item/player_setup_item/Destroy()
	pref = null
	return ..()

/datum/category_item/player_setup_item/dd_SortValue()
	return sort_order

/*
* Called when the item is asked to load per character settings
*/
/datum/category_item/player_setup_item/proc/load_character(var/savefile/S)
	return

/*
* Called when the item is asked to save per character settings
*/
/datum/category_item/player_setup_item/proc/save_character(var/savefile/S)
	return

/*
* Called when the item is asked to load user/global settings
*/
/datum/category_item/player_setup_item/proc/load_preferences(var/savefile/S)
	return

/*
* Called when the item is asked to save user/global settings
*/
/datum/category_item/player_setup_item/proc/save_preferences(var/savefile/S)
	return

/*
* Called when the item is asked to update user/global settings
*/
/datum/category_item/player_setup_item/proc/update_setup(var/savefile/preferences, var/savefile/character)
	return 0

/datum/category_item/player_setup_item/proc/content()
	return

/datum/category_item/player_setup_item/proc/sanitize_character()
	return

/datum/category_item/player_setup_item/proc/sanitize_preferences()
	return

/datum/category_item/player_setup_item/Topic(var/href,var/list/href_list)
	if(..())
		return 1
	var/mob/pref_mob = preference_mob()
	if(!pref_mob || !pref_mob.client)
		return 1

	. = OnTopic(href, href_list, usr)
	if(. & TOPIC_UPDATE_PREVIEW)
		pref_mob.client.prefs.preview_icon = null
	if(. & TOPIC_REFRESH)
		pref_mob.client.prefs.ShowChoices(usr)

/datum/category_item/player_setup_item/CanUseTopic(var/mob/user)
	return 1

/datum/category_item/player_setup_item/proc/OnTopic(var/href,var/list/href_list, var/mob/user)
	return TOPIC_NOACTION

/datum/category_item/player_setup_item/proc/preference_mob()
	if(!pref.client)
		for(var/client/C)
			if(C.ckey == pref.client_ckey)
				pref.client = C
				break

	if(pref.client)
		return pref.client.mob

/datum/category_item/player_setup_item/proc/preference_species()
	return all_species[pref.species] || all_species[SPECIES_HUMAN]
