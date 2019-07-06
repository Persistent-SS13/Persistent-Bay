/obj/machinery/autolathe
	name = "autolathe"
	desc = "It produces items using metal and glass."
	icon = 'icons/obj/machines/autolathe.dmi'
	icon_state = "autolathe"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 2000
	clicksound = "keyboard"
	clickvol = 30
	multiplier = 1
	circuit_type = /obj/item/weapon/circuitboard/autolathe

	var/list/machine_recipes
	var/list/stored_material = list(MATERIAL_STEEL = 0, MATERIAL_GLASS = 0)
	var/list/storage_capacity = 0
	var/show_category = "All"

	var/hacked = 0
	var/disabled = 0
	var/shocked = 0
	var/busy = 0

	var/mat_efficiency = 1
	var/build_time = 50

	var/datum/wires/autolathe/wires = null

/obj/machinery/autolathe/New()
	..()
	wires = new(src)
	ADD_SAVED_VAR(stored_material)
	ADD_SAVED_VAR(storage_capacity)
	ADD_SAVED_VAR(hacked)
	ADD_SAVED_VAR(disabled)
	ADD_SAVED_VAR(shocked)

/obj/machinery/autolathe/Destroy()
	QDEL_NULL(wires)
	return ..()

/obj/machinery/autolathe/proc/update_recipe_list()
	if(!machine_recipes)
		machine_recipes = autolathe_recipes

/obj/machinery/autolathe/interact(mob/user as mob)

	update_recipe_list()

	if(..() || (disabled && !panel_open))
		to_chat(user, "<span class='danger'>\The [src] is disabled!</span>")
		return

	if(shocked)
		shock(user, 50)

	var/dat = "<center><h1>Autolathe Control Panel</h1><hr/>"

	if(!disabled)
		dat += "<table width = '100%'>"
		var/material_top = "<tr>"
		var/material_bottom = "<tr>"

		for(var/material in stored_material)
			material_top += "<td width = '25%' align = center><b>[material]</b></td>"
			material_bottom += "<td width = '25%' align = center>[stored_material[material]]<b>/[storage_capacity]</b></td>"

		dat += "[material_top]</tr>[material_bottom]</tr></table><hr>"
		dat += GetMultiplierForm(src)
		dat += "<h2>Printable Designs</h2><h3>Showing: <a href='?src=\ref[src];change_category=1'>[show_category]</a>.</h3></center><table width = '100%'>"

		var/index = 0
		for(var/datum/autolathe/recipe/R in machine_recipes)
			index++
			if(R.hidden && !hacked || (show_category != "All" && show_category != R.category))
				continue
			var/can_make = 1
			var/material_string = ""
			var/multiplier_string = ""
			var/max_sheets
			var/comma
			if(!R.resources || !R.resources.len)
				material_string = "No resources required.</td>"
			else
				//Fucking stacks should never get a bonus due to having "REALLY good manipulators"
				var/actual_efficiency = 1
				if(!ispath(R.path, /obj/item/stack))
					actual_efficiency = mat_efficiency
				//Make sure it's buildable and list requires resources.
				for(var/material in R.resources)
					if(!stored_material[material])
						stored_material[material] = 0
					var/sheets = round(stored_material[material]/round(R.resources[material]*actual_efficiency*multiplier))
					if(isnull(max_sheets) || max_sheets > sheets)
						max_sheets = sheets
					if(stored_material[material] < round(R.resources[material]*actual_efficiency*multiplier))
						can_make = 0
					if(!comma)
						comma = 1
					else
						material_string += ", "
					material_string += "[round(R.resources[material] * actual_efficiency * multiplier)] [material]"
				material_string += ".<br></td>"
				//Build list of multipliers for sheets.
				if(R.is_stack)
					var/obj/item/stack/R_stack = R.path
					max_sheets = min(max_sheets, initial(R_stack.max_amount))
					//do not allow lathe to print more sheets than the max amount that can fit in one stack
					if(max_sheets && max_sheets > 0)
						multiplier_string  += "<br>"
						for(var/i = 5;i<max_sheets;i*=2) //5,10,20,40...
							multiplier_string  += "<a href='?src=\ref[src];make=[index];multiplier=[i]'>\[x[i]\]</a>"
						multiplier_string += "<a href='?src=\ref[src];make=[index];multiplier=[max_sheets]'>\[x[max_sheets]\]</a>"

			dat += "<tr><td width = 180>[R.hidden ? "<font color = 'red'>*</font>" : ""]<b>[can_make ? "<a href='?src=\ref[src];make=[index];multiplier=1'>" : ""][R.name][multiplier > 1 ? " x[multiplier]" : ""][can_make ? "</a>" : ""]</b>[R.hidden ? "<font color = 'red'>*</font>" : ""][multiplier_string]</td><td align = right>[material_string]</tr>"

		dat += "</table><hr>"
	//Hacking.
	if(panel_open)
		dat += "<h2>Maintenance Panel</h2>"
		dat += wires.GetInteractWindow()

		dat += "<hr>"

	var/datum/browser/popup = new(usr, "autolathe", "Autolathe Control Panel")
	popup.set_content(jointext(dat, null))
	popup.open()
	onclose(user, "autolathe")

/obj/machinery/autolathe/attackby(var/obj/item/O as obj, var/mob/user as mob)

	if(busy)
		to_chat(user, "<span class='notice'>\The [src] is busy. Please wait for completion of previous operation.</span>")
		return

	if(default_deconstruction_screwdriver(user, O))
		updateUsrDialog()
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return

	if(stat)
		return

	if(panel_open)
		//Don't eat multitools or wirecutters used on an open lathe.
		if(isMultitool(O) || isWirecutter(O))
			attack_hand(user)
			return

	if(O.loc != user && !(istype(O,/obj/item/stack)))
		return 0

	if(is_robot_module(O))
		return 0

	//Resources are being loaded.
	var/obj/item/eating = O

	var/list/taking_matter
	if(istype(eating, /obj/item/stack/material))
		var/obj/item/stack/material/mat = eating
		taking_matter = list()
		for(var/matname in eating.matter)
			taking_matter[matname] = Floor(eating.matter[matname]/mat.amount)
	else
		taking_matter = eating.matter

	var/found_useful_mat
	if(LAZYLEN(taking_matter))
		for(var/material in taking_matter)
			if(!isnull(stored_material[material])) //Checks if the matter is actually useable. Currently copper, steel, and glass.
				found_useful_mat = TRUE
				break

	if(!found_useful_mat)
		to_chat(user, "<span class='warning'>\The [eating] does not contain any accessible useful materials and cannot be accepted.</span>")
		return

	var/filltype = 0       // Used to determine message.
	var/total_used = 0     // Amount of material used.
	var/mass_per_sheet = 0 // Amount of material constituting one sheet.

	for(var/material in taking_matter)

		if(stored_material[material] >= storage_capacity)
			continue

		var/total_material = taking_matter[material]

		//If it's a stack, we eat multiple sheets.
		if(istype(eating,/obj/item/stack))
			var/obj/item/stack/stack = eating
			total_material *= stack.get_amount()

		if(stored_material[material] + total_material > storage_capacity)
			total_material = storage_capacity - stored_material[material]
			filltype = 1
		else
			filltype = 2

		stored_material[material] += total_material
		total_used += total_material
		mass_per_sheet += taking_matter[material]

	if(!filltype)
		to_chat(user, "<span class='notice'>\The [src] is full. Please remove material from the autolathe in order to insert more.</span>")
		return
	else if(filltype == 1)
		to_chat(user, "You fill \the [src] to capacity with \the [eating].")
	else
		to_chat(user, "You fill \the [src] with \the [eating].")

	flick("autolathe_o", src) // Plays metal insertion animation. Work out a good way to work out a fitting animation. ~Z

	if(istype(eating,/obj/item/stack))
		var/obj/item/stack/stack = eating
		stack.use(max(1, round(total_used/mass_per_sheet))) // Always use at least 1 to prevent infinite materials.
	else if(user.unEquip(O))
		O.loc = null
		qdel(O)

	updateUsrDialog()

/obj/machinery/autolathe/attack_hand(mob/user as mob)
	user.set_machine(src)
	interact(user)

/obj/machinery/autolathe/Topic(href, href_list)

	if(..())
		return

	usr.set_machine(src)
	add_fingerprint(usr)

	if(busy)
		to_chat(usr, "<span class='notice'>The autolathe is busy. Please wait for completion of previous operation.</span>")
		return

	if(ProcessMultiplierForm(src, href_list))
		src.updateUsrDialog()
		return

	if(href_list["change_category"])

		var/choice = input("Which category do you wish to display?") as null|anything in autolathe_categories+"All"
		if(!choice) return
		show_category = choice

	if(href_list["make"] && machine_recipes)

		var/index = text2num(href_list["make"])
		var/stack_multiplier = text2num(href_list["multiplier"])
		var/datum/autolathe/recipe/making

		if(index > 0 && index <= machine_recipes.len)
			making = machine_recipes[index]

		//Exploit detection, not sure if necessary after rewrite.
		//Not necessary, loop breaks if you can't afford shit
		//if(!making || stack_multiplier < 0 || stack_multiplier > 100)
		//	var/turf/exploit_loc = get_turf(usr)
		//	message_admins("[key_name_admin(usr)] tried to exploit an autolathe to duplicate an item! ([exploit_loc ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[exploit_loc.x];Y=[exploit_loc.y];Z=[exploit_loc.z]'>JMP</a>" : "null"])", 0)
		//	log_admin("EXPLOIT : [key_name(usr)] tried to exploit an autolathe to duplicate an item!")
		//	return

		var/mult = multiplier
		//Fucking stacks should never get a bonus due to having "REALLY good manipulators"
		var/actual_efficiency = 1
		if(!istype(making.path, /obj/item/stack))
			actual_efficiency = mat_efficiency
		busy = 1
		update_use_power(2)
		var/longest_spawn = 0
		for(var/i = 0, i < mult, i++)
			//Check if we still have the materials.
			var/break_mult = 0
			for(var/material in making.resources)
				if(!isnull(stored_material[material]))
					if(stored_material[material] < round(making.resources[material] * actual_efficiency) * stack_multiplier)
						break_mult = 1
						break
			if(break_mult)
				break
			longest_spawn = build_time + (build_time * i)
			//Consume materials.
			for(var/material in making.resources)
				if(!isnull(stored_material[material]))
					stored_material[material] = max(0, stored_material[material] - round(making.resources[material] * actual_efficiency) * stack_multiplier)

			spawn(longest_spawn)
				//Sanity check.
				if(!src) return
				//Create the desired item.
				var/obj/item/I = new making.path(loc)
				if(istype(I, /obj/item/stack))
					var/obj/item/stack/S = I
					if(stack_multiplier > 1)
						S.amount = stack_multiplier
						S.update_icon()
					for(var/material in I.matter) //Time to prevent free materials at higher levels, 0.8 cost multiplier + 0.9 gain multiplier hmmmm yumyum spicey
						S.matter[material] = round(S.matter[material] * actual_efficiency)

					S.update_strings() //Updates matter values for material strings.

				//Fancy autolathe animation.
				flick("autolathe_n", src)
		spawn(longest_spawn)
			busy = 0
			update_use_power(1)

	updateUsrDialog()

/obj/machinery/autolathe/update_icon()
	icon_state = (panel_open ? "autolathe_t" : "autolathe")

//Updates overall lathe storage size.
/obj/machinery/autolathe/RefreshParts()
	..()
	var/mb_rating = 0
	var/man_rating = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/MB in component_parts)
		mb_rating += MB.rating
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		man_rating += M.rating

	storage_capacity = mb_rating * 15 SHEETS
	build_time = 45 / man_rating
	mat_efficiency = 1.1 - man_rating * 0.1	//You get a slight discount on items with better parts, also affects the recycling penalty of the autolathe (AKA use the recycler)

/obj/machinery/autolathe/dismantle()
	for(var/mat in stored_material)
		var/material/M = SSmaterials.get_material_by_name(mat)
		if(!istype(M))
			continue
		var/obj/item/stack/material/S = M.place_sheet(get_turf(src), 1, M.name)
		if(stored_material[mat] > ONE_SHEET)
			S.set_amount(round(stored_material[mat] / ONE_SHEET))
		else
			qdel(S)
	..()
	return 1