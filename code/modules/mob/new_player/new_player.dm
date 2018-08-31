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
	verbs += /mob/proc/toggle_antag_pool

/mob/new_player/verb/new_player_panel()
	set src = usr
	new_player_panel_proc()

/mob/new_player/proc/new_player_panel_proc()
	var/output = "<div align='center'>"
	output +="<hr>"
	output += "<p><a href='byond://?src=\ref[src];show_preferences=1'>Create A New Character</A></p>"

	if(!ticker || ticker.current_state <= GAME_STATE_PREGAME)
		if(ready)
			output += "<p>\[ <span class='linkOn'><b>Ready</b></span> | <a href='byond://?src=\ref[src];ready=0'>Not Ready</a> \]</p>"
		else
			output += "<p>\[ <a href='byond://?src=\ref[src];ready=1'>Ready</a> | <span class='linkOn'><b>Not Ready</b></span> \]</p>"

	else
		output += "<a href='byond://?src=\ref[src];manifest=1'>View the Crew Manifest</A><br><br>"
		output += "<p><a href='byond://?src=\ref[src];late_join=1'>Join Game!</A></p>"

//	output += "<p><a href='byond://?src=\ref[src];observe=1'>Observe</A></p>"
	output += "<br><p><a href='byond://?src=\ref[src];delete_char=1'>Delete a Character</A></p>"
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

	panel = new(src, "Persistent SS13","Persistent SS13", 210, 300, src)
	panel.set_window_options("can_close=0")
	panel.set_content(output)
	panel.open()
	return

/mob/new_player/proc/slot_select_load()
	if(ticker.current_state < GAME_STATE_PREGAME) return 0
	var/slots = config.character_slots
	if(!client.prefs.character_list || (client.prefs.character_list.len < slots))
		client.prefs.load_characters()
		sleep(20)
		return slot_select_load()
	for(var/mob/loaded_mob in SSmobs.mob_list)
		if(!loaded_mob.perma_dead && loaded_mob.type != /mob/new_player && (loaded_mob.saved_ckey == ckey || loaded_mob.saved_ckey == "@[ckey]") && get_turf(loaded_mob))
			if(ticker.current_state <= GAME_STATE_PREGAME)
				to_chat(src, "A character is already in game, selecting on start")
				ready = 1
				close_spawn_windows()
				new_player_panel_proc()
				return 0
			else
				close_spawn_windows()
				loaded_mob.ckey = ckey
				loaded_mob.saved_ckey = ""
				sound_to(src, sound(null, repeat = 0, wait = 0, volume = 85, channel = 1)) // MAD JAMS cant last forever yo
				qdel(src)
				return 0
	var/mob/user = src
	
	if(check_rights(R_ADMIN, 0, client))
		slots += 2
	slots += client.prefs.bonus_slots
	
	var/dat  = list()
	dat += "<body>"
	dat += "<tt><center>"
	dat += "<b>Select the character you want to load</b><hr>"
	var/ind = 0
	for(var/x in client.prefs.character_list)
		ind++
		var/mob/M = x
		if(istype(M))
			var/icon/ico = client.prefs.get_preview_icon(M)
			user << browse_rsc(ico, "[ind]preview.png")
			dat += "<center><img src=[ind]preview.png width=[ico.Width()] height=[ico.Height()]></center><br>"
			dat += "<b><a href='?src=\ref[src];pickslot_load=[ind]'>[M.real_name]</a></b><hr>"
		else
			dat += "Open Slot [ind]<hr>"
	dat += "<hr>"
	dat += "</center></tt>"
	load_panel = new(user, "Character Slots", "Character Slots", 300, 500, src)
	load_panel.set_content(jointext(dat,null))
	load_panel.open()
/mob/new_player/proc/slot_select_delete()
	var/mob/user = src
	var/slots = config.character_slots
	if(check_rights(R_ADMIN, 0, client))
		slots += 2
	slots += client.prefs.bonus_slots
	if(!client.prefs.character_list || (client.prefs.character_list.len < slots))
		client.prefs.load_characters()

	var/dat  = list()
	dat += "<body>"
	dat += "<tt><center>"
	dat += "<b>Select the character you want to delete</b><hr>"
	var/ind = 0
	for(var/x in client.prefs.character_list)
		ind++
		var/mob/M = x
		if(istype(M))
			var/icon/ico = client.prefs.get_preview_icon(M)
			user << browse_rsc(ico, "[ind]preview.png")
			dat += "<center><img src=[ind]preview.png width=[ico.Width()] height=[ico.Height()]></center><br>"
			dat += "<b><a href='?src=\ref[src];pickslot_delete=[ind]'>[M.real_name]</a></b><hr>"
		else
			dat += "Open Slot [ind]<hr>"
	dat += "<hr>"
	dat += "</center></tt>"
	load_panel = new(user, "Character Slots", "Character Slots", 300, 500, src)
	load_panel.set_content(jointext(dat,null))
	load_panel.open()

/mob/new_player/Stat()
	. = ..()

	if(statpanel("Lobby") && ticker)
		if(check_rights(R_INVESTIGATE, 0, src))
			stat("Game Mode:", "[ticker.mode || master_mode][ticker.hide_mode ? " (Secret)" : ""]")
		else
			stat("Game Mode:", PUBLIC_GAME_MODE)
		var/extra_antags = list2params(additional_antag_types)
		stat("Added Antagonists:", extra_antags ? extra_antags : "None")

		if(ticker.current_state == GAME_STATE_PREGAME)
			stat("Time To Start:", "[ticker.pregame_timeleft][round_progressing ? "" : " (DELAYED)"]")
			stat("Players: [totalPlayers]", "Players Ready: [totalPlayersReady]")
			totalPlayers = 0
			totalPlayersReady = 0
			for(var/mob/new_player/player in GLOB.player_list)
				var/highjob
				if(player.client && player.client.prefs && player.client.prefs.job_high)
					highjob = " as [player.client.prefs.job_high]"
				stat("[player.key]", (player.ready)?("(Playing[highjob])"):(null))
				totalPlayers++
				if(player.ready)totalPlayersReady++

/mob/new_player/Topic(href, href_list[])
	if(!client)	return 0

	if(href_list["show_preferences"])
		client.prefs.slot_select(src)
		return 0
	if(href_list["pickslot_load"])
		src << browse(null, "window=saves")
		chosen_slot = text2num(href_list["pickslot_load"])
		var/mob/M = client.prefs.character_list[chosen_slot]
		if(M.perma_dead)
			to_chat(usr, "This character is permanently dead. Your only option is to delete it and remake a new character.")
		for(var/mob/mobbie in GLOB.all_cryo_mobs)
			if(mobbie.real_name == M.real_name)
				client.prefs.character_list[chosen_slot] = mobbie
		load_panel.close()
		panel.close()
		if(ticker.current_state <= GAME_STATE_PREGAME)
			ready = 1
			load_panel.close()
			new_player_panel_proc()
		else
			close_spawn_windows()
			AttemptLateSpawn()
		return 0
	if(href_list["pickslot_delete"])

		chosen_slot = text2num(href_list["pickslot_delete"])
		var/mob/M = client.prefs.character_list[chosen_slot]
		if(input("Are you SURE you want to delete [M.real_name]. THIS IS PERMANENT. Enter the characters full name to confirm","DELETE A CHARACTER","") == M.real_name)
			src << browse(null, "window=saves")
			for(var/mob/mobbie in GLOB.all_cryo_mobs)
				if(mobbie.real_name == M.real_name)
					GLOB.all_cryo_mobs -= mobbie
					qdel(mobbie)
			client.prefs.delete_character(chosen_slot)
			load_panel.close()
		return 0
	if(href_list["ready"])
		ready = text2num(href_list["ready"])
		slot_select_load()
		return 0
	//	if(!ticker || ticker.current_state <= GAME_STATE_PREGAME) // Make sure we don't ready up after the round has started
	//		ready = text2num(href_list["ready"])
	//	else
	//		ready = 0

	if(href_list["refresh"])
		panel.close()
		new_player_panel_proc()
		return 0
	if(href_list["observe"])
		if(!(initialization_stage&INITIALIZATION_COMPLETE))
			to_chat(src, "<span class='warning'>Please wait for server initialization to complete...</span>")
			return

		if(!config.respawn_delay || client.holder || alert(src,"Are you sure you wish to observe? You will have to wait [config.respawn_delay] minute\s before being able to respawn!","Player Setup","Yes","No") == "Yes")
			if(!client)	return 1
			var/mob/observer/ghost/observer = new()

			spawning = 1
			sound_to(src, sound(null, repeat = 0, wait = 0, volume = 85, channel = 1))// MAD JAMS cant last forever yo


			observer.started_as_observer = 1
			close_spawn_windows()

			if(GLOB.cryopods.len)
				var/obj/O = pick(GLOB.cryopods)
				to_chat(src, "<span class='notice'>Now teleporting.</span>")
				observer.forceMove(get_step(O.loc, O.dir))
			else
				to_chat(src, "<span class='danger'>Could not locate an observer spawn point. Use the Teleport verb to jump to the map.</span>")
			observer.timeofdeath = world.time // Set the time of death so that the respawn timer works correctly.

			if(isnull(client.holder))
				announce_ghost_joinleave(src)

			var/mob/living/carbon/human/dummy/mannequin = new()
			client.prefs.dress_preview_mob(mannequin)
			observer.set_appearance(mannequin)
			qdel(mannequin)

			if(client.prefs.be_random_name)
				client.prefs.real_name = random_name(client.prefs.gender)
			observer.real_name = client.prefs.real_name
			observer.name = observer.real_name
			if(!client.holder && !config.antag_hud_allowed)           // For new ghosts we remove the verb from even showing up if it's not allowed.
				observer.verbs -= /mob/observer/ghost/verb/toggle_antagHUD        // Poor guys, don't know what they are missing!
			observer.key = key
			qdel(src)

			return 1

	if(href_list["late_join"])
		slot_select_load()
		return 0
	//	if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
	//		to_chat(usr, "<span class='warning'>The round is either not ready, or has already finished...</span>")
	//		return
	//	LateChoices() //show the latejoin job selection menu
	if(href_list["delete_char"])
		slot_select_delete()
		return 0
	if(href_list["manifest"])
		ViewManifest()

	if(href_list["SelectedJob"])
		var/datum/job/job = job_master.GetJob(href_list["SelectedJob"])

		if(!job)
			to_chat(usr, "<span class='danger'>The job '[href_list["SelectedJob"]]' doesn't exist!</span>")
			return

		if(!config.enter_allowed)
			to_chat(usr, "<span class='notice'>There is an administrative lock on entering the game!</span>")
			return
		if(ticker && ticker.mode && ticker.mode.explosion_in_progress)
			to_chat(usr, "<span class='danger'>The [station_name()] is currently exploding. Joining would go poorly.</span>")
			return

		var/datum/species/S = all_species[client.prefs.species]
		if(!check_species_allowed(S))
			return 0

		AttemptLateSpawn(job, client.prefs.spawnpoint)
		return

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
				usr << browse(null,"window=privacypoll")
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
			usr << browse(null,"window=privacypoll")

	if(!ready && href_list["preference"])
		if(client)
			client.prefs.process_link(src, href_list)
			
	else if(!href_list["late_join"])
		new_player_panel()

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

	if(href_list["invalid_jobs"])
		show_invalid_jobs = !show_invalid_jobs
		LateChoices()

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

/mob/new_player/proc/IsJobAvailable(var/datum/job/job)
	if(!job)	return 0
	if(!job.is_position_available()) return 0
	if(jobban_isbanned(src, job.title))	return 0
	if(!job.player_old_enough(src.client))	return 0

	return 1

/mob/new_player/proc/get_branch_pref()
	if(client)
		return client.prefs.char_branch

/mob/new_player/proc/get_rank_pref()
	if(client)
		return client.prefs.char_rank

/mob/new_player/proc/AttemptLateSpawn(var/datum/job/job, var/turf/spawning_at)
	message_admins("attemptlatespawn")
	if(src != usr)
		message_admins("ran by non usr...")
		return 0
	if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
		to_chat(usr, "<span class='warning'>The round is either not ready, or has already finished...</span>")
		return 0
	if(!config.enter_allowed)
		to_chat(usr, "<span class='notice'>There is an administrative lock on entering the game!</span>")
		return 0
	var/mob/living/character = create_character()	//creates the human and transfers vars and mind
	if(!character)
		message_admins("create_character failed!")
		return 0
	qdel(src)

	/**
	if(src != usr)
		return 0
	if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
		to_chat(usr, "<span class='warning'>The round is either not ready, or has already finished...</span>")
		return 0
	if(!config.enter_allowed)
		to_chat(usr, "<span class='notice'>There is an administrative lock on entering the game!</span>")
		return 0

	if(!IsJobAvailable(job))
		alert("[job.title] is not available. Please try another.")
		return 0
	if(job.is_restricted(client.prefs, src))
		return

	var/datum/spawnpoint/spawnpoint = job_master.get_spawnpoint_for(client, job.title)
	var/turf/spawn_turf = pick(spawnpoint.turfs)
	if(job.latejoin_at_spawnpoints)
		var/obj/S = job_master.get_roundstart_spawnpoint(job.title)
		spawn_turf = get_turf(S)
	var/radlevel = radiation_repository.get_rads_at_turf(spawn_turf)
	var/airstatus = IsTurfAtmosUnsafe(spawn_turf)
	if(airstatus || radlevel > 0 )
		var/reply = alert(usr, "Warning. Your selected spawn location seems to have unfavorable conditions. \
		You may die shortly after spawning. \
		Spawn anyway? More information: [airstatus] Radiation: [radlevel] Bq", "Atmosphere warning", "Abort", "Spawn anyway")
		if(reply == "Abort")
			return 0
		else
			// Let the staff know, in case the person complains about dying due to this later. They've been warned.
			log_and_message_admins("User [src] spawned at spawn point with dangerous atmosphere.")

		// Just in case someone stole our position while we were waiting for input from alert() proc
		if(!IsJobAvailable(job))
			to_chat(src, alert("[job.title] is not available. Please try another."))
			return 0

	job_master.AssignRole(src, job.title, 1)

	var/mob/living/character = create_character()	//creates the human and transfers vars and mind
	if(!character)
		return 0

//	character = job_master.EquipRank(character, job.title, 1)					//equips the human
//	equip_custom_items(character)

	// AIs don't need a spawnpoint, they must spawn at an empty core
	if(character.mind.assigned_role == "AI")

		character = character.AIize(move=0) // AIize the character, but don't move them yet

			// IsJobAvailable for AI checks that there is an empty core available in this list
		var/obj/structure/AIcore/deactivated/C = empty_playable_ai_cores[1]
		empty_playable_ai_cores -= C

		character.forceMove(C.loc)
		var/mob/living/silicon/ai/A = character
		A.on_mob_init()

		AnnounceCyborg(character, job.title, "has been downloaded to the empty core in \the [character.loc.loc]")
		ticker.mode.handle_latejoin(character)

		qdel(C)
		qdel(src)
		return

	ticker.mode.handle_latejoin(character)
	GLOB.universe.OnPlayerLatejoin(character)
	if(job_master.ShouldCreateRecords(job.title))
		if(character.mind.assigned_role != "Cyborg")
			CreateModularRecord(character)
			AnnounceArrival(character, job, spawnpoint.msg)
		else
			AnnounceCyborg(character, job, spawnpoint.msg)
		matchmaker.do_matchmaking()
	log_and_message_admins("has joined the round as [character.mind.assigned_role].", character)
	qdel(src)
	**/

/mob/new_player/proc/AnnounceCyborg(var/mob/living/character, var/rank, var/join_message)
	if (ticker.current_state == GAME_STATE_PLAYING)
		if(character.mind.role_alt_title)
			rank = character.mind.role_alt_title
		// can't use their name here, since cyborg namepicking is done post-spawn, so we'll just say "A new Cyborg has arrived"/"A new Android has arrived"/etc.
		GLOB.global_announcer.autosay("A new[rank ? " [rank]" : " visitor" ] [join_message ? join_message : "has arrived"].", "Arrivals Announcement Computer")
		log_and_message_admins("has joined the round as [character.mind.assigned_role].", character)

/mob/new_player/proc/LateChoices()
	var/name = client.prefs.be_random_name ? "friend" : client.prefs.real_name

	var/list/dat = list("<html><body><center>")
	dat += "<b>Welcome, [name].<br></b>"
	dat += "Round Duration: [roundduration2text()]<br>"

	if(evacuation_controller.has_evacuated())
		dat += "<font color='red'><b>The [station_name()] has been evacuated.</b></font><br>"
	else if(evacuation_controller.is_evacuating())
		if(evacuation_controller.emergency_evacuation) // Emergency shuttle is past the point of no recall
			dat += "<font color='red'>The [station_name()] is currently undergoing evacuation procedures.</font><br>"
		else                                           // Crew transfer initiated
			dat += "<font color='red'>The [station_name()] is currently undergoing crew transfer procedures.</font><br>"

	dat += "Choose from the following open/valid positions:<br>"
	dat += "<a href='byond://?src=\ref[src];invalid_jobs=1'>[show_invalid_jobs ? "Hide":"Show"] unavailable jobs.</a><br>"
	dat += "<table>"
	for(var/datum/job/job in job_master.occupations)
		if(job && IsJobAvailable(job))
			if(job.minimum_character_age && (client.prefs.age < job.minimum_character_age))
				continue

			var/active = 0
			// Only players with the job assigned and AFK for less than 10 minutes count as active
			for(var/mob/M in GLOB.player_list) if(M.mind && M.client && M.mind.assigned_role == job.title && M.client.inactivity <= 10 * 60 * 10)
				active++

			if(job.is_restricted(client.prefs))
				if(show_invalid_jobs)
					dat += "<tr><td><a style='text-decoration: line-through' href='byond://?src=\ref[src];SelectedJob=[job.title]'>[job.title]</a></td><td>[job.current_positions]</td><td>(Active: [active])</td></tr>"
			else
				dat += "<tr><td><a href='byond://?src=\ref[src];SelectedJob=[job.title]'>[job.title]</a></td><td>[job.current_positions]</td><td>(Active: [active])</td></tr>"

	dat += "</table></center>"
	src << browse(jointext(dat, null), "window=latechoices;size=450x640;can_close=1")


/mob/proc/after_spawn()
	return
/mob/living/carbon/lace/after_spawn()
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
/mob/new_player/proc/create_character(var/turf/spawn_turf)
	message_admins("create_character")
	spawning = 1
	if(!chosen_slot)
		message_admins("no chosen slot..")
		return
	var/mob/new_character = client.prefs.character_list[chosen_slot]
	if(!new_character)
		message_admins("null new_character")
		return
	if(!new_character.mind)
		mind.active = 0					//we wish to transfer the key manually
		mind.original = new_character
		if(client.prefs.memory)
			mind.store_memory(client.prefs.memory)
		mind.transfer_to(new_character)					//won't transfer key since the mind is not active

	sound_to(src, sound(null, repeat = 0, wait = 0, volume = 85, channel = 1))// MAD JAMS cant last forever yo
	if(!spawn_turf)

		if(new_character.spawn_type == 1)
			if(!GLOB.cryopods.len)
				message_admins("WARNING! No cryopods avalible for spawning! Get some spawned and connected to the starting factions uid (req_access_faction)")
				spawn_turf = locate(102, 98, 1)
			else
				var/list/possible_spawn_turfs = list()
				var/list/faction_spawns = list()
				for(var/obj/machinery/cryopod/pod in GLOB.cryopods)
					if(!pod.loc) continue
					if(pod.req_access_faction == new_character.spawn_loc)
						faction_spawns |= pod
				if(faction_spawns.len)
					var/key = "default"
					var/datum/world_faction/faction = get_faction(new_character.spawn_loc)
					if(faction)
						var/datum/computer_file/crew_record/record = faction.get_record(new_character.real_name)
						if(record)
							var/datum/assignment/curr_assignment = faction.get_assignment(record.assignment_uid)
							if(curr_assignment)
								key = curr_assignment.cryo_net
					for(var/obj/machinery/cryopod/pod2 in faction_spawns)
						if(pod2.network == key)
							possible_spawn_turfs |= pod2.loc
					if(!possible_spawn_turfs.len)
						key = "default"
						for(var/obj/machinery/cryopod/pod2 in faction_spawns)
							if(pod2.network == key)
								possible_spawn_turfs |= pod2.loc
					if(!possible_spawn_turfs.len)
						for(var/obj/machinery/cryopod/pod2 in faction_spawns)
							possible_spawn_turfs |= pod2.loc
				if(possible_spawn_turfs.len)
					spawn_turf = pick(possible_spawn_turfs)
				if(!spawn_turf)
					for(var/obj/machinery/cryopod/pod in GLOB.cryopods)
						if(!pod.loc) continue
						if(pod.req_access_faction == "nanotrasen")
							spawn_turf = pod.loc
							break
				if(!spawn_turf)
					var/obj/o
					while(!o && GLOB.cryopods.len)
						o = pick(GLOB.cryopods)
						if(!o.loc)
							GLOB.cryopods -= o
							qdel(o)
							o = null
					if(o)
						spawn_turf = o.loc
				if(!spawn_turf)
					message_admins("WARNING! No cryopods avalible for spawning! Get some spawned and connected to the starting factions uid (req_access_faction)")
					spawn_turf = locate(102, 98, 1)
		else if(new_character.spawn_type == 2)
			if(!GLOB.frontierbeacons.len)
				message_admins("WARNING! No beacons avalible for spawning! spawn one and set the req_access_faction!")
			for(var/obj/structure/frontier_beacon/beacon in GLOB.frontierbeacons)
				if(!beacon.loc) continue
				if(beacon.req_access_faction == new_character.spawn_loc)
					spawn_turf = get_step(beacon.loc,pick(GLOB.cardinal))
					new /obj/effect/portal(spawn_turf, delete_after = 50)
					break
			if(!spawn_turf)
				message_admins("No frontier beacon for [new_character.spawn_loc], spawn one and set the req_access_faction!")
				for(var/obj/structure/frontier_beacon/beacon in GLOB.frontierbeacons)
					if(!beacon.loc) continue
					spawn_turf = get_step(beacon.loc,pick(GLOB.cardinal))
					new /obj/effect/portal(spawn_turf, delete_after = 50)
					break
			if(!spawn_turf)
				for(var/obj/machinery/cryopod/pod in GLOB.cryopods)
					if(!pod.loc) continue
					if(pod.req_access_faction == "refugee")
						spawn_turf = pod.loc
						break
			if(!spawn_turf)
				for(var/obj/machinery/cryopod/pod in GLOB.cryopods)
					if(!pod.loc) continue
					if(pod.req_access_faction == "nanotrasen")
						spawn_turf = pod.loc
						break
			if(!spawn_turf)
				var/obj/o
				while(!o && GLOB.cryopods.len)
					o = pick(GLOB.cryopods)
					if(!o.loc)
						GLOB.cryopods -= o
						qdel(o)
						o = null
				if(o)
					spawn_turf = o.loc
			if(!spawn_turf)
				message_admins("WARNING! No cryopods avalible for spawning! Get some spawned and connected to the starting factions uid (req_access_faction)")
				spawn_turf = locate(102, 98, 1)
		if(!spawn_turf)
			message_admins("WARNING! spawn-turf still invalid!!")
			spawn_turf = locate(102, 98, 1)



	close_spawn_windows()
	new_character.loc = spawn_turf
	new_character.key = key		//Manually transfer the key to log them in
	new_character.save_slot = chosen_slot
	ticker.minds |= new_character.mind//Cyborgs and AIs handle this in the transform proc.	//TODO!!!!! ~Carn
	new_character.redraw_inv()
	CreateModularRecord(new_character)
	sound_to(src, sound(null, repeat = 0, wait = 0, volume = 85, channel = 1))// MAD JAMS cant last forever yo
	if(new_character.spawn_type == 2)
		var/obj/screen/cinematic

		cinematic = new
		cinematic.icon = 'icons/effects/gateway_intro.dmi'
		cinematic.icon_state = "blank"
		cinematic.plane = HUD_PLANE
		cinematic.layer = HUD_ABOVE_ITEM_LAYER
		cinematic.mouse_opacity = 2
		cinematic.screen_loc = "WEST,SOUTH"

		if(new_character.client)
			new_character.client.screen += cinematic

			flick("neurallaceboot",cinematic)
			sleep(150)
			new_character.client.screen -= cinematic

		new_character.spawn_type = 1
		sound_to(new_character, sound('sound/music/brandon_morris_loop.ogg', repeat = 0, wait = 0, volume = 85, channel = 1))
		spawn()
			shake_camera(new_character, 3, 1)
		new_character.druggy = 3
		new_character.Weaken(3)
		to_chat(new_character, "<span class='danger'>Your trip through the frontier gateway is like nothing you have ever experienced!</span>")
		to_chat(new_character, "In fact, it was like your consciousness was ripped from your body and then hammered back inside moments later.")
		to_chat(new_character, "However, you've made it to the uncharted frontier. You don't know when you'll be able to return to the places you've left behind.")
		to_chat(new_character, "No time to think about that, your first priority is to get your bearings and find a job that pays. Whatever you decide to do in this new frontier, you're going to need a lot more cash than what you have now.")
	else
		to_chat(new_character, "You eject from your cryosleep, ready to resume life in the frontier.")
	new_character.after_spawn()
	return new_character
	/**
	var/mob/living/carbon/human/new_character

	var/datum/species/chosen_species
	if(client.prefs.species)
		chosen_species = all_species[client.prefs.species]



	if(chosen_species)
		if(!check_species_allowed(chosen_species))
			spawning = 0 //abort
			return null
		new_character = new(spawn_turf, chosen_species.name)
		if(chosen_species.has_organ[BP_POSIBRAIN] && client && client.prefs.is_shackled)
			var/obj/item/organ/internal/posibrain/B = new_character.internal_organs_by_name[BP_POSIBRAIN]
			if(B)	B.shackle(client.prefs.get_lawset())

	if(!new_character)
		new_character = new(spawn_turf)

	new_character.lastarea = get_area(spawn_turf)

	for(var/lang in client.prefs.alternate_languages)
		var/datum/language/chosen_language = all_languages[lang]
		if(chosen_language)
			var/is_species_lang = (chosen_language.name in new_character.species.secondary_langs)
			if(is_species_lang || ((!(chosen_language.flags & RESTRICTED) || has_admin_rights()) && is_alien_whitelisted(src, chosen_language)))
				new_character.add_language(lang)

	if(ticker.random_players)
		new_character.gender = pick(MALE, FEMALE)
		client.prefs.real_name = random_name(new_character.gender)
		client.prefs.randomize_appearance_and_body_for(new_character)
	else
		client.prefs.copy_to(new_character)



	if(mind)
		mind.active = 0					//we wish to transfer the key manually
		mind.original = new_character
		if(client.prefs.memory)
			mind.store_memory(client.prefs.memory)
		if(client.prefs.relations.len)
			for(var/T in client.prefs.relations)
				var/TT = matchmaker.relation_types[T]
				var/datum/relation/R = new TT
				R.holder = mind
				R.info = client.prefs.relations_info[T]
			mind.gen_relations_info = client.prefs.relations_info["general"]
		mind.transfer_to(new_character)					//won't transfer key since the mind is not active

	new_character.name = real_name
	new_character.dna.ready_dna(new_character)
	new_character.dna.b_type = client.prefs.b_type
	new_character.sync_organ_dna()
	if(client.prefs.disabilities)
		// Set defer to 1 if you add more crap here so it only recalculates struc_enzymes once. - N3X
		new_character.dna.SetSEState(GLOB.GLASSESBLOCK,1,0)
		new_character.disabilities |= NEARSIGHTED

	// Give them their cortical stack if we're using them.
	if(config && config.use_cortical_stacks && client && client.prefs.has_cortical_stack /*&& new_character.should_have_organ(BP_BRAIN)*/)
		new_character.create_stack()

	// Do the initial caching of the player's body icons.
	new_character.force_update_limbs()
	new_character.update_eyes()
	new_character.regenerate_icons()

	new_character.key = key		//Manually transfer the key to log them in
	return new_character
	**/
/mob/new_player/proc/ViewManifest()
	var/dat = "<div align='center'>"
	dat += html_crew_manifest(OOC = 1)
	//src << browse(dat, "window=manifest;size=370x420;can_close=1")
	var/datum/browser/popup = new(src, "Crew Manifest", "Crew Manifest", 370, 420, src)
	popup.set_content(dat)
	popup.open()

/mob/new_player/Move()
	return 0

/mob/new_player/proc/close_spawn_windows()
	src << browse(null, "window=latechoices") //closes late choices window
	if(panel)
		panel.close()
	if(load_panel)
		load_panel.close()
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
