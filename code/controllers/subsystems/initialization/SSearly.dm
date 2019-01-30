SUBSYSTEM_DEF(early)
	name = "Early Initialization"
	init_order = SS_INIT_EARLY_INIT
	flags = SS_NO_FIRE

/datum/controller/subsystem/early/Initialize()

	employment_controller = new

	populate_robolimb_list()
	setupFlooring()
	setupgenetics()
//	PopulateExperiments()

	job_master = new /datum/controller/occupations()
	job_master.SetupOccupations(setup_titles=1)
	job_master.LoadJobs("config/jobs.txt")

	. = ..()
