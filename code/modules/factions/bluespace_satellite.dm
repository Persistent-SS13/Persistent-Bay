

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
	var/chosen_tag
	var/chosen_password
	var/starting_leader
	var/chosen_netuid
	var/list/pending_contracts = list()
	var/list/signed_contracts = list()

/obj/machinery/bluespace_satellite/New()
	..()

/obj/machinery/bluespace_satellite/proc/cancel_contracts()
	for(var/obj/item/weapon/paper/contract/contract in pending_contracts)
		contract.cancel()
	for(var/obj/item/weapon/paper/contract/contract in signed_contracts)
		contract.cancel()

/obj/machinery/bluespace_satellite/proc/get_contributed()
	var/contributed = 0
	for(var/obj/item/weapon/paper/contract/contract in signed_contracts)
		contributed += contract.required_cash
	return contributed

/obj/machinery/bluespace_satellite/contract_signed(var/obj/item/weapon/paper/contract/contract)
	pending_contracts -= contract
	signed_contracts |= contract
	SSnano.update_uis(src)
	return 1

/obj/machinery/bluespace_satellite/contract_cancelled(var/obj/item/weapon/paper/contract/contract)
	pending_contracts -= contract
	signed_contracts -= contract
	SSnano.update_uis(src)
	return 1



/obj/machinery/bluespace_satellite/attack_hand(var/mob/user as mob)
	ui_interact(user)


/obj/machinery/bluespace_satellite/attackby(var/obj/I as obj, var/mob/user as mob)
	if(istype(I, /obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/id = I
		starting_leader = id.registered_name
		cancel_contracts()
		loc.visible_message("The \icon[src] [src] reports that the card was successfully scanned and the leadership has been set to '[starting_leader]'.")
		SSnano.update_uis(src)
		return
	..()


/obj/machinery/bluespace_satellite/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)


	// this is the data which will be sent to the ui
	var/data[0]
	data["chosen_uid"] = chosen_uid ? chosen_uid : "*UNSET*"
	data["chosen_name"] = chosen_name ? chosen_name : "*UNSET*"
	data["chosen_short"] = chosen_short ? chosen_short : "*UNSET*"
	data["chosen_tag"] = chosen_tag ? chosen_tag : "*UNSET*"
	data["chosen_password"] = chosen_password ? chosen_password : "*UNSET*"
	data["chosen_netuid"] = chosen_netuid ? chosen_netuid : "*UNSET*"
	data["starting_leader"] = starting_leader ? starting_leader : "*UNSET*"

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
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
				cancel_contracts()
	if(href_list["change_name"])
		var/select_name = sanitizeName(input(usr,"Enter the full name of your organization","Lognet Full Name", chosen_name) as null|text, MAX_NAME_LEN, 1, 0)
		if(select_name)
			chosen_name = select_name
			cancel_contracts()
	if(href_list["change_short"])
		var/select_name = sanitizeName(input(usr,"Enter the short name of your organization","Lognet Short Name", chosen_short) as null|text, MAX_NAME_LEN, 1, 0)
		if(select_name)
			chosen_short = select_name
	if(href_list["change_tag"])
		var/select_name = sanitizeName(input(usr,"Enter the tag of your organization","Lognet Tag Name", chosen_tag) as null|text, 4, 1, 0)
		if(select_name)
			for(var/datum/world_faction/fac in GLOB.all_world_factions)
				if(fac.short_tag == select_name)
					to_chat(usr, "That Tag is already in use.")
					return
				else
					chosen_tag = select_name
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

	if(href_list["contract"])
		if(!chosen_name || chosen_name == "")
			to_chat(usr, "A name for the network must be chosen first.")
			return
		if(!starting_leader)
			to_chat(usr, "A leader for the network must be chosen first.")
			return
		if(!chosen_uid)
			to_chat(usr, "A UID for the network must be chosen first.")
			return

		var/cost = round(input("How much ethericoin should be the funding contract be for?", "Funding", 25000-get_contributed()) as null|num)
		if(!cost || cost < 0)
			return 0
		var/choice = input(usr,"This will create a funding contract for [cost] ethericoin.") in list("Confirm", "Cancel")
		if(choice == "Confirm")
			var/obj/item/weapon/paper/contract/contract = new()
			contract.required_cash = cost
			contract.linked = src
			contract.purpose = "Funding contract for [cost]$$ to [chosen_name] ([chosen_uid]) led by [starting_leader]."
			contract.name = "[chosen_name] funding contract"
			var/t = ""
			t += "<font face='Verdana' color=blue><table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'><center></td><tr><td><H1>Investment Contract</td>"
			t += "<tr><td><br><b>For:</b>[chosen_name] ([chosen_uid]) led by [starting_leader]<br>"
			t += "<b>Cost:</b> [cost] $$ Ethericoins<br><br>"
			t += "<tr><td><h3>Status</H3>*Unsigned*<br></td></tr></table><br><table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>"
			t += "<td><font size='4'><b>Swipe ID to sign contract.</b></font></center></font>"
			contract.info = t
			contract.loc = get_turf(src)
			contract.update_icon()
			pending_contracts |= contract
			playsound(get_turf(src), pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 75, 1, -3)


	if(href_list["launch"])
		if(!chosen_uid || !chosen_name || !chosen_short || !chosen_tag || !chosen_password || !starting_leader || !chosen_netuid)
			to_chat(usr, "Network not configured correctly. Check settings.")
			return 1
		if(get_contributed() < 25000)
			to_chat(usr, "25000$ needs to be committed in order to proceed.")

		if(get_faction(chosen_uid))
			chosen_uid = null
			to_chat(usr, "Chosen UID was already in use, choose new UID.")
			return 1
		var/turf/space/T = loc
		if(!T || !istype(T))
			to_chat(usr, "The satellite can only be launched from space.")
			return 1
		for(var/obj/item/weapon/paper/contract/contract in signed_contracts)
			if(!contract.is_solvent())
				contract.cancel()
				SSnano.update_uis(src)
				return 0
		for(var/obj/item/weapon/paper/contract/contract in signed_contracts)
			contract.finalize()
			signed_contracts -= contract
		var/datum/world_faction/new_faction = new()
		LAZYDISTINCTADD(GLOB.all_world_factions, new_faction)
		new_faction.uid = chosen_uid
		new_faction.name = chosen_name
		new_faction.abbreviation = chosen_short
		new_faction.short_tag = chosen_tag
		new_faction.password = chosen_password
		new_faction.leader_name = starting_leader
		new_faction.network.invisible = 1
		new_faction.network.net_uid = chosen_netuid
		new_faction.network.name = chosen_netuid
		cancel_contracts()
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

