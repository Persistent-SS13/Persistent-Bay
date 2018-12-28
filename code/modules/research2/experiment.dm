GLOBAL_LIST_EMPTY(experiments)

/proc/PopulateExperiments()
	for(var/field in RESEARCH_FIELDS)
		for(var/path in subtypesof(text2path("/datum/researchExperiment/[field]")))
			var/datum/researchExperiment/E = new path()
			LAZYINITLIST(GLOB.experiments[field])
			LAZYADD(GLOB.experiments[field][E.difficulty], E)

/proc/GetExperiments(var/field, var/list/prior)
	return list(pick(GLOB.experiments[field][DIFFICULTY_EASY] - prior), pick(GLOB.experiments[field][DIFFICULTY_MEDIUM] - prior), pick(GLOB.experiments[field][DIFFICULTY_HARD] - prior))

/datum/researchExperiment
	var/title = "A research experiment"
	var/difficulty = "UNSET"
	var/content = "Details reguarding the experiment"
	var/complete = "The results of an experiment"

	var/list/requirements = list()
	var/list/research = list()
