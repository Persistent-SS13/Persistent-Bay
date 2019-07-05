SUBSYSTEM_DEF(research)
	name = "Research"
	priority = SS_PRIORITY_CHEMISTRY
	init_order = SS_INIT_CHEMISTRY
	var/datum/research/files
	var/list/business_modules = list()
	flags = SS_NO_FIRE
/datum/controller/subsystem/research/Initialize()
	files = new()
	for(var/module_type in subtypesof(/datum/business_module))
		business_modules |= new module_type()
	return ..()
