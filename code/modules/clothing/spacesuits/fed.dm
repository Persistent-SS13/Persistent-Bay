/obj/item/clothing/head/helmet/space/fed
	name = "ODST Helmet"
	desc = "Standard issue short-EVA capable helmet issued to ODST forces"
	item_state = "federation_helmet"
	icon_state = "federation_helmet"
	item_flags = STOPPRESSUREDAMAGE|THICKMATERIAL
	body_parts_covered = HEAD|FACE
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	armor = list(melee = 60, bullet = 35, laser = 25,energy = 25, bomb = 25, bio = 0, rad = 5)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4
	on = 0

/obj/item/clothing/suit/space/fed
	name = "\improper Federation Armor"
	desc = "Lightweight, durable armor issued to Federation soldiers for increased survivability in the field."
	icon_state = "federation_armor"
	blood_overlay_type = "armor"
	armor = list(melee = 55, bullet = 45, laser = 55, energy = 55, bomb = 45, bio = 30, rad = 25)
	item_flags = STOPPRESSUREDAMAGE|THICKMATERIAL
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

//Defines for armour subtypes//
/obj/item/clothing/suit/space/fed/medic
	name = "\improper Federation Medic Armour"
	icon_state = "federation_armor_medic"

/obj/item/clothing/head/helmet/space/fed/medic
	name = "\improper Federation Medic Helmet"
	item_state = "federation_helmet_medic"
	icon_state = "federation_helmet_medic"


/obj/item/clothing/head/helmet/space/fed/engineer
	name = "\improper Federation Engineer Helmet"

	item_state = "federation_helmet_engineer"
	icon_state = "federation_helmet_engineer"

/obj/item/clothing/suit/space/fed/engineer
	name = "\improper Federation Engineer Armour"
	icon_state = "federation_armor_engineer"


/obj/item/clothing/head/helmet/space/fed/squadleader
	name = "\improper Federation Squad Leader Helmet"
	item_state = "federation_helmet_squad_leader"
	icon_state = "federation_helmet_squad_leader"

/obj/item/clothing/suit/space/fed/squadleader
	name = "\improper Federation Squad Leader Armour"

	icon_state = "federation_armor_squad_leader"
