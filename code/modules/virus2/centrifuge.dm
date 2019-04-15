/obj/machinery/centrifuge
	name = "isolation centrifuge"
	desc = "Used to separate things with different weights. Spin 'em round, round, right round."
	icon = 'icons/obj/virology.dmi'
	icon_state = "centrifuge"
	density = 1
	var/curing = FALSE
	var/isolating = FALSE
	var/obj/item/weapon/reagent_containers/glass/beaker/vial/sample = null
	var/datum/disease2/disease/virus2 = null
	var/time_curing_end
	var/time_isolating_end

/obj/machinery/centrifuge/New()
	..()
	ADD_SAVED_VAR(curing)
	ADD_SAVED_VAR(isolating)
	ADD_SAVED_VAR(sample)
	ADD_SAVED_VAR(virus2)
	ADD_SAVED_VAR(time_curing_end)
	ADD_SAVED_VAR(time_isolating_end)

	ADD_SKIP_EMPTY(sample)
	ADD_SKIP_EMPTY(virus2)
	ADD_SKIP_EMPTY(time_curing_end)
	ADD_SKIP_EMPTY(time_isolating_end)

/obj/machinery/centrifuge/Initialize()
	. = ..()
	if(!map_storage_loaded)
		component_parts = list()
		component_parts += new /obj/item/weapon/circuitboard/centrifuge(src)
		component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
		component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
		component_parts += new /obj/item/weapon/computer_hardware/hard_drive/portable(src)
		component_parts += new /obj/item/stack/material/glass(src)
	RefreshParts()

/obj/machinery/centrifuge/before_save()
	. = ..()
	//Convert to absolute time
	if(curing && time_curing_end)
		time_curing_end = world.time - time_curing_end
	if(isolating && time_isolating_end)
		time_isolating_end = world.time - time_isolating_end

/obj/machinery/centrifuge/after_load()
	. = ..()
	//Convert to relative time
	if(curing && time_curing_end)
		time_curing_end = world.time + time_curing_end
	if(isolating && time_isolating_end)
		time_isolating_end = world.time + time_isolating_end

/obj/machinery/centrifuge/attackby(var/obj/O as obj, var/mob/user as mob)
	if(default_deconstruction_screwdriver(user, O))
		return 1
	else if(default_deconstruction_crowbar(user, O))
		return 1
	else if(istype(O,/obj/item/weapon/reagent_containers/glass/beaker/vial))
		if(sample)
			to_chat(user, "\The [src] is already loaded.")
			return
		if(!user.unEquip(O, src))
			return
		sample = O

		user.visible_message("[user] adds \a [O] to \the [src]!", "You add \a [O] to \the [src]!")
		SSnano.update_uis(src)
		return 1
	else
		return ..()

/obj/machinery/centrifuge/on_update_icon()
	..()
	if(operable() && (isolating || curing))
		icon_state = "centrifuge_moving"

/obj/machinery/centrifuge/attack_hand(var/mob/user as mob)
	if(..()) 
		return
	ui_interact(user)

/obj/machinery/centrifuge/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/data[0]
	data["antibodies"] = null
	data["pathogens"] = null
	data["is_antibody_sample"] = null

	if (curing)
		data["busy"] = "Isolating antibodies..."
	else if (isolating)
		data["busy"] = "Isolating pathogens..."
	else
		data["sample_inserted"] = !!sample

		if (sample)
			var/datum/reagent/blood/B = locate(/datum/reagent/blood) in sample.reagents.reagent_list
			if (B)
				data["antibodies"] = antigens2string(B.data["antibodies"], none=null)

				var/list/pathogens[0]
				var/list/virus = B.data["virus2"]
				for (var/ID in virus)
					var/datum/disease2/disease/V = virus[ID]
					pathogens.Add(list(list("name" = V.name(), "spread_type" = V.spreadtype, "reference" = "\ref[V]")))

				if (pathogens.len > 0)
					data["pathogens"] = pathogens

			else
				var/datum/reagent/antibodies/A = locate(/datum/reagent/antibodies) in sample.reagents.reagent_list
				if(A)
					data["antibodies"] = antigens2string(A.data["antibodies"], none=null)
				data["is_antibody_sample"] = 1

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "isolation_centrifuge.tmpl", src.name, 400, 500)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/centrifuge/Process()
	..()
	if (inoperable())
		return

	if (curing && world.time > time_curing_end)
		curing = FALSE
		time_curing_end = null
		cure()

	if (isolating && world.time > time_isolating_end)
		isolating = FALSE
		time_isolating_end = null
		isolate()

	if(virus2)
		infect_nearby(virus2)

/obj/machinery/centrifuge/OnTopic(user, href_list)
	if (href_list["close"])
		SSnano.close_user_uis(user, src, "main")
		return TOPIC_HANDLED

	if (href_list["print"])
		print(user)
		return TOPIC_REFRESH

	if(href_list["isolate"])
		var/datum/reagent/blood/B = locate(/datum/reagent/blood) in sample.reagents.reagent_list
		if (B)
			var/datum/disease2/disease/virus = locate(href_list["isolate"])
			virus2 = virus.getcopy()
			isolating = TRUE
			time_curing_end = world.time + 40 SECONDS
			update_icon()
			operator_skill = user.get_skill_value(core_skill)
		return TOPIC_REFRESH

	switch(href_list["action"])
		if ("antibody")
			var/delay = 20
			var/datum/reagent/blood/B = locate(/datum/reagent/blood) in sample.reagents.reagent_list
			if (!B)
				state("\The [src] buzzes, \"No antibody carrier detected.\"", "blue")
				return TOPIC_HANDLED

			var/list/viruses = B.data["virus2"]
			if(length(viruses))
				var/ID = pick(viruses)
				var/datum/disease2/disease/V = viruses[ID]
				virus2 = V.getcopy()
			operator_skill = user.get_skill_value(core_skill)
			var/has_toxins = locate(/datum/reagent/toxin) in sample.reagents.reagent_list
			var/has_radium = sample.reagents.has_reagent(/datum/reagent/radium)
			if (has_toxins || has_radium)
				state("\The [src] beeps, \"Pathogen purging speed above nominal.\"", "blue")
				if (has_toxins)
					delay = delay/2
				if (has_radium)
					delay = delay/2

			curing = TRUE
			time_curing_end = world.time + round(delay) SECONDS
			playsound(src.loc, 'sound/machines/juicer.ogg', 50, 1)
			update_icon()
			return TOPIC_REFRESH

		if("sample")
			if(sample)
				sample.dropInto(loc)
				sample = null
			return TOPIC_REFRESH

/obj/machinery/centrifuge/proc/cure()
	if (!sample) return
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in sample.reagents.reagent_list
	if (!B) return

	var/list/data = list("antibodies" = B.data["antibodies"])
	var/amt= sample.reagents.get_reagent_amount(/datum/reagent/blood)
	sample.reagents.remove_reagent(/datum/reagent/blood, amt)
	sample.reagents.add_reagent(/datum/reagent/antibodies, amt, data)
	operator_skill = null

	SSnano.update_uis(src)
	update_icon()
	ping("\The [src] pings, \"Antibody isolated.\"")

/obj/machinery/centrifuge/proc/isolate()
	if (!sample) return
	var/obj/item/weapon/virusdish/dish = new/obj/item/weapon/virusdish(loc)
	dish.virus2 = virus2
	virus2 = null
	operator_skill = null

	SSnano.update_uis(src)
	update_icon()
	ping("\The [src] pings, \"Pathogen isolated.\"")

/obj/machinery/centrifuge/proc/print(var/mob/user)
	var/obj/item/weapon/paper/P = new /obj/item/weapon/paper(loc)
	P.SetName("paper - Pathology Report")
	P.info = {"
		[virology_letterhead("Pathology Report")]
		<large><u>Sample:</u></large> [sample.name]<br>
"}

	if (user)
		P.info += "<u>Generated By:</u> [user.name]<br>"

	P.info += "<hr>"

	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in sample.reagents.reagent_list
	if (B)
		P.info += "<u>Antibodies:</u> "
		P.info += antigens2string(B.data["antibodies"])
		P.info += "<br>"

		var/list/virus = B.data["virus2"]
		P.info += "<u>Pathogens:</u> <br>"
		if (virus.len > 0)
			for (var/ID in virus)
				var/datum/disease2/disease/V = virus[ID]
				P.info += "[V.name()]<br>"
		else
			P.info += "None<br>"

	else
		var/datum/reagent/antibodies/A = locate(/datum/reagent/antibodies) in sample.reagents.reagent_list
		if (A)
			P.info += "The following antibodies have been isolated from the blood sample: "
			P.info += antigens2string(A.data["antibodies"])
			P.info += "<br>"

	P.info += {"
	<hr>
	<u>Additional Notes:</u> <field>
"}

	state("The nearby computer prints out a pathology report.")
