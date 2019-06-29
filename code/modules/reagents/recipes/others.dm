
//C2 H6 O
/*
/datum/chemical_reaction/ethanol
	name = "pure ethanol"
	result = /datum/reagent/ethanol
	result_amount = 1
	required_reagents = list(/datum/reagent/carbon = 2, /datum/reagent/hydrogen = 6, /datum/reagent/oxygen = 1)
	minimum_temperature = T0C + 100 //Normally you'd wanna distill. But this will do
	maximum_temperature = T0C + 150
*/
//Alternate, more true to life reaction by fermentation and "distilation"
/datum/chemical_reaction/ethanol2
	name = "pure ethanol"
	result = /datum/reagent/ethanol
	result_amount = 6
	required_reagents = list(/datum/reagent/sugar = 4, /datum/reagent/water = 4, /datum/reagent/enzyme = 2)
	minimum_temperature = T0C + 100 //Normally you'd wanna distill. But this will do
	maximum_temperature = T0C + 150

//Precursor Chem recipies.
/datum/chemical_reaction/acetone_production
	name = "Acetone Production"
	result = /datum/reagent/acetone
	required_reagents = list(/datum/reagent/oxygen = 1, /datum/reagent/carbon = 3, /datum/reagent/hydrogen = 6) //(CH3)2CO
	result_amount = 1 //kinda expensive? balance later

/datum/chemical_reaction/sulphuric_acid_prod
	name = "Sulphuric Acid Production"
	result = /datum/reagent/acid
	required_reagents = list(/datum/reagent/sulfur = 1, /datum/reagent/oxygen = 4, /datum/reagent/hydrogen = 2) //H2SO4.
	result_amount = 1

/datum/chemical_reaction/hydrochloric_acid_prod
	name = "Hydrochloric Acid production"
	result = /datum/reagent/acid/hydrochloric
	required_reagents = list(/datum/reagent/toxin/chlorine = 1, /datum/reagent/hydrogen = 1, /datum/reagent/water = 1)// 1:1 hydrogen chloride to water makes HCl acid.
	result_amount = 1

/datum/chemical_reaction/ice
	name = "water ice"
	result = /datum/reagent/drink/ice
	result_amount = 1
	required_reagents = list(/datum/reagent/water = 1)
	minimum_temperature = T0C
	maximum_temperature = T0C - 150
