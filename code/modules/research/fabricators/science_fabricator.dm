/obj/machinery/fabricator/science_fabricator
	// Things that must be adjusted for each fabricator
	name = "Science Fabricator" // Self-explanatory
	desc = "A machine used for the production of robotics and science equipment." // Self-explanatory
	circuit_type = /obj/item/weapon/circuitboard/fabricator/sciencefab // Circuit for the machine. These, as well as their designs, should be defined in fabricator_circuits.dm
	build_type = SCIENCEFAB // The identifer for what gets built in what fabricator. A new one *MUST* be defined in _defines/research.dm for each fabricator.
						 					 // More than one can be assigned per design, however, if you want something to be able to be built in more than one fabricator eg. Power Cells

/obj/machinery/fabricator/science_fabricator/can_connect(var/datum/world_faction/trying, var/mob/M)
	req_access_faction = trying.uid
	connected_faction = src
	return 1
/obj/machinery/fabricator/science_fabricator/can_disconnect(var/datum/world_faction/trying, var/mob/M)
	req_access_faction = ""
	connected_faction = null
	if(M) to_chat(M, "The machine has been disconnected.")

////////////////////////////////////////////////////
//////////////////////DESIGNS///////////////////////
////////////////////////////////////////////////////

//sciences
/datum/design/item/sciencefab
	build_type = SCIENCEFAB		   // This must match the build_type of the fabricator(s)
	category = "Misc"	 			   // The design will appear under this in the UI. Each design must have a category, or it will not display properly.
	req_tech = list(TECH_MATERIAL = 1) // The tech required for the design. Note that anything above 1 for *ANY* tech will require a RnD console for the item to be
									   // fabricated.

	time = 50						   // Time in seconds for the item to be produced - This changes based off the components used in the fabricator

/datum/design/item/sciencefab/robotics
	category = "Robotics"
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_GLASS = 2 SHEETS, MATERIAL_COPPER = 4 SHEETS)

/datum/design/item/sciencefab/robotics/l_arm/nanotrasen 
	build_path = /obj/item/robot_parts/l_arm/nanotrasen
	
/datum/design/item/sciencefab/robotics/l_arm/morpheus 
	build_path = /obj/item/robot_parts/l_arm/morpheus
	
/datum/design/item/sciencefab/robotics/l_arm/bishop 
	build_path = /obj/item/robot_parts/l_arm/bishop
	
/datum/design/item/sciencefab/robotics/l_arm/hephaestus 
	build_path = /obj/item/robot_parts/l_arm/hephaestus

/datum/design/item/sciencefab/robotics/l_arm/zenghu 
	build_path = /obj/item/robot_parts/l_arm/zenghu

/datum/design/item/sciencefab/robotics/l_arm/xion 
	build_path = /obj/item/robot_parts/l_arm/xion

/datum/design/item/sciencefab/robotics/l_arm/wardtakahshi 
	build_path = /obj/item/robot_parts/l_arm/wardtakahshi

/datum/design/item/sciencefab/robotics/l_arm/veymed 
	build_path = /obj/item/robot_parts/l_arm/veymed

/datum/design/item/sciencefab/robotics/l_arm/grayson 
	build_path = /obj/item/robot_parts/l_arm/grayson


/datum/design/item/sciencefab/robotics/r_arm/nanotrasen 
	build_path = /obj/item/robot_parts/r_arm/nanotrasen
	
/datum/design/item/sciencefab/robotics/r_arm/morpheus 
	build_path = /obj/item/robot_parts/r_arm/morpheus
	
/datum/design/item/sciencefab/robotics/r_arm/bishop 
	build_path = /obj/item/robot_parts/r_arm/bishop
	
/datum/design/item/sciencefab/robotics/r_arm/hephaestus 
	build_path = /obj/item/robot_parts/r_arm/hephaestus

/datum/design/item/sciencefab/robotics/r_arm/zenghu 
	build_path = /obj/item/robot_parts/r_arm/zenghu

/datum/design/item/sciencefab/robotics/r_arm/xion 
	build_path = /obj/item/robot_parts/r_arm/xion

/datum/design/item/sciencefab/robotics/r_arm/wardtakahshi 
	build_path = /obj/item/robot_parts/r_arm/wardtakahshi

/datum/design/item/sciencefab/robotics/r_arm/veymed 
	build_path = /obj/item/robot_parts/r_arm/veymed

/datum/design/item/sciencefab/robotics/r_arm/grayson 
	build_path = /obj/item/robot_parts/r_arm/grayson



/datum/design/item/sciencefab/robotics/l_leg/nanotrasen 
	build_path = /obj/item/robot_parts/l_leg/nanotrasen
	
/datum/design/item/sciencefab/robotics/l_leg/morpheus 
	build_path = /obj/item/robot_parts/l_leg/morpheus
	
/datum/design/item/sciencefab/robotics/l_leg/bishop 
	build_path = /obj/item/robot_parts/l_leg/bishop
	
/datum/design/item/sciencefab/robotics/l_leg/hephaestus 
	build_path = /obj/item/robot_parts/l_leg/hephaestus

/datum/design/item/sciencefab/robotics/l_leg/zenghu 
	build_path = /obj/item/robot_parts/l_leg/zenghu

/datum/design/item/sciencefab/robotics/l_leg/xion 
	build_path = /obj/item/robot_parts/l_leg/xion

/datum/design/item/sciencefab/robotics/l_leg/wardtakahshi 
	build_path = /obj/item/robot_parts/l_leg/wardtakahshi

/datum/design/item/sciencefab/robotics/l_leg/veymed 
	build_path = /obj/item/robot_parts/l_leg/veymed

/datum/design/item/sciencefab/robotics/l_leg/grayson 
	build_path = /obj/item/robot_parts/l_leg/grayson



/datum/design/item/sciencefab/robotics/r_leg/nanotrasen 
	build_path = /obj/item/robot_parts/r_leg/nanotrasen
	
/datum/design/item/sciencefab/robotics/r_leg/morpheus 
	build_path = /obj/item/robot_parts/r_leg/morpheus
	
/datum/design/item/sciencefab/robotics/r_leg/bishop 
	build_path = /obj/item/robot_parts/r_leg/bishop
	
/datum/design/item/sciencefab/robotics/r_leg/hephaestus 
	build_path = /obj/item/robot_parts/r_leg/hephaestus

/datum/design/item/sciencefab/robotics/r_leg/zenghu 
	build_path = /obj/item/robot_parts/r_leg/zenghu

/datum/design/item/sciencefab/robotics/r_leg/xion 
	build_path = /obj/item/robot_parts/r_leg/xion

/datum/design/item/sciencefab/robotics/r_leg/wardtakahshi 
	build_path = /obj/item/robot_parts/r_leg/wardtakahshi

/datum/design/item/sciencefab/robotics/r_leg/veymed 
	build_path = /obj/item/robot_parts/r_leg/veymed

/datum/design/item/sciencefab/robotics/r_leg/grayson 
	build_path = /obj/item/robot_parts/r_leg/grayson



/datum/design/item/sciencefab/robotics/head/nanotrasen 
	build_path = /obj/item/robot_parts/head/nanotrasen
	
/datum/design/item/sciencefab/robotics/head/morpheus 
	build_path = /obj/item/robot_parts/head/morpheus
	
/datum/design/item/sciencefab/robotics/head/bishop 
	build_path = /obj/item/robot_parts/head/bishop
	
/datum/design/item/sciencefab/robotics/head/hephaestus 
	build_path = /obj/item/robot_parts/head/hephaestus

/datum/design/item/sciencefab/robotics/head/zenghu 
	build_path = /obj/item/robot_parts/head/zenghu

/datum/design/item/sciencefab/robotics/head/xion 
	build_path = /obj/item/robot_parts/head/xion

/datum/design/item/sciencefab/robotics/head/wardtakahshi 
	build_path = /obj/item/robot_parts/head/wardtakahshi

/datum/design/item/sciencefab/robotics/head/veymed 
	build_path = /obj/item/robot_parts/head/veymed

/datum/design/item/sciencefab/robotics/head/grayson 
	build_path = /obj/item/robot_parts/head/grayson


/datum/design/item/sciencefab/robotics/chest/nanotrasen 
	build_path = /obj/item/robot_parts/chest/nanotrasen
	
/datum/design/item/sciencefab/robotics/chest/morpheus 
	build_path = /obj/item/robot_parts/chest/morpheus
	
/datum/design/item/sciencefab/robotics/chest/bishop 
	build_path = /obj/item/robot_parts/chest/bishop
	
/datum/design/item/sciencefab/robotics/chest/hephaestus 
	build_path = /obj/item/robot_parts/chest/hephaestus

/datum/design/item/sciencefab/robotics/chest/zenghu 
	build_path = /obj/item/robot_parts/chest/zenghu

/datum/design/item/sciencefab/robotics/chest/xion 
	build_path = /obj/item/robot_parts/chest/xion

/datum/design/item/sciencefab/robotics/chest/wardtakahshi 
	build_path = /obj/item/robot_parts/chest/wardtakahshi

/datum/design/item/sciencefab/robotics/chest/veymed 
	build_path = /obj/item/robot_parts/chest/veymed

/datum/design/item/sciencefab/robotics/chest/grayson 
	build_path = /obj/item/robot_parts/chest/grayson

/datum/design/item/sciencefab/Tools
	category = "Tools"
	time = 15

/datum/design/item/sciencefab/Tools/nanopaste
	materials = list(MATERIAL_STEEL = 5 SHEETS, MATERIAL_GLASS = 5 SHEETS)
	build_path = /obj/item/stack/nanopaste
	research = "nanopaste"

/datum/design/item/sciencefab/Tools/flash
	build_path = /obj/item/device/flash
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_COPPER = 2 SHEET, MATERIAL_GOLD = 0.5 SHEET)

/datum/design/item/sciencefab/Handling
	category = "Handling"
	time = 15

/datum/design/item/sciencefab/Handling/coolingunit
	name = "personal cooling unit"
	build_path = /obj/item/device/suit_cooling_unit
	materials = list(MATERIAL_ALUMINIUM = 3, MATERIAL_GLASS = 2)

/datum/design/item/sciencefab/Handling/robot_scanner
	materials = list(MATERIAL_STEEL = 3 SHEET, MATERIAL_GLASS = 0.5 SHEETS, MATERIAL_COPPER = 0.5 SHEETS)
	build_path = /obj/item/device/robotanalyzer