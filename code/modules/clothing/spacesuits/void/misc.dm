
/obj/item/clothing/suit/space/void/swat
	name = "\improper SWAT suit"
	desc = "A heavily armored suit that protects against moderate damage. Used in special operations."
	icon_state = "deathsquad"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/tank)
	armor  = list(
		DAM_BLUNT 	= 80,
		DAM_PIERCE 	= 70,
		DAM_CUT 	= 80,
		DAM_BULLET 	= 60,
		DAM_LASER 	= 60,
		DAM_ENERGY 	= 25,
		DAM_BURN 	= 45,
		DAM_BOMB 	= 50,
		DAM_EMP 	= 5,
		DAM_BIO 	= 100,
		DAM_RADS 	= 100,
		DAM_STUN 	= 5)
	flags_inv = HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 0.6

/obj/item/clothing/suit/space/void/swat/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 1