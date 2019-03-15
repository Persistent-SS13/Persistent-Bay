/obj/structure/handrail
	name = "handrail"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "handrail"
	desc = "A safety railing with buckles to secure yourself to when floor isn't stable enough."
	density = 0
	anchored = 1
	can_buckle = 1
	max_health = 80
	mass = 15
	armor = list(
		DAM_BLUNT  	= 20,
		DAM_PIERCE 	= 20,
		DAM_CUT 	= 40,
		DAM_BULLET 	= 10,
		DAM_ENERGY 	= 10,
		DAM_BURN 	= 10,
		DAM_BOMB 	= 5,
		DAM_EMP 	= MaxArmorValue,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)

