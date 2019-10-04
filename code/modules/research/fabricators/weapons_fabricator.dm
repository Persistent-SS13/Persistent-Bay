/obj/machinery/fabricator/weapon_fabricator
	// Things that must be adjusted for each fabricator
	name = "Weapon Fabricator" // Self-explanatory
	desc = "A machine used for the production of a variety of weapons and ammo" // Self-explanatory
	circuit_type = /obj/item/weapon/circuitboard/fabricator/weaponfab // Circuit for the machine. These, as well as their designs, should be defined in fabricator_circuits.dm
	build_type = WEAPONFAB // The identifer for what gets built in what fabricator. A new one *MUST* be defined in _defines/research.dm for each fabricator.
						 					 // More than one can be assigned per design, however, if you want something to be able to be built in more than one fabricator eg. Power Cells

////////////////////////////////////////////////////
//////////////////////DESIGNS///////////////////////
////////////////////////////////////////////////////


/datum/design/item/weaponfab
	build_type = WEAPONFAB 			   // This must match the build_type of the fabricator(s)
	category = "Weapons"	 			   // The design will appear under this in the UI. Each design must have a category, or it will not display properly.

	time = 10						   // Time in seconds for the item to be produced - This changes based off the components used in the fabricator



/obj/machinery/fabricator/weapon_fabricator/can_connect(var/datum/world_faction/trying, var/mob/M)
	var/datum/machine_limits/limits = trying.get_limits()
	if(M && !has_access(list(core_access_machine_linking), list(), M.GetAccess(trying.uid)))
		to_chat(M, "You do not have access to link machines to [trying.name].")
		return 0
	if(limits.limit_ammofab <= limits.ammofabs.len)
		if(M)
			to_chat(M, "[trying.name] cannot connect any more machines of this type.")
		return 0
	limits.ammofabs |= src
	req_access_faction = trying.uid
	connected_faction = trying

/obj/machinery/fabricator/weapon_fabricator/can_disconnect(var/datum/world_faction/trying, var/mob/M)
	var/datum/machine_limits/limits = trying.get_limits()
	limits.engfabs -= src
	req_access_faction = ""
	connected_faction = null
	if(M) to_chat(M, "The machine has been disconnected.")

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// SECURITY EQUIPMENT

/datum/design/item/weaponfab/sectools
	category = "Policing Equipment"

/datum/design/item/weaponfab/sectools/adv

/////////////////////////////////////////////////////////////////////////////

/datum/design/item/weaponfab/sectools/handcuffs
	name = "handcuffs"
	build_path = /obj/item/weapon/handcuffs
	materials = list(MATERIAL_STEEL = 0.5 SHEET)
/datum/design/item/weaponfab/sectools/adv/hud
	materials = list(MATERIAL_STEEL = 0.1 SHEET, MATERIAL_GLASS = 0.1 SHEET)

/datum/design/item/weaponfab/sectools/adv/hud/AssembleDesignName()
	..()
	name = "HUD glasses prototype ([item_name])"

/datum/design/item/weaponfab/sectools/adv/hud/AssembleDesignDesc()
	desc = "Allows for the construction of \a [item_name] HUD glasses."




/datum/design/item/weaponfab/sectools/adv/hud/security
	name = "police hud"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	build_path = /obj/item/clothing/glasses/hud/security
	materials = list(MATERIAL_STEEL = 0.25 SHEET, MATERIAL_GLASS = 0.25 SHEET)
/datum/design/item/weaponfab/sectools/adv/pepperspray
	name = "pepperspray (empty)"
	build_path = /obj/item/weapon/reagent_containers/spray/pepper
	materials = list(MATERIAL_STEEL = 0.1 SHEET, MATERIAL_GLASS = 0.1 SHEET)

/datum/design/item/weaponfab/sectools/flash
	build_path = /obj/item/device/flash
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_COPPER = 2 SHEET, MATERIAL_GOLD = 0.5 SHEET)

/datum/design/item/weaponfab/sectools/flash/advanced // tier 2
	build_path = /obj/item/device/flash/advanced
	materials = list(MATERIAL_STEEL = 5 SHEETS, MATERIAL_COPPER = 4 SHEET, MATERIAL_GOLD = 2 SHEET)


/datum/design/item/weaponfab/sectools/adv/riotshield // tier 3
	name = "riot shield"
	build_path = /obj/item/weapon/shield/riot
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_GLASS = 2 SHEETS, MATERIAL_GOLD = 0.5 SHEET)


/datum/design/item/weaponfab/sectools/adv/crimebriefcase
	name = "crime scene kit (empty)"
	build_path = /obj/item/weapon/storage/briefcase/crimekit
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_LEATHER = 1 SHEET)

/datum/design/item/weaponfab/sectools/adv/fingerprints
	name = "box of fingerprint cards."
	build_path = /obj/item/weapon/storage/box/fingerprints
	materials = list(MATERIAL_CARDBOARD = 1 SHEET)

/datum/design/item/weaponfab/sectools/adv/evidence
	name = "box of evidence bags."
	build_path = /obj/item/weapon/storage/box/evidence
	materials = list(MATERIAL_PLASTIC = 1.5 SHEET)


/datum/design/item/weaponfab/sectools/adv/swabs
	name = "box of swab sets."
	build_path = /obj/item/weapon/storage/box/swabs
	materials = list(MATERIAL_CARDBOARD = 0.5 SHEET, MATERIAL_GLASS = 0.5 SHEET)

/datum/design/item/weaponfab/sectools/adv/uvlight
	build_path = /obj/item/device/uv_light
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_COPPER = 1 SHEET, MATERIAL_GLASS = 1 SHEET)

/datum/design/item/weaponfab/sectools/adv/samplekit
	build_path = /obj/item/weapon/forensics/sample_kit
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_GOLD = 0.5 SHEET, MATERIAL_GLASS = 1 SHEET)

/datum/design/item/weaponfab/sectools/adv/samplekit/powder
	build_path = /obj/item/weapon/forensics/sample_kit/powder

/datum/design/item/weaponfab/sectools/adv/baton
	build_path = /obj/item/weapon/melee/baton
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_GOLD = 1 SHEET)

/datum/design/item/weaponfab/sectools/adv/baton/classic
	build_path = /obj/item/weapon/melee/classic_baton
	materials = list(MATERIAL_STEEL = 1.5 SHEETS)

/datum/design/item/weaponfab/sectools/adv/telebaton // tier 1
	build_path = /obj/item/weapon/melee/telebaton
	materials = list(MATERIAL_STEEL = 1.5 SHEETS, MATERIAL_GOLD = 1 SHEET)

/datum/design/item/weaponfab/sectools/adv/hailer // tier 1
	build_path = /obj/item/device/hailer
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_COPPER = 1.2 SHEET)


/datum/design/item/weaponfab/sectools/adv/debugger // tier 1
	build_path = /obj/item/device/debugger
	materials = list(MATERIAL_STEEL = 1 SHEETS, MATERIAL_COPPER = 1 SHEET)



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
// REJECTED DUE TO ITEM BEING UNDERDEVELOPED
/datum/design/item/weaponfab/weapons/guns/energy/simple
	materials = list(MATERIAL_STEEL = 8 SHEETS, MATERIAL_GLASS = 3 SHEETS, MATERIAL_GOLD = 3 SHEETS,  MATERIAL_PHORON = 2 SHEETS)
	build_path = /obj/item/weapon/gun/energy


/datum/design/item/weaponfab/weapons/guns/temp_gun
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_POWER = 3, TECH_MAGNET = 2)
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_GLASS = 3 SHEETS, MATERIAL_SILVER = 5 SHEETS, MATERIAL_PHORON = 1 SHEET)
	build_path = /obj/item/weapon/gun/energy/temperature


// REJECTED DUE TO IRRADIATION MECHANICS BEING POORLY UNDERSTOOD
/datum/design/item/weaponfab/weapons/guns/phoronpistol
	req_tech = list(TECH_COMBAT = 5, TECH_PHORON = 4)
	materials = list(MATERIAL_STEEL = 1.5 SHEETS, MATERIAL_GLASS = 1 SHEET, MATERIAL_URANIUM = 2 SHEETS, MATERIAL_PHORON = 4 SHEETS)
	build_path = /obj/item/weapon/gun/energy/toxgun

/datum/design/item/weaponfab/weapons/guns/decloner
	req_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 7, TECH_BIO = 5, TECH_POWER = 6)
	materials = list(MATERIAL_STEEL = 8 SHEETS, MATERIAL_GOLD = 6 SHEETS,MATERIAL_URANIUM = 12 SHEETS)
	chemicals = list(/datum/reagent/mutagen = 40)
	build_path = /obj/item/weapon/gun/energy/decloner

/datum/design/item/weaponfab/weapons/guns/nuclear_gun
	materials = list(MATERIAL_PLASTEEL = 8 SHEETS, MATERIAL_GLASS = 2 SHEETS, MATERIAL_GOLD = 8 SHEETS, MATERIAL_URANIUM = 10 SHEETS, MATERIAL_PHORON = 5 SHEETS)
	build_path = /obj/item/weapon/gun/energy/gun/nuclear

// grenade launchers are not needed at this moment

/datum/design/item/weaponfab/weapons/guns/automatic/z8
	materials = list(MATERIAL_STEEL = 15 SHEETS, MATERIAL_GOLD = 12 SHEETS, MATERIAL_DIAMOND = 8 SHEETS, MATERIAL_URANIUM = 5 SHEETS, MATERIAL_PHORON = 5 SHEETS)
	build_path = /obj/item/weapon/gun/projectile/automatic/z8


/datum/design/item/weaponfab/weapons/launcher/grenade
	build_path = /obj/item/weapon/gun/launcher/grenade
	materials = list(MATERIAL_STEEL = 8 SHEETS, MATERIAL_GLASS = 2 SHEETS, MATERIAL_SILVER = 2 SHEETS, MATERIAL_GOLD = 2 SHEETS, MATERIAL_DIAMOND = 4 SHEETS, MATERIAL_PHORON = 0.5 SHEET)


/datum/design/item/weaponfab/weapons/guns/automatic/z8 // tier 4
	materials = list(MATERIAL_PLASTEEL = 12 SHEETS, MATERIAL_GOLD = 10 SHEETS, MATERIAL_DIAMOND = 8 SHEETS, MATERIAL_PHORON = 4 SHEETS) //TODO
	build_path = /obj/item/weapon/gun/projectile/automatic/z8
	research = "autos_4"


// icons are a bit ugly

/datum/design/item/weaponfab/weapons/hook
	build_path = /obj/item/weapon/material/knife/hook
	materials = list(MATERIAL_STEEL = 3 SHEETS)

/datum/design/item/weaponfab/weapons/ritualdagger
	build_path = /obj/item/weapon/material/knife/ritual
	materials = list(MATERIAL_STEEL = 3 SHEETS)



**/


// WEAPONS

/datum/design/item/weaponfab/weapons
	category = "Weapons"

/datum/design/item/weaponfab/weapons/guns
	category = "Guns"

/datum/design/item/weaponfab/weapons/grenades
	category = "Grenades"

/datum/design/item/weaponfab/weapons/illegal
	category = "Restricted Devices"

////////////////////////////////////////////////////////////////////

///////Grenades

/datum/design/item/weaponfab/weapons/grenades/smoke
	materials = list(MATERIAL_STEEL = 5 SHEETS, MATERIAL_GOLD = 2 SHEETS)
	build_path = /obj/item/weapon/grenade/smokebomb
	research = "grenade_smoke"
/datum/design/item/weaponfab/weapons/grenades/empgrenade
	materials = list(MATERIAL_STEEL = 5 SHEETS, MATERIAL_GOLD = 4 SHEETS, MATERIAL_COPPER = 4 SHEETS)
	build_path = /obj/item/weapon/grenade/empgrenade
	research = "grenade_emp"
/datum/design/item/weaponfab/weapons/grenades/frag
	materials = list(MATERIAL_STEEL = 5 SHEETS, MATERIAL_GOLD = 5 SHEETS, MATERIAL_PHORON = 2 SHEETS)
	build_path = /obj/item/weapon/grenade/frag
	research = "grenade_frag"
/datum/design/item/weaponfab/weapons/grenades/flashbang
	materials = list(MATERIAL_STEEL = 5 SHEETS, MATERIAL_GOLD = 2 SHEETS, MATERIAL_COPPER = 2 SHEETS)
	build_path = /obj/item/weapon/grenade/flashbang
	research = "grenade_flash"
/datum/design/item/weaponfab/weapons/grenades/chem_grenade
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_SILVER = 0.5 SHEETS)
	build_path = /obj/item/weapon/grenade/chem_grenade
	research = "grenade_chem"
/datum/design/item/weaponfab/weapons/grenades/anti_photon
	materials = list(MATERIAL_STEEL = 5 SHEETS, MATERIAL_GOLD = 5 SHEETS, MATERIAL_PHORON = 0.5 SHEETS, MATERIAL_URANIUM = 0.5 SHEETS)
	build_path = /obj/item/weapon/grenade/anti_photon
	research = "grenade_photon"

/datum/design/item/weaponfab/weapons/grenades/large_grenade
	materials = list(MATERIAL_STEEL = 6 SHEETS, MATERIAL_SILVER = 1 SHEET)
	build_path = /obj/item/weapon/grenade/chem_grenade/large



// END GRENADES


// Stun weapons

/datum/design/item/weaponfab/weapons/guns/taser // tier 0
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_GLASS = 2 SHEETS, MATERIAL_COPPER = 4 SHEETS)
	build_path = /obj/item/weapon/gun/energy/taser

/datum/design/item/weaponfab/weapons/guns/taser/carbine // tier 1
	materials = list(MATERIAL_STEEL = 8 SHEETS, MATERIAL_GLASS = 5 SHEETS, MATERIAL_COPPER = 6.5 SHEETS)
	build_path = /obj/item/weapon/gun/energy/stunrevolver/rifle
	research = "stun_1"

/datum/design/item/weaponfab/weapons/guns/stunrevolver // tier 2
	materials = list(MATERIAL_STEEL = 5 SHEETS, MATERIAL_COPPER = 4 SHEETS, MATERIAL_GOLD = 2 SHEETS)
	build_path = /obj/item/weapon/gun/energy/stunrevolver
	research = "stun_2"
/datum/design/item/weaponfab/weapons/guns/stunrevolver/rifle // tier 2.5
	materials = list(MATERIAL_STEEL = 10 SHEETS, MATERIAL_COPPER = 6.5 SHEETS, MATERIAL_GOLD = 4 SHEETS)
	build_path = /obj/item/weapon/gun/energy/stunrevolver/rifle
	research = "stun_2"

/datum/design/item/weaponfab/weapons/guns/plasmastun // tier 3
	materials = list(MATERIAL_STEEL = 10 SHEETS, MATERIAL_GOLD = 4 SHEETS, MATERIAL_URANIUM = 4 SHEETS, MATERIAL_DIAMOND = 1 SHEET)
	build_path = /obj/item/weapon/gun/energy/plasmastun
	research = "stun_3"
// END STUN WEAPONS



// BALLISTICS WEAPONS

//	Pistols
/datum/design/item/weaponfab/weapons/guns/pistol // tier 0
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_GOLD = 1.5 SHEETS, MATERIAL_COPPER = 1.5 SHEETS)
	build_path = /obj/item/weapon/gun/projectile/pistol/sec
/datum/design/item/weaponfab/weapons/guns/pistol/MK // tier 0, the MK is a cheap knock-off with a high jam chance apparently
	name = "defective MK58"
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_COPPER = 5 SHEETS)
	build_path = /obj/item/weapon/gun/projectile/pistol/sec/MK
/datum/design/item/weaponfab/weapons/guns/pistol/m1911 // tier 1 RESKIN of pistol
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_GOLD = 1.5 SHEETS, MATERIAL_COPPER = 1.5 SHEETS) //TODO
	build_path = /obj/item/weapon/gun/projectile/pistol/m1911
	research = "pistol_1"
/datum/design/item/weaponfab/weapons/guns/pistol/c96
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_GOLD = 1.5 SHEETS, MATERIAL_COPPER = 1.5 SHEETS) //TODO
	build_path = /obj/item/weapon/gun/projectile/pistol/c96
	research = "pistol_1"
/datum/design/item/weaponfab/weapons/guns/pistol/p08
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_GOLD = 1.5 SHEETS, MATERIAL_COPPER = 1.5 SHEETS) //TODO
	build_path = /obj/item/weapon/gun/projectile/pistol/p08
	research = "pistol_1"
/datum/design/item/weaponfab/weapons/guns/pistol/holdout // tier 1
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_GOLD = 1.3 SHEETS, MATERIAL_COPPER = 1.3 SHEETS) //TODO
	build_path = /obj/item/weapon/gun/projectile/pistol/holdout
	research = "pistol_1"
/datum/design/item/weaponfab/weapons/guns/pistol/holdout/silencer // tier 1
	name = "LAP3 silencer attachment"
	materials = list(MATERIAL_STEEL = 6 SHEETS) //TODO
	build_path = /obj/item/weapon/silencer
	research = "pistol_1"

/datum/design/item/weaponfab/weapons/guns/pistol/bhp // tier 1
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_GOLD = 1.3 SHEETS, MATERIAL_COPPER = 1.3 SHEETS) //TODO
	build_path = /obj/item/weapon/gun/projectile/pistol/bhp
	research = "pistol_1"

/datum/design/item/weaponfab/weapons/guns/pistol/military // tier 2
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_GOLD = 1.3 SHEETS, MATERIAL_COPPER = 1.3 SHEETS) //TODO
	build_path = /obj/item/weapon/gun/projectile/pistol/military
	research = "pistol_2"
/datum/design/item/weaponfab/weapons/guns/pistol/military_alt // tier 2
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_GOLD = 1.3 SHEETS, MATERIAL_COPPER = 1.3 SHEETS) //TODO
	build_path = /obj/item/weapon/gun/projectile/pistol/military/alt
	research = "pistol_2"
/datum/design/item/weaponfab/weapons/guns/pistol/silenced // tier 2
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_GOLD = 1.3 SHEETS, MATERIAL_COPPER = 1.3 SHEETS) //TODO
	build_path = /obj/item/weapon/gun/projectile/silenced
	research = "pistol_2"
/datum/design/item/weaponfab/weapons/guns/pistol/b92fs // tier 2
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_GOLD = 1.3 SHEETS, MATERIAL_COPPER = 1.3 SHEETS) //TODO
	build_path = /obj/item/weapon/gun/projectile/pistol/b92
	research = "pistol_2"
/datum/design/item/weaponfab/weapons/guns/pistol/usp45 // tier 2
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_GOLD = 1.3 SHEETS, MATERIAL_COPPER = 1.3 SHEETS) //TODO
	build_path = /obj/item/weapon/gun/projectile/pistol/usp
	research = "pistol_2"

/datum/design/item/weaponfab/weapons/guns/pistol/magnum_pistol // tier 4
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_GOLD = 1.3 SHEETS, MATERIAL_COPPER = 1.3 SHEETS) //TODO
	build_path = /obj/item/weapon/gun/projectile/pistol/magnum_pistol
	research = "pistol_2"

//	Revolvers
/datum/design/item/weaponfab/weapons/guns/revolver/holdout // tier 0, shitty .22lr revolver
	materials = list(MATERIAL_STEEL = 6 SHEETS, MATERIAL_GOLD = 3 SHEETS, MATERIAL_COPPER = 2.5 SHEETS) //TODO
	build_path = /obj/item/weapon/gun/projectile/revolver/holdout

/datum/design/item/weaponfab/weapons/guns/revolver/c38 // tier 1
	materials = list(MATERIAL_STEEL = 6 SHEETS, MATERIAL_GOLD = 3 SHEETS, MATERIAL_COPPER = 2.5 SHEETS) //TODO
	build_path = /obj/item/weapon/gun/projectile/revolver/medium
	research = "pistol_1"
/datum/design/item/weaponfab/weapons/guns/revolver/c38_detective // tier 1
	materials = list(MATERIAL_STEEL = 6 SHEETS, MATERIAL_GOLD = 3 SHEETS, MATERIAL_COPPER = 2.5 SHEETS) //TODO
	build_path = /obj/item/weapon/gun/projectile/revolver/detective
	research = "pistol_1"

/datum/design/item/weaponfab/weapons/guns/revolver/c357 // tier 2
	materials = list(MATERIAL_STEEL = 6 SHEETS, MATERIAL_GOLD = 3 SHEETS, MATERIAL_COPPER = 2.5 SHEETS) //TODO
	build_path = /obj/item/weapon/gun/projectile/revolver
	research = "pistol_2"

/datum/design/item/weaponfab/weapons/guns/revolver/auto // tier 2
	materials = list(MATERIAL_STEEL = 2500, MATERIAL_ALUMINIUM = 1200, MATERIAL_SILVER = 250) //TODO
	build_path = /obj/item/weapon/gun/projectile/revolver/medium/auto
	research = "pistol_2"

/datum/design/item/weaponfab/weapons/guns/revolver/c44 // tier 3
	materials = list(MATERIAL_STEEL = 6 SHEETS, MATERIAL_GOLD = 3 SHEETS, MATERIAL_COPPER = 2.5 SHEETS) //TODO
	build_path = /obj/item/weapon/gun/projectile/revolver/webley
	research = "pistol_2"
/datum/design/item/weaponfab/weapons/guns/revolver/deckard44 // tier 3
	materials = list(MATERIAL_STEEL = 6 SHEETS, MATERIAL_GOLD = 3 SHEETS, MATERIAL_COPPER = 2.5 SHEETS) //TODO
	build_path = /obj/item/weapon/gun/projectile/revolver/deckard
	research = "pistol_2"

/datum/design/item/weaponfab/weapons/guns/revolver/mateba50 // tier 4
	materials = list(MATERIAL_PLASTEEL = 6 SHEETS, MATERIAL_GOLD = 5 SHEETS, MATERIAL_DIAMOND = 4 SHEETS, MATERIAL_PHORON = 1 SHEETS)
	build_path = /obj/item/weapon/gun/projectile/revolver/mateba
	research = "pistol_2"

/datum/design/item/weaponfab/weapons/guns/revolver/foundation // tier 5? Just some hiddne shit
	materials = list(MATERIAL_PLASTEEL = 6 SHEETS, MATERIAL_GOLD = 5 SHEETS, MATERIAL_DIAMOND = 4 SHEETS, MATERIAL_PHORON = 3 SHEETS, MATERIAL_NULLGLASS = 5 SHEETS)
	build_path = /obj/item/weapon/gun/projectile/revolver/foundation
	research = "pistol_5"

//	Shotguns
/datum/design/item/weaponfab/weapons/guns/shotgun/doublebarrel // tier 1.5
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_WOOD = 4 SHEETS, MATERIAL_GOLD = 3.5 SHEET, MATERIAL_COPPER = 3 SHEET)
	build_path = /obj/item/weapon/gun/projectile/shotgun/doublebarrel
	research = "shotgun_1"
/datum/design/item/weaponfab/weapons/guns/shotgun/pump // tier 2
	materials = list(MATERIAL_STEEL = 8 SHEETS, MATERIAL_GOLD = 4 SHEETS, MATERIAL_DIAMOND = 1 SHEETS)
	build_path = /obj/item/weapon/gun/projectile/shotgun/pump
	research = "shotgun_2"
/datum/design/item/weaponfab/weapons/guns/shotgun/pump/exploration // tier 2
	materials = list(MATERIAL_STEEL = 8 SHEETS, MATERIAL_GOLD = 4 SHEETS, MATERIAL_DIAMOND = 1 SHEETS)
	build_path = /obj/item/weapon/gun/projectile/shotgun/pump/exploration
	research = "shotgun_2"
/datum/design/item/weaponfab/weapons/guns/shotgun/combat // tier 3
	materials = list(MATERIAL_STEEL = 10 SHEETS, MATERIAL_GOLD = 8 SHEETS, MATERIAL_DIAMOND = 4 SHEETS)
	build_path = /obj/item/weapon/gun/projectile/shotgun/pump/combat
	research = "shotgun_3"

//	SMG
/datum/design/item/weaponfab/weapons/guns/automatic/wt550 // tier 1
	materials = list(MATERIAL_STEEL = 5 SHEETS, MATERIAL_GOLD = 5 SHEETS, MATERIAL_DIAMOND = 2 SHEETS)
	build_path = /obj/item/weapon/gun/projectile/automatic/wt550
	research = "autos_1"

/datum/design/item/weaponfab/weapons/guns/automatic/uzi // tier 2.5
	materials = list(MATERIAL_STEEL = 7 SHEETS, MATERIAL_GOLD = 7 SHEETS, MATERIAL_DIAMOND = 4 SHEETS)
	build_path = /obj/item/weapon/gun/projectile/automatic/machine_pistol
	research = "autos_2"

/datum/design/item/weaponfab/weapons/guns/automatic/c20r // tier 3.5
	materials = list(MATERIAL_PLASTEEL = 8 SHEETS, MATERIAL_GOLD = 8 SHEETS, MATERIAL_DIAMOND = 5 SHEETS, MATERIAL_PHORON = 2 SHEETS)
	build_path = /obj/item/weapon/gun/projectile/automatic/c20r
	research = "autos_3"

/datum/design/item/weaponfab/weapons/guns/automatic/proto_smg // tier 5
	materials = list(MATERIAL_PLASTEEL = 8 SHEETS, MATERIAL_GOLD = 8 SHEETS, MATERIAL_DIAMOND = 5 SHEETS, MATERIAL_PHORON = 2 SHEETS) //TODO
	build_path = /obj/item/weapon/gun/projectile/automatic/proto_smg
	research = "autos_4"

//	Rifles
/datum/design/item/weaponfab/weapons/guns/automatic/sts35 // tier 4
	materials = list(MATERIAL_PLASTEEL = 12 SHEETS, MATERIAL_GOLD = 10 SHEETS, MATERIAL_DIAMOND = 8 SHEETS, MATERIAL_PHORON = 4 SHEETS)
	build_path = /obj/item/weapon/gun/projectile/automatic/sts35
	research = "autos_3"

//	Sniper

/datum/design/item/weaponfab/weapons/guns/automatic/heavysniper/replica // tier 0, Knock-off 9mm replica, basically an expensive pipe rifle
	name = "heavy sniper replica"
	materials = list(MATERIAL_PLASTEEL = 5 SHEETS)
	build_path = /obj/item/weapon/gun/projectile/boltaction/heavysniper/ant

/**
/datum/design/item/weaponfab/weapons/guns/automatic/heavysniper // tier 4
	materials = list(MATERIAL_PLASTEEL = 10 SHEETS, MATERIAL_GOLD = 8 SHEETS, MATERIAL_DIAMOND = 3 SHEETS, MATERIAL_PHORON = 11 SHEETS)
	build_path = /obj/item/weapon/gun/projectile/boltaction/heavysniper
	research = "antimaterial"
**/
// END BALLISTIC WEAPONS




// ENERGY WEAPONS

/datum/design/item/weaponfab/weapons/guns/energy/small // TIER 2
	materials = list(MATERIAL_PLASTEEL = 4 SHEETS, MATERIAL_GOLD = 2 SHEETS, MATERIAL_PHORON = 1 SHEETS, MATERIAL_DIAMOND = 1 SHEETS)
	build_path = /obj/item/weapon/gun/energy/gun/small
	research = "energy_1"

/datum/design/item/weaponfab/weapons/guns/energy // TIER 2.5
	materials = list(MATERIAL_PLASTEEL = 6 SHEETS, MATERIAL_GOLD = 4 SHEETS, MATERIAL_PHORON = 2 SHEETS, MATERIAL_DIAMOND = 1 SHEETS)
	build_path = /obj/item/weapon/gun/energy/gun
	research = "energy_1"

/datum/design/item/weaponfab/weapons/guns/xray/pistol // tier 3
	materials = list(MATERIAL_PLASTEEL = 6 SHEETS, MATERIAL_GOLD = 4 SHEETS, MATERIAL_PHORON = 2 SHEETS, MATERIAL_URANIUM = 1 SHEETS)
	build_path = /obj/item/weapon/gun/energy/xray/pistol
	research = "xray_1"

/datum/design/item/weaponfab/weapons/guns/xray // tier 3.5
	materials = list(MATERIAL_PLASTEEL = 8 SHEETS, MATERIAL_GOLD = 6 SHEETS, MATERIAL_PHORON = 4 SHEETS, MATERIAL_URANIUM = 2 SHEETS)
	build_path = /obj/item/weapon/gun/energy/xray
	research = "xray_1"

/datum/design/item/weaponfab/weapons/guns/laser_carbine // tier 3.5
	materials = list(MATERIAL_PLASTEEL = 8 SHEETS, MATERIAL_GOLD = 6 SHEETS, MATERIAL_PHORON = 4 SHEETS, MATERIAL_DIAMOND = 2 SHEETS)
	build_path = /obj/item/weapon/gun/energy/laser
	research = "energy_2"

/datum/design/item/weaponfab/weapons/guns/energy_revolver // tier 3.5
	materials = list(MATERIAL_PLASTEEL = 8 SHEETS, MATERIAL_GOLD = 6 SHEETS, MATERIAL_PHORON = 4 SHEETS, MATERIAL_DIAMOND = 2 SHEETS)
	build_path = /obj/item/weapon/gun/energy/revolver/secure
	research = "energy_2"

/datum/design/item/weaponfab/weapons/guns/energy/ionrifle/pistol // tier 3.5
	materials = list(MATERIAL_PLASTEEL = 6 SHEETS, MATERIAL_SILVER = 5 SHEETS, MATERIAL_PHORON = 4 SHEETS, MATERIAL_DIAMOND = 4 SHEETS)
	build_path = /obj/item/weapon/gun/energy/ionrifle/small
	research = "ion_1"
/datum/design/item/weaponfab/weapons/guns/energy/ionrifle // tier 4
	materials = list(MATERIAL_PLASTEEL = 10 SHEETS, MATERIAL_SILVER = 10 SHEETS, MATERIAL_PHORON = 8 SHEETS, MATERIAL_DIAMOND = 8 SHEETS)
	build_path = /obj/item/weapon/gun/energy/ionrifle
	research = "ion_2"

/datum/design/item/weaponfab/weapons/guns/energy/sniper // tier 4
	materials = list(MATERIAL_PLASTEEL = 10 SHEETS, MATERIAL_GOLD = 10 SHEETS, MATERIAL_PHORON = 10 SHEETS, MATERIAL_DIAMOND = 5 SHEETS)
	build_path = /obj/item/weapon/gun/energy/sniperrifle
	research = "energy_3"

/datum/design/item/weaponfab/weapons/guns/lasercannon // tier 4
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	materials = list(MATERIAL_PLASTEEL = 10 SHEETS, MATERIAL_GOLD = 8 SHEETS, MATERIAL_DIAMOND = 5 SHEETS, MATERIAL_URANIUM = 5 SHEETS, MATERIAL_PHORON = 5 SHEETS)
	build_path = /obj/item/weapon/gun/energy/lasercannon
	research = "energy_3"
/datum/design/item/weaponfab/weapons/guns/pulse/pistol // tier 4
	materials = list(MATERIAL_PLASTEEL = 8 SHEETS, MATERIAL_GOLD = 10 SHEETS, MATERIAL_PHORON = 6 SHEETS, MATERIAL_DIAMOND = 4 SHEETS, MATERIAL_URANIUM = 2 SHEETS)
	build_path = /obj/item/weapon/gun/energy/pulse_rifle/pistol
	research = "pulse_1"

/datum/design/item/weaponfab/weapons/guns/pulse/carbine // tier 4.5
	materials = list(MATERIAL_PLASTEEL = 12 SHEETS, MATERIAL_GOLD = 15 SHEETS, MATERIAL_PHORON = 10 SHEETS, MATERIAL_DIAMOND = 10 SHEETS, MATERIAL_URANIUM = 10 SHEETS)
	build_path = /obj/item/weapon/gun/energy/pulse_rifle/carbine
	research = "pulse_1"


//
// Not sure if those should be in the fab as-is, so I made them use a "skrell"  research
//
/datum/design/item/weaponfab/weapons/guns/energy/pistol/skrell // tier 1
	materials = list(MATERIAL_PLASTEEL = 6 SHEETS, MATERIAL_GOLD = 4 SHEETS, MATERIAL_PHORON = 2 SHEETS, MATERIAL_DIAMOND = 1 SHEETS)
	build_path = /obj/item/weapon/gun/energy/gun/skrell
	research = "skrell_1"

/datum/design/item/weaponfab/weapons/guns/pulse/skrell // tier 2
	materials = list(MATERIAL_PLASTEEL = 20 SHEETS, MATERIAL_GOLD = 20 SHEETS, MATERIAL_PHORON = 20 SHEETS, MATERIAL_DIAMOND = 20 SHEETS, MATERIAL_URANIUM = 20 SHEETS)
	build_path = /obj/item/weapon/gun/energy/pulse_rifle/skrell
	research = "skrell_2"



// END ENERGY WEAPONS



// MELEE WEAPONS

/datum/design/item/weaponfab/weapons/tacknife // tier 0
	build_path = /obj/item/weapon/material/knife/combat
	materials = list(MATERIAL_STEEL = 3 SHEETS)
	research = "melee_1"
/datum/design/item/weaponfab/weapons/unathiknife // tier 1 cosmetic
	build_path = /obj/item/weapon/material/hatchet/unathiknife
	materials = list(MATERIAL_STEEL = 3 SHEETS)
	research = "melee_1"
/datum/design/item/weaponfab/weapons/machete // tier 1 cosmetic
	build_path = /obj/item/weapon/material/hatchet/machete
	materials = list(MATERIAL_STEEL = 3 SHEETS)
	research = "melee_1"

/datum/design/item/weaponfab/weapons/melee/sword // tier 2
	build_path = /obj/item/weapon/material/sword
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_LEATHER = 1 SHEET)
	research = "melee_2"
/datum/design/item/weaponfab/weapons/buckler // tier 2
	build_path = /obj/item/weapon/shield/buckler
	materials = list(MATERIAL_STEEL = 5 SHEETS, MATERIAL_GOLD = 0.5 SHEET)
	research = "melee_2"
/datum/design/item/weaponfab/weapons/shuriken // tier 2
	build_path = /obj/item/weapon/material/star
	materials = list(MATERIAL_STEEL = 0.5 SHEETS)
	research = "melee_2"


/datum/design/item/weaponfab/weapons/melee/harpoon // tier 2
	build_path = /obj/item/weapon/material/harpoon
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_LEATHER = 1 SHEET)
	research = "melee_2"

/datum/design/item/weaponfab/weapons/melee/whip // tier 2
	build_path = /obj/item/weapon/melee/whip
	materials = list(MATERIAL_LEATHER = 2 SHEETS, MATERIAL_CLOTH = 1 SHEET)
	research = "melee_2"

/datum/design/item/weaponfab/weapons/melee/whip/fancy // tier 3
	build_path = /obj/item/weapon/melee/whip/chainofcommand
	materials = list(MATERIAL_LEATHER = 2 SHEETS, MATERIAL_CLOTH = 1 SHEET, MATERIAL_GOLD = 0.25 SHEETS, MATERIAL_SILVER = 0.25 SHEETS)
	research = "melee_3"

/datum/design/item/weaponfab/weapons/melee/sword/officersword // tier 3
	build_path = /obj/item/weapon/material/sword/officersword
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_LEATHER = 1 SHEET, MATERIAL_GOLD = 0.25 SHEET)

/datum/design/item/weaponfab/weapons/melee/sword/marinesword // tier 3
	build_path = /obj/item/weapon/material/sword/officersword/marine
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_LEATHER = 1 SHEET, MATERIAL_GOLD = 0.25 SHEET)
	research = "melee_3"
/datum/design/item/weaponfab/weapons/melee/sword/pettyofficersword // tier 3
	build_path = /obj/item/weapon/material/sword/officersword/pettyofficer
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_LEATHER = 1 SHEET, MATERIAL_GOLD = 0.25 SHEET)
	research = "melee_3"
/datum/design/item/weaponfab/weapons/machete/deluxe // tier 3
	build_path = /obj/item/weapon/material/hatchet/machete/deluxe
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_WOOD = 1 SHEET, MATERIAL_LEATHER = 1 SHEET)
	research = "melee_3"
/datum/design/item/weaponfab/weapons/melee/sword/katana // tier 3
	build_path = /obj/item/weapon/material/sword/katana
	research = "melee_3"

/datum/design/item/weaponfab/weapons/energyshield // tier 4
	build_path = /obj/item/weapon/shield/energy
	materials = list(MATERIAL_PLASTEEL = 4 SHEETS, MATERIAL_GOLD = 4 SHEETS, MATERIAL_URANIUM = 2 SHEETS, MATERIAL_PHORON = 2 SHEET)
	research = "melee_4"
/datum/design/item/weaponfab/weapons/energysword // tier 4
	materials = list(MATERIAL_PLASTEEL = 5 SHEETS, MATERIAL_GOLD = 6 SHEETS, MATERIAL_URANIUM = 5 SHEETS, MATERIAL_PHORON = 5 SHEET)
	research = "melee_4"
/datum/design/item/weaponfab/weapons/energysword/red // tier 4
	name = "red energy sword"
	build_path = /obj/item/weapon/melee/energy/sword/red
	research = "melee_4"
/datum/design/item/weaponfab/weapons/energysword/blue // tier 4
	name = "blue energy sword"
	build_path = /obj/item/weapon/melee/energy/sword/blue
	research = "melee_4"
/datum/design/item/weaponfab/weapons/energysword/green // tier 4
	name = "green energy sword"
	build_path = /obj/item/weapon/melee/energy/sword/green
	research = "melee_4"
/datum/design/item/weaponfab/weapons/energysword/cutlass // tier 4
	build_path = /obj/item/weapon/melee/energy/sword/pirate
	research = "melee_4"
/datum/design/item/weaponfab/weapons/energyaxe // tier 4.5
	build_path = /obj/item/weapon/melee/energy/axe
	materials = list(MATERIAL_PLASTEEL = 10 SHEETS, MATERIAL_GOLD = 10 SHEETS, MATERIAL_URANIUM = 10 SHEETS, MATERIAL_PHORON = 10 SHEET)
	research = "melee_4"


// END MELEE WEAPONS

// MISC WEAPONS

/datum/design/item/weaponfab/weapons/launcher/crossbow // tier 2
	build_path = /obj/item/weapon/gun/launcher/crossbow
	materials = list(MATERIAL_WOOD = 8 SHEETS, MATERIAL_STEEL = 5 SHEETS, MATERIAL_GOLD = 2 SHEETS)
	research = "melee_2"
/datum/design/item/weaponfab/weapons/arrow // tier 2
	time = 1
	build_path = /obj/item/weapon/arrow
	materials = list(MATERIAL_WOOD = 1 SHEETS, MATERIAL_STEEL = 0.5 SHEETS)
	research = "melee_2"


// END MISC Weapons

// ILLEGAL DEVICES

/datum/design/item/weaponfab/weapons/illegal/suit_sensor_jammer // tier 3
	build_path = /obj/item/device/suit_sensor_jammer
	materials = list(MATERIAL_STEEL = 5 SHEETS, MATERIAL_GOLD = 10 SHEET, MATERIAL_SILVER = 5 SHEET, MATERIAL_URANIUM = 5 SHEET, MATERIAL_PHORON = 5 SHEET, MATERIAL_DIAMOND = 3 SHEET)
	research = "illegal_1"

/datum/design/item/weaponfab/weapons/illegal/electropack // tier 3
	build_path = /obj/item/device/radio/electropack
	materials = list(MATERIAL_STEEL = 8 SHEETS, MATERIAL_GOLD = 5 SHEET, MATERIAL_SILVER = 5 SHEET, MATERIAL_URANIUM = 2 SHEET, MATERIAL_PHORON = 2 SHEET, MATERIAL_DIAMOND = 2 SHEET)
	research = "illegal_1"

/**
/datum/design/item/weaponfab/weapons/illegal/batterer // tier 4
	build_path = /obj/item/device/batterer
	materials = list(MATERIAL_STEEL = 5 SHEETS, MATERIAL_GOLD = 5 SHEET, MATERIAL_SILVER = 5 SHEET, MATERIAL_PHORON = 2 SHEET, MATERIAL_DIAMOND = 2 SHEET)
**/

/datum/design/item/weaponfab/weapons/illegal/spy_bug // tier 4
	name = "clandestine listening device (bug)"
	build_path = /obj/item/device/spy_bug
	materials = list(MATERIAL_STEEL = 1 SHEETS, MATERIAL_GOLD = 3 SHEET, MATERIAL_SILVER = 3 SHEET, MATERIAL_DIAMOND = 1 SHEET)
	research = "illegal_2"

/datum/design/item/weaponfab/weapons/illegal/spy_monitor // tier 4
	name = "clandestine monitoring device"
	build_path = /obj/item/device/spy_monitor
	materials = list(MATERIAL_STEEL = 5 SHEETS, MATERIAL_GOLD = 5 SHEET, MATERIAL_SILVER = 5 SHEET, MATERIAL_DIAMOND = 1 SHEET)
	research = "illegal_2"

/datum/design/item/weaponfab/weapons/illegal/syringe_gun/disguised // medical tech
	name = "disguised syringe gun"
	build_path = /obj/item/weapon/gun/launcher/syringe/disguised
	research = "rapid_syringe_gun"

/datum/design/item/weaponfab/weapons/illegal/imprinting // medical tech
	materials = list(MATERIAL_STEEL = 2 SHEET, MATERIAL_SILVER = 3 SHEETS, MATERIAL_COPPER = 2 SHEETS, MATERIAL_PHORON = 1 SHEET)
	build_path = /obj/item/weapon/implant/imprinting
	research = "implant_imprinting"


/datum/design/item/weaponfab/weapons/illegal/freedom // medical tech
	materials = list(MATERIAL_STEEL = 2 SHEET, MATERIAL_SILVER = 3 SHEETS, MATERIAL_COPPER = 2 SHEETS, MATERIAL_PHORON = 2 SHEET)
	build_path = /obj/item/weapon/implant/freedom
	research = "implant_freedom"


// END ILLEGAL DEVICES




// ARMOR


//
//body armor
//materials probably needs more balancing, but the general rule i had was: steel = basic/stab protection, plasteel = ballistic, ocp = thermal
//
/datum/design/item/weaponfab/armor/barmour
	category = "Oversuits - Body armour"
	materials = list(MATERIAL_LEATHER = 2.5 SHEETS, MATERIAL_STEEL = 2.5 SHEETS)

/datum/design/item/weaponfab/armor/barmour/basic_vest
	name = "armor vest - basic"
	id = "basic_vest"
	build_path = /obj/item/clothing/suit/armor/vest/old

/datum/design/item/weaponfab/armor/barmour/basic_vest_nt	// tier 1	//NT item
	name = "armor vest - basic NT"
	id = "basic_vest_nt"
	build_path = /obj/item/clothing/suit/armor/vest/old/security

/datum/design/item/weaponfab/armor/barmour/basic_vest_brown // tier 1
	name = "armor vest - basic brown"
	id = "basic_vest_brown"
	build_path = /obj/item/clothing/suit/armor/det_suit

/datum/design/item/weaponfab/armor/barmour/basic_vest_ballistic // tier 1
	name = "armor vest - basic ballistic"
	id = "basic_vest_ballistic"
	build_path = /obj/item/clothing/suit/armor/bulletproof/vest
	materials = list(MATERIAL_LEATHER = 2.5 SHEETS, MATERIAL_PLASTEEL = 2.5 SHEETS)

/datum/design/item/weaponfab/armor/barmour/basic_vest_laser // tier 1
	name = "armor vest - basic laserproof"
	id = "basic_vest_laser"
	build_path = /obj/item/clothing/suit/armor/laserproof/empty
	materials = list(MATERIAL_LEATHER = 2.5 SHEETS, MATERIAL_SILVER = 2.5 SHEETS)

/datum/design/item/weaponfab/armor/barmour/tact_vest
	name = "armor vest - tactical"
	id = "tact_vest"
	build_path = /obj/item/clothing/suit/armor/vest
	materials = list(MATERIAL_LEATHER = 2.5 SHEETS, MATERIAL_STEEL = 2.5 SHEETS, MATERIAL_SILVER = 3000)

/datum/design/item/weaponfab/armor/barmour/tact_vest_nt	//NT item
	name = "armor vest - tactical NT"
	id = "tact_vest_nt"
	build_path = /obj/item/clothing/suit/armor/vest/nt
	materials = list(MATERIAL_LEATHER = 2.5 SHEETS, MATERIAL_STEEL = 2.5 SHEETS, MATERIAL_SILVER = 3000)

/datum/design/item/weaponfab/armor/barmour/tact_vest_pcrc
	name = "armor vest - tactical PCRC"
	id = "tact_vest_pcrc"
	build_path = /obj/item/clothing/suit/armor/vest/pcrc
	materials = list(MATERIAL_LEATHER = 2.5 SHEETS, MATERIAL_STEEL = 2.5 SHEETS, MATERIAL_SILVER = 3000)

/datum/design/item/weaponfab/armor/barmour/tact_vest_press
	name = "armor vest - tactical press"
	id = "tact_vest_press"
	build_path = /obj/item/clothing/suit/armor/vest/press
	materials = list(MATERIAL_LEATHER = 2.5 SHEETS, MATERIAL_STEEL = 2.5 SHEETS, MATERIAL_SILVER = 3000)

/datum/design/item/weaponfab/armor/barmour/tact_brown
	name = "armor vest - tactical brown"
	id = "tact_brown"
	build_path = /obj/item/clothing/suit/armor/vest/detective
	materials = list(MATERIAL_LEATHER = 2.5 SHEETS, MATERIAL_STEEL = 2.5 SHEETS, MATERIAL_SILVER = 3000)

/datum/design/item/weaponfab/armor/barmour/stab_vest
	name = "armor vest - stab protection"
	id = "stab_vest"
	build_path = /obj/item/clothing/suit/armor/riot/empty
	materials = list(MATERIAL_LEATHER = 2.5 SHEETS, MATERIAL_STEEL = 5 SHEETS)

/datum/design/item/weaponfab/armor/barmour/pocket_vest
	name = "armor vest - webbed"
	id = "pocket_vest"
	build_path = /obj/item/clothing/suit/storage/vest
	materials = list(MATERIAL_LEATHER = 2.5 SHEETS, MATERIAL_STEEL = 5 SHEETS)

/datum/design/item/weaponfab/armor/barmour/pocket_vest_sec
	name = "armor vest - webbed security"
	id = "pocket_vest_sec"
	build_path = /obj/item/clothing/suit/storage/vest/nt
	materials = list(MATERIAL_LEATHER = 2.5 SHEETS, MATERIAL_STEEL = 5 SHEETS, MATERIAL_SILVER = 2 SHEETS)

/datum/design/item/weaponfab/armor/barmour/pocket_vest_pcrc
	name = "armor vest - webbed PCRC"
	id = "pocket_vest_pcrc"
	build_path = /obj/item/clothing/suit/storage/vest/pcrc
	materials = list(MATERIAL_LEATHER = 2.5 SHEETS, MATERIAL_STEEL = 5 SHEETS, MATERIAL_SILVER = 2 SHEETS)

/datum/design/item/weaponfab/armor/barmour/pocket_vest_warden
	name = "armor vest - webbed warden"
	id = "pocket_vest_warden"
	build_path = /obj/item/clothing/suit/storage/vest/nt/warden
	materials = list(MATERIAL_LEATHER = 2.5 SHEETS, MATERIAL_STEEL = 5 SHEETS, MATERIAL_SILVER = 2 SHEETS)

///datum/design/item/weaponfab/armor/barmour/pocket_vest_com
//	name = "armor vest - webbed commander"
//	id = "pocket_vest_com"
//	build_path = /obj/item/clothing/suit/storage/vest/nt/hos
//	materials = list(MATERIAL_LEATHER = 2.5 SHEETS, MATERIAL_STEEL = 5 SHEETS, MATERIAL_SILVER = 2 SHEETS)

/datum/design/item/weaponfab/armor/barmour/pocket_vest_tact
	name = "armor vest - large webbed tactical"
	id = "pocket_vest_tact"
	build_path = /obj/item/clothing/suit/storage/vest/tactical
	materials = list(MATERIAL_LEATHER = 2.5 SHEETS, MATERIAL_STEEL = 5 SHEETS, MATERIAL_SILVER = 2 SHEETS)

/datum/design/item/weaponfab/armor/barmour/pocket_vest_fleet
	name = "armor vest - large webbed fleet"
	id = "pocket_vest_fleet"
	build_path = /obj/item/clothing/suit/storage/vest/tactical/mirania
	materials = list(MATERIAL_LEATHER = 2.5 SHEETS, MATERIAL_STEEL = 5 SHEETS, MATERIAL_SILVER = 2 SHEETS)

/datum/design/item/weaponfab/armor/barmour/suit_vest_combat
	name = "body armor - large webbed combat"
	id = "pocket_vest_combat"
	build_path = /obj/item/clothing/suit/storage/vest/merc
	materials = list(MATERIAL_LEATHER = 2.5 SHEETS, MATERIAL_STEEL = 5 SHEETS, MATERIAL_SILVER = 2 SHEETS)

/datum/design/item/weaponfab/armor/barmour/suit_ballistic
	name = "body armor - ballistic"
	id = "suit_ballistic"
	build_path = /obj/item/clothing/suit/armor/bulletproof
	materials = list(MATERIAL_STEEL = 11 SHEET, MATERIAL_PLASTEEL = 5 SHEETS)

/datum/design/item/weaponfab/armor/barmour/suit_stab
	name = "body armor - riot control"
	id = "suit_stab"
	build_path = /obj/item/clothing/suit/armor/riot
	materials = list(MATERIAL_STEEL = 5 SHEETS)

/datum/design/item/weaponfab/armor/barmour/helmet_riot
	name = "Helmet - riot control"
	id = "helmet_riot"
	build_path = /obj/item/clothing/head/helmet/riot
	materials = list(MATERIAL_STEEL = 1000, "plastic" = 5 SHEETS)

/datum/design/item/weaponfab/armor/barmour/suit_laserproof
	name = "body armor - laserproof"
	id = "suit_laserproof"
	build_path = /obj/item/clothing/suit/armor/laserproof
	materials = list(MATERIAL_STEEL = 11 SHEET, MATERIAL_SILVER = 11 SHEET)

/datum/design/item/weaponfab/armor/barmour/suit_combat
	name = "body armor - heavy duty"
	id = "suit_combat"
	build_path = /obj/item/clothing/suit/armor/heavy
	materials = list(MATERIAL_STEEL = 30000, MATERIAL_PLASTEEL = 5 SHEETS, MATERIAL_SILVER = 2.5 SHEETS)

/datum/design/item/weaponfab/armor/barmour/suit_hofficer	//maybe remove, bad colors
	name = "body armor - high ranking officer"
	id = "suit_hofficer"
	build_path = /obj/item/clothing/suit/armor/centcomm
	materials = list(MATERIAL_STEEL = 30000, MATERIAL_PLASTEEL = 5 SHEETS, MATERIAL_SILVER = 2.5 SHEETS)

/datum/design/item/weaponfab/armor/barmour/suit_coat
	name = "body armor - coat"
	id = "suit_coat"
	build_path = /obj/item/clothing/suit/armor/hos
	materials = list(MATERIAL_LEATHER = 1 SHEET, MATERIAL_STEEL = 2.5 SHEETS, MATERIAL_PLASTEEL = 2.5 SHEETS, MATERIAL_SILVER = 2 SHEETS)

/datum/design/item/weaponfab/armor/barmour/suit_trenchcoat
	name = "body armor - trenchcoat"
	id = "suit_trenchcoat"
	build_path = /obj/item/clothing/suit/armor/hos/jensen
	materials = list(MATERIAL_LEATHER = 1 SHEET, MATERIAL_STEEL = 2.5 SHEETS, MATERIAL_PLASTEEL = 2.5 SHEETS, MATERIAL_SILVER = 2 SHEETS)

/datum/design/item/weaponfab/armor/barmour/suit_sec
	name = "body armor - red coat"
	id = "suit_sec"
	build_path = /obj/item/clothing/suit/armor/vest/warden
	materials = list(MATERIAL_LEATHER = 2.5 SHEETS, MATERIAL_STEEL = 2.5 SHEETS, MATERIAL_SILVER = 7000)

/datum/design/item/weaponfab/armor/barmour/guard_robes
	name = "body armor - guard robes"
	id = "guard_robes"
	build_path =/obj/item/clothing/suit/armor/robes
	materials = list(MATERIAL_STEEL = 30000, MATERIAL_PLASTEEL = 5 SHEETS, MATERIAL_SILVER = 2.5 SHEETS)

/datum/design/item/autotailor/ccombat/barmour/guard_helmet
	name = "Helmet - guard mantle"
	id = "guard_helmet"
	build_path = /obj/item/clothing/head/helmet/guard
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_PLASTEEL = 0.5 SHEETS, MATERIAL_SILVER = 0.5 SHEETS)

/datum/design/item/weaponfab/armor/barmour/ert_comarmor
	name = "ERT body armor - commander"
	id = "ert_comarmor"
	build_path = /obj/item/clothing/suit/armor/vest/ert
	materials = list(MATERIAL_LEATHER = 2.5 SHEETS, MATERIAL_STEEL = 5 SHEETS, MATERIAL_SILVER = 2 SHEETS)

/datum/design/item/weaponfab/armor/barmour/ert_comhat
	name = "ERT helmet - commander"
	id = "ert_comhat"
	build_path = /obj/item/clothing/head/helmet/ert
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_PLASTEEL = 0.5 SHEETS, MATERIAL_SILVER = 0.5 SHEETS)

/datum/design/item/weaponfab/armor/barmour/ert_engarmor
	name = "ERT body armor - engineer"
	id = "ert_engarmor"
	build_path = /obj/item/clothing/suit/armor/vest/ert/engineer
	materials = list(MATERIAL_LEATHER = 2.5 SHEETS, MATERIAL_STEEL = 5 SHEETS, MATERIAL_SILVER = 2 SHEETS)

/datum/design/item/weaponfab/armor/barmour/ert_enghat
	name = "ERT helmet - engineer"
	id = "ert_enghat"
	build_path = /obj/item/clothing/head/helmet/ert/engineer
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_PLASTEEL = 0.5 SHEETS, MATERIAL_SILVER = 0.5 SHEETS)

/datum/design/item/weaponfab/armor/barmour/ert_secarmor
	name = "ERT body armor - security"
	id = "ert_secarmor"
	build_path = /obj/item/clothing/suit/armor/vest/ert/security
	materials = list(MATERIAL_LEATHER = 2.5 SHEETS, MATERIAL_STEEL = 5 SHEETS, MATERIAL_SILVER = 2 SHEETS)

/datum/design/item/weaponfab/armor/barmour/ert_sechat
	name = "ERT helmet - security"
	id = "ert_sechat"
	build_path = /obj/item/clothing/head/helmet/ert/security
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_PLASTEEL = 0.5 SHEETS, MATERIAL_SILVER = 0.5 SHEETS)

/datum/design/item/weaponfab/armor/barmour/ert_docarmor
	name = "ERT body armor - medical"
	id = "ert_docarmor"
	build_path = /obj/item/clothing/suit/armor/vest/ert/medical
	materials = list(MATERIAL_LEATHER = 2.5 SHEETS, MATERIAL_STEEL = 5 SHEETS, MATERIAL_SILVER = 2 SHEETS)

/datum/design/item/weaponfab/armor/barmour/ert_dochat
	name = "ERT helmet - medical"
	id = "ert_dochat"
	build_path = /obj/item/clothing/head/helmet/ert/medical
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_PLASTEEL = 0.5 SHEETS, MATERIAL_SILVER = 0.5 SHEETS)

/datum/design/item/weaponfab/armor/barmour/bombsuit_purple
	name = "Bombsuit - purple stripes"
	id = "bomsuit_purple"
	build_path = /obj/item/clothing/suit/bomb_suit
	materials = list(MATERIAL_LEATHER = 2.5 SHEETS, MATERIAL_STEEL = 30000)

/datum/design/item/weaponfab/armor/barmour/bombhood_purple
	name = "Bombsuit hood - purple"
	id = "bombhood_purple"
	build_path = /obj/item/clothing/head/bomb_hood
	materials = list(MATERIAL_LEATHER = 1 SHEET, MATERIAL_STEEL = 5 SHEETS, "plastic" = 5 SHEETS)

/datum/design/item/weaponfab/armor/barmour/bombsuit_green
	name = "Bombsuit - green"
	id = "bombsuit_green"
	build_path = /obj/item/clothing/suit/bomb_suit/security
	materials = list(MATERIAL_LEATHER = 2.5 SHEETS, MATERIAL_STEEL = 30000)

/datum/design/item/weaponfab/armor/barmour/bombhood_green
	name = "Bombsuit hood - green"
	id = "bombhood_green"
	build_path = /obj/item/clothing/head/bomb_hood/security
	materials = list(MATERIAL_LEATHER = 1 SHEET, MATERIAL_STEEL = 5 SHEETS, "plastic" = 5 SHEETS)

/datum/design/item/weaponfab/armor/barmour/dermal	//remove this when implants exist
	name = "Dermal Patch"
	id = "dermal"
	build_path = /obj/item/clothing/head/HoS/dermal
	materials = list(MATERIAL_PLASTEEL = 1 SHEET, MATERIAL_SILVER = 1 SHEET, MATERIAL_PHORON = 2.5 SHEETS)

/datum/design/item/weaponfab/armor/barmour/helmet_laserproof
	name = "Helmet - laserproof"
	id = "helmet_laserproof"
	build_path = /obj/item/clothing/head/helmet/ablative
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_SILVER = 1 SHEET)

/datum/design/item/weaponfab/armor/barmour/helmet_ballistic
	name = "Helmet - ballistic"
	id = "helmet_ballistic"
	build_path = /obj/item/clothing/head/helmet/ballistic
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_PLASTEEL = 1 SHEET)

/datum/design/item/weaponfab/armor/barmour/helmet_tan
	name = "Helmet - tactical"
	id = "helmet_tan"
	build_path = /obj/item/clothing/head/helmet/tactical
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_PLASTEEL = 7000)

/datum/design/item/weaponfab/armor/barmour/helmet_navy
	name = "Helmet - navy"
	id = "helmet_navy"
	build_path = /obj/item/clothing/head/helmet/tactical/mirania
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_PLASTEEL = 1 SHEET)

/datum/design/item/weaponfab/armor/barmour/helmet_black
	name = "helmet - black"
	id = "helmet_black"
	build_path = /obj/item/clothing/head/helmet
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_PLASTEEL = 1 SHEET)

/datum/design/item/weaponfab/armor/barmour/helmet_bl_redstripe
	name = "Helmet - black w. red stripes"
	id = "helmet_bl_redstripe"
	build_path = /obj/item/clothing/head/helmet/merc
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_PLASTEEL = 9000,  MATERIAL_SILVER = 1 SHEET)

/datum/design/item/weaponfab/armor/barmour/helmet_bl_redmark
	name = "Helmet - black w. red markings"
	id = "helmet_bl_redmark"
	build_path = /obj/item/clothing/head/helmet/nt
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_PLASTEEL = 1 SHEET)

/datum/design/item/weaponfab/armor/barmour/helmet_bl_bluemark
	name = "Helmet - black w. blue markings"
	id = "helmet_bl_bluemark"
	build_path = /obj/item/clothing/head/helmet/pcrc
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_PLASTEEL = 1 SHEET)

/datum/design/item/weaponfab/armor/barmour/helmet_augment
	name = "Helmet - augmented"
	id = "helmet_augment"
	build_path = /obj/item/clothing/head/helmet/augment
	materials = list(MATERIAL_STEEL = 1 SHEET,MATERIAL_PLASTEEL = 1 SHEET, MATERIAL_SILVER = 1 SHEET,MATERIAL_PHORON = 2.5 SHEETS)

/datum/design/item/weaponfab/armor/barmour/arm_guards
	name = "Gloves - arm guards"
	id = "arm_guards"
	build_path = /obj/item/clothing/gloves/guards
	materials = list(MATERIAL_LEATHER = 0.5 SHEETS, MATERIAL_PLASTEEL = 1 SHEET, MATERIAL_SILVER = 1 SHEET)

/datum/design/item/weaponfab/armor/barmour/guard_gloves
	name = "Gloves - guard gloves"
	id = "guard_gloves"
	build_path = /obj/item/clothing/gloves/thick/blueguard
	materials = list(MATERIAL_LEATHER = 0.5 SHEETS, MATERIAL_PLASTEEL = 0.5 SHEETS)

//
//modular body armor
//
/datum/design/item/weaponfab/armor/modular_armor
	category = "Plate carriers"
	materials = list(MATERIAL_LEATHER = 2.5 SHEETS)

/datum/design/item/weaponfab/armor/modular_armor/vest_black
	name = "Plate carrier - black"
	id = "vest_black"
	build_path = /obj/item/clothing/suit/armor/pcarrier

/datum/design/item/weaponfab/armor/modular_armor/vest_navy
	name = "Plate carrier - navy"
	id = "vest_navy"
	build_path = /obj/item/clothing/suit/armor/pcarrier/navy

/datum/design/item/weaponfab/armor/modular_armor/vest_green
	name = "Plate carrier - green"
	id = "vest_green"
	build_path = /obj/item/clothing/suit/armor/pcarrier/green

/datum/design/item/weaponfab/armor/modular_armor/vest_tan
	name = "Plate carrier - tan"
	id = "vest_tan"
	build_path = /obj/item/clothing/suit/armor/pcarrier/tan

/datum/design/item/weaponfab/armor/modular_armor/vest_blue
	name = "Plate carrier - blue"
	id = "vest_blue"
	build_path = /obj/item/clothing/suit/armor/pcarrier/blue

/datum/design/item/weaponfab/armor/modular_armor/chest_light
	name = "Chestplate - light"
	id = "chest_light"
	build_path = /obj/item/clothing/accessory/armorplate
	materials = list(MATERIAL_STEEL = 2.5 SHEETS)

/datum/design/item/weaponfab/armor/modular_armor/chest_med
	name = "Chestplate - medium"
	id = "chest_med"
	build_path = /obj/item/clothing/accessory/armorplate/medium
	materials = list(MATERIAL_STEEL = 2.5 SHEETS, MATERIAL_PLASTEEL = 7000, MATERIAL_SILVER = 7000)

/datum/design/item/weaponfab/armor/modular_armor/chest_medtan
	name = "Chestplate - medium tan"
	id = "chest_medtan"
	build_path = /obj/item/clothing/accessory/armorplate/tactical
	materials = list(MATERIAL_STEEL = 2.5 SHEETS, MATERIAL_PLASTEEL = 2 SHEETS, MATERIAL_SILVER = 2 SHEETS)

/datum/design/item/weaponfab/armor/modular_armor/chest_heavy
	name = "Chestplate - heavy"
	id = "chest_heavy"
	build_path = /obj/item/clothing/accessory/armorplate/merc
	materials = list(MATERIAL_STEEL = 2.5 SHEETS, MATERIAL_PLASTEEL = 2.5 SHEETS, MATERIAL_SILVER = 2.5 SHEETS)

/datum/design/item/weaponfab/armor/modular_armor/arm_black
	name = "Armguards - black"
	id = "arm_black"
	build_path = /obj/item/clothing/accessory/armguards
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_PLASTEEL = 6000, MATERIAL_SILVER = 6000)

/datum/design/item/weaponfab/armor/modular_armor/arm_tan
	name = "Armguards - tan"
	id = "arm_tan"
	build_path = /obj/item/clothing/accessory/armguards/tan
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_PLASTEEL = 6000, MATERIAL_SILVER = 6000)

/datum/design/item/weaponfab/armor/modular_armor/arm_green
	name = "Armguards - green"
	id = "arm_green"
	build_path = /obj/item/clothing/accessory/armguards/green
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_PLASTEEL = 6000, MATERIAL_SILVER = 6000)

/datum/design/item/weaponfab/armor/modular_armor/arm_navy
	name = "Armguards - navy"
	id = "arm_navy"
	build_path = /obj/item/clothing/accessory/armguards/navy
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_PLASTEEL = 6000, MATERIAL_SILVER = 6000)

/datum/design/item/weaponfab/armor/modular_armor/arm_blue
	name = "Armguards - blue"
	id = "arm_blue"
	build_path = /obj/item/clothing/accessory/armguards/blue
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_PLASTEEL = 6000, MATERIAL_SILVER = 6000)

/datum/design/item/weaponfab/armor/modular_armor/arm_heavy
	name = "Armguards - heavy"
	id = "arm_heavy"
	build_path = /obj/item/clothing/accessory/armguards/merc
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_PLASTEEL = 9000, MATERIAL_SILVER = 9000)

/datum/design/item/weaponfab/armor/modular_armor/leg_black
	name = "Legguards - black"
	id = "leg_black"
	build_path = /obj/item/clothing/accessory/legguards
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_PLASTEEL = 6000, MATERIAL_SILVER = 6000)

/datum/design/item/weaponfab/armor/modular_armor/leg_tan
	name = "Legguards - tan"
	id = "leg_tan"
	build_path = /obj/item/clothing/accessory/legguards/tan
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_PLASTEEL = 6000, MATERIAL_SILVER = 6000)

/datum/design/item/weaponfab/armor/modular_armor/leg_green
	name = "Legguards - green"
	id = "leg_green"
	build_path = /obj/item/clothing/accessory/legguards/green
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_PLASTEEL = 6000, MATERIAL_SILVER = 6000)

/datum/design/item/weaponfab/armor/modular_armor/leg_navy
	name = "Legguards - navy"
	id = "leg_navy"
	build_path = /obj/item/clothing/accessory/legguards/navy
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_PLASTEEL = 6000, MATERIAL_SILVER = 6000)

/datum/design/item/weaponfab/armor/modular_armor/leg_blue
	name = "Legguards - blue"
	id = "leg_blue"
	build_path = /obj/item/clothing/accessory/legguards/blue
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_PLASTEEL = 6000, MATERIAL_SILVER = 6000)

/datum/design/item/weaponfab/armor/modular_armor/leg_heavy
	name = "Legguards - heavy"
	id = "leg_heavy"
	build_path = /obj/item/clothing/accessory/legguards/merc
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_PLASTEEL = 9000, MATERIAL_SILVER = 9000)

/datum/design/item/weaponfab/armor/modular_armor/s_store_black
	name = "Storage pouches - small black"
	id = "s_store_black"
	build_path = /obj/item/clothing/accessory/storage/pouches
	materials = list("cloth" = 2.5 SHEETS, MATERIAL_LEATHER = 5 SHEETS)

/datum/design/item/weaponfab/armor/modular_armor/s_store_tan
	name = "Storage pouches - small tan"
	id = "s_store_tan"
	build_path = /obj/item/clothing/accessory/storage/pouches/tan
	materials = list("cloth" = 2.5 SHEETS, MATERIAL_LEATHER = 5 SHEETS)

/datum/design/item/weaponfab/armor/modular_armor/s_store_green
	name = "Storage pouches - small green"
	id = "s_store_green"
	build_path = /obj/item/clothing/accessory/storage/pouches/green
	materials = list("cloth" = 2.5 SHEETS, MATERIAL_LEATHER = 5 SHEETS)

/datum/design/item/weaponfab/armor/modular_armor/s_store_navy
	name = "Storage pouches - small navy "
	id = "s_store_navy"
	build_path = /obj/item/clothing/accessory/storage/pouches/navy
	materials = list("cloth" = 2.5 SHEETS, MATERIAL_LEATHER = 5 SHEETS)

/datum/design/item/weaponfab/armor/modular_armor/s_store_blue
	name = "Storage pouches - small blue"
	id = "s_store_blue"
	build_path = /obj/item/clothing/accessory/storage/pouches/blue
	materials = list("cloth" = 2.5 SHEETS, MATERIAL_LEATHER = 5 SHEETS)

/datum/design/item/weaponfab/armor/modular_armor/l_store_black
	name = "Storage pouches - large black"
	id = "l_store_black"
	build_path = /obj/item/clothing/accessory/storage/pouches/large
	materials = list("cloth" = 5 SHEETS, MATERIAL_LEATHER = 8 SHEET)

/datum/design/item/weaponfab/armor/modular_armor/l_store_tan
	name = "Storage pouches - large tan"
	id = "l_store_tan"
	build_path = /obj/item/clothing/accessory/storage/pouches/large/tan
	materials = list("cloth" = 5 SHEETS, MATERIAL_LEATHER = 8 SHEET)

/datum/design/item/weaponfab/armor/modular_armor/l_store_green
	name = "Storage pouches - large green"
	id = "l_store_green"
	build_path = /obj/item/clothing/accessory/storage/pouches/large/green
	materials = list("cloth" = 5 SHEETS, MATERIAL_LEATHER = 8 SHEET)

/datum/design/item/weaponfab/armor/modular_armor/l_store_navy
	name = "Storage pouches - large navy "
	id = "l_store_navy"
	build_path = /obj/item/clothing/accessory/storage/pouches/large/navy
	materials = list("cloth" = 5 SHEETS, MATERIAL_LEATHER = 8 SHEET)

/datum/design/item/weaponfab/armor/modular_armor/l_store_blue
	name = "Storage pouches - large blue"
	id = "l_store_blue"
	build_path = /obj/item/clothing/accessory/storage/pouches/large/blue
	materials = list("cloth" = 5 SHEETS, MATERIAL_LEATHER = 8 SHEET)

/datum/design/item/weaponfab/armor/modular_armor/tag_red
	name = "Accessory - red tag"
	id = "tag_red"
	build_path = /obj/item/clothing/accessory/armor/tag/nt
	materials = list(MATERIAL_STEEL = 500, "plastic" = 500)

/datum/design/item/weaponfab/armor/modular_armor/tag_blue
	name = "Accessory - blue tag"
	id = "tag_blue"
	build_path = /obj/item/clothing/accessory/armor/tag/pcrc
	materials = list(MATERIAL_STEEL = 500, "plastic" = 500)

/datum/design/item/weaponfab/armor/modular_armor/tag_green
	name = "Accessory - green tag"
	id = "tag_green"
	build_path = /obj/item/clothing/accessory/armor/tag/saare
	materials = list(MATERIAL_STEEL = 500, "plastic" = 500)

/datum/design/item/weaponfab/armor/modular_armor/tag_white
	name = "Accessory - white tag"
	id = "tag_white"
	build_path = /obj/item/clothing/accessory/armor/tag/press
	materials = list(MATERIAL_STEEL = 500, "plastic" = 500)

/datum/design/item/weaponfab/armor/modular_armor/apos_tag
	name = "Accessory - A+ tag"
	id = "apos_tag"
	build_path = /obj/item/clothing/accessory/armor/tag/apos
	materials = list("cloth" = 1000, "plastic" = 500)

/datum/design/item/weaponfab/armor/modular_armor/aneg_tag
	name = "Accessory - A- tag"
	id = "aneg_tag"
	build_path = /obj/item/clothing/accessory/armor/tag/aneg
	materials = list("cloth" = 1000, "plastic" = 500)

/datum/design/item/weaponfab/armor/modular_armor/abpos_tag
	name = "Accessory - AB+ tag "
	id = "abpos_tag"
	build_path = /obj/item/clothing/accessory/armor/tag/abpos
	materials = list("cloth" = 1000, "plastic" = 500)

/datum/design/item/weaponfab/armor/modular_armor/abneg_tag
	name = "Accessory - AB- tag"
	id = "abneg_tag"
	build_path = /obj/item/clothing/accessory/armor/tag/abneg
	materials = list("cloth" = 1000, "plastic" = 500)

/datum/design/item/weaponfab/armor/modular_armor/bpos_tag
	name = "Accessory - B+ tag"
	id = "bpos_tag"
	build_path = /obj/item/clothing/accessory/armor/tag/bpos
	materials = list("cloth" = 1000, "plastic" = 500)

/datum/design/item/weaponfab/armor/modular_armor/bneg_tag
	name = "Accessory - B- tag"
	id = "bneg_tag"
	build_path = /obj/item/clothing/accessory/armor/tag/bneg
	materials = list("cloth" = 1000, "plastic" = 500)

/datum/design/item/weaponfab/armor/modular_armor/opos_tag
	name = "Accessory - O+ tag"
	id = "opos_tag"
	build_path = /obj/item/clothing/accessory/armor/tag/opos
	materials = list("cloth" = 1000, "plastic" = 500)

/datum/design/item/weaponfab/armor/modular_armor/oneg_tag
	name = "Accessory - O- tag"
	id = "oneg_tag"
	build_path = /obj/item/clothing/accessory/armor/tag/oneg
	materials = list("cloth" = 1000, "plastic" = 500)

//
//accessories
//
/datum/design/item/weaponfab/armor/accessory
	category = "Tactical accessories"

/datum/design/item/weaponfab/armor/accessory/bandolier_access
	name = "Accessory - bandolier"
	id = "bandolier_access"
	build_path = /obj/item/clothing/accessory/storage/bandolier
	materials = list(MATERIAL_LEATHER = 30000)

/datum/design/item/weaponfab/armor/accessory/holster_waist
	name = "Holster - waist"
	id = "holster_waist"
	build_path = /obj/item/clothing/accessory/storage/holster/waist
	materials = list(MATERIAL_LEATHER = 30000, MATERIAL_STEEL = 2.5 SHEETS)

/datum/design/item/weaponfab/armor/accessory/holster_arm
	name = "Holster - armpit"
	id = "holster_arm"
	build_path = /obj/item/clothing/accessory/storage/holster/armpit
	materials = list(MATERIAL_LEATHER = 30000, MATERIAL_STEEL = 2.5 SHEETS)

/datum/design/item/weaponfab/armor/accessory/holster_hip
	name = "Holster - hip"
	id = "holster_hip"
	build_path = /obj/item/clothing/accessory/storage/holster/hip
	materials = list(MATERIAL_LEATHER = 30000, MATERIAL_STEEL = 2.5 SHEETS)

/datum/design/item/weaponfab/armor/accessory/holster_thigh
	name = "Holster - thigh"
	id = "holster_thigh"
	build_path = /obj/item/clothing/accessory/storage/holster/thigh
	materials = list(MATERIAL_LEATHER = 30000, MATERIAL_STEEL = 2.5 SHEETS)

/datum/design/item/weaponfab/armor/accessory/holster_machete
	name = "Holster - machete"
	id = "holster_machete"
	build_path = /obj/item/clothing/accessory/storage/holster/machete
	materials = list(MATERIAL_LEATHER = 30000, MATERIAL_STEEL = 2.5 SHEETS)

/datum/design/item/weaponfab/armor/accessory/holster_knife
	name = "Dectroated harness - knife"
	id = "holster_knife"
	build_path = /obj/item/clothing/accessory/storage/knifeharness
	materials = list(MATERIAL_LEATHER = 30000, MATERIAL_STEEL = 2.5 SHEETS)

/datum/design/item/weaponfab/armor/accessory/access_ubac_bla
	name = "Accessory - black ubac"
	id = "access_ubac_bla"
	build_path = /obj/item/clothing/accessory/ubac
	materials = list("cloth" = 0.5 SHEETS)

/datum/design/item/weaponfab/armor/accessory/access_ubac_blue
	name = "Accessory - blue ubac"
	id = "access_ubac_blue"
	build_path = /obj/item/clothing/accessory/ubac/blue
	materials = list("cloth" = 0.5 SHEETS)

/datum/design/item/weaponfab/armor/accessory/access_ubac_tan
	name = "Accessory - tan ubac"
	id = "access_ubac_tan"
	build_path = /obj/item/clothing/accessory/ubac/tan
	materials = list("cloth" = 0.5 SHEETS)

/datum/design/item/weaponfab/armor/accessory/access_ubac_green
	name = "Accessory - green ubac"
	id = "access_ubac_green"
	build_path = /obj/item/clothing/accessory/ubac/green
	materials = list("cloth" = 0.5 SHEETS)

/datum/design/item/weaponfab/armor/accessory/holobadge
	name = "Holobadge - Police"
	id = "holobadge"
	build_path = /obj/item/clothing/accessory/badge/holo
	materials = list(MATERIAL_STEEL = 0.5 SHEETS, MATERIAL_PHORON = 0.5 SHEETS)

/datum/design/item/weaponfab/armor/accessory/holotag
	name = "Holobadge lanyard - Police"
	id = "holotag"
	build_path = /obj/item/clothing/accessory/badge/holo/cord
	materials = list(MATERIAL_STEEL = 0.5 SHEETS, MATERIAL_PHORON = 0.5 SHEETS)

/datum/design/item/weaponfab/armor/accessory/holobadge_det
	name = "Holobadge - Private Security"
	id = "holobadge_det"
	build_path = /obj/item/clothing/accessory/badge/defenseintel
	materials = list(MATERIAL_STEEL = 0.5 SHEETS, MATERIAL_PHORON = 0.5 SHEETS)

/datum/design/item/weaponfab/armor/accessory/holobadge_det_old
	name = "Holobadge - Old"
	id = "holobadge_det_old"
	build_path = /obj/item/clothing/accessory/badge/old
	materials = list(MATERIAL_STEEL = 0.5 SHEETS, MATERIAL_PHORON = 0.5 SHEETS)

// /datum/design/item/weaponfab/armor/accessory/holobadge_marshal
// 	name = "Holobadge - marshal"
// 	id = "holobadge_marshal"
// 	build_path = /obj/item/clothing/accessory/badge/marshal
// 	materials = list(MATERIAL_STEEL = 0.5 SHEETS, MATERIAL_PHORON = 0.5 SHEETS)

/datum/design/item/weaponfab/armor/accessory/holotag_det
	name = "Badge - Detective"
	id = "holotag_det"
	build_path = /obj/item/clothing/accessory/badge
	materials = list(MATERIAL_STEEL = 0.5 SHEETS, MATERIAL_PHORON = 0.5 SHEETS)

/datum/design/item/weaponfab/armor/accessory/holotag_agent
	name = "Badge - Office of Internal Control"
	id = "holotag_agent"
	build_path = /obj/item/clothing/accessory/badge/interstellarintel
	materials = list(MATERIAL_STEEL = 0.5 SHEETS, MATERIAL_PHORON = 0.5 SHEETS)

/datum/design/item/weaponfab/armor/accessory/holotag_agent
	name = "Badge - Governor Appointee"
	id = "holotag_agent"
	build_path = /obj/item/clothing/accessory/badge/tracker
	materials = list(MATERIAL_STEEL = 0.5 SHEETS, MATERIAL_PHORON = 0.5 SHEETS)

/datum/design/item/weaponfab/armor/accessory/holotag_agent
	name = "Badge - Council Appointee"
	id = "holotag_agent"
	build_path = /obj/item/clothing/accessory/badge/ocieagent
	materials = list(MATERIAL_STEEL = 0.5 SHEETS, MATERIAL_PHORON = 0.5 SHEETS)

/datum/design/item/weaponfab/armor/accessory/holotag_press
	name = "Holotag - Press"
	id = "holotag_press"
	build_path = /obj/item/clothing/accessory/badge/press
	materials = list(MATERIAL_STEEL = 0.5 SHEETS, MATERIAL_PHORON = 0.5 SHEETS)

/datum/design/item/weaponfab/armor/accessory/holotag_nt	//nt item
	name = "Holotag - Corporate Exec"
	id = "holotag_nt"
	build_path = /obj/item/clothing/accessory/badge/nanotrasen
	materials = list(MATERIAL_STEEL = 0.5 SHEETS, MATERIAL_PHORON = 0.5 SHEETS)




// END ARMOR







//Ammunition
/datum/design/item/weaponfab/ammo
	category = "Ammunition"
	req_tech = list(TECH_MATERIAL = 1, TECH_COMBAT = 1)
	time = 1
/datum/design/item/weaponfab/c357
	name = ".357 Bullet"
	id = "c357"
	build_path = /obj/item/ammo_casing/c357
	materials = list(MATERIAL_STEEL = 210)

/datum/design/item/weaponfab/c50
	name = ".50 Bullet"
	id = "c50"
	build_path = /obj/item/ammo_casing/c50
	materials = list(MATERIAL_STEEL = 260)

/datum/design/item/weaponfab/c22lr
	name = ".22 Long Rifle Bullet"
	id = "c22"
	build_path = /obj/item/ammo_casing/c22lr
	materials = list(MATERIAL_STEEL = 40)

/datum/design/item/weaponfab/c38
	name = ".38 Bullet"
	id = "c38"
	build_path = /obj/item/ammo_casing/c38
	materials = list(MATERIAL_STEEL = 60)

/datum/design/item/weaponfab/c38/rubber
	name = "Rubber .38 Bullet"
	id = "c38r"
	build_path = /obj/item/ammo_casing/c38/rubber
	materials = list(MATERIAL_PLASTIC = 60)

/datum/design/item/weaponfab/c9mm
	name = "9mm Bullet"
	id = "c9mm"
	build_path = /obj/item/ammo_casing/c9mm
	materials = list(MATERIAL_STEEL = 60)

/datum/design/item/weaponfab/c9mm/flash
	name = "Flash 9mm Bullet"
	id = "c9mmf"
	build_path = /obj/item/ammo_casing/c9mm/flash
	materials = list(MATERIAL_STEEL = 50)

/datum/design/item/weaponfab/c9mm/rubber
	name = "Rubber 9mm Bullet"
	id = "c9mmr"
	build_path = /obj/item/ammo_casing/c9mm/rubber
	materials = list(MATERIAL_STEEL = 60)

/datum/design/item/weaponfab/c9mm/practice
	name = "Practice 9mm Bullet"
	id = "c9mmp"
	build_path = /obj/item/ammo_casing/c9mm/practice
	materials = list(MATERIAL_STEEL = 50)

/datum/design/item/weaponfab/c44
	name = ".44 Bullet"
	id = "c44"
	build_path = /obj/item/ammo_casing/c44
	materials = list(MATERIAL_STEEL = 75)

/datum/design/item/weaponfab/c44/rubber
	name = "Rubber .44 Bullet"
	id = "c44r"
	build_path = /obj/item/ammo_casing/c44/rubber
	materials = list(MATERIAL_PLASTIC = 75)

/datum/design/item/weaponfab/c44/nullglass
	name = "Nullglass .44 Bullet"
	id = "c44ng"
	build_path = /obj/item/ammo_casing/c44/nullglass
	materials = list(MATERIAL_NULLGLASS = 75)

/datum/design/item/weaponfab/c45
	name = ".45 Bullet"
	id = "c45"
	build_path = /obj/item/ammo_casing/c45
	materials = list(MATERIAL_STEEL = 75)

/datum/design/item/weaponfab/c45/rubber
	name = "Rubber.45 Bullet"
	id = "c45r"
	build_path = /obj/item/ammo_casing/c45/rubber
	materials = list(MATERIAL_PLASTIC = 75)

/datum/design/item/weaponfab/c45/practice
	name = "Practice .45 Bullet"
	id = "c45p"
	build_path = /obj/item/ammo_casing/c45/practice
	materials = list(MATERIAL_STEEL = 75)

/datum/design/item/weaponfab/c45/flash
	name = "Flash .45 Bullet"
	id = "c45f"
	build_path = /obj/item/ammo_casing/c45/flash
	materials = list(MATERIAL_STEEL = 60)

/datum/design/item/weaponfab/c10mm
	name = "10mm Bullet"
	id = "a10mm"
	build_path = /obj/item/ammo_casing/c10mm
	materials = list(MATERIAL_STEEL = 75)

/datum/design/item/weaponfab/shotgun
	name = "Shotgun Slug"
	id = "slug"
	build_path = /obj/item/ammo_casing/shotgun
	materials = list(MATERIAL_STEEL = 360)

/datum/design/item/weaponfab/shotgun/pellet
	name = "Shotgun Shell"
	id = "shell"
	build_path = /obj/item/ammo_casing/shotgun/pellet
	materials = list(MATERIAL_STEEL = 360)

/datum/design/item/weaponfab/shotgun/rubber
	name = "Rubber Shotgun Shell"
	id = "shellr"
	build_path = /obj/item/ammo_casing/shotgun/rubber
	materials = list(MATERIAL_PLASTIC = 180)

/datum/design/item/weaponfab/shotgun/blank
	name = "Blank Shotgun Shell"
	id = "shellb"
	build_path = /obj/item/ammo_casing/shotgun/blank
	materials = list(MATERIAL_STEEL = 90)

/datum/design/item/weaponfab/shotgun/practice
	name = "Practice Shotgun Shell"
	id = "shellp"
	build_path = /obj/item/ammo_casing/shotgun/practice
	materials = list(MATERIAL_STEEL = 90)

/datum/design/item/weaponfab/shotgun/beanbag
	name = "Beanbag Shotgun Shell"
	id = "shellbb"
	build_path = /obj/item/ammo_casing/shotgun/beanbag
	materials = list(MATERIAL_STEEL = 180)

/datum/design/item/weaponfab/shotgun/stunshell
	name = "Stun Shell"
	id = "stunshell"
	build_path = /obj/item/ammo_casing/shotgun/stunshell
	materials = list(MATERIAL_STEEL = 360, MATERIAL_GLASS = 720)

/datum/design/item/weaponfab/c556
	name = "5.56mm Bullet"
	id = "c556"
	build_path = /obj/item/ammo_casing/c556
	materials = list(MATERIAL_STEEL = 90)

/datum/design/item/weaponfab/c762
	name = "7.76mm Bullet"
	id = "c762"
	build_path = /obj/item/ammo_casing/c762
	materials = list(MATERIAL_STEEL = 90)

/datum/design/item/weaponfab/c762/practice
	name = "Practice 7.76mm Bullet"
	id = "c762p"
	build_path = /obj/item/ammo_casing/c762/practice
	materials = list(MATERIAL_STEEL = 90)

/datum/design/item/weaponfab/cap
	name = "Popgun Cap"
	id = "cap"
	build_path = /obj/item/ammo_casing/cap
	materials = list(MATERIAL_PLASTIC = 50)

/datum/design/item/weaponfab/flechette
	name = "4mm Flechette Rounds"
	id = "4mmflechette"
	build_path = /obj/item/ammo_casing/flechette
	materials = list(MATERIAL_TUNGSTEN = 90)

//Magazines

/datum/design/item/weaponfab/magazines/
	category = "Magazines"
	materials = list(MATERIAL_STEEL = 0.75 SHEETS)
	time = 10

/datum/design/item/weaponfab/magazines/empty
	time = 2
	materials = list(MATERIAL_STEEL = 0.25 SHEETS)

/datum/design/item/weaponfab/magazines/empty/speedloader/c22lr
	name = ".22lr Speedloader (empty)"
	build_path = /obj/item/ammo_magazine/speedloader/c22lr/empty
/datum/design/item/weaponfab/magazines/speedloader/c22lr
	name = ".22lr Speedloader"
	build_path = /obj/item/ammo_magazine/speedloader/c22lr

/datum/design/item/weaponfab/magazines/empty/c357
	name = ".357 Speedloader (empty)"
	build_path = /obj/item/ammo_magazine/speedloader/c357/empty
/datum/design/item/weaponfab/magazines/c357
	name = ".357 Speedloader"
	build_path = /obj/item/ammo_magazine/speedloader/c357


/datum/design/item/weaponfab/magazines/empty/c38
	name = ".38 Speedloader (empty)"
	build_path = /obj/item/ammo_magazine/speedloader/c38/empty
/datum/design/item/weaponfab/magazines/c38
	name = ".38 Speedloader"
	build_path = /obj/item/ammo_magazine/speedloader/c38


/datum/design/item/weaponfab/magazines/empty/c44
	name = ".44 Speedloader (empty)"
	build_path = /obj/item/ammo_magazine/speedloader/c44/empty
/datum/design/item/weaponfab/magazines/c44
	name = ".44 Speedloader"
	build_path = /obj/item/ammo_magazine/speedloader/c44


/datum/design/item/weaponfab/magazines/empty/c50
	name = ".50 Speedloader (empty)"
	build_path = /obj/item/ammo_magazine/speedloader/c50/empty
/datum/design/item/weaponfab/magazines/c50
	name = ".50 Speedloader"
	build_path = /obj/item/ammo_magazine/speedloader/c50
	materials = list(MATERIAL_STEEL = 1 SHEET)

/datum/design/item/weaponfab/magazines/empty/c45
	name = "Standard 10 rounds, .45 magazine(empty)"
	build_path = /obj/item/ammo_magazine/box/c45/empty
/datum/design/item/weaponfab/magazines/c45
	name = "Standard 10 rounds, .45 magazine"
	build_path = /obj/item/ammo_magazine/box/c45

/datum/design/item/weaponfab/magazines/empty/c45_15
	name = "Standard 15 rounds, .45 magazine(empty)"
	build_path = /obj/item/ammo_magazine/box/c45/_15/empty
/datum/design/item/weaponfab/magazines/c45_15
	name = "Standard 15 rounds, .45 magazine"
	build_path = /obj/item/ammo_magazine/box/c45/_15

/datum/design/item/weaponfab/magazines/empty/c45_20
	name = "Standard 20 rounds, .45 magazine(empty)"
	build_path = /obj/item/ammo_magazine/box/c45/_20/empty
/datum/design/item/weaponfab/magazines/c45_20
	name = "Standard 20 rounds, .45 magazine"
	build_path = /obj/item/ammo_magazine/box/c45/_20

/datum/design/item/weaponfab/magazines/empty/m1911
	name = "M1911 Magazine (empty)"
	build_path = /obj/item/ammo_magazine/box/m1911/empty
/datum/design/item/weaponfab/magazines/m1911
	name = "M1911 Magazine"
	build_path = /obj/item/ammo_magazine/box/m1911

/datum/design/item/weaponfab/magazines/empty/usp
	name = "USP .45 Pistol Magazine (empty)"
	build_path = /obj/item/ammo_magazine/box/usp/empty
/datum/design/item/weaponfab/magazines/usp
	name = "USP .45 Pistol Magazine"
	build_path = /obj/item/ammo_magazine/box/usp


/datum/design/item/weaponfab/magazines/empty/c45uzi
	name = ".45 UZI SMG, 16 rounds stick magazine (empty)"
	build_path = /obj/item/ammo_magazine/box/c45uzi/empty
/datum/design/item/weaponfab/magazines/c45uzi
	name = ".45 UZI SMG, 16 rounds stick magazine"
	build_path = /obj/item/ammo_magazine/box/c45uzi

/datum/design/item/weaponfab/magazines/empty/mc9mm
	name = "Standard 9mm, 8 rounds magazine (empty)"
	build_path = /obj/item/ammo_magazine/box/c9mm/empty
/datum/design/item/weaponfab/magazines/mc9mm
	name = "Standard 9mm, 8 rounds magazine"
	build_path = /obj/item/ammo_magazine/box/c9mm

/datum/design/item/weaponfab/magazines/empty/c9mm_20
	name = "Standard 9mm, 20 rounds magazine(empty)"
	build_path = /obj/item/ammo_magazine/box/c9mm/_20/empty
/datum/design/item/weaponfab/magazines/c9mm_20
	name = "Standard 9mm, 20 rounds magazine"
	build_path = /obj/item/ammo_magazine/box/c9mm/_20

/datum/design/item/weaponfab/magazines/empty/lap39mm
	name = "LAP3 9mm Pistol Magazine (empty)"
	build_path = /obj/item/ammo_magazine/box/lap3/empty
/datum/design/item/weaponfab/magazines/lap39mm
	name = "LAP3 9mm Pistol Magazine"
	build_path = /obj/item/ammo_magazine/box/lap3

/datum/design/item/weaponfab/magazines/empty/b92fs
	name = "92fs Pistol Magazine (empty)"
	build_path = /obj/item/ammo_magazine/box/b92fs/empty
/datum/design/item/weaponfab/magazines/box/b92fs
	name = "92fs Pistol Magazine"
	build_path = /obj/item/ammo_magazine/box/b92fs

/datum/design/item/weaponfab/magazines/empty/bhp
	name = "HP-35 Pistol Magazine (empty)"
	build_path = /obj/item/ammo_magazine/box/bhp/empty
/datum/design/item/weaponfab/magazines/bhp
	name = "HP-35 Pistol Magazine"
	build_path = /obj/item/ammo_magazine/box/bhp

/datum/design/item/weaponfab/magazines/empty/p08
	name = "P.08 Pistol Magazine (empty)"
	build_path = /obj/item/ammo_magazine/box/p08/empty
/datum/design/item/weaponfab/magazines/p08
	name = "P.08 Pistol Magazine"
	build_path = /obj/item/ammo_magazine/box/p08

/datum/design/item/weaponfab/magazines/empty/wt550
	name = "WT550 Magazine (empty)"
	build_path = /obj/item/ammo_magazine/box/wt550/empty
/datum/design/item/weaponfab/magazines/wt550
	name = "WT550 Magazine Magazine"
	build_path = /obj/item/ammo_magazine/box/wt550


/datum/design/item/weaponfab/magazines/empty/c10mm
	name = "10mm Magazine (empty)"
	build_path = /obj/item/ammo_magazine/box/c45/empty
/datum/design/item/weaponfab/magazines/c10mm
	name = "10mm Magazine"
	build_path = /obj/item/ammo_magazine/box/c45

/datum/design/item/weaponfab/magazines/empty/c44
	name = ".44 Magazine (empty)"
	build_path = /obj/item/ammo_magazine/box/c44/empty
/datum/design/item/weaponfab/magazines/c44
	name = ".44 Magazine"
	build_path = /obj/item/ammo_magazine/box/c44
	materials = list(MATERIAL_STEEL = 1.25 SHEET)

//For now apparently the gun using this disapeared...
// /datum/design/item/weaponfab/magazines/empty/c50
// 	name = ".50 Magazine (empty)"
// 	build_path = /obj/item/ammo_magazine/box/c50/empty
// /datum/design/item/weaponfab/magazines/c50
// 	name = ".50 Magazine"
// 	build_path = /obj/item/ammo_magazine/box/c50
// 	materials = list(MATERIAL_STEEL = 1.25 SHEET)

/datum/design/item/weaponfab/magazines/empty/c762
	name = "Standard 7.62mm, 15 rounds magazine (empty)"
	build_path = /obj/item/ammo_magazine/box/c762/empty
/datum/design/item/weaponfab/magazines/c762
	name = "Standard 7.62mm, 15 rounds magazine"
	build_path = /obj/item/ammo_magazine/box/c762
	materials = list(MATERIAL_STEEL = 1.25 SHEET)

/datum/design/item/weaponfab/magazines/empty/c556
	name = "Standard 5.56mm, 20 rounds magazine(empty)"
	build_path = /obj/item/ammo_magazine/box/c556/empty
/datum/design/item/weaponfab/magazines/c556
	name = "Standard 5.56mm, 20 rounds magazine"
	build_path = /obj/item/ammo_magazine/box/c556
	materials = list(MATERIAL_STEEL = 1.25 SHEET)

/datum/design/item/weaponfab/magazines/empty/proto_smg
	name = "Flechette SMG Magazine (empty)"
	build_path = /obj/item/ammo_magazine/box/proto_smg/empty
/datum/design/item/weaponfab/magazines/proto_smg
	name = "Flechette SMG Magazine"
	build_path = /obj/item/ammo_magazine/box/proto_smg

/datum/design/item/weaponfab/magazines/empty/clip762
	name = "7.62mm 5 rounds Clip (empty)"
	build_path = /obj/item/ammo_magazine/clip/c762/empty
/datum/design/item/weaponfab/magazines/clip762
	name = "7.62mm rounds Clip"
	build_path = /obj/item/ammo_magazine/clip/c762
	materials = list(MATERIAL_STEEL = 1.25 SHEET)

/datum/design/item/weaponfab/magazines/empty/clip9mm
	name = "9mm, 9 rounds Clip (empty)"
	build_path = /obj/item/ammo_magazine/clip/c9mm/empty
/datum/design/item/weaponfab/magazines/clip9mm
	name = "9mm, 9 rounds Clip"
	build_path = /obj/item/ammo_magazine/clip/c9mm
	materials = list(MATERIAL_STEEL = 1.25 SHEET)

// Ammo Boxes

/datum/design/item/weaponfab/ammobox
	category = "Ammo Boxes"

/datum/design/item/weaponfab/ammobox/ammobox
	time = 20
	name = "Ammo Box"
	id = "ammobox"
	build_path = /obj/item/weapon/storage/ammobox
	materials = list(MATERIAL_STEEL = 10000)

/datum/design/item/weaponfab/ammobox/ammobox/big
	time = 40
	name = "Big Ammo Box"
	id = "bigammobox"
	build_path = /obj/item/weapon/storage/ammobox/big
	materials = list(MATERIAL_STEEL = 30000)

/datum/design/item/weaponfab/ammobox/ammotbox
	time = 10
	name = "Ammo Transport Box"
	id = "ammotbox"
	build_path = /obj/item/weapon/storage/ammotbox
	materials = list(MATERIAL_STEEL = 5000)
