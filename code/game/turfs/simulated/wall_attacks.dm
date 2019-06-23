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

	take_damage(damage, DAM_BLUNT)

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
			var/obj/item/weapon/tool/weldingtool/WT = W
			if( WT.remove_fuel(0,user) )
				to_chat(user, SPAN_NOTICE("You burn away the fungi with \the [WT]."))
				playsound(src, 'sound/items/Welder.ogg', 10, 1)
				for(var/obj/effect/overlay/wallrot/WR in src)
					qdel(WR)
				return
		else if(!is_sharp(W) && W.force >= 10 || W.force >= 20)
			to_chat(user, SPAN_NOTICE("\The [src] crumbles away under the force of your [W.name]."))
			src.dismantle_wall(1)
			return

	//THERMITE related stuff. Calls src.thermitemelt() which handles melting simulated walls and the relevant effects
	if(thermite)
		if(isWelder(W))
			var/obj/item/weapon/tool/weldingtool/WT = W
			if( WT.remove_fuel(0,user) )
				thermitemelt(user)
				return

		else if(istype(W, /obj/item/weapon/gun/energy/plasmacutter))
			thermitemelt(user)
			return

		else if( istype(W, /obj/item/weapon/melee/energy/blade) )
			var/obj/item/weapon/melee/energy/blade/EB = W

			EB.spark_system.start()
			to_chat(user, SPAN_NOTICE("You slash \the [src] with \the [EB]; the thermite ignites!"))
			playsound(src, "sparks", 50, 1)
			playsound(src, 'sound/weapons/blade1.ogg', 50, 1)

			thermitemelt(user)
			return

	if(integrity != MaxIntegrity() && Weld(W, user, null, "You start repairing the damage to [src]."))
		repair_damage(MaxIntegrity())
		return

	switch(state)
		if(0)
			if(Wrench(W, user))
				to_chat(user, SPAN_NOTICE("You secure the  material to \the [src]."))
				state = 1
				update_icon()
				return
			if(Wirecutter(W, user, 5, "You start removing \the [material.display_name]."))
				to_chat(user, SPAN_NOTICE("You finish removing \the [material.display_name]."))
				dismantle_wall()
				return
		if(1)
			if(Crowbar(W, user))
				to_chat(user, SPAN_NOTICE("You bend the material around \the [src]."))
				state = 2
				update_icon()
				return
			if(Wrench(W, user))
				to_chat(user, SPAN_NOTICE("You unsecure the material from \the [src]"))
				state = 0
				update_icon()
				return
		if(2)
			if(Weld(W, user, null, "You start welding the material to \the [src]."))
				to_chat(user, SPAN_NOTICE("You weld the material to \the [src]."))
				state = null
				update_connections(TRUE)
				update_icon()
				return
			if(Crowbar(W, user))
				to_chat(user, SPAN_NOTICE("You unbend the material from around \the [src]."))
				state = 1
				update_icon()
				return
		// NOTE: The weld directly above skips to the bottom via state = null
		// If we decide to reinforce we come back up here
		if(3)
			if(Wirecutter(W, user))
				state = 4
				to_chat(user, SPAN_NOTICE("You cut holes for reinforcing rods."))
				update_icon()
				return
			if(Screwdriver(W, user))
				to_chat(user, SPAN_NOTICE("You unprepare \the [src]."))
				state = null
				update_icon()
				return
		if(4)
			if(istype(W, /obj/item/stack/material/rods))
				if(UseMaterial(W, user, null, null, null, null, 4))
					var/obj/item/stack/material/rods/R = W
					reinf_material = SSmaterials.get_material_by_name(R.default_type)
					to_chat(user, SPAN_NOTICE("You insert the rods into \the [src]."))
					state = 5
					update_material(1)
					return
			if(Weld(W, user))
				to_chat(user, SPAN_NOTICE("You repair the holes made for reinforcing rods."))
				state = 3
				update_icon()
				return
		if(5)
			if(Screwdriver(W, user))
				state = 6
				to_chat(user, SPAN_NOTICE("You secure the rods to \the [src]."))
				update_icon()
				return
			if(Wirecutter(W, user))
				to_chat(user, SPAN_NOTICE("You remove the rods from \the [src]."))
				new reinf_material.stack_type(get_turf(src), 2)
				state = 4
				update_icon()
				return
		if(6)
			if(Weld(W, user, null, "You start to weld the rods into place."))
				to_chat(user, SPAN_NOTICE("You finish \the [src]."))
				state = null
				update_connections(TRUE)
				update_icon()
				return
			if(Screwdriver(W, user))
				to_chat(user, SPAN_NOTICE("You unsecure the rods from \the [src]."))
				state = 5
				update_icon()
				return
		if(null)
			if(!reinf_material && Weld(W, user, null, "You start unwelding the material from \the [src]."))
				to_chat(user, SPAN_NOTICE("You unweld the material from \the [src]."))
				state = 2
				update_connections(TRUE)
				update_icon()
				return
			if(!reinf_material && Screwdriver(W, user))
				to_chat(user, SPAN_NOTICE("You prepare \the [src] for reinforcement."))
				state = 3
				update_icon()
				return
			if(reinf_material && Weld(W, user, null, "You start to unweld the rods from \the [src]."))
				to_chat(user, SPAN_NOTICE("You unweld the rods."))
				state = 6
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
				visible_message(SPAN_DANGER("\The [user] attacks \the [src] with \the [W] and it [material.destruction_desc]!"))
				return
			if(1)
				visible_message(SPAN_DANGER("\The [user] attacks \the [src] with \the [W]!"))
				return
			if(0)
				visible_message(SPAN_DANGER("\The [user] attacks \the [src] with \the [W], but it bounces off!"))
				return
		return