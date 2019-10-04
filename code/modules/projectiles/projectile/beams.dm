/obj/item/projectile/beam
	name = "laser"
	icon_state = "laser"
	fire_sound='sound/weapons/Laser.ogg'
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GLASS | PASS_FLAG_GRILLE
	force = 15
	damtype = DAM_LASER
	sharpness = 1 //concentrated burns
	eyeblur = 4
	hitscan = 1
	invisibility = 101	//beam projectiles are invisible as they are rendered by the effect engine
	mass = 0
	penetration_modifier = 0.3
	distance_falloff = 2.5

	muzzle_type = /obj/effect/projectile/laser/muzzle
	tracer_type = /obj/effect/projectile/laser/tracer
	impact_type = /obj/effect/projectile/laser/impact

/obj/item/projectile/beam/practice
	name = "laser"
	icon_state = "laser"
	fire_sound = 'sound/weapons/Taser.ogg'
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GLASS | PASS_FLAG_GRILLE
	force = 2
	damtype = DAM_LASER
	eyeblur = 2
	mass = 0

/obj/item/projectile/beam/smalllaser
	force = 10
	armor_penetration = 10

/obj/item/projectile/beam/midlaser
	force = 25
	armor_penetration = 20
	distance_falloff = 1

/obj/item/projectile/beam/heavylaser
	name = "heavy laser"
	icon_state = "heavylaser"
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	force = 35
	armor_penetration = 30
	distance_falloff = 0.5

	muzzle_type = /obj/effect/projectile/laser/heavy/muzzle
	tracer_type = /obj/effect/projectile/laser/heavy/tracer
	impact_type = /obj/effect/projectile/laser/heavy/impact

/obj/item/projectile/beam/xray
	name = "x-ray beam"
	icon_state = "xray"
	fire_sound = 'sound/weapons/laser3.ogg'
	force = 18
	armor_penetration = 30
	penetration_modifier = 0.8
	damtype = DAM_ENERGY

	muzzle_type = /obj/effect/projectile/laser/xray/muzzle
	tracer_type = /obj/effect/projectile/laser/xray/tracer
	impact_type = /obj/effect/projectile/laser/xray/impact

/obj/item/projectile/beam/xray/midlaser
	force = 25
	armor_penetration = 50

/obj/item/projectile/beam/pulse
	name = "pulse"
	icon_state = "u_laser"
	fire_sound='sound/weapons/pulse.ogg'
	force = 10 //lower damage, but fires in bursts
	damtype = DAM_LASER

	muzzle_type = /obj/effect/projectile/laser/pulse/muzzle
	tracer_type = /obj/effect/projectile/laser/pulse/tracer
	impact_type = /obj/effect/projectile/laser/pulse/impact

/obj/item/projectile/beam/pulse/mid
	force = 15

/obj/item/projectile/beam/pulse/heavy
	force = 25

/obj/item/projectile/beam/pulse/destroy
	name = "destroyer pulse"
	force = 30 //badmins be badmins I don't give a fuck
	armor_penetration = 50

/obj/item/projectile/beam/pulse/destroy/on_hit(var/atom/target, var/blocked = 0)
	if(isturf(target))
		target.ex_act(2)
	..()
	
/obj/item/projectile/beam/pulse/skrell
	icon_state = "pu_laser"
	force = 20
	muzzle_type = /obj/effect/projectile/laser/pulse/skrell/muzzle
	tracer_type = /obj/effect/projectile/laser/pulse/skrell/tracer
	impact_type = /obj/effect/projectile/laser/pulse/skrell/impact
	
/obj/item/projectile/beam/pulse/skrell/heavy
	force = 30
	
/obj/item/projectile/beam/pulse/skrell/single
	force = 40

/obj/item/projectile/beam/emitter
	name = "emitter beam"
	icon_state = "emitter"
	fire_sound = 'sound/weapons/emitter.ogg'
	force = 0 // The actual damage is computed in /code/modules/power/singularity/emitter.dm

	muzzle_type = /obj/effect/projectile/laser/emitter/muzzle
	tracer_type = /obj/effect/projectile/laser/emitter/tracer
	impact_type = /obj/effect/projectile/laser/emitter/impact

/obj/item/projectile/beam/lastertag/blue
	name = "lasertag beam"
	icon_state = "bluelaser"
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GLASS | PASS_FLAG_GRILLE
	force = 0
	no_attack_log = 1
	damtype = DAM_LASER

	muzzle_type = /obj/effect/projectile/laser/blue/muzzle
	tracer_type = /obj/effect/projectile/laser/blue/tracer
	impact_type = /obj/effect/projectile/laser/blue/impact

/obj/item/projectile/beam/lastertag/blue/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/redtag))
			M.Weaken(5)
	return 1

/obj/item/projectile/beam/lastertag/red
	name = "lasertag beam"
	icon_state = "laser"
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GLASS | PASS_FLAG_GRILLE
	force = 0
	no_attack_log = 1
	damtype = DAM_LASER

/obj/item/projectile/beam/lastertag/red/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/bluetag))
			M.Weaken(5)
	return 1

/obj/item/projectile/beam/lastertag/omni//A laser tag bolt that stuns EVERYONE
	name = "lasertag beam"
	icon_state = "omnilaser"
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GLASS | PASS_FLAG_GRILLE
	force = 0
	damtype = DAM_STUN

	muzzle_type = /obj/effect/projectile/laser/omni/muzzle
	tracer_type = /obj/effect/projectile/laser/omni/tracer
	impact_type = /obj/effect/projectile/laser/omni/impact

/obj/item/projectile/beam/lastertag/omni/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = target
		if((istype(M.wear_suit, /obj/item/clothing/suit/bluetag))||(istype(M.wear_suit, /obj/item/clothing/suit/redtag)))
			M.Weaken(5)
	return 1

/obj/item/projectile/beam/sniper
	name = "sniper beam"
	icon_state = "xray"
	fire_sound = 'sound/weapons/marauder.ogg'
	force = 40
	armor_penetration = 10
	stun = 3
	weaken = 3
	stutter = 3
	damtype = DAM_ENERGY

	muzzle_type = /obj/effect/projectile/laser/xray/muzzle
	tracer_type = /obj/effect/projectile/laser/xray/tracer
	impact_type = /obj/effect/projectile/laser/xray/impact

/obj/item/projectile/beam/stun
	name = "stun beam"
	icon_state = "stun"
	fire_sound = 'sound/weapons/Taser.ogg'
	sharpness = 0
	agony = 20
	damtype = DAM_STUN

	muzzle_type = /obj/effect/projectile/stun/muzzle
	tracer_type = /obj/effect/projectile/stun/tracer
	impact_type = /obj/effect/projectile/stun/impact

/obj/item/projectile/beam/stun/heavy
	name = "heavy stun beam"
	agony = 25

/obj/item/projectile/beam/stun/shock
	name = "shock beam"
	damtype = DAM_ELECTRIC
	force = 10
	agony  = 5
	fire_sound='sound/weapons/pulse.ogg'

/obj/item/projectile/beam/stun/shock/heavy
	name = "heavy shock beam"
	force = 20
	agony  = 10

/obj/item/projectile/beam/plasmacutter
	name = "plasma arc"
	icon_state = "omnilaser"
	fire_sound = 'sound/weapons/plasma_cutter.ogg'
	force = 15
	sharpness = 3
	damtype = DAM_ENERGY
	kill_count = 5
	pass_flags = PASS_FLAG_TABLE
	distance_falloff = 4

	muzzle_type = /obj/effect/projectile/trilaser/muzzle
	tracer_type = /obj/effect/projectile/trilaser/tracer
	impact_type = /obj/effect/projectile/trilaser/impact

/obj/item/projectile/beam/plasmacutter/on_impact(var/atom/A)
	if(istype(A, /turf/simulated/mineral))
		var/turf/simulated/mineral/M = A
		M.GetDrilled(1)
	. = ..()
