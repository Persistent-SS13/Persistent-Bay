//----------------------------------
// MK58
//----------------------------------
/obj/item/weapon/gun/projectile/pistol/sec
	name = "\improper MK58 .45 pistol"
	desc = "The NT Mk58 is a cheap, ubiquitous sidearm, produced by a Nanotrasen for use in the frontier. Found everywhere in the frontier. Uses .45 rounds."
	icon = 'icons/obj/weapons/guns/pistol_secgun.dmi'
	icon_state = "secgundark"
	safety_icon = "safety"
	caliber = CALIBER_45
	magazine_type = /obj/item/ammo_magazine/box/c45/empty
	allowed_magazines = /obj/item/ammo_magazine/box/c45
	accuracy = -1
	accuracy_power = 6
	fire_delay = 4
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)

// /obj/item/weapon/gun/projectile/pistol/sec/wood
// 	desc = "The NT Mk58 is a cheap, ubiquitous sidearm, produced by a Nanotrasen subsidiary. This one has a sweet wooden grip. Uses .45 rounds."
// 	name = "custom .45 Pistol"
// 	icon_state = "secgundark"

