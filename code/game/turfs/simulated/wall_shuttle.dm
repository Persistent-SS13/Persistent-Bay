/turf/simulated/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'
	thermal_conductivity = 0.05
	heat_capacity = 0

/turf/simulated/wall/shuttle
	name = "shuttle wall"
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "wall"
	opacity = 1
	density = 1
	blocks_air = 1

/turf/simulated/wall/shuttle/corner
	var/corner_overlay_state = "diagonalWall"
	var/image/corner_overlay

/turf/simulated/wall/shuttle/corner/New()
	..()
	reset_base_appearance()
	reset_overlay()

//Grabs the base turf type from our area and copies its appearance
/turf/simulated/wall/shuttle/corner/proc/reset_base_appearance()
	var/turf/base_type = get_base_turf_by_area(src)
	if(!base_type) return

	icon = initial(base_type.icon)
	icon_state = initial(base_type.icon_state)

/turf/simulated/wall/shuttle/corner/proc/reset_overlay()
	if(corner_overlay)
		overlays -= corner_overlay
	else
		corner_overlay = image(icon = 'icons/turf/shuttle.dmi', icon_state = corner_overlay_state, dir = src.dir)
		corner_overlay.plane = plane
		corner_overlay.layer = layer
	overlays += corner_overlay

/turf/simulated/wall/shuttle/dark
	icon_state = "wall3"
/turf/simulated/wall/shuttle/orange
	icon_state = "pwall"
/turf/simulated/wall/shuttle/vwall
	icon_state = "vwall"
/turf/simulated/wall/shuttle/roundedvwall
	icon_state = "vwall_r"

/turf/simulated/wall/shuttle/corner/orange
	corner_overlay_state = "diagonalWall2"
/turf/simulated/wall/shuttle/corner/dark
	corner_overlay_state = "diagonalWall3"
/turf/simulated/wall/shuttle/corner/vwall
	corner_overlay_state = "diagonalVWall"

//Predefined Shuttle Corners
/turf/simulated/wall/shuttle/corner/smoothwhite
	icon_state = "corner_white" //for mapping preview
	corner_overlay_state = "corner_white"
/turf/simulated/wall/shuttle/corner/smoothwhite/ne
	dir = NORTH|EAST
/turf/simulated/wall/shuttle/corner/smoothwhite/nw
	dir = NORTH|WEST
/turf/simulated/wall/shuttle/corner/smoothwhite/se
	dir = SOUTH|EAST
/turf/simulated/wall/shuttle/corner/smoothwhite/sw
	dir = SOUTH|WEST

/turf/simulated/wall/shuttle/corner/blockwhite
	icon_state = "corner_white_block"
	corner_overlay_state = "corner_white_block"
/turf/simulated/wall/shuttle/corner/blockwhite/ne
	dir = NORTH|EAST
/turf/simulated/wall/shuttle/corner/blockwhite/nw
	dir = NORTH|WEST
/turf/simulated/wall/shuttle/corner/blockwhite/se
	dir = SOUTH|EAST
/turf/simulated/wall/shuttle/corner/blockwhite/sw
	dir = SOUTH|WEST

/turf/simulated/wall/shuttle/corner/dark
	icon_state = "corner_dark"
	corner_overlay_state = "corner_dark"
/turf/simulated/wall/shuttle/corner/dark/ne
	dir = NORTH|EAST
/turf/simulated/wall/shuttle/corner/dark/nw
	dir = NORTH|WEST
/turf/simulated/wall/shuttle/corner/dark/se
	dir = SOUTH|EAST
/turf/simulated/wall/shuttle/corner/dark/sw
	dir = SOUTH|WEST

/turf/simulated/wall/shuttle/corner/blockorange
	icon_state = "diagonalWall2"
	corner_overlay_state = "diagonalWall2"
/turf/simulated/wall/shuttle/corner/blockorange/ne
	dir = NORTH|EAST
/turf/simulated/wall/shuttle/corner/blockorange/nw
	dir = NORTH|WEST
/turf/simulated/wall/shuttle/corner/blockorange/se
	dir = SOUTH|EAST
/turf/simulated/wall/shuttle/corner/blockorange/sw
	dir = SOUTH|WEST

/turf/simulated/wall/shuttle/corner/vwall
	icon_state = "corner_vwall"
	corner_overlay_state = "corner_vwall"
/turf/simulated/wall/shuttle/corner/vwall/ne
	dir = NORTH|EAST
/turf/simulated/wall/shuttle/corner/vwall/nw
	dir = NORTH|WEST
/turf/simulated/wall/shuttle/corner/vwall/se
	dir = SOUTH|EAST
/turf/simulated/wall/shuttle/corner/vwall/sw
	dir = SOUTH|WEST

/turf/simulated/wall/shuttle/corner/vwallrounded
	icon_state = "corner_vwall_r"
	corner_overlay_state = "corner_vwall_r"
/turf/simulated/wall/shuttle/corner/vwallrounded/ne
	dir = NORTH|EAST
/turf/simulated/wall/shuttle/corner/vwallrounded/nw
	dir = NORTH|WEST
/turf/simulated/wall/shuttle/corner/vwallrounded/se
	dir = SOUTH|EAST
/turf/simulated/wall/shuttle/corner/vwallrounded/sw
	dir = SOUTH|WEST