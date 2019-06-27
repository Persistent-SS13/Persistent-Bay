/*
	Enzyme
*/
/datum/chemical_reaction/enzyme
	name = "Universal enzyme"
	result = /datum/reagent/enzyme
	required_reagents = list(/datum/reagent/water = 2, /datum/reagent/nutriment = 2, /datum/reagent/nutriment/flour = 2)
	minimum_temperature = T0C + 20
	maximum_temperature = T0C + 60
	mix_message = "The mix oozes together and starts bubbling. It smells like yeast.."

//Alternate recipe to grow more of it
/datum/chemical_reaction/enzyme2
	name = "Universal enzyme"
	result = /datum/reagent/enzyme
	required_reagents = list(/datum/reagent/water = 2, /datum/reagent/nutriment/flour = 2, /datum/reagent/enzyme = 1)
	result_amount = 2 //make it more efficient
	minimum_temperature = T0C + 20
	maximum_temperature = T0C + 60
	mix_message = "The mix oozes together and starts bubbling. It smells like yeast.."
