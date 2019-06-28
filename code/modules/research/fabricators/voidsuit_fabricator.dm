/obj/machinery/fabricator/voidsuit_fabricator
	// Things that must be adjusted for each fabricator
	name = "Voidsuit Fabricator" // Self-explanatory
	desc = "A machine used for the production of voidsuits and other spacesuits" // Self-explanatory
	circuit_type = /obj/item/weapon/circuitboard/fabricator/voidfab // Circuit for the machine. These, as well as their designs, should be defined in fabricator_circuits.dm
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

/obj/machinery/fabricator/voidsuit_fabricator/can_connect(var/datum/world_faction/trying, var/mob/M)
	if(!trying.limits) return 0
	if(M && !has_access(list(core_access_machine_linking), list(), M.GetAccess(trying.uid)))
		to_chat(M, "You do not have access to link machines to [trying.name].")
		return 0
	if(trying.limits.limit_voidfab <= trying.limits.voidfabs.len)
		if(M)
			to_chat(M, "[trying.name] cannot connect any more machines of this type.")
		return 0
	trying.limits.voidfabs |= src
	req_access_faction = trying.uid
	connected_faction = src

/obj/machinery/fabricator/voidsuit_fabricator/can_disconnect(var/datum/world_faction/trying, var/mob/M)
	if(!trying.limits) return 0
	trying.limits.voidfabs -= src
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

/datum/design/item/voidfab/engineering
	category = "Engineering"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 3)

/datum/design/item/voidfab/engineering/engineeringsuit
	name = "Engineering voidsuit"
	id = "engi_voidsuit"
	build_path = /obj/item/clothing/suit/space/void/engineering // The path to the item produced
	materials = list(MATERIAL_PLASTEEL = 120000, MATERIAL_TUNGSTEN = 40000)	// The amount of material required for the item. 2000 = 1 sheet

/datum/design/item/voidfab/engineering/engineeringhelmet
	name = "Engineering voidsuit helmet"
	id = "engi_helment"
	build_path = /obj/item/clothing/head/helmet/space/void/engineering
	materials = list(MATERIAL_PLASTEEL = 60000, MATERIAL_GLASS = 20000, MATERIAL_TUNGSTEN = 40000)

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

//Softsuits

/datum/design/item/voidfab/softsuit/
	category = "Softsuits"
	time = 25

/datum/design/item/voidfab/softsuit/suit
	materials = list(MATERIAL_CLOTH = 30000, MATERIAL_STEEL = 1000)
/datum/design/item/voidfab/softsuit/helmet
	materials = list(MATERIAL_CLOTH = 20000, MATERIAL_GLASS = 20000)

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

/datum/design/item/voidfab/softsuit/helmet/emergency/fishbowl
	name = "emergency fishbowl softsuit helmet"
	id = "emr_softhelm_fish"
	build_path = /obj/item/clothing/head/helmet/space
/datum/design/item/voidfab/softsuit/suit/emergency/fishbowl
	name = "emergency fishbowl softsuit"
	id = "emr_softsuit_fish"
	build_path = /obj/item/clothing/suit/space/emergency/fishbowl
	
/datum/design/item/voidfab/softsuit/helmet/emergency
	name = "emergency softsuit helmet"
	id = "emr_softhelm"
	build_path = /obj/item/clothing/head/helmet/space/emergency
/datum/design/item/voidfab/softsuit/suit/emergency
	name = "emergency softsuit"
	id = "emr_softsuit"
	build_path = /obj/item/clothing/suit/space/emergency

/datum/design/item/voidfab/softsuit/helmet/civilian
	name = "civilian softsuit helmet"
	id = "civ_softhelm"
	build_path = /obj/item/clothing/head/helmet/space/civilian
/datum/design/item/voidfab/softsuit/suit/civilian
	name = "civilian softsuit"
	id = "civ_softsuit"
	build_path = /obj/item/clothing/suit/space/civilian 

/datum/design/item/voidfab/softsuit/helmet/civilian/alt
	name = "civilian fishbowl softsuit helmet"
	id = "civ_softhelm_fish"
	build_path = /obj/item/clothing/head/helmet/space
/datum/design/item/voidfab/softsuit/suit/civilian/alt
	name = "civilian fishbowl softsuit"
	id = "civ_softsuit_fish"
	build_path = /obj/item/clothing/suit/space