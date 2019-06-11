/obj/item/weapon/gun/projectile/pistol/bhp
	name = "\improper HP-35 9mm pistol"
	desc = "A product of one of thousands of illegal workshops from around the galaxy. Often replicas of ancient Earth handguns, these guns are usually found in hands of frontier colonists and pirates."
	icon = 'icons/obj/weapons/guns/pistol_bhp.dmi'
	icon_state = "bhp"
	magazine_type = /obj/item/ammo_magazine/box/bhp
	allowed_magazines = /obj/item/ammo_magazine/box/bhp
	accuracy_power = 7
	one_hand_penalty = 2
	fire_delay = 4
	caliber = CALIBER_9MM
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)

//----------------------------------
//	9mm BHP Magazine
//----------------------------------
/obj/item/ammo_magazine/box/bhp
	name = "\improper HP-35 magazine (9mm)"
	desc = "A 15 rounds magazine made for a HP-35 9mm pistol."
	icon_state = "pistol"
	origin_tech = list(TECH_COMBAT = 2)
	matter = list(MATERIAL_STEEL = 1800)
	caliber = CALIBER_9MM
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 15
/obj/item/ammo_magazine/box/bhp/empty
	initial_ammo = 0