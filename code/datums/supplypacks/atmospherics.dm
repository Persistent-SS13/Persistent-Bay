/decl/hierarchy/supply_pack/atmospherics
	name = "Atmospherics"

//gear
/decl/hierarchy/supply_pack/atmospherics/internals
	name = "Gear - Internals"
	contains = list(/obj/item/clothing/mask/gas = 3,
					/obj/item/weapon/tank/air = 3)
	cost = 10
	containername = "internals crate"
	containertype = /obj/structure/closet/crate/internals

//equipment
/decl/hierarchy/supply_pack/atmospherics/inflatable
	name = "Equipment - Inflatable barriers"
	contains = list(/obj/item/weapon/storage/briefcase/inflatable = 3)
	cost = 20
	containername = "inflatable barrier crate"

/decl/hierarchy/supply_pack/atmospherics/airpump
	name = "Equipment - Four portable air pumps"
	contains = list(/obj/machinery/portable_atmospherics/powered/pump = 4)
	cost = 25
	containername = "portable air pumps crate"
	containertype = /obj/structure/largecrate

/decl/hierarchy/supply_pack/atmospherics/scrubber
	name = "Equipment - Four portable air scrubbers"
	contains = list(/obj/machinery/portable_atmospherics/powered/scrubber = 4)
	cost = 25
	containername = "portable air scrubbers crate"
	containertype = /obj/structure/largecrate

/decl/hierarchy/supply_pack/atmospherics/gas_generator
	name = "Equipment - Gas generator"
	contains = list(/obj/machinery/portable_atmospherics/gas_generator)
	cost = 25
	containername = "gas generator crate"
	containertype = /obj/structure/largecrate

//gas
/decl/hierarchy/supply_pack/atmospherics/canister_empty
	name = "Gas - Empty gas canister"
	contains = list(/obj/machinery/portable_atmospherics/canister)
	cost = 7
	containername = "empty gas canister crate"
	containertype = /obj/structure/largecrate

/decl/hierarchy/supply_pack/atmospherics/canister_air
	name = "Gas - Air canister"
	contains = list(/obj/machinery/portable_atmospherics/canister/air)
	cost = 10
	containername = "air canister crate"
	containertype = /obj/structure/largecrate

/decl/hierarchy/supply_pack/atmospherics/canister_oxygen
	name = "Gas - Oxygen canister"
	contains = list(/obj/machinery/portable_atmospherics/canister/oxygen)
	cost = 15
	containername = "oxygen canister crate"
	containertype = /obj/structure/largecrate

/decl/hierarchy/supply_pack/atmospherics/canister_nitrogen
	name = "Gas - Nitrogen canister"
	contains = list(/obj/machinery/portable_atmospherics/canister/nitrogen)
	cost = 10
	containername = "nitrogen canister crate"
	containertype = /obj/structure/largecrate

/decl/hierarchy/supply_pack/atmospherics/canister_phoron
	name = "Gas - Phoron gas canister"
	contains = list(/obj/machinery/portable_atmospherics/canister/phoron)
	cost = 60
	containername = "phoron gas canister crate"
	containertype = /obj/structure/closet/crate/secure/large/phoron
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/atmospherics/canister_sleeping_agent
	name = "Gas - Nitrous oxide canister"
	contains = list(/obj/machinery/portable_atmospherics/canister/sleeping_agent)
	cost = 40
	containername = "nitrous oxide canister crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/atmospherics/canister_carbon_dioxide
	name = "Gas - Carbon dioxide canister"
	contains = list(/obj/machinery/portable_atmospherics/canister/carbon_dioxide)
	cost = 40
	containername = "carbon dioxide canister crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/atmospherics/canister_hydrogen
	name = "Gas - Hydrogen canister"
	contains = list(/obj/machinery/portable_atmospherics/canister/hydrogen)
	cost = 10
	containername = "hydrogen canister crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/atmospherics/bulk_canister_air
	name = "Gas - Ten air canisters"
	contains = list(/obj/machinery/portable_atmospherics/canister/air = 10)
	cost = 100
	containername = "air canister crate"
	containertype = /obj/structure/largecrate

/decl/hierarchy/supply_pack/atmospherics/phoron
	name = "Gas - Phoron tanks"
	contains = list(/obj/item/weapon/tank/phoron = 3)
	cost = 35
	containername = "phoron tank crate"

//eva
/decl/hierarchy/supply_pack/atmospherics/voidsuit
	name = "EVA - Atmospherics voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/atmos,
					/obj/item/clothing/head/helmet/space/void/atmos,
					/obj/item/clothing/shoes/magboots)
	cost = 100
	containername = "atmospherics voidsuit crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/atmospherics/voidsuit_heavyduty
	name = "EVA - Heavy-duty atmospherics voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/atmos/alt,
					/obj/item/clothing/head/helmet/space/void/atmos/alt,
					/obj/item/clothing/shoes/magboots)
	cost = 150
	containername = "heavy-duty atmospherics voidsuit crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = core_access_engineering_programs