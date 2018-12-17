#define IMPROVRIFLE_TAPE_NEEDED 30

/obj/item/weapon/gun/projectile/boltaction/imprifle
	name = "improvised rifle"
	icon = 'icons/obj/weapons/improvised_rifle.dmi'
	desc = "A shoddy 7.62 improvised rifle."
	wielded_item_state = "woodarifle-wielded"
	icon_state = "308bolt"
	item_state = "dshotgun" //placeholder
	w_class = ITEM_SIZE_HUGE
	one_hand_penalty = 4
	force = 10
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 1)
	caliber = "a762"
	//fire_sound = 'sound/weapons/sniper.ogg'
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING
	max_shells = 5
	ammo_type = /obj/item/ammo_casing/a762
	accuracy = -1
	jam_chance = 5


/obj/item/weapon/gun/projectile/boltaction/imprifle/impriflesawn
	name = "improvised short rifle"
	icon = 'icons/obj/weapons/improvised_rifle.dmi'
	desc = "A crudely cut down 7.62 improvised rifle."
	icon_state = "308boltsawed"
	item_state = "sawnshotgun" //placeholder
	w_class = ITEM_SIZE_NORMAL
	one_hand_penalty = 0
	force = 4
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 1)
	caliber = "a762"
	//fire_sound = 'sound/weapons/sniper.ogg'
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING
	max_shells = 3
	ammo_type = /obj/item/ammo_casing/a762
	accuracy = -2
	jam_chance = 10

/obj/item/weapon/gun/projectile/boltaction/imprifle/impriflesawn/update_icon()
	if(bolt_open)
		icon_state = "308boltsawed_alt"
	else
		icon_state = "308boltsawed"
//rifle construction

/obj/item/weapon/imprifleframe/imprifleframesawn
	name = "unfinished improvised short rifle"
	desc = "An almost-complete improvised short rifle."
	icon = 'icons/obj/weapons/improvised_rifle.dmi'
	icon_state = "308boltsawed"
	item_state = "sawnshotgun"

/obj/item/weapon/imprifleframe
	name = "improvised rifle stock"
	desc = "A half-finished improvised rifle."
	icon = 'icons/obj/weapons/improvised_rifle.dmi'
	icon_state = "308boltframe0"
	item_state = "sawnshotgun"
	var/buildstate = 0

/obj/item/weapon/imprifleframe/update_icon()
	icon_state = "308boltframe[buildstate]"

/obj/item/weapon/imprifleframe/examine(mob/user)
	..(user)
	switch(buildstate)
		if(1) to_chat(user, "It has an unfinished pipe barrel in place on the wooden furniture.")
		if(2) to_chat(user, "It has an unfinished pipe barrel taped in place.")
		if(3) to_chat(user, "It has an unfinished reinforced pipe barrel taped in place.")
		if(4) to_chat(user, "It has a reinforced pipe barrel secured on the wooden furniture.")
		if(5) to_chat(user, "It has an unsecured reciever in place.")
		if(6) to_chat(user, "It has a secured reciever in place.")
		if(7) to_chat(user, "It has an unfinished pipe bolt in place.")
		if(8) to_chat(user, "It has a finished unsecured pipe bolt in place.")
		if(9) to_chat(user, "It has a finished secured bolt in place.")

/obj/item/weapon/imprifleframe/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/pipe))
		if(buildstate == 0)
			user.drop_from_inventory(W)
			qdel(W)
			user.visible_message("[user] places the pipe on \the [src]'s stock.", "<span class='notice'>You place the piping on the stock.</span>")
			buildstate++
			update_icon()
			return
		if(buildstate == 7)
			user.drop_from_inventory(W)
			qdel(W)
			user.visible_message("[user] places a makeshift bolt on \the [src]'s frame.", "<span class='notice'>You install a bolt on the frame.</span>")
			buildstate++
			playsound(src.loc, 'sound/items/syringeproj.ogg', 100, 1)
			update_icon()
			return
	else if(istype(W,/obj/item/weapon/tape_roll))
		var/obj/item/weapon/tape_roll/tape = W
		if(buildstate == 1)
			if(tape.use_tape(IMPROVRIFLE_TAPE_NEEDED))
				user.visible_message("[user] tapes generously \the [src]'s barrel to its stock.", "<span class='notice'>You secure the barrel to the wooden furniture with [tape].</span>")
				buildstate++
				update_icon()
			else
				to_chat(user, "<span class='notice'>You need at least [IMPROVRIFLE_TAPE_NEEDED] segments of [tape] to complete this task.</span>")
			return
	else if(istype(W,/obj/item/weapon/screwdriver))
		if(buildstate == 2)
			user.visible_message("[user] screws \the [src]'s barrel to its stock.", "<span class='notice'>You further secure the barrel to the wooden furniture.</span>")
			buildstate++
			playsound(src.loc, 'sound/items/Screwdriver2.ogg', 100, 1)
			return
		if(buildstate == 6)
			user.visible_message("[user] secures \the [src]'s receiver.", "<span class='notice'>You secure the reciever.</span>")
			buildstate++
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
			return
	else if(istype(W,/obj/item/stack/material) && W.get_material_name() == MATERIAL_PLASTEEL)
		if(buildstate == 3)
			var/obj/item/stack/material/P = W
			if(P.use(5))
				user.visible_message("[user] reinforces the barrel of \the [src] with [P].", "<span class='notice'>You reinforce the barrel with [P].</span>")
				buildstate++
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 100, 1)
			else
				to_chat(user, "<span class='notice'>You need at least five plasteel sheets to complete this task.</span>")
			return
	else if(istype(W,/obj/item/weapon/wrench))
		if(buildstate == 4)
			user.visible_message("[user] wrenches \the [src]'s barrel firmly.", "<span class='notice'>You secure the reinforced barrel.</span>")
			buildstate++
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			return
	else if(istype(W,/obj/item/stack/material) && W.get_material_name() == MATERIAL_STEEL)
		if(buildstate == 5)
			var/obj/item/stack/material/P = W
			if(P.use(10))
				user.visible_message("[user] assembles a roughly made receiver and install it on \the [src].", "<span class='notice'>You assemble and install a roughly made reciever onto the frame</span>")
				buildstate++
				update_icon()
				playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
			else
				to_chat(user, "<span class='notice'>You need at least ten steel sheets to complete this task.</span>")
			return
	else if(istype(W,/obj/item/stack/rods))
		if(buildstate == 8)
			var/obj/item/stack/rods/R = W
			if(R.use(3))
				user.visible_message("[user] attaches [R] onto \the [src]'s bolt.", "<span class='notice'>You attach the rods to the bolt.</span>")
				buildstate++
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
			else
				to_chat(user, "<span class='notice'>You need at least 3 rods to complete this task.</span>")
			return
	else if(istype(W,/obj/item/weapon/weldingtool))
		if(buildstate == 9)
			var/obj/item/weapon/weldingtool/T = W
			if(T.remove_fuel(5,user))
				if(!src || !T.isOn()) return
				playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
			user.visible_message("[user] is appling welds onto \the [src].", "<span class='notice'>You secure the improvised rifle's various parts.</span>")
			var/obj/item/weapon/gun/projectile/boltaction/imprifle/emptymag = new /obj/item/weapon/gun/projectile/boltaction/imprifle(get_turf(src))
			emptymag.loaded = list()
			qdel(src)
		return
	else if(istype(W,/obj/item/weapon/circular_saw))
		if(buildstate == 9)
			user.visible_message("[user] is sawing off part of \the [src].", "<span class='notice'>You saw the barrel on the unfinished improvised rifle down.</span>")
			new /obj/item/weapon/imprifleframe/imprifleframesawn(get_turf(src))
			playsound(src.loc, 'sound/weapons/circsawhit.ogg', 100, 1)
			qdel(src)
		return


/obj/item/weapon/imprifleframe/imprifleframesawn/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/weldingtool))
		if(buildstate == 0)
			var/obj/item/weapon/weldingtool/T = W
			if(T.remove_fuel(5,user))
				if(!src || !T.isOn()) return
				playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
			user.visible_message("[user] is appling welds onto \the [src].", "<span class='notice'>You secure the improvised rifle's various parts.</span>")
			var/obj/item/weapon/gun/projectile/boltaction/imprifle/impriflesawn/emptymag = new /obj/item/weapon/gun/projectile/boltaction/imprifle/impriflesawn(get_turf(src))
			emptymag.loaded = list()
			qdel(src)
		return
	..()

#undef IMPROVRIFLE_TAPE_NEEDED
