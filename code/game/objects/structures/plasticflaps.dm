/obj/structure/plasticflaps //HOW DO YOU CALL THOSE THINGS ANYWAY
	name = "\improper plastic flaps"
	desc = "Completely impassable - or are they?"
	icon = 'icons/obj/stationobjs.dmi' //Change this.
	icon_state = "plasticflaps"
	density = FALSE
	anchored = TRUE
	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER
	explosion_resistance = 5
	obj_flags = OBJ_FLAG_ANCHORABLE
	atmos_canpass = CANPASS_NEVER
	mass = 5
	max_health = 60
	var/list/mobs_can_pass = list(
		/mob/living/bot,
		/mob/living/carbon/slime,
		/mob/living/simple_animal/mouse,
		/mob/living/silicon/robot/drone
		)

/obj/structure/plasticflaps/CanPass(atom/A, turf/T)
	if(istype(A) && A.checkpass(PASS_FLAG_GLASS))
		return prob(60)

	var/obj/structure/bed/B = A
	if (istype(A, /obj/structure/bed) && B.buckled_mob)//if it's a bed/chair and someone is buckled, it will not pass
		return 0

	if(istype(A, /obj/vehicle))	//no vehicles
		return 0

	var/mob/living/M = A
	if(istype(M))
		if(M.lying)
			return ..()
		for(var/mob_type in mobs_can_pass)
			if(istype(A, mob_type))
				return ..()
		return issmall(M)

	return ..()

/obj/structure/plasticflaps/attackby(obj/item/weapon/tool/W, mob/user)
	if((isScrewdriver(W)) && (istype(loc, /turf/simulated) || anchored))
		if(W.use_tool(src, 4 SECONDS))
			anchored = !anchored
			user.visible_message("<span class='notice'>[user] [anchored ? "fastens" : "unfastens"] the [src].</span>", \
								 "<span class='notice'>You have [anchored ? "fastened the [src] to" : "unfastened the [src] from"] the floor.</span>")
			return
	if(isWelder(W) && W.use_tool(src, 3 SECONDS))
		dismantle()
		user.visible_message("<span class='warning'>\The [user] deconstructs \the [src].</span>", "<span class='warning'>You deconstruct \the [src].</span>")
		return

/obj/structure/plasticflaps/Destroy() //lazy hack to set the turf to allow air to pass if it's a simulated floor
	clear_airtight()
	. = ..()

/obj/structure/plasticflaps/proc/become_airtight()
	var/turf/T = get_turf(loc)
	if(T)
		T.blocks_air = 1

/obj/structure/plasticflaps/proc/clear_airtight()
	var/turf/T = get_turf(loc)
	if(T)
		if(istype(T, /turf/simulated/floor))
			T.blocks_air = 0

