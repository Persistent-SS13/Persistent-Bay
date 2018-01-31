/obj/machinery/computer/faction_core
	name = "Logistics Core Computer"
	icon_keyboard = "rd_key"
	icon_screen = "rdcomp"
	light_color = "#a97faa"
	circuit = /obj/item/weapon/circuitboard/rdconsole
	var/screen = 1.0	//Which screen is currently showing.
	var/faction_uid = ""
	var/faction_password = ""
	var/attempted_password = ""
	var/datum/world_faction/connected_faction
	var/connected = 0
	
/obj/machinery/computer/faction_core/proc/connect_to()
	connected_faction = get_faction(faction_uid)
	if(!connected_faction || connected_faction.password != faction_password) return 0
	connected = 1
	
/obj/machinery/computer/faction_core/proc/disconnect()
	faction_uid = ""
	faction_password = ""
	connected_faction = null
	connected = 0