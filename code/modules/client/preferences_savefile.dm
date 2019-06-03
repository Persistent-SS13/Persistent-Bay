#define SAVEFILE_VERSION_MIN	8
#define SAVEFILE_VERSION_MAX	17

/datum/preferences/proc/load_path(ckey,filename="preferences.sav")
	if(!ckey)	return
	path = load_path(ckey, filename)
	char_save_path = "data/player_saves/[copytext(ckey,1,2)]/[ckey]/"
	savefile_version = SAVEFILE_VERSION_MAX

/datum/preferences/proc/beta_path(ckey,filename="preferences.sav")
	if(!ckey) return
	path =  beta_path(ckey, filename)
	savefile_version = SAVEFILE_VERSION_MAX

/datum/preferences/proc/exit_path(ckey,filename="preferences.sav")
	if(!ckey)	return
	path = exit_path(ckey, filename)
	savefile_version = SAVEFILE_VERSION_MAX

/datum/preferences/proc/character_load_path(slot)
	if(!char_save_path || !slot)	return
	return "[char_save_path][slot].sav"


/datum/preferences/proc/load_preferences()
	if(!path)				return 0
	if(!fexists(path))		return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/"

	from_file(S["version"], savefile_version)
	player_setup.load_preferences(S)
	loaded_preferences = S
	return 1

/datum/preferences/proc/save_preferences()
	if(!path)				return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/"

	to_file(S["version"], SAVEFILE_VERSION_MAX)
	player_setup.save_preferences(S)
	loaded_preferences = S
	return 1

/datum/preferences/proc/load_character(slot)
//	var/char_path = character_load_path(slot)
//	if(!char_path)				return 0
//	if(!fexists(char_path))		return 0
//	var/savefile/S = new /savefile(char_path)
//	if(!S)					return 0
//	S.cd = "/"
//	if(!slot)	slot = default_slot

	/**
	if(slot != SAVE_RESET) // SAVE_RESET will reset the slot as though it does not exist, but keep the current slot for saving purposes.
		slot = sanitize_integer(slot, 1, config.character_slots, initial(default_slot))
		if(slot != default_slot)
			default_slot = slot
			to_file(S["default_slot"], slot)
	else
		to_file(S["default_slot"], default_slot)

	if(slot != SAVE_RESET)
		// S.cd = GLOB.using_map.character_load_path(S, slot)
		player_setup.load_character(S)
	else
		player_setup.load_character(S)
		// S.cd = GLOB.using_map.character_load_path(S, default_slot)

	loaded_character = S
	**/
	return 1

//This saves the initial character after creation is complete
/datum/preferences/proc/save_character()
	var/mob/mannequin = create_mannequin()
	setup_new_accounts(mannequin)
	SScharacter_setup.save_character(chosen_slot, client.ckey, mannequin)
	character_list = list()
	// var/char_path = character_load_path(chosen_slot)
	// if(!char_path)				return 0
	// var/savefile/S = new /savefile(char_path)
	// if(!S)					return 0
	// S.cd = "/"
	//to_file(S["version"], SAVEFILE_VERSION_MAX)
	// player_setup.save_character(S)
	// loaded_character = S
	//return S

/datum/preferences/proc/sanitize_preferences()
	player_setup.sanitize_setup()
	if(!bonus_slots) bonus_slots = 0
	if(!bonus_notes) bonus_notes = ""
	return 1

/datum/preferences/proc/update_setup(var/savefile/preferences, var/savefile/character)
	if(!preferences || !character)
		return 0
	return player_setup.update_setup(preferences, character)

//Make the new email, and bank accounts for the new character
/datum/preferences/proc/setup_new_accounts(var/mob/living/carbon/human/H)
	//Accounts
	var/datum/computer_file/data/email_account/email = new()
	email.login = "[replacetext(H.real_name, " ", "_")]@[pick(GLOB.using_map.usable_email_tlds)]"
	email.password = chosen_password
	H.mind.initial_email_login = list("login" = email.login, "password" = email.password)
	testing("created email for [H], [email.login], [email.password]")

	var/datum/computer_file/report/crew_record/record = CreateModularRecord(H)
	testing("created modular record for [H], [record]")
	var/faction_uid = GLOB.using_map.default_faction_uid
	var/datum/world_faction/F = get_faction(src.faction)
	if(F)
		faction_uid = F.uid
		var/datum/money_account/M = create_account(H.real_name, F.get_new_character_money(H), null)
		M.remote_access_pin = chosen_pin
		H.mind.store_memory( {"
<b>Your email account is :</b> [email.login]<br>
<b>Your email password is :</b> [email.password]<br>
<b>Your account number is:</b> #[M.account_number]<br>
<b>Your account pin is:</b> [M.remote_access_pin]<br>
"})
		H.mind.initial_account = M

		var/datum/computer_file/report/crew_record/record2 = new()
		if(!record2.load_from_global(real_name))
			message_admins("record for [real_name] failed to load in character creation..")
		else
			F.records.faction_records |= record
		
		//ID stuff is handled by the outfit code later on, when the actual final ID is spawned

	if(src.faction)
		H.spawn_loc = faction_uid
		testing("[H], [H.spawn_loc], src.faction")
	else
		H.spawn_loc = "null"
		log_warning("[H]'s spawn_loc is null! Got faction: [src.faction]'")

//Creates the dummy mob used to store initial character data in the save file
/datum/preferences/proc/create_mannequin()
	var/mob/living/carbon/human/mannequin = new()
	mannequin.name = real_name
	mannequin.real_name = real_name
	mannequin.spawn_type = 2 //For first time spawn
	if(!mannequin.mind)
		mannequin.mind = new()

	//Languages
	for(var/token in cultural_info)
		mannequin.set_cultural_value(token, cultural_info[token], defer_language_update = TRUE)

	for(var/lang in alternate_languages)
		var/datum/language/chosen_language = all_languages[lang]
		if(chosen_language)
			var/decl/cultural_info/current_culture = SSculture.get_culture(mannequin.species.default_cultural_info[TAG_CULTURE])
			var/is_species_lang = (chosen_language in (current_culture.get_spoken_languages()))
			if(is_species_lang || ((!(chosen_language.flags & RESTRICTED) || check_rights(R_ADMIN, 0, client))))
				mannequin.add_language(lang)
	mannequin.update_languages()

	//DNA should be last
	mannequin.dna.ResetUIFrom(mannequin)
	mannequin.dna.ready_dna(mannequin)
	mannequin.dna.b_type = client.prefs.b_type
	mannequin.sync_organ_dna()

	if(client.prefs.disabilities)
		// Set defer to 1 if you add more crap here so it only recalculates struc_enzymes once. - N3X
		mannequin.dna.SetSEState(GLOB.GLASSESBLOCK,1,0)
		mannequin.disabilities |= NEARSIGHTED

	// Give them their cortical stack if we're using them.
	if(config && config.use_cortical_stacks && client && client.prefs.has_cortical_stack)
		mannequin.create_stack(faction_uid = src.faction, silent = TRUE) //Auto-spawn the correct kind of stack
		//Faction is auto-assigned

	dress_preview_mob(mannequin, TRUE)

	// Do the initial caching of the player's body icons.
	mannequin.force_update_limbs()
	mannequin.update_eyes()
	mannequin.regenerate_icons()

	return mannequin

#undef SAVEFILE_VERSION_MAX
#undef SAVEFILE_VERSION_MIN
