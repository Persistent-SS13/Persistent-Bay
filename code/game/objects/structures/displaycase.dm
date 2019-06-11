/obj/structure/displaycase
	name = "display case"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "glassbox"
	desc = "A display case for prized possessions. It taunts you to kick it."
	density = 1
	anchored = 1
	unacidable = 1//Dissolving the case would also delete the gun.
	alpha = 150
	max_health = 200
	min_health = -20
	broken_threshold = 0
	sound_destroyed = "shatter"
	sound_hit = 'sound/effects/Glasshit.ogg'
	matter = list(MATERIAL_GLASS = 5 SHEETS)
	obj_flags = OBJ_FLAG_ANCHORABLE | OBJ_FLAG_DAMAGEABLE

/obj/structure/displaycase/Initialize()
	. = ..()
	var/turf/T = get_turf(src)
	for(var/atom/movable/AM in T)
		if(AM.simulated && !AM.anchored)
			AM.forceMove(src)
	update_icon()

/obj/structure/displaycase/examine(var/user)
	..()
	if(contents.len)
		to_chat(user, "Inside you see [english_list(contents)].")

/obj/structure/displaycase/on_update_icon()
	if(isbroken())
		icon_state = "glassboxb"
	else
		icon_state = "glassbox"
	underlays.Cut()
	for(var/atom/movable/AM in contents)
		underlays += AM.appearance

/obj/structure/displaycase/attackby(obj/item/weapon/W as obj, mob/user as mob)
	//TODO: Deconstruction stuff
	return ..()

/obj/structure/displaycase/attack_hand(mob/user as mob)
	add_fingerprint(user)
	if(!isbroken())
		to_chat(usr, text("<span class='warning'>You kick the display case.</span>"))
		visible_message("<span class='warning'>[usr] kicks the display case.</span>")
		take_damage(2)
	else
		return ..()