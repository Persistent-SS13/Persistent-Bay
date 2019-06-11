/obj/item/clothing/head/terran
	name = "master ICCGN hat"
	icon = 'code/modules/torch/icons/obj/obj_head_terran.dmi'
	item_icons = list(slot_head_str = 'code/modules/torch/icons/mob/onmob_head_terran.dmi')
	armor = list(DAM_BLUNT = 0, DAM_CUT = 0, DAM_PIERCE = 0, DAM_BULLET = 0, DAM_LASER = 0, DAM_ENERGY = 0, DAM_BOMB = 0, DAM_BIO = 0, DAM_RADS = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/head/terran/navy/service
	name = "ICCGN service cover"
	desc = "A service uniform cover, worn by low-ranking crew within the Independent Navy."
	icon_state = "terranservice"
	item_state = "terranservice"
	item_state_slots = list(
		slot_l_hand_str = "helmet",
		slot_r_hand_str = "helmet")
	body_parts_covered = 0

/obj/item/clothing/head/terran/navy/service/command
	name = "ICCGN command service cover"
	desc = "A service uniform cover, worn by high-ranking crew within the Independent Navy."
	icon_state = "terranservice_comm"
	item_state = "terranservice_comm"