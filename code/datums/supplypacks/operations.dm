/decl/hierarchy/supply_pack/operations
	name = "Operations"

//equipment
/decl/hierarchy/supply_pack/operations/mule
	name = "Equipment - MULEbot"
	contains = list()
	cost = 20
	containertype = /obj/structure/largecrate/animal/mulebot
	containername = "mulebot crate"

/decl/hierarchy/supply_pack/operations/cargotrain
	name = "Equipment - Train tug"
	contains = list(/obj/vehicle/train/cargo/engine)
	cost = 45
	containertype = /obj/structure/largecrate
	containername = "train tug crate"

/decl/hierarchy/supply_pack/operations/cargotrailer
	name = "Equipment - Train trolley"
	contains = list(/obj/vehicle/train/cargo/trolley)
	cost = 15
	containertype = /obj/structure/largecrate
	containername = "train trolley crate"

/decl/hierarchy/supply_pack/operations/hoverpod
	name = "Equipment - Hoverpod"
	contains = list()
	cost = 120
	containertype = /obj/structure/largecrate/hoverpod
	containername = "hoverpod crate"
/*
//gear
/decl/hierarchy/supply_pack/operations/webbing
	name = "Gear - Webbing"
	num_contained = 4
	contains = list(/obj/item/clothing/accessory/holster,
					/obj/item/clothing/accessory/storage/black_vest,
					/obj/item/clothing/accessory/storage/brown_vest,
					/obj/item/clothing/accessory/storage/white_vest,
					/obj/item/clothing/accessory/storage/drop_pouches/black,
					/obj/item/clothing/accessory/storage/drop_pouches/brown,
					/obj/item/clothing/accessory/storage/drop_pouches/white,
					/obj/item/clothing/accessory/storage/webbing)
	cost = 15
	containername = "webbing crate"
*/
//bureaucracy
/decl/hierarchy/supply_pack/operations/bureaucracy
	name = "Bureaucracy - Office supplies"
	contains = list(/obj/item/weapon/clipboard,
					/obj/item/weapon/clipboard,
					/obj/item/weapon/pen/red,
					/obj/item/weapon/pen/blue = 2,
					/obj/item/device/camera_film,
					/obj/item/weapon/folder/blue,
					/obj/item/weapon/folder/red,
					/obj/item/weapon/folder/yellow,
					/obj/item/weapon/hand_labeler,
					/obj/item/weapon/tape_roll,
					/obj/item/weapon/paper_bin)
	cost = 10
	containertype = /obj/structure/closet/crate/large
	containername = "office supplies crate"

/decl/hierarchy/supply_pack/operations/fax
	name = "Bureaucracy - Fax machine"
	contains = list(/obj/machinery/photocopier/faxmachine)
	cost = 80
	containertype = /obj/structure/largecrate
	containername = "fax machine crate"

//eva
/decl/hierarchy/supply_pack/operations/softsuit_emergency
	name = "EVA - Emergency softsuit"
	contains = list(/obj/item/clothing/suit/space/emergency,
					/obj/item/clothing/head/helmet/space/emergency,
					/obj/item/weapon/tank/emergency/oxygen/engi)
	cost = 15
	containername = "emergency softsuit crate"

/decl/hierarchy/supply_pack/operations/softsuit
	name = "EVA - Basic softsuit"
	contains = list(/obj/item/clothing/suit/space,
					/obj/item/clothing/head/helmet/space,
					/obj/item/clothing/shoes/magboots,
					/obj/item/weapon/tank/emergency/oxygen/engi)
	cost = 30
	containername = "softsuit crate"

/decl/hierarchy/supply_pack/operations/salvagedsuit
	name = "EVA - Salvaged voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/engineering/salvage,
					/obj/item/clothing/head/helmet/space/void/engineering/salvage,
					/obj/item/clothing/shoes/magboots)
	cost = 50
	containername = "salvaged voidsuit crate"

/decl/hierarchy/supply_pack/operations/voidsuit
	name = "EVA - Basic voidsuit"
	contains = list(/obj/item/clothing/suit/space/void,
					/obj/item/clothing/head/helmet/space/void,
					/obj/item/clothing/shoes/magboots)
	cost = 100
	containername = "basic voidsuit crate"

/decl/hierarchy/supply_pack/operations/voidsuit_purple
	name = "EVA - Deluxe purple voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/exploration,
					/obj/item/clothing/head/helmet/space/void/exploration,
					/obj/item/clothing/shoes/magboots)
	cost = 300 //Expensive because moderately protects armor & heat
	containername = "purple voidsuit crate"

/decl/hierarchy/supply_pack/operations/voidsuit_red
	name = "EVA - Red voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/pilot,
					/obj/item/clothing/head/helmet/space/void/pilot,
					/obj/item/clothing/shoes/magboots)
	cost = 100
	containername = "red voidsuit crate"
