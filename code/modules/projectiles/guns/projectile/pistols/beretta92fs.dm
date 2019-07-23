//----------------------------------
//	Beretta 92fs
//----------------------------------
/obj/item/weapon/gun/projectile/pistol/b92
	name = "92fs 9mm pistol"
	desc = "A product of one of thousands of illegal workshops from around the galaxy. Often replicas of ancient Earth handguns, these guns are usually found in hands of frontier colonists and pirates."
	icon = 'icons/obj/weapons/guns/pistol_b92.dmi'
	icon_state = "b92"
	magazine_type = /obj/item/ammo_magazine/box/b92fs
	allowed_magazines = /obj/item/ammo_magazine/box/b92fs
	accuracy_power = 9
	one_hand_penalty = 2
	fire_delay = 3
	caliber = CALIBER_9MM
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)

//----------------------------------
//	9mm Beretta 92fs magazine
//----------------------------------
/obj/item/ammo_magazine/box/b92fs
	name = "92fs magazine (9mm)"
	desc = "A 15 rounds magazine made for a 92fs 9mm pistol."
	icon_state = "pistol"
	caliber = CALIBER_9MM
	matter = list(MATERIAL_STEEL = 1050)
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 15
/obj/item/ammo_magazine/box/b92fs/empty
	initial_ammo = 0