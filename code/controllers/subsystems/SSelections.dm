SUBSYSTEM_DEF(elections)
	name = "Elections"
	wait = 5 MINUTES
	next_fire = 5 MINUTES	// To prevent firing upon start

/datum/controller/subsystem/elections/stat_entry()
	..("Next election check in [round((next_fire - world.time) / (1 MINUTE), 0.1)] minutes.")


/datum/controller/subsystem/elections/fire()
	var/datum/world_faction/democracy/nexus = get_faction("nexus")
	var/time = world.realtime
	var/weekday = time2text(time, "Day")
	var/daynumber = text2number(time2text(time, "DD"))
	var/hour = text2number(time2text(time, "hh"))
	if(nexus.current_election)
		if(hour > nexus.current_election.end_hour && weekday == nexus.current_election.end_day)
			nexus.end_election()	
	else	
		for(var/datum/election/election in nexus.waiting_elections)
			if(election.start_day == weekday && election.start_hour >= hour && election.cut_off > hour && (!election.typed || election.num_type == nexus.election_toggle))
				nexus.start_election(election)
				break
	
	
/datum/controller/subsystem/elections/proc/Save()
	if(saving)
		message_admins(SPAN_DANGER("Attempted to save while already saving!"))
	else
		saving = 1
		for(var/datum/controller/subsystem/S in Master.subsystems)
			S.disable()
		Save_World()
		for(var/datum/controller/subsystem/S in Master.subsystems)
			S.enable()
		saving = 0


/datum/controller/subsystem/autosave/proc/AnnounceSave()
	var/minutes = (next_fire - world.time) / (1 MINUTE)

	if(!announced && minutes <= 5)
		to_world("<font size=4 color='green'>Autosave in 5 Minutes!</font>")
		announced = 1
	if(announced == 1 && minutes <= 1)
		to_world("<font size=4 color='green'>Autosave in 1 Minute!</font>")
		announced = 2
	if(announced == 2 && minutes >= 6)
		announced = 0