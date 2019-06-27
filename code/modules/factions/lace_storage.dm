
// This general proc is used to retrieve a lace storage for a matching character, depending on its faction.
/proc/GetLaceStorage(var/mob/living/carbon/lace/character)
	var/returnLoc = null
	for(var/obj/machinery/lace_storage/S in GLOB.lace_storages)
		if(S.req_access_faction == character.spawn_loc || S.req_access_faction == character.container.connected_faction)
			if(S.network == character.spawn_loc_2)
				returnLoc = S
				break
			else
				returnLoc = S
	return returnLoc

// Actual lace_storage code below
/obj/machinery/lace_storage
	name = "Lace Storage"
	desc = "Home to those who departed to their better selves."
	anchored = 1
	density = 1
	icon = 'icons/obj/machines/lace_storage.dmi'
	icon_state = "lace"
	use_power = 2			//1 = idle, 2 = active
	var/network = "default"

/obj/machinery/lace_storage/New()
	. = ..()
	GLOB.lace_storages |= src
	ADD_SAVED_VAR(network)

/obj/machinery/lace_storage/Destroy()
	GLOB.lace_storages -= src
	DespawnAllLaces()
	. = ..()

// Despawn all the laces as we don't really want to save them if they are inside this machine already.
/obj/machinery/lace_storage/before_save()
	DespawnAllLaces()
	..()

/obj/machinery/lace_storage/attackby(var/obj/item/O, var/mob/user = usr)
	// Connecting the machine to the faction by id/pda
	if (O.GetIdCard())
		var/obj/item/weapon/card/id/id = O.GetIdCard()
		if(!req_access_faction)
			if(id)
				var/datum/world_faction/faction = get_faction(id.selected_faction)
				if(faction)
					req_access_faction = id.selected_faction
					to_chat(user, SPAN_NOTICE("\The [src] has been connected to your organization.") )
				else
					to_chat(user, SPAN_WARNING("Access Denied.") )
	// We don't really want to do anything else further if we don't have the machine connected to a faction
	if(!req_access_faction)
		to_chat(user, "<span class='notice'>\The [src] hasn't been connected to a organization.</span>")
		return
	// Inserting a lace item
	if(istype(O, /obj/item/organ/internal/stack))
		InsertLace(O, user)
		return

/obj/machinery/lace_storage/interact(mob/user)
	// When is this even called anymore ?
	if (!user)
		return
	ui_interact(user)

/obj/machinery/lace_storage/attack_hand(var/mob/user = usr)
	if(stat)	// If there are any status flags, it shouldn't be opperable
		return

	user.set_machine(src)
	src.add_fingerprint(user)

	ui_interact(user)

/obj/machinery/lace_storage/Topic(href, href_list)
	switch (href_list["action"])
		// ACTUAL LACE STORAGE CALLS (MADE FROM LIVING MOBS)
		if("eject_lace")
			EjectLaces()
		if("disconnect")
			if(allowed(usr) && req_access_faction)
				var/datum/world_faction/faction = get_faction(req_access_faction)
				req_access_faction = ""
				to_chat(usr, SPAN_NOTICE("\The [src] has been disconnected from [faction? faction.name : "ERROR" ] .") )
			else
				to_chat(usr, SPAN_WARNING("Access Denied.") )
		// LACE ONLY ACTION CALLS (MADE FROM DA DED)
		if ("despawn")
			var/mob/living/carbon/lace/mob = usr
			message_admins("USR = [mob.container]")
			DespawnLace(mob.container)
		if ("ping_insurance")
			// TO-DO
			return 1
	SSnano.update_uis(src)

/obj/machinery/lace_storage/proc/lace_ui_interact(var/mob/user)
	// This proc is called only by the lace's action when inside the machine.
	// Since they dont have hands they need some help right...
	ui_interact(user)

/obj/machinery/lace_storage/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.interactive_state)
	var/list/data = list()

	data["living"] = TRUE

	if (istype(user, /mob/living/carbon/lace))
		data["living"] = FALSE
		data["has_insurance"] = FALSE // NOT YET IMPLEMENTED!
	else
		var/datum/world_faction/faction = get_faction(req_access_faction)
		data["faction"] = faction? faction.name : null

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "lace_storage.tmpl", "[name] UI", 550, 450, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/lace_storage/Process()
	. = ..()
	if (!use_power || stat)
		return

	for (var/obj/item/organ/internal/stack/S in contents)
		var/mob/living/carbon/lace/mob = S.lacemob
		if (!mob || !istype(mob) || mob.perma_dead)
			qdel(S)
			continue
		if (!mob.client)
			DespawnLace(S)
			continue
		if (!mob.tmp_storage_action)
			mob.tmp_storage_action = new(src)
			mob.tmp_storage_action.button_icon = icon
			mob.tmp_storage_action.button_icon_state = icon_state
			mob.tmp_storage_action.Grant(mob)
			mob.update_action_buttons()

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
	// Uses similar code to the despawnOccupant() on cryopods.
	if(!S || !istype(S))
		return 0

	if (!S.lacemob || S.lacemob.perma_dead)
		qdel(S)
		return

	var/mob/new_player/player = new(locate(100,100,51))
	var/mob/character
	var/key
	var/name = ""
	var/lacesaveslot = 0

	if(S.lacemob.ckey)
		S.lacemob.stored_ckey = S.lacemob.ckey
		key = S.lacemob.ckey
		player.ckey = S.lacemob.ckey
	else
		key = S.lacemob.stored_ckey
		player.ckey = S.lacemob.stored_ckey
	name = S.get_owner_name()
	character = S.lacemob
	lacesaveslot = S.lacemob.save_slot
	S.lacemob.spawn_loc = req_access_faction
	S.lacemob.spawn_loc_2 = network
	S.lacemob.spawn_type = CHARACTER_SPAWN_TYPE_LACE_STORAGE
	S.loc = null

	//
	key = copytext(key, max(findtext(key, "@"), 1))
	if(!lacesaveslot)
		lacesaveslot = SScharacter_setup.find_character_save_slot(character, key)
	SScharacter_setup.save_character(lacesaveslot, key, character)
	if(req_access_faction == "betaquad")
		var/savefile/E = new(beta_path(key, "[lacesaveslot].sav"))
		to_file(E["name"], name)
		to_file(E["mob"], character)
		to_file(E["records"], Retrieve_Record(name))
	if(req_access_faction == "exiting")
		var/savefile/E = new(beta_path(key, "[lacesaveslot].sav"))
		to_file(E["name"], name)
		to_file(E["mob"], character)
		to_file(E["records"], Retrieve_Record(name))

	src.name = initial(src.name)
	icon_state = initial(icon_state)
	S.loc = null
	QDEL_NULL(S)

/obj/machinery/lace_storage/proc/DespawnAllLaces()
	for (var/obj/item/organ/internal/stack/S in contents)
		DespawnLace(S)

/obj/machinery/lace_storage/proc/EjectLaces()
	var/list/laces = new()
	for (var/obj/item/organ/internal/stack/S in contents)
		laces |= S

	var/obj/item/organ/internal/stack/ejecting = input("Choose a Lace to eject from \The [src]", "[src]", null) in laces
	if (ejecting)
		EjectLace(ejecting)

/obj/machinery/lace_storage/proc/EjectLace(var/obj/item/organ/internal/stack/ejecting)
	if (! ejecting in contents)
		return
	ejecting.loc = get_turf(src)
	if (ejecting.lacemob.tmp_storage_action)
		ejecting.lacemob.tmp_storage_action.Remove(ejecting.lacemob)
		QDEL_NULL(ejecting.lacemob.tmp_storage_action)
	ejecting.lacemob.update_action_buttons()