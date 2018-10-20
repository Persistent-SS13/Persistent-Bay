
#define allowedOccupants list(/mob/living/carbon/human, /mob/living/silicon/robot, /obj/item/organ/internal/stack)

/obj/machinery/cryopod
	name = "cryogenic freezer"
	desc = "A man-sized pod for entering suspended animation. Takes one minutes to enter stasis."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "body_scanner_0"
	density = 1
	anchored = 1
	dir = WEST
	req_access = core_access_command_programs

	var/network = "default"

	var/tmp/timeEntered = 0
	var/tmp/atom/movable/occupant

/obj/machinery/cryopod/New()
	..()
	GLOB.cryopods |= src
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/cryopod(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
	RefreshParts()

/obj/machinery/cryopod/Destroy()
	for(var/atom/movable/A in InsertedContents())
		A.forceMove(get_turf(src))
	. = ..()

/obj/machinery/cryopod/before_save()
	if(occupant)
		despawnOccupant()
	..()

/obj/machinery/cryopod/attackby(var/obj/item/O, var/mob/user = usr)
	src.add_fingerprint(user)

	if(!req_access_faction)
		to_chat(user, "<span class='notice'>\The [src] hasn't been connected to a faction.</span>")
		return

	if(occupant)
		to_chat(user, "<span class='notice'>\The [src] is in use.</span>")
		return

	if(istype(O, /obj/item/grab))
		var/obj/item/grab/G = O
		if(checkOccupantAllowed(G.affecting))
			user.visible_message("<span class='notice'>\The [user] begins placing \the [G.affecting] into \the [src].</span>", "<span class='notice'>You start placing \the [G.affecting] into \the [src].</span>")
			if(do_after(user, 20, src))
				if(!G || !G.affecting) return
			insertOccupant(G.affecting, user)
			return

	if(istype(O, /obj/item/organ/internal/stack))
		insertOccupant(O, user)
		return

	if(InsertedContents())
		to_chat(user, "<span class='notice'>\The [src] must be emptied of all stored users first.</span>")
		return

	if(default_deconstruction_screwdriver(user, O))
		return

	if(default_deconstruction_crowbar(user, O))
		return

/obj/machinery/cryopod/attack_hand(var/mob/user = usr)
	if(stat)	// If there are any status flags, it shouldn't be opperable
		return

	user.set_machine(src)
	src.add_fingerprint(user)

	if(!ticker)
		return

	var/datum/world_faction/faction = get_faction(req_access_faction)

	var/data[]
	data += "<hr><br><b>Cryopod Control</b></br>"
	data += "This cryopod is [faction ? "connected to " + faction.name : "Not Connected"]<br><hr>"
	if(faction)
		data += "It's cryopod network is set to [network]<br><br>"
		data += "<a href='?src=\ref[src];enter=1'>Enter Pod</a><br>"
		data += "<a href='?src=\ref[src];eject=1'>Eject Occupant</a><br><br>"
		data += "Those authorized can <a href='?src=\ref[src];disconnect=1'>disconnect this pod from the logistics network</a> or <a href='?src=\ref[src];connect_net=1'>connect to a different cryonetwork</a>."
	else
		data += "Those authorized can <a href='?src=\ref[src];connect=1'>connect this pod to a network</a>"

	show_browser(user, data, "window=cryopod")
	onclose(user, "cryopod")

/obj/machinery/cryopod/MouseDrop_T(var/mob/target, var/mob/user)
	if(!CanMouseDrop(target, user))
		return

	if(occupant)
		to_chat(user, "<span class='notice'>\The [src] is in use.</span>")
		return

	if(checkOccupantAllowed(target))
		user.visible_message("<span class='notice'>\The [user] begins placing \the [target] into \the [src].</span>", "<span class='notice'>You start placing \the [target] into \the [src].</span>")
		if(do_after(user, 30, src))
			insertOccupant(target, user)

/obj/machinery/cryopod/OnTopic(var/mob/user = usr, href_list)
	if(href_list["enter"])
		insertOccupant(user, user)
	if(href_list["eject"])
		ejectOccupant()
	if(href_list["connect"])
		req_access_faction = user.GetFaction()
		if(!allowed(user))
			req_access_faction = ""
	if(href_list["disconnect"])
		if(allowed(user))
			req_access_faction = ""
	if(href_list["connect_net"])
		if(allowed(user))
			var/list/choices = get_faction(req_access_faction).cryo_networks.Copy()
			choices |= "default"
			var/choice = input(usr,"Choose which cryo network [src] should use.","Choose Cryo-net",null) as null|anything in choices
			if(choice)
				network = choice

/obj/machinery/cryopod/Process()
	if(occupant)
		if(world.time - timeEntered >= 1 MINUTE)
			despawnOccupant()

/obj/machinery/cryopod/verb/EjectPod()
	set name = "Eject Pod"
	set category = "Object"
	set src in oview(1)

	if(usr.stat)
		return

	ejectOccupant()

/obj/machinery/cryopod/verb/EnterPod()
	set name = "Enter Pod"
	set category = "Object"
	set src in oview(1)

	if(usr.stat)
		return

	if(checkOccupantAllowed(usr))
		visible_message("[usr] starts climbing into \the [src].", 3)
		if(do_after(usr, 20, src))
			insertOccupant(usr, usr)

/obj/machinery/cryopod/proc/checkOccupantAllowed(var/atom/A)
	for(var/type in allowedOccupants)
		if(istype(A, type))
			return 1
	return 0


/obj/machinery/cryopod/proc/insertOccupant(var/atom/movable/A, var/mob/user = usr)
	if(!req_access_faction)
		to_chat(user, "<span class='notice'>\The [src] hasn't been connected to a faction.</span>")
		return 0

	if(occupant)
		to_chat(user, "<span class='notice'>\The [src] is in use.</span>")
		return 0

	if(!checkOccupantAllowed(A))
		to_chat(user, "<span class='notice'>\The [A] cannot be inserted into \the [src].</span>")
		return 0

	var/mob/M
	if(istype(A, /mob))
		M = A
		if(M.buckled)
			to_chat(user, "<span class='warning'>Unbuckle the subject before attempting to move them.</span>")
			return 0

		src.add_fingerprint(M)
		M.stop_pulling()
		to_chat(M, "<span class='notice'><b>Simply wait one full minute to be sent back to the lobby where you can switch characters.</b></span>")

	if(istype(A, /obj/item/organ/internal/stack))
		var/obj/item/organ/internal/stack/S = A
		if(!S.lacemob)
			to_chat(user, "<span class='notice'>\The [S] is inert.</span>")
			return 0
		M = S.lacemob
		user.drop_from_inventory(A)

	name = "[initial(name)] ([M.real_name])"
	icon_state = "body_scanner_1"

	occupant = A
	A.forceMove(src)
	timeEntered = world.time

	src.add_fingerprint(user)

/obj/machinery/cryopod/proc/ejectOccupant()
	name = initial(name)
	icon_state = initial(icon_state)

	if(occupant)
		occupant.forceMove(get_turf(src))
		occupant = null

/obj/machinery/cryopod/proc/despawnOccupant(var/autocryo = 0)
	if(!occupant)
		return 0

	var/mob/new_player/player = new(locate(100,100,51))
	var/mob/character
	var/key
	var/name = ""
	var/dir = 0

	if(istype(occupant, /obj/item/organ/internal/stack))
		var/obj/item/organ/internal/stack/S = occupant
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

	else
		var/mob/M = occupant
		if(M.ckey)
			M.stored_ckey = M.ckey
			key = M.ckey
			player.ckey = M.ckey
		else
			key = M.stored_ckey
			player.ckey = M.stored_ckey
		name = M.real_name
		character = M
		dir = M.save_slot
		if(!autocryo)
			M.spawn_loc = req_access_faction
			M.spawn_loc_2 = network
			M.spawn_type = 1
			M.loc = null

	key = copytext(key, max(findtext(key, "@"), 1))

	if(!dir)
		log_and_message_admins("Warning! [key]'s [occupant] failed to find a save_slot, and is picking one!")
		for(var/file in flist(load_path(key, "")))
			var/firstNumber = text2num(copytext(file, 1, 2))
			if(firstNumber)
				var/storedName = CharacterName(firstNumber, key)
				if(storedName == name)
					dir = firstNumber
					log_and_message_admins("[key]'s [occupant] found a savefile with it's realname [file]")
					break
		if(!dir)
			dir++
			while(fexists(load_path(key, "[dir].sav")))
				dir++


	var/savefile/F = new(load_path(key, "[dir].sav"))
	to_file(F["name"], name)
	to_file(F["mob"], character)

	src.name = initial(src.name)
	icon_state = initial(icon_state)
	occupant.loc = null
	QDEL_NULL(occupant)

#undef allowedOccupants