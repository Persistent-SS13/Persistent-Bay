/obj/structure/closet/secure_closet
	name = "secure locker"
	desc = "It's a card-locked storage unit."

	setup = CLOSET_HAS_LOCK
	locked = TRUE

	icon_state = "secure1"
	icon_closed = "secure"
	icon_locked = "secure1"
	icon_broken = "securebroken"
	icon_off = "secureoff"

	icon_opened = "secureopen"

	wall_mounted = 0 //never solid (You can always pass over it)
	health = 200
