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
	var/list/consumer_fab = list()
	var/list/service_fab = list()
	var/list/storage_fab = list()
	var/list/science_fab = list()
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
					if(MEDICALFAB)
						med_fab |= D
					if(MECHFAB)
						mech_fab |= D
					if(VOIDFAB)
						void_fab |= D
					if(WEAPONFAB)
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
					if(CONSUMERFAB)
						consumer_fab |= D
					if(SERVICEFAB)
						service_fab |= D
					if(STORAGEFAB)
						storage_fab |= D
					if(SCIENCEFAB)
						science_fab |= D
		else
			switch(D.build_type)
				if(GENERALFAB)
					gen_fab |= D
				if(ENGIFAB)
					eng_fab |= D
				if(MEDICALFAB)
					med_fab |= D
				if(MECHFAB)
					mech_fab |= D
				if(VOIDFAB)
					void_fab |= D
				if(WEAPONFAB)
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
				if(CONSUMERFAB)
					consumer_fab |= D
				if(SERVICEFAB)
					service_fab |= D
				if(STORAGEFAB)
					storage_fab |= D
				if(SCIENCEFAB)
					science_fab |= D
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
		if(MEDICALFAB)
			return med_fab
		if(MECHFAB)
			return mech_fab
		if(VOIDFAB)
			return void_fab
		if(WEAPONFAB)
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
		if(CONSUMERFAB)
			return consumer_fab
		if(SERVICEFAB)
			return service_fab
		if(STORAGEFAB)
			return storage_fab
		if(SCIENCEFAB)
			return science_fab
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


/datum/tech_entry
	var/name
	var/desc
	var/uid
	var/tier = 1
	var/category = TECH_ENGI
	var/points = 150
	var/list/prereqs = list()
	var/uses = -10 // some techs will have limited uses. -10 is infinite

/datum/tech_entry/engi
	category = TECH_ENGI

/datum/tech_entry/medical
	category = TECH_MEDI

/datum/tech_entry/combat
	category = TECH_WAR
	uses = 3

/datum/tech_entry/consumer
	category = TECH_CONSUMER

/datum/tech_entry/general
	category = TECH_GENERAL


//////////////////////////////////////////////////
//////////////////////////////////////////////////
// Engineering designs
/////////////////////////////////////////////////


/datum/tech_entry/engi/fireaxe
	name = "Fireaxe design"
	desc = "The fireaxe can smash through airlocks to clear a path during engineering emergencies, particularly fires. Unlocks fireaxe designs for the appropriate fabricators."
	tier = 3
	points = 800
	uid = "fireaxe"

/datum/tech_entry/engi/inflatables
	name = "Inflatables"
	desc = "The infatable door and wall is an incredibly useful way to seal off areas in a hurry. Unlocks inflatable door & inflatable wall designs for the appropriate fabricators."
	tier = 1
	points = 150
	uid = "inflatables"

/datum/tech_entry/engi/combitool
	name = "Tool-miniaturization"
	desc = "Application of phoron allows for a device can function as several different tools. Unlocks combitool designs for the appropriate fabricators."
	tier = 3
	points = 650
	uid = "combitool"
	prereqs = list("nano_mani")

/datum/tech_entry/engi/rcd
	name = "Phoron-based rapid construction"
	desc = "Putting together a variety of advanced technologies, a method for rapidly constructing walls could be developed. Unlocks rapid construction device & rcd ammo designs for the appropriate fabricators."
	tier = 4
	points = 1500
	uid = "rcd"
	prereqs = list("super_matter_bin", "cell_super", "ultra_micro_laser")
	uses = 2

/datum/tech_entry/engi/welder_industrial
	name = "Industrial Fuel Storage"
	desc = "Larger welding fuel tanks make engineering work more efficent. Unlocks industrial welder designs for the appropriate fabricators."
	tier = 1
	points = 150
	uid = "welding_industrial"

/datum/tech_entry/engi/welder_industrial
	name = "High-Capacity Fuel Storage"
	desc = "Welding fuel tanks can be expanded even further for higher capacity. Unlocks high-capacity welder designs for the appropriate fabricators."
	tier = 2
	points = 300
	uid = "welding_huge"
	prereqs = list("welding_industrial")

/datum/tech_entry/engi/welder_experimental
	name = "Experimental Fuel Generation"
	desc = "The experimental welding tool uses phoron to create a tool that continually refills with fuel. Unlocks experimental welder designs for the appropriate fabricators."
	tier = 4
	points = 1400
	uid = "welding_experimental"
	prereqs = list("welding_industrial", "welding_huge")
	uses = 3

/datum/tech_entry/engi/airlock_brace
	name = "Airlock Bracing"
	desc = "The airlock brace can restrict areas and it can only be effectively removed using a brace jack. Unlocks airlock brace & brace jack designs for the appropriate fabricators."
	tier = 3
	points = 400
	uid = "bracejack"

/datum/tech_entry/engi/light_replacer
	name = "Magnetic Bulb-Swapping"
	desc = "Magnets attached to a device can make swapping out bulbs very fast and very easy. Unlocks light replacer designs for the appropriate fabricators."
	tier = 1
	points = 150
	uid = "lightreplacer"

/datum/tech_entry/engi/rped
	name = "Phoron-based Part-Swapping"
	desc = "Phoron applied with other conductors can create a device thats capable of swapping out parts without deconstructing the machine in question. Unlocks rapid part exchange device designs for the appropriate fabricators."
	tier = 2
	points = 400
	uid = "rped"
	prereqs = list("lightreplacer")


/datum/tech_entry/engi/mesons
	name = "Meson Optical Scanners"
	desc = "High end materials can be applied to create eyeware that can image a space station through walls.. Unlocks optical meson scanner designs for the appropriate fabricators."
	tier = 2
	points = 500
	uid = "mesons"

/datum/tech_entry/engi/nanopaste
	name = "Nanopaste Production"
	desc = "Nanopaste can be applied directly to damaged machines to repair them but it remains costly to produce. Unlocks nanopaste designs for the appropriate fabricators."
	tier = 1
	points = 150
	uid = "nanopaste"

/datum/tech_entry/engi/smes/standard
	name = "Improved Power Induction"
	desc = "Improving the techniques for power induction allows for faster SMES designs. Unlocks standard SMES coil designs for the appropriate fabricators."
	tier = 1
	points = 150
	uid = "smes_standard"


/datum/tech_entry/engi/smes/master
	name = "Mastered Power Induction"
	desc = "Induction can be further improved, but at a certain point their is a tradeoff between capacity and output speed.. Unlocks super capaciity & super io SMES coil designs for the appropriate fabricators."
	tier = 2
	points = 400
	uid = "smes_master"


/datum/tech_entry/engi/color_lights
	name = "Photon Spectral Prisms"
	desc = "Colored bulbs use a special light-refractal prism so they can be just as efficent as their normal counterparts. Unlocks colored bulb designs for the appropriate fabricators."
	tier = 1
	points = 100
	uid = "color_lights"

/datum/tech_entry/engi/carpeting
	name = "Fancy Carpeting"
	desc = "With a little sensibility, fancy looking carpeting fabricated from cloth can be developed. Unlocks carpet designs for the appropriate fabricators."
	tier = 1
	points = 100
	uid = "carpets"
////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////
//////////////////////////////////////////////////
// Consumer designs
/////////////////////////////////////////////////

/datum/tech_entry/consumer/coffeecups
	name = "17% Better Coffee Cups"
	desc = "Applying focus group feedback loops leads to coffee cups with up to 17% better approval rating. Unlocks special coffee cups designs for the appropriate fabricators."
	tier = 1
	points = 75
	uid = "coffeecups"

/datum/tech_entry/consumer/flasks
	name = "Flasking Technology"
	desc = "Flasking means shaping metal for optimal storage of hard liqour. Unlocks flask designs for the appropriate fabricators."
	tier = 1
	points = 75
	uid = "flasks"

/datum/tech_entry/consumer/flora_gun
	name = "Rapid Flora Mutation"
	desc = "Develop a device that can prompt rapid mutations in plants. Unlocks floral somatoray designs for the appropriate fabricators."
	tier = 1
	points = 200
	uid = "floragun"

/datum/tech_entry/consumer/toys/plushie
	name = "Super-Cute Plushies"
	desc = "These plushies can attract customers in droves, and they are quite inexpensive. Unlocks the uncommon action figure designs for the appropriate fabricators."
	tier = 1
	points = 100
	uid = "plushie"


/datum/tech_entry/consumer/toys/figures_1
	name = "Uncommon Action Figures"
	desc = "By buying into the figurine tech tree, you will have exclusive access to increasingly rare figures. Unlocks the uncommon action figure designs for the appropriate fabricators."
	tier = 1
	points = 75
	uid = "figures_1"

/datum/tech_entry/consumer/toys/figures_2
	name = "Scarce Action Figures"
	desc = "These figures are much more engaging than the more common ones. Unlocks the scarce action figure designs for the appropriate fabricators."
	tier = 2
	points = 150
	uid = "figures_2"

/datum/tech_entry/consumer/toys/figures_3
	name = "Rare Action Figures"
	desc = "These action figures are high ranking and fantasy characters. Unlocks the rare action figure designs for the appropriate fabricators."
	tier = 3
	points = 300
	uid = "figures_3"
	uses = 10
/datum/tech_entry/consumer/toys/figures_4
	name = "Ultra-Rare Action Figures"
	desc = "Only a select few people should ever get these special figures. Unlocks the rare action figure designs for the appropriate fabricators."
	tier = 4
	points = 600
	uid = "figures_4"
	uses = 1

/datum/tech_entry/consumer/unusal_trees
	name = "Spacial Garneding"
	desc = "this allows you to appease them with a unusal shrubbery."
	tier = 1
	points = 75
	uid = "unusal_trees"

//////////////////////////////////////////////////
//////////////////////////////////////////////////
// Combat designs
/////////////////////////////////////////////////

/datum/tech_entry/combat/grenades/smoke
	name = "Smoke Deployment"
	desc = "Develop grenades that emit a concealing smoke. Unlocks smoke grenade designs for the appropriate fabricators."
	tier = 2
	points = 400
	uid = "grenade_smoke"
	prereqs = list("grenade_chem")

/datum/tech_entry/combat/grenades/flashbang
	name = "Flash Emmitance"
	desc = "Develop grenades that flash nearby combatants. Unlocks flash grenade designs for the appropriate fabricators."
	tier = 2
	points = 400
	uid = "grenade_flash"
	prereqs = list("grenade_chem")

/datum/tech_entry/combat/grenades/emp
	name = "Minature EMP Implementation"
	desc = "Develop grenades that use an EMP signal to disrupt electronics. Unlocks EMP grenade designs for the appropriate fabricators."
	tier = 3
	points = 700
	uid = "grenade_emp"
	prereqs = list("grenade_flash")

/datum/tech_entry/combat/grenades/frag
	name = "Frag Grenade Implementation"
	desc = "Develop fragmentation grenades that deal heavy damage to infantry. Unlocks fragmentation grenade designs for the appropriate fabricators."
	tier = 3
	points = 700
	uid = "grenade_frag"
	prereqs = list("grenade_smoke")

/datum/tech_entry/combat/grenades/chem
	name = "Rapid Chem Scattering"
	desc = "Develop grenades that can be filled with chemicals to achieve different effects. Unlocks chem grenade designs for the appropriate fabricators."
	tier = 1
	points = 200
	uid = "grenade_chem"

/datum/tech_entry/combat/grenades/anti_photon
	name = "Anti-Photon Experimental Nodules"
	desc = "Develop experimental grenades that suck in light to create dark areas. Unlocks anti-photon grenade designs for the appropriate fabricators."
	tier = 4
	points = 900
	uid = "grenade_photon"
	prereqs = list("grenade_emp")
	uses = -10



// MINING Equipment

/datum/tech_entry/combat/mining/basic_rock
	name = "Rock Shattering"
	desc = "Hand-held drills can be used to drill into asteroids to get valuable ores. Unlocks hand-held drill designs for the appropriate fabricators."
	tier = 1
	points = 150
	uid = "mining_1"
	uses = -10

/datum/tech_entry/combat/mining/sonic_jackhammer
	name = "Sonic Hammering"
	desc = "The sonic jackhammer can smash into asteroids by projecting sonic waves. Unlocks sonic jackhammer designs for the appropriate fabricators."
	tier = 2
	points = 300
	uid = "mining_2"
	uses = -10
	prereqs = list("mining_1")

/datum/tech_entry/combat/mining/diamond_edge
	name = "Perfect Diamond Edge"
	desc = "Diamond can be refined into a perfect tip by applying high value materials. Unlocks diamond pickaxe designs for the appropriate fabricators."
	tier = 3
	points = 600
	uid = "mining_3"
	uses = -10
	prereqs = list("mining_2")

/datum/tech_entry/combat/mining/diamond_drill
	name = "Diamond Drilling"
	desc = "The hand-held diamond drill is the final word in personal drilling. Unlocks diamond drill designs for the appropriate fabricators."
	tier = 4
	points = 1200
	uid = "mining_4"
	uses = -10
	prereqs = list("mining_3")

/datum/tech_entry/combat/mining/plasma_cutter
	name = "Plasma Cutter"
	desc = "The plasma cutter is a weapon designed for use in EVA, and a tool for mining.. Unlocks plasma cutter designs for the appropriate fabricators."
	tier = 2
	points = 400
	uid = "plasma_cutter"
	uses = 3
	prereqs = list("mining_1")




// STUN WEAPONS


/datum/tech_entry/combat/taser/carbine
	name = "Improved Tasers"
	desc = "By improving capacitors in stun weapons concentrated energy bolts can be developed. Unlocks taser carbine designs for the appropriate fabricators."
	tier = 1
	points = 200
	uid = "stun_1"
	uses = -10
/datum/tech_entry/combat/taser/revolver
	name = "Advanced stun weapons"
	desc = "The schematics for powerful stun revolver and stun rifle designs could be developed. Unlocks stun revolver & stun rifle designs for the appropriate fabricators."
	tier = 2
	points = 400
	uid = "stun_2"
	prereqs = list("stun_1")
	uses = -10
/datum/tech_entry/combat/taser/plasmastun
	name = "Concussive Plasma Bolts"
	desc = "The final word in non-lethal weaponry. Unlocks plasma pulse projector designs for the appropriate fabricators."
	tier = 3
	points = 700
	uid = "stun_3"
	prereqs = list("stun_2")
	uses = -10
// END STUN WEAPONS

// BALLISTIC WEAPONS

/datum/tech_entry/combat/proj/pistol
	name = "Improved Pistols"
	desc = "A variety of pistol designs could be put together quite easily. Unlocks a variety of simple pistol designs for the appropriate fabricators."
	tier = 1
	points = 175
	uid = "pistol_1"
	uses = -10
/datum/tech_entry/combat/proj/shotgun
	name = "Double Barrel Rifling"
	desc = "A shotgun with two barrels can fire both at the same time to take down a larger target. Unlocks double barrel shotgun designs for the appropriate fabricators."
	tier = 1
	points = 175
	uid = "shotgun_1"
	uses = -10
/datum/tech_entry/combat/proj/automatic/uzi
	name = "Small Automatic Weapons"
	desc = "Automatic weapons can put bullets into bad-guys faster than any alternative. Unlocks 9mm machine pistol &  9mm sub-machine gun designs for the appropriate fabricators."
	tier = 2
	points = 500
	uid = "autos_1"
	prereqs = list("pistol_1", "shotgun_2")

/datum/tech_entry/combat/proj/shotgun/pump
	name = "Pump Shotgun Implementation"
	desc = "The pump shotgun is an effective weapon for personal security at home or abroad. Unlocks double barrel shotgun designs for the appropriate fabricators."
	tier = 2
	points = 500
	uid = "shotgun_2"
	prereqs = list("shotgun_1")

/datum/tech_entry/combat/proj/shotgun/combat
	name = "Combat Shotgun Implementation"
	desc = "The combat shotgun is a powerful weapon that can take down high value targets. Unlocks combat shotgun designs for the appropriate fabricators."
	tier = 3
	points = 1200
	uid = "shotgun_3"
	prereqs = list("shotgun_2")

/datum/tech_entry/combat/proj/automatic/smg
	name = "Improved Automatics"
	desc = "Larger automatic weapons require both hands free in order to be effective. Unlocks 10mm sub-machine gun designs for the appropriate fabricators."
	tier = 3
	points = 1200
	uid = "autos_2"
	prereqs = list("autos_1")

/datum/tech_entry/combat/proj/pistol/mateba
	name = "Deadly Revolvers"
	desc = "Building on prior shotgun designs, revolvers could be absolutely deadly. Unlocks mateba .50 revolver designs for the appropriate fabricators."
	tier = 3
	points = 1400
	uid = "pistol_2"
	prereqs = list("pistol_1", "shotgun_2")
	
	
/datum/tech_entry/combat/proj/automatic/rifle
	name = "The Assault Rifle"
	desc = "It's an incredibly effective and supremely cool assault rifle. This is what you've been waiting for. Unlocks assault rifle designs for the appropriate fabricators."
	tier = 4
	points = 3000
	uid = "autos_3"
	prereqs = list("autos_2")
	uses = 1
/datum/tech_entry/combat/proj/sniper
	name = "Anti-Material Rifles"
	desc = "The application of phoron heavily throughout the design of a rifle gives it a powerful structural penetration capability. Unlocks anti-material sniper designs for the appropriate fabricators."
	tier = 4
	points = 500
	uid = "antimaterial"
	prereqs = list("pistol_2", "shotgun_3")
	uses = 1

// END BALLISTIC WEAPONS


// ENERGY WEAPONS

/datum/tech_entry/combat/energy
	name = "Basic Energy Weapons"
	desc = "Energy weapons inflict different wounds than conventional projectiles and they can have additional functions built into them. Unlocks energy pistol & energy gun designs for the appropriate fabricators."
	tier = 2
	points = 400
	uid = "energy_1"
	prereqs = list("shotgun_1", "adv_capacitor")

/datum/tech_entry/combat/energy/xray
	name = "Xray Laser Weapons"
	desc = "Xray based weapons can penetrate armors that are otherwise effective against energy weapons. Unlocks xray laser pistol & xray laser carbine gun designs for the appropriate fabricators."
	tier = 3
	points = 2000
	uid = "xray_1"
	prereqs = list("energy_1", "high_micro_laser")

/datum/tech_entry/combat/energy/carbine
	name = "Advanced Energy Rifle"
	desc = "Phoron can enrich an energy weapons to be more efficent and deadly. Unlocks laser carbine designs for the appropriate fabricators."
	tier = 3
	points = 2000
	uid = "energy_2"
	prereqs = list("energy_1")

/datum/tech_entry/combat/energy/ion
	name = "Ion Projectiles"
	desc = "Ion projectiles cause an EMP effect on whatever electronics they hit. Unlocks ion pistol designs for the appropriate fabricators."
	tier = 3
	points = 2500
	uid = "ion_1"
	prereqs = list("energy_1", "phasic_sensor")

/datum/tech_entry/combat/energy/ion/adv
	name = "Ion Detonation"
	desc = "Larger ion projectiles with additional enrichment could detonate to cause an EMP in a small area. Unlocks ion rifle designs for the appropriate fabricators."
	tier = 4
	points = 4000
	uid = "ion_2"
	prereqs = list("ion_1", "energy_2")
	uses = 1
/datum/tech_entry/combat/energy/heavy
	name = "Masterful Energy Weapons"
	desc = "Putting together all the prior applications of beam and laser weapons, a heavy sniper and assault-cannon can be developed. Unlocks ion rifle designs for the appropriate fabricators."
	tier = 4
	points = 5000
	uid = "energy_3"
	prereqs = list("xray_1", "energy_2")
	uses = 1

/datum/tech_entry/combat/energy/pulse
	name = "Pulse Weapons"
	desc = "Extremely powerful energy weapons that fire in devestating bursts. Unlocks the pulse pistol & pulse carbine designs for the appropriate fabricators."
	tier = 4
	points = 6000
	uid = "pulse_1"
	prereqs = list("energy_2", "super_capacitor")
	uses = 1

// END ENERGY WEAPONS

// MELEE WEAPONS

/datum/tech_entry/combat/melee/savage
	name = "Savagery"
	desc = "Before you can learn to kill you must be prepared to inflict pain. Unlocks the machete & dueling knife designs for the appropriate fabricators."
	tier = 1
	points = 100
	uid = "melee_1"
	uses = -10
/datum/tech_entry/combat/melee/exotic
	name = "Exotic Weapons"
	desc = "A variety of cultural weapons from across history could be developed. Unlocks a variety of exotic weapon designs for the appropriate fabricators."
	tier = 2
	points = 400
	uid = "melee_2"
	prereqs = list("melee_1")
	uses = -10
/datum/tech_entry/combat/melee/blademaster
	name = "Blade Mastery"
	desc = "The last and best of the conventional melee weapon designs can be completed. Unlocks fancy melee weapon designs for the appropriate fabricators."
	tier = 3
	points = 2500
	uid = "melee_3"
	prereqs = list("melee_2")
	uses = -10
/datum/tech_entry/combat/melee/energy
	name = "Energy Blades"
	desc = "By enriching the point of contact with uranium reactant with phoron a variety of melee energy wepaons can be developed. Unlocks energy melee weapon designs for the appropriate fabricators."
	tier = 4
	points = 3000
	uid = "melee_4"
	prereqs = list("melee_3", "energy_2")

// END MELEE WEAPONS

// ILLEGAL DEVICES

/datum/tech_entry/combat/illegal/kidnapping
	name = "(RESTRICTED) Kidnapping Tools"
	desc = "Tools to keep hostages in line and block suit senors could be developed, but they are both considered unethical. Unlocks suit sensor jammers & electropack designs for the appropriate fabricators."
	tier = 3
	points = 2000
	uid = "illegal_1"
	prereqs = list("adv_capacitor", "shotgun_2")
	uses = 1
/datum/tech_entry/combat/illegal/spying
	name = "(RESTRICTED) Clandestine Monitoring Equipment"
	desc = "A spy bug and monitor pairing could be designed, but these are instruments of sabotage. Unlocks spy bug and spy monitor designs for the appropriate fabricators."
	tier = 4
	points = 4000
	uid = "illegal_2"
	prereqs = list("illegal_1", "pico_mani")
	uses = 3

// END ILLEGAL DEVICES


///////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////
//////////////////////////////////////////////////
// Medical designs
/////////////////////////////////////////////////


/datum/tech_entry/medical/beaker/noreact
	name = "Chemical Cryostasis"
	desc = "Held in a phoron-enriched basin, chemicals can enter a sort of reactionless cryostasis. Unlocks cryostasis beaker designs for the appropriate fabricators."
	tier = 1
	points = 125
	uid = "cryostasis_beaker"


/datum/tech_entry/medical/beaker/bluespace
	name = "Ultra-Efficent Chemical Containment"
	desc = "Using diamond and phoron an extremely high volume bluespace beaker can be developed. Unlocks bluespace beaker designs for the appropriate fabricators."
	tier = 2
	points = 300
	uid = "bluespace_beaker"
	prereqs = list("cryostasis_beaker")

/datum/tech_entry/medical/autopsy_scanner
	name = "Cadaver Analysis"
	desc = "Procedures can be developed for analysing the remains of any type of humanoid. Unlocks autopsy scanner designs for the appropriate fabricators."
	tier = 1
	points = 150
	uid = "autopsy_scanner"

/datum/tech_entry/medical/syringe_gun
	name = "Syringe Cartridging"
	desc = "Syringes can be loaded into cartridges and fired out of a pneumatic launcher. Unlocks syringe gun & syringe cartridge designs for the appropriate fabricators."
	tier = 2
	points = 400
	uid = "syringe_gun"

/datum/tech_entry/medical/syringe_gun/rapid
	name = "Rapid Syringe Deployment Mechanics"
	desc = "Is a fancy way of describing the technology behind a rapid fire syringe gun. Unlocks rapid-fire syringe gun & disguised syringe gun designs for the appropriate fabricators."
	tier = 3
	points = 800
	uid = "rapid_syringe_gun"
	prereqs = list("syringe_gun")


/datum/tech_entry/medical/health_scanner
	name = "Portable Health Scanning"
	desc = "Handheld devices capable of auditing health require minimal research commitment. Unlocks health scanner designs for the appropriate fabricators."
	tier = 1
	points = 150
	uid = "health_scanner"

/datum/tech_entry/medical/mass_spectrometer
	name = "Mass Spectrometer"
	desc = "Develop a device capable of finding trace chemicals in blood. Unlocks mass spectrometer designs for the appropriate fabricators."
	tier = 1
	points = 100
	uid = "mass_spectrometer"

/datum/tech_entry/medical/mass_spectrometer/adv
	name = "Advanced Mass Spectrometer"
	desc = "Improve the analysis that a mass spectrometer can perform. Unlocks advanced mass spectrometer designs for the appropriate fabricators."
	tier = 2
	points = 350
	uid = "adv_mass_spectrometer"
	prereqs = list("mass_spectrometer")

/datum/tech_entry/medical/reagent_scanner
	name = "Chemical Analysis"
	desc = "Develop a device capable of chemical analysis. Unlocks reagent scanner designs for the appropriate fabricators."
	tier = 1
	points = 100
	uid = "reagent_scanner"

/datum/tech_entry/medical/reagent_scanner/adv
	name = "Mastered Chemical Analysis"
	desc = "Improve the reagent scanner for better data from the device. Unlocks advanced reagent scanner designs for the appropriate fabricators."
	tier = 2
	points = 350
	uid = "adv_reagent_scanner"

/datum/tech_entry/medical/scalpel/laser1
	name = "Basic Laser Suturing"
	desc = "Even the basic laser scalpel is a big improvement from the generic scalpel. Unlocks basic laser scalpel designs for the appropriate fabricators."
	tier = 1
	points = 150
	uid = "scalpel_1"

/datum/tech_entry/medical/scalpel/laser2
	name = "Improved Laser Suturing"
	desc = "The improved laser scalpel makes surgical procedures easier. Unlocks improved laser scalpel designs for the appropriate fabricators."
	tier = 2
	points = 400
	uid = "scalpel_2"
	prereqs = list("scalpel_1")

/datum/tech_entry/medical/scalpel/laser3
	name = "Mastered Laser Suturing"
	desc = "Diamond can be introduced in the focal lense to make the laser scalpel perfectly precise. Unlocks advanced laser scalpel designs for the appropriate fabricators."
	tier = 3
	points = 800
	uid = "scalpel_3"
	prereqs = list("scalpel_2", "high_micro_laser")

/datum/tech_entry/medical/scalpel/laser4
	name = "Incision Management System"
	desc = "Phoron and the application of other related technologies can create the ultimate surgeons tool. Unlocks incision managment system designs for the appropriate fabricators."
	tier = 4
	points = 2000
	uid = "scalpel_4"
	prereqs = list("scalpel_3", "ultra_micro_laser", "nano_mani")
	uses = 5

/datum/tech_entry/medical/scalpel/hypospray
	name = "Advanced Injection Mechanics"
	desc = "Develop an advanced hypospray that can inject chemicals directly into the bloodstream with extreme speed and efficency."
	tier = 4
	points = 2000
	uid = "hypospray"
	prereqs = list("ultra_micro_laser", "nano_mani")
	uses = 2


/datum/tech_entry/medical/defib
	name = "Electro-Resuscitation"
	desc = "An electro-pulse sent through the body can restart a heart. Unlocks auto-resuscitator designs for the appropriate fabricators."
	tier = 2
	points = 350
	uid = "defib"

/datum/tech_entry/medical/defib/compact
	name = "Compact-Resuscitation"
	desc = "The resuscitator can be made much easier to transport, an improvement which can save lives. Unlocks compact auto-resuscitator designs for the appropriate fabricators."
	tier = 3
	points = 700
	uid = "defib_compact"
	prereqs = list("defib")


/datum/tech_entry/medical/implants/tracking
	name = "Internal Tracking Implant"
	desc = "Develop an implant that can be remotely tracked. Unlocks tracking implant designs for the appropriate fabricators."
	tier = 2
	points = 300
	uid = "implant_tracking"


/datum/tech_entry/medical/implants/chem
	name = "Internal Chemical Deployment"
	desc = "Develop an implant that can be remotely activated to deploy chemicals directly into the body. Unlocks chem implant designs for the appropriate fabricators."
	tier = 3
	points = 600
	uid = "implant_chem"

/datum/tech_entry/medical/implants/adrenalin
	name = "Internal Adrenalin Stimulant"
	desc = "Develop an implant that can be remotely activated to stimulate rapid adrenalin production in the body. Unlocks adrenalin implant designs for the appropriate fabricators."
	tier = 3
	points = 600
	uid = "implant_adrenalin"

/datum/tech_entry/medical/implants/biomonitor
	name = "Internal Health Reporting"
	desc = "Develop an implant that reports critical injuries over all emergency frequencies. Unlocks biomonitor implant designs for the appropriate fabricators."
	tier = 3
	points = 600
	uid = "implant_biomonitor"

/datum/tech_entry/medical/implants/imprinting
	name = "(RESTRICTED) Internal Physco-Suggestive Implant"
	desc = "Develop an implant that can be programed to periodically cause forceful recurring thoughts. Considered an implement of tyrants, this technology is typically restricted. Unlocks imprinting implant designs for the appropriate fabricators."
	tier = 3
	points = 600
	uid = "implant_imprinting"

/datum/tech_entry/medical/implants/freedom
	name = "(RESTRICTED) Implanted Restraint Disabling"
	desc = "Develop an implant that emits a signal that disables handcuffs. This is a a restricted technology. Unlocks freedom implant designs for the appropriate fabricators."
	tier = 3
	points = 600
	uid = "implant_freedom"

/datum/tech_entry/medical/implants/compressed
	name = "Internal Bluespace Matter Compression"
	desc = "Develop an amazing implant that allows a small item to be held in a bluespace pocket and retrieved directly into the hands. Unlocks compressed matter implant designs for the appropriate fabricators."
	tier = 4
	points = 1400
	uid = "implant_compressed"


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
	name = "Pico-miniaturized manipulators"
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
	desc = "Uranium can be used throughout the design of a cell to greatly improve its potential capacity. Unlocks super-capacity power cell & super-capacity device cell designs for the appropriate fabricators."
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

/datum/tech_entry/general/computer/adv_parts
	name = "Advanced Computer Components"
	desc = "Better computer components let you run more programs at once, and store more on a hard drive. Unlocks improved computer component designs for the appropriate fabricators."
	tier = 1
	points = 150
	uid = "computer_1"

/datum/tech_entry/general/computer/super_parts
	name = "Super Computer Components"
	desc = "An even better set of core computer components can be developed. Unlocks super computer component designs for the appropriate fabricators."
	tier = 2
	points = 300
	uid = "computer_2"
	prereqs = list("computer_1")

/datum/tech_entry/general/computer/ultra_parts
	name = "Mastered Computer Components"
	desc = "The absolute best computer components outclass the others completely. Unlocks the final computer component designs for the appropriate fabricators."
	tier = 3
	points = 600
	uid = "computer_3"
	prereqs = list("computer_2")

/datum/tech_entry/general/communication/color_communication
	name = "Multi-Color Communication"
	desc = "A variety of crayons and a multi-color pen can be developed. Unlocks crayons and multi-color pen designs for the appropriate fabricators."
	tier = 1
	points = 100
	uid = "color_comms_1"

/datum/tech_entry/general/communication/powerful_crayons
	name = "Powerful Crayons"
	desc = "Crayons that can change color and more! Unlocks the rainbow and mime crayon designs for the appropriate fabricators."
	tier = 2
	points = 200
	uid = "color_comms_2"

/datum/tech_entry/general/eva/jetpacks
	name = "EVA Jetpacks"
	desc = "Develop a jetpack design that can be used for space maneuvering and to supply the user with air at the same time. Unlocks jetpack designs for the appropriate fabricators."
	tier = 1
	points = 150
	uid = "jetpacks"




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


/obj/item/weapon/disk/tech_entry_disk
	name = "tech disk"
	desc = "Load this into a fabricator to unlock designs that require this technology. This disk will be consumer in the process."
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk2"
	item_state = "card-id"
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_STEEL = 30, MATERIAL_GLASS = 10)
	var/uid


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
