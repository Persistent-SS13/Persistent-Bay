//
//	Magnum .44 Pistol
//
/obj/item/weapon/gun/projectile/pistol/magnum_pistol
	name = "\improper HT Magnus pistol"
	desc = "The HelTek Magnus, a robust Terran handgun that uses high-caliber ammo."
	icon = 'icons/obj/weapons/guns/magnum_pistol.dmi'
	icon_state = "magnum"
	item_state = "revolver"
	safety_icon = "safety"
	force = 8
	caliber = CALIBER_44
	fire_delay = 8
	screen_shake = 1
	magazine_type = /obj/item/ammo_magazine/box/c44/empty
	allowed_magazines = /obj/item/ammo_magazine/box/c44
	mag_insert_sound = 'sound/weapons/guns/interaction/hpistol_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/hpistol_magout.ogg'
	accuracy = 2
	accuracy_power = 9
	one_hand_penalty = 2
	bulk = 2

/obj/item/weapon/gun/projectile/pistol/magnum_pistol/update_icon()
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "magnum"
	else
		icon_state = "magnum-e"

