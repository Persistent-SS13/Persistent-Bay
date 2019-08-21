/obj/item/weapon/material/sword
	name = "claymore"
	desc = "What are you standing around staring at this for? Get to killing!"
	icon_state = "claymore"
	item_state = "claymore"
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_LARGE
	force_divisor = 0.25 // 15 when wielded with hardness 60 (steel)
	thrown_force_divisor = 0.5 // 10 when thrown with weight 20 (steel)
	sharpness = 1
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	sound_attack = 'sound/weapons/bladeslice.ogg'
	base_parry_chance = 50
	melee_accuracy_bonus = 10
	damtype = DAM_CUT
	mass = 3.6 
/obj/item/weapon/material/sword/replica
	sharpness = 0
	force_divisor = 0.15
	thrown_force_divisor = 0.2
	damtype = DAM_BLUNT
	mass = 1

/obj/item/weapon/material/sword/katana
	name = "katana"
	desc = "Woefully underpowered in D20. This one looks pretty sharp."
	icon_state = "katana"
	item_state = "katana"
	furniture_icon = "katana_handle"
	slot_flags = SLOT_BELT | SLOT_BACK
	mass = 1.5

/obj/item/weapon/material/sword/katana/replica
	sharpness = 0
	force_divisor = 0.15
	thrown_force_divisor = 0.2
	damtype = DAM_BLUNT
	mass = 1

/obj/item/weapon/material/sword/katana/vibro
	name = "vibrokatana"
	desc = "A high-tech take on a woefully underpowered weapon. Can't mistake its sound for anything."
	default_material = MATERIAL_TITANIUM
	sound_hit = 'sound/weapons/anime_sword.wav'

/obj/item/weapon/material/sword/katana/vibro/equipped(mob/user, slot)
	if(slot == slot_l_hand || slot == slot_r_hand)
		playsound(src, 'sound/weapons/katana_out.wav', 50, 1, -5)
	
