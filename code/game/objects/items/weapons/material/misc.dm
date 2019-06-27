/obj/item/weapon/material/harpoon
	name = "harpoon"
	desc = "A short throwing spear with a deep barb, specifically designed to embed itself in its target."
	sharpness = 2
	icon_state = "harpoon"
	item_state = "harpoon"
	force_divisor = 0.3 // 18 with hardness 60 (steel)
	thrown_force_divisor = 1.8
	attack_verb = list("jabbed","stabbed","ripped")
	does_spin = FALSE
	var/spent
	damtype = DAM_PIERCE
	mass = 1.6

/obj/item/weapon/material/harpoon/bomb
	name = "explosive harpoon"
	desc = "A short throwing spear with a deep barb and an explosive fitted in the head. Traditionally fired from some kind of cannon to harvest big game."
	icon_state = "harpoon_bomb"

/obj/item/weapon/material/harpoon/bomb/has_embedded()
	if(spent)
		return
	audible_message(SPAN_WARNING("\The [src] emits a long, harsh tone!"))
	playsound(loc, 'sound/weapons/bombwhine.ogg', 100, 0, -3)
	addtimer(CALLBACK(src, .proc/harpoon_detonate), 4 SECONDS) //for suspense

/obj/item/weapon/material/harpoon/bomb/proc/harpoon_detonate()
	audible_message(SPAN_DANGER("\The [src] detonates!")) //an actual sound will be handled by explosion()
	var/turf/T = get_turf(src)
	explosion(T, 0, 0, 2, 0, 1, UP|DOWN, 1)
	fragmentate(T, 4, 2)
	handle_afterbomb()

/obj/item/weapon/material/harpoon/bomb/proc/handle_afterbomb()
	spent = TRUE
	SetName("broken harpoon")
	desc = "A short spear with just a barb - if it once had a spearhead, it doesn't any more."
	icon_state = "harpoon_bomb_spent"
	force_divisor = 0.1
	thrown_force_divisor = 0.3
	damtype = DAM_PIERCE

/obj/item/weapon/material/hatchet
	name = "hatchet"
	desc = "A very sharp axe blade upon a short fibremetal handle. It has a long history of chopping things, but now it is used for chopping wood."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "hatchet"
	force_divisor = 0.2 // 12 with hardness 60 (steel)
	thrown_force_divisor = 0.75 // 15 with weight 20 (steel)
	w_class = ITEM_SIZE_SMALL
	sharpness = 2
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 1)
	attack_verb = list("chopped", "torn", "cut")
	applies_material_colour = 0
	sound_hit = "chop"
	damtype = DAM_CUT
	mass = 1.1

/obj/item/weapon/material/hatchet/unbreakable
	obj_flags = 0 //not damageable
	max_health = 0
	min_health = 0
	health = 0

/obj/item/weapon/material/hatchet/unathiknife
	name = "duelling knife"
	desc = "A razor sharp blade meant to inflict painful wounds."
	icon = 'icons/obj/knife.dmi'
	icon_state = "unathiknife"
	attack_verb = list("ripped", "torn", "cut")
	damtype = DAM_CUT
	mass = 1.2

/obj/item/weapon/material/hatchet/machete
	name = "machete"
	desc = "A long, sturdy blade with a rugged handle. Leading the way to cursed treasures since before space travel."
	item_state = "machete"
	icon_state = "machete"
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_BELT
	default_material = MATERIAL_TITANIUM
	base_parry_chance = 50
	attack_cooldown_modifier = 1
	damtype = DAM_CUT
	mass = 1.3

/obj/item/weapon/material/hatchet/machete/unbreakable
	unbreakable = TRUE

/obj/item/weapon/material/hatchet/machete/steel
	name = "fabricated machete"
	desc = "A long, machine-stamped blade with a somewhat ungainly handle. Found in military surplus stores, malls, and horror movies since before interstellar travel."
	default_material = MATERIAL_STEEL
	base_parry_chance = 40
	matter = list(MATERIAL_STEEL = 15000, MATERIAL_PLASTIC = 2500)

/obj/item/weapon/material/hatchet/machete/Initialize()
	icon_state = "machete[pick("","_red","_blue", "_black", "_olive")]"
	. = ..()

/obj/item/weapon/material/hatchet/machete/deluxe
	name = "deluxe machete"
	desc = "A fine example of a machete, with a polished blade, wooden handle and a leather cord loop."
	icon_state = "machetedx"
	item_state = "machete"
	damtype = DAM_CUT
	mass = 1.4

/obj/item/weapon/material/hatchet/machete/deluxe/Initialize()
	. = ..()
	icon_state = "machetedx"

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

/obj/item/weapon/material/minihoe/unbreakable
	obj_flags = 0 //not damageable
	max_health = 0
	min_health = 0
	health = 0

/obj/item/weapon/material/scythe
	icon_state = "scythe0"
	name = "scythe"
	desc = "A sharp and curved blade on a long fibremetal handle, this tool makes it easy to reap what you sow."
	force_divisor = 0.275 // 16 with hardness 60 (steel)
	thrown_force_divisor = 0.25 // 5 with weight 20 (steel)
	sharpness = 3
	throw_speed = 1
	throw_range = 3
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 2)
	attack_verb = list("chopped", "sliced", "cut", "reaped")
	damtype = DAM_CUT
	mass = 2.70


