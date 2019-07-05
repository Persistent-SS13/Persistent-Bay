/obj/item/weapon/gun/projectile/automatic/machine_pistol
	name = "MP6 machine pistol"
	desc = "The Hephaestus Industries MP6 Vesper, A fairly common machine pistol. Sometimes refered to as an 'uzi' by the backwater spacers it is often associated with. Compatible with standard 9mm magazines."
	icon = 'icons/obj/guns/machine_pistol.dmi'
	icon_state = "mpistolen"
	safety_icon = "safety"
	item_state = "wt550"
	caliber = CALIBER_9MM
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2, TECH_ILLEGAL = 3)
	ammo_type = /obj/item/ammo_casing/c9mm
	magazine_type = /obj/item/ammo_magazine/box/c9mm/_20/empty
	allowed_magazines = /obj/item/ammo_magazine/box/c9mm
	one_hand_penalty = 2
	slot_flags = SLOT_BELT | SLOT_HOLSTER

	firemodes = list(
		list(mode_name="semi auto",      burst=1, fire_delay=null, move_delay=null, one_hand_penalty=0, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    one_hand_penalty=1, burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="short bursts",   burst=5, fire_delay=null, move_delay=4,    one_hand_penalty=2, burst_accuracy=list(0,-1,-1,-1,-2), dispersion=list(0.6, 0.6, 1.0, 1.0, 1.2)),
		)
