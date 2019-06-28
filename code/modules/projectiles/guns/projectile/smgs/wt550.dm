//----------------------------------
//	WT550 SMG
//----------------------------------
/obj/item/weapon/gun/projectile/automatic/wt550
	name = "WT-550 SMG"
	desc = "The WT-550 Saber is a cheap self-defense weapon, mass-produced by Ward-Takahashi for paramilitary and private use. Compatible only with top-mounted magazines."
	icon = 'icons/obj/weapons/guns/sec_smg.dmi'
	icon_state = "wt550"
	item_state = "wt550"
	safety_icon = "safety"
	w_class = ITEM_SIZE_NORMAL
	caliber = CALIBER_9MM
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	ammo_type = /obj/item/ammo_casing/c9mm
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/box/wt550/empty
	allowed_magazines = /obj/item/ammo_magazine/box/wt550
	accuracy_power = 7
	one_hand_penalty = 3

	//machine pistol, like SMG but easier to one-hand with
	firemodes = list(
		list(mode_name="semi auto",      burst=1, fire_delay=null, move_delay=null, one_hand_penalty=3, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    one_hand_penalty=4, burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="short bursts",   burst=5, fire_delay=null, move_delay=4,    one_hand_penalty=5, burst_accuracy=list(0,-1,-1,-1,-2), dispersion=list(0.6, 0.6, 1.0, 1.0, 1.2)),
		)

/obj/item/weapon/gun/projectile/automatic/wt550/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "[initial(icon_state)]-[round(ammo_magazine.stored_ammo.len,4)]"
	else
		icon_state = initial(icon_state)

//----------------------------------
//	9mm top mounted smg Magazine
//----------------------------------
/obj/item/ammo_magazine/box/wt550
	name = "top mounted magazine (9mm)"
	icon_state = "9mmt"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/c9mm
	matter = list(MATERIAL_STEEL = 1200)
	caliber = CALIBER_9MM
	max_ammo = 20
	multiple_sprites = 1
/obj/item/ammo_magazine/box/wt550/empty
	initial_ammo = 0
/obj/item/ammo_magazine/box/wt550/rubber
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/c9mm/rubber
/obj/item/ammo_magazine/box/wt550/practice
	labels = list("practice")
	ammo_type = /obj/item/ammo_casing/c9mm/practice