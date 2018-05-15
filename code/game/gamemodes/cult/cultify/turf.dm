/turf/proc/cultify()
	ChangeTurf(/turf/space)
	return

/turf/simulated/floor/cultify()
	//todo: flooring datum cultify check
	cultify_floor()


/turf/simulated/wall/cult/cultify()
	return

/turf/unsimulated/wall/cult/cultify()
	return

/turf/unsimulated/beach/cultify()
	return

/turf/simulated/floor/proc/cultify_floor()
	set_flooring(get_flooring_data(/decl/flooring/reinforced/cult))
	cult.add_cultiness(CULTINESS_PER_TURF)

