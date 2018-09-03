/obj/structure/frontier_beacon
	name = "Frontier Beacon"
	desc = "A huge bluespace beacon. The technology is unlike anything you've ever seen, but its apparent that this recieves teleportation signals from the gateway outside the frontier."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "frontier_beacon"
	anchored = 1
	density = 0

/obj/structure/frontier_beacon/New()
	..()
	GLOB.frontierbeacons |= src