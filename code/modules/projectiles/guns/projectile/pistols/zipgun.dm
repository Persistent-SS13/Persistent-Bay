#define DUCTTAPE_ZIPGUN_NEEDED 30
/obj/item/weapon/gun/projectile/pirate
	name = "zip gun"
	desc = "Little more than a barrel, handle, and firing mechanism, cheap makeshift firearms like this one are not uncommon in frontier systems."
	icon = 'icons/obj/weapons/guns/zipgun.dmi'
	icon_state = "zipgun"
	item_state = "sawnshotgun"
	handle_casings = CYCLE_CASINGS //player has to take the old casing out manually before reloading
	load_method = SINGLE_CASING
	max_shells = 1 //literally just a barrel
	accuracy_power = 4

	var/global/list/ammo_types = list(
		/obj/item/ammo_casing/c357              = ".357",
		/obj/item/ammo_casing/shotgun           = "12 gauge",
		/obj/item/ammo_casing/shotgun           = "12 gauge",
		/obj/item/ammo_casing/shotgun/pellet    = "12 gauge",
		/obj/item/ammo_casing/shotgun/pellet    = "12 gauge",
		/obj/item/ammo_casing/shotgun/pellet    = "12 gauge",
		/obj/item/ammo_casing/shotgun/beanbag   = "12 gauge",
		/obj/item/ammo_casing/shotgun/stunshell = "12 gauge",
		/obj/item/ammo_casing/shotgun/flash     = "12 gauge",
		/obj/item/ammo_casing/c762              = "7.62mm",
		/obj/item/ammo_casing/c556              = "5.56mm"
		)

/obj/item/weapon/gun/projectile/pirate/New()
	ammo_type = pick(ammo_types)
	desc += " Uses [ammo_types[ammo_type]] rounds."

	var/obj/item/ammo_casing/ammo = ammo_type
	caliber = initial(ammo.caliber)
	..()

// Zip gun construction.
/obj/item/weapon/zipgunframe
	name = "zip gun frame"
	desc = "A half-finished zip gun."
	icon = 'icons/obj/weapons/guns/zipgun.dmi'
	icon_state = "zipgun0"
	item_state = "zipgun-solid"
	var/buildstate = 0

/obj/item/weapon/zipgunframe/New()
	..()
	ADD_SAVED_VAR(buildstate)

/obj/item/weapon/zipgunframe/update_icon()
	icon_state = "zipgun[buildstate]"

/obj/item/weapon/zipgunframe/examine(mob/user)
	. = ..()
	..(user)
	switch(buildstate)
		if(1) to_chat(user, "It has a barrel loosely fitted to the stock.")
		if(2) to_chat(user, "It has a barrel that has been secured to the stock with tape.")
		if(3) to_chat(user, "It has a trigger and firing pin assembly loosely fitted into place.")

/obj/item/weapon/zipgunframe/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing,/obj/item/pipe) && buildstate == 0)
		user.drop_from_inventory(thing)
		qdel(thing)
		user.visible_message("<span class='notice'>\The [user] fits \the [thing] to \the [src] as a crude barrel.</span>")
		add_fingerprint(user)
		buildstate++
		update_icon()
		return
	else if(istype(thing,/obj/item/weapon/tape_roll) && buildstate == 1)
		var/obj/item/weapon/tape_roll/thetape = thing
		if(!thetape.use_tape(DUCTTAPE_ZIPGUN_NEEDED))
			to_chat(user, "<span class='warning'>You need at least [DUCTTAPE_ZIPGUN_NEEDED] strips of tape to do this!</span>")
			return
		user.visible_message("<span class='notice'>\The [user] secures the assembly with \the [thing].</span>")
		add_fingerprint(user)
		buildstate++
		update_icon()
		return
	else if(istype(thing,/obj/item/device/assembly/mousetrap) && buildstate == 2)
		user.drop_from_inventory(thing)
		qdel(thing)
		user.visible_message("<span class='notice'>\The [user] takes apart \the [thing] and uses the parts to construct a crude trigger and firing mechanism inside the assembly.</span>")
		add_fingerprint(user)
		buildstate++
		update_icon()
		return
	else if(isScrewdriver(thing) && buildstate == 3)
		user.visible_message("<span class='notice'>\The [user] secures the trigger assembly with \the [thing].</span>")
		playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
		var/obj/item/weapon/gun/projectile/pirate/zipgun
		zipgun = new/obj/item/weapon/gun/projectile/pirate { starts_loaded = 0 } (loc)
		if(ismob(loc))
			var/mob/M = loc
			M.drop_from_inventory(src)
			M.put_in_hands(zipgun)
		transfer_fingerprints_to(zipgun)
		qdel(src)
		return
	else
		..()

#undef DUCTTAPE_ZIPGUN_NEEDED