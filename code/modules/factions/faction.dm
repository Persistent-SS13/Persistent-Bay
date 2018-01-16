GLOBAL_LIST_EMPTY(all_world_factions)
/datum/world_faction
	var/name = "" // can be safely changed
	var/name_short = "" // 
	var/uid = "" // THIS SHOULD NEVER BE CHANGED!
	var/password = "password" // this is used to access the factions 
	var/list/assignment_catagories = list()
	var/list/access_catagories = list()
	var/datum/records_holder/records
	var/datum/ntnet/network
/datum/world_faction/New()
	network = new()
	records = new()
/datum/records_holder
	var/use_standard = 1
	var/custom_records = list() // format-- list("")
	var/faction_records = list() // stores all employee record files
/datum/assignment_category
	var/name = ""
	var/list/assignments = list()
	var/datum/assignment/head_position
	var/datum/world_faction/parent
/datum/assignment
	var/name = ""
	var/list/accesses = list()
	var/datum/assignment_category/parent
/datum/access_category
	var/name = ""
	var/list/accesses = list() // format-- list("11" = "Bridge Access")
	
/obj/faction_spawner
	name = "Name to start faction with"
	var/name_short = "Faction shortname"
	var/uid = "faction_uid"
	var/password = "starting_password"
	var/network_name = "network name"
	var/network_uid = "network_uid"
	var/network_password
	var/network_invisible = 0
/obj/faction_spawner/New()
	for(var/datum/world_faction/existing_faction in GLOB.all_world_factions)
		if(existing_faction.uid == uid)
			qdel(src)
			return
	var/datum/world_faction/fact = new()
	fact.name = name
	fact.name_short = name_short
	fact.uid = uid
	fact.password = password
	fact.network.name = network_name
	fact.network.net_uid = network_uid
	if(network_password)
		fact.network.secured = 1
		fact.network.password = network_password
	fact.network.invisible = network_invisible
	qdel(src)
	return
/obj/faction_spawner/Nanotrasen
	name = "Nanotrasen Corporate Colony"
	name_short = "Nanotrasen"
	uid = "nanotrasen"
	password = "rosebud"
	network_name = "Nanotrasen Network"
	network_uid = "nt_net"
