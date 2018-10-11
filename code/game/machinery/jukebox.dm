//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

datum/track
	var/title
	var/sound
	var/genre

datum/track/New(var/title_name, var/audio, var/genre_name)
	title = title_name
	sound = audio
	genre = genre_name

/obj/machinery/media/jukebox
	name = "space jukebox"
	icon = 'icons/obj/jukebox.dmi'
	icon_state = "jukebox2-nopower"
	var/state_base = "jukebox2"
	anchored = 0
	density = 1
	power_channel = EQUIP
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 100
	clicksound = 'sound/machines/buttonbeep.ogg'

	var/playing = 0
	var/volume = 20

	var/sound_id
	var/datum/sound_token/sound_token

	var/datum/track/current_track
	var/list/datum/track/tracks = list(
		new/datum/track("Beyond", 'sound/ambience/ambispace.ogg', "SS13"),
		new/datum/track("Clouds of Fire", 'sound/music/clouds.s3m', "SS13"),
		new/datum/track("D`Bert", 'sound/music/title2.ogg', "SS13"),
		new/datum/track("D`Fort", 'sound/ambience/song_game.ogg', "SS13"),
		new/datum/track("Floating", 'sound/music/main.ogg', "SS13"),
		new/datum/track("Endless Space", 'sound/music/space.ogg', "SS13"),
		new/datum/track("Part A", 'sound/misc/TestLoop1.ogg', "SS13"),
		new/datum/track("Scratch", 'sound/music/title1.ogg', "SS13"),
		new/datum/track("Trai`Tor", 'sound/music/traitor.ogg', "SS13"),
		new/datum/track("A Little Bit", 'sound/music/jukebox/A Little Bit.ogg', "SS13"),
		new/datum/track("Astrogenesis", 'sound/music/jukebox/Astrogenesis.ogg', "Cyberpunk"),
		new/datum/track("Decay", 'sound/music/jukebox/Decay.ogg', "Cyberpunk"),
		new/datum/track("Drunk", 'sound/music/jukebox/Drunk.ogg', "Cyberpunk"),
		new/datum/track("Half Moon", 'sound/music/jukebox/Half Moon.ogg', "Cyberpunk"),
		new/datum/track("Metropolis", 'sound/music/jukebox/Metropolis.ogg', "Cyberpunk"),
		new/datum/track("Midnight Market", 'sound/music/jukebox/Midnight Market.ogg', "Cyberpunk"),
		new/datum/track("Native", 'sound/music/jukebox/Native.ogg', "Cyberpunk"),
		new/datum/track("When I'm Gone", "sound/music/jukebox/When I'm Gone.ogg", "Cyberpunk"),
	)

/obj/machinery/media/jukebox/New()
	..()
	update_icon()
	sound_id = "[type]_[sequential_id(type)]"

/obj/machinery/media/jukebox/Destroy()
	StopPlaying()
	. = ..()

/obj/machinery/media/jukebox/powered()
	return anchored && ..()

/obj/machinery/media/jukebox/power_change()
	. = ..()
	if(stat & (NOPOWER|BROKEN) && playing)
		StopPlaying()

/obj/machinery/media/jukebox/update_icon()
	overlays.Cut()
	if(stat & (NOPOWER|BROKEN) || !anchored)
		if(stat & BROKEN)
			icon_state = "[state_base]-broken"
		else
			icon_state = "[state_base]-nopower"
		return
	icon_state = state_base
	if(playing)
		if(emagged)
			overlays += "[state_base]-emagged"
		else
			overlays += "[state_base]-running"

/obj/machinery/media/jukebox/interact(mob/user)
	if(!anchored)
		to_chat(usr, "<span class='warning'>You must secure \the [src] first.</span>")
		return

	if(stat & (NOPOWER|BROKEN))
		to_chat(usr, "\The [src] doesn't appear to function.")
		return

	ui_interact(user)

/obj/machinery/media/jukebox/ui_status(mob/user, datum/ui_state/state)
	if(!anchored || inoperable())
		return UI_CLOSE
	return ..()

/obj/machinery/media/jukebox/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/title = "RetroBox - Space Style"
	var/data[0]
	data["current_track"] = current_track != null ? current_track.title : ""
	data["playing"] = playing
	var/list/tracks_ss13 = list()
	for(var/datum/track/T in tracks)
		if(T.genre == "SS13")
			tracks_ss13[++tracks_ss13.len] = list("track" = T.title)
	data["tracks_ss13"] = tracks_ss13

	var/list/tracks_cyberpunk = list()
	for(var/datum/track/T in tracks)
		if(T.genre == "Cyberpunk")
			tracks_cyberpunk[++tracks_cyberpunk.len] = list("track" = T.title)
	data["tracks_cyberpunk"] = tracks_cyberpunk

 	// update the ui if it exists, returns null if no ui is passed/found
	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "jukebox.tmpl", title, 450, 600)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()


/obj/machinery/media/jukebox/Topic(href, href_list)
	if(!anchored)
		to_chat(usr,"<span class='warning'>You must secure \the [src] first.</span>")
		return
	if(stat & (NOPOWER|BROKEN))
		to_chat(usr,"\The [src] doesn't appear to function.")
		return
	if(!(Adjacent(usr) || istype(usr, /mob/living/silicon)))
		return
	if(href_list["change_track"])
		for(var/datum/track/T in tracks)
			if(T.title == href_list["title"])
				current_track = T
				StartPlaying()
		GLOB.nanomanager.update_uis(src)
	if(href_list["stop"])
		StopPlaying()
		GLOB.nanomanager.update_uis(src)
	if(href_list["play"])
		if(!current_track)
			to_chat(usr, "No track selected.")
		else
			StartPlaying()
		GLOB.nanomanager.update_uis(src)

/obj/machinery/media/jukebox/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/media/jukebox/attack_hand(var/mob/user as mob)
	interact(user)

/obj/machinery/media/jukebox/proc/explode()
	walk_to(src,0)
	src.visible_message("<span class='danger'>\the [src] blows apart!</span>", 1)

	explosion(src.loc, 0, 0, 1, rand(1,2), 1)

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()

	new /obj/effect/decal/cleanable/blood/oil(src.loc)
	qdel(src)

/obj/machinery/media/jukebox/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)

	if(isWrench(W))
		wrench_floor_bolts(user, 0)
		power_change()
		return
	return ..()

/obj/machinery/media/jukebox/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		emagged = 1
		StopPlaying()
		visible_message("<span class='danger'>\The [src] makes a fizzling sound.</span>")
		update_icon()
		return 1

/obj/machinery/media/jukebox/proc/StopPlaying()
	playing = 0
	update_use_power(1)
	update_icon()
	QDEL_NULL(sound_token)


/obj/machinery/media/jukebox/proc/StartPlaying()
	StopPlaying()
	if(!current_track)
		return

	// Jukeboxes cheat massively and actually don't share id. This is only done because it's music rather than ambient noise.
	sound_token = sound_player.PlayLoopingSound(src, sound_id, current_track.sound, volume = volume, range = 7, falloff = 3, prefer_mute = TRUE)

	playing = 1
	update_use_power(2)
	update_icon()

/obj/machinery/media/jukebox/proc/AdjustVolume(var/new_volume)
	volume = Clamp(new_volume, 0, 100)
	if(sound_token)
		sound_token.SetVolume(volume)
