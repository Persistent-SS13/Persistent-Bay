/decl/hierarchy/supply_pack/engineering
	name = "Engineering"

/decl/hierarchy/supply_pack/engineering/lightbulbs
	name = "Replacement lights"
	contains = list(/obj/item/weapon/storage/box/lights/mixed = 3)
	cost = 10
	containername = "\improper Replacement lights"

/decl/hierarchy/supply_pack/engineering/smes_circuit
	name = "Superconducting Magnetic Energy Storage Unit Circuitry"
	contains = list(/obj/item/weapon/circuitboard/smes)
	cost = 15
	containername = "\improper Superconducting Magnetic Energy Storage Unit Circuitry"

/decl/hierarchy/supply_pack/engineering/smescoil
	name = "Superconductive Magnetic Coil"
	contains = list(/obj/item/weapon/smes_coil)
	cost = 25
	containername = "\improper Superconductive Magnetic Coil crate"

/decl/hierarchy/supply_pack/engineering/smescoil_weak
	name = "Basic Superconductive Magnetic Coil"
	contains = list(/obj/item/weapon/smes_coil/weak)
	cost = 15
	containername = "\improper Basic Superconductive Magnetic Coil crate"

/decl/hierarchy/supply_pack/engineering/smescoil_super_capacity
	name = "Superconductive Capacitance Coil"
	contains = list(/obj/item/weapon/smes_coil/super_capacity)
	cost = 35
	containername = "\improper Superconductive Capacitance Coil crate"

/decl/hierarchy/supply_pack/engineering/smescoil_super_io
	name = "Superconductive Transmission Coil"
	contains = list(/obj/item/weapon/smes_coil/super_io)
	cost = 35
	containername = "\improper Superconductive Transmission Coil crate"

/decl/hierarchy/supply_pack/engineering/engineering_electrical
	name = "Electrical maintenance crate"
	contains = list(/obj/item/clothing/gloves/insulated/cheap = 2,
					/obj/item/weapon/storage/toolbox/electrical = 3,
					/obj/item/weapon/module/power_control = 3,
					/obj/item/weapon/cell = 4,
					/obj/item/device/flashlight = 3,
					/obj/item/device/multitool = 3
					)
	cost = 35
	containername = "\improper electrical supplies"
	containertype = /obj/structure/closet/secure_closet/engineering_electrical
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/engineering/electrical
	name = "Insulated glove crate"
	contains = list(/obj/item/clothing/gloves/insulated
					)
	cost = 17
	containername = "\improper insulated glove crate"
	containertype = /obj/structure/closet/crate/secure
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/engineering/mechanical
	name = "Mechanical maintenance crate"
	contains = list(/obj/item/weapon/storage/belt/utility/full = 3,
					/obj/item/clothing/suit/storage/hazardvest = 3,
					/obj/item/clothing/head/welding = 3,
					/obj/item/device/flashlight = 3
					)
	cost = 12
	containername = "\improper Mechanical maintenance crate"

/decl/hierarchy/supply_pack/engineering/solar	//Removed solar control and tracker circuit, can be made in circuit imprinter
	name = "Solar Panels (x50)"
	contains  = list(/obj/item/solar_assembly = 50,
					/obj/item/weapon/paper/solar
					)
	containertype = /obj/structure/largecrate
	cost = 48
	containername = "\improper Large Solar Panel crate"

/decl/hierarchy/supply_pack/engineering/solar_small	//Less solars
	name = "Solar Panels (x10)"
	contains  = list(/obj/item/solar_assembly = 10,
					/obj/item/weapon/paper/solar
					)
	cost = 10
	containername = "\improper Small Solar Panel crate"

/decl/hierarchy/supply_pack/engineering/emitter
	name = "Emitter crate"
	contains = list(/obj/machinery/power/emitter = 2)
	cost = 12
	containertype = /obj/structure/closet/crate/secure/large
	containername = "\improper Emitter crate"
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/engineering/gyrotron
	name = "Gyrotron crate"
	contains = list(/obj/machinery/power/emitter/gyrotron = 2)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/large
	containername = "\improper Gyrotron crate"
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/engineering/field_gen
	name = "Field Generator crate"
	contains = list(/obj/machinery/field_generator = 2)
	containertype = /obj/structure/closet/crate/large
	cost = 10
	containername = "\improper Field Generator crate"
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/engineering/collector
	name = "Collector crate"
	contains = list(/obj/machinery/power/rad_collector = 2)
	cost = 6
	containertype = /obj/structure/closet/crate/secure/large
	containername = "\improper Collector crate"
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/engineering/PA
	name = "Particle Accelerator crate"
	contains = list(/obj/structure/particle_accelerator/fuel_chamber,
					/obj/machinery/particle_accelerator/control_box,
					/obj/structure/particle_accelerator/particle_emitter/center,
					/obj/structure/particle_accelerator/particle_emitter/left,
					/obj/structure/particle_accelerator/particle_emitter/right,
					/obj/structure/particle_accelerator/power_box,
					/obj/structure/particle_accelerator/end_cap)
	cost = 60
	containertype = /obj/structure/largecrate
	containername = "\improper Particle Accelerator crate"

/decl/hierarchy/supply_pack/engineering/pacman_parts
	name = "P.A.C.M.A.N. portable generator parts"
	contains = list(/obj/item/weapon/stock_parts/micro_laser,
					/obj/item/weapon/stock_parts/capacitor,
					/obj/item/weapon/stock_parts/matter_bin,
					/obj/item/weapon/circuitboard/pacman)
	cost = 20
	containername = "\improper P.A.C.M.A.N. Portable Generator Construction Kit"
	containertype = /obj/structure/closet/crate

/decl/hierarchy/supply_pack/engineering/super_pacman_parts
	name = "Super P.A.C.M.A.N. portable generator parts"
	contains = list(/obj/item/weapon/stock_parts/micro_laser,
					/obj/item/weapon/stock_parts/capacitor,
					/obj/item/weapon/stock_parts/matter_bin,
					/obj/item/weapon/circuitboard/pacman/super)
	cost = 30
	containername = "\improper Super P.A.C.M.A.N. portable generator construction kit"
	containertype = /obj/structure/closet/crate

/decl/hierarchy/supply_pack/engineering/teg
	name = "Mark I Thermoelectric Generator"
	contains = list(/obj/machinery/power/generator)
	cost = 75
	containertype = /obj/structure/closet/crate/secure/large
	containername = "\improper Mk1 TEG crate"
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/engineering/circulator
	name = "Binary atmospheric circulator"
	contains = list(/obj/machinery/atmospherics/binary/circulator)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/large
	containername = "\improper Atmospheric circulator crate"
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/engineering/air_dispenser
	name = "Pipe Dispenser"
	contains = list(/obj/machinery/pipedispenser/orderable)
	cost = 35
	containertype = /obj/structure/closet/crate/secure/large
	containername = "\improper Pipe Dispenser crate"
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/engineering/disposals_dispenser
	name = "Disposals Pipe Dispenser"
	contains = list(/obj/machinery/pipedispenser/disposal/orderable)
	cost = 35
	containertype = /obj/structure/closet/crate/secure/large
	containername = "\improper Disposal Dispenser crate"
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/engineering/shield_generator
	name = "Shield Generator Construction Kit"
	contains = list(/obj/item/weapon/circuitboard/shield_generator,
					/obj/item/weapon/stock_parts/capacitor,
					/obj/item/weapon/stock_parts/micro_laser,
					/obj/item/weapon/smes_coil,
					/obj/item/weapon/stock_parts/console_screen)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper shield generator construction kit crate"
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/engineering/fueltank
	name = "Fuel tank crate"
	contains = list(/obj/structure/reagent_dispensers/fueltank)
	cost = 8
	containertype = /obj/structure/largecrate
	containername = "\improper fuel tank crate"

/decl/hierarchy/supply_pack/engineering/radsuit
	name = "Radiation Suits w/ Geiger Counters (x6)"
	contains = list(/obj/item/clothing/suit/radiation = 6,
					/obj/item/clothing/head/radiation = 6,
					/obj/item/device/geiger = 6)
	cost = 25
	containertype = /obj/structure/closet/radiation
	containername = "\improper Radiation suit locker"

/decl/hierarchy/supply_pack/engineering/painters
	name = "Pipe, Floor, & Cable Painters"
	contains = list(/obj/item/device/pipe_painter = 2,
					/obj/item/device/floor_painter = 2,
					/obj/item/device/cable_painter = 2)
	cost = 8
	containername = "\improper Pipe, Floor, & Cable Painters crate"
	containertype = /obj/structure/closet/crate

/decl/hierarchy/supply_pack/engineering/bluespacerelay
	name = "Emergency Bluespace Relay Assembly Kit"
	contains = list(/obj/item/weapon/circuitboard/bluespacerelay,
					/obj/item/weapon/stock_parts/manipulator,
					/obj/item/weapon/stock_parts/manipulator,
					/obj/item/weapon/stock_parts/subspace/filter,
					/obj/item/weapon/stock_parts/subspace/crystal,
					/obj/item/weapon/storage/toolbox/electrical)
	cost = 75
	containername = "\improper emergency bluespace relay assembly kit"
	containertype = /obj/structure/closet/crate/secure
	access = core_access_leader

/decl/hierarchy/supply_pack/engineering/firefighter
	name = "Firefighting equipment"
	contains = list(/obj/item/clothing/suit/fire/firefighter = 2,
					/obj/item/clothing/mask/gas = 2,
					/obj/item/weapon/tank/oxygen/red = 2,
					/obj/item/weapon/extinguisher = 2,
					/obj/item/clothing/head/hardhat/red = 2)
	cost = 12
	containertype = /obj/structure/closet/firecloset
	containername = "\improper fire-safety closet"

/decl/hierarchy/supply_pack/engineering/voidsuit
	name = "Engineering Voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/engineering/prepared)
	containername = "\improper Engineering Voidsuit"
	containertype = /obj/structure/closet/crate/secure/large
	cost = 100
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/engineering/voidsuit_heavyduty
	name = "Heavy Duty Engineering Voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/engineering/alt/prepared)
	containername = "\improper Heavy Duty Engineering Voidsuit"
	containertype = /obj/structure/closet/crate/secure/large
	cost = 180
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/engineering/antibreach
	name = "Anti-Breach Shields (x4)"
	contains = list(/obj/machinery/shieldgen = 4)
	containername = "\improper Anti-Breach Shield crate (x4)"
	containertype = /obj/structure/largecrate
	cost = 40

/decl/hierarchy/supply_pack/engineering/shieldgens
	name = "Standard Shield Generators (x2)"
	contains = list(/obj/machinery/shieldwallgen = 2)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/large
	containername = "\improper wall shield generators crate"
	access = core_access_engineering_programs

decl/hierarchy/supply_pack/engineering/cablelayer
	name = "AutoMatic Cable Layer"
	contains = list(/obj/machinery/cablelayer)
	containername = "AutoMatic Cable Layer"
	containertype = /obj/structure/closet/crate/large
	cost = 50

decl/hierarchy/supply_pack/engineering/floorlayer
	name = "AutoMatic Tiler"
	contains = list(/obj/machinery/floorlayer)
	containername = "AutoMatic Tiler"
	containertype = /obj/structure/closet/crate/large
	cost = 50

decl/hierarchy/supply_pack/engineering/pipelayer
	name = "AutoMatic Piper"
	contains = list(/obj/machinery/pipelayer)
	containername = "AutoMatic Piper"
	containertype = /obj/structure/closet/crate/large
	cost = 50
