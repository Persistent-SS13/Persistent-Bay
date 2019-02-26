/obj/item/weapon/material/harpoon
	name = "harpoon"
	sharpness = 1
	desc = "Tharr she blows!"
	icon_state = "harpoon"
	item_state = "harpoon"
	force_divisor = 0.3 // 18 with hardness 60 (steel)
	attack_verb = list("jabbed","stabbed","ripped")
	damtype = DAM_PIERCE
	mass = 1.6

/obj/item/weapon/material/hatchet
	name = "hatchet"
	desc = "A very sharp axe blade upon a short fibremetal handle. It has a long history of chopping things, but now it is used for chopping wood."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "hatchet"
	force_divisor = 0.2 // 12 with hardness 60 (steel)
	thrown_force_divisor = 0.75 // 15 with weight 20 (steel)
	w_class = ITEM_SIZE_SMALL
	sharpness = 1
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 1)
	attack_verb = list("chopped", "torn", "cut")
	applies_material_colour = 0
	damtype = DAM_CUT
	mass = 1.1

/obj/item/weapon/material/hatchet/unathiknife
	name = "duelling knife"
	desc = "A razor sharp blade meant to inflict painful wounds."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "unathiknife"
	attack_verb = list("ripped", "torn", "cut")
	damtype = DAM_CUT
	mass = 1.2

/obj/item/weapon/material/hatchet/tacknife
	name = "tactical knife"
	desc = "A sharp tactical knife."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "tacknife"
	item_state = "knife"
	attack_verb = list("stabbed", "chopped", "cut")
	applies_material_colour = 1
	damtype = DAM_CUT
	mass = 0.6

/obj/item/weapon/material/hatchet/machete
	name = "machete"
	desc = "A long, sturdy blade with a rugged handle. Leading the way to cursed treasures since before space travel."
	icon_state = "machete"
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_BELT
	damtype = DAM_CUT
	mass = 1.3

/obj/item/weapon/material/hatchet/machete/deluxe
	name = "deluxe machete"
	desc = "A fine example of a machete, with a polished blade, wooden handle and a leather cord loop."
	icon_state = "machetedx"
	item_state = "machete"
	damtype = DAM_CUT
	mass = 1.4

/obj/item/weapon/material/minihoe // -- Numbers
	name = "mini hoe"
	desc = "It's used for removing weeds or scratching your back."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "hoe"
	item_state = "hoe"
	force_divisor = 0.25 // 5 with weight 20 (steel)
	thrown_force_divisor = 0.25 // as above
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("slashed", "sliced", "cut", "clawed")
	damtype = DAM_PIERCE
	mass = 0.5

/obj/item/weapon/material/scythe
	icon_state = "scythe0"
	name = "scythe"
	desc = "A sharp and curved blade on a long fibremetal handle, this tool makes it easy to reap what you sow."
	force_divisor = 0.275 // 16 with hardness 60 (steel)
	thrown_force_divisor = 0.25 // 5 with weight 20 (steel)
	sharpness = 1
	throw_speed = 1
	throw_range = 3
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 2)
	attack_verb = list("chopped", "sliced", "cut", "reaped")
	damtype = DAM_CUT
	mass = 2.70


