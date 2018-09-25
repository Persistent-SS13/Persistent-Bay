/decl/hierarchy/supply_pack/hospitality
	name = "Hospitality"

//foodstuffs
/decl/hierarchy/supply_pack/hospitality/pizza
	num_contained = 5
	name = "Foodstuffs - Surprise pack of five pizzas"
	contains = list(/obj/item/pizzabox/margherita,
					/obj/item/pizzabox/mushroom,
					/obj/item/pizzabox/meat,
					/obj/item/pizzabox/vegetable)
	cost = 12
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Pizza crate"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/hospitality/beef
	name = "Foodstuffs - Beef (x36)"
	contains = list(/obj/item/weapon/reagent_containers/food/snacks/meat/beef = 36)
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Beef crate"
	cost = 20

/decl/hierarchy/supply_pack/hospitality/goat
	name = "Foodstuffs - Goat Meat (x36)"
	contains = list(/obj/item/weapon/reagent_containers/food/snacks/meat/goat = 36)
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Goat meat crate"
	cost = 20

/decl/hierarchy/supply_pack/hospitality/chicken
	name = "Foodstuffs - Chicken Meat (x36)"
	contains = list(/obj/item/weapon/reagent_containers/food/snacks/meat/chicken = 36)
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Chicken meat crate"
	cost = 20

/decl/hierarchy/supply_pack/hospitality/eggs
	name = "Foodstuffs - Five Cartons of Eggs"
	contains = list(/obj/item/weapon/storage/fancy/egg_box = 5)
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Egg crate"
	cost = 15

/decl/hierarchy/supply_pack/hospitality/soymilk
	name = "Foodstuffs - Imported Soy Milk (x7)"
	contains = list(/obj/item/weapon/reagent_containers/food/drinks/soymilk = 7)
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Imported Soy Milk crate"
	cost = 15

//amenities
/decl/hierarchy/supply_pack/hospitality/party
	name = "Amenities - Party equipment"
	contains = list(/obj/item/weapon/storage/box/mixedglasses = 2,
					/obj/item/weapon/storage/box/glasses/square,
					/obj/item/weapon/storage/box/glowsticks = 2,
					/obj/item/weapon/storage/fancy/cigarettes/dromedaryco,
					/obj/item/weapon/reagent_containers/food/drinks/shaker,
					/obj/item/weapon/reagent_containers/food/drinks/flask/barflask,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/patron,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/goldschlager,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/specialwhiskey,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/small/ale = 2,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/small/beer = 4,
					/obj/item/weapon/lipstick/random,
					/obj/item/weapon/clothingbag/rubbermask,
					/obj/item/weapon/clothingbag/rubbersuit)
	cost = 15
	containername = "\improper Party equipment"

/decl/hierarchy/supply_pack/hospitality/cigarettes
	num_contained = 4
	name = "Amenities - Imported cigarettes"
	contains = list(/obj/item/weapon/storage/fancy/cigarettes,
					/obj/item/weapon/storage/fancy/cigarettes/dromedaryco,
					/obj/item/weapon/storage/fancy/cigarettes/killthroat,
					/obj/item/weapon/storage/fancy/cigarettes/luckystars,
					/obj/item/weapon/storage/fancy/cigarettes/jerichos,
					/obj/item/weapon/storage/fancy/cigarettes/menthols,
					/obj/item/weapon/storage/fancy/cigarettes/carcinomas,
					/obj/item/weapon/storage/fancy/cigarettes/professionals,
					/obj/item/weapon/flame/lighter)
	cost = 28
	containername = "\improper Imported cigarettes"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/hospitality/cigars
	name = "Amenities - Imported cigars"
	contains = list(/obj/item/weapon/storage/fancy/cigar,
					/obj/item/weapon/flame/lighter/zippo)
	cost = 100
	containername = "\improper Imported cigars"

/decl/hierarchy/supply_pack/hospitality/barsupplies
	name = "Bar supplies"
	contains = list(/obj/item/weapon/storage/box/glasses/cocktail,
					/obj/item/weapon/storage/box/glasses/rocks,
					/obj/item/weapon/storage/box/glasses/square,
					/obj/item/weapon/storage/box/glasses/pint,
					/obj/item/weapon/storage/box/glasses/wine,
					/obj/item/weapon/storage/box/glasses/shake,
					/obj/item/weapon/storage/box/glasses/shot,
					/obj/item/weapon/storage/box/glasses/mug,
					/obj/item/weapon/storage/box/glass_extras/straws,
					/obj/item/weapon/storage/box/glass_extras/sticks,
					/obj/item/weapon/reagent_containers/food/drinks/shaker)
	cost = 10
	containername = "crate of bar supplies"

/decl/hierarchy/supply_pack/hospitality/lasertag
	name = "Amenities - Lasertag equipment"
	contains = list(/obj/item/weapon/gun/energy/lasertag/red = 3,
					/obj/item/clothing/suit/redtag = 3,
					/obj/item/weapon/gun/energy/lasertag/blue = 3,
					/obj/item/clothing/suit/bluetag = 3)
	cost = 10
	containertype = /obj/structure/closet
	containername = "\improper Lasertag Closet"

/decl/hierarchy/supply_pack/hospitality/artscrafts
	name = "Amenities - Arts and Crafts supplies"
	contains = list(/obj/item/weapon/storage/fancy/crayons,
					/obj/item/device/camera,
					/obj/item/device/camera_film = 2,
					/obj/item/weapon/storage/photo_album,
					/obj/item/weapon/packageWrap,
					/obj/item/weapon/reagent_containers/glass/paint/red,
					/obj/item/weapon/reagent_containers/glass/paint/green,
					/obj/item/weapon/reagent_containers/glass/paint/blue,
					/obj/item/weapon/reagent_containers/glass/paint/yellow,
					/obj/item/weapon/reagent_containers/glass/paint/purple,
					/obj/item/weapon/reagent_containers/glass/paint/black,
					/obj/item/weapon/reagent_containers/glass/paint/white,
					/obj/item/weapon/contraband/poster,
					/obj/item/weapon/wrapping_paper = 3)
	cost = 6
	containername = "\improper Arts and Crafts crate"

/decl/hierarchy/supply_pack/hospitality/posters
	name = "Amenities - Assorted Posters (x4)"
	contains = list(/obj/item/weapon/contraband/poster = 4)
	cost = 4
	containername = "\improper Posters crate"

/decl/hierarchy/supply_pack/hospitality/athletic
	name = "Athletics crate"
	contains = list(/obj/item/clothing/under/shorts/blue,
					/obj/item/clothing/under/shorts/red,
					/obj/item/clothing/under/shorts/green,
					/obj/item/clothing/under/shorts/black,
					/obj/item/clothing/gloves/boxing/green,
					/obj/item/clothing/gloves/boxing,
					/obj/item/weapon/beach_ball/holoball = 2)
	cost = 6
	containertype = /obj/structure/closet/athletic_mixed
	containername = "\improper Athletics crate"

//music
/decl/hierarchy/supply_pack/hospitality/jukebox
	name = "Music - Jukebox"
	contains = list(/obj/machinery/media/jukebox)
	cost = 260
	containertype = /obj/structure/largecrate
	containername = "\improper Jukebox crate"

/decl/hierarchy/supply_pack/hospitality/piano
	name = "Music - Piano crate"
	contains = list(/obj/structure/device/piano)
	cost = 500
	containertype = /obj/structure/largecrate
	containername = "\improper Piano crate"

/decl/hierarchy/supply_pack/hospitality/guitar
	name = "Music - Guitar crate"
	contains = list(/obj/item/instrument/guitar)
	cost = 20
	containername = "\improper Guitar crate"

/decl/hierarchy/supply_pack/hospitality/piano
	name = "Music - Violin crate"
	contains = list(/obj/item/device/violin)
	cost = 40
	containername = "\improper Violin crate"
