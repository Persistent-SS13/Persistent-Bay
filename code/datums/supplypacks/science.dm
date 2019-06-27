/decl/hierarchy/supply_pack/science
	name = "Research - Exploration"

/decl/hierarchy/supply_pack/science/chemistry_dispenser
	name = "Equipment - Chemical Reagent dispenser"
	contains = list(
			/obj/machinery/chemical_dispenser{anchored = 0}
		)
	cost = 25
	containertype = /obj/structure/largecrate
	containername = "reagent dispenser crate"

/decl/hierarchy/supply_pack/science/bombsuit_pack
	name = "Equipment - Scientist explosion resistant suit"
	contains = list(/obj/item/clothing/suit/bomb_suit,
					/obj/item/clothing/head/bomb_hood,
					/obj/item/clothing/shoes/eod)
	cost = 50
	containertype = /obj/structure/closet/bombcloset
	containername = "EOD closet"

/decl/hierarchy/supply_pack/science/virus
	name = "Samples - Virus (BIOHAZARD)"
	contains = list(/obj/item/weapon/virusdish/random = 4)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "virus sample crate"
	access = core_access_medical_programs

/decl/hierarchy/supply_pack/science/coolanttank
	name = "Liquid - Coolant tank"
	contains = list(/obj/structure/reagent_dispensers/coolanttank)
	cost = 16
	containertype = /obj/structure/largecrate
	containername = "coolant tank crate"

/decl/hierarchy/supply_pack/science/rnd
	name = "Parts - Research and Development boards"
	contains = list(/obj/item/weapon/circuitboard/rdserver,
					/obj/item/weapon/circuitboard/destructive_analyzer,
					/obj/item/weapon/circuitboard/autolathe,
					/obj/item/weapon/circuitboard/protolathe,
					/obj/item/weapon/circuitboard/fabricator/circuitfab,
					/obj/item/weapon/circuitboard/rdservercontrol,
					/obj/item/weapon/circuitboard/rdconsole)
	cost = 300
	containertype = /obj/structure/largecrate
	containername = "research startup crate"
//eva
/decl/hierarchy/supply_pack/science/softsuit
	name = "EVA - Scientist softsuit"
	contains = list(/obj/item/clothing/suit/space/science,
					/obj/item/clothing/head/helmet/space/science,
					/obj/item/clothing/shoes/magboots,
					/obj/item/weapon/tank/emergency/oxygen/engi)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/large
	containername = "scientist softsuit crate"
	access = core_access_science_programs

/decl/hierarchy/supply_pack/science/voidsuit
	name = "EVA - Scientist voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/excavation,
					/obj/item/clothing/head/helmet/space/void/excavation,
					/obj/item/clothing/shoes/magboots)
	cost = 100
	containertype = /obj/structure/closet/crate/secure/large
	containername = "scientist voidsuit crate"
	access = core_access_science_programs

/decl/hierarchy/supply_pack/science/robotics
	name = "Parts - Robotics"
	contains = list(/obj/item/device/assembly/prox_sensor = 3,
					/obj/item/weapon/storage/toolbox/electrical,
					/obj/item/device/flash = 4,
					/obj/item/weapon/cell/high = 2)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "robotics assembly crate"
	access = access_robotics

/decl/hierarchy/supply_pack/science/phoron
	name = "Parts - Phoron device kit"
	contains = list(/obj/item/weapon/tank/phoron = 3,
					/obj/item/device/assembly/igniter = 3,
					/obj/item/device/assembly/prox_sensor = 3,
					/obj/item/device/assembly/timer = 3)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/phoron
	containername = "phoron assembly crate"
	access = access_tox_storage

/decl/hierarchy/supply_pack/science/scanner_module
	name = "Electronics - Reagent scanner modules"
	contains = list(/obj/item/weapon/computer_hardware/scanner/reagent = 4)
	cost = 20
	containername = "reagent scanner module crate"

/decl/hierarchy/supply_pack/science/minergear
	name = "Shaft miner equipment"
	contains = list(/obj/item/weapon/storage/backpack/industrial,
					/obj/item/weapon/storage/backpack/satchel/eng,
					/obj/item/device/radio/headset/headset_cargo,
					/obj/item/clothing/under/rank/miner,
					/obj/item/clothing/gloves/thick,
					/obj/item/clothing/shoes/black,
					/obj/item/device/scanner/gas,
					/obj/item/weapon/storage/ore,
					/obj/item/device/flashlight/lantern,
					/obj/item/weapon/shovel,
					/obj/item/weapon/pickaxe,
					/obj/item/device/scanner/mining/,
					/obj/item/clothing/glasses/material,
					/obj/item/clothing/glasses/meson)
	cost = 15
	containertype = /obj/structure/closet/crate/secure
	containername = "shaft miner equipment crate"
	access = access_mining

/decl/hierarchy/supply_pack/science/flamps
	num_contained = 3
	contains = list(/obj/item/device/flashlight/lamp/floodlamp,
					/obj/item/device/flashlight/lamp/floodlamp/green)
	name = "Equipment - Flood lamps"
	cost = 20
	containername = "flood lamp crate"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/science/illuminate
	name = "Gear - Illumination grenades"
	contains = list(/obj/item/weapon/grenade/light = 8)
	cost = 20
	containername = "illumination grenade crate"
