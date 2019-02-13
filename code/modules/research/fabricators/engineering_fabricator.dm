/obj/machinery/fabricator/engineering_fabricator
	// Things that must be adjusted for each fabricator
	name = "Engineering Equipment Fabricator" // Self-explanatory
	desc = "A machine used for the production of engineering equipment." // Self-explanatory
	circuit = /obj/item/weapon/circuitboard/fabricator/engfab // Circuit for the machine. These, as well as their designs, should be defined in fabricator_circuits.dm
	build_type = ENGIFAB // The identifer for what gets built in what fabricator. A new one *MUST* be defined in _defines/research.dm for each fabricator.
						  // More than one can be assigned per design, however, if you want something to be able to be built in more than one fabricator eg. Power Cells
	metal_load_anim = TRUE				// Determines if a sheet loading animation will be applied when loading metals. If you're using a non-standard icon and don't
										// want to sprite a new loading animation as well, set this to FALSE.

	has_reagents = TRUE				// Defaults to FALSE, but added here for explanation. If this is set to true, than you require designs to use reagents


/obj/machinery/fabricator/engineering_fabricator/can_connect(var/datum/world_faction/trying, var/mob/M)
	if(!trying.limits) return 0
	if(M && !has_access(list(core_access_machine_linking), list(), M.GetAccess(req_access_faction)))
		to_chat(M, "You do not have access to link machines to [trying.name].")
		return 0
	if(trying.limits.limit_engfab <= trying.limits.engfabs.len)
		if(M)
			to_chat(M, "[trying.name] cannot connect any more machines of this type.")
		return 0
	trying.limits.engfabs |= src
	req_access_faction = trying.uid
	connected_faction = src
	
/obj/machinery/fabricator/engineering_fabricator/can_disconnect(var/datum/world_faction/trying, var/mob/M)
	if(!trying.limits) return 0
	trying.limits.engfabs -= src
	req_access_faction = ""
	connected_faction = null
	if(M) to_chat(M, "The machine has been disconnected.")

										// in addition to any material costs.
////////////////////////////////////////////////////
//////////////////////DESIGNS///////////////////////
////////////////////////////////////////////////////

/datum/design/item/engifab
	build_type = ENGIFAB 			   // This must match the build_type of the fabricator(s)
	category = "Misc"	 			   // The design will appear under this in the UI. Each design must have a category, or it will not display properly.
	time = 10	// Time in seconds for the item to be produced - This changes based off the components used in the fabricator

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ENGINEERING EQUIPMENT

/datum/design/item/engifab/engitools
	category = "Engineering Equipment"
	time = 10

/datum/design/item/engifab/engitools/simple
	build_type = list(ENGIFAB, GENERALFAB)

/datum/design/item/engifab/engitools/adv


/////////////////////////////////////////////////////////////////////////////////////////////

/datum/design/item/engifab/engitools/adv/analyzer
	name = "Gas Analyzer"
	build_path = /obj/item/device/analyzer
	materials = list(MATERIAL_STEEL = 0.25 SHEETS, MATERIAL_GLASS = 0.25 SHEETS, MATERIAL_COPPER = 0.25 SHEETS)

/datum/design/item/engifab/engitools/adv/geiger
	name = "Geiger Counter"
	build_path = /obj/item/device/geiger
	materials = list(MATERIAL_STEEL = 0.25 SHEETS, MATERIAL_GLASS = 0.25 SHEETS, MATERIAL_COPPER = 0.25 SHEETS)

/datum/design/item/engifab/engitools/adv/floor_painter
	name = "Floor Painter"
	build_path = /obj/item/device/floor_painter
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_COPPER = 1 SHEETS)

/datum/design/item/engifab/engitools/pipe_painter
	name = "Pipe Painter"
	build_path = /obj/item/device/pipe_painter
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_COPPER = 1 SHEET)


/datum/design/item/engifab/engitools/t_scanner
	name = "T-ray Scanner"
	build_path = /obj/item/device/t_scanner
	materials = list(MATERIAL_STEEL = 0.5 SHEETS)

/datum/design/item/engifab/engitools/simple/flashlight
	name = "Flashlight"
	build_path = /obj/item/device/flashlight
	materials = list(MATERIAL_STEEL = 0.5 SHEETS, MATERIAL_GLASS = 0.25 SHEETS)


/datum/design/item/engifab/engitools/simple/tape_roll
	name = "Tape Roll"
	build_path = /obj/item/weapon/tape_roll
	materials = list(MATERIAL_PLASTIC = 8 SHEET) // ADJUST MATERIALS

/datum/design/item/engifab/engitools/simple/cone
	name = "warning cone"
	build_path = /obj/item/weapon/caution/cone
	materials = list(MATERIAL_PLASTIC = 1 SHEET) // ADJUST MATERIALS



/datum/design/item/engifab/engitools/maglight
	name = "Maglight"
	build_path = /obj/item/device/flashlight/maglight
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_GLASS = 0.5 SHEETS)

/datum/design/item/engifab/engitools/simple/crowbar
	name = "Crowbar"
	build_path = /obj/item/weapon/crowbar
	materials = list(MATERIAL_STEEL = 0.5 SHEETS)

/datum/design/item/engifab/engitools/prybar
	name = "Pry bar"
	build_path = /obj/item/weapon/crowbar/prybar
	materials = list(MATERIAL_STEEL = 0.5 SHEETS)

/datum/design/item/engifab/engitools/multitool
	name = "Multitool"
	id = "multitool"
	build_path = /obj/item/device/multitool
	materials = list(MATERIAL_STEEL = 1 SHEETS, MATERIAL_GLASS = 1 SHEETS, MATERIAL_COPPER = 0.5 SHEETS)

/datum/design/item/engifab/engitools/simple/screwdriver
	name = "Screwdriver"
	id = "screwdriver"
	build_path = /obj/item/weapon/screwdriver
	materials = list(MATERIAL_STEEL = 0.25 SHEETS)

/datum/design/item/engifab/engitools/simple/wirecutters
	name = "Wirecutters"
	id = "wirecutters"
	build_path = /obj/item/weapon/wirecutters
	materials = list(MATERIAL_STEEL = 0.25 SHEETS)

/datum/design/item/engifab/engitools/simple/wrench
	name = "Wrench"
	id = "wrench"
	build_path = /obj/item/weapon/wrench
	materials = list(MATERIAL_STEEL = 0.25 SHEETS)

/datum/design/item/engifab/engitools/suit_cooler
	name = "Suit cooling unit"
	build_path = /obj/item/device/suit_cooling_unit
	materials = list(MATERIAL_STEEL = 8 SHEETS, MATERIAL_GLASS = 3 SHEETS)

/datum/design/item/engifab/engitools/simple/weldermask
	name = "Welding mask"
	build_path = /obj/item/clothing/head/welding
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_GLASS = 1 SHEET)

/datum/design/item/engifab/engitools/fireaxe
	build_path = /obj/item/weapon/material/twohanded/fireaxe
	materials = list(MATERIAL_STEEL = 5 SHEET, MATERIAL_WOOD = 2 SHEET)	

/datum/design/item/engifab/engitools/inflatabledoor
	build_path = /obj/item/inflatable/door
	materials = list(MATERIAL_PLASTIC = 3 SHEET)	

/datum/design/item/engifab/engitools/inflatablewall
	build_path = /obj/item/inflatable/wall
	materials = list(MATERIAL_PLASTIC = 2 SHEET)	


/datum/design/item/engifab/engitools/rcd
	name = "Rapid Construction Device"
	build_path = /obj/item/weapon/rcd
	materials = list(MATERIAL_STEEL = 15 SHEETS, MATERIAL_GLASS = 5 SHEETS, MATERIAL_GOLD = 5 SHEETS, MATERIAL_SILVER = 5 SHEETS, MATERIAL_PHORON = 5 SHEETS, MATERIAL_DIAMOND = 5 SHEETS)

/datum/design/item/engifab/engitools/combitool
	name = "Combitool"
	build_path = /obj/item/weapon/combitool
	materials = list(MATERIAL_STEEL = 8 SHEETS, MATERIAL_GLASS = 2 SHEETS, MATERIAL_GOLD = 1 SHEETS, MATERIAL_SILVER = 1 SHEETS)


/datum/design/item/engifab/engitools/rcd_ammo
	name = "Matter Cartridge"
	build_path = /obj/item/weapon/rcd_ammo
	materials = list(MATERIAL_STEEL = 5 SHEETS, MATERIAL_GLASS = 2 SHEETS)

/datum/design/item/engifab/engitools/rcd_ammo_large
	name = "High-capacity matter cartridge"
	build_path = /obj/item/weapon/rcd_ammo/large
	materials = list(MATERIAL_STEEL = 15 SHEETS, MATERIAL_GLASS = 10 SHEETS)

/datum/design/item/engifab/engitools/simple/cable_coil
	name = "Cable coil"
	build_path = /obj/item/stack/cable_coil/single		//must be /single path, else printing 1x will instead print a whole stack
	materials = list(MATERIAL_COPPER = 0.04 SHEETS)

/datum/design/item/engifab/engitools/weldinggoggles
	name = "Welding goggles"
	build_path = /obj/item/clothing/glasses/welding
	materials = list(MATERIAL_STEEL = 1 SHEETS, MATERIAL_GLASS = 3 SHEETS)

/datum/design/item/engifab/engitools/stasisclamp
	name = "Stasis clamp"
	build_path = /obj/item/clamp
	materials = list(MATERIAL_STEEL = 2 SHEETS)


/datum/design/item/engifab/engitools/simple/welder_mini
	name = "Miniture welding tool"
	id = "miniature_welding_tool"
	build_path = /obj/item/weapon/weldingtool/mini/empty
	materials = list(MATERIAL_STEEL = 1 SHEETS, MATERIAL_GLASS = 0.5 SHEET)

/datum/design/item/engifab/engitools/weldertool
	name = "Welding tool"
	id = "welding_tool"
	build_path = /obj/item/weapon/weldingtool/empty
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_GLASS = 1 SHEETS)

/datum/design/item/engifab/engitools/weldingpack
	build_path = /obj/item/weapon/weldpack
	materials = list(MATERIAL_STEEL = 5 SHEETS, MATERIAL_GLASS = 3 SHEETS)



/datum/design/item/engifab/engitools/welder_industrial
	name = "Industrial welding tool"
	build_path = /obj/item/weapon/weldingtool/largetank/empty
	req_tech = list(TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_GLASS = 2 SHEETS)

/datum/design/item/engifab/engitools/welder_huge
	name = "High-capacity welding tool"
	build_path = /obj/item/weapon/weldingtool/hugetank/empty
	req_tech = list(TECH_ENGINEERING = 3)
	materials = list(MATERIAL_STEEL = 6 SHEETS, MATERIAL_GLASS = 3 SHEETS)


/datum/design/item/engifab/engitools/adv/airlock_brace
	name = "Airlock brace"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2)
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_GLASS = 0.5 SHEETS)
	build_path = /obj/item/weapon/airlock_brace

/datum/design/item/engifab/engitools/adv/light_replacer
	name = "Light replacer"
	req_tech = list(TECH_MAGNET = 3, TECH_MATERIAL = 4)
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_COPPPER = 0.5 SHEETS, MATERIAL_GLASS = 1 SHEETS)
	build_path = /obj/item/device/lightreplacer

/datum/design/item/engifab/engitools/adv/mesons
	name = "Optical meson scanners"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 1 SHEETS, MATERIAL_GLASS = 2 SHEETS, MATERIAL_PHORON = 2 SHEETS)
	build_path = /obj/item/clothing/glasses/meson

/datum/design/item/engifab/engitools/adv/RPED
	name = "Rapid Part Exchange Device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts."
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 3)
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_GLASS = 1.5 SHEETS, MATERIAL_GOLD = 1 SHEET, MATERIAL_PHORON = 1 SHEET)
	build_path = /obj/item/weapon/storage/part_replacer

/datum/design/item/engifab/engitools/adv/brace_jack
	name = "Brace jack"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2)
	materials = list(MATERIAL_STEEL = 2 SHEETS)
	build_path = /obj/item/weapon/crowbar/brace_jack
	
/datum/design/item/engifab/engitools/adv/airlock_brace
	name = "Airlock Brace"
	materials = list(MATERIAL_STEEL = 5 SHEETS, MATERIAL_GLASS = 2 SHEETS)
	build_path = /obj/item/weapon/airlock_brace
	

/datum/design/item/engifab/engitools/adv/experimental_welder
	name = "Experimental welding tool"
	req_tech = list(TECH_ENGINEERING = 5, TECH_PHORON = 4)
	materials = list(MATERIAL_STEEL = 5 SHEETS, MATERIAL_GLASS = 5 SHEETS, MATERIAL_PLASTEEL = 5 SHEETS)
	chemicals = list(/datum/reagent/toxin/phoron/oxygen = 80)	//hopefully this makes a good detterant for obtaining OP welding tool
	build_path = /obj/item/weapon/weldingtool/experimental

/datum/design/item/engifab/engitools/adv/nanopaste
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	materials = list(MATERIAL_STEEL = 5 SHEETS, MATERIAL_GLASS = 5 SHEETS)
	build_path = /obj/item/stack/nanopaste

/datum/design/item/engifab/engitools/smes_coil/standard
	build_path = /obj/item/weapon/smes_coil
	materials = list(MATERIAL_STEEL = 8 SHEETS, MATERIAL_GLASS = 3 SHEETS, MATERIAL_COPPER = 5 SHEET, MATERIAL_URANIUM = 2 SHEET)
	
/datum/design/item/engifab/engitools/smes_coil/weak
	build_path = /obj/item/weapon/smes_coil/weak
	materials = list(MATERIAL_STEEL = 5 SHEETS, MATERIAL_GLASS = 2 SHEETS, MATERIAL_COPPER = 3 SHEET, MATERIAL_URANIUM = 1 SHEET)
	
/datum/design/item/engifab/engitools/smes_coil/super_capacity
	build_path = /obj/item/weapon/smes_coil/super_capacity
	materials = list(MATERIAL_STEEL = 12 SHEETS, MATERIAL_GLASS = 4 SHEETS, MATERIAL_COPPER = 6 SHEET, MATERIAL_URANIUM = 5 SHEET, MATERIAL_PHORON = 2 SHEET)

/datum/design/item/engifab/engitools/smes_coil/super_io
	build_path = /obj/item/weapon/smes_coil/super_io
	materials = list(MATERIAL_STEEL = 12 SHEETS, MATERIAL_GLASS = 4 SHEETS, MATERIAL_COPPER = 6 SHEET, MATERIAL_URANIUM = 2 SHEET, MATERIAL_PHORON = 5 SHEET)


/datum/design/item/engifab/engitools/simple/extinguisher_mini
	name = "Compact extinguisher"
	build_path = /obj/item/weapon/extinguisher/mini/empty
	materials = list(MATERIAL_STEEL = 1 SHEET)

/datum/design/item/engifab/engitools/adv/extinguisher
	name = "Extinguisher"
	build_path = /obj/item/weapon/extinguisher/empty
	materials = list(MATERIAL_STEEL = 2 SHEETS)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ELECTRONICS

/datum/design/item/engifab/electronics
	time = 10
	category = "Electronics"
	materials = list(MATERIAL_STEEL = 0.25 SHEETS, MATERIAL_COPPER = 0.25 SHEETS)
	
/datum/design/item/engifab/electronics/adv

/datum/design/item/engifab/electronics/simple
	build_type = list(ENGIFAB,GENERALFAB)


//////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/design/item/engifab/electronics/norad_airlock_controller
	build_path = /obj/item/frame/airlock_controller_norad
	category = "Electronics"

/datum/design/item/engifab/electronics/norad_airlock_sensor
	name = "Airlock sensor (no radio)"
	build_path = /obj/item/frame/airlock_sensor_norad
	category = "Electronics"

/datum/design/item/engifab/electronics/simple/airlockmodule
	name = "Airlock electronics"
	build_path = /obj/item/weapon/airlock_electronics

/datum/design/item/engifab/electronics/simple/airalarm
	name = "Air alarm electronics"
	build_path = /obj/item/weapon/airalarm_electronics

/datum/design/item/engifab/electronics/firealarm
	name = "Fire alarm electronics"
	build_path = /obj/item/weapon/firealarm_electronics

/datum/design/item/engifab/electronics/simple/powermodule
	name = "Power control module"
	build_path = /obj/item/weapon/module/power_control

/datum/design/item/engifab/electronics/keypad
	name = "Airlock keypad electronics"
	build_path = /obj/item/weapon/airlock_electronics/keypad_electronics

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PARTS


/datum/design/item/engifab/parts
	category = "Parts"
	time = 10
	build_type = list(ENGIFAB, GENERALFAB)
	
/datum/design/item/engifab/parts/adv
	build_type = ENGIFAB

//////////////////////////////////////////////////////////////////////////


/datum/design/item/engifab/parts/camera_assembly
	name = "Camera assembly"
	id = "camera_assembly"
	build_path = /obj/item/weapon/camera_assembly
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_GLASS = 1 SHEET)

/datum/design/item/engifab/parts/consolescreen
	name = "Console screen"
	id = "console_screen"
	build_path = /obj/item/weapon/stock_parts/console_screen
	materials = list(MATERIAL_GLASS = 1 SHEET)

/datum/design/item/engifab/parts/igniter
	name = "Igniter"
	id = "igniter"
	build_path = /obj/item/device/assembly/igniter
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_COPPER = 1 SHEET)

/datum/design/item/engifab/parts/signaler
	name = "Signaler"
	id = "signaler"
	build_path = /obj/item/device/assembly/signaler
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_COPPER = 0.5 SHEET)

/datum/design/item/engifab/parts/sensor_infra
	name = "Infrared sensor"
	id = "infrared_sensor"
	build_path = /obj/item/device/assembly/infra
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_GLASS = 0.5 SHEET)

/datum/design/item/engifab/parts/voice
	build_path = /obj/item/device/assembly/voice
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_GLASS = 0.5 SHEET)
	
	

/datum/design/item/engifab/parts/timer
	name = "Timer"
	id = "timer"
	build_path = /obj/item/device/assembly/timer
	category = "Parts"
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_GLASS = 0.5 SHEET)

/datum/design/item/engifab/parts/sensor_prox
	name = "Proximity sensor"
	id = "proximity_sensor"
	build_path = /obj/item/device/assembly/prox_sensor
	category = "Parts"
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_GLASS = 0.5 SHEET)






/datum/design/item/engifab/lights
	category = "Lights"
	materials = list(MATERIAL_GLASS = 0.25 SHEETS)

/datum/design/item/engifab/lights/tube/large
	build_path = /obj/item/weapon/light/tube/large

/datum/design/item/engifab/lights/tube
	build_path = /obj/item/weapon/light/tube
	build_type = list(ENGIFAB, GENERALFAB)

/datum/design/item/engifab/lights/tube/simple
	build_path = /obj/item/weapon/light/tube
	build_type = list(ENGIFAB, GENERALFAB)
/datum/design/item/engifab/lights/bulb

/datum/design/item/engifab/lights/bulb/simple
	build_path = /obj/item/weapon/light/bulb
	build_type = list(ENGIFAB, GENERALFAB)

/datum/design/item/engifab/lights/tube/red
	build_path = /obj/item/weapon/light/tube/red

/datum/design/item/engifab/lights/tube/green
	build_path = /obj/item/weapon/light/tube/green

/datum/design/item/engifab/lights/tube/blue
	build_path = /obj/item/weapon/light/tube/blue

/datum/design/item/engifab/lights/tube/purple
	build_path = /obj/item/weapon/light/tube/purple

/datum/design/item/engifab/lights/tube/pink
	build_path = /obj/item/weapon/light/tube/pink

/datum/design/item/engifab/lights/tube/yellow
	build_path = /obj/item/weapon/light/tube/yellow

/datum/design/item/engifab/lights/tube/orange
	build_path = /obj/item/weapon/light/tube/orange


/datum/design/item/engifab/lights/bulb/red
	build_path = /obj/item/weapon/light/bulb/red

/datum/design/item/engifab/lights/bulb/green
	build_path = /obj/item/weapon/light/bulb/green


/datum/design/item/engifab/lights/bulb/blue
	build_path = /obj/item/weapon/light/bulb/blue

/datum/design/item/engifab/lights/bulb/purple
	build_path = /obj/item/weapon/light/bulb/purple

/datum/design/item/engifab/lights/bulb/pink
	build_path = /obj/item/weapon/light/bulb/pink

/datum/design/item/engifab/lights/bulb/yellow
	build_path = /obj/item/weapon/light/bulb/yellow

/datum/design/item/engifab/lights/bulb/orange
	build_path = /obj/item/weapon/light/bulb/orange





/datum/design/item/engifab/parts/cell_device
	name = "Device cell"
	build_path = /obj/item/weapon/cell/device/standard/empty
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_GLASS = 1 SHEET)

/datum/design/item/engifab/parts/basic_capacitor
	name = "Basic capacitor"
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_GLASS = 1 SHEET)
	build_path = /obj/item/weapon/stock_parts/capacitor

/datum/design/item/engifab/parts/adv_capacitor
	name = "Advanced capacitor"
	materials = list(MATERIAL_STEEL = 5 SHEET, MATERIAL_GLASS = 3 SHEET, MATERIAL_GOLD = 2 SHEET, MATERIAL_COPPER = 2 SHEET)
	build_path = /obj/item/weapon/stock_parts/capacitor/adv
	research = "adv_capacitor"
/datum/design/item/engifab/parts/super_capacitor
	name = "Super capacitor"
	materials = list(MATERIAL_STEEL = 10 SHEET, MATERIAL_GLASS = 5 SHEET, MATERIAL_URANIUM = 5 SHEETS, MATERIAL_COPPER = 5 SHEETS)
	build_path = /obj/item/weapon/stock_parts/capacitor/super
	research = "super_capacitor"
/datum/design/item/engifab/parts/micro_mani
	name = "Micro manipulator"
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_GLASS = 1 SHEET)
	build_path = /obj/item/weapon/stock_parts/manipulator
	
/datum/design/item/engifab/parts/nano_mani
	name = "Nano manipulator"
	materials = list(MATERIAL_STEEL = 0.75 SHEET, MATERIAL_GLASS = 0.75 SHEET, MATERIAL_SILVER = 3 SHEET, MATERIAL_COPPER = 5 SHEET)
	build_path = /obj/item/weapon/stock_parts/manipulator/nano
	research = "nano_mani"
/datum/design/item/engifab/parts/pico_mani
	name = "Pico manipulator"
	materials = list(MATERIAL_STEEL = 0.5 SHEET, MATERIAL_GLASS = 0.5 SHEET, MATERIAL_SILVER = 5 SHEET, MATERIAL_PHORON = 5 SHEET)
	build_path = /obj/item/weapon/stock_parts/manipulator/pico
	research = "pico_mani"
/datum/design/item/engifab/parts/basic_matter_bin
	name = "Basic matter bin"
	materials = list(MATERIAL_STEEL = 2 SHEETS)
	build_path = /obj/item/weapon/stock_parts/matter_bin

/datum/design/item/engifab/parts/adv_matter_bin
	name = "Advanced matter bin"
	materials = list(MATERIAL_STEEL = 5 SHEETS, MATERIAL_GLASS = 2 SHEET, MATERIAL_COPPER = 3 SHEETS)
	build_path = /obj/item/weapon/stock_parts/matter_bin/adv
	research = "adv_matter_bin"
/datum/design/item/engifab/parts/super_matter_bin
	name = "Super matter bin"
	materials = list(MATERIAL_STEEL = 10 SHEETS, MATERIAL_GLASS = 2 SHEET, MATERIAL_PHORON = 5 SHEETS)
	build_path = /obj/item/weapon/stock_parts/matter_bin/super
	research = "super_matter_bin"
/datum/design/item/engifab/parts/basic_micro_laser
	name = "Basic micro laser"
	req_tech = list(TECH_MAGNET = 1)
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_GLASS = 1.5 SHEET)
	build_path = /obj/item/weapon/stock_parts/micro_laser

/datum/design/item/engifab/parts/high_micro_laser
	name = "High intensity micro laser"
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_GLASS = 5 SHEETS, MATERIAL_URANIUM = 1 SHEET)
	build_path = /obj/item/weapon/stock_parts/micro_laser/high
	research = "high_micro_laser"
	
/datum/design/item/engifab/parts/ultra_micro_laser
	name = "Ultra intensity micro laser"
	materials = list(MATERIAL_STEEL = 5 SHEETS, MATERIAL_GLASS = 10 SHEETS, MATERIAL_URANIUM = 2 SHEETS, MATERIAL_DIAMOND = 2 SHEETS)
	build_path = /obj/item/weapon/stock_parts/micro_laser/ultra
	research = "ultra_micro_laser"
/datum/design/item/engifab/parts/basic_sensor
	name = "Basic sensor"
	materials = list(MATERIAL_STEEL = 1 SHEETS, MATERIAL_GLASS = 0.75 SHEETS)
	build_path = /obj/item/weapon/stock_parts/scanning_module

/datum/design/item/engifab/parts/adv_sensor
	name = "Advanced sensor"
	req_tech = list(TECH_MAGNET = 3)
	build_path = /obj/item/weapon/stock_parts/scanning_module/adv
	research = "adv_sensor"
/datum/design/item/engifab/parts/phasic_sensor
	name = "Phasic sensor"
	materials = list(MATERIAL_STEEL = 5 SHEETS, MATERIAL_GLASS = 10 SHEETS, MATERIAL_SILVER = 4 SHEETS, MATERIAL_PHORON = 5 SHEETS)
	build_path = /obj/item/weapon/stock_parts/scanning_module/phasic
	research = "phasic_sensor"
/datum/design/item/engifab/parts/powercell/basic
	name = "Basic power cell"
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_COPPER = 1 SHEET)
	build_path = /obj/item/weapon/cell

/datum/design/item/engifab/parts/powercell/high
	name = "High-capacity power cell"
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_COPPER = 2 SHEETS, MATERIAL_URANIUM = 0.5 SHEETS)
	build_path = /obj/item/weapon/cell/high
	research = "cell_high"
/datum/design/item/engifab/parts/powercell/super
	name = "Super-capacity power cell"
	materials = list(MATERIAL_STEEL = 5 SHEETS, MATERIAL_COPPER = 5 SHEETS, MATERIAL_URANIUM = 2 SHEETS)
	build_path = /obj/item/weapon/cell/super
	research = "cell_super"
/datum/design/item/engifab/parts/powercell/hyper
	name = "Hyper-capacity power cell"
	materials = list(MATERIAL_STEEL = 8 SHEETS, MATERIAL_PHORON = 2 SHEETS, MATERIAL_URANIUM = 5 SHEETS)
	build_path = /obj/item/weapon/cell/hyper
	research = "cell_super"
/datum/design/item/engifab/parts/powercell/device/standard
	name = "Standard capacity device power cell"
	materials = list(MATERIAL_STEEL = 70, MATERIAL_GLASS = 5)
	build_path = /obj/item/weapon/cell/device/standard

/datum/design/item/engifab/parts/powercell/device/high
	name = "High capacity device power cell"
	materials = list(MATERIAL_STEEL = 70, MATERIAL_GLASS = 6,MATERIAL_PHORON = 100)
	build_path = /obj/item/weapon/cell/device/high
	research = "cell_high"
/datum/design/item/engifab/parts/adv/subspace_ansible
	name = "Subspace ansible"
	materials = list(MATERIAL_STEEL = 80, MATERIAL_SILVER = 20)
	build_path = /obj/item/weapon/stock_parts/subspace/ansible

/datum/design/item/engifab/parts/adv/hyperwave_filter
	name = "Hyperwave Filter"
	materials = list(MATERIAL_STEEL = 40, MATERIAL_SILVER = 10)
	build_path = /obj/item/weapon/stock_parts/subspace/filter
/datum/design/item/engifab/parts/adv/subspace_amplifier
	id = "s-amplifier"
	materials = list(MATERIAL_STEEL = 10, MATERIAL_GOLD = 30, MATERIAL_URANIUM = 15)
	build_path = /obj/item/weapon/stock_parts/subspace/amplifier

/datum/design/item/engifab/parts/adv/subspace_treatment
	name = "Subspace treatment:"
	materials = list(MATERIAL_STEEL = 10, MATERIAL_SILVER = 20)
	build_path = /obj/item/weapon/stock_parts/subspace/treatment

/datum/design/item/engifab/parts/adv/subspace_analyzer
	name = "Subspace analyzer"
	materials = list(MATERIAL_STEEL = 10, MATERIAL_GOLD = 15)
	build_path = /obj/item/weapon/stock_parts/subspace/analyzer

/datum/design/item/engifab/parts/adv/subspace_crystal
	name = "Subspace crystal"
	materials = list(MATERIAL_GLASS = 1000, MATERIAL_SILVER = 20, MATERIAL_GOLD = 20)
	build_path = /obj/item/weapon/stock_parts/subspace/crystal

/datum/design/item/engifab/parts/adv/subspace_transmitter
	name = "Subspace transmitter"
	materials = list(MATERIAL_GLASS = 100, MATERIAL_SILVER = 10, MATERIAL_URANIUM = 15)
	build_path = /obj/item/weapon/stock_parts/subspace/transmitter

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Floor Tiles

/datum/design/item/engifab/floortiles
	category = "Floor tiles"
	time = 5

/////////////////////////////////////////////////////////////////////////////////////////////
//Carpets
/////////////////////////////////////////////////////////////////////////////////////////////

/datum/design/item/engifab/floortiles/carpet
	materials = list(MATERIAL_CLOTH = 0.04 SHEETS)

/datum/design/item/engifab/floortiles/carpet/brown
	name = "Brown carpet"
	build_path = /obj/item/stack/tile/carpet


/datum/design/item/engifab/floortiles/carpet/blue
	name = "Blue carpet"
	build_path = /obj/item/stack/tile/carpetblue2

/datum/design/item/engifab/floortiles/carpet/purple
	name = "Purple carpet"
	build_path = /obj/item/stack/tile/carpetpurple

/datum/design/item/engifab/floortiles/carpet/orange
	name = "Orange carpet"
	build_path = /obj/item/stack/tile/carpetorange

/datum/design/item/engifab/floortiles/carpet/green
	name = "Green carpet"
	build_path = /obj/item/stack/tile/carpetgreen

/datum/design/item/engifab/floortiles/carpet/red
	name = "Red carpet"
	build_path = /obj/item/stack/tile/carpetred

////////////////////////////////////////////////////////////////////////////////////////////////
// Plastic Flooring
////////////////////////////////////////////////////////////////////////////////////////////////
/datum/design/item/engifab/floortiles/plastic
	materials = list(MATERIAL_PLASTIC = 0.04 SHEETS)

/datum/design/item/engifab/floortiles/plastic/linoleum
	name = "Linoleum flooring"
	build_path = /obj/item/stack/tile/linoleum

/datum/design/item/engifab/floortiles/plastic/floor_freezer
	name = "Freezer flooring"
	build_path = /obj/item/stack/tile/floor_freezer

/datum/design/item/engifab/floortiles/plastic/white
	name = "White plastic flooring"
	build_path = /obj/item/stack/tile/floor_white

////////////////////////////////////////////////////////////////////////////////////////////////
// Steel Flooring
////////////////////////////////////////////////////////////////////////////////////////////////
/datum/design/item/engifab/floortiles/floor
	name = "Steel flooring"
	build_path = /obj/item/stack/tile/floor
	materials = list(MATERIAL_STEEL = 0.04 SHEETS)

/datum/design/item/engifab/floortiles/floor_dark
	name = "Plasteel flooring"
	build_path = /obj/item/stack/tile/floor_dark
	materials = list(MATERIAL_STEEL = 0.04 SHEETS)
