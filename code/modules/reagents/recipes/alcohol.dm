/datum/chemical_reaction/whiskey
	name = "Whiskey"
	result = /datum/reagent/ethanol/whiskey
	required_reagents = list(/datum/reagent/nutriment/flour = 5, /datum/reagent/water = 5, /datum/reagent/enzyme = 5)
	catalysts = list(/datum/reagent/woodpulp = 5)
	minimum_temperature = T0C + 100
	maximum_temperature = T0C + 150
	result_amount = 15
	mix_message = "The solution roils as it rapidly ferments into a red-brown liquid."