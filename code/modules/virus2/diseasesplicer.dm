#define DISEASE_SPLICER_SCANNING 0x1
#define DISEASE_SPLICER_SPLICING 0x2
#define DISEASE_SPLICER_WRITING  0x4
#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/diseasesplicer
	name = T_BOARD("disease splicer")
	build_path = /obj/machinery/computer/diseasesplicer
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 2)

/obj/machinery/computer/diseasesplicer
	name = "disease splicer"
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "med_key"
	icon_screen = "crew"
	circuit = /obj/item/weapon/circuitboard/diseasesplicer

	var/datum/disease2/effect/memorybank = null
	var/list/species_buffer = null
	var/obj/item/weapon/virusdish/dish = null
	var/analysed = 0
	var/time_job_done
	var/busy_state = 0

/obj/machinery/computer/diseasesplicer/New()
	..()
	ADD_SAVED_VAR(memorybank)
	ADD_SAVED_VAR(species_buffer)
	ADD_SAVED_VAR(dish)
	ADD_SAVED_VAR(analysed)
	ADD_SAVED_VAR(time_job_done)
	ADD_SAVED_VAR(busy_state)

	ADD_SKIP_EMPTY(memorybank)
	ADD_SKIP_EMPTY(species_buffer)
	ADD_SKIP_EMPTY(dish)
	ADD_SKIP_EMPTY(time_job_done)

/obj/machinery/computer/diseasesplicer/before_save()
	. = ..()
	//Convert to absolute time
	if(busy_state && time_job_done)
		time_job_done = world.time - time_job_done

/obj/machinery/computer/diseasesplicer/after_load()
	. = ..()
	//Convert to relative time
	if(busy_state && time_job_done)
		time_job_done = world.time + time_job_done

/obj/machinery/computer/diseasesplicer/attackby(var/obj/I as obj, var/mob/user as mob)
	if(default_deconstruction_screwdriver(user, I))
		return 1
	else if(default_deconstruction_crowbar(user, I))
		return 1
	else if(istype(I,/obj/item/weapon/virusdish))
		if (dish)
			to_chat(user, "\The [src] is already loaded.")
			return
		dish = I
		user.drop_from_inventory(I)
		I.forceMove(src)
		SSnano.update_uis(src)
		return 1
	else if(istype(I,/obj/item/weapon/diseasedisk))
		to_chat(user, "You upload the contents of the disk onto the buffer.")
		var/obj/item/weapon/diseasedisk/disk = I
		memorybank = disk.effect
		species_buffer = disk.species
		analysed = disk.analysed
		SSnano.update_uis(src)
		return 1
	else
		return ..()

/obj/machinery/computer/diseasesplicer/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/diseasesplicer/attack_hand(var/mob/user as mob)
	if(..()) return
	ui_interact(user)

/obj/machinery/computer/diseasesplicer/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/data[0]
	data["dish_inserted"] = !!dish
	data["growth"] = 0
	data["affected_species"] = null

	if (memorybank)
		data["buffer"] = list("name" = (analysed ? memorybank.name : "Unknown Symptom"), "stage" = memorybank.stage)
	if (species_buffer)
		data["species_buffer"] = analysed ? jointext(species_buffer, ", ") : "Unknown Species"

	if(busy_state == DISEASE_SPLICER_SPLICING)
		data["busy"] = "Splicing..."
	else if (busy_state == DISEASE_SPLICER_SCANNING)
		data["busy"] = "Scanning..."
	else if (busy_state == DISEASE_SPLICER_WRITING)
		data["busy"] = "Copying data to disk..."
	else if (dish)
		data["growth"] = min(dish.growth, 100)

		if (dish.virus2)
			if (dish.virus2.affected_species)
				data["affected_species"] = dish.analysed ? jointext(dish.virus2.affected_species, ", ") : "Unknown"

			if (dish.growth >= 50)
				var/list/effects[0]
				for (var/datum/disease2/effect/e in dish.virus2.effects)
					effects.Add(list(list("name" = (dish.analysed ? e.name : "Unknown"), "stage" = (e.stage), "reference" = "\ref[e]")))
				data["effects"] = effects
			else
				data["info"] = "Insufficient cell growth for gene splicing."
		else
			data["info"] = "No virus detected."
	else
		data["info"] = "No dish loaded."

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "disease_splicer.tmpl", src.name, 400, 600)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/computer/diseasesplicer/Process()
	if(inoperable())
		return

	switch(busy_state)
		if(DISEASE_SPLICER_SCANNING)
			if(world.time >= time_job_done)
				busy_state = 0
				time_job_done = null
				ping("\The [src] pings, \"Analysis complete.\"")
				SSnano.update_uis(src)
		if(DISEASE_SPLICER_SPLICING)
			if(world.time >= time_job_done)
				busy_state = 0
				time_job_done = null
				ping("\The [src] pings, \"Splicing operation complete.\"")
				SSnano.update_uis(src)
		if(DISEASE_SPLICER_WRITING)
			if(world.time >= time_job_done)
				busy_state = 0
				time_job_done = null
				var/obj/item/weapon/diseasedisk/d = new /obj/item/weapon/diseasedisk(src.loc)
				d.analysed = analysed
				if(analysed)
					if (memorybank)
						d.SetName("[memorybank.name] GNA disk (Stage: [memorybank.stage])")
						d.effect = memorybank
					else if (species_buffer)
						d.SetName("[jointext(species_buffer, ", ")] GNA disk")
						d.species = species_buffer
				else
					if (memorybank)
						d.SetName("Unknown GNA disk (Stage: [memorybank.stage])")
						d.effect = memorybank
					else if (species_buffer)
						d.SetName("Unknown Species GNA disk")
						d.species = species_buffer

				ping("\The [src] pings, \"Backup disk saved.\"")
				SSnano.update_uis(src)
	if(busy_state && dish && dish.virus2)
		infect_nearby(dish.virus2, 40, SKILL_PROF)

/obj/machinery/computer/diseasesplicer/OnTopic(mob/user, href_list)
	operator_skill = user.get_skill_value(core_skill)
	if (href_list["close"])
		SSnano.close_user_uis(user, src, "main")
		return TOPIC_HANDLED

	if (href_list["grab"])
		if (dish)
			memorybank = locate(href_list["grab"])
			species_buffer = null
			analysed = dish.analysed
			dish = null
			time_job_done = world.time + 5 SECONDS
			busy_state = DISEASE_SPLICER_SCANNING
		return TOPIC_REFRESH

	if (href_list["affected_species"])
		if (dish)
			memorybank = null
			species_buffer = dish.virus2.affected_species
			analysed = dish.analysed
			dish = null
			time_job_done = world.time + 5 SECONDS
			busy_state = DISEASE_SPLICER_SCANNING
		return TOPIC_REFRESH

	if(href_list["eject"])
		if (dish)
			if(Adjacent(usr) && !issilicon(usr))
				usr.put_in_hands(dish)
			dish = null
		return TOPIC_REFRESH

	if(href_list["splice"])
		if(dish)
			var/target = text2num(href_list["splice"]) // target = 1+ for effects, -1 for species
			if(memorybank && target > 0)
				if(target < memorybank.stage)
					return // too powerful, catching this for href exploit prevention

				var/datum/disease2/effect/target_effect
				var/list/illegal_types = list()
				for(var/datum/disease2/effect/e in dish.virus2.effects)
					if(e.stage == target)
						target_effect = e
					if(!e.allow_multiple)
						illegal_types += e.type
				if(memorybank.type in illegal_types)
					to_chat(user, "<span class='warning'>Virus DNA can't hold more than one [memorybank]</span>")
					return TOPIC_REFRESH
				dish.virus2.effects -= target_effect
				dish.virus2.effects += memorybank
				qdel(target_effect)

			else if(species_buffer && target == -1)
				dish.virus2.affected_species = species_buffer
			else
				return TOPIC_HANDLED

			time_job_done = world.time + 6 SECONDS
			busy_state = DISEASE_SPLICER_SPLICING
			dish.virus2.uniqueID = random_id("virusid", 0, 10000)
		return TOPIC_REFRESH

	if(href_list["disk"])
		time_job_done = world.time + 5 SECONDS
		busy_state = DISEASE_SPLICER_WRITING
		return TOPIC_REFRESH

#undef DISEASE_SPLICER_SCANNING
#undef DISEASE_SPLICER_SPLICING
#undef DISEASE_SPLICER_WRITING
