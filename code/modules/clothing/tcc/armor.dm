#define TCC_OVERRIDE 'code/modules/clothing/tcc/icons/tcc.dmi'
#define ITEM_INHAND 'code/modules/clothing/tcc/icons/tcc_items.dmi'

/obj/item/clothing/head/armor/bulletproof/light/tcclight/helmet
	name = "TCC Augmetic Helmet"
	desc = "A suit of armor with heavy plates to protect against ballistic projectiles. Looks like it might impair movement."
	icon = ITEM_INHAND
	icon_override = TCC_OVERRIDE
	icon_state = "tcchelmet"
	item_state = "tcchelmet"
	w_class = ITEM_SIZE_NORMAL
	body_parts_covered = HEAD
	slot_flags = SLOT_HEAD
	flags_inv = HIDEEARS|HIDEMASK
	armor  = list(
		DAM_BLUNT 	= 65,
		DAM_PIERCE 	= 60,
		DAM_CUT 	= 65,
		DAM_BULLET 	= 80,
		DAM_LASER 	= 40,
		DAM_ENERGY 	= 40,
		DAM_BURN 	= 10,
		DAM_BOMB 	= 25,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0.5)
	siemens_coefficient = 0.7

/obj/item/clothing/feet/armor/bulletproof/tcc/tcc/boots
	name = "TCC Combat Boots"
	desc = "A suit of armor with heavy plates to protect against ballistic projectiles. Looks like it might impair movement."
	icon = ITEM_INHAND
	icon_override = TCC_OVERRIDE
	icon_state = "tccboots"
	item_state = "tccboots"
	w_class = ITEM_SIZE_NORMAL
	body_parts_covered = LEGS|FEET
	slot_flags = SLOT_FEET
	armor  = list(
		DAM_BLUNT 	= 65,
		DAM_PIERCE 	= 60,
		DAM_CUT 	= 65,
		DAM_BULLET 	= 80,
		DAM_LASER 	= 40,
		DAM_ENERGY 	= 40,
		DAM_BURN 	= 10,
		DAM_BOMB 	= 45,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0.5)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/armor/bulletproof/light/tcclight
	name = "TCC Light Ballistic Vest"
	desc = "A vest of armor with light kevlar plate to protect against ballistic projectiles. Looks like it might impair movement."
	icon = ITEM_INHAND
	icon_override = TCC_OVERRIDE
	icon_state = "tcclightarmor"
	item_state = "tcclightarmor"
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)
	w_class = ITEM_SIZE_NORMAL
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	armor  = list(
		DAM_BLUNT 	= 65,
		DAM_PIERCE 	= 60,
		DAM_CUT 	= 65,
		DAM_BULLET 	= 80,
		DAM_LASER 	= 50,
		DAM_ENERGY 	= 50,
		DAM_BURN 	= 10,
		DAM_BOMB 	= 45,
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
	icon = ITEM_INHAND
	icon_override = TCC_OVERRIDE
	icon_state = "tccmediumarmor"
	item_state = "tccmediumarmor"
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)
	w_class = ITEM_SIZE_LARGE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	armor  = list(
		DAM_BLUNT 	= 75,
		DAM_PIERCE 	= 70,
		DAM_CUT 	= 75,
		DAM_BULLET 	= 90,
		DAM_LASER 	= 70,
		DAM_ENERGY 	= 60,
		DAM_BURN 	= 15,
		DAM_BOMB 	= 50,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 2)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/armor/bulletproof/medium/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 0.5

/obj/item/clothing/suit/armor/bulletproof/heavy/tccheavy
	name = "TCC Heavy Ballistic Vest"
	desc = "A vest of armor with heavy kevlar plate to protect against ballistic projectiles. Looks like it might impair movement."
	icon = ITEM_INHAND
	icon_override = TCC_OVERRIDE
	icon_state = "tccheavyarmor"
	item_state = "tccheavyarmor"
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)
	w_class = ITEM_SIZE_HUGE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	armor  = list(
		DAM_BLUNT 	= 80,
		DAM_PIERCE 	= 75,
		DAM_CUT 	= 80,
		DAM_BULLET 	= 95,
		DAM_LASER 	= 75,
		DAM_ENERGY 	= 65,
		DAM_BURN 	= 20,
		DAM_BOMB 	= 55,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 3)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/armor/bulletproof/heavy/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 1

/obj/item/clothing/suit/armor/bulletproof/hazmat/biohazard
	name = "TCC Armored Hazmat Suit"
	desc = "A suit of armor with heavy plates to protect against ballistic projectiles. Looks like it might impair movement."
	icon = ITEM_INHAND
	icon_override = TCC_OVERRIDE
	icon_state = "swatsuit"
	item_state = "swatsuit"
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)
	w_class = ITEM_SIZE_LARGE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor  = list(
		DAM_BLUNT 	= 60,
		DAM_PIERCE 	= 55,
		DAM_CUT 	= 60,
		DAM_BULLET 	= 70,
		DAM_LASER 	= 45,
		DAM_ENERGY 	= 30,
		DAM_BURN 	= 30,
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