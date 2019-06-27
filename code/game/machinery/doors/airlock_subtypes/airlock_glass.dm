/obj/machinery/door/airlock/glass_command
	name = "Maintenance Hatch"
	sound_hit = 'sound/effects/Glasshit.ogg'
	max_health = 300
	explosion_resistance = 5
	opacity = FALSE
	glass = TRUE
	door_color = COLOR_COMMAND_BLUE
	stripe_color = COLOR_SKY_BLUE
	armor = list(
		DAM_BLUNT  	= 80,
		DAM_PIERCE 	= 80,
		DAM_CUT 	= MaxArmorValue,
		DAM_BULLET 	= 80,
		DAM_ENERGY 	= 80,
		DAM_BURN 	= 90,
		DAM_BOMB 	= 40,
		DAM_EMP 	= 50,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)
	req_one_access = list(core_access_command_programs)

/obj/machinery/door/airlock/glass_external
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
	sound_hit = 'sound/effects/Glasshit.ogg'
	max_health = 300
	explosion_resistance = 5
	opacity = 0
	glass = 1
	armor = list(
		DAM_BLUNT  	= 80,
		DAM_PIERCE 	= 80,
		DAM_CUT 	= MaxArmorValue,
		DAM_BULLET 	= 80,
		DAM_ENERGY 	= 80,
		DAM_BURN 	= 90,
		DAM_BOMB 	= 40,
		DAM_EMP 	= 50,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)

/obj/machinery/door/airlock/glass_external/bolted
	icon_state = "door_locked"
	locked = TRUE

/obj/machinery/door/airlock/glass_external/bolted/cycling
	frequency = DOOR_FREQ

/obj/machinery/door/airlock/glass_external/bolted_open
	icon_state = "door_open"
	density = FALSE
	locked = TRUE
	opacity = 0

/obj/machinery/door/airlock/glass_engineering
	name = "Maintenance Hatch"
	sound_hit = 'sound/effects/Glasshit.ogg'
	max_health = 300
	explosion_resistance = 5
	opacity = 0
	glass = TRUE
	door_color = COLOR_AMBER
	stripe_color = COLOR_RED
	armor = list(
		DAM_BLUNT  	= 80,
		DAM_PIERCE 	= 80,
		DAM_CUT 	= MaxArmorValue,
		DAM_BULLET 	= 80,
		DAM_ENERGY 	= 80,
		DAM_BURN 	= 90,
		DAM_BOMB 	= 40,
		DAM_EMP 	= 50,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)
	req_one_access = list(core_access_engineering_programs)

/obj/machinery/door/airlock/glass_security
	name = "Maintenance Hatch"
	sound_hit = 'sound/effects/Glasshit.ogg'
	max_health = 300
	explosion_resistance = 5
	opacity = 0
	glass = TRUE
	door_color = COLOR_NT_RED
	stripe_color = COLOR_ORANGE
	armor = list(
		DAM_BLUNT  	= 80,
		DAM_PIERCE 	= 80,
		DAM_CUT 	= MaxArmorValue,
		DAM_BULLET 	= 80,
		DAM_ENERGY 	= 80,
		DAM_BURN 	= 90,
		DAM_BOMB 	= 40,
		DAM_EMP 	= 50,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)
	req_one_access = list(core_access_security_programs)

/obj/machinery/door/airlock/glass_medical
	name = "Maintenance Hatch"
	sound_hit = 'sound/effects/Glasshit.ogg'
	max_health = 300
	explosion_resistance = 5
	opacity = 0
	glass = TRUE
	door_color = COLOR_WHITE
	stripe_color = COLOR_DEEP_SKY_BLUE
	armor = list(
		DAM_BLUNT  	= 80,
		DAM_PIERCE 	= 80,
		DAM_CUT 	= MaxArmorValue,
		DAM_BULLET 	= 80,
		DAM_ENERGY 	= 80,
		DAM_BURN 	= 90,
		DAM_BOMB 	= 40,
		DAM_EMP 	= 50,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)
	req_one_access = list(core_access_medical_programs)

/obj/machinery/door/airlock/glass_virology
	name = "Maintenance Hatch"
	sound_hit = 'sound/effects/Glasshit.ogg'
	max_health = 300
	explosion_resistance = 5
	opacity = 0
	glass = TRUE
	door_color = COLOR_WHITE
	stripe_color = COLOR_GREEN
	armor = list(
		DAM_BLUNT  	= 80,
		DAM_PIERCE 	= 80,
		DAM_CUT 	= MaxArmorValue,
		DAM_BULLET 	= 80,
		DAM_ENERGY 	= 80,
		DAM_BURN 	= 90,
		DAM_BOMB 	= 40,
		DAM_EMP 	= 50,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)
	req_one_access = list(core_access_medical_programs)

/obj/machinery/door/airlock/glass_sol
	name = "Maintenance Hatch"
	sound_hit = 'sound/effects/Glasshit.ogg'
	max_health = 300
	explosion_resistance = 5
	opacity = 0
	glass = TRUE
	door_color = COLOR_BLUE_GRAY
	stripe_color = COLOR_AMBER
	armor = list(
		DAM_BLUNT  	= 80,
		DAM_PIERCE 	= 80,
		DAM_CUT 	= MaxArmorValue,
		DAM_BULLET 	= 80,
		DAM_ENERGY 	= 80,
		DAM_BURN 	= 90,
		DAM_BOMB 	= 40,
		DAM_EMP 	= 50,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)
	req_one_access = list(core_access_command_programs)


/obj/machinery/door/airlock/glass
	name = "Glass Airlock"
	icon_state = "closed"
	sound_hit = 'sound/effects/Glasshit.ogg'
	max_health = 300
	explosion_resistance = 5
	opacity = 0
	glass = TRUE
	armor = list(
		DAM_BLUNT  	= 80,
		DAM_PIERCE 	= 80,
		DAM_CUT 	= MaxArmorValue,
		DAM_BULLET 	= 80,
		DAM_ENERGY 	= 80,
		DAM_BURN 	= 90,
		DAM_BOMB 	= 40,
		DAM_EMP 	= 50,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)

/obj/machinery/door/airlock/glass/command
	door_color = COLOR_COMMAND_BLUE
	stripe_color = COLOR_SKY_BLUE
	req_one_access = list(core_access_command_programs)

/obj/machinery/door/airlock/glass/security
	door_color = COLOR_NT_RED
	stripe_color = COLOR_ORANGE
	req_one_access = list(core_access_security_programs)

/obj/machinery/door/airlock/glass/engineering
	door_color = COLOR_AMBER
	stripe_color = COLOR_RED
	req_one_access = list(core_access_engineering_programs)

/obj/machinery/door/airlock/glass/medical
	door_color = COLOR_WHITE
	stripe_color = COLOR_DEEP_SKY_BLUE
	req_one_access = list(core_access_medical_programs)

/obj/machinery/door/airlock/glass/virology
	door_color = COLOR_WHITE
	stripe_color = COLOR_GREEN
	req_one_access = list(core_access_medical_programs)

/obj/machinery/door/airlock/glass/mining
	door_color = COLOR_PALE_ORANGE
	stripe_color = COLOR_BEASTY_BROWN

/obj/machinery/door/airlock/glass/atmos
	door_color = COLOR_AMBER
	stripe_color = COLOR_CYAN
	req_one_access = list(core_access_engineering_programs)

/obj/machinery/door/airlock/glass/research
	door_color = COLOR_WHITE
	stripe_color = COLOR_BOTTLE_GREEN
	req_one_access = list(core_access_science_programs)

/obj/machinery/door/airlock/glass/science
	door_color = COLOR_WHITE
	stripe_color = COLOR_VIOLET
	req_one_access = list(core_access_science_programs)

/obj/machinery/door/airlock/glass/sol
	door_color = COLOR_BLUE_GRAY
	stripe_color = COLOR_AMBER
	req_one_access = list(core_access_command_programs)

/obj/machinery/door/airlock/glass/freezer
	door_color = COLOR_WHITE

/obj/machinery/door/airlock/glass/maintenance
	name = "Maintenance Access"
	stripe_color = COLOR_AMBER
	req_one_access = list(core_access_engineering_programs)

/obj/machinery/door/airlock/glass/civilian
	stripe_color = COLOR_CIVIE_GREEN
