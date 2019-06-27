/obj/machinery/shield
	name = "Emergency energy shield"
	desc = "An energy shield used to contain hull breaches."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield-old"
	density = 1
	opacity = 0
	anchored = 1
	unacidable = 1
	max_health = 200
	var/shield_generate_power = 7500	//how much power we use when regenerating
	var/shield_idle_power = 1500		//how much power we use when just being sustained.
	sound_hit = 'sound/effects/EMPulse.ogg'
	var/time_hit_effect_end = 0 		//Time until we need to change the opacity back
	should_save = 0

/obj/machinery/shield/malfai
	name = "emergency forcefield"
	desc = "A weak forcefield which seems to be projected by the emergency atmosphere containment field."
	max_health = 100 // Half health, it's not suposed to resist much.

/obj/machinery/shield/malfai/Process()
	rem_health(0.5) // Slowly lose integrity over time
	update_health()

/obj/machinery/shield/New()
	src.set_dir(pick(1,2,3,4))
	..()
	update_nearby_tiles(need_rebuild=1)

/obj/machinery/shield/Destroy()
	set_opacity(0)
	set_density(0)
	update_nearby_tiles()
	..()

/obj/machinery/shield/proc/shield_hit_effec()
	time_hit_effect_end = world.realtime + 2 SECONDS
	set_opacity(1)

/obj/machinery/shield/update_health(var/damagetype)
	if(health <= 0)
		destroyed(damagetype)
	update_icon()

/obj/machinery/shield/destroyed()
	visible_message(SPAN_NOTICE("\The [src] dissipates!"))
	qdel(src)

/obj/machinery/shield/Process()
	. = ..()
	if(time_hit_effect_end && world.realtime >= time_hit_effect_end)
		set_opacity(0)
		time_hit_effect_end = 0

/obj/machinery/shield/CanPass(atom/movable/mover, turf/target, height, air_group)
	if(!height || air_group) return 0
	else return ..()

/obj/machinery/shield/take_damage()
	..()
	shield_hit_effec()

/obj/machinery/shield/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(!istype(W))
		return
	..()

/obj/machinery/shield/ex_act(severity)
	shield_hit_effec()
	..()

/obj/machinery/shield/emp_act(severity)
	if(severity == 3) //ignore low emp damage
		return
	shield_hit_effec()
	..()


/obj/machinery/shield/hitby(AM as mob|obj)
	if(..())
		shield_hit_effec()

/obj/machinery/shieldgen
	name = "Emergency shield projector"
	desc = "Used to seal minor hull breaches."
	icon = 'icons/obj/objects.dmi'
	icon_state = "shieldoff"
	density = 1
	opacity = 0
	anchored = 0
	req_access = list(core_access_engineering_programs)
	max_health = 100
	broken_threshold = 0.3 //30 hp
	var/active = 0
	var/malfunction = 0 //Malfunction causes parts of the shield to slowly dissapate
	var/list/deployed_shields = list()
	var/list/regenerating = list()
	var/is_open = 0 //Whether or not the wires are exposed
	var/locked = 0
	var/check_delay = 60	//periodically recheck if we need to rebuild a shield
	use_power = POWER_USE_OFF
	idle_power_usage = 0
	var/time_explosion = 0 //When destroyed the machine will explode in the amount of time set here
	armor = list(
		DAM_BLUNT  	= 20,
		DAM_PIERCE 	= 10,
		DAM_CUT 	= 20,
		DAM_BULLET 	= 20,
		DAM_LASER 	= 20,
		DAM_ENERGY 	= 60,
		DAM_BURN 	= 40,
		DAM_BOMB 	= 40,
		DAM_EMP 	= 20,
		DAM_RADS 	= MaxArmorValue) 	//Resistance for various types of damages


/obj/machinery/shieldgen/after_load()
	..()
	power_change() //Get the shield back up if needed

/obj/machinery/shieldgen/Destroy()
	collapse_shields()
	..()

/obj/machinery/shieldgen/proc/shields_up()
	if(active) return 0 //If it's already turned on, how did this get called?
	src.active = 1
	update_icon()
	create_shields()

	var/new_idle_power_usage = 0
	for(var/obj/machinery/shield/shield_tile in deployed_shields)
		new_idle_power_usage += shield_tile.shield_idle_power
	change_power_consumption(new_idle_power_usage, POWER_USE_IDLE)
	update_use_power(POWER_USE_IDLE)

/obj/machinery/shieldgen/proc/shields_down()
	if(!active) return 0 //If it's already off, how did this get called?

	src.active = 0
	update_icon()

	collapse_shields()

	update_use_power(POWER_USE_OFF)

/obj/machinery/shieldgen/proc/create_shields()
	for(var/turf/target_tile in range(8, src))
		if ((istype(target_tile,/turf/space)|| istype(target_tile, /turf/simulated/open)) && !(locate(/obj/machinery/shield) in target_tile))
			if (malfunction && prob(33) || !malfunction)
				var/obj/machinery/shield/S = new/obj/machinery/shield(target_tile)
				deployed_shields += S
				use_power_oneoff(S.shield_generate_power)

	for(var/turf/above in range(8, GetAbove(src)))//Probably a better way to do this.
		if ((istype(above,/turf/space)|| istype(above, /turf/simulated/open)) && !(locate(/obj/machinery/shield) in above))
			if (malfunction && prob(33) || !malfunction)
				var/obj/machinery/shield/A = new/obj/machinery/shield(above)
				deployed_shields += A
				use_power_oneoff(A.shield_generate_power)

/obj/machinery/shieldgen/proc/collapse_shields()
	for(var/obj/machinery/shield/shield_tile in deployed_shields)
		qdel(shield_tile)

/obj/machinery/shieldgen/power_change()
	. = ..()
	if(!. || !active) return
	if (!ispowered())
		collapse_shields()
	else
		create_shields()

/obj/machinery/shieldgen/Process()
	if(time_explosion && world.realtime >= time_explosion)
		time_explosion = 0
		explosion(get_turf(src.loc), 0, 0, 1, 0, 0, 0)
		qdel(src)
		return
	if (!active || !ispowered())
		return

	if(malfunction)
		if(deployed_shields.len && prob(5))
			qdel(pick(deployed_shields))
	else
		if (check_delay <= 0)
			create_shields()

			var/new_power_usage = 0
			for(var/obj/machinery/shield/shield_tile in deployed_shields)
				new_power_usage += shield_tile.shield_idle_power

			if (new_power_usage != idle_power_usage)
				change_power_consumption(new_power_usage, POWER_USE_IDLE)

			check_delay = 60
		else
			check_delay--

/obj/machinery/shieldgen/broken()
	..()
	src.malfunction = 1
	update_icon()

/obj/machinery/shieldgen/destroyed()
	time_explosion = world.realtime + 1 SECOND
	update_icon()

/obj/machinery/shieldgen/attack_hand(mob/user as mob)
	if(locked)
		to_chat(user, "The machine is locked, you are unable to use it.")
		return
	if(is_open)
		to_chat(user, "The panel must be closed before operating this machine.")
		return

	if (src.active)
		user.visible_message(SPAN_NOTICE("\icon[src] [user] deactivated the shield generator."), \
			SPAN_NOTICE("\icon[src] You deactivate the shield generator."), \
			"You hear heavy droning fade out.")
		src.shields_down()
	else
		if(anchored)
			user.visible_message(SPAN_NOTICE("\icon[src] [user] activated the shield generator."), \
				SPAN_NOTICE("\icon[src] You activate the shield generator."), \
				"You hear heavy droning.")
			src.shields_up()
		else
			to_chat(user, "The device must first be secured to the floor.")
	return

/obj/machinery/shieldgen/emag_act(var/remaining_charges, var/mob/user)
	if(!malfunction)
		broken()
		return 1

/obj/machinery/shieldgen/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(default_deconstruction_screwdriver(W))
		return
	else if(default_deconstruction_crowbar(W))
		return
	else if(isCoil(W) && malfunction && is_open)
		var/obj/item/stack/cable_coil/coil = W
		to_chat(user, SPAN_NOTICE("You begin to replace the wires."))
		if(do_after(user, 30,src))
			if (coil.use(1))
				health = max_health
				malfunction = 0
				set_broken(FALSE)
				to_chat(user, SPAN_NOTICE("You repair the [src]!"))
				update_icon()

	else if(istype(W, /obj/item/weapon/tool/wrench))
		if(locked)
			to_chat(user, SPAN_WARNING("The bolts are covered, unlocking this would retract the covers."))
			return
		if(anchored)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			to_chat(user, SPAN_NOTICE("'You unsecure the [src] from the floor!"))
			if(active)
				to_chat(user, SPAN_WARNING("The [src] shuts off!"))
				src.shields_down()
			anchored = 0
		else
			if(istype(get_turf(src), /turf/space)) return //No wrenching these in space!
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			to_chat(user, SPAN_NOTICE("You secure the [src] to the floor!"))
			anchored = 1


	else if(istype(W, /obj/item/weapon/card/id) || istype(W, /obj/item/modular_computer/pda))
		if(src.allowed(user))
			src.locked = !src.locked
			to_chat(user, SPAN_NOTICE("The controls are now [src.locked ? "locked." : "unlocked."]"))
		else
			to_chat(user, SPAN_WARNING("Access denied."))
	else
		..()


/obj/machinery/shieldgen/on_update_icon()
	if(active && ispowered())
		src.icon_state = malfunction ? "shieldonbr":"shieldon"
	else
		src.icon_state = malfunction ? "shieldoffbr":"shieldoff"
	return
