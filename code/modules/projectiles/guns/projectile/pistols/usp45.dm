//----------------------------------
//	USP .45 Pistol
//----------------------------------
/obj/item/weapon/gun/projectile/pistol/usp
	name = "\improper USP .45 pistol"
	desc = "A product of one of thousands of illegal workshops from around the galaxy. Often replicas of ancient Earth handguns, these guns are usually found in hands of frontier colonists and pirates."
	icon = 'icons/obj/weapons/guns/pistol_usp.dmi'
	icon_state = "usp"
	magazine_type = /obj/item/ammo_magazine/box/usp
	allowed_magazines = /obj/item/ammo_magazine/box/usp
	accuracy_power = 7
	one_hand_penalty = 2
	fire_delay = 5
	caliber = CALIBER_45
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)

//----------------------------------
//	USP .45 Magazine
//----------------------------------
/obj/item/ammo_magazine/box/usp
	name = "USP 12rnds magazine (.45)"
	desc = "A magazine made for a USP .45 pistol."
	icon_state = "pistolds"
	origin_tech = list(TECH_COMBAT = 2)
	caliber = CALIBER_45
	matter = list(MATERIAL_STEEL = 2250)
	ammo_type = /obj/item/ammo_casing/c45
	max_ammo = 12
/obj/item/ammo_magazine/box/usp/empty
	initial_ammo = 0