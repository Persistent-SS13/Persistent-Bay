/obj/item/weapon/gun/projectile/boltaction/heavysniper
	name = "HI PTR-7 anti-material rifle"
	desc = "A portable anti-armour rifle fitted with a scope, the HI PTR-7 Rifle was originally designed to used against armoured exosuits. It is capable of punching through windows and non-reinforced walls with ease. Fires armor piercing 14.5mm shells."
	icon = 'icons/obj/weapons/guns/heavysniper.dmi'
	icon_state = "heavysniper"
	item_state = "heavysniper" //sort of placeholder
	w_class = ITEM_SIZE_HUGE
	force = 10
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	caliber = CALIBER_ANTIMATERIAL
	screen_shake = 2 //extra kickback
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/c145
	one_hand_penalty = 12
	accuracy = -2
	bulk = 8
	scoped_accuracy = 8 //increased accuracy over the LWAP because only one shot
	scope_zoom = 2
	wielded_item_state = "heavysniper-wielded" //sort of placeholder
	load_sound = 'sound/weapons/guns/interaction/rifle_load.ogg'
	fire_delay = 12

/obj/item/weapon/gun/projectile/boltaction/heavysniper/ant
	name = "HI PTR-7 anti-material rifle"
	desc = "A portable anti-armour rifle fitted with a scope, the HI PTR-7 Rifle was originally designed to used against armoured exosuits. It is capable of punching through windows and non-reinforced walls with ease. Fires armor piercing 14.5mm shells. This replica however fires 9mm rounds."
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = CALIBER_9MM
