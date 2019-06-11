
/datum/chemical_reaction/tofu
	name = "Tofu"
	result = null
	required_reagents = list(/datum/reagent/drink/milk/soymilk = 10, /datum/reagent/enzyme = 5)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 1

/datum/chemical_reaction/tofu/on_reaction(var/datum/reagents/holder, var/created_volume)
	..()
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/tofu(location)

/datum/chemical_reaction/chocolate_bar
	name = "Chocolate Bar"
	result = null
	required_reagents = list(/datum/reagent/drink/milk/soymilk = 2, /datum/reagent/nutriment/coco = 2, /datum/reagent/sugar = 2)
	result_amount = 1

/datum/chemical_reaction/chocolate_bar/on_reaction(var/datum/reagents/holder, var/created_volume)
	..()
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/chocolatebar(location)

/datum/chemical_reaction/chocolate_bar2
	name = "Chocolate Bar"
	result = null
	required_reagents = list(/datum/reagent/drink/milk = 2, /datum/reagent/nutriment/coco = 2, /datum/reagent/sugar = 2)
	result_amount = 1

/datum/chemical_reaction/chocolate_bar2/on_reaction(var/datum/reagents/holder, var/created_volume)
	..()
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/chocolatebar(location)

/datum/chemical_reaction/chocolate_milk
	name = "Chocolate Milk"
	result = /datum/reagent/drink/milk/chocolate
	required_reagents = list(/datum/reagent/drink/milk = 5, /datum/reagent/nutriment/coco = 1)
	result_amount = 5
	mix_message = "The solution thickens into a creamy brown beverage."

/datum/chemical_reaction/coffee
	name = "Coffee"
	result = /datum/reagent/drink/coffee
	required_reagents = list(/datum/reagent/water = 5, /datum/reagent/nutriment/coffee = 1)
	result_amount = 5
	minimum_temperature = 70 CELSIUS
	maximum_temperature = (70 CELSIUS) + 100
	mix_message = "The solution thickens into a steaming dark brown beverage."

/datum/chemical_reaction/tea
	name = "Black tea"
	result = /datum/reagent/drink/tea
	required_reagents = list(/datum/reagent/water = 5, /datum/reagent/nutriment/tea = 1)
	result_amount = 5
	minimum_temperature = 70 CELSIUS
	maximum_temperature = (70 CELSIUS) + 100
	mix_message = "The solution thickens into a steaming black beverage."

/datum/chemical_reaction/hot_coco
	name = "Hot Coco"
	result = /datum/reagent/drink/hot_coco
	required_reagents = list(/datum/reagent/water = 5, /datum/reagent/nutriment/coco = 1)
	result_amount = 5
	minimum_temperature = 70 CELSIUS
	maximum_temperature = (70 CELSIUS) + 100
	mix_message = "The solution thickens into a steaming brown beverage."

/datum/chemical_reaction/grapejuice
	name = "Grape Juice"
	result = /datum/reagent/drink/juice/grape
	required_reagents = list(/datum/reagent/water = 3, /datum/reagent/nutriment/instantjuice/grape = 1)
	result_amount = 3
	mix_message = "The solution settles into a purplish-red beverage."

/datum/chemical_reaction/orangejuice
	name = "Orange Juice"
	result = /datum/reagent/drink/juice/orange
	required_reagents = list(/datum/reagent/water = 3, /datum/reagent/nutriment/instantjuice/orange = 1)
	result_amount = 3
	mix_message = "The solution settles into an orange beverage."

/datum/chemical_reaction/watermelonjuice
	name = "Watermelon Juice"
	result = /datum/reagent/drink/juice/watermelon
	required_reagents = list(/datum/reagent/water = 3, /datum/reagent/nutriment/instantjuice/watermelon = 1)
	result_amount = 3
	mix_message = "The solution settles into a red beverage."

/datum/chemical_reaction/applejuice
	name = "Apple Juice"
	result = /datum/reagent/drink/juice/apple
	required_reagents = list(/datum/reagent/water = 3, /datum/reagent/nutriment/instantjuice/apple = 1)
	result_amount = 3
	mix_message = "The solution settles into a clear brown beverage."

/datum/chemical_reaction/cheesewheel
	name = "Cheesewheel"
	result = null
	required_reagents = list(/datum/reagent/drink/milk = 40, /datum/reagent/enzyme = 5)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 1
	mix_message = "The solution thickens and curdles into a rich yellow substance."
	minimum_temperature = 40 CELSIUS
	maximum_temperature = (40 CELSIUS) + 100

/datum/chemical_reaction/cheesewheel/on_reaction(var/datum/reagents/holder, var/created_volume)
	..()
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesewheel(location)

/datum/chemical_reaction/rawmeatball
	name = "Raw Meatball"
	result = null
	required_reagents = list(/datum/reagent/nutriment/protein = 3, /datum/reagent/nutriment/flour = 5)
	result_amount = 3
	mix_message = "The flour thickens the processed meat until it clumps."

/datum/chemical_reaction/rawmeatball/on_reaction(var/datum/reagents/holder, var/created_volume)
	..()
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/rawmeatball(location)

/datum/chemical_reaction/dough
	name = "Dough"
	result = null
	required_reagents = list(/datum/reagent/nutriment/protein/egg = 3, /datum/reagent/nutriment/flour = 10, /datum/reagent/water = 10)
	result_amount = 1
	mix_message = "The solution folds and thickens into a large ball of dough."

/datum/chemical_reaction/dough/on_reaction(var/datum/reagents/holder, var/created_volume)
	..()
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/dough(location)

/datum/chemical_reaction/soydough
	name = "Soy dough"
	result = null
	required_reagents = list(/datum/reagent/nutriment/softtofu = 3, /datum/reagent/nutriment/flour = 10, /datum/reagent/water = 10)
	result_amount = 1
	mix_message = "The solution folds and thickens into a large ball of dough."

/datum/chemical_reaction/soydough/on_reaction(var/datum/reagents/holder, var/created_volume)
	..()
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/dough(location)

//batter reaction as food precursor, for things that don't use pliable dough precursor.

/datum/chemical_reaction/batter
	name = "Batter"
	result = /datum/reagent/nutriment/batter
	required_reagents = list(/datum/reagent/nutriment/protein/egg = 3, /datum/reagent/nutriment/flour = 5, /datum/reagent/drink/milk = 5)
	result_amount = 10
	mix_message = "The solution thickens into a glossy batter."

/datum/chemical_reaction/cakebatter
	name = "Cake Batter"
	result = /datum/reagent/nutriment/batter/cakebatter
	required_reagents = list(/datum/reagent/sugar = 1, /datum/reagent/nutriment/batter = 2)
	result_amount = 3
	mix_message = "The sugar lightens the batter and gives it a sweet smell."

/datum/chemical_reaction/soybatter
	name = "Vegan Batter"
	result = /datum/reagent/nutriment/batter
	required_reagents = list(/datum/reagent/nutriment/softtofu = 3, /datum/reagent/nutriment/flour = 5, /datum/reagent/drink/milk = 5)
	result_amount = 10
	mix_message = "The solution thickens into a glossy batter."

/datum/chemical_reaction/syntiflesh
	name = "Syntiflesh"
	result = null
	required_reagents = list(/datum/reagent/blood = 5, /datum/reagent/clonexadone = 1)
	result_amount = 1
	mix_message = "The solution thickens disturbingly, taking on a meaty appearance."

/datum/chemical_reaction/syntiflesh/on_reaction(var/datum/reagents/holder, var/created_volume)
	..()
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/meat/syntiflesh(location)

/datum/chemical_reaction/hot_ramen
	name = "Hot Ramen"
	result = /datum/reagent/drink/hot_ramen
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/drink/dry_ramen = 3)
	result_amount = 3
	mix_message = "The noodles soften in the hot water, releasing savoury steam."
	minimum_temperature = 80 CELSIUS
	maximum_temperature = (100 CELSIUS) + 50

/datum/chemical_reaction/hell_ramen
	name = "Hell Ramen"
	result = /datum/reagent/drink/hell_ramen
	required_reagents = list(/datum/reagent/capsaicin = 1, /datum/reagent/drink/hot_ramen = 6)
	result_amount = 6
	mix_message = "The broth of the noodles takes on a hellish red gleam."

//===============================
// Condiments
//===============================


/datum/chemical_reaction/vinegar2
	name = "Clear Vinegar"
	result = /datum/reagent/nutriment/vinegar
	required_reagents = list(/datum/reagent/ethanol = 10, /datum/reagent/enzyme = 5)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/mayo
	name = "Vinegar Mayo"
	result = /datum/reagent/nutriment/mayo
	required_reagents = list(/datum/reagent/nutriment/vinegar = 5, /datum/reagent/nutriment/protein/egg = 5)
	result_amount = 10

/datum/chemical_reaction/mayo2
	name = "Lemon Mayo"
	result = /datum/reagent/nutriment/mayo
	required_reagents = list(/datum/reagent/drink/juice/lemon = 5, /datum/reagent/nutriment/protein/egg = 5)
	result_amount = 10

/datum/chemical_reaction/sodiumchloride
	name = "Sodium Chloride"
	result = /datum/reagent/sodiumchloride
	required_reagents = list(/datum/reagent/sodium = 1, /datum/reagent/acid/hydrochloric = 1)
	result_amount = 2

/datum/chemical_reaction/condensedcapsaicin
	name = "Condensed Capsaicin"
	result = /datum/reagent/capsaicin/condensed
	required_reagents = list(/datum/reagent/capsaicin = 2)
	catalysts = list(/datum/reagent/toxin/phoron = 5)
	result_amount = 1

/datum/chemical_reaction/soysauce
	name = "Soy Sauce"
	result = /datum/reagent/nutriment/soysauce
	required_reagents = list(/datum/reagent/drink/milk/soymilk = 5, /datum/reagent/nutriment/vinegar = 5)
	result_amount = 10
	mix_message = "The solution settles into a glossy black sauce."

/datum/chemical_reaction/soysauce_acid
	name = "Bitey Soy Sauce"
	result = /datum/reagent/nutriment/soysauce
	required_reagents = list(/datum/reagent/drink/milk/soymilk = 4, /datum/reagent/acid = 1)
	result_amount = 5
	mix_message = "The solution settles into a glossy black sauce."

/datum/chemical_reaction/ketchup
	name = "Ketchup"
	result = /datum/reagent/nutriment/ketchup
	required_reagents = list(/datum/reagent/drink/juice/tomato = 2, /datum/reagent/water = 1, /datum/reagent/sugar = 1)
	result_amount = 4
	mix_message = "The solution thickens into a sweet-smelling red sauce."

/datum/chemical_reaction/barbecue
	name = "Barbecue Sauce"
	result = /datum/reagent/nutriment/barbecue
	required_reagents = list(/datum/reagent/nutriment/ketchup = 2, /datum/reagent/blackpepper = 1, /datum/reagent/sodiumchloride = 1)
	result_amount = 4
	mix_message = "The solution thickens into a sweet-smelling brown sauce."

/datum/chemical_reaction/garlicsauce
	name = "Garlic Sauce"
	result = /datum/reagent/nutriment/garlicsauce
	required_reagents = list(/datum/reagent/drink/juice/garlic = 1, /datum/reagent/nutriment/cornoil = 1)
	result_amount = 2
	mix_message = "The solution thickens into a creamy white oil."