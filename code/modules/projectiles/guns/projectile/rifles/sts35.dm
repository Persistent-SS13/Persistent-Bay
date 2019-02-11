/obj/item/weapon/gun/projectile/automatic/sts35
	name = "assault rifle"
	desc = "The rugged STS-35 is a durable automatic weapon of a make popular weapons of choice in frontier conflicts. Uses 5.56mm rounds."
	icon_state = "arifle"
	item_state = null
	w_class = ITEM_SIZE_HUGE
	force = 10
	caliber = "a556"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ILLEGAL = 5)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/c556
	allowed_magazines = /obj/item/ammo_magazine/c556
	one_hand_penalty = 3
	wielded_item_state = "arifle-wielded"

	//Assault rifle, burst fire degrades quicker than SMG, worse one-handing penalty, slightly increased move delay
	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, one_hand_penalty=4, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=6,    one_hand_penalty=5, burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0), jam_chance=10),
		list(mode_name="short bursts",   burst=5, fire_delay=null, move_delay=6,    one_hand_penalty=6, burst_accuracy=list(0,-1,-2,-3,-3), dispersion=list(0.6, 1.0, 1.2, 1.2, 1.5), jam_chance=15),
		)

/obj/item/weapon/gun/projectile/automatic/sts35/update_icon()
	icon_state = (ammo_magazine)? "arifle" : "arifle-empty"
	wielded_item_state = (ammo_magazine)? "arifle-wielded" : "arifle-wielded-empty"
	..()
