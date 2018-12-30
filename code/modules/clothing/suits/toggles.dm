///Hoods for winter coats and chaplain hoodie etc

/obj/item/clothing/suit/storage/hooded
	var/obj/item/clothing/head/winterhood/hood
	var/hoodtype = null //so the chaplain hoodie or other hoodies can override this
	var/suittoggled = 0

/obj/item/clothing/suit/storage/hooded/New()
	MakeHood()
	..()

/obj/item/clothing/suit/storage/hooded/Destroy()
	QDEL_NULL(hood)
	return ..()

/obj/item/clothing/suit/storage/hooded/proc/MakeHood()
	if(!hood)
		hood = new hoodtype(src)

/obj/item/clothing/suit/storage/hooded/ui_action_click()
	ToggleHood()

/obj/item/clothing/suit/storage/hooded/equipped(mob/user, slot)
	if(slot != slot_wear_suit)
		RemoveHood()
	..()

/obj/item/clothing/suit/storage/hooded/proc/RemoveHood()
	if(!hood)
		return
	suittoggled = 0
	update_icon()
	if(ishuman(hood.loc))
		var/mob/living/carbon/H = hood.loc
		H.unEquip(hood, 1)
		H.update_inv_wear_suit()
	hood.forceMove(src)

/obj/item/clothing/suit/storage/hooded/dropped()
	RemoveHood()

/obj/item/clothing/suit/storage/hooded/proc/ToggleHood()
	if(!suittoggled)
		if(ishuman(loc))
			var/mob/living/carbon/human/H = src.loc
			if(H.wear_suit != src)
				to_chat(H, "<span class='warning'>You must be wearing \the [src] to put up the hood!</span>")
				return
			if(H.head)
				to_chat(H, "<span class='warning'>You're already wearing something on your head!</span>")
				return
			else
				H.equip_to_slot_if_possible(hood,slot_head,0,0,1)
				suittoggled = 1
				update_icon()
				H.update_inv_wear_suit()
	else
		RemoveHood()

/obj/item/clothing/suit/storage/hooded/update_icon()
	if(suittoggled)
		icon_state = "[initial(icon_state)]_t"
	else
		icon_state = "[initial(icon_state)]"


/obj/item/clothing/suit/storage/hooded/wintercoat
	name = "winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs."
	icon_state = "coatwinter"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	armor  = list(
		DAM_BLUNT 	= 10,
		DAM_PIERCE 	= 5,
		DAM_CUT 	= 5,
		DAM_BULLET 	= 0,
		DAM_LASER 	= 0,
		DAM_ENERGY 	= 5,
		DAM_BURN 	= 5,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 0,
		DAM_BIO 	= 10,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)
	action_button_name = "Toggle Winter Hood"
	hoodtype = /obj/item/clothing/head/winterhood
	allowed = list (/obj/item/weapon/pen, /obj/item/weapon/paper, /obj/item/device/flashlight,/obj/item/weapon/storage/fancy/cigarettes, /obj/item/weapon/storage/box/matches, /obj/item/weapon/reagent_containers/food/drinks/flask)
	siemens_coefficient = 0.6

/obj/item/clothing/head/winterhood
	name = "winter hood"
	desc = "A hood attached to a heavy winter jacket."
	icon_state = "generic_hood"
	body_parts_covered = HEAD
	cold_protection = HEAD
	flags_inv = HIDEEARS | BLOCKHAIR
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/storage/hooded/wintercoat/captain
	name = "captain's winter coat"
	icon_state = "coatcaptain"
	armor  = list(
		DAM_BLUNT 	= 20,
		DAM_PIERCE 	= 5,
		DAM_CUT 	= 20,
		DAM_BULLET 	= 15,
		DAM_LASER 	= 20,
		DAM_ENERGY 	= 10,
		DAM_BURN 	= 10,
		DAM_BOMB 	= 15,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 1)

/obj/item/clothing/suit/storage/hooded/wintercoat/security
	name = "security winter coat"
	icon_state = "coatsecurity"
	armor  = list(
		DAM_BLUNT 	= 25,
		DAM_PIERCE 	= 15,
		DAM_CUT 	= 25,
		DAM_BULLET 	= 20,
		DAM_LASER 	= 20,
		DAM_ENERGY 	= 15,
		DAM_BURN 	= 10,
		DAM_BOMB 	= 20,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 1)

/obj/item/clothing/suit/storage/hooded/wintercoat/medical
	name = "medical winter coat"
	icon_state = "coatmedical"
	armor  = list(
		DAM_BLUNT 	= 10,
		DAM_PIERCE 	= 5,
		DAM_CUT 	= 5,
		DAM_BULLET 	= 0,
		DAM_LASER 	= 0,
		DAM_ENERGY 	= 5,
		DAM_BURN 	= 5,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 0,
		DAM_BIO 	= 50,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)

/obj/item/clothing/suit/storage/hooded/wintercoat/science
	name = "science winter coat"
	icon_state = "coatscience"
	armor  = list(
		DAM_BLUNT 	= 10,
		DAM_PIERCE 	= 5,
		DAM_CUT 	= 5,
		DAM_BULLET 	= 0,
		DAM_LASER 	= 0,
		DAM_ENERGY 	= 5,
		DAM_BURN 	= 5,
		DAM_BOMB 	= 10,
		DAM_EMP 	= 0,
		DAM_BIO 	= 50,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)

/obj/item/clothing/suit/storage/hooded/wintercoat/engineering
	name = "engineering winter coat"
	icon_state = "coatengineer"
	armor  = list(
		DAM_BLUNT 	= 10,
		DAM_PIERCE 	= 5,
		DAM_CUT 	= 5,
		DAM_BULLET 	= 0,
		DAM_LASER 	= 0,
		DAM_ENERGY 	= 5,
		DAM_BURN 	= 5,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 20,
		DAM_STUN 	= 0)

/obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos
	name = "atmospherics winter coat"
	icon_state = "coatatmos"
	armor  = list(
		DAM_BLUNT 	= 10,
		DAM_PIERCE 	= 5,
		DAM_CUT 	= 5,
		DAM_BULLET 	= 0,
		DAM_LASER 	= 0,
		DAM_ENERGY 	= 5,
		DAM_BURN 	= 20,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)

/obj/item/clothing/suit/storage/hooded/wintercoat/hydro
	name = "hydroponics winter coat"
	icon_state = "coathydro"

/obj/item/clothing/suit/storage/hooded/wintercoat/cargo
	name = "cargo winter coat"
	icon_state = "coatcargo"

/obj/item/clothing/suit/storage/hooded/wintercoat/miner
	name = "mining winter coat"
	icon_state = "coatminer"
	armor  = list(
		DAM_BLUNT 	= 20,
		DAM_PIERCE 	= 10,
		DAM_CUT 	= 15,
		DAM_BULLET 	= 0,
		DAM_LASER 	= 0,
		DAM_ENERGY 	= 5,
		DAM_BURN 	= 5,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 1)

/obj/item/clothing/suit/storage/hooded/hoodie
	name = "hoodie"
	desc = "A warm sweatshirt."
	icon_state = "hoodie"
	item_state = "hoodie"
	min_cold_protection_temperature = T0C - 20
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	action_button_name = "Toggle Hood"
	hoodtype = /obj/item/clothing/head/hoodiehood
	
/obj/item/clothing/head/hoodiehood
	name = "hoodie hood"
	desc = "A hood attached to a warm sweatshirt."
	icon_state = "generic_hood"
	body_parts_covered = HEAD
	min_cold_protection_temperature = T0C - 20
	cold_protection = HEAD
	flags_inv = HIDEEARS | BLOCKHAIR
