//////////////////////////////
//Contents: Ladders, Stairs.//
//////////////////////////////

/obj/structure/ladder
	name = "ladder"
	desc = "A ladder. You can climb it up and down."
	icon_state = "ladder01"
	icon = 'icons/obj/structures.dmi'
	density = 0
	opacity = 0
	anchored = 1
	var/dnr = 0
	var/allowed_directions = DOWN
	var/obj/structure/ladder/target_up
	var/obj/structure/ladder/target_down

	var/const/climb_time = 2 SECONDS
	var/static/list/climbsounds = list('sound/effects/ladder.ogg','sound/effects/ladder2.ogg','sound/effects/ladder3.ogg','sound/effects/ladder4.ogg')

/obj/structure/ladder/Initialize()
	. = ..()
	// the upper will connect to the lower
	if(allowed_directions & DOWN) //we only want to do the top one, as it will initialize the ones before it.
		for(var/obj/structure/ladder/L in GetBelow(src))
			if(L.allowed_directions & UP)
				target_down = L
				L.target_up = src
				return
	update_icon()

/obj/structure/ladder/Destroy()
	if(target_down)
		target_down.target_up = null
		target_down = null
	if(target_up)
		target_up.target_down = null
		target_up = null
	return ..()

/obj/structure/ladder/attackby(obj/item/C as obj, mob/user as mob)
	climb(user)

/obj/structure/ladder/attack_hand(var/mob/M)
	climb(M)

/obj/structure/ladder/attack_ai(var/mob/M)
	var/mob/living/silicon/ai/ai = M
	if(!istype(ai))
		return
	var/mob/observer/eye/AIeye = ai.eyeobj
	if(istype(AIeye))
		instant_climb(AIeye)

/obj/structure/ladder/attack_robot(var/mob/M)
	climb(M)

/obj/structure/ladder/proc/instant_climb(var/mob/M)
	var/target_ladder = getTargetLadder(M)
	if(target_ladder)
		M.forceMove(get_turf(target_ladder))

/obj/structure/ladder/proc/climb(var/mob/M)
	if(!M.may_climb_ladders(src))
		return

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
		climbLadder(M, target_ladder)
		for (var/obj/item/grab/G in M)
			G.adjust_position(force = 1)

/obj/structure/ladder/attack_ghost(var/mob/M)
	instant_climb(M)

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

/obj/structure/ladder/proc/climbLadder(var/mob/M, var/target_ladder)
	var/turf/T = get_turf(target_ladder)
	for(var/atom/A in T)
		if(!A.CanPass(M, M.loc, 1.5, 0))
			to_chat(M, "<span class='notice'>\The [A] is blocking \the [src].</span>")
			return FALSE
	playsound(src, pick(climbsounds), 50)
	playsound(target_ladder, pick(climbsounds), 50)
	return M.Move(T)

/obj/structure/ladder/CanPass(obj/mover, turf/source, height, airflow)
	return airflow || !density

/obj/structure/ladder/update_icon()
	icon_state = "ladder[!!(allowed_directions & UP)][!!(allowed_directions & DOWN)]"

/obj/structure/ladder/up
	allowed_directions = UP
	icon_state = "ladder10"

/obj/structure/ladder/updown
	allowed_directions = UP|DOWN
	icon_state = "ladder11"

/obj/structure/stairs
	name = "Stairs"
	desc = "Stairs leading to another deck.  Not too useful if the gravity goes out."
	icon = 'icons/obj/stairs.dmi'
	density = 0
	opacity = 0
	anchored = 1
	plane = ABOVE_TURF_PLANE
	layer = RUNE_LAYER

	Initialize()
		for(var/turf/turf in locs)
			var/turf/simulated/open/above = GetAbove(turf)
			if(!above)
				warning("Stair created without level above: ([loc.x], [loc.y], [loc.z])")
				return INITIALIZE_HINT_QDEL
			if(!istype(above))
				above.ChangeTurf(/turf/simulated/open)
		. = ..()

	Uncross(atom/movable/A)
		if(A.dir == dir)
			// This is hackish but whatever.
			var/turf/target = get_step(GetAbove(A), dir)
			var/turf/source = A.loc
			var/turf/above = GetAbove(A)
			if(above.CanZPass(source, UP) && target.Enter(A, source))
				A.forceMove(target)
			else
				to_chat(A, "<span class='warning'>Something blocks the path.</span>")
			return 0
		return 1

	CanPass(obj/mover, turf/source, height, airflow)
		return airflow || !density

	// type paths to make mapping easier.
	north
		dir = NORTH
		bound_height = 64
		bound_y = -32
		pixel_y = -32

	south
		dir = SOUTH
		bound_height = 64

	east
		dir = EAST
		bound_width = 64
		bound_x = -32
		pixel_x = -32

	west
		dir = WEST
		bound_width = 64

/obj/item/weapon/plasteel_ladder
	name = "plasteel ladder"
	desc = "A plasteel ladder, which you can use to move up or down. Or alternatively, you can bash some faces in."
	icon_state = "ladder00"
	item_state = "ladder00"
	icon = 'icons/obj/structures.dmi'
	throw_range = 3
	force = 10
	w_class = ITEM_SIZE_LARGE
	slot_flags = SLOT_BACK

/obj/item/weapon/plasteel_ladder/proc/place_ladder(atom/A, mob/user)
	if(istype(A, /turf/simulated/open))         //Place into open space
		var/turf/below_loc = GetBelow(A)
		if(!below_loc || (istype(/turf/space, below_loc)))
			to_chat(user, "<span class='notice'>Why would you do that?! There is only infinite space there...</span>")
			return
		user.visible_message("<span class='warning'>[user] begins to lower \the [src] into \the [A].</span>",
			"<span class='warning'>You begin to lower \the [src] into \the [A].</span>")
		if(!handle_action(A, user))
			return
		// Create the lower ladder first. ladder/Initialize() will make the upper
		// ladder create the appropriate links. So the lower ladder must exist first.
		var/obj/structure/ladder/downer = new(below_loc)
		downer.allowed_directions = UP

		new /obj/structure/ladder(A)

		user.drop_item()
		qdel(src)

	else if (istype(A, /turf/simulated/floor))        //Place onto Floor
		var/turf/upper_loc = GetAbove(A)
		if(!upper_loc || !istype(upper_loc,/turf/simulated/open))
			to_chat(user, "<span class='notice'>There is something above. You can't deploy!</span>")
			return
		user.visible_message("<span class='warning'>[user] begins deploying \the [src] on \the [A].</span>",
			"<span class='warning'>You begin to deploy \the [src] on \the [A].</span>")
		if(!handle_action(A, user))
			return
		// Ditto here. Create the lower ladder first.
		var/obj/structure/ladder/downer = new(A)
		downer.allowed_directions = UP
		downer.icon_state = "ladder10"

		new /obj/structure/ladder(upper_loc)
		user.drop_item()
		qdel(src)

/obj/item/weapon/plasteel_ladder/afterattack(atom/A, mob/user,proximity)
	if(!proximity)
		return
	place_ladder(A,user)


/obj/item/weapon/plasteel_ladder/proc/handle_action(atom/A, mob/user)
	log_and_message_admins("is attemping to place a ladder.")
	if(!do_after(user, 120, src))
		to_chat(user, "Can't place ladder! You were interrupted!")
		return FALSE
	if(!A || QDELETED(src) || QDELETED(user))
		// Shit was deleted during delay, call is no longer valid.
		return FALSE
	return TRUE


/obj/structure/ladder/attackby(obj/item/I as obj, mob/user as mob)
	if(isMaintJack(I) && !dnr)
		log_and_message_admins("is attempting to remove a ladder.")
		if(do_after(user, 120))
			playsound(get_turf(src), 'sound/items/Crowbar.ogg', 100, 1)
			remove()

/obj/structure/ladder/proc/remove()
	if(usr.incapacitated() || !usr.IsAdvancedToolUser())
		to_chat(usr, "<span class='warning'>You can't do that right now!</span>")
		return

	var/mob/living/carbon/human/H = usr
	H.visible_message("<span class='notice'>[H] starts removing the [src].</span>",
		"<span class='notice'>You start removing the [src].</span>")

	if(!do_after(H, 60, src))
		to_chat(H, "<span class='warning'>You are interrupted!</span>")
		return

	if(QDELETED(src))
		return

	var/obj/item/weapon/plasteel_ladder/R = new(get_turf(H))
	transfer_fingerprints_to(R)

	H.visible_message("<span class='notice'>[H] removes the [src] into [R]!</span>",
		"<span class='notice'>You fold [src] up into [R]!</span>")

	if(target_down)
		QDEL_NULL(target_down)
		qdel(src)
	else
		QDEL_NULL(target_up)
		qdel(src)