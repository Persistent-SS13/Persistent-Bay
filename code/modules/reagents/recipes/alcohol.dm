/*
	Base Alcohols
*/
/datum/chemical_reaction/whiskey
	name = "Whiskey"
	result = /datum/reagent/ethanol/whiskey
	required_reagents = list(/datum/reagent/nutriment/flour = 5, /datum/reagent/nutriment/cornoil = 5, /datum/reagent/enzyme = 5)
	catalysts = list(/datum/reagent/woodpulp = 5)
	minimum_temperature = T0C + 80
	maximum_temperature = T0C + 90
	result_amount = 15
	mix_message = "The solution roils as it rapidly ferments. Then you distil it into a red-brown liquid."

/datum/chemical_reaction/specialwhiskey
	name = "Special blend whiskey"
	result = /datum/reagent/ethanol/specialwhiskey
	required_reagents = list(/datum/chemical_reaction/whiskey = 20, /datum/reagent/enzyme = 20, /datum/reagent/hydrazine = 5)
	catalysts = list(/datum/reagent/woodpulp = 10)
	minimum_temperature = T0C + 60
	maximum_temperature = T0C + 90
	result_amount = 40
	mix_message = "The solution roils as it rapidly ferments and thickens. Then you distil it into an intensely reddish-brown liquid."

/datum/chemical_reaction/rum
	name = "Rum"
	result = /datum/reagent/ethanol/rum
	required_reagents = list(/datum/reagent/drink/juice/sugarcane_juice = 5, /datum/reagent/enzyme = 5)
	minimum_temperature = T0C + 60
	maximum_temperature = T0C + 90
	result_amount = 15
	mix_message = "The solution roils as it rapidly ferments. Then you distil it into a brown-ish liquid."

/datum/chemical_reaction/gin
	name = "Gin"
	result = /datum/reagent/ethanol/gin
	required_reagents = list(/datum/reagent/drink/juice/berry/juniper = 5, /datum/reagent/water = 5, /datum/reagent/enzyme = 5)
	maximum_temperature = T0C + 60
	result_amount = 15
	mix_message = "The solution roils as it rapidly ferments. Then you distil it into a clear juniper scented liquid."

/datum/chemical_reaction/vermouth
	name = "Vermouth"
	result = /datum/reagent/ethanol/vermouth
	required_reagents = list(/datum/reagent/ethanol/wine = 5, /datum/reagent/blackpepper = 5)
	minimum_temperature = T0C + 60
	maximum_temperature = T0C + 90
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a clear spice scented liquid."

/datum/chemical_reaction/tequila
	name = "Tequila"
	result = /datum/reagent/ethanol/tequilla
	required_reagents = list(/datum/reagent/drink/juice/agave_sap = 5, /datum/reagent/enzyme = 5)
	minimum_temperature = T0C + 80
	maximum_temperature = T0C + 90
	result_amount = 15
	mix_message = "The solution roils as it rapidly ferments. Then you distil it into a clear liquid."

/datum/chemical_reaction/nothing
	name = "nothing"
	result = /datum/reagent/drink/nothing
	required_reagents = list(/datum/reagent/ethanol = 5, /datum/reagent/hydrogen_peroxide = 5)
	minimum_temperature = T0C + 80
	maximum_temperature = T0C + 90
	result_amount = 10
	mix_message = "The solution boils off leaving behind a feeling of emptyness."

/datum/chemical_reaction/absinthe
	name = "absinthe"
	result = /datum/reagent/ethanol/absinthe
	required_reagents = list(/datum/reagent/nutriment/oil/aniseoil = 5, /datum/reagent/enzyme = 5)
	minimum_temperature = T0C + 80
	maximum_temperature = T0C + 90
	result_amount = 15
	mix_message = "The solution roils as it rapidly ferments. Then you distil it into a strongly scented green liquid."

/datum/chemical_reaction/cognac
	name = "cognac"
	result = /datum/reagent/ethanol/cognac
	required_reagents = list(/datum/reagent/ethanol/wine/premium = 5, /datum/reagent/enzyme = 5)
	catalysts = list(/datum/reagent/copper = 5)
	minimum_temperature = T0C + 80
	maximum_temperature = T0C + 90
	result_amount = 15
	mix_message = "The solution roils as it rapidly ferments. Then you distil it into a smooth, amber liquid."

/datum/chemical_reaction/premium_wine //white wine literally
	name = "premium wine"
	result = /datum/reagent/ethanol/wine/premium
	required_reagents = list(/datum/reagent/drink/juice/grape/green = 5, /datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments."

/datum/chemical_reaction/deadrum
	name = "dead rum"
	result = /datum/reagent/ethanol/deadrum
	required_reagents = list(/datum/reagent/ethanol/grog = 5, /datum/reagent/enzyme = 5)
	catalysts = list(/datum/reagent/sodiumchloride = 5,	/datum/reagent/water = 5)
	result_amount = 5 //highly concentrated
	mix_message = "The solution roils as it rapidly ferments. A puff of saltwater scented black smoke erupts out of the mix."

/datum/chemical_reaction/hessia
	name = "Hessia"
	result = /datum/reagent/ethanol/hessia
	required_reagents = list(/datum/reagent/ethanol/pwine = 5, /datum/reagent/psilocybin = 5, /datum/reagent/enzyme = 5)
	catalysts = list(/datum/reagent/sugar = 1) //The irony!
	result_amount = 15

/datum/chemical_reaction/goodbeer
	name = "Good beer"
	result = /datum/reagent/ethanol/beer/good
	required_reagents = list(/datum/reagent/ethanol/beer = 5, /datum/reagent/ethanol/ale = 5)
	catalysts = list(/datum/reagent/enzyme = 1)
	result_amount = 3

/*
	Drink Mixes
*/
/datum/chemical_reaction/bluebird
	name = "Blue Bird"
	result = /datum/reagent/ethanol/bluebird
	required_reagents = list(/datum/reagent/ethanol/gin = 1, /datum/reagent/ethanol/bluecuracao = 1, /datum/reagent/drink/juice/lemon = 1)
	result_amount = 3
	
/datum/chemical_reaction/bj
	name = "BJ"
	result = /datum/reagent/ethanol/bj
	required_reagents = list(/datum/reagent/ethanol/coffee/kahlua = 1, /datum/reagent/drink/milk/cream = 1)
	result_amount = 2
	
/datum/chemical_reaction/starrycola
	name = "Starry Cola"
	result = /datum/reagent/ethanol/starrycola
	required_reagents = list(/datum/reagent/ethanol/moonshine = 1, /datum/reagent/drink/space_cola = 2)
	result_amount = 3
	
/datum/chemical_reaction/calvincraig
	name = "Calvin Craig"
	result = /datum/reagent/ethanol/calvincraig
	required_reagents = list(/datum/reagent/drink/dr_gibb = 1, /datum/reagent/drink/space_up = 1, /datum/reagent/sugar = 1,  /datum/reagent/drink/juice/lemon = 1, /datum/reagent/ethanol/melonliquor = 2)
	result_amount = 6
	
/datum/chemical_reaction/white_russian2
	name = "White Russian"
	result = /datum/reagent/ethanol/white_russian
	required_reagents = list(/datum/reagent/ethanol/bj = 2, /datum/reagent/ethanol/vodka = 1)
	result_amount = 3