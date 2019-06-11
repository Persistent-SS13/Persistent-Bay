/obj/structure/hygiene/sink
	name = "sink"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "sink"
	desc = "A sink used for washing one's hands and face."
	anchored = TRUE
	mass = 12
	max_health = 110
	damthreshold_brute 	= 3
	matter = list(MATERIAL_PLASTIC = 5 SHEETS)
	var/frame_type = /obj/item/frame/plastic/sink/
	var/busy = 0 	//Something's being washed at the moment

/obj/structure/hygiene/sink/New(loc, dir, atom/frame)
	..(loc)
	
	if(dir)
		src.set_dir(dir)

	// if(istype(frame))
	// 	pixel_x = (dir & 3)? 0 : (dir == 4 ? -20 : 20)
	// 	pixel_y = (dir & 3)? (dir ==1 ? -32 : 32) : 0

/obj/structure/hygiene/sink/Initialize(mapload, d)
	. = ..()
	if(!reagents)
		create_reagents(30)
	queue_icon_update()

/obj/structure/hygiene/sink/kitchen/on_update_icon()
	. = ..()
	switch(dir)
		if(NORTH)
			src.pixel_x = 0
			src.pixel_y = -32
		if(SOUTH)
			src.pixel_x = 0
			src.pixel_y = 32
		if(EAST)
			src.pixel_x = -20
			src.pixel_y = 0
		if(WEST)
			src.pixel_x = 20
			src.pixel_y = 0

/obj/structure/hygiene/sink/MouseDrop_T(var/obj/item/thing, var/mob/user)
	..()
	if(!istype(thing) || !thing.is_open_container())
		return ..()
	if(!usr.Adjacent(src))
		return ..()
	if(!thing.reagents || thing.reagents.total_volume == 0)
		to_chat(usr, SPAN_WARNING("\The [thing] is empty."))
		return
	// Clear the vessel.
	visible_message(SPAN_NOTICE("\The [usr] tips the contents of \the [thing] into \the [src]."))
	thing.reagents.clear_reagents()
	thing.update_icon()

/obj/structure/hygiene/sink/attack_hand(mob/user as mob)
	if (ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.organs_by_name[BP_R_HAND]
		if (user.hand)
			temp = H.organs_by_name[BP_L_HAND]
		if(temp && !temp.is_usable())
			to_chat(user, SPAN_WARNING("You try to move your [temp.name], but cannot!"))
			return

	if(isrobot(user) || isAI(user))
		return

	if(!Adjacent(user))
		return

	if(busy)
		to_chat(user, SPAN_WARNING("Someone's already washing here."))
		return

	to_chat(usr, SPAN_NOTICE("You start washing your hands."))
	busy = 1
	if(do_after(usr, 4 SECONDS, src))
		user.clean_blood()
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.update_inv_gloves()
		visible_message(SPAN_NOTICE("[user] washes their hands using \the [src]."))
	else
		visible_message(SPAN_WARNING("[user] stops washing their hands.."))
	busy = 0

/obj/structure/hygiene/sink/attackby(obj/item/O as obj, mob/living/user as mob)
	if(busy)
		to_chat(user, SPAN_WARNING("Someone's already washing here."))
		return 0
	var/obj/item/weapon/reagent_containers/RG = O
	if (istype(RG) && RG.is_open_container())
		RG.reagents.add_reagent(/datum/reagent/water, min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
		user.visible_message(SPAN_NOTICE("[user] fills \the [RG] using \the [src]."), SPAN_NOTICE("You fill \the [RG] using \the [src]."))
		return 1
	else if (istype(O, /obj/item/weapon/melee/baton))
		var/obj/item/weapon/melee/baton/B = O
		if(B.bcell)
			if(B.bcell.charge > 0 && B.status == 1)
				flick("baton_active", src)
				user.Stun(10)
				user.stuttering = 10
				user.Weaken(10)
				if(isrobot(user))
					var/mob/living/silicon/robot/R = user
					R.cell.charge -= 20
				else
					B.deductcharge(B.hitcost)
				user.visible_message( \
					SPAN_DANGER("[user] was stunned by \his wet [O]!"), \
					"<span class='userdanger'>[user] was stunned by \his wet [O]!</span>")
				return 1
	else if(istype(O, /obj/item/weapon/mop))
		O.reagents.add_reagent(/datum/reagent/water, 5)
		to_chat(user, SPAN_NOTICE("You wet \the [O] in \the [src]."))
		playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		return 1
	else if(default_deconstruction_wrench(O,user) && src)
		to_chat(usr, SPAN_NOTICE("You finish dismantling \the [src]."))
		return 1
	else if(istype(O, /obj/item))
		to_chat(usr, SPAN_NOTICE("You start washing \the [O]."))
		busy = 1
		var/objname = O.name //For dissolving items
		if(do_after(usr, 4 SECONDS, src))
			if(!O)
				visible_message(SPAN_WARNING("\The [objname] dissolves!"))
			else if(user.get_active_hand() != O)
				visible_message(SPAN_WARNING("[user] stopped what they were doing.."))
			else
				O.clean_blood()
				user.visible_message( \
					SPAN_NOTICE("[user] washes \a [O] using \the [src]."), \
					SPAN_NOTICE("You wash \a [O] using \the [src]."))
		else
			visible_message(SPAN_WARNING("[user] stopped washing \the [O] midway.."))
		busy = 0
		return 1
	else
		return ..()

/obj/structure/hygiene/sink/dismantle()
	new frame_type(src.loc)
	qdel(src)

