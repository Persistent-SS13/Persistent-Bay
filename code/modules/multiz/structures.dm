//////////////////////////////
//Contents: Ladders, Stairs.//
//////////////////////////////

//
//	Ladders
//
/obj/structure/ladder
	name 		= "ladder"
	desc 		= "A ladder. You can climb it up and down."
	icon_state 	= "ladder01"
	icon 		= 'icons/obj/structures/ladders.dmi'
	density 	= 0
	opacity 	= 0
	anchored 	= TRUE
	matter 		= list(MATERIAL_STEEL = 5 SHEETS)

	var/allowed_directions = DOWN
	var/obj/structure/ladder/target_up
	var/obj/structure/ladder/target_down

	var/const/climb_time = 2 SECONDS
	var/static/list/climbsounds = list('sound/effects/ladder.ogg','sound/effects/ladder2.ogg','sound/effects/ladder3.ogg','sound/effects/ladder4.ogg')
	var/dnr = 0

/obj/structure/ladder/up
	allowed_directions = UP
	icon_state = "ladder10"

/obj/structure/ladder/updown
	allowed_directions = UP|DOWN
	icon_state = "ladder11"

/obj/structure/ladder/New()
	. = ..()
	ADD_SAVED_VAR(allowed_directions)

/obj/structure/ladder/proc/link_ladders()
	// the upper will connect to the lower
	for(var/obj/structure/ladder/L in GetBelow(src))
		log_debug("Tring to link [src]([x],[y],[z]) down with [L]([L.x],[L.y],[L.z])")
		log_debug("Linked!")
		target_down = L
		allowed_directions |= DOWN
		L.target_up = src
		L.allowed_directions |= UP
		return

/obj/structure/ladder/Initialize(mapload)
	. = ..()
	if(mapload)
		link_ladders() //On map load, just do the downward link
	else
		update_links()
	queue_icon_update()

//Meant to be used when building/removing ladders
/obj/structure/ladder/proc/update_links()
	var/obj/structure/ladder/LU = locate() in GetAbove(src)
	var/obj/structure/ladder/LD = locate() in GetBelow(src)

	if(LU)
		LU.target_down = src
		target_up = LU
		LU.allowed_directions |= DOWN
		allowed_directions |= UP
		LU.update_icon()
		log_debug("Linking [src]([x][y][z]) up with [LU]([LU.x],[LU.y],[LU.z])")
	else
		target_up = null
		allowed_directions &= ~UP

	if(LD)
		LD.target_up = src
		target_down = LD
		LD.allowed_directions |= UP
		allowed_directions |= DOWN
		LD.update_icon()
		log_debug("Linking [src]([x][y][z]) down with [LD]([LD.x],[LD.y],[LD.z])")
	else
		target_down = null
		allowed_directions &= ~DOWN

	update_icon()

/obj/structure/ladder/Destroy()
	if(target_down)
		target_down.target_up = null
		target_down = null
	if(target_up)
		target_up.target_down = null
		target_up = null
	return ..()

/obj/structure/ladder/attackby(obj/item/I, mob/user)
	if(default_deconstruction_wrench(I, user, 20 SECONDS))
		return
	else
		climb(user, I)

/obj/structure/ladder/attack_hand(var/mob/M)
	climb(M)
/obj/structure/ladder/attack_robot(var/mob/M)
	climb(M)
/obj/structure/ladder/attack_ghost(var/mob/M)
	instant_climb(M)

/obj/structure/ladder/attack_ai(var/mob/M)
	var/mob/living/silicon/ai/ai = M
	if(!istype(ai))
		return
	var/mob/observer/eye/AIeye = ai.eyeobj
	if(istype(AIeye))
		instant_climb(AIeye)

/obj/structure/ladder/proc/instant_climb(var/mob/M)
	var/atom/target_ladder = getTargetLadder(M)
	if(target_ladder)
		M.forceMove(get_turf(target_ladder))

/obj/structure/ladder/proc/climb(mob/M, obj/item/I = null)
	if(!M.may_climb_ladders(src))
		return

	add_fingerprint(M)
	var/obj/structure/ladder/target_ladder = getTargetLadder(M)
	if(!target_ladder)
		return
	if(!M.Move(get_turf(src)))
		to_chat(M, "<span class='notice'>You fail to reach \the [src].</span>")
		return

	for (var/obj/item/grab/G in M)
		G.adjust_position()

	var/direction = target_ladder == target_up ? "up" : "down"

	M.visible_message("<span class='notice'>\The [M] begins climbing [direction] \the [src]!</span>",
	"You begin climbing [direction] \the [src]!",
	"You hear the grunting and clanging of a metal ladder being used.")

	target_ladder.audible_message("<span class='notice'>You hear something coming [direction] \the [src]</span>")

	if(do_after(M, climb_time, src))
		climbLadder(M, target_ladder, I)
		for (var/obj/item/grab/G in M)
			G.adjust_position(force = 1)

/obj/structure/ladder/proc/getTargetLadder(var/mob/M)
	if((!target_up && !target_down) || (target_up && !istype(target_up.loc, /turf) || (target_down && !istype(target_down.loc,/turf))))
		to_chat(M, "<span class='notice'>\The [src] is incomplete and can't be climbed.</span>")
		return
	if(target_down && target_up)
		var/direction = alert(M,"Do you want to go up or down?", "Ladder", "Up", "Down", "Cancel")

		if(direction == "Cancel")
			return

		if(!M.may_climb_ladders(src))
			return

		switch(direction)
			if("Up")
				return target_up
			if("Down")
				return target_down
	else
		return target_down || target_up

/mob/proc/may_climb_ladders(var/ladder)
	if(!Adjacent(ladder))
		to_chat(src, "<span class='warning'>You need to be next to \the [ladder] to start climbing.</span>")
		return FALSE
	if(incapacitated())
		to_chat(src, "<span class='warning'>You are physically unable to climb \the [ladder].</span>")
		return FALSE

	var/carry_count = 0
	for(var/obj/item/grab/G in src)
		if(!G.ladder_carry())
			to_chat(src, "<span class='warning'>You can't carry [G.affecting] up \the [ladder].</span>")
			return FALSE
		else
			carry_count++
	if(carry_count > 1)
		to_chat(src, "<span class='warning'>You can't carry more than one person up \the [ladder].</span>")
		return FALSE

	return TRUE

/mob/observer/ghost/may_climb_ladders(var/ladder)
	return TRUE

/obj/structure/ladder/proc/climbLadder(mob/user, target_ladder, obj/item/I = null)
	var/turf/T = get_turf(target_ladder)
	for(var/atom/A in T)
		if(!A.CanPass(user, user.loc, 1.5, 0))
			to_chat(user, "<span class='notice'>\The [A] is blocking \the [src].</span>")

			//We cannot use the ladder, but we probably can remove the obstruction
			var/atom/movable/M = A
			if(istype(M) && M.movable_flags & MOVABLE_FLAG_Z_INTERACT)
				if(isnull(I))
					M.attack_hand(user)
				else
					M.attackby(I, user)

			return FALSE

	playsound(src, pick(climbsounds), 50)
	playsound(target_ladder, pick(climbsounds), 50)
	return user.Move(T)

/obj/structure/ladder/CanPass(obj/mover, turf/source, height, airflow)
	return airflow || !density

/obj/structure/ladder/on_update_icon()
	icon_state = "ladder[!!(allowed_directions & UP)][!!(allowed_directions & DOWN)]"


//
//	Stairs
//
/obj/structure/stairs
	name 		= "stairs"
	desc 		= "Stairs leading to another deck.  Not too useful if the gravity goes out."
	icon		= 'icons/obj/stairs.dmi'
	density 	= FALSE
	opacity 	= TRUE
	anchored 	= TRUE
	plane 		= ABOVE_TURF_PLANE
	layer 		= RUNE_LAYER
	matter 		= list(MATERIAL_STEEL = 5 SHEETS)
	var/tmp/was_already_saved = FALSE //In order to fix multi-tiles objects we gotta make sure only the base turf of the object saves it

// type paths to make mapping easier.
/obj/structure/stairs/north
	dir = NORTH
	bound_height = 64
	bound_width = 32
	bound_y = -32
	pixel_y = -32

/obj/structure/stairs/south
	dir = SOUTH
	bound_height = 64
	bound_width = 32

/obj/structure/stairs/east
	dir = EAST
	bound_width = 64
	bound_height = 32
	bound_x = -32
	pixel_x = -32

/obj/structure/stairs/west
	dir = WEST
	bound_width = 64
	bound_height = 32

/obj/structure/stairs/attackby(obj/item/O, mob/user)
	if(default_deconstruction_wrench(O, user, 20 SECONDS))
		return
	else
		return ..()

/obj/structure/stairs/should_save(datum/saver)
	. = ..()
	if(!.)
		return FALSE
	var/turf/T = saver
	if(istype(saver))
		return T == get_turf(src) //only save if we're on the "base" turf on which the stairs rest on
	return FALSE

/obj/structure/stairs/Initialize(var/mapload)
	for(var/turf/turf in locs)
		var/turf/simulated/open/above = GetAbove(turf)
		if(!above)
			warning("Stair created without level above: ([loc.x], [loc.y], [loc.z])")
			return INITIALIZE_HINT_QDEL
		//Don't do that, it can be exploited to get into places
		// if(!istype(above))
		// 	above.ChangeTurf(/turf/simulated/open)
	. = ..()

/obj/structure/stairs/CheckExit(atom/movable/mover as mob|obj, turf/target as turf)
	if(get_dir(loc, target) == dir && upperStep(mover.loc))
		return FALSE
	return ..()

/obj/structure/stairs/Bumped(atom/movable/A)
	var/turf/target = get_step(GetAbove(A), dir)
	var/turf/source = A.loc
	var/turf/above = GetAbove(A)
	if(above.CanZPass(source, UP) && target.Enter(A, src))
		A.forceMove(target)
		if(isliving(A))
			var/mob/living/L = A
			if(L.pulling)
				L.pulling.forceMove(target)
		if(ishuman(A))
			var/mob/living/carbon/human/H = A
			if(H.has_footsteps())
				playsound(source, 'sound/effects/stairs_step.ogg', 50)
				playsound(target, 'sound/effects/stairs_step.ogg', 50)
	else
		to_chat(A, "<span class='warning'>Something blocks the path.</span>")

/obj/structure/stairs/proc/upperStep(var/turf/T)
	return (T == loc)

/obj/structure/stairs/CanPass(obj/mover, turf/source, height, airflow)
	return airflow || !density
