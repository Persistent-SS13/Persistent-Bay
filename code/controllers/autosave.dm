var/datum/controller/save_controller/save_controller


/datum/controller/save_controller/
	var/timerbuffer = 0 //buffer for time check
	var/anounce1 = 0
	var/anounce2 = 0
	var/anounce3 = 0
/datum/controller/save_controller/New()
	timerbuffer = config.autosave_initial
	START_PROCESSING(SSprocessing, src)

/datum/controller/save_controller/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	. = ..()


/datum/controller/save_controller/Process()
	if (time_till_autosave() <= 0)
		timerbuffer += config.autosave_interval
		anounce1 = 0
		anounce2 = 0
		anounce3 = 0
		save()

	if (!anounce1 && time_till_autosave() <= 5 MINUTE)
		anounce1 = 1
		to_world("<span class='notice'>Routine Neural Lace Diagnositcs in 5 Minutes.</span class>")

	if (!anounce2 && time_till_autosave() <= 1 MINUTE)
		anounce2 = 1
		to_world("<span class='notice'>Routine Neural Lace Diagnositcs in 1 Minute.</span class>")

	if (!anounce3 && time_till_autosave() <= 10 SECOND)
		anounce3 = 1
		to_world("<font size=4 color='green'>Routine Neural Lace Diagnositcs in 10 Seconds.</font>")
		//
/datum/controller/save_controller/proc/time_till_autosave()
	return timerbuffer - round_duration_in_ticks



/datum/controller/save_controller/proc/save()
	Save_World()
