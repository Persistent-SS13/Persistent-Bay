/obj/item/weapon/gun/projectile/magnum_pistol
	name = ".50 magnum pistol"
	desc = "A robust handgun that uses .50 AE ammo."
	icon_state = "magnum"
	item_state = "revolver"
	force = 14.0
	caliber = ".50"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a50
	allowed_magazines = /obj/item/ammo_magazine/a50

/obj/item/weapon/gun/projectile/magnum_pistol/update_icon()
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "magnum"
	else
		icon_state = "magnum-e"
