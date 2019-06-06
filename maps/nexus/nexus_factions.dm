//Faction for nexus citizens
/obj/faction_spawner/democratic/Nexus
	name 			= "Nexus City Government"
	name_short 		= "Nexus"
	name_tag 		= "NX"
	uid 			= NEXUS_FACTION_CITIZEN
	password 		= ""
	network_name 	= "NEXUSGOV-NET"//"NexusNet"
	network_uid 	= "nx_net"
	purpose 		= "To represent the citizenship of Nexus and keep the station operating."
	starter_outfit	= /decl/hierarchy/outfit/nexus/citizen
	starter_phorosian_outfit	= /decl/hierarchy/outfit/phorosian/nexus
	starter_vox_outfit	= /decl/hierarchy/outfit/vox/nexus

	//Mapper helpers
	icon 			= 'icons/misc/map_helpers.dmi'
	icon_state 		= "faction"

//Faction for slums denizens
/obj/faction_spawner/Freemen
	name 			= "Resident"
	name_short 		= "Resident"
	name_tag 		= "RD"
	uid 			= NEXUS_FACTION_RESIDENT
	password 		= ""
	network_name 	= "FreeNet"
	network_uid 	= "free_net"
	starter_outfit	= /decl/hierarchy/outfit/nexus/starter
	starter_phorosian_outfit	= /decl/hierarchy/outfit/phorosian/nexus
	starter_vox_outfit	= /decl/hierarchy/outfit/vox/nexus
	
	//Mapper helpers
	icon 			= 'icons/misc/map_helpers.dmi'
	icon_state 		= "faction"
