/datum/map/nexus
	// Networks that will show up as options in the camera monitor program
	station_networks = list(
		NETWORK_PUBLIC,
		NETWORK_NEXUS,
		NETWORK_NEXUS_SECURITY,
		NETWORK_REFUGEE,
	)

// Networks
/obj/machinery/camera/network/nexus
	network = list(NETWORK_NEXUS)

/obj/machinery/camera/network/nexus_security
	network = list(NETWORK_NEXUS_SECURITY)

/obj/machinery/camera/network/refugee
	network = list(NETWORK_REFUGEE)

/obj/effect/landmark/map_data/nexus
	height = 3

