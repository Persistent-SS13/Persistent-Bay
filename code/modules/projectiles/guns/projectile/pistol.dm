
/obj/item/weapon/gun/projectile/pistol
	load_method = MAGAZINE
	caliber = CALIBER_PISTOL
	magazine_type = null
	allowed_magazines = null
	max_shells = 0
	accuracy_power = 7
	slot_flags = SLOT_BELT | SLOT_HOLSTER
	var/empty_icon = TRUE  //If it should change icon when empty
	var/ammo_indicator = FALSE

/obj/item/weapon/gun/projectile/pistol/on_update_icon()
	..()
	if(empty_icon)
		if(ammo_magazine && ammo_magazine.stored_ammo.len)
			icon_state = initial(icon_state)
		else
			icon_state = "[initial(icon_state)]-e"
	if(ammo_indicator)
		if(!ammo_magazine || !LAZYLEN(ammo_magazine.stored_ammo))
			overlays += image(icon, "ammo_bad")
		else if(LAZYLEN(ammo_magazine.stored_ammo) <= 0.5 * ammo_magazine.max_ammo)
			overlays += image(icon, "ammo_warn")
			return
		else
			overlays += image(icon, "ammo_ok")
	
