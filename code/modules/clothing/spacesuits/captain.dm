//Captain's Spacesuit
/obj/item/clothing/head/helmet/space/capspace
	name = "space helmet"
	icon_state = "capspace"
	item_state = "capspace"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Only for the most fashionable of military figureheads."
	item_flags = ITEM_FLAG_STOPPRESSUREDAMAGE
	flags_inv = HIDEFACE|BLOCKHAIR
	permeability_coefficient = 0.01
	armor  = list(
		DAM_BLUNT 	= 65,
		DAM_PIERCE 	= 55,
		DAM_CUT 	= 65,
		DAM_BULLET 	= 50,
		DAM_LASER 	= 50,
		DAM_ENERGY 	= 25,
		DAM_BURN 	= 50,
		DAM_BOMB 	= 50,
		DAM_EMP 	= 0,
		DAM_BIO 	= 100,
		DAM_RADS 	= 50,
		DAM_STUN 	= 5)

//Captain's space suit This is not the proper path but I don't currently know enough about how this all works to mess with it.
/obj/item/clothing/suit/armor/captain
	name = "Captain's armor"
	desc = "A bulky, heavy-duty piece of exclusive corporate armor. YOU are in charge!"
	icon_state = "caparmor"
	item_state_slots = list(
		slot_l_hand_str = "capspacesuit",
		slot_r_hand_str = "capspacesuit",
	)
	w_class = ITEM_SIZE_HUGE
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	item_flags = ITEM_FLAG_STOPPRESSUREDAMAGE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	allowed = list(/obj/item/weapon/tank/emergency, /obj/item/device/flashlight,/obj/item/weapon/gun/energy, /obj/item/weapon/gun/projectile, /obj/item/ammo_magazine, /obj/item/ammo_casing, /obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	armor  = list(
		DAM_BLUNT 	= 65,
		DAM_PIERCE 	= 55,
		DAM_CUT 	= 65,
		DAM_BULLET 	= 50,
		DAM_LASER 	= 50,
		DAM_ENERGY 	= 25,
		DAM_BURN 	= 50,
		DAM_BOMB 	= 50,
		DAM_EMP 	= 10,
		DAM_BIO 	= 100,
		DAM_RADS 	= 50,
		DAM_STUN 	= 5)

/obj/item/clothing/suit/armor/captain/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 1.5
