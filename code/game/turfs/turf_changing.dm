/turf/proc/ReplaceWithLattice()
	src.ChangeTurf(get_base_turf_by_area(src))
	spawn()
		new /obj/structure/lattice( locate(src.x, src.y, src.z) )

// Removes all signs of lattice on the pos of the turf -Donkieyo
/turf/proc/RemoveLattice()
	var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
	if(L)
		qdel(L)
// Called after turf replaces old one
/turf/proc/post_change()
	levelupdate()
	var/turf/simulated/open/T = GetAbove(src)
	if(istype(T))
		T.update_icon()

//Creates a new turf
/turf/proc/ChangeTurf(var/turf/N, var/tell_universe=1, var/force_lighting_update = 0, var/space_override = 0)
	var/old_type = src.type
	var/old_resources = null
	if(istype(src, /turf/simulated))
		var/turf/simulated/T = src
		old_resources = T.resources
	if (!N)
		return

	// This makes sure that turfs are not changed to space when one side is part of a zone
	if(N == /turf/space && !space_override)
		for(var/atom/movable/lighting_overlay/overlay in contents)
			overlay.loc = null
			qdel(overlay)
		var/turf/below = GetBelow(src)
		if(istype(below) && !istype(below,/turf/space))
			N = below.density ? /turf/simulated/floor/airless : /turf/simulated/open

	var/obj/fire/old_fire = fire
	var/old_opacity = opacity
	var/old_dynamic_lighting = dynamic_lighting
//	var/old_affecting_lights = affecting_lights
//	var/old_lighting_overlay = lighting_overlay
//	var/old_corners = corners

//	log_debug("Replacing [src.type] with [N]")


	if(connections) connections.erase_all()

	overlays.Cut()
	underlays.Cut()
	if(istype(src,/turf/simulated))
		//Yeah, we're just going to rebuild the whole thing.
		//Despite this being called a bunch during explosions,
		//the zone will only really do heavy lifting once.
		var/turf/simulated/S = src
		if(S.zone) S.zone.rebuild()

	var/turf/simulated/W = new N( locate(src.x, src.y, src.z) )

	W.opaque_counter = opaque_counter

	if(ispath(N, /turf/simulated))
		var/turf/simulated/simu = W
		simu.resources = old_resources
		if(old_fire)
			fire = old_fire
		if (istype(W,/turf/simulated/floor) && old_type == /turf/simulated/asteroid)
			var/turf/simulated/floor/F = W
			F.prior_floortype = old_type
			F.prior_resources = old_resources
			W.RemoveLattice()
	else if(old_fire)
		old_fire.RemoveFire()

	if(tell_universe)
		GLOB.universe.OnTurfChange(W)

	SSair.mark_for_update(src) //handle the addition of the new turf.

	for(var/turf/space/S in range(W,1))
		S.update_starlight()

	W.post_change()
	. = W
	if(dynamic_lighting)
		lighting_build_overlay()
	else
		lighting_clear_overlay()
	if((old_opacity != opacity) || (dynamic_lighting != old_dynamic_lighting))
		reconsider_lights()
	/**
	if(lighting_overlays_initialised)
		lighting_overlay = old_lighting_overlay
		affecting_lights = old_affecting_lights
		corners = old_corners
		if((old_opacity != opacity) || (dynamic_lighting != old_dynamic_lighting))
			reconsider_lights()
		if(dynamic_lighting != old_dynamic_lighting)
			if(dynamic_lighting)
				lighting_build_overlay()
			else
				lighting_clear_overlay()
	**/
/turf/proc/transport_properties_from(turf/other)
	if(!istype(other, src.type))
		return 0
	src.set_dir(other.dir)
	src.icon_state = other.icon_state
	src.icon = other.icon
	src.overlays = other.overlays.Copy()
	src.underlays = other.underlays.Copy()
	if(other.decals)
		src.decals = other.decals.Copy()
		src.update_icon()
	return 1

/turf/simulated/wall/transport_properties_from(turf/simulated/wall/other)
	if(!..())
		return 0
	material = other.material
	p_material = other.p_material


//I would name this copy_from() but we remove the other turf from their air zone for some reason
/turf/simulated/floor/transport_properties_from(turf/simulated/other)
	if(!..())
		return 0
	if(istype(other, /turf/simulated/floor))
		var/turf/simulated/floor/F = other
		set_flooring(F.flooring)
	if(other.zone)
		if(!src.air)
			src.make_air()
		src.air.copy_from(other.zone.air)
		other.zone.remove(other)
	return 1


//No idea why resetting the base appearence from New() isn't enough, but without this it doesn't work
/turf/simulated/wall/shuttle/corner/transport_properties_from(turf/simulated/other)
	. = ..()
	reset_base_appearance()
