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

/datum/stack_recipe/urinal
	title = "urinal frame"
	result_type = /obj/item/frame/plastic/urinal
	req_amount = 6
	time = 5 SECONDS
	on_floor = 0
	difficulty = 2
	one_per_turf = 0

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
	difficulty = 1
	time = 20 SECONDS

/datum/stack_recipe/structure/weight_lifter
	title = "weight lifter"
	result_type = /obj/structure/fitness/weightlifter
	req_amount = 20
	time = 25 SECONDS
	one_per_turf = 1
	on_floor = 1
	difficulty = 3


/datum/stack_recipe/structure/conveyorbelt_assembly
	title = "conveyor belt assembly"
	result_type = /obj/item/conveyor_construct
	req_amount = 3
	time = 15
	one_per_turf = 1
	on_floor = 1
	difficulty = 3

/datum/stack_recipe/structure/conveyorbelt_switch
	title = "conveyor belt switch assembly"
	result_type = /obj/item/conveyor_switch_construct
	req_amount = 1
	time = 5
	one_per_turf = 1
	on_floor = 1
	difficulty = 3

/datum/stack_recipe/machinery/paper_shredder
	title = "paper shredder"
	result_type = /obj/machinery/papershredder
	req_amount = 5
	time = 25
	one_per_turf = 1
	on_floor = 1
	difficulty = 3

/datum/stack_recipe/structure/drain
	title = "floor drain"
	result_type = /obj/structure/drain
	req_amount = 5
	time = 3 SECONDS
	one_per_turf = 1
	on_floor = 1
	difficulty = 3

/datum/stack_recipe/button
	title = "button frame"
	result_type = /obj/item/frame/button
	req_amount = 2
	time = 5 SECONDS
	difficulty = 3
/datum/stack_recipe/button/door
	title = "door button frame"
	result_type = /obj/item/frame/button/door
/datum/stack_recipe/button/switch
	title = "switch button frame"
	result_type = /obj/item/frame/button/switch

/datum/stack_recipe/button/toggle
	title = "toggle button frame"
	result_type = /obj/item/frame/button/toggle
/datum/stack_recipe/button/toggle/door
	title = "door toggle button frame"
	result_type = /obj/item/frame/button/toggle/alernate
/datum/stack_recipe/button/toggle/switch
	title = "toggle switch frame"
	result_type = /obj/item/frame/button/toggle/switch
datum/stack_recipe/button/toggle/lever
	title = "toggle lever frame"
	result_type = /obj/item/frame/button/toggle/lever
datum/stack_recipe/button/toggle/lever/double
	title = "toggle double lever frame"
	result_type = /obj/item/frame/button/toggle/lever/double


/datum/stack_recipe/structure/meat_spike
	title = "meat spike frame"
	result_type = /obj/structure/kitchenspike_frame
	req_amount = 5
	time = 15 SECONDS
	on_floor = 1
	one_per_turf = 1
	difficulty = 1

/datum/stack_recipe/furniture/iv_drip
	title = "IV drip"
	result_type = /obj/machinery/iv_drip
	req_amount = 3
	time = 5 SECONDS
	on_floor = 1 
	one_per_turf = 1
	difficulty = 2

/datum/stack_recipe/furniture/rollerbed
	title = "roller bed"
	result_type = /obj/item/roller
	req_amount = 5
	time = 10 SECONDS
	difficulty = 2

/datum/stack_recipe/furniture/mirror
	title = "Wall mirror"
	result_type = /obj/item/frame/mirror
	req_amount = 2
	time = 20 SECONDS
	difficulty = 3

/datum/stack_recipe/furniture/punching_bag
	title = "Punching bag"
	result_type = /obj/structure/fitness/punchingbag
	req_amount = 5
	one_per_turf = 1
	on_floor = 1
	time = 15 SECONDS
	difficulty = 2

/datum/stack_recipe/furniture/bed/psychiatrist
	title = "psychiatrist couch"
	result_type = /obj/structure/bed/psych
	req_amount = 10
	time = 20 SECONDS
	one_per_turf = 1
	on_floor = 1
	difficulty = 3

/datum/stack_recipe/furniture/cabinet
	title = "cabinet"
	result_type = /obj/structure/closet/cabinet
	req_amount = 10
	time = 25 SECONDS
	one_per_turf = 1
	on_floor = 1
	difficulty = 3

/datum/stack_recipe/furniture/dog_bed
	title = "dog bed"
	result_type = /obj/structure/dogbed
	req_amount = 2
	time = 10
	one_per_turf = 1
	on_floor = 1
	difficulty = 1


