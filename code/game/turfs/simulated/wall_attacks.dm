/turf/simulated/wall/proc/fail_smash(var/mob/user)
	to_chat(user, "<span class='danger'>You smash against \the [src]!</span>")
	take_damage(rand(25,75) - BruteArmor())

/turf/simulated/wall/proc/success_smash(var/mob/user)
	to_chat(user, "<span class='danger'>You smash through \the [src]!</span>")
	user.do_attack_animation(src)
	spawn(1)
		dismantle_wall(1)

/turf/simulated/wall/attack_hand(var/mob/user)
	attack_generic(user, 0, null, 0)

/turf/simulated/wall/attack_generic(var/mob/user, var/damage, var/attack_message, var/wallreturner)
	radiate()

	if(!istype(user))
		return

	add_fingerprint(user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	if(!damage || !wallreturner)
		to_chat(user, "<span class='notice'>You push \the [src], but nothing happens.</span>")
		playsound(src, hitsound, 25, 1)
		return

	take_damage(damage, "brute")

	if(wallreturner == 2)
		return success_smash(user)
	return fail_smash(user)

/turf/simulated/wall/attackby(obj/item/weapon/W as obj, mob/user as mob)

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if (!user.IsAdvancedToolUser())
		to_chat(user, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return

	//get the user's location
	if(!istype(user.loc, /turf))	return	//can't do this stuff whilst inside objects and such



	if(locate(/obj/effect/overlay/wallrot) in src)
		if(isWelder(W))
			var/obj/item/weapon/weldingtool/WT = W
			if( WT.remove_fuel(0,user) )
				to_chat(user, "<span class='notice'>You burn away the fungi with \the [WT].</span>")
				playsound(src, 'sound/items/Welder.ogg', 10, 1)
				for(var/obj/effect/overlay/wallrot/WR in src)
					qdel(WR)
				return
		else if(!is_sharp(W) && W.force >= 10 || W.force >= 20)
			to_chat(user, "<span class='notice'>\The [src] crumbles away under the force of your [W.name].</span>")
			src.dismantle_wall(1)
			return

	//THERMITE related stuff. Calls src.thermitemelt() which handles melting simulated walls and the relevant effects
	if(thermite)
		if(isWelder(W))
			var/obj/item/weapon/weldingtool/WT = W
			if( WT.remove_fuel(0,user) )
				thermitemelt(user)
				return

		else if(istype(W, /obj/item/weapon/gun/energy/plasmacutter))
			thermitemelt(user)
			return

		else if( istype(W, /obj/item/weapon/melee/energy/blade) )
			var/obj/item/weapon/melee/energy/blade/EB = W

			EB.spark_system.start()
			to_chat(user, "<span class='notice'>You slash \the [src] with \the [EB]; the thermite ignites!</span>")
			playsound(src, "sparks", 50, 1)
			playsound(src, 'sound/weapons/blade1.ogg', 50, 1)

			thermitemelt(user)
			return

	if(integrity != MaxIntegrity() && Weld(W, user, null, "You start repairing the damage to [src]."))
		repair_damage(MaxIntegrity())
		return

	// Basic dismantling.
	if(r_material)
		switch(state)
			if(0)
				if(Wrench(W, user, 10))
					state = 1
					to_chat(user, "<span class='notice'>You secure the material to \the [src].</span>")
					update_icon()
					return
				if(Wirecutter(W, user, 5, "You start removing \the [p_material.display_name]."))
					to_chat(user, "<span class='notice'>You finish removing \the [p_material.display_name].</span>")
					dismantle_wall()
					return
			if(1)
				if(Crowbar(W, user))
					state = 2
					to_chat(user, "<span class='notice'>You bend the material around \the [src].</span>")
					update_icon()
					return
				if(Wrench(W, user, 10))
					state = 0
					to_chat(user, "<span class='notice'>You unsecure the material from \the [src].</span>")
					update_icon()
					return
			if(2)
				if(Weld(W, user, null, "You start welding the material to \the [src]."))
					to_chat(user, "<span class='notice'>You weld the material to \the [src].</span>")
					state = 3
					update_icon()
					return
				if(Crowbar(W, user))
					state = 1
					to_chat(user, "<span class='notice'>You unbend the material from around \the [src].</span>")
					update_icon()
					return
			if(3)
				if(Wirecutter(W, user))
					state = 4
					to_chat(user, "<span class='notice'>You cut a hole for reinforcing rods.</span>")
					update_icon()
					return
				if(Weld(W, user, null, "You start to unweld the material from \the [src]."))
					to_chat(user, "<span class='notice'>You unweld the material from \the [src].</span>")
					state = 2
					update_icon()
					return
			if(4)
				if(istype(W, /obj/item/stack/rods))
					if(W:use(4))
						to_chat(user, "<span class='notice'>You insert the rods into \the [src].</span>")
						state = 5
						update_icon()
						return
					else
						to_chat(user, "<span class='notice'>You need more rods.</span>")
				if(Weld(W, user))
					to_chat(user, "<span class='notice'>You repair the hole for reinforcing rods.</span>")
					state = 3
					update_icon()
					return
			if(5)
				if(Screwdriver(W, user))
					state = 6
					to_chat(user, "<span class='notice'>You secure the rods to \the [src].</span>")
					update_icon()
					return
				if(Wirecutter(W, user))
					to_chat(user, "<span class='notice'>You remove the rods from \the [src].</span>")
					state = 4
					update_icon()
					return
			if(6)
				if(Weld(W, user, null, "You start to weld the rods into place."))
					to_chat(user, "<span class='notice'>You finish \the [src].</span>")
					state = null
					update_connections(1)
					update_icon()
					return
				if(Screwdriver(W, user))
					to_chat(user, "<span class='notice'>You unsecure the rods from \the [src].</span>")
					state = 5
					update_icon()
					return
			if(null)
				if(Weld(W, user, null, "You start to unweld the rods from \the [src]."))
					to_chat(user, "<span class='notice'>You unweld the rods.</span>")
					state = 6
					update_connections(1)
					update_icon()
					return
	else
		switch(state)
			if(0)
				if(Wrench(W, user))
					to_chat(user, "<span class='notice'>You secure the  material to \the [src].</span>")
					state = 1
					update_icon()
					return
				if(Wirecutter(W, user, 5, "You start removing \the [p_material.display_name]."))
					to_chat(user, "<span class='notice'>You finish removing \the [p_material.display_name].</span>")
					dismantle_wall()
					return
			if(1)
				if(Crowbar(W, user))
					to_chat(user, "<span class='notice'>You bend the material around \the [src].</span>")
					state = 2
					update_icon()
					return
				if(Wrench(W, user))
					to_chat(user, "<span class='notice'>You unsecure the material from \the [src]</span>")
					state = 0
					update_icon()
					return
			if(2)
				if(Weld(W, user, null, "You start welding the material to \the [src]."))
					to_chat(user, "<span class='notice'>You weld the material to \the [src].</span>")
					state = null
					update_connections(1)
					update_icon()
					return
				if(Crowbar(W, user))
					to_chat(user, "<span class='notice'>You unbend the material from around \the [src].</span>")
					state = 1
					update_icon()
					return
			if(null)
				if(Weld(W, user, null, "You start unwelding the material from \the [src]."))
					to_chat(user, "<span class='notice'>You unweld the material from \the [src].</span>")
					state = 2
					update_connections(1)
					update_icon()
					return

	if(W)
		radiate()
		if(is_hot(W))
			burn(is_hot(W))

	if(istype(W,/obj/item/frame))
		var/obj/item/frame/F = W
		F.try_build(src)
		return

	else if(!istype(W,/obj/item/weapon/rcd) && !istype(W, /obj/item/weapon/reagent_containers))
		if(!W.force)
			return attack_hand(user)
		switch(!istool(W) && take_damage(W.force, W.damtype))
			if(2)
				visible_message("<span class='danger'>\The [user] attacks \the [src] with \the [W] and it [material.destruction_desc]!</span>")
				return
			if(1)
				visible_message("<span class='danger'>\The [user] attacks \the [src] with \the [W]!</span>")
				return
			if(0)
				visible_message("<span class='danger'>\The [user] attacks \the [src] with \the [W], but it bounces off!</span>")
				return
		return
