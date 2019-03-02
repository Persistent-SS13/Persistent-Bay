SUBSYSTEM_DEF(research)
	name = "Research"
	priority = SS_PRIORITY_CHEMISTRY
	init_order = SS_INIT_CHEMISTRY
	var/datum/research/files
	flags = SS_NO_FIRE
/datum/controller/subsystem/research/Initialize()
	files = new()
	..()
