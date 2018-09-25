/decl/hierarchy/supply_pack/materials
	name = "Materials"

// Material Sheets - Bulk!
/decl/hierarchy/supply_pack/materials/steel200
	name = "Basic Material - Steel Bulk Order - (x200)"
	contains = list(/obj/item/stack/material/steel/fifty = 4)
	cost = 90
	containername = "\improper Bulk Steel Shipment"

/decl/hierarchy/supply_pack/materials/glass200
	name = "Basic Material - Glass Bulk Order (x200)"
	contains = list(/obj/item/stack/material/glass/fifty = 4)
	cost = 50
	containername = "\improper Bulk Glass Shipment"

// Material sheets (50 - full stack)
/decl/hierarchy/supply_pack/materials/steel50
	name = "Basic Material - Steel (x50)"
	contains = list(/obj/item/stack/material/steel/fifty)
	cost = 30
	containername = "\improper Steel sheets crate"

/decl/hierarchy/supply_pack/materials/glass50
	name = "Basic Material - Glass (x50)"
	contains = list(/obj/item/stack/material/glass/fifty)
	cost = 15
	containername = "\improper Glass sheets crate"

/decl/hierarchy/supply_pack/materials/cardboard50
	name = "Basic Material - Cardboard (x50)"
	contains = list(/obj/item/stack/material/cardboard/fifty)
	cost = 5
	containername = "\improper Cardboard sheets crate"

/decl/hierarchy/supply_pack/materials/wood50
	name = "Basic Material - Wooden Planks (x50)"
	contains = list(/obj/item/stack/material/wood/fifty)
	cost = 100
	containername = "\improper Wooden planks crate"

/decl/hierarchy/supply_pack/materials/plastic50
	name = "Basic Material - Plastic (x50)"
	contains = list(/obj/item/stack/material/plastic/fifty)
	cost = 8
	containername = "\improper Plastic sheets crate"

/decl/hierarchy/supply_pack/materials/marble50
	name = "Basic Material - Marble (x50)"
	contains = list(/obj/item/stack/material/marble/fifty)
	cost = 60
	containername = "\improper Marble slabs crate"

/decl/hierarchy/supply_pack/materials/plasteel50
	name = "Heavy Material - Plasteel (x50)"
	contains = list(/obj/item/stack/material/plasteel/fifty)
	cost = 80
	containername = "\improper Plasteel sheets crate"

/decl/hierarchy/supply_pack/materials/ocp50
	name = "Heavy Material - Osmium Carbide Plasteel (x50)"
	contains = list(/obj/item/stack/material/ocp/fifty)
	cost = 100
	containername = "\improper Osmium carbide plasteel sheets crate"

// Material sheets (10 - Smaller amounts, less cost efficient)
/decl/hierarchy/supply_pack/materials/marble10
	name = "Basic Material - Marble (x10)"
	contains = list(/obj/item/stack/material/marble/ten)
	cost = 20
	containername = "\improper Marble slabs crate"

/decl/hierarchy/supply_pack/materials/plasteel10
	name = "Heavy Material - Plasteel (x10)"
	contains = list(/obj/item/stack/material/plasteel/ten)
	cost = 25
	containername = "\improper Plasteel sheets crate"

/decl/hierarchy/supply_pack/materials/ocp10
	name = "Heavy Material - Osmium Carbide Plasteel (x10)"
	contains = list(/obj/item/stack/material/ocp/ten)
	cost = 30
	containername = "\improper Osmium carbide plasteel sheets crate"

// Material sheets of expensive materials. These are very expensive and therefore pretty hard
// to get without mining crew that would bring materials to sell in exchange.
/decl/hierarchy/supply_pack/materials/phoron10
	name = "Exotic Material - Phoron (x10)"
	contains = list(/obj/item/stack/material/phoron/ten)
	cost = 350
	containername = "\improper Phoron sheets crate"
	containertype = /obj/structure/closet/crate/secure/phoron
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/materials/gold10
	name = "Rare Material - Gold (x10)"
	contains = list(/obj/item/stack/material/gold/ten)
	cost = 100
	containername = "\improper Gold sheets crate"

/decl/hierarchy/supply_pack/materials/silver10
	name = "Rare Material - Silver (x10)"
	contains = list(/obj/item/stack/material/silver/ten)
	cost = 80
	containername = "\improper Silver sheets crate"

/decl/hierarchy/supply_pack/materials/uranium10
	name = "Rare Material - Uranium (x10)"
	contains = list(/obj/item/stack/material/uranium/ten)
	cost = 125
	containername = "\improper Uranium sheets crate"
	containertype = /obj/structure/closet/crate/uranium

/decl/hierarchy/supply_pack/materials/diamond10
	name = "Rare Material - Diamond (x10)"
	contains = list(/obj/item/stack/material/diamond/ten)
	cost = 200
	containername = "\improper Diamond sheets crate"

//tiling
/decl/hierarchy/supply_pack/miscellaneous/carpetbrown
	name = "Tiling - Brown carpet"
	contains = list(/obj/item/stack/tile/carpet/fifty)
	cost = 5
	containername = "\improper Brown carpet crate"

/decl/hierarchy/supply_pack/miscellaneous/carpetblue
	name = "Tiling - Blue and gold carpet"
	contains = list(/obj/item/stack/tile/carpetblue/fifty)
	cost = 5
	containername = "\improper Blue and gold carpet crate"

/decl/hierarchy/supply_pack/miscellaneous/carpetblue2
	name = "Tiling - Blue and silver carpet"
	contains = list(/obj/item/stack/tile/carpetblue2/fifty)
	cost = 5
	containername = "\improper Blue and silver carpet crate"

/decl/hierarchy/supply_pack/miscellaneous/carpetpurple
	name = "Tiling - Purple carpet"
	contains = list(/obj/item/stack/tile/carpetpurple/fifty)
	cost = 5
	containername = "\improper Purple carpet crate"

/decl/hierarchy/supply_pack/miscellaneous/carpetorange
	name = "Tiling - Orange carpet"
	contains = list(/obj/item/stack/tile/carpetorange/fifty)
	cost = 5
	containername = "\improper Orange carpet crate"

/decl/hierarchy/supply_pack/miscellaneous/carpetgreen
	name = "Tiling - Green carpet"
	contains = list(/obj/item/stack/tile/carpetgreen/fifty)
	cost = 5
	containername = "\improper Green carpet crate"

/decl/hierarchy/supply_pack/miscellaneous/carpetred
	name = "Tiling - Red carpet"
	contains = list(/obj/item/stack/tile/carpetred/fifty)
	cost = 5
	containername = "\improper Red carpet crate"

/decl/hierarchy/supply_pack/miscellaneous/linoleum
	name = "Tiling - Linoleum"
	contains = list(/obj/item/stack/tile/linoleum/fifty)
	cost = 5
	containername = "\improper Linoleum crate"

/decl/hierarchy/supply_pack/miscellaneous/dark_tiles	//Leaving dark tiles because it is made from plasteel, which is expensive
	name = "Tiling - Dark floor tiles"
	contains = list(/obj/item/stack/tile/floor_dark/fifty)
	cost = 5
	containername = "\improper Dark floor tile crate"
