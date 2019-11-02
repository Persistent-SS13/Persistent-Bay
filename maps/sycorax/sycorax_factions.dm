//Faction for nexus citizens
/obj/faction_spawner/democratic/Nexus
	name 			= "Sycorax Administration"
	name_short 		= "Sycorax"
	name_tag 		= "SX"
	uid 			= NEXUS_FACTION_CITIZEN
	password 		= ""
	network_name 	= "SYCORAX-NET"//"NexusNet"
	network_uid 	= "sx_net"
	purpose 		= "To represent the citizenship of Sycorax Station and keep the station operating."
	starter_outfit	= /decl/hierarchy/outfit/nexus/citizen

	//Mapper helpers
	icon 			= 'icons/misc/map_helpers.dmi'
	icon_state 		= "faction"

//Null faction
/obj/faction_spawner/Freemen
	name 			= "None"
	name_short 		= "None"
	name_tag 		= "NO"
	uid 			= NEXUS_FACTION_RESIDENT
	password 		= ""
	network_name 	= "FreeNet"
	network_uid 	= "free_net"
	starter_outfit	= /decl/hierarchy/outfit/nexus/starter

	//Mapper helpers
	icon 			= 'icons/misc/map_helpers.dmi'
	icon_state 		= "faction"
