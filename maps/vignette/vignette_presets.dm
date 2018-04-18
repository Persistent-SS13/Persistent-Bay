var/const/NETWORK_PUBLIC      = "Public"
var/const/NETWORK_NT      	  = "nt_net"
var/const/NETWORK_REFUGEE     = "freenet"

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