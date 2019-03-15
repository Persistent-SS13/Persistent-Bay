/obj/machinery/door/airlock/command
	door_color = COLOR_COMMAND_BLUE
	req_one_access = list(core_access_command_programs) 

/obj/machinery/door/airlock/security
	door_color = COLOR_NT_RED
	req_one_access = list(core_access_security_programs) 

/obj/machinery/door/airlock/security/research
	door_color = COLOR_WHITE
	stripe_color = COLOR_NT_RED
	req_one_access = list(core_access_science_programs)

/obj/machinery/door/airlock/engineering
	name = "Maintenance Hatch"
	door_color = COLOR_AMBER
	req_one_access = list(core_access_engineering_programs) 

/obj/machinery/door/airlock/medical
	door_color = COLOR_WHITE
	stripe_color = COLOR_DEEP_SKY_BLUE
	req_one_access = list(core_access_medical_programs)

/obj/machinery/door/airlock/virology
	door_color = COLOR_WHITE
	stripe_color = COLOR_GREEN
	req_one_access = list(core_access_medical_programs)

/obj/machinery/door/airlock/mining
	name = "Mining Airlock"
	door_color = COLOR_PALE_ORANGE
	stripe_color = COLOR_BEASTY_BROWN

/obj/machinery/door/airlock/atmos
	door_color = COLOR_AMBER
	stripe_color = COLOR_CYAN
	req_one_access = list(core_access_engineering_programs) 

/obj/machinery/door/airlock/research
	door_color = COLOR_WHITE
	stripe_color = COLOR_BOTTLE_GREEN
	req_one_access = list(core_access_science_programs)

/obj/machinery/door/airlock/science
	door_color = COLOR_WHITE
	stripe_color = COLOR_VIOLET
	req_one_access = list(core_access_science_programs)

/obj/machinery/door/airlock/sol
	door_color = COLOR_BLUE_GRAY
	req_one_access = list(core_access_command_programs) 

/obj/machinery/door/airlock/civilian
	stripe_color = COLOR_CIVIE_GREEN

/obj/machinery/door/airlock/freezer
	name = "Freezer Airlock"
	door_color = COLOR_WHITE

/obj/machinery/door/airlock/maintenance
	name = "Maintenance Access"
	stripe_color = COLOR_AMBER
	req_one_access = list(core_access_engineering_programs) 

/obj/machinery/door/airlock/centcom
	airlock_type = "centcomm"
	name = "\improper Airlock"
	icon = 'icons/obj/doors/centcomm/door.dmi'
	fill_file = 'icons/obj/doors/centcomm/fill_steel.dmi'
	paintable = AIRLOCK_PAINTABLE|AIRLOCK_STRIPABLE
