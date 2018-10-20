/decl/hierarchy/supply_pack/science
	name = "Science"

/decl/hierarchy/supply_pack/science/chemistry_dispenser
	name = "Equipment - Chemical reagent dispenser"
	contains = list(/obj/machinery/chemical_dispenser{anchored = 0})
	cost = 25
	containertype = /obj/structure/largecrate
	containername = "reagent dispenser crate"

/decl/hierarchy/supply_pack/science/virus
	name = "Samples - Virus dishes"
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
					/obj/item/weapon/circuitboard/circuit_imprinter,
					/obj/item/weapon/circuitboard/rdservercontrol,
					/obj/item/weapon/circuitboard/rdconsole)
	cost = 300
	containertype = /obj/structure/largecrate
	containername = "research startup crate"

/decl/hierarchy/supply_pack/science/voidsuit
	name = "EVA - Scientist voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/excavation,
					/obj/item/clothing/head/helmet/space/void/excavation,
					/obj/item/clothing/shoes/magboots)
	cost = 100
	containertype = /obj/structure/closet/crate/secure/large
	containername = "excavation voidsuit crate"
	access = core_access_science_programs