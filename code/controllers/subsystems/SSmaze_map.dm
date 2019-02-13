SUBSYSTEM_DEF(mazemap)
	name = "Maze Map"
	wait = 5 MINUTES
//	next_fire = 3 HOURS	// To prevent saving upon start.
	var/init = 0
	var/list/map_data = list()
/datum/controller/subsystem/mazemap/stat_entry()
	..("Maze Map Running")


/datum/controller/subsystem/mazemap/fire()
	if(!init)
		init = 1
		inits()
		return
	respawn()
/datum/controller/subsystem/mazemap/proc/inits()
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
		data.replenish_monsters()
		
/datum/controller/subsystem/mazemap/proc/respawn()
	for(var/datum/zlevel_data/data in map_data)
		data.replenish_monsters()

