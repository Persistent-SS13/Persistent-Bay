/datum/preferences
	 var/list/skills	= list()	//List of "/decl/hierarchy/skill" , with values saved skill points spent. Should only include entries with nonzero spending.
	 var/skillpoints = 0			//Amount of unused skillpoints left to spend

/datum/preferences/proc/get_max_skill(decl/hierarchy/skill/S)
	var/min = get_min_skill(S)
	if(!.)
		. = S.default_max
	if(!.)
		. = SKILL_MAX
	. = max(min, .)

/datum/preferences/proc/get_min_skill(decl/hierarchy/skill/S)
	// if(!.)
	// 	var/datum/mil_branch/branch = mil_branches.get_branch(branches)
	// 	if(branch && branch.min_skill)
	// 		. = branch.min_skill[S.type]
	if(!.)
		. = SKILL_MIN

// /datum/preferences/proc/get_spent_points(decl/hierarchy/skill/S)
// 	if(!(S in skills))
// 		return 0
// 	return get_level_cost(S, get_min_skill(S) + skills[S])

/datum/preferences/proc/get_level_cost(decl/hierarchy/skill/S, level)
	var/min = get_min_skill(S)
	. = 0
	for(var/i=min+1, i <= level, i++)
		. += S.get_cost(i)

// /datum/preferences/proc/get_max_affordable(decl/hierarchy/skill/S)
// 	var/current_level = get_min_skill(S)
// 	var/allocation = skills[S]
// 	if(allocation)
// 		current_level += allocation
// 	var/max = get_max_skill(S)
// 	var/budget = skillpoints
// 	. = max
// 	for(var/i=current_level+1, i <= max, i++)
// 		if(budget - S.get_cost(i) < 0)
// 			return i-1
// 		budget -= S.get_cost(i)

// /datum/preferences/proc/check_skill_prerequisites(decl/hierarchy/skill/S)
// 	if(!S.prerequisites)
// 		return TRUE
// 	for(var/skill_type in S.prerequisites)
// 		var/decl/hierarchy/skill/prereq = decls_repository.get_decl(skill_type)
// 		var/value = get_min_skill(prereq) + LAZYACCESS(skills[S], prereq)
// 		if(value < S.prerequisites[skill_type])
// 			return FALSE
// 	return TRUE

// /datum/preferences/proc/purge_skills_missing_prerequisites()
// 	if(!skills)
// 		return
// 	for(var/decl/hierarchy/skill/S in skills)
// 		if(!check_skill_prerequisites(S))
// 			clear_skill(S)
// 			.() // restart checking from the beginning, as after doing this we don't know whether what we've already checked is still fine.
// 			return

/datum/preferences/proc/clear_skill(decl/hierarchy/skill/S)
	var/min = get_min_skill(S)
	var/freed_points = get_level_cost(S, min + skills[S])
	skillpoints += freed_points
	skills -= S		//And we no longer need this entry
