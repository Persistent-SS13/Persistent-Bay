#define SAVEFILE_VERSION_MIN	8
#define SAVEFILE_VERSION_MAX	17

/proc/load_path(ckey,filename="preferences.sav")
	if(!ckey)	return
	return "data/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename]"

/proc/beta_path(ckey,filename="preferences.sav")
	if(!ckey) return
	return "exports/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename]"

/proc/exit_path(ckey,filename="preferences.sav")
	if(!ckey)	return
	return "exits/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename]"

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

/datum/preferences/proc/save_character()
	var/char_path = character_load_path(chosen_slot)
	if(!char_path)				return 0
	var/savefile/S = new /savefile(char_path)
	if(!S)					return 0
	S.cd = "/"
	//S.cd = GLOB.using_map.character_save_path(default_slot)

	// var/use_path = load_path(client.ckey, "")
	// var/savefile/S = new("[use_path][chosen_slot].sav")
	// var/mob/living/carbon/human/mannequin = new()
	// dress_preview_mob(mannequin, TRUE)
	// mannequin.name = real_name
	// mannequin.real_name = real_name
	// mannequin.dna.ResetUIFrom(mannequin)
	// mannequin.dna.ready_dna(mannequin)
	// mannequin.dna.b_type = client.prefs.b_type
	// mannequin.sync_organ_dna()
	// if (client.prefs.has_vatgrown_chip)
	// 	mannequin.internal_organs_by_name[BP_STACK] = new /obj/item/organ/internal/stack/vat(mannequin,1)
	// else
	// 	mannequin.internal_organs_by_name[BP_STACK] = new /obj/item/organ/internal/stack(mannequin,1)
	// var/datum/computer_file/data/email_account/email = new()
	// email.login = "[replacetext(mannequin.real_name, " ", "_")]@freemail.nt"
	// email.password = chosen_password
	// var/money_amount = 500
	// var/datum/money_account/M = create_account(mannequin.real_name, money_amount, null)
	// M.remote_access_pin = chosen_pin
	// if(!mannequin.mind)
	// 	mannequin.mind = new()
	// var/remembered_info = ""
	// remembered_info += "<b>Your email account is :</b> [email.login]<br>"
	// remembered_info += "<b>Your email password is :</b> [email.password]<br>"
	// remembered_info += "<b>Your account number is:</b> #[M.account_number]<br>"
	// remembered_info += "<b>Your account pin is:</b> [M.remote_access_pin]<br>"
	// remembered_info += "<b>Your account funds are:</b> [M.money]<br>"
	// mannequin.mind.store_memory(remembered_info)
	// var/decl/backpack_outfit/bo
	// var/metadata
	// if(mannequin.backpack_setup)
	// 	bo = mannequin.backpack_setup.backpack
	// 	metadata = mannequin.backpack_setup.metadata
	// else
	// 	bo = get_default_outfit_backpack()
	// var/backpack = bo.spawn_backpack(mannequin, metadata)
	// if(backpack)
	// 	mannequin.equip_to_slot_or_del(backpack,slot_back)
	// mannequin.mind.initial_account = M
	// var/datum/computer_file/report/crew_record/record = CreateModularRecord(mannequin)
	// var/faction_uid = "refugee"
	// faction_uid = "nanotrasen"
	// var/datum/world_faction/factions = get_faction(faction)
	// if(factions)
	// 	var/datum/computer_file/report/crew_record/record2 = new()
	// 	if(!record2.load_from_global(real_name))
	// 		message_admins("record for [real_name] failed to load in character creation..")
	// 	else
	// 		factions.records.faction_records |= record
	// 	var/obj/item/weapon/card/id/id = new(mannequin)
	// 	id.registered_name = real_name
	// 	faction_uid = factions.uid
	// 	id.selected_faction = factions.uid
	// 	id.approved_factions |= factions.uid
	// 	id.associated_account_number = M.account_number
	// 	if(record2)
	// 		id.sync_from_record(record2)
	// 	mannequin.equip_to_slot_or_del(id,slot_wear_id)
	// 	var/obj/item/organ/internal/stack/stack = mannequin.internal_organs_by_name["stack"]
	// 	if(stack)
	// 		stack.connected_faction = factions.uid
	// 		stack.try_connect()
	// 	mannequin.equip_to_slot_or_del(new /obj/item/device/radio/headset(mannequin),slot_l_ear)
	// if(faction)
	// 	mannequin.spawn_loc = faction_uid
	// else
	// 	mannequin.spawn_loc = "null"
	// mannequin.spawn_type = 2
	// mannequin.species.equip_survival_gear(mannequin)
	// mannequin.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(mannequin),slot_shoes)
	// for(var/lang in alternate_languages)
	// 	var/datum/language/chosen_language = all_languages[lang]
	// 	if(chosen_language)
	// 		var/decl/cultural_info/current_culture = SSculture.get_culture(mannequin.species.default_cultural_info[TAG_CULTURE])
	// 		var/is_species_lang = (chosen_language in (current_culture.get_spoken_languages()))
	// 		if(is_species_lang || ((!(chosen_language.flags & RESTRICTED) || check_rights(R_ADMIN, 0, client))))
	// 			mannequin.add_language(lang)
	// to_file(S["name"], mannequin.real_name)
	// to_file(S["mob"], mannequin)
	// character_list = list()
	// qdel(mannequin)

	to_file(S["version"], SAVEFILE_VERSION_MAX)
	player_setup.save_character(S)
	loaded_character = S
	return S

/datum/preferences/proc/sanitize_preferences()
	player_setup.sanitize_setup()
	if(!bonus_slots) bonus_slots = 0
	if(!bonus_notes) bonus_notes = ""
	return 1

/datum/preferences/proc/update_setup(var/savefile/preferences, var/savefile/character)
	if(!preferences || !character)
		return 0
	return player_setup.update_setup(preferences, character)

#undef SAVEFILE_VERSION_MAX
#undef SAVEFILE_VERSION_MIN
