//Faction for sycorax citizens
/obj/faction_spawner/democratic/Sycorax
	name 			= "Sycorax Administration"
	name_short 		= "Sycorax"
	name_tag 		= "SX"
	uid 			= SYCORAX_FACTION_CITIZEN
	password 		= ""
	network_name 	= "SYCORAX-NET"
	network_uid 	= "sx_net"
	purpose 		= "To represent the citizenship of Sycorax and keep the station operating."
	starter_outfit	= /decl/hierarchy/outfit/sycorax/citizen

	//Mapper helpers
	icon 			= 'icons/misc/map_helpers.dmi'
	icon_state 		= "faction"

//Null faction
/obj/faction_spawner/Freemen
	name 			= "None"
	name_short 		= "None"
	name_tag 		= "NO"
	uid 			= SYCORAX_FACTION_RESIDENT
	password 		= ""
	network_name 	= "FreeNet"
	network_uid 	= "free_net"
	starter_outfit	= /decl/hierarchy/outfit/sycorax/starter

	//Mapper helpers
	icon 			= 'icons/misc/map_helpers.dmi'
	icon_state 		= "faction"
