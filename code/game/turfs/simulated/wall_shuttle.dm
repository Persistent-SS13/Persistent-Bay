/turf/simulated/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'
	thermal_conductivity = 0.05
	heat_capacity = 0

/turf/simulated/shuttle/wall
	name = "wall"
	icon_state = "wall"
	opacity = 1
	density = 1
	blocks_air = 1

/turf/simulated/shuttle/wall/corner
	var/corner_overlay_state = "diagonalWall"
	var/image/corner_overlay

/turf/simulated/shuttle/wall/corner/New()
	..()
	reset_base_appearance()
	reset_overlay()

//Grabs the base turf type from our area and copies its appearance
/turf/simulated/shuttle/wall/corner/proc/reset_base_appearance()
	var/turf/base_type = get_base_turf_by_area(src)
	if(!base_type) return

	icon = initial(base_type.icon)
	icon_state = initial(base_type.icon_state)

/turf/simulated/shuttle/wall/corner/proc/reset_overlay()
	if(corner_overlay)
		overlays -= corner_overlay
	else
		corner_overlay = image(icon = 'icons/turf/shuttle.dmi', icon_state = corner_overlay_state, dir = src.dir)
		corner_overlay.plane = plane
		corner_overlay.layer = layer
	overlays += corner_overlay

/turf/simulated/shuttle/wall/dark
	icon_state = "wall3"
/turf/simulated/shuttle/wall/orange
	icon_state = "pwall"
/turf/simulated/shuttle/wall/vwall
	icon_state = "vwall"
/turf/simulated/shuttle/wall/roundedvwall
	icon_state = "vwall_r"

/turf/simulated/shuttle/wall/corner/orange
	corner_overlay_state = "diagonalWall2"
/turf/simulated/shuttle/wall/corner/dark
	corner_overlay_state = "diagonalWall3"
/turf/simulated/shuttle/wall/corner/vwall
	corner_overlay_state = "diagonalVWall"

//Predefined Shuttle Corners
/turf/simulated/shuttle/wall/corner/smoothwhite
	icon_state = "corner_white" //for mapping preview
	corner_overlay_state = "corner_white"
/turf/simulated/shuttle/wall/corner/smoothwhite/ne
	dir = NORTH|EAST
/turf/simulated/shuttle/wall/corner/smoothwhite/nw
	dir = NORTH|WEST
/turf/simulated/shuttle/wall/corner/smoothwhite/se
	dir = SOUTH|EAST
/turf/simulated/shuttle/wall/corner/smoothwhite/sw
	dir = SOUTH|WEST

/turf/simulated/shuttle/wall/corner/blockwhite
	icon_state = "corner_white_block"
	corner_overlay_state = "corner_white_block"
/turf/simulated/shuttle/wall/corner/blockwhite/ne
	dir = NORTH|EAST
/turf/simulated/shuttle/wall/corner/blockwhite/nw
	dir = NORTH|WEST
/turf/simulated/shuttle/wall/corner/blockwhite/se
	dir = SOUTH|EAST
/turf/simulated/shuttle/wall/corner/blockwhite/sw
	dir = SOUTH|WEST

/turf/simulated/shuttle/wall/corner/dark
	icon_state = "corner_dark"
	corner_overlay_state = "corner_dark"
/turf/simulated/shuttle/wall/corner/dark/ne
	dir = NORTH|EAST
/turf/simulated/shuttle/wall/corner/dark/nw
	dir = NORTH|WEST
/turf/simulated/shuttle/wall/corner/dark/se
	dir = SOUTH|EAST
/turf/simulated/shuttle/wall/corner/dark/sw
	dir = SOUTH|WEST

/turf/simulated/shuttle/wall/corner/blockorange
	icon_state = "diagonalWall2"
	corner_overlay_state = "diagonalWall2"
/turf/simulated/shuttle/wall/corner/blockorange/ne
	dir = NORTH|EAST
/turf/simulated/shuttle/wall/corner/blockorange/nw
	dir = NORTH|WEST
/turf/simulated/shuttle/wall/corner/blockorange/se
	dir = SOUTH|EAST
/turf/simulated/shuttle/wall/corner/blockorange/sw
	dir = SOUTH|WEST

/turf/simulated/shuttle/wall/corner/vwall
	icon_state = "corner_vwall"
	corner_overlay_state = "corner_vwall"
/turf/simulated/shuttle/wall/corner/vwall/ne
	dir = NORTH|EAST
/turf/simulated/shuttle/wall/corner/vwall/nw
	dir = NORTH|WEST
/turf/simulated/shuttle/wall/corner/vwall/se
	dir = SOUTH|EAST
/turf/simulated/shuttle/wall/corner/vwall/sw
	dir = SOUTH|WEST

/turf/simulated/shuttle/wall/corner/vwallrounded
	icon_state = "corner_vwall_r"
	corner_overlay_state = "corner_vwall_r"
/turf/simulated/shuttle/wall/corner/vwallrounded/ne
	dir = NORTH|EAST
/turf/simulated/shuttle/wall/corner/vwallrounded/nw
	dir = NORTH|WEST
/turf/simulated/shuttle/wall/corner/vwallrounded/se
	dir = SOUTH|EAST
/turf/simulated/shuttle/wall/corner/vwallrounded/sw
	dir = SOUTH|WEST