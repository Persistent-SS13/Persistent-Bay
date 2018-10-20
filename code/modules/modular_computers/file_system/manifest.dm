// Generates a simple HTML crew manifest for use in various places
/proc/html_crew_manifest_faction(var/monochrome, var/OOC, var/datum/world_faction/connected_faction, var/setting = 1) // setting 1 = online members, setting 2 = all members
	if(!connected_faction) return
	var/list/dept_data[0]
	for(var/datum/assignment_category/category in connected_faction.assignment_categories)
		dept_data += "0"
		dept_data[dept_data.len] = list("names" = list(), "header" = category.name, "flag" = category.name)
	dept_data += "0"
	dept_data[dept_data.len] = list("names" = list(), "header" = "Miscellaneous", "flag" = MSC)
	dept_data += "0"
	dept_data[dept_data.len] = list("names" = list(), "header" = "Off duty", "flag" = "Off duty")
	var/list/misc //Special departments for easier access
	for(var/list/department in dept_data)
		if(department["flag"] == MSC)
			misc = department["names"]

	var/list/isactive = new()
	var/list/mil_ranks = list() // HTML to prepend to name
	var/dat = {"
	<head><style>
		.manifest {border-collapse:collapse;}
		.manifest td, th {border:1px solid [monochrome?"black":"[OOC?"black; background-color:#272727; color:white":"#DEF; background-color:white; color:black"]"]; padding:.25em}
		.manifest th {height: 2em; [monochrome?"border-top-width: 3px":"background-color: [OOC?"#40628a":"#48c"]; color:white"]}
		.manifest tr.head th { [monochrome?"border-top-width: 1px":"background-color: [OOC?"#013D3B;":"#488;"]"] }
		.manifest td:first-child {text-align:right}
		.manifest tr.alt td {[monochrome?"border-top-width: 2px":"background-color: [OOC?"#373737; color:white":"#DEF"]"]}
	</style></head>
	<table class="manifest" width='350px'>
	<tr class='head'><th>Name</th><th>Position</th><th>Activity</th></tr>
	"}
	// sort mobs
	var/list/records = list()
	var/list/offduty = list()
	if(setting == 1)
		for(var/obj/item/organ/internal/stack/stack in connected_faction.connected_laces)
			var/datum/computer_file/crew_record/record = connected_faction.get_record(stack.get_owner_name())
			if(!record)
				continue
			if(stack.duty_status)
				records |= record
			else
				offduty |= record
	else
		for(var/datum/computer_file/crew_record/R in connected_faction.records.faction_records)
			records |= R
	
	for(var/datum/computer_file/crew_record/CR in records)
		var/name = CR.get_name()
		var/datum/assignment/assignment = connected_faction.get_assignment(CR.assignment_uid)
		var/rank
		if(CR.custom_title)
			rank = CR.custom_title
		if(assignment)
			if(!rank)
				var/x = text2num(CR.assignment_data[assignment.uid])
				if(x && x > 1)
					rank = assignment.ranks[x-1]
				else
					rank = assignment.name
			var/found_place = 0
			var/datum/assignment_category/category = assignment.parent
			if(category)
				for(var/list/department in dept_data)
					var/list/names = department["names"]
					if(category.name == department["flag"])
						names[name] = rank
						found_place = 1
			if(!found_place)
				var/list/names = misc["names"]
				names[name] = rank
		else
			if(!rank) rank = "Unset"
			var/list/names = misc["names"]
			names[name] = rank
		mil_ranks[name] = ""

		if(GLOB.using_map.flags & MAP_HAS_RANK)
			var/datum/mil_branch/branch_obj = mil_branches.get_branch(CR.get_branch())
			var/datum/mil_rank/rank_obj = mil_branches.get_rank(CR.get_branch(), CR.get_rank())

			if(branch_obj && rank_obj)
				mil_ranks[name] = "<abbr title=\"[rank_obj.name], [branch_obj.name]\">[rank_obj.name_short]</abbr> "

		var/active = 0
		for(var/mob/M in GLOB.player_list)
			if(M.real_name == name && M.client && M.client.inactivity <= 10 * 60 * 10)
				active = 1
				break
		isactive[name] = active ? "Active" : "Inactive"
	for(var/datum/computer_file/crew_record/CR in offduty)
		var/name = CR.get_name()
		var/datum/assignment/assignment = connected_faction.get_assignment(CR.assignment_uid)
		var/rank
		if(CR.custom_title)
			rank = CR.custom_title
		if(assignment)
			if(!rank)
				var/x = text2num(CR.assignment_data[assignment.uid])
				if(x && x > 1)
					rank = assignment.ranks[x-1]
				else
					rank = assignment.name
		if(!rank) rank = "Unset"
		for(var/list/department in dept_data)
			var/list/names = department["names"]
			if(department["flag"] == "Off duty")
				names[name] = rank
		mil_ranks[name] = ""

		if(GLOB.using_map.flags & MAP_HAS_RANK)
			var/datum/mil_branch/branch_obj = mil_branches.get_branch(CR.get_branch())
			var/datum/mil_rank/rank_obj = mil_branches.get_rank(CR.get_branch(), CR.get_rank())

			if(branch_obj && rank_obj)
				mil_ranks[name] = "<abbr title=\"[rank_obj.name], [branch_obj.name]\">[rank_obj.name_short]</abbr> "

		var/active = 0
		for(var/mob/M in GLOB.player_list)
			if(M.real_name == name && M.client && M.client.inactivity <= 10 * 60 * 10)
				active = 1
				break
		isactive[name] = active ? "Active" : "Inactive"
	for(var/list/department in dept_data)
		var/list/names = department["names"]
		if(names.len > 0)
			dat += "<tr><th colspan=3>[department["header"]]</th></tr>"
			for(var/name in names)
				if(isactive[name] != "Inactive")
					dat += "<tr class='candystripe'><td>[mil_ranks[name]][name]</td><td>[names[name]]</td><td>[isactive[name]]</td></tr>"

	dat += "</table>"
	dat = replacetext(dat, "\n", "") // so it can be placed on paper correctly
	dat = replacetext(dat, "\t", "")
	return dat


/proc/html_crew_manifest(var/monochrome, var/OOC)
	var/list/dept_data = list(
		list("names" = list(), "header" = "Heads of Staff", "flag" = COM),
		list("names" = list(), "header" = "Command Support", "flag" = SPT),
		list("names" = list(), "header" = "Research", "flag" = SCI),
		list("names" = list(), "header" = "Security", "flag" = SEC),
		list("names" = list(), "header" = "Medical", "flag" = MED),
		list("names" = list(), "header" = "Engineering", "flag" = ENG),
		list("names" = list(), "header" = "Supply", "flag" = SUP),
		list("names" = list(), "header" = "Exploration", "flag" = EXP),
		list("names" = list(), "header" = "Service", "flag" = SRV),
		list("names" = list(), "header" = "Civilian", "flag" = CIV),
		list("names" = list(), "header" = "Miscellaneous", "flag" = MSC),
		list("names" = list(), "header" = "Silicon")
	)
	var/list/misc //Special departments for easier access
	var/list/bot
	for(var/list/department in dept_data)
		if(department["flag"] == MSC)
			misc = department["names"]
		if(isnull(department["flag"]))
			bot = department["names"]

	var/list/isactive = new()
	var/list/mil_ranks = list() // HTML to prepend to name
	var/dat = {"
	<head><style>
		.manifest {border-collapse:collapse;}
		.manifest td, th {border:1px solid [monochrome?"black":"[OOC?"black; background-color:#272727; color:white":"#DEF; background-color:white; color:black"]"]; padding:.25em}
		.manifest th {height: 2em; [monochrome?"border-top-width: 3px":"background-color: [OOC?"#40628a":"#48c"]; color:white"]}
		.manifest tr.head th { [monochrome?"border-top-width: 1px":"background-color: [OOC?"#013D3B;":"#488;"]"] }
		.manifest td:first-child {text-align:right}
		.manifest tr.alt td {[monochrome?"border-top-width: 2px":"background-color: [OOC?"#373737; color:white":"#DEF"]"]}
	</style></head>
	<table class="manifest" width='350px'>
	<tr class='head'><th>Name</th><th>Position</th><th>Activity</th></tr>
	"}
	// sort mobs
	for(var/datum/computer_file/crew_record/CR in GLOB.all_crew_records)
		var/name = CR.get_name()
		var/rank = CR.get_job()
		mil_ranks[name] = ""

		if(GLOB.using_map.flags & MAP_HAS_RANK)
			var/datum/mil_branch/branch_obj = mil_branches.get_branch(CR.get_branch())
			var/datum/mil_rank/rank_obj = mil_branches.get_rank(CR.get_branch(), CR.get_rank())

			if(branch_obj && rank_obj)
				mil_ranks[name] = "<abbr title=\"[rank_obj.name], [branch_obj.name]\">[rank_obj.name_short]</abbr> "

		var/active = 0
		for(var/mob/M in GLOB.player_list)
			if(M.real_name == name && M.client && M.client.inactivity <= 10 * 60 * 10)
				active = 1
				break

		if(!active)
			isactive[name] = "Inactive"
		else
			isactive[name] = OOC ? "Active" : CR.get_status()

		var/datum/job/job = job_master.occupations_by_title[rank]
		var/found_place = 0
		if(job)
			for(var/list/department in dept_data)
				var/list/names = department["names"]
				if(job.department_flag & department["flag"])
					names[name] = rank
					found_place = 1
		if(!found_place)
			misc[name] = rank

	// Synthetics don't have actual records, so we will pull them from here.
	for(var/mob/living/silicon/ai/ai in SSmobs.mob_list)
		bot[ai.name] = "Artificial Intelligence"

	for(var/mob/living/silicon/robot/robot in SSmobs.mob_list)
		// No combat/syndicate cyborgs, no drones.
		if(robot.module && robot.module.hide_on_manifest)
			continue

		bot[robot.name] = "[robot.modtype] [robot.braintype]"

	for(var/list/department in dept_data)
		var/list/names = department["names"]
		if(names.len > 0)
			dat += "<tr><th colspan=3>[department["header"]]</th></tr>"
			for(var/name in names)
				if(isactive[name] != "Inactive")
					dat += "<tr class='candystripe'><td>[mil_ranks[name]][name]</td><td>[names[name]]</td><td>[isactive[name]]</td></tr>"

	dat += "</table>"
	dat = replacetext(dat, "\n", "") // so it can be placed on paper correctly
	dat = replacetext(dat, "\t", "")
	return dat

/proc/silicon_nano_crew_manifest(var/list/filter)
	var/list/filtered_entries = list()

	for(var/mob/living/silicon/ai/ai in SSmobs.mob_list)
		filtered_entries.Add(list(list(
			"name" = ai.name,
			"rank" = "Artificial Intelligence",
			"status" = ""
		)))
	for(var/mob/living/silicon/robot/robot in SSmobs.mob_list)
		if(robot.module && robot.module.hide_on_manifest)
			continue
		filtered_entries.Add(list(list(
			"name" = robot.name,
			"rank" = "[robot.modtype] [robot.braintype]",
			"status" = ""
		)))
	return filtered_entries

/proc/filtered_nano_crew_manifest(var/list/filter, var/blacklist = FALSE)
	var/list/filtered_entries = list()
	for(var/datum/computer_file/crew_record/CR in department_crew_manifest(filter, blacklist))
		filtered_entries.Add(list(list(
			"name" = CR.get_name(),
			"rank" = CR.get_job(),
			"status" = CR.get_status(),
			"branch" = CR.get_branch(),
			"milrank" = CR.get_rank()
		)))
	return filtered_entries

/proc/nano_crew_manifest()
	return list(\
		"heads" = filtered_nano_crew_manifest(GLOB.command_positions),\
		"spt" = filtered_nano_crew_manifest(GLOB.support_positions),\
		"sci" = filtered_nano_crew_manifest(GLOB.science_positions),\
		"sec" = filtered_nano_crew_manifest(GLOB.security_positions),\
		"eng" = filtered_nano_crew_manifest(GLOB.engineering_positions),\
		"med" = filtered_nano_crew_manifest(GLOB.medical_positions),\
		"sup" = filtered_nano_crew_manifest(GLOB.supply_positions),\
		"exp" = filtered_nano_crew_manifest(GLOB.exploration_positions),\
		"srv" = filtered_nano_crew_manifest(GLOB.service_positions),\
		"bot" = silicon_nano_crew_manifest(GLOB.nonhuman_positions),\
		"civ" = filtered_nano_crew_manifest(GLOB.civilian_positions),\
		"misc" = filtered_nano_crew_manifest(GLOB.unsorted_positions)\
		)
