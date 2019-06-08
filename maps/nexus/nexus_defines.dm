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
	default_faction_uid = NEXUS_FACTION_RESIDENT

	use_overmap = TRUE		//If overmap should be used (including overmap space travel override)
	overmap_size = 20		//Dimensions of overmap zlevel if overmap is used.
	overmap_z = 0		//If 0 will generate overmap zlevel on init. Otherwise will populate the zlevel provided.
	overmap_event_areas = 0 //How many event "clouds" will be generated
	num_exoplanets = 0

//Overriding event containers to remove random versions of overmap events - electrical storm, dust and meteor
/datum/event_container/mundane
	available_events = list(
		// Severity level, event name, even type, base weight, role weights, one shot, min weight, max weight. Last two only used if set and non-zero
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Nothing",			/datum/event/nothing,			100),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "APC Damage",		/datum/event/apc_damage,		20, 	list(ASSIGNMENT_ENGINEER = 10)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Brand Intelligence",/datum/event/brand_intelligence,10, 	list(ASSIGNMENT_JANITOR = 10),	1),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Camera Damage",		/datum/event/camera_damage,		20, 	list(ASSIGNMENT_ENGINEER = 10)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Economic News",		/datum/event/economic_event,	300),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Lost Carp",			/datum/event/carp_migration, 	20, 	list(ASSIGNMENT_SECURITY = 10), 1),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Money Hacker",		/datum/event/money_hacker, 		0, 		list(ASSIGNMENT_ANY = 4), 1, 10, 25),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Money Lotto",		/datum/event/money_lotto, 		0, 		list(ASSIGNMENT_ANY = 1), 1, 5, 15),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mundane News", 		/datum/event/mundane_news, 		300),
//		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Shipping Error",	/datum/event/shipping_error	, 	30, 	list(ASSIGNMENT_ANY = 2), 0),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Sensor Suit Jamming",/datum/event/sensor_suit_jamming,50,	list(ASSIGNMENT_MEDICAL = 20, ASSIGNMENT_AI = 20), 1),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Trivial News",		/datum/event/trivial_news, 		400),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Vermin Infestation",/datum/event/infestation, 		100,	list(ASSIGNMENT_JANITOR = 100)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Wallrot",			/datum/event/wallrot, 			0,		list(ASSIGNMENT_ENGINEER = 30, ASSIGNMENT_GARDENER = 50)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Space Cold Outbreak",/datum/event/space_cold,		100,	list(ASSIGNMENT_MEDICAL = 20)),
	)

/datum/event_container/moderate
	available_events = list(
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Nothing",					/datum/event/nothing,					1000),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Appendicitis", 			/datum/event/spontaneous_appendicitis, 	0,		list(ASSIGNMENT_MEDICAL = 10), 1),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Communication Blackout",	/datum/event/communications_blackout,	500,	list(ASSIGNMENT_AI = 150, ASSIGNMENT_SECURITY = 120)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Gravity Failure",			/datum/event/gravity,	 				75,		list(ASSIGNMENT_ENGINEER = 25)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Prison Break",				/datum/event/prison_break,				0,		list(ASSIGNMENT_SECURITY = 100)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Radiation Storm",			/datum/event/radiation_storm, 			0,		list(ASSIGNMENT_MEDICAL = 50), 1),
		new /datum/event_meta/extended_penalty(EVENT_LEVEL_MODERATE, "Random Antagonist",/datum/event/random_antag,		2.5,	list(ASSIGNMENT_SECURITY = 1), 1, 0, 5),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Rogue Drones",				/datum/event/rogue_drone, 				20,		list(ASSIGNMENT_SECURITY = 20)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Sensor Suit Jamming",		/datum/event/sensor_suit_jamming,		10,		list(ASSIGNMENT_MEDICAL = 20, ASSIGNMENT_AI = 20)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Solar Storm",				/datum/event/solar_storm, 				10,		list(ASSIGNMENT_ENGINEER = 20, ASSIGNMENT_SECURITY = 10), 1),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Spider Infestation",		/datum/event/spider_infestation, 		25,		list(ASSIGNMENT_SECURITY = 30), 1),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Virology Breach",			/datum/event/prison_break/virology,		0,		list(ASSIGNMENT_MEDICAL = 100)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Xenobiology Breach",		/datum/event/prison_break/xenobiology,	0,		list(ASSIGNMENT_SCIENCE = 100)),
	)

/datum/event_container/major
	available_events = list(
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Nothing",				/datum/event/nothing,			1000),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Blob",				/datum/event/blob, 				0,	list(ASSIGNMENT_ENGINEER = 40), 1),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Containment Breach",	/datum/event/prison_break/station,0,list(ASSIGNMENT_ANY = 5)),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Space Vines",			/datum/event/spacevine, 		0,	list(ASSIGNMENT_ENGINEER = 15), 1),
	)

//Spawn code particular to this map
//This proc is called right after a new character is spawned for the first time
//It plays the spawn cutscene and etc 
/datum/map/nexus/on_new_spawn(var/mob/new_player/newchar)
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
			sleep(106)
			newchar.client.screen -= cinematic

	newchar.spawn_type = CHARACTER_SPAWN_TYPE_CRYONET
	sound_to(newchar, sound('sound/music/brandon_morris_loop.ogg', repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel))
	spawn()
		new /obj/effect/portal(get_turf(newchar), null, 5 SECONDS, 0)
		shake_camera(newchar, 3, 1)
	newchar.druggy = 3
	newchar.Weaken(3)
	to_chat(newchar, "<span class='danger'>Your trip through the frontier gateway is like nothing you have ever experienced!</span>")
	to_chat(newchar, "In fact, it was like your consciousness was ripped from your body and then hammered back inside moments later.")
	to_chat(newchar, "However, you've made it to the uncharted frontier. You don't know when you'll be able to return to the places you've left behind.")
	to_chat(newchar, "No time to think about that, your first priority is to get your bearings and find a job that pays. Whatever you decide to do in this new frontier, you're going to need a lot more cash than what you have now.")

//Example for adding map specific starter uniforms
/datum/map/nexus/populate_uniforms(var/client/C)
	. = ..()
	switch(C.prefs.cultural_info[TAG_CULTURE])
		if(CULTURE_HUMAN_SPACER)
			. |= new /obj/item/clothing/under/blazer()
	
