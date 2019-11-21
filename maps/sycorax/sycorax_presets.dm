/datum/map/sycorax
	// Networks that will show up as options in the camera monitor program
	station_networks = list(
		NETWORK_PUBLIC,
		NETWORK_SYCORAX,
		NETWORK_SYCORAX_SECURITY,
		NETWORK_REFUGEE,
	)

// Networks
/obj/machinery/camera/network/sycorax
	network = list(NETWORK_SYCORAX)

/obj/machinery/camera/network/sycorax_security
	network = list(NETWORK_SYCORAX_SECURITY)

/obj/machinery/camera/network/refugee
	network = list(NETWORK_REFUGEE)

/obj/effect/landmark/map_data/sycorax
	height = 1