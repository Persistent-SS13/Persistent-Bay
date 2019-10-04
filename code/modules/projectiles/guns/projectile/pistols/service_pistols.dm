/obj/item/weapon/gun/projectile/pistol/military
	name = "\improper HI-P20 pistol"
	desc = "The Hephaestus Industries P20 - a mass produced kinetic sidearm in widespread service with the SCGDF."
	magazine_type = /obj/item/ammo_magazine/box/c45/_15
	allowed_magazines = /obj/item/ammo_magazine/box/c45
	caliber = CALIBER_45
	icon = 'icons/obj/weapons/guns/military_pistol.dmi'
	icon_state = "military"
	safety_icon = "safety"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	fire_delay = 4
	accuracy_power = 8
	accuracy = 1

/obj/item/weapon/gun/projectile/pistol/military/alt
	name = "\improper HT Optimus pistol"
	desc = "The HelTek Optimus, best known as the standard-issue sidearm for the ICCG Navy."
	icon = 'icons/obj/weapons/guns/military_pistol2.dmi'
	icon_state = "military-alt"
	safety_icon = "safety"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	fire_delay = 5
	accuracy = 1
	accuracy_power = 12
