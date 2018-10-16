/decl/hierarchy/supply_pack/hospitality
	name = "Hospitality"

//kitchen
/decl/hierarchy/supply_pack/hospitality/food
	name = "Kitchen - Kitchen supplies"
	contains = list(/obj/item/weapon/reagent_containers/food/condiment/flour = 6,
					/obj/item/weapon/reagent_containers/food/condiment/enzyme,
					/obj/item/weapon/reagent_containers/food/drinks/milk = 2,
					/obj/item/weapon/reagent_containers/food/snacks/tofu = 4,
					/obj/item/weapon/reagent_containers/food/snacks/meat = 4)
	cost = 5
	containertype = /obj/structure/closet/crate/freezer
	containername = "food crate"

//foodstuffs
/decl/hierarchy/supply_pack/hospitality/pizza
	num_contained = 5
	name = "Foodstuffs - Five pizzas"
	contains = list(/obj/item/pizzabox/margherita,
					/obj/item/pizzabox/mushroom,
					/obj/item/pizzabox/meat,
					/obj/item/pizzabox/vegetable)
	cost = 12
	containertype = /obj/structure/closet/crate/freezer
	containername = "pizza crate"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/hospitality/beef
	name = "Foodstuffs - Beef"
	contains = list(/obj/item/weapon/reagent_containers/food/snacks/meat/beef = 36)
	containertype = /obj/structure/closet/crate/freezer
	containername = "beef crate"
	cost = 20

/decl/hierarchy/supply_pack/hospitality/goat
	name = "Foodstuffs - Goat meat"
	contains = list(/obj/item/weapon/reagent_containers/food/snacks/meat/goat = 36)
	containertype = /obj/structure/closet/crate/freezer
	containername = "goat meat crate"
	cost = 20

/decl/hierarchy/supply_pack/hospitality/chicken
	name = "Foodstuffs - Poultry"
	contains = list(/obj/item/weapon/reagent_containers/food/snacks/meat/chicken = 36)
	containertype = /obj/structure/closet/crate/freezer
	containername = "poultry crate"
	cost = 20

/decl/hierarchy/supply_pack/hospitality/eggs
	name = "Foodstuffs - Five cartons of eggs"
	contains = list(/obj/item/weapon/storage/fancy/egg_box = 4)
	containertype = /obj/structure/closet/crate/freezer
	containername = "egg crate"
	cost = 12

/decl/hierarchy/supply_pack/hospitality/soymilk
	name = "Foodstuffs - Imported soy milk"
	contains = list(/obj/item/weapon/reagent_containers/food/drinks/soymilk = 6)
	containertype = /obj/structure/closet/crate/freezer
	containername = "soy milk crate"
	cost = 12

/decl/hierarchy/supply_pack/hospitality/seafood
	name = "Foodstuffs - Seafood crate"
	contains = list(
		/obj/item/weapon/reagent_containers/food/snacks/fish = 2,
		/obj/item/weapon/reagent_containers/food/snacks/fish/shark = 2,
		/obj/item/weapon/reagent_containers/food/snacks/fish/octopus = 2
		)
	containertype = /obj/structure/closet/crate/freezer
	containername = "seafood crate"
	cost = 20

//bar
/decl/hierarchy/supply_pack/hospitality/party
	name = "Bar - Party equipment"
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
	containername = "party equipment"

/decl/hierarchy/supply_pack/hospitality/barsupplies
	name = "Bar - Bar supplies"
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

//equipment
/decl/hierarchy/supply_pack/hospitality/beer_dispenser
	name = "Equipment - Booze dispenser"
	contains = list(/obj/machinery/chemical_dispenser/bar_alc{anchored = 0})
	cost = 25
	containertype = /obj/structure/largecrate
	containername = "booze dispenser crate"

/decl/hierarchy/supply_pack/hospitality/soda_dispenser
	name = "Equipment - Soda dispenser"
	contains = list(/obj/machinery/chemical_dispenser/bar_soft{anchored = 0})
	cost = 25
	containertype = /obj/structure/largecrate
	containername = "soda dispenser crate"

//amenities
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
	containername = "imported cigarettes"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/hospitality/cigars
	name = "Amenities - Imported cigars"
	contains = list(/obj/item/weapon/storage/fancy/cigar,
					/obj/item/weapon/flame/lighter/zippo)
	cost = 100
	containername = "imported cigars"