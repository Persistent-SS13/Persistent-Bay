/obj/item/clothing/under/syndicate
	name = "tactical turtleneck"
	desc = "It's some non-descript, slightly suspicious looking, civilian clothing."
	icon_state = "syndicate"
	item_state = "bl_suit"
	worn_state = "syndicate"
	has_sensor = 0
	gender_icons = 1
	armor  = list(
		DAM_BLUNT 	= 10,
		DAM_PIERCE 	= 5,
		DAM_CUT 	= 10,
		DAM_BULLET 	= 10,
		DAM_LASER 	= 10,
		DAM_ENERGY 	= 2,
		DAM_BURN 	= 2,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/syndicate/combat
	name = "combat turtleneck"
	desc = "The height of fashion and tactical utility."
	icon_state = "combat"
	item_state = "bl_suit"
	worn_state = "combat"
	gender_icons = 1
	has_sensor = SUIT_HAS_SENSORS

/obj/item/clothing/under/syndicate/tacticool
	name = "\improper Tacticool turtleneck"
	desc = "Just looking at it makes you want to buy an SKS, go into the woods, and -operate-."
	icon_state = "tactifool"
	item_state = "bl_suit"
	worn_state = "tactifool"
	armor  = list(
		DAM_BLUNT 	= 1,
		DAM_PIERCE 	= 1,
		DAM_CUT 	= 5,
		DAM_BULLET 	= 0,
		DAM_LASER 	= 0,
		DAM_ENERGY 	= 2,
		DAM_BURN 	= 2,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)
	siemens_coefficient = 1
	has_sensor = SUIT_HAS_SENSORS


