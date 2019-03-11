/obj/faction_spawner/democratic/Nexus
	name 			= "Nexus City Government"
	name_short 		= "Nexus"
	name_tag 		= "NX"
	uid 			= "nexus"
	password 		= ""
	network_name 	= "NEXUSGOV-NET"//"NexusNet"
	network_uid 	= "nx_net"
	purpose 		= "To represent the citizenship of Nexus and keep the station operating."

	//Mapper helpers
	icon 			= 'icons/misc/map_helpers.dmi'
	icon_state 		= "faction"

/obj/faction_spawner/democratic/Nexus/New()
	if(!GLOB.all_world_factions)
		GLOB.all_world_factions = list()
	for(var/datum/world_faction/existing_faction in GLOB.all_world_factions)
		if(existing_faction.uid == uid)
			qdel(src)
			return
	var/datum/world_faction/democratic/nexus = new()
	nexus.name = src.name
	nexus.abbreviation = src.name_short
	nexus.short_tag = src.name_tag
	nexus.purpose = src.purpose
	nexus.uid = src.uid
	nexus.gov = new()
	var/datum/election/gov/gov_elect = new()
	gov_elect.ballots |= nexus.gov

	nexus.waiting_elections |= gov_elect

	var/datum/election/council_elect = new()
	var/datum/democracy/councillor/councillor1 = new()
	councillor1.title = "Councillor of Justice and Criminal Matters"
	nexus.city_council |= councillor1
	council_elect.ballots |= councillor1

	var/datum/democracy/councillor/councillor2 = new()
	councillor2.title = "Councillor of Budget and Tax Measures"
	nexus.city_council |= councillor2
	council_elect.ballots |= councillor2

	var/datum/democracy/councillor/councillor3 = new()
	councillor3.title = "Councillor of Commerce and Business Relations"
	nexus.city_council |= councillor3
	council_elect.ballots |= councillor3

	var/datum/democracy/councillor/councillor4 = new()
	councillor4.title = "Councillor for Culture and Ethical Oversight"
	nexus.city_council |= councillor4
	council_elect.ballots |= councillor4

	var/datum/democracy/councillor/councillor5 = new()
	councillor5.title = "Councillor for the Domestic Affairs"
	nexus.city_council |= councillor5
	council_elect.ballots |= councillor5

	nexus.waiting_elections |= council_elect

	nexus.network.name = src.network_name
	nexus.network.net_uid = src.network_uid
	nexus.network.password = src.password
	nexus.network.invisible = FALSE

	GLOB.all_world_factions |= nexus

/obj/faction_spawner/Freemen
	name 			= "Null"
	name_short 		= "Null"
	name_tag 		= "Null"
	uid 			= "null"
	password 		= null
	network_name 	= "FreeNet"
	network_uid 	= "free_net"

	//Mapper helpers
	icon 			= 'icons/misc/map_helpers.dmi'
	icon_state 		= "faction"
