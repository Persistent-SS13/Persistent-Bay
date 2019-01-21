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

	time = 50						   // Time in seconds for the item to be produced - This changes based off the components used in the fabricator


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CONTAINERS
/datum/design/item/genfab/container
	category = "Containers"

/datum/design/item/genfab/container/sci


//////////////////////////////////////////////////////////////////////////////////////////////////



/datum/design/item/genfab/container/bucket
	name = "bucket"
	build_path = /obj/item/weapon/reagent_containers/glass/bucket

/datum/design/item/genfab/container/jar
	name = "jar"
	build_path = /obj/item/glass_jar

/datum/design/item/genfab/container/beaker
	name = "glass beaker"
	build_path = /obj/item/weapon/reagent_containers/glass/beaker
	category = "Medical"

/datum/design/item/genfab/container/beaker_large
	name = "large glass beaker"
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/large
	category = "Medical"

/datum/design/item/genfab/container/vial
	name = "glass vial"
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/vial
	category = "Medical"

/datum/design/item/genfab/container/pillbottle
	name = "pill bottle"
	build_path = /obj/item/weapon/storage/pill_bottle
	category = "Medical"

/datum/design/item/genfab/container/syringe
	name = "syringe"
	build_path = /obj/item/weapon/reagent_containers/syringe
	category = "Medical"

/datum/design/item/genfab/container/beerkeg
	name = "beer keg"
	build_path = /obj/structure/reagent_dispensers/beerkeg/empty
	category = "General"


/datum/design/item/genfab/container/glasses
	name = "prescription glasses"
	build_path = /obj/item/clothing/glasses/regular
	category = "Medical"

/datum/design/item/genfab/container/dropper
	name = "dropper"
	build_path = /obj/item/weapon/reagent_containers/dropper
	category = "Medical"

/datum/design/item/genfab/container/pitcher
	name = "pitcher"
	build_path = /obj/item/weapon/reagent_containers/food/drinks/pitcher
	category = "General"

/datum/design/item/genfab/container/carafe
	name = "carafe"
	build_path = /obj/item/weapon/reagent_containers/food/drinks/glass2/carafe
	category = "General"

/datum/design/item/genfab/container/coffeecup
	name = "coffee cup"
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup
	category = "General"
	New()
		..()
		var/obj/O = build_path
		name = initial(O.name) // generic recipes yay

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

/datum/design/item/genfab/container/drinkingglass
	name = "drinking glass"
	build_path = /obj/item/weapon/reagent_containers/food/drinks/glass2/square
	category = "General"
	New()
		..()
		var/obj/O = build_path
		name = initial(O.name) // generic recipes yay

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

/datum/design/item/genfab/container/sci/beaker/noreact
	name = "cryostasis beaker"
	desc = "A cryostasis beaker that allows for chemical storage without reactions. Can hold up to 50 units."
	id = "splitbeaker"
	req_tech = list(TECH_MATERIAL = 2)
	materials = list(MATERIAL_STEEL = 3000, MATERIAL_PHORON = 2000)
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/noreact
	sort_string = "MADAA"

/datum/design/item/genfab/container/sci/beaker/bluespace
	name = "bluespace beaker"
	desc = "A bluespace beaker, powered by experimental bluespace technology and Element Cuban combined with the Compound Pete. Can hold up to 300 units."
	id = "bluespacebeaker"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 6)
	materials = list(MATERIAL_STEEL = 3000, MATERIAL_PHORON = 4000, MATERIAL_DIAMOND = 2000)
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/bluespace
	sort_string = "MADAB"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// MEDICAL EQUIPMENT

/datum/design/item/genfab/meditools
	category = "Medical Equipment"

/datum/design/item/genfab/meditools/adv

//////////////////////////////////////////////////////////////////////////

/datum/design/item/genfab/meditools/penlight
	name = "penlight"
	build_path = /obj/item/device/flashlight/pen

/datum/design/item/genfab/meditools/scalpel
	name = "scalpel"
	build_path = /obj/item/weapon/scalpel
	category = "Medical"

/datum/design/item/genfab/meditools/circularsaw
	name = "circular saw"
	build_path = /obj/item/weapon/circular_saw
	category = "Medical"

/datum/design/item/genfab/meditools/surgicaldrill
	name = "surgical drill"
	build_path = /obj/item/weapon/surgicaldrill
	category = "Medical"

/datum/design/item/genfab/meditools/retractor
	name = "retractor"
	build_path = /obj/item/weapon/retractor
	category = "Medical"

/datum/design/item/genfab/meditools/cautery
	name = "cautery"
	build_path = /obj/item/weapon/cautery
	category = "Medical"

/datum/design/item/genfab/meditools/hemostat
	name = "hemostat"
	build_path = /obj/item/weapon/hemostat
	category = "Medical"


/datum/design/item/genfab/meditools/adv/hud
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50)

/datum/design/item/genfab/meditools/adv/hud/AssembleDesignName()
	..()
	name = "HUD glasses prototype ([item_name])"

/datum/design/item/genfab/meditools/adv/hud/AssembleDesignDesc()
	desc = "Allows for the construction of \a [item_name] HUD glasses."

/datum/design/item/genfab/meditools/adv/hud/health
	name = "health scanner"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 3)
	build_path = /obj/item/clothing/glasses/hud/health


/datum/design/item/genfab/meditools/healthscanner
	name = "health scanner"
	build_path = /obj/item/device/healthanalyzer
	category = "Medical"

/datum/design/item/genfab/meditools/adv/robot_scanner
	desc = "A hand-held scanner able to diagnose robotic injuries."
	id = "robot_scanner"
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 2, TECH_ENGINEERING = 3)
	materials = list(MATERIAL_STEEL = 500, MATERIAL_GLASS = 200)
	build_path = /obj/item/device/robotanalyzer
	sort_string = "MACFA"

/datum/design/item/genfab/meditools/adv/mass_spectrometer
	desc = "A device for analyzing chemicals in blood."
	id = "mass_spectrometer"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 2)
	build_path = /obj/item/device/mass_spectrometer
	sort_string = "MACAA"

/datum/design/item/genfab/meditools/adv/adv_mass_spectrometer
	desc = "A device for analyzing chemicals in blood and their quantities."
	id = "adv_mass_spectrometer"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 4)
	build_path = /obj/item/device/mass_spectrometer/adv
	sort_string = "MACAB"

/datum/design/item/genfab/meditools/adv/reagent_scanner
	desc = "A device for identifying chemicals."
	id = "reagent_scanner"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 2)
	build_path = /obj/item/device/reagent_scanner
	sort_string = "MACBA"

//datum/design/item/genfab/meditools/adv/adv_reagent_scanner
	desc = "A device for identifying chemicals and their proportions."
	id = "adv_reagent_scanner"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 4)
	build_path = /obj/item/device/reagent_scanner/adv
	sort_string = "MACBB"

/datum/design/item/genfab/meditools/adv/slime_scanner
	desc = "A device for scanning identified and unidentified lifeforms."
	id = "slime_scanner"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 2)
	build_path = /obj/item/device/slime_scanner
	sort_string = "MACBC"

/datum/design/item/genfab/meditools/adv/nanopaste
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	id = "nanopaste"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	materials = list(MATERIAL_STEEL = 7000, MATERIAL_GLASS = 7000)
	build_path = /obj/item/stack/nanopaste
	sort_string = "MBAAA"

/datum/design/item/genfab/meditools/adv/scalpel_laser1
	name = "Basic Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks basic and could be improved."
	id = "scalpel_laser1"
	req_tech = list(TECH_BIO = 2, TECH_MATERIAL = 2, TECH_MAGNET = 2)
	materials = list(MATERIAL_STEEL = 12500, MATERIAL_GLASS = 7500)
	build_path = /obj/item/weapon/scalpel/laser1
	sort_string = "MBBAA"

/datum/design/item/genfab/meditools/adv/scalpel_laser2
	name = "Improved Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks somewhat advanced."
	id = "scalpel_laser2"
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 4, TECH_MAGNET = 4)
	materials = list(MATERIAL_STEEL = 12500, MATERIAL_GLASS = 7500, MATERIAL_SILVER = 2500, MATERIAL_PHORON = 2000)
	build_path = /obj/item/weapon/scalpel/laser2
	sort_string = "MBBAB"

/datum/design/item/genfab/meditools/adv/scalpel_laser3
	name = "Advanced Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks to be the pinnacle of precision energy cutlery!"
	id = "scalpel_laser3"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 6, TECH_MAGNET = 5)
	materials = list(MATERIAL_STEEL = 12500, MATERIAL_GLASS = 7500, MATERIAL_SILVER = 4000, MATERIAL_GOLD = 3000, MATERIAL_PHORON = 4000)
	build_path = /obj/item/weapon/scalpel/laser3
	sort_string = "MBBAC"

/datum/design/item/genfab/meditools/adv/scalpel_manager
	name = "Incision Management System"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	id = "scalpel_manager"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 7, TECH_MAGNET = 5, TECH_DATA = 4)
	materials = list (MATERIAL_STEEL = 12500, MATERIAL_GLASS = 7500, MATERIAL_SILVER = 3000, MATERIAL_GOLD = 3000, MATERIAL_DIAMOND = 1000, MATERIAL_PHORON = 6000)
	build_path = /obj/item/weapon/scalpel/manager
	sort_string = "MBBAD"

/datum/design/item/genfab/meditools/adv/implant
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50)

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
	materials = list(MATERIAL_STEEL = 50000, MATERIAL_GLASS = 30000, MATERIAL_GOLD = 20000, MATERIAL_SILVER = 10000, MATERIAL_PHORON = 1000)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/weapon/defibrillator

/datum/design/item/genfab/meditools/adv/defib_compact
	name = "compact auto-resuscitator"
	req_tech = list(TECH_BIO = 5, TECH_ENGINEERING = 5, TECH_POWER = 6)
	materials = list(MATERIAL_STEEL = 30000, MATERIAL_GLASS = 20000, MATERIAL_GOLD = 15000, MATERIAL_SILVER = 10000, MATERIAL_PHORON = 8000)
	chemicals = list(/datum/reagent/acid = 80)
	build_path = /obj/item/weapon/defibrillator/compact

/datum/design/item/genfab/meditools/lmi
	name = "Lace-machine interface"
	id = "lmi"
	req_tech = list(TECH_DATA = 2, TECH_BIO = 3)
	materials = list(MATERIAL_STEEL = 1000, MATERIAL_GLASS = 500)
	build_path = /obj/item/device/lmi

/datum/design/item/genfab/meditools/adv/lmi_radio
	name = "Radio-enabled lace-machine interface"
	id = "lmi_radio"
	req_tech = list(TECH_DATA = 2, TECH_BIO = 4)
	materials = list(MATERIAL_STEEL = 1200, MATERIAL_GLASS = 500)
	build_path = /obj/item/device/lmi/radio_enabled

/datum/design/item/genfab/meditools/stethoscope
	name = "Stethoscope"
	desc = "An outdated medical apparatus for listening to the sounds of the human body. It also makes you look like you know what you're doing."
	id = "stethoscope"
	req_tech = list(TECH_BIO = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 1000)
	build_path = /obj/item/clothing/accessory/stethoscope


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// WEAPONS

/datum/design/item/genfab/weapons
	category = "Weapons"

/datum/design/item/genfab/weapons/guns
	category = "Guns"

////////////////////////////////////////////////////////////////////

/datum/design/item/genfab/weapons/syringegun_ammo
	name = "syringe gun cartridge"
	build_path = /obj/item/weapon/syringe_cartridge


/datum/design/item/genfab/weapons/guns/stunrevolver
	id = "stunrevolver"
	desc = "A non-lethal stun. Warning: Can cause cardiac arrest."
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(MATERIAL_STEEL = 4000, MATERIAL_SILVER = 2000, MATERIAL_GOLD = 1000)
	build_path = /obj/item/weapon/gun/energy/stunrevolver
	sort_string = "TAAAA"

/datum/design/item/genfab/weapons/guns/laser_carbine
	id = "laser_carbine"
	desc = "A laser weapon designed to kill."
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 5, TECH_POWER = 5)
	materials = list(MATERIAL_STEEL = 5000, MATERIAL_GLASS = 3000, MATERIAL_SILVER = 4000, MATERIAL_GOLD = 4000, MATERIAL_DIAMOND = 12000, MATERIAL_PHORON = 8000)
	build_path = /obj/item/weapon/gun/energy/laser
	sort_string = "TAAAB"
/*
/datum/design/item/weapon/nuclear_gun
	id = "nuclear_gun"
	desc = "Self-recharging energy weapon powered by a nuclear core."
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 5, TECH_POWER = 5)
	materials = list(MATERIAL_STEEL = 5000, MATERIAL_GLASS = 1000, MATERIAL_SILVER = 1000, MATERIAL_GOLD = 2000, MATERIAL_URANIUM = 10000, MATERIAL_PHORON = 6000)
	build_path = /obj/item/weapon/gun/energy/gun/nuclear
	sort_string = "TAAAB"
/datum/design/item/weapon/lasercannon
	desc = "The lasing medium of this prototype is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core."
	id = "lasercannon"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	materials = list(MATERIAL_STEEL = 10000, MATERIAL_GLASS = 1000, MATERIAL_SILVER = 2000, MATERIAL_DIAMOND = 6000, MATERIAL_PHORON = 6000)
	build_path = /obj/item/weapon/gun/energy/lasercannon
	sort_string = "TAAAC"
/datum/design/item/weapon/phoronpistol
	id = "ppistol"
	req_tech = list(TECH_COMBAT = 5, TECH_PHORON = 4)
	materials = list(MATERIAL_STEEL = 5000, MATERIAL_GLASS = 1000, MATERIAL_URANIUM = 1000, MATERIAL_PHORON = 6000)
	build_path = /obj/item/weapon/gun/energy/toxgun
	sort_string = "TAAAD"
*/
/datum/design/item/genfab/weapons/guns/decloner
	id = "decloner"
	req_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 7, TECH_BIO = 5, TECH_POWER = 6)
	materials = list(MATERIAL_GOLD = 5000,MATERIAL_URANIUM = 10000)
	chemicals = list(/datum/reagent/mutagen = 40)
	build_path = /obj/item/weapon/gun/energy/decloner
	sort_string = "TAAAE"

/datum/design/item/genfab/weapons/guns/wt550
	id = "wt-550"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3)
	materials = list(MATERIAL_STEEL = 8000, MATERIAL_SILVER = 2000, MATERIAL_DIAMOND = 1000, MATERIAL_PHORON = 4000)
	build_path = /obj/item/weapon/gun/projectile/automatic/wt550
	sort_string = "TAABA"
/*
/datum/design/item/weapon/smg
	id = "smg"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	materials = list(MATERIAL_STEEL = 8000, MATERIAL_SILVER = 2000, MATERIAL_DIAMOND = 1000)
	build_path = /obj/item/weapon/gun/projectile/automatic
	sort_string = "TAABA"
*/

/datum/design/item/genfab/weapons/chemsprayer
	desc = "An advanced chem spraying device."
	id = "chemsprayer"
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	materials = list(MATERIAL_STEEL = 5000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/weapon/reagent_containers/spray/chemsprayer
	sort_string = "TABAA"

/datum/design/item/genfab/weapons/guns/rapidsyringe
	id = "rapidsyringe"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	materials = list(MATERIAL_STEEL = 5000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/weapon/gun/launcher/syringe/rapid
	sort_string = "TABAB"

/datum/design/item/genfab/weapons/guns/temp_gun
	desc = "A gun that shoots high-powered glass-encased energy temperature bullets."
	id = "temp_gun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_POWER = 3, TECH_MAGNET = 2)
	materials = list(MATERIAL_STEEL = 5000, MATERIAL_GLASS = 500, MATERIAL_SILVER = 3000)
	build_path = /obj/item/weapon/gun/energy/temperature
	sort_string = "TABAC"

/datum/design/item/genfab/weapon/large_grenade
	id = "large_Grenade"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	materials = list(MATERIAL_STEEL = 3000)
	build_path = /obj/item/weapon/grenade/chem_grenade/large
	sort_string = "TACAA"

/datum/design/item/genfab/weapon/flora_gun
	id = "flora_gun"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_POWER = 3)
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_GLASS = 500, MATERIAL_URANIUM = 500)
	build_path = /obj/item/weapon/gun/energy/floragun
	sort_string = "TBAAA"

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
	materials = list(MATERIAL_STEEL = 400, MATERIAL_GLASS = 100)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/

/datum/design/item/genfab/computer/adv/disk/advanced
	name = "advanced hard drive"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 800, MATERIAL_GLASS = 200)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/advanced

/datum/design/item/genfab/computer/adv/disk/super
	name = "super hard drive"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	materials = list(MATERIAL_STEEL = 1600, MATERIAL_GLASS = 400)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/super

/datum/design/item/genfab/computer/adv/disk/cluster
	name = "cluster hard drive"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	materials = list(MATERIAL_STEEL = 3200, MATERIAL_GLASS = 800)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/cluster

/datum/design/item/genfab/computer/adv/disk/small
	name = "small hard drive"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 800, MATERIAL_GLASS = 200)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/small

/datum/design/item/genfab/computer/adv/disk/micro
	name = "micro hard drive"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	materials = list(MATERIAL_STEEL = 400, MATERIAL_GLASS = 100)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/micro

// Card slot
/datum/design/item/genfab/computer/adv/cardslot
	name = "RFID card slot"
	req_tech = list(TECH_DATA = 2)
	materials = list(MATERIAL_STEEL = 600)
	build_path = /obj/item/weapon/computer_hardware/card_slot


// Nano printer
/datum/design/item/genfab/computer/adv/nanoprinter
	name = "nano printer"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 600)
	build_path = /obj/item/weapon/computer_hardware/nano_printer

// Tesla Link
/datum/design/item/genfab/computer/adv/teslalink
	name = "tesla link"
	req_tech = list(TECH_DATA = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 2000)
	build_path = /obj/item/weapon/computer_hardware/tesla_link

// Batteries
/datum/design/item/genfab/computer/adv/battery/normal
	name = "standard battery module"
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	materials = list(MATERIAL_STEEL = 400)
	build_path = /obj/item/weapon/computer_hardware/battery_module

/datum/design/item/genfab/computer/adv/battery/advanced
	name = "advanced battery module"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 800)
	build_path = /obj/item/weapon/computer_hardware/battery_module/advanced

/datum/design/item/genfab/computer/adv/battery/super
	name = "super battery module"
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	materials = list(MATERIAL_STEEL = 1600)
	build_path = /obj/item/weapon/computer_hardware/battery_module/super

/datum/design/item/genfab/computer/adv/battery/ultra
	name = "ultra battery module"
	req_tech = list(TECH_POWER = 5, TECH_ENGINEERING = 4)
	materials = list(MATERIAL_STEEL = 3200)
	build_path = /obj/item/weapon/computer_hardware/battery_module/ultra

/datum/design/item/genfab/computer/battery/nano
	name = "nano battery module"
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	materials = list(MATERIAL_STEEL = 200)
	build_path = /obj/item/weapon/computer_hardware/battery_module/nano

/datum/design/item/genfab/computer/adv/micro
	name = "micro battery module"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 400)
	build_path = /obj/item/weapon/computer_hardware/battery_module/micro

/datum/design/item/genfab/computer/adv/logistic_processor
	name = "Advanced Logistic Processor"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 4)
	materials = list(MATERIAL_STEEL = 5000, MATERIAL_GLASS = 1000, MATERIAL_PHORON = 3000, MATERIAL_DIAMOND = 3000, MATERIAL_URANIUM = 3000)
	build_path = /obj/item/weapon/computer_hardware/logistic_processor

/datum/design/item/genfab/computer/adv/pda
	name = "PDA design"
	desc = "Cheaper than whiny non-digital assistants."
	id = "pda"
	req_tech = list(TECH_ENGINEERING = 2, TECH_POWER = 3)
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/device/pda
	sort_string = "VAAAA"

// Cartridges
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


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Communication Equipment

/datum/design/item/genfab/communication
	category = "Communication Equipment"


////////////////////////////////////////////////////////////////////

/datum/design/item/genfab/communication/radio_headset
	name = "radio headset"
	build_path = /obj/item/device/radio/headset

/datum/design/item/genfab/communication/radio_bounced
	name = "shortwave radio"
	build_path = /obj/item/device/radio/off

/datum/design/item/genfab/communication/taperecorder
	name = "tape recorder"
	build_path = /obj/item/device/taperecorder/empty
	category = "General"

/datum/design/item/genfab/communication/tape
	name = "tape recorder tape"
	build_path = /obj/item/device/tape
	category = "General"

/datum/design/item/genfab/communication/blackpen
	name = "black ink pen"
	build_path = /obj/item/weapon/pen
	category = "General"

/datum/design/item/genfab/communication/bluepen
	name = "blue ink pen"
	build_path = /obj/item/weapon/pen/blue
	category = "General"

/datum/design/item/genfab/communication/redpen
	name = "red ink pen"
	build_path = /obj/item/weapon/pen/red
	category = "General"


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

/datum/design/item/genfab/eva/adv/tank_double
	name = "emergency air tank"
	build_path = /obj/item/weapon/tank/emergency/oxygen/engi/empty

/datum/design/item/genfab/eva/adv/jetpack
	name = "Air Supply and Propulsion System"	//Just a fancy name for a jetpack, heh
	id = "jetpack"
	req_tech = list(TECH_ENGINEERING = 4)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 6000, MATERIAL_GOLD = 2000, MATERIAL_PHORON = 4000)
	build_path = /obj/item/weapon/tank/jetpack
	sort_string = "VBABC"

/datum/design/item/genfab/eva/adv/beacon
	name = "Bluespace tracking beacon design"
	id = "beacon"
	req_tech = list(TECH_BLUESPACE = 1)
	materials = list (MATERIAL_STEEL = 20, MATERIAL_GLASS = 10)
	build_path = /obj/item/device/radio/beacon
	sort_string = "VADAA"

/datum/design/item/genfab/eva/gps
	name = "Triangulating device design"
	desc = "Triangulates approximate co-ordinates using a nearby satellite network."
	id = "gps"
	req_tech = list(TECH_MATERIAL = 2, TECH_DATA = 2, TECH_BLUESPACE = 2)
	materials = list(MATERIAL_STEEL = 500)
	build_path = /obj/item/device/gps
	sort_string = "VADAB"

/datum/design/item/genfab/eva/adv/beacon_locator
	name = "Beacon tracking pinpointer"
	desc = "Used to scan and locate signals on a particular frequency."
	id = "beacon_locator"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 2, TECH_BLUESPACE = 3)
	materials = list(MATERIAL_STEEL = 1000,MATERIAL_GLASS = 500)
	build_path = /obj/item/device/beacon_locator
	sort_string = "VADAC"



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
	category = "General"

/datum/design/item/genfab/furniture/desklamp
	name = "desk lamp"
	build_path = /obj/item/device/flashlight/lamp

/datum/design/item/genfab/furniture/floor_light
	name = "floor light"
	build_path = /obj/machinery/floor_light


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

/datum/design/item/genfab/botanytools/minihoe
	name = "mini hoe"
	build_path = /obj/item/weapon/material/minihoe


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
	category = "General"

/datum/design/item/genfab/culinarytools/butch
	name = "butcher knife"
	build_path = /obj/item/weapon/material/knife/butch
	category = "General"



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Consumer Goods

/datum/design/item/genfab/consumer
	category = "Consumer Goods"


////////////////////////////////////////////////////////////////////

/datum/design/item/genfab/consumer/lighter
	name = "cheap lighter"
	build_path = /obj/item/weapon/flame/lighter
	category = "General"

/datum/design/item/genfab/consumer/clipboard
	name = "clipboard"
	build_path = /obj/item/weapon/clipboard
	category = "General"

/datum/design/item/genfab/consumer/labeler
	name = "hand labeler"
	build_path = /obj/item/weapon/hand_labeler
	category = "General"

/datum/design/item/genfab/consumer/ecigcartridge
	name = "ecigarette cartridge"
	build_path = /obj/item/weapon/reagent_containers/ecig_cartridge/blank
	category = "Devices and Components"

/datum/design/item/genfab/consumer/ecig
	// We get it, you vape
	name = "ecigarette"
	build_path = /obj/item/clothing/mask/smokable/ecig/lathed
	category = "Devices and Components"

/datum/design/item/genfab/consumer/mop
	name = "mop"
	build_path = /obj/item/weapon/mop
	category = "General"

/datum/design/item/genfab/consumer/spraybottle
	name = "spray bottle"
	build_path = /obj/item/weapon/reagent_containers/spray
	category = "General"

/datum/design/item/genfab/consumer/lipstick
	name = "lipstick"
	build_path = /obj/item/weapon/lipstick
	category = "General"

/datum/design/item/genfab/consumer/lipstick_purple
	name = "purple lipstick"
	build_path = /obj/item/weapon/lipstick/purple
	category = "General"

/datum/design/item/genfab/consumer/lipstick_jade
	name = "jade lipstick"
	build_path = /obj/item/weapon/lipstick/jade
	category = "General"

/datum/design/item/genfab/consumer/lipstick_black
	name = "black lipstick"
	build_path = /obj/item/weapon/lipstick/black
	category = "General"

/datum/design/item/genfab/consumer/comb
	name = "comb"
	build_path = /obj/item/weapon/haircomb
	category = "General"

/datum/design/item/genfab/consumer/red_doll
	name = "red doll"
	build_path = /obj/item/toy/therapy_red
	category = "General"

/datum/design/item/genfab/consumer/purple_doll
	name = "purple doll"
	build_path = /obj/item/toy/therapy_purple
	category = "General"

/datum/design/item/genfab/consumer/blue_doll
	name = "blue doll"
	build_path = /obj/item/toy/therapy_blue
	category = "General"

/datum/design/item/genfab/consumer/yellow_doll
	name = "yellow doll"
	build_path = /obj/item/toy/therapy_yellow
	category = "General"

/datum/design/item/genfab/consumer/green_doll
	name = "green doll"
	build_path = /obj/item/toy/therapy_green
	category = "General"

/datum/design/item/genfab/consumer/water_balloon
	name = "water balloon"
	build_path = /obj/item/toy/water_balloon
	category = "General"

/datum/design/item/genfab/consumer/picket_sign
	name = "Picket sign"
	id = "picket_sign"
	build_path = /obj/item/weapon/picket_sign
	category = "Consumer Goods"
	materials = list(MATERIAL_STEEL = 1, MATERIAL_CARDBOARD = 4)



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
	category = "General"

/datum/design/item/genfab/sectools/adv/hud
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50)

/datum/design/item/genfab/sectools/adv/hud/AssembleDesignName()
	..()
	name = "HUD glasses prototype ([item_name])"

/datum/design/item/genfab/sectools/adv/hud/AssembleDesignDesc()
	desc = "Allows for the construction of \a [item_name] HUD glasses."




/datum/design/item/genfab/sectools/adv/hud/security
	name = "police scanner"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	build_path = /obj/item/clothing/glasses/hud/security


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
	id = "jackhammer"
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_GLASS = 500, MATERIAL_SILVER = 500)
	build_path = /obj/item/weapon/pickaxe/jackhammer

/datum/design/item/genfab/miningtools/adv/drill
	id = "drill"
	req_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 6000, MATERIAL_GLASS = 1000) //expensive, but no need for miners.
	build_path = /obj/item/weapon/pickaxe/drill
	sort_string = "KAAAB"

/datum/design/item/genfab/miningtools/adv/plasmacutter
	id = "plasmacutter"
	req_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 3, TECH_ENGINEERING = 3)
	materials = list(MATERIAL_STEEL = 1500, MATERIAL_GLASS = 500, MATERIAL_GOLD = 500, MATERIAL_PHORON = 4000)
	build_path = /obj/item/weapon/gun/energy/plasmacutter
	sort_string = "KAAAC"

/datum/design/item/genfab/miningtools/adv/pick_diamond
	id = "pick_diamond"
	req_tech = list(TECH_MATERIAL = 6)
	materials = list(MATERIAL_DIAMOND = 4000)
	build_path = /obj/item/weapon/pickaxe/diamond
	sort_string = "KAAAD"

/datum/design/item/genfab/miningtools/adv/drill_diamond
	id = "drill_diamond"
	req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 4)
	materials = list(MATERIAL_STEEL = 4000, MATERIAL_GLASS = 2000, MATERIAL_DIAMOND = 6000)
	build_path = /obj/item/weapon/pickaxe/diamonddrill
	sort_string = "KAAAE"

/datum/design/item/genfab/miningtools/adv/mining_scanner
	desc = "Scans for ore deposits."
	id = "mining_scanner"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 1000,MATERIAL_GLASS = 1000)
	build_path = /obj/item/weapon/mining_scanner
	sort_string = "KAAAF"

/datum/design/item/genfab/miningtools/adv/depth_scanner
	desc = "Used to check spatial depth and density of rock outcroppings."
	id = "depth_scanner"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2, TECH_BLUESPACE = 2)
	materials = list(MATERIAL_STEEL = 1000,MATERIAL_GLASS = 1000)
	build_path = /obj/item/device/depth_scanner
	sort_string = "KAAAG"



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
	id = "ano_scanner"
	desc = "Aids in triangulation of exotic particles."
	req_tech = list(TECH_BLUESPACE = 3, TECH_MAGNET = 3)
	materials = list(MATERIAL_STEEL = 10000,MATERIAL_GLASS = 5000)
	build_path = /obj/item/device/ano_scanner
	sort_string = "UAAAH"


/datum/design/item/genfab/science/adv/binaryencrypt
	name = "Binary encryption key"
	desc = "Allows for deciphering the binary channel on-the-fly."
	id = "binaryencrypt"
	req_tech = list(TECH_ILLEGAL = 2)
	materials = list(MATERIAL_STEEL = 300, MATERIAL_GLASS = 300, MATERIAL_PHORON = 10000)
	build_path = /obj/item/device/encryptionkey/binary
	sort_string = "VASAA"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
