/obj/structure/stasis_cage
	name = "stasis cage"
	desc = "A high-tech animal cage, designed to keep contained fauna docile and safe."
	icon = 'icons/obj/structures/stasiscage.dmi'
	icon_state = "stasis_cage"
	density = 1
	layer = ABOVE_OBJ_LAYER
	mass = 30
	max_health = 150
	armor = list(
		DAM_BLUNT  	= 95,
		DAM_PIERCE 	= 90,
		DAM_CUT 	= MaxArmorValue,
		DAM_BULLET 	= 95,
		DAM_ENERGY 	= 90,
		DAM_BURN 	= 80,
		DAM_BOMB 	= 50,
		DAM_EMP 	= MaxArmorValue,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)
	damthreshold_brute 	= 5
	damthreshold_burn	= 5
	var/mob/living/simple_animal/contained

/obj/structure/stasis_cage/New()
	. = ..()
	ADD_SAVED_VAR(contained)
	ADD_SKIP_EMPTY(contained)

/obj/structure/stasis_cage/Initialize()
	. = ..()

	var/mob/living/simple_animal/A = locate() in loc
	if(A)
		contain(A)

/obj/structure/stasis_cage/attack_hand(var/mob/user)
	release()

/obj/structure/stasis_cage/attack_robot(var/mob/user)
	if(Adjacent(user))
		release()

/obj/structure/stasis_cage/on_update_icon()
	if(contained)
		icon_state = "[initial(icon_state)]_on"
	else
		icon_state = initial(icon_state)

/obj/structure/stasis_cage/examine(mob/user)
	. = ..()
	if(. && contained)
		to_chat(user, "\The [contained] is kept inside.")

/obj/structure/stasis_cage/proc/contain(var/mob/living/simple_animal/animal)
	if(contained || !istype(animal))
		return

	contained = animal
	animal.forceMove(src)
	animal.in_stasis = 1
	update_icon()

/obj/structure/stasis_cage/proc/release()
	if(!contained)
		return

	contained.dropInto(src)
	contained.in_stasis = 0
	contained = null
	update_icon()

/obj/structure/stasis_cage/Destroy()
	release()
	return ..()

/obj/structure/stasis_cage/attackby(obj/item/O, mob/user)
	if(default_deconstruction_wrench(O, user) && src)
		dismantle()
		return 1
	return ..()

/mob/living/simple_animal/MouseDrop(var/obj/structure/stasis_cage/over_object)
	if(istype(over_object) && Adjacent(over_object) && CanMouseDrop(over_object, usr))

		if(!src.buckled || !istype(src.buckled, /obj/effect/energy_net))
			to_chat(usr, "It's going to be difficult to convince \the [src] to move into \the [over_object] without capturing it in a net.")
			return

		usr.visible_message("[usr] begins stuffing \the [src] into \the [over_object].", "You begin stuffing \the [src] into \the [over_object].")
		Bumped(usr)
		if(do_after(usr, 20, over_object))
			usr.visible_message("[usr] has stuffed \the [src] into \the [over_object].", "You have stuffed \the [src] into \the [over_object].")
			over_object.contain(src)
	else
		return ..()
