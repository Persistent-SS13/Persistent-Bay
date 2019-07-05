//----------------------------------
//	Colt M1911
//----------------------------------
/obj/item/weapon/gun/projectile/pistol/m1911
	name = ".45 pistol"
	desc = "A cheap Martian knock-off of a Colt M1911."
	icon = 'icons/obj/weapons/guns/pistol_m1911.dmi'
	icon_state = "colt"
	magazine_type = /obj/item/ammo_magazine/box/m1911
	allowed_magazines = /obj/item/ammo_magazine/box/m1911
	accuracy_power = 5
	one_hand_penalty = 2
	fire_delay = 7
	caliber = CALIBER_45
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)

//----------------------------------
//	.45 M1911 Magazine
//----------------------------------
/obj/item/ammo_magazine/box/m1911
	name = "\improper M1911 magazine (.45)"
	desc = "A magazine made for a M1911 .45 pistol."
	icon_state = "45"
	origin_tech = list(TECH_COMBAT = 2)
	caliber = CALIBER_45
	matter = list(MATERIAL_STEEL = 2250)
	ammo_type = /obj/item/ammo_casing/c45
	max_ammo = 7
/obj/item/ammo_magazine/box/m1911/empty
	initial_ammo = 0