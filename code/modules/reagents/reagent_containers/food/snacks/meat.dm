/obj/item/weapon/reagent_containers/food/snacks/meat
	name = "meat"
	desc = "A slab of meat."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "meat"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/rawcutlet
	slices_num = 3
	max_health = 180
	filling_color = "#ff1c1c"
	center_of_mass = "x=16;y=14"
	starts_with = list(/datum/reagent/nutriment/protein = 9)
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/meat/syntiflesh
	name = "synthetic meat"
	desc = "A slab of flesh synthetized from reconstituted biomass or artificially grown from chemicals."
	icon = 'icons/obj/food.dmi'

// Seperate definitions because some food likes to know if it's human.
// TODO: rewrite kitchen code to check a var on the meat item so we can remove
// all these sybtypes.
/obj/item/weapon/reagent_containers/food/snacks/meat/human
/obj/item/weapon/reagent_containers/food/snacks/meat/monkey
	//same as plain meat

/obj/item/weapon/reagent_containers/food/snacks/meat/corgi
	name = "corgi meat"
	desc = "Tastes like... well, you know."

/obj/item/weapon/reagent_containers/food/snacks/meat/beef
	name = "beef slab"
	desc = "The classic red meat."
	starts_with = list(/datum/reagent/nutriment/protein = 20)

/obj/item/weapon/reagent_containers/food/snacks/meat/goat
	name = "chevon slab"
	desc = "Goat meat, to the uncultured."

/obj/item/weapon/reagent_containers/food/snacks/meat/chicken
	name = "chicken piece"
	desc = "It tastes like you'd expect."

/obj/item/weapon/reagent_containers/food/snacks/meat/xenomeat
	name = "meat"
	desc = "A slab of green meat. Smells like acid."
	icon_state = "xenomeat"
	filling_color = "#43de18"
	center_of_mass = "x=16;y=10"
	bitesize = 6
	starts_with = list(/datum/reagent/nutriment/protein = 6, /datum/reagent/acid/polyacid = 6)

/obj/item/weapon/reagent_containers/food/snacks/meat/bearmeat
	name = "bear meat"
	desc = "A very manly slab of meat."
	icon_state = "bearmeat"
	filling_color = "#db0000"
	center_of_mass = "x=16;y=10"
	bitesize = 3
	starts_with = list(/datum/reagent/nutriment/protein = 12, /datum/reagent/hyperzine = 5) 