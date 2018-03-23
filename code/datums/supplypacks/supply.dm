/decl/hierarchy/supply_pack/supply
	name = "Supply"

/decl/hierarchy/supply_pack/supply/food
	name = "Kitchen supply crate"
	contains = list(/obj/item/weapon/reagent_containers/food/condiment/flour = 6,
					/obj/item/weapon/reagent_containers/food/drinks/milk = 4,
					/obj/item/weapon/reagent_containers/food/drinks/soymilk = 2,
					/obj/item/weapon/storage/fancy/egg_box = 2,
					/obj/item/weapon/reagent_containers/food/snacks/tofu = 4,
					/obj/item/weapon/reagent_containers/food/snacks/meat = 4
					)
	cost = 10
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Food crate"

/decl/hierarchy/supply_pack/supply/toner
	name = "Toner cartridges"
	contains = list(/obj/item/device/toner = 6)
	cost = 10
	containername = "\improper Toner cartridges"

/decl/hierarchy/supply_pack/supply/janitor
	name = "Janitorial supplies"
	contains = list(/obj/item/weapon/reagent_containers/glass/bucket,
					/obj/item/weapon/mop,
					/obj/item/weapon/caution = 4,
					/obj/item/weapon/storage/bag/trash,
					/obj/item/device/lightreplacer,
					/obj/item/weapon/reagent_containers/spray/cleaner,
					/obj/item/weapon/reagent_containers/glass/rag,
					/obj/item/weapon/grenade/chem_grenade/cleaner = 3,
					/obj/structure/mopbucket)
	cost = 10
	containertype = /obj/structure/closet/crate/large
	containername = "\improper Janitorial supplies"

/decl/hierarchy/supply_pack/supply/boxes
	name = "Empty boxes"
	contains = list(/obj/item/weapon/storage/box = 10)
	cost = 10
	containername = "\improper Empty box crate"

/decl/hierarchy/supply_pack/supply/bureaucracy
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
					 /obj/structure/filingcabinet/chestdrawer{anchored = 0},
					 /obj/item/weapon/paper_bin)
	name = "Office supplies"
	cost = 15
	containertype = /obj/structure/closet/crate/large
	containername = "\improper Office supplies crate"

/decl/hierarchy/supply_pack/supply/spare_pda
	name = "Spare PDAs"
	contains = list(/obj/item/device/pda = 3)
	cost = 10
	containername = "\improper Spare PDA crate"

/decl/hierarchy/supply_pack/supply/minergear
	name = "Shaft miner equipment"
	contains = list(/obj/item/weapon/storage/backpack/industrial,
					/obj/item/weapon/storage/backpack/satchel_eng,
					/obj/item/device/radio/headset/headset_cargo,
					/obj/item/clothing/under/rank/miner,
					/obj/item/clothing/gloves/thick,
					/obj/item/clothing/shoes/black,
					/obj/item/device/analyzer,
					/obj/item/weapon/storage/ore,
					/obj/item/device/flashlight/lantern,
					/obj/item/weapon/shovel,
					/obj/item/weapon/pickaxe,
					/obj/item/weapon/mining_scanner,
					/obj/item/clothing/glasses/material,
					/obj/item/clothing/glasses/meson)
	cost = 15
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Shaft miner equipment"
	access = access_mining

/decl/hierarchy/supply_pack/supply/mule
	name = "MULEbot Crate"
	contains = list()
	cost = 20
	containertype = /obj/structure/largecrate/animal/mulebot
	containername = "Mulebot Crate"

/decl/hierarchy/supply_pack/supply/cargotrain
	name = "Cargo Train Tug"
	contains = list(/obj/vehicle/train/cargo/engine)
	cost = 45
	containertype = /obj/structure/largecrate
	containername = "\improper Cargo Train Tug Crate"

/decl/hierarchy/supply_pack/supply/cargotrailer
	name = "Cargo Train Trolley"
	contains = list(/obj/vehicle/train/cargo/trolley)
	cost = 15
	containertype = /obj/structure/largecrate
	containername = "\improper Cargo Train Trolley Crate"

/decl/hierarchy/supply_pack/supply/contraband
	num_contained = 5
	contains = list(/obj/item/seeds/bloodtomatoseed,
					/obj/item/weapon/storage/pill_bottle/zoom,
					/obj/item/weapon/storage/pill_bottle/happy,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/pwine)

	name = "Contraband crate"
	cost = 30
	containername = "\improper Unlabeled crate"
	contraband = 1
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/supply/hoverpod
	name = "Hoverpod Shipment"
	contains = list()
	cost = 80
	containertype = /obj/structure/largecrate/hoverpod
	containername = "\improper Hoverpod Crate"

/decl/hierarchy/supply_pack/supply/webbing
	name = "Webbing crate"
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
	containername = "\improper Webbing crate"

/decl/hierarchy/supply_pack/supply/glowsticks
	name = "Glowsticks (x20)"
	contains = list(/obj/item/device/flashlight/glowstick,
					/obj/item/device/flashlight/glowstick/red,
					/obj/item/device/flashlight/glowstick/yellow,
					/obj/item/device/flashlight/glowstick/orange,
					/obj/item/device/flashlight/glowstick/blue)
	cost = 10
	containername = "\improper Glowstick Crate"
	num_contained = 20
	supply_method = /decl/supply_method/randomized