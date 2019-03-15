/obj/item/projectile/ion
	name = "ion bolt"
	icon_state = "ion"
	fire_sound = 'sound/weapons/Laser.ogg'
	force = 0
	damtype = DAM_EMP
	nodamage = TRUE
	var/pulse_range = 1

	on_hit(var/atom/target, var/blocked = 0)
		empulse(target, pulse_range, pulse_range)
		return 1

/obj/item/projectile/ion/small
	name = "ion pulse"
	pulse_range = 0

/obj/item/projectile/bullet/gyro
	name ="explosive bolt"
	icon_state= "bolter"
	force = 25
	sharpness = 1
	mass = 0.012

	on_hit(var/atom/target, var/blocked = 0)
		explosion(target, -1, 0, 2)
		return 1

/obj/item/projectile/temp
	name = "freeze beam"
	icon_state = "ice_2"
	fire_sound = 'sound/weapons/pulse3.ogg'
	force = 0
	damtype = DAM_BURN
	nodamage = TRUE
	temperature = T0C - 80


	on_hit(var/atom/target, var/blocked = 0)//These two could likely check temp protection on the mob
		if(istype(target, /mob/living))
			var/mob/M = target
			M.bodytemperature = temperature
		return 1

/obj/item/projectile/meteor
	name = "meteor"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "smallf"
	force = 0
	damtype = DAM_BULLET
	nodamage = TRUE

	Bump(atom/A as mob|obj|turf|area)
		if(A == firer)
			loc = A.loc
			return

		sleep(-1) //Might not be important enough for a sleep(-1) but the sleep/spawn itself is necessary thanks to explosions and metoerhits

		if(src)//Do not add to this if() statement, otherwise the meteor won't delete them
			if(A)

				A.ex_act(2)
				playsound(src.loc, 'sound/effects/meteorimpact.ogg', 40, 1)

				for(var/mob/M in range(10, src))
					if(!M.stat && !istype(M, /mob/living/silicon/ai))\
						shake_camera(M, 3, 1)
				qdel(src)
				return 1
		else
			return 0

/obj/item/projectile/energy/floramut
	name = "alpha somatoray"
	icon_state = "energy"
	fire_sound = 'sound/effects/stealthoff.ogg'
	force = 0
	damtype = DAM_RADS
	nodamage = TRUE

	on_hit(var/atom/target, var/blocked = 0)
		var/mob/living/M = target
		if(ishuman(target))
			var/mob/living/carbon/human/H = M
			if((H.species.species_flags & SPECIES_FLAG_IS_PLANT) && (H.nutrition < 500))
				if(prob(15))
					H.apply_effect((rand(30,80)),IRRADIATE,blocked = H.getarmor(null, DAM_RADS))
					H.Weaken(5)
					for (var/mob/V in viewers(src))
						V.show_message("<span class='warning'>[M] writhes in pain as \his vacuoles boil.</span>", 3, "<span class='warning'>You hear the crunching of leaves.</span>", 2)
				if(prob(35))
					if(prob(80))
						randmutb(M)
						domutcheck(M,null)
					else
						randmutg(M)
						domutcheck(M,null)
				else
					M.adjustFireLoss(rand(5,15))
					M.show_message("<span class='danger'>The radiation beam singes you!</span>")
		else if(istype(target, /mob/living/carbon/))
			M.show_message("<span class='notice'>The radiation beam dissipates harmlessly through your body.</span>")
		else
			return 1

/obj/item/projectile/energy/floramut/gene
	name = "gamma somatoray"
	icon_state = "energy2"
	fire_sound = 'sound/effects/stealthoff.ogg'
	force = 0
	damtype = DAM_RADS
	nodamage = TRUE
	var/decl/plantgene/gene = null

/obj/item/projectile/energy/florayield
	name = "beta somatoray"
	icon_state = "energy2"
	fire_sound = 'sound/effects/stealthoff.ogg'
	force = 0
	damtype = DAM_RADS
	nodamage = TRUE

	on_hit(var/atom/target, var/blocked = 0)
		var/mob/M = target
		if(ishuman(target)) //These rays make plantmen fat.
			var/mob/living/carbon/human/H = M
			if((H.species.species_flags & SPECIES_FLAG_IS_PLANT) && (H.nutrition < 500))
				H.nutrition += 30
		else if (istype(target, /mob/living/carbon/))
			M.show_message("<span class='notice'>The radiation beam dissipates harmlessly through your body.</span>")
		else
			return 1


/obj/item/projectile/beam/mindflayer
	name = "flayer ray"

	on_hit(var/atom/target, var/blocked = 0)
		if(ishuman(target))
			var/mob/living/carbon/human/M = target
			M.confused += rand(5,8)

/obj/item/projectile/chameleon
	name = "bullet"
	icon_state = "bullet"
	force = 1 // stop trying to murderbone with a fake gun dumbass!!!
	embed = FALSE // nope
	nodamage = TRUE
	damtype = DAM_PAIN
	muzzle_type = /obj/effect/projectile/bullet/muzzle

/obj/item/projectile/plasma
	name = "plasma blast"
	icon_state = "purplelaser"
	damtype = DAM_ENERGY
	sharpness = 1
	force = 20
	var/pressure_decrease_active = FALSE
	var/pressure_decrease = 0.25
	kill_count=15

	Initialize()
		. = ..()
		if(!is_below_sound_pressure(get_turf(src)))
			name = "weakened [name]"
			force = force * pressure_decrease
			pressure_decrease_active = TRUE
