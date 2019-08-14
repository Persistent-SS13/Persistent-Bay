// GENERIC PRINTER - DO NOT USE THIS OBJECT.
// Flesh and robot printers are defined below this object.

/obj/machinery/organ_printer
	name = "organ printer"
	desc = "It's a machine that prints organs."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bioprinter"
	anchored = 1
	density = 1
	idle_power_usage = 40
	active_power_usage = 300
	var/stored_matter = 0
	var/max_stored_matter = 0
	var/print_delay = 10 SECONDS
	var/printing = null //key of the organ being printed
	var/time_print_end = 0
	var/list/products = list()

/obj/machinery/organ_printer/attackby(var/obj/item/O, var/mob/user)
	if(default_deconstruction_screwdriver(user, O))
		updateUsrDialog()
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	return ..()

/obj/machinery/organ_printer/on_update_icon()
	overlays.Cut()
	if(panel_open)
		overlays += "[icon_state]_panel_open"
	else if(printing)
		overlays += "[icon_state]_working"

/obj/machinery/organ_printer/New()
	..()
	ADD_SAVED_VAR(stored_matter)
	ADD_SAVED_VAR(printing)
	ADD_SAVED_VAR(time_print_end)
	ADD_SAVED_VAR(matter_in_use)

	ADD_SKIP_EMPTY(stored_matter)
	ADD_SKIP_EMPTY(printing)
	ADD_SKIP_EMPTY(time_print_end)

/obj/machinery/organ_printer/before_save()
	. = ..()
	//Make sure we only save the time difference from the start of the printing process
	time_print_end -= world.time

/obj/machinery/organ_printer/after_load()
	. = ..()
	//Add the current time to the time difference we just saved
	time_print_end += world.time

/obj/machinery/organ_printer/Initialize(mapload, d)
	. = ..()
	if(!map_storage_loaded)
		stored_matter = max_stored_matter

/obj/machinery/organ_printer/examine(var/mob/user)
	. = ..()
	to_chat(user, "<span class='notice'>It is loaded with [stored_matter]/[max_stored_matter] matter units.</span>")

/obj/machinery/organ_printer/RefreshParts()
	print_delay = initial(print_delay)
	max_stored_matter = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/bin in component_parts)
		max_stored_matter += bin.rating * 50
	for(var/obj/item/weapon/stock_parts/manipulator/manip in component_parts)
		print_delay -= (manip.rating-1)*10
	print_delay = max(0,print_delay)
	. = ..()

/obj/machinery/organ_printer/proc/printer_status()
	return 	{"Matter levels: [round(stored_matter,1)]/[max_stored_matter] units<BR>
Time left: [time_print_end != 0? (time_print_end - world.time)/10 : "N/A"] second(s)<BR>"}

/obj/machinery/organ_printer/interact(mob/user)
	if(!panel_open)
		var/list/dat = list()
		dat += "[src.name]: "
		dat += printer_status()
		dat += "<BR><BR>"
		
		dat += "Print options: <br /><div>"
		for(var/key in products)
			var/list/P = products[key]
			if(P && P.len)
				dat += "<div class='item'>[key] - [P[2]]u <a href='?src=\ref[src];print=[key]'>Print</a></div>"
		dat += "</div>"
		dat += "<SPAN><A HREF='?src=\ref[src];cancel=1'>Cancel</A></SPAN>"
		user.set_machine(src)
		var/datum/browser/popup = new(usr, "organ_printer", "[src.name] menu")
		popup.set_content(jointext(dat, null))
		popup.open()

/obj/machinery/organ_printer/OnTopic(mob/user, href_list, datum/topic_state/state)
	. = ..()
	if(href_list["print"] && !printing)
		var/prod = sanitize(href_list["print"])
		if(can_print(prod))
			printing = prod
			time_print_end = world.time + print_delay
			update_use_power(POWER_USE_ACTIVE)
			update_icon()
			updateUsrDialog()
		else
			state("Not enough matter for completing the task!")
		return TOPIC_HANDLED
	if(href_list["cancel"] && printing)
		printing = null
		time_print_end = 0
		update_use_power(POWER_USE_IDLE)
		update_icon()
		updateUsrDialog()
		return TOPIC_REFRESH

/obj/machinery/organ_printer/Process()
	if(inoperable())
		return

	if(printing && (world.time >= time_print_end))
		time_print_end = 0
		stored_matter -= products[printing][2]
		print_organ(printing)
		printing = null
		update_use_power(POWER_USE_IDLE)
		queue_icon_update()
	updateUsrDialog()

/obj/machinery/organ_printer/proc/can_print(var/choice)
	if(stored_matter < products[choice][2])
		visible_message("<span class='notice'>\The [src] displays a warning: 'Not enough matter. [stored_matter] stored and [products[choice][2]] needed.'</span>")
		return 0
	return 1

/obj/machinery/organ_printer/proc/print_organ(var/choice)
	var/new_organ = products[choice][1]
	var/obj/item/organ/O = new new_organ(get_turf(src))
	O.status |= ORGAN_CUT_AWAY
	return O
// END GENERIC PRINTER

// ROBOT ORGAN PRINTER
/obj/machinery/organ_printer/robot
	name = "prosthetic organ fabricator"
	desc = "It's a machine that prints prosthetic organs."
	icon_state = "roboprinter"

	products = list(
		BP_HEART    = list(/obj/item/organ/internal/heart,      25),
		BP_LUNGS    = list(/obj/item/organ/internal/lungs,      25),
		BP_KIDNEYS  = list(/obj/item/organ/internal/kidneys,    20),
		BP_EYES     = list(/obj/item/organ/internal/eyes,       20),
		BP_LIVER    = list(/obj/item/organ/internal/liver,      25),
		BP_STOMACH  = list(/obj/item/organ/internal/stomach,    25),
		BP_L_ARM    = list(/obj/item/organ/external/arm,        65),
		BP_R_ARM    = list(/obj/item/organ/external/arm/right,  65),
		BP_L_LEG    = list(/obj/item/organ/external/leg,        65),
		BP_R_LEG    = list(/obj/item/organ/external/leg/right,  65),
		BP_L_FOOT   = list(/obj/item/organ/external/foot,       40),
		BP_R_FOOT   = list(/obj/item/organ/external/foot/right, 40),
		BP_L_HAND   = list(/obj/item/organ/external/hand,       40),
		BP_R_HAND   = list(/obj/item/organ/external/hand/right, 40)
		)

	circuit_type = /obj/item/weapon/circuitboard/roboprinter
	var/matter_amount_per_sheet = 10
	var/matter_type = MATERIAL_STEEL

/obj/machinery/organ_printer/robot/print_organ(var/choice)
	var/obj/item/organ/O = ..()
	O.robotize()
	O.status |= ORGAN_CUT_AWAY  // robotize() resets status to 0
	visible_message("<span class='info'>\The [src] churns for a moment, then spits out \a [O].</span>")
	return O

/obj/machinery/organ_printer/robot/attackby(var/obj/item/weapon/W, var/mob/user)
	if(istype(W, /obj/item/stack/material) && W.get_material_name() == matter_type)
		if((max_stored_matter-stored_matter) < matter_amount_per_sheet)
			to_chat(user, "<span class='warning'>\The [src] is too full.</span>")
			return 1
		var/obj/item/stack/S = W
		var/space_left = max_stored_matter - stored_matter
		var/sheets_to_take = min(S.amount, Floor(space_left/matter_amount_per_sheet))
		if(sheets_to_take <= 0)
			to_chat(user, "<span class='warning'>\The [src] is too full.</span>")
			return 1
		stored_matter = min(max_stored_matter, stored_matter + (sheets_to_take*matter_amount_per_sheet))
		to_chat(user, "<span class='info'>\The [src] processes \the [W]. Levels of stored matter now: [stored_matter]</span>")
		S.use(sheets_to_take)
		updateUsrDialog()
		return 1
	return ..()
// END ROBOT ORGAN PRINTER

// FLESH ORGAN PRINTER
/obj/machinery/organ_printer/flesh
	name = "bioprinter"
	desc = "It's a machine that prints replacement organs."
	icon_state = "bioprinter"
	circuit_type = /obj/item/weapon/circuitboard/bioprinter
	var/list/amount_list = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat = 50,
		/obj/item/weapon/reagent_containers/food/snacks/rawcutlet = 15
		)
	var/loaded_dna //DNA uni identity hash
	var/datum/species/loaded_species //For quick refrencing

/obj/machinery/organ_printer/flesh/can_print(var/choice)
	. = ..()
	if(!loaded_dna || !loaded_dna["donor"])
		visible_message("<span class='info'>\The [src] displays a warning: 'No DNA saved. Insert a blood sample.'</span>")
		return 0

/obj/machinery/organ_printer/flesh/dismantle()
	var/turf/T = get_turf(src)
	if(T)
		while(stored_matter >= amount_list[/obj/item/weapon/reagent_containers/food/snacks/meat])
			stored_matter -= amount_list[/obj/item/weapon/reagent_containers/food/snacks/meat]
			new /obj/item/weapon/reagent_containers/food/snacks/meat(T)
	return ..()

/obj/machinery/organ_printer/flesh/New()
	..()
	ADD_SAVED_VAR(loaded_dna)
	ADD_SAVED_VAR(loaded_species)

	ADD_SKIP_EMPTY(loaded_dna)
	ADD_SKIP_EMPTY(loaded_species)

/obj/machinery/organ_printer/flesh/print_organ(var/choice)
	var/obj/item/organ/O
	var/new_organ
	if(loaded_species.has_organ[choice])
		new_organ = loaded_species.has_organ[choice]
	else if(loaded_species.has_limbs[choice])
		new_organ = loaded_species.has_limbs[choice]["path"]
	if(new_organ)
		O = new new_organ(get_turf(src), loaded_dna)
		O.status |= ORGAN_CUT_AWAY
	else
		O = ..()
	if(O.species)
		// This is a very hacky way of doing of what organ/New() does if it has an owner
		O.w_class = max(O.w_class + mob_size_difference(O.species.mob_size, MOB_MEDIUM), 1)

	visible_message("<span class='info'>\The [src] churns for a moment, injects its stored DNA into the biomass, then spits out \a [O].</span>")
	updateUsrDialog()
	return O

/obj/machinery/organ_printer/flesh/printer_status()
	return {"[..()]Loaded dna: [loaded_dna? loaded_dna : "<span class='bad'>N/A</span>"] <BR>
Loaded specie: [loaded_species? loaded_species.name : "<span class='bad'>N/A</span>"]<BR>"}

/obj/machinery/organ_printer/flesh/can_print(choice)
	if(!loaded_dna || !loaded_species)
		return FALSE
	. = ..()

/obj/machinery/organ_printer/flesh/attackby(obj/item/weapon/W, mob/user)
	// Load with matter for printing.
	for(var/path in amount_list)
		if(istype(W, path))
			if(max_stored_matter == stored_matter)
				to_chat(user, SPAN_WARNING("\The [src] is too full."))
				return
			if(!user.unEquip(W))
				return
			stored_matter += min(amount_list[path], max_stored_matter - stored_matter)
			to_chat(user, SPAN_INFO("\The [src] processes \the [W]. Levels of stored biomass now: [stored_matter]"))
			updateUsrDialog()
			qdel(W)
			return

	// DNA sample from syringe.
	if(istype(W,/obj/item/weapon/reagent_containers/syringe))
		var/obj/item/weapon/reagent_containers/syringe/S = W
		var/datum/reagent/blood/injected = locate() in S.reagents.reagent_list //Grab some blood
		if(injected && injected.data)
			loaded_dna = injected.get_dna()
			loaded_species = all_species[injected.data["species"]]
			to_chat(user, SPAN_INFO("You inject the blood sample into the bioprinter."))
			S.reagents.remove_any(5) //blood samples are 5u I guess
			products = get_possible_products()
			updateUsrDialog()
		return
	return ..()

/obj/machinery/organ_printer/flesh/proc/get_possible_products()
	. = list()
	if(!loaded_species)
		return
	var/list/organs = list()
	for(var/organ in loaded_species.has_organ)
		organs += loaded_species.has_organ[organ]
	for(var/organ in loaded_species.has_limbs)
		organs += loaded_species.has_limbs[organ]["path"]
	for(var/organ in organs)
		var/obj/item/organ/O = organ
		if(check_printable(organ))
			var/cost = initial(O.print_cost)
			if(!cost)
				cost = round(0.75 * initial(O.max_health))
			.[initial(O.organ_tag)] = list(O, cost)

/obj/machinery/organ_printer/flesh/proc/check_printable(var/organtype)
	var/obj/item/organ/O = organtype
	if(!initial(O.can_be_printed))
		return FALSE
	if(initial(O.vital))
		return FALSE
	if(initial(O.status) & ORGAN_ROBOTIC)
		return FALSE
	if(ispath(organtype, /obj/item/organ/external))
		var/obj/item/organ/external/E = organtype
		if(initial(E.limb_flags) & ORGAN_FLAG_HEALS_OVERKILL)
			return FALSE
	return TRUE

// END FLESH ORGAN PRINTER
