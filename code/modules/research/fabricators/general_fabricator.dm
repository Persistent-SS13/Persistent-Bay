/obj/machinery/fabricator/general_fabricator
	// Things that must be adjusted for each fabricator
	name = "General Fabricator" // Self-explanatory
	desc = "A general purpose fabricator that can produce a variety of simple equipment." // Self-explanatory
	circuit = /obj/item/weapon/circuitboard/fabricator/genfab // Circuit for the machine. These, as well as their designs, should be defined in fabricator_circuits.dm
	build_type = GENERALFAB // The identifer for what gets built in what fabricator. A new one *MUST* be defined in _defines/research.dm for each fabricator.
						  // More than one can be assigned per design, however, if you want something to be able to be built in more than one fabricator eg. Power Cells
	metal_load_anim = TRUE				// Determines if a sheet loading animation will be applied when loading metals. If you're using a non-standard icon and don't
										// want to sprite a new loading animation as well, set this to FALSE.

	has_reagents = FALSE				// Defaults to FALSE, but added here for explanation. If this is set to true, than you require designs to use reagents
										// in addition to any material costs.

////////////////////////////////////////////////////
//////////////////////DESIGNS///////////////////////
////////////////////////////////////////////////////

/datum/design/item/genfab
	build_type = GENERALFAB 			   // This must match the build_type of the fabricator(s)
	category = "Misc"	 			   // The design will appear under this in the UI. Each design must have a category, or it will not display properly.

	time = 10						   // Time in seconds for the item to be produced - This changes based off the components used in the fabricator


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CONTAINERS
/datum/design/item/genfab/container
	category = "Containers"
	materials = list(MATERIAL_GLASS = 0.1 SHEET)
/datum/design/item/genfab/container/sci


//////////////////////////////////////////////////////////////////////////////////////////////////

/datum/design/item/genfab/container/sci/spraybottle
	build_path = /obj/item/weapon/reagent_containers/spray

/datum/design/item/genfab/container/sci/chem_disp_cartridge
	build_path = /obj/item/weapon/reagent_containers/chem_disp_cartridge


/datum/design/item/genfab/container/sci/bucket
	build_path = /obj/item/weapon/reagent_containers/glass/bucket

/datum/design/item/genfab/container/sci/jar
	build_path = /obj/item/glass_jar

/datum/design/item/genfab/container/sci/beaker
	build_path = /obj/item/weapon/reagent_containers/glass/beaker

/datum/design/item/genfab/container/sci/beaker_large
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/large

/datum/design/item/genfab/container/sci/vial
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/vial

/datum/design/item/genfab/container/sci/pillbottle
	build_path = /obj/item/weapon/storage/pill_bottle

/datum/design/item/genfab/container/sci/syringe
	build_path = /obj/item/weapon/reagent_containers/syringe

/datum/design/item/genfab/container/beerkeg
	build_path = /obj/structure/reagent_dispensers/beerkeg/empty
	materials = list(MATERIAL_STEEL = 0.25 SHEET)

/datum/design/item/genfab/container/sci/dropper
	build_path = /obj/item/weapon/reagent_containers/dropper

/datum/design/item/genfab/container/pitcher
	build_path = /obj/item/weapon/reagent_containers/food/drinks/pitcher

/datum/design/item/genfab/container/carafe
	build_path = /obj/item/weapon/reagent_containers/food/drinks/glass2/carafe

/datum/design/item/genfab/container/coffeecup
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup

/datum/design/item/genfab/container/coffeecup/black
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup/black

/datum/design/item/genfab/container/coffeecup/green
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup/green

/datum/design/item/genfab/container/coffeecup/heart
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup/heart

/datum/design/item/genfab/container/coffeecup/metal
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup/metal

/datum/design/item/genfab/container/coffeecup/rainbow
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup/rainbow

/datum/design/item/genfab/container/coffeecup/NT
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup/NT

/datum/design/item/genfab/container/coffeecup/STC
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup/STC

/datum/design/item/genfab/container/coffeecup/SCG
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup/SCG

/datum/design/item/genfab/container/coffeecup/one
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup/one

/datum/design/item/genfab/container/coffeecup/pawn
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup/pawn

/datum/design/item/genfab/container/coffeecup/britcup
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup/britcup

/datum/design/item/genfab/container/coffeecup/tall
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup/tall

/datum/design/item/genfab/container/coffeecup/diona
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup/diona


/datum/design/item/genfab/container/drinkingglass
	build_path = /obj/item/weapon/reagent_containers/food/drinks/glass2/square

/datum/design/item/genfab/container/drinkingglass/rocks
	build_path = /obj/item/weapon/reagent_containers/food/drinks/glass2/rocks

/datum/design/item/genfab/container/drinkingglass/shake
	build_path = /obj/item/weapon/reagent_containers/food/drinks/glass2/shake

/datum/design/item/genfab/container/drinkingglass/cocktail
	build_path = /obj/item/weapon/reagent_containers/food/drinks/glass2/cocktail

/datum/design/item/genfab/container/drinkingglass/shot
	build_path = /obj/item/weapon/reagent_containers/food/drinks/glass2/shot

/datum/design/item/genfab/container/drinkingglass/pint
	build_path = /obj/item/weapon/reagent_containers/food/drinks/glass2/pint

/datum/design/item/genfab/container/drinkingglass/mug
	build_path = /obj/item/weapon/reagent_containers/food/drinks/glass2/mug

/datum/design/item/genfab/container/drinkingglass/wine
	build_path = /obj/item/weapon/reagent_containers/food/drinks/glass2/wine

/datum/design/item/genfab/container/drinkingglass/shaker
	build_path = /obj/item/weapon/reagent_containers/food/drinks/shaker

/datum/design/item/genfab/container/drinkingglass/teapot
	build_path = /obj/item/weapon/reagent_containers/food/drinks/teapot

/datum/design/item/genfab/container/drinkingglass/pitcher
	build_path = /obj/item/weapon/reagent_containers/food/drinks/pitcher

/datum/design/item/genfab/container/drinkingglass/flask
	build_path = /obj/item/weapon/reagent_containers/food/drinks/flask
	materials = list(MATERIAL_STEEL = 0.2 SHEET)
/datum/design/item/genfab/container/drinkingglass/flask/shiny
	build_path = /obj/item/weapon/reagent_containers/food/drinks/flask/shiny


/datum/design/item/genfab/container/drinkingglass/flask/lithium
	build_path = /obj/item/weapon/reagent_containers/food/drinks/flask/lithium


/datum/design/item/genfab/container/drinkingglass/flask/detflask
	build_path = /obj/item/weapon/reagent_containers/food/drinks/flask/detflask

/datum/design/item/genfab/container/drinkingglass/flask/barflask
	build_path = /obj/item/weapon/reagent_containers/food/drinks/flask/barflask

/datum/design/item/genfab/container/drinkingglass/flask/vacuumflask
	build_path = /obj/item/weapon/reagent_containers/food/drinks/flask/vacuumflask

/datum/design/item/genfab/container/drinkingglass/flask/fitnessflask
	build_path = /obj/item/weapon/reagent_containers/food/drinks/glass2/fitnessflask

/datum/design/item/genfab/container/sci/beaker/noreact
	req_tech = list(TECH_MATERIAL = 2)
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_PHORON = 1 SHEET)
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/noreact

/datum/design/item/genfab/container/sci/beaker/bluespace
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 6)
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_PHORON = 2 SHEETS, MATERIAL_DIAMOND = 1 SHEET)
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/bluespace


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// MEDICAL EQUIPMENT

/datum/design/item/genfab/meditools
	category = "Medical Equipment"

/datum/design/item/genfab/meditools/adv

//////////////////////////////////////////////////////////////////////////

/datum/design/item/genfab/meditools/penlight
	build_path = /obj/item/device/flashlight/pen
	materials = list(MATERIAL_STEEL = 0.1 SHEETS)
	
/datum/design/item/genfab/meditools/scalpel
	build_path = /obj/item/weapon/scalpel
	materials = list(MATERIAL_STEEL = 1 SHEETS)
/datum/design/item/genfab/meditools/circularsaw
	build_path = /obj/item/weapon/circular_saw
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_COPPER = 0.5 SHEETS)
/datum/design/item/genfab/meditools/bonesetter
	build_path = /obj/item/weapon/bonesetter
	materials = list(MATERIAL_STEEL = 1 SHEETS)

/datum/design/item/genfab/meditools/surgicaldrill
	build_path = /obj/item/weapon/surgicaldrill
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_COPPER = 0.5 SHEETS)
/datum/design/item/genfab/meditools/retractor
	build_path = /obj/item/weapon/retractor
	materials = list(MATERIAL_STEEL = 1 SHEETS)
/datum/design/item/genfab/meditools/cautery
	build_path = /obj/item/weapon/cautery
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_COPPER = 0.5 SHEETS)
/datum/design/item/genfab/meditools/hemostat
	build_path = /obj/item/weapon/hemostat
	materials = list(MATERIAL_STEEL = 1 SHEETS)
/datum/design/item/genfab/meditools/adv/syringe_cartridge
	build_path = /obj/item/weapon/syringe_cartridge
	materials = list(MATERIAL_STEEL = 0.1 SHEETS)
/datum/design/item/genfab/meditools/adv/syringe_gun
	build_path = /obj/item/weapon/gun/launcher/syringe
	materials = list(MATERIAL_STEEL = 5 SHEETS, MATERIAL_GLASS = 3 SHEETS, MATERIAL_COPPER = 2 SHEETS, MATERIAL_SILVER = 2 SHEETS)
	
/datum/design/item/genfab/meditools/adv/syringe_gun/rapid
	build_path = /obj/item/weapon/gun/launcher/syringe/rapid
	materials = list(MATERIAL_STEEL = 8 SHEETS, MATERIAL_GLASS = 5 SHEETS, MATERIAL_COPPER = 5 SHEETS, MATERIAL_SILVER = 5 SHEETS)

/**
/datum/design/item/genfab/meditools/adv/syringe_gun/disguised
	name = "disguised syringe gun"
	build_path = /obj/item/weapon/gun/launcher/syringe/disguised
**/



/datum/design/item/genfab/meditools/adv/FixOVein
	build_path = /obj/item/weapon/FixOVein
	materials = list(MATERIAL_CLOTH = 1 SHEETS, MATERIAL_GLASS = 1 SHEETS)
/datum/design/item/genfab/meditools/adv/bonegel
	build_path = /obj/item/weapon/bonegel
	materials = list(MATERIAL_CLOTH = 1 SHEETS, MATERIAL_GLASS = 1 SHEETS)


/datum/design/item/genfab/meditools/adv/hud
	materials = list(MATERIAL_STEEL = 0.25 SHEETS, MATERIAL_GLASS = 0.5 SHEETS)

/datum/design/item/genfab/meditools/adv/hud/AssembleDesignName()
	..()

/datum/design/item/genfab/meditools/adv/hud/AssembleDesignDesc()
	desc = "Allows for the construction of \a [item_name] HUD glasses."

/datum/design/item/genfab/meditools/adv/hud/health
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 3)
	build_path = /obj/item/clothing/glasses/hud/health


/datum/design/item/genfab/meditools/healthscanner
	build_path = /obj/item/device/healthanalyzer
	category = "Medical"
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_GLASS = 0.5 SHEETS, MATERIAL_COPPER = 0.5 SHEETS)
	
/datum/design/item/genfab/meditools/adv/robot_scanner
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 2, TECH_ENGINEERING = 3)
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_GLASS = 0.5 SHEETS, MATERIAL_COPPER = 0.5 SHEETS)
	build_path = /obj/item/device/robotanalyzer

/datum/design/item/genfab/meditools/adv/mass_spectrometer
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 2)
	build_path = /obj/item/device/mass_spectrometer
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_GLASS = 0.5 SHEETS, MATERIAL_COPPER = 0.5 SHEETS)
	
/datum/design/item/genfab/meditools/adv/adv_mass_spectrometer
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 4)
	build_path = /obj/item/device/mass_spectrometer/adv
	materials = list(MATERIAL_STEEL = 2 SHEET, MATERIAL_GLASS = 1 SHEETS, MATERIAL_SILVER = 1 SHEETS)
	
/datum/design/item/genfab/meditools/adv/reagent_scanner
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 2)
	build_path = /obj/item/device/reagent_scanner
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_GLASS = 0.5 SHEETS, MATERIAL_COPPER = 0.5 SHEETS)
	
//datum/design/item/genfab/meditools/adv/adv_reagent_scanner
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 4)
	build_path = /obj/item/device/reagent_scanner/adv
	materials = list(MATERIAL_STEEL = 2 SHEET, MATERIAL_GLASS = 1 SHEETS, MATERIAL_SILVER = 1 SHEETS)
	
/datum/design/item/genfab/meditools/adv/slime_scanner
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 2)
	build_path = /obj/item/device/slime_scanner
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_GLASS = 0.5 SHEETS, MATERIAL_COPPER = 0.5 SHEETS)
	
/datum/design/item/genfab/meditools/adv/scalpel_laser1
	name = "Basic Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks basic and could be improved."
	req_tech = list(TECH_BIO = 2, TECH_MATERIAL = 2, TECH_MAGNET = 2)
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_GLASS = 2 SHEETS, MATERIAL_SILVER = 0.5 SHEET)
	build_path = /obj/item/weapon/scalpel/laser1

/datum/design/item/genfab/meditools/adv/scalpel_laser2
	name = "Improved Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks somewhat advanced."
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 4, TECH_MAGNET = 4)
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_GLASS = 3 SHEETS, MATERIAL_SILVER = 1 SHEETS)
	build_path = /obj/item/weapon/scalpel/laser2

/datum/design/item/genfab/meditools/adv/scalpel_laser3
	name = "Advanced Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks to be the pinnacle of precision energy cutlery!"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 6, TECH_MAGNET = 5)
	materials = list(MATERIAL_STEEL = 6 SHEETS, MATERIAL_GLASS = 5 SHEETS, MATERIAL_SILVER = 3 SHEETS, MATERIAL_DIAMOND = 1 SHEET)
	build_path = /obj/item/weapon/scalpel/laser3

/datum/design/item/genfab/meditools/adv/scalpel_manager
	name = "Incision Management System"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 7, TECH_MAGNET = 5, TECH_DATA = 4)
	materials = list (MATERIAL_STEEL = 8 SHEET, MATERIAL_GLASS = 6 SHEET, MATERIAL_SILVER = 5 SHEET, MATERIAL_DIAMOND = 2 SHEET, MATERIAL_PHORON = 1 SHEET)
	build_path = /obj/item/weapon/scalpel/manager

/datum/design/item/genfab/meditools/adv/implant
	materials = list(MATERIAL_STEEL = 0.5 SHEET, MATERIAL_GLASS = 0.25 SHEET)

/datum/design/item/genfab/meditools/adv/implant/AssembleDesignName()
	..()
	name = "Implantable biocircuit design ([item_name])"

/datum/design/item/genfab/meditools/adv/item/implant/chemical
	name = "chemical release"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3)
	build_path = /obj/item/weapon/implantcase/chem

/datum/design/item/genfab/meditools/adv/item/implant/freedom
	name = "anti restraint"
	req_tech = list(TECH_ILLEGAL = 2, TECH_BIO = 3)
	build_path = /obj/item/weapon/implantcase/freedom

/datum/design/item/genfab/meditools/adv/defib
	name = "auto-resuscitator"
	req_tech = list(TECH_BIO = 5, TECH_ENGINEERING = 3, TECH_POWER = 4)
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_GLASS = 3 SHEETS, MATERIAL_GOLD = 2 SHEETS, MATERIAL_SILVER = 1 SHEET)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/weapon/defibrillator

/datum/design/item/genfab/meditools/adv/defib_compact
	name = "compact auto-resuscitator"
	req_tech = list(TECH_BIO = 5, TECH_ENGINEERING = 5, TECH_POWER = 6)
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_GLASS = 3 SHEETS, MATERIAL_GOLD = 3 SHEETS, MATERIAL_SILVER = 3 SHEETS, MATERIAL_PHORON = 2 SHEETS)
	chemicals = list(/datum/reagent/acid = 80)
	build_path = /obj/item/weapon/defibrillator/compact

/datum/design/item/genfab/meditools/lmi
	name = "Lace-machine interface"
	id = "lmi"
	req_tech = list(TECH_DATA = 2, TECH_BIO = 3)
	materials = list(MATERIAL_STEEL = 0.5 SHEET, MATERIAL_GLASS = 0.5 SHEET)
	build_path = /obj/item/device/lmi

/datum/design/item/genfab/meditools/adv/lmi_radio
	name = "Radio-enabled lace-machine interface"
	id = "lmi_radio"
	req_tech = list(TECH_DATA = 2, TECH_BIO = 4)
	materials = list(MATERIAL_STEEL = 2 SHEET, MATERIAL_GLASS = 1 SHEET, MATERIAL_COPPER = 1 SHEET)
	build_path = /obj/item/device/lmi/radio_enabled

/datum/design/item/genfab/meditools/stethoscope
	name = "Stethoscope"
	desc = "An outdated medical apparatus for listening to the sounds of the human body. It also makes you look like you know what you're doing."
	req_tech = list(TECH_BIO = 1)
	materials = list(MATERIAL_STEEL = 0.5 SHEET)
	build_path = /obj/item/clothing/accessory/stethoscope


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// WEAPONS

/datum/design/item/genfab/weapons
	category = "Weapons"

/datum/design/item/genfab/weapons/guns
	category = "Guns"


////////////////////////////////////////////////////////////////////


/datum/design/item/genfab/weapons/guns/stunrevolver
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(MATERIAL_STEEL = 5 SHEETS, MATERIAL_SILVER = 3 SHEETS, MATERIAL_GOLD = 2 SHEETS)
	build_path = /obj/item/weapon/gun/energy/stunrevolver

/datum/design/item/genfab/weapons/guns/laser_carbine
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 5, TECH_POWER = 5)
	materials = list(MATERIAL_STEEL = 8 SHEETS, MATERIAL_GLASS = 2 SHEETS, MATERIAL_SILVER = 2 SHEETS, MATERIAL_GOLD = 2 SHEETS, MATERIAL_DIAMOND = 3 SHEETS, MATERIAL_PHORON = 3 SHEETS)
	build_path = /obj/item/weapon/gun/energy/laser

/datum/design/item/genfab/weapons/guns/nuclear_gun
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 5, TECH_POWER = 5)
	materials = list(MATERIAL_STEEL = 8 SHEETS, MATERIAL_GLASS = 2 SHEETS, MATERIAL_SILVER = 2 SHEETS, MATERIAL_GOLD = 5 SHEETS, MATERIAL_URANIUM = 10 SHEETS, MATERIAL_PHORON = 10 SHEETS)
	build_path = /obj/item/weapon/gun/energy/gun/nuclear

/datum/design/item/genfab/weapons/guns/lasercannon
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	materials = list(MATERIAL_STEEL = 8 SHEETS, MATERIAL_GLASS = 2 SHEETS, MATERIAL_SILVER = 2 SHEETS, MATERIAL_DIAMOND = 5 SHEETS, MATERIAL_URANIUM = 3 SHEETS, MATERIAL_PHORON = 10 SHEETS)
	build_path = /obj/item/weapon/gun/energy/lasercannon

/datum/design/item/genfab/weapons/guns/phoronpistol
	req_tech = list(TECH_COMBAT = 5, TECH_PHORON = 4)
	materials = list(MATERIAL_STEEL = 1.5 SHEETS, MATERIAL_GLASS = 1 SHEET, MATERIAL_URANIUM = 2 SHEETS, MATERIAL_PHORON = 4 SHEETS)
	build_path = /obj/item/weapon/gun/energy/toxgun

/datum/design/item/genfab/weapons/guns/decloner
	req_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 7, TECH_BIO = 5, TECH_POWER = 6)
	materials = list(MATERIAL_STEEL = 8 SHEETS, MATERIAL_GOLD = 6 SHEETS,MATERIAL_URANIUM = 12 SHEETS)
	chemicals = list(/datum/reagent/mutagen = 40)
	build_path = /obj/item/weapon/gun/energy/decloner

/datum/design/item/genfab/weapons/guns/wt550
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3)
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_SILVER = 2 SHEETS, MATERIAL_DIAMOND = 2 SHEETS)
	build_path = /obj/item/weapon/gun/projectile/automatic/wt550

/datum/design/item/genfab/weapons/chemsprayer
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_GLASS = 3 SHEETS, MATERIAL_SILVER = 2 SHEETS)
	build_path = /obj/item/weapon/reagent_containers/spray/chemsprayer


/datum/design/item/genfab/weapons/guns/temp_gun
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_POWER = 3, TECH_MAGNET = 2)
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_GLASS = 3 SHEETS, MATERIAL_SILVER = 5 SHEETS, MATERIAL_PHORON = 1 SHEET)
	build_path = /obj/item/weapon/gun/energy/temperature

/datum/design/item/genfab/weapons/large_grenade
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_SILVER = 1 SHEET)
	build_path = /obj/item/weapon/grenade/chem_grenade/large

/datum/design/item/genfab/weapons/flora_gun
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_POWER = 3)
	materials = list(MATERIAL_STEEL = 4 SHEET, MATERIAL_GLASS = 2 SHEETS, MATERIAL_URANIUM = 2 SHEETS)
	build_path = /obj/item/weapon/gun/energy/floragun

/datum/design/item/genfab/weapons/launcher/grenade
	build_path = /obj/item/weapon/gun/launcher/grenade
	materials = list(MATERIAL_STEEL = 8 SHEETS, MATERIAL_GLASS = 2 SHEETS, MATERIAL_SILVER = 2 SHEETS, MATERIAL_GOLD = 2 SHEETS, MATERIAL_DIAMOND = 4 SHEETS, MATERIAL_PHORON = 0.5 SHEET)

/datum/design/item/genfab/weapons/buckler
	build_path = /obj/item/weapon/shield/buckler
	
/datum/design/item/genfab/weapons/energyshield
	build_path = /obj/item/weapon/shield/energy
	materials = list(MATERIAL_STEEL = 5 SHEETS, MATERIAL_GLASS = 3 SHEETS, MATERIAL_GOLD = 4 SHEETS, MATERIAL_DIAMOND = 2 SHEETS, MATERIAL_PHORON = 0.5 SHEET)
	
/datum/design/item/genfab/weapons/woodstaff
	build_path = /obj/item/weapon/material/stick
	materials = list(MATERIAL_WOOD = 1 SHEETS)

/datum/design/item/genfab/weapons/shuriken
	build_path = /obj/item/weapon/material/star
	materials = list(MATERIAL_STEEL = 0.5 SHEETS)

/datum/design/item/genfab/weapons/hook
	build_path = /obj/item/weapon/material/knife/hook
	materials = list(MATERIAL_STEEL = 1 SHEETS)
/datum/design/item/genfab/weapons/ritualdagger
	build_path = /obj/item/weapon/material/knife/ritual
	materials = list(MATERIAL_STEEL = 1 SHEETS)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// COMPUTER EQUIPMENT

/datum/design/item/genfab/computer
	category = "Computer Equipment"

/datum/design/item/genfab/computer/adv


///////////////////////////////////////////////////////////////////////////////
// Hard drives
/datum/design/item/genfab/computer/disk/normal
	name = "basic hard drive"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_COPPER = 0.5 SHEET)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/

/datum/design/item/genfab/computer/adv/disk/advanced
	name = "advanced hard drive"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 1.5 SHEETS, MATERIAL_COPPER = 1 SHEET)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/advanced

/datum/design/item/genfab/computer/adv/disk/super
	name = "super hard drive"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_COPPER = 1.5 SHEETS, MATERIAL_SILVER = 0.5 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/super

/datum/design/item/genfab/computer/adv/disk/cluster
	name = "cluster hard drive"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_COPPER = 2 SHEETS, MATERIAL_SILVER = 2 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/cluster

/datum/design/item/genfab/computer/adv/disk/small
	name = "small hard drive"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 0.5 SHEET, MATERIAL_COPPER = 0.75 SHEET)
	
	build_path = /obj/item/weapon/computer_hardware/hard_drive/small

/datum/design/item/genfab/computer/adv/disk/micro
	name = "micro hard drive"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	materials = list(MATERIAL_STEEL = 0.25 SHEET, MATERIAL_COPPER = 1 SHEET)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/micro

// Card slot
/datum/design/item/genfab/computer/adv/cardslot
	name = "RFID card slot"
	req_tech = list(TECH_DATA = 2)
	materials = list(MATERIAL_STEEL = 0.25 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/card_slot


// Nano printer
/datum/design/item/genfab/computer/adv/nanoprinter
	name = "nano printer"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 0.25 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/nano_printer

// Tesla Link
/datum/design/item/genfab/computer/adv/teslalink
	name = "tesla link"
	req_tech = list(TECH_DATA = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 0.5 SHEETS, MATERIAL_COPPER = 0.25 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/tesla_link

// Batteries
/datum/design/item/genfab/computer/adv/battery/normal
	name = "standard battery module"
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	materials = list(MATERIAL_STEEL = 0.25 SHEETS, MATERIAL_COPPER = 0.25 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/battery_module

/datum/design/item/genfab/computer/adv/battery/advanced
	name = "advanced battery module"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 0.5 SHEETS, MATERIAL_COPPER = 0.5 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/battery_module/advanced

/datum/design/item/genfab/computer/adv/battery/super
	name = "super battery module"
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	materials = list(MATERIAL_STEEL = 1 SHEETS, MATERIAL_COPPER = 1 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/battery_module/super

/datum/design/item/genfab/computer/adv/battery/ultra
	name = "ultra battery module"
	req_tech = list(TECH_POWER = 5, TECH_ENGINEERING = 4)
	materials = list(MATERIAL_STEEL = 1.5 SHEETS, MATERIAL_COPPER = 1.5 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/battery_module/ultra
	
/datum/design/item/genfab/computer/battery/nano
	name = "nano battery module"
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	materials = list(MATERIAL_STEEL = 0.1 SHEETS, MATERIAL_COPPER = 0.5 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/battery_module/nano

/datum/design/item/genfab/computer/adv/micro
	name = "micro battery module"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 0.05 SHEETS, MATERIAL_COPPER = 0.75 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/battery_module/micro

/datum/design/item/genfab/computer/adv/dna_scanner
	name = "DNA scanner port"
	req_tech = list(TECH_DATA = 2)
	materials = list(MATERIAL_STEEL = 0.5 SHEETS, MATERIAL_COPPER = 0.25 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/dna_scanner


/datum/design/item/genfab/computer/adv/pda
	name = "PDA design"
	desc = "Cheaper than whiny non-digital assistants."
	req_tech = list(TECH_ENGINEERING = 2, TECH_POWER = 3)
	materials = list(MATERIAL_STEEL = 1.5 SHEETS, MATERIAL_GLASS = 1 SHEET, MATERIAL_COPPER = 0.5 SHEETS)
	build_path = /obj/item/device/pda

// Cartridges
/**
/datum/design/item/genfab/computer/adv/pda_cartridge
	req_tech = list(TECH_ENGINEERING = 2, TECH_POWER = 3)
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50)

/datum/design/item/genfab/computer/adv/pda_cartridge/AssembleDesignName()
	..()
	name = "PDA accessory ([item_name])"

/datum/design/item/genfab/computer/adv/cart_basic
	id = "cart_basic"
	build_path = /obj/item/weapon/cartridge
	sort_string = "VBAAA"

/datum/design/item/genfab/computer/adv/engineering
	id = "cart_engineering"
	build_path = /obj/item/weapon/cartridge/engineering
	sort_string = "VBAAB"

/datum/design/item/genfab/computer/adv/atmos
	id = "cart_atmos"
	build_path = /obj/item/weapon/cartridge/atmos
	sort_string = "VBAAC"

/datum/design/item/genfab/computer/adv/medical
	id = "cart_medical"
	build_path = /obj/item/weapon/cartridge/medical
	sort_string = "VBAAD"

/datum/design/item/genfab/computer/adv/chemistry
	id = "cart_chemistry"
	build_path = /obj/item/weapon/cartridge/chemistry
	sort_string = "VBAAE"

/datum/design/item/genfab/computer/adv/security
	id = "cart_security"
	build_path = /obj/item/weapon/cartridge/security
	sort_string = "VBAAF"

/datum/design/item/genfab/computer/adv/janitor
	id = "cart_janitor"
	build_path = /obj/item/weapon/cartridge/janitor
	sort_string = "VBAAG"

/datum/design/item/genfab/computer/adv/science
	id = "cart_science"
	build_path = /obj/item/weapon/cartridge/signal/science
	sort_string = "VBAAH"

/datum/design/item/genfab/computer/adv/quartermaster
	id = "cart_quartermaster"
	build_path = /obj/item/weapon/cartridge/quartermaster
	sort_string = "VBAAI"

/datum/design/item/genfab/computer/adv/hop
	id = "cart_hop"
	build_path = /obj/item/weapon/cartridge/hop
	sort_string = "VBAAJ"

/datum/design/item/genfab/computer/adv/hos
	id = "cart_hos"
	build_path = /obj/item/weapon/cartridge/hos
	sort_string = "VBAAK"

/datum/design/item/genfab/computer/adv/ce
	id = "cart_ce"
	build_path = /obj/item/weapon/cartridge/ce
	sort_string = "VBAAL"

/datum/design/item/genfab/computer/adv/cmo
	id = "cart_cmo"
	build_path = /obj/item/weapon/cartridge/cmo
	sort_string = "VBAAM"

/datum/design/item/genfab/computer/adv/rd
	id = "cart_rd"
	build_path = /obj/item/weapon/cartridge/rd
	sort_string = "VBAAN"

/datum/design/item/genfab/computer/adv/captain
	id = "cart_captain"
	build_path = /obj/item/weapon/cartridge/captain
	sort_string = "VBAAO"
**/

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Communication Equipment

/datum/design/item/genfab/communication
	category = "Comms & Paperwork"


////////////////////////////////////////////////////////////////////

/datum/design/item/genfab/communication/radio_headset
	name = "radio headset"
	build_path = /obj/item/device/radio/headset
	materials = list(MATERIAL_STEEL = 0.5 SHEETS)

/datum/design/item/genfab/communication/radio_bounced
	name = "shortwave radio"
	build_path = /obj/item/device/radio/off
	materials = list(MATERIAL_STEEL = 0.5 SHEETS)

/datum/design/item/genfab/communication/taperecorder
	name = "tape recorder"
	build_path = /obj/item/device/taperecorder/empty
	materials = list(MATERIAL_STEEL = 1 SHEETS)

/datum/design/item/genfab/communication/camera_film
	name = "camera film"
	build_path = /obj/item/device/camera_film
	materials = list(MATERIAL_COPPER = 0.25 SHEETS)

/datum/design/item/genfab/communication/tape
	name = "tape recorder tape"
	build_path = /obj/item/device/tape
	materials = list(MATERIAL_STEEL = 0.5 SHEETS)

/datum/design/item/genfab/communication/camera
	name = "photo camera"
	build_path = /obj/item/device/camera/empty
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_COPPER = 0.25 SHEETS, MATERIAL_SILVER = 0.25 SHEETS)

/datum/design/item/genfab/communication/blackpen
	name = "black ink pen"
	build_path = /obj/item/weapon/pen

/datum/design/item/genfab/communication/bluepen
	name = "blue ink pen"
	build_path = /obj/item/weapon/pen/blue

/datum/design/item/genfab/communication/redpen
	name = "red ink pen"
	build_path = /obj/item/weapon/pen/red

/datum/design/item/genfab/communication/multipen
	name = "multi-color ink pen"
	build_path = /obj/item/weapon/pen/multi


/datum/design/item/genfab/communication/clipboard
	name = "clipboard"
	build_path = /obj/item/weapon/clipboard
	materials = list(MATERIAL_WOOD = 0.05 SHEET)
/datum/design/item/genfab/communication/folder
	name = "grey folder"
	build_path = /obj/item/weapon/folder
	materials = list(MATERIAL_WOOD = 0.05 SHEET)
/datum/design/item/genfab/communication/folder/blue
	name = "blue folder"
	build_path = /obj/item/weapon/folder/blue
	materials = list(MATERIAL_WOOD = 0.05 SHEET)
/datum/design/item/genfab/communication/folder/red
	name = "red folder"
	build_path = /obj/item/weapon/folder/red
	materials = list(MATERIAL_WOOD = 0.05 SHEET)
/datum/design/item/genfab/communication/folder/yellow
	name = "yellow folder"
	build_path = /obj/item/weapon/folder/yellow
	materials = list(MATERIAL_WOOD = 0.05 SHEET)
/datum/design/item/genfab/communication/paper
	name = "sheet of paper"
	build_path = /obj/item/weapon/paper
	materials = list(MATERIAL_WOOD = 0.05 SHEET) // 20 papers per sheet
/datum/design/item/genfab/communication/paper/carbon
	name = "sheet of carbon paper"
	build_path = /obj/item/weapon/paper/carbon
	materials = list(MATERIAL_WOOD = 0.1 SHEET) // 10 papers per sheet

/datum/design/item/genfab/communication/hand_labeler
	name = "hand labeler"
	build_path = /obj/item/weapon/hand_labeler

/datum/design/item/genfab/communication/paper_bin
	name = "paper bin"
	build_path = /obj/item/weapon/paper_bin
	materials = list(MATERIAL_STEEL = 1 SHEET)







/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// EVA Equipment
/datum/design/item/genfab/eva
	category = "EVA Equipment"

/datum/design/item/genfab/eva/adv

///////////////////////////////////////////////////////////////

/datum/design/item/genfab/eva/tank
	name = "air tank"
	build_path = /obj/item/weapon/tank/oxygen/empty
	materials = list(MATERIAL_STEEL = 1 SHEETS)
	
/datum/design/item/genfab/eva/adv/tank_double
	name = "emergency air tank"
	build_path = /obj/item/weapon/tank/emergency/oxygen/engi/empty
	materials = list(MATERIAL_STEEL = 2.5 SHEETS)
	
/datum/design/item/genfab/eva/adv/jetpack
	name = "Blue Jetpack"	//Just a fancy name for a jetpack, heh
	req_tech = list(TECH_ENGINEERING = 4)
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_GOLD = 3 SHEETS, MATERIAL_SILVER = 2 SHEETS)
	build_path = /obj/item/weapon/tank/jetpack

/datum/design/item/genfab/eva/adv/jetpack/black
	name = "Blue Jetpack"	//Just a fancy name for a jetpack, heh
	req_tech = list(TECH_ENGINEERING = 4)
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_GOLD = 3 SHEETS, MATERIAL_SILVER = 2 SHEETS)
	build_path = /obj/item/weapon/tank/jetpack/carbondioxide


/datum/design/item/genfab/eva/adv/beacon
	name = "Bluespace tracking beacon design"
	req_tech = list(TECH_BLUESPACE = 1)
	materials = list (MATERIAL_STEEL = 1 SHEET, MATERIAL_COPPER = 0.5 SHEETS)
	build_path = /obj/item/device/radio/beacon

/datum/design/item/genfab/eva/gps
	name = "Triangulating device design"
	req_tech = list(TECH_MATERIAL = 2, TECH_DATA = 2, TECH_BLUESPACE = 2)
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_COPPER = 0.5 SHEETS)
	build_path = /obj/item/device/gps

/datum/design/item/genfab/eva/adv/beacon_locator
	name = "Beacon tracking pinpointer"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 2, TECH_BLUESPACE = 3)
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_COPPER = 0.5 SHEETS)
	build_path = /obj/item/device/beacon_locator



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Furniture
/datum/design/item/genfab/furniture
	category = "Furniture"

/////////////////////////////////////

/datum/design/item/genfab/furniture/ashtray_glass
	name = "glass ashtray"
	build_path = /obj/item/weapon/material/ashtray/glass
	materials = list(MATERIAL_GLASS = 0.25 SHEET)
/datum/design/item/genfab/furniture/ashtray_bronze
	name = "metal ashtray"
	build_path = /obj/item/weapon/material/ashtray/bronze
	materials = list(MATERIAL_STEEL = 0.25 SHEET)
/datum/design/item/genfab/furniture/ashtray_plastic
	name = "plastic ashtray"
	build_path = /obj/item/weapon/material/ashtray/plastic
	materials = list(MATERIAL_PLASTIC = 0.25 SHEET)

/datum/design/item/genfab/furniture/desklamp
	name = "desk lamp"
	build_path = /obj/item/device/flashlight/lamp
	materials = list(MATERIAL_STEEL = 0.25 SHEET)
	
/datum/design/item/genfab/furniture/floor_light
	name = "floor light"
	build_path = /obj/machinery/floor_light
	materials = list(MATERIAL_GLASS = 1 SHEET)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Botany Tools

/datum/design/item/genfab/botanytools
	category = "Botany Tools"


/////////////////////////////////////////////////////////////////////////////////////

/datum/design/item/genfab/botanytools/hatchet
	name = "hatchet"
	build_path = /obj/item/weapon/material/hatchet
	materials = list(MATERIAL_STEEL = 1 SHEET)
/datum/design/item/genfab/botanytools/minihoe
	name = "mini hoe"
	build_path = /obj/item/weapon/material/minihoe
	materials = list(MATERIAL_STEEL = 0.75 SHEET)
/datum/design/item/genfab/botanytools/plantbgone
	name = "Plant-B-Gone (empty)"
	build_path = /obj/item/weapon/reagent_containers/spray/plantbgone
	materials = list(MATERIAL_GLASS = 0.1 SHEET)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Culinary Tools

/datum/design/item/genfab/culinarytools
	category = "Culinary Tools"

/////////////////////////////////////////////////////////////////////////////////////

/datum/design/item/genfab/culinarytools/knife
	name = "kitchen knife"
	build_path = /obj/item/weapon/material/knife
	materials = list(MATERIAL_STEEL = 1 SHEET)
/datum/design/item/genfab/culinarytools/butch
	name = "butcher knife"
	build_path = /obj/item/weapon/material/knife/butch
	materials = list(MATERIAL_STEEL = 1.5 SHEET)
/datum/design/item/genfab/culinarytools/utensil_knife
	name = "dining knife"
	build_path = /obj/item/weapon/material/kitchen/utensil/knife
	materials = list(MATERIAL_STEEL = 0.1 SHEET)
/datum/design/item/genfab/culinarytools/utensil_fork
	name = "dining fork"
	build_path = /obj/item/weapon/material/kitchen/utensil/fork
	materials = list(MATERIAL_STEEL = 0.1 SHEET)
/datum/design/item/genfab/culinarytools/utensil_spoon
	name = "dining spoon"
	build_path = /obj/item/weapon/material/kitchen/utensil/spoon
	materials = list(MATERIAL_STEEL = 0.1 SHEET)

/datum/design/item/genfab/culinarytools/utensil_fork_plastic
	name = "plastic dining fork"
	build_path 	= /obj/item/weapon/material/kitchen/utensil/fork/plastic
	materials = list(MATERIAL_PLASTIC = 0.1 SHEET)
/datum/design/item/genfab/culinarytools/utensil_knife_plastic
	name = "plastic dining knife"
	build_path = /obj/item/weapon/material/kitchen/utensil/knife/plastic
	materials = list(MATERIAL_PLASTIC = 0.1 SHEET)
	
/datum/design/item/genfab/culinarytools/utensil_spoon_plastic
	name = "plastic dining spoon"
	build_path = /obj/item/weapon/material/kitchen/utensil/spoon/plastic
	materials = list(MATERIAL_PLASTIC = 0.1 SHEET)

/datum/design/item/genfab/culinarytools/tray
	name = "tray"
	build_path = /obj/item/weapon/tray
	materials = list(MATERIAL_STEEL = 0.25 SHEET)
	
/datum/design/item/genfab/culinarytools/rollingpin
	name = "rolling pin"
	build_path = /obj/item/weapon/material/kitchen/rollingpin
	materials = list(MATERIAL_WOOD = 0.25 SHEET)


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Consumer Goods

/datum/design/item/genfab/consumer
	category = "Consumer Goods"
	materials = list(MATERIAL_PLASTIC = 0.1 SHEETS)
/datum/design/item/genfab/consumer/toys
	category = "Toys"

/datum/design/item/genfab/consumer/games
	category = "Games"



////////////////////////////////////////////////////////////////////

/datum/design/item/genfab/consumer/lighter
	name = "cheap lighter"
	build_path = /obj/item/weapon/flame/lighter
	materials = list(MATERIAL_PLASTIC = 0.25 SHEETS)

/datum/design/item/genfab/consumer/labeler
	name = "hand labeler"
	build_path = /obj/item/weapon/hand_labeler

/datum/design/item/genfab/consumer/ecigcartridge
	name = "ecigarette cartridge"
	build_path = /obj/item/weapon/reagent_containers/ecig_cartridge/blank

/datum/design/item/genfab/consumer/ecig
	// We get it, you vape
	name = "ecigarette"
	build_path = /obj/item/clothing/mask/smokable/ecig/lathed

/datum/design/item/genfab/consumer/mop
	name = "mop"
	build_path = /obj/item/weapon/mop
	materials = list(MATERIAL_STEEL = 1 SHEETS)
/datum/design/item/genfab/consumer/lipstick
	name = "red lipstick"
	build_path = /obj/item/weapon/lipstick
	materials = list(MATERIAL_PLASTIC = 0.25 SHEETS)
/datum/design/item/genfab/consumer/lipstick/purple
	name = "purple lipstick"
	build_path = /obj/item/weapon/lipstick/purple

/datum/design/item/genfab/consumer/lipstick/jade
	name = "jade lipstick"
	build_path = /obj/item/weapon/lipstick/jade

/datum/design/item/genfab/consumer/lipstick/black
	name = "black lipstick"
	build_path = /obj/item/weapon/lipstick/black

/datum/design/item/genfab/consumer/comb
	name = "comb"
	build_path = /obj/item/weapon/haircomb
	materials = list(MATERIAL_PLASTIC = 0.25 SHEETS)
/datum/design/item/genfab/consumer/picket_sign
	name = "Picket sign"
	build_path = /obj/item/weapon/picket_sign
	materials = list(MATERIAL_WOOD = 0.25 SHEETS)

/datum/design/item/genfab/consumer/water_flower
	name = "water flower"
	build_path = /obj/item/weapon/reagent_containers/spray/waterflower
	materials = list(MATERIAL_PLASTIC = 0.25 SHEETS)

//toys

/datum/design/item/genfab/consumer/toys/doll
	materials = list(MATERIAL_CLOTH = 0.5 SHEETS, MATERIAL_PLASTIC = 0.1 SHEETS)
/datum/design/item/genfab/consumer/toys/doll/red_doll
	name = "red doll"
	build_path = /obj/item/toy/therapy_red

/datum/design/item/genfab/consumer/toys/doll/purple_doll
	name = "purple doll"
	build_path = /obj/item/toy/therapy_purple

/datum/design/item/genfab/consumer/toys/doll/blue_doll
	name = "blue doll"
	build_path = /obj/item/toy/therapy_blue

/datum/design/item/genfab/consumer/toys/doll/yellow_doll
	name = "yellow doll"
	build_path = /obj/item/toy/therapy_yellow

/datum/design/item/genfab/consumer/toys/doll/green_doll
	name = "green doll"
	build_path = /obj/item/toy/therapy_green

/datum/design/item/genfab/consumer/toys/water_balloon
	name = "water balloon"
	build_path = /obj/item/toy/water_balloon
	materials = list(MATERIAL_PLASTIC = 0.25 SHEETS)

/datum/design/item/genfab/consumer/toys/ntballoon
	name = "nanotrasen balloon"
	build_path = /obj/item/toy/balloon/nanotrasen
	materials = list(MATERIAL_PLASTIC = 0.25 SHEETS)

/datum/design/item/genfab/consumer/toys/blink
	name = "electronic blink toy game"
	build_path = /obj/item/toy/blink
	materials = list(MATERIAL_METAL = 0.25 SHEETS)

/datum/design/item/genfab/consumer/toys/spinningtoy
	name = "gravitational singularity toy"
	build_path = /obj/item/toy/spinningtoy
	materials = list(MATERIAL_METAL = 0.25 SHEETS, MATERIAL_CLOTH = 0.25 SHEETS)

/datum/design/item/genfab/consumer/toys/crossbow
	name = "foam dart crossbow"
	build_path = /obj/item/toy/crossbow
	materials = list(MATERIAL_METAL = 1 SHEETS)

/datum/design/item/genfab/consumer/toys/ammo/crossbow
	name = "foam dart"
	build_path = /obj/item/toy/ammo/crossbow
	materials = list(MATERIAL_METAL = 0.01 SHEETS)

/datum/design/item/genfab/consumer/toys/snappop
	name = "snap pop"
	build_path = /obj/item/toy/snappop
	materials = list(MATERIAL_METAL = 0.01 SHEETS)


/datum/design/item/genfab/consumer/games/cards
	name = "playing cards"
	build_path = /obj/item/weapon/deck/cards
	materials = list(MATERIAL_PLASTIC = 0.5 SHEETS)


/datum/design/item/genfab/consumer/games/tarot
	name = "playing cards"
	build_path = /obj/item/weapon/deck/tarot
	materials = list(MATERIAL_PLASTIC = 0.25 SHEETS)

/datum/design/item/genfab/consumer/games/board
	name = "checkerboard"
	build_path = /obj/item/weapon/board
	materials = list(MATERIAL_WOOD = 0.25 SHEETS)
/datum/design/item/genfab/consumer/games/checker
	name = "black checker"
	build_path = /obj/item/weapon/checker

/datum/design/item/genfab/consumer/games/redchecker
	name = "red checker"
	build_path = /obj/item/weapon/checker/red

/datum/design/item/genfab/consumer/games/pawn
	name = "black pawn"
	build_path = /obj/item/weapon/checker/pawn

/datum/design/item/genfab/consumer/games/redpawn
	name = "red pawn"
	build_path = /obj/item/weapon/checker/pawn/red

/datum/design/item/genfab/consumer/games/knight
	name = "black knight"
	build_path = /obj/item/weapon/checker/knight

/datum/design/item/genfab/consumer/games/redknight
	name = "red knight"
	build_path = /obj/item/weapon/checker/knight/red

/datum/design/item/genfab/consumer/games/bishop
	name = "black bishop"
	build_path = /obj/item/weapon/checker/bishop

/datum/design/item/genfab/consumer/games/redbishop
	name = "red bishop"
	build_path = /obj/item/weapon/checker/bishop/red

/datum/design/item/genfab/consumer/games/rook
	name = "black rook"
	build_path = /obj/item/weapon/checker/rook

/datum/design/item/genfab/consumer/games/redrook
	name = "red rook"
	build_path = /obj/item/weapon/checker/rook/red

/datum/design/item/genfab/consumer/games/queen
	name = "black queen"
	build_path = /obj/item/weapon/checker/queen

/datum/design/item/genfab/consumer/games/redqueen
	name = "red queen"
	build_path = /obj/item/weapon/checker/queen/red

/datum/design/item/genfab/consumer/games/king
	name = "black king"
	build_path = /obj/item/weapon/checker/king

/datum/design/item/genfab/consumer/games/redking
	name = "red king"
	build_path = /obj/item/weapon/checker/king/red

/datum/design/item/genfab/consumer/games/cardemon
	name = "cardemon booster pack"
	build_path = /obj/item/weapon/pack/cardemon
	materials = list(MATERIAL_PLASTIC = 0.25 SHEETS)
/datum/design/item/genfab/consumer/games/spaceball
	name = "spaceball booster pack"
	build_path = /obj/item/weapon/pack/spaceball
	materials = list(MATERIAL_PLASTIC = 0.25 SHEETS)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// SECURITY EQUIPMENT

/datum/design/item/genfab/sectools
	category = "Security Equipment"

/datum/design/item/genfab/sectools/adv

/////////////////////////////////////////////////////////////////////////////

/datum/design/item/genfab/sectools/handcuffs
	name = "handcuffs"
	build_path = /obj/item/weapon/handcuffs
	materials = list(MATERIAL_STEEL = 0.5 SHEET)
/datum/design/item/genfab/sectools/adv/hud
	materials = list(MATERIAL_STEEL = 0.1 SHEET, MATERIAL_GLASS = 0.1 SHEET)

/datum/design/item/genfab/sectools/adv/hud/AssembleDesignName()
	..()
	name = "HUD glasses prototype ([item_name])"

/datum/design/item/genfab/sectools/adv/hud/AssembleDesignDesc()
	desc = "Allows for the construction of \a [item_name] HUD glasses."




/datum/design/item/genfab/sectools/adv/hud/security
	name = "police scanner"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	build_path = /obj/item/clothing/glasses/hud/security

/datum/design/item/genfab/sectools/adv/pepperspray
	name = "pepperspray (empty)"
	build_path = /obj/item/weapon/reagent_containers/spray/pepper
	materials = list(MATERIAL_STEEL = 0.1 SHEET, MATERIAL_GLASS = 0.1 SHEET)
	
/datum/design/item/genfab/sectools/adv/riotshield
	name = "riot shield"
	build_path = /obj/item/weapon/shield/riot
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_GLASS = 2 SHEETS)


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//MINING EQUIPMENT
/datum/design/item/genfab/miningtools
	category = "Mining Equipment"

/datum/design/item/genfab/miningtools/adv

//////////////////////////////////////////////////////////////////////////////

/datum/design/item/genfab/miningtools/adv/jackhammer
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_GLASS = 0.5 SHEETS, MATERIAL_SILVER = 0.5 SHEETS)
	build_path = /obj/item/weapon/pickaxe/jackhammer

/datum/design/item/genfab/miningtools/pickaxe
	materials = list(MATERIAL_STEEL = 2 SHEETS)
	build_path = /obj/item/weapon/pickaxe

/datum/design/item/genfab/miningtools/hammer
	materials = list(MATERIAL_STEEL = 2 SHEETS)
	build_path = /obj/item/weapon/pickaxe/hammer

/datum/design/item/genfab/miningtools/flag/red
	materials = list(MATERIAL_CLOTH = 1 SHEETS)
	build_path = /obj/item/stack/flag/red

/datum/design/item/genfab/miningtools/flag/yellow
	materials = list(MATERIAL_CLOTH = 1 SHEETS)
	build_path = /obj/item/stack/flag/yellow

/datum/design/item/genfab/miningtools/flag/green
	materials = list(MATERIAL_CLOTH = 1 SHEETS)
	build_path = /obj/item/stack/flag/green

/datum/design/item/genfab/miningtools/flag/solgov
	materials = list(MATERIAL_CLOTH = 1 SHEETS)
	build_path = /obj/item/stack/flag/solgov




/datum/design/item/genfab/miningtools/adv/plasmacutter
	req_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 3, TECH_ENGINEERING = 3)
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_GLASS = 1 SHEETS, MATERIAL_GOLD = 1 SHEETS, MATERIAL_PHORON = 2 SHEETS)
	build_path = /obj/item/weapon/gun/energy/plasmacutter

/datum/design/item/genfab/miningtools/adv/drill
	req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 4)
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_GLASS = 2 SHEETS, MATERIAL_DIAMOND = 3 SHEETS)
	build_path = /obj/item/weapon/pickaxe/drill

/datum/design/item/genfab/miningtools/adv/jackhammer
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_GLASS = 1 SHEET)
	build_path = /obj/item/weapon/pickaxe/jackhammer


/datum/design/item/genfab/miningtools/adv/pick_diamond
	req_tech = list(TECH_MATERIAL = 6)
	materials = list(MATERIAL_DIAMOND = 2 SHEETS, MATERIAL_STEEL = 1 SHEET)
	build_path = /obj/item/weapon/pickaxe/diamond

/datum/design/item/genfab/miningtools/adv/drill_diamond
	req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 4)
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_GLASS = 2 SHEETS, MATERIAL_DIAMOND = 3 SHEETS)
	build_path = /obj/item/weapon/pickaxe/diamonddrill

/datum/design/item/genfab/miningtools/adv/mining_scanner
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 0.5 SHEETS,MATERIAL_GLASS = 0.5 SHEETS)
	build_path = /obj/item/weapon/mining_scanner

/datum/design/item/genfab/miningtools/adv/depth_scanner
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2, TECH_BLUESPACE = 2)
	materials = list(MATERIAL_STEEL = 0.5 SHEETS,MATERIAL_GLASS = 0.5 SHEETS)
	build_path = /obj/item/device/depth_scanner



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// SCIENCE EQUIPMENT

/datum/design/item/genfab/science
	category = "Science Equipment"

/datum/design/item/genfab/science/adv


/////////////////////////////////////////////

/datum/design/item/genfab/science/adv/ano_scanner
	name = "Alden-Saraspova counter"
	desc = "Aids in triangulation of exotic particles."
	req_tech = list(TECH_BLUESPACE = 3, TECH_MAGNET = 3)
	materials = list(MATERIAL_STEEL = 3 SHEETS,MATERIAL_GLASS = 2 SHEETS, MATERIAL_SILVER = 1 SHEET)
	build_path = /obj/item/device/ano_scanner

/**
/datum/design/item/genfab/science/adv/binaryencrypt
	name = "Binary encryption key"
	desc = "Allows for deciphering the binary channel on-the-fly."
	req_tech = list(TECH_ILLEGAL = 2)
	materials = list(MATERIAL_STEEL = 300, MATERIAL_GLASS = 300, MATERIAL_PHORON = 10000)
	build_path = /obj/item/device/encryptionkey/binary
**/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
