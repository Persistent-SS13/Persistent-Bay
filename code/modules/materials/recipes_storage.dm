
/datum/stack_recipe/box/box
	title = "box"
	result_type = /obj/item/weapon/storage/box

/datum/stack_recipe/box/large
	title = "large box"
	result_type = /obj/item/weapon/storage/box/large
	req_amount = 2

/datum/stack_recipe/box/donut
	title = "donut box"
	result_type = /obj/item/weapon/storage/box/donut/empty

/datum/stack_recipe/box/egg
	title = "egg box"
	result_type = /obj/item/weapon/storage/fancy/egg_box/empty

/datum/stack_recipe/box/light_tubes
	title = "light tubes box"
	result_type = /obj/item/weapon/storage/box/lights/tubes/empty

/datum/stack_recipe/box/light_bulbs
	title = "light bulbs box"
	result_type = /obj/item/weapon/storage/box/lights/bulbs/empty

/datum/stack_recipe/box/mouse_traps
	title = "mouse traps box"
	result_type = /obj/item/weapon/storage/box/mousetraps/empty

/datum/stack_recipe/box/pizza
	title = "pizza box"
	result_type = /obj/item/pizzabox

/datum/stack_recipe/box/cigs
	title = "cigarette carton"
	result_type = 	/obj/item/weapon/storage/box/cigarettes
	req_amount = 4

/datum/stack_recipe/box/vials
	title = "vial box"
	result_type = /obj/item/weapon/storage/fancy/vials/empty
	req_amount = 5

/datum/stack_recipe/bag
	title = "bag"
	result_type = /obj/item/weapon/storage/bag/plasticbag
	req_amount = 3
	on_floor = 1

/datum/stack_recipe/folder
	title = "folder"
	result_type = /obj/item/weapon/folder
	var/modifier = "grey"

/datum/stack_recipe/folder/display_name()
	return "[modifier] [title]"

/datum/stack_recipe/folder/normal

#define COLORED_FOLDER(color) /datum/stack_recipe/folder/##color{\
	result_type = /obj/item/weapon/folder/##color;\
	modifier = #color\
	}
COLORED_FOLDER(blue)
COLORED_FOLDER(red)
COLORED_FOLDER(white)
COLORED_FOLDER(yellow)
#undef COLORED_FOLDER


/datum/stack_recipe/storage/wall_safe_frame
	title = "wall safe frame"
	result_type = /obj/item/frame/wall_safe
	req_amount = 15
	time = 75

/datum/stack_recipe/storage/item_safe
	title = "item safe"
	result_type = /obj/structure/safe
	req_amount = 10
	time = 50
	one_per_turf = 1
	on_floor = 1

/datum/stack_recipe/storage/trash_bin
	title = "trash bin" 
	result_type = /obj/structure/closet/crate/bin
	req_amount = 5
	time = 50
	one_per_turf = 1
	on_floor = 1

/datum/stack_recipe/storage/tank_dispenser
	title = "tank dispenser" 
	result_type = /obj/structure/dispenser/empty
	req_amount = 5
	time = 25
	one_per_turf = 1
	on_floor = 1

/datum/stack_recipe/storage/filing_cabinet
	title = "filing cabinet" 
	result_type = /obj/structure/filingcabinet
	req_amount = 3
	time = 25
	one_per_turf = 1
	on_floor = 1

/datum/stack_recipe/storage/chest_drawer
	title = "chest drawer"
	result_type = /obj/structure/filingcabinet/chestdrawer
	req_amount = 3
	time = 25
	one_per_turf = 1
	on_floor = 1

/datum/stack_recipe/storage/wall
	title = "wall mounted closet"
	result_type = /obj/item/frame/general_closet
	req_amount = 5
	time = 5 SECONDS
	one_per_turf = 0
	on_floor = 0
/datum/stack_recipe/storage/wall/aid
	title = "wall mounted first aid closet"
	result_type = /obj/item/frame/medical_closet
/datum/stack_recipe/storage/wall/fire
	title = "wall mounted fire-safety closet"
	result_type = /obj/item/frame/hydrant_closet
/datum/stack_recipe/storage/wall/cargo
	title = "wall mounted supplies closet"
	result_type = /obj/item/frame/shipping_closet

/datum/stack_recipe/storage/wall/extinguisher_cabinet
	title = "extinguisher cabinet"
	result_type = /obj/item/frame/extinguisher_cabinet

/datum/stack_recipe/storage/shipping_crate
	title = "Wooden shipping crate"
	result_type = /obj/structure/largecrate
	req_amount = 5
	time = 30
	one_per_turf = 1
	on_floor = 1
	difficulty = 0
