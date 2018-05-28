/datum/preferences
	var/used_skillpoints = 0
	var/list/skills          // skills can range from 0 to 3
/datum/category_item/player_setup_item/welcome
	name = "Welcome to Persistent Station 13!"
	sort_order = 1

/datum/category_item/player_setup_item/welcome/content()
	. = list()
	. += "<h2>Persistence is a codebase that makes the world and characters of SS13 save and load. Instead of rounds, the game is continuous with players creating factions and establishing space installations both peaceful and hostile, competing and cooperating in a galaxy of limited resources. After years of private Alpha Testing, the game is finally ready to be publically playable. It's still in early beta under active development however, so you can expect bugs."
	. += "<br><br>As a new player, the best way to get into the game is to take some time designing your first character. You will need to choose your starting faction and if you haven't played very long your choices for a starting faction will be limited, but most factions recruit their members from defectors of the basic starting factions. If you choose Nanotrasen, you will start on a space station with gameplay very similar to traditional SS13."
	. += "<br><br>Once you have a character, just look for an assignment so you can start putting money into your account. You can rise through the ranks anywhere, and soon you'll be ensconced in a world of intrigue and politics. Open a buisness designing atmospherics, or found an intersteller empire."
	. += "<br><br>Persistence is a collaborative project that is developed by an entire community of people. If you are intrested in joining us you can visit our forums here: https://persistentss13.com/forum or our discord here: https://discord.gg/UUpHSPp plus you can find a wiki here: https://persistentss13.com/wiki"
	. += "<br><br>Thanks for playing our game -- Brawler, Lead Developer</h3>"
	. = jointext(.,null)
/datum/category_item/player_setup_item/skills
	name = "Skills"
	sort_order = 1

/datum/category_item/player_setup_item/skills/load_character(var/savefile/S)
	from_file(S["skills"],pref.skills)
	from_file(S["used_skillpoints"],pref.used_skillpoints)

/datum/category_item/player_setup_item/skills/save_character(var/savefile/S)
	to_file(S["skills"],pref.skills)
	to_file(S["used_skillpoints"],pref.used_skillpoints)

/datum/category_item/player_setup_item/skills/sanitize_character()
	if(SKILLS == null)				setup_skills()
	if(!istype(pref.skills))		pref.skills = list()
	if(!pref.skills.len)			pref.ZeroSkills()
	if(pref.used_skillpoints < 0)	pref.used_skillpoints = 0

/datum/category_item/player_setup_item/skills/content()
	. = list()
	. += "<h1>Coming soon! Level up and improve attributes that change the way your character plays.<br><br><br>Dont worry, when the update comes older characters will get a chance to assign their points.</h1>"
	. = jointext(.,null)
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
/datum/category_item/player_setup_item/proc/skill_to_button(var/skill, var/level_name, var/current_level, var/selection_level)
	if(current_level == selection_level)
		return "<th><span class='linkOn'>[level_name]</span></th>"
	return "<th><a href='?src=\ref[src];setskill=\ref[skill];newvalue=[selection_level]'>[level_name]</a></th>"

/datum/category_item/player_setup_item/skills/OnTopic(href, href_list, user)
	if(href_list["skillinfo"])
		var/datum/skill/S = locate(href_list["skillinfo"])
		var/HTML = "<h2>[S.name][S.secondary ? "(secondary)" : ""]</h2>"
		HTML += "<b>Generic Description</b>: [S.desc]<br><br><b>Unskilled</b>: [S.desc_unskilled]<br>"
		if(!S.secondary)
			HTML += "<b>Amateur</b>: [S.desc_amateur]<br>"
		HTML += "<b>Trained</b>: [S.desc_trained]<br><b>Professional</b>: [S.desc_professional]"

		user << browse(HTML, "window=\ref[user]skillinfo")
		return TOPIC_HANDLED

	else if(href_list["setskill"])
		var/datum/skill/S = locate(href_list["setskill"])
		var/value = text2num(href_list["newvalue"])
		pref.skills[S.ID] = value
		pref.CalculateSkillPoints()
		return TOPIC_REFRESH

	return ..()
