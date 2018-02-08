GLOBAL_LIST_EMPTY(all_world_factions)
#define core_access_leader 1
#define core_access_command_programs 2
#define core_access_engineering_programs 3
#define core_access_medical_programs 4
#define core_access_security_programs 5
#define core_access_wireless_programs 6
/proc/get_faction(var/name, var/password)
	if(password)
		var/datum/world_faction/found_faction
		for(var/datum/world_faction/fac in GLOB.all_world_factions)
			if(fac.uid == name) 
				found_faction = fac 
				break
		if(!found_faction) return
		if(found_faction.password != password) return
		return found_faction
	var/datum/world_faction/found_faction
	for(var/datum/world_faction/fac in GLOB.all_world_factions)
		if(fac.uid == name) 
			found_faction = fac 
			break
	if(!found_faction) return
	return found_faction
/datum/world_faction
	var/name = "" // can be safely changed
	var/abbreviation = "" // can be safely changed
	var/purpose = "" // can be safely changed
	var/uid = "" // THIS SHOULD NEVER BE CHANGED!
	var/password = "password" // this is used to access the faction, can be safely changed
	var/list/assignment_categories = list()
	var/list/access_categories = list()
	var/list/all_access = list() // format list("10", "11", "12", "13") used to determine which accesses are already given out. 
	var/datum/records_holder/records
	var/datum/ntnet/network
	
	var/allow_id_access = 0 // allows access off the ID (the IDs access var instead of directly from faction records, assuming its a faction-approved ID
	var/allow_unapproved_ids = 0 // allows ids that are not faction-approved or faction-created to still be used to access doors IF THE registered_name OF THE CARD HAS VALID RECORDS ON FILE or allow_id_access is set to 1
/datum/world_faction/New()
	network = new()
	records = new()
/datum/world_faction/proc/rebuild_all_access()
	all_access = list()
	for(var/datum/access_category/access_category in access_categories)
		for(var/x in access_category.accesses)
			all_access |= x
/datum/records_holder
	var/use_standard = 1
	var/list/custom_records = list() // format-- list("")
	var/list/faction_records = list() // stores all employee record files, format-- list("[M.real_name]" = /datum/crew_record)
/datum/world_faction/proc/get_records()
	return records.faction_records
/datum/world_faction/proc/get_record(var/real_name)
	return records.faction_records.Find(real_name)
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
	var/name_short = "Faction Abbreviation"
	var/uid = "faction_uid"
	var/password = "starting_password"
	var/network_name = "network name"
	var/network_uid = "network_uid"
	var/network_password
	var/network_invisible = 0
/obj/faction_spawner/New()
	if(!GLOB.all_world_factions)
		GLOB.all_world_factions = list()
	for(var/datum/world_faction/existing_faction in GLOB.all_world_factions)
		if(existing_faction.uid == uid)
			qdel(src)
			return
	var/datum/world_faction/fact = new()
	fact.name = name
	fact.abbreviation = name_short
	fact.uid = uid
	fact.password = password
	fact.network.name = network_name
	fact.network.net_uid = network_uid
	if(network_password)
		fact.network.secured = 1
		fact.network.password = network_password
	fact.network.invisible = network_invisible
	GLOB.all_world_factions |= fact
	qdel(src)
	return
/obj/faction_spawner/Nanotrasen
	name = "Nanotrasen Corporate Colony"
	name_short = "Nanotrasen"
	uid = "nanotrasen"
	password = "rosebud"
	network_name = "Nanotrasen Network"
	network_uid = "nt_net"

	