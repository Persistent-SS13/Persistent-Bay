/obj/machinery/fabricator/storage_fabricator
	// Things that must be adjusted for each fabricator
	name = "Secure Storage Fabricator" // Self-explanatory
	desc = "A machine used for the production of crates, lockers and other storage items." // Self-explanatory
	circuit = /obj/item/weapon/circuitboard/fabricator/storagefab // Circuit for the machine. These, as well as their designs, should be defined in fabricator_circuits.dm
	build_type = STORAGEFAB // The identifer for what gets built in what fabricator. A new one *MUST* be defined in _defines/research.dm for each fabricator.
						 					 // More than one can be assigned per design, however, if you want something to be able to be built in more than one fabricator eg. Power Cells

	metal_load_anim = TRUE				// Determines if a sheet loading animation will be applied when loading metals. If you're using a non-standard icon and don't
										// want to sprite a new loading animation as well, set this to FALSE.

	has_reagents = FALSE				// Defaults to FALSE, but added here for explanation. If this is set to true, than you require designs to use reagents
										// in addition to any material costs.

/obj/machinery/fabricator/storage_fabricator/can_connect(var/datum/world_faction/trying, var/mob/M)
	if(M && !has_access(list(core_access_machine_linking), list(), M.GetAccess(trying.uid)))
		to_chat(M, "You do not have access to link machines to [trying.name].")
		return 0
	req_access_faction = trying.uid
	connected_faction = trying
	return 1

/obj/machinery/fabricator/storage_fabricator/can_disconnect(var/datum/world_faction/trying, var/mob/M)
	req_access_faction = ""
	connected_faction = null
	if(M) to_chat(M, "The machine has been disconnected.")

////////////////////////////////////////////////////
//////////////////////DESIGNS///////////////////////
////////////////////////////////////////////////////

/datum/design/item/storagefab
	build_type = STORAGEFAB	   // This must match the build_type of the fabricator(s)
	category = "Misc"	 			   // The design will appear under this in the UI. Each design must have a category, or it will not display properly.
	time = 10						   // Time in seconds for the item to be produced - This changes based off the components used in the fabricator

/datum/design/item/storagefab/crates
	category = "Crates"
	materials = list(MATERIAL_STEEL = 2 SHEETS)

/datum/design/item/storagefab/securecrates
	category = "Secure Crates"
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_COPPER = 1 SHEET)


/datum/design/item/storagefab/securecrates/crate
	build_path = /obj/structure/closet/crate/secure

/datum/design/item/storagefab/securecrates/weapon
	build_path = /obj/structure/closet/crate/secure/weapon

/datum/design/item/storagefab/securecrates/phoron
	build_path = /obj/structure/closet/crate/secure/phoron

/datum/design/item/storagefab/securecrates/gear
	build_path = /obj/structure/closet/crate/secure/gear

/datum/design/item/storagefab/securecrates/crate
	build_path = /obj/structure/closet/crate/secure/hydrosec

/datum/design/item/storagefab/securecrates/bin
	build_path = /obj/structure/closet/crate/secure/bin

/datum/design/item/storagefab/securecrates/large
	build_path = /obj/structure/closet/crate/secure/large
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_COPPER = 1 SHEET)

/datum/design/item/storagefab/securecrates/large/phoron
	build_path = /obj/structure/closet/crate/secure/large/phoron

/datum/design/item/storagefab/securecrates/large/reinforced
	build_path = /obj/structure/closet/crate/secure/large/reinforced

/datum/design/item/storagefab/securecrates/biohazard
	build_path = /obj/structure/closet/crate/secure/biohazard



/datum/design/item/storagefab/crates/crate
	build_path = /obj/structure/closet/crate

/datum/design/item/storagefab/crates/trashcart
	build_path = /obj/structure/closet/crate/trashcart

/datum/design/item/storagefab/crates/medical
	build_path = /obj/structure/closet/crate/medical

/datum/design/item/storagefab/crates/freezer
	build_path = /obj/structure/closet/crate/freezer

/datum/design/item/storagefab/crates/bin
	build_path = /obj/structure/closet/crate/bin

/datum/design/item/storagefab/crates/plastic
	build_path = /obj/structure/closet/crate/plastic
	materials = list(MATERIAL_PLASTIC = 2 SHEETS)

/datum/design/item/storagefab/crates/internals
	build_path = /obj/structure/closet/crate/internals

/datum/design/item/storagefab/crates/radiation
	build_path = /obj/structure/closet/crate/radiation

/datum/design/item/storagefab/crates/large
	build_path = /obj/structure/closet/crate/large
	materials = list(MATERIAL_STEEL = 3 SHEETS)

/datum/design/item/storagefab/crates/large/hydroponics
	build_path = /obj/structure/closet/crate/large/hydroponics

/datum/design/item/storagefab/crates/hydroponics
	build_path = /obj/structure/closet/crate/hydroponics

/datum/design/item/storagefab/lockers
	category = "Lockers"
	materials = list(MATERIAL_STEEL = 2 SHEETS)

/datum/design/item/storagefab/lockers/secure
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_COPPER = 1 SHEET)
	category = "Secure Lockers"
/datum/design/item/storagefab/lockers/locker
	build_path = /obj/structure/closet

/datum/design/item/storagefab/lockers/emcloset
	build_path = /obj/structure/closet/emcloset

/datum/design/item/storagefab/lockers/firecloset
	build_path = /obj/structure/closet/firecloset

/datum/design/item/storagefab/lockers/toolcloset
	build_path = /obj/structure/closet/toolcloset

/datum/design/item/storagefab/lockers/radiation
	build_path = /obj/structure/closet/radiation

/datum/design/item/storagefab/lockers/bombcloset
	build_path = /obj/structure/closet/bombcloset

/datum/design/item/storagefab/lockers/secure/chiefengineer
	build_path = /obj/structure/closet/secure_closet/empty/engineering_chief


/datum/design/item/storagefab/lockers/secure/electrical
	build_path = /obj/structure/closet/secure_closet/empty/engineering_electrical

/datum/design/item/storagefab/lockers/secure/welding
	build_path = /obj/structure/closet/secure_closet/empty/engineering_welding

/datum/design/item/storagefab/lockers/secure/engineer
	build_path = /obj/structure/closet/secure_closet/empty/engineering_personal


/datum/design/item/storagefab/lockers/secure/atmos
	build_path = /obj/structure/closet/secure_closet/empty/atmos_personal

/datum/design/item/storagefab/lockers/secure/miner
	build_path = /obj/structure/closet/secure_closet/empty/miner

/datum/design/item/storagefab/lockers/secure/captains
	build_path = /obj/structure/closet/secure_closet/empty/captains

/datum/design/item/storagefab/lockers/secure/hop
	build_path = /obj/structure/closet/secure_closet/empty/hop

/datum/design/item/storagefab/lockers/secure/hos
	build_path = /obj/structure/closet/secure_closet/empty/hos

/datum/design/item/storagefab/lockers/secure/warden
	build_path = /obj/structure/closet/secure_closet/empty/warden

/datum/design/item/storagefab/lockers/secure/security
	build_path = /obj/structure/closet/secure_closet/empty/security

/datum/design/item/storagefab/lockers/secure/scientist
	build_path = /obj/structure/closet/secure_closet/empty/scientist

/datum/design/item/storagefab/lockers/secure/rd
	build_path = /obj/structure/closet/secure_closet/empty/RD

/datum/design/item/storagefab/lockers/secure/hop
	build_path = /obj/structure/closet/secure_closet/empty/hop

/datum/design/item/storagefab/lockers/secure/medical
	build_path = /obj/structure/closet/secure_closet/empty/medical1

/datum/design/item/storagefab/lockers/secure/doctor
	build_path = /obj/structure/closet/secure_closet/empty/medical3

/datum/design/item/storagefab/lockers/secure/cmo
	build_path = /obj/structure/closet/secure_closet/empty/CMO

/datum/design/item/storagefab/lockers/secure/virology
	build_path = /obj/structure/closet/secure_closet/empty/virology

/datum/design/item/storagefab/lockers/secure/hydroponics
	build_path = /obj/structure/closet/secure_closet/empty/hydroponics

/datum/design/item/storagefab/lockers/secure/freezer
	build_path = /obj/structure/closet/secure_closet/freezer/kitchen

/datum/design/item/storagefab/lockers/secure/cargo
	build_path = /obj/structure/closet/secure_closet/empty/cargotech

/datum/design/item/storagefab/lockers/secure/qm
	build_path = /obj/structure/closet/secure_closet/empty/quartermaster









