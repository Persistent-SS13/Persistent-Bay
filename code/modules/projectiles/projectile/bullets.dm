/obj/item/projectile/bullet
	name = "bullet"
	icon_state = "bullet"
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	force = 25
	damtype = DAM_BULLET
	nodamage = 0
	embed = 1
	sharpness = 1
	penetration_modifier = 1.0
	var/mob_passthrough_check = 0
	muzzle_type = /obj/effect/projectile/bullet/muzzle
	miss_sounds = list('sound/weapons/guns/miss1.ogg','sound/weapons/guns/miss2.ogg','sound/weapons/guns/miss3.ogg','sound/weapons/guns/miss4.ogg')

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
	if(QDELETED(A) || !A.density) return 1 //if whatever it was got destroyed when we hit it, then I guess we can just keep going

	if(istype(A, /obj/mecha))
		return 1 //mecha have their own penetration handling

	if(ismob(A))
		if(!mob_passthrough_check)
			return 0
		return 1

	var/chance = force
	if(has_extension(A, /datum/extension/penetration))
		var/datum/extension/penetration/P = get_extension(A, /datum/extension/penetration)
		chance = P.PenetrationProbability(chance, force, damtype)

	if(prob(chance))
		if(A.opacity)
			//display a message so that people on the other side aren't so confused
			A.visible_message("<span class='warning'>\The [src] pierces through \the [A]!</span>")
		return 1

	return 0

//---------------------------------------------------
//	Pellets
//---------------------------------------------------
//For projectiles that actually represent clouds of projectiles
/obj/item/projectile/bullet/pellet
	name = "shrapnel" //'shrapnel' sounds more dangerous (i.e. cooler) than 'pellet'
	force = 22.5
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

//---------------------------------------------------
//	Rubber
//---------------------------------------------------
/obj/item/projectile/bullet/rubber //"rubber" bullets
	name = "rubber bullet"
	damtype = DAM_BLUNT
	force = 2.5
	agony = 15
	embed = 0
	sharpness = 0
	penetration_modifier = 0.1
	armor_penetration = 1

//---------------------------------------------------
//	Shorter Pistol Bullets
//---------------------------------------------------
/obj/item/projectile/bullet/pistol
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	distance_falloff = 3

//---------------------------------------------------
//	Shorter SMG Bullets
//---------------------------------------------------
/obj/item/projectile/bullet/smg
	fire_sound = 'sound/weapons/gunshot/gunshot_smg.ogg'

//---------------------------------------------------
//	Shorter Revolver Bullets
//---------------------------------------------------
/obj/item/projectile/bullet/revolver
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'

//---------------------------------------------------
//	9mm Bullet (481 J)
//---------------------------------------------------
/obj/item/projectile/bullet/pistol/c9mm
	force = 17 //9mm, .38, etc
	armor_penetration = 13.5
	penetration_modifier = 0.8
	distance_falloff = 2
/obj/item/projectile/bullet/rubber/c9mm
	distance_falloff = 4

/obj/item/projectile/bullet/smg/c9mm //SMGs gotta be nerfed a bit since they fire quickly
	force = 7
	armor_penetration = 10
	penetration_modifier = 0.6
	distance_falloff = 4

//---------------------------------------------------
//	.22lr Bullet (178 J)
//---------------------------------------------------
/obj/item/projectile/bullet/pistol/c22lr
	force = 9
	armor_penetration = 3
	penetration_modifier = 0.7
	distance_falloff = 5

//---------------------------------------------------
//	.45 Bullet (483 J)
//---------------------------------------------------
/obj/item/projectile/bullet/pistol/c45
	force = 18 //.45
	armor_penetration = 14.5
	penetration_modifier = 1.2
	distance_falloff = 3
/obj/item/projectile/bullet/rubber/c45
	distance_falloff = 6

/obj/item/projectile/bullet/smg/c45 //SMGs gotta be nerfed a bit since they fire quickly
	force = 10
	armor_penetration = 12
	penetration_modifier = 1.2
	distance_falloff = 4

//---------------------------------------------------
//	.357 Bullet (790 J)
//---------------------------------------------------
/obj/item/projectile/bullet/pistol/c357
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	force = 24 
	penetration_modifier = 1.3
	armor_penetration = 16
	mass = 8 GRAMS

//---------------------------------------------------
//	.38 Bullet (358 J)
//---------------------------------------------------
/obj/item/projectile/bullet/pistol/c38
	force = 12
	penetration_modifier = 0.8
	armor_penetration = 12
	distance_falloff = 3
	mass = 9.5 GRAMS

//---------------------------------------------------
//	.44 Bullet (1,005 J)
//---------------------------------------------------
/obj/item/projectile/bullet/pistol/c44
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	force = 28 //.44 magnum or something
	armor_penetration = 25
	penetration_modifier = 1.7
	distance_falloff = 2.5
	mass = 16 GRAMS

//---------------------------------------------------
//	.50 Bullet (2,200 J)
//---------------------------------------------------
/obj/item/projectile/bullet/pistol/c50 
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	force = 35 //.50AE
	armor_penetration = 30
	penetration_modifier = 2.1
	distance_falloff = 2.5
	mass = 19 GRAMS

//---------------------------------------------------
//	.50 Bullet Revolver
//---------------------------------------------------
/obj/item/projectile/bullet/revolver/c50 //revolvers
	force = 40 //Revolvers get snowflake bullets, to keep them relevant
	armor_penetration = 30
	penetration_modifier = 1.8
	distance_falloff = 2.5
	mass = 19 GRAMS

//---------------------------------------------------
//	4mm Flechette
//---------------------------------------------------
//4mm. Tiny, very low damage, does not embed, but has very high penetration. Only to be used for the experimental SMG.
/obj/item/projectile/bullet/flechette
	fire_sound = 'sound/weapons/gunshot/gunshot_4mm.ogg'
	force = 8
	penetrating = 1
	penetration_modifier = 0.3
	armor_penetration = 70
	embed = 0
	distance_falloff = 2
	mass = 0.001

/* shotgun projectiles */
//---------------------------------------------------
//	12 Gauge Slug (2,135J)
//---------------------------------------------------
/obj/item/projectile/bullet/shotgun
	name = "slug"
	fire_sound = 'sound/weapons/gunshot/shotgun.ogg'
	force = 32
	penetrating = 1
	armor_penetration = 20
	penetration_modifier = 1.5
	distance_falloff = 4
	mass = 24 GRAMS

//---------------------------------------------------
//	12 Gauge BeanBag
//---------------------------------------------------
/obj/item/projectile/bullet/shotgun/beanbag		//because beanbags are not bullets
	name = "beanbag"
	damtype = DAM_BLUNT
	force = 5
	agony = 25
	embed = 0
	penetration_modifier = 0.1
	armor_penetration = 0
	distance_falloff = 6
	sharpness = 0
	mass = 40 GRAMS

//---------------------------------------------------
//	12 Gauge Pellets (2,135J)
//---------------------------------------------------
//Should do about 80 damage at 1 tile distance (adjacent), and 50 damage at 3 tiles distance.
//Overall less damage than slugs in exchange for more damage at very close range and more embedding
/obj/item/projectile/bullet/pellet/shotgun
	name = "pellet"
	fire_sound = 'sound/weapons/gunshot/shotgun.ogg'
	force = 5
	pellets = 6
	range_step = 1
	spread_step = 10
	damtype = DAM_BULLET
	distance_falloff = 4
	penetration_modifier = 0.4
	mass = 3 GRAMS //a pellet

//---------------------------------------------------
//	12 Gauge Rubber Balls
//---------------------------------------------------
/obj/item/projectile/bullet/pellet/shotgun/rubber
	name = "rubber ball"
	damtype = DAM_BLUNT
	force = 5
	agony = 15
	embed = 0
	sharpness = 0
	range_step = 1
	spread_step = 12
	base_spread = 80
	distance_falloff = 6
	penetration_modifier = 0.1
	mass = 14 GRAMS

/* "Rifle" rounds */
//---------------------------------------------------
//	Rifle Bullets
//---------------------------------------------------
/obj/item/projectile/bullet/rifle
	fire_sound = 'sound/weapons/gunshot/gunshot3.ogg'
	force = 15
	armor_penetration = 25
	penetration_modifier = 1.5
	penetrating = 1
	distance_falloff = 1.5
	mass = 4 GRAMS

//---------------------------------------------------
//	5.56mm Rifle Bullet (1,755 J)
//---------------------------------------------------
/obj/item/projectile/bullet/rifle/c556
	fire_sound = 'sound/weapons/gunshot/gunshot3.ogg'
	force = 30
	armor_penetration = 15
	penetration_modifier = 1.5
	penetrating = 1
	distance_falloff = 1.5
	mass = 4 GRAMS
/obj/item/projectile/bullet/rifle/c556/practice
	force = 3

//---------------------------------------------------
//	7.62mm Rifle Bullet (3,470 J)
//---------------------------------------------------
/obj/item/projectile/bullet/rifle/c762
	fire_sound = 'sound/weapons/gunshot/gunshot2.ogg'
	force = 42
	armor_penetration = 25
	penetration_modifier = 1.8
	distance_falloff = 2
	mass = 10 GRAMS
/obj/item/projectile/bullet/rifle/c762/practice
	force = 3

//---------------------------------------------------
//	14.5mm Rifle Bullet (32,200 J)
//---------------------------------------------------
/obj/item/projectile/bullet/rifle/c145
	fire_sound = 'sound/weapons/gunshot/sniper.ogg'
	force = 52
	weaken = 2
	penetrating = 5
	armor_penetration = 80
	//hitscan = 1 //so the PTR isn't useless as a sniper weapon
	penetration_modifier = 3.1
	distance_falloff = 0.5
	mass = 64 GRAMS

//---------------------------------------------------
//	14.5mm Rifle Armor Piercing Discarding Sabot
//---------------------------------------------------
/obj/item/projectile/bullet/rifle/c145/apds
	force = 32
	penetrating = 6
	armor_penetration = 95
	penetration_modifier = 1.6 //Internal damage, nothing to do with penetration..
	distance_falloff = 0.25

/* Miscellaneous */
//---------------------------------------------------
//	Gyrojet Rocket
//---------------------------------------------------
//obj/item/projectile/bullet/gyro
//	force = 25
//	penetrating = 1
//	armor_penetration = 10
//	penetration_modifier = 1.5
//	distance_falloff = 0.5
//	mass = 0.012

//Gyrojet rounds don't explode.. They're meant to deal kinectic damage
//obj/item/projectile/bullet/gyro/on_hit(var/atom/target, var/blocked = 0)
	// if(isturf(target))
	// 	explosion(target, -1, 0, 2)
	//..()

//---------------------------------------------------
//	Blanks
//---------------------------------------------------
/obj/item/projectile/bullet/blank
	invisibility = 101
	damtype = DAM_BURN
	force = 0.1
	embed = 0
	armor_penetration = 0
	penetration_modifier = 0.01
	distance_falloff = 12

/* Practice */
//---------------------------------------------------
//	Practice Bullets
//---------------------------------------------------
/obj/item/projectile/bullet/pistol/practice
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
	qdel(src)
	return PROCESS_KILL

/obj/item/projectile/bullet/rock //spess dust
	name = "micrometeor"
	icon_state = "rock"
	force = 40
	armor_penetration = 25
	kill_count = 255
	distance_falloff = 0
	mass = 1

/obj/item/projectile/bullet/rock/New()
	icon_state = "rock[rand(1,3)]"
	pixel_x = rand(-10,10)
	pixel_y = rand(-10,10)
	..()
