/obj/item/weapon/gun/projectile/automatic/proto_smg
	name = "prototype SMG"
	desc = "A protoype lightweight, fast firing gun. Uses special prototype 4mm flechette rounds."
	icon = 'icons/obj/guns/prototype_smg.dmi'
	icon_state = "prototype"
	w_class = ITEM_SIZE_NORMAL
	bulk = -1
	load_method = MAGAZINE
	caliber = CALIBER_PISTOL_FLECHETTE
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 3)
	slot_flags = SLOT_BELT | SLOT_BACK
	ammo_type = /obj/item/ammo_casing/flechette
	magazine_type = /obj/item/ammo_magazine/box/proto_smg
	allowed_magazines = /obj/item/ammo_magazine/box/proto_smg
	multi_aim = 1
	burst_delay = 2
	mag_insert_sound = 'sound/weapons/guns/interaction/smg_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/smg_magout.ogg'

	//machine pistol, easier to one-hand with
	firemodes = list(
		list(mode_name="semi auto",      burst=1, fire_delay=null, move_delay=null, one_hand_penalty=0, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    one_hand_penalty=1, burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0), jam_chance=5),
		list(mode_name="short bursts",   burst=5, fire_delay=null, move_delay=4,    one_hand_penalty=2, burst_accuracy=list(0,-1,-1,-1,-2), dispersion=list(0.6, 0.6, 1.0, 1.0, 1.2), jam_chance=6),
		)

/obj/item/ammo_magazine/box/proto_smg
	name = "prototype SMG magazine (4mm)"
	icon_state = "4mm"
	origin_tech = list(TECH_COMBAT = 4)
	mag_type = MAGAZINE
	caliber = CALIBER_PISTOL_FLECHETTE
	matter = list(MATERIAL_STEEL = 2000)
	ammo_type = /obj/item/ammo_casing/flechette
	max_ammo = 40
	multiple_sprites = 1
/obj/item/ammo_magazine/box/proto_smg/empty
	initial_ammo = 0