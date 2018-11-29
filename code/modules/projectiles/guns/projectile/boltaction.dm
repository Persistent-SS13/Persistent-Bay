/obj/item/weapon/gun/projectile/boltaction
	var/bolt_open = 0

/obj/item/weapon/gun/projectile/boltaction/update_icon()
	if(bolt_open)
		icon_state = "[initial(icon_state)]_alt"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/weapon/gun/projectile/boltaction/attack_self(mob/user as mob)
	playsound(src.loc, 'sound/weapons/flipblade.ogg', 50, 1)
	bolt_open = !bolt_open
	if(bolt_open)
		if(chambered)
			to_chat(user, "<span class='notice'>You work the bolt open, ejecting [chambered]!</span>")
			chambered.loc = get_turf(src)
			loaded -= chambered
			chambered = null
		else
			to_chat(user, "<span class='notice'>You work the bolt open.</span>")
	else
		to_chat(user, "<span class='notice'>You work the bolt closed.</span>")
		bolt_open = 0
	add_fingerprint(user)
	update_icon()

/obj/item/weapon/gun/projectile/boltaction/special_check(mob/user)
	if(bolt_open)
		to_chat(user, "<span class='warning'>You can't fire [src] while the bolt is open!</span>")
		return 0
	return ..()

/obj/item/weapon/gun/projectile/boltaction/load_ammo(var/obj/item/A, mob/user)
	if(!bolt_open)
		return
	..()

/obj/item/weapon/gun/projectile/boltaction/unload_ammo(mob/user, var/allow_dump=1)
	if(!bolt_open)
		return
	..()
