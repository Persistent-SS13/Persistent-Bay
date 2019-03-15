/obj/machinery/disposal_switch
	name = "disposal divert switch"
	desc = "A switch that is meant to control a disposal divert pipe of a matching id."
	icon = 'icons/obj/recycling.dmi'
	icon_state = "switch-off"
	layer = ABOVE_OBJ_LAYER

	id_tag = null
	var/on = FALSE
	var/list/junctions = list()

/obj/machinery/disposal_switch/New(loc, newid)
	..(loc)
	if(!id_tag)
		id_tag = newid

/obj/machinery/disposal_switch/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/disposal_switch/LateInitialize()
	. = ..()
	for(var/obj/structure/disposalpipe/diversion_junction/D in world)
		if(D.id_tag && !D.linked && D.id_tag == src.id_tag)
			junctions += D
			D.linked = src

/obj/machinery/disposal_switch/Destroy()
	junctions.Cut()
	return ..()

/obj/machinery/disposal_switch/attackby(obj/item/I, mob/user, params)
	if(isCrowbar(I))
		dismantle()
	else
		return ..()

/obj/machinery/disposal_switch/dismantle()
	var/obj/item/disposal_switch_construct/C = new/obj/item/disposal_switch_construct(src.loc, id_tag)
	transfer_fingerprints_to(C)
	if(usr)
		usr.visible_message(SPAN_NOTICE("\The [usr] deattaches \the [src]"))
	qdel(src)
	
/obj/machinery/disposal_switch/attack_hand(mob/user)
	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return
	on = !on
	for(var/obj/structure/disposalpipe/diversion_junction/D in junctions)
		if(D.id_tag == src.id_tag)
			D.active = on
	if(on)
		icon_state = "switch-fwd"
	else
		icon_state = "switch-off"

//
// Switch Contruct
//
//Frame object the switch is built with
/obj/item/disposal_switch_construct
	name = "disposal switch assembly"
	desc = "A disposal control switch assembly."
	icon = 'icons/obj/recycling.dmi'
	icon_state = "switch-off"
	w_class = ITEM_SIZE_LARGE
	var/id_tag

/obj/item/disposal_switch_construct/New(var/turf/loc, var/id)
	..(loc)
	if(id) 
		id_tag = id
	else
		id_tag = "ds[sequential_id(/obj/item/disposal_switch_construct)]"

/obj/item/disposal_switch_construct/afterattack(atom/A, mob/user, proximity)
	if(!proximity || !istype(A, /turf/simulated/floor) || istype(A, /area/shuttle) || user.incapacitated() || !id_tag)
		return
	var/found = 0
	for(var/obj/structure/disposalpipe/diversion_junction/D in world)
		if(D.id_tag == src.id_tag)
			found = 1
			break
	if(!found)
		to_chat(user, SPAN_NOTICE("\icon[src]\The [src] is not linked to any junctions!"))
		return
	var/obj/machinery/disposal_switch/NC = new/obj/machinery/disposal_switch(A, id_tag)
	transfer_fingerprints_to(NC)
	qdel(src)