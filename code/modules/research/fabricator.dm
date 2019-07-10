#define EJECT_ALL -1
#define EJECT_ONE 0

/*
Fabricators
A reworked and modular system intended to differentiate the production of items from RnD through specialized machines, in addition to giving them a nicer
interface. It is designed for subtypes to be easily created with minimal changes. New fabricators should be placed under the fabricators sub-folder, as well
as their designs, in a single .dm file. voidsuit_fabricator.dm is an entirely commented example.
*/

/datum/fabricator_tech
	var/uid
	var/uses = -10

/obj/machinery/fabricator
	// Things that must be adjusted for each fabricator
	name = "Fabricator"
	desc = "A machine used for the production of various items"
	var/obj/item/weapon/circuitboard/fabricator/circuit //Pointer to the circuit board, since we save info into it
	circuit_type = /obj/item/weapon/circuitboard/fabricator
	var/build_type = PROTOLATHE
	req_access = list()

	// Things that CAN be adjusted, but are okay to leave as default
	icon_state = 			"fab-idle"
	var/icon_idle = 	 	"fab-idle"
	var/icon_open = 	 	"fab-o"
	var/overlay_active = 	"fab-active"
	var/metal_load_anim = 1

	var/has_reagents = FALSE

	// Things best left untouched, unless you know what you're doing
	icon = 'icons/obj/machines/fabricators.dmi'
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 20
	active_power_usage = 5000

	var/speed = 1
	var/mat_efficiency = 1

	var/list/materials = list()
	var/res_max_amount = 200000
	var/datum/research/files
	var/list/datum/design/queue = list()
	var/progress = 0
	var/busy = 0

	var/list/categories = list()
	var/category = null
	var/sync_message = ""

	var/menu = 1

	var/datum/world_faction/connected_faction
	var/datum/design/selected_design


/obj/machinery/fabricator/New()
	..()
	if(has_reagents)
		atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	ADD_SAVED_VAR(materials)
	ADD_SAVED_VAR(circuit)

	ADD_SKIP_EMPTY(materials)

/obj/machinery/fabricator/Initialize()
	. = ..()
	update_categories()

//Base class uses the circuit's details to add the required parts to the machine
/obj/machinery/fabricator/SetupParts()
	if(has_reagents)
		LAZYADD(component_parts, new /obj/item/weapon/reagent_containers/glass/beaker(src))
		LAZYADD(component_parts, new /obj/item/weapon/reagent_containers/glass/beaker(src))
	..()
	//Since we already create the circuit in the base class, just fetch it here and save the pointer
	circuit = locate(circuit_type) in component_parts
	if(!istype(circuit))
		CRASH("[src]\ref[src] no circuit found for the fabricator")

/obj/machinery/fabricator/Destroy()
	can_disconnect(connected_faction)
	connected_faction = null
	selected_design = null
	LAZYCLEARLIST(queue)
	queue = null
	if(files)
		QDEL_NULL(files)
	..()

/obj/machinery/fabricator/Process()
	..()
	if(stat)
		return
	if(busy)
		update_use_power(POWER_USE_ACTIVE)
		progress += speed
		check_build()
	else
		update_use_power(POWER_USE_IDLE)
	queue_icon_update()

/obj/machinery/fabricator/update_icon()
	overlays.Cut()
	if(panel_open)
		icon_state = icon_open
	else
		icon_state = icon_idle
	if(busy)
		overlays +=  overlay_active

/obj/machinery/fabricator/dismantle()
	for(var/f in materials)
		eject_materials(f, EJECT_ALL)
	..()

/obj/machinery/fabricator/RefreshParts()
	var/R = 0
	for(var/obj/item/weapon/reagent_containers/glass/G in component_parts) // In case wants to get creative with beaker amounts
		R += G.reagents.maximum_volume
	if(!reagents) create_reagents(R)

	res_max_amount = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/M in component_parts)
		res_max_amount += M.rating * 100000 // 200k -> 600k
	var/T = 0
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		T += M.rating
	mat_efficiency = 1 - (T - 1) / 4 // 1 -> 0.5
	for(var/obj/item/weapon/stock_parts/micro_laser/M in component_parts) // Not resetting T is intended; speed is affected by both
		T += M.rating
	speed = T / 2 // 1 -> 3

/obj/machinery/fabricator/attack_hand(var/mob/user)
	if(..())
		return
	if(!allowed(user))
		to_chat(user, "<span class='warning'>Access denied.</span>")
		return
	ui_interact(user)

/obj/machinery/fabricator/ui_interact(var/mob/user, var/ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	var/datum/design/current = queue.len ? queue[1] : null
	if(current)
		data["current"] = current.name
		data["builtperc"] = round((progress / current.time) * 100)
	else
		data["current"] = "**None**"
		data["builtperc"] = 0
	data["sync"] = sync_message
	data["menu"] = menu
	if(!connected_faction && req_access_faction && req_access_faction != "")
		connected_faction = get_faction(req_access_faction)
	if(!connected_faction)
		menu = 3
		req_access = list()
	if(menu == 1)
		if(!selected_design)
			data["buildable"] = get_build_options()
			data["category"] = category
			data["categories"] = categories
		else
			data["design_name"] = selected_design.name
			data["design_description"] = selected_design.desc
			data["design_materials"] = get_design_resources(selected_design)
			data["design_buildtime"] = get_design_time(selected_design)
			data["design_icon"] = user.browse_rsc_icon(selected_design.builds.icon, selected_design.builds.icon_state)
			if(selected_design.research && selected_design.research != "")
				var/datum/tech_entry/entry = SSresearch.files.get_tech_entry(selected_design.research)
				if(entry)
					if(!has_research(selected_design.research))
						data["design_research"] = "<font color='red'>" + entry.name + "</font>"
					else
						data["design_research"] = "<font color='green'>" + entry.name + "</font>"
					data["disk_uses"] = get_uses()

	if(menu == 2)
		data["queue"] = get_queue_names()
		data["materials"] = get_materials()
		data["has_reagents"] = has_reagents
		data["reagents"] = get_reagents()
		data["maxres"] = res_max_amount

	if(menu == 3)
		if(connected_faction)
			data["org"] = connected_faction.name

		if(req_access.len)
			var/access = req_access[1]
			data["access"] = connected_faction.get_access_name(access)
		else
			data["access"] = "**NO ACCESS REQUIREMENT**"



	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "fabricator.tmpl", "[name] UI", 1000, 600)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/fabricator/Topic(href, href_list)
	if(..())
		return

	if(href_list["select"])
		if(!connected_faction)
			to_chat(usr, "You must connect the fabricator to an organization first.")
			return 0
		selected_design = locate(href_list["select"])

	if(href_list["remove"])
		if(!connected_faction)
			to_chat(usr, "You must connect the fabricator to an organization first.")
			return 0
		remove_from_queue(text2num(href_list["remove"]))

	if(href_list["category"])
		if(!connected_faction)
			to_chat(usr, "You must connect the fabricator to an organization first.")
			return 0
		if(href_list["category"] in categories)
			category = href_list["category"]

	if(href_list["eject"])
		if(!connected_faction)
			to_chat(usr, "You must connect the fabricator to an organization first.")
			return 0
		eject_materials(href_list["eject"], text2num(href_list["amount"]))

	if(href_list["menu"])
		if(!connected_faction)
			to_chat(usr, "You must connect the fabricator to an organization first.")
			return 0
		menu = text2num(href_list["menu"])

	if(href_list["back"])
		if(!connected_faction)
			to_chat(usr, "You must connect the fabricator to an organization first.")
			return 0
		selected_design = null

	if(href_list["build"])
		if(!connected_faction)
			to_chat(usr, "You must connect the fabricator to an organization first.")
			return 0
		add_to_queue(selected_design)
	if(href_list["link_org"])
		var/obj/item/weapon/card/id/id = usr.GetIdCard()
		if(id)
			var/datum/world_faction/faction = get_faction(id.selected_faction)
			if(faction)
				can_connect(faction, usr)
	if(href_list["unlink_org"])
		if(!has_access(list(core_access_machine_linking), list(), usr.GetAccess(req_access_faction)))
			to_chat(usr, "You do not have access to unlink machines.")
			return 0
		can_disconnect(connected_faction, usr)
	if(href_list["link_org"])
		var/obj/item/weapon/card/id/id = usr.GetIdCard()
		if(id)
			var/datum/world_faction/faction = get_faction(id.selected_faction)
			if(faction)
				can_connect(faction, usr)
	return 1

/obj/machinery/fabricator/attackby(var/obj/item/I as obj, var/mob/user as mob)

	if(busy)
		to_chat(user, "<span class='notice'>\The [src] is busy. Please wait for completion of previous operation.</span>")
		return 1

	if(default_deconstruction_screwdriver(user, I))
		return

	if(default_deconstruction_crowbar(user, I))
		return

	if(default_part_replacement(user, I))
		return

	if(I.is_open_container())
		update_busy()
		return

	if(istype(I, /obj/item/weapon/disk/tech_entry_disk))
		var/obj/item/weapon/disk/tech_entry_disk/disk = I
		if(!disk.uid || disk.uid == "")
			to_chat(user, "This tech disk is blank. Contact a developer.")
		if(has_research(disk.uid))
			to_chat(user, "The fabricator already carries this tech.")
		if(!needs_research(disk.uid))
			to_chat(user, "The fabricator has no designs that require this tech.")
		add_research(disk.uid)
		user.drop_item()
		disk.loc = null
		qdel(disk)
	if(!istype(I, /obj/item/stack/material))
		return ..()

	var/obj/item/stack/material/stack = I
	var/material = stack.material.name
	var/stack_singular = "[stack.material.use_name] [stack.material.sheet_singular_name]" // eg "steel sheet", "wood plank"
	var/stack_plural = "[stack.material.use_name] [stack.material.sheet_plural_name]" // eg "steel sheets", "wood planks"

	if(!(material in materials))
		to_chat(user, "<span class=warning>\The [src] does not accept [stack_plural]!</span>")
		return

	var/stackMatter = stack.material.get_matter()
	for(var/mat in stackMatter)
		stackMatter[mat] = round(stackMatter[mat] * stack.matter_multiplier)

	if(stack.reinf_material)
		var/stackReinfMatter = stack.reinf_material.get_matter()
		for(var/rmat in stackReinfMatter)
			LAZYASSOC(stackMatter, rmat)
			stackMatter[rmat] += stackReinfMatter[rmat] * 0.5 * stack.matter_multiplier

	var/can_fit = TRUE
	var/count = 0
	while(can_fit && stack.amount >= 1)
		for(var/mat in stackMatter)
			if(materials[mat] + stackMatter[mat] > res_max_amount)
				can_fit = FALSE
				break

		if(can_fit)
			for(var/mat in stackMatter)
				materials[mat] += stackMatter[mat]
				
			stack.use(1)
			count++
	
	if(count)
		to_chat(user, "You insert [count] [count == 1 ? stack_singular : stack_plural] into the fabricator.")	// 0 steel sheets, 1 steel sheet, 2 steel sheets, etc
		if(metal_load_anim)
			overlays += "fab-load-[material]"
			spawn(10)
				overlays -= "fab-load-[material]"
	else
		to_chat(user, SPAN_NOTICE("The fabricator cannot hold any more [stack_plural]."))	// use the plural form even if the given sheet is singular

	update_busy()

/obj/machinery/fabricator/emag_act(var/remaining_charges, var/mob/user)
	switch(emagged)
		if(0)
			emagged = 0.5
			visible_message("\icon[src] <b>[src]</b> beeps: \"DB error \[Code 0x00F1\]\"")
			sleep(10)
			visible_message("\icon[src] <b>[src]</b> beeps: \"Attempting auto-repair\"")
			sleep(15)
			visible_message("\icon[src] <b>[src]</b> beeps: \"User DB corrupted \[Code 0x00FA\]. Truncating data structure...\"")
			sleep(30)
			visible_message("\icon[src] <b>[src]</b> beeps: \"User DB truncated. Please contact your [GLOB.using_map.company_name] system operator for future assistance.\"")
			req_access = null
			emagged = 1
			return 1
		if(0.5)
			visible_message("\icon[src] <b>[src]</b> beeps: \"DB not responding \[Code 0x0003\]...\"")
		if(1)
			visible_message("\icon[src] <b>[src]</b> beeps: \"No records in User DB\"")

/obj/machinery/fabricator/proc/update_busy()
	if(queue.len)
		if(can_build(queue[1]))
			busy = 1
		else
			busy = 0
	else
		busy = 0

/obj/machinery/fabricator/proc/add_to_queue(var/datum/design/D)
	queue += D
	update_busy()

/obj/machinery/fabricator/proc/remove_from_queue(var/index)
	if(index == 1)
		progress = 0
	queue.Cut(index, index + 1)
	update_busy()

/obj/machinery/fabricator/proc/can_build(var/datum/design/D)
	if(!connected_faction) return 0
	for(var/M in D.materials)
		if(materials[M] <= D.materials[M] * mat_efficiency)
			return 0
	for(var/C in D.chemicals)
		if(!reagents.has_reagent(C, D.chemicals[C] * mat_efficiency))
			return 0
	if(D.research && D.research != "" && !(has_research(D.research))) return 0
	return 1


/obj/machinery/fabricator/proc/has_mats(var/datum/design/D)
	for(var/M in D.materials)
		if(materials[M] <= D.materials[M] * mat_efficiency)
			return 0
	return 1

/obj/machinery/fabricator/proc/has_mat(var/datum/design/D, var/M)
	if(materials[M] <= D.materials[M] * mat_efficiency)
		return 0
	return 1



/obj/machinery/fabricator/proc/has_regs(var/datum/design/D)
	for(var/C in D.chemicals)
		if(!reagents.has_reagent(C, D.chemicals[C] * mat_efficiency))
			return 0
	return 1

/obj/machinery/fabricator/proc/has_reg(var/datum/design/D, var/C)
	if(!reagents.has_reagent(C, D.chemicals[C] * mat_efficiency))
		return 0
	return 1

/obj/machinery/fabricator/proc/add_research(var/uid)
	var/datum/tech_entry/entry = SSresearch.files.get_tech_entry(uid)
	var/datum/fabricator_tech/tech = new()
	tech.uid = entry.uid
	tech.uses = entry.uses
	circuit.unlocked_techs |= tech
/obj/machinery/fabricator/proc/has_research(var/uid)
	for(var/datum/fabricator_tech/tech in circuit.unlocked_techs)
		if(tech.uid == uid)
			return 1
	return 0

/obj/machinery/fabricator/proc/needs_research(var/uid)
	var/list/design_options = SSresearch.files.get_research_options(build_type)
	for(var/datum/design/D in design_options)
		if(D.research == uid) return 1

/obj/machinery/fabricator/proc/get_research(var/uid)
	for(var/datum/fabricator_tech/tech in circuit.unlocked_techs)
		if(tech.uid == uid)
			return tech
	return 0

/obj/machinery/fabricator/proc/handle_uses(var/uid)
	var/datum/fabricator_tech/tech = get_research(uid)
	if(tech && tech.uses != -10)
		tech.uses--
		if(tech.uses <= 0)
			circuit.unlocked_techs -= tech
/obj/machinery/fabricator/proc/get_uses()
	var/datum/fabricator_tech/tech = get_research(selected_design.research)
	if(tech)
		if(tech.uses == -10)
			return "unlimited"
		else
			return tech.uses
	return "unlimited"


/obj/machinery/fabricator/proc/check_build()
	if(!queue.len)
		progress = 0
		return
	var/datum/design/D = queue[1]
	if(!can_build(D))
		progress = 0
		return
	if(D.time > progress)
		return
	for(var/M in D.materials)
		materials[M] = max(0, materials[M] - D.materials[M] * mat_efficiency)
	for(var/C in D.chemicals)
		reagents.remove_reagent(C, D.chemicals[C] * mat_efficiency)
	if(D.build_path)
		if(D.research && D.research != "")
			handle_uses(D.research)
		var/obj/new_item = D.Fabricate(loc, src)
		if(connected_faction)
			if(istype(connected_faction, /datum/world_faction/business))
				var/datum/world_faction/business/business_faction = connected_faction
				business_faction.fabricator_objectives()
		visible_message("\The [src] pings, indicating that \the [D] is complete.", "You hear a ping.")
		if(mat_efficiency != 1)
			if(new_item.matter && new_item.matter.len > 0)
				for(var/i in new_item.matter)
					new_item.matter[i] = new_item.matter[i] * mat_efficiency
	remove_from_queue(1)

/obj/machinery/fabricator/proc/get_queue_names()
	. = list()
	for(var/i = 2 to queue.len)
		var/datum/design/D = queue[i]
		. += D.name

/obj/machinery/fabricator/proc/get_build_options()
	. = list()
	var/list/design_options = SSresearch.files.get_research_options(build_type)
	var/list/techless = list()
	for(var/i = 1 to design_options.len)
		var/datum/design/D = design_options[i]
		var/design_research
		if(D.research && D.research != "")
			if(!has_research(D.research))
				techless |= D
				continue
			else
				design_research = "<font color='green'>[D.get_tech_name()]</font>"
		. += list(list("name" = D.name, "id" = i, "category" = D.category, "resources" = get_design_resources(D), "research" = design_research, "ref" = "\ref[D]"))

	for(var/i = 1 to techless.len)
		var/datum/design/D = techless[i]
		var/design_research
		if(D.research && D.research != "")
			if(!has_research(D.research))
				design_research = "<font color='red'>[D.get_tech_name()]</font>"
			else
				design_research = "<font color='green'>[D.get_tech_name()]</font>"
		. += list(list("name" = D.name, "id" = i, "category" = D.category, "resources" = get_design_resources(D), "research" = design_research, "ref" = "\ref[D]"))

/obj/machinery/fabricator/proc/CallReagentName(var/reagent_type)
	var/datum/reagent/R = reagent_type
	return ispath(reagent_type, /datum/reagent) ? initial(R.name) : "Unknown"

/obj/machinery/fabricator/proc/get_design_resources(var/datum/design/D)
	return get_design_mats(D) + " " + get_design_regs(D)

/obj/machinery/fabricator/proc/get_design_mats(var/datum/design/D)
	var/list/F = list()
	for(var/T in D.materials)
		if(has_mat(D, T))
			F += "<font color='green'>[capitalize(T)]: [D.materials[T] * mat_efficiency]</font>"
		else
			F += "<font color='red'>[capitalize(T)]: [D.materials[T] * mat_efficiency]</font>"
	return english_list(F, and_text = ", ")

/obj/machinery/fabricator/proc/get_design_regs(var/datum/design/D)
	var/list/F = list()
	for(var/R in D.chemicals)
		if(has_reg(D, R))
			F += "<font color='green'>[CallReagentName(R)]: [D.chemicals[R] * mat_efficiency]</font>"
		else
			F += "<font color='red'>[CallReagentName(R)]: [D.chemicals[R] * mat_efficiency]</font>"
	return english_list(F, "", and_text = ", ")


/obj/machinery/fabricator/proc/get_design_time(var/datum/design/D)
	return time2text(round(10 * D.time / speed), "mm:ss")

/obj/machinery/fabricator/proc/update_categories()
	categories = list()
	var/list/design_options = SSresearch.files.get_research_options(build_type)
	var/list/design_materials = list()
	for(var/i = 1 to design_options.len)
		var/datum/design/D = design_options[i]
		categories |= D.category
		for(var/material in D.materials) // Iterating over the Designs' materials so that we know what should be able to be inserted
			design_materials |= material
			design_materials[material] = 0 // Prevents material count from appearing as null instead of 0

	for(var/material in materials)
		if(!(material in design_materials))
			eject_materials(material, EJECT_ALL) // Dump all the materials not used in designs so that players don't use materials on code changes.

	materials |= design_materials
	materials &= design_materials

	if(!category || !(category in categories) && LAZYLEN(categories))
		category = categories[1]

/obj/machinery/fabricator/proc/get_materials()
	. = list()
	for(var/T in materials)
		. += list(list("mat" = capitalize(T), "amt" = materials[T]))

/obj/machinery/fabricator/proc/get_reagents()
	. = list()
	if(has_reagents)
		for(var/datum/reagent/R in reagents.reagent_list)
			. += list(list("reg" = R.name, "amt" = R.volume))

/obj/machinery/fabricator/proc/eject_materials(var/material, var/amount) // 0 amount = 0 means ejecting a full stack; -1 means eject everything
	var/recursive = 0
	material = lowertext(material)
	var/material/M = SSmaterials.get_material_by_name(material)
	var/stacktype = M.stack_type

	if(!stacktype)
		log_error("Unable to create stack type for material '[material]'")
		return

	var/obj/item/stack/material/S = new stacktype(loc)
	if(amount <= 0)
		recursive = amount
		amount = S.max_amount
	var/ejected = min(round(materials[material] / ONE_SHEET), amount)
	S.amount = min(ejected, amount)
	if(S.amount <= 0)
		qdel(S)
		return
	materials[material] -= ejected * ONE_SHEET
	if(recursive && materials[material] >= ONE_SHEET)
		eject_materials(material, EJECT_ALL)
	update_busy()

/obj/machinery/fabricator/proc/sync()
	sync_message = "Error: no console found."
	for(var/obj/machinery/computer/rdconsole/RDC in range(7, src))
		if(!RDC.sync)
			continue
		for(var/datum/tech/T in RDC.files.known_tech)
			files.AddTech2Known(T)
		for(var/datum/design/D in RDC.files.known_designs)
			files.AddDesign2Known(D)
		files.RefreshResearch()
		sync_message = "Sync complete."
	update_categories()

#undef EJECT_ONE
#undef EJECT_ALL