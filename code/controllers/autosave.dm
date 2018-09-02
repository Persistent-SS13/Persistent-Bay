var/datum/controller/save_controller/save_controller


/datum/controller/save_controller/
	var/timerbuffer = 0 //buffer for time check

/datum/controller/save_controller/New()
	timerbuffer = config.autosave_initial
	START_PROCESSING(SSprocessing, src)

/datum/controller/save_controller/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	. = ..()


/datum/controller/save_controller/Process()
	if (time_till_autosave() <= 0)
		timerbuffer += config.autosave_interval
		save()


/datum/controller/save_controller/proc/time_till_autosave()
	return timerbuffer - round_duration_in_ticks

/datum/controller/save_controller/proc/save()
	Save_World()

