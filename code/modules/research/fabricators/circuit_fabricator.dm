/obj/machinery/fabricator/circuit_fabricator
	name = "Circuit Imprinter"
	desc = "A machine used for the production of circuits."
	req_access = list(core_access_science_programs)
	circuit = /obj/item/weapon/circuitboard/fabricator/circuitfab
	build_type = CIRCUITFAB

	icon_state = 	 "circuitfab-idle"
	icon_idle = 	 "circuitfab-idle"
	icon_open = 	 "circuitfab-o"
	overlay_active = "circuitfab-active"
	metal_load_anim = FALSE

	has_reagents = TRUE

////////////////////////////////////////////////////
//////////////////////DESIGNS///////////////////////
////////////////////////////////////////////////////

/datum/design/circuit
	build_type = CIRCUITFAB
	req_tech = list(TECH_DATA = 2)
	materials = list(MATERIAL_GLASS = 2000)
	chemicals = list(/datum/reagent/acid = 20)
	category = "Circuits"
	time = 5

/datum/design/circuit/AssembleDesignName()
	..()
	if(build_path)
		var/obj/item/weapon/circuitboard/C = build_path
		if(initial(C.board_type) == "machine")
			category = "Machine Circuits"
		else if(initial(C.board_type) == "computer")
			category = "Computer Circuits"
		name = "Circuit ([item_name])"

/datum/design/circuit/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a [item_name] circuit board."

/datum/design/circuit/arcademachine
	name = "battle arcade machine"
	id = "arcademachine"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/weapon/circuitboard/arcade/battle

/datum/design/circuit/oriontrail
	name = "orion trail arcade machine"
	id = "oriontrail"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/weapon/circuitboard/arcade/orion_trail

/datum/design/circuit/prisonmanage
	name = "prisoner management console"
	id = "prisonmanage"
	build_path = /obj/item/weapon/circuitboard/prisoner

/datum/design/circuit/operating
	name = "patient monitoring console"
	id = "operating"
	build_path = /obj/item/weapon/circuitboard/operating

/datum/design/circuit/cryo_cell
	name = "Cryotube"
	id = "cryocell"
	req_tech = list(TECH_DATA = 2, TECH_BIO = 3, TECH_ENGINEERING = 4)
	build_path = /obj/item/weapon/circuitboard/cryo_tube

/datum/design/circuit/resleever
	name = "neural lace resleever"
	id = "resleever"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/weapon/circuitboard/resleever

/datum/design/circuit/crewconsole
	name = "crew monitoring console"
	id = "crewconsole"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 2, TECH_BIO = 2)
	build_path = /obj/item/weapon/circuitboard/crew

/*
/datum/design/circuit/bioprinter
	name = "bioprinter"
	id = "bioprinter"
	req_tech = list(TECH_ENGINEERING = 1, TECH_BIO = 3, TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/bioprinter
*/

/datum/design/circuit/roboprinter
	name = "prosthetic organ fabricator"
	id = "roboprinter"
	req_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/roboprinter

/datum/design/circuit/teleconsole
	name = "teleporter control console"
	id = "teleconsole"
	req_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 2)
	build_path = /obj/item/weapon/circuitboard/teleporter

/datum/design/circuit/robocontrol
	name = "robotics control console"
	id = "robocontrol"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/robotics

/datum/design/circuit/mechacontrol
	name = "exosuit control console"
	id = "mechacontrol"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/mecha_control

/datum/design/circuit/rdconsole
	name = "R&D control console"
	id = "rdconsole"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/rdconsole

/datum/design/circuit/comm_monitor
	name = "telecommunications monitoring console"
	id = "comm_monitor"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/comm_monitor

/datum/design/circuit/comm_server
	name = "telecommunications server monitoring console"
	id = "comm_server"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/comm_server

/datum/design/circuit/message_monitor
	name = "messaging monitor console"
	id = "message_monitor"
	req_tech = list(TECH_DATA = 5)
	build_path = /obj/item/weapon/circuitboard/message_monitor

/datum/design/circuit/aiupload
	name = "AI upload console"
	id = "aiupload"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/aiupload

/datum/design/circuit/borgupload
	name = "cyborg upload console"
	id = "borgupload"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/borgupload

/datum/design/circuit/destructive_analyzer
	name = "destructive analyzer"
	id = "destructive_analyzer"
	req_tech = list(TECH_DATA = 2, TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/destructive_analyzer

/datum/design/circuit/protolathe
	name = "protolathe"
	id = "protolathe"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/protolathe

/datum/design/circuit/autolathe
	name = "autolathe board"
	id = "autolathe"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/autolathe

/datum/design/circuit/mining_console
	name = "mining console board"
	id = "mining_console"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/mineral_processing

/datum/design/circuit/mining_processor
	name = "mining processor board"
	id = "mining_processor"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/mining_processor

/datum/design/circuit/mining_unloader
	name = "ore unloader board"
	id = "mining_unloader"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/mining_unloader

/datum/design/circuit/mining_stacker
	name = "sheet stacker board"
	id = "mining_stacker"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/mining_stacker

/datum/design/circuit/rdservercontrol
	name = "R&D server control console"
	id = "rdservercontrol"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/rdservercontrol

/datum/design/circuit/rdserver
	name = "R&D server"
	id = "rdserver"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/rdserver

/datum/design/circuit/mech_recharger
	name = "mech recharger"
	id = "mech_recharger"
	req_tech = list(TECH_DATA = 2, TECH_POWER = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/mech_recharger

/datum/design/circuit/recharge_station
	name = "cyborg recharge station"
	id = "recharge_station"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/recharge_station

/datum/design/circuit/atmosalerts
	name = "atmosphere alert console"
	id = "atmosalerts"
	build_path = /obj/item/weapon/circuitboard/atmos_alert

/datum/design/circuit/air_management
	name = "atmosphere monitoring console"
	id = "air_management"
	build_path = /obj/item/weapon/circuitboard/air_management

/datum/design/circuit/rcon_console
	name = "RCON remote control console"
	id = "rcon_console"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_POWER = 5)
	build_path = /obj/item/weapon/circuitboard/rcon_console

/datum/design/circuit/dronecontrol
	name = "drone control console"
	id = "dronecontrol"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/drone_control

/datum/design/circuit/powermonitor
	name = "power monitoring console"
	id = "powermonitor"
	build_path = /obj/item/weapon/circuitboard/powermonitor

/datum/design/circuit/solarcontrol
	name = "solar control console"
	id = "solarcontrol"
	build_path = /obj/item/weapon/circuitboard/solar_control

/datum/design/circuit/tracker_electronics
	name = "Solar Tracker"
	id = "tracker_electronics"
	build_path = /obj/item/weapon/tracker_electronics

/datum/design/circuit/pacman
	name = "PACMAN-type generator"
	id = "pacman"
	req_tech = list(TECH_DATA = 3, TECH_PHORON = 3, TECH_POWER = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/weapon/circuitboard/pacman

/datum/design/circuit/superpacman
	name = "SUPERPACMAN-type generator"
	id = "superpacman"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 4, TECH_ENGINEERING = 4)
	build_path = /obj/item/weapon/circuitboard/pacman/super

/datum/design/circuit/mrspacman
	name = "MRSPACMAN-type generator"
	id = "mrspacman"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 5, TECH_ENGINEERING = 5)
	build_path = /obj/item/weapon/circuitboard/pacman/mrs

/datum/design/circuit/batteryrack
	name = "cell rack PSU"
	id = "batteryrack"
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/batteryrack

/datum/design/circuit/smes_cell
	name = "'SMES' superconductive magnetic energy storage"
	desc = "Allows for the construction of circuit boards used to build a SMES."
	id = "smes_cell"
	req_tech = list(TECH_POWER = 7, TECH_ENGINEERING = 5)
	build_path = /obj/item/weapon/circuitboard/smes

/datum/design/circuit/gas_heater
	name = "gas heating system"
	id = "gasheater"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/unary_atmos/heater

/datum/design/circuit/gas_cooler
	name = "gas cooling system"
	id = "gascooler"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/unary_atmos/cooler

/datum/design/circuit/secure_airlock
	name = "secure airlock electronics"
	desc =  "Allows for the construction of a tamper-resistant airlock electronics."
	id = "securedoor"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/airlock_electronics/secure

/datum/design/circuit/biogenerator
	name = "biogenerator"
	id = "biogenerator"
	req_tech = list(TECH_DATA = 2)
	build_path = /obj/item/weapon/circuitboard/biogenerator

/datum/design/circuit/miningdrill
	name = "mining drill head"
	id = "mining drill head"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/miningdrill

/datum/design/circuit/gasdrill
	name = "gas drill head"
	id = "gas drill head"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/gasdrill

/datum/design/circuit/miningdrillbrace
	name = "mining drill brace"
	id = "mining drill brace"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/miningdrillbrace
/datum/design/circuit/clonepod
	name = "clone pod"
	id = "clonepod"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/weapon/circuitboard/clonepod
//This sorting system is too autistic for me, so fuck it, they're all starting at Z and working their way up
/datum/design/circuit/chem_dispenser
	name = "Portable Chem Dispenser"
	id = "chem_dispenser"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 2, TECH_ENGINEERING = 3)
	build_path = /obj/item/weapon/circuitboard/chem_dispenser
/datum/design/circuit/reagentgrinder
	name = "Reagent Grinder"
	id = "reagent_grinder"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 1, TECH_BIO = 1)
	build_path = /obj/item/weapon/circuitboard/reagentgrinder
/datum/design/circuit/chem_master
	name = "Chem Master"
	id = "chem_master"
	req_tech = list(TECH_MATERIAL = 2, TECH_DATA = 3, TECH_BIO = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/chem_master
/datum/design/circuit/libraryscanner
	name = "Book Scanner"
	id = "libraryscanner"
	req_tech = list(TECH_MATERIAL =1, TECH_DATA = 1)
	build_path = /obj/item/weapon/circuitboard/libraryscanner
/datum/design/circuit/bookbinder
	name = "Book Binder"
	id = "bookbinder"
	req_tech = list(TECH_MATERIAL =1, TECH_DATA = 1)
	build_path = /obj/item/weapon/circuitboard/bookbinder
/datum/design/circuit/smartfridge
	name = "Modular Smart Fridge"
	id = "smartfridge"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/weapon/circuitboard/smartfridge
/datum/design/circuit/generator
	name = "Thermoelectric Generator"
	id = "generator"
	req_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 4)
	build_path = /obj/item/weapon/circuitboard/generator
/datum/design/circuit/circulator
	name = "Circulator"
	id = "circulator"
	req_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 4)
	build_path = /obj/item/weapon/circuitboard/circulator
/datum/design/circuit/telepad
	name = "Telepad"
	id = "telepad"
	req_tech = list(TECH_BLUESPACE = 2)
	build_path = /obj/item/weapon/circuitboard/telepad
/datum/design/circuit/photocopier
	name = "Photocopier"
	id = "photocopier"
	req_tech = list(TECH_MATERIAL = 2, TECH_DATA = 2)
	build_path = /obj/item/weapon/circuitboard/photocopier
/datum/design/circuit/gibber
	name = "Meat Grinder"
	id = "gibber"
	req_tech = list(TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/gibber
/datum/design/circuit/microwave
	name = "Microwave"
	id = "microwave"
	req_tech = list(TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/microwave
/datum/design/circuit/oven
	name = "Oven"
	id = "oven"
	req_tech = list(TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/oven
/datum/design/circuit/grill
	name = "Grill"
	id = "grill"
	req_tech = list(TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/grill
/datum/design/circuit/candy_maker
	name = "Candy Maker"
	id = "candy_maker"
	req_tech = list(TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/candy_maker
/datum/design/circuit/deepfryer
	name = "Deep Fryer"
	id = "deepfryer"
	req_tech = list(TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/deepfryer
/datum/design/circuit/cereal
	name = "Cereal Maker"
	id = "cereal"
	req_tech = list(TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/cereal
/datum/design/circuit/bodyscanner_console
	name = "Body Scanner Console"
	id = "bodyscanner_console"
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2, TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/bodyscanner_console
/datum/design/circuit/bodyscanner
	name = "Body Scanner"
	id = "bodyscanner"
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2, TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/bodyscanner
/datum/design/circuit/sleeper
	name = "Sleeper"
	id = "sleeper"
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2, TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/sleeper
/datum/design/circuit/area_atmos
	name = "Area Air Control Console"
	id = "area_atmos"
	req_tech = list(TECH_DATA = 2)
	build_path = /obj/item/weapon/circuitboard/area_atmos
/datum/design/circuit/holopad
	name = "Holopad"
	id = "holopad"
	req_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 3, TECH_BLUESPACE = 1)
	build_path = /obj/item/weapon/circuitboard/holopad
/datum/design/circuit/holopad_longrange
	name = "Long Range Holopad"
	id = "holopad_longrange"
	req_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 3, TECH_BLUESPACE = 2)
	build_path = /obj/item/weapon/circuitboard/holopad_longrange
/datum/design/circuit/cryopod
	name = "Cryogenic Freezer"
	id = "cryopod"
	req_tech = list(TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/cryopod
/datum/design/circuit/atm
	name = "Automatic Teller Machine (ATM)"
	id = "atm"
	req_tech = list(TECH_ENGINEERING = 1,TECH_DATA = 1)
	build_path = /obj/item/weapon/circuitboard/atm
/datum/design/circuit/recycler
	name = "Recycler"
	id = "recycler"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/recycler
/datum/design/circuit/microscope
	name = "Microscope"
	id = "microscope"
	req_tech = list(TECH_DATA = 2, TECH_BIO = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/weapon/circuitboard/microscope
/datum/design/circuit/dnaforensics
	name = "DNA Analyzer"
	id = "dnaforensics"
	req_tech = list(TECH_DATA = 2, TECH_BIO = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/weapon/circuitboard/dnaforensics
/datum/design/circuit/turbine
	name = "Gas Turbine"
	id = "turbine"
	req_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 4)
	build_path = /obj/item/weapon/circuitboard/turbine
/datum/design/circuit/compressor
	name = "Compressor"
	id = "compressor"
	req_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 4)
	build_path = /obj/item/weapon/circuitboard/compressor
/datum/design/circuit/turbine_control
	name = "Gas Turbine Control Console"
	id = "turbine_control"
	req_tech = list(TECH_ENGINEERING = 2, TECH_POWER = 2, TECH_DATA = 2)
	build_path = /obj/item/weapon/circuitboard/turbine_control
/datum/design/circuit/pipeturbine
	name = "Pipe Turbine"
	id = "pipeturbine"
	req_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 4)
	build_path = /obj/item/weapon/circuitboard/pipeturbine
/datum/design/circuit/turbinemotor
	name = "Turbine Motor"
	id = "turbinemotor"
	req_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 4)
	build_path = /obj/item/weapon/circuitboard/turbinemotor
/datum/design/circuit/botany_extractor
	name = "Lysis-Isolation Centrifuge"
	id = "botany_extractor"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2, TECH_BIO = 3, TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/botany_extractor
/datum/design/circuit/botany_editor
	name = "Bioballistic Delivery System"
	id = "botany_editor"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2, TECH_BIO = 3, TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/botany_editor
/datum/design/circuit/seed_extractor
	name = "Seed Extractor"
	id = "seed_extractor"
	req_tech = list(TECH_BIO = 3, TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/seed_extractor
/datum/design/circuit/diseaseanalyser
	name = "Disease Analyzer"
	id = "diseaseanalyser"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/weapon/circuitboard/diseaseanalyser
/datum/design/circuit/centrifuge
	name = "Centrifuge"
	id = "centrifuge"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/weapon/circuitboard/centrifuge
/datum/design/circuit/incubator
	name = "Incubator"
	id = "incubator"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/weapon/circuitboard/incubator
/datum/design/circuit/isolator
	name = "Isolator"
	id = "isolator"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/weapon/circuitboard/isolator
/datum/design/circuit/splicer
	name = "Disease Splicer"
	id = "splicer"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/weapon/circuitboard/splicer
/datum/design/circuit/shuttleengine
	name = "Shuttle Engine"
	id = "shuttleengine"
	req_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 4)
	build_path = /obj/item/weapon/circuitboard/shuttleengine
/datum/design/circuit/dockingbeacon
	name = "Docking Beacon"
	id = "dockingbeacon"
	req_tech = list(TECH_ENGINEERING = 4, TECH_BLUESPACE = 4)
	build_path = /obj/item/weapon/circuitboard/docking_beacon
/datum/design/circuit/bridgecomputer
	name = "Bridge Computer"
	id = "bridgecomputer"
	req_tech = list(TECH_ENGINEERING = 4, TECH_BLUESPACE = 4)
	build_path = /obj/item/weapon/circuitboard/bridge_computer
/datum/design/circuit/metal_detector
	name= "Metal Detector"
	id = "metal_detector"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 3)
	build_path = /obj/item/weapon/circuitboard/metal_detector

/datum/design/circuit/incinerator
	name= "Trash incinerator"
	id = "trash_incinerator"
	req_tech = list(TECH_ENGINEERING = 1, TECH_BIO = 1)
	build_path = /obj/item/weapon/circuitboard/incinerator

/datum/design/circuit/crematorium
	name= "Crematorium"
	id = "corpse_incinerator"
	req_tech = list(TECH_ENGINEERING = 1, TECH_BIO = 1)
	build_path = /obj/item/weapon/circuitboard/crematorium

/datum/design/circuit/diseasesplicer
	name= "Disease splicer"
	id = "disease_splicer"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 2)
	build_path = /obj/item/weapon/circuitboard/diseasesplicer

/*
/datum/design/circuit/
	name = ""
	id = ""
	req_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1, TECH_PHORON = 1, TECH_POWER = 1, TECH_BLUESPACE = 1, TECH_BIO = 1, TECH_COMBAT = 1, TECH_MAGNET = 1, TECH_DATA = 1, TECH_ILLEGAL = 1)
	build_path = /obj/item/weapon/circuitboard/
/datum/design/circuit/
	name = ""
	id = ""
	req_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1, TECH_PHORON = 1, TECH_POWER = 1, TECH_BLUESPACE = 1, TECH_BIO = 1, TECH_COMBAT = 1, TECH_MAGNET = 1, TECH_DATA = 1, TECH_ILLEGAL = 1)
	build_path = /obj/item/weapon/circuitboard/
/datum/design/circuit/
	name = ""
	id = ""
	req_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1, TECH_PHORON = 1, TECH_POWER = 1, TECH_BLUESPACE = 1, TECH_BIO = 1, TECH_COMBAT = 1, TECH_MAGNET = 1, TECH_DATA = 1, TECH_ILLEGAL = 1)
	build_path = /obj/item/weapon/circuitboard/
/datum/design/circuit/
	name = ""
	id = ""
	req_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1, TECH_PHORON = 1, TECH_POWER = 1, TECH_BLUESPACE = 1, TECH_BIO = 1, TECH_COMBAT = 1, TECH_MAGNET = 1, TECH_DATA = 1, TECH_ILLEGAL = 1)
	build_path = /obj/item/weapon/circuitboard/
/datum/design/circuit/
	name = ""
	id = ""
	req_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1, TECH_PHORON = 1, TECH_POWER = 1, TECH_BLUESPACE = 1, TECH_BIO = 1, TECH_COMBAT = 1, TECH_MAGNET = 1, TECH_DATA = 1, TECH_ILLEGAL = 1)
	build_path = /obj/item/weapon/circuitboard/
/datum/design/circuit/
	name = ""
	id = ""
	req_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1, TECH_PHORON = 1, TECH_POWER = 1, TECH_BLUESPACE = 1, TECH_BIO = 1, TECH_COMBAT = 1, TECH_MAGNET = 1, TECH_DATA = 1, TECH_ILLEGAL = 1)
	build_path = /obj/item/weapon/circuitboard/
/datum/design/circuit/
	name = ""
	id = ""
	req_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1, TECH_PHORON = 1, TECH_POWER = 1, TECH_BLUESPACE = 1, TECH_BIO = 1, TECH_COMBAT = 1, TECH_MAGNET = 1, TECH_DATA = 1, TECH_ILLEGAL = 1)
	build_path = /obj/item/weapon/circuitboard/
/datum/design/circuit/
	name = ""
	id = ""
	req_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1, TECH_PHORON = 1, TECH_POWER = 1, TECH_BLUESPACE = 1, TECH_BIO = 1, TECH_COMBAT = 1, TECH_MAGNET = 1, TECH_DATA = 1, TECH_ILLEGAL = 1)
	build_path = /obj/item/weapon/circuitboard/
/datum/design/circuit/
	name = ""
	id = ""
	req_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1, TECH_PHORON = 1, TECH_POWER = 1, TECH_BLUESPACE = 1, TECH_BIO = 1, TECH_COMBAT = 1, TECH_MAGNET = 1, TECH_DATA = 1, TECH_ILLEGAL = 1)
	build_path = /obj/item/weapon/circuitboard/
*/



/datum/design/circuit/mecha
	category = "Mecha Circuits"
	req_tech = list(TECH_DATA = 3)

/datum/design/circuit/mecha/AssembleDesignName()
	name = "Exosuit module circuit design ([name])"
/datum/design/circuit/mecha/AssembleDesignDesc()
	desc = "Allows for the construction of \a [name] module."

/datum/design/circuit/mecha/ripley_main
	name = "APLU 'Ripley' central control"
	id = "ripley_main"
	build_path = /obj/item/weapon/circuitboard/mecha/ripley/main

/datum/design/circuit/mecha/ripley_peri
	name = "APLU 'Ripley' peripherals control"
	id = "ripley_peri"
	build_path = /obj/item/weapon/circuitboard/mecha/ripley/peripherals

/datum/design/circuit/mecha/odysseus_main
	name = "'Odysseus' central control"
	id = "odysseus_main"
	req_tech = list(TECH_DATA = 3,TECH_BIO = 2)
	build_path = /obj/item/weapon/circuitboard/mecha/odysseus/main

/datum/design/circuit/mecha/odysseus_peri
	name = "'Odysseus' peripherals control"
	id = "odysseus_peri"
	req_tech = list(TECH_DATA = 3,TECH_BIO = 2)
	build_path = /obj/item/weapon/circuitboard/mecha/odysseus/peripherals

/datum/design/circuit/mecha/gygax_main
	name = "'Gygax' central control"
	id = "gygax_main"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/mecha/gygax/main

/datum/design/circuit/mecha/gygax_peri
	name = "'Gygax' peripherals control"
	id = "gygax_peri"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/mecha/gygax/peripherals

/datum/design/circuit/mecha/gygax_targ
	name = "'Gygax' weapon control and targeting"
	id = "gygax_targ"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	build_path = /obj/item/weapon/circuitboard/mecha/gygax/targeting

/datum/design/circuit/mecha/durand_main
	name = "'Durand' central control"
	id = "durand_main"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/mecha/durand/main

/datum/design/circuit/mecha/durand_peri
	name = "'Durand' peripherals control"
	id = "durand_peri"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/mecha/durand/peripherals

/datum/design/circuit/mecha/durand_targ
	name = "'Durand' weapon control and targeting"
	id = "durand_targ"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	build_path = /obj/item/weapon/circuitboard/mecha/durand/targeting

/datum/design/circuit/tcom
	category = "Telecommunications Circuits"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)

/datum/design/circuit/tcom/AssembleDesignName()
	name = "Telecommunications machinery circuit design ([name])"
/datum/design/circuit/tcom/AssembleDesignDesc()
	desc = "Allows for the construction of a telecommunications [name] circuit board."

/datum/design/circuit/tcom/server
	name = "server mainframe"
	id = "tcom-server"
	build_path = /obj/item/weapon/circuitboard/telecomms/server

/datum/design/circuit/tcom/processor
	name = "processor unit"
	id = "tcom-processor"
	build_path = /obj/item/weapon/circuitboard/telecomms/processor

/datum/design/circuit/tcom/bus
	name = "bus mainframe"
	id = "tcom-bus"
	build_path = /obj/item/weapon/circuitboard/telecomms/bus

/datum/design/circuit/tcom/hub
	name = "hub mainframe"
	id = "tcom-hub"
	build_path = /obj/item/weapon/circuitboard/telecomms/hub

/datum/design/circuit/tcom/relay
	name = "relay mainframe"
	id = "tcom-relay"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 4, TECH_BLUESPACE = 3)
	build_path = /obj/item/weapon/circuitboard/telecomms/relay

/datum/design/circuit/tcom/broadcaster
	name = "subspace broadcaster"
	id = "tcom-broadcaster"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_BLUESPACE = 2)
	build_path = /obj/item/weapon/circuitboard/telecomms/broadcaster

/datum/design/circuit/tcom/receiver
	name = "subspace receiver"
	id = "tcom-receiver"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_BLUESPACE = 2)
	build_path = /obj/item/weapon/circuitboard/telecomms/receiver

/datum/design/circuit/bluespace_satellite
	name = "bluespace satellite"
	id = "bluespace-satellite"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_BLUESPACE = 3)
	build_path = /obj/item/weapon/circuitboard/telecomms/bluespace_satellite


/datum/design/circuit/shield_generator
	name = "Shield Generator"
	desc = "Allows for the construction of a shield generator circuit board."
	id = "shield_generator"
	req_tech = list(TECH_MAGNET = 3, TECH_POWER = 4)
	build_path = /obj/item/weapon/circuitboard/shield_generator

/datum/design/circuit/shield_diffuser
	name = "Shield Diffuser"
	desc = "Allows for the construction of a shield generator circuit board."
	id = "shield_diffuser"
	req_tech = list(TECH_MAGNET = 3, TECH_POWER = 4)
	build_path = /obj/item/weapon/circuitboard/shield_diffuser

/datum/design/circuit/ntnet_relay
	name = "NTNet Quantum Relay"
	id = "ntnet_relay"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/ntnet_relay

/datum/design/circuit/replicator
	name = "food replicator"
	id = "freplicator"
	req_tech = list(TECH_BIO = 3, TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/replicator

/datum/design/circuit/aicore
	name = "AI core"
	id = "aicore"
	req_tech = list(TECH_DATA = 4, TECH_BIO = 3)
	build_path = /obj/item/weapon/circuitboard/aicore

/datum/design/circuit/cellcharger
	name = "cell charger"
	id = "cellcharger"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/weapon/circuitboard/machinery/cell_charger

/datum/design/circuit/recharger
	name = "recharger"
	id = "recharger"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/weapon/circuitboard/machinery/recharger

/datum/design/circuit/suit_storage_unit
	name = "Suit Storage Unit"
	id = "suit_storage_unit"
	req_tech = list(TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/suit_storage_unit

/datum/design/circuit/suit_cycler
	name = "Suit Cycler"
	id = "suit_cycler"
	req_tech = list(TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/suit_cycler

/datum/design/aimodule
	category = "AI Modules"
	build_type = CIRCUITFAB
	materials = list(MATERIAL_GLASS = 2000, MATERIAL_GOLD = 100)

/datum/design/aimodule/AssembleDesignName()
	name = "AI module design ([name])"

/datum/design/aimodule/AssembleDesignDesc()
	desc = "Allows for the construction of \a '[name]' AI module."

/datum/design/aimodule/safeguard
	name = "Safeguard"
	id = "safeguard"
	req_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/aiModule/safeguard

/datum/design/aimodule/onehuman
	name = "OneCrewMember"
	id = "onehuman"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 6)
	build_path = /obj/item/weapon/aiModule/oneHuman

/datum/design/aimodule/protectstation
	name = "ProtectInstallation"
	id = "protectstation"
	req_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6)
	build_path = /obj/item/weapon/aiModule/protectStation

/datum/design/aimodule/notele
	name = "TeleporterOffline"
	id = "notele"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/aiModule/teleporterOffline

/datum/design/aimodule/quarantine
	name = "Quarantine"
	id = "quarantine"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 2, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/aiModule/quarantine

/datum/design/aimodule/oxygen
	name = "OxygenIsToxicToHumans"
	id = "oxygen"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 2, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/aiModule/oxygen

/datum/design/aimodule/freeform
	name = "Freeform"
	id = "freeform"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/aiModule/freeform

/datum/design/aimodule/reset
	name = "Reset"
	id = "reset"
	req_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6)
	build_path = /obj/item/weapon/aiModule/reset

/datum/design/aimodule/purge
	name = "Purge"
	id = "purge"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 6)
	build_path = /obj/item/weapon/aiModule/purge

// Core modules
/datum/design/aimodule/core
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 6)

/datum/design/aimodule/core/AssembleDesignName()
	name = "AI core module design ([name])"

/datum/design/aimodule/core/AssembleDesignDesc()
	desc = "Allows for the construction of \a '[name]' AI core module."

/datum/design/aimodule/core/freeformcore
	name = "Freeform"
	id = "freeformcore"
	build_path = /obj/item/weapon/aiModule/freeformcore

/datum/design/aimodule/core/asimov
	name = "Asimov"
	id = "asimov"
	build_path = /obj/item/weapon/aiModule/asimov

/datum/design/aimodule/core/paladin
	name = "P.A.L.A.D.I.N."
	id = "paladin"
	build_path = /obj/item/weapon/aiModule/paladin

/datum/design/aimodule/core/tyrant
	name = "T.Y.R.A.N.T."
	id = "tyrant"
	req_tech = list(TECH_DATA = 4, TECH_ILLEGAL = 2, TECH_MATERIAL = 6)
	build_path = /obj/item/weapon/aiModule/tyrant

// Network cards
/datum/design/item/modularcomponent/netcard/basic
	name = "basic network card"
	id = "netcard_basic"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 1)
	build_type = CIRCUITFAB
	materials = list(MATERIAL_STEEL = 250, MATERIAL_GLASS = 100)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/weapon/computer_hardware/network_card

/datum/design/item/modularcomponent/netcard/advanced
	name = "advanced network card"
	id = "netcard_advanced"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 2)
	build_type = CIRCUITFAB
	materials = list(MATERIAL_STEEL = 500, MATERIAL_GLASS = 200)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/weapon/computer_hardware/network_card/advanced

/datum/design/item/modularcomponent/netcard/wired
	name = "wired network card"
	id = "netcard_wired"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 3)
	build_type = CIRCUITFAB
	materials = list(MATERIAL_STEEL = 2500, MATERIAL_GLASS = 400)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/weapon/computer_hardware/network_card/wired

// Data crystals (USB flash drives)
/datum/design/item/modularcomponent/portabledrive/basic
	name = "basic data crystal"
	id = "portadrive_basic"
	req_tech = list(TECH_DATA = 1)
	build_type = CIRCUITFAB
	materials = list(MATERIAL_GLASS = 800)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/portable

/datum/design/item/modularcomponent/portabledrive/advanced
	name = "advanced data crystal"
	id = "portadrive_advanced"
	req_tech = list(TECH_DATA = 2)
	build_type = CIRCUITFAB
	materials = list(MATERIAL_GLASS = 1600)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/portable/advanced

/datum/design/item/modularcomponent/portabledrive/super
	name = "super data crystal"
	id = "portadrive_super"
	req_tech = list(TECH_DATA = 4)
	build_type = CIRCUITFAB
	materials = list(MATERIAL_GLASS = 3200)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/portable/super

// Processor unit
/datum/design/item/modularcomponent/cpu/
	name = "computer processor unit"
	id = "cpu_normal"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	build_type = CIRCUITFAB
	materials = list(MATERIAL_STEEL = 1600)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/weapon/computer_hardware/processor_unit

/datum/design/item/modularcomponent/cpu/small
	name = "computer microprocessor unit"
	id = "cpu_small"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = CIRCUITFAB
	materials = list(MATERIAL_STEEL = 800)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/weapon/computer_hardware/processor_unit/small

/datum/design/item/modularcomponent/cpu/photonic
	name = "computer photonic processor unit"
	id = "pcpu_normal"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 4)
	build_type = CIRCUITFAB
	materials = list(MATERIAL_STEEL = 6400, glass = 2000)
	chemicals = list(/datum/reagent/acid = 40)
	build_path = /obj/item/weapon/computer_hardware/processor_unit/photonic

/datum/design/item/modularcomponent/cpu/photonic/small
	name = "computer photonic microprocessor unit"
	id = "pcpu_small"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3)
	build_type = CIRCUITFAB
	materials = list(MATERIAL_STEEL = 3200, glass = 1000)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/weapon/computer_hardware/processor_unit/photonic/small

// inteliCard Slot
/datum/design/item/modularcomponent/aislot
	name = "inteliCard slot"
	id = "aislot"
	req_tech = list(TECH_POWER = 2, TECH_DATA = 3)
	build_type = CIRCUITFAB
	materials = list(MATERIAL_STEEL = 2000)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/weapon/computer_hardware/ai_slot
