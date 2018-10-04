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
	cost = 5
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Food crate"

/decl/hierarchy/supply_pack/supply/toner
	name = "Toner cartridges"
	contains = list(/obj/item/device/toner = 20)
	cost = 3
	containername = "\improper Toner cartridges"

/decl/hierarchy/supply_pack/supply/janitor
	name = "Janitorial supplies"
	contains = list(/obj/item/weapon/reagent_containers/glass/bucket,
					/obj/item/weapon/mop,
					/obj/structure/mopbucket,
					/obj/item/weapon/caution = 4,
					/obj/item/weapon/storage/bag/trash,
					/obj/item/device/lightreplacer,
					/obj/item/weapon/reagent_containers/spray/cleaner,
					/obj/item/weapon/reagent_containers/glass/rag,
					/obj/item/weapon/grenade/chem_grenade/cleaner = 3,
					/obj/item/weapon/soap)
	cost = 10
	containertype = /obj/structure/closet/crate/trashcart
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
					/obj/item/weapon/paper_bin)
	name = "Office supplies"
	cost = 10
	containertype = /obj/structure/closet/crate/large
	containername = "\improper Office supplies crate"

/decl/hierarchy/supply_pack/supply/paper
	name = "Paper (x50)"
	contains = list(/obj/item/weapon/paper_package)
	cost = 4
	containername = "\improper Paper supplies crate"

/decl/hierarchy/supply_pack/supply/spare_pda
	name = "Spare PDAs"
	contains = list(/obj/item/device/pda = 10)
	cost = 10
	containername = "\improper Spare PDA crate"

/decl/hierarchy/supply_pack/supply/mule
	name = "MULEbot crate"
	contains = list()
	cost = 20
	containertype = /obj/structure/largecrate/animal/mulebot
	containername = "Mulebot crate"

/decl/hierarchy/supply_pack/supply/janicart
	name = "Janitorial Cart crate"
	contains = list(/obj/structure/janitorialcart)
	cost = 35
	containertype = /obj/structure/largecrate
	containername = "Janitorial Cart crate"

/decl/hierarchy/supply_pack/supply/cargotrain
	name = "Cargo Train Tug"
	contains = list(/obj/vehicle/train/cargo/engine)
	cost = 45
	containertype = /obj/structure/largecrate
	containername = "\improper Cargo Train Tug crate"

/decl/hierarchy/supply_pack/supply/cargotrailer
	name = "Cargo Train Trolley"
	contains = list(/obj/vehicle/train/cargo/trolley)
	cost = 15
	containertype = /obj/structure/largecrate
	containername = "\improper Cargo Train Trolley crate"

/decl/hierarchy/supply_pack/supply/hoverpod
	name = "Hoverpod Shipment"
	contains = list()
	cost = 120
	containertype = /obj/structure/largecrate/hoverpod
	containername = "\improper Hoverpod crate"
/*
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
*/
/decl/hierarchy/supply_pack/supply/glowsticks
	name = "Glowsticks (x20)"
	contains = list(/obj/item/device/flashlight/glowstick,
					/obj/item/device/flashlight/glowstick/red,
					/obj/item/device/flashlight/glowstick/yellow,
					/obj/item/device/flashlight/glowstick/orange,
					/obj/item/device/flashlight/glowstick/blue)
	cost = 2
	containername = "\improper Glowstick crate"
	num_contained = 20
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/supply/colortubes
	name = "Colored Light Tubes"
	contains = list(/obj/item/weapon/light/tube/red = 3,
					/obj/item/weapon/light/tube/green = 3,
					/obj/item/weapon/light/tube/blue = 3,
					/obj/item/weapon/light/tube/purple = 3,
					/obj/item/weapon/light/tube/pink = 3,
					/obj/item/weapon/light/tube/yellow = 3,
					/obj/item/weapon/light/tube/orange = 3)
	cost = 4
	containername = "\improper Light Tube crate"

/decl/hierarchy/supply_pack/supply/colorbulbs
	name = "Colored Light Bulbs"
	contains = list(/obj/item/weapon/light/bulb/red = 4,
					/obj/item/weapon/light/bulb/green = 4,
					/obj/item/weapon/light/bulb/blue = 4,
					/obj/item/weapon/light/bulb/purple = 4,
					/obj/item/weapon/light/bulb/pink = 4,
					/obj/item/weapon/light/bulb/yellow = 4,
					/obj/item/weapon/light/bulb/orange = 4)
	cost = 4
	containername = "\improper Light Bulb crate"

/decl/hierarchy/supply_pack/supply/softsuit_emergency
	name = "Emergency Softsuit w/ Small Airtank"
	contains = list(/obj/item/weapon/tank/emergency/oxygen/engi,
			 		/obj/item/clothing/suit/space/emergency,
					/obj/item/clothing/head/helmet/space/emergency)
	cost = 15
	containername = "\improper Emergency Softsuit crate"

/decl/hierarchy/supply_pack/supply/softsuit
	name = "EVA Softsuit w/ Small Airtank"
	contains = list(/obj/item/weapon/tank/emergency/oxygen/engi,
			 		/obj/item/clothing/suit/space,
					/obj/item/clothing/head/helmet/space,
					/obj/item/clothing/shoes/magboots)
	cost = 30
	containername = "\improper Softsuit crate"

/decl/hierarchy/supply_pack/supply/salvagedsuit
	name = "Salvaged Voidsuit with Airtank"
	contains = list(/obj/item/weapon/tank/oxygen,
			 		/obj/item/clothing/suit/space/void/engineering/salvage/prepared)
	cost = 50
	containername = "\improper Salvaged Voidsuit crate"

/decl/hierarchy/supply_pack/supply/voidsuit
	name = "Basic Voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/prepared)
	cost = 100
	containername = "\improper Basic Voidsuit crate"

/decl/hierarchy/supply_pack/supply/voidsuit_purple
	name = "Deluxe Purple Voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/exploration/prepared)
	cost = 300 //Expensive because moderately protects armor & heat
	containername = "\improper Purple Voidsuit crate"

/decl/hierarchy/supply_pack/supply/voidsuit_red
	name = "Red Voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/pilot/prepared)
	cost = 100
	containername = "\improper Red Voidsuit crate"

/decl/hierarchy/supply_pack/supply/blueprints
	name = "Blueprints"
	contains = list(/obj/item/blueprints)
	cost = 150
	containertype = /obj/structure/closet/crate/secure/large
	containername = "\improper Blueprints crate"
	access = core_access_leader

/decl/hierarchy/supply_pack/supply/duct_tape_crate
	name = "Duct tape crate x10"
	contains = list(/obj/item/weapon/tape_roll=10)
	cost = 5
	containername = "\improper Duct Tape crate"
