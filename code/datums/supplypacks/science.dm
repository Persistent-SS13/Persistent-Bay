/decl/hierarchy/supply_pack/science
	name = "Science"

/decl/hierarchy/supply_pack/science/virus
	name = "Virus sample crate"
	contains = list(/obj/item/weapon/virusdish/random = 4)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Virus sample crate"
	access = core_access_medical_programs

/decl/hierarchy/supply_pack/science/slimecore
	name = "Slime core crate"
	contains = list(/obj/item/slime_extract/grey = 2)
	cost = 50
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Slime core crate"

/decl/hierarchy/supply_pack/science/coolanttank
	name = "Coolant tank crate"
	contains = list(/obj/structure/reagent_dispensers/coolanttank)
	cost = 16
	containertype = /obj/structure/largecrate
	containername = "\improper coolant tank crate"

/decl/hierarchy/supply_pack/science/rnd
	name = "Research and Development Boards"
	contains = list(/obj/item/weapon/circuitboard/rdserver,
					/obj/item/weapon/circuitboard/destructive_analyzer,
					/obj/item/weapon/circuitboard/autolathe,
					/obj/item/weapon/circuitboard/protolathe,
					/obj/item/weapon/circuitboard/circuit_imprinter,
					/obj/item/weapon/circuitboard/rdservercontrol,
					/obj/item/weapon/circuitboard/rdconsole)
	cost = 300
	containertype = /obj/structure/largecrate
	containername = "\improper research startup crate"

/decl/hierarchy/supply_pack/science/voidsuit
	name = "Scientist Voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/excavation/prepared)
	cost = 100
	containertype = /obj/structure/closet/crate/secure/large
	containername = "\improper Scientist Voidsuit"
	access = core_access_science_programs
