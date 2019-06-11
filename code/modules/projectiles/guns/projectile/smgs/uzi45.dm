//----------------------------------
//	UZI .45 Machine Pistol
//----------------------------------
/obj/item/weapon/gun/projectile/automatic/uzi45
	name = ".45 machine pistol"
	icon = 'icons/obj/guns/machine_pistol.dmi'
	icon_state = "saber"
	safety_icon = "safety"
	item_state = "wt550"
	caliber = CALIBER_45
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2, TECH_ILLEGAL = 3)
	ammo_type = /obj/item/ammo_casing/c45
	magazine_type = /obj/item/ammo_magazine/box/c45uzi/empty
	allowed_magazines = /obj/item/ammo_magazine/box/c45uzi
	one_hand_penalty = 2

	firemodes = list(
		list(mode_name="semi auto",       burst=1, fire_delay=null,    move_delay=null, one_hand_penalty=0, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    one_hand_penalty=1, burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="short bursts",   burst=5, fire_delay=null, move_delay=4,    one_hand_penalty=2, burst_accuracy=list(0,-1,-1,-1,-2), dispersion=list(0.6, 0.6, 1.0, 1.0, 1.2)),
		)

//----------------------------------
//	UZI .45 Machine Pistol
//----------------------------------
/obj/item/ammo_magazine/box/c45uzi
	name = "16rnds stick magazine (.45)"
	icon_state = "uzi45"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/c45
	matter = list(MATERIAL_STEEL = 1200)
	caliber = CALIBER_45
	max_ammo = 16
	multiple_sprites = 1
/obj/item/ammo_magazine/box/c45uzi/empty
	initial_ammo = 0