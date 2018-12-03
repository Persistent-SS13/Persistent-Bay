/turf/simulated/floor
	name = "plating"
	icon = 'icons/turf/flooring/plating.dmi'
	icon_state = "plating"

	// Damage to flooring.
	var/broken
	var/burnt

	// Plating data.
	var/base_name = "plating"
	var/base_desc = "The naked hull."
	var/base_icon = 'icons/turf/flooring/plating.dmi'
	var/base_icon_state = "plating"

	// Flooring data.
	var/flooring_override
	var/initial_flooring
	var/decl/flooring/flooring
	var/mineral = MATERIAL_STEEL

	var/prior_floortype = /turf/space
	var/prior_resources = list()

	thermal_conductivity = 0.040
	heat_capacity = 10000
	var/lava = 0

/turf/simulated/floor/Initialize()
	levelupdate()
	if(!map_storage_loaded)
		set_flooring(get_flooring_data(initial_flooring))
	else if(flooring)
		set_flooring(flooring)
	else
		make_plating()

	. = ..()

/turf/simulated/floor/ReplaceWithLattice()
	var/resources = prior_resources
	var/floortype = prior_floortype
	src.ChangeTurf(prior_floortype)
	spawn()
		var/turf/simulated/T = locate(src.x, src.y, src.z)
		if(ispath(floortype, /turf/simulated))
			T.resources = resources
		new /obj/structure/lattice(T)

/turf/simulated/floor/is_plating()
	return !flooring

/turf/simulated/floor/protects_atom(var/atom/A)
	return (A.level <= 1 && !is_plating()) || ..()

/turf/simulated/floor/proc/set_flooring(var/decl/flooring/newflooring)
	make_plating(defer_icon_update = 1)
	flooring = newflooring
	update_icon(1)
	levelupdate()

//This proc will set floor_type to null and the update_icon() proc will then change the icon_state of the turf
//This proc auto corrects the grass tiles' siding.
/turf/simulated/floor/proc/make_plating(var/place_product, var/defer_icon_update)

	overlays.Cut()

	name = base_name
	desc = base_desc
	icon = base_icon
	icon_state = base_icon_state
	plane = PLATING_PLANE
	color = initial(color)

	if(flooring)
		flooring.on_remove()
		if(flooring.build_type && place_product)
			new flooring.build_type(src)
		flooring = null

	set_light(0)
	broken = null
	burnt = null
	flooring_override = null
	levelupdate()

	if(!defer_icon_update)
		update_icon(1)

/turf/simulated/floor/levelupdate()
	for(var/obj/O in src)
		O.hide(O.hides_under_flooring() && src.flooring)

	if(flooring)
		plane = TURF_PLANE
	else
		plane = PLATING_PLANE
