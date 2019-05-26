//Faction for nexus citizens
/obj/faction_spawner/democratic/Nexus
	name 			= "Nexus City Government"
	name_short 		= "Nexus"
	name_tag 		= "NX"
	uid 			= "nexus"
	password 		= ""
	network_name 	= "NEXUSGOV-NET"//"NexusNet"
	network_uid 	= "nx_net"
	purpose 		= "To represent the citizenship of Nexus and keep the station operating."
	starter_outfit	= /decl/hierarchy/outfit/nexus/citizen

	//Mapper helpers
	icon 			= 'icons/misc/map_helpers.dmi'
	icon_state 		= "faction"

//Faction for slums denizens
/obj/faction_spawner/Freemen
	name 			= "Resident"
	name_short 		= "Resident"
	name_tag 		= "RD"
	uid 			= "resident"
	password 		= ""
	network_name 	= "FreeNet"
	network_uid 	= "free_net"
	starter_outfit	= /decl/hierarchy/outfit/nexus/starter

	//Mapper helpers
	icon 			= 'icons/misc/map_helpers.dmi'
	icon_state 		= "faction"
