/obj/item/projectile/bullet
	name = "bullet"
	icon_state = "bullet"
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	force = 25
	embed = 1
	damtype = DAM_BLUNT
	sharpness = 1
	penetration_modifier = 1.0
	var/mob_passthrough_check = 0

	muzzle_type = /obj/effect/projectile/bullet/muzzle

/obj/item/projectile/bullet/on_hit(var/atom/target, var/blocked = 0)
	if (..(target, blocked))
		var/mob/living/L = target
		shake_camera(L, 3, 2)

/obj/item/projectile/bullet/attack_mob(var/mob/living/target_mob, var/distance, var/miss_modifier)
	if(penetrating > 0 && force > 20 && prob(force))
		mob_passthrough_check = 1
	else
		mob_passthrough_check = 0
	. = ..()

	if(. == 1 && iscarbon(target_mob))
		force *= 0.7 //squishy mobs absorb KE

/obj/item/projectile/bullet/can_embed()
	//prevent embedding if the projectile is passing through the mob
	if(mob_passthrough_check)
		return 0
	return ..()

/obj/item/projectile/bullet/check_penetrate(var/atom/A)
	if(!A || !A.density) return 1 //if whatever it was got destroyed when we hit it, then I guess we can just keep going

	if(istype(A, /obj/mecha))
		return 1 //mecha have their own penetration handling

	if(ismob(A))
		if(!mob_passthrough_check)
			return 0
		return 1

	var/chance = force
	if(istype(A, /turf/simulated/wall))
		var/turf/simulated/wall/W = A
		chance = round(force/W.material.integrity*180)
	else if(istype(A, /obj/machinery/door))
		var/obj/machinery/door/D = A
		chance = round(force/D.get_max_health()*180)
		if(D.glass) chance *= 2
	else if(istype(A, /obj/structure/girder))
		chance = 100

	if(prob(chance))
		if(A.opacity)
			//display a message so that people on the other side aren't so confused
			A.visible_message("<span class='warning'>\The [src] pierces through \the [A]!</span>")
		return 1

	return 0

//For projectiles that actually represent clouds of projectiles
/obj/item/projectile/bullet/pellet
	name = "shrapnel" //'shrapnel' sounds more dangerous (i.e. cooler) than 'pellet'
	force = 4
	//icon_state = "bullet" //TODO: would be nice to have it's own icon state
	var/pellets = 4			//number of pellets
	var/range_step = 2		//projectile will lose a fragment each time it travels this distance. Can be a non-integer.
	var/base_spread = 90	//lower means the pellets spread more across body parts. If zero then this is considered a shrapnel explosion instead of a shrapnel cone
	var/spread_step = 10	//higher means the pellets spread more across body parts with distance

/obj/item/projectile/bullet/pellet/Bumped()
	. = ..()
	bumped = 0 //can hit all mobs in a tile. pellets is decremented inside attack_mob so this should be fine.

/obj/item/projectile/bullet/pellet/proc/get_pellets(var/distance)
	var/pellet_loss = round((distance - 1)/range_step) //pellets lost due to distance
	return max(pellets - pellet_loss, 1)

/obj/item/projectile/bullet/pellet/attack_mob(var/mob/living/target_mob, var/distance, var/miss_modifier)
	if (pellets < 0) return 1

	var/total_pellets = get_pellets(distance)
	var/spread = max(base_spread - (spread_step*distance), 0)

	//shrapnel explosions miss prone mobs with a chance that increases with distance
	var/prone_chance = 0
	if(!base_spread)
		prone_chance = max(spread_step*(distance - 2), 0)

	var/hits = 0
	for (var/i in 1 to total_pellets)
		if(target_mob.lying && target_mob != original && prob(prone_chance))
			continue

		//pellet hits spread out across different zones, but 'aim at' the targeted zone with higher probability
		//whether the pellet actually hits the def_zone or a different zone should still be determined by the parent using get_zone_with_miss_chance().
		var/old_zone = def_zone
		def_zone = ran_zone(def_zone, spread)
		if (..()) hits++
		def_zone = old_zone //restore the original zone the projectile was aimed at

	pellets -= hits //each hit reduces the number of pellets left
	if (hits >= total_pellets || pellets <= 0)
		return 1
	return 0

/obj/item/projectile/bullet/pellet/get_structure_damage()
	var/distance = get_dist(loc, starting)
	return ..() * get_pellets(distance)

/obj/item/projectile/bullet/pellet/Move()
	. = ..()

	//If this is a shrapnel explosion, allow mobs that are prone to get hit, too
	if(. && !base_spread && isturf(loc))
		for(var/mob/living/M in loc)
			if(M.lying || !M.CanPass(src, loc, 0.5, 0)) //Bump if lying or if we would normally Bump.
				if(Bump(M)) //Bump will make sure we don't hit a mob multiple times
					return

/* short-casing projectiles, like the kind used in pistols or SMGs */

/obj/item/projectile/bullet/pistol
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	force = 16 //9mm, .38, etc
	armor_penetration = 13.5

/obj/item/projectile/bullet/pistol/medium
	force = 20 //.45
	armor_penetration = 14.5

/obj/item/projectile/bullet/pistol/medium/smg
	fire_sound = 'sound/weapons/gunshot/gunshot_smg.ogg'
	force = 18 //10mm
	armor_penetration = 15

/obj/item/projectile/bullet/pistol/medium/revolver
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	force = 26 //.44 magnum or something

/obj/item/projectile/bullet/pistol/strong //matebas
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	force = 33 //.50AE
	armor_penetration = 30

/obj/item/projectile/bullet/pistol/strong/revolver //revolvers
	force = 30 //Revolvers get snowflake bullets, to keep them relevant
	armor_penetration = 20

/obj/item/projectile/bullet/pistol/rubber //"rubber" bullets
	name = "rubber bullet"
	damtype = DAM_BLUNT
	force = 2.5
	agony = 20
	embed = 0
	sharpness = 0
	armor_penetration = 2.5

/* shotgun projectiles */

/obj/item/projectile/bullet/shotgun
	name = "slug"
	fire_sound = 'sound/weapons/gunshot/shotgun.ogg'
	force = 28
	armor_penetration = 20

/obj/item/projectile/bullet/shotgun/beanbag		//because beanbags are not bullets
	name = "beanbag"
	damtype = DAM_BLUNT
	force = 5
	agony = 25
	embed = 0
	sharpness = 0
	mass = 0.008

//Should do about 80 damage at 1 tile distance (adjacent), and 50 damage at 3 tiles distance.
//Overall less damage than slugs in exchange for more damage at very close range and more embedding
/obj/item/projectile/bullet/pellet/shotgun
	name = "shrapnel"
	fire_sound = 'sound/weapons/gunshot/shotgun.ogg'
	force = 7
	pellets = 6
	range_step = 1
	spread_step = 10
	damtype = DAM_BULLET
	mass = 0.004

/obj/item/projectile/bullet/pellet/shotgun/rubber
	name = "shrapnel"
	damtype = DAM_BLUNT
	force = 3
	agony = 10
	embed = 0
	sharpness = 0
	range_step = 1
	spread_step = 12
	base_spread = 80
	mass = 0.008

/* "Rifle" rounds */

/obj/item/projectile/bullet/rifle
	armor_penetration = 25
	penetrating = 1
	force = 23

/obj/item/projectile/bullet/rifle/a556
	fire_sound = 'sound/weapons/gunshot/gunshot3.ogg'
	force = 26
	mass = 0.004

/obj/item/projectile/bullet/rifle/a762
	fire_sound = 'sound/weapons/gunshot/gunshot2.ogg'
	force = 26
	armor_penetration = 30
	mass = 0.009

/obj/item/projectile/bullet/rifle/a145
	fire_sound = 'sound/weapons/gunshot/sniper.ogg'
	force = 38
	stun = 3
	weaken = 3
	penetrating = 2
	armor_penetration = 80
	hitscan = 1 //so the PTR isn't useless as a sniper weapon
	penetration_modifier = 1.25
	mass = 0.0665

/obj/item/projectile/bullet/rifle/a145/apds
	force = 43
	penetrating = 5
	armor_penetration = 95
	penetration_modifier = 1.5

/* Miscellaneous */

/obj/item/projectile/bullet/suffocationbullet//How does this even work?
	name = "co bullet"
	force = 5
	damtype = DAM_OXY

/obj/item/projectile/bullet/cyanideround
	name = "poison bullet"
	force = 10
	damtype = DAM_BIO

/obj/item/projectile/bullet/burstbullet
	name = "exploding bullet"
	force = 15
	embed = 0

/obj/item/projectile/bullet/gyro
	fire_sound = 'sound/effects/Explosion1.ogg'
	mass = 0.012

/obj/item/projectile/bullet/gyro/on_hit(var/atom/target, var/blocked = 0)
	if(isturf(target))
		explosion(target, -1, 0, 2)
	..()

/obj/item/projectile/bullet/blank
	invisibility = 101
	force = 1
	embed = 0

/* Practice */

/obj/item/projectile/bullet/pistol/practice
	force = 3

/obj/item/projectile/bullet/rifle/a762/practice
	force = 3

/obj/item/projectile/bullet/shotgun/practice
	name = "practice"
	force = 3

/obj/item/projectile/bullet/pistol/cap
	name = "cap"
	invisibility = 101
	fire_sound = null
	damtype = DAM_PAIN
	force = 0
	nodamage = 1
	embed = 0
	sharpness = 0

/obj/item/projectile/bullet/pistol/cap/Process()
	loc = null
	qdel(src)

/obj/item/projectile/bullet/rock //spess dust
	name = "micrometeor"
	icon_state = "rock"
	force = 40
	armor_penetration = 25
	kill_count = 255
	mass = 1

/obj/item/projectile/bullet/rock/New()
	icon_state = "rock[rand(1,3)]"
	pixel_x = rand(-10,10)
	pixel_y = rand(-10,10)
	..()
