
//C2 H6 O
/datum/chemical_reaction/ethanol
	name = "pure ethanol"
	result = /datum/reagent/ethanol
	required_reagents = list(/datum/reagent/carbon = 2, /datum/reagent/hydrogen = 6, /datum/reagent/oxygen = 1)
	minimum_temperature = T0C + 100 //Normally you'd wanna distill. But this will do
	maximum_temperature = T0C + 150

//Alternate, more true to life reaction by fermentation and "distilation"
/datum/chemical_reaction/ethanol2
	name = "pure ethanol"
	result = /datum/reagent/ethanol
	required_reagents = list(/datum/reagent/sugar = 4, /datum/reagent/water = 4, /datum/reagent/enzyme = 2)
	minimum_temperature = T0C + 100 //Normally you'd wanna distill. But this will do
	maximum_temperature = T0C + 150
