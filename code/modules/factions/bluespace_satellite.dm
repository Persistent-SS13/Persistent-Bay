/obj/machinery/bluespace_satellite
	name = "bluespace satellite"
	desc = "Can be configured and launched to create a new logistics network."
	anchored = 0
	density = 1
	icon = 'icons/obj/supplybeacon.dmi'
	icon_state = "beacon"

	use_power = 0			//1 = idle, 2 = active
	var/chosen_uid
	var/chosen_name
	var/chosen_short
	var/chosen_password
	var/starting_leader
	var/chosen_netuid

/obj/machinery/bluespace_satellite/New()
	..()


/obj/machinery/bluespace_satellite/attack_hand(var/mob/user as mob)
	ui_interact(user)

/obj/machinery/bluespace_satellite/attackby(var/obj/I as obj, var/mob/user as mob)
	if(istype(I, /obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/id = I
		starting_leader = id.registered_name
		loc.visible_message("The \icon[src] [src] reports that the card was successfully scanned and the leadership has been set to '[starting_leader]'.")
		GLOB.nanomanager.update_uis(src)
		return
	..()

/obj/machinery/bluespace_satellite/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	if(user.stat)
		return

	// this is the data which will be sent to the ui
	var/data[0]
	data["chosen_uid"] = chosen_uid ? chosen_uid : "*UNSET*"
	data["chosen_name"] = chosen_name ? chosen_name : "*UNSET*"
	data["chosen_short"] = chosen_short ? chosen_short : "*UNSET*"
	data["chosen_password"] = chosen_password ? chosen_password : "*UNSET*"
	data["chosen_netuid"] = chosen_netuid ? chosen_netuid : "*UNSET*"
	data["starting_leader"] = starting_leader ? starting_leader : "*UNSET*"

	// update the ui if it exists, returns null if no ui is passed/found
	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "bluespacesatellite.tmpl", "Bluespace Satellite Config", 650, 900)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()


/obj/machinery/bluespace_satellite/Topic(href, href_list)
	if(stat & (NOPOWER|BROKEN))
		return 0 // don't update UIs attached to this object

	if(href_list["change_uid"])
		var/select_name = sanitizeName(input(usr,"Enter a UID for the network","Lognet UID", chosen_uid) as null|text, MAX_NAME_LEN, 1, 0)
		if(select_name)
			if(get_faction(select_name))
				to_chat(usr, "That UID is already in use.")
				return
			else
				chosen_uid = select_name
	if(href_list["change_name"])
		var/select_name = sanitizeName(input(usr,"Enter the full name of your organization","Lognet Full Name", chosen_name) as null|text, MAX_NAME_LEN, 1, 0)
		if(select_name)
			chosen_name = select_name
	if(href_list["change_short"])
		var/select_name = sanitizeName(input(usr,"Enter the short name of your organization","Lognet Short Name", chosen_short) as null|text, MAX_NAME_LEN, 1, 0)
		if(select_name)
			chosen_short = select_name
	if(href_list["change_password"])
		var/select_name = sanitizeName(input(usr,"Enter the lognet password","Lognet Password", chosen_password) as null|text, MAX_NAME_LEN, 1, 0)
		if(select_name)
			chosen_password = select_name
	if(href_list["change_netuid"])
		var/select_name = sanitizeName(input(usr,"Enter the wireless network uid. Spaces are not allowed,","Wireless Network UID", chosen_netuid) as null|text, MAX_NAME_LEN, 1, 0,1)
		if(select_name)
			for(var/datum/world_faction/existing_faction in GLOB.all_world_factions)
				if(existing_faction.network.net_uid == select_name)
					to_chat(usr, "Error! A network with that UID already exists!")
					return 1
			chosen_netuid = select_name
	if(href_list["launch"])
		if(!chosen_uid || !chosen_name || !chosen_short || !chosen_password || !starting_leader || !chosen_netuid)
			to_chat(usr, "Network not configured correctly. Check settings.")
			return 1
		if(get_faction(chosen_uid))
			chosen_uid = null
			to_chat(usr, "Chosen UID was already in use, choose new UID.")
			return 1
		var/turf/space/T = loc
		if(!T || !istype(T))
			to_chat(usr, "The satellite can only be launched from space.")
			return 1
		var/datum/world_faction/new_faction = new()
		GLOB.all_world_factions |= new_faction
		new_faction.uid = chosen_uid
		new_faction.name = chosen_name
		new_faction.abbreviation = chosen_short
		new_faction.password = chosen_password
		new_faction.leader_name = starting_leader
		new_faction.network.invisible = 1
		new_faction.network.net_uid = chosen_netuid
		var/obj/effect/portal/portal = new(loc)
		loc.visible_message("The \icon[src] [src] beams away!.")
		sleep(1 SECOND)
		playsound(src,'sound/effects/teleport.ogg',100,1)
		portal.loc = null
		qdel(portal)
		loc = null
		qdel(src)
		
	add_fingerprint(usr)
	return 1 // update UIs attached to this object
