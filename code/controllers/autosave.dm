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
	for(var/mob/mobbie in GLOB.all_cryo_mobs)
		if(!mobbie.stored_ckey) continue
		var/save_path = load_path(mobbie.stored_ckey, "")
		if(fexists("[save_path][mobbie.save_slot].sav"))
			fdel("[save_path][mobbie.save_slot].sav")
		var/savefile/f = new("[save_path][mobbie.save_slot].sav")
		f << mobbie
		mobbie.should_save = 0
	for(var/datum/mind/employee in ticker.minds)
		if(!employee.current || !employee.current.ckey) continue
		var/save_path = load_path(employee.current.ckey, "")
		if(fexists("[save_path][employee.current.save_slot].sav"))
			fdel("[save_path][employee.current.save_slot].sav")
		var/savefile/f = new("[save_path][employee.current.save_slot].sav")
		f << employee.current
		employee.current.should_save = 0
		to_chat(employee.current, "You character has been autosaved.")

