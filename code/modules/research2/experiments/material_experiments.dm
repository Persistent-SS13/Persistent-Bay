/datum/researchExperiment/material/leadacid
	title = "Combine Lead and Sulfuric Acid"
	difficulty = DIFFICULTY_EASY
	content = {"
				Combining Lead and Sulfuric Acid should yield some
				interesting results when it comes to researching material
				interactions. It also might provide some insight into
				power storage.
			  "}

	complete = {"
				You complete the reaction and observe some interesting
				results.
			   "}


	requirements = list(/datum/reagent/toxin/lead = 10, /datum/reagent/acid = 10)
	research = list(TECH_MATERIALS = 7, TECH_POWER = 3)

/datum/researchExperiment/material/leadlithium
	title = "Combine Lead and Lithium"
	difficulty = DIFFICULTY_MEDIUM
	content = {"
				Combining Lead and Lithium should yield some interesting
				results when it comes to researching material
				interactions. It also might provide some insight into
				power storage.
			  "}

	complete = {"
				You complete the reaction and observe some interesting
				results.
			   "}


	requirements = list(/datum/reagent/toxin/lead = 10, /datum/reagent/lithium = 10)
	research = list(TECH_MATERIALS = 10, TECH_POWER = 5)

/datum/researchExperiment/material/leaduranium
	title = "Combine Lead and Uranium"
	difficulty = DIFFICULTY_HARD
	content = {"
				Combining Lead and Uranium should yield some
				interesting results when it comes to researching material
				interactions. It also might provide some insight into
				nuclear contaiment.
			  "}

	complete = {"
				You complete the reaction and observe some interesting
				results.
			   "}


	requirements = list(/datum/reagent/toxin/lead = 10, /datum/reagent/uranium = 10)
	research = list(TECH_MATERIALS = 13, TECH_NUCLEAR = 7)
