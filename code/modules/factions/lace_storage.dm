

/obj/machinery/lace_storage
	name = "Lace Storage"
	desc = "Home to those who departed to their better selves."
	anchored = 1
	density = 1
	icon = 'icons/obj/machines/dock_beacon.dmi'
	icon_state = "unpowered2"
	use_power = 0			//1 = idle, 2 = active
	var/network = "default"

/obj/machinery/lace_storage/New()
	. = ..()
	GLOB.lace_storages |= src


/obj/machinery/lace_storage/before_save()
	for (var/obj/item/organ/internal/stack/S in contents)
		DespawnLace(S)
	..()

/obj/machinery/lace_storage/attackby(var/obj/item/O, var/mob/user = usr)

	if (istype(O, /obj/item/weapon/card/id)||istype(O, /obj/item/device/pda))			// trying to unlock the interface with an ID card
		if(!req_access_faction)
			var/obj/item/weapon/card/id/id
			if(istype(O, /obj/item/weapon/card/id))
				id = O
			else if(istype(O, /obj/item/device/pda))
				var/obj/item/device/pda/pda = O
				id = pda.id
			if(id)
				var/datum/world_faction/faction = get_faction(id.selected_faction)
				if(faction)
					req_access_faction = id.selected_faction
					to_chat(user, SPAN_NOTICE("\The [src] has been connected to your organization.") )
				else
					to_chat(user, SPAN_WARNING("Access Denied.") )

	if(!req_access_faction)
		to_chat(user, "<span class='notice'>\The [src] hasn't been connected to a organization.</span>")
		return
	if(istype(O, /obj/item/organ/internal/stack))
		InsertLace(O, user)
		return

/obj/machinery/lace_storage/interact(mob/user)
	if (!user)
		return
	attack_hand(user)

/obj/machinery/lace_storage/attack_hand(var/mob/user = usr)
	if(stat)	// If there are any status flags, it shouldn't be opperable
		return

	user.set_machine(src)
	src.add_fingerprint(user)

	var/datum/world_faction/faction = get_faction(req_access_faction)

	var/data[]
	data += "<hr><br><b>Lace Storage Control</b></br>"
	data += "This Lace Storage is [faction ? "connected to " + faction.name : "Not Connected"]<br><hr>"
	if(faction)
		data += "It's lace storage network is set to [network]<br><br>"
		data += "<a href='?src=\ref[src];enter=1'>Enter Pod</a><br>"
		data += "<a href='?src=\ref[src];eject=1'>Eject Occupant</a><br><br>"
		data += "Those authorized can <a href='?src=\ref[src];disconnect=1'>disconnect this pod from the logistics network</a> or <a href='?src=\ref[src];connect_net=1'>connect to a different cryonetwork</a>."
	else
		data += "Those authorized can connect this lace storage using an ID on it.</a>"

	show_browser(user, data, "window=cryopod")
	onclose(user, "cryopod")

/obj/machinery/lace_storage/OnTopic(var/mob/user = usr, href_list)
	if(href_list["eject"])
		EjectLaces()
	if(href_list["disconnect"])
		if(allowed(user) && req_access_faction)
			var/datum/world_faction/faction = get_faction(req_access_faction)
			req_access_faction = ""
			to_chat(user, SPAN_NOTICE("\The [src] has been disconnected from [faction? faction.name : "ERROR" ] .") )
		else
			to_chat(user, SPAN_WARNING("Access Denied.") )

/obj/machinery/lace_storage/ui_action_click()
	attack_hand(usr)

/obj/machinery/lace_storage/Process()
	if (!use_power || stat)
		return

	for (var/obj/item/organ/internal/stack/S in contents)
		var/mob/living/carbon/lace/mob = S.lacemob
		if (!mob || !istype(mob))
			qdel(S)
			continue
		if (!mob.client)
			DespawnLace(S)
			continue
		/*if (!mob.storage_action)
			mob.storage_action = new(src)
			mob.storage_action.Grant(mob)
			mob.update_action_buttons()*/

/obj/machinery/lace_storage/proc/InsertLace(var/obj/item/organ/internal/stack/S, var/mob/user)
	if (!S)
		return
	if(!S.lacemob)
		to_chat(user, "<span class='notice'>\The [S] is inert.</span>")
		return
	user.drop_from_inventory(S)
	S.forceMove(src)
	to_chat(user, SPAN_NOTICE("You insert \the [S] into \the [src]."))

/obj/machinery/lace_storage/proc/DespawnLace(var/obj/item/organ/internal/stack/S)
	if(!S)
		return 0

	if (!S.lacemob)
		qdel(S)
		return

	var/mob/new_player/player = new(locate(100,100,51))
	var/mob/character
	var/key
	var/name = ""
	var/dir = 0

	if(S.lacemob.ckey)
		S.lacemob.stored_ckey = S.lacemob.ckey
		key = S.lacemob.ckey
		player.ckey = S.lacemob.ckey
	else
		key = S.lacemob.stored_ckey
		player.ckey = S.lacemob.stored_ckey
	name = S.get_owner_name()
	character = S.lacemob
	dir = S.lacemob.save_slot
	S.lacemob.spawn_loc = req_access_faction
	S.lacemob.spawn_loc_2 = network
	S.lacemob.spawn_type = 1
	S.loc = null

	//

	key = copytext(key, max(findtext(key, "@"), 1))

	if(!dir)
		log_and_message_admins("Warning! [key]'s [S] failed to find a save_slot, and is picking one!")
		for(var/file in flist(load_path(key, "")))
			var/firstNumber = text2num(copytext(file, 1, 2))
			if(firstNumber)
				var/storedName = CharacterName(firstNumber, key)
				if(storedName == name)
					dir = firstNumber
					log_and_message_admins("[key]'s [S] found a savefile with it's realname [file]")
					break
		if(!dir)
			dir++
			while(fexists(load_path(key, "[dir].sav")))
				dir++


	var/savefile/F = new(load_path(key, "[dir].sav"))
	to_file(F["name"], name)
	to_file(F["mob"], character)
	if(req_access_faction == "betaquad")
		var/savefile/E = new(beta_path(key, "[dir].sav"))
		to_file(E["name"], name)
		to_file(E["mob"], character)
		to_file(E["records"], Retrieve_Record(name))
	if(req_access_faction == "exiting")
		var/savefile/E = new(beta_path(key, "[dir].sav"))
		to_file(E["name"], name)
		to_file(E["mob"], character)
		to_file(E["records"], Retrieve_Record(name))

	src.name = initial(src.name)
	icon_state = initial(icon_state)
	S.loc = null
	QDEL_NULL(S)

/obj/machinery/lace_storage/proc/EjectLaces()
	var/list/laces = new()
	for (var/obj/item/organ/internal/stack/S in contents)
		laces |= S

	var/obj/item/organ/internal/stack/ejecting = input("Choose a Lace to eject from \The [src]", "[src]") in laces
	if (ejecting)
		EjectLace(ejecting)

/obj/machinery/lace_storage/proc/EjectLace(var/obj/item/organ/internal/stack/ejecting)
	if (! ejecting in contents)
		return
	ejecting.loc = get_turf(src)
	/*if (ejecting.lacemob.storage_action)
		ejecting.lacemob.storage_action.Remove()
		ejecting.lacemob.storage_action = null
	ejecting.lacemob.update_action_buttons()
	*/