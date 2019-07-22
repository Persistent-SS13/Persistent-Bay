
/obj/structure/reagent_dispensers
	name = "dispenser"
	desc = "..."
	icon = 'icons/obj/objects.dmi'
	icon_state = "watertank"
	density = TRUE
	anchored = FALSE

	var/initial_capacity = 1000
	var/initial_reagent_types  // A list of reagents and their ratio relative the initial capacity. list(/datum/reagent/water = 0.5) would fill the dispenser halfway to capacity.
	var/amount_per_transfer_from_this = 10
	var/possible_transfer_amounts = "10;25;50;100;500"
	var/can_fill = FALSE //Whether the tank's cap is opened for pouring reagents in

/obj/structure/reagent_dispensers/New()
	..()
	ADD_SAVED_VAR(amount_per_transfer_from_this)

/obj/structure/reagent_dispensers/Initialize()
	. = ..()
	if (!possible_transfer_amounts)
		src.verbs -= /obj/structure/reagent_dispensers/verb/set_amount_per_transfer_from_this

/obj/structure/reagent_dispensers/SetupReagents()
	. = ..()
	create_reagents(initial_capacity)
	for(var/reagent_type in initial_reagent_types)
		var/reagent_ratio = initial_reagent_types[reagent_type]
		reagents.add_reagent(reagent_type, reagent_ratio * initial_capacity)

/obj/structure/reagent_dispensers/attackby(var/obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/reagent_containers))
		return //Don't hit the dispenser idiot!
	else 
		return ..()

/obj/structure/reagent_dispensers/attack_hand(mob/user)
	if(user.a_intent == I_HELP)
		can_fill = !can_fill

		if(can_fill)
			visible_message(SPAN_NOTICE("[user] pop off the cap."))
			atom_flags |= ATOM_FLAG_OPEN_CONTAINER
		else
			visible_message(SPAN_NOTICE("[user] tighten the cap."))
			atom_flags &= ~ATOM_FLAG_OPEN_CONTAINER
			
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
	if(can_fill)
		to_chat(user, SPAN_WARNING("Its cap is off."))

/obj/structure/reagent_dispensers/verb/set_amount_per_transfer_from_this()
	set name = "Set transfer amount"
	set category = "Object"
	set src in view(1)
	if(!CanPhysicallyInteract(usr))
		to_chat(usr, "<span class='notice'>You're in no condition to do that!'</span>")
		return
	var/N = input("Amount per transfer from this:","[src]") as null|anything in cached_number_list_decode(possible_transfer_amounts)
	if(!CanPhysicallyInteract(usr))  // because input takes time and the situation can change
		to_chat(usr, "<span class='notice'>You're in no condition to do that!'</span>")
		return
	if (N)
		amount_per_transfer_from_this = N

/obj/structure/reagent_dispensers/destroyed(damagetype, user)
	if(reagents)
		reagents.splash(loc, reagents.total_volume, 1, 0, 80, 100)
	. = ..()

/obj/structure/reagent_dispensers/AltClick(var/mob/user)
	if(possible_transfer_amounts)
		set_amount_per_transfer_from_this()
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
	

//
//	Wall-mounted reagent dispensers base class
//
/obj/structure/reagent_dispensers/wall
	density = FALSE
	anchored = TRUE

/obj/structure/reagent_dispensers/wall/Initialize()
	. = ..()
	update_icon()

/obj/structure/reagent_dispensers/wall/on_update_icon()
	. = ..()
	switch(dir)
		if(NORTH)
			src.pixel_x = 0
			src.pixel_y = 30
		if(SOUTH)
			src.pixel_x = 0
			src.pixel_y = -30
		if(EAST)
			src.pixel_x = 30
			src.pixel_y = 0
		if(WEST)
			src.pixel_x = -30
			src.pixel_y = 0

/obj/structure/reagent_dispensers/wall/attackby(var/obj/item/weapon/W as obj, mob/user as mob)
	if(default_deconstruction_wrench(user,W))
		return TRUE
	else
		return ..()
