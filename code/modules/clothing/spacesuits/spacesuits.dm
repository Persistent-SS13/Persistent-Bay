//Civilian Softsuit
//Note: Everything in modules/clothing/spacesuits should have the entire suit grouped together.
//      Meaning the the suit is defined directly after the corrisponding helmet. Just like below!

/obj/item/clothing/head/helmet/space
	name = "Space helmet"
	icon = 'icons/obj/clothing/obj_head.dmi'
	icon_state = "space"
	desc = "A flimsy helmet designed for work in a hazardous, low-pressure environment."
	item_flags = ITEM_FLAG_STOPPRESSUREDAMAGE | ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_AIRTIGHT
	flags_inv = BLOCKHAIR
	item_icons = list(slot_head_str = 'icons/mob/onmob/onmob_head.dmi')
	item_state_slots = list(
		slot_l_hand_str = "s_helmet",
		slot_r_hand_str = "s_helmet",
		)
	permeability_coefficient = 0
	armor  = list(
		DAM_BLUNT 	= 10,
		DAM_PIERCE 	= 5,
		DAM_CUT 	= 5,
		DAM_BULLET 	= 5,
		DAM_LASER 	= 2,
		DAM_ENERGY 	= 10,
		DAM_BURN 	= 5,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 0,
		DAM_BIO 	= 100,
		DAM_RADS 	= 10,
		DAM_STUN 	= 0)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.9
	center_of_mass = null
	randpixel = 0
	species_restricted = list("exclude", SPECIES_NABBER, "Xenophage")
	flash_protection = FLASH_PROTECTION_MAJOR

	var/obj/machinery/camera/camera

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 0.8
	on = 0

	var/tinted = null	//Set to non-null for toggleable tint helmets

/obj/item/clothing/head/helmet/space/Destroy()
	if(camera && !ispath(camera))
		QDEL_NULL(camera)
	. = ..()

/obj/item/clothing/head/helmet/space/Initialize()
	. = ..()
	if(camera)
		verbs += /obj/item/clothing/head/helmet/space/proc/toggle_camera
	if(!isnull(tinted))
		verbs += /obj/item/clothing/head/helmet/space/proc/toggle_tint
		update_tint()

/obj/item/clothing/head/helmet/space/proc/toggle_camera()
	set name = "Toggle Helmet Camera"
	set category = "Object"
	set src in usr

	if(ispath(camera))
		camera = new camera(src)
		camera.set_status(0)

	if(camera)
		camera.set_status(!camera.status)
		if(camera.status)
			camera.c_tag = FindNameFromID(usr)
			to_chat(usr, "<span class='notice'>User scanned as [camera.c_tag]. Camera activated.</span>")
		else
			to_chat(usr, "<span class='notice'>Camera deactivated.</span>")

/obj/item/clothing/head/helmet/space/examine(var/mob/user)
	if(..(user, 1) && camera)
		to_chat(user, "This helmet has a built-in camera. Its [!ispath(camera) && camera.status ? "" : "in"]active.")

/obj/item/clothing/head/helmet/space/proc/update_tint()
	if(tinted)
		icon_state = "[initial(icon_state)]_dark"
		flash_protection = FLASH_PROTECTION_MAJOR
		flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	else
		icon_state = initial(icon_state)
		flash_protection = FLASH_PROTECTION_NONE
		flags_inv = HIDEEARS|BLOCKHAIR
	update_icon()
	update_clothing_icon()

/obj/item/clothing/head/helmet/space/proc/toggle_tint()
	set name = "Toggle Helmet Tint"
	set category = "Object"
	set src in usr

	var/mob/user = usr
	if(istype(user) && user.incapacitated())
		return

	tinted = !tinted
	to_chat(usr, "You toggle [src]'s visor tint.")
	update_tint()

/obj/item/clothing/suit/space
	name = "EVA softsuit"
	desc = "Your average general use softsuit. Though lacking in protection that modern voidsuits give, its cheap cost and portable size makes it perfect for those still getting used to life on the frontier."
	icon = 'icons/obj/clothing/obj_suit.dmi'
	icon_state = "space"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/onmob/items/lefthand_spacesuits.dmi',
		slot_wear_suit_str = 'icons/mob/onmob/onmob_suit.dmi',
		slot_r_hand_str = 'icons/mob/onmob/items/righthand_spacesuits.dmi',
		)
	item_state_slots = list(
		slot_l_hand_str = "s_suit",
		slot_r_hand_str = "s_suit",
	)
	w_class = ITEM_SIZE_LARGE//large item
	gas_transfer_coefficient = 0
	permeability_coefficient = 0
	item_flags = ITEM_FLAG_STOPPRESSUREDAMAGE | ITEM_FLAG_THICKMATERIAL
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency,/obj/item/device/suit_cooling_unit)
	armor  = list(
		DAM_BLUNT 	= 10,
		DAM_PIERCE 	= 5,
		DAM_CUT 	= 5,
		DAM_BULLET 	= 5,
		DAM_LASER 	= 2,
		DAM_ENERGY 	= 10,
		DAM_BURN 	= 5,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 0,
		DAM_BIO 	= 100,
		DAM_RADS 	= 10,
		DAM_STUN 	= 0)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.9
	center_of_mass = null
	randpixel = 0
	species_restricted = list("exclude", SPECIES_NABBER, "Xenophage")
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)

/obj/item/clothing/suit/space/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 1
