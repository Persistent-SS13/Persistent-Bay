SUBSYSTEM_DEF(supply)
	name = "Supply"
	wait = 30 SECONDS
	flags = SS_NO_INIT

/datum/controller/subsystem/supply/fire(resumed = FALSE)
	supply_controller.process()