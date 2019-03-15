/obj/structure/alien
	name = "alien thing"
	desc = "There's something alien about this."
	icon = 'icons/mob/alien.dmi'
	layer = ABOVE_OBJ_LAYER
	max_health = 50
	sound_hit = 'sound/effects/attackblob.ogg'

/obj/structure/alien/destroyed()
	set_density(0)
	..()

/obj/structure/alien/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group) return 0
	if(istype(mover) && mover.checkpass(PASS_FLAG_GLASS))
		return !opacity
	return !density
