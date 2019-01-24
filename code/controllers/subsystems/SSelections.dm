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
	