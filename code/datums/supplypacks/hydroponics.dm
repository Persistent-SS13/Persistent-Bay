/decl/hierarchy/supply_pack/hydroponics
	name = "Hydroponics"
	containertype = /obj/structure/closet/crate/hydroponics

//monkeys
/decl/hierarchy/supply_pack/hydroponics/monkey
	name = "Monkeys - Monkey crate"
	contains = list (/obj/item/weapon/storage/box/monkeycubes)
	cost = 20
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Monkey crate"

/decl/hierarchy/supply_pack/hydroponics/farwa
	name = "Monkeys - Farwa crate"
	contains = list (/obj/item/weapon/storage/box/monkeycubes/farwacubes)
	cost = 30
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Farwa crate"

/decl/hierarchy/supply_pack/hydroponics/skrell
	name = "Monkeys - Neaera crate"
	contains = list (/obj/item/weapon/storage/box/monkeycubes/neaeracubes)
	cost = 30
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Neaera crate"

/decl/hierarchy/supply_pack/hydroponics/stok
	name = "Monkeys - Stok crate"
	contains = list (/obj/item/weapon/storage/box/monkeycubes/stokcubes)
	cost = 30
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Stok crate"

//pets
/decl/hierarchy/supply_pack/hydroponics/corgi
	name = "Pets - Corgi crate"
	contains = list()
	cost = 50
	containertype = /obj/structure/largecrate/animal/corgi
	containername = "\improper Corgi crate"

//livestock
/decl/hierarchy/supply_pack/hydroponics/cow
	name = "Livestock - Cow crate"
	cost = 45
	containertype = /obj/structure/largecrate/animal/cow
	containername = "\improper Cow crate"

/decl/hierarchy/supply_pack/hydroponics/goat
	name = "Livestock - Goat crate"
	cost = 35
	containertype = /obj/structure/largecrate/animal/goat
	containername = "\improper Goat crate"

/decl/hierarchy/supply_pack/hydroponics/chicken
	name = "Livestock - Chicken crate"
	cost = 25
	containertype = /obj/structure/largecrate/animal/chick
	containername = "\improper Chicken crate"

//botany
/decl/hierarchy/supply_pack/hydroponics/hydroponics
	name = "Botany - Hydroponics Supply crate"
	contains = list(/obj/item/clothing/suit/apron,
					/obj/item/clothing/gloves/thick/botany,
					/obj/item/weapon/storage/box/botanydisk,
					/obj/item/weapon/reagent_containers/spray/plantbgone = 4,
					/obj/item/weapon/reagent_containers/glass/bottle/ammonia = 2,
					/obj/item/weapon/material/hatchet,
					/obj/item/weapon/material/minihoe = 2,
					/obj/item/device/analyzer/plant_analyzer)
	cost = 15
	containername = "\improper Hydroponics crate"

/decl/hierarchy/supply_pack/hydroponics/seeds
	name = "Botany - Seeds crate"
	contains = list(/obj/item/seeds/chiliseed,
					/obj/item/seeds/berryseed,
					/obj/item/seeds/cornseed,
					/obj/item/seeds/eggplantseed,
					/obj/item/seeds/tomatoseed,
					/obj/item/seeds/appleseed,
					/obj/item/seeds/soyaseed,
					/obj/item/seeds/wheatseed,
					/obj/item/seeds/carrotseed,
					/obj/item/seeds/harebell,
					/obj/item/seeds/lemonseed,
					/obj/item/seeds/orangeseed,
					/obj/item/seeds/grassseed,
					/obj/item/seeds/sunflowerseed,
					/obj/item/seeds/chantermycelium,
					/obj/item/seeds/potatoseed,
					/obj/item/seeds/sugarcaneseed)
	cost = 10
	containername = "\improper Seeds crate"

/decl/hierarchy/supply_pack/hydroponics/weedcontrol
	name = "Botany - Weed control crate"
	contains = list(/obj/item/clothing/mask/gas = 2,
					/obj/item/weapon/material/hatchet = 2,
					/obj/item/weapon/reagent_containers/spray/plantbgone = 4,
					/obj/item/weapon/shovel,
					/obj/item/weapon/shovel/spade,
					/obj/item/weapon/grenade/chem_grenade/antiweed = 2)
	cost = 25
	containername = "\improper Weed control crate"

/decl/hierarchy/supply_pack/hydroponics/watertank
	name = "Water tank crate"
	contains = list(/obj/structure/reagent_dispensers/watertank)
	cost = 8
	containertype = /obj/structure/largecrate
	containername = "\improper water tank crate"

/decl/hierarchy/supply_pack/hydroponics/bee_keeper
	name = "Beekeeping crate"
	contains = list(/obj/item/beehive_assembly,
					/obj/item/bee_smoker,
					/obj/item/honey_frame = 5,
					/obj/item/bee_pack)
	cost = 35
	containername = "\improper Beekeeping crate"

/decl/hierarchy/supply_pack/hydroponics/hydrotray
	name = "Botany - Empty hydroponics tray"
	contains = list(/obj/machinery/portable_atmospherics/hydroponics{anchored = 0})
	cost = 28
	containertype = /obj/structure/closet/crate/large/hydroponics
	containername = "\improper Hydroponics tray crate"

//xenobotany
/decl/hierarchy/supply_pack/hydroponics/exoticseeds
	name = "Xenobotany - Exotic seeds crate"
	contains = list(/obj/item/seeds/libertymycelium,
					/obj/item/seeds/reishimycelium,
					/obj/item/seeds/random = 6,
					/obj/item/seeds/kudzuseed)
	cost = 15
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Exotic Seeds crate"
	access = core_access_science_programs
