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
										// in addition to any material costs.
////////////////////////////////////////////////////
//////////////////////DESIGNS///////////////////////
////////////////////////////////////////////////////

/datum/design/item/engifab
	build_type = ENGIFAB 			   // This must match the build_type of the fabricator(s)
	category = "Misc"	 			   // The design will appear under this in the UI. Each design must have a category, or it will not display properly.
	time = 50	// Time in seconds for the item to be produced - This changes based off the components used in the fabricator

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ENGINEERING EQUIPMENT

/datum/design/item/engifab/engitools
	category = "Engineering Equipment"
	time = 20

/datum/design/item/engifab/engitools/simple
	build_type = ENGIFAB|GENERALFAB

/datum/design/item/engifab/engitools/adv


/////////////////////////////////////////////////////////////////////////////////////////////

/datum/design/item/engifab/engitools/adv/analyzer
	name = "Gas analyzer"
	id = "gas_analyzer"
	build_path = /obj/item/device/analyzer
	category = "Tools"
	materials = list(MATERIAL_STEEL = 30, MATERIAL_GLASS = 20)

/datum/design/item/engifab/engitools/t_scanner
	name = "T-ray Scanner"
	id = "t-ray_scanner"
	build_path = /obj/item/device/t_scanner
	category = "Tools"
	materials = list(MATERIAL_STEEL = 150)

/datum/design/item/engifab/engitools/simple/flashlight
	name = "Flashlight"
	id = "flashlight"
	build_path = /obj/item/device/flashlight
	category = "Tools"
	materials = list(MATERIAL_STEEL = 20, MATERIAL_GLASS = 20)

/datum/design/item/engifab/engitools/maglight
	name = "Maglight"
	id = "maglight"
	build_path = /obj/item/device/flashlight/maglight
	category = "Tools"
	materials = list(MATERIAL_STEEL = 200, MATERIAL_GLASS = 50)

/datum/design/item/engifab/engitools/simple/crowbar
	name = "Crowbar"
	id = "crowbar"
	build_path = /obj/item/weapon/crowbar
	category = "Tools"
	materials = list(MATERIAL_STEEL = 140)

/datum/design/item/engifab/engitools/prybar
	name = "Pry bar"
	id = "pry_bar"
	build_path = /obj/item/weapon/crowbar/prybar
	category = "Tools"
	materials = list(MATERIAL_STEEL = 80)

/datum/design/item/engifab/engitools/simple/multitool
	name = "Multitool"
	id = "multitool"
	build_path = /obj/item/device/multitool
	category = "Tools"
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 20)


/datum/design/item/engifab/engitools/simple/welder_mini
	name = "Miniture welding tool"
	id = "miniature_welding_tool"
	build_path = /obj/item/weapon/weldingtool/mini/empty
	category = "Tools"
	materials = list(MATERIAL_STEEL = 70, MATERIAL_GLASS = 30)

/datum/design/item/engifab/engitools/weldertool
	name = "Welding tool"
	id = "welding_tool"
	build_path = /obj/item/weapon/weldingtool/empty
	category = "Tools"
	materials = list(MATERIAL_STEEL = 210, MATERIAL_GLASS = 90)

/datum/design/item/engifab/engitools/simple/screwdriver
	name = "Screwdriver"
	id = "screwdriver"
	build_path = /obj/item/weapon/screwdriver
	category = "Tools"
	materials = list(MATERIAL_STEEL = 75)

/datum/design/item/engifab/engitools/simple/wirecutters
	name = "Wirecutters"
	id = "wirecutters"
	build_path = /obj/item/weapon/wirecutters
	category = "Tools"
	materials = list(MATERIAL_STEEL = 80)

/datum/design/item/engifab/engitools/simple/wrench
	name = "Wrench"
	id = "wrench"
	build_path = /obj/item/weapon/wrench
	category = "Tools"
	materials = list(MATERIAL_STEEL = 150)

/datum/design/item/engifab/engitools/suit_cooler
	name = "Suit cooling unit"
	id = "suit_cooling_unit"
	build_path = /obj/item/device/suit_cooling_unit
	category = "General"
	materials = list(MATERIAL_STEEL = 15000, MATERIAL_GLASS = 3500)

/datum/design/item/engifab/engitools/simple/weldermask
	name = "Welding mask"
	id = "welding_mask"
	build_path = /obj/item/clothing/head/welding
	category = "General"
	materials = list(MATERIAL_STEEL = 3000, MATERIAL_GLASS = 1000)

/datum/design/item/engifab/engitools/rcd_ammo
	name = "Matter Cartridge"
	id = "matter_cartridge"
	build_path = /obj/item/weapon/rcd_ammo
	category = "General"
	materials = list(MATERIAL_STEEL = 15000, MATERIAL_GLASS = 7500)

/datum/design/item/engifab/engitools/rcd_ammo_large
	name = "High-capacity matter cartridge"
	id = "hi-cap_matter_cartridge"
	build_path = /obj/item/weapon/rcd_ammo/large
	category = "General"
	materials = list(MATERIAL_STEEL = 45000, MATERIAL_GLASS = 22500)

/datum/design/item/engifab/engitools/simple/cable_coil
	name = "Cable coil"
	id = "cable_coil"
	build_path = /obj/item/stack/cable_coil/single		//must be /single path, else printing 1x will instead print a whole stack
//	is_stack = 1
	category = "Parts"
	materials = list(MATERIAL_COPPER = 1)

/datum/design/item/engifab/engitools/weldinggoggles
	name = "Welding goggles"
	id = "welding_goggles"
	build_path = /obj/item/clothing/glasses/welding
	category = "General"
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 200)

/datum/design/item/engifab/engitools/stasisclamp
	name = "Stasis clamp"
	id = "stasis_clamp"
	build_path = /obj/item/clamp
	category = "Tools"
	materials = list(MATERIAL_STEEL = 4000)

/datum/design/item/engifab/engitools/welder_industrial
	name = "Industrial welding tool"
	id = "ind_welding_tool"
	build_path = /obj/item/weapon/weldingtool/largetank/empty
	category = "Tools"
	req_tech = list(TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 420, MATERIAL_GLASS = 180)

/datum/design/item/engifab/engitools/welder_huge
	name = "High-capacity welding tool"
	id = "hi-cap_welding_tool"
	build_path = /obj/item/weapon/weldingtool/hugetank/empty
	category = "Tools"
	req_tech = list(TECH_ENGINEERING = 3)
	materials = list(MATERIAL_STEEL = 840, MATERIAL_GLASS = 360)


/datum/design/item/engifab/engitools/adv/airlock_brace
	name = "Airlock brace"
	id = "airlock_brace"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2)
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_GLASS = 50)
	build_path = /obj/item/weapon/airlock_brace
	sort_string = "VBAAP"
	category = "Tools"

/datum/design/item/engifab/engitools/adv/light_replacer
	name = "Light replacer"
	id = "light_replacer"
	req_tech = list(TECH_MAGNET = 3, TECH_MATERIAL = 4)
	materials = list(MATERIAL_STEEL = 1500, MATERIAL_SILVER = 150, MATERIAL_GLASS = 3000)
	build_path = /obj/item/device/lightreplacer
	sort_string = "VAAAH"
	category = "Tools"

/datum/design/item/engifab/engitools/adv/mesons
	name = "Optical meson scanners"
	id = "menson_scanner"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50, MATERIAL_PHORON = 1000)
	build_path = /obj/item/clothing/glasses/meson
	category = "General"

/datum/design/item/engifab/engitools/adv/RPED
	name = "Rapid Part Exchange Device"
	id = "rapid_part_exchange_device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts."
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 3)
	materials = list(MATERIAL_STEEL = 15000, MATERIAL_GLASS = 6000, , MATERIAL_GLASS = 6000, MATERIAL_GOLD = 6000, MATERIAL_PHORON = 8000)
	build_path = /obj/item/weapon/storage/part_replacer
	sort_string = "CBAAA"
	category = "Tools"

/datum/design/item/engifab/engitools/adv/brace_jack
	name = "Brace jack"
	id = "brace_jack"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2)
	materials = list(MATERIAL_STEEL = 120)
	build_path = /obj/item/weapon/crowbar/brace_jack
	sort_string = "VBAAS"
	category = "Tools"

/datum/design/item/engifab/engitools/adv/experimental_welder
	name = "Experimental welding tool"
	id = "exp_welding_tool"
	req_tech = list(TECH_ENGINEERING = 5, TECH_PHORON = 4)
	materials = list(MATERIAL_STEEL = 6000, MATERIAL_GLASS = 500, MATERIAL_PLASTEEL = 2000)
	chemicals = list(/datum/reagent/toxin/phoron/oxygen = 80)	//hopefully this makes a good detterant for obtaining OP welding tool
	build_path = /obj/item/weapon/weldingtool/experimental
	sort_string = "VBAAT"
	category = "Tools"

/datum/design/item/engifab/engitools/simple/extinguisher_mini
	name = "Compact extinguisher"
	id = "compact_extinguisher"
	build_path = /obj/item/weapon/extinguisher/mini/empty
	category = "Tools"
	materials = list(MATERIAL_STEEL = 90)

/datum/design/item/engifab/engitools/adv/extinguisher
	name = "Extinguisher"
	id = "extinguisher"
	build_path = /obj/item/weapon/extinguisher/empty
	category = "Tools"
	materials = list(MATERIAL_STEEL = 180)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ELECTRONICS

/datum/design/item/engifab/electronics
	category = "Electronics"
	time = 50

/datum/design/item/engifab/electronics/adv

//////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/design/item/engifab/electronics/norad_airlock_controller
	id = "Airlock controller (no radio)"
	id = "airlock_controller_norad"
	build_path = /obj/item/frame/airlock_controller_norad
	category = "Electronics"
	materials = list(MATERIAL_STEEL = 150, MATERIAL_GLASS = 150)

/datum/design/item/engifab/electronics/norad_airlock_sensor
	name = "Airlock sensor (no radio)"
	id = "airlock_sensor_norad"
	build_path = /obj/item/frame/airlock_sensor_norad
	category = "Electronics"
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50)

/datum/design/item/engifab/electronics/airlockmodule
	name = "Airlock electronics"
	id = "airlock_electronics"
	build_path = /obj/item/weapon/airlock_electronics
	category = "Electronics"
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50)

/datum/design/item/engifab/electronics/airalarm
	name = "Air alarm electronics"
	id = "air_alarm_electronics"
	build_path = /obj/item/weapon/airalarm_electronics
	category = "Electronics"
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50)

/datum/design/item/engifab/electronics/firealarm
	name = "Fire alarm electronics"
	id = "fire_alarm_electronics"
	build_path = /obj/item/weapon/firealarm_electronics
	category = "Electronics"
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50)

/datum/design/item/engifab/electronics/powermodule
	name = "Power control module"
	id = "power_control_module"
	build_path = /obj/item/weapon/module/power_control
	category = "Electronics"
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50)

/datum/design/item/engifab/electronics/keypad
	name = "Airlock keypad electronics"
	id = "airlock_keypad_electronics"
	build_path = /obj/item/weapon/airlock_electronics/keypad_electronics
	category = "Electronics"
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50)


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PARTS


/datum/design/item/engifab/parts
	category = "Parts"
	time = 40
/datum/design/item/engifab/parts/adv


//////////////////////////////////////////////////////////////////////////


/datum/design/item/engifab/parts/camera_assembly
	name = "Camera assembly"
	id = "camera_assembly"
	build_path = /obj/item/weapon/camera_assembly
	category = "Parts"
	materials = list(MATERIAL_STEEL = 700, MATERIAL_GLASS = 300)

/datum/design/item/engifab/parts/consolescreen
	name = "Console screen"
	id = "console_screen"
	build_path = /obj/item/weapon/stock_parts/console_screen
	category = "Parts"
	materials = list(MATERIAL_GLASS = 200)

/datum/design/item/engifab/parts/igniter
	name = "Igniter"
	id = "igniter"
	build_path = /obj/item/device/assembly/igniter
	category = "Parts"
	materials = list(MATERIAL_STEEL = 500, MATERIAL_GLASS = 50)

/datum/design/item/engifab/parts/signaler
	name = "Signaler"
	id = "signaler"
	build_path = /obj/item/device/assembly/signaler
	category = "Parts"
	materials = list(MATERIAL_STEEL = 1000, MATERIAL_GLASS = 200)

/datum/design/item/engifab/parts/sensor_infra
	name = "Infrared sensor"
	id = "infrared_sensor"
	build_path = /obj/item/device/assembly/infra
	category = "Parts"
	materials = list(MATERIAL_STEEL = 1000, MATERIAL_GLASS = 500)

/datum/design/item/engifab/parts/timer
	name = "Timer"
	id = "timer"
	build_path = /obj/item/device/assembly/timer
	category = "Parts"
	materials = list(MATERIAL_STEEL = 500, MATERIAL_GLASS = 50)

/datum/design/item/engifab/parts/sensor_prox
	name = "Proximity sensor"
	id = "proximity_sensor"
	build_path = /obj/item/device/assembly/prox_sensor
	category = "Parts"
	materials = list(MATERIAL_STEEL = 800, MATERIAL_GLASS = 200)

/datum/design/item/engifab/parts/tube/large
	name = "Spotlight tube"
	id = "spotlight_tube"
	build_path = /obj/item/weapon/light/tube/large
	category = "Parts"
	materials = list(MATERIAL_GLASS = 150)

/datum/design/item/engifab/parts/recipe/tube
	name = "Light tube"
	id = "light_tube"
	build_path = /obj/item/weapon/light/tube
	category = "Parts"
	materials = list(MATERIAL_GLASS = 100)

/datum/design/item/engifab/parts/bulb
	name = "Light bulb"
	id = "light_bulb"
	build_path = /obj/item/weapon/light/bulb
	category = "Parts"
	materials = list(MATERIAL_GLASS = 100)

/datum/design/item/engifab/parts/cell_device
	name = "Device cell"
	id = "device_cell"
	build_path = /obj/item/weapon/cell/device/standard/empty
	category = "Parts"
	materials = list(MATERIAL_STEEL = 70, MATERIAL_GLASS = 5)

/datum/design/item/engifab/parts/basic_capacitor
	name = "Basic capacitor"
	id = "basic_capacitor"
	req_tech = list(TECH_POWER = 1)
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/weapon/stock_parts/capacitor
	category = "Parts"

/datum/design/item/engifab/parts/adv/adv_capacitor
	name = "Advanced capacitor"
	id = "adv_capacitor"
	req_tech = list(TECH_POWER = 3)
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50, MATERIAL_GOLD = 500, MATERIAL_PHORON = 500)
	build_path = /obj/item/weapon/stock_parts/capacitor/adv
	category = "Parts"

/datum/design/item/engifab/parts/adv/super_capacitor
	name = "Super capacitor"
	id = "super_capacitor"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 500, MATERIAL_GOLD = 2000, MATERIAL_PHORON = 1000)
	build_path = /obj/item/weapon/stock_parts/capacitor/super
	category = "Parts"

/datum/design/item/engifab/parts/micro_mani
	name = "Micro manipulator"
	id = "micro_manipulator"
	req_tech = list(TECH_MATERIAL = 1, TECH_DATA = 1)
	materials = list(MATERIAL_STEEL = 30)
	build_path = /obj/item/weapon/stock_parts/manipulator
	category = "Parts"

/datum/design/item/engifab/parts/adv/nano_mani
	name = "Nano manipulator"
	id = "nano_manipulator"
	req_tech = list(TECH_MATERIAL = 3, TECH_DATA = 2)
	materials = list(MATERIAL_STEEL = 30, MATERIAL_PHORON = 250)
	build_path = /obj/item/weapon/stock_parts/manipulator/nano
	category = "Parts"

/datum/design/item/engifab/parts/adv/pico_mani
	name = "Pico manipulator"
	id = "pico_manipulator"
	req_tech = list(TECH_MATERIAL = 5, TECH_DATA = 2)
	materials = list(MATERIAL_STEEL = 30, MATERIAL_PHORON = 1000)
	build_path = /obj/item/weapon/stock_parts/manipulator/pico
	category = "Parts"

/datum/design/item/engifab/parts/basic_matter_bin
	name = "Basic matter bin"
	id = "basic_matter_bin"
	req_tech = list(TECH_MATERIAL = 1)
	materials = list(MATERIAL_STEEL = 80)
	build_path = /obj/item/weapon/stock_parts/matter_bin
	category = "Parts"

/datum/design/item/engifab/parts/adv/adv_matter_bin
	name = "Advanced matter bin"
	id = "adv_matter_bin"
	req_tech = list(TECH_MATERIAL = 3)
	materials = list(MATERIAL_STEEL = 80, MATERIAL_PHORON = 250)
	build_path = /obj/item/weapon/stock_parts/matter_bin/adv
	category = "Parts"

/datum/design/item/engifab/parts/adv/super_matter_bin
	name = "Super matter bin"
	id = "super_matter_bin"
	req_tech = list(TECH_MATERIAL = 5)
	materials = list(MATERIAL_STEEL = 80, MATERIAL_PHORON = 500)
	build_path = /obj/item/weapon/stock_parts/matter_bin/super
	category = "Parts"

/datum/design/item/engifab/parts/basic_micro_laser
	name = "Basic micro laser"
	id = "basic_micro_laser"
	req_tech = list(TECH_MAGNET = 1)
	materials = list(MATERIAL_STEEL = 10, MATERIAL_GLASS = 20)
	build_path = /obj/item/weapon/stock_parts/micro_laser
	category = "Parts"

/datum/design/item/engifab/parts/adv/high_micro_laser
	name = "High intensity micro laser"
	id = "high_micro_laser"
	req_tech = list(TECH_MAGNET = 3)
	materials = list(MATERIAL_STEEL = 10, MATERIAL_GLASS = 20, MATERIAL_URANIUM = 500, MATERIAL_PHORON = 500)
	build_path = /obj/item/weapon/stock_parts/micro_laser/high
	category = "Parts"

/datum/design/item/engifab/parts/adv/ultra_micro_laser
	name = "Ultra intensity micro laser"
	id = "ultra_micro_laser"
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 5)
	materials = list(MATERIAL_STEEL = 10, MATERIAL_GLASS = 20, MATERIAL_URANIUM = 1000, MATERIAL_PHORON = 1000)
	build_path = /obj/item/weapon/stock_parts/micro_laser/ultra
	category = "Parts"

/datum/design/item/engifab/parts/basic_sensor
	name = "Basic sensor"
	id = "basic_sensor"
	req_tech = list(TECH_MAGNET = 1)
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 20)
	build_path = /obj/item/weapon/stock_parts/scanning_module
	sort_string = "CAAEA"
	category = "Parts"

/datum/design/item/engifab/parts/adv/adv_sensor
	name = "Advanced sensor"
	id = "adv_sensor"
	req_tech = list(TECH_MAGNET = 3)
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 20, MATERIAL_SILVER = 1000, MATERIAL_PHORON = 500)
	build_path = /obj/item/weapon/stock_parts/scanning_module/adv
	sort_string = "CAAEB"
	category = "Parts"

/datum/design/item/engifab/parts/adv/phasic_sensor
	name = "Phasic sensor"
	id = "phasic_sensor"
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 3)
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 20, MATERIAL_SILVER = 2000, MATERIAL_PHORON = 1000)
	build_path = /obj/item/weapon/stock_parts/scanning_module/phasic
	sort_string = "CAAEC"
	category = "Parts"

/datum/design/item/engifab/parts/adv/powercell/basic
	name = "Basic power cell"
	id = "basic_power_cell"
	req_tech = list(TECH_POWER = 1)
	materials = list(MATERIAL_STEEL = 700, MATERIAL_GLASS = 50)
	build_path = /obj/item/weapon/cell
	sort_string = "DAAAA"
	category = "Parts"

/datum/design/item/engifab/parts/adv/powercell/high
	name = "High-capacity power cell"
	id = "high_power_cell"
	req_tech = list(TECH_POWER = 2)
	materials = list(MATERIAL_STEEL = 700, MATERIAL_GLASS = 60, MATERIAL_GOLD = 200, MATERIAL_SILVER = 200)
	build_path = /obj/item/weapon/cell/high
	sort_string = "DAAAB"
	category = "Parts"

/datum/design/item/engifab/parts/adv/powercell/super
	name = "Super-capacity power cell"
	id = "super_power_cell"
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 2)
	materials = list(MATERIAL_STEEL = 700, MATERIAL_GLASS = 70, MATERIAL_GOLD = 500, MATERIAL_SILVER = 500, MATERIAL_PHORON = 500)
	build_path = /obj/item/weapon/cell/super
	sort_string = "DAAAC"
	category = "Parts"

/datum/design/item/engifab/parts/adv/powercell/hyper
	name = "Hyper-capacity power cell"
	id = "hyper_power_cell"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	materials = list(MATERIAL_STEEL = 400, MATERIAL_DIAMOND = 1000, MATERIAL_GOLD = 1000, MATERIAL_SILVER = 1000, MATERIAL_GLASS = 70, MATERIAL_PHORON = 1000)
	build_path = /obj/item/weapon/cell/hyper
	sort_string = "DAAAD"
	category = "Parts"

/datum/design/item/engifab/parts/adv/powercell/device/standard
	name = "Standard capacity device power cell"
	id = "device_cell_standard"
	req_tech = list(TECH_POWER = 1)
	materials = list(MATERIAL_STEEL = 70, MATERIAL_GLASS = 5)
	build_path = /obj/item/weapon/cell/device/standard
	sort_string = "DAAAE"
	category = "Parts"

/datum/design/item/engifab/parts/adv/powercell/device/high
	name = "High capacity device power cell"
	id = "device_cell_high"
	build_type = PROTOLATHE | MECHFAB
	id = "device_cell_high"
	req_tech = list(TECH_POWER = 2)
	materials = list(MATERIAL_STEEL = 70, MATERIAL_GLASS = 6,MATERIAL_PHORON = 100)
	build_path = /obj/item/weapon/cell/device/high
	sort_string = "DAAAF"
	category = "Parts"

/datum/design/item/engifab/parts/adv/subspace_ansible
	name = "Subspace ansible"
	id = "sansible"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(MATERIAL_STEEL = 80, MATERIAL_SILVER = 20)
	build_path = /obj/item/weapon/stock_parts/subspace/ansible
	sort_string = "UAAAA"
	category = "Parts"

/datum/design/item/engifab/parts/adv/hyperwave_filter
	name = "Hyperwave Filter"
	id = "s-filter"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 3)
	materials = list(MATERIAL_STEEL = 40, MATERIAL_SILVER = 10)
	build_path = /obj/item/weapon/stock_parts/subspace/filter
	sort_string = "UAAAB"
	category = "Parts"

/datum/design/item/engifab/parts/adv/subspace_amplifier
	name = "Subspace amplifier"
	id = "s-amplifier"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(MATERIAL_STEEL = 10, MATERIAL_GOLD = 30, MATERIAL_URANIUM = 15)
	build_path = /obj/item/weapon/stock_parts/subspace/amplifier
	sort_string = "UAAAC"
	category = "Parts"

/datum/design/item/engifab/parts/adv/subspace_treatment
	name = "Subspace treatment:"
	id = "s-treatment"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 2, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(MATERIAL_STEEL = 10, MATERIAL_SILVER = 20)
	build_path = /obj/item/weapon/stock_parts/subspace/treatment
	sort_string = "UAAAD"
	category = "Parts"

/datum/design/item/engifab/parts/adv/subspace_analyzer
	name = "Subspace analyzer"
	id = "s-analyzer"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(MATERIAL_STEEL = 10, MATERIAL_GOLD = 15)
	build_path = /obj/item/weapon/stock_parts/subspace/analyzer
	sort_string = "UAAAE"
	category = "Parts"

/datum/design/item/engifab/parts/adv/subspace_crystal
	name = "Subspace crystal"
	id = "s-crystal"
	req_tech = list(TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(MATERIAL_GLASS = 1000, MATERIAL_SILVER = 20, MATERIAL_GOLD = 20)
	build_path = /obj/item/weapon/stock_parts/subspace/crystal
	sort_string = "UAAAF"
	category = "Parts"

/datum/design/item/engifab/parts/adv/subspace_transmitter
	name = "Subspace transmitter"
	id = "s-transmitter"
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 5, TECH_BLUESPACE = 3)
	materials = list(MATERIAL_GLASS = 100, MATERIAL_SILVER = 10, MATERIAL_URANIUM = 15)
	build_path = /obj/item/weapon/stock_parts/subspace/transmitter
	sort_string = "UAAAG"
	category = "Parts"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Floor Tiles

/datum/design/item/engifab/floortiles
	category = "Floor tiles"
	time = 5

/////////////////////////////////////////////////////////////////////////////////////////////
//Carpets
/////////////////////////////////////////////////////////////////////////////////////////////

/datum/design/item/engifab/floortiles/carpet/brown
	name = "Brown carpet"
	id = "brown carpet"
	build_path = /obj/item/stack/tile/carpet
	category = "Floor Tiles"
	materials = list(MATERIAL_CLOTH = 100, MATERIAL_PLASTIC = 10)

/datum/design/item/engifab/floortiles/carpet/blue
	name = "Blue carpet"
	id = "blue carpet"
	build_path = /obj/item/stack/tile/carpetblue2
	category = "Floor Tiles"
	materials = list(MATERIAL_CLOTH = 100, MATERIAL_PLASTIC = 10)

/datum/design/item/engifab/floortiles/carpet/purple
	name = "Purple carpet"
	id = "purple carpet"
	build_path = /obj/item/stack/tile/carpetpurple
	category = "Floor Tiles"
	materials = list(MATERIAL_CLOTH = 100, MATERIAL_PLASTIC = 10)

/datum/design/item/engifab/floortiles/carpet/orange
	name = "Orange carpet"
	id = "orange carpet"
	build_path = /obj/item/stack/tile/carpetorange
	category = "Floor Tiles"
	materials = list(MATERIAL_CLOTH = 100, MATERIAL_PLASTIC = 10)

/datum/design/item/engifab/floortiles/carpet/green
	name = "Green carpet"
	id = "green carpet"
	build_path = /obj/item/stack/tile/carpetgreen
	category = "Floor Tiles"
	materials = list(MATERIAL_CLOTH = 100, MATERIAL_PLASTIC = 10)

/datum/design/item/engifab/floortiles/carpet/red
	name = "Red carpet"
	id = "red carpet"
	build_path = /obj/item/stack/tile/carpetred
	category = "Floor Tiles"
	materials = list(MATERIAL_CLOTH = 100, MATERIAL_PLASTIC = 10)

////////////////////////////////////////////////////////////////////////////////////////////////
// Plastic Flooring
////////////////////////////////////////////////////////////////////////////////////////////////
/datum/design/item/engifab/floortiles/plastic/linoleum
	name = "Linoleum flooring"
	id = "linoleum_flooring"
	build_path = /obj/item/stack/tile/linoleum
	category = "Floor Tiles"
	materials = list(MATERIAL_PLASTIC = 1)

/datum/design/item/engifab/floortiles/plastic/floor_freezer
	name = "Freezer flooring"
	id = "freezer_flooring"
	build_path = /obj/item/stack/tile/floor_freezer
	category = "Floor Tiles"
	materials = list(MATERIAL_PLASTIC = 1)

/datum/design/item/engifab/floortiles/plastic/white
	name = "White plastic flooring"
	id = "white_plastic_flooring"
	build_path = /obj/item/stack/tile/floor_white
	category = "Floor Tiles"
	materials = list(MATERIAL_PLASTIC = 1)

////////////////////////////////////////////////////////////////////////////////////////////////
// Steel Flooring
////////////////////////////////////////////////////////////////////////////////////////////////
/datum/design/item/engifab/floortiles/floor
	name = "Steel flooring"
	id = "steel_flooring"
	build_path = /obj/item/stack/tile/floor
	category = "Floor Tiles"
	materials = list(MATERIAL_STEEL = 1)

/datum/design/item/engifab/floortiles/floor_dark
	name = "Plasteel flooring"
	id = "plasteel_flooring"
	build_path = /obj/item/stack/tile/floor_dark
	category = "Floor Tiles"
	materials = list(MATERIAL_PLASTEEL = 1)
