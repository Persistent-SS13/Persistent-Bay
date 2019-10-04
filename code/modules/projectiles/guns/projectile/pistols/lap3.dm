/obj/item/weapon/gun/projectile/pistol/holdout
	name = "\improper LAP3 pistol"
	desc = "The Lumoco Arms P3 Whisper. A small, easily concealable gun."
	icon = 'icons/obj/weapons/guns/holdout_pistol.dmi'
	icon_state = "pistol"
	item_state = null
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_BELT | SLOT_HOLSTER | SLOT_POCKET
	caliber = CALIBER_9MM
	silenced = FALSE
	fire_delay = 2
	accuracy_power = 10
	accuracy = 1
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 2)
	magazine_type = /obj/item/ammo_magazine/box/lap3
	allowed_magazines = /obj/item/ammo_magazine/box/lap3

/obj/item/weapon/gun/projectile/pistol/holdout/New()
	..()
	ADD_SAVED_VAR(silenced)

/obj/item/weapon/gun/projectile/pistol/holdout/attack_hand(mob/user as mob)
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

/obj/item/weapon/gun/projectile/pistol/holdout/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/silencer))
		if(user.l_hand != src && user.r_hand != src)	//if we're not in his hands
			to_chat(user, "<span class='notice'>You'll need [src] in your hands to do that.</span>")
			return
		if(!user.unEquip(I, src))
			return//put the silencer into the gun
		to_chat(user, "<span class='notice'>You screw [I] onto [src].</span>")
		silenced = I	//dodgy?
		w_class = ITEM_SIZE_NORMAL
		update_icon()
		return
	..()

/obj/item/weapon/gun/projectile/pistol/holdout/on_update_icon()
	..()
	if(silenced)
		icon_state = "pistol-silencer"
	else
		icon_state = "pistol"
	if(!(ammo_magazine && ammo_magazine.stored_ammo.len))
		icon_state = "[icon_state]-e"

/obj/item/weapon/silencer
	name = "silencer"
	desc = "A silencer."
	icon = 'icons/obj/weapons/guns/holdout_pistol.dmi'
	icon_state = "silencer"
	w_class = ITEM_SIZE_SMALL

//----------------------------------
//	9mm LAP3 Magazine
//----------------------------------
/obj/item/ammo_magazine/box/lap3
	name = "\improper LAP3 magazine (9mm)"
	icon_state = "holdout"
	origin_tech = list(TECH_COMBAT = 2)
	matter = list(MATERIAL_STEEL = 600)
	caliber = CALIBER_9MM
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 8
	multiple_sprites = 1
/obj/item/ammo_magazine/box/lap3/empty
	initial_ammo = 0