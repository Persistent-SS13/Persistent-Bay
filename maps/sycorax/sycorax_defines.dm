proc/GetNbSavedZLevels()
	return 20

/datum/map/sycorax
	name = "Sycorax"
	full_name = "Sycorax Quadrant"
	path = "sycorax"
	flags = MAP_HAS_RANK

	lobby_icon = 'maps/sycorax/icons/lobby.dmi'
	intro_icon = 'maps/sycorax/icons/intro.dmi'

	station_levels = list(1)
	contact_levels = list(1,2)
	player_levels = list(1,2)
	admin_levels = list(20)
	empty_levels = list(19)
	accessible_z_levels = list("1"=1,"2"=1)
	usable_email_tlds = list(EMAIL_DOMAIN_DEFAULT)

	allowed_spawns = list("Cryogenic Storage", "Cyborg Storage")
	default_spawn = "Cryogenic Storage"

	system_name   = "Frontier Gamma Quadrant"
	station_name  = "Gamma Quadrant Sycorax"
	station_short = "Sycorax"
	dock_name     = "Sycorax Docks"
	boss_name     = "Sycorax Administration"
	boss_short    = "Sycorax Admin"
	company_name  = "Sycorax"
	company_short = "SX"
	default_faction_uid = SYCORAX_FACTION_CITIZEN

	use_overmap = TRUE		//If overmap should be used (including overmap space travel override)
	overmap_size = 20		//Dimensions of overmap zlevel if overmap is used.
	overmap_z = 0		//If 0 will generate overmap zlevel on init. Otherwise will populate the zlevel provided.
	overmap_event_areas = 0 //How many event "clouds" will be generated
	num_exoplanets = 0

//Overriding event containers to remove random versions of overmap events - electrical storm, dust and meteor
/datum/event_container/mundane
	available_events = list()

/datum/event_container/moderate
	available_events = list()

/datum/event_container/major
	available_events = list()

//Spawn code particular to this map
//This proc is called right after a new character is spawned for the first time
//It plays the spawn cutscene and etc
/datum/map/sycorax/on_new_spawn(var/mob/newchar)
	if(!istype(newchar))
		return
	if(src.intro_icon)
		var/obj/screen/cinematic
		cinematic = new
		cinematic.icon = src.intro_icon
		cinematic.icon_state = "blank"
		cinematic.plane = HUD_PLANE
		cinematic.layer = HUD_ABOVE_ITEM_LAYER
		cinematic.mouse_opacity = 2
		cinematic.screen_loc = "WEST,SOUTH"

		if(newchar.client)
			newchar.client.screen += cinematic
			flick("cinematic",cinematic)
			sleep(65)
			if(!newchar)
				return //it might have gotten deleted or something??
			newchar.client.screen -= cinematic

	newchar.spawn_type = CHARACTER_SPAWN_TYPE_CRYONET
	var/sound/mus = sound('sound/music/brandon_morris_loop.ogg', repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel)
	mus.environment = -1 //Don't do silly reverb stuff
	mus.status = SOUND_STREAM //Cheaper to do streams
	sound_to(newchar, mus)
	spawn()
		new /obj/effect/portal(get_turf(newchar), null, 5 SECONDS, 0)
		shake_camera(newchar, 3, 1)
	GLOB.global_announcer.autosay("[newchar.real_name] has just arrived at Sycorax Quadrant. Welcome [newchar.real_name]!", "Arrival Announcer")
	newchar.druggy = 3
	newchar.Weaken(3)
	to_chat(newchar, "<span class='danger'>You are carried through the swirling amber portal to your new home, Sycorax Quadrant.</span>")
	sleep(100)
	to_chat(newchar, "The neural lace that you recently had implanted burns at the back of your skull.")
	sleep(100)
	to_chat(newchar, "You wake up on a beacon with a book at your feet titled 'Guide to Sycorax Quadrant'.")
	sleep(100)
	to_chat(newchar, "You've come here to make a new life in a far-away space station. Better read the book to find out how this station works.")
	to_chat(newchar, "((Persistence is a very unique codebase! If you need help you can *always* ask staff by pressing F1. Go out and meet other characters, you dont need to find work right away but making friends is invaluable.))")

//Example for adding map specific starter uniforms
// /datum/map/sycorax/populate_uniforms(var/client/C)
// 	. = ..()
// 	switch(C.prefs.cultural_info[TAG_CULTURE])
// 		if(CULTURE_HUMAN_SPACER)
// 			. |= new /obj/item/clothing/under/blazer()
