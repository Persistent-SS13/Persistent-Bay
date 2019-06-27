var/const/DEFAULT_AMOUNT_SKILL_POINTS = 10

/datum/category_item/player_setup_item/skills
	name = "Skills"
	sort_order = 1
	var/datum/browser/panel

/datum/category_item/player_setup_item/skills/load_character(var/savefile/S)
	// from_file(S["skills"], pref.skills)
	// from_file(S["skillpoints"],pref.skillpoints)
	// load_skills()

/datum/category_item/player_setup_item/skills/save_character(var/savefile/S)
	// save_skills()
	// to_file(S["skills"], pref.skills)
	// to_file(S["skillpoints"],pref.skillpoints)

//These procs convert to/from static save-data formats.
// /datum/category_item/player_setup_item/skills/proc/load_skills()
// 	if(!length(GLOB.skills))
// 		decls_repository.get_decl(/decl/hierarchy/skill)

// /datum/category_item/player_setup_item/skills/proc/save_skills()
// 	return

//Sets up skills
// /datum/preferences/proc/sanitize_skills(var/list/input)
// 	. = list()
// 	var/datum/species/S = all_species[species]
// 	var/L = list()
// 	var/sum = 0

// 	for(var/decl/hierarchy/skill/skill in GLOB.skills)
// 		if(skill in input)
// 			var/min = get_min_skill(skill)
// 			var/max = get_max_skill(skill)
// 			var/level = sanitize_integer(input[skill], 0, max - min, 0)
// 			var/spent = get_level_cost(skill, min + level)
// 			if(spent)						//Only include entries with nonzero spent points
// 				L[skill] = level
// 				sum += spent

// 	skillpoints = DEFAULT_AMOUNT_SKILL_POINTS							//We compute how many points we had.
// 	// if(!job.no_skill_buffs)
// 	skillpoints += S.skills_from_age(age)				//Applies the species-appropriate age modifier.
// 	// 	points_by_job[job] += S.job_skill_buffs[job.type]			//Applies the per-job species modifier, if any.

// 	if((skillpoints >= sum) && sum)				//we didn't overspend, so use sanitized imported data
// 		. = L
// 		skillpoints -= sum						//if we overspent, or did no spending, default to not including the job at all
// 	purge_skills_missing_prerequisites()

// /datum/category_item/player_setup_item/skills/sanitize_character()
// 	if(!istype(pref.skills))
// 		pref.skills = list()
// 	if(pref.skillpoints < 0)
// 		pref.skillpoints = 0

// /datum/category_item/player_setup_item/skills/OnTopic(href, href_list, user)
// 	// if(href_list["set_skills"])
// 	// 	open_skill_setup(user)
// 	// 	return TOPIC_HANDLED
// 	else if(href_list["hit_skill_button"])
// 		var/decl/hierarchy/skill/S = locate(href_list["hit_skill_button"])
// 		if(!istype(S))
// 			return
// 		var/value = text2num(href_list["newvalue"])
// 		update_skill_value(S, value)
// 		pref.ShowChoices(user) //Manual refresh to allow us to focus the panel, not the main window.
// 		panel.set_content(generate_skill_content())
// 		panel.open()
// 		winset(user, panel.window_id, "focus=1") //Focuses the panel.
// 		return TOPIC_HANDLED
// 	else if(href_list["skillinfo"])
// 		var/decl/hierarchy/skill/S = locate(href_list["skillinfo"])
// 		if(!istype(S))
// 			return
// 		var/HTML = list()
// 		HTML += "<h2>[S.name]</h2>"
// 		HTML += "[S.desc]<br>"
// 		var/i
// 		for(i=1, i <= length(S.levels), i++)
// 			var/level_name = S.levels[i]
// 			HTML +=	"<br><b>[level_name]</b>: [S.levels[level_name]]<br>"
// 		show_browser(user, jointext(HTML, null), "window=\ref[user]skillinfo")
// 		return TOPIC_HANDLED
// 	return ..()

// /datum/category_item/player_setup_item/skills/proc/update_skill_value(decl/hierarchy/skill/S, new_level)
// 	if(!isnum(new_level) || (round(new_level) != new_level))
// 		return											//Checks to make sure we were fed an integer.
// 	if(!pref.check_skill_prerequisites(S))
// 		return
// 	var/min = pref.get_min_skill(S)

// 	if(new_level == min)
// 		pref.clear_skill(S)
// 		pref.purge_skills_missing_prerequisites()
// 		return

// 	var/max = pref.get_max_skill(S)
// 	var/current_value = pref.get_level_cost(S, min + pref.skills[S])
// 	var/new_value = pref.get_level_cost(S, new_level)

// 	if((new_level < min) || (new_level > max) || (pref.skillpoints + current_value - new_value < 0))
// 		return											//Checks if the new value is actually allowed.
// 														//None of this should happen normally, but this avoids client attacks.
// 	pref.skillpoints += (current_value - new_value)
// 	pref.skills[S] = new_level - min								//skills stores the difference from job minimum
// 	pref.purge_skills_missing_prerequisites()

// /datum/category_item/player_setup_item/skills/proc/generate_skill_content()
// 	var/dat  = list()
// 	dat += "<body>"
// 	dat += "<style>.Selectable,.Current,.Unavailable,.Toohigh{border: 1px solid #161616;padding: 1px 4px 1px 4px;margin: 0 2px 0 0}</style>"
// 	dat += "<style>.Selectable,a.Selectable{background: #40628a}</style>"
// 	dat += "<style>.Current,a.Current{background: #2f943c}</style>"
// 	dat += "<style>.Unavailable{background: #d09000}</style>"
// 	dat += "<tt><center>"
// 	dat += "<b>Skill points remaining: [pref.skillpoints].</b><hr>"
// 	dat += "<hr>"
// 	dat += "</center></tt>"

// 	dat += "<table>"
// 	var/decl/hierarchy/skill/skill = decls_repository.get_decl(/decl/hierarchy/skill)
// 	for(var/decl/hierarchy/skill/cat in skill.children)
// 		dat += "<tr><th colspan = 4><b>[cat.name]</b>"
// 		dat += "</th></tr>"
// 		for(var/decl/hierarchy/skill/S in cat.children)
// 			dat += get_skill_row(S)
// 			for(var/decl/hierarchy/skill/perk in S.children)
// 				dat += get_skill_row(perk)
// 	dat += "</table>"
// 	return JOINTEXT(dat)

// /datum/category_item/player_setup_item/skills/proc/get_skill_row(decl/hierarchy/skill/S)
// 	var/list/dat = list()
// 	var/min = pref.get_min_skill(S)
// 	var/level = min + pref.skills[S]				//the current skill level
// 	var/cap = pref.get_max_affordable(S) //if selecting the skill would make you overspend, it won't be shown
// 	dat += "<tr style='text-align:left;'>"
// 	dat += "<th><a href='?src=\ref[src];skillinfo=\ref[S]'>[S.name] ([pref.get_spent_points(S)])</a></th>"
// 	for(var/i = SKILL_MIN, i <= SKILL_MAX, i++)
// 		dat += skill_to_button(S,level, i, min, cap)
// 	dat += "</tr>"
// 	return JOINTEXT(dat)

// /datum/category_item/player_setup_item/skills/proc/open_skill_setup(mob/user)
// 	panel = new(user, "Skill Selection", "Skill Selection", 770, 850, src)
// 	panel.set_content(generate_skill_content())
// 	panel.open()

// /datum/category_item/player_setup_item/skills/proc/skill_to_button(decl/hierarchy/skill/skill, current_level, selection_level, min, max)
// 	var/offset = skill.prerequisites ? skill.prerequisites[skill.parent.type] - 1 : 0
// 	var/effective_level = selection_level - offset
// 	if(effective_level <= 0 || effective_level > length(skill.levels))
// 		return "<th></th>"
// 	var/level_name = skill.levels[effective_level]
// 	var/cost = skill.get_cost(effective_level)
// 	var/button_label = "[level_name] ([cost])"
// 	if(effective_level < min)
// 		return "<th><span class='Unavailable'>[button_label]</span></th>"
// 	else if(effective_level < current_level)
// 		return "<th>[add_link(skill, button_label, "'Current'", effective_level)]</th>"
// 	else if(effective_level == current_level)
// 		return "<th><span class='Current'>[button_label]</span></th>"
// 	else if(effective_level <= max)
// 		return "<th>[add_link(skill, button_label, "'Selectable'", effective_level)]</th>"
// 	else
// 		return "<th><span class='Toohigh'>[button_label]</span></th>"

// /datum/category_item/player_setup_item/skills/proc/add_link(decl/hierarchy/skill/skill, text, style, value)
// 	if(pref.check_skill_prerequisites(skill))
// 		return "<a class=[style] href='?src=\ref[src];hit_skill_button=\ref[skill];newvalue=[value]'>[text]</a>"
// 	return text

// /datum/category_item/player_setup_item/skills/sanitize_character()
// 	if(!istype(pref.skills))		pref.skills = list()
// 	if(!pref.skills.len)			pref.ZeroSkills()
// 	if(pref.used_skillpoints < 0)	pref.used_skillpoints = 0

// /datum/category_item/player_setup_item/skills/content()
// 	. = list()
// 	. += "<h1>Coming soon! Level up and improve attributes that change the way your character plays.<br><br><br>Dont worry, when the update comes older characters will get a chance to assign their points.</h1>"
// 	. = jointext(.,null)
	/*
	. = list()
	. += "<b>Select your Skills</b><br>"
	. += "Current skill level: <b>[pref.GetSkillClass(pref.used_skillpoints)]</b> ([pref.used_skillpoints])<br>"
	. += "<table>"
	for(var/V in SKILLS)
		. += "<tr><th colspan = 5><b>[V]</b>"
		. += "</th></tr>"
		for(var/datum/skill/S in SKILLS[V])
			var/level = pref.skills[S.ID]
			. += "<tr style='text-align:left;'>"
			. += "<th><a href='?src=\ref[src];skillinfo=\ref[S]'>[S.name]</a></th>"
			. += skill_to_button(S, "Untrained", level, SKILL_NONE)
			// secondary skills don't have an amateur level
			if(S.secondary)
				. += "<th></th>"
			else
				. += skill_to_button(S, "Amateur", level, SKILL_BASIC)
			. += skill_to_button(S, "Trained", level, SKILL_ADEPT)
			. += skill_to_button(S, "Professional", level, SKILL_EXPERT)
			. += "</tr>"
	. += "</table>"
	. = jointext(.,null)
	*/
// /datum/category_item/player_setup_item/proc/skill_to_button(var/skill, var/level_name, var/current_level, var/selection_level)
// 	if(current_level == selection_level)
// 		return "<th><span class='linkOn'>[level_name]</span></th>"
// 	return "<th><a href='?src=\ref[src];setskill=\ref[skill];newvalue=[selection_level]'>[level_name]</a></th>"

// /datum/category_item/player_setup_item/skills/OnTopic(href, href_list, user)
// 	if(href_list["skillinfo"])
// 		var/datum/skillset/S = locate(href_list["skillinfo"])
// 		if(S)
// 			S.open_ui()
// 		// var/HTML = "<h2>[S.name][S.secondary ? "(secondary)" : ""]</h2>"
// 		// HTML += "<b>Generic Description</b>: [S.desc]<br><br><b>Unskilled</b>: [S.desc_unskilled]<br>"
// 		// if(!S.secondary)
// 		// 	HTML += "<b>Amateur</b>: [S.desc_amateur]<br>"
// 		// HTML += "<b>Trained</b>: [S.desc_trained]<br><b>Professional</b>: [S.desc_professional]"

// 		//user << browse(HTML, "window=\ref[user]skillinfo")
// 		return TOPIC_HANDLED

// 	else if(href_list["setskill"])
// 		// var/datum/skillset/S = locate(href_list["setskill"])
// 		// var/value = text2num(href_list["newvalue"])
// 		// pref.skills[S.ID] = value
// 		// pref.CalculateSkillPoints()
// 		return TOPIC_REFRESH

// 	return ..()
