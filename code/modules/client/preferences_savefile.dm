#define SAVEFILE_VERSION_MIN	8
#define SAVEFILE_VERSION_MAX	17

/datum/preferences/proc/load_path_pref(ckey,filename="preferences.sav")
	if(!ckey)	return
	path = "data/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename]"
	char_save_path = "data/player_saves/[copytext(ckey,1,2)]/[ckey]/"
	savefile_version = SAVEFILE_VERSION_MAX
	return path
/datum/preferences/proc/beta_path(ckey,filename="preferences.sav")
	if(!ckey) return
	path =  "exports/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename]"
	savefile_version = SAVEFILE_VERSION_MAX

/datum/preferences/proc/exit_path(ckey,filename="preferences.sav")
	if(!ckey)	return
	path = "exits/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename]"
	savefile_version = SAVEFILE_VERSION_MAX

/datum/preferences/proc/character_load_path(slot)
	if(!char_save_path || !slot)	return
	return "[char_save_path][slot].sav"


/datum/preferences/proc/load_preferences()
	// if(!path)
	path = load_path_pref(client_ckey, "preferences.sav")
	if(!fexists(path))		return 0
	var/savefile/S = new(path)
	if(!S)					return 0
	S.cd = "/"

	from_file(S["version"], savefile_version)
	player_setup.load_preferences(S)
	loaded_preferences = S
	return 1

/datum/preferences/proc/save_preferences()
	testing("preferences/save_preferences() : Attempting to save prefs (ckey = [client_ckey], path = [path])")
	//if(!path || (path && (length(path) == 0) ) )
	path = load_path_pref(client_ckey, "preferences.sav")
	testing("preferences/save_preferences() : Set path to (path = [path])")
	var/savefile/S = new (path)
	if(!S)					return 0
	S.cd = "/"

	to_file(S["version"], SAVEFILE_VERSION_MAX)
	player_setup.save_preferences(S)
	loaded_preferences = S
	return 1

//Since characters are saved into separate files
// and not meant to be modified after creation, we don't use this method
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

//This saves the initial character, before its tweaked again
/datum/preferences/proc/save_character()
	SScharacter_setup.save_character(chosen_slot, client.ckey, create_initial_character())
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
	player_setup.sanitize_setup() //Leave it runtime if it must
	if(!bonus_slots) bonus_slots = 0
	if(!bonus_notes) bonus_notes = ""
	return 1

/datum/preferences/proc/update_setup(var/savefile/preferences, var/savefile/character)
	if(!preferences /*|| !character*/) //since character aren't saved the same way, we don't care
		return 0
	return player_setup.update_setup(preferences, character)

//Make the new email, and bank accounts for the new character
/datum/preferences/proc/setup_new_accounts(var/mob/living/carbon/human/H)
	//Accounts
	var/datum/computer_file/data/email_account/email = new()
	email.login = "[replacetext(H.real_name, " ", "_")]@[pick(GLOB.using_map.usable_email_tlds)]"
	email.password = chosen_password
	H.mind.initial_email_login = list("login" = email.login, "password" = email.password)

	var/datum/world_faction/F = get_faction(GLOB.using_map.default_faction_uid)
	src.faction = GLOB.using_map.default_faction_uid
	if(!F)
		log_warning("setup_new_accounts(): Couldn't find faction [GLOB.using_map.default_faction_uid]")

	//testing("created email for [H], [email.login], [email.password]")
	var/datum/money_account/M = create_account(H.real_name, F.get_new_character_money(H), null)
	M.remote_access_pin = chosen_pin
	H.mind.initial_account = M
	//After the bank account and email accounts are made, create the record.
	// Since the record contains both.
	var/datum/computer_file/report/crew_record/record = CreateModularRecord(H)
	//testing("created modular record for [H], [record]")
	record.ckey = client.ckey
	var/datum/computer_file/report/crew_record/record2 = new()
	if(!record2.load_from_global(real_name))
		message_admins("record for [real_name] failed to load in character creation..")
	else if(F)
		F.records.faction_records |= record

	//ID stuff is handled by the outfit code later on, when the actual final ID is spawned
	H.spawn_loc = F? F.uid : ""

//Creates the dummy mob used to store initial character data in the save file
/datum/preferences/proc/create_initial_character()
	var/mob/living/carbon/human/H = new()
	H.name 			= real_name
	H.real_name 	= real_name
	H.spawn_type 	= CHARACTER_SPAWN_TYPE_FRONTIER_BEACON //For first time spawn
	H.age 			= age
	H.gender 		= gender
	H.b_type		= b_type
	H.set_species(species)
	if(!H.mind)
		H.mind = new()

	//Languages + culture are copied
	for(var/token in cultural_info)
		H.set_cultural_value(token, cultural_info[token], defer_language_update = TRUE)

	for(var/lang in alternate_languages)
		var/datum/language/chosen_language = all_languages[lang]
		if(chosen_language)
			var/decl/cultural_info/current_culture = SSculture.get_culture(H.species.default_cultural_info[TAG_CULTURE])
			var/is_species_lang = (chosen_language in (current_culture.get_spoken_languages()))
			if(is_species_lang || ((!(chosen_language.flags & RESTRICTED) || check_rights(R_ADMIN, 0, client))))
				H.add_language(lang)
	H.update_languages()
	H.update_citizenship()

	//DNA should be last
	H.dna.ResetUIFrom(H)
	H.dna.ready_dna(H) //Do this before setting disabilities
	if(client.prefs.disabilities)
		// Set defer to 1 if you add more crap here so it only recalculates struc_enzymes once. - N3X
		H.dna.SetSEState(GLOB.GLASSESBLOCK,1,0)
		H.disabilities |= NEARSIGHTED
	H.sync_organ_dna()

	// Give them their cortical stack if we're using them.
	if(config && config.use_cortical_stacks && client && client.prefs.has_cortical_stack)
		H.create_stack(faction_uid = src.faction, silent = TRUE) //Auto-spawn the correct kind of stack

	setup_new_accounts(H) //make accounts before! Outfit setup needs the record set
	dress_preview_mob(H, TRUE)

	// Do the initial caching of the player's body icons.
	H.force_update_limbs()
	H.update_eyes()
	H.regenerate_icons()
	return H

#undef SAVEFILE_VERSION_MAX
#undef SAVEFILE_VERSION_MIN
