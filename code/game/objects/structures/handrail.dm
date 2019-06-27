/obj/structure/handrai
	name = "handrail"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "handrail"
	desc = "A safety railing with buckles to secure yourself to when floor isn't stable enough."
	density = 0
	anchored = 1
	can_buckle = 1
	max_health = 80
	mass = 15
	matter = list(MATERIAL_STEEL = 5 SHEETS)

/obj/structure/handrai/buckle_mob(mob/living/M)
	. = ..()
	if(.)
		playsound(src, 'sound/effects/buckle.ogg', 20)

/obj/structure/handrai/dismantle()
	unbuckle_mob()
	refund_matter()
	qdel(src)

/obj/structure/handrai/attackby(obj/item/O, mob/user)
	if(default_deconstruction_wrench(O, user))
		dismantle()
		return 1
	. = ..()
	
