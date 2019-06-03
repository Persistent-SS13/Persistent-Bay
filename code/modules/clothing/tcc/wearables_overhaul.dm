/obj/item/clothing/suit
	name = "Generic Suit"
	armor = list(
		DAM_BLUNT 	= 3,
		DAM_PIERCE 	= 3,
		DAM_CUT 	= 3,
		DAM_BULLET 	= 3,
		DAM_LASER 	= 3,
		DAM_ENERGY 	= 3,
		DAM_BURN 	= 3,
		DAM_BOMB 	= 3,
		DAM_EMP 	= 0,
		DAM_PAIN	= 3,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)

/obj/item/clothing/head/armor
	name = "Generic Helmet"
	armor = list(
		DAM_PAIN	= 4)

/obj/item/clothing/feet/armor
	name = "Generic Armored Boots"
	armor = list(
		DAM_PAIN	= 4)

/obj/item/clothing/suit/armor
	name = "Generic Armor"
	armor = list(
		DAM_PAIN	= 2)

/obj/item/clothing/suit/armor/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 0.2

obj/item/clothing/suit/armor/bulletproof
	name = "Generic Bulletproof Armor"
	armor  = list(
		DAM_BLUNT 	= 65,
		DAM_PIERCE 	= 60,
		DAM_CUT 	= 65,
		DAM_BULLET 	= 80,
		DAM_LASER 	= 50,
		DAM_ENERGY 	= 40,
		DAM_BURN 	= 10,
		DAM_BOMB 	= 40,
		DAM_EMP 	= 0,
		DAM_PAIN	= 2,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 2)

/obj/item/clothing/suit/armor/bulletproof/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 0.4

obj/item/clothing/suit/armor/ablative
	name = "Generic Ablative Armor"
	armor  = list(
		DAM_BLUNT 	= 45,
		DAM_PIERCE 	= 40,
		DAM_CUT 	= 45,
		DAM_BULLET 	= 60,
		DAM_LASER 	= 80,
		DAM_ENERGY 	= 80,
		DAM_BURN 	= 10,
		DAM_BOMB 	= 20,
		DAM_EMP 	= 0,
		DAM_PAIN	= 2,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 1)

/obj/item/clothing/suit/armor/ablative/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 0.4

/obj/item/clothing/suit/armor/riot
	name = "Generic Riot Armor"
	armor  = list(
		DAM_BLUNT 	= 80,
		DAM_PIERCE 	= 80,
		DAM_CUT 	= 80,
		DAM_BULLET 	= 40,
		DAM_LASER 	= 20,
		DAM_ENERGY 	= 20,
		DAM_BURN 	= 20,
		DAM_BOMB 	= 30,
		DAM_EMP 	= 0,
		DAM_PAIN	= 2,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 4)

/obj/item/clothing/suit/armor/riot/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 0.4