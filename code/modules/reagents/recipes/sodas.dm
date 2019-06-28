/*
	Soda
*/
/datum/chemical_reaction/sodawater 
	result = /datum/reagent/drink/sodawater
	result_amount = 6
	required_reagents = list(/datum/reagent/carbon_dioxide = 2, /datum/reagent/water = 4, /datum/reagent/sugar = 2)
	minimum_temperature = 40 CELSIUS //Makes dissolving the CO2 easier or something
	maximum_temperature = (40 CELSIUS) + 100
	mix_message = "The sugar and carbon dioxide dissolves into the water, and forms bubbles."

//	C20H24N2O2
/datum/chemical_reaction/quinine //Normally comes from bark of a plant, but didn't have time to make the plant... #TODO
	result = /datum/reagent/quinine
	result_amount = 2
	required_reagents = list(/datum/reagent/carbon = 10, /datum/reagent/hydrogen = 12,  /datum/reagent/nitrogen = 1, /datum/reagent/oxygen = 1)

/datum/chemical_reaction/tonic_water
	result = /datum/reagent/drink/tonic
	result_amount = 5
	required_reagents = list(/datum/reagent/drink/sodawater = 2, /datum/reagent/sugar = 2, /datum/reagent/quinine = 1 )
	mix_message = "You suddenly feel this tonic mix could cure malaria.."

/datum/chemical_reaction/space_cola
	result = /datum/reagent/drink/space_cola
	result_amount = 5
	required_reagents = list(/datum/reagent/drink/sodawater = 2, /datum/reagent/sugar = 4, /datum/reagent/glycerol = 1)
	mix_message = "The clear soda water mixes with the sugar and thick glycerol to form a slightly thicker and darker liquid."

/datum/chemical_reaction/spacemountainwind
	result = /datum/reagent/drink/spacemountainwind
	result_amount = 5
	required_reagents = list(/datum/reagent/drink/space_cola = 2, /datum/reagent/drink/juice/orange = 1, /datum/reagent/drink/juice/lime = 1, /datum/reagent/drink/juice/lemon = 1 )
	mix_message = "A sudden citrus flavored wind rushes from the mix."

/datum/chemical_reaction/lemon_lime
	result = /datum/reagent/drink/lemon_lime
	result_amount = 6
	required_reagents = list(/datum/reagent/drink/space_cola = 2,  /datum/reagent/drink/juice/lime = 2, /datum/reagent/drink/juice/lemon = 2)
	catalysts = list(/datum/reagent/drink/juice/orange = 1) //You wanted orange but it gave you lemon-lime C:
	mix_message = "The lime juice and lemon juice readily mix with the space cola while the orange juice forms a deposit. You feel disapointment."

/datum/chemical_reaction/space_up
	result = /datum/reagent/drink/space_up
	result_amount = 3
	required_reagents = list(/datum/reagent/drink/space_cola = 2, /datum/reagent/frostoil = 1) //helps keep your cool
	catalysts = list(/datum/reagent/fuel = 1) //Tastes like a hull breach apparently so *shrug*
	mix_message = "The frostoil and space cola mix together to form a thick liquid, as the fuel settles.. You thought you heard the air breach alarm just now.."

/datum/chemical_reaction/dr_gibb
	result = /datum/reagent/drink/dr_gibb
	result_amount = 4
	required_reagents = list(/datum/reagent/drink/space_cola = 2, /datum/reagent/drink/juice/berry = 2) //Should be cherries, but we don't have cherry juice
	mix_message = "The space cola hesitently mixes with the berry juice.."

/datum/chemical_reaction/thirteenloko
	result = /datum/reagent/ethanol/thirteenloko
	result_amount = 12
	required_reagents = list(/datum/reagent/drink/space_cola = 4, /datum/reagent/drink/coffee = 4, /datum/reagent/ethanol/grog = 4)
	mix_message = "As the various reagents combines, a thick, dark puff of smoke erupt from the mix.."
