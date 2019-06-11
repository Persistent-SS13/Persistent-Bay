//----------------------------------
//	Luger P.08
//----------------------------------
/obj/item/weapon/gun/projectile/pistol/p08
	name = "\improper P.08 9mm pistol"
	desc = "A product of one of thousands of illegal workshops from around the galaxy. Often replicas of ancient Earth handguns, these guns are usually found in hands of frontier colonists and pirates."
	icon = 'icons/obj/weapons/guns/pistol_luger.dmi'
	icon_state = "p08"
	magazine_type = /obj/item/ammo_magazine/box/p08
	allowed_magazines = /obj/item/ammo_magazine/box/p08
	accuracy_power = 8
	one_hand_penalty = 1
	fire_delay = 2
	caliber = CALIBER_9MM
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)

//----------------------------------
//	9mm P.08 Magazine
//----------------------------------
/obj/item/ammo_magazine/box/p08
	name = "\improper P.08 magazine (9mm)"
	icon_state = "9x19p"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	matter = list(MATERIAL_STEEL = 600)
	caliber = CALIBER_9MM
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 8
	multiple_sprites = 1
/obj/item/ammo_magazine/box/p08/empty
	initial_ammo = 0