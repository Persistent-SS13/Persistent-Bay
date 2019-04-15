//Dummy object for holding items in vehicles.
//Prevents items from being interacted with.
/datum/vehicle_dummy_load
	var/name = "dummy load"
	var/actual_load

/obj/vehicle
	name 				= "vehicle"
	icon 				= 'icons/obj/vehicles.dmi'
	plane 				= ABOVE_HUMAN_PLANE
	layer 				= ABOVE_HUMAN_LAYER
	density 			= TRUE
	anchored 			= TRUE
	animate_movement	= TRUE
	light_outer_range = 3
	can_buckle 			= TRUE
	buckle_movable 		= TRUE
	buckle_lying 		= FALSE
	max_health 			= 0		//do not forget to set health for your vehicle!

	var/on 					= FALSE
	var/open 				= FALSE	//Maint panel
	var/locked 				= TRUE
	var/stat 				= 0
	var/emagged 			= FALSE

	var/move_delay 			= 1	//set this to limit the speed of the vehicle
	var/special_movement 	= FALSE

	var/powered 			= FALSE		//set if vehicle is powered and should use fuel when moving
	var/has_cell 			= TRUE
	var/charge_use 			= 200 //W
	var/obj/item/weapon/cell/cell

	var/atom/movable/load		//all vehicles can take a load, since they should all be a least drivable
	var/load_item_visible 	= TRUE	//set if the loaded item should be overlayed on the vehicle sprite
	var/load_offset_x 		= 0		//pixel_x offset for item overlay
	var/load_offset_y 		= 0		//pixel_y offset for item overlay
	var/attack_log 			= null

//-------------------------------------------
// Standard procs
//-------------------------------------------
/obj/vehicle/New()
	..()
	//spawn the cell you want in each vehicle
	ADD_SAVED_VAR(on)
	ADD_SAVED_VAR(open)
	ADD_SAVED_VAR(locked)
	ADD_SAVED_VAR(stat)
	ADD_SAVED_VAR(emagged)
	ADD_SAVED_VAR(cell)
	ADD_SAVED_VAR(load)

	ADD_SKIP_EMPTY(cell)
	ADD_SKIP_EMPTY(load)

/obj/vehicle/Move()
	if(special_movement)
		var/init_anc = anchored
		anchored = FALSE
		if(!..())
			anchored = init_anc
			return 0
		anchored = init_anc
		if(load && !istype(load, /datum/vehicle_dummy_load))
			load.forceMove(loc)
		return 1

	if(world.time > l_move_time + move_delay)
		var/old_loc = get_turf(src)
		if(on && powered && cell.charge < (charge_use * CELLRATE))
			turn_off()

		var/init_anc = anchored
		anchored = FALSE
		if(!..())
			anchored = init_anc
			return 0

		set_dir(get_dir(old_loc, loc))
		anchored = init_anc

		if(on && powered)
			cell.use(charge_use * CELLRATE)

		//Dummy loads do not have to be moved as they are just an overlay
		//See load_object() proc in cargo_trains.dm for an example
		if(load && !istype(load, /datum/vehicle_dummy_load))
			load.forceMove(loc)
			load.set_dir(dir)

		return 1
	else
		return 0

/obj/vehicle/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/hand_labeler))
		return
	else if(isScrewdriver(W))
		if(!locked)
			var/obj/item/weapon/tool/screwdriver/T = W
			if(T.use_tool(user, src, 1 SECOND))
				open = !open
				update_icon()
				to_chat(user, SPAN_NOTICE("Maintenance panel is now [open ? "opened" : "closed"]."))
				return TRUE
		else
			to_chat(user, SPAN_WARNING("Its locked.."))
	else if(isCrowbar(W) && cell && open)
		remove_cell(user)
	else if(istype(W, /obj/item/weapon/cell) && !cell && open)
		insert_cell(W, user)
	else if(isWelder(W))
		var/obj/item/weapon/tool/weldingtool/T = W
		if(isdamaged())
			if(!open)
				to_chat(user, SPAN_NOTICE("Unable to repair with the maintenance panel closed."))
				return TRUE
			if(T.use_tool(user, src, 5 SECONDS))
				add_health(10)
				user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				user.visible_message(SPAN_WARNING("\The [user] repairs some of the damages on \the [src]!"), SPAN_NOTICE("You repair some of the damages on \the [src]!"))
				return TRUE
		else
			to_chat(user, SPAN_NOTICE("[src] does not need repairs."))
	else
		. = ..()

/obj/vehicle/emp_act(severity)
	var/was_on = on
	stat |= EMPED
	var/obj/effect/overlay/pulse2 = new /obj/effect/overlay(loc)
	pulse2.icon = 'icons/effects/effects.dmi'
	pulse2.icon_state = "empdisable"
	pulse2.SetName("emp sparks")
	pulse2.anchored = TRUE
	pulse2.set_dir(pick(GLOB.cardinal))

	spawn(10)
		qdel(pulse2)
	if(on)
		turn_off()
	spawn(severity*300)
		stat &= ~EMPED
		if(was_on)
			turn_on()

/obj/vehicle/attack_ai(mob/user as mob)
	return

/obj/vehicle/unbuckle_mob(mob/user)
	. = ..(user)
	if(load == .)
		unload(.)

//-------------------------------------------
// Vehicle procs
//-------------------------------------------
/obj/vehicle/proc/turn_on()
	if(stat)
		return 0
	if(powered && cell.charge < (charge_use * CELLRATE))
		return 0
	on = TRUE
	set_light(0.8, 1, 5)
	update_icon()
	return 1

/obj/vehicle/proc/turn_off()
	on = FALSE
	set_light(0)
	update_icon()

/obj/vehicle/emag_act(var/remaining_charges, mob/user as mob)
	if(!emagged)
		emagged = TRUE
		if(locked)
			locked = FALSE
			to_chat(user, SPAN_WARNING("You bypass [src]'s controls."))
		return 1

/obj/vehicle/make_debris()
	var/turf/Tsec = get_turf(src)
	new /obj/item/stack/material/rods(Tsec)
	new /obj/item/stack/material/rods(Tsec)
	new /obj/item/stack/cable_coil/cut(Tsec)
	if(cell)
		cell.forceMove(Tsec)
		cell.update_icon()
		cell = null
	new /obj/effect/gibspawner/robot(Tsec)
	new /obj/effect/decal/cleanable/blood/oil(src.loc)

/obj/vehicle/destroyed(damagetype, user)
	//stuns people who are thrown off a train that has been blown up
	if(istype(load, /mob/living))
		var/mob/living/M = load
		M.apply_effects(5, 5)
	unload()
	return ..()

/obj/vehicle/proc/powercheck()
	if(!cell && !powered)
		return

	if(!cell && powered)
		turn_off()
		return

	if(cell.charge < (charge_use * CELLRATE))
		turn_off()
		return

	if(cell && powered)
		turn_on()
		return

/obj/vehicle/proc/insert_cell(var/obj/item/weapon/cell/C, var/mob/living/carbon/human/H)
	if(!has_cell)
		return
	if(cell)
		return
	if(!istype(C))
		return
	if(!H.unEquip(C, src))
		return
	cell = C
	powercheck()
	to_chat(usr, SPAN_NOTICE("You install [C] in [src]."))

/obj/vehicle/proc/remove_cell(var/mob/living/carbon/human/H)
	if(!cell)
		return

	to_chat(usr, SPAN_NOTICE("You remove [cell] from [src]."))
	cell.forceMove(get_turf(H))
	H.put_in_hands(cell)
	cell = null
	powercheck()

/obj/vehicle/proc/RunOver(var/mob/living/carbon/human/H)
	return		//write specifics for different vehicles

//-------------------------------------------
// Loading/unloading procs
//
// Set specific item restriction checks in
// the vehicle load() definition before
// calling this parent proc.
//-------------------------------------------
/obj/vehicle/proc/load(var/atom/movable/C)
	//This loads objects onto the vehicle so they can still be interacted with.
	//Define allowed items for loading in specific vehicle definitions.
	if(!isturf(C.loc)) //To prevent loading things from someone's inventory, which wouldn't get handled properly.
		return 0
	if(load || C.anchored)
		return 0

	// if a create/closet, close before loading
	var/obj/structure/closet/crate = C
	if(istype(crate) && crate.opened && !crate.close())
		return 0

	C.forceMove(loc)
	C.set_dir(dir)
	C.anchored = TRUE

	load = C

	if(load_item_visible)
		C.plane = plane
		C.layer = VEHICLE_LOAD_LAYER		//so it sits above the vehicle

	if(ismob(C))
		buckle_mob(C)
		var/mob/M = C
		M.riding = TRUE
	else if(load_item_visible)
		C.pixel_x += load_offset_x
		C.pixel_y += load_offset_y

	return 1


/obj/vehicle/proc/unload(var/mob/user, var/direction)
	if(!load)
		return

	var/turf/dest = null

	//find a turf to unload to
	if(direction)	//if direction specified, unload in that direction
		dest = get_step(src, direction)
	else if(user)	//if a user has unloaded the vehicle, unload at their feet
		dest = get_turf(user)

	if(!dest)
		dest = get_step_to(src, get_step(src, turn(dir, 90))) //try unloading to the side of the vehicle first if neither of the above are present

	//if these all result in the same turf as the vehicle or nullspace, pick a new turf with open space
	if(!dest || dest == get_turf(src))
		var/list/options = new()
		for(var/test_dir in GLOB.alldirs)
			var/new_dir = get_step_to(src, get_step(src, test_dir))
			if(new_dir && load.Adjacent(new_dir))
				options += new_dir
		if(options.len)
			dest = pick(options)
		else
			dest = get_turf(src)	//otherwise just dump it on the same turf as the vehicle

	if(!isturf(dest))	//if there still is nowhere to unload, cancel out since the vehicle is probably in nullspace
		return 0

	load.forceMove(dest)
	load.set_dir(get_dir(loc, dest))
	load.anchored = FALSE		//we can only load non-anchored items, so it makes sense to set this to false
	if(ismob(load)) //atoms should probably have their own procs to define how their pixel shifts and layer can be manipulated, someday
		var/mob/M = load
		M.pixel_x = M.default_pixel_x
		M.pixel_y = M.default_pixel_y

		M.riding = FALSE
	else
		load.pixel_x = initial(load.pixel_x)
		load.pixel_y = initial(load.pixel_y)
	load.reset_plane_and_layer()

	if(ismob(load))
		unbuckle_mob(load)

	load = null
	queue_icon_update()

	return 1

/obj/vehicle/get_cell()
	return cell

//-------------------------------------------------------
// Stat update procs
//-------------------------------------------------------
/obj/vehicle/proc/update_stats()
	return
