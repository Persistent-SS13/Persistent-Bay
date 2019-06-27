/obj/item/weapon/gun/projectile/boltaction
	var/bolt_open = 0
	var/sound_bolt_open = 'sound/weapons/guns/interaction/rifle_boltback.ogg'
	var/sound_bolt_close = 'sound/weapons/guns/interaction/rifle_boltforward.ogg'

/obj/item/weapon/gun/projectile/boltaction/New()
	..()
	ADD_SAVED_VAR(bolt_open)

/obj/item/weapon/gun/projectile/boltaction/update_icon()
	if(bolt_open)
		icon_state = "[initial(icon_state)]-open"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/weapon/gun/projectile/boltaction/proc/unload_shell()
	if(chambered)
		if(!bolt_open)
			playsound(src.loc, sound_bolt_open, 50, 1)
			bolt_open = 1
		chambered.dropInto(src.loc)
		loaded -= chambered
		chambered = null

/obj/item/weapon/gun/projectile/boltaction/proc/close_bolt()
	if(!bolt_open)
		return
	playsound(src.loc, sound_bolt_close, 50, 1)
	bolt_open = 0

/obj/item/weapon/gun/projectile/boltaction/attack_self(mob/user as mob)
	bolt_open = !bolt_open
	if(bolt_open)
		if(chambered)
			to_chat(user, "<span class='notice'>You work the bolt open, ejecting [chambered]!</span>")
			unload_shell()
		else
			to_chat(user, "<span class='notice'>You work the bolt open.</span>")
			bolt_open = 1
	else
		to_chat(user, "<span class='notice'>You work the bolt closed.</span>")
		close_bolt()
	add_fingerprint(user)
	update_icon()

/obj/item/weapon/gun/projectile/boltaction/handle_post_fire(mob/user, atom/target, var/pointblank=0, var/reflex=0)
	..()
	if(user && user.skill_check(SKILL_WEAPONS, SKILL_PROF))
		to_chat(user, "<span class='notice'>You work the bolt open with a reflexive motion, ejecting [chambered]!</span>")
		unload_shell()

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
