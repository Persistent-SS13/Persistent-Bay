SUBSYSTEM_DEF(elections)
	name = "Elections"
	wait = 5 MINUTES
	next_fire = 5 MINUTES	// To prevent firing upon start

/datum/controller/subsystem/elections/stat_entry()
	..("Next election check in [round((next_fire - world.time) / (1 MINUTE), 0.1)] minutes.")


/datum/controller/subsystem/elections/fire()
	var/datum/world_faction/democratic/nexus = get_faction("nexus")
	var/time = world.realtime
	var/weekday = time2text(time, "Day")
	var/hour = text2num(time2text(time, "hh"))
	var/month = time2text(time, "Month")
	if(nexus.current_election)
		if(hour > nexus.current_election.end_hour && weekday == nexus.current_election.end_day)
			nexus.end_election()	
	else	
		for(var/datum/election/election in nexus.waiting_elections)
			if(election.start_day == weekday && election.start_hour >= hour && election.cut_off > hour && (!election.typed || election.num_type == nexus.election_toggle))
				nexus.start_election(election)
				break
		for(var/datum/judge_trial/trial in nexus.scheduled_trials)
			if(trial.day == weekday && trial.month == month && trial.hour == hour)
				nexus.start_trial(trial)