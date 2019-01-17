/datum/random_map/noise/ore
	descriptor = "ore distribution map"
	var/deep_val = 0.8              // Threshold for deep metals, set in new as percentage of cell_range.
	var/rare_val = 0.7              // Threshold for rare metal, set in new as percentage of cell_range.
	var/chunk_size = 4              // Size each cell represents on map

/datum/random_map/noise/ore/New(var/seed, var/tx, var/ty, var/tz, var/tlx, var/tly, var/do_not_apply, var/do_not_announce, var/never_be_priority = 0)
	rare_val = cell_range * rare_val
	deep_val = cell_range * deep_val
	..(seed, tx, ty, tz, (tlx / chunk_size), (tly / chunk_size), do_not_apply, do_not_announce, never_be_priority)

/datum/random_map/noise/ore/check_map_sanity()

	var/rare_count = 0
	var/surface_count = 0
	var/deep_count = 0

	// Increment map sanity counters.
	for(var/value in map)
		if(value < rare_val)
			surface_count++
		else if(value < deep_val)
			rare_count++
		else
			deep_count++

	var/num_chunks = surface_count + rare_count + deep_count

	// Sanity check.
	if(surface_count < (MIN_SURFACE_COUNT_PER_CHUNK * num_chunks))
		admin_notice("<span class='danger'>Insufficient surface minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else if(rare_count < (MIN_RARE_COUNT_PER_CHUNK * num_chunks))
		admin_notice("<span class='danger'>Insufficient rare minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else if(deep_count < (MIN_DEEP_COUNT_PER_CHUNK * num_chunks))
		admin_notice("<span class='danger'>Insufficient deep minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else
		return 1

/*
Low Tier asteroids

Iron-Tin Asteroids
	Solid-Heavy (building and fabricators)
	Reagent-Heavy (grinding for reagents)
	Low amounts of silver
Aluminum-Zinc Asteroids
	Solid-Heavy (building and fabricators)
	Reagent-Heavy (grinding for reagents)
	Low amounts of gold
*/

/datum/random_map/noise/ore/iron_tin_solid_heavy/apply_to_turf(var/x,var/y)

	var/tx = ((origin_x-1)+x)*chunk_size
	var/ty = ((origin_y-1)+y)*chunk_size

	var/tmp_cell
	var/current_cell = get_map_cell(x,y)
	if(current_cell)
		tmp_cell = map[current_cell]

	// Solid Resources

	for(var/i=0,i<chunk_size,i++)
		for(var/j=0,j<chunk_size,j++)
			var/turf/simulated/T = locate(tx+j, ty+i, origin_z)
			if(!istype(T) || !T.has_resources)
				continue
			if(!priority_process)
				CHECK_TICK
			T.resources = list()
			T.resources[MATERIAL_SAND] = rand(3,5)

			if(tmp_cell < rare_val)      // Surface metals.
				T.resources[MATERIAL_HEMATITE] =			rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_GRAPHITE] =			rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_CASSITERITE] =			rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_TETRAHEDRITE] =		rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_ROCK_SALT] =			rand(RESOURCE_LOW_MIN,	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_PYRITE] =				rand(RESOURCE_LOW_MIN,	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_CINNABAR] =			rand(RESOURCE_LOW_MIN,	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_PHOSPHORITE] =			rand(RESOURCE_LOW_MIN,	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_POTASH] =				rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_QUARTZ] =				rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_SPODUMENE] =			rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_FREIBERGITE] =			rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_BOHMEITE] =			0
				T.resources[MATERIAL_SPHALERITE] =			0
				T.resources[MATERIAL_GALENA] =				0
				T.resources[MATERIAL_SILVER] =				0
				T.resources[MATERIAL_GOLD] =				0
				T.resources[MATERIAL_BAUXITE] =   			0
				T.resources[MATERIAL_PITCHBLENDE] =			0
				T.resources[MATERIAL_ILMENITE] = 			0
				T.resources[MATERIAL_DIAMOND] =  			0
				T.resources[MATERIAL_PHORON] =   			0
				T.resources[MATERIAL_PLATINUM] = 			0
				T.resources[MATERIAL_TUNGSTEN] = 			0
				T.resources[MATERIAL_HYDROGEN] = 			0
				T.resources[MATERIAL_BSPACE_CRYSTAL] = 		0
				T.resources[MATERIAL_TITANIUM] =			0
				T.resources[MATERIAL_DEUTERIUM] =			0
				T.resources[MATERIAL_TRITIUM] =				0
			else if(tmp_cell < deep_val) // Rare metals.
				T.resources[MATERIAL_HEMATITE] =			rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_GRAPHITE] =			rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_CASSITERITE] =			rand(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_TETRAHEDRITE] =		rand(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_ROCK_SALT] =			rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_PYRITE] =				rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_CINNABAR] =			rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_PHOSPHORITE] =			rand(RESOURCE_LOW_MIN,	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_POTASH] =				rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_QUARTZ] =				rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_SPODUMENE] =			rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_FREIBERGITE] =			rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_BOHMEITE] =			0
				T.resources[MATERIAL_SPHALERITE] =			0
				T.resources[MATERIAL_GALENA] =				0
				T.resources[MATERIAL_SILVER] =				0
				T.resources[MATERIAL_GOLD] =				0
				T.resources[MATERIAL_BAUXITE] =   			0
				T.resources[MATERIAL_PITCHBLENDE] =			0
				T.resources[MATERIAL_ILMENITE] = 			0
				T.resources[MATERIAL_DIAMOND] =  			0
				T.resources[MATERIAL_PHORON] =   			0
				T.resources[MATERIAL_PLATINUM] = 			0
				T.resources[MATERIAL_TUNGSTEN] = 			0
				T.resources[MATERIAL_HYDROGEN] = 			0
				T.resources[MATERIAL_BSPACE_CRYSTAL] = 		0
				T.resources[MATERIAL_TITANIUM] =			0
				T.resources[MATERIAL_DEUTERIUM] =			0
				T.resources[MATERIAL_TRITIUM] =				0
			else                             // Deep metals.
				T.resources[MATERIAL_HEMATITE] =			rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_GRAPHITE] =			rand(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_CASSITERITE] =			rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_TETRAHEDRITE] =		rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_ROCK_SALT] =			rand(RESOURCE_LOW_MIN,	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_PYRITE] =				rand(RESOURCE_LOW_MIN,	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_CINNABAR] =			rand(RESOURCE_LOW_MIN,	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_PHOSPHORITE] =			rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_POTASH] =				rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_QUARTZ] =				rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_SPODUMENE] =			rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_FREIBERGITE] =			rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_SILVER] =				rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_BOHMEITE] =			0
				T.resources[MATERIAL_SPHALERITE] =			0
				T.resources[MATERIAL_GALENA] =				0
				T.resources[MATERIAL_GOLD] =				0
				T.resources[MATERIAL_BAUXITE] =   			0
				T.resources[MATERIAL_PITCHBLENDE] =			0
				T.resources[MATERIAL_ILMENITE] = 			0
				T.resources[MATERIAL_DIAMOND] =  			0
				T.resources[MATERIAL_PHORON] =   			0
				T.resources[MATERIAL_PLATINUM] = 			0
				T.resources[MATERIAL_TUNGSTEN] = 			0
				T.resources[MATERIAL_HYDROGEN] = 			0
				T.resources[MATERIAL_BSPACE_CRYSTAL] = 		0
				T.resources[MATERIAL_TITANIUM] =			0
				T.resources[MATERIAL_DEUTERIUM] =			0
				T.resources[MATERIAL_TRITIUM] =				0

	..() // For normal gas resources

/datum/random_map/noise/ore/iron_tin_reagent_heavy/apply_to_turf(var/x,var/y)

	var/tx = ((origin_x-1)+x)*chunk_size
	var/ty = ((origin_y-1)+y)*chunk_size

	var/tmp_cell
	var/current_cell = get_map_cell(x,y)
	if(current_cell)
		tmp_cell = map[current_cell]

	// Solid Resources

	for(var/i=0,i<chunk_size,i++)
		for(var/j=0,j<chunk_size,j++)
			var/turf/simulated/T = locate(tx+j, ty+i, origin_z)
			if(!istype(T) || !T.has_resources)
				continue
			if(!priority_process)
				CHECK_TICK
			T.resources = list()
			T.resources[MATERIAL_SAND] = rand(3,5)

			if(tmp_cell < rare_val)      // Surface metals.
				T.resources[MATERIAL_HEMATITE] =			rand(RESOURCE_LOW_MIN,	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_GRAPHITE] =			rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_CASSITERITE] =			rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_TETRAHEDRITE] =		rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_ROCK_SALT] =			rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_PYRITE] =				rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_CINNABAR] =			rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_PHOSPHORITE] =			rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_POTASH] =				rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_QUARTZ] =				rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_SPODUMENE] =			rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_FREIBERGITE] =			0
				T.resources[MATERIAL_BOHMEITE] =			0
				T.resources[MATERIAL_SPHALERITE] =			0
				T.resources[MATERIAL_GALENA] =				0
				T.resources[MATERIAL_SILVER] =				0
				T.resources[MATERIAL_GOLD] =				0
				T.resources[MATERIAL_BAUXITE] =   			0
				T.resources[MATERIAL_PITCHBLENDE] =			0
				T.resources[MATERIAL_ILMENITE] = 			0
				T.resources[MATERIAL_DIAMOND] =  			0
				T.resources[MATERIAL_PHORON] =   			0
				T.resources[MATERIAL_PLATINUM] = 			0
				T.resources[MATERIAL_TUNGSTEN] = 			0
				T.resources[MATERIAL_HYDROGEN] = 			0
				T.resources[MATERIAL_BSPACE_CRYSTAL] = 		0
				T.resources[MATERIAL_TITANIUM] =			0
				T.resources[MATERIAL_DEUTERIUM] =			0
				T.resources[MATERIAL_TRITIUM] =				0
			else if(tmp_cell < deep_val) // Rare metals.
				T.resources[MATERIAL_HEMATITE] =			rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_GRAPHITE] =			rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_CASSITERITE] =			rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_TETRAHEDRITE] =		rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_ROCK_SALT] =			rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_PYRITE] =				rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_CINNABAR] =			rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_PHOSPHORITE] =			rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_POTASH] =				rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_QUARTZ] =				rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_SPODUMENE] =			rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_FREIBERGITE] =			0
				T.resources[MATERIAL_BOHMEITE] =			0
				T.resources[MATERIAL_SPHALERITE] =			0
				T.resources[MATERIAL_GALENA] =				0
				T.resources[MATERIAL_SILVER] =				0
				T.resources[MATERIAL_GOLD] =				0
				T.resources[MATERIAL_BAUXITE] =   			0
				T.resources[MATERIAL_PITCHBLENDE] =			0
				T.resources[MATERIAL_ILMENITE] = 			0
				T.resources[MATERIAL_DIAMOND] =  			0
				T.resources[MATERIAL_PHORON] =   			0
				T.resources[MATERIAL_PLATINUM] = 			0
				T.resources[MATERIAL_TUNGSTEN] = 			0
				T.resources[MATERIAL_HYDROGEN] = 			0
				T.resources[MATERIAL_BSPACE_CRYSTAL] = 		0
				T.resources[MATERIAL_TITANIUM] =			0
				T.resources[MATERIAL_DEUTERIUM] =			0
				T.resources[MATERIAL_TRITIUM] =				0
			else                             // Deep metals.
				T.resources[MATERIAL_HEMATITE] =			rand(RESOURCE_LOW_MIN,	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_GRAPHITE] =			rand(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_CASSITERITE] =			rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_TETRAHEDRITE] =		rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_ROCK_SALT] =			rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_PYRITE] =				rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_CINNABAR] =			rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_PHOSPHORITE] =			rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_POTASH] =				rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_QUARTZ] =				rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_SPODUMENE] =			rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_FREIBERGITE] =			rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_BOHMEITE] =			0
				T.resources[MATERIAL_SILVER] =				0
				T.resources[MATERIAL_SPHALERITE] =			0
				T.resources[MATERIAL_GALENA] =				0
				T.resources[MATERIAL_GOLD] =				0
				T.resources[MATERIAL_BAUXITE] =   			0
				T.resources[MATERIAL_PITCHBLENDE] =			0
				T.resources[MATERIAL_ILMENITE] = 			0
				T.resources[MATERIAL_DIAMOND] =  			0
				T.resources[MATERIAL_PHORON] =   			0
				T.resources[MATERIAL_PLATINUM] = 			0
				T.resources[MATERIAL_TUNGSTEN] = 			0
				T.resources[MATERIAL_HYDROGEN] = 			0
				T.resources[MATERIAL_BSPACE_CRYSTAL] = 		0
				T.resources[MATERIAL_TITANIUM] =			0
				T.resources[MATERIAL_DEUTERIUM] =			0
				T.resources[MATERIAL_TRITIUM] =				0

	..() // For normal gas resources

/datum/random_map/noise/ore/aluminum_zinc_solid_heavy/apply_to_turf(var/x,var/y)

	var/tx = ((origin_x-1)+x)*chunk_size
	var/ty = ((origin_y-1)+y)*chunk_size

	var/tmp_cell
	var/current_cell = get_map_cell(x,y)
	if(current_cell)
		tmp_cell = map[current_cell]

	// Solid Resources

	for(var/i=0,i<chunk_size,i++)
		for(var/j=0,j<chunk_size,j++)
			var/turf/simulated/T = locate(tx+j, ty+i, origin_z)
			if(!istype(T) || !T.has_resources)
				continue
			if(!priority_process)
				CHECK_TICK
			T.resources = list()
			T.resources[MATERIAL_SAND] = rand(3,5)

			if(tmp_cell < rare_val)      // Surface metals.
				T.resources[MATERIAL_BAUXITE] =				rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_GRAPHITE] =			rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_SPHALERITE] =			rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_TETRAHEDRITE] =		rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_ROCK_SALT] =			rand(RESOURCE_LOW_MIN,	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_PYRITE] =				rand(RESOURCE_LOW_MIN,	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_CINNABAR] =			rand(RESOURCE_LOW_MIN,	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_PHOSPHORITE] =			rand(RESOURCE_LOW_MIN,	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_POTASH] =				rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_QUARTZ] =				rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_SPODUMENE] =			rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_FREIBERGITE] =			0
				T.resources[MATERIAL_BOHMEITE] =			0
				T.resources[MATERIAL_CASSITERITE] =			0
				T.resources[MATERIAL_GALENA] =				0
				T.resources[MATERIAL_SILVER] =				0
				T.resources[MATERIAL_GOLD] =				0
				T.resources[MATERIAL_HEMATITE] =   			0
				T.resources[MATERIAL_PITCHBLENDE] =			0
				T.resources[MATERIAL_ILMENITE] = 			0
				T.resources[MATERIAL_DIAMOND] =  			0
				T.resources[MATERIAL_PHORON] =   			0
				T.resources[MATERIAL_PLATINUM] = 			0
				T.resources[MATERIAL_TUNGSTEN] = 			0
				T.resources[MATERIAL_HYDROGEN] = 			0
				T.resources[MATERIAL_BSPACE_CRYSTAL] = 		0
				T.resources[MATERIAL_TITANIUM] =			0
				T.resources[MATERIAL_DEUTERIUM] =			0
				T.resources[MATERIAL_TRITIUM] =				0
			else if(tmp_cell < deep_val) // Rare metals.
				T.resources[MATERIAL_BAUXITE] =				rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_GRAPHITE] =			rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_SPHALERITE] =			rand(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_TETRAHEDRITE] =		rand(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_ROCK_SALT] =			rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_PYRITE] =				rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_CINNABAR] =			rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_PHOSPHORITE] =			rand(RESOURCE_LOW_MIN,	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_POTASH] =				rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_QUARTZ] =				rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_SPODUMENE] =			rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_BOHMEITE] =			rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_FREIBERGITE] =			0
				T.resources[MATERIAL_SPHALERITE] =			0
				T.resources[MATERIAL_GALENA] =				0
				T.resources[MATERIAL_SILVER] =				0
				T.resources[MATERIAL_GOLD] =				0
				T.resources[MATERIAL_BAUXITE] =   			0
				T.resources[MATERIAL_PITCHBLENDE] =			0
				T.resources[MATERIAL_ILMENITE] = 			0
				T.resources[MATERIAL_DIAMOND] =  			0
				T.resources[MATERIAL_PHORON] =   			0
				T.resources[MATERIAL_PLATINUM] = 			0
				T.resources[MATERIAL_TUNGSTEN] = 			0
				T.resources[MATERIAL_HYDROGEN] = 			0
				T.resources[MATERIAL_BSPACE_CRYSTAL] = 		0
				T.resources[MATERIAL_TITANIUM] =			0
				T.resources[MATERIAL_DEUTERIUM] =			0
				T.resources[MATERIAL_TRITIUM] =				0
			else                             // Deep metals.
				T.resources[MATERIAL_BAUXITE] =				rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_GRAPHITE] =			rand(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_SPHALERITE] =			rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_TETRAHEDRITE] =		rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_ROCK_SALT] =			rand(RESOURCE_LOW_MIN,	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_PYRITE] =				rand(RESOURCE_LOW_MIN,	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_CINNABAR] =			rand(RESOURCE_LOW_MIN,	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_PHOSPHORITE] =			rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_POTASH] =				rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_QUARTZ] =				rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_SPODUMENE] =			rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_BOHMEITE] =			rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_GOLD] =				rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_FREIBERGITE] =			0
				T.resources[MATERIAL_CASSITERITE] =			0
				T.resources[MATERIAL_GALENA] =				0
				T.resources[MATERIAL_SILVER] =				0
				T.resources[MATERIAL_HEMATITE] =   			0
				T.resources[MATERIAL_PITCHBLENDE] =			0
				T.resources[MATERIAL_ILMENITE] = 			0
				T.resources[MATERIAL_DIAMOND] =  			0
				T.resources[MATERIAL_PHORON] =   			0
				T.resources[MATERIAL_PLATINUM] = 			0
				T.resources[MATERIAL_TUNGSTEN] = 			0
				T.resources[MATERIAL_HYDROGEN] = 			0
				T.resources[MATERIAL_BSPACE_CRYSTAL] = 		0
				T.resources[MATERIAL_TITANIUM] =			0
				T.resources[MATERIAL_DEUTERIUM] =			0
				T.resources[MATERIAL_TRITIUM] =				0

	..() // For normal gas resources

/datum/random_map/noise/ore/aluminum_zinc_reagent_heavy/apply_to_turf(var/x,var/y)

	var/tx = ((origin_x-1)+x)*chunk_size
	var/ty = ((origin_y-1)+y)*chunk_size

	var/tmp_cell
	var/current_cell = get_map_cell(x,y)
	if(current_cell)
		tmp_cell = map[current_cell]

	// Solid Resources

	for(var/i=0,i<chunk_size,i++)
		for(var/j=0,j<chunk_size,j++)
			var/turf/simulated/T = locate(tx+j, ty+i, origin_z)
			if(!istype(T) || !T.has_resources)
				continue
			if(!priority_process)
				CHECK_TICK
			T.resources = list()
			T.resources[MATERIAL_SAND] = rand(3,5)

			if(tmp_cell < rare_val)      // Surface metals.
				T.resources[MATERIAL_BAUXITE] =				rand(RESOURCE_LOW_MIN,	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_GRAPHITE] =			rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_SPHALERITE] =			rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_TETRAHEDRITE] =		rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_ROCK_SALT] =			rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_PYRITE] =				rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_CINNABAR] =			rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_PHOSPHORITE] =			rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_POTASH] =				rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_QUARTZ] =				rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_SPODUMENE] =			rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_FREIBERGITE] =			0
				T.resources[MATERIAL_BOHMEITE] =			0
				T.resources[MATERIAL_CASSITERITE] =			0
				T.resources[MATERIAL_GALENA] =				0
				T.resources[MATERIAL_SILVER] =				0
				T.resources[MATERIAL_GOLD] =				0
				T.resources[MATERIAL_HEMATITE] =   			0
				T.resources[MATERIAL_PITCHBLENDE] =			0
				T.resources[MATERIAL_ILMENITE] = 			0
				T.resources[MATERIAL_DIAMOND] =  			0
				T.resources[MATERIAL_PHORON] =   			0
				T.resources[MATERIAL_PLATINUM] = 			0
				T.resources[MATERIAL_TUNGSTEN] = 			0
				T.resources[MATERIAL_HYDROGEN] = 			0
				T.resources[MATERIAL_BSPACE_CRYSTAL] = 		0
				T.resources[MATERIAL_TITANIUM] =			0
				T.resources[MATERIAL_DEUTERIUM] =			0
				T.resources[MATERIAL_TRITIUM] =				0
			else if(tmp_cell < deep_val) // Rare metals.
				T.resources[MATERIAL_BAUXITE] =				rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_GRAPHITE] =			rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_SPHALERITE] =			rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_TETRAHEDRITE] =		rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_ROCK_SALT] =			rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_PYRITE] =				rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_CINNABAR] =			rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_PHOSPHORITE] =			rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_POTASH] =				rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_QUARTZ] =				rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_SPODUMENE] =			rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_FREIBERGITE] =			0
				T.resources[MATERIAL_BOHMEITE] =			0
				T.resources[MATERIAL_CASSITERITE] =			0
				T.resources[MATERIAL_GALENA] =				0
				T.resources[MATERIAL_SILVER] =				0
				T.resources[MATERIAL_GOLD] =				0
				T.resources[MATERIAL_BAUXITE] =   			0
				T.resources[MATERIAL_PITCHBLENDE] =			0
				T.resources[MATERIAL_ILMENITE] = 			0
				T.resources[MATERIAL_DIAMOND] =  			0
				T.resources[MATERIAL_PHORON] =   			0
				T.resources[MATERIAL_PLATINUM] = 			0
				T.resources[MATERIAL_TUNGSTEN] = 			0
				T.resources[MATERIAL_HYDROGEN] = 			0
				T.resources[MATERIAL_BSPACE_CRYSTAL] = 		0
				T.resources[MATERIAL_TITANIUM] =			0
				T.resources[MATERIAL_DEUTERIUM] =			0
				T.resources[MATERIAL_TRITIUM] =				0
			else                             // Deep metals.
				T.resources[MATERIAL_BAUXITE] =			rand(RESOURCE_LOW_MIN,	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_GRAPHITE] =			rand(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_SPHALERITE] =			rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_TETRAHEDRITE] =		rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_ROCK_SALT] =			rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_PYRITE] =				rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_CINNABAR] =			rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_PHOSPHORITE] =			rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_POTASH] =				rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_QUARTZ] =				rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_SPODUMENE] =			rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_BOHMEITE] =			rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_FREIBERGITE] =			0
				T.resources[MATERIAL_SILVER] =				0
				T.resources[MATERIAL_CASSITERITE] =			0
				T.resources[MATERIAL_GALENA] =				0
				T.resources[MATERIAL_GOLD] =				0
				T.resources[MATERIAL_BAUXITE] =   			0
				T.resources[MATERIAL_PITCHBLENDE] =			0
				T.resources[MATERIAL_ILMENITE] = 			0
				T.resources[MATERIAL_DIAMOND] =  			0
				T.resources[MATERIAL_PHORON] =   			0
				T.resources[MATERIAL_PLATINUM] = 			0
				T.resources[MATERIAL_TUNGSTEN] = 			0
				T.resources[MATERIAL_HYDROGEN] = 			0
				T.resources[MATERIAL_BSPACE_CRYSTAL] = 		0
				T.resources[MATERIAL_TITANIUM] =			0
				T.resources[MATERIAL_DEUTERIUM] =			0
				T.resources[MATERIAL_TRITIUM] =				0

	..() // For normal gas resources

/*
High Tier asteroids

Silver-Tungsten Asteroids
	Solid-Heavy
	Medium amount of pitchblende
	Medium amount of iron
	Medium amount of lead
	Low amount of reagents
	Low amount of phoron
	Low amount of Bluespace Crystals
Gold-Platinum Asteroids
	Solid-Heavy
	Medium amount of diamond
	Medium amount of aluminum
	Medium amount of lead
	Low amount of reagents
	Low amount of phoron
	Low amount of Bluespace Crystals
Titanium-Fusion Asteroids
	Solid-Heavy
	Medium amount of lead
	Medium amount of hydrogen
	Medium amount of deuterium/tritium
	Medium amount of phoron
	Low amount of Bluespace Crystals
	No Reagents
*/

/datum/random_map/noise/ore/silver_tungsten/apply_to_turf(var/x,var/y)

	var/tx = ((origin_x-1)+x)*chunk_size
	var/ty = ((origin_y-1)+y)*chunk_size

	var/tmp_cell
	var/current_cell = get_map_cell(x,y)
	if(current_cell)
		tmp_cell = map[current_cell]

	// Solid Resources

	for(var/i=0,i<chunk_size,i++)
		for(var/j=0,j<chunk_size,j++)
			var/turf/simulated/T = locate(tx+j, ty+i, origin_z)
			if(!istype(T) || !T.has_resources)
				continue
			if(!priority_process)
				CHECK_TICK
			T.resources = list()
			T.resources[MATERIAL_SAND] = rand(3,5)

			if(tmp_cell < rare_val)      // Surface metals.
				T.resources[MATERIAL_SILVER] =				rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_TUNGSTEN] = 			rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_HEMATITE] =   			rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_PITCHBLENDE] =			rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_GALENA] =				rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_BAUXITE] =				0
				T.resources[MATERIAL_GRAPHITE] =			0
				T.resources[MATERIAL_SPHALERITE] =			0
				T.resources[MATERIAL_TETRAHEDRITE] =		0
				T.resources[MATERIAL_ROCK_SALT] =			0
				T.resources[MATERIAL_PYRITE] =				0
				T.resources[MATERIAL_CINNABAR] =			0
				T.resources[MATERIAL_PHOSPHORITE] =			0
				T.resources[MATERIAL_POTASH] =				0
				T.resources[MATERIAL_QUARTZ] =				0
				T.resources[MATERIAL_SPODUMENE] =			0
				T.resources[MATERIAL_FREIBERGITE] =			0
				T.resources[MATERIAL_BOHMEITE] =			0
				T.resources[MATERIAL_CASSITERITE] =			0
				T.resources[MATERIAL_GOLD] =				0
				T.resources[MATERIAL_ILMENITE] = 			0
				T.resources[MATERIAL_DIAMOND] =  			0
				T.resources[MATERIAL_PHORON] =   			0
				T.resources[MATERIAL_PLATINUM] = 			0
				T.resources[MATERIAL_HYDROGEN] = 			0
				T.resources[MATERIAL_BSPACE_CRYSTAL] = 		0
				T.resources[MATERIAL_TITANIUM] =			0
				T.resources[MATERIAL_DEUTERIUM] =			0
				T.resources[MATERIAL_TRITIUM] =				0
			else if(tmp_cell < deep_val) // Rare metals.
				T.resources[MATERIAL_SILVER] =				rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_TUNGSTEN] = 			rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_HEMATITE] =   			rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_PITCHBLENDE] =			rand(RESOURCE_MID_MIN, 	RESOURCE_MID_MAX)
				T.resources[MATERIAL_GALENA] =				rand(RESOURCE_MID_MIN, 	RESOURCE_MID_MAX)
				T.resources[MATERIAL_ROCK_SALT] =			rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_PYRITE] =				rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_CINNABAR] =			rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_PHOSPHORITE] =			rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_POTASH] =				rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_QUARTZ] =				rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_SPODUMENE] =			rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_PHORON] =   			rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_GRAPHITE] =			rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_FREIBERGITE] =			0
				T.resources[MATERIAL_BOHMEITE] =			0
				T.resources[MATERIAL_CASSITERITE] =			0
				T.resources[MATERIAL_GOLD] =				0
				T.resources[MATERIAL_ILMENITE] = 			0
				T.resources[MATERIAL_DIAMOND] =  			0
				T.resources[MATERIAL_BAUXITE] =				0
				T.resources[MATERIAL_SPHALERITE] =			0
				T.resources[MATERIAL_TETRAHEDRITE] =		0
				T.resources[MATERIAL_PLATINUM] = 			0
				T.resources[MATERIAL_HYDROGEN] = 			0
				T.resources[MATERIAL_BSPACE_CRYSTAL] = 		0
				T.resources[MATERIAL_TITANIUM] =			0
				T.resources[MATERIAL_DEUTERIUM] =			0
				T.resources[MATERIAL_TRITIUM] =				0
			else                             // Deep metals.
				T.resources[MATERIAL_SILVER] =				rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_TUNGSTEN] = 			rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_HEMATITE] =   			rand(RESOURCE_MID_MIN, 	RESOURCE_MID_MAX)
				T.resources[MATERIAL_PITCHBLENDE] =			rand(RESOURCE_MID_MIN, 	RESOURCE_MID_MAX)
				T.resources[MATERIAL_GALENA] =				rand(RESOURCE_MID_MIN, 	RESOURCE_MID_MAX)

				T.resources[MATERIAL_PHORON] =   			rand(RESOURCE_MID_MIN, 	RESOURCE_MID_MAX)
				if(prob(0.5)) // half a percent
					T.resources[MATERIAL_BSPACE_CRYSTAL] = 1
				else
					T.resources[MATERIAL_BSPACE_CRYSTAL] = 0
				T.resources[MATERIAL_PLATINUM] = 			0
				T.resources[MATERIAL_HYDROGEN] = 			0
				T.resources[MATERIAL_BAUXITE] =				0
				T.resources[MATERIAL_GRAPHITE] =			0
				T.resources[MATERIAL_SPHALERITE] =			0
				T.resources[MATERIAL_TETRAHEDRITE] =		0
				T.resources[MATERIAL_ROCK_SALT] =			0
				T.resources[MATERIAL_PYRITE] =				0
				T.resources[MATERIAL_CINNABAR] =			0
				T.resources[MATERIAL_PHOSPHORITE] =			0
				T.resources[MATERIAL_POTASH] =				0
				T.resources[MATERIAL_QUARTZ] =				0
				T.resources[MATERIAL_SPODUMENE] =			0
				T.resources[MATERIAL_FREIBERGITE] =			0
				T.resources[MATERIAL_BOHMEITE] =			0
				T.resources[MATERIAL_CASSITERITE] =			0
				T.resources[MATERIAL_GOLD] =				0
				T.resources[MATERIAL_ILMENITE] = 			0
				T.resources[MATERIAL_DIAMOND] =  			0
				T.resources[MATERIAL_TITANIUM] =			0
				T.resources[MATERIAL_DEUTERIUM] =			0
				T.resources[MATERIAL_TRITIUM] =				0

	..() // For normal gas resources

/datum/random_map/noise/ore/gold_platinum/apply_to_turf(var/x,var/y)

	var/tx = ((origin_x-1)+x)*chunk_size
	var/ty = ((origin_y-1)+y)*chunk_size

	var/tmp_cell
	var/current_cell = get_map_cell(x,y)
	if(current_cell)
		tmp_cell = map[current_cell]

	// Solid Resources

	for(var/i=0,i<chunk_size,i++)
		for(var/j=0,j<chunk_size,j++)
			var/turf/simulated/T = locate(tx+j, ty+i, origin_z)
			if(!istype(T) || !T.has_resources)
				continue
			if(!priority_process)
				CHECK_TICK
			T.resources = list()
			T.resources[MATERIAL_SAND] = rand(3,5)

			if(tmp_cell < rare_val)      // Surface metals.
				T.resources[MATERIAL_GOLD] =				rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_PLATINUM] = 			rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_BAUXITE] =   			rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_DIAMOND] =				rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_GALENA] =				rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_HEMATITE] =			0
				T.resources[MATERIAL_GRAPHITE] =			0
				T.resources[MATERIAL_SPHALERITE] =			0
				T.resources[MATERIAL_TETRAHEDRITE] =		0
				T.resources[MATERIAL_ROCK_SALT] =			0
				T.resources[MATERIAL_PYRITE] =				0
				T.resources[MATERIAL_CINNABAR] =			0
				T.resources[MATERIAL_PHOSPHORITE] =			0
				T.resources[MATERIAL_POTASH] =				0
				T.resources[MATERIAL_QUARTZ] =				0
				T.resources[MATERIAL_SPODUMENE] =			0
				T.resources[MATERIAL_FREIBERGITE] =			0
				T.resources[MATERIAL_BOHMEITE] =			0
				T.resources[MATERIAL_CASSITERITE] =			0
				T.resources[MATERIAL_SILVER] =				0
				T.resources[MATERIAL_HEMATITE] =   			0
				T.resources[MATERIAL_ILMENITE] = 			0
				T.resources[MATERIAL_PITCHBLENDE] =			0
				T.resources[MATERIAL_PHORON] =   			0
				T.resources[MATERIAL_TUNGSTEN] = 			0
				T.resources[MATERIAL_HYDROGEN] = 			0
				T.resources[MATERIAL_BSPACE_CRYSTAL] = 		0
				T.resources[MATERIAL_TITANIUM] =			0
				T.resources[MATERIAL_DEUTERIUM] =			0
				T.resources[MATERIAL_TRITIUM] =				0
			else if(tmp_cell < deep_val) // Rare metals.
				T.resources[MATERIAL_GOLD] =				rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_PLATINUM] = 			rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_BAUXITE] =   			rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_DIAMOND] =				rand(RESOURCE_MID_MIN, 	RESOURCE_MID_MAX)
				T.resources[MATERIAL_GALENA] =				rand(RESOURCE_MID_MIN, 	RESOURCE_MID_MAX)
				T.resources[MATERIAL_ROCK_SALT] =			rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_PYRITE] =				rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_CINNABAR] =			rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_PHOSPHORITE] =			rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_POTASH] =				rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_QUARTZ] =				rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_SPODUMENE] =			rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_GRAPHITE] =			rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_PHORON] =   			rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_FREIBERGITE] =			0
				T.resources[MATERIAL_BOHMEITE] =			0
				T.resources[MATERIAL_CASSITERITE] =			0
				T.resources[MATERIAL_SILVER] =				0
				T.resources[MATERIAL_HEMATITE] =   			0
				T.resources[MATERIAL_ILMENITE] = 			0
				T.resources[MATERIAL_PITCHBLENDE] =  		0
				T.resources[MATERIAL_HEMATITE] =			0
				T.resources[MATERIAL_SPHALERITE] =			0
				T.resources[MATERIAL_TETRAHEDRITE] =		0
				T.resources[MATERIAL_TUNGSTEN] = 			0
				T.resources[MATERIAL_HYDROGEN] = 			0
				T.resources[MATERIAL_BSPACE_CRYSTAL] = 		0
				T.resources[MATERIAL_TITANIUM] =			0
				T.resources[MATERIAL_DEUTERIUM] =			0
				T.resources[MATERIAL_TRITIUM] =				0
			else                             // Deep metals.
				T.resources[MATERIAL_GOLD] =				rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_PLATINUM] = 			rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_BAUXITE] =   			rand(RESOURCE_MID_MIN, 	RESOURCE_MID_MAX)
				T.resources[MATERIAL_DIAMOND] =				rand(RESOURCE_MID_MIN, 	RESOURCE_MID_MAX)
				T.resources[MATERIAL_GALENA] =				rand(RESOURCE_MID_MIN, 	RESOURCE_MID_MAX)

				T.resources[MATERIAL_PHORON] =   			rand(RESOURCE_MID_MIN, 	RESOURCE_MID_MAX)
				if(prob(0.5)) // half a percent
					T.resources[MATERIAL_BSPACE_CRYSTAL] = 1
				else
					T.resources[MATERIAL_BSPACE_CRYSTAL] = 0
				T.resources[MATERIAL_TUNGSTEN] = 			0
				T.resources[MATERIAL_HYDROGEN] = 			0
				T.resources[MATERIAL_HEMATITE] =			0
				T.resources[MATERIAL_GRAPHITE] =			0
				T.resources[MATERIAL_SPHALERITE] =			0
				T.resources[MATERIAL_TETRAHEDRITE] =		0
				T.resources[MATERIAL_ROCK_SALT] =			0
				T.resources[MATERIAL_PYRITE] =				0
				T.resources[MATERIAL_CINNABAR] =			0
				T.resources[MATERIAL_PHOSPHORITE] =			0
				T.resources[MATERIAL_POTASH] =				0
				T.resources[MATERIAL_QUARTZ] =				0
				T.resources[MATERIAL_SPODUMENE] =			0
				T.resources[MATERIAL_FREIBERGITE] =			0
				T.resources[MATERIAL_BOHMEITE] =			0
				T.resources[MATERIAL_CASSITERITE] =			0
				T.resources[MATERIAL_SILVER] =				0
				T.resources[MATERIAL_HEMATITE] =   			0
				T.resources[MATERIAL_ILMENITE] = 			0
				T.resources[MATERIAL_PITCHBLENDE] =  		0
				T.resources[MATERIAL_TITANIUM] =			0
				T.resources[MATERIAL_DEUTERIUM] =			0
				T.resources[MATERIAL_TRITIUM] =				0

	..() // For normal gas resources

/datum/random_map/noise/ore/titanium_fusion/apply_to_turf(var/x,var/y)

	var/tx = ((origin_x-1)+x)*chunk_size
	var/ty = ((origin_y-1)+y)*chunk_size

	var/tmp_cell
	var/current_cell = get_map_cell(x,y)
	if(current_cell)
		tmp_cell = map[current_cell]

	// Solid Resources

	for(var/i=0,i<chunk_size,i++)
		for(var/j=0,j<chunk_size,j++)
			var/turf/simulated/T = locate(tx+j, ty+i, origin_z)
			if(!istype(T) || !T.has_resources)
				continue
			if(!priority_process)
				CHECK_TICK
			T.resources = list()
			T.resources[MATERIAL_SAND] = rand(3,5)

			if(tmp_cell < rare_val)      // Surface metals.
				T.resources[MATERIAL_TITANIUM] =			rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_DEUTERIUM] =			rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_TRITIUM] =				rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_GALENA] =				rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_HYDROGEN] = 			0
				T.resources[MATERIAL_HEMATITE] =			0
				T.resources[MATERIAL_GRAPHITE] =			0
				T.resources[MATERIAL_SPHALERITE] =			0
				T.resources[MATERIAL_TETRAHEDRITE] =		0
				T.resources[MATERIAL_ROCK_SALT] =			0
				T.resources[MATERIAL_PYRITE] =				0
				T.resources[MATERIAL_CINNABAR] =			0
				T.resources[MATERIAL_PHOSPHORITE] =			0
				T.resources[MATERIAL_POTASH] =				0
				T.resources[MATERIAL_QUARTZ] =				0
				T.resources[MATERIAL_SPODUMENE] =			0
				T.resources[MATERIAL_FREIBERGITE] =			0
				T.resources[MATERIAL_BOHMEITE] =			0
				T.resources[MATERIAL_CASSITERITE] =			0
				T.resources[MATERIAL_SILVER] =				0
				T.resources[MATERIAL_HEMATITE] =   			0
				T.resources[MATERIAL_ILMENITE] = 			0
				T.resources[MATERIAL_PITCHBLENDE] =			0
				T.resources[MATERIAL_PHORON] =   			0
				T.resources[MATERIAL_TUNGSTEN] = 			0
				T.resources[MATERIAL_PLATINUM] = 			0
				T.resources[MATERIAL_BAUXITE] =   			0
				T.resources[MATERIAL_DIAMOND] =				0
				T.resources[MATERIAL_BSPACE_CRYSTAL] = 		0

				T.gas_resources["deuterium"] =		rand(GAS_RESOURCE_LOW_MIN, 	GAS_RESOURCE_MID_MAX)
				T.gas_resources["helium"] = 		rand(GAS_RESOURCE_LOW_MIN, 	GAS_RESOURCE_LOW_MAX)
				T.gas_resources["tritium"] =		rand(GAS_RESOURCE_LOWEST_MIN,	GAS_RESOURCE_LOWEST_MAX)
			else if(tmp_cell < deep_val) // Rare metals.
				T.resources[MATERIAL_TITANIUM] =			rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_DEUTERIUM] =			rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_TRITIUM] =				rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_GALENA] =				rand(RESOURCE_MID_MIN, 	RESOURCE_MID_MAX)
				T.resources[MATERIAL_PHORON] =   			rand(RESOURCE_MID_MIN, 	RESOURCE_MID_MAX)
				T.resources[MATERIAL_HYDROGEN] = 			rand(RESOURCE_LOWEST_MIN, 	RESOURCE_LOWEST_MAX)
				T.resources[MATERIAL_GOLD] =				0
				T.resources[MATERIAL_PLATINUM] = 			0
				T.resources[MATERIAL_BAUXITE] =   			0
				T.resources[MATERIAL_DIAMOND] =				0
				T.resources[MATERIAL_GALENA] =				0
				T.resources[MATERIAL_ROCK_SALT] =			0
				T.resources[MATERIAL_PYRITE] =				0
				T.resources[MATERIAL_CINNABAR] =			0
				T.resources[MATERIAL_PHOSPHORITE] =			0
				T.resources[MATERIAL_POTASH] =				0
				T.resources[MATERIAL_QUARTZ] =				0
				T.resources[MATERIAL_SPODUMENE] =			0
				T.resources[MATERIAL_FREIBERGITE] =			0
				T.resources[MATERIAL_BOHMEITE] =			0
				T.resources[MATERIAL_CASSITERITE] =			0
				T.resources[MATERIAL_SILVER] =				0
				T.resources[MATERIAL_HEMATITE] =   			0
				T.resources[MATERIAL_ILMENITE] = 			0
				T.resources[MATERIAL_PITCHBLENDE] =  		0
				T.resources[MATERIAL_HEMATITE] =			0
				T.resources[MATERIAL_GRAPHITE] =			0
				T.resources[MATERIAL_SPHALERITE] =			0
				T.resources[MATERIAL_TETRAHEDRITE] =		0
				T.resources[MATERIAL_TUNGSTEN] = 			0
				T.resources[MATERIAL_HYDROGEN] = 			0
				T.resources[MATERIAL_BSPACE_CRYSTAL] = 		0

				T.gas_resources["deuterium"] =		rand(GAS_RESOURCE_LOW_MIN, 	GAS_RESOURCE_MID_MAX)
				T.gas_resources["helium"] = 		rand(GAS_RESOURCE_LOW_MIN, 	GAS_RESOURCE_LOW_MAX)
				T.gas_resources["tritium"] =		rand(GAS_RESOURCE_LOWEST_MIN,	GAS_RESOURCE_LOWEST_MAX)
			else                             // Deep metals.
				T.resources[MATERIAL_TITANIUM] =			rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_DEUTERIUM] =			rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_TRITIUM] =				rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_GALENA] =				rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_PHORON] =   			rand(RESOURCE_MID_MIN, 	RESOURCE_MID_MAX)
				T.resources[MATERIAL_PHORON] =   			rand(RESOURCE_MID_MIN, 	RESOURCE_MID_MAX)
				if(prob(0.5)) // half a percent
					T.resources[MATERIAL_BSPACE_CRYSTAL] = 1
				else
					T.resources[MATERIAL_BSPACE_CRYSTAL] = 0
				T.resources[MATERIAL_TUNGSTEN] = 			0
				T.resources[MATERIAL_HYDROGEN] = 			0
				T.resources[MATERIAL_HEMATITE] =			0
				T.resources[MATERIAL_GRAPHITE] =			0
				T.resources[MATERIAL_SPHALERITE] =			0
				T.resources[MATERIAL_TETRAHEDRITE] =		0
				T.resources[MATERIAL_ROCK_SALT] =			0
				T.resources[MATERIAL_PYRITE] =				0
				T.resources[MATERIAL_CINNABAR] =			0
				T.resources[MATERIAL_PHOSPHORITE] =			0
				T.resources[MATERIAL_POTASH] =				0
				T.resources[MATERIAL_QUARTZ] =				0
				T.resources[MATERIAL_SPODUMENE] =			0
				T.resources[MATERIAL_FREIBERGITE] =			0
				T.resources[MATERIAL_BOHMEITE] =			0
				T.resources[MATERIAL_CASSITERITE] =			0
				T.resources[MATERIAL_SILVER] =				0
				T.resources[MATERIAL_HEMATITE] =   			0
				T.resources[MATERIAL_ILMENITE] = 			0
				T.resources[MATERIAL_PITCHBLENDE] =  		0
				T.resources[MATERIAL_GOLD] =				0
				T.resources[MATERIAL_PLATINUM] = 			0
				T.resources[MATERIAL_BAUXITE] =   			0
				T.resources[MATERIAL_DIAMOND] =				0

				T.gas_resources["deuterium"] =		rand(GAS_RESOURCE_MID_MIN, 	GAS_RESOURCE_MID_MAX)
				T.gas_resources["helium"] = 		rand(GAS_RESOURCE_MID_MIN, 	GAS_RESOURCE_MID_MAX)
				T.gas_resources["tritium"] =		rand(GAS_RESOURCE_MID_MIN,	GAS_RESOURCE_MID_MAX)

	..() // For normal gas resources
/datum/random_map/noise/ore/rich/apply_to_turf(var/x,var/y)

	var/tx = ((origin_x-1)+x)*chunk_size
	var/ty = ((origin_y-1)+y)*chunk_size

	var/tmp_cell
	var/current_cell = get_map_cell(x,y)
	if(current_cell)
		tmp_cell = map[current_cell]

	// Solid Resources

	for(var/i=0,i<chunk_size,i++)
		for(var/j=0,j<chunk_size,j++)
			var/turf/simulated/T = locate(tx+j, ty+i, origin_z)
			if(!istype(T) || !T.has_resources)
				continue
			if(!priority_process)
				CHECK_TICK
			T.resources = list()
			T.resources[MATERIAL_SAND] = rand(3,5)
			T.resources[MATERIAL_GRAPHITE] = rand(RESOURCE_HIGH_MIN,  RESOURCE_HIGH_MAX)

			if(tmp_cell < rare_val)      // Surface metals.
				T.resources[MATERIAL_HEMATITE] =			rand(RESOURCE_HIGH_MIN,	RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_GOLD] =					rand(RESOURCE_LOWEST_MIN,	RESOURCE_LOWEST_MAX)
				T.resources[MATERIAL_SILVER] =				rand(RESOURCE_LOW_MIN, 	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_PITCHBLENDE] =		rand(RESOURCE_LOW_MIN,	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_ROCK_SALT] =			rand(RESOURCE_MID_MIN,	RESOURCE_MID_MAX)
				T.resources[MATERIAL_PYRITE] =				rand(RESOURCE_LOW_MIN,	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_CINNABAR] =			rand(RESOURCE_LOW_MIN,	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_PHOSPHORITE] =		rand(RESOURCE_LOW_MIN,	RESOURCE_LOW_MAX)
				T.resources[MATERIAL_POTASH] =				rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_BAUXITE] =   	  rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_QUARTZ] =				rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_SPODUMENE] =			rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_SPHALERITE] =		rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_GALENA] =				rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_CASSITERITE] =		rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_TETRAHEDRITE] =	rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_FREIBERGITE] =		rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_ILMENITE] = 0
				T.resources[MATERIAL_DIAMOND] =  0
				T.resources[MATERIAL_PHORON] =   0
				T.resources[MATERIAL_PLATINUM] = 0
				T.resources[MATERIAL_TUNGSTEN] = 0
				T.resources[MATERIAL_HYDROGEN] = 0
				T.resources[MATERIAL_BSPACE_CRYSTAL] = 0
			else if(tmp_cell < deep_val) // Rare metals.
				T.resources[MATERIAL_GOLD] =     rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_SILVER] =   rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_PITCHBLENDE] =  rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_PHORON] =   rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_TUNGSTEN] = 0
				T.resources[MATERIAL_PLATINUM] = 0
				T.resources[MATERIAL_HYDROGEN] = 0
				if(prob(0.25)) // .5 percent
					T.resources[MATERIAL_BSPACE_CRYSTAL] = 1
				else
					T.resources[MATERIAL_BSPACE_CRYSTAL] = 0
				T.resources[MATERIAL_DIAMOND] =  0
				T.resources[MATERIAL_HEMATITE] =     0
				T.resources[MATERIAL_ROCK_SALT] =     0
				T.resources[MATERIAL_PYRITE] =   0
				T.resources[MATERIAL_CINNABAR] =   0
				T.resources[MATERIAL_PHOSPHORITE] =   0
				T.resources[MATERIAL_POTASH] =  0
				T.resources[MATERIAL_BAUXITE] =   0
				T.resources[MATERIAL_QUARTZ] =  0
				T.resources[MATERIAL_SPODUMENE] =  0
				T.resources[MATERIAL_ILMENITE] = 0
				T.resources[MATERIAL_SPHALERITE] = 0
				T.resources[MATERIAL_GALENA] =	0
				T.resources[MATERIAL_CASSITERITE] =	0
				T.resources[MATERIAL_TETRAHEDRITE] =	0
				T.resources[MATERIAL_FREIBERGITE] =	0
			else                             // Deep metals.
				T.resources[MATERIAL_PITCHBLENDE] =  rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_DIAMOND] =  rand(RESOURCE_LOWEST_MIN,  RESOURCE_LOWEST_MAX)
				T.resources[MATERIAL_TUNGSTEN] = rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources[MATERIAL_PHORON] =   rand(RESOURCE_HIGH_MIN,  RESOURCE_HIGH_MAX)
				T.resources[MATERIAL_PLATINUM] =   rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_HYDROGEN] = rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources[MATERIAL_ILMENITE] =    rand(GAS_RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				if(prob(0.5)) // half a percent
					T.resources[MATERIAL_BSPACE_CRYSTAL] = 1
				else
					T.resources[MATERIAL_BSPACE_CRYSTAL] = 0
				T.resources[MATERIAL_HEMATITE] =     0
				T.resources[MATERIAL_ROCK_SALT] =     0
				T.resources[MATERIAL_PYRITE] =   0
				T.resources[MATERIAL_CINNABAR] =   0
				T.resources[MATERIAL_PHOSPHORITE] =   0
				T.resources[MATERIAL_POTASH] =  0
				T.resources[MATERIAL_BAUXITE] =   0
				T.resources[MATERIAL_QUARTZ] =  0
				T.resources[MATERIAL_SPODUMENE] =  0
				T.resources[MATERIAL_SPHALERITE] = 0
				T.resources[MATERIAL_GALENA] =	0
				T.resources[MATERIAL_CASSITERITE] =	0
				T.resources[MATERIAL_TETRAHEDRITE] =	0
				T.resources[MATERIAL_FREIBERGITE] =	0

	// Gas Resources

	for(var/k=0,k<chunk_size,k++)
		for(var/l=0,l<chunk_size,l++)
			var/turf/simulated/T = locate(tx+l, ty+k, origin_z)
			if(!istype(T) || !T.has_gas_resources)
				continue
			if(!priority_process)
				CHECK_TICK

			T.gas_resources = list()

			if(tmp_cell < rare_val)      // Surface gases
				T.gas_resources["nitrogen"] = 		rand(GAS_RESOURCE_HIGH_MIN,	GAS_RESOURCE_HIGH_MAX)
				T.gas_resources["hydrogen"] = 		rand(GAS_RESOURCE_MID_MIN,  GAS_RESOURCE_MID_MAX)
				T.gas_resources["deuterium"] =		rand(GAS_RESOURCE_LOW_MIN, 	GAS_RESOURCE_LOW_MAX)
				T.gas_resources["helium"] = 		rand(GAS_RESOURCE_LOW_MIN, 	GAS_RESOURCE_LOW_MAX)
				T.gas_resources["oxygen"]	= 		rand(GAS_RESOURCE_LOW_MIN, 	GAS_RESOURCE_LOW_MAX)
				T.gas_resources["carbon_dioxide"] = rand(GAS_RESOURCE_LOW_MIN, 	GAS_RESOURCE_LOW_MAX)
				T.gas_resources["sleeping_agent"] = rand(GAS_RESOURCE_LOWEST_MIN,	GAS_RESOURCE_LOWEST_MAX) // Sleeping agent is largely useless, so an abundance isn't needed
				T.gas_resources["tritium"] =		0
				T.gas_resources["phoron"] =			0
			else if(tmp_cell < deep_val) // Rare gases
				T.gas_resources["oxygen"]	= 		rand(GAS_RESOURCE_HIGH_MIN, 	GAS_RESOURCE_HIGH_MAX)
				T.gas_resources["hydrogen"] = 		rand(GAS_RESOURCE_MID_MIN,  GAS_RESOURCE_MID_MAX)
				T.gas_resources["deuterium"] =		rand(GAS_RESOURCE_MID_MIN, 	GAS_RESOURCE_MID_MAX)
				T.gas_resources["helium"] = 		rand(GAS_RESOURCE_LOW_MIN, 	GAS_RESOURCE_LOW_MAX)
				T.gas_resources["tritium"] =		rand(GAS_RESOURCE_LOW_MIN,	GAS_RESOURCE_LOW_MAX)
				T.gas_resources["carbon_dioxide"] = rand(GAS_RESOURCE_LOWEST_MIN, GAS_RESOURCE_LOWEST_MAX)
				T.gas_resources["phoron"] =			rand(GAS_RESOURCE_LOWEST_MIN,	GAS_RESOURCE_LOWEST_MAX)
				T.gas_resources["nitrogen"] = 		0
				T.gas_resources["sleeping_agent"] = 0
			else						 // Deep gases
				T.gas_resources["deuterium"] =		rand(GAS_RESOURCE_HIGH_MIN, GAS_RESOURCE_HIGH_MAX)
				T.gas_resources["helium"] = 		rand(GAS_RESOURCE_MID_MIN, 	GAS_RESOURCE_MID_MAX)
				T.gas_resources["tritium"] =		rand(GAS_RESOURCE_MID_MIN,	GAS_RESOURCE_MID_MAX)
				T.gas_resources["oxygen"]	= 		rand(GAS_RESOURCE_MID_MIN, 	GAS_RESOURCE_MID_MAX)
				T.gas_resources["phoron"] =			rand(GAS_RESOURCE_LOW_MIN,	GAS_RESOURCE_LOW_MAX)
				T.gas_resources["hydrogen"] = 		rand(GAS_RESOURCE_LOW_MIN,  GAS_RESOURCE_LOW_MAX)
				T.gas_resources["nitrogen"] = 		0
				T.gas_resources["sleeping_agent"] = 0
				T.gas_resources["carbon_dioxide"] = 0

/datum/random_map/noise/ore/apply_to_turf(var/x,var/y)

	var/tx = ((origin_x-1)+x)*chunk_size
	var/ty = ((origin_y-1)+y)*chunk_size

	var/tmp_cell
	var/current_cell = get_map_cell(x,y)
	if(current_cell)
		tmp_cell = map[current_cell]

	// Gas resources

	for(var/k=0,k<chunk_size,k++)
		for(var/l=0,l<chunk_size,l++)
			var/turf/simulated/T = locate(tx+l, ty+k, origin_z)
			if(!istype(T) || !T.has_gas_resources)
				continue
			if(!priority_process)
				CHECK_TICK

			T.gas_resources = list()

			if(tmp_cell < rare_val)      // Surface gases
				T.gas_resources["nitrogen"] = 		rand(GAS_RESOURCE_MID_MIN,	GAS_RESOURCE_MID_MAX)
				T.gas_resources["hydrogen"] = 		rand(GAS_RESOURCE_LOW_MIN,  GAS_RESOURCE_MID_MAX)
				T.gas_resources["carbon_dioxide"] = rand(GAS_RESOURCE_LOW_MIN, 	GAS_RESOURCE_LOW_MAX)
				T.gas_resources["oxygen"]	= 		rand(GAS_RESOURCE_LOWEST_MIN, 	GAS_RESOURCE_LOWEST_MAX)
				T.gas_resources["sleeping_agent"] = rand(GAS_RESOURCE_LOWEST_MIN,	GAS_RESOURCE_LOWEST_MAX) // Sleeping agent is largely useless, so an abundance isn't needed
				T.gas_resources["phoron"] =			0
			else if(tmp_cell < deep_val) // Rare gases
				T.gas_resources["oxygen"]	= 		rand(GAS_RESOURCE_MID_MIN, 	GAS_RESOURCE_MID_MAX)
				T.gas_resources["hydrogen"] = 		rand(GAS_RESOURCE_MID_MIN,  GAS_RESOURCE_MID_MAX)
				T.gas_resources["carbon_dioxide"] = 0
				T.gas_resources["phoron"] =			0
				T.gas_resources["nitrogen"] = 		0
				T.gas_resources["sleeping_agent"] = 0
			else						 // Deep gases
				T.gas_resources["oxygen"]	= 		rand(GAS_RESOURCE_LOW_MIN, 	GAS_RESOURCE_LOW_MAX)
				T.gas_resources["phoron"] =			rand(GAS_RESOURCE_LOW_MIN,	GAS_RESOURCE_LOW_MAX)
				T.gas_resources["hydrogen"] = 		rand(GAS_RESOURCE_LOW_MIN,  GAS_RESOURCE_LOW_MAX)
				T.gas_resources["nitrogen"] = 		0
				T.gas_resources["sleeping_agent"] = 0
				T.gas_resources["carbon_dioxide"] = 0


/datum/random_map/noise/ore/get_map_char(var/value)
	if(value < rare_val)
		return "S"
	else if(value < deep_val)
		return "R"
	else
		return "D"
