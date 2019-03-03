/obj/machinery/fabricator/weapon_fabricator
	// Things that must be adjusted for each fabricator
	name = "Weapon Fabricator" // Self-explanatory
	desc = "A machine used for the production of a variety of weapons and ammo" // Self-explanatory
	circuit = /obj/item/weapon/circuitboard/fabricator/weaponfab // Circuit for the machine. These, as well as their designs, should be defined in fabricator_circuits.dm
	build_type = WEAPONFAB // The identifer for what gets built in what fabricator. A new one *MUST* be defined in _defines/research.dm for each fabricator.
						 					 // More than one can be assigned per design, however, if you want something to be able to be built in more than one fabricator eg. Power Cells

////////////////////////////////////////////////////
//////////////////////DESIGNS///////////////////////
////////////////////////////////////////////////////


/datum/design/item/weaponfab
	build_type = WEAPONFAB 			   // This must match the build_type of the fabricator(s)
	category = "Weapons"	 			   // The design will appear under this in the UI. Each design must have a category, or it will not display properly.

	time = 10						   // Time in seconds for the item to be produced - This changes based off the components used in the fabricator



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

/datum/design/item/weaponfab/weapons/guns/pistol // tier 0
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_GOLD = 1.5 SHEETS, MATERIAL_COPPER = 1.5 SHEETS)
	build_path = /obj/item/weapon/gun/projectile/sec

/datum/design/item/weaponfab/weapons/guns/colt/officer // tier 1 RESKIN of pistol
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_GOLD = 1.5 SHEETS, MATERIAL_COPPER = 1.5 SHEETS)
	build_path = /obj/item/weapon/gun/projectile/colt/officer
	research = "pistol_1"
/datum/design/item/weaponfab/weapons/guns/colt/detective // tier 1 RESKIN of pistol
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_GOLD = 1.5 SHEETS, MATERIAL_COPPER = 1.5 SHEETS)
	build_path = /obj/item/weapon/gun/projectile/colt/detective
	research = "pistol_1"

/datum/design/item/weaponfab/weapons/guns/pistol/holdout // tier 1
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_GOLD = 1.3 SHEETS, MATERIAL_COPPER = 1.3 SHEETS)
	build_path = /obj/item/weapon/gun/projectile/pistol
	research = "pistol_1"
/datum/design/item/weaponfab/weapons/guns/revolver // tier 1
	materials = list(MATERIAL_STEEL = 6 SHEETS, MATERIAL_GOLD = 3 SHEETS, MATERIAL_COPPER = 2.5 SHEETS)
	build_path = /obj/item/weapon/gun/projectile/revolver
	research = "pistol_1"
/datum/design/item/weaponfab/weapons/guns/shotgun/doublebarrel // tier 1.5
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_WOOD = 4 SHEETS, MATERIAL_GOLD = 3.5 SHEET, MATERIAL_COPPER = 3 SHEET)
	build_path = /obj/item/weapon/gun/projectile/shotgun/doublebarrel
	research = "shotgun_1"
/datum/design/item/weaponfab/weapons/guns/shotgun/pump // tier 2
	materials = list(MATERIAL_STEEL = 8 SHEETS, MATERIAL_GOLD = 4 SHEETS, MATERIAL_DIAMOND = 1 SHEETS)
	build_path = /obj/item/weapon/gun/projectile/shotgun/pump
	research = "shotgun_2"
/datum/design/item/weaponfab/weapons/guns/automatic/uzi // tier 2.5
	materials = list(MATERIAL_STEEL = 5 SHEETS, MATERIAL_GOLD = 5 SHEETS, MATERIAL_DIAMOND = 2 SHEETS)
	build_path = /obj/item/weapon/gun/projectile/automatic/machine_pistol
	research = "autos_1"
/datum/design/item/weaponfab/weapons/guns/automatic/wt550 // tier 2.5
	materials = list(MATERIAL_STEEL = 7 SHEETS, MATERIAL_GOLD = 7 SHEETS, MATERIAL_DIAMOND = 4 SHEETS)
	build_path = /obj/item/weapon/gun/projectile/automatic/wt550
	research = "autos_1"
/datum/design/item/weaponfab/weapons/guns/shotgun/combat // tier 3
	materials = list(MATERIAL_STEEL = 10 SHEETS, MATERIAL_GOLD = 8 SHEETS, MATERIAL_DIAMOND = 4 SHEETS)
	build_path = /obj/item/weapon/gun/projectile/shotgun/doublebarrel
	research = "shotgun_3"
/datum/design/item/weaponfab/weapons/guns/automatic/c20r // tier 3.5
	materials = list(MATERIAL_PLASTEEL = 8 SHEETS, MATERIAL_GOLD = 8 SHEETS, MATERIAL_DIAMOND = 5 SHEETS, MATERIAL_PHORON = 2 SHEETS)
	build_path = /obj/item/weapon/gun/projectile/automatic/c20r
	research = "autos_2"
/datum/design/item/weaponfab/weapons/guns/automatic/revolver/mateba // tier 3.5
	materials = list(MATERIAL_PLASTEEL = 6 SHEETS, MATERIAL_GOLD = 5 SHEETS, MATERIAL_DIAMOND = 4 SHEETS, MATERIAL_PHORON = 1 SHEETS)
	build_path = /obj/item/weapon/gun/projectile/revolver/mateba
	research = "pistol_1"
/datum/design/item/weaponfab/weapons/guns/automatic/sts35 // tier 4
	materials = list(MATERIAL_PLASTEEL = 12 SHEETS, MATERIAL_GOLD = 10 SHEETS, MATERIAL_DIAMOND = 8 SHEETS, MATERIAL_PHORON = 4 SHEETS)
	build_path = /obj/item/weapon/gun/projectile/automatic/sts35
	research = "autos_3"
/datum/design/item/weaponfab/weapons/guns/automatic/heavysniper // tier 4
	materials = list(MATERIAL_PLASTEEL = 10 SHEETS, MATERIAL_GOLD = 8 SHEETS, MATERIAL_DIAMOND = 3 SHEETS, MATERIAL_PHORON = 11 SHEETS)
	build_path = /obj/item/weapon/gun/projectile/heavysniper
	research = "antimaterial"


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




// END ENERGY WEAPONS



// MELEE WEAPONS

/datum/design/item/weaponfab/weapons/tacknife // tier 0
	build_path = /obj/item/weapon/material/hatchet/tacknife
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


























//Ammunition
/datum/design/item/weaponfab/ammo
	category = "Ammunition"
	req_tech = list(TECH_MATERIAL = 1, TECH_COMBAT = 1)
	time = 1
/datum/design/item/weaponfab/a357
	name = ".357 Bullet"
	id = "a357"
	build_path = /obj/item/ammo_casing/a357
	materials = list(MATERIAL_STEEL = 210)

/datum/design/item/weaponfab/a50
	name = ".50 Bullet"
	id = "a50"
	build_path = /obj/item/ammo_casing/a50
	materials = list(MATERIAL_STEEL = 260)

/datum/design/item/weaponfab/a75
	name = "20mm Bullet"
	id = "75"
	build_path = /obj/item/ammo_casing/a75
	materials = list(MATERIAL_STEEL = 320)

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

/datum/design/item/weaponfab/a10mm
	name = "10mm Bullet"
	id = "a10mm"
	build_path = /obj/item/ammo_casing/a10mm
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

/datum/design/item/weaponfab/a556
	name = "5.56mm Bullet"
	id = "a556"
	build_path = /obj/item/ammo_casing/a556
	materials = list(MATERIAL_STEEL = 90)

/datum/design/item/weaponfab/a762
	name = "7.76mm Bullet"
	id = "a762"
	build_path = /obj/item/ammo_casing/a762
	materials = list(MATERIAL_STEEL = 90)

/datum/design/item/weaponfab/a762/practice
	name = "Practice 7.76mm Bullet"
	id = "a762p"
	build_path = /obj/item/ammo_casing/a762/practice
	materials = list(MATERIAL_STEEL = 90)

/datum/design/item/weaponfab/cap
	name = "Popgun Cap"
	id = "cap"
	build_path = /obj/item/ammo_casing/cap
	materials = list(MATERIAL_PLASTIC = 50)

//Magazines

/datum/design/item/weaponfab/magazines/
	category = "Magazines"
	materials = list(MATERIAL_STEEL = 0.75 SHEETS)
	time = 10

/datum/design/item/weaponfab/magazines/empty
	time = 2
	materials = list(MATERIAL_STEEL = 0.25 SHEETS)


/datum/design/item/weaponfab/magazines/empty/a357
	name = ".357 Speedloader (empty)"
	build_path = /obj/item/ammo_magazine/a357/empty

/datum/design/item/weaponfab/magazines/a357
	name = ".357 Speedloader"
	build_path = /obj/item/ammo_magazine/a357/empty


/datum/design/item/weaponfab/magazines/empty/c38
	name = ".38 Speedloader (empty)"
	build_path = /obj/item/ammo_magazine/c38/empty

/datum/design/item/weaponfab/magazines/c38
	name = ".38 Speedloader"
	build_path = /obj/item/ammo_magazine/c38


/datum/design/item/weaponfab/magazines/empty/c44
	name = ".44 Speedloader (empty)"
	build_path = /obj/item/ammo_magazine/c44/empty

/datum/design/item/weaponfab/magazines/c44
	name = ".44 Speedloader"
	build_path = /obj/item/ammo_magazine/c44


/datum/design/item/weaponfab/magazines/empty/c50
	name = ".50 Speedloader (empty)"
	build_path = /obj/item/ammo_magazine/c50/empty

/datum/design/item/weaponfab/magazines/c50
	name = ".50 Speedloader"
	build_path = /obj/item/ammo_magazine/c50
	materials = list(MATERIAL_STEEL = 1 SHEET)

/datum/design/item/weaponfab/magazines/empty/c45
	name = ".45 Magazine (empty)"
	build_path = /obj/item/ammo_magazine/c45m/empty

/datum/design/item/weaponfab/magazines/c45
	name = ".45 Magazine"
	build_path = /obj/item/ammo_magazine/c45m

/** UNUSED
/datum/design/item/weaponfab/magazines/empty/c45uzi
	name = ".45 SMG Magazine (empty)"
	build_path = /obj/item/ammo_magazine/c45uzi/empty
**/
/datum/design/item/weaponfab/magazines/empty/mc9mm
	name = "9mm Magazine (empty)"
	build_path = /obj/item/ammo_magazine/mc9mm/empty

/datum/design/item/weaponfab/magazines/mc9mm
	name = "9mm Magazine"
	build_path = /obj/item/ammo_magazine/mc9mm


/datum/design/item/weaponfab/magazines/empty/mc9mmt
	name = "9mm Topmount Magazine (empty)"
	build_path = /obj/item/ammo_magazine/mc9mmt/empty

/datum/design/item/weaponfab/magazines/mc9mmt
	name = "9mm Topmount Magazine"
	build_path = /obj/item/ammo_magazine/mc9mmt



/datum/design/item/weaponfab/magazines/empty/a10mm
	name = "10mm Magazine (empty)"
	build_path = /obj/item/ammo_magazine/a10mm/empty

/datum/design/item/weaponfab/magazines/a10mm
	name = "10mm Magazine"
	build_path = /obj/item/ammo_magazine/a10mm


/datum/design/item/weaponfab/magazines/empty/a50
	name = ".50 Magazine (empty)"
	build_path = /obj/item/ammo_magazine/a50/empty

/datum/design/item/weaponfab/magazines/a50
	name = ".50 Magazine"
	build_path = /obj/item/ammo_magazine/a50
	materials = list(MATERIAL_STEEL = 1.25 SHEET)

/datum/design/item/weaponfab/magazines/empty/a762
	name = "7.62 Magazine (empty)"
	build_path = /obj/item/ammo_magazine/a762/empty

/datum/design/item/weaponfab/magazines/a762
	name = "7.62 Magazine"
	build_path = /obj/item/ammo_magazine/a762/
	materials = list(MATERIAL_STEEL = 1.25 SHEET)

/datum/design/item/weaponfab/magazines/empty/a75
	name = "20mm Magazine (empty)"
	build_path = /obj/item/ammo_magazine/a75/empty

/datum/design/item/weaponfab/magazines/a75
	name = "20mm Magazine"
	build_path = /obj/item/ammo_magazine/a75
	materials = list(MATERIAL_STEEL = 1.25 SHEET)

/datum/design/item/weaponfab/magazines/empty/c556
	name = "5.56 Magazine (empty)"
	build_path = /obj/item/ammo_magazine/c556/empty

/datum/design/item/weaponfab/magazines/c556
	name = "5.56 Magazine"
	build_path = /obj/item/ammo_magazine/c556
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
