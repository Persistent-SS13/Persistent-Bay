#define CONTROL_DELAY 0.5
#define STARTER_TICKS 5

#define MIN_ACCELERATION 0.1
#define MAX_ACCELERATION 0.5

#define MIN_TRACTION	 0.1
#define MAX_TRACTION	 0.5

#define MIN_MINDELAY	 0.1
#define MAX_MINDELAY	 1.5

#define STARTING_DELAY	 2.0

#define KNOCK_OFF_PROB	 0.2

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
	health = 100
	maxhealth = 100

	animate_movement = SYNC_STEPS

	has_cell = FALSE

	locked = TRUE
	fire_dam_coeff = 0.6
	brute_dam_coeff = 0.5
	var/protection_percent = 60

	var/min_delay =    		MIN_MINDELAY	//the lowest delay; fastest speed of vehicle
	var/starting_delay = 	STARTING_DELAY	//the highest delay; slowest/starting speed of the vehicle. If the move_delay is set to this, the bike is stopped.
	var/control_delay = 	CONTROL_DELAY	//time between accepted inputs
	var/acceleration = 		0.2				//how quickly move_delay decreases.
	var/traction = 	   		0.3				//how quickly move_delay increases

	var/l_control_time	//last control time
	var/stopped = TRUE
	var/starter			//time given before friction activates
	var/relayed = FALSE	//tracks relayed movements

	var/paint_color = "#ffffff"
	var/list/registered_names = list() //tracks who can unlock and ride the bike (tracks by ID name)

	var/fuel_points = 0
	var/kickstand = 1

/obj/vehicle/bike/New()
	..()
	l_control_time = world.time
	update_icon()

/obj/vehicle/bike/Initialize()
	. = ..()

/obj/vehicle/bike/Destroy()
	registered_names.Cut()
	return ..()

/obj/vehicle/bike/load(var/atom/movable/C)
	var/mob/living/M = C
	if(!istype(C)) return 0
	if(M.buckled || M.restrained() || !Adjacent(M) || !M.Adjacent(src) || M.incapacitated())
		return 0
	return ..(M)

/obj/vehicle/bike/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/card/id) || istype(W, /obj/item/device/pda))

		var/obj/item/weapon/card/id/ID = W

		if(istype(W, /obj/item/device/pda))
			var/obj/item/device/pda/pda = W
			ID = pda.id

		if(!registered_names.len)
			registered_names += ID.registered_name
			to_chat(user, "You add add your name to \the [src]'s database, locking it to your control.")
			return
		else if(ID.registered_name in registered_names)
			to_chat(user, "You [locked ? "unlock" : "lock"] \the [src]'s controls.")
			locked = !locked
			return
		else if(open)
			registered_names += ID.registered_name
			to_chat(user, "You add your name to \the [src]'s database, allowing you to control it.")
			return
		else
			to_chat(user, "<span class='warning'>Open the panel of \the [src] to register an additional name.</span>")
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
						to_chat(user, "Please enter a value between [MIN_ACCELERATION] and [MAX_ACCELERATION].")
						return

				if("Traction")
					val = input("Enter a traction value between [MIN_TRACTION] and [MAX_TRACTION]") as num
					if(val >= MIN_TRACTION && val <= MAX_TRACTION)
						traction = val
					else
						to_chat(user, "Please enter a value between [MIN_TRACTION] and [MAX_TRACTION].")
						return

				if("Max Speed")
					val = input("Enter a max speed value between [MIN_MINDELAY] and [MAX_MINDELAY]. Lower numbers are faster.") as num
					if(val >= MIN_MINDELAY && val <= MAX_MINDELAY)
						min_delay = val
					else
						to_chat(user, "Please enter a value between [MIN_MINDELAY] and [MAX_MINDELAY].")
						return

			to_chat(user, "You set the [choice] to [val].")
			return

		if(istype(W, /obj/item/device/multitool))
			paint_color = input("What color would you like to paint \the [src]?") as color
			update_icon()
			return

		if(istype(W, /obj/item/stack/cable_coil))
			to_chat(user, "You short the blackbox on \the [src], clearing its ID memory.")
			registered_names.Cut()
			return

		if(istype(W, /obj/item/weapon/reagent_containers))
			var/obj/item/weapon/reagent_containers/rc = W

			for(var/datum/reagent/R in rc.reagents.reagent_list)
				if(istype(R, /datum/reagent/ethanol))
					fuel_points += 10 * rc.reagents.get_reagent_amount(/datum/reagent/ethanol)
				if(istype(R, /datum/reagent/fuel))
					fuel_points += 30 * rc.reagents.get_reagent_amount(/datum/reagent/fuel)
				if(istype(R, /datum/reagent/toxin/phoron))
					fuel_points += 50 * rc.reagents.get_reagent_amount(/datum/reagent/toxin/phoron)

			rc.reagents.clear_reagents()
			to_chat(user, "You refill \the [src]'s fuel tank.")
			return

	return ..()

/obj/vehicle/bike/MouseDrop_T(var/atom/movable/C, mob/user as mob)
	if(!load(C))
		to_chat(user, "<span class='warning'>You were unable to load \the [C] onto \the [src].</span>")
		return

/obj/vehicle/bike/attack_hand(var/mob/user as mob)
	if(user == load)
		unload(load)
		to_chat(user, "You unbuckle yourself from \the [src]")

/obj/vehicle/bike/relaymove(mob/user, direction)
	if(user != load || !on || user.incapacitated())
		return

	if(kickstand) return

	if(world.time >= (l_control_time + CONTROL_DELAY)) // Putting a minor delay between inputs to keep the controls tight
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
				Move(get_step(src,	direction))
				set_dir(direction)
				if(load)
					load.set_dir(direction)
				// Turning slows you down more
				move_delay = ((move_delay += traction) < starting_delay) ? (move_delay += traction) : starting_delay
				if(move_delay == starting_delay)
					stopped = TRUE

				l_control_time = world.time + control_delay // Turning takes twice as long as swerving
			relayed = TRUE
			return

	if(world.time < (l_move_time + move_delay))
		return

	if(stopped)
		if(dir == direction)  			// Start movement
			move_delay -= acceleration
			stopped = FALSE
			l_move_time = world.time
			starter = STARTER_TICKS
			return
		else							// Rotate the vehicle without moving
			set_dir(direction)
			if(load)
				load.set_dir(direction)
			l_move_time = world.time
			return

	// Going forward - doing the check here to avoid doing the more expensive checks after,
	if(direction == dir)
		move_delay = ((move_delay -= acceleration) > min_delay) ? (move_delay -= acceleration) : min_delay
		Move(get_step(src, dir))
		if(load)
			load.set_dir(direction)
		l_move_time = world.time
		relayed = TRUE
		return

	// Going backwards - braking
	if((direction == NORTH && dir == SOUTH) || (direction == SOUTH && dir == NORTH) || (direction == WEST && dir == EAST) || (direction == EAST && dir == WEST))
		move_delay = ((move_delay += traction) < starting_delay) ? (move_delay += traction) : starting_delay
		l_move_time = world.time
		if(move_delay == starting_delay)
			stopped = TRUE
			return
		relayed = TRUE
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
	// Relayed actions
	if(starter > 0) // Time is given for the bike to get moving before friction kicks in
		starter--
		return


	if(!relayed) // No actions taken; continue moving in the current direction
		move_delay = ((move_delay += traction/2) < starting_delay) ? (move_delay += traction/2) : starting_delay
		if(move_delay == starting_delay)
			stopped = TRUE
			return
		Move(get_step(src, dir))
		return

	relayed = FALSE


/obj/vehicle/bike/Move(var/turf/destination)
	if(!use_fuel())
		turn_off()
		return 0

	return ..()

/obj/vehicle/bike/Bump(atom/Obstacle)
	if(istype(Obstacle, /obj/machinery/door/))
		Obstacle.Bumped(load)
		return
   
	if(move_delay <= starting_delay/2)

		if(istype(Obstacle, /obj/structure/window))
			var/obj/structure/window/win = Obstacle
			if(!win.reinf)
				win.shatter()
				if(istype(load, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = load
					H.apply_damage(rand(1, 3), BRUTE)
				return

		playsound(src.loc, 'sound/effects/grillehit.ogg', 80, 0, 10)
		health -= round(2/move_delay)

		var/list/parts = list(BP_HEAD, BP_CHEST, BP_L_LEG, BP_R_LEG, BP_L_ARM, BP_R_ARM)

		if(istype(Obstacle, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = Obstacle
			H.apply_effects(5, 3)
			for(var/i = 0, i < rand(1,3), i++)
				var/def_zone = pick(parts)
				H.apply_damage(rand(2, 5), BRUTE, def_zone, H.run_armor_check(def_zone, "melee"))

			var/list/throw_dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)

			//Make sure we're throwing them *away* from the bike
			throw_dirs -= dir
			throw_dirs -= get_dir(H, src)
			var/turf/turf = get_step(H, pick(throw_dirs))

			H.throw_at(turf, 3)

		if(istype(load, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = load
			H.apply_effects(5, 5)
			for(var/i = 0, i < rand(1,3), i++)
				var/def_zone = pick(parts)
				H.apply_damage(rand(2, 5), BRUTE, def_zone, H.run_armor_check(def_zone, "melee"))
			unload()

	move_delay = starting_delay
	stopped = TRUE

/obj/vehicle/bike/turn_on()
	if(on)
		return

	src.audible_message("\The [src] rumbles to life.")

	anchored = 1

	update_icon()

	if(pulledby)
		pulledby.stop_pulling()

	l_move_time = world.time
	START_PROCESSING(SSfastprocess, src)
	..()

/obj/vehicle/bike/turn_off()
	if(!on)
		return

	src.audible_message("\The [src] putters before turning off.")

	anchored = kickstand

	update_icon()

	STOP_PROCESSING(SSfastprocess, src)
	..()

/obj/vehicle/bike/proc/use_fuel()
	if(fuel_points)
		fuel_points--
		return TRUE
	return FALSE

/obj/vehicle/bike/bullet_act(var/obj/item/projectile/Proj)
	if(buckled_mob && prob(protection_percent))
		buckled_mob.bullet_act(Proj)
		if(prob(KNOCK_OFF_PROB))
			to_chat(buckled_mob, "You're knocked off \the [src] by the force of the blow!")
		return
	..()

/obj/vehicle/bike/update_icon()
	overlays.Cut()

	var/image/bodypaint = image('icons/obj/bike.dmi', "body_color_overlay", src.layer)
	bodypaint.color = paint_color
	overlays += bodypaint

	overlays += image('icons/obj/bike.dmi', "bike_overlay", "layer" = VEHICLE_TOP_LAYER)
	..()

/obj/vehicle/bike/verb/toggle()
	set name = "Toggle Engine"
	set category = "Object"
	set src in view(0)

	if(usr.incapacitated()) return

	if(!(usr.name in registered_names))
		to_chat(usr, "<span class='warning'>\The [src] doesn't respond to your ID.</span>")
		return

	if(!on)
		turn_on()
	else
		turn_off()

/obj/vehicle/bike/verb/kickstand()
	set name = "Toggle Kickstand"
	set category = "Object"
	set src in view(0)

	if(usr.incapacitated()) return

	if(!(usr.name in registered_names))
		to_chat(usr, "<span class='warning'>\The [src] doesn't respond to your ID.</span>")
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


#undef CONTROL_DELAY
#undef STARTER_TICKS

#undef MIN_ACCELERATION
#undef MAX_ACCELERATION

#undef MIN_TRACTION
#undef MAX_TRACTION

#undef MIN_MINDELAY
#undef MAX_MINDELAY

#undef STARTING_DELAY

#undef KNOCK_OFF_PROB

#undef ADJUSTABLES