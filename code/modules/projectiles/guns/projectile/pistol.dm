
/obj/item/weapon/gun/projectile/pistol
	load_method = MAGAZINE
	caliber = CALIBER_PISTOL
	magazine_type = null
	allowed_magazines = null
	max_shells = 0
	var/empty_icon = TRUE  //If it should change icon when empty

/obj/item/weapon/gun/projectile/pistol/on_update_icon()
	..()
	if(empty_icon)
		if(ammo_magazine && ammo_magazine.stored_ammo.len)
			icon_state = initial(icon_state)
		else
			icon_state = "[initial(icon_state)]-e"
