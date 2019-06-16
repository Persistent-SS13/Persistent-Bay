//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/mob/new_player
	var/ready = 0
	var/spawning = 0//Referenced when you want to delete the new_player later on in the code.
	var/totalPlayers = 0		 //Player counts for the Lobby tab
	var/totalPlayersReady = 0
	var/datum/browser/panel
	var/datum/browser/load_panel
	var/show_invalid_jobs = 0
	universal_speak = 1
	should_save = 0
	invisibility = 101

	density = 0
	stat = DEAD

	movement_handlers = list()
	anchored = 1	//  don't get pushed around

	virtual_mob = null // Hear no evil, speak no evil

	// Persitent Edit, chosen slot
	var/chosen_slot = 0

/mob/new_player/New()
	..()
	//verbs += /mob/proc/toggle_antag_pool //no antags

/mob/new_player/proc/new_player_panel(force = FALSE)
	if(!SScharacter_setup.initialized && !force)
		return // Not ready yet.

	var/output = list()
	output += "<div align='center'><hr><br>"
	if(GAME_STATE < RUNLEVEL_GAME)
		output += "<span class='average'><b>The Game Is Loading!</b></span><br><br>"

	else
		output += "<a href='byond://?src=\ref[src];createCharacter=1'>Create A New Character</a><br><br>"
		output += "<a href='byond://?src=\ref[src];deleteCharacter=1'>Delete A Character</a><br><br>"
		output += "<a href='byond://?src=\ref[src];joinGame=1'>Join Game!</a><br><br>"
		output += "<a href='byond://?src=\ref[src];importCharacter=1'>Import Prior Character</a><br><br>"
	output += "<a href='https://discord.gg/53YgfNU'target='_blank'>Join Discord</a><br><br>"
	output += "<a href='byond://?src=\ref[src];joinGame=1'>Link Discord Account</a><br><br>"
	if(check_rights(R_DEBUG, 0, client))
		output += "<a href='byond://?src=\ref[src];observeGame=1'>Observe</a><br><br>"
	output += "<a href='byond://?src=\ref[src];refreshPanel=1'>Refresh</a><br><br>"
	//output += "<a href='byond://?src=\ref[src];show_preferences=1'>Preferences</a><br><br>"

	if(!IsGuestKey(src.key))
		establish_db_connection()
		if(dbcon.IsConnected())
			var/isadmin = 0
			if(src.client && src.client.holder)
				isadmin = 1
			var/DBQuery/query = dbcon.NewQuery("SELECT id FROM erro_poll_question WHERE [(isadmin ? "" : "adminonly = false AND")] Now() BETWEEN starttime AND endtime AND id NOT IN (SELECT pollid FROM erro_poll_vote WHERE ckey = \"[ckey]\") AND id NOT IN (SELECT pollid FROM erro_poll_textreply WHERE ckey = \"[ckey]\")")
			query.Execute()
			var/newpoll = 0
			while(query.NextRow())
				newpoll = 1
				break

			if(newpoll)
				output += "<p><b><a href='byond://?src=\ref[src];showpoll=1'>Show Player Polls</A> (NEW!)</b></p>"
			else
				output += "<p><a href='byond://?src=\ref[src];showpoll=1'>Show Player Polls</A></p>"

	output += "</div>"

	panel = new(src, "Persistent SS13","Persistent SS13", 250, 400, src)
	panel.set_window_options("can_close=0")
	panel.set_content(JOINTEXT(output))
	panel.open()

/mob/new_player/Stat()
	. = ..()

	if(statpanel("Lobby"))
		stat("Players : [GLOB.player_list.len]")

/mob/proc/after_spawn()
	after_load()
	for(var/datum/D in recursive_content_check(src, client_check = FALSE, sight_check = FALSE, include_mobs = TRUE))
		D.after_load()
	return

/mob/living/carbon/lace/after_spawn()
	..()
	if(container2)
		container2.loc = loc
		loc = container
		if(client)
			client.perspective = EYE_PERSPECTIVE
			client.eye = container
	else if(container)
		container.loc = loc
		loc = container
		if(client)
			client.perspective = EYE_PERSPECTIVE
			client.eye = container

/mob/new_player/Topic(href, href_list[])
	if(!client)	return 0

	if(href_list["createCharacter"])
		newCharacterPanel()
		return 0

	if(href_list["joinGame"])
		selectCharacterPanel("load")
		return 0

	if(href_list["crewManifest"])
		crewManifestPanel()
		return 0

	if(href_list["observeGame"])
		observeGame()
		return 0

	if(href_list["deleteCharacter"])
		selectCharacterPanel("delete")
		return 0

	if(href_list["refresh"])
		panel.close()
		new_player_panel()

	if(href_list["importSlot"])
		chosen_slot = text2num(href_list["importSlot"])
		ImportCharacter()

	if(href_list["pickSlot"])
		chosen_slot = text2num(copytext(href_list["pickSlot"], 1, 2))
		client.prefs.chosen_slot = chosen_slot
		load_panel?.close()
		switch(copytext(href_list["pickSlot"], 2))
			if("create")
				client.prefs.randomize_appearance_and_body_for()
				client.prefs.real_name = null
				client.prefs.preview_icon = null
				// client.prefs.home_system = null
				client.prefs.faction = null
				client.prefs.selected_under = null
				client.prefs.sanitize_preferences()
				client.prefs.ShowChoices(src)
			if("load")
				loadCharacter()
			if("delete")
				deleteCharacter()
		return 0

	if(href_list["pickSlot"])
		chosen_slot = text2num(copytext(href_list["pickSlot"], 1, 2))
		client.prefs.chosen_slot = chosen_slot
		load_panel?.close()
		switch(copytext(href_list["pickSlot"], 2))
			if("create")
				client.prefs.randomize_appearance_and_body_for()
				client.prefs.real_name = null
				client.prefs.preview_icon = null
				// client.prefs.home_system = null
				client.prefs.faction = null
				client.prefs.selected_under = null
				client.prefs.sanitize_preferences()
				client.prefs.ShowChoices(src)
			if("load")
				loadCharacter()
			if("delete")
				deleteCharacter()
		return 0



	if(href_list["privacy_poll"])
		establish_db_connection()
		if(!dbcon.IsConnected())
			return
		var/voted = 0

		//First check if the person has not voted yet.
		var/DBQuery/query = dbcon.NewQuery("SELECT * FROM erro_privacy WHERE ckey='[src.ckey]'")
		query.Execute()
		while(query.NextRow())
			voted = 1
			break

		//This is a safety switch, so only valid options pass through
		var/option = "UNKNOWN"
		switch(href_list["privacy_poll"])
			if("signed")
				option = "SIGNED"
			if("anonymous")
				option = "ANONYMOUS"
			if("nostats")
				option = "NOSTATS"
			if("later")
				close_browser(usr, "window=privacypoll")
				return
			if("abstain")
				option = "ABSTAIN"

		if(option == "UNKNOWN")
			return

		if(!voted)
			var/sql = "INSERT INTO erro_privacy VALUES (null, Now(), '[src.ckey]', '[option]')"
			var/DBQuery/query_insert = dbcon.NewQuery(sql)
			query_insert.Execute()
			to_chat(usr, "<b>Thank you for your vote!</b>")
			close_browser(usr, "window=privacypoll")

	if(!ready && href_list["preference"])
		if(client)
			client.prefs.process_link(src, href_list)
//	else if(!href_list["late_join"])
//		new_player_panel()

	if(href_list["showpoll"])

		handle_player_polling()
		return

	if(href_list["pollid"])

		var/pollid = href_list["pollid"]
		if(istext(pollid))
			pollid = text2num(pollid)
		if(isnum(pollid))
			src.poll_player(pollid)
		return

	if(href_list["votepollid"] && href_list["votetype"])
		var/pollid = text2num(href_list["votepollid"])
		var/votetype = href_list["votetype"]
		switch(votetype)
			if("OPTION")
				var/optionid = text2num(href_list["voteoptionid"])
				vote_on_poll(pollid, optionid)
			if("TEXT")
				var/replytext = href_list["replytext"]
				log_text_poll_reply(pollid, replytext)
			if("NUMVAL")
				var/id_min = text2num(href_list["minid"])
				var/id_max = text2num(href_list["maxid"])

				if( (id_max - id_min) > 100 )	//Basic exploit prevention
					to_chat(usr, "The option ID difference is too big. Please contact administration or the database admin.")
					return

				for(var/optionid = id_min; optionid <= id_max; optionid++)
					if(!isnull(href_list["o[optionid]"]))	//Test if this optionid was replied to
						var/rating
						if(href_list["o[optionid]"] == "abstain")
							rating = null
						else
							rating = text2num(href_list["o[optionid]"])
							if(!isnum(rating))
								return

						vote_on_numval_poll(pollid, optionid, rating)
			if("MULTICHOICE")
				var/id_min = text2num(href_list["minoptionid"])
				var/id_max = text2num(href_list["maxoptionid"])

				if( (id_max - id_min) > 100 )	//Basic exploit prevention
					to_chat(usr, "The option ID difference is too big. Please contact administration or the database admin.")
					return

				for(var/optionid = id_min; optionid <= id_max; optionid++)
					if(!isnull(href_list["option_[optionid]"]))	//Test if this optionid was selected
						vote_on_poll(pollid, optionid, 1)

/mob/new_player/proc/newCharacterPanel()
	var/data = "<div align='center'><br>"
	data += "<b>Select the slot you want to save this character under.</b><br>"

	for(var/ind = 1, ind <= client.prefs.Slots(), ind++)
		var/characterName = SScharacter_setup.peek_character_name(ind, ckey)
		if(characterName)
			data += "<b>[characterName]</b><br>"
		else
			data += "<b><a href='byond://?src=\ref[src];pickSlot=[ind]create'>Open Slot</a></b><br>"

	data += "</div>"
	load_panel = new(src, "Create Character", "Create Character", 300, 500, src)
	load_panel.set_content(data)
	load_panel.open()

/mob/new_player/proc/ImportCharacter()
	var/found_slot = 0
	if(!chosen_slot)
		return 0
	for(var/ind = 1, ind <= client.prefs.Slots(), ind++)
		var/characterName = SScharacter_setup.peek_import_name(ind, ckey)
		if(!characterName)
			found_slot = ind
			break
	if(!found_slot)
		to_chat(src, "Your character slots are full. Import failed.")
	var/mob/character = SScharacter_setup.load_import_character(chosen_slot, ckey)
	if(!character)
		return
	var/list/L = recursive_content_check(character)
	var/list/spared = list()
	for(var/ind in 1 to L.len)
		var/atom/A = L[ind]
		if(istype(A, /obj/item/clothing/accessory/toggleable/hawaii))
			var/obj/item/clothing/accessory/toggleable/hawaii = A
			hawaii.has_suit = null
			spared |= A
		if(istype(A, /obj/item/weapon/paper))
			spared |= A
		if(istype(A, /obj/item/weapon/photo))
			spared |= A
	for(var/obj/item/W in character)
		character.drop_from_inventory(W)
	character.spawn_type = CHARACTER_SPAWN_TYPE_FRONTIER_BEACON //For first time spawn
	if(!character.mind)
		character.mind = new()
	client.prefs.setup_new_accounts(character) //make accounts before! Outfit setup needs the record set
	var/decl/hierarchy/outfit/clothes = new()
	clothes.uniform = /obj/item/clothing/under/color/lightpurple
	clothes.shoes = /obj/item/clothing/shoes/brown
		//The outfit class does most of the equipping from preferences, along with the ID setup, backpack setup, etc.. Its really handy
	clothes.equip(character)

	var/obj/item/weapon/card/id/W = new (character)
	W.registered_name = character.real_name
	W.selected_faction = "nexus"
	character.equip_to_slot_or_store_or_drop(character, slot_wear_id)
	for(var/ind in 1 to spared.len)
		var/atom/A = spared[ind]
		character.equip_to_slot_or_store_or_drop(A, slot_l_hand)
	SScharacter_setup.save_character(found_slot, client.ckey, character)

/mob/new_player/proc/selectImportPanel()
	var/data = "<div align='center'><br>"
	data += "<b>Select the character you want to import.</b><br>"


	for(var/ind = 1, ind <= client.prefs.Slots(), ind++)
		var/characterName = SScharacter_setup.peek_import_name(ind, ckey)
		if(characterName)
			var/icon/preview = SScharacter_setup.peek_import_icon(ind, ckey)
			if(preview)
				send_rsc(src, preview, "[ind]preview.png")
			data += "<img src=[ind]preview.png width=[preview.Width()] height=[preview.Height()]><br>"
			data += "<b><a href='?src=\ref[src];importSlot=[ind]'>[characterName]</a></b><hr>"
	data += "</div>"
	load_panel = new(src, "Select Character", "Select Character", 300, 500, src)
	load_panel.set_content(data)
	load_panel.open()


/mob/new_player/proc/selectCharacterPanel(var/action = "")
	for(var/mob/M in SSmobs.mob_list)
		if(M.loc && !M.perma_dead && M.type != /mob/new_player && (M.stored_ckey == ckey || M.stored_ckey == "@[ckey]"))
			chosen_slot = M.save_slot
			to_chat(src, "<span class='notice'>A character is already in game.</span>")
			Retrieve_Record(M.real_name)
			if(GAME_STATE == RUNLEVEL_GAME)
				panel?.close()
				load_panel?.close()
				M.key = key
			else
				to_chat(src, "<span class='notice'>Wait until the round starts to join.</span>")
			return

	var/data = "<div align='center'><br>"
	data += "<b>Select the character you want to [action].</b><br>"

	for(var/ind = 1, ind <= client.prefs.Slots(), ind++)
		var/characterName = SScharacter_setup.peek_character_name(ind, ckey)
		if(characterName)
			var/icon/preview = SScharacter_setup.peek_character_icon(ind, ckey)
			if(preview)
				send_rsc(src, preview, "[ind]preview.png")
			data += "<img src=[ind]preview.png width=[preview.Width()] height=[preview.Height()]><br>"
			data += "<b><a href='?src=\ref[src];pickSlot=[ind][action]'>[characterName]</a></b><hr>"
		else
			data += "<b>Open Slot</b><hr>"
	data += "</div>"
	load_panel = new(src, "Select Character", "Select Character", 300, 500, src)
	load_panel.set_content(data)
	load_panel.open()


/mob/new_player/proc/observeGame()
	chosen_slot = -1
	loadCharacter()

//Stops the lobby music and close the main menu panels
/mob/new_player/proc/transitionToGame()
	panel?.close()
	load_panel?.close()
	sound_to(src, sound(null, repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel))

/mob/new_player/proc/loadCharacter()
	if(!config.enter_allowed && !check_rights(R_ADMIN|R_MENTOR|R_MOD, 0, src))
		to_chat(usr, "<span class='notice'>There is an administrative lock on entering the game!</span>")
		return
	if(!chosen_slot)
		return
	if(spawning)
		return

	spawning = TRUE

	//Resume playing
	for(var/mob/M in SSmobs.mob_list)
		transitionToGame() //Don't forget to close the panel and stop the lobby music
		if(M.loc && !M.perma_dead && M.type != /mob/new_player && (M.stored_ckey == ckey || M.stored_ckey == "@[ckey]"))
			if(istype(M, /mob/observer))
				qdel(M)
				continue
			M.ckey = ckey
			qdel(src)
			return

	//Observer Spawn
	if(chosen_slot == -1)
		transitionToGame() //Don't forget to close the panel and stop the lobby music
		var/mob/observer/ghost/observer = new()
		observer.started_as_observer = 1
		observer.forceMove(GLOB.cryopods.len ? get_turf(pick(GLOB.cryopods)) : locate(100, 100, 1))
		observer.ckey = ckey
		qdel(src)
		return

	var/mob/character = SScharacter_setup.load_character(chosen_slot, ckey)
	Retrieve_Record(character.real_name)
	var/turf/spawnTurf = locate(0,0,0) //Instead of null start with 0,0,0 because the unsafe spawn check will kick in and warn the user if there's something wrong

	if(character.spawn_type == CHARACTER_SPAWN_TYPE_CRYONET)
		var/datum/world_faction/faction = get_faction(character.spawn_loc)
		var/assignmentSpawnLocation = faction?.get_assignment(faction?.get_record(character.real_name)?.assignment_uid, character.real_name)?.cryo_net
		if (assignmentSpawnLocation == "Last Known Cryonet")
			// The character's assignment is set to spawn in their last cryo location
			// Do nothing, leave it the way it is.
		else if (assignmentSpawnLocation)
			// The character has a special cryo network set to override their normal spawn location
			character.spawn_loc_2 = assignmentSpawnLocation
		else
			// The character doesn't have a spawn_loc_2, so use the one for their assignment or the default
			character.spawn_loc_2 = " default"

		for(var/obj/machinery/cryopod/pod in GLOB.cryopods)
			if(!pod.loc)
				qdel(pod)
				continue
			if(pod.req_access_faction == character.spawn_loc)
				if(pod.network == character.spawn_loc_2)
					spawnTurf = get_turf(pod)
					break
				else
					spawnTurf = get_turf(pod)
			else if(!spawnTurf)
				spawnTurf = get_turf(pod)

		if(!spawnTurf)
			log_and_message_admins("WARNING! No cryopods avalible for spawning! Get some spawned and connected to the starting factions uid (req_access_faction)")
			spawnTurf = locate(102, 98, 1)

	else if(character.spawn_type == CHARACTER_SPAWN_TYPE_FRONTIER_BEACON)
		for(var/obj/structure/frontier_beacon/beacon in GLOB.frontierbeacons)
			if(!beacon.loc)
				qdel(beacon)
				continue
			if(beacon.req_access_faction == character.spawn_loc)
				spawnTurf = get_turf(beacon)//get_step(get_turf(beacon), pick(GLOB.cardinal)) //Set it to get turf because otherwise people spawn in the walls
				break
			if(!spawnTurf)
				spawnTurf = get_turf(beacon)//get_step(get_turf(beacon), pick(GLOB.cardinal)) //Set it to get turf because otherwise people spawn in the walls

		if(!spawnTurf)
			log_and_message_admins("WARNING! No frontier beacons avalible for spawning! Get some spawned and connected to the starting factions uid (req_access_faction)")
			spawnTurf = locate(102, 98, 1)

	else if(character.spawn_type == CHARACTER_SPAWN_TYPE_LACE_STORAGE)
		spawnTurf = GetLaceStorage(character)
		if(!spawnTurf)
			log_and_message_admins("WARNING! Unable To Find Any Spawn Turf!!! Prehaps you didn't include a map?")
			return

	//If the atmos is bad or etc.. Ask the player if they still want to spawn!
	if(!SSjobs.check_unsafe_spawn(character, spawnTurf))
		spawning = FALSE
		return

	//Close the menu and stop the lobby music once we're sure we're spawning
	transitionToGame()
	character.after_spawn()

	if(!character.mind)		// Not entirely sure what this if() block does, but keeping it just in case
		mind.active = 0
		mind.original = character
		if(client && client.prefs.memory)
			mind.store_memory(client.prefs.memory)
		if(client.prefs.relations.len)
			for(var/T in client.prefs.relations)
				var/TT = matchmaker.relation_types[T]
				var/datum/relation/R = new TT
				R.holder = mind
				R.info = client.prefs.relations_info[T]
			mind.gen_relations_info = client.prefs.relations_info["general"]
		mind.transfer_to(character)					//won't transfer key since the mind is not active

	character.forceMove(spawnTurf)
	character.stored_ckey = key
	character.key = key
	character.save_slot = chosen_slot

	//Make sure dna is spread to limbs
	character.dna.ready_dna(character)
	character.sync_organ_dna()

	GLOB.minds |= character.mind
	character.regenerate_icons()
	character.update_inv_back()
	character.update_inv_wear_id()
	character.update_inv_belt()
	character.update_inv_pockets()
	character.update_inv_l_hand()
	character.update_inv_r_hand()
	character.update_inv_s_store()
	character.redraw_inv()

	//Execute post-spawn stuff
	character.finishLoadCharacter()	// This is ran because new_players don't like to stick around long.
	return 1

//Runs what happens after the character is loaded. Mainly for cinematics and lore text.
/mob/proc/finishLoadCharacter()
	if(spawn_type == CHARACTER_SPAWN_TYPE_CRYONET)
		to_chat(src, "You eject from your cryosleep, ready to resume life in the frontier.")
	else if(spawn_type == CHARACTER_SPAWN_TYPE_FRONTIER_BEACON)
		GLOB.using_map.on_new_spawn(src) //Moved to overridable map specific code
	else if(spawn_type == CHARACTER_SPAWN_TYPE_LACE_STORAGE)
		to_chat(src, "You regain consciousness, still prisoner of your neural lace.")

/mob/new_player/proc/deleteCharacter()
	var/charname = SScharacter_setup.peek_character_name(chosen_slot, ckey)
	if(input("Are you SURE you want to delete [charname]? THIS IS PERMANENT. enter the character\'s full name to conform.", "DELETE A CHARACTER", "") == charname)
		SScharacter_setup.delete_character(chosen_slot, ckey)
	load_panel.close()

/mob/new_player/proc/crewManifestPanel()
	var/list/factions = list()

	for(var/obj/item/organ/internal/stack/stack in GLOB.neural_laces)
		if(!stack.loc) continue
		var/faction = get_faction(stack.connected_faction)?.name
		if(factions["[faction]"])
			factions["[faction]"] += stack
		else
			factions["[faction]"] = list(stack)

	var/data = "<div align='center'><br>"

	for(var/faction in factions)
		data += "<table width=150px>"
		data += "<tr class='title'><th colspan=3>[faction]</th></tr>"
		data += "<tr class='title'><th>Name</th><th>Status</th></tr>"
		var/ind = 0
		for(var/obj/item/organ/internal/stack/stack in factions[faction])
			data += "<tr[ind ? " class='alt'" : " class='norm'"]><td>[stack.get_owner_name()]</td><td>[stack.duty_status ? "On Duty" : "Off Duty"]</td></tr>"
			ind = !ind
		data += "</table>"

	data += "</div>"
	load_panel = new(src, "Crew Manifest", "Crew Manifest", 300, 500, src)
	load_panel.set_content(data)
	load_panel.open()

// /mob/new_player/proc/create_character(var/turf/spawn_turf)
// 	spawning = 1
// 	close_spawn_windows()

// 	var/mob/living/carbon/human/new_character

// 	var/datum/species/chosen_species
// 	if(client.prefs.species)
// 		chosen_species = all_species[client.prefs.species]

// 	if(!spawn_turf)
// 		var/datum/job/job = SSjobs.get_by_title(mind.assigned_role)
// 		if(!job)
// 			job = SSjobs.get_by_title(GLOB.using_map.default_assistant_title)
// 		var/datum/spawnpoint/spawnpoint = job.get_spawnpoint(client, client.prefs.ranks[job.title])
// 		spawn_turf = pick(spawnpoint.turfs)

// 	if(chosen_species)
// 		if(!check_species_allowed(chosen_species))
// 			spawning = 0 //abort
// 			return null
// 		new_character = new(spawn_turf, chosen_species.name)
// 		if(chosen_species.has_organ[BP_POSIBRAIN] && client && client.prefs.is_shackled)
// 			var/obj/item/organ/internal/posibrain/B = new_character.internal_organs_by_name[BP_POSIBRAIN]
// 			if(B)	B.shackle(client.prefs.get_lawset())

// 	if(!new_character)
// 		new_character = new(spawn_turf)

// 	new_character.lastarea = get_area(spawn_turf)

// 	if(GLOB.random_players)
// 		client.prefs.gender = pick(MALE, FEMALE)
// 		client.prefs.real_name = random_name(new_character.gender)
// 		client.prefs.randomize_appearance_and_body_for(new_character)
// 	client.prefs.copy_to(new_character)

// 	sound_to(src, sound(null, repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel))// MAD JAMS cant last forever yo

// 	if(mind)
// 		mind.active = 0 //we wish to transfer the key manually
// 		mind.original = new_character
// 		if(client.prefs.memory)
// 			mind.store_memory(client.prefs.memory)
// 		if(client.prefs.relations.len)
// 			for(var/T in client.prefs.relations)
// 				var/TT = matchmaker.relation_types[T]
// 				var/datum/relation/R = new TT
// 				R.holder = mind
// 				R.info = client.prefs.relations_info[T]
// 			mind.gen_relations_info = client.prefs.relations_info["general"]
// 		mind.transfer_to(new_character)					//won't transfer key since the mind is not active

// 	new_character.dna.ready_dna(new_character)
// 	new_character.dna.b_type = client.prefs.b_type
// 	new_character.sync_organ_dna()
// 	if(client.prefs.disabilities)
// 		// Set defer to 1 if you add more crap here so it only recalculates struc_enzymes once. - N3X
// 		new_character.dna.SetSEState(GLOB.GLASSESBLOCK,1,0)
// 		new_character.disabilities |= NEARSIGHTED

// 	// Give them their cortical stack if we're using them.
// 	if(config && config.use_cortical_stacks && client && client.prefs.has_cortical_stack /*&& new_character.should_have_organ(BP_BRAIN)*/)
// 		new_character.create_stack()

// 	// Do the initial caching of the player's body icons.
// 	new_character.force_update_limbs()
// 	new_character.update_eyes()
// 	new_character.regenerate_icons()

// 	new_character.key = key		//Manually transfer the key to log them in
// 	return new_character

/mob/new_player/Move()
	return 0

/mob/new_player/proc/close_spawn_windows()
	close_browser(src, "window=latechoices") //closes late choices window
	panel.close()

/mob/new_player/proc/check_species_allowed(datum/species/S, var/show_alert=1)
	if(!S.is_available_for_join() && !has_admin_rights())
		if(show_alert)
			to_chat(src, alert("Your current species, [client.prefs.species], is not available for play."))
		return 0
	if(!is_alien_whitelisted(src, S))
		if(show_alert)
			to_chat(src, alert("You are currently not whitelisted to play [client.prefs.species]."))
		return 0
	return 1

/mob/new_player/get_species()
	var/datum/species/chosen_species
	if(client.prefs.species)
		chosen_species = all_species[client.prefs.species]

	if(!chosen_species || !check_species_allowed(chosen_species, 0))
		return SPECIES_HUMAN

	return chosen_species.name

/mob/new_player/get_gender()
	if(!client || !client.prefs) ..()
	return client.prefs.gender

/mob/new_player/is_ready()
	return ready && ..()

/mob/new_player/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null)
	return

/mob/new_player/hear_radio(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/part_c, var/mob/speaker = null, var/hard_to_hear = 0)
	return

/mob/new_player/show_message(msg, type, alt, alt_type)
	return

mob/new_player/MayRespawn()
	return 1

/mob/new_player/touch_map_edge()
	return

/mob/new_player/say(var/message)
	sanitize_and_communicate(/decl/communication_channel/ooc, client, message)
