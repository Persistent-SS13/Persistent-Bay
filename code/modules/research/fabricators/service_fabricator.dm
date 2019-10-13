/obj/machinery/fabricator/service_fabricator
	// Things that must be adjusted for each fabricator
	name = "Service Equipment Fabricator" // Self-explanatory
	desc = "A machine used for the production of voidsuits and other spacesuits, plus equipment for mining and salvage." // Self-explanatory
	circuit_type = /obj/item/weapon/circuitboard/fabricator/servicefab // Circuit for the machine. These, as well as their designs, should be defined in fabricator_circuits.dm
	build_type = SERVICEFAB // The identifer for what gets built in what fabricator. A new one *MUST* be defined in _defines/research.dm for each fabricator.
						 					 // More than one can be assigned per design, however, if you want something to be able to be built in more than one fabricator eg. Power Cells
	metal_load_anim = TRUE				// Determines if a sheet loading animation will be applied when loading metals. If you're using a non-standard icon and don't
										// want to sprite a new loading animation as well, set this to FALSE.

	has_reagents = FALSE				// Defaults to FALSE, but added here for explanation. If this is set to true, than you require designs to use reagents
										// in addition to any material costs.

/obj/machinery/fabricator/service_fabricator/can_connect(var/datum/world_faction/trying, var/mob/M)
	var/datum/machine_limits/limits = trying.get_limits()
	if(M && !has_access(list(core_access_machine_linking), list(), M.GetAccess(trying.uid)))
		to_chat(M, "You do not have access to link machines to [trying.name].")
		return 0
	if(limits.limit_servicefab <= limits.servicefabs.len)
		if(M)
			to_chat(M, "[trying.name] cannot connect any more machines of this type.")
		return 0
	limits.servicefabs |= src
	req_access_faction = trying.uid
	connected_faction = trying

/obj/machinery/fabricator/service_fabricator/can_disconnect(var/datum/world_faction/trying, var/mob/M)
	var/datum/machine_limits/limits = trying.get_limits()
	if(limits)
		limits.servicefabs -= src
	req_access_faction = ""
	connected_faction = null
	if(M) to_chat(M, "The machine has been disconnected.")

////////////////////////////////////////////////////
//////////////////////DESIGNS///////////////////////
////////////////////////////////////////////////////

//Voidsuits
/datum/design/item/servicefab
	build_type = SERVICEFAB 			   // This must match the build_type of the fabricator(s)
	category = "Misc"	 			   // The design will appear under this in the UI. Each design must have a category, or it will not display properly.
	req_tech = list(TECH_MATERIAL = 1) // The tech required for the design. Note that anything above 1 for *ANY* tech will require a RnD console for the item to be
									   // fabricated.
	time = 5						   // Time in seconds for the item to be produced - This changes based off the components used in the fabricator



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Botany Tools

/datum/design/item/servicefab/botanytools
	category = "Botany Tools"


/////////////////////////////////////////////////////////////////////////////////////

/datum/design/item/servicefab/botanytools/hatchet
	name = "hatchet"
	build_path = /obj/item/weapon/material/hatchet
	materials = list(MATERIAL_STEEL = 3 SHEET)

/datum/design/item/servicefab/botanytools/minihoe
	name = "mini hoe"
	build_path = /obj/item/weapon/material/minihoe
	materials = list(MATERIAL_STEEL = 0.75 SHEET)

/datum/design/item/servicefab/botanytools/plant_scanner
	name = "plant scanner"
	build_path = /obj/item/device/scanner/plant
	materials = list(MATERIAL_ALUMINIUM = 0.5 SHEET, MATERIAL_COPPER = 0.5 SHEET, MATERIAL_GLASS = 0.5 SHEET)

/datum/design/item/servicefab/botanytools/plantbgone
	name = "Plant-B-Gone (empty)"
	build_path = /obj/item/weapon/reagent_containers/spray/plantbgone
	materials = list(MATERIAL_GLASS = 0.1 SHEET)

/datum/design/item/servicefab/botanytools/scythe
	build_path = /obj/item/weapon/material/scythe
	materials = list(MATERIAL_STEEL = 3 SHEET, MATERIAL_WOOD = 2 SHEET)

/datum/design/item/servicefab/botanytools/tray // tier 2
	materials = list(MATERIAL_STEEL = 8 SHEETS, MATERIAL_GLASS = 5 SHEETS, MATERIAL_COPPER = 1 SHEET)
	build_path = /obj/machinery/portable_atmospherics/hydroponics

/datum/design/item/servicefab/botanytools/flora_gun // tier 2
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_POWER = 3)
	materials = list(MATERIAL_STEEL = 8 SHEET, MATERIAL_GLASS = 5 SHEETS, MATERIAL_URANIUM = 4 SHEETS)
	build_path = /obj/item/weapon/gun/energy/floragun
	research = "floragun"
/datum/design/item/servicefab/botanytools/weedspray
	build_path = /obj/item/weapon/plantspray/weeds
	materials = list(MATERIAL_PLASTIC = 1 SHEET, MATERIAL_SILVER = 0.25 SHEETS)
/datum/design/item/servicefab/botanytools/pestspray
	build_path = /obj/item/weapon/plantspray/pests
	materials = list(MATERIAL_PLASTIC = 1 SHEET, MATERIAL_SILVER = 0.25 SHEETS)

/datum/design/item/servicefab/botanytools/clippers
	build_path = /obj/item/weapon/tool/wirecutters/clippers
	materials = list(MATERIAL_STEEL = 1 SHEET)
	
/datum/design/item/servicefab/botanytools/beehiveassembly
	build_path = /obj/item/beehive_assembly
	materials = list(MATERIAL_WOOD = 4 SHEET)

/datum/design/item/servicefab/botanytools/beesmoker
	build_path = /obj/item/bee_smoker
	materials = list(MATERIAL_STEEL = 2 SHEET)
	
/datum/design/item/servicefab/botanytools/beeframe
	build_path = /obj/item/honey_frame
	materials = list(MATERIAL_WOOD = 1 SHEET)

/datum/design/item/servicefab/botanytools/disks
	build_path = /obj/item/weapon/disk/botany
	materials = list(MATERIAL_PLASTIC = 0.05 SHEET, MATERIAL_ALUMINIUM = 0.05 SHEET, MATERIAL_COPPER = 0.05 SHEET)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Culinary Tools

/datum/design/item/servicefab/culinarytools
	category = "Culinary Tools"

/////////////////////////////////////////////////////////////////////////////////////

/datum/design/item/servicefab/culinarytools/knife
	name = "kitchen knife"
	build_path = /obj/item/weapon/material/knife
	materials = list(MATERIAL_STEEL = 2 SHEET)
/datum/design/item/servicefab/culinarytools/butch
	name = "butcher knife"
	build_path = /obj/item/weapon/material/knife/kitchen/cleaver
	materials = list(MATERIAL_STEEL = 2.5 SHEET)
/datum/design/item/servicefab/culinarytools/utensil_knife
	name = "dining knife"
	build_path = /obj/item/weapon/material/kitchen/utensil/knife
	materials = list(MATERIAL_STEEL = 0.1 SHEET)
/datum/design/item/servicefab/culinarytools/utensil_fork
	name = "dining fork"
	build_path = /obj/item/weapon/material/kitchen/utensil/fork
	materials = list(MATERIAL_STEEL = 0.1 SHEET)
/datum/design/item/servicefab/culinarytools/utensil_spoon
	name = "dining spoon"
	build_path = /obj/item/weapon/material/kitchen/utensil/spoon
	materials = list(MATERIAL_STEEL = 0.1 SHEET)

/datum/design/item/servicefab/culinarytools/utensil_fork_plastic
	name = "plastic dining fork"
	build_path 	= /obj/item/weapon/material/kitchen/utensil/fork/plastic
	materials = list(MATERIAL_PLASTIC = 0.1 SHEET)
/datum/design/item/servicefab/culinarytools/utensil_knife_plastic
	name = "plastic dining knife"
	build_path = /obj/item/weapon/material/kitchen/utensil/knife/plastic
	materials = list(MATERIAL_PLASTIC = 0.1 SHEET)

/datum/design/item/servicefab/culinarytools/mixsstick
	name = "mixing stick"
	build_path = /obj/item/weapon/glass_extra/stick
	materials = list(MATERIAL_WOOD = 0.01 SHEET)

/datum/design/item/servicefab/culinarytools/straw
	name = "drink straw"
	build_path = /obj/item/weapon/glass_extra/straw
	materials = list(MATERIAL_PLASTIC = 0.01 SHEET)


/datum/design/item/servicefab/culinarytools/utensil_spoon_plastic
	name = "plastic dining spoon"
	build_path = /obj/item/weapon/material/kitchen/utensil/spoon/plastic
	materials = list(MATERIAL_PLASTIC = 0.1 SHEET)

/datum/design/item/servicefab/culinarytools/tray
	name = "tray"
	build_path = /obj/item/weapon/tray
	materials = list(MATERIAL_STEEL = 0.5 SHEET)

/datum/design/item/servicefab/culinarytools/rollingpin
	name = "rolling pin"
	build_path = /obj/item/weapon/material/kitchen/rollingpin
	materials = list(MATERIAL_WOOD = 0.5 SHEET)

/datum/design/item/servicefab/culinarytools/bowl
	name = "mixing bowl"
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/bowl
	materials = list(MATERIAL_GLASS = 0.5 SHEET)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/design/item/servicefab/botanytools/honey_extractor
	name = "honey extractor"
	build_path = /obj/item/weapon/circuitboard/honey_extractor
	materials = list(MATERIAL_COPPER = 1250, MATERIAL_GLASS = 1500)

/datum/design/item/servicefab/botanytools/reagent_heater
	name = "chemical heating system"
	id = "chemheater"
	build_path = /obj/item/weapon/circuitboard/reagent_heater
	materials = list(MATERIAL_COPPER = 1250, MATERIAL_GLASS = 1500)

/datum/design/item/servicefab/botanytools/reagent_cooler
	name = "chemical cooling system"
	id = "chemcooler"
	build_path = /obj/item/weapon/circuitboard/reagent_heater/cooler
	materials = list(MATERIAL_COPPER = 1250, MATERIAL_GLASS = 1500)

/datum/design/item/servicefab/culinarytools/icecream_vat
	name = "icecream vat"
	build_path = /obj/machinery/icecream_vat
	materials = list(MATERIAL_COPPER = 1250, MATERIAL_GLASS = 1500)