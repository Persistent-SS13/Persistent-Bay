SUBSYSTEM_DEF(autosave)
	name = "Autosave"
	wait = 1 MINUTES
	// runlevels = RUNLEVEL_GAME
	init_order = SS_INIT_AUTOSAVE

	var/time_next_save = 0
	var/saving = 0
	var/announced = 0
	var/save_interval = 3 HOURS

/datum/controller/subsystem/autosave/Initialize(start_timeofday)
	CalculateTimeNextSave()
	return ..()

/datum/controller/subsystem/autosave/Recover()
	. = ..()
	saving = 0
	announced = 0
	CalculateTimeNextSave()

/datum/controller/subsystem/autosave/stat_entry()
	..(saving ? "Currently Saving" : "Next autosave in [round(time_next_save/(1 MINUTE), 0.1)] minutes.")

/datum/controller/subsystem/autosave/fire()
	var/time_diff = time_next_save - world.time
	if(time_diff <= 0)
		Save()
	else if(time_diff <= (1 MINUTES))
		to_world("<font size=4 color='green'>Autosave in 1 Minute!</font>")
		announced = 2
	else if(time_diff <= (5 MINUTES))
		to_world("<font size=4 color='green'>Autosave in 5 Minutes!</font>")
		announced = 1
	else if(announced)
		announced = 0
	
/datum/controller/subsystem/autosave/proc/Save()
	if(saving)
		message_admins(SPAN_DANGER("Attempted to save while already saving!"))
	else
		saving = 1
		for(var/datum/controller/subsystem/S in Master.subsystems)
			S.disable()
		
		//Run save in the try/catch, since otherwise it'll defcon and make recovery really hard
		try
			Save_World()
		catch(var/exception/E)
			var/msg = "[name]: Save failed. Caught exception '[E]'"
			log_error(msg)
			message_staff(msg)
		
		for(var/datum/controller/subsystem/S in Master.subsystems)
			S.enable()
		saving = 0
	CalculateTimeNextSave()

/datum/controller/subsystem/autosave/proc/CalculateTimeNextSave()
	time_next_save = world.time + save_interval