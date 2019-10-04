/obj/machinery/fabricator/eva_fabricator
	// Things that must be adjusted for each fabricator
	name = "EVA Equipment Fabricator" // Self-explanatory
	desc = "A machine used for the production of voidsuits and other spacesuits and any other EVA related equipment, plus mining equipment.." // Self-explanatory
	circuit_type = /obj/item/weapon/circuitboard/fabricator/evafab // Circuit for the machine. These, as well as their designs, should be defined in fabricator_circuits.dm
	build_type = VOIDFAB // The identifer for what gets built in what fabricator. A new one *MUST* be defined in _defines/research.dm for each fabricator.
						 					 // More than one can be assigned per design, however, if you want something to be able to be built in more than one fabricator eg. Power Cells

	// Things that CAN be adjusted, but are okay to leave as default
	// Icon states - if you want your fabricator to use a special icon, place it in fabricators.dmi following these naming conventions.
	icon_state = 	 "voidsuitfab-idle"
	icon_idle = 	 "voidsuitfab-idle"
	icon_open = 	 "voidsuitfab-o"
	overlay_active = "voidsuitfab-active"

	metal_load_anim = TRUE				// Determines if a sheet loading animation will be applied when loading metals. If you're using a non-standard icon and don't
										// want to sprite a new loading animation as well, set this to FALSE.

	has_reagents = FALSE				// Defaults to FALSE, but added here for explanation. If this is set to true, than you require designs to use reagents
										// in addition to any material costs.

/obj/machinery/fabricator/eva_fabricator/can_connect(var/datum/world_faction/trying, var/mob/M)
	var/datum/machine_limits/limits = trying.get_limits()


	if(M && !has_access(list(core_access_machine_linking), list(), M.GetAccess(trying.uid)))
		to_chat(M, "You do not have access to link machines to [trying.name].")
		return 0
	if(limits.limit_voidfab <= limits.voidfabs.len)
		if(M)
			to_chat(M, "[trying.name] cannot connect any more machines of this type.")
		return 0
	limits.voidfabs |= src
	req_access_faction = trying.uid
	connected_faction = trying

/obj/machinery/fabricator/eva_fabricator/can_disconnect(var/datum/world_faction/trying, var/mob/M)
	var/datum/machine_limits/limits = trying.get_limits()
	limits.voidfabs -= src
	req_access_faction = ""
	connected_faction = null
	if(M) to_chat(M, "The machine has been disconnected.")

////////////////////////////////////////////////////
//////////////////////DESIGNS///////////////////////
////////////////////////////////////////////////////

//Voidsuits
/datum/design/item/voidfab
	build_type = VOIDFAB 			   // This must match the build_type of the fabricator(s)
	category = "Misc"	 			   // The design will appear under this in the UI. Each design must have a category, or it will not display properly.
	req_tech = list(TECH_MATERIAL = 1) // The tech required for the design. Note that anything above 1 for *ANY* tech will require a RnD console for the item to be
									   // fabricated.

	time = 50						   // Time in seconds for the item to be produced - This changes based off the components used in the fabricator

/datum/design/item/voidfab/magboots
	name = "Magboots"
	id = "magboots"
	build_path = /obj/item/clothing/shoes/magboots
	materials = list(MATERIAL_STEEL = 10 SHEETS, MATERIAL_COPPER = 10 SHEETS)

/datum/design/item/voidfab/engineering
	category = "Engineering"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 3)

/datum/design/item/voidfab/engineering/engineeringsuit
	name = "Engineering voidsuit"
	id = "engi_voidsuit"
	build_path = /obj/item/clothing/suit/space/void/engineering // The path to the item produced
	materials = list(MATERIAL_PLASTEEL = 5 SHEETS, MATERIAL_STEEL = 10 SHEETS, MATERIAL_COPPER = 5 SHEETS)	// The amount of material required for the item. 2000 = 1 sheet

/datum/design/item/voidfab/engineering/engineeringhelmet
	name = "Engineering voidsuit helmet"
	id = "engi_helment"
	build_path = /obj/item/clothing/head/helmet/space/void/engineering
	materials = list(MATERIAL_PLASTEEL = 1 SHEET, MATERIAL_GLASS = 2 SHEETS)

/datum/design/item/voidfab/engineering/engineeringsuitheavy
	name = "Reinforced engineering voidsuit"
	id = "engi_voidsuit_heavy"
	build_path = /obj/item/clothing/suit/space/void/engineering/alt // The path to the item produced
	materials = list(MATERIAL_PLASTEEL = 20 SHEETS, MATERIAL_STEEL = 35 SHEETS, MATERIAL_BRONZE = 15 SHEETS, MATERIAL_LEAD = 10 SHEETS)	// The amount of material required for the item. 2000 = 1 sheet

/datum/design/item/voidfab/engineering/engineeringhelmetheavy
	name = "Reinforced engineering voidsuit helmet"
	id = "engi_helment_heavy"
	build_path = /obj/item/clothing/head/helmet/space/void/engineering/alt
	materials = list(MATERIAL_PLASTEEL = 10 SHEET, MATERIAL_GLASS = 10 SHEETS, MATERIAL_BRONZE = 10 SHEETS, MATERIAL_LEAD = 5 SHEETS)

/datum/design/item/voidfab/engineering/atmossuit
	name = "Atmospherics voidsuit"
	id = "atmos_voidsuit"
	build_path = /obj/item/clothing/suit/space/void/atmos
	materials = list(MATERIAL_OSMIUM_CARBIDE_PLASTEEL = 100000, MATERIAL_GOLD = 20000)

/datum/design/item/voidfab/engineering/atmoshelmet
	name = "Atmospherics voidsuit helmet"
	id = "atmos_helmet"
	build_path = /obj/item/clothing/head/helmet/space/void/atmos
	materials = list(MATERIAL_OSMIUM_CARBIDE_PLASTEEL = 40000, MATERIAL_GOLD = 10000, MATERIAL_GLASS = 20000)

/datum/design/item/voidfab/engineering/atmoshelmetheavy
	name = "Reinforced atmospherics voidsuit helmet"
	id = "atmos_helmet_heavy"
	build_path = /obj/item/clothing/head/helmet/space/void/atmos/alt
	materials = list(MATERIAL_OSMIUM_CARBIDE_PLASTEEL = 5 SHEETS, MATERIAL_GOLD = 10 SHEETS, MATERIAL_GLASS = 10 SHEETS)

/datum/design/item/voidfab/engineering/atmossuitheavy
	name = "Reinforced atmospherics voidsuit"
	id = "atmos_voidsuit_heavy"
	build_path = /obj/item/clothing/suit/space/void/atmos/alt
	materials = list(MATERIAL_OSMIUM_CARBIDE_PLASTEEL = 15 SHEETS, MATERIAL_GOLD = 15 SHEETS, MATERIAL_PLASTEEL = 15 SHEETS)

/datum/design/item/voidfab/security
	category = "Security"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 3, TECH_COMBAT = 3)

/datum/design/item/voidfab/security/securitysuit
	name = "Security voidsuit"
	id = "sec_voidsuit"
	build_path = /obj/item/clothing/suit/space/void/security
	materials = list(MATERIAL_PLASTEEL = 140000, MATERIAL_PLATINUM = 40000)

/datum/design/item/voidfab/security/securityhelmet
	name = "Security voidsuit helmet"
	id = "sec_helmet"
	build_path = /obj/item/clothing/head/helmet/space/void/security
	materials = list(MATERIAL_PLASTEEL = 80000, MATERIAL_GLASS = 20000, MATERIAL_PLATINUM = 40000)

/datum/design/item/voidfab/security/riotsuit
	name = "Security riot voidsuit"
	id = "sec_voidsuit_riot"
	build_path = /obj/item/clothing/suit/space/void/security/alt
	materials = list(MATERIAL_PLASTEEL = 20 SHEETS, MATERIAL_PLATINUM = 20 SHEETS, MATERIAL_TUNGSTEN = 15 SHEETS)

/datum/design/item/voidfab/security/riotsuithelmet
	name = "Security riot voidsuit helmet"
	id = "sec_helmet_riot"
	build_path = /obj/item/clothing/head/helmet/space/void/security/alt
	materials = list(MATERIAL_PLASTEEL = 7.5 SHEETS, MATERIAL_GLASS = 5 SHEETS, MATERIAL_PLATINUM = 7.5 SHEETS, MATERIAL_TUNGSTEN = 7.5 SHEETS)

/datum/design/item/voidfab/medical
	category = "Medical"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 3, TECH_BIO = 3)

/datum/design/item/voidfab/medical/medicalsuit
	name = "Medical voidsuit"
	id = "med_voidsuit"
	build_path = /obj/item/clothing/suit/space/void/medical/alt
	materials = list(MATERIAL_PLASTEEL = 100000, MATERIAL_PLATINUM = 40000)

/datum/design/item/voidfab/medical/medicalhelmet
	name = "Medical voidsuit helmet"
	id = "med_helmet"
	build_path = /obj/item/clothing/head/helmet/space/void/medical/alt
	materials = list(MATERIAL_PLASTEEL = 40000, MATERIAL_GLASS = 20000)

/datum/design/item/voidfab/mining
	category = "Mining"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 3, TECH_BIO = 3)

/datum/design/item/voidfab/mining/normsuit
	name = "Mining voidsuit"
	id = "mining_voidsuit_voidfab"
	build_path = /obj/item/clothing/suit/space/void/mining
	materials = list(MATERIAL_PLASTEEL = 10 SHEETS, MATERIAL_COPPER = 5 SHEETS)

/datum/design/item/voidfab/mining/normhelm
	name = "Mining voidsuit helmet"
	id = "mining_voidsuit_helmet_voidfab"
	build_path = /obj/item/clothing/head/helmet/space/void/mining
	materials = list(MATERIAL_PLASTEEL = 5 SHEETS, MATERIAL_COPPER = 2.5 SHEETS, MATERIAL_GLASS = 5 SHEETS)

/datum/design/item/voidfab/mining/heavysuit
	name = "Reinforced mining voidsuit"
	id = "mining_voidsuit_voidfab_heavy"
	build_path = /obj/item/clothing/suit/space/void/mining/alt
	materials = list(MATERIAL_PLASTEEL = 20 SHEETS, MATERIAL_COPPER = 15 SHEETS, MATERIAL_ZINC = 10 SHEETS, MATERIAL_BRONZE = 10 SHEETS)

/datum/design/item/voidfab/mining/heavyhelm
	name = "Reinforced mining voidsuit helmet"
	id = "mining_voidsuit_helmet_voidfab_heavy"
	build_path = /obj/item/clothing/head/helmet/space/void/mining/alt
	materials = list(MATERIAL_PLASTEEL = 15 SHEETS, MATERIAL_COPPER = 5 SHEETS, MATERIAL_GLASS = 10 SHEETS, MATERIAL_BRONZE = 5 SHEETS)

/datum/design/item/voidfab/exploration
	category = "Exploration"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 3, TECH_BIO = 3)

/datum/design/item/voidfab/exploration/helm
	name = "Exploration voidsuit helmet"
	id = "explovoid"
	build_path = /obj/item/clothing/head/helmet/space/void/pilot
	materials = list(MATERIAL_PLASTEEL = 5 SHEETS, MATERIAL_GLASS = 5 SHEETS)

/datum/design/item/voidfab/exploration/suit
	name = "Exploration voidsuit"
	id = "explovoidsuit"
	build_path = /obj/item/clothing/suit/space/void/pilot
	materials = list(MATERIAL_PLASTEEL = 10 SHEETS, MATERIAL_ZINC = 10 SHEETS)
//Softsuits

/datum/design/item/voidfab/softsuit/
	category = "Softsuits"
	time = 25

/datum/design/item/voidfab/softsuit/suit
	materials = list(MATERIAL_CLOTH = 30000, MATERIAL_STEEL = 1000)
/datum/design/item/voidfab/softsuit/helmet
	materials = list(MATERIAL_CLOTH = 20000, MATERIAL_GLASS = 20000)


/datum/design/item/voidfab/softsuit/suit/assistant
	name = "Phorosian spacesuit"
	id = "Phoron_suit"
	build_path = /obj/item/clothing/suit/space/phorosian/assistant

/datum/design/item/voidfab/softsuit/helmet/assistant
	name = "Phorosian helmet"
	id = "Phoron_suitthelmet"
	build_path = /obj/item/clothing/head/helmet/space/phorosian/assistant

/datum/design/item/voidfab/softsuit/suit/engineeringsuit
	name = "Engineering softsuit"
	id = "eng_softsuit"
	build_path = /obj/item/clothing/suit/space/engineering

/datum/design/item/voidfab/softsuit/helmet/engineeringhelmet
	name = "Engineering softsuit helmet"
	id = "eng_softhelmet"
	build_path = /obj/item/clothing/head/helmet/space/engineering

/datum/design/item/voidfab/softsuit/suit/securitysuit
	name = "Security softsuit"
	id = "sec_softsuit"
	build_path = /obj/item/clothing/suit/space/security

/datum/design/item/voidfab/softsuit/helmet/securityhelmet
	name = "Security softsuit helmet"
	id = "sec_softhelmet"
	build_path = /obj/item/clothing/head/helmet/space/security

/datum/design/item/voidfab/softsuit/suit/medicalsuit
	name = "Medical softsuit"
	id = "med_softsuit"
	build_path = /obj/item/clothing/suit/space/medical

/datum/design/item/voidfab/softsuit/helmet/medicalhelmet
	name = "Medical softsuit helmet"
	id = "med_softhelmet"
	build_path = /obj/item/clothing/head/helmet/space/medical

/datum/design/item/voidfab/softsuit/suit/miningsuit
	name = "Mining softsuit"
	id = "min_softsuit"
	build_path = /obj/item/clothing/suit/space/mining

/datum/design/item/voidfab/softsuit/helmet/mininghelmet
	name = "Mining softsuit helmet"
	id = "min_softhelmet"
	build_path = /obj/item/clothing/head/helmet/space/mining

/datum/design/item/voidfab/softsuit/suit/sciencesuit
	name = "Science softsuit"
	id = "sci_softsuit"
	build_path = /obj/item/clothing/suit/space/science

/datum/design/item/voidfab/softsuit/helmet/sciencehelmet
	name = "Science softsuit helmet"
	id = "sci_softhelmet"
	build_path = /obj/item/clothing/head/helmet/space/science

/datum/design/item/voidfab/softsuit/helmet/fishbowl
	name = "fishbowl softsuit helmet"
	id = "softhelm_fish"
	build_path = /obj/item/clothing/head/helmet/space/fishbowl

/datum/design/item/voidfab/softsuit/helmet/emergency/fishbowl
	name = "emergency fishbowl softsuit helmet"
	id = "emr_softhelm_fish"
	build_path = /obj/item/clothing/head/helmet/space/emergency
/datum/design/item/voidfab/softsuit/suit/emergency/fishbowl
	name = "emergency fishbowl softsuit"
	id = "emr_softsuit_fish"
	build_path = /obj/item/clothing/suit/space/emergency

/datum/design/item/voidfab/softsuit/helmet/emergency
	name = "emergency softsuit helmet"
	id = "emr_softhelm"
	build_path = /obj/item/clothing/head/helmet/space/emergency/alt
/datum/design/item/voidfab/softsuit/suit/emergency
	name = "emergency softsuit"
	id = "emr_softsuit"
	build_path = /obj/item/clothing/suit/space/emergency/alt

/datum/design/item/voidfab/softsuit/helmet/civilian
	name = "civilian softsuit helmet"
	id = "civ_softhelm"
	build_path = /obj/item/clothing/head/helmet/space/civilian
/datum/design/item/voidfab/softsuit/suit/civilian
	name = "civilian softsuit"
	id = "civ_softsuit"
	build_path = /obj/item/clothing/suit/space/civilian

/datum/design/item/voidfab/softsuit/helmet/civilian/alt
	name = "civilian alternate softsuit helmet"
	id = "civ_softhelm_alt"
	build_path = /obj/item/clothing/head/helmet/space
/datum/design/item/voidfab/softsuit/suit/civilian/alt
	name = "civilian alternate softsuit"
	id = "civ_softsuit_alt"
	build_path = /obj/item/clothing/suit/space

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// EVA Equipment
/datum/design/item/genfab/eva
	category = "EVA Equipment"
	time = 10
/datum/design/item/genfab/eva/adv

///////////////////////////////////////////////////////////////

/*Tanks*/
/datum/design/item/genfab/eva/tank
	name = "Blue EVA air tank"
	build_path = /obj/item/weapon/tank/oxygen/empty
	materials = list(MATERIAL_STEEL = 2000)
/datum/design/item/genfab/eva/tank/yellow
	name = "Yellow EVA air tank"
	build_path = /obj/item/weapon/tank/oxygen/yellow/empty
/datum/design/item/genfab/eva/tank/red
	name = "Red EVA air tank"
	build_path = /obj/item/weapon/tank/oxygen/red/empty
/datum/design/item/genfab/eva/tank/nitrogen //Its a bit of a different size or something
	name = "Red EVA nitrogen tank"
	build_path = /obj/item/weapon/tank/nitrogen/empty

/datum/design/item/genfab/eva/adv/tank/small
	name = "Small blue emergency tank"
	build_path = /obj/item/weapon/tank/emergency/empty
	materials = list(MATERIAL_STEEL = 850)
/datum/design/item/genfab/eva/adv/tank/small/orange
	name = "Small orange emergency tank"
	build_path = /obj/item/weapon/tank/emergency/phoron/empty
/datum/design/item/genfab/eva/adv/tank/small/red
	name = "Small red emergency tank"
	build_path = /obj/item/weapon/tank/emergency/nitrogen/empty
/datum/design/item/genfab/eva/adv/tank/small/phoron
	name = "Small red emergency phoron tank(phorosian)"
	build_path = /obj/item/weapon/tank/emergency/phoron/empty

/datum/design/item/genfab/eva/adv/tank/small/extended
	name = "Extended-capacity small yellow air tank"
	build_path = /obj/item/weapon/tank/emergency/oxygen/engi/empty
	materials = list(MATERIAL_STEEL = 950)

/datum/design/item/genfab/eva/adv/tank/double
	name = "Double-capacity small yellow air tank"
	build_path = /obj/item/weapon/tank/emergency/oxygen/double/empty
	materials = list(MATERIAL_STEEL = 1200)
/datum/design/item/genfab/eva/adv/tank/double/red
	name = "Double-capacity small red air tank"
	build_path = /obj/item/weapon/tank/emergency/nitrogen/double/empty
/*End tanks*/


/datum/design/item/genfab/eva/oxygen_candle
	name = "oxygen candle"
	build_path = /obj/item/device/oxycandle
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_IRON = 0.5 SHEET, MATERIAL_ROCK_SALT = 1 SHEET) //An actual oxy candle uses iron powder and sodium cholorate, then heats to 300c to generate oxygen

/datum/design/item/genfab/eva/adv/jetpack // tier 1
	name = "Blue Jetpack"	//Just a fancy name for a jetpack, heh
	req_tech = list(TECH_ENGINEERING = 4)
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_GOLD = 3 SHEETS, MATERIAL_SILVER = 2 SHEETS)
	build_path = /obj/item/weapon/tank/jetpack
	research = "jetpacks"
/datum/design/item/genfab/eva/adv/jetpack/black // tier 1
	name = "Black Jetpack"	//Just a fancy name for a jetpack, heh
	req_tech = list(TECH_ENGINEERING = 4)
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_GOLD = 3 SHEETS, MATERIAL_SILVER = 2 SHEETS)
	build_path = /obj/item/weapon/tank/jetpack/carbondioxide
	research = "jetpacks"

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
	build_path = /obj/item/weapon/pinpointer/radio

/datum/design/item/genfab/eva/adv/marshalling_wand
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_COPPER = 0.5 SHEETS)
	build_path = /obj/item/weapon/marshalling_wand
/datum/design/item/genfab/eva/flare
	materials = list(MATERIAL_STEEL = 1.5 SHEET, MATERIAL_GOLD = 0.15 SHEETS)
	build_path = /obj/item/device/flashlight/flare

/datum/design/item/genfab/eva/binoculars
	materials = list(MATERIAL_STEEL = 1.5 SHEET, MATERIAL_COPPER = 0.5 SHEETS, MATERIAL_GLASS = 1.5 SHEETS)
	build_path = /obj/item/device/binoculars

/datum/design/item/genfab/eva/modkit
	materials = list(MATERIAL_STEEL = 4 SHEET, MATERIAL_COPPER = 1 SHEETS, MATERIAL_CLOTH = 2 SHEET)

/datum/design/item/genfab/eva/modkit/vox
	build_path = /obj/item/device/modkit/vox

/datum/design/item/genfab/eva/modkit/unathi
	build_path = /obj/item/device/modkit/unathi

/datum/design/item/genfab/eva/modkit/phorosian
	build_path = /obj/item/device/phorosiansuit_changer

/datum/design/item/genfab/eva/modkit/resomi
	build_path = /obj/item/device/modkit/resomi

/datum/design/item/genfab/eva/adv/net_launcher
	materials = list(MATERIAL_STEEL = 6 SHEET, MATERIAL_COPPER = 3 SHEETS)
	build_path = /obj/item/weapon/gun/launcher/net

/datum/design/item/genfab/eva/adv/net_shell
	materials = list(MATERIAL_STEEL = 2 SHEET, MATERIAL_CLOTH = 3 SHEETS)
	build_path = /obj/item/weapon/net_shell


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//MINING EQUIPMENT
/datum/design/item/genfab/miningtools
	category = "Mining Equipment"
	time = 10
/datum/design/item/genfab/miningtools/adv

/datum/design/item/genfab/miningtools/flag
	materials = list(MATERIAL_CLOTH = 1 SHEETS)
	build_path = /obj/item/stack/flag

/datum/design/item/genfab/miningtools/flag/red
	build_path = /obj/item/stack/flag/red

/datum/design/item/genfab/miningtools/flag/yellow
	build_path = /obj/item/stack/flag/yellow

/datum/design/item/genfab/miningtools/flag/green
	build_path = /obj/item/stack/flag/green

/datum/design/item/genfab/miningtools/flag/solgov
	build_path = /obj/item/stack/flag/solgov

/datum/design/item/genfab/miningtools/flag/blue
	build_path = /obj/item/stack/flag/blue

/datum/design/item/genfab/miningtools/flag/teal
	build_path = /obj/item/stack/flag/teal

/datum/design/item/engifab/miningtools/lantern
	build_path = /obj/item/device/flashlight/lantern
	materials = list(MATERIAL_STEEL = 0.5 SHEETS, MATERIAL_GLASS = 0.25 SHEETS)




//////////////////////////////////////////////////////////////////////////////

/datum/design/item/genfab/miningtools/pickaxe// 40
	materials = list(MATERIAL_STEEL = 2 SHEETS)
	build_path = /obj/item/weapon/pickaxe

//	/datum/design/item/genfab/miningtools/hammer // 40
//		materials = list(MATERIAL_STEEL = 2 SHEETS)
//		build_path = /obj/item/weapon/pickaxe/hammer

/datum/design/item/genfab/miningtools/shovel
	build_path = /obj/item/weapon/shovel
	materials = list(MATERIAL_WOOD = 1 SHEET, MATERIAL_STEEL = 1 SHEET)

/datum/design/item/genfab/miningtools/spade
	build_path = /obj/item/weapon/shovel/spade
	materials = list(MATERIAL_STEEL = 2 SHEET)


/datum/design/item/genfab/miningtools/adv/drill // 30
	req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 4)
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_GLASS = 2 SHEETS, MATERIAL_DIAMOND = 3 SHEETS)
	build_path = /obj/item/weapon/pickaxe/drill
	research = "mining_1"

/datum/design/item/genfab/miningtools/adv/jackhammer // 20
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_COPPER = 2 SHEETS, MATERIAL_SILVER = 1 SHEETS)
	build_path = /obj/item/weapon/pickaxe/jackhammer
	research = "mining_2"


/datum/design/item/genfab/miningtools/adv/pick_diamond // 10
	req_tech = list(TECH_MATERIAL = 6)
	materials = list(MATERIAL_DIAMOND = 2 SHEETS, MATERIAL_STEEL = 1 SHEET)
	build_path = /obj/item/weapon/pickaxe/diamond
	research = "mining_3"
/datum/design/item/genfab/miningtools/adv/drill_diamond // 5
	req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 4)
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_GLASS = 2 SHEETS, MATERIAL_DIAMOND = 3 SHEETS)
	build_path = /obj/item/weapon/pickaxe/diamonddrill
	research = "mining_4"


/datum/design/item/genfab/miningtools/adv/plasmacutter
	req_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 3, TECH_ENGINEERING = 3)
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_GLASS = 1 SHEETS, MATERIAL_GOLD = 1 SHEETS, MATERIAL_PHORON = 2 SHEETS)
	build_path = /obj/item/weapon/gun/energy/plasmacutter
	research = "plasma_cutter"

/datum/design/item/genfab/miningtools/adv/mining_scanner
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 0.5 SHEETS,MATERIAL_GLASS = 0.5 SHEETS)
	build_path = /obj/item/device/scanner/mining/

/datum/design/item/genfab/miningtools/adv/depth_scanner
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2, TECH_BLUESPACE = 2)
	materials = list(MATERIAL_STEEL = 0.5 SHEETS,MATERIAL_GLASS = 0.5 SHEETS)
	build_path = /obj/item/device/depth_scanner


/datum/design/item/genfab/miningtools/adv/arch/brush
	materials = list(MATERIAL_STEEL = 1 SHEETS, MATERIAL_CLOTH = 0.5 SHEETS)
	build_path = /obj/item/weapon/pickaxe/xeno/brush

/datum/design/item/genfab/miningtools/adv/arch/one_pick
	materials = list(MATERIAL_STEEL = 1 SHEETS, MATERIAL_CLOTH = 0.5 SHEETS)
	build_path = /obj/item/weapon/pickaxe/xeno/one_pick

/datum/design/item/genfab/miningtools/adv/arch/two_pick
	materials = list(MATERIAL_STEEL = 1 SHEETS, MATERIAL_CLOTH = 0.5 SHEETS)
	build_path = /obj/item/weapon/pickaxe/xeno/two_pick

/datum/design/item/genfab/miningtools/adv/arch/three_pick
	materials = list(MATERIAL_STEEL = 1 SHEETS, MATERIAL_CLOTH = 0.5 SHEETS)
	build_path = /obj/item/weapon/pickaxe/xeno/one_pick

/datum/design/item/genfab/miningtools/adv/arch/three_pick
	materials = list(MATERIAL_STEEL = 1 SHEETS, MATERIAL_CLOTH = 0.5 SHEETS)
	build_path = /obj/item/weapon/pickaxe/xeno/three_pick

/datum/design/item/genfab/miningtools/adv/arch/four_pick
	materials = list(MATERIAL_STEEL = 1 SHEETS, MATERIAL_CLOTH = 0.5 SHEETS)
	build_path = /obj/item/weapon/pickaxe/xeno/four_pick

/datum/design/item/genfab/miningtools/adv/arch/five_pick
	materials = list(MATERIAL_STEEL = 1 SHEETS, MATERIAL_CLOTH = 0.5 SHEETS)
	build_path = /obj/item/weapon/pickaxe/xeno/five_pick

/datum/design/item/genfab/miningtools/adv/arch/six_pick
	materials = list(MATERIAL_STEEL = 1 SHEETS, MATERIAL_CLOTH = 0.5 SHEETS)
	build_path = /obj/item/weapon/pickaxe/xeno/six_pick

/datum/design/item/genfab/miningtools/adv/arch/hand
	materials = list(MATERIAL_STEEL = 1 SHEETS, MATERIAL_CLOTH = 0.5 SHEETS)
	build_path = /obj/item/weapon/pickaxe/xeno/hand

/datum/design/item/genfab/miningtools/adv/arch/sampler
	materials = list(MATERIAL_STEEL = 1 SHEETS, MATERIAL_COPPER = 1 SHEETS)
	build_path = /obj/item/device/core_sampler

/datum/design/item/genfab/miningtools/adv/arch/measuring_tape
	materials = list(MATERIAL_STEEL = 1 SHEETS, MATERIAL_COPPER = 1 SHEETS)
	build_path = /obj/item/device/measuring_tape

/datum/design/item/genfab/miningtools/adv/arch/suspension_gen
	materials = list(MATERIAL_STEEL = 5 SHEETS, MATERIAL_COPPER = 2 SHEETS, MATERIAL_QUARTZ = 5 SHEETS)
	build_path = /obj/machinery/suspension_gen

/datum/design/item/genfab/miningtools/adv/arch/anodevice
	materials = list(MATERIAL_TITANIUM = 2 SHEETS, MATERIAL_COPPER = 2 SHEETS)
	build_path = /obj/item/weapon/anodevice

/datum/design/item/genfab/miningtools/adv/arch/anobattery
	materials = list(MATERIAL_TITANIUM = 2 SHEETS, MATERIAL_COPPER = 2 SHEETS)
	build_path = /obj/item/weapon/anobattery

/datum/design/item/genfab/miningtools/adv/arch/ano_scanner
	materials = list(MATERIAL_TITANIUM = 2 SHEETS, MATERIAL_COPPER = 2 SHEETS)
	build_path = /obj/item/device/ano_scanner

/datum/design/item/genfab/miningtools/adv/arch/fossil_bag
	materials = list(MATERIAL_CLOTH = 1 SHEETS)
	build_path = /obj/item/weapon/storage/bag/fossils
