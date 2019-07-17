#define MIN_ACCELERATION 0.1
#define MAX_ACCELERATION 0.5

#define MIN_TRACTION	 0.1
#define MAX_TRACTION	 0.5

#define MIN_MINDELAY	 0.1
#define MAX_MINDELAY	 1.5

#define STARTING_DELAY	 2.0

#define KNOCK_OFF_PROB	 20

#define ADJUSTABLES 	 list("Acceleration","Traction","Max Speed")

/obj/vehicle/bike/
	name = "space-bike"
	desc = "A sleek personal-transportation vehicle commonly seen on large stations."
	icon = 'icons/obj/bike.dmi'
	icon_state = "bike"
	dir = SOUTH

	plane = ABOVE_HUMAN_PLANE
	layer = VEHICLE_BASE_LAYER

	load_item_visible = TRUE
	buckle_pixel_shift = "x=0;y=5"
	max_health = 100
	mass = 170.0 //kg or ~373 lb

	animate_movement = SYNC_STEPS

	has_cell = FALSE
	special_movement = TRUE

	locked = TRUE
	armor = list(
		DAM_BLUNT  	= 50,
		DAM_PIERCE 	= 40,
		DAM_CUT 	= 50,
		DAM_BULLET 	= 50,
		DAM_ENERGY 	= 60,
		DAM_BURN 	= 60,
		DAM_BOMB 	= 60,
		DAM_EMP 	= 50,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue) 	//Resistance for various types of damages
	var/protection_percent = 60

	var/min_delay =    		MIN_MINDELAY	//the lowest delay; fastest speed of vehicle
	var/starting_delay = 	STARTING_DELAY	//the highest delay; slowest/starting speed of the vehicle. If the move_delay is set to this, the bike is stopped.
	var/acceleration = 		0.2				//how quickly move_delay decreases.
	var/traction = 	   		0.3				//how quickly move_delay increases

	var/l_control_time	// last control time
	var/cruise =  FALSE // cruise control; disables friction
	var/stopped = TRUE
	var/starter			//time given before friction activates

	var/paint_color = "#ffffff"
	var/kickstand = FALSE

	var/fuel_points = 0
	atom_flags = ATOM_FLAG_OPEN_CONTAINER | ATOM_FLAG_NO_REACT

/obj/vehicle/bike/New()
	..()
	if(!reagents) create_reagents(500)
	update_icon()

/obj/vehicle/bike/Destroy()
	STOP_PROCESSING(SSvehicleprocess, src)
	. = ..()

/obj/vehicle/bike/load(var/atom/movable/C)
	var/mob/living/M = C
	if(!istype(M)) return 0
	if(M.buckled || M.restrained() || !Adjacent(M) || !M.Adjacent(src) || M.incapacitated())
		return 0

	var/datum/action/vehicle/toggle_engine/te = new(src)
	var/datum/action/vehicle/toggle_cruise/tc = new(src)

	te.Grant(M)
	tc.Grant(M)

	return ..(M)

/obj/vehicle/bike/unload(var/atom/movable/C)
	var/mob/living/carbon/human/H = C

	if(move_delay <= starting_delay * 0.33 && istype(H))
		var/list/throw_dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)

		//Make sure we're throwing them *away* from the bike
		throw_dirs -= dir

		visible_message("<span class='danger'>\The [load] is thrown from \the [src]!</span>")
		H.apply_effects(5, 3)
		for(var/i = 0; i < 2; i++)
			var/def_zone = ran_zone()
			H.apply_damage(2 / (move_delay ? move_delay : 0.1), DAM_BLUNT, def_zone)

		var/turf/turf = get_step(H, pick(throw_dirs))
		H.throw_at(turf, 3)

	return ..(H)

/obj/vehicle/bike/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/weapon/card/id) || istype(W, /obj/item/modular_computer/pda))

		var/obj/item/weapon/card/id/ID = W

		if(istype(W, /obj/item/modular_computer/pda))
			var/obj/item/modular_computer/pda/pda = W
			ID = pda.GetIdCard()

		if(!req_access_personal_list.len)
			req_access_personal_list += ID.registered_name
			to_chat(user, SPAN_NOTICE("You add your name to \the [src]'s database, locking it to your control."))
			return
		else if(ID.registered_name in req_access_personal_list)
			to_chat(user, SPAN_NOTICE("You [locked ? "unlock" : "lock"] \the [src]'s maintenance panel."))
			locked = !locked
			return
		else if(open)
			req_access_personal_list += ID.registered_name
			to_chat(user, SPAN_NOTICE("You add your name to \the [src]'s database, allowing you to control it."))
			return
		else
			to_chat(user, SPAN_WARNING("Open the panel of \the [src] to register an additional name."))
			return

	if(open)
		if(isWrench(W))
			var/choice = input("What part of \the [src] would you like to adjust?") as null|anything in ADJUSTABLES

			var/val

			switch(choice)
				if("Acceleration")
					val = input("Enter an acceleration speed between [MIN_ACCELERATION] and [MAX_ACCELERATION]") as num
					if(val >= MIN_ACCELERATION && val <= MAX_ACCELERATION)
						acceleration = val
					else
						to_chat(user, SPAN_NOTICE("Please enter a value between [MIN_ACCELERATION] and [MAX_ACCELERATION]."))
						return

				if("Traction")
					val = input("Enter a traction value between [MIN_TRACTION] and [MAX_TRACTION]") as num
					if(val >= MIN_TRACTION && val <= MAX_TRACTION)
						traction = val
					else
						to_chat(user, SPAN_NOTICE("Please enter a value between [MIN_TRACTION] and [MAX_TRACTION]."))
						return

				if("Max Speed")
					val = input("Enter a max speed value between [MIN_MINDELAY] and [MAX_MINDELAY]. Lower numbers are faster.") as num
					if(val >= MIN_MINDELAY && val <= MAX_MINDELAY)
						min_delay = val
					else
						to_chat(user, SPAN_NOTICE("Please enter a value between [MIN_MINDELAY] and [MAX_MINDELAY]."))
						return

			to_chat(user, SPAN_NOTICE("You set the [choice] to [val]."))
			return

		if(istype(W, /obj/item/device/multitool))
			paint_color = input("What color would you like to paint \the [src]?") as color
			update_icon()
			return

		if(istype(W, /obj/item/stack/cable_coil))
			to_chat(user, SPAN_NOTICE("You short the blackbox on \the [src], clearing its ID memory."))
			req_access_personal_list.Cut()
			return

	if(istype(W,/obj/item/weapon/reagent_containers) && W.is_open_container())
		to_chat(user, SPAN_NOTICE("You refill \the [src]'s fuel tank."))
		return

	return ..()

/obj/vehicle/bike/MouseDrop_T(var/atom/movable/C, var/mob/user)
	if(!load(C))
		to_chat(user, SPAN_WARNING("You were unable to load \the [C] onto \the [src]."))
		return

/obj/vehicle/bike/attack_hand(var/mob/user)
	if(user == load)
		unbuckle_mob(user)
		to_chat(user, SPAN_NOTICE("You unbuckle yourself from \the [src]"))

/obj/vehicle/bike/relaymove(mob/user, direction)
	if(user != load || !on || user.incapacitated())
		return

	if(kickstand) return

	// Turning - Going fast (> .5 of max speed) will result in a 'swerve' - a minor speed decrease and shift in tile without a change in direction.
	//		   - Going slow (< .5 of max speed) will result in a 'turn'	  - retains your speed while shifting tile and direction
	if(((direction == EAST || direction == WEST) && (dir == NORTH || dir == SOUTH)) || ((direction == NORTH || direction == SOUTH) && (dir == WEST || dir == EAST)))
		// Swerving
		if(move_delay < (starting_delay/2))
			Move(get_step(src, direction))
			// Swerving slows you down slightly
			move_delay = ((move_delay += traction/2) < starting_delay) ? (move_delay += traction/2) : starting_delay
			if(move_delay == starting_delay)
				stopped = TRUE
		// Turning
		else
			set_dir(direction)
			if(load)
				load.set_dir(direction)
		return

	if(stopped)
		if(dir == direction)  			// Start movement
			move_delay -= acceleration
			stopped = FALSE
			return
		else							// Rotate the vehicle without moving
			set_dir(direction)
			if(load)
				load.set_dir(direction)
			return

	// Going forward - doing the check here to avoid doing the more expensive checks after,
	if(direction == dir)
		move_delay = ((move_delay -= acceleration) > min_delay) ? (move_delay -= acceleration) : min_delay
		return

	// Going backwards - braking
	if((direction == NORTH && dir == SOUTH) || (direction == SOUTH && dir == NORTH) || (direction == WEST && dir == EAST) || (direction == EAST && dir == WEST))
		move_delay = ((move_delay += traction) < starting_delay) ? (move_delay += traction) : starting_delay
		l_move_time = world.time
		if(move_delay == starting_delay)
			stopped = TRUE
			return
		return

/obj/vehicle/bike/Process()
	if(load && ismob(load))
		var/mob/M = load
		if(M.incapacitated())
			unload()

	// Vehicle processing is expensive
	if(world.time - l_move_time > 1 MINUTE)
		move_delay = starting_delay
		stopped = TRUE
		turn_off()

	if(stopped)
		return

	playsound(src.loc, 'sound/machines/motorloop.ogg', 12, 0, 2)

	if(world.time >= (l_move_time + move_delay))
		Move(get_step(src, dir))
		l_move_time = world.time

		if(!cruise) // Friction kicks in if cruise control isn't on
			move_delay = ((move_delay += traction/2) < starting_delay) ? (move_delay += traction/2) : starting_delay
			if(move_delay == starting_delay)
				stopped = TRUE
	if(load)
		load.set_dir(dir)

/obj/vehicle/bike/Move(var/turf/destination)
	if(on && !use_fuel())
		turn_off()
		return 0

	return ..()

/obj/vehicle/bike/Bump(atom/Obstacle)
	if(istype(Obstacle, /obj/machinery/door/))
		Obstacle.Bumped(load)
		return

	if(move_delay <= starting_delay * 0.33)

		if(istype(Obstacle, /obj/structure/window))
			var/obj/structure/window/win = Obstacle
			win.take_damage((mass * (move_delay ? move_delay : 0.1) / 2.0), DAM_BLUNT)
			if(istype(load, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = load
				H.apply_damage(rand(1, 3))
			return

		playsound(src.loc, 'sound/effects/grillehit.ogg', 80, 0, 10)
		take_damage(round(2/(move_delay ? move_delay : 0.1)), DAM_BLUNT, 0, Obstacle) // BYOND rounding can lead to a division by zero error. Ditto throughout the file.

		var/list/throw_dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)

		//Make sure we're throwing them *away* from the bike
		throw_dirs -= dir
		throw_dirs -= get_dir(Obstacle, src)

		if(istype(Obstacle, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = Obstacle
			H.apply_effects(5, 3)
			for(var/i = 0; i < 2; i++)
				var/def_zone = ran_zone()
				H.apply_damage(1.5 / (move_delay ? move_delay : 0.1), DAM_BLUNT, def_zone)

			var/turf/turf = get_step(H, pick(throw_dirs))

			visible_message(SPAN_DANGER("[Obstacle] is hit by \the [src]!"))

			H.throw_at(turf, 3)

		unload()

	move_delay = starting_delay
	stopped = TRUE

/obj/vehicle/bike/RunOver(var/mob/living/carbon/human/H)
	H.apply_effects(5, 3)
	for(var/i = 0; i < 2; i++)
		var/def_zone = ran_zone()
		H.apply_damage(1 / (move_delay ? move_delay : 0.1), DAM_BLUNT, def_zone)

	visible_message(SPAN_DANGER("[H] is run over by \the [src]!"))

	if(prob(KNOCK_OFF_PROB)) // Running over someone has a chance to throw you off your bike.
		unbuckle_mob(buckled_mob)

/obj/vehicle/bike/turn_on()
	if(on)
		return

	src.audible_message("\The [src] rumbles to life.")

	anchored = TRUE

	update_icon()

	if(pulledby)
		pulledby.stop_pulling()

	l_move_time = world.time

	update_fuel()
	START_PROCESSING(SSvehicleprocess, src)
	..()

/obj/vehicle/bike/turn_off()
	if(!on)
		return

	src.audible_message("\The [src] putters before turning off.")

	anchored = kickstand

	update_icon()

	move_delay = starting_delay
	stopped = TRUE

	update_fuel()
	STOP_PROCESSING(SSvehicleprocess, src)
	..()

/obj/vehicle/bike/proc/use_fuel()
	if(LAZYLEN(reagents.reagent_list))
		update_fuel()
	if(fuel_points)
		fuel_points--
		return TRUE
	return FALSE

/obj/vehicle/bike/proc/update_fuel()
	for(var/datum/reagent/R in reagents.reagent_list)
		if(istype(R, /datum/reagent/ethanol))
			fuel_points += 10 * reagents.get_reagent_amount(R.type)
		if(istype(R, /datum/reagent/fuel))
			fuel_points += 30 * reagents.get_reagent_amount(R.type)
		if(istype(R, /datum/reagent/toxin/phoron))
			fuel_points += 50 * reagents.get_reagent_amount(R.type)

	reagents.clear_reagents()

/obj/vehicle/bike/examine(mob/user)
	. = ..()
	update_fuel()
	to_chat(user, SPAN_NOTICE("The fuel gauge shows it has [fuel_points] unit(s) of fuel left."))

/obj/vehicle/bike/bullet_act(var/obj/item/projectile/Proj)
	if(buckled_mob && prob(protection_percent))
		buckled_mob.bullet_act(Proj)
		if(prob(KNOCK_OFF_PROB))
			buckled_mob.visible_message("[buckled_mob] is knocked off \the [src] by the force of the blow!", "You're knocked off \the [src] by the force of the blow!")
			unbuckle_mob(buckled_mob)
	..()

/obj/vehicle/bike/update_icon()
	overlays.Cut()

	var/image/bodypaint = image(src.icon, "body_color_overlay", src.layer)
	bodypaint.color = paint_color
	overlays += bodypaint

	overlays += image(src.icon, "bike_overlay", "layer" = VEHICLE_TOP_LAYER)
	..()

/datum/action/vehicle/
	action_type = AB_GENERIC
	check_flags = AB_CHECK_STUNNED|AB_CHECK_LYING

/datum/action/vehicle/CheckRemoval(mob/living/user)
	return (get_dist(target, user) > 0)

/datum/action/vehicle/toggle_engine
	name = "Toggle Engine"
	procname = "toggle_engine"
	button_icon_state = "toggle_engine"

/datum/action/vehicle/toggle_cruise
	name = "Toggle Cruise Control"
	procname = "toggle_cruise"
	button_icon_state = "toggle_cruise"

/obj/vehicle/bike/proc/toggle_engine(var/mob/living/user)

	if(!allowed(user))
		to_chat(usr, SPAN_WARNING("\The [src] doesn't respond to your ID."))
		return

	if(!on)
		turn_on()
	else
		turn_off()

/obj/vehicle/bike/proc/toggle_cruise(var/mob/living/user)

	if(!allowed(user))
		to_chat(usr, SPAN_WARNING("\The [src] doesn't respond to your ID."))
		return

	cruise = !cruise
	to_chat(usr, SPAN_WARNING("You toggle \the [src]'s cruise control [cruise ? "on" : "off"]."))

/obj/vehicle/bike/verb/kickstand()
	set name = "Toggle Kickstand"
	set category = "Object"
	set src in view(0)

	if(usr.incapacitated()) return

	if(!allowed(usr))
		to_chat(usr, SPAN_WARNING("\The [src] doesn't respond to your ID."))
		return

	usr.visible_message("\The [usr] puts [kickstand ? "up" : "down"] \the [src]'s kickstand.")
	kickstand = !kickstand

	if(pulledby)
		pulledby.stop_pulling()

	anchored = (kickstand || on)

/obj/vehicle/bike/verb/unbuckle()
	set name = "Unbuckle"
	set category = "Object"
	set src in view(1)

	if(!load)
		return
	usr.visible_message("\The [usr] starts unbuckling \the [load] from the [src].")
	if(do_after(usr, 15, src))
		unload(usr)


/obj/vehicle/bike/prefilled
	fuel_points = 1000

#undef MIN_ACCELERATION
#undef MAX_ACCELERATION

#undef MIN_TRACTION
#undef MAX_TRACTION

#undef MIN_MINDELAY
#undef MAX_MINDELAY

#undef KNOCK_OFF_PROB

#undef ADJUSTABLES
