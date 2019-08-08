#define SAVE_RESET -1

datum/preferences
	//doohickeys for savefiles
	var/path
	var/char_save_path
	var/default_slot = 1				//Holder so it doesn't default to slot 1, rather the last one used
	var/chosen_slot = 0
	var/savefile_version = 0

	//non-preference stuff
	var/warns = 0
	var/muted = 0
	var/last_ip
	var/last_id

	//game-preferences
	var/lastchangelog = ""				//Saved changlog filesize to detect if there was a change

	//character preferences
	var/species_preview                 //Used for the species selection window.

		//Mob preview
	var/icon/preview_icon = null

	var/client/client = null
	var/client_ckey = null

	var/savefile/loaded_preferences
	var/savefile/loaded_character
	var/datum/category_collection/player_setup_collection/player_setup
	var/datum/browser/panel
	// Persistent Edit, Adding the character list..
	var/list/character_list = list()
	var/list/icon_list = list()

	var/bonus_slots = 0
	var/bonus_notes = ""
	var/datum/browser/prefspanel

	var/rules_agree = 0
	var/guide_agree = 0

/datum/preferences/New(client/C)
	if(istype(C))
		client = C
		client_ckey = C.ckey
		SScharacter_setup.preferences_datums += src
		if(SScharacter_setup.initialized)
			testing("preferences/New(): Created and directly setup preferences for [client_ckey]")
			setup()
		else
			testing("preferences/New(): Created and queued preference setup for [client_ckey]")
			SScharacter_setup.prefs_awaiting_setup += src
	..()

/datum/preferences/Destroy()
	if(LAZYLEN(SScharacter_setup.prefs_awaiting_setup))
		testing("preferences/Destroy(): was called for [client_ckey]")
		SScharacter_setup.prefs_awaiting_setup -= src
	. = ..()

/datum/preferences/proc/setup()
	testing("preferences/setup(): was called for [client_ckey]")
	if(!length(GLOB.skills))
		decls_repository.get_decl(/decl/hierarchy/skill)
	player_setup = new(src)
	gender = pick(MALE, FEMALE)
	real_name = random_name(gender,species)
	b_type = RANDOM_BLOOD_TYPE

	if(client && !IsGuestKey(client.key))
		src.load_path_pref(client.key)
		load_preferences()
	//	load_and_update_character()
	sanitize_preferences()
	if(client && istype(client.mob, /mob/new_player))
		var/mob/new_player/np = client.mob
		np.new_player_panel(TRUE)
	if(!length(GLOB.skills))
		decls_repository.get_decl(/decl/hierarchy/skill)

/datum/preferences/proc/load_and_update_character(var/slot)
	load_character(slot)
	if(update_setup(loaded_preferences, loaded_character))
		SScharacter_setup.queue_preferences_save(src)
		save_character()

/datum/preferences/proc/ShowChoices(mob/user)
	if(!SScharacter_setup.initialized)
		return
	if(!user || !user.client)
		return

	if(!get_mob_by_key(client_ckey))
		to_chat(user, "<span class='danger'>No mob exists for the given client!</span>")
		close_load_dialog(user)
		return

	var/dat = "<html><body><center>"

	// if(path)
		// dat += "Slot - "
		// dat += "<a href='?src=\ref[src];load=1'>Load slot</a> - "
		// dat += "<a href='?src=\ref[src];save=1'>Save slot</a> - "
		// dat += "<a href='?src=\ref[src];resetslot=1'>Reset slot</a> - "
		// dat += "<a href='?src=\ref[src];reload=1'>Reload slot</a>"

	//dat += "Finish Character - "
	dat += "<a href='?src=\ref[src];save=1'>Finalize</a>"
	// else
	// 	dat += "Please create an account to save your preferences."

	dat += "<br>"
	dat += player_setup.header()
	dat += "<br><HR></center>"
	dat += player_setup.content(user)
	if(!preview_icon)
		update_preview_icon()
		return ShowChoices(user)
	dat += "</html></body>"
	panel =  new(user, "Create a new character","Create a new character", 1200, 800, src)
	panel.set_content(dat)
	panel.open()

/datum/preferences/proc/process_link(mob/user, list/href_list)

	if(!user)	return
	if(isliving(user)) return

	if(href_list["preference"] == "open_whitelist_forum")
		if(config.forumurl)
			open_link(user, config.forumurl)
		else
			to_chat(user, "<span class='danger'>The forum URL is not set in the server configuration.</span>")
			return
	ShowChoices(usr)
	return 1

/datum/preferences/Topic(href, list/href_list)
	if(..())
		return 1

	if(href_list["save"])
		if(!cultural_info)
			log_error("Something went very wrong with cultural info!!!")
			return
		if(!real_name)
			to_chat(usr, "You must select a valid character name")
			return
		if(!rules_agree)
			to_chat(usr, "You must read the rules and verify that you have read them.")
			return
		if(!welcome_accept)
			to_chat(usr, "You should read the welcome message and then certify you are ready to play persistence.")
			return
		if(!guide_agree)
			to_chat(usr, "You must agree to play a reasonable character, stay in character and follow our guidelines.")
			return
		if(!cultural_info[TAG_CULTURE])
			to_chat(usr, "You must select an early life for your character.")
			return
		if(!cultural_info[TAG_AMBITION])
			to_chat(usr, "You must select an ambition for your character.")
			return

		save_character()
		save_preferences()
		close_browser(usr, "window=saves")
		if(panel)
			panel.close()
		return 0
	else if(href_list["reload"])
		load_preferences()
		load_character()
		sanitize_preferences()
	else if(href_list["load"])
		if(!IsGuestKey(usr.key))
			open_load_dialog(usr)
			return 1
	else if(href_list["changeslot"])
		load_character(text2num(href_list["changeslot"]))
		sanitize_preferences()
		close_load_dialog(usr)
	else if(href_list["pickslot"])
		chosen_slot = text2num(href_list["pickslot"])
		randomize_appearance_and_body_for()
		real_name = null
		preview_icon = null
		faction = null
		selected_under = null
		sanitize_preferences()
		client.prefs.ShowChoices(src)
		close_load_dialog(usr)
	else if(href_list["resetslot"])
		if(real_name != input("This will reset the current slot. Enter the character's full name to confirm."))
			return 0
		load_character(SAVE_RESET)
		sanitize_preferences()
	else if(href_list["saveprefs"])
		save_preferences()
		prefspanel?.close()
	else
		return 0

	ShowChoices(usr)
	return 1

/datum/preferences/proc/copy_import(mob/living/carbon/human/character, mob/living/carbon/human/character2)
	character.set_species(character2.get_species())
	character.fully_replace_character_name(character2.real_name)
	character.gender = character2.gender
	character.age = character2.age
	character.b_type = character2.b_type

	character.r_eyes = character2.r_eyes
	character.g_eyes = character2.g_eyes
	character.b_eyes = character2.b_eyes

	character.h_style = character2.h_style
	character.r_hair = character2.r_hair
	character.g_hair = character2.g_hair
	character.b_hair = character2.b_hair

	character.f_style = character2.f_style
	character.r_facial = character2.r_facial
	character.g_facial = character2.g_facial
	character.b_facial = character2.b_facial

	character.r_skin = character2.r_skin
	character.g_skin = character2.g_skin
	character.b_skin = character2.b_skin

	character.s_tone = character2.s_tone
	character.s_base = character2.s_base

	character.h_style = character2.h_style
	character.f_style = character2.f_style
	character.species.handle_limbs_setup(character)

	character.force_update_limbs()
	character.update_mutations(0)
	character.update_body(0)
	character.update_underwear(0)
	character.update_hair(0)
	character.update_icons()

	if(!character.isSynthetic())
		character.nutrition = rand(140,360)



/datum/preferences/proc/copy_to(mob/living/carbon/human/character, is_preview_copy = FALSE)
	// Sanitizing rather than saving as someone might still be editing when copy_to occurs.
	player_setup.sanitize_setup()
	character.set_species(species)

	// if(be_random_name)
	// 	var/decl/cultural_info/culture = SSculture.get_culture(cultural_info[TAG_CULTURE])
	// 	if(culture) real_name = culture.get_random_name(gender)

	if(config.humans_need_surnames)
		var/firstspace = findtext(real_name, " ")
		var/name_length = length(real_name)
		if(!firstspace)	//we need a surname
			real_name += " [pick(GLOB.last_names)]"
		else if(firstspace == name_length)
			real_name += "[pick(GLOB.last_names)]"

	character.fully_replace_character_name(real_name)

	character.gender = gender
	character.age = age
	character.b_type = b_type

	character.r_eyes = r_eyes
	character.g_eyes = g_eyes
	character.b_eyes = b_eyes

	character.h_style = h_style
	character.r_hair = r_hair
	character.g_hair = g_hair
	character.b_hair = b_hair

	character.f_style = f_style
	character.r_facial = r_facial
	character.g_facial = g_facial
	character.b_facial = b_facial

	character.r_skin = r_skin
	character.g_skin = g_skin
	character.b_skin = b_skin

	character.s_tone = s_tone
	character.s_base = s_base

	character.h_style = h_style
	character.f_style = f_style

	// Replace any missing limbs.
	for(var/name in BP_ALL_LIMBS)
		var/obj/item/organ/external/O = character.organs_by_name[name]
		if(!O && organ_data[name] != "amputated")
			var/list/organ_data = character.species.has_limbs[name]
			if(!islist(organ_data)) continue
			var/limb_path = organ_data["path"]
			O = new limb_path(character)

	// Destroy/cyborgize organs and limbs. The order is important for preserving low-level choices for robolimb sprites being overridden.
	for(var/name in BP_BY_DEPTH)
		var/status = organ_data[name]
		var/obj/item/organ/external/O = character.organs_by_name[name]
		if(!O)
			continue
		O.status = 0
		O.model = null
		if(status == "amputated")
			character.organs_by_name[O.organ_tag] = null
			character.organs -= O
			if(O.children) // This might need to become recursive.
				for(var/obj/item/organ/external/child in O.children)
					character.organs_by_name[child.organ_tag] = null
					character.organs -= child
					qdel(child)
			qdel(O)
		else if(status == "cyborg")
			if(rlimb_data[name])
				O.robotize(rlimb_data[name])
			else
				O.robotize()
		else //normal organ
			O.force_icon = initial(O.force_icon)
			O.SetName(initial(O.name))
			O.desc = initial(O.desc)

	//For species that don't care about your silly prefs
	character.species.handle_limbs_setup(character)
	if(!is_preview_copy)
		for(var/name in list(BP_HEART,BP_EYES,BP_BRAIN,BP_LUNGS,BP_LIVER,BP_KIDNEYS))
			var/status = organ_data[name]
			if(!status)
				continue
			var/obj/item/organ/I = character.internal_organs_by_name[name]
			if(I)
				if(status == "assisted")
					I.mechassist()
				else if(status == "mechanical")
					I.robotize()

	QDEL_NULL_LIST(character.worn_underwear)
	character.worn_underwear = list()

	for(var/underwear_category_name in all_underwear)
		var/datum/category_group/underwear/underwear_category = GLOB.underwear.categories_by_name[underwear_category_name]
		if(underwear_category)
			var/underwear_item_name = all_underwear[underwear_category_name]
			var/datum/category_item/underwear/UWD = underwear_category.items_by_name[underwear_item_name]
			var/metadata = all_underwear_metadata[underwear_category_name]
			var/obj/item/underwear/UW = UWD.create_underwear(metadata)
			if(UW)
				UW.ForceEquipUnderwear(character, FALSE)
		else
			all_underwear -= underwear_category_name

	character.backpack_setup = new(backpack, backpack_metadata["[backpack]"])

	for(var/N in character.organs_by_name)
		var/obj/item/organ/external/O = character.organs_by_name[N]
		O.markings.Cut()

	for(var/M in body_markings)
		var/datum/sprite_accessory/marking/mark_datum = GLOB.body_marking_styles_list[M]
		var/mark_color = "[body_markings[M]]"

		for(var/BP in mark_datum.body_parts)
			var/obj/item/organ/external/O = character.organs_by_name[BP]
			if(O)
				O.markings[M] = list("color" = mark_color, "datum" = mark_datum)

	character.force_update_limbs()
	character.update_mutations(0)
	character.update_body(0)
	character.update_underwear(0)
	character.update_hair(0)
	character.update_icons()

	if(is_preview_copy)
		return

	for(var/token in cultural_info)
		character.set_cultural_value(token, cultural_info[token], defer_language_update = TRUE)
	character.update_languages()
	for(var/lang in alternate_languages)
		character.add_language(lang)

	character.flavor_texts["general"] = flavor_texts["general"]
	character.flavor_texts["head"] = flavor_texts["head"]
	character.flavor_texts["face"] = flavor_texts["face"]
	character.flavor_texts["eyes"] = flavor_texts["eyes"]
	character.flavor_texts["torso"] = flavor_texts["torso"]
	character.flavor_texts["arms"] = flavor_texts["arms"]
	character.flavor_texts["hands"] = flavor_texts["hands"]
	character.flavor_texts["legs"] = flavor_texts["legs"]
	character.flavor_texts["feet"] = flavor_texts["feet"]

	character.public_record = public_record
	character.med_record = med_record
	character.sec_record = sec_record
	character.gen_record = gen_record
	//character.exploit_record = exploit_record

	if(LAZYLEN(character.descriptors))
		for(var/entry in body_descriptors)
			character.descriptors[entry] = body_descriptors[entry]
	character.personal_faction = faction

	if(!character.isSynthetic())
		character.nutrition = rand(140,360)


/datum/preferences/proc/delete_character(var/slot)
	if(!slot)
		return
	SScharacter_setup.delete_character(slot, client.ckey)
	if(character_list && (character_list.len >= slot))
		character_list[slot] = "nothing"

/datum/preferences/proc/load_characters()
/*	var/path_to = load_path(client.ckey, "")
	character_list = list()
	var/slots = config.character_slots
	if(check_rights(R_ADMIN, 0, client))
		slots += 2
	slots += client.prefs.bonus_slots
	var/list/loaded = list()
	for(var/i=1, i<= slots, i++)
		if(fexists("[path_to][i].sav"))
			var/savefile/S =  new("[path_to][i].sav")
			var/mob/M
			from_file(S, M)
			loaded |= M
			if(M)
				M.after_load()
				for(var/datum/D in M.contents)
					D.after_load()
				for(var/mob/loaded_mob in SSmobs.mob_list)
					if(loaded_mob in loaded) continue
					if(!loaded_mob.perma_dead && loaded_mob.type != /mob/new_player && (loaded_mob.real_name == M.real_name) && (get_turf(loaded_mob)))
						loaded_mob.save_slot = i
				character_list += M
				M.save_slot = i
		else
			character_list += "empty"
	return 1
	*/

/datum/preferences/proc/open_load_dialog(mob/user)
	var/dat  = list()
	dat += "<body>"
	dat += "<tt><center>"
	var/slots = config.character_slots
	if(check_rights(R_ADMIN, 0, client))
		slots += 2
	slots += client.prefs.bonus_slots
	var/savefile/S = new /savefile(path)
	if(S)
		dat += "<b>Select a character slot to load</b><hr>"
		var/name
		for(var/i=1, i<= slots, i++)
			name = SScharacter_setup.peek_character_name(i, client.ckey)
			from_file(S["name"], name)
			if(!name)	name = "Character[i]"
			if(i==default_slot)
				name = "<b>[name]</b>"
			dat += "<a href='?src=\ref[src];changeslot=[i]'>[name]</a><br>"

	dat += "<hr>"
	dat += "</center></tt>"
	panel = new(user, "Character Slots", "Character Slots", 300, 390, src)
	panel.set_content(jointext(dat,null))
	panel.open()

/datum/preferences/proc/slot_select(mob/user)
	var/slots = config.character_slots
	if(check_rights(R_ADMIN, 0, client))
		slots += 2
	slots += client.prefs.bonus_slots
	// if(!character_list || (character_list.len < slots))
	// 	load_characters()
	var/dat  = list()
	dat += "<body>"
	dat += "<tt><center>"
	dat += "<b>Select the character slot you want to save this character under.</b><hr>"
	for(var/ind = 0, ind < slots, ind++)
		var/name = SScharacter_setup.peek_character_name(ind, client.ckey)
		if(!isnull(name))
			dat += "<b>[name]</b><br>"
		else
			dat += "<a href='?src=\ref[src];pickslot=[ind]'>Open Slot [ind]</a><br>"
	dat += "<hr>"
	dat += "</center></tt>"
	panel = new(user, "Character Slots", "Character Slots", 300, 390, src)
	panel.set_content(jointext(dat,null))
	panel.open()


/datum/preferences/proc/close_load_dialog(mob/user)
	if(panel)
		panel.close()
		panel = null
	close_browser(user, "window=saves")


/datum/preferences/proc/Slots()
	var/slots = 2 + bonus_slots

	if(check_rights(R_ADMIN, 0, client))
		slots += 2

	return slots

/datum/preferences/proc/GetPlayerAltTitle(datum/job/job)
	// return (job.title in player_alt_titles) ? player_alt_titles[job.title] : job.title
	return (job)? job.title : ""
