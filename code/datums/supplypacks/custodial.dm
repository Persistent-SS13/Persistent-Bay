/decl/hierarchy/supply_pack/custodial
	name = "Custodial"

//gear
/decl/hierarchy/supply_pack/custodial/janitor
	name = "Gear - Janitorial supplies"
	contains = list(/obj/item/clothing/shoes/galoshes,
					/obj/item/weapon/reagent_containers/glass/bucket,
					/obj/item/weapon/mop,
					/obj/item/weapon/caution = 4,
					/obj/item/weapon/storage/bag/trash,
					/obj/item/device/lightreplacer,
					/obj/item/weapon/reagent_containers/spray/cleaner,
					/obj/item/weapon/reagent_containers/glass/rag,
					/obj/item/weapon/grenade/chem_grenade/cleaner = 3,
					/obj/item/weapon/soap)
				//	/obj/structure/mopbucket Don't add this, it doesn't fit back inside		
	cost = 14
	containertype = /obj/structure/closet/crate/trashcart
	containername = "janitorial cart"

/decl/hierarchy/supply_pack/custodial/mousetrap
	num_contained = 3
	contains = list(/obj/item/weapon/storage/box/mousetraps)
	name = "Misc - Pest control"
	cost = 10
	containername = "pest control crate"

/decl/hierarchy/supply_pack/custodial/lightbulbs
	name = "Spares - Replacement lights"
	contains = list(/obj/item/weapon/storage/box/lights/mixed = 3)
	cost = 10
	containername = "replacement lights crate"

/decl/hierarchy/supply_pack/custodial/cleaning
	name = "Gear - Cleaning supplies"
	contains = list(/obj/item/weapon/mop,
					/obj/item/weapon/grenade/chem_grenade/cleaner = 3,
					/obj/item/weapon/storage/box/detergent = 3,
					/obj/item/weapon/reagent_containers/glass/bucket,
					/obj/item/weapon/reagent_containers/glass/rag,
					/obj/item/weapon/reagent_containers/spray/cleaner = 2,
					/obj/item/weapon/soap)
	cost = 10
	containertype = /obj/structure/closet/crate/large
	containername = "cleaning supplies crate"

//equipment
/decl/hierarchy/supply_pack/custodial/janicart
	name = "Equipment - Janitorial cart"
	contains = list(/obj/structure/janitorialcart)
	cost = 35
	containertype = /obj/structure/largecrate
	containername = "janitorial cart crate"

/decl/hierarchy/supply_pack/custodial/bodybag
	name = "Equipment - Body bags"
	contains = list(/obj/item/weapon/storage/box/bodybags = 3)
	cost = 10
	containername = "body bag crate"

/decl/hierarchy/supply_pack/custodial/janitorbiosuits
	name = "Gear - Janitor biohazard equipment"
	contains = list(/obj/item/clothing/head/bio_hood/janitor,
					/obj/item/clothing/suit/bio_suit/janitor,
					/obj/item/clothing/mask/gas,
					/obj/item/weapon/tank/oxygen)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "janitor biohazard equipment crate"

/decl/hierarchy/supply_pack/custodial/lightbulbs
	name = "Equipment - Replacement lights"
	contains = list(/obj/item/weapon/storage/box/lights/mixed = 3)
	cost = 6
	containername = "replacement lights crate"

/decl/hierarchy/supply_pack/custodial/mousetrap
	name = "Equipment - Pest control"
	contains = list(/obj/item/weapon/storage/box/mousetraps = 3)
	cost = 3
	containername = "pest control crate"
