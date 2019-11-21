SUBSYSTEM_DEF(elections)
	name = "Elections"
	wait = 5 MINUTES
	next_fire = 5 MINUTES	// To prevent firing upon start
	runlevels = RUNLEVEL_GAME

/datum/controller/subsystem/elections/stat_entry()
	..("Next election check in [round((next_fire - world.time) / (1 MINUTE), 0.1)] minutes.")


/datum/controller/subsystem/elections/fire()
	var/datum/world_faction/democratic/sycorax = get_faction("sycorax")
	var/time = world.realtime
	var/weekday = time2text(time, "Day")
	var/hour = text2num(time2text(time, "hh"))
	var/month = time2text(time, "Month")
	if(!sycorax)
		log_warning("SSElection couldn't find the 'sycorax' faction. Skipping this update..")
		next_fire = 5 MINUTES
		return
	if(sycorax.current_election)
		if(hour > sycorax.current_election.end_hour && weekday == sycorax.current_election.end_day)
			sycorax.end_election()
	else
		for(var/datum/election/election in sycorax.waiting_elections)
			if(election.start_day == weekday && election.start_hour >= hour && election.cut_off > hour && (!election.typed || election.num_type == sycorax.election_toggle))
				sycorax.start_election(election)
				break
		for(var/datum/judge_trial/trial in sycorax.scheduled_trials)
			if(trial.day == weekday && trial.month == month && trial.hour == hour)
				sycorax.start_trial(trial)