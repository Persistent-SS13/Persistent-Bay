/decl/hierarchy/supply_pack/atmospherics
	name = "Atmospherics"

/decl/hierarchy/supply_pack/atmospherics/internals
	name = "Internals crate"
	contains = list(/obj/item/clothing/mask/gas = 3,
					/obj/item/weapon/tank/air = 3)
	cost = 10
	containername = "\improper Internals crate"

/decl/hierarchy/supply_pack/atmospherics/inflatable
	name = "Inflatable barriers"
	contains = list(/obj/item/weapon/storage/briefcase/inflatable = 3)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "\improper Inflatable Barrier Crate"

/decl/hierarchy/supply_pack/atmospherics/canister_empty
	name = "Empty gas canister"
	contains = list(/obj/machinery/portable_atmospherics/canister)
	cost = 7
	containername = "\improper Empty gas canister crate"
	containertype = /obj/structure/largecrate

/decl/hierarchy/supply_pack/atmospherics/canister_air
	name = "Air canister"
	contains = list(/obj/machinery/portable_atmospherics/canister/air)
	cost = 10
	containername = "\improper Air canister crate"
	containertype = /obj/structure/largecrate

/decl/hierarchy/supply_pack/atmospherics/canister_oxygen
	name = "Oxygen canister"
	contains = list(/obj/machinery/portable_atmospherics/canister/oxygen)
	cost = 15
	containername = "\improper Oxygen canister crate"
	containertype = /obj/structure/largecrate

/decl/hierarchy/supply_pack/atmospherics/canister_nitrogen
	name = "Nitrogen canister"
	contains = list(/obj/machinery/portable_atmospherics/canister/nitrogen)
	cost = 10
	containername = "\improper Nitrogen canister crate"
	containertype = /obj/structure/largecrate

/decl/hierarchy/supply_pack/atmospherics/canister_phoron
	name = "Phoron gas canister"
	contains = list(/obj/machinery/portable_atmospherics/canister/phoron)
	cost = 60
	containername = "\improper Phoron gas canister crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/atmospherics/canister_sleeping_agent
	name = "N2O gas canister"
	contains = list(/obj/machinery/portable_atmospherics/canister/sleeping_agent)
	cost = 40
	containername = "\improper N2O gas canister crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/atmospherics/canister_carbon_dioxide
	name = "Carbon dioxide gas canister"
	contains = list(/obj/machinery/portable_atmospherics/canister/carbon_dioxide)
	cost = 40
	containername = "\improper CO2 canister crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/atmospherics/canister_hydrogen
	name = "Hydrogen canister"
	contains = list(/obj/machinery/portable_atmospherics/canister/hydrogen)
	cost = 10
	containername = "\improper Hydrogen canister crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/atmospherics/airpump
	name = "Portable Air Pumps (x4)"
	contains = list(/obj/machinery/portable_atmospherics/powered/pump = 4)
	cost = 25
	containername = "Portable Air Pump Shipment"
	containertype = /obj/structure/largecrate

/decl/hierarchy/supply_pack/atmospherics/scrubber
	name = "Portable Air Scrubber (x4)"
	contains = list(/obj/machinery/portable_atmospherics/powered/scrubber = 4)
	cost = 25
	containername = "Portable Air scrubber Shipment"
	containertype = /obj/structure/largecrate

/decl/hierarchy/supply_pack/atmospherics/gas_generator
	name = "Gas Generator"
	contains = list(/obj/machinery/portable_atmospherics/gas_generator)
	cost = 25
	containername = "\improper Gas Generator Crate"
	containertype = /obj/structure/largecrate

/decl/hierarchy/supply_pack/atmospherics/bulk_canister_air
	name = "Large Air Canister Shipment (x10)"
	contains = list(/obj/machinery/portable_atmospherics/canister/air = 10)
	cost = 100
	containername = "\improper Large Air Canister Crate"
	containertype = /obj/structure/largecrate

//void suits
/decl/hierarchy/supply_pack/atmospherics/voidsuit
	name = "Voidsuits - Atmospherics Voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/atmos/prepared)
	cost = 100
	containername = "\improper Atmospherics Voidsuit crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/atmospherics/voidsuit_heavyduty
	name = "Voidsuits - Heavy-duty atmospherics voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/atmos/alt/prepared)
	cost = 150
	containername = "\improper Heavy-duty atmospherics voidsuit crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = core_access_engineering_programs
