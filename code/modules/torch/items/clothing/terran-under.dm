//Terrans

/obj/item/clothing/under/terran
	name = "master ICCGN uniform"
	desc = "You shouldn't be seeing this."
	icon = 'code/modules/torch/icons/obj/obj_under_terran.dmi'
	item_icons = list(slot_w_uniform_str = 'code/modules/torch/icons/mob/onmob_under_terran.dmi')
	armor = list(DAM_BLUNT = 5, DAM_CUT = 5, DAM_PIERCE = 0, DAM_BULLET = 0, DAM_LASER = 5, DAM_ENERGY = 5, DAM_BOMB = 0, DAM_BIO = 5, DAM_RADS = 5)
	siemens_coefficient = 0.8

/obj/item/clothing/under/terran/navy/utility
	name = "ICCGN utility uniform"
	desc = "A comfortable black utility jumpsuit. Worn by the ICCG Navy."
	icon_state = "terranutility"
	item_state = "bl_suit"
	worn_state = "terranutility"

/obj/item/clothing/under/terran/navy/service
	name = "ICCGN service uniform"
	desc = "The service uniform of the ICCG Navy, for low-ranking crew."
	icon_state = "terranservice"
	worn_state = "terranservice"
	armor = list(DAM_BLUNT = 5, DAM_CUT = 5, DAM_PIERCE = 0, DAM_BULLET = 0, DAM_LASER = 0, DAM_ENERGY = 0, DAM_BOMB = 0, DAM_BIO = 5, DAM_RADS = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/terran/navy/service/command
	name = "ICCGN command service uniform"
	desc = "The service uniform of the ICCG Navy, for high-ranking crew."
	icon_state = "terranservice_comm"
	worn_state = "terranservice_comm"