/turf/simulated/wall
	name = "wall"
	desc = "A huge chunk of metal used to seperate rooms."
	icon = 'icons/turf/wall_masks.dmi'
	icon_state = "generic"
	opacity = 1
	density = 1
	blocks_air = 1
	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall

	var/integrity = 150 // Placeholder until assigned
	var/damage_overlay = 0
	var/can_open = 0
	var/reinf_material		// Material to be updated to the latest
	var/material/material	// Material the girder is made out of
	var/material/r_material	// Material used to reinforce the girder
	var/material/p_material	// Material used to plate the girder
	var/state
	var/hitsound = 'sound/weapons/Genhit.ogg'
	var/list/wall_connections = list("0", "0", "0", "0")
	var/list/other_connections = list("0", "0", "0", "0")
	var/floor_type = /turf/simulated/floor/plating //turf it leaves after destruction
	var/paint_color
	var/stripe_color
	var/global/list/wall_stripe_cache = list()

	var/global/damage_overlays[16]

/turf/simulated/wall/r_wall/after_load()
	..()
	var/mat = material
	var/r_mat = r_material
	var/p_mat = p_material
	ChangeTurf(/turf/simulated/wall)
	material = mat
	r_material = r_mat
	p_material = p_mat


/turf/simulated/wall/New(var/newloc, var/material/mat, var/material/r_mat, var/material/p_mat)
	..(newloc)
	material = mat
	r_material = r_mat
	p_material = p_mat
	update_full(1, 1)
	START_PROCESSING(SSturf, src) //Used for radiation.

/turf/simulated/wall/after_load()
	..()
	if(reinf_material)
		p_material = reinf_material
		r_material = reinf_material
	reinf_material = null
	update_full(1, 1)

/turf/simulated/wall/Destroy()
	STOP_PROCESSING(SSturf, src)
	dismantle_wall(1)
	. = ..()

// Walls always hide the stuff below them.
/turf/simulated/wall/levelupdate()
	for(var/obj/O in src)
		O.hide(1)

/turf/simulated/wall/protects_atom(var/atom/A)
	var/obj/O = A
	return (istype(O) && O.hides_under_flooring()) || ..()

/turf/simulated/wall/Process(wait, times_fired)
	var/how_often = max(round(2 SECONDS / wait), 1)

	if(times_fired % how_often)
		return //We only work about every 2 seconds

	if(!radiate())
		return PROCESS_KILL


/turf/simulated/wall/bullet_act(var/obj/item/projectile/Proj)
	var/damage = Proj.get_structure_damage()
	var/damType
	switch(Proj.check_armour)
		if("bullet")
			damType = "brute"
			return
		if("laser")
			damType = "burn"
			return
		if("bomb")
			damType = "explosion"
			return
	take_damage(damage, damType)
	..()

/turf/simulated/wall/hitby(AM as mob|obj, var/speed=THROWFORCE_SPEED_DIVISOR)
	..()
	if(ismob(AM))
		return

	var/obj/O = AM
	var/tforce = O.throwforce * (speed/THROWFORCE_SPEED_DIVISOR)

	take_damage(tforce, "brute")

/turf/simulated/wall/proc/clear_plants()
	for(var/obj/effect/overlay/wallrot/WR in src)
		qdel(WR)
	for(var/obj/effect/vine/plant in range(src, 1))
		if(!plant.floor) //shrooms drop to the floor
			plant.floor = 1
			plant.update_icon()
			plant.pixel_x = 0
			plant.pixel_y = 0
		plant.update_neighbors()

/turf/simulated/wall/ChangeTurf(var/newtype)
	clear_plants()
	return ..(newtype)

//Appearance
/turf/simulated/wall/examine(mob/user)
	. = ..(user)

	if(!.)
		return

	var/health = integrity / MaxIntegrity()
	if(health >= 0.9)
		to_chat(user, "<span class='notice'>It looks fully intact.</span>")
	else if(health >= 0.6)
		to_chat(user, "<span class='warning'>It looks slightly damaged.</span>")
	else if(health >= 0.3)
		to_chat(user, "<span class='warning'>It looks moderately damaged.</span>")
	else
		to_chat(user, "<span class='danger'>It looks heavily damaged.</span>")
	if(paint_color)
		to_chat(user, "<span class='notice'>It has a coat of paint applied.</span>")
	if(locate(/obj/effect/overlay/wallrot) in src)
		to_chat(user, "<span class='warning'>There is fungus growing on [src].</span>")

//Damage

/turf/simulated/wall/proc/take_damage(var/damage, var/damageType)
	playsound(src, hitsound, 80, 1)
	if(locate(/obj/effect/overlay/wallrot) in src)
		damage *= 3
	switch(damageType)
		if("brute")
			damage -= BruteArmor()
		if("burn")
			damage -= BurnArmor()
		if("explosion")
			damage -= ExplosionArmor()
	integrity -= max(0, damage)
	if(integrity <= 0)
		spawn(1) // So it returns that it broke
			dismantle_wall()
		return 2
	return damage ? 1 : 0

/turf/simulated/wall/proc/repair_damage(var/damage)
	if(integrity != MaxIntegrity())
		integrity = min(MaxIntegrity(), damage + integrity)
		return 1
	return 0

/turf/simulated/wall/adjacent_fire_act(turf/simulated/floor/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	burn(adj_temp)
	return ..()

/turf/simulated/wall/proc/dismantle_wall(var/devastated)

	playsound(src, 'sound/items/Welder.ogg', 100, 1)
	if(!devastated)
		var/obj/structure/girder/G
		if(r_material)
			G = new(src, material, r_material)
			G.state = 7
			new /obj/item/stack/rods(src, 4)
		else
			G = new(src, material)
			G.state = 2
		G.anchored = 1
		G.update_icon()
		new p_material.stack_type(src, 2)
		src.ChangeTurf(floor_type)

	for(var/turf/simulated/wall/W in orange(src, 1))
		W.update_connections()
		W.update_icon()

	for(var/obj/O in src.contents) //Eject contents!
		if(istype(O,/obj/structure/sign/poster))
			var/obj/structure/sign/poster/P = O
			P.roll_and_drop(src)
		else
			O.forceMove(src)

	clear_plants()
	material = null
	r_material = null
	p_material = null
	update_connections(1)

	ChangeTurf(floor_type)

/turf/simulated/wall/ex_act(severity)
	switch(severity)
		if(1.0)
			src.ChangeTurf(get_base_turf(src.z))
			return
		if(2.0)
			if(prob(25))
				dismantle_wall(1)
			else
				take_damage(rand(150, 250), "explosion")
		if(3.0)
			take_damage(rand(0, 250), "explosion")
		else
	return

// Wall-rot effect, a nasty fungus that destroys walls.
/turf/simulated/wall/proc/rot()
	if(locate(/obj/effect/overlay/wallrot) in src)
		return
	var/number_rots = rand(2,3)
	for(var/i=0, i<number_rots, i++)
		new/obj/effect/overlay/wallrot(src)

/turf/simulated/wall/proc/thermitemelt(mob/user as mob)
	var/obj/effect/overlay/O = new/obj/effect/overlay( src )
	O.name = "Thermite"
	O.desc = "Looks hot."
	O.icon = 'icons/effects/fire.dmi'
	O.icon_state = "2"
	O.anchored = 1
	O.set_density(1)
	O.plane = LIGHTING_PLANE
	O.layer = FIRE_LAYER

	to_chat(user, "<span class='warning'>The thermite starts burning the wall.</span>")
	var/endtime = world.time + 100
	while (world.time < endtime)
		burn(2500)
		sleep(1)

	if(O)
		qdel(O)

//	F.sd_LumReset()		//TODO: ~Carn
	return

/turf/simulated/wall/proc/radiate()
	var/total_radiation = p_material.radioactivity + (r_material ? r_material.radioactivity / 4 : 0) + (material.radioactivity / 16)
	if(!total_radiation)
		return

	SSradiation.radiate(src, total_radiation)
	return total_radiation

/turf/simulated/wall/proc/burn(temperature)
	// This looks like it is performance intensive, however combustion_effect
	// returns 0 instantly if the temperature is not hot enough, making this
	// actually performance friendly
	if(p_material.combustion_effect(src, temperature, 6))
		spawn(2)
			new /obj/structure/girder(src, material, r_material)
			if(r_material)
				new /obj/item/stack/rods(src, 4)
			src.ChangeTurf(floor_type)
			for(var/turf/simulated/wall/W in range(3,src))
				W.burn((temperature/4))
			for(var/obj/machinery/door/airlock/phoron/D in range(3,src))
				D.ignite(temperature/4)
			var/turf/simulated/floor/F = src
			F.burn_tile()
	else if(r_material && r_material.combustion_effect(src, temperature, 2))
		spawn(2)
			visible_message("<span class='danger' \The [src] explodes apart!")
			playsound(src, 'sound/effects/Explosion1.ogg', 50, 1)
			new /obj/structure/girder(src, material)
			new p_material.stack_type(src, 4)
			new /obj/item/stack/rods(src, 8)
			src.ChangeTurf(floor_type)
			for(var/turf/simulated/wall/W in range(3,src))
				W.burn((temperature/4))
			for(var/obj/machinery/door/airlock/phoron/D in range(3,src))
				D.ignite(temperature/4)
			var/turf/simulated/floor/F = src
			F.burn_tile()
	else if(material.combustion_effect(src, temperature, 4))
		spawn(2)
			visible_message("<span class='danger' \The [src] explodes apart!")
			playsound(src, 'sound/effects/Explosion1.ogg', 50, 1)
			new p_material.stack_type(src, 4)
			if(r_material)
				new r_material.stack_type(6)
				new /obj/item/stack/rods(src, 8)
			else
				new /obj/item/stack/rods(src, 4)
			src.ChangeTurf(floor_type)
			for(var/turf/simulated/wall/W in range(3,src))
				W.burn((temperature/4))
			for(var/obj/machinery/door/airlock/phoron/D in range(3,src))
				D.ignite(temperature/4)
			var/turf/simulated/floor/F = src
			F.burn_tile()
	else
		if(p_material.melting_point < temperature)
			take_damage(temperature / p_material.melting_point)
		if(r_material && r_material.melting_point < temperature)
			take_damage(temperature / r_material.melting_point)
		if(material.melting_point < temperature)
			take_damage(temperature / material.melting_point)

/turf/simulated/wall/proc/MaxIntegrity()
	return p_material.integrity + (r_material ? r_material.integrity + (p_material.integrity * r_material.integrity / 100) : 0) + (material.integrity / 2)

/turf/simulated/wall/proc/BruteArmor()
	return p_material.brute_armor + (r_material ? r_material.brute_armor + (p_material.brute_armor * r_material.brute_armor / 100) : 0) + (material.brute_armor / 2)

/turf/simulated/wall/proc/BurnArmor()
	return p_material.burn_armor + (r_material ? r_material.burn_armor + (p_material.burn_armor * r_material.burn_armor / 100) : 0) + (material.burn_armor / 2)

/turf/simulated/wall/proc/ExplosionArmor()
	return p_material.hardness + (r_material ? r_material.hardness + (p_material.integrity * r_material.hardness / 100) : 0) + (material.hardness / 2)

/turf/simulated/wall/get_color()
	return paint_color

//Tungsten rwalls!
/turf/simulated/wall/r_wall/tungsten
	reinf_material 	= new /material/tungsten
	material 		= new /material/tungsten
	r_material 		= new /material/tungsten
	p_material 		= new /material/tungsten