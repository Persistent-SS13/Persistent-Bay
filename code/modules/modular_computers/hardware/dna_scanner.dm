/obj/item/weapon/computer_hardware/dna_scanner
	name = "Dna Scanner"
	desc = "Scanning hardware that allows organs and full-bodied samples to be scanned to the computer."
	power_usage = 30 //W
	critical = 0
	icon_state = "cardreader"
	hardware_size = 1
	origin_tech = list(TECH_DATA = 2)

	var/datum/dna/stored_dna = null
	var/list/connected_pods = list()
	
/obj/item/weapon/computer_hardware/dna_scanner/Destroy()
	if(holder2 && (holder2.dna_scanner == src))
		holder2.dna_scanner = null
	holder2 = null
	return ..()