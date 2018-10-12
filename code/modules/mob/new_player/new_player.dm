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
	canmove = 0

	anchored = 1	//  don't get pushed around

	virtual_mob = null // Hear no evil, speak no evil

	// Persitent Edit, chosen slot
	var/chosen_slot = 0

/mob/new_player/New()
	..()

/mob/new_player/verb/newPlayerPanel()
	set src = usr

	var/output = "<div align='center'><hr><br>"
	output += "<a href='byond://?src=\ref[src];createCharacter=1'>Create A New Character</a><br><br>"

	if(ticker?.current_state <= GAME_STATE_PREGAME)
		output += "<span class='average'><b>The Game Is Loading!</b></span><br><br>"
	else
		output += "<a href='byond://?src=\ref[src];joinGame=1'>Join Game!</a><br><br>"

	if(check_rights(R_DEBUG, 0, client))
		output += "<a href='byond://?src=\ref[src];observeGame=1'>Observe</a><br><br>"

	output += "<a href='byond://?src=\ref[src];deleteCharacter=1'>Delete A Character</a><br><br>"
	output += "<a href='byond://?src=\ref[src];refreshPanel=1'>Refresh</a><br><br>"
	output += "<hr></div>"

	panel = new(src, "Persistent SS13","Persistent SS13", 250, 350, src)
	panel.set_window_options("can_close=0")
	panel.set_content(output)
	panel.open()
	return

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

	if(href_list["refreshPanel"])
		panel.close()
		newPlayerPanel()
		return 0

	if(href_list["pickSlot"])
		chosen_slot = text2num(copytext(href_list["pickSlot"], 1, 2))
		client.prefs.chosen_slot = chosen_slot
		load_panel?.close()
		switch(copytext(href_list["pickSlot"], 2))
			if("create")
				client.prefs.ShowChoices(src)
			if("load")
				loadCharacter()
			if("delete")
				deleteCharacter()
		return 0

	if(href_list["preference"])
		client.prefs.process_link(src, href_list)
		client.prefs.randomize_appearance_and_body_for()
		client.prefs.real_name = null
		client.prefs.preview_icon = null
		client.prefs.home_system = null
		client.prefs.faction = null
		client.prefs.selected_under = null
		client.prefs.sanitize_preferences()
/mob/new_player/proc/newCharacterPanel()
	var/data = "<div align='center'><br>"
	data += "<b>Select the slot you want to save this character under.</b><br>"

	for(var/ind = 1, ind <= client.prefs.Slots(), ind++)
		var/characterName = CharacterName(ind, ckey)
		if(characterName)
			data += "<b>[characterName]</b><br>"
		else
			data += "<b><a href='byond://?src=\ref[src];pickSlot=[ind]create'>Open Slot</a></b><br>"

	data += "</div>"
	load_panel = new(src, "Create Character", "Create Character", 300, 500, src)
	load_panel.set_content(data)
	load_panel.open()

/mob/new_player/proc/selectCharacterPanel(var/action = "")
	for(var/mob/M in SSmobs.mob_list)
		if(M.loc && !M.perma_dead && M.type != /mob/new_player && (M.stored_ckey == ckey || M.stored_ckey == "@[ckey]"))
			chosen_slot = M.save_slot
			to_chat(src, "<span class='notice'>A character is already in game.</span>")
			if(ticker.current_state > GAME_STATE_PREGAME)
				panel?.close()
				load_panel?.close()
				M.key = key
			else
				to_chat(src, "<span class='notice'>Wait until the round starts to join.</span>")
			return

	var/data = "<div align='center'><br>"
	data += "<b>Select the character you want to [action].</b><br>"

	for(var/ind = 1, ind <= client.prefs.Slots(), ind++)
		var/characterName = CharacterName(ind, ckey)
		if(characterName)
			var/icon/preview = CharacterIcon(ind, ckey)
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

/mob/new_player/proc/observeGame()
	chosen_slot = -1
	loadCharacter()

/mob/new_player/proc/loadCharacter()
	if(!config.enter_allowed && !check_rights(R_ADMIN|R_MENTOR|R_MOD, 0, src))
		to_chat(usr, "<span class='notice'>There is an administrative lock on entering the game!</span>")
		return

	if(!chosen_slot)
		return

	if(spawning)
		return

	spawning = 1

	panel?.close()
	load_panel?.close()

	sound_to(src, sound(null, repeat = 0, wait = 0, volume = 85, channel = 1))

	for(var/mob/M in SSmobs.mob_list)
		if(M.loc && !M.perma_dead && M.type != /mob/new_player && (M.stored_ckey == ckey || M.stored_ckey == "@[ckey]"))
			if(istype(M, /mob/observer))
				qdel(M)
				continue
			M.ckey = ckey
			qdel(src)
			return

	if(chosen_slot == -1)
		var/mob/observer/ghost/observer = new()
		observer.started_as_observer = 1
		observer.forceMove(GLOB.cryopods.len ? get_turf(pick(GLOB.cryopods)) : locate(100, 100, 1))
		observer.ckey = ckey
		qdel(src)
		return

	var/mob/character = Character(chosen_slot, ckey)

	var/turf/spawnTurf


	if(character.spawn_type == 1)
		var/datum/world_faction/faction = get_faction(character.spawn_loc)
		var/assignmentSpawnLocation = faction?.get_assignment(faction?.get_record(character.real_name)?.assignment_uid)?.cryo_net
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

		to_chat(character, "You eject from your cryosleep, ready to resume life in the frontier.")

	else if(character.spawn_type == 2)
		for(var/obj/structure/frontier_beacon/beacon in GLOB.frontierbeacons)
			if(!beacon.loc)
				qdel(beacon)
				continue
			if(beacon.req_access_faction == character.spawn_loc)
				spawnTurf = get_step(get_turf(beacon), pick(GLOB.cardinal))
				break
			if(!spawnTurf)
				spawnTurf = get_step(get_turf(beacon), pick(GLOB.cardinal))

		if(!spawnTurf)
			log_and_message_admins("WARNING! No frontier beacons avalible for spawning! Get some spawned and connected to the starting factions uid (req_access_faction)")
			spawnTurf = locate(102, 98, 1)
		new /obj/effect/portal(spawnTurf, delete_after = 50)

	if(!spawnTurf)
		log_and_message_admins("WARNING! Unable To Find Any Spawn Turf!!! Prehaps you didn't include a map?")
		return

	character.after_spawn()

	if(!character.mind)		// Not entirely sure what this if() block does, but keeping it just in case
		mind.active = 0
		mind.original = character
		if(client && client.prefs.memory)
			mind.store_memory(client.prefs.memory)
			mind.transfer_to(character)

	character.forceMove(spawnTurf)
	character.stored_ckey = key
	character.key = key
	character.save_slot = chosen_slot

	ticker.minds |= character.mind
	character.redraw_inv()
	CreateModularRecord(character)
	character.finishLoadCharacter()	// This is ran because new_players don't like to stick around long.
	return 1

/mob/proc/finishLoadCharacter()
	if(spawn_type == 2)
		var/obj/screen/cinematic

		cinematic = new
		cinematic.icon = 'icons/effects/gateway_intro.dmi'
		cinematic.icon_state = "blank"
		cinematic.plane = HUD_PLANE
		cinematic.layer = HUD_ABOVE_ITEM_LAYER
		cinematic.mouse_opacity = 2
		cinematic.screen_loc = "WEST,SOUTH"

		if(client)
			client.screen += cinematic

			flick("neurallaceboot",cinematic)
			sleep(106)
			client.screen -= cinematic

		spawn_type = 1
		sound_to(src, sound('sound/music/brandon_morris_loop.ogg', repeat = 0, wait = 0, volume = 85, channel = 1))
		spawn()
			shake_camera(src, 3, 1)
		druggy = 3
		Weaken(3)
		to_chat(src, "<span class='danger'>Your trip through the frontier gateway is like nothing you have ever experienced!</span>")
		to_chat(src, "In fact, it was like your consciousness was ripped from your body and then hammered back inside moments later.")
		to_chat(src, "However, you've made it to the uncharted frontier. You don't know when you'll be able to return to the places you've left behind.")
		to_chat(src, "No time to think about that, your first priority is to get your bearings and find a job that pays. Whatever you decide to do in this new frontier, you're going to need a lot more cash than what you have now.")
	else
		to_chat(src, "You eject from your cryosleep, ready to resume life in the frontier.")

/mob/new_player/proc/deleteCharacter()
	if(input("Are you SURE you want to delete [CharacterName(chosen_slot, ckey)]? THIS IS PERMANENT. enter the character\'s full name to conform.", "DELETE A CHARACTER", "") == CharacterName(chosen_slot, ckey))
		fdel(load_path(ckey, "[chosen_slot].sav"))
	load_panel.close()

/mob/new_player/Move()
	return 0

/mob/new_player/proc/has_admin_rights()
	return check_rights(R_ADMIN, 0, src)

/mob/new_player/proc/check_species_allowed(datum/species/S, var/show_alert=1)
	if(!(S.spawn_flags & SPECIES_CAN_JOIN) && !has_admin_rights())
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

/mob/new_player/Stat()
	. = ..()

	if(statpanel("Lobby") && ticker)
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
