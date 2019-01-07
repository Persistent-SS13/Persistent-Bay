/*
CONTAINS:

Deployable items
Barricades
*/

//Barricades!
/obj/structure/barricade
	name = "barricade"
	desc = "This space is blocked off by a barricade."
	icon = 'icons/obj/structures.dmi'
	icon_state = "barricade"
	anchored = 1
	density = 1
	mass = 20
	max_health = 100
	atom_flags = ATOM_FLAG_CLIMBABLE
	armor  = list(
		DAM_BLUNT 	= 50,
		DAM_PIERCE 	= 50,
		DAM_CUT 	= 50,
		DAM_BULLET 	= 50,
		DAM_LASER 	= 50,
		DAM_ENERGY 	= 0,
		DAM_BURN 	= 50,
		DAM_BOMB 	= 50,
		DAM_EMP 	= MaxArmorValue,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN 	= MaxArmorValue,
		DAM_CLONE 	= MaxArmorValue)
	var/material/material

/obj/structure/barricade/New(var/newloc, var/material_name)
	..(newloc)
	if(!material_name)
		material_name = MATERIAL_WOOD
	material = SSmaterials.get_material_by_name("[material_name]")
	if(!material)
		qdel(src)
		return
	max_health = material.integrity
	mass = material.weight
	matter = list(material.name = 5 * SHEET_MATERIAL_AMOUNT)
	name = "[material.display_name] barricade"
	desc = "This space is blocked off by a barricade made of [material.display_name]."
	color = material.icon_colour

/obj/structure/barricade/get_material()
	return material

/obj/structure/barricade/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/stack))
		var/obj/item/stack/D = W
		if(D.get_material_name() != material.name)
			return //hitting things with the wrong type of stack usually doesn't produce messages, and probably doesn't need to.
		if (health < max_health)
			if (D.get_amount() < 1)
				to_chat(user, "<span class='warning'>You need one sheet of [material.display_name] to repair \the [src].</span>")
				return
			visible_message("<span class='notice'>[user] begins to repair \the [src].</span>")
			if(do_after(user,20,src) && health < max_health)
				if (D.use(1))
					health = max_health
					visible_message("<span class='notice'>[user] repairs \the [src].</span>")
				return
		return

	if((isScrewdriver(W)) && (istype(loc, /turf/simulated) || anchored))
		playsound(loc, 'sound/items/Screwdriver.ogg', 100, 1)
		anchored = !anchored
		user.visible_message("<span class='notice'>[user] [anchored ? "fastens" : "unfastens"] the [src].</span>", \
								 "<span class='notice'>You have [anchored ? "fastened the [src] to" : "unfastened the [src] from"] the floor.</span>")
		return

	return ..() //handle attacks

/obj/structure/barricade/destroyed(var/damtype)
	if(ISDAMTYPE(damtype, DAM_BOMB))
		visible_message(SPAN_DANGER("\The [src] is blown apart!"))
	else
		visible_message(SPAN_DANGER("\The [src] is smashed apart!"))
	dismantle()

/obj/structure/barricade/dismantle()
	refund_matter()
	qdel(src)

/obj/structure/barricade/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)//So bullets will fly over and stuff.
	if(air_group || (height==0))
		return 1
	if(istype(mover) && mover.checkpass(PASS_FLAG_TABLE))
		return 1
	else
		return 0

//Actual Deployable machinery stuff
/obj/machinery/deployable
	name = "deployable"
	desc = "Deployable."
	icon = 'icons/obj/objects.dmi'
	req_access = list(core_access_security_programs)//I'm changing this until these are properly tested./N

/obj/machinery/deployable/barrier
	name = "deployable barrier"
	desc = "A deployable barrier. Swipe your ID card to lock/unlock it."
	icon = 'icons/obj/objects.dmi'
	anchored = FALSE
	density = 1
	icon_state = "barrier0"
	max_health = 100
	var/locked = FALSE

/obj/machinery/deployable/barrier/New()
	..()
	src.icon_state = "barrier[src.locked]"

/obj/machinery/deployable/barrier/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/card/id/))
		if (src.allowed(user))
			if	(src.emagged < 2.0)
				src.locked = !src.locked
				src.anchored = !src.anchored
				src.icon_state = "barrier[src.locked]"
				if ((src.locked == 1.0) && (src.emagged < 2.0))
					to_chat(user, "Barrier lock toggled on.")
					return
				else if ((src.locked == 0.0) && (src.emagged < 2.0))
					to_chat(user, "Barrier lock toggled off.")
					return
			else
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(2, 1, src)
				s.start()
				visible_message(SPAN_WARNING("BZZzZZzZZzZT"))
				return
		return
	else if(isWrench(W))
		if (src.health < src.max_health)
			src.health = src.max_health
			src.emagged = 0
			src.req_access = list(core_access_security_programs)
			visible_message(SPAN_WARNING("[user] repairs \the [src]!"))
			return
		else if (src.emagged > 0)
			src.emagged = 0
			src.req_access = list(core_access_security_programs)
			visible_message(SPAN_WARNING("[user] repairs \the [src]!"))
			return
		return
	else
		return ..()

/obj/machinery/deployable/barrier/ex_act(severity)
	switch(severity)
		if(1.0)
			src.explode()
			return
		if(2.0)
			src.health -= 25
			if (src.health <= 0)
				src.explode()
			return

/obj/machinery/deployable/barrier/emp_act(severity)
	if(prob(50/severity))
		locked = !locked
		anchored = !anchored
		icon_state = "barrier[src.locked]"
	..()

/obj/machinery/deployable/barrier/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)//So bullets will fly over and stuff.
	if(air_group || (height==0))
		return 1
	if(istype(mover) && mover.checkpass(PASS_FLAG_TABLE))
		return 1
	else
		return 0

/obj/machinery/deployable/barrier/proc/explode()

	visible_message("<span class='danger'>[src] blows apart!</span>")
	var/turf/Tsec = get_turf(src)
	new /obj/item/stack/rods(Tsec)

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()

	explosion(src.loc,-1,-1,0)
	if(src)
		qdel(src)


/obj/machinery/deployable/barrier/emag_act(var/remaining_charges, var/mob/user)
	if (src.emagged == 0)
		src.emagged = 1
		src.req_access.Cut()
		src.req_one_access.Cut()
		to_chat(user, "You break the ID authentication lock on \the [src].")
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(2, 1, src)
		s.start()
		visible_message("<span class='warning'>BZZzZZzZZzZT</span>")
		return 1
	else if (src.emagged == 1)
		src.emagged = 2
		to_chat(user, "You short out the anchoring mechanism on \the [src].")
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(2, 1, src)
		s.start()
		visible_message("<span class='warning'>BZZzZZzZZzZT</span>")
		return 1
