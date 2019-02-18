/obj/machinery/door/airlock/maintenance_hatch
	name = "Maintenance Hatch"
	explosion_resistance = 20
	opacity = 1
	armor = list(
		DAM_BLUNT  	= 90,
		DAM_PIERCE 	= 80,
		DAM_CUT 	= MaxArmorValue,
		DAM_BULLET 	= 90,
		DAM_ENERGY 	= 80,
		DAM_BURN 	= 90,
		DAM_BOMB 	= 80,
		DAM_EMP 	= 50,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)
	req_one_access = list(core_access_engineering_programs) 

/obj/machinery/door/airlock/maintenance_hatch/bolted
	locked = TRUE
	icon_state = "door_locked"

/obj/machinery/door/airlock/hatch
	airlock_type = "hatch"
	name = "\improper Airtight Hatch"
	icon = 'icons/obj/doors/hatch/door.dmi'
	fill_file = 'icons/obj/doors/hatch/fill_steel.dmi'
	stripe_file = 'icons/obj/doors/hatch/stripe.dmi'
	stripe_fill_file = 'icons/obj/doors/hatch/fill_stripe.dmi'
	bolts_file = 'icons/obj/doors/hatch/lights_bolts.dmi'
	deny_file = 'icons/obj/doors/hatch/lights_deny.dmi'
	lights_file = 'icons/obj/doors/hatch/lights_green.dmi'
	panel_file = 'icons/obj/doors/hatch/panel.dmi'
	welded_file = 'icons/obj/doors/hatch/welded.dmi'
	emag_file = 'icons/obj/doors/hatch/emag.dmi'
	explosion_resistance = 20
	opacity = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_hatch
	paintable = AIRLOCK_STRIPABLE
	armor = list(
		DAM_BLUNT  	= 90,
		DAM_PIERCE 	= 90,
		DAM_CUT 	= MaxArmorValue,
		DAM_BULLET 	= 90,
		DAM_ENERGY 	= 80,
		DAM_BURN 	= MaxArmorValue,
		DAM_BOMB 	= 60,
		DAM_EMP 	= 60,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)

/obj/machinery/door/airlock/hatch/maintenance
	name = "Maintenance Hatch"
	stripe_color = COLOR_AMBER
	req_one_access = list(core_access_engineering_programs) 

/obj/machinery/door/airlock/hatch/maintenance/bolted
	locked = TRUE
