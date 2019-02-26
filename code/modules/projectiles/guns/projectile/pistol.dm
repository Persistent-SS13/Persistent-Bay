/obj/item/weapon/silencer
	name = "silencer"
	desc = "A silencer."
	icon = 'icons/obj/gun.dmi'
	icon_state = "silencer"
	w_class = ITEM_SIZE_SMALL

/obj/item/weapon/gun/projectile/pistol
	name = "holdout pistol"
	desc = "The Lumoco Arms P3 Whisper. A small, easily concealable gun. Uses 9mm rounds."
	icon_state = "pistol"
	item_state = null
	w_class = ITEM_SIZE_SMALL
	caliber = "9mm"
	silenced = FALSE
	fire_delay = 1
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 2)
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/mc9mm
	allowed_magazines = /obj/item/ammo_magazine/mc9mm

/obj/item/weapon/gun/projectile/pistol/flash
	name = "holdout signal pistol"
	magazine_type = /obj/item/ammo_magazine/mc9mm/flash

/obj/item/weapon/gun/projectile/pistol/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		if(silenced)
			if(user.l_hand != src && user.r_hand != src)
				..()
				return
			to_chat(user, "<span class='notice'>You unscrew [silenced] from [src].</span>")
			user.put_in_hands(silenced)
			silenced = initial(silenced)
			w_class = initial(w_class)
			update_icon()
			return
	..()

/obj/item/weapon/gun/projectile/pistol/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/silencer))
		if(user.l_hand != src && user.r_hand != src)	//if we're not in his hands
			to_chat(user, "<span class='notice'>You'll need [src] in your hands to do that.</span>")
			return
		user.drop_item()
		to_chat(user, "<span class='notice'>You screw [I] onto [src].</span>")
		silenced = I	//dodgy?
		w_class = ITEM_SIZE_NORMAL
		I.forceMove(src)		//put the silencer into the gun
		update_icon()
		return
	..()

/obj/item/weapon/gun/projectile/pistol/update_icon()
	..()
	if(silenced)
		icon_state = "pistol-silencer"
	else
		icon_state = "pistol"
	if(!(ammo_magazine && ammo_magazine.stored_ammo.len))
		icon_state = "[icon_state]-e"
