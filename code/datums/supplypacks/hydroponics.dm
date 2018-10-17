/decl/hierarchy/supply_pack/hydroponics
	name = "Hydroponics"
	containertype = /obj/structure/closet/crate/hydroponics

//gear
/decl/hierarchy/supply_pack/hydroponics/hydroponics
	name = "Gear - Hydroponics supplies"
	contains = list(/obj/item/clothing/suit/apron,
					/obj/item/clothing/gloves/thick/botany,
					/obj/item/weapon/storage/box/botanydisk,
					/obj/item/weapon/reagent_containers/spray/plantbgone = 4,
					/obj/item/weapon/reagent_containers/glass/bottle/ammonia = 2,
					/obj/item/weapon/material/hatchet,
					/obj/item/weapon/material/minihoe = 2,
					/obj/item/weapon/wirecutters/clippers,
					/obj/item/device/analyzer/plant_analyzer = 2)
	cost = 15
	containername = "hydroponics crate"

/decl/hierarchy/supply_pack/hydroponics/weedcontrol
	name = "Gear - Weed control"
	contains = list(/obj/item/clothing/mask/gas = 2,
					/obj/item/weapon/material/hatchet = 2,
					/obj/item/weapon/reagent_containers/spray/plantbgone = 4,
					/obj/item/weapon/shovel,
					/obj/item/weapon/shovel/spade,
					/obj/item/weapon/grenade/chem_grenade/antiweed = 2)
	cost = 25
	containername = "weed control crate"

//samples
/decl/hierarchy/supply_pack/hydroponics/seeds
	name = "Samples - Mundane seeds"
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
	containername = "seeds crate"

/decl/hierarchy/supply_pack/hydroponics/exoticseeds
	name = "Samples - Exotic seeds"
	contains = list(/obj/item/seeds/libertymycelium,
					/obj/item/seeds/reishimycelium,
					/obj/item/seeds/random = 6,
					/obj/item/seeds/kudzuseed)
	cost = 15
	containertype = /obj/structure/closet/crate/secure/hydrosec
	containername = "exotic seeds crate"
	access = core_access_science_programs

//equipment
/decl/hierarchy/supply_pack/hydroponics/bee_keeper
	name = "Equipment - Beekeeping"
	contains = list(/obj/item/beehive_assembly,
					/obj/item/bee_smoker,
					/obj/item/honey_frame = 5,
					/obj/item/bee_pack)
	cost = 35
	containername = "beekeeping crate"

/decl/hierarchy/supply_pack/hydroponics/hydrotray
	name = "Equipment - Empty hydroponics tray"
	contains = list(/obj/machinery/portable_atmospherics/hydroponics{anchored = 0})
	cost = 28
	containertype = /obj/structure/closet/crate/large/hydroponics
	containername = "hydroponics tray crate"

//liquid
/decl/hierarchy/supply_pack/hydroponics/watertank
	name = "Liquid - Water tank crate"
	contains = list(/obj/structure/reagent_dispensers/watertank)
	cost = 8
	containertype = /obj/structure/largecrate
	containername = "water tank crate"