/decl/hierarchy/supply_pack/engineering
	name = "Engineering"

/decl/hierarchy/supply_pack/engineering/smes_circuit
	name = "Electronics - Superconducting magnetic energy storage unit circuitry"
	contains = list(/obj/item/weapon/circuitboard/smes)
	cost = 15
	containername = "superconducting magnetic energy storage unit circuitry crate"

//parts
/decl/hierarchy/supply_pack/engineering/smescoil
	name = "Parts - Superconductive magnetic coil"
	contains = list(/obj/item/weapon/smes_coil)
	cost = 25
	containername = "superconductive magnetic coil crate"

/decl/hierarchy/supply_pack/engineering/smescoil_weak
	name = "Parts - Basic superconductive magnetic coil"
	contains = list(/obj/item/weapon/smes_coil/weak)
	cost = 15
	containername = "basic superconductive magnetic coil crate"

/decl/hierarchy/supply_pack/engineering/smescoil_super_capacity
	name = "Parts - Superconductive capacitance coil"
	contains = list(/obj/item/weapon/smes_coil/super_capacity)
	cost = 35
	containername = "superconductive capacitance coil crate"

/decl/hierarchy/supply_pack/engineering/smescoil_super_io
	name = "Parts - Superconductive transmission coil"
	contains = list(/obj/item/weapon/smes_coil/super_io)
	cost = 35
	containername = "superconductive transmission coil crate"

/decl/hierarchy/supply_pack/engineering/bluespacerelay
	name = "Parts - Emergency bluespace relay parts"
	contains = list(/obj/item/weapon/circuitboard/bluespacerelay,
					/obj/item/weapon/stock_parts/manipulator,
					/obj/item/weapon/stock_parts/manipulator,
					/obj/item/weapon/stock_parts/subspace/filter,
					/obj/item/weapon/stock_parts/subspace/crystal,
					/obj/item/weapon/storage/toolbox/electrical)
	cost = 75
	containername = "emergency bluespace relay assembly kit"
	containertype = /obj/structure/closet/crate/secure
	access = core_access_leader

//gear
/decl/hierarchy/supply_pack/engineering/engineering_electrical
	name = "Gear - Electrical maintenance"
	contains = list(/obj/item/clothing/gloves/insulated/cheap = 2,
					/obj/item/weapon/storage/toolbox/electrical = 3,
					/obj/item/weapon/module/power_control = 3,
					/obj/item/weapon/cell = 4,
					/obj/item/device/flashlight = 3,
					/obj/item/device/multitool = 3)
	cost = 35
	containername = "electrical supplies"
	containertype = /obj/structure/closet/secure_closet/engineering_electrical
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/engineering/electrical
	name = "Gear - Insulated gloves"
	contains = list(/obj/item/clothing/gloves/insulated = 3)
	cost = 20
	containername = "insulated glove crate"
	containertype = /obj/structure/closet/crate/secure
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/engineering/mechanical
	name = "Gear - Mechanical maintenance crate"
	contains = list(/obj/item/weapon/storage/belt/utility/full = 3,
					/obj/item/clothing/suit/storage/hazardvest = 3,
					/obj/item/clothing/head/welding = 3,
					/obj/item/device/flashlight = 3)
	cost = 12
	containername = "mechanical maintenance crate"

/decl/hierarchy/supply_pack/engineering/radsuit
	name = "Gear - Radiation protection gear"
	contains = list(/obj/item/clothing/suit/radiation = 6,
					/obj/item/clothing/head/radiation = 6,
					/obj/item/device/geiger = 6)
	cost = 25
	containertype = /obj/structure/closet/radiation
	containername = "radiation suit locker"

/decl/hierarchy/supply_pack/engineering/firefighter
	name = "Gear - Firefighting equipment"
	contains = list(/obj/item/clothing/suit/fire/firefighter = 2,
					/obj/item/clothing/mask/gas = 2,
					/obj/item/weapon/tank/oxygen/red = 2,
					/obj/item/weapon/extinguisher = 2,
					/obj/item/clothing/head/hardhat/red = 2)
	cost = 12
	containertype = /obj/structure/closet/firecloset
	containername = "fire-safety closet"

//power
/decl/hierarchy/supply_pack/engineering/solar	//Removed solar control and tracker circuit, can be made in circuit imprinter
	name = "Power - Solar panels (x50)"
	contains  = list(/obj/item/solar_assembly = 50,
					/obj/item/weapon/paper/solar
					)
	containertype = /obj/structure/largecrate
	cost = 48
	containername = "large solar panel crate"

/decl/hierarchy/supply_pack/engineering/solar_small	//Less solars
	name = "Power - Solar panels (x10)"
	contains  = list(/obj/item/solar_assembly = 10,
					/obj/item/weapon/paper/solar
					)
	cost = 10
	containername = "small solar panel crate"

/decl/hierarchy/supply_pack/engineering/collector
	name = "Power - Radiation collectors"
	contains = list(/obj/machinery/power/rad_collector = 2)
	cost = 6
	containertype = /obj/structure/closet/crate/secure/large
	containername = "collector crate"
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/engineering/pacman_parts
	name = "Power - P.A.C.M.A.N. portable generator parts"
	contains = list(/obj/item/weapon/stock_parts/micro_laser,
					/obj/item/weapon/stock_parts/capacitor,
					/obj/item/weapon/stock_parts/matter_bin,
					/obj/item/weapon/circuitboard/pacman)
	cost = 20
	containername = "\improper P.A.C.M.A.N. portable generator construction kit"
	containertype = /obj/structure/closet/crate

/decl/hierarchy/supply_pack/engineering/super_pacman_parts
	name = "Power - Super P.A.C.M.A.N. portable generator parts"
	contains = list(/obj/item/weapon/stock_parts/micro_laser,
					/obj/item/weapon/stock_parts/capacitor,
					/obj/item/weapon/stock_parts/matter_bin,
					/obj/item/weapon/circuitboard/pacman/super)
	cost = 30
	containername = "\improper Super P.A.C.M.A.N. portable generator construction kit"
	containertype = /obj/structure/closet/crate

/decl/hierarchy/supply_pack/engineering/teg
	name = "Power - Mark I Thermoelectric Generator"
	contains = list(/obj/machinery/power/generator)
	cost = 75
	containertype = /obj/structure/closet/crate/secure/large
	containername = "\improper Mk1 TEG crate"
	access = core_access_engineering_programs

//equipment
/decl/hierarchy/supply_pack/engineering/emitter
	name = "Equipment - Emitters"
	contains = list(/obj/machinery/power/emitter = 2)
	cost = 12
	containertype = /obj/structure/closet/crate/secure/large
	containername = "emitter crate"
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/engineering/gyrotron
	name = "Equipment - Gyrotrons"
	contains = list(/obj/machinery/power/emitter/gyrotron = 2)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/large
	containername = "gyrotron crate"
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/engineering/field_gen
	name = "Equipment - Field generator"
	contains = list(/obj/machinery/field_generator = 2)
	containertype = /obj/structure/closet/crate/large
	cost = 10
	containername = "field generator crate"
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/engineering/pa
	name = "Equipment - Particle accelerator"
	contains = list(/obj/structure/particle_accelerator/fuel_chamber,
					/obj/machinery/particle_accelerator/control_box,
					/obj/structure/particle_accelerator/particle_emitter/center,
					/obj/structure/particle_accelerator/particle_emitter/left,
					/obj/structure/particle_accelerator/particle_emitter/right,
					/obj/structure/particle_accelerator/power_box,
					/obj/structure/particle_accelerator/end_cap)
	cost = 60
	containertype = /obj/structure/largecrate
	containername = "particle accelerator crate"

/decl/hierarchy/supply_pack/engineering/circulator
	name = "Equipment - Binary atmospheric circulator"
	contains = list(/obj/machinery/atmospherics/binary/circulator)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/large
	containername = "atmospheric circulator crate"
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/engineering/air_dispenser
	name = "Equipment - Pipe dispenser"
	contains = list(/obj/machinery/pipedispenser/orderable)
	cost = 35
	containertype = /obj/structure/closet/crate/secure/large
	containername = "pipe dispenser crate"
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/engineering/disposals_dispenser
	name = "Equipment - Disposals pipe dispenser"
	contains = list(/obj/machinery/pipedispenser/disposal/orderable)
	cost = 35
	containertype = /obj/structure/closet/crate/secure/large
	containername = "disposal dispenser crate"
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/engineering/shield_generator
	name = "Equipment - Advanced shield generator construction kit"
	contains = list(/obj/item/weapon/circuitboard/shield_generator,
					/obj/item/weapon/stock_parts/capacitor,
					/obj/item/weapon/stock_parts/micro_laser,
					/obj/item/weapon/smes_coil,
					/obj/item/weapon/stock_parts/console_screen)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "shield generator construction kit"
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/engineering/antibreach
	name = "Equipment - Anti-breach shields"
	contains = list(/obj/machinery/shieldgen = 4)
	containername = "anti-breach shield crate"
	containertype = /obj/structure/largecrate
	cost = 40

/decl/hierarchy/supply_pack/engineering/shieldgens
	name = "Equipment - Standard shield generators"
	contains = list(/obj/machinery/shieldwallgen = 2)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/large
	containername = "wall shield generators crate"
	access = core_access_engineering_programs

decl/hierarchy/supply_pack/engineering/cablelayer
	name = "Equipment - Automatic cable layer"
	contains = list(/obj/machinery/cablelayer)
	containername = "automatic cable layer crate"
	containertype = /obj/structure/closet/crate/large
	cost = 50

decl/hierarchy/supply_pack/engineering/floorlayer
	name = "Equipment - Automatic floor layer"
	contains = list(/obj/machinery/floorlayer)
	containername = "automatic floor layer crate"
	containertype = /obj/structure/closet/crate/large
	cost = 50

decl/hierarchy/supply_pack/engineering/pipelayer
	name = "Equipment - Automatic pipe layer"
	contains = list(/obj/machinery/pipelayer)
	containername = "automatic pipe layer crate"
	containertype = /obj/structure/closet/crate/large
	cost = 50

/decl/hierarchy/supply_pack/engineering/engineering_cables
	name = "Bulk Cables Crate x300"
	contains = list(/obj/item/stack/cable_coil=10)
	cost = 35
	containername = "\improper Bulk Cables Crate"

//eva
/decl/hierarchy/supply_pack/engineering/voidsuit
	name = "EVA - Engineering voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/engineering,
					/obj/item/clothing/head/helmet/space/void/engineering,
					/obj/item/clothing/shoes/magboots)
	containername = "engineering voidsuit crate"
	containertype = /obj/structure/closet/crate/secure/large
	cost = 100
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/engineering/voidsuit_heavyduty
	name = "EVA - Heavy-duty engineering voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/engineering/alt,
					/obj/item/clothing/head/helmet/space/void/engineering/alt,
					/obj/item/clothing/shoes/magboots)
	containername = "heavy-duty engineering voidsuit crate"
	containertype = /obj/structure/closet/crate/secure/large
	cost = 180
	access = core_access_engineering_programs

//liquid
/decl/hierarchy/supply_pack/engineering/fueltank
	name = "Liquid - Fuel tank"
	contains = list(/obj/structure/reagent_dispensers/fueltank)
	cost = 8
	containertype = /obj/structure/largecrate
	containername = "fuel tank crate"
