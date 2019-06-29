SUBSYSTEM_DEF(mazemap)
	name = "Maze Map"
	wait = 3 MINUTES

	var/stat_active_wild_maps = 0

	var/list/map_data = list()
	var/list/activity_checklist
	
/datum/controller/subsystem/mazemap/stat_entry()
	..("Maze Map Running")

/datum/controller/subsystem/mazemap/Initialize(start_timeofday)
	map_data["1"] = new /datum/zlevel_data/one()
	map_data["2"] = new /datum/zlevel_data/two()
	map_data["3"] = new /datum/zlevel_data/three()
	map_data["4"] = new /datum/zlevel_data/four()
	map_data["5"] = new /datum/zlevel_data/five()
	map_data["6"] = new /datum/zlevel_data/six()
	map_data["7"] = new /datum/zlevel_data/seven()
	map_data["8"] = new /datum/zlevel_data/eight()
	map_data["9"] = new /datum/zlevel_data/nine()
	map_data["10"] = new /datum/zlevel_data/ten()
	map_data["11"] = new /datum/zlevel_data/eleven()
	map_data["12"] = new /datum/zlevel_data/twelve()
	map_data["13"] = new /datum/zlevel_data/thirteen()

	for(var/x in map_data)
		var/datum/zlevel_data/data = map_data[x]
		var/op_z = data.z
		var/obj/structure/transition_barrier/barrier
		barrier = new(locate(TRANSITIONEDGE, TRANSITIONEDGE,op_z))
		barrier.dir = 5
		barrier = new(locate(TRANSITIONEDGE, world.maxy-TRANSITIONEDGE,op_z))
		barrier.dir = 6
		barrier = new(locate(world.maxx-TRANSITIONEDGE, TRANSITIONEDGE,op_z))
		barrier.dir = 9
		barrier = new(locate(world.maxx-TRANSITIONEDGE, world.maxy-TRANSITIONEDGE,op_z))
		barrier.dir = 10
		var/transition_dir = 0
		if(data.N_connect)
			transition_dir = 1
		for(var/i = TRANSITIONEDGE+1 to world.maxx-TRANSITIONEDGE-1)
			barrier = new(locate(i, world.maxy-TRANSITIONEDGE, op_z))
			barrier.dir = EAST
			if(transition_dir)
				barrier.alpha = 50
		transition_dir = 0
		if(data.S_connect)
			transition_dir = 1
		for(var/i = TRANSITIONEDGE+1 to world.maxx-TRANSITIONEDGE-1)
			barrier = new(locate(i, TRANSITIONEDGE, op_z))
			barrier.dir = EAST
			if(transition_dir)
				barrier.alpha = 50
		transition_dir = 0
		if(data.W_connect)
			transition_dir = 1
		for(var/i = TRANSITIONEDGE+1 to world.maxy-TRANSITIONEDGE-1)
			barrier = new(locate(TRANSITIONEDGE, i, op_z))
			if(transition_dir)
				barrier.alpha = 50
		transition_dir = 0
		if(data.E_connect)
			transition_dir = 1
		for(var/i = TRANSITIONEDGE+1 to world.maxy-TRANSITIONEDGE-1)
			barrier = new(locate(world.maxx-TRANSITIONEDGE, i, op_z))
			if(transition_dir)
				barrier.alpha = 50
		transition_dir = 0
	return ..()
	

/datum/controller/subsystem/mazemap/fire()
	check_activity()
	update_levels()
	
/datum/controller/subsystem/mazemap/proc/check_activity()
	activity_checklist = list()
	for (var/client/C in GLOB.clients)
		var/mob/M = C.mob
		if (!M.z || !isliving(M) || M.stat == DEAD)
			continue
		activity_checklist["[M.z]"] = TRUE


/datum/controller/subsystem/mazemap/proc/update_levels()
	stat_active_wild_maps = 0 // For stat purposes
	for(var/z in map_data)
		var/datum/zlevel_data/data = map_data[z]
		if (activity_checklist["[z]"] == TRUE)
			data.set_active()
			stat_active_wild_maps++
		else
			data.lower_state()
		data.update()
