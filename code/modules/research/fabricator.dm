/*
Fabricators
A reworked and modular system intended to differentiate the production of items from RnD through specialized machines, in addition to giving them a nicer
interface. It is designed for subtypes to be easily created with minimal changes. New fabricators should be placed under the fabricators sub-folder, as well
as their designs, in a single .dm file. voidsuit_fabricator.dm is an entirely commented example.
*/

/obj/machinery/fabricator
	// Things that must be adjusted for each fabricator
	name = "Fabricator"
	desc = "A machine used for the production of various items"
	var/obj/item/weapon/circuitboard/circuit = /obj/item/weapon/circuitboard/fabricator
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
	
/obj/machinery/fabricator/New()
	..()

	component_parts = list()
	component_parts += new circuit(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/micro_laser(src)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)

	if(has_reagents)
		component_parts += new /obj/item/weapon/reagent_containers/glass/beaker(src)
		component_parts += new /obj/item/weapon/reagent_containers/glass/beaker(src)
		atom_flags += ATOM_FLAG_OPEN_CONTAINER
	RefreshParts()

	files = new /datum/research(src) //Setup the research data holder.

	update_categories()
	return

/obj/machinery/fabricator/Process()
	..()
	if(stat)
		return
	if(busy)
		use_power = 2
		progress += speed
		check_build()
	else
		use_power = 1
	update_icon()

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
		eject_materials(f, -1)
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
	data["name"] = name
	data["queue"] = get_queue_names()
	data["buildable"] = get_build_options()
	data["category"] = category
	data["categories"] = categories
	data["materials"] = get_materials()
	data["has_reagents"] = has_reagents
	data["reagents"] = get_reagents()
	data["maxres"] = res_max_amount
	data["sync"] = sync_message
	if(current)
		data["builtperc"] = round((progress / current.time) * 100)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "fabricator.tmpl", "[name] UI", 800, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/fabricator/Topic(href, href_list)
	if(..())
		return

	if(href_list["build"])
		add_to_queue(text2num(href_list["build"]))

	if(href_list["remove"])
		remove_from_queue(text2num(href_list["remove"]))

	if(href_list["category"])
		if(href_list["category"] in categories)
			category = href_list["category"]

	if(href_list["eject"])
		eject_materials(href_list["eject"], text2num(href_list["amount"]))

	if(href_list["sync"])
		sync()
	else
		sync_message = ""

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

	if(!istype(I, /obj/item/stack/material))
		return ..()

	var/obj/item/stack/material/stack = I
	var/material = stack.material.name
	var/stack_singular = "[stack.material.use_name] [stack.material.sheet_singular_name]" // eg "steel sheet", "wood plank"
	var/stack_plural = "[stack.material.use_name] [stack.material.sheet_plural_name]" // eg "steel sheets", "wood planks"
	var/amnt = stack.perunit

	if(!(material in materials))
		to_chat(user, "<span class=warning>\The [src] does not accept [stack_plural]!</span>")
		return

	if(materials[material] + amnt <= res_max_amount)
		if(stack && stack.amount >= 1)
			var/count = 0
			if(metal_load_anim)
				overlays += "fab-load-[material]"
				spawn(10)
					overlays -= "fab-load-[material]"
			while(materials[material] + amnt <= res_max_amount && stack.amount >= 1)
				materials[material] += amnt
				stack.use(1)
				count++
			to_chat(user, "You insert [count] [count == 1 ? stack_singular : stack_plural] into the fabricator.")// 0 steel sheets, 1 steel sheet, 2 steel sheets, etc
	else
		to_chat(user, "The fabricator cannot hold more [stack_plural].")// use the plural form even if the given sheet is singular

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

/obj/machinery/fabricator/proc/add_to_queue(var/index)
	var/datum/design/D = files.known_designs[index]
	queue += D
	update_busy()

/obj/machinery/fabricator/proc/remove_from_queue(var/index)
	if(index == 1)
		progress = 0
	queue.Cut(index, index + 1)
	update_busy()

/obj/machinery/fabricator/proc/can_build(var/datum/design/D)
	for(var/M in D.materials)
		if(materials[M] <= D.materials[M] * mat_efficiency)
			return 0
	for(var/C in D.chemicals)
		if(!reagents.has_reagent(C, D.chemicals[C] * mat_efficiency))
			return 0
	return 1

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
		var/obj/new_item = D.Fabricate(loc, src)
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
	for(var/i = 1 to files.known_designs.len)
		var/datum/design/D = files.known_designs[i]
		if(islist(D.build_type))
			if(!D.build_path || !(build_type in D.build_type))
				continue
		else
			if(!D.build_path || !(D.build_type && D.build_type == build_type))
				continue
		. += list(list("name" = D.name, "id" = i, "category" = D.category, "resources" = get_design_resources(D), "time" = get_design_time(D)))

/obj/machinery/fabricator/proc/CallReagentName(var/reagent_type)
	var/datum/reagent/R = reagent_type
	return ispath(reagent_type, /datum/reagent) ? initial(R.name) : "Unknown"

/obj/machinery/fabricator/proc/get_design_resources(var/datum/design/D)
	var/list/F = list()
	for(var/T in D.materials)
		F += "[capitalize(T)]: [D.materials[T] * mat_efficiency]"
	for(var/R in D.chemicals)
		F += "[CallReagentName(R)]: [D.chemicals[R] * mat_efficiency]"
	return english_list(F, and_text = ", ")

/obj/machinery/fabricator/proc/get_design_time(var/datum/design/D)
	return time2text(round(10 * D.time / speed), "mm:ss")

/obj/machinery/fabricator/proc/update_categories()
	categories = list()
	if(files)
		var/list/design_materials = list()
		for(var/datum/design/D in files.known_designs)
			if(islist(D.build_type))
				if(!D.build_path || !(build_type in D.build_type))
					continue
			else
				if(!D.build_path || !(D.build_type && D.build_type == build_type))
					continue
			categories |= D.category

			for(var/material in D.materials) // Iterating over the Designs' materials so that we know what should be able to be inserted
				design_materials |= material
				design_materials[material] = 0 // Prevents material count from appearing as null instead of 0

		for(var/material in materials)
			if(!(material in design_materials))
				eject_materials(material, -1) // Dump all the materials not used in designs so that players don't use materials on code changes.

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
	var/recursive = amount == -1 ? 1 : 0
	material = lowertext(material)
	var/material/M = SSmaterials.get_material_by_name(material)
	var/stacktype = M.stack_type

	if(!stacktype)
		log_error("Unable to create stack type for material '[material]'")
		return

	var/obj/item/stack/material/S = new stacktype(loc)
	if(amount <= 0)
		amount = S.max_amount
	var/ejected = min(round(materials[material] / S.perunit), amount)
	S.amount = min(ejected, amount)
	if(S.amount <= 0)
		qdel(S)
		return
	materials[material] -= ejected * S.perunit
	if(recursive && materials[material] >= S.perunit)
		eject_materials(material, -1)
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
