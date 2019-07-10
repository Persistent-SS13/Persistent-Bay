/obj/item/weapon/melee/whip
	name = "whip"
	desc = "A generic whip."
	icon_state = "chain"
	item_state = "whip"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	force = 8
	throwforce = 7
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 4)
	attack_verb = list("flicked", "whipped", "lashed")
	damtype = DAM_BLUNT
	mass = 3


/obj/item/weapon/melee/whip/abyssal
	name = "abyssal whip"
	desc = "A weapon from the abyss. Requires 70 attack to wield."
	icon_state = "whip"
	item_state = "whip"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	force = 12 //max hit with 60 strength and no equipment. Duel Arena no No forfeit - Snapshot
	throwforce = 7
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 4)
	attack_verb = list("flicked", "whipped", "lashed")
	mass = 5

/obj/item/weapon/melee/whip/chainofcommand
	name = "chain of command"
	desc = "A tool used by great men to placate the frothing masses."
	attack_verb = list("flogged", "whipped", "lashed", "disciplined")
	icon_state = "chain"
	item_state = "whip"
	mass = 4

/obj/item/weapon/material/sword/officersword
	name = "fleet officer's sword"
	desc = "A polished sword issued to officers of the fleet."
	icon_state = "officersword"
	item_state = "officersword"
	slot_flags = SLOT_BELT
	applies_material_colour = FALSE
	damtype = DAM_CUT
	mass = 2

/obj/item/weapon/material/sword/officersword/marine
	name = "marine NCO's sword"
	desc = "A polished sword issued to SCG Marine NCOs."
	icon_state = "armysword"
	damtype = DAM_CUT
	mass = 2

/obj/item/weapon/material/sword/officersword/marineofficer
	name = "marine officer's sword"
	desc = "A curved sword issued to SCG Marine officers."
	icon_state = "armyofficersword"
	item_state = "armyofficersword"
	damtype = DAM_CUT
	mass = 2

/obj/item/weapon/material/sword/officersword/pettyofficer
	name = "chief petty officer's cutlass"
	desc = "A polished cutlass issued to chief petty officers of the fleet."
	icon_state = "pettyofficersword"
	item_state = "pettyofficersword"
	damtype = DAM_CUT
	mass = 2
