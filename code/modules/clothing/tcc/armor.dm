/obj/item/clothing/suit/armor/bulletproof/light/tcclight/helmet
	name = "TCC Augmetic Helmet"
	desc = "A suit of armor with heavy plates to protect against ballistic projectiles. Looks like it might impair movement."
	icon_state = "tcchelmet"
	item_state = "tcchelmet"
	w_class = ITEM_SIZE_NORMAL
	body_parts_covered = HEAD
	flags_inv = HIDEEARS|BLOCKHEADHAIR
	armor  = list(
		DAM_BLUNT 	= 45,
		DAM_PIERCE 	= 40,
		DAM_CUT 	= 45,
		DAM_BULLET 	= 75,
		DAM_LASER 	= 40,
		DAM_ENERGY 	= 10,
		DAM_BURN 	= 10,
		DAM_BOMB 	= 25,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 2)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/armor/bulletproof/tcc/tcc/boots
	name = "TCC Combat Boots"
	desc = "A suit of armor with heavy plates to protect against ballistic projectiles. Looks like it might impair movement."
	icon_state = "tccboots"
	item_state = "tccboots"
	w_class = ITEM_SIZE_NORMAL
	body_parts_covered = LEGS|FEET
	armor  = list(
		DAM_BLUNT 	= 45,
		DAM_PIERCE 	= 40,
		DAM_CUT 	= 45,
		DAM_BULLET 	= 75,
		DAM_LASER 	= 40,
		DAM_ENERGY 	= 10,
		DAM_BURN 	= 10,
		DAM_BOMB 	= 25,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 2)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/armor/bulletproof/light/tcclight
	name = "TCC Light Ballistic Vest"
	desc = "A vest of armor with light kevlar plate to protect against ballistic projectiles. Looks like it might impair movement."
	icon_state = "tcclightarmor"
	item_state = "tcclightarmor"
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)
	w_class = ITEM_SIZE_LARGE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	armor  = list(
		DAM_BLUNT 	= 35,
		DAM_PIERCE 	= 30,
		DAM_CUT 	= 35,
		DAM_BULLET 	= 65,
		DAM_LASER 	= 30,
		DAM_ENERGY 	= 5,
		DAM_BURN 	= 5,
		DAM_BOMB 	= 15,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 1)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/armor/bulletproof/light/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 0.2

/obj/item/clothing/suit/armor/bulletproof/medium/tccmedium
	name = "TCC Reinforced Ballistic Vest"
	desc = "A vest of armor with a moderately strong kevlar plate to protect against ballistic projectiles. Looks like it might impair movement."
	icon_state = "tccmediumarmor"
	item_state = "tccmediumarmor"
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)
	w_class = ITEM_SIZE_LARGE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	armor  = list(
		DAM_BLUNT 	= 45,
		DAM_PIERCE 	= 40,
		DAM_CUT 	= 45,
		DAM_BULLET 	= 75,
		DAM_LASER 	= 40,
		DAM_ENERGY 	= 10,
		DAM_BURN 	= 10,
		DAM_BOMB 	= 25,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 2)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/armor/bulletproof/medium/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 0.5

/obj/item/clothing/suit/armor/bulletproof/heavy/tccheavy
	name = "ballistic suit"
	desc = "A vest of armor with heavy kevlar plate to protect against ballistic projectiles. Looks like it might impair movement."
	icon_state = "tccheavy"
	item_state = "tccheavy"
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)
	w_class = ITEM_SIZE_LARGE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	armor  = list(
		DAM_BLUNT 	= 55,
		DAM_PIERCE 	= 50,
		DAM_CUT 	= 55,
		DAM_BULLET 	= 85,
		DAM_LASER 	= 50,
		DAM_ENERGY 	= 20,
		DAM_BURN 	= 20,
		DAM_BOMB 	= 35,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 3)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/armor/bulletproof/heavy/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 1

/obj/item/clothing/suit/armor/bulletproof/hazmat/biohazard
	name = "ballistic suit"
	desc = "A suit of armor with heavy plates to protect against ballistic projectiles. Looks like it might impair movement."
	icon_state = "swatsuit"
	item_state = "swatsuit"
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)
	w_class = ITEM_SIZE_LARGE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor  = list(
		DAM_BLUNT 	= 40,
		DAM_PIERCE 	= 35,
		DAM_CUT 	= 40,
		DAM_BULLET 	= 70,
		DAM_LASER 	= 35,
		DAM_ENERGY 	= 8,
		DAM_BURN 	= 8,
		DAM_BOMB 	= 20,
		DAM_EMP 	= 0,
		DAM_BIO 	= 100,
		DAM_RADS 	= 0,
		DAM_STUN 	= 2)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/armor/bulletproof/hazmat/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 1

///obj/item/clothing/suit/armor/raider/heavy
//	name = "ballistic suit"
//	desc = "A suit of armor with heavy plates to protect against ballistic projectiles. Looks like it might impair movement."
//	icon_state = "bulletproof"
//	//item_state = "swat_suit"
//	w_class = ITEM_SIZE_LARGE
//	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
//	armor  = list(
//		DAM_BLUNT 	= 50,
//		DAM_PIERCE 	= 45,
//		DAM_CUT 	= 50,
//		DAM_BULLET 	= 75,
//		DAM_LASER 	= 45,
//		DAM_ENERGY 	= 15,
//		DAM_BURN 	= 15,
//		DAM_BOMB 	= 30,
//		DAM_EMP 	= 0,
//		DAM_BIO 	= 0,
//		DAM_RADS 	= 0,
//		DAM_STUN 	= 2)
//	siemens_coefficient = 0.7
//
///obj/item/clothing/suit/armor/raider/heavy/New()
//	..()
//	slowdown_per_slot[slot_wear_suit] = 1