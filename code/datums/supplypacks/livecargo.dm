/decl/hierarchy/supply_pack/livecargo
	name = "Living cargo"
	containertype = /obj/structure/closet/crate/hydroponics

//monkeys
/decl/hierarchy/supply_pack/livecargo/monkey
	name = "Inert - Monkey cubes"
	contains = list (/obj/item/weapon/storage/box/monkeycubes)
	cost = 20
	containertype = /obj/structure/closet/crate/freezer
	containername = "monkey crate"

/decl/hierarchy/supply_pack/livecargo/farwa
	name = "Inert - Farwa cubes"
	contains = list (/obj/item/weapon/storage/box/monkeycubes/farwacubes)
	cost = 30
	containertype = /obj/structure/closet/crate/freezer
	containername = "farwa crate"

/decl/hierarchy/supply_pack/livecargo/neaera
	name = "Inert - Neaera cubes"
	contains = list (/obj/item/weapon/storage/box/monkeycubes/neaeracubes)
	cost = 30
	containertype = /obj/structure/closet/crate/freezer
	containername = "neaera crate"

/decl/hierarchy/supply_pack/livecargo/stok
	name = "Inert - Stok cubes"
	contains = list (/obj/item/weapon/storage/box/monkeycubes/stokcubes)
	cost = 30
	containertype = /obj/structure/closet/crate/freezer
	containername = "stok crate"

//slimes
/decl/hierarchy/supply_pack/livecargo/greyslime
	name = "Slimes - Grey extract"
	contains = list(/obj/item/slime_extract/grey = 2)
	cost = 50
	containertype = /obj/structure/closet/crate/freezer
	containername = "slime core crate"

//pets
/decl/hierarchy/supply_pack/livecargo/corgi
	name = "Pets - Corgi"
	contains = list()
	cost = 50
	containertype = /obj/structure/largecrate/animal/corgi
	containername = "corgi carrier"

/decl/hierarchy/supply_pack/livecargo/cat
	name = "Pets - Cat"
	contains = list()
	cost = 50
	containertype = /obj/structure/largecrate/animal/cat
	containername = "cat carrier"

//livestock
/decl/hierarchy/supply_pack/livecargo/cow
	name = "Livestock - Cow"
	cost = 45
	containertype = /obj/structure/largecrate/animal/cow
	containername = "cow crate"

/decl/hierarchy/supply_pack/livecargo/goat
	name = "Livestock - Goat"
	cost = 35
	containertype = /obj/structure/largecrate/animal/goat
	containername = "goat crate"

/decl/hierarchy/supply_pack/livecargo/chicken
	name = "Livestock - Chicken"
	cost = 25
	containertype = /obj/structure/largecrate/animal/chick
	containername = "chicken crate"