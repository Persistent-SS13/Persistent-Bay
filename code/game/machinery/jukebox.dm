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
	var/selected_genre = "ALL"
	var/playing = 0
	var/volume = 60

	var/sound_id
	var/datum/sound_token/sound_token

	var/datum/track/current_track
	var/list/datum/track/tracks = list(
		new/datum/track("The Ball and Diner", 'sound/music/jukebox/ballanddiner.mid', "Pleasent"),
		new/datum/track("Pleasantly Understated", 'sound/music/jukebox/02 - A Pleasantly Understated Credit Sequence.mid', "Pleasent"),
		new/datum/track("Surfin' the Highway", 'sound/music/jukebox/06 - Surfin The Highway.mid', "Rockin"),
		new/datum/track("Snuckey's Muzak", 'sound/music/jukebox/09 - Snuckeys Greatest Muzaks #2.mid', "Pleasent"),
		new/datum/track("Red Liccorice Candy", 'sound/music/jukebox/11 - Snuckeys Greatest Muzaks #4.mid', "Pleasent"),
		new/datum/track("Doug, The Moleman", 'sound/music/jukebox/17 - Doug, The Moleman.mid', "Moody"),
		new/datum/track("I'm a Trout, Stupid!", 'sound/music/jukebox/21 - Im A Trout, Stupid!.mid', "Country"),
		new/datum/track("GatorGolf", 'sound/music/jukebox/23 - GatorGolf.mid', "Country"),
		new/datum/track("Nobody Makes Fun Of My Hair!", 'sound/music/jukebox/24 - Nobody Makes Fun Of My Hair.mid', "Rockin"),
		new/datum/track("Mystery Vortex", 'sound/music/jukebox/25 - Mystery Vortex.mid', "Moody"),
		new/datum/track("Shuv-Oohl", 'sound/music/jukebox/27 - Shuv-Oohl.mid', "Moody"),
		new/datum/track("BumpusVille", 'sound/music/jukebox/29 - BumpusVille.mid', "Country"),
		new/datum/track("King of The Creatures", 'sound/music/jukebox/33 - King Of The Creatures.mid', "Rockin"),
		new/datum/track("Celebrity Vegetable Museum", 'sound/music/jukebox/36 - Celebrity Vegetable Museum.mid', "Country"),
		new/datum/track("Savage Jungle Inn", 'sound/music/jukebox/40 - Savage Jungle Inn.mid', "Moody"),
		new/datum/track("Dino Bungee National Memorial", 'sound/music/jukebox/37 - Dino Bungee National Memorial.mid', "Pleasent"),
		new/datum/track("Bigfoot Shuffle", 'sound/music/jukebox/41 - Bigfoot Shuffle.mid', "Pleasent"),
		new/datum/track("Ice Cavern", 'sound/music/jukebox/son3ice.mid', "Pleasent"),
		new/datum/track("Special Zone", 'sound/music/jukebox/SMW-Special_Zone.mid', "Pleasent"),
		new/datum/track("Goodbye and Goodnight", 'sound/music/jukebox/SMW_Ending_and_Credits.mid', "Pleasent"),
		new/datum/track("Enter, Vanguard (Agarthan Battle Music)", 'sound/music/jukebox/SF64_Corneria-KM.mid', "Agarthan"),
		new/datum/track("The Harvest Moon", 'sound/music/jukebox/HM64_-_Ending_Credits.mid', "Country"),
		new/datum/track("Mirthful Victory", 'sound/music/jukebox/Ending487.mid', "Pleasent"),
		new/datum/track("Elise", 'sound/music/jukebox/elise.mid', "Classical"),
		new/datum/track("Hotel Rhumba", 'sound/music/jukebox/eb_hotelrhumbaremix.mid', "Moody"),
		new/datum/track("Buy something, will ya?", 'sound/music/jukebox/earthbound-drugstore-buysomethinwillya-v2.mid', "Pleasent"),
		new/datum/track("Clean Sweep", 'sound/music/jukebox/CleanSweep.mid', "Jazz"),
		new/datum/track("Canon in D", 'sound/music/jukebox/canon4.mid', "Classical"),
		new/datum/track("Hay Burner", 'sound/music/jukebox/burnerrg.mid', "Jazz"),
		new/datum/track("Angela", 'sound/music/jukebox/Angela.mid', "Jazz"),
		new/datum/track("Anything goes", 'sound/music/jukebox/anythgo_.mid', "Jazz"),
		new/datum/track("Blues 'N' Boogie", 'sound/music/jukebox/Bluenboo.mid', "Jazz"),
		new/datum/track("Previously Used", 'sound/music/jukebox/stan.mid', "Pleasent"),
		new/datum/track("Swamp", 'sound/music/jukebox/swamp.mid', "Moody"),
		new/datum/track("Celebrate!", 'sound/music/jukebox/5565.mid', "Pleasent"),
		new/datum/track("Liberty Soil (Agarthan Battle Music)", 'sound/music/jukebox/Command_And_Conquer_Tiberian_Sun_-_Mechanical_Man_Target.mid', "Agarthan"),
		new/datum/track("Wedding March", 'sound/music/jukebox/mendelssohn-wedding-march.mid', "Classical"),
		new/datum/track("Beyond", 'sound/ambience/ambispace.ogg', "SS13"),
		new/datum/track("Clouds of Fire", 'sound/music/clouds.s3m', "SS13"),
		new/datum/track("D`Bert", 'sound/music/title2.ogg', "SS13"),
		new/datum/track("D`Fort", 'sound/ambience/song_game.ogg', "SS13"),
		new/datum/track("Floating", 'sound/music/main.ogg', "SS13"),
		new/datum/track("Endless Space", 'sound/music/space.ogg', "SS13"),
		new/datum/track("Part A", 'sound/misc/TestLoop1.ogg', "SS13"),
		new/datum/track("Scratch", 'sound/music/title1.ogg', "SS13"),
		new/datum/track("Trai`Tor", 'sound/music/traitor.ogg', "SS13"),
		new/datum/track("A Little Bit", 'sound/music/jukebox/A Little Bit.ogg', "Cyberpunk"),
		new/datum/track("Astrogenesis", 'sound/music/jukebox/Astrogenesis.ogg', "Cyberpunk"),
		new/datum/track("Decay", 'sound/music/jukebox/Decay.ogg', "Cyberpunk"),
		new/datum/track("Drunk", 'sound/music/jukebox/Drunk.ogg', "Cyberpunk"),
		new/datum/track("Half Moon", 'sound/music/jukebox/Half Moon.ogg', "Cyberpunk"),
		new/datum/track("Metropolis", 'sound/music/jukebox/Metropolis.ogg', "Cyberpunk"),
		new/datum/track("Midnight Market", 'sound/music/jukebox/Midnight Market.ogg', "Cyberpunk"),
		new/datum/track("Native", 'sound/music/jukebox/Native.ogg', "Cyberpunk"),
		new/datum/track("When I'm Gone", "sound/music/jukebox/When I'm Gone.ogg", "Cyberpunk"),
		new/datum/track("All Systems Go!", 'sound/music/jukebox/all_systems_go.mid', "Rockin"),
		new/datum/track("Bloody Stream", 'sound/music/jukebox/Bloody_Stream.mid', "Rockin"),
		new/datum/track("Drinkin'", 'sound/music/jukebox/Drinking.mid', "Mercenary/Spacer"),
		new/datum/track("End of the World'", 'sound/music/jukebox/End_Of_The_World.mid', "Rockin"),
		new/datum/track("Every Day is Night", 'sound/music/jukebox/Every_Day_Is_Night.mid', "Rockin"),
		new/datum/track("Con te Partiro", 'sound/music/jukebox/Con_te_Partiro.mid', "Classical"),
		new/datum/track("Dalida Besame Mucho'", 'sound/music/jukebox/Dalida_Besame_Mucho.mid', "Moody"),
		new/datum/track("Hua Hao Yue Yuan", 'sound/music/jukebox/Hua_Hao_Yue_Yuan.mid', "Faeren"),
		new/datum/track("Largo's Town", 'sound/music/jukebox/LARGSTAB.mid', "Mercenary/Spacer"),
		new/datum/track("Dive Bar'n", 'sound/music/jukebox/mkdive.mid', "Mercenary/Spacer"),
		new/datum/track("Ghost Pirates", 'sound/music/jukebox/ghostpirate.mid', "Mercenary/Spacer"),
		new/datum/track("Slight Scabb", 'sound/music/jukebox/scabbmap.mid', "Mercenary/Spacer"),
		new/datum/track("Sono Chi No Sadame", 'sound/music/jukebox/Sono_Chi_No_Sadame.mid', "Faeren"),
		new/datum/track("Tarantella", 'sound/music/jukebox/tarantella.mid', "Pleasent"),
		new/datum/track("Stand Proud", 'sound/music/jukebox/Stand_Proud.mid', "Rockin"),
		new/datum/track("Xiang Jian Xiao Lu", 'sound/music/jukebox/Xiang_Jian_Xiao_Lu.mid', "Faeren"),
		new/datum/track("Xin Tai Ruan", 'sound/music/jukebox/Xin_Tai_Ruan.mid', "Faeren"),
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
	data["genre"] = selected_genre
	var/list/tracks_rockin = list()
	for(var/datum/track/T in tracks)
		if(T.genre == "Rockin")
			tracks_rockin[++tracks_rockin.len] = list("track" = T.title)
	data["tracks_rockin"] = tracks_rockin

	var/list/tracks_pleasent = list()
	for(var/datum/track/T in tracks)
		if(T.genre == "Pleasent")
			tracks_pleasent[++tracks_pleasent.len] = list("track" = T.title)
	data["tracks_pleasent"] = tracks_pleasent

	var/list/tracks_country = list()
	for(var/datum/track/T in tracks)
		if(T.genre == "Country")
			tracks_country[++tracks_country.len] = list("track" = T.title)
	data["tracks_country"] = tracks_country

	var/list/tracks_moody = list()
	for(var/datum/track/T in tracks)
		if(T.genre == "Moody")
			tracks_moody[++tracks_moody.len] = list("track" = T.title)
	data["tracks_moody"] = tracks_moody

	var/list/tracks_agarthan = list()
	for(var/datum/track/T in tracks)
		if(T.genre == "Agarthan")
			tracks_agarthan[++tracks_agarthan.len] = list("track" = T.title)
	data["tracks_agarthan"] = tracks_agarthan

	var/list/tracks_jazz = list()
	for(var/datum/track/T in tracks)
		if(T.genre == "Jazz")
			tracks_jazz[++tracks_jazz.len] = list("track" = T.title)
	data["tracks_jazz"] = tracks_jazz

	var/list/tracks_classical = list()
	for(var/datum/track/T in tracks)
		if(T.genre == "Classical")
			tracks_classical[++tracks_classical.len] = list("track" = T.title)
	data["tracks_classical"] = tracks_classical
	
	var/list/tracks_faeren = list()
	for(var/datum/track/T in tracks)
		if(T.genre == "Faeren")
			tracks_faeren[++tracks_faeren.len] = list("track" = T.title)
	data["tracks_faeren"] = tracks_faeren
	
	var/list/tracks_spacer = list()
	for(var/datum/track/T in tracks)
		if(T.genre == "Mercenary/Spacer")
			tracks_spacer[++tracks_spacer.len] = list("track" = T.title)
	data["tracks_spacer"] = tracks_spacer
	
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
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
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
		SSnano.update_uis(src)
	if(href_list["change_genre"])
		selected_genre = href_list["change_genre"]
		SSnano.update_uis(src)
	if(href_list["stop"])
		StopPlaying()
		SSnano.update_uis(src)
	if(href_list["play"])
		if(!current_track)
			to_chat(usr, "No track selected.")
		else
			StartPlaying()
		SSnano.update_uis(src)

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
	if(default_wrench_floor_bolts(user, W))
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
	sound_token = GLOB.sound_player.PlayLoopingSound(src, sound_id, current_track.sound, volume = volume, range = 7, falloff = 3, prefer_mute = TRUE, channel = GLOB.sound_channels.RequestChannel(src.type) )

	playing = 1
	update_use_power(2)
	update_icon()

/obj/machinery/media/jukebox/proc/AdjustVolume(var/new_volume)
	volume = Clamp(new_volume, 0, 100)
	if(sound_token)
		sound_token.SetVolume(volume)
