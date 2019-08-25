//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
#define DOOR_REPAIR_AMOUNT 50	//amount of health regained per stack amount used

/obj/machinery/door
	name 				= "Door"
	desc 				= "It opens and closes."
	icon 				= 'icons/obj/doors/Doorint.dmi'
	icon_state 			= "door1"
	dir 				= SOUTH
	anchored 			= TRUE
	opacity 			= TRUE
	density 			= TRUE
	layer 				= CLOSED_DOOR_LAYER
	max_health 			= 300
	sound_hit 			= 'sound/weapons/smash.ogg' //sound door makes when hit with a weapon
	atmos_canpass		= CANPASS_PROC
	damthreshold_brute	= 10
	damthreshold_burn	= 10
	armor = list(
		DAM_BLUNT  	= 90,
		DAM_PIERCE 	= 80,
		DAM_CUT 	= MaxArmorValue,
		DAM_BULLET 	= 90,
		DAM_ENERGY 	= 80,
		DAM_BURN 	= 80,
		DAM_BOMB 	= 60,
		DAM_EMP 	= 50,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue) 	//Resistance for various types of damages

	var/open_layer 		= OPEN_DOOR_LAYER
	var/closed_layer 	= CLOSED_DOOR_LAYER
	var/visible 		= TRUE
	var/p_open 			= 0
	var/operating 		= FALSE
	var/autoclose 		= FALSE
	var/glass 			= FALSE
	var/width 			= 1 	//Multi-tile doors
	var/normalspeed		= 1
	var/heat_proof 		= FALSE // For glass airlocks/opacity firedoors
	var/block_air_zones = TRUE 	//If set, air zones cannot merge across the door even when it is opened.
	var/close_door_at 	= 0 	//When to automatically close the door, if possible
	var/destroy_hits 	= 10 	//How many strong hits it takes to destroy the door
	var/autoset_access	= FALSE // Determines whether the door will automatically set its access from the areas surrounding it. Can be used for mapping.
	var/list/connections = list("0", "0", "0", "0")
	var/list/blend_objects = list(/obj/structure/wall_frame, /obj/structure/window, /obj/structure/grille) // Objects which to blend with
	var/air_properties_vary_with_direction = 0
	var/obj/item/stack/material/repairing
	// turf animation
	var/atom/movable/overlay/c_animation = null
	var/datum/gas_mixture/tile_air

/obj/machinery/door/before_save()
	if(loc && istype(loc, /turf/simulated))
		var/turf/simulated/floor = loc
		tile_air = floor.air
	..()
/obj/machinery/door/after_load()
	if(tile_air)
		for(var/turf/simulated/T in locs)
			T.air = new()
			T.air.copy_from(tile_air)

/obj/machinery/door/morgue
	icon = 'icons/obj/doors/doormorgue.dmi'

/obj/machinery/door/New()
	. = ..()
	if(density)
		layer = closed_layer
		update_heat_protection(get_turf(src))
	else
		layer = open_layer


	if(width > 1)
		if(dir in list(EAST, WEST))
			bound_width = width * world.icon_size
			bound_height = world.icon_size
		else
			bound_width = world.icon_size
			bound_height = width * world.icon_size

	update_connections(TRUE)
	queue_icon_update()
	update_nearby_tiles(need_rebuild = TRUE)

/obj/machinery/door/Initialize()
	set_extension(src, /datum/extension/penetration, /datum/extension/penetration/proc_call, .proc/CheckPenetration)
	. = ..()
	if(autoset_access)
#ifdef UNIT_TEST
		if(length(req_access))
			crash_with("A door with mapped access restrictions was set to autoinitialize access.")
#endif
		return INITIALIZE_HINT_LATELOAD

/obj/machinery/door/LateInitialize()
	..()
	if(autoset_access) // Delayed because apparently the dir is not set by mapping and we need to wait for nearby walls to init and turn us.
		inherit_access_from_area()

/obj/machinery/door/Destroy()
	set_density(FALSE)
	update_nearby_tiles()
	. = ..()

/obj/machinery/door/attack_generic(var/mob/user, var/damage, var/attack_verb, var/environment_smash, var/damtype)
	if(environment_smash >= 1)
		damage = max(damage, damthreshold_brute)

	if(pass_damage_threshold(damage, damtype))
		visible_message(SPAN_DANGER("\The [user] [attack_verb] into \the [src]!"))
		take_damage(damage)
	else
		visible_message(SPAN_NOTICE("\The [user] bonks \the [src] harmlessly."))
	attack_animation(user)

/obj/machinery/door/Process()
	if(close_door_at && world.time >= close_door_at)
		if(autoclose)
			close_door_at = next_close_time()
			close()
		else
			close_door_at = 0

/obj/machinery/door/proc/can_open()
	return density && !operating

/obj/machinery/door/proc/can_close()
	return !density && !operating

/obj/machinery/door/Bumped(atom/AM)
	if(p_open || operating)
		return
	if(ismob(AM))
		var/mob/M = AM
		if(world.time - M.last_bumped <= 10) return	//Can bump-open one airlock per second. This is to prevent shock spam.
		M.last_bumped = world.time
		if(!M.restrained() && (!issmall(M) || ishuman(M) || issilicon(M)))
			bumpopen(M)
		return
	else if(istype(AM, /mob/living/bot))
		var/mob/living/bot/bot = AM
		if(src.check_access(bot.botcard))
			if(density)
				open()
		return
	else if(istype(AM, /obj/mecha))
		var/obj/mecha/mecha = AM
		if(density)
			if(mecha.occupant && (src.allowed(mecha.occupant) || src.check_access_list(mecha.operation_req_access)))
				open()
			else
				do_animate("deny")
		return
	else if(istype(AM, /obj/structure/bed/chair/wheelchair))
		var/obj/structure/bed/chair/wheelchair/wheel = AM
		if(density)
			if(wheel.pulling && (src.allowed(wheel.pulling)))
				open()
			else
				do_animate("deny")
		return
	else if(istype(AM, /obj/vehicle))
		var/obj/vehicle/V = AM
		if(density)
			if(V.buckled_mob && src.allowed(V.buckled_mob))
				open()
			else
				do_animate("deny")
		return

/obj/machinery/door/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group)
		return !block_air_zones
	if(istype(mover) && mover.checkpass(PASS_FLAG_GLASS))
		return !opacity
	return !density

/obj/machinery/door/proc/bumpopen(mob/user as mob)
	if(operating)
		return
	if(user.last_airflow > world.time - vsc.airflow_delay) //Fakkit
		return
	src.add_fingerprint(user)
	if(density)
		if(allowed(user))
			open()
		else
			do_animate("deny")
	update_icon()
	return

/obj/machinery/door/destroyed(damtype)
	if(!IsDamageTypeBurn(damtype))
		new /obj/item/stack/material/steel(src.loc, 2)
		new /obj/item/stack/material/rods(src.loc, 3)
	return ..()

/obj/machinery/door/melt()
	new /obj/effect/decal/cleanable/ash(src.loc) // Turn it to ashes!
	return ..()

/obj/machinery/door/bullet_act(var/obj/item/projectile/Proj)
	var/damage = Proj.get_structure_damage()

	// Emitter Blasts - these will eventually completely destroy the door, given enough time.
	if (damage > 90)
		destroy_hits--
		if (destroy_hits <= 0)
			kill(Proj.damtype)
	return ..(Proj)

/obj/machinery/door/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/door/attack_hand(mob/user as mob)
	return src.attackby(user, user)

/obj/machinery/door/attack_tk(mob/user as mob)
	if(requiresID() && !allowed(null))
		return
	return ..()

/obj/machinery/door/attackby(obj/item/I as obj, mob/user as mob)
	src.add_fingerprint(user, 0, I)

	if(istype(I, /obj/item/stack/material) && I.get_material_name() == src.get_material_name())
		if(isbroken())
			to_chat(user, SPAN_NOTICE("It looks like \the [src] is pretty busted. It's going to need more than just patching up now."))
			return
		if(health >= max_health)
			to_chat(user, SPAN_NOTICE("Nothing to fix!"))
			return
		if(!density)
			to_chat(user, SPAN_WARNING("\The [src] must be closed before you can repair it."))
			return

		//figure out how much metal we need
		var/amount_needed = (max_health - health) / DOOR_REPAIR_AMOUNT
		amount_needed = ceil(amount_needed)

		var/obj/item/stack/stack = I
		var/transfer
		if (repairing)
			transfer = stack.transfer_to(repairing, amount_needed - repairing.amount)
			if (!transfer)
				to_chat(user, SPAN_WARNING("You must weld or remove \the [repairing] from \the [src] before you can add anything else."))
		else
			repairing = stack.split(amount_needed, force=TRUE)
			if (repairing)
				repairing.dropInto(loc)
				transfer = repairing.amount
				repairing.uses_charge = FALSE //for clean robot door repair - stacks hint immortal if true

		if (transfer)
			to_chat(user, SPAN_NOTICE("You fit [transfer] [stack.singular_name]\s to damaged and broken parts on \the [src]."))

		return

	if(repairing && isWelder(I))
		if(!density)
			to_chat(user, SPAN_WARNING("\The [src] must be closed before you can repair it."))
			return
		var/obj/item/weapon/tool/weldingtool/welder = I
		to_chat(user, SPAN_NOTICE("You start to fix dents and weld \the [repairing] into place."))
		if(welder.use_tool(user, src, 5 * repairing.amount))
			to_chat(user, SPAN_NOTICE("You finish repairing the damage to \the [src]."))
			health = between(health, health + repairing.amount * DOOR_REPAIR_AMOUNT, max_health)
			update_icon()
			QDEL_NULL(repairing)
		return

	if(repairing && isCrowbar(I))
		var/obj/item/weapon/tool/T = I
		if(T.use_tool(user, src, 1 SECOND))
			to_chat(user, SPAN_NOTICE("You remove \the [repairing]."))
			repairing.loc = user.loc
			repairing = null
		return

	//check_force(I, user)
	if(src.density && istype(I, /obj/item/weapon) && user.a_intent == I_HURT && !istype(I, /obj/item/weapon/card))
		I.attack(src,user)
		return

	if(src.operating > 0 || isrobot(user))
		return //borgs can't attack doors open because it conflicts with their AI-like interaction with them.

	if(src.operating)
		return

	if(src.allowed(user) && operable())
		if(src.density)
			INVOKE_ASYNC(src, .proc/open)
		else
			INVOKE_ASYNC(src, .proc/close)
		return

	if(src.density)
		do_animate("deny")
	update_icon()
	return

/obj/machinery/door/emag_act(var/remaining_charges)
	if(density && operable())
		do_animate("emag")
		sleep(6)
		open()
		operating = -1
		return 1

//psa to whoever coded this, there are plenty of objects that need to call attack() on doors without bludgeoning them.
/obj/machinery/door/proc/check_force(obj/item/I as obj, mob/user as mob)
	if(src.density && istype(I, /obj/item/weapon) && user.a_intent == I_HURT && !istype(I, /obj/item/weapon/card))
		var/obj/item/weapon/W = I
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(IsDamageTypeBrute(W.damtype) || IsDamageTypeBurn(W.damtype))
			user.do_attack_animation(src)
			// if(W.force < damthreshold_brute)
			// 	user.visible_message(SPAN_DANGER("\The [user] hits \the [src] with \the [W] with no visible effect."))
			// else
			// 	user.visible_message(SPAN_DANGER("\The [user] forcefully strikes \the [src] with \the [W]!"))
			playsound(src.loc, sound_hit, 100, 1)
			take_damage(W.force, W.damtype, W.armor_penetration, W)

/obj/machinery/door/take_damage(damage, damtype, armorbypass, used_weapon)
	var/initialhealth = src.health
	//cap projectile damage so that there's still a minimum number of hits required to break the door
	if(damage)
		damage = min(damage, 100)
	..(damage, damtype, armorbypass, used_weapon)
	if(src.health <= 0 && initialhealth > 0)
		src.set_broken()
	else if(src.health < src.max_health / 4 && initialhealth >= src.max_health / 4)
		visible_message("\The [src] looks like it's about to break!" )
	else if(src.health < src.max_health / 2 && initialhealth >= src.max_health / 2)
		visible_message("\The [src] looks seriously damaged!" )
	else if(src.health < src.max_health * 3/4 && initialhealth >= src.max_health * 3/4)
		visible_message("\The [src] shows signs of damage!" )
	update_icon()



/obj/machinery/door/examine(mob/user)
	. = ..()
	if(src.health <= src.min_health)
		to_chat(user, "\The [src] is broken!")
	else if(src.health < src.max_health / 4)
		to_chat(user, "\The [src] looks like it's about to break!")
	else if(src.health < src.max_health / 2)
		to_chat(user, "\The [src] looks seriously damaged!")
	else if(src.health < src.max_health * 3/4)
		to_chat(user, "\The [src] shows signs of damage!")

/obj/machinery/door/set_broken(var/new_state)
	. = ..()
	if(. && new_state)
		visible_message(SPAN_WARNING("\The [src.name] breaks!"))

/obj/machinery/door/ex_act(severity)
	if(severity == 3 && prob(80))
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(2, 1, src)
		s.start()
	..(severity)


/obj/machinery/door/on_update_icon()
	//Don't do that. It does weird shit with multi-tile doors and some wall placements, and its generally uneeded
	// if(connections in list(NORTH, SOUTH, NORTH|SOUTH))
	// 	if(connections in list(WEST, EAST, EAST|WEST))
	// 		set_dir(SOUTH)
	// 	else
	// 		set_dir(EAST)
	// else
	// 	set_dir(SOUTH)

	if(density)
		icon_state = "door1"
	else
		icon_state = "door0"
	SSradiation.resistance_cache.Remove(get_turf(src))
	return

/obj/machinery/door/proc/do_animate(animation)
	switch(animation)
		if("opening")
			if(p_open)
				flick("o_doorc0", src)
			else
				flick("doorc0", src)
		if("closing")
			if(p_open)
				flick("o_doorc1", src)
			else
				flick("doorc1", src)
		if("spark")
			if(density)
				flick("door_spark", src)
		if("deny")
			if(density && operable())
				flick("door_deny", src)
				playsound(src.loc, 'sound/machines/buzz-two.ogg', 50, 0)
	return


/obj/machinery/door/proc/open(var/forced = FALSE)
	if(!can_open(forced))
		return
	operating = TRUE
	do_animate("opening")
	icon_state = "door0"
	set_opacity(0)
	sleep(3)
	src.set_density(FALSE)
	update_nearby_tiles()
	sleep(7)
	src.layer = open_layer
	update_icon()
	set_opacity(0)
	operating = FALSE

	if(autoclose)
		close_door_at = next_close_time()
	return TRUE

/obj/machinery/door/proc/next_close_time()
	return world.time + (normalspeed ? 150 : 5)

/obj/machinery/door/proc/close(var/forced = FALSE)
	if(!can_close(forced))
		return
	operating = TRUE
	close_door_at = 0
	do_animate("closing")
	sleep(3)
	src.set_density(TRUE)
	src.layer = closed_layer
	update_nearby_tiles()
	sleep(7)
	update_icon()
	if(visible && !glass)
		set_opacity(TRUE)	//caaaaarn!
	operating = FALSE

	//I shall not add a check every x ticks if a door has closed over some fire.
	var/obj/fire/fire = locate() in loc
	if(fire)
		qdel(fire)
	return

/obj/machinery/door/proc/requiresID()
	return TRUE

/obj/machinery/door/allowed(mob/M)
	if(!requiresID())
		return ..(null) //don't care who they are or what they have, act as if they're NOTHING
	return ..(M)

/obj/machinery/door/update_nearby_tiles(need_rebuild)
	. = ..()
	for(var/turf/simulated/turf in locs)
		update_heat_protection(turf)
		SSair.mark_for_update(turf)
	return 1

/obj/machinery/door/proc/update_heat_protection(var/turf/simulated/source)
	if(istype(source))
		if(src.density && (src.opacity || src.heat_proof))
			source.thermal_conductivity = DOOR_HEAT_TRANSFER_COEFFICIENT
		else
			source.thermal_conductivity = initial(source.thermal_conductivity)

/obj/machinery/door/Move(new_loc, new_dir)
	update_nearby_tiles()
	. = ..()
	if(width > 1)
		if(dir in list(EAST, WEST))
			bound_width = width * world.icon_size
			bound_height = world.icon_size
		else
			bound_width = world.icon_size
			bound_height = width * world.icon_size
	if(.)
		deconstruct(null, TRUE)

/obj/machinery/door/proc/CheckPenetration(var/base_chance, var/damage)
	. = damage/max_health*180
	if(glass)
		. *= 2
	. = round(.)

/obj/machinery/door/proc/deconstruct(mob/user, var/moved = FALSE)
	return null

/obj/machinery/door/proc/update_connections(var/propagate = FALSE)
	var/dirs = 0

	for(var/direction in GLOB.cardinal)
		var/turf/T = get_step(src, direction)
		var/success = FALSE

		if( istype(T, /turf/simulated/wall))
			success = TRUE
			if(propagate)
				var/turf/simulated/wall/W = T
				W.update_connections(TRUE)
				W.update_icon()

		else if( istype(T, /turf/simulated/shuttle/wall) ||  istype(T, /turf/unsimulated/wall))
			success = TRUE
		else
			for(var/obj/O in T)
				for(var/b_type in blend_objects)
					if( istype(O, b_type))
						success = TRUE
					if(success)
						break
				if(success)
					break

		if(success)
			dirs |= direction
	connections = dirs

/obj/machinery/door/CanFluidPass(var/coming_from)
	return !density

// Most doors will never be deconstructed over the course of a round,
// so as an optimization defer the creation of electronics until
// the airlock is deconstructed
/obj/machinery/door/proc/create_electronics(var/electronics_type = /obj/item/weapon/airlock_electronics)
	var/obj/item/weapon/airlock_electronics/electronics = new electronics_type(loc)
	electronics.set_access(src)
	electronics.autoset = autoset_access
	return electronics

/obj/machinery/door/proc/access_area_by_dir(direction)
	var/turf/T = get_turf(get_step(src, direction))
	if (T && !T.density)
		return get_area(T)

/obj/machinery/door/proc/inherit_access_from_area()
	var/area/fore = access_area_by_dir(dir)
	var/area/aft = access_area_by_dir(GLOB.reverse_dir[dir])
	fore = fore || aft
	aft = aft || fore

	if (!fore && !aft)
		req_access = list()
	else if (fore.secure || aft.secure)
		req_access = req_access_union(fore, aft)
	else
		req_access = req_access_diff(fore, aft)
