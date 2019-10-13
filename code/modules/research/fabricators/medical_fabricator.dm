/obj/machinery/fabricator/medical_fabricator
	// Things that must be adjusted for each fabricator
	name = "Medical Fabricator" // Self-explanatory
	desc = "A machine used for the production of medical equipment." // Self-explanatory
	circuit = /obj/item/weapon/circuitboard/fabricator/medicalfab // Circuit for the machine. These, as well as their designs, should be defined in fabricator_circuits.dm
	build_type = MEDICALFAB // The identifer for what gets built in what fabricator. A new one *MUST* be defined in _defines/research.dm for each fabricator.
						 					 // More than one can be assigned per design, however, if you want something to be able to be built in more than one fabricator eg. Power Cells
	metal_load_anim = TRUE				// Determines if a sheet loading animation will be applied when loading metals. If you're using a non-standard icon and don't
										// want to sprite a new loading animation as well, set this to FALSE.

	has_reagents = TRUE				// Defaults to FALSE, but added here for explanation. If this is set to true, than you require designs to use reagents
										// in addition to any material costs.

/obj/machinery/fabricator/medical_fabricator/can_connect(var/datum/world_faction/trying, var/mob/M)
	var/datum/machine_limits/limits = trying.get_limits()
	if(M && !has_access(list(core_access_machine_linking), list(), M.GetAccess(trying.uid)))
		to_chat(M, "You do not have access to link machines to [trying.name].")
		return 0
	if(limits.limit_medicalfab <= limits.medicalfabs.len)
		if(M)
			to_chat(M, "[trying.name] cannot connect any more machines of this type.")
		return 0
	limits.medicalfabs |= src
	req_access_faction = trying.uid
	connected_faction = trying

/obj/machinery/fabricator/medical_fabricator/can_disconnect(var/datum/world_faction/trying, var/mob/M)
	var/datum/machine_limits/limits = trying.get_limits()
	if(limits)
		limits.medicalfabs -= src
	req_access_faction = ""
	connected_faction = null
	if(M) to_chat(M, "The machine has been disconnected.")

////////////////////////////////////////////////////
//////////////////////DESIGNS///////////////////////
////////////////////////////////////////////////////

//Voidsuits
/datum/design/item/medicalfab
	build_type = MEDICALFAB 			   // This must match the build_type of the fabricator(s)
	category = "Misc"	 			   // The design will appear under this in the UI. Each design must have a category, or it will not display properly.
	req_tech = list(TECH_MATERIAL = 1) // The tech required for the design. Note that anything above 1 for *ANY* tech will require a RnD console for the item to be
									   // fabricated.
	time = 5						   // Time in seconds for the item to be produced - This changes based off the components used in the fabricator



////////////////////////////////////////////////////
//////////////////////DESIGNS///////////////////////
////////////////////////////////////////////////////

// Medicines
/datum/design/item/medicalfab/medicines
	category = "Medicines"

/datum/design/item/medicalfab/medicines/splint
	name = "Medical splint"
	build_path = /obj/item/stack/medical/splint
	materials = list(MATERIAL_CLOTH = 1 SHEETS, MATERIAL_WOOD = 1 SHEETS)

/datum/design/item/medicalfab/medicines/bruise_pack
	build_path = /obj/item/stack/medical/bruise_pack
	materials = list(MATERIAL_CLOTH = 5 SHEETS)

/datum/design/item/medicalfab/medicines/ointment
	build_path = /obj/item/stack/medical/ointment
	materials = list(MATERIAL_PLASTIC = 2 SHEETS)
	chemicals = list(/datum/reagent/kelotane = 5)

/datum/design/item/medicalfab/medicines/atk
	build_path = /obj/item/stack/medical/advanced/bruise_pack
	materials = list(MATERIAL_CLOTH = 5 SHEETS)
	chemicals = list(/datum/reagent/bicaridine = 10)

/datum/design/item/medicalfab/medicines/abt
	build_path = /obj/item/stack/medical/advanced/ointment
	materials = list(MATERIAL_CLOTH = 5 SHEETS)
	chemicals = list(/datum/reagent/dermaline = 10)

// Tools etc.
/datum/design/item/medicalfab/meditools
	category = "Medical Equipment"

/datum/design/item/medicalfab/meditools/adv

/datum/design/item/medicalfab/meditools/bodybag
	build_path = /obj/item/bodybag
	materials = list(MATERIAL_CLOTH = 2 SHEETS)

/datum/design/item/medicalfab/meditools/adv/cryobag
	build_path = /obj/item/bodybag/cryobag
	materials = list(MATERIAL_CLOTH = 2 SHEETS, MATERIAL_PHORON = 1 SHEET)

/datum/design/item/medicalfab/meditools/adv/rescuebag
	build_path = /obj/item/bodybag/rescue
	materials = list(MATERIAL_CLOTH = 2 SHEETS, MATERIAL_PHORON = 1 SHEET)

/datum/design/item/medicalfab/meditools/autoinjector
	build_path = /obj/item/weapon/reagent_containers/hypospray/autoinjector
	materials = list(MATERIAL_GLASS = 600)

/datum/design/item/medicalfab/meditools/dropper
	name = "dropper"
	build_path = /obj/item/weapon/reagent_containers/dropper
	materials = list(MATERIAL_GLASS = 60)

/datum/design/item/medicalfab/meditools/dropper_industrial
	name = "industrial size dropper"
	build_path = /obj/item/weapon/reagent_containers/dropper/industrial
	materials = list(MATERIAL_GLASS = 120, MATERIAL_PLASTIC = 10)

/datum/design/item/medicalfab/meditools/penlight
	build_path = /obj/item/device/flashlight/pen
	materials = list(MATERIAL_STEEL = 0.1 SHEETS)

/datum/design/item/medicalfab/meditools/autopsy_scanner
	build_path = /obj/item/weapon/autopsy_scanner
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_COPPER = 1 SHEETS)

/datum/design/item/medicalfab/meditools/bodybag
	build_path = /obj/item/bodybag
	materials = list(MATERIAL_PLASTIC = 4 SHEETS)

/datum/design/item/medicalfab/meditools/scalpel
	build_path = /obj/item/weapon/scalpel
	materials = list(MATERIAL_STEEL = 1 SHEETS)

/datum/design/item/medicalfab/meditools/circularsaw
	build_path = /obj/item/weapon/circular_saw
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_COPPER = 0.5 SHEETS)

/datum/design/item/medicalfab/meditools/bonesetter
	build_path = /obj/item/weapon/bonesetter
	materials = list(MATERIAL_STEEL = 1 SHEETS)

/datum/design/item/medicalfab/meditools/surgicaldrill
	build_path = /obj/item/weapon/surgicaldrill
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_COPPER = 0.5 SHEETS)

/datum/design/item/medicalfab/meditools/retractor
	build_path = /obj/item/weapon/retractor
	materials = list(MATERIAL_STEEL = 1 SHEETS)

/datum/design/item/medicalfab/meditools/cautery
	build_path = /obj/item/weapon/cautery
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_COPPER = 0.5 SHEETS)

/datum/design/item/medicalfab/meditools/hemostat
	build_path = /obj/item/weapon/hemostat
	materials = list(MATERIAL_STEEL = 1 SHEETS)

/datum/design/item/medicalfab/meditools/virusdish
	build_path = /obj/item/weapon/virusdish
	materials = list(MATERIAL_GLASS = 0.25 SHEETS)

/datum/design/item/medicalfab/meditools/adv/bloodpack
	build_path = /obj/item/weapon/reagent_containers/ivbag
	materials = list(MATERIAL_PLASTIC = 0.25 SHEETS)

/datum/design/item/medicalfab/meditools/adv/syringe_cartridge
	build_path = /obj/item/weapon/syringe_cartridge
	materials = list(MATERIAL_STEEL = 0.1 SHEETS)
	research = "syringe_gun"
/datum/design/item/medicalfab/meditools/adv/syringe_gun
	build_path = /obj/item/weapon/gun/launcher/syringe
	materials = list(MATERIAL_STEEL = 5 SHEETS, MATERIAL_GLASS = 3 SHEETS, MATERIAL_COPPER = 2 SHEETS, MATERIAL_SILVER = 2 SHEETS)
	research = "syringe_gun"
/datum/design/item/medicalfab/meditools/adv/syringe_gun/rapid
	build_path = /obj/item/weapon/gun/launcher/syringe/rapid
	materials = list(MATERIAL_STEEL = 8 SHEETS, MATERIAL_GLASS = 5 SHEETS, MATERIAL_COPPER = 5 SHEETS, MATERIAL_SILVER = 5 SHEETS)
	research = "rapid_syringe_gun"





/datum/design/item/medicalfab/meditools/adv/FixOVein
	build_path = /obj/item/weapon/FixOVein
	materials = list(MATERIAL_CLOTH = 1 SHEETS, MATERIAL_GLASS = 1 SHEETS)
/datum/design/item/medicalfab/meditools/adv/bonegel
	build_path = /obj/item/weapon/bonegel
	materials = list(MATERIAL_CLOTH = 1 SHEETS, MATERIAL_GLASS = 1 SHEETS)


/datum/design/item/medicalfab/meditools/adv/hud
	materials = list(MATERIAL_STEEL = 0.25 SHEETS, MATERIAL_GLASS = 0.5 SHEETS)

/datum/design/item/medicalfab/meditools/adv/hud/AssembleDesignName()
	..()

/datum/design/item/medicalfab/meditools/adv/hud/AssembleDesignDesc()
	desc = "Allows for the construction of \a [item_name] HUD glasses."

/datum/design/item/medicalfab/meditools/adv/hud/health
	build_path = /obj/item/clothing/glasses/hud/health


/datum/design/item/medicalfab/meditools/healthscanner
	build_path = /obj/item/device/scanner/health
	materials = list(MATERIAL_STEEL = 3 SHEET, MATERIAL_GLASS = 0.5 SHEETS, MATERIAL_COPPER = 1 SHEETS)
	research = "health_scanner"

/datum/design/item/medicalfab/meditools/adv/robot_scanner
	materials = list(MATERIAL_STEEL = 3 SHEET, MATERIAL_GLASS = 0.5 SHEETS, MATERIAL_COPPER = 0.5 SHEETS)
	build_path = /obj/item/device/robotanalyzer


/datum/design/item/medicalfab/meditools/adv/mass_spectrometer
	build_path = /obj/item/device/scanner/spectrometer
	materials = list(MATERIAL_STEEL = 3 SHEET, MATERIAL_GLASS = 1 SHEETS, MATERIAL_COPPER = 2 SHEETS)
	research = "mass_spectrometer"


/datum/design/item/medicalfab/meditools/adv/adv_mass_spectrometer
	build_path = /obj/item/device/scanner/spectrometer/adv
	materials = list(MATERIAL_STEEL = 5 SHEET, MATERIAL_GLASS = 3 SHEETS, MATERIAL_SILVER = 5 SHEETS)
	research = "adv_mass_spectrometer"


/datum/design/item/medicalfab/meditools/adv/reagent_scanner
	build_path = /obj/item/device/scanner/reagent
	materials = list(MATERIAL_STEEL = 3 SHEET, MATERIAL_GLASS = 1 SHEETS, MATERIAL_COPPER = 2 SHEETS)
	research = "reagent_scanner"


/datum/design/item/medicalfab/meditools/adv/adv_reagent_scanner
	build_path = /obj/item/device/scanner/reagent/adv
	materials = list(MATERIAL_STEEL = 5 SHEET, MATERIAL_GLASS = 3 SHEETS, MATERIAL_SILVER = 5 SHEETS)
	research = "adv_reagent_scanner"


/datum/design/item/medicalfab/meditools/adv/slime_scanner
	build_path = /obj/item/device/scanner/xenobio
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_GLASS = 0.5 SHEETS, MATERIAL_COPPER = 0.5 SHEETS)


/datum/design/item/medicalfab/meditools/adv/scalpel_laser1
	name = "Basic Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks basic and could be improved."
	req_tech = list(TECH_BIO = 2, TECH_MATERIAL = 2, TECH_MAGNET = 2)
	build_path = /obj/item/weapon/scalpel/laser1
	research = "scalpel_1"


/datum/design/item/medicalfab/meditools/adv/scalpel_laser2
	name = "Improved Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks somewhat advanced."
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 4, TECH_MAGNET = 4)
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_GLASS = 3 SHEETS, MATERIAL_SILVER = 1 SHEETS)
	build_path = /obj/item/weapon/scalpel/laser2
	research = "scalpel_2"


/datum/design/item/medicalfab/meditools/adv/scalpel_laser3
	name = "Advanced Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks to be the pinnacle of precision energy cutlery!"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 6, TECH_MAGNET = 5)
	materials = list(MATERIAL_STEEL = 6 SHEETS, MATERIAL_GLASS = 5 SHEETS, MATERIAL_SILVER = 3 SHEETS, MATERIAL_DIAMOND = 1 SHEET)
	build_path = /obj/item/weapon/scalpel/laser3
	research = "scalpel_3"


/datum/design/item/medicalfab/meditools/adv/scalpel_manager
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 7, TECH_MAGNET = 5, TECH_DATA = 4)
	materials = list (MATERIAL_STEEL = 8 SHEET, MATERIAL_GLASS = 6 SHEET, MATERIAL_SILVER = 5 SHEET, MATERIAL_DIAMOND = 2 SHEET, MATERIAL_PHORON = 1 SHEET)
	build_path = /obj/item/weapon/scalpel/manager
	research = "scalpel_4"

/datum/design/item/medicalfab/meditools/adv/hypospray
	materials = list (MATERIAL_STEEL = 10 SHEET, MATERIAL_GLASS = 10 SHEET, MATERIAL_SILVER = 10 SHEET, MATERIAL_DIAMOND = 3 SHEET, MATERIAL_PHORON = 2 SHEET)
	build_path = /obj/item/weapon/reagent_containers/hypospray/vial
	research = "hypospray"

/datum/design/item/medicalfab/meditools/adv/defib
	name = "auto-resuscitator"
	req_tech = list(TECH_BIO = 5, TECH_ENGINEERING = 3, TECH_POWER = 4)
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_GLASS = 3 SHEETS, MATERIAL_GOLD = 2 SHEETS, MATERIAL_SILVER = 1 SHEET)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/weapon/defibrillator
	research = "defib"


/datum/design/item/medicalfab/meditools/adv/defib_compact
	name = "compact auto-resuscitator"
	req_tech = list(TECH_BIO = 5, TECH_ENGINEERING = 5, TECH_POWER = 6)
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_GLASS = 3 SHEETS, MATERIAL_GOLD = 3 SHEETS, MATERIAL_SILVER = 3 SHEETS, MATERIAL_PHORON = 2 SHEETS)
	chemicals = list(/datum/reagent/acid = 80)
	build_path = /obj/item/weapon/defibrillator/compact
	research = "defib_compact"


/datum/design/item/medicalfab/meditools/lmi
	name = "Lace-machine interface"
	id = "lmi"
	req_tech = list(TECH_DATA = 2, TECH_BIO = 3)
	materials = list(MATERIAL_STEEL = 0.5 SHEET, MATERIAL_GLASS = 0.5 SHEET)
	build_path = /obj/item/device/lmi


/datum/design/item/medicalfab/meditools/adv/lmi_radio
	name = "Radio-enabled lace-machine interface"
	id = "lmi_radio"
	req_tech = list(TECH_DATA = 2, TECH_BIO = 4)
	materials = list(MATERIAL_STEEL = 2 SHEET, MATERIAL_GLASS = 1 SHEET, MATERIAL_COPPER = 1 SHEET)
	build_path = /obj/item/device/lmi/radio_enabled


/datum/design/item/medicalfab/meditools/stethoscope
	name = "Stethoscope"
	materials = list(MATERIAL_STEEL = 0.5 SHEET)
	build_path = /obj/item/clothing/accessory/stethoscope


/datum/design/item/medicalfab/meditools/implants/tracking
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_SILVER = 2 SHEETS, MATERIAL_COPPER = 1 SHEETS, MATERIAL_PHORON = 0.5 SHEET)
	build_path = /obj/item/weapon/implant/tracking
	research = "implant_tracking"


/datum/design/item/medicalfab/meditools/implants/compressed
	materials = list(MATERIAL_STEEL = 4 SHEET, MATERIAL_SILVER = 8 SHEETS, MATERIAL_COPPER = 4 SHEETS, MATERIAL_PHORON = 5 SHEET, MATERIAL_URANIUM = 5 SHEET)
	build_path = /obj/item/weapon/implant/compressed
	research = "implant_compressed"


/datum/design/item/medicalfab/meditools/implants/biomonitor
	materials = list(MATERIAL_STEEL = 2 SHEET, MATERIAL_SILVER = 4 SHEETS, MATERIAL_COPPER = 2 SHEETS, MATERIAL_PHORON = 0.5 SHEET)
	build_path = /obj/item/weapon/implant/death_alarm/trauma
	research = "implant_biomonitor"


/datum/design/item/medicalfab/meditools/implants/adrenalin
	materials = list(MATERIAL_STEEL = 2 SHEET, MATERIAL_SILVER = 3 SHEETS, MATERIAL_COPPER = 2 SHEETS, MATERIAL_PHORON = 0.5 SHEET)
	build_path = /obj/item/weapon/implant/adrenalin
	research = "implant_adrenalin"


/datum/design/item/medicalfab/meditools/implants/chem
	materials = list(MATERIAL_STEEL = 2 SHEET, MATERIAL_SILVER = 3 SHEETS, MATERIAL_COPPER = 2 SHEETS, MATERIAL_PHORON = 0.5 SHEET)
	build_path = /obj/item/weapon/implant/chem
	research = "implant_chem"


/datum/design/item/medicalfab/meditools/implants/implantpad
	materials = list(MATERIAL_STEEL = 4 SHEET, MATERIAL_GLASS = 2 SHEET, MATERIAL_COPPER = 1 SHEETS)
	build_path = /obj/item/weapon/implantpad

/datum/design/item/medicalfab/meditools/implants/implanter
	materials = list(MATERIAL_STEEL = 3 SHEET, MATERIAL_COPPER = 2 SHEETS)
	build_path = /obj/item/weapon/implanter

/datum/design/item/medicalfab/meditools/implants/implantcase
	materials = list(MATERIAL_GLASS = 1 SHEET)
	build_path = /obj/item/weapon/implantcase

/datum/design/item/medicalfab/meditools/coffin
	build_path = /obj/structure/closet/coffin
	materials = list(MATERIAL_WOOD = 2 SHEETS, MATERIAL_CLOTH = 1 SHEET)


/datum/design/item/medicalfab/restaint
	category = "Restraints"

/datum/design/item/medicalfab/restaint/straitjacket
	name = "Straitjacket"
	id = "straitjacket"
	build_path = /obj/item/clothing/suit/straight_jacket
	materials = list(MATERIAL_LEATHER = 15 SHEETS)

/datum/design/item/medicalfab/restaint/muzzle
	name = "Muzzle"
	id = "muzzle"
	build_path = /obj/item/clothing/mask/muzzle
	materials = list("cloth" = 1000)

/datum/design/item/medicalfab/restaint/blindfold
	name = "Blindfold"
	id = "blindfold"
	build_path = /obj/item/clothing/glasses/sunglasses/blindfold
	materials = list("cloth" = 1000)

/datum/design/item/medicalfab/restraint/roller
	name = "Roller Bed"
	id = "roller bed"
	build_path = /obj/item/roller
	materials = list("cloth" = 4000, MATERIAL_ALUMINIUM = 4000)

/datum/design/item/medicalfab/restaint/facecover
	name = "Face cover"
	id = "facecover"
	build_path = /obj/item/clothing/head/helmet/facecover
	materials = list(MATERIAL_STEEL = 1000, "plastic" = 1000)


/datum/design/item/medicalfab/meditools/autocpr
	build_path = /obj/item/auto_cpr
	materials = list(MATERIAL_ALUMINIUM = 3 SHEET, MATERIAL_GLASS = 0.5 SHEETS, MATERIAL_COPPER = 1 SHEETS)

/datum/design/item/medicalfab/robotics/posibrain
	build_path = /obj/item/organ/internal/posibrain
	materials = list(MATERIAL_TITANIUM = 3 SHEET, MATERIAL_COPPER = 1 SHEETS, MATERIAL_DIAMOND = 5 SHEETS, MATERIAL_BSPACE_CRYSTAL = 1 SHEET)
/datum/design/item/medicalfab/robotics/mmi
	build_path = /obj/item/device/mmi
	materials = list(MATERIAL_ALUMINIUM = 3 SHEET, MATERIAL_COPPER = 2 SHEETS)
/datum/design/item/medicalfab/robotics/mmi_holder
	build_path = /obj/item/organ/internal/mmi_holder
	materials = list(MATERIAL_ALUMINIUM = 3 SHEET, MATERIAL_COPPER = 2 SHEETS)