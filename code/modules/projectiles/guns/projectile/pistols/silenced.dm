/obj/item/weapon/gun/projectile/silenced
	name = "silenced .45 pistol"
	desc = "A handgun with an integral silencer. Compatible with standard mags."
	icon = 'icons/obj/weapons/guns/silenced_pistol.dmi'
	icon_state = "silenced_pistol"
	w_class = ITEM_SIZE_NORMAL
	caliber = CALIBER_45
	silenced = TRUE
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/box/c45
	allowed_magazines = /obj/item/ammo_magazine/box/c45

/obj/item/weapon/gun/projectile/silenced/New()
	..()
	ADD_SAVED_VAR(silenced)