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
	title = "sink"
	result_type = /obj/structure/hygiene/sink
	req_amount = 5
	time = 4 SECONDS
	on_floor = 0
	difficulty = 2
	send_material_data = 1
	one_per_turf = 1
/datum/stack_recipe/sink/kitchen
	title = "kitchen sink"
	result_type = /obj/structure/hygiene/sink/kitchen

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

