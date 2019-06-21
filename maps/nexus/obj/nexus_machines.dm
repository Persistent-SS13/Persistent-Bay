/obj/machinery/alarm/nexus
	req_access_faction = NEXUS_FACTION_CITIZEN
	faction_uid = NEXUS_FACTION_CITIZEN

/obj/machinery/alarm/nexus/cold
	target_temperature = T0C+4

/obj/machinery/alarm/nexus/nobreach
	breach_detection = FALSE

/obj/machinery/alarm/nexus/monitor
	report_danger_level = FALSE
	breach_detection = FALSE

/obj/machinery/alarm/nexus/server/New()
	..()
	req_access = list(core_access_science_programs, core_access_engineering_programs)
	TLV["temperature"] =	list(T0C-26, T0C, T0C+30, T0C+40) // K
	target_temperature = T0C+10
