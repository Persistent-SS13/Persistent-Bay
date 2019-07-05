/obj/item/weapon/gun/projectile/shotgun/pump/combat
	name = "KS-40 shotgun"
	desc = "Built for close quarters combat, the Hephaestus Industries KS-40 is widely regarded as a weapon of choice for repelling boarders."
	icon = 'icons/obj/weapons/guns/shotguns.dmi'
	icon_state = "cshotgun"
	item_state = "cshotgun"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	max_shells = 7 //match the ammo box capacity, also it can hold a round in the chamber anyways, for a total of 8.
	ammo_type = /obj/item/ammo_casing/shotgun
	one_hand_penalty = 8
