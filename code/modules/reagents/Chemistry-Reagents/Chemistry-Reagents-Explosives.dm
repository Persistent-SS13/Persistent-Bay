//--------------------------------
//	Nitroglycerin
//--------------------------------
/datum/reagent/nitroglycerin
	name = "Nitroglycerin"
	description = "Nitroglycerin is a heavy, colorless, oily, explosive liquid obtained by nitrating glycerol."
	taste_description = "oil"
	reagent_state = LIQUID
	color = "#808080"

/datum/reagent/nitroglycerin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.add_chemical_effect(CE_PULSE, 2)

//--------------------------------
//	Black Powder
//--------------------------------
/datum/reagent/black_powder
	name = "Black powder"
	description = "An ancient low explosive. Generates lots of smoke on deflagration."
	taste_description = "burnt wood"
	reagent_state = SOLID
	color = "#2b2b2a"

//--------------------------------
//	Pyroxylin
//--------------------------------
/datum/reagent/pyroxylin //15 parts (2 Part sulfuric acid + 1 Part Nitric acid)  + 1 part cellulose
	name = "Pyroxylin"
	description = "Also known as nitrocellulose or gun cotton. A highly flammable compound formed by nitrating cellulose through exposure to nitric acid."
	taste_description = "acid"
	reagent_state = SOLID
	color = "#808080"

//--------------------------------
//	Gunpowders
//--------------------------------
/datum/reagent/gunpowder
	name = "Single base gunpowder"
	description = "A gunpowder made of a single explosive compound, a dried and powdered solution of pyroxylin in ether and alcohol called collodion."
	taste_description = "carbonated carbon"
	reagent_state = SOLID
	color = "#4f5139"

/datum/reagent/gunpowder/double
	name = "Double base gunpowder"
	description = "A gunpowder made of two explosive compound, collodion and nitroglycerin."
	taste_description = "fizzy oil"
	reagent_state = SOLID
	color = "#43565b"

/datum/reagent/gunpowder/triple
	name = "Triple base gunpowder"
	description = "A gunpowder made of three explosive compound, collodion, nitroglycerin, and nitroguanidine."
	taste_description = "fizzy oil"
	reagent_state = SOLID
	color = "#30333c"