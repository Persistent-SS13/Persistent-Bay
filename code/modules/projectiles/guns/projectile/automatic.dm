//Base class for full automatic capable weapons
/obj/item/weapon/gun/projectile/automatic
	load_method = MAGAZINE
	w_class = ITEM_SIZE_NORMAL
	multi_aim = 1
	burst_delay = 2
	mag_insert_sound = 'sound/weapons/guns/interaction/smg_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/smg_magout.ogg'
	//machine pistol, easier to one-hand with
	firemodes = list(
		list(mode_name="semi auto",      burst=1, fire_delay=null, move_delay=null, one_hand_penalty=0, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    one_hand_penalty=1, burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0), jam_chance=5),
		)

/obj/item/weapon/gun/projectile/automatic/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-empty"
