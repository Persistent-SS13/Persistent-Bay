/datum/map/vignette
	// Networks that will show up as options in the camera monitor program
	station_networks = list(
		NETWORK_PUBLIC,
		NETWORK_NT,
		NETWORK_REFUGEE,
	)

// Networks
/obj/machinery/camera/network/nt
	network = list(NETWORK_NT)

/obj/machinery/camera/network/refugee
	network = list(NETWORK_REFUGEE)

/obj/effect/landmark/map_data/vignette
	height = 2

