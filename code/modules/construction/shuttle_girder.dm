/obj/structure/girder/shuttle
	name = "shuttle wall girder"
	desc = "The internals of a wall"
	icon_state = "girder_d"

/obj/structure/girder/shuttle/make_wall(var/material/mat, var/isrwall = FALSE)
	var/turf/simulated/wall/shuttle/T = get_turf(src)
	T.ChangeTurf(/turf/simulated/wall/shuttle)
	T.material = material
	T.r_material = isrwall? r_material : null
	T.p_material = mat
	T.state = 0
	T.update_material(1)
	T.update_icon()

/obj/structure/girder/shuttle/corner
	name = "shuttle corner wall girder"
	desc = "The internals of a corner wall"
	icon_state = "girder_d"

/obj/structure/girder/shuttle/corner/make_wall(var/material/mat, var/isrwall = FALSE)
	var/turf/simulated/wall/shuttle/corner/T = get_turf(src)
	T.ChangeTurf(/turf/simulated/wall/shuttle/corner)
	T.material = material
	T.r_material = isrwall? r_material : null
	T.p_material = mat
	T.state = 0
	T.update_material(1)
	T.update_icon()