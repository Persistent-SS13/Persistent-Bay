//Furniture is in a separate file.

/datum/stack_recipe/ai_core
	title = "AI core"
	result_type = /obj/structure/AIcore
	req_amount = 4
	time = 50
	one_per_turf = 1
	difficulty = 2

/datum/stack_recipe/railing
	title = "railing"
	result_type = /obj/structure/railing
	req_amount = 3
	time = 40
	on_floor = 1
	difficulty = 2
	send_material_data = 1

/datum/stack_recipe/noticeboard
	title = "noticeboard"
	result_type = /obj/structure/noticeboard
	req_amount = 10
	time = 50
	on_floor = 1
	difficulty = 2

/datum/stack_recipe/stairs
	title = "stairs"
	result_type = /obj/structure/stairs
	req_amount = 20
	time = 10 SECONDS
	on_floor = 1
	difficulty = 2
	send_material_data = 1
	one_per_turf = 1
/datum/stack_recipe/stairs/can_make(mob/user)
	. = ..()
	if(!.)
		return .
	//Check if the upper Z-level has open space to place the stairs under
	var/turf/simulated/open/above = GetAbove(get_turf(user))
	if(!above)
		to_chat(user, SPAN_WARNING("The space above has to be open to place a stair here!"))
		return FALSE

/datum/stack_recipe/ladder
	title = "ladder"
	result_type = /obj/structure/ladder
	req_amount = 10
	time = 8 SECONDS
	on_floor = 1
	difficulty = 2
	send_material_data = 1
	one_per_turf = 1
/datum/stack_recipe/stairs/can_make(mob/user)
	. = ..()
	if(!.)
		return .
	//Check if the upper Z-level has open space to place the stairs under
	var/turf/simulated/open/above = GetAbove(get_turf(user))
	if(!above)
		to_chat(user, SPAN_WARNING("The space above has to be open to place a stair here!"))
		return FALSE

/datum/stack_recipe/morgue
	title = "morgue slab"
	result_type = /obj/structure/morgue
	req_amount = 10
	time = 5 SECONDS
	on_floor = 1
	difficulty = 2
	send_material_data = 1
	one_per_turf = 1

/datum/stack_recipe/sink
	title = "sink frame"
	result_type = /obj/item/frame/plastic/sink/
	req_amount = 5
	time = 4 SECONDS
	on_floor = 0
	difficulty = 2
	send_material_data = 1

/datum/stack_recipe/sink/kitchen
	title = "kitchen sink frame"
	result_type = /obj/item/frame/plastic/kitchensink

/datum/stack_recipe/shower
	title = "shower"
	result_type = /obj/structure/hygiene/shower
	req_amount = 6
	time = 5 SECONDS
	on_floor = 0
	difficulty = 2
	send_material_data = 1
	one_per_turf = 1

/datum/stack_recipe/toilet
	title = "toilet"
	result_type = /obj/structure/hygiene/toilet
	req_amount = 5
	time = 4 SECONDS
	on_floor = 1
	difficulty = 2
	send_material_data = 1
	one_per_turf = 1

/datum/stack_recipe/handrail
	title = "handrail"
	result_type = /obj/structure/handrai
	req_amount = 5
	time = 4 SECONDS
	on_floor = 1
	difficulty = 2
	send_material_data = 1

/datum/stack_recipe/fountain
	title = "fountain"
	result_type = /obj/structure/fountain/mundane
	req_amount = 20
	on_floor = 1
	difficulty = 2
	send_material_data = 1

/datum/stack_recipe/mopbucket
	title = "mop bucket"
	result_type = /obj/structure/mopbucket
	req_amount = 10
	on_floor = 1
	difficulty = 2

/datum/stack_recipe/anomaly_container
	title = "anomaly container"
	result_type = /obj/structure/anomaly_container
	req_amount = 10
	on_floor = 1
	one_per_turf = 1
	difficulty = 3
	time = 20 SECONDS

/datum/stack_recipe/orebox
	title = "ore box"
	result_type = /obj/structure/ore_box
	req_amount = 10
	on_floor = 1
	one_per_turf = 1
	difficulty = 3
	time = 20 SECONDS