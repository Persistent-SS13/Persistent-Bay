/turf/simulated/wall
	name = "wall"
	desc = "A huge chunk of metal used to seperate rooms."
	icon = 'icons/turf/wall_masks.dmi'
	icon_state = "generic"
	opacity = 1
	density = TRUE
	blocks_air = TRUE
	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall

	var/integrity = 150 // Placeholder until assigned
	var/damage_overlay = 0
	var/global/damage_overlays[16]
	var/active
	var/can_open = FALSE
	var/material/material
	var/material/reinf_material
	var/material/girder_material
	var/material/girder_reinf_material
	var/last_state
	var/state
	var/hitsound = 'sound/weapons/Genhit.ogg'
	var/list/wall_connections = list("0", "0", "0", "0")
	var/list/other_connections = list("0", "0", "0", "0")
	var/floor_type = /turf/simulated/floor/plating //turf it leaves after destruction
	var/paint_color
	var/stripe_color
	var/global/list/wall_stripe_cache = list()
	var/list/blend_turfs = list(/turf/simulated/wall/cult, /turf/simulated/wall/wood, /turf/simulated/wall/walnut, /turf/simulated/wall/maple, /turf/simulated/wall/mahogany, /turf/simulated/wall/ebony)
	var/list/blend_objects = list(/obj/machinery/door, /obj/structure/wall_frame, /obj/structure/grille, /obj/structure/window/reinforced/full, /obj/structure/window/reinforced/polarized/full, /obj/structure/window/shuttle, ,/obj/structure/window/phoronbasic/full, /obj/structure/window/phoronreinforced/full) // Objects which to blend with
	var/list/noblend_objects = list(/obj/machinery/door/window) //Objects to avoid blending with (such as children of listed blend objects.

/turf/simulated/wall/New(var/newloc, var/materialtype, var/rmaterialtype, var/girder_mat, var/girder_reinf_mat)
	..()
	//icon_state = "blank"
	ADD_SAVED_VAR(paint_color)
	ADD_SAVED_VAR(stripe_color)
	ADD_SAVED_VAR(state)
	ADD_SAVED_VAR(integrity)
	ADD_SAVED_VAR(material)
	ADD_SAVED_VAR(reinf_material)
	ADD_SAVED_VAR(girder_material)
	ADD_SAVED_VAR(girder_reinf_material)
	ADD_SAVED_VAR(can_open) //For hidden doors
	ADD_SAVED_VAR(blocks_air) //For hidden doors

	ADD_SKIP_EMPTY(reinf_material)
	ADD_SKIP_EMPTY(girder_reinf_material)

/turf/simulated/wall/Initialize(mapload, var/materialtype, var/rmaterialtype, var/girder_mat, var/girder_reinf_mat)
	//testing("wall/initialize([mapload], [materialtype], [rmaterialtype], [girder_mat], [girder_reinf_mat])")
	set_extension(src, /datum/extension/penetration, /datum/extension/penetration/proc_call, .proc/CheckPenetration)
	. = ..()
	if(!map_storage_loaded)
		if(!materialtype)
			materialtype = DEFAULT_WALL_MATERIAL
		material = (istext(materialtype))?  SSmaterials.get_material_by_name(materialtype) : materialtype
		if(!isnull(rmaterialtype))
			reinf_material = (istext(rmaterialtype))? SSmaterials.get_material_by_name(rmaterialtype) : rmaterialtype
		if(!isnull(girder_mat))
			girder_material = (istext(girder_mat))? SSmaterials.get_material_by_name(girder_mat) : girder_mat
		if(!isnull(girder_reinf_mat))
			girder_reinf_material = (istext(girder_reinf_mat))? SSmaterials.get_material_by_name(girder_reinf_mat) : girder_reinf_mat
	return INITIALIZE_HINT_LATELOAD

/turf/simulated/wall/LateInitialize()
	. = ..()
	if(!map_storage_loaded)
		update_full(TRUE, TRUE)
	else
		update_full(FALSE, FALSE) //Don't propagate on load
	hitsound = material.hitsound
	START_PROCESSING(SSturf, src) //Used for radiation.

/turf/simulated/wall/Destroy()
	STOP_PROCESSING(SSturf, src)
	dismantle_wall(null,null,1)
	. = ..()

// Walls always hide the stuff below them.
/turf/simulated/wall/levelupdate()
	for(var/obj/O in src)
		O.hide(1)

/turf/simulated/wall/protects_atom(var/atom/A)
	var/obj/O = A
	return (istype(O) && O.hides_under_flooring()) || ..()

/turf/simulated/wall/Process(wait, times_fired)
	var/how_often = max(round(2 SECONDS/wait), 1)
	if(times_fired % how_often)
		return //We only work about every 2 seconds
	if(!radiate())
		return PROCESS_KILL

/turf/simulated/wall/proc/get_material()
	return material

/turf/simulated/wall/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj,/obj/item/projectile/beam))
		burn(2500)
	else if(istype(Proj,/obj/item/projectile/ion))
		burn(500)

	var/proj_damage = Proj.get_structure_damage()

	if(reinf_material)
		if(IsDamageTypeBurn(Proj.damtype))
			proj_damage /= reinf_material.burn_armor
		else if(IsDamageTypeBrute(Proj.damtype))
			proj_damage /= reinf_material.brute_armor

	//cap the amount of damage, so that things like emitters can't destroy walls in one hit.
	var/damage = min(proj_damage, 100)

	take_damage(damage, Proj.damtype)
	return

/turf/simulated/wall/hitby(AM as mob|obj, var/speed=THROWFORCE_SPEED_DIVISOR)
	..()
	if(ismob(AM))
		return

	var/obj/O = AM
	var/tforce = O.throwforce * (speed/THROWFORCE_SPEED_DIVISOR)
	take_damage(tforce, DAM_BLUNT)

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
		to_chat(user, SPAN_NOTICE("It looks fully intact."))
	else if(health >= 0.6)
		to_chat(user, SPAN_WARNING("It looks slightly damaged."))
	else if(health >= 0.3)
		to_chat(user, SPAN_WARNING("It looks moderately damaged."))
	else
		to_chat(user, SPAN_DANGER("It looks heavily damaged."))
	if(paint_color)
		to_chat(user, SPAN_NOTICE("It has a coat of paint applied."))
	if(locate(/obj/effect/overlay/wallrot) in src)
		to_chat(user, SPAN_WARNING("There is fungus growing on [src]."))

//Damage

/turf/simulated/wall/proc/take_damage(damage, damtype, armorbypass, used_weapon)
	playsound(src, hitsound, 80, 1)
	if(locate(/obj/effect/overlay/wallrot) in src)
		damage *= 3
	if(IsDamageTypeBrute(damtype))
		damage -= BruteArmor()
	else if(IsDamageTypeBurn(damtype))
		damage -= BurnArmor()
	else if(ISDAMTYPE(damtype, DAM_BOMB))
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
		return TRUE
	return FALSE

/turf/simulated/wall/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)//Doesn't fucking work because walls don't interact with air :(
	burn(exposed_temperature)

/turf/simulated/wall/adjacent_fire_act(turf/simulated/floor/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	burn(adj_temp)
	if(adj_temp > material.melting_point)
		take_damage(log(RAND_F(0.9, 1.1) * (adj_temp - material.melting_point)))

	return ..()

/turf/simulated/wall/proc/dismantle_wall(var/devastated, var/explode, var/no_product)

	playsound(src, 'sound/items/Welder.ogg', 100, 1)
	if(!no_product)
		var/obj/structure/girder/G = new(src, girder_material, girder_reinf_material)
		G.reset_girder()
		new material.stack_type(src, 4)

	for(var/obj/O in src.contents) //Eject contents!
		if(istype(O,/obj/structure/sign/poster))
			var/obj/structure/sign/poster/P = O
			P.roll_and_drop(src)
		else
			O.forceMove(src)

	clear_plants()
	material = SSmaterials.get_material_by_name("placeholder")
	reinf_material = null
	update_connections(TRUE)

	ChangeTurf(floor_type)

/turf/simulated/wall/ex_act(severity)
	switch(severity)
		if(1.0)
			src.ChangeTurf(get_base_turf(src.z))
			return
		if(2.0)
			if(prob(25))
				dismantle_wall(TRUE)
			else
				take_damage(rand(150, 250), DAM_BOMB)
		if(3.0)
			take_damage(rand(0, 250), DAM_BOMB)
		else
	return

// Wall-rot effect, a nasty fungus that destroys walls.
/turf/simulated/wall/proc/rot()
	if(locate(/obj/effect/overlay/wallrot) in src)
		return
	var/number_rots = rand(2,3)
	for(var/i=0, i<number_rots, i++)
		new/obj/effect/overlay/wallrot(src)

/turf/simulated/wall/proc/can_melt()
	if(material.flags & MATERIAL_UNMELTABLE)
		return 0
	return 1

/turf/simulated/wall/proc/thermitemelt(mob/user as mob)
	if(!can_melt())
		return
	var/obj/effect/overlay/O = new/obj/effect/overlay( src )
	O.SetName("Thermite")
	O.desc = "Looks hot."
	O.icon = 'icons/effects/fire.dmi'
	O.icon_state = "2"
	O.anchored = 1
	O.set_density(1)
	O.plane = LIGHTING_PLANE
	O.layer = FIRE_LAYER

	src.ChangeTurf(/turf/simulated/floor/plating)

	var/turf/simulated/floor/F = src
	F.burn_tile()
	F.icon_state = "wall_thermite"
	to_chat(user, "<span class='warning'>The thermite starts melting through the wall.</span>")

	spawn(100)
		if(O)
			qdel(O)
//	F.sd_LumReset()		//TODO: ~Carn
	return

/turf/simulated/wall/proc/radiate()
	var/total_radiation = material.radioactivity + (reinf_material ? reinf_material.radioactivity / 2 : 0)
	if(!total_radiation)
		return

	SSradiation.radiate(src, total_radiation)
	return total_radiation

/turf/simulated/wall/proc/burn(temperature)
	if(material.combustion_effect(src, temperature, 0.7))
		spawn(2)
			new /obj/structure/girder(src, material, reinf_material)
			if(reinf_material)
				new /obj/item/stack/material/rods(src, 4)
			src.ChangeTurf(floor_type)
			for(var/turf/simulated/wall/W in range(3,src))
				W.burn((temperature/4))
			for(var/obj/machinery/door/airlock/phoron/D in range(3,src))
				D.ignite(temperature/4)
			var/turf/simulated/floor/F = src
			F.burn_tile()
	else if(reinf_material && reinf_material.combustion_effect(src, temperature, 2))
		spawn(2)
			visible_message("<span class='danger' \The [src] explodes apart!")
			playsound(src, 'sound/effects/Explosion1.ogg', 50, 1)
			new /obj/structure/girder(src, girder_material, girder_reinf_material)
			new material.stack_type(src, 4)
			new /obj/item/stack/material/rods(src, 8)
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
			new material.stack_type(src, 4)
			if(reinf_material)
				new reinf_material.stack_type(6)
				new /obj/item/stack/material/rods(src, 8)
			else
				new /obj/item/stack/material/rods(src, 4)
			src.ChangeTurf(floor_type)
			for(var/turf/simulated/wall/W in range(3,src))
				W.burn((temperature/4))
			for(var/obj/machinery/door/airlock/phoron/D in range(3,src))
				D.ignite(temperature/4)
			var/turf/simulated/floor/F = src
			F.burn_tile()
	else
		if(material.melting_point < temperature)
			take_damage(temperature / material.melting_point)
		if(reinf_material && reinf_material.melting_point < temperature)
			take_damage(temperature / reinf_material.melting_point)
		if(material.melting_point < temperature)
			take_damage(temperature / material.melting_point)

/turf/simulated/wall/proc/MaxIntegrity()
	return material.integrity + (reinf_material ? reinf_material.integrity + (material.integrity * reinf_material.integrity / 100) : 0) + (material.integrity / 2)

/turf/simulated/wall/proc/BruteArmor()
	return material.brute_armor + (reinf_material ? reinf_material.brute_armor + (material.brute_armor * reinf_material.brute_armor / 100) : 0) + (material.brute_armor / 2)

/turf/simulated/wall/proc/BurnArmor()
	return material.burn_armor + (reinf_material ? reinf_material.burn_armor + (material.burn_armor * reinf_material.burn_armor / 100) : 0) + (material.burn_armor / 2)

/turf/simulated/wall/proc/ExplosionArmor()
	return material.hardness + (reinf_material ? reinf_material.hardness + (material.integrity * reinf_material.hardness / 100) : 0) + (material.hardness / 2)

/turf/simulated/wall/get_color()
	return paint_color

/turf/simulated/wall/proc/CheckPenetration(var/base_chance, var/damage)
	return round(damage/material.integrity*180)

/turf/simulated/wall/can_engrave()
	return (material && material.hardness >= 10 && material.hardness <= 100)

/turf/simulated/wall/is_wall()
	return TRUE
//Tungsten rwalls!
/turf/simulated/wall/r_wall/tungsten
	reinf_material 			= new /material/tungsten
	material 				= new /material/tungsten
	girder_material 		= new /material/tungsten
	girder_reinf_material 	= new /material/tungsten

/turf/simulated/wall/r_wall/tungsten/New(newloc, material/mat, material/r_mat, material/p_mat)
	. = ..(newloc, src.material, src.reinf_material, src.material) //Keeps the base ctor from being a dipshit
