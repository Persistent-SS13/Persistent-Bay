/decl/hierarchy/supply_pack/supply
	name = "Supplies - Comissary"
	containertype = /obj/structure/closet/crate

//refills
/decl/hierarchy/supply_pack/supply/toner
	name = "Refills - Toner cartridges"
	contains = list(/obj/item/device/toner = 3)
	cost = 10
	containername = "toner cartridges"

/decl/hierarchy/supply_pack/supply/cardboard_sheets
	name = "Material - cardboard sheets (50)"
	contains = list(/obj/item/stack/material/cardboard/fifty)
	cost = 10
	containername = "cardboard sheets crate"

/decl/hierarchy/supply_pack/supply/paper
	name = "Refills - Paper"
	contains = list(/obj/item/weapon/paper_package)
	cost = 4
	containertype = /obj/structure/closet/crate/paper_refill
	containername = "paper refill crate"

/decl/hierarchy/supply_pack/supply/stickies
	name = "Stationery - sticky notes (50)"
	contains = list(/obj/item/sticky_pad/random)
	cost = 10
	containername = "\improper Sticky notes crate"

/decl/hierarchy/supply_pack/supply/duct_tape_crate
	name = "Refills - Duct tape"
	contains = list(/obj/item/weapon/tape_roll = 10)
	cost = 5
	containername = "duct tape crate"

/decl/hierarchy/supply_pack/supply/wpaper
	name = "Cargo - Wrapping paper"
	contains = list(/obj/item/stack/package_wrap/twenty_five = 3)
	cost = 10
	containername = "wrapping paper"

/decl/hierarchy/supply_pack/supply/tapes
	name = "Medium - Blank Tapes (14)"
	contains = list (/obj/item/weapon/storage/box/tapes)
	cost = 10
	containername = "blank tapes crate"

/decl/hierarchy/supply_pack/supply/scanner_module
	name = "Electronics - Paper scanner modules"
	contains = list(/obj/item/weapon/computer_hardware/scanner/paper = 4)
	cost = 20
	containername = "paper scanner module crate"

//electronics
/decl/hierarchy/supply_pack/supply/spare_pda
	name = "Electronics - Spare PDAs"
	contains = list(/obj/item/modular_computer/pda = 3)
	cost = 10
	containername = "spare PDA crate"

/decl/hierarchy/supply_pack/supply/eftpos
	contains = list(/obj/item/device/eftpos)
	name = "Electronics - EFTPOS scanner"
	cost = 10
	containername = "\improper EFTPOS crate"

/decl/hierarchy/supply_pack/supply/water
	name = "Refills - Bottled water"
	contains = list (/obj/item/weapon/storage/box/water = 2)
	cost = 12
	containername = "bottled water crate"

/decl/hierarchy/supply_pack/supply/sodas
	num_contained = 2
	contains = list(/obj/item/weapon/storage/box/cola,
					/obj/item/weapon/storage/box/cola/spacewind,
					/obj/item/weapon/storage/box/cola/drgibb,
					/obj/item/weapon/storage/box/cola/starkist,
					/obj/item/weapon/storage/box/cola/spaceup,
					/obj/item/weapon/storage/box/cola/lemonlime,
					/obj/item/weapon/storage/box/cola/icedtea,
					/obj/item/weapon/storage/box/cola/grapejuice,
					/obj/item/weapon/storage/box/cola/sodawater)
	name = "Refills - Soda cans"
	cost = 10
	containername = "soda can crate"
//misc
/decl/hierarchy/supply_pack/supply/glowsticks
	name = "Misc - Glowsticks (x20)"
	contains = list(/obj/item/device/flashlight/flare/glowstick,
					/obj/item/device/flashlight/flare/glowstick/red,
					/obj/item/device/flashlight/flare/glowstick/yellow,
					/obj/item/device/flashlight/flare/glowstick/orange,
					/obj/item/device/flashlight/flare/glowstick/blue)
	cost = 2
	containername = "glowstick crate"
	num_contained = 20
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/supply/snacks
	num_contained = 2
	contains = list(/obj/item/weapon/storage/box/snack,
					/obj/item/weapon/storage/box/snack/jerky,
					/obj/item/weapon/storage/box/snack/noraisin,
					/obj/item/weapon/storage/box/snack/cheesehonks,
					/obj/item/weapon/storage/box/snack/tastybread,
					/obj/item/weapon/storage/box/snack/candy,
					/obj/item/weapon/storage/box/snack/chips)
	name = "Refills - Snack foods"
	cost = 10
	containername = "snack foods crate"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/supply/colortubes
	name = "Misc - Colored light tubes"
	contains = list(/obj/item/weapon/light/tube/red = 3,
					/obj/item/weapon/light/tube/green = 3,
					/obj/item/weapon/light/tube/blue = 3,
					/obj/item/weapon/light/tube/purple = 3,
					/obj/item/weapon/light/tube/pink = 3,
					/obj/item/weapon/light/tube/yellow = 3,
					/obj/item/weapon/light/tube/orange = 3)
	cost = 4
	containername = "colored light tube crate"

/decl/hierarchy/supply_pack/supply/colorbulbs
	name = "Misc - Colored light bulbs"
	contains = list(/obj/item/weapon/light/bulb/red = 4,
					/obj/item/weapon/light/bulb/green = 4,
					/obj/item/weapon/light/bulb/blue = 4,
					/obj/item/weapon/light/bulb/purple = 4,
					/obj/item/weapon/light/bulb/pink = 4,
					/obj/item/weapon/light/bulb/yellow = 4,
					/obj/item/weapon/light/bulb/orange = 4)
	cost = 4
	containername = "colored light bulb crate"

//high-risk
/decl/hierarchy/supply_pack/supply/blueprints
	name = "High-risk - Blueprints"
	contains = list(/obj/item/blueprints)
	cost = 150
	containertype = /obj/structure/closet/crate/secure
	containername = "blueprints crate"
	access = core_access_leader

//liquid
/decl/hierarchy/supply_pack/supply/coolanttank
	name = "Liquid - Coolant tank"
	contains = list(/obj/structure/reagent_dispensers/coolanttank)
	cost = 16
	containertype = /obj/structure/largecrate
	containername = "coolant tank crate"

/decl/hierarchy/supply_pack/supply/fueltank
	name = "Liquid - Fuel tank"
	contains = list(/obj/structure/reagent_dispensers/fueltank)
	cost = 8
	containertype = /obj/structure/largecrate
	containername = "fuel tank crate"

/decl/hierarchy/supply_pack/supply/watertank
	name = "Liquid - Water tank"
	contains = list(/obj/structure/reagent_dispensers/watertank)
	cost = 8
	containertype = /obj/structure/largecrate
	containername = "water tank crate"
