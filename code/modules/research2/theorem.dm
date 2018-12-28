/obj/item/weapon/researchTheorem
	name = "Blank Theorem"
	desc = "A blank research theorem"
	gender = NEUTER
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper_words"
	item_state = "paper_words"
	throwforce = 0
	w_class = ITEM_SIZE_TINY
	throw_range = 1
	throw_speed = 1
	layer = ABOVE_OBJ_LAYER

	var/field = null
	var/progress = 0
	var/list/current = list()
	var/list/research = list()

/obj/item/weapon/researchTheorem/attackby(var/obj/item/weapon/O as obj, var/mob/user as mob)

	if(istype(O, /obj/item/stack))
		for(var/type in current)
			if(istype(O, type))
				var/obj/item/stack/S = O
				var/removed = min(current[type], S.amount)
				S.use(removed)
				current[type] -= removed
				to_chat(user, "You add some of the material to the experiment.")

				if(current[type] == 0)
					current -= type
					checkCompletion(user)

				SSnano.update_uis(src)
				return

	if(istype(O, /obj/item/weapon/reagent_containers))
		if(!current.len)
			return

		var/needed = current[1]
		var/datum/reagents/R = O.reagents

		for(var/datum/reagent/has in R.reagent_list)
			if(!istype(has, needed))
				to_chat(user, "This contaminated or irrelevent sample wouldn't provide very useful data.")
				if(has.type in current)
					to_chat(user, "Make sure the samples are provided in the correct order and seperate.")
				return

		var/removed = min(current[needed], R.get_reagent_amount(needed))
		R.remove_reagent(needed, removed)
		current[needed] -= removed
		to_chat(user, "You add some of the reagent to the experiment.")

		if(current[needed] == 0)
			current -= needed
			checkCompletion(user)

		SSnano.update_uis(src)
		return

	if(O.type in current)
		to_chat(user, "You add \the [O] to the experiment")
		current[O.type]--

		if(current[O.type] == 0)
			current -= O.type
			checkCompletion(user)

		SSnano.update_uis(src)
		return

	. = ..()

/obj/item/weapon/researchTheorem/proc/checkCompletion(var/mob/user)
	if(current.len)
		return

	var/datum/researchExperiment/E = research["experiment"]
	to_chat(user, E.complete)

	for(var/tech in E.research)
		if(!isnum(research[tech]))
			research[tech] = 0

		research[tech] += E.research[tech]

	progress += rand(10, 20)
	LAZYADD(research["completed"], E.type)
	research["experiment"] = null
	research["experiments"] = GetExperiments(field, research["completed"])

/obj/item/weapon/researchTheorem/attack_self(mob/living/user as mob)
	ui_interact(user)

/obj/item/weapon/researchTheorem/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/list/data = list()
	data["name"] = name
	data["field"] = field

	if(field)
		var/tmp = ""
		switch(progress)
			if(0)
				tmp = "No research has been done yet."
			if(1 to 20)
				tmp = "Barely any research has been done yet."
			if(21 to 40)
				tmp = "Some research has been done."
			if(41 to 60)
				tmp = "About half the research has been done."
			if(61 to 80)
				tmp = "Most the research has been done."
			if(81 to 99)
				tmp = "Almost all the research has been done."
			else
				tmp = "The Theorem is complete!"
		data["progress"] = tmp

		if(progress < 100)
			if(istype(research["experiment"], /datum/researchExperiment))
				var/datum/researchExperiment/E = research["experiment"]
				var/list/tmpList = list()
				for(var/path in E.requirements)
					var/needed = E.requirements[path]
					tmpList[++tmpList.len] = "[path] - [(path in current) ? (needed - current[path]) : needed] / [needed]"
				data["experiment"] = list("title" = E.title, "content" = E.content, "requirements" = tmpList.Join(" | "))

			else
				var/list/tmpList = list()
				for(var/datum/researchExperiment/E in research["experiments"])
					var/list/researchInfo = list()
					var/list/tmpListTwo = list()
					researchInfo["title"] = E.title
					researchInfo["content"] = E.content
					for(var/path in E.requirements)
						tmpListTwo[++tmpListTwo.len] = "[path] - [E.requirements[path]]"
					researchInfo["requirements"] = tmpListTwo.Join(" | ")
					researchInfo["id"] = ++tmpList.len
					tmpList[tmpList.len] = researchInfo
				data["experiments"] = tmpList
		else
			var/list/tmpList = list()
			for(var/tech in RESEARCH_FIELDS)
				if(research[tech])
					tmpList[++tmpList.len] = list("field" = capitalize(tech), "amount" = research[tech])
			data["complete"] = tmpList

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "theoremPaper.tmpl", name, 350, 500)
		ui.set_initial_data(data)
		ui.open()

/obj/item/weapon/researchTheorem/Topic(href, href_list)
	..()

	if(href_list["field"])
		if(field)
			return TOPIC_REFRESH

		field = input("Choose a field for this Theorem", "Theorem Field") in RESEARCH_FIELDS | null
		if(field)
			name = "[capitalize(field)] Theorem"
			LAZYADD(research["experiments"], GetExperiments(field))
		return TOPIC_REFRESH

	if(href_list["experiment"])
		if(research["experiment"])
			return TOPIC_REFRESH
		var/datum/researchExperiment/E = research["experiments"][text2num(href_list["experiment"])]
		research["experiment"] = E
		current = E.requirements.Copy()
		return TOPIC_REFRESH
