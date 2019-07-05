
/obj/machinery/door/airlock/external
	airlock_type = "External"
	name = "External Airlock"
	icon = 'icons/obj/doors/external/door.dmi'
	fill_file = 'icons/obj/doors/external/fill_steel.dmi'
	color_file = 'icons/obj/doors/external/color.dmi'
	color_fill_file = 'icons/obj/doors/external/fill_color.dmi'
	glass_file = 'icons/obj/doors/external/fill_glass.dmi'
	bolts_file = 'icons/obj/doors/external/lights_bolts.dmi'
	deny_file = 'icons/obj/doors/external/lights_deny.dmi'
	lights_file = 'icons/obj/doors/external/lights_green.dmi'
	emag_file = 'icons/obj/doors/external/emag.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_ext
	door_color = COLOR_NT_RED
	paintable = AIRLOCK_PAINTABLE
	armor = list(
		DAM_BLUNT  	= 90,
		DAM_PIERCE 	= 80,
		DAM_CUT 	= MaxArmorValue,
		DAM_BULLET 	= 90,
		DAM_ENERGY 	= 90,
		DAM_BURN 	= 90,
		DAM_BOMB 	= 80,
		DAM_EMP 	= 70,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)

/obj/machinery/door/airlock/external/bolted
	locked = TRUE

/obj/machinery/door/airlock/external/bolted/cycling
	frequency = DOOR_FREQ

/obj/machinery/door/airlock/external/bolted_open
	icon_state = "open"
	density = FALSE
	locked = TRUE
	opacity = 0

/obj/machinery/door/airlock/external/glass
	max_health = 300
	explosion_resistance = 5
	opacity = 0
	glass = TRUE
	armor = list(
		DAM_BLUNT  	= 90,
		DAM_PIERCE 	= 80,
		DAM_CUT 	= MaxArmorValue,
		DAM_BULLET 	= 90,
		DAM_ENERGY 	= 90,
		DAM_BURN 	= 90,
		DAM_BOMB 	= 80,
		DAM_EMP 	= 70,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)

/obj/machinery/door/airlock/external/glass/bolted
	locked = TRUE

/obj/machinery/door/airlock/external/glass/bolted/cycling
	frequency = DOOR_FREQ

/obj/machinery/door/airlock/external/glass/bolted_open
	icon_state = "open"
	density = FALSE
	locked = TRUE
	opacity = 0
