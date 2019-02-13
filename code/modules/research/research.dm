/*
General Explination:
The research datum is the "folder" where all the research information is stored in a R&D console. It's also a holder for all the
various procs used to manipulate it. It has four variables and seven procs:

Variables:
- possible_tech is a list of all the /datum/tech that can potentially be researched by the player. The RefreshResearch() proc
(explained later) only goes through those when refreshing what you know. Generally, possible_tech contains ALL of the existing tech
but it is possible to add tech to the game that DON'T start in it (example: Xeno tech). Generally speaking, you don't want to mess
with these since they should be the default version of the datums. They're actually stored in a list rather then using typesof to
refer to them since it makes it a bit easier to search through them for specific information.
- know_tech is the companion list to possible_tech. It's the tech you can actually research and improve. Until it's added to this
list, it can't be improved. All the tech in this list are visible to the player.
- possible_designs is functionally identical to possbile_tech except it's for /datum/design.
- known_designs is functionally identical to known_tech except it's for /datum/design

Procs:
- TechHasReqs: Used by other procs (specifically RefreshResearch) to see whether all of a tech's requirements are currently in
known_tech and at a high enough level.
- DesignHasReqs: Same as TechHasReqs but for /datum/design and known_design.
- AddTech2Known: Adds a /datum/tech to known_tech. It checks to see whether it already has that tech (if so, it just replaces it). If
it doesn't have it, it adds it. Note: It does NOT check possible_tech at all. So if you want to add something strange to it (like
a player made tech?) you can.
- AddDesign2Known: Same as AddTech2Known except for /datum/design and known_designs.
- RefreshResearch: This is the workhorse of the R&D system. It updates the /datum/research holder and adds any unlocked tech paths
and designs you have reached the requirements for. It only checks through possible_tech and possible_designs, however, so it won't
accidentally add "secret" tech to it.
- UpdateTech is used as part of the actual researching process. It takes an ID and finds techs with that same ID in known_tech. When
it finds it, it checks to see whether it can improve it at all. If the known_tech's level is less then or equal to
the inputted level, it increases the known tech's level to the inputted level -1 or know tech's level +1 (whichever is higher).

The tech datums are the actual "tech trees" that you improve through researching. Each one has five variables:
- Name:		Pretty obvious. This is often viewable to the players.
- Desc:		Pretty obvious. Also player viewable.
- ID:		This is the unique ID of the tech that is used by the various procs to find and/or maniuplate it.
- Level:	This is the current level of the tech. All techs start at 1 and have a max of 20. Devices and some techs require a certain
level in specific techs before you can produce them.
- Req_tech:	This is a list of the techs required to unlock this tech path. If left blank, it'll automatically be loaded into the
research holder datum.

*/
/***************************************************************
**						Master Types						  **
**	Includes all the helper procs and basic tech processing.  **
***************************************************************/

/datum/research								//Holder for all the existing, archived, and known tech. Individual to console.
	var/list/known_tech = list()			//List of locally known tech. Datum/tech go here.
	var/list/possible_designs = list()		//List of all designs.
	var/list/known_designs = list()			//List of available designs.

	var/list/tech_entries = list()

	var/list/gen_fab = list()
	var/list/eng_fab = list()
	var/list/med_fab = list()
	var/list/mech_fab = list()
	var/list/void_fab = list()
	var/list/ammo_fab = list()
	var/list/accessory_at = list()
	var/list/standard_at = list()
	var/list/nonstandard_at = list()
	var/list/tactical_at = list()
	var/list/storage_at = list()
	var/list/circuit_fab = list()



/datum/research/New()		//Insert techs into possible_tech here. Known_tech automatically updated.
	for(var/T in typesof(/datum/tech) - /datum/tech)
		known_tech += new T(src)
	for(var/T in typesof(/datum/tech_entry) - /datum/tech_entry)
		tech_entries += new T(src)
	for(var/x in typesof(/datum/design) - /datum/design)
		var/datum/design/D = new x(src)
		if(!D.build_path) continue
		possible_designs |= D
		if(islist(D.build_type))
			for(var/y in D.build_type)
				switch(y)
					if(GENERALFAB)
						gen_fab |= D
					if(ENGIFAB)
						eng_fab |= D
					if(MEDIFAB)
						med_fab |= D
					if(MECHFAB)
						mech_fab |= D
					if(VOIDFAB)
						void_fab |= D
					if(AMMOFAB)
						ammo_fab |= D
					if(AUTOTAILOR_ACCESSORIES)
						accessory_at |= D
					if(AUTOTAILOR_NONSTANDARD)
						nonstandard_at |= D
					if(AUTOTAILOR)
						standard_at |= D
					if(AUTOTAILOR_STORAGE)
						storage_at |= D
					if(AUTOTAILOR_TACTICAL)
						tactical_at |= D
					if(CIRCUITFAB)
						circuit_fab |= D

		else
			switch(D.build_type)
				if(GENERALFAB)
					gen_fab |= D
				if(ENGIFAB)
					eng_fab |= D
				if(MEDIFAB)
					med_fab |= D
				if(MECHFAB)
					mech_fab |= D
				if(VOIDFAB)
					void_fab |= D
				if(AMMOFAB)
					ammo_fab |= D
				if(AUTOTAILOR_ACCESSORIES)
					accessory_at |= D
				if(AUTOTAILOR_NONSTANDARD)
					nonstandard_at |= D
				if(AUTOTAILOR)
					standard_at |= D
				if(AUTOTAILOR_STORAGE)
					storage_at |= D
				if(AUTOTAILOR_TACTICAL)
					tactical_at |= D
				if(CIRCUITFAB)
					circuit_fab |= D

	RefreshResearch()

/datum/research/proc/get_tech_entry(var/uid)
	for(var/datum/tech_entry/tech in tech_entries)
		if(tech.uid == uid) return tech
	return 0

/datum/research/proc/get_research_options(var/build_type)
	switch(build_type)
		if(GENERALFAB)
			return gen_fab
		if(ENGIFAB)
			return eng_fab
		if(MEDIFAB)
			return med_fab
		if(MECHFAB)
			return mech_fab
		if(VOIDFAB)
			return void_fab
		if(AMMOFAB)
			return ammo_fab
		if(AUTOTAILOR_ACCESSORIES)
			return accessory_at
		if(AUTOTAILOR_NONSTANDARD)
			return nonstandard_at
		if(AUTOTAILOR)
			return standard_at
		if(AUTOTAILOR_STORAGE)
			return storage_at
		if(AUTOTAILOR_TACTICAL)
			return tactical_at
		if(CIRCUITFAB)
			return circuit_fab

/datum/research/techonly

/datum/research/techonly/New()
	for(var/T in typesof(/datum/tech) - /datum/tech)
		known_tech += new T(src)
	RefreshResearch()

//Checks to see if design has all the required pre-reqs.
//Input: datum/design; Output: 0/1 (false/true)
/datum/research/proc/DesignHasReqs(var/datum/design/D)
	if(D.req_tech.len == 0)
		return 1

	var/list/k_tech = list()

	for(var/datum/tech/known in known_tech)
		k_tech[known.id] = known.level

	for(var/req in D.req_tech)
		if(isnull(k_tech[req]) || k_tech[req] < D.req_tech[req])
			return 0

	return 1

//Adds a tech to known_tech list. Checks to make sure there aren't duplicates and updates existing tech's levels if needed.
//Input: datum/tech; Output: Null
/datum/research/proc/AddTech2Known(var/datum/tech/T)
	for(var/datum/tech/known in known_tech)
		if(T.id == known.id)
			if(T.level > known.level)
				known.level = T.level
			return
	return

/datum/research/proc/AddDesign2Known(var/datum/design/D)
	if(!D) return
	if(!known_designs.len) // Special case
		known_designs.Add(D)
		return
	for(var/i = 1 to known_designs.len)
		var/datum/design/A = known_designs[i]
		if(!A) continue
		if(A.id == D.id) // We are guaranteed to reach this if the ids are the same, because sort_string will also be the same
			return
		if(A.sort_string > D.sort_string)
			known_designs.Insert(i, D)
			return
	known_designs.Add(D)
	return

//Refreshes known_tech and known_designs list
//Input/Output: n/a
/datum/research/proc/RefreshResearch()
	for(var/datum/design/PD in possible_designs)
		if(DesignHasReqs(PD))
			AddDesign2Known(PD)
	for(var/datum/tech/T in known_tech)
		T = between(0, T.level, 20)
	return

//Refreshes the levels of a given tech.
//Input: Tech's ID and Level; Output: null
/datum/research/proc/UpdateTech(var/ID, var/level)
	for(var/datum/tech/KT in known_tech)
		if(KT.id == ID && KT.level <= level)
			KT.level = max(KT.level + 1, level - 1)
	return

// A simple helper proc to find the name of a tech with a given ID.
/proc/CallTechName(var/ID)
	for(var/T in subtypesof(/datum/tech))
		var/datum/tech/check_tech = T
		if(initial(check_tech.id) == ID)
			return  initial(check_tech.name)





/***************************************************************
**						brawlTechnology Datums				  **
** 							aaa								  **/
//***************************************************************

#define TECH_ENGI 1
#define TECH_MEDI 2
#define TECH_WAR 3
#define TECH_CONSUMER 4
#define TECH_GENERAL 5
/datum/tech_entry
	var/name
	var/desc
	var/uid
	var/tier = 1
	var/category = TECH_ENGI
	var/points = 150
	var/list/prereqs = list()

/datum/tech_entry/engi
	category = TECH_ENGI
/datum/tech_entry/medi
	category = TECH_MEDI
/datum/tech_entry/combat
	category = TECH_WAR
/datum/tech_entry/consumer
	category = TECH_CONSUMER
/datum/tech_entry/general
	category = TECH_GENERAL

/datum/tech_entry/general/capacitor/adv_capacitor
	name = "Advanced capacitors"
	desc = "Capacitors can be rearranged and redesigned to hold more current with less capacity for failure. Unlocks advanced capacitor designs for the appropriate fabricators."
	tier = 1
	points = 150
	uid = "adv_capacitor"

/datum/tech_entry/general/capacitor/super_capacitor
	name = "Super capacitance"
	desc = "Uranium alloys can be used to develop devices with super capacitance, which can be changed by running eletric charges at a cross-variance through the alloy. Unlocks super capacitor designs for the appropriate fabricators."
	tier = 2
	points = 400
	uid = "super_capacitor"
	prereqs = list("adv_capacitor")


/datum/tech_entry/general/manipulator/nano_mani
	name = "Nano-manipulators"
	desc = "Smaller manipulators can perform more operations before its machine or device needs to stop and readjust it. Unlocks nano manipulator designs for the appropriate fabricators."
	tier = 1
	points = 150
	uid = "nano_mani"

/datum/tech_entry/general/manipulator/pico_mani
	name = "Pico-miniturazied manipulators"
	desc = "Application of phoron allows for an even smaller set of manipulator designs. Unlocks pico manipulator designs for the appropriate fabricators."
	tier = 2
	points = 400
	uid = "pico_mani"
	prereqs = list("nano_mani")

/datum/tech_entry/general/bin/adv_matter_bin
	name = "Advanced matter bins"
	desc = "The matter bins need to store a variety of distinct materials as efficently as possible while still having them equally accessible by its machine. Unlocks advanced matter bin designs for the appropriate fabricators."
	tier = 1
	points = 150
	uid = "adv_matter_bin"

/datum/tech_entry/general/bin/super_matter_bin
	name = "Super dense matter storage"
	desc = "A device enriched with phoron could store materials in a super dense state. Unlocks super matter bin designs for the appropriate fabricators."
	tier = 2
	points = 400
	uid = "super_matter_bin"
	prereqs = list("adv_matter_bin")

/datum/tech_entry/general/micro_laser/high_micro_laser
	name = "High intensity micro lasers"
	desc = "Micro lasers project beams capable of slicing materials and a higher intensity model could work faster. Unlocks high intensity micro laser designs for the appropriate fabricators."
	tier = 1
	points = 150
	uid = "high_micro_laser"

/datum/tech_entry/general/micro_laser/ultra_micro_laser
	name = "Ultra intensity micro lasers"
	desc = "A diamond focusing lense goes into a new model of micro laser that works at an even higher intensity. Unlocks ultra intensity micro laser designs for the appropriate fabricators."
	tier = 2
	points = 400
	uid = "ultra_micro_laser"
	prereqs = list("high_micro_laser")

/datum/tech_entry/general/sensor/adv_sensor
	name = "Advanced sensors"
	desc = "An advanced sensor could transmit more accurate input data to whatever machine or device uses it. Unlocks advanced sensor designs for the appropriate fabricators."
	tier = 1
	points = 150
	uid = "adv_sensor"

/datum/tech_entry/general/sensor/phasic_sensor
	name = "Multi-Phasic Sensor Technique"
	desc = "A technique for sensors that uses phoron to analyze matter in mulitple electro-spectrum phases. Unlocks phasic sensor designs for the appropriate fabricators."
	tier = 2
	points = 400
	uid = "phasic_sensor"
	prereqs = list("adv_sensor")

/datum/tech_entry/general/powercell/high
	name = "High-capacity power cells"
	desc = "Reconfiguring and improving the materials in powercells can improve their capacity. Unlocks high-capacity power cell & high-capacity device cell designs for the appropriate fabricators."
	tier = 1
	points = 100
	uid = "cell_high"

/datum/tech_entry/general/powercell/super
	name = "Super-capacity power cells"
	desc = "Uranium can be used throughout the design of a cell to greatly improve its potential capacity. Unlocks super-capacity power cell designs for the appropriate fabricators."
	tier = 2
	points = 400
	uid = "cell_super"
	prereqs = list("cell_high")

/datum/tech_entry/general/powercell/hyper
	name = "Hyper-capacity power cells"
	desc = "Phoron and uranium can be applied together to create a cell of maximum possible capacity. Unlocks hyper-capacity power cell designs for the appropriate fabricators."
	tier = 3
	points = 1000
	uid = "cell_hyper"
	prereqs = list("cell_high", "cell_super")



/***************************************************************
**						Technology Datums					  **
**	Includes all the various technoliges and what they make.  **
***************************************************************/

/datum/tech //Datum of individual technologies.
	var/name = "name"					//Name of the technology.
	var/desc = "description"			//General description of what it does and what it makes.
	var/id = "id"						//An easily referenced ID. Must be alphanumeric, lower-case, and no symbols.
	var/level = 1						//A simple number scale of the research level. Level 0 = Secret tech.

/datum/tech/materials
	name = "Materials Research"
	desc = "Development of new and improved materials."
	id = TECH_MATERIAL

/datum/tech/engineering
	name = "Engineering Research"
	desc = "Development of new and improved engineering parts."
	id = TECH_ENGINEERING

/datum/tech/phorontech
	name = "Phoron Research"
	desc = "Research into the mysterious substance colloqually known as 'phoron'."
	id = TECH_PHORON

/datum/tech/powerstorage
	name = "Power Manipulation Technology"
	desc = "The various technologies behind the storage and generation of electicity."
	id = TECH_POWER

/datum/tech/bluespace
	name = "'Blue-space' Research"
	desc = "Research into the sub-reality known as 'blue-space'"
	id = TECH_BLUESPACE

/datum/tech/biotech
	name = "Biological Technology"
	desc = "Research into the deeper mysteries of life and organic substances."
	id = TECH_BIO

/datum/tech/combat
	name = "Combat Systems Research"
	desc = "The development of offensive and defensive systems."
	id = TECH_COMBAT

/datum/tech/magnets
	name = "Electromagnetic Spectrum Research"
	desc = "Research into the electromagnetic spectrum. No clue how they actually work, though."
	id = TECH_MAGNET

/datum/tech/programming
	name = "Data Theory Research"
	desc = "The development of new computer and artificial intelligence and data storage systems."
	id = TECH_DATA

/datum/tech/syndicate
	name = "Illegal Technologies Research"
	desc = "The study of technologies that violate standard government regulations."
	id = TECH_ILLEGAL
	level = 0

/datum/tech/arcane
	name = "Arcane Research"
	desc = "Research into the occult and arcane field for use in practical science"
	id = TECH_ARCANE
	level = 0

/obj/item/weapon/disk/tech_disk
	name = "technology disk"
	desc = "A disk for storing technology data for further research."
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk2"
	item_state = "card-id"
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_STEEL = 30, MATERIAL_GLASS = 10)
	var/datum/tech/stored


/obj/item/weapon/disk/design_disk
	name = "component design disk"
	desc = "A disk for storing device design data for construction in lathes."
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk2"
	item_state = "card-id"
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_STEEL = 30, MATERIAL_GLASS = 10)
	var/datum/design/blueprint
