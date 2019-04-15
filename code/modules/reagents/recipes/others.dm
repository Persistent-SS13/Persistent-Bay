// /datum/chemical_reaction/silicate
// 	name = "Silicate"
// 	result = /datum/reagent/silicate
// 	required_reagents = list(/datum/reagent/aluminum = 1, /datum/reagent/silicon = 1, /datum/reagent/acetone = 1)
// 	result_amount = 3

/datum/chemical_reaction/mutagen
	name = "Unstable mutagen"
	result = /datum/reagent/mutagen
	required_reagents = list(/datum/reagent/radium = 1, /datum/reagent/phosphorus = 1, /datum/reagent/acid/hydrochloric = 1)
	result_amount = 3

/datum/chemical_reaction/glycerol
	name = "Glycerol"
	result = /datum/reagent/glycerol
	required_reagents = list(/datum/reagent/nutriment/cornoil = 3, /datum/reagent/acid = 1)
	result_amount = 1

/datum/chemical_reaction/oxyphoron
	name = "Oxyphoron"
	result = /datum/reagent/toxin/phoron/oxygen
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/toxin/phoron = 1)
	result_amount = 2