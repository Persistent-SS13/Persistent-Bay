/obj/structure
	icon = 'icons/obj/structures.dmi'
	w_class = ITEM_SIZE_NO_CONTAINER
	obj_flags = OBJ_FLAG_DAMAGEABLE
	max_health = 100
	damthreshold_brute 	= 5
	damthreshold_burn = 5
	var/parts
	var/list/connections = list("0", "0", "0", "0")
	var/list/other_connections = list("0", "0", "0", "0")
	var/list/blend_objects = newlist() // Objects which to blend with
	var/list/noblend_objects = newlist() //Objects to avoid blending with (such as children of listed blend objects.

/obj/structure/New()
	..()
	ADD_SAVED_VAR(anchored)

/obj/structure/after_load()
	update_connections(1)
	..()

/obj/structure/Destroy()
	. = ..()

/obj/structure/attack_hand(mob/user)
	if(isdamageable())
		if(MUTATION_HULK in user.mutations)
			user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
			attack_generic(user,1,"smashes")
		else if(istype(user,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			if(H.species.can_shred(user))
				attack_generic(user,1,"slices")
	return ..()

/obj/structure/attack_tk()
	return

/obj/structure/proc/can_visually_connect()
	return anchored

/obj/structure/proc/can_visually_connect_to(var/obj/structure/S)
	return istype(S, src)

/obj/structure/proc/update_connections(propagate = 0)
	var/list/dirs = list()
	var/list/other_dirs = list()

	if(!anchored)
		return

	for(var/obj/structure/S in orange(src, 1))
		if(can_visually_connect_to(S))
			if(S.can_visually_connect())
				if(propagate)
					S.update_connections(0)
					S.update_icon()
				dirs += get_dir(src, S)

	for(var/direction in GLOB.cardinal)
		var/turf/T = get_step(src, direction)
		var/success = 0
		for(var/b_type in blend_objects)
			if(istype(T, b_type))
				success = 1
				if(propagate)
					var/turf/simulated/wall/W = T
					if(istype(W))
						W.update_connections(1)
						W.update_icon()
				if(success)
					break
			if(success)
				break
		if(!success)
			for(var/obj/O in T)
				for(var/b_type in blend_objects)
					if(istype(O, b_type))
						success = 1
						for(var/obj/structure/S in T)
							if(istype(S, src))
								success = 0
						for(var/nb_type in noblend_objects)
							if(istype(O, nb_type))
								success = 0

					if(success)
						break
				if(success)
					break

		if(success)
			dirs += get_dir(src, T)
			other_dirs += get_dir(src, T)

	connections = dirs_to_corner_states(dirs)
	other_connections = dirs_to_corner_states(other_dirs)

/obj/structure/proc/dismantle()
	if(parts)
		new parts(loc)

/obj/structure/proc/default_deconstruction_screwdriver(var/obj/item/weapon/tool/screwdriver/S, var/mob/living/user, var/deconstruct_time = null)
	if(!istype(S))
		return FALSE
	src.add_fingerprint(user)
	user.visible_message(SPAN_NOTICE("You begin to unscrew \the [src]."), SPAN_NOTICE("[user] begins to unscrew \the [src]."))
	playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
	if(do_after(usr, deconstruct_time? deconstruct_time : 6 SECONDS, src) && src)
		user.visible_message(SPAN_NOTICE("You finish unscrewing \the [src]."), SPAN_NOTICE("[user] finishes unscrewing \the [src]."))
		dismantle()
		return TRUE
	return FALSE

/obj/structure/proc/default_deconstruction_wrench(var/obj/item/weapon/tool/wrench/W, var/mob/living/user, var/deconstruct_time = null)
	if(!istype(W))
		return FALSE
	src.add_fingerprint(user)
	to_chat(usr, SPAN_NOTICE("You begin to dismantle \the [src]."))
	playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
	if(do_after(usr, deconstruct_time? deconstruct_time : 4 SECONDS, src) && src)
		to_chat(usr, SPAN_NOTICE("You finish dismantling \the [src]."))
		dismantle()
		return TRUE
	return FALSE

