/decl/hierarchy/supply_pack/materials
	name = "Materials"

/decl/hierarchy/supply_pack/materials/New()
	for(var/thing in contains)
		var/obj/item/stack/material/S = thing
		var/material/mat = SSmaterials.get_material_by_name(initial(S.default_type))
		if(istype(mat) && mat.sale_price)
			cost += mat.sale_price * initial(S.amount)
	..()

// Material Sheets - Bulk!
/decl/hierarchy/supply_pack/materials/steel200
	name = "Basic Material - Steel Bulk Order - (x200)"
	contains = list(/obj/item/stack/material/steel/fifty = 4)
	cost = 90
	containername = "bulk steel order crate"

/decl/hierarchy/supply_pack/materials/glass200
	name = "Basic Material - Glass Bulk Order (x200)"
	contains = list(/obj/item/stack/material/glass/fifty = 4)
	cost = 50
	containername = "bulk glass order crate"

// Material sheets (50 - full stack)
/decl/hierarchy/supply_pack/materials/steel50
	name = "Basic Material - Steel (x50)"
	contains = list(/obj/item/stack/material/steel/fifty)
	cost = 30
	containername = "steel sheets crate"

/decl/hierarchy/supply_pack/materials/alum50
	name = "50 aluminium sheets"
	contains = list(/obj/item/stack/material/aluminium/fifty)
	cost = 10
	containername = "aluminium sheets crate"

/decl/hierarchy/supply_pack/materials/glass50
	name = "Basic Material - Glass (x50)"
	contains = list(/obj/item/stack/material/glass/fifty)
	cost = 15
	containername = "glass sheets crate"

/decl/hierarchy/supply_pack/materials/plastic50
	name = "Basic Material - Plastic (x50)"
	contains = list(/obj/item/stack/material/plastic/fifty)
	cost = 8
	containername = "plastic sheets crate"

/decl/hierarchy/supply_pack/materials/marble50
	name = "Basic Material - Marble (x50)"
	contains = list(/obj/item/stack/material/marble/fifty)
	cost = 60
	containername = "marble slabs crate"

/decl/hierarchy/supply_pack/materials/plasteel50
	name = "Heavy Material - Plasteel (x50)"
	contains = list(/obj/item/stack/material/plasteel/fifty)
	cost = 80
	containername = "plasteel sheets crate"

/decl/hierarchy/supply_pack/materials/ocp50
	name = "Heavy Material - Osmium-carbide plasteel (x50)"
	contains = list(/obj/item/stack/material/ocp/fifty)
	cost = 100
	containername = "osmium-carbide plasteel sheets crate"

// Material sheets (10 - Smaller amounts, less cost efficient)
/decl/hierarchy/supply_pack/materials/marble10
	name = "Basic Material - Marble (x10)"
	contains = list(/obj/item/stack/material/marble/ten)
	cost = 20
	containername = "marble slabs crate"

/decl/hierarchy/supply_pack/materials/plasteel10
	name = "Heavy Material - Plasteel (x10)"
	contains = list(/obj/item/stack/material/plasteel/ten)
	cost = 25
	containername = "plasteel sheets crate"

/decl/hierarchy/supply_pack/materials/ocp10
	name = "Heavy Material - Osmium-carbide plasteel (x10)"
	contains = list(/obj/item/stack/material/ocp/ten)
	cost = 30
	containername = "osmium-carbide plasteel sheets crate"

/decl/hierarchy/supply_pack/materials/copper10
	name = "Basic Material - Copper (x10)"
	contains = list(/obj/item/stack/material/copper/ten)
	cost = 18
	containername = "copper sheets crate"

// Material sheets of expensive materials. These are very expensive and therefore pretty hard
// to get without mining crew that would bring materials to sell in exchange.
/decl/hierarchy/supply_pack/materials/phoron10
	name = "Exotic Material - Phoron (x10)"
	contains = list(/obj/item/stack/material/phoron/ten)
	cost = 350
	containername = "phoron sheets crate"
	containertype = /obj/structure/closet/crate/secure/phoron
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/materials/gold10
	name = "Rare Material - Gold (x10)"
	contains = list(/obj/item/stack/material/gold/ten)
	cost = 100
	containername = "gold sheets crate"

/decl/hierarchy/supply_pack/materials/silver10
	name = "Rare Material - Silver (x10)"
	contains = list(/obj/item/stack/material/silver/ten)
	cost = 80
	containername = "silver sheets crate"

/decl/hierarchy/supply_pack/materials/uranium10
	name = "Rare Material - Uranium (x10)"
	contains = list(/obj/item/stack/material/uranium/ten)
	cost = 125
	containername = "uranium sheets crate"
	containertype = /obj/structure/closet/crate/uranium

/decl/hierarchy/supply_pack/materials/diamond10
	name = "Rare Material - Diamond (x10)"
	contains = list(/obj/item/stack/material/diamond/ten)
	cost = 200
	containername = "diamond sheets crate"

//wood zone
/decl/hierarchy/supply_pack/materials/wood50
	name = "50 wooden planks"
	contains = list(/obj/item/stack/material/wood/fifty)
	cost = 10
	containername = "wooden planks crate"

/decl/hierarchy/supply_pack/materials/mahogany25
	name = "25 mahogany planks"
	contains = list(/obj/item/stack/material/wood/mahogany/twentyfive)
	cost = 10
	containername = "wooden planks crate"

/decl/hierarchy/supply_pack/materials/maple25
	name = "25 maple planks"
	contains = list(/obj/item/stack/material/wood/maple/twentyfive = 2)
	cost = 10
	containername = "wooden planks crate"

/decl/hierarchy/supply_pack/materials/walnut25
	name = "25 walnut planks"
	contains = list(/obj/item/stack/material/wood/walnut/twentyfive)
	cost = 10
	containername = "walnut planks crate"

/decl/hierarchy/supply_pack/materials/ebony25
	name = "25 ebony planks"
	contains = list(/obj/item/stack/material/wood/ebony/twentyfive)
	cost = 15 //luxury tax
	containername = "ebony planks crate"


/decl/hierarchy/supply_pack/materials/cardboard50
	name = "Basic Material - Cardboard (x50)"
	contains = list(/obj/item/stack/material/cardboard/fifty)
	cost = 5
	containername = "cardboard sheets crate"

