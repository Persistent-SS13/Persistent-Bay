
/obj/structure/reagent_dispensers
	name = "Dispenser"
	desc = "..."
	icon = 'icons/obj/objects.dmi'
	icon_state = "watertank"
	density = 1
	anchored = 0

	var/initial_capacity = 1000
	var/initial_reagent_types  // A list of reagents and their ratio relative the initial capacity. list(/datum/reagent/water = 0.5) would fill the dispenser halfway to capacity.
	var/amount_per_transfer_from_this = 10
	var/possible_transfer_amounts = "10;25;50;100;500"
	var/tankcap = FALSE //Whether the tank's cap is opened for pouring reagents in

/obj/structure/reagent_dispensers/New()
	if (!possible_transfer_amounts)
		src.verbs -= /obj/structure/reagent_dispensers/verb/set_APTFT
	..()

/obj/structure/reagent_dispensers/Initialize()
	. = ..()
	if(!map_storage_loaded)
		create_reagents(initial_capacity)
		for(var/reagent_type in initial_reagent_types)
			var/reagent_ratio = initial_reagent_types[reagent_type]
			reagents.add_reagent(reagent_type, reagent_ratio * initial_capacity)

/obj/structure/reagent_dispensers/attackby(var/obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/reagent_containers))
		return 1 //Don't hit the dispenser idiot!
	else 
		return ..()

/obj/structure/reagent_dispensers/attack_hand(mob/user)
	if(user.a_intent == I_HELP)
		if(tankcap)
			visible_message(SPAN_NOTICE("[user] tighten the cap."))
			tankcap = FALSE
		else 
			visible_message(SPAN_NOTICE("[user] pop off the cap."))
			tankcap = TRUE
		src.add_fingerprint(user)
		return 1
	else
		return ..()

/obj/structure/reagent_dispensers/examine(mob/user)
	if(!..(user, 2))
		return
	to_chat(user, SPAN_NOTICE("It contains:"))
	if(reagents && reagents.reagent_list.len)
		for(var/datum/reagent/R in reagents.reagent_list)
			to_chat(user, SPAN_NOTICE("[R.volume] units of [R.name]"))
	else
		to_chat(user, SPAN_NOTICE("Nothing."))
	if(tankcap)
		to_chat(user, SPAN_WARNING("Its cap is open to pour in reagents."))

/obj/structure/reagent_dispensers/verb/set_APTFT() //set amount_per_transfer_from_this
	set name = "Set transfer amount"
	set category = "Object"
	set src in view(1)
	var/N = input("Amount per transfer from this:","[src]") as null|anything in cached_number_list_decode(possible_transfer_amounts)
	if (N)
		amount_per_transfer_from_this = N

/obj/structure/reagent_dispensers/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				new /obj/effect/effect/water(src.loc)
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				new /obj/effect/effect/water(src.loc)
				qdel(src)
				return
		else
	return

/obj/structure/reagent_dispensers/AltClick(var/mob/user)
	if(possible_transfer_amounts)
		if(CanPhysicallyInteract(user))
			set_APTFT()
	else
		return ..()

/obj/structure/reagent_dispensers/default_deconstruction_screwdriver(var/obj/item/weapon/tool/screwdriver/S, var/mob/living/user, var/deconstruct_time = null)
	if(!istype(S))
		return 0
	if(reagents.total_volume > 1)
		to_chat(user, SPAN_WARNING("Empty it first!"))
	else
		return ..()

/obj/structure/reagent_dispensers/default_deconstruction_wrench(var/obj/item/weapon/tool/wrench/W, var/mob/living/user, var/deconstruct_time = null)
	if(!istype(W))
		return 0
	if(reagents.total_volume != 0)
		to_chat(user, SPAN_WARNING("Empty it first!"))
	else
		return ..()