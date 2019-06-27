/obj/machinery/mineral/stacking_machine
	name = "stacking machine"
	icon_state = "stacker"
	console = /obj/machinery/computer/mining
	input_turf =  EAST
	output_turf = WEST
	circuit_type = /obj/item/weapon/circuitboard/mining_stacker
	var/stack_amt = 50
	var/list/stacks

/obj/machinery/mineral/stacking_machine/New()
	..()
	ADD_SAVED_VAR(stack_amt)
	ADD_SAVED_VAR(stacks)

/obj/machinery/mineral/stacking_machine/Initialize()
	. = ..()
	if(!stacks)
		stacks = list()

/obj/machinery/mineral/stacking_machine/Process()
	if(input_turf)
		for(var/obj/item/I in input_turf)
			if(istype(I, /obj/item/stack/material))
				var/obj/item/stack/material/S = I
				if(S.material && S.material.stack_type)
					if(isnull(stacks[S.material.name]))
						stacks[S.material.name] = 0
					stacks[S.material.name] += S.amount
					qdel(S)
					continue
			if(output_turf)
				I.forceMove(output_turf)

	if(output_turf)
		for(var/sheet in stacks)
			if(stacks[sheet] >= stack_amt)
				var/material/stackmat = SSmaterials.get_material_by_name(sheet)
				stackmat.place_sheet(output_turf, stack_amt)
				stacks[sheet] -= stack_amt

/obj/machinery/mineral/stacking_machine/get_console_data()
	. = ..()
	. += "<h1>Sheet Stacking</h1>"
	. += "Stacking: [stack_amt] <A href='?src=\ref[src];change_stack=1'>\[change\]</a>"
	var/line = ""
	for(var/stacktype in stacks)
		if(stacks[stacktype] > 0)
			line += "<tr><td>[capitalize(stacktype)]</td><td>[stacks[stacktype]]</td><td><A href='?src=\ref[src];release_stack=[stacktype]'>Release.</a></td></tr>"
	. += "<table>[line]</table>"

/obj/machinery/mineral/stacking_machine/Topic(href, href_list)
	if((. = ..()))
		return
	if(href_list["change_stack"])
		. = set_stack_amount(input("What would you like to set the stack amount to?") as null|anything in list(1,5,10,20,50))
	else if(href_list["release_stack"] && stacks[href_list["release_stack"]] > 0)
		. = release_stack(href_list["release_stack"])
	if(. && console)
		console.updateUsrDialog()

/obj/machinery/mineral/stacking_machine/proc/set_stack_amount(var/samount)
	if(!samount)
		return FALSE
	stack_amt = samount
	return TRUE

/obj/machinery/mineral/stacking_machine/proc/release_stack(var/stackmatname)
	if(stackmatname && stacks[stackmatname] > 0)
		var/material/stackmat = SSmaterials.get_material_by_name(stackmatname)
		stackmat.place_sheet(output_turf, stacks[stackmatname])
		stacks[stackmatname] = 0
		return TRUE
	return FALSE