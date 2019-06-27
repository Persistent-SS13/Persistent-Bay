proc/GetNbSavedZLevels()
	return 20

/datum/map/nexus
	name = "Nexus"
	full_name = "Nexus Station"
	path = "nexus"
	flags = MAP_HAS_RANK

	lobby_icon = 'maps/nexus/icons/lobby.dmi'
	intro_icon = 'maps/nexus/icons/intro.dmi'

	station_levels = list(1,2,3)
	contact_levels = list(1,2,3)
	player_levels = list(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20)
	admin_levels = list(25)
	empty_levels = list(24)
	accessible_z_levels = list("1"=1,"2"=1,"3"=1,"4"=1,"5"=1,"6"=1,"7"=1,"8"=1,"9"=1,"10"=1,"11"=1,"12"=1,"13"=1,"14"=1,"15"=1,"16"=1,"17"=1,"18"=1,"19"=1,"20"=1)
	usable_email_tlds = list(EMAIL_DOMAIN_DEFAULT)

	allowed_spawns = list("Cryogenic Storage", "Cyborg Storage")
	default_spawn = "Cryogenic Storage"

	system_name   = "Frontier Beta Quadrant"
	station_name  = "Beta Quadrant Nexus"
	station_short = "Nexus"
	dock_name     = "Nexus Docks"
	boss_name     = "Nexus AI"
	boss_short    = "Nexus"
	company_name  = "Nexus"
	company_short = "NX"
	default_faction_uid = NEXUS_FACTION_CITIZEN

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
/datum/map/nexus/on_new_spawn(var/mob/newchar)
	if(!istype(newchar))
		return
	if(src.intro_icon)
		sound_to(newchar, sound('sound/music/brandon_morris_loop.ogg', repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel))
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
			sleep(106)
			if(!newchar)
				return //it might have gotten deleted or something??
			newchar.client.screen -= cinematic

	newchar.spawn_type = CHARACTER_SPAWN_TYPE_CRYONET
	
	spawn()
		new /obj/effect/portal(get_turf(newchar), null, 5 SECONDS, 0)
		shake_camera(newchar, 3, 1)
	newchar.druggy = 3
	newchar.Weaken(3)
	to_chat(newchar, "<span class='danger'>You are carried through the swirling amber portal to your new home, Nexus City.</span>")
	sleep(100)
	to_chat(newchar, "The neural lace that you recently had implanted burns at the back of your skull.")
	sleep(100)
	to_chat(newchar, "You wake up on a beacon with a book at your feet titled 'Guide to Nexus City'.")
	sleep(100)
	to_chat(newchar, "You've come here to make a new life in a far-away space station. Better read the book to find out how this station works.")
	to_chat(newchar, "((Persistence is a very unique codebase! If you need help you can *always* ask staff by pressing F1. Go out and meet other characters, you dont need to find work right away but making friends is invaluable.))")

//Example for adding map specific starter uniforms
// /datum/map/nexus/populate_uniforms(var/client/C)
// 	. = ..()
// 	switch(C.prefs.cultural_info[TAG_CULTURE])
// 		if(CULTURE_HUMAN_SPACER)
// 			. |= new /obj/item/clothing/under/blazer()
