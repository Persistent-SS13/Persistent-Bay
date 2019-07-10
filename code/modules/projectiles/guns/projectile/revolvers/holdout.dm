/obj/item/weapon/gun/projectile/revolver/holdout
	name = "\improper AMM \"Partner\" .22 revolver"
	desc = "The al-Maliki & Mosley Partner is a concealed-carry revolver made for people who do not trust automatic pistols any more than the people they're dealing with."
	icon_state = "holdout"
	item_state = "pen"
	caliber = CALIBER_22LR
	ammo_type = /obj/item/ammo_casing/c22lr
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_BELT | SLOT_HOLSTER | SLOT_POCKET
	accuracy = 2
	accuracy_power = 20
	one_hand_penalty = 0
	bulk = 0
	fire_delay = 1.8 //Gotta compensate for its weakness
	matter = list(MATERIAL_STEEL = 1500, MATERIAL_ALUMINIUM = 200)
	mass = 550 GRAMS