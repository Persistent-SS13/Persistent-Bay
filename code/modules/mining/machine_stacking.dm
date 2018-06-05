/**********************Mineral stacking unit**************************/
/obj/machinery/mineral/stacking_machine
	name = "stacking machine"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "stacker"
	density = 1
	anchored = 1.0
	var/obj/machinery/mineral/stacking_unit_console/console
	var/list/stack_storage[0]
	var/list/stack_paths[0]
	var/stack_amt = 50; // Amount to stack before releassing

/obj/machinery/mineral/stacking_machine/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/stacking_machine(src)
	component_parts += new /obj/item/stack/material/steel(src)
	component_parts += new /obj/item/stack/material/steel(src)
	component_parts += new /obj/item/stack/material/steel(src)
	component_parts += new /obj/item/stack/material/steel(src)
	component_parts += new /obj/item/stack/material/steel(src)
	RefreshParts()


	for(var/stacktype in subtypesof(/obj/item/stack/material))
		var/obj/item/stack/S = stacktype
		var/stack_name = initial(S.name)
		stack_storage[stack_name] = 0
		stack_paths[stack_name] = stacktype

	stack_storage["glass"] = 0
	stack_paths["glass"] = /obj/item/stack/material/glass
	stack_storage[DEFAULT_WALL_MATERIAL] = 0
	stack_paths[DEFAULT_WALL_MATERIAL] = /obj/item/stack/material/steel	//HAHAHA
	stack_storage["plasteel"] = 0
	stack_paths["plasteel"] = /obj/item/stack/material/plasteel
	return

/obj/machinery/mineral/stacking_machine/attackby(var/obj/O as obj, var/mob/user as mob)
	if(default_deconstruction_screwdriver(user, O))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	..()

/obj/machinery/mineral/stacking_machine/Bumped(var/atom/movable/A)
	var/obj/item/stack/material/M = A
	if(!istype(M) || isnull(stack_storage[initial(M.name)]))
		A.forceMove(get_step(loc, dir))
	else
		stack_storage[initial(M.name)] += M.amount
		qdel(M)

	for(var/sheet in stack_storage)
		if(stack_storage[sheet] >= stack_amt)
			var/stacktype = stack_paths[sheet]
			var/obj/item/stack/material/S = new stacktype (get_step(loc, dir))
			S.amount = stack_amt
			stack_storage[sheet] -= stack_amt
	updateUsrDialog()
	return

/**********************Mineral stacking unit console**************************/
/obj/machinery/mineral/stacking_machine/attack_hand(mob/user)
	add_fingerprint(user)
	interact(user)

/obj/machinery/mineral/stacking_machine/interact(mob/user)
	user.set_machine(src)
	var/dat = text("<h1>Stacking unit console</h1>")
	dat += "<hr>Output direction: <a href='?src=\ref[src];setdir=1'>[dir2text(dir)]</a>"
	dat += "<hr><table>"
	for(var/stacktype in stack_storage)
		if(stack_storage[stacktype] > 0)
			dat += "<tr><td width = 150><b>[capitalize(stacktype)]:</b></td><td width = 30>[stack_storage[stacktype]]</td><td width = 50><A href='?src=\ref[src];release_stack=[stacktype]'>\[release\]</a></td></tr>"

	dat += "</table><hr>"
	dat += text("<br>Stacking: [stack_amt] <A href='?src=\ref[src];change_stack=1'>\[change\]</a><br><br>")
	var/datum/browser/popup = new(usr, "console_stacking_machine", "Stacking Machine Console")
	popup.set_content(jointext(dat, null))
	popup.open()
	onclose(user, "console_stacking_machine")


/obj/machinery/mineral/stacking_machine/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["setdir"])
		dir = angle2dir(dir2angle(dir) + 45)

	if(href_list["change_stack"])
		var/choice = input("What would you like to set the stack amount to?") as null|anything in list(1,5,10,20,50)
		if(!choice) return
		stack_amt = choice

	if(href_list["release_stack"])
		if(stack_storage[href_list["release_stack"]] > 0)
			var/stacktype = stack_paths[href_list["release_stack"]]
			var/obj/item/stack/material/S = new stacktype (get_step(loc, dir))
			S.amount = stack_storage[href_list["release_stack"]]
			stack_storage[href_list["release_stack"]] = 0

	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return
