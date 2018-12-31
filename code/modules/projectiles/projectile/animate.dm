/obj/item/projectile/animate
	name = "bolt of animation"
	icon_state = "ice_1"
	force = 0
	damtype = DAM_ENERGY
	nodamage = 1

/obj/item/projectile/animate/Bump(var/atom/change)
	if((istype(change, /obj/item) || istype(change, /obj/structure)) && !is_type_in_list(change, protected_objects))
		var/obj/O = change
		new /mob/living/simple_animal/hostile/mimic/(O.loc, O, firer)
	..()
