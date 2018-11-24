SUBSYSTEM_DEF(late)
	name = "Late Initialization"
	init_order = SS_INIT_LATE_INIT
	flags = SS_NO_FIRE

/datum/controller/subsystem/late/Initialize()
	populate_lathe_recipes()

	supply_controller.generate_initial()
	. = ..()