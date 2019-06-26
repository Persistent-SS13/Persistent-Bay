/obj/machinery/cryopod
	name = "cryogenic freezer"
	desc = "A man-sized pod for entering suspended animation. Takes one minutes to enter stasis."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "cryopod_open"
	density = 1
	anchored = 1
	dir = WEST
	req_access = core_access_command_programs
	circuit_type = /obj/item/weapon/circuitboard/cryopod

	var/base_icon_state = "cryopod_open"
	var/occupied_icon_state = "cryopod_closed"
	var/on_store_message = "has entered cryo sleep."
	var/on_store_name = "Cryogenic Oversight"
	var/on_enter_occupant_message = "You feel cool air surround you. You go numb as your senses turn inward."
	var/allow_occupant_types = list(/mob/living/carbon/human, /mob/living/silicon/robot, /obj/item/organ/internal/stack)
	var/disallow_occupant_types = list()

	var/network = "default"
	var/tmp/time_entered = 0
	var/time_till_despawn = 60 SECONDS
	var/tmp/atom/movable/occupant
	var/obj/item/device/radio/intercom/announce
	var/obj/machinery/computer/cryopod/control_computer
	var/tmp/last_no_computer_message = 0
	var/applies_stasis = 1

	// These items are preserved when the process() despawn proc occurs.
	var/list/preserve_items = list(
		// /obj/item/integrated_circuit/manipulation/bluespace_rift,
		// /obj/item/integrated_circuit/input/teleporter_locator,
		// /obj/item/weapon/card/id/captains_spare,
		/obj/item/weapon/aicard,
		// /obj/item/device/mmi,
		///obj/item/device/paicard,
		// /obj/item/weapon/gun,
		// /obj/item/weapon/pinpointer,
		// /obj/item/clothing/suit,
		// /obj/item/clothing/shoes/magboots,
		///obj/item/blueprints,
		// /obj/item/clothing/head/helmet/space,
		// /obj/item/weapon/storage/internal
	)

/obj/machinery/cryopod/New()
	..()
	GLOB.cryopods |= src
	ADD_SAVED_VAR(announce)
	ADD_SAVED_VAR(network)

/obj/machinery/cryopod/Initialize(mapload, d)
	. = ..()
	find_control_computer()

/obj/machinery/cryopod/SetupParts()
	announce = new /obj/item/device/radio/intercom(src)
	LAZYADD(component_parts, new /obj/item/weapon/stock_parts/matter_bin(src))
	LAZYADD(component_parts, new /obj/item/weapon/stock_parts/scanning_module(src))
	LAZYADD(component_parts, new /obj/item/weapon/stock_parts/console_screen(src))
	. = ..()

/obj/machinery/cryopod/Destroy()
	if(announce)
		QDEL_NULL(announce)
	if(occupant)
		var/mob/living/ocmob = occupant
		occupant.forceMove(loc)
		if(ocmob)
			ocmob.resting = 1
	for(var/atom/movable/A in InsertedContents())
		A.forceMove(get_turf(src))
	GLOB.cryopods -= src
	. = ..()

/obj/machinery/cryopod/before_save()
	if(occupant)
		despawn_occupant()
	..()

/obj/machinery/cryopod/proc/find_control_computer(urgent=0)
	// Workaround for http://www.byond.com/forum/?post=2007448
	for(var/obj/machinery/computer/cryopod/C in get_area(src))
		control_computer = C
		break
	// Don't send messages unless we *need* the computer, and less than five minutes have passed since last time we messaged
	if(!control_computer && urgent && last_no_computer_message + 5*60*10 < world.time)
		log_admin("Cryopod in [src.loc.loc] could not find control computer!")
		message_admins("Cryopod in [src.loc.loc] could not find control computer!")
		last_no_computer_message = world.time

	return control_computer != null

/obj/machinery/cryopod/proc/check_occupant_allowed(mob/M)
	var/correct_type = 0
	for(var/type in allow_occupant_types)
		if(istype(M, type))
			correct_type = 1
			break

	if(!correct_type) return 0

	for(var/type in disallow_occupant_types)
		if(istype(M, type))
			return 0

	return 1

//Lifted from Unity stasis.dm and refactored. ~Zuhayr
/obj/machinery/cryopod/Process()
	if(occupant)
		if(applies_stasis && iscarbon(occupant))
			var/mob/living/carbon/C = occupant
			C.SetStasis(2)

		//Allow a one minute gap between entering the pod and actually despawning.
		if ((world.time - time_entered) < time_till_despawn)
			return

		var/mob/M = occupant
		if(M && !M.is_dead()) //Occupant is living
			if(!control_computer)
				if(!find_control_computer())
					log_debug("[src] \ref[src] ([x], [y], [z]): No control computer, skipping advanced stuff.")

			despawn_occupant()

/obj/machinery/cryopod/attackby(var/obj/item/O, var/mob/user = usr)
	src.add_fingerprint(user)
	if(!req_access_faction)
		to_chat(user, "<span class='notice'>\The [src] hasn't been connected to an organization.</span>")
		return
	if(occupant)
		to_chat(user, "<span class='notice'>\The [src] is in use.</span>")
		return
	if(istype(O, /obj/item/grab))
		var/obj/item/grab/G = O
		if(check_occupant_allowed(G.affecting))
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

	if(check_occupant_allowed(target))
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

/obj/machinery/cryopod/examine(mob/user)
	. = ..()
	if (. && occupant && user.Adjacent(src))
		occupant.examine(user)

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

	if(check_occupant_allowed(usr))
		visible_message("[usr] starts climbing into \the [src].", 3)
		if(do_after(usr, 20, src))
			insertOccupant(usr, usr)

/obj/machinery/cryopod/proc/insertOccupant(var/atom/movable/A, var/mob/user = usr)
	if(!req_access_faction)
		to_chat(user, "<span class='notice'>\The [src] hasn't been connected to an organization.</span>")
		return 0

	if(occupant)
		to_chat(user, "<span class='notice'>\The [src] is in use.</span>")
		return 0

	if(!check_occupant_allowed(A))
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
	icon_state = "cryopod_closed"

	occupant = A
	A.forceMove(src)
	time_entered = world.time

	src.add_fingerprint(user)

/obj/machinery/cryopod/proc/ejectOccupant()
	name = initial(name)
	icon_state = initial(icon_state)

	if(occupant)
		occupant.forceMove(get_turf(src))
		occupant = null

/obj/machinery/cryopod/proc/despawn_occupant(var/autocryo = 0)
	if(!occupant)
		return 0

	var/mob/character
	var/key
	var/name = ""
	var/saveslot = 0
	var/islace = istype(occupant, /obj/item/organ/internal/stack)
	occupant.should_save = 1
	if(istype(occupant, /obj/item/organ/internal/stack))
		var/obj/item/organ/internal/stack/S = occupant
		if(S.lacemob.ckey)
			S.lacemob.stored_ckey = S.lacemob.ckey
			key = S.lacemob.ckey
		else
			key = S.lacemob.stored_ckey
		name = S.get_owner_name()
		character = S.lacemob
		saveslot = S.lacemob.save_slot
		S.lacemob.spawn_loc = req_access_faction
		S.lacemob.spawn_loc_2 = network
		S.lacemob.spawn_type = CHARACTER_SPAWN_TYPE_CRYONET
		S.loc = null
	else
		var/mob/M = occupant
		if(M.ckey)
			M.stored_ckey = M.ckey
			key = M.ckey
		else
			key = M.stored_ckey
		name = M.real_name
		character = M
		saveslot = M.save_slot
		if(!autocryo)
			M.spawn_loc = req_access_faction
			M.spawn_loc_2 = network
			M.spawn_type = CHARACTER_SPAWN_TYPE_CRYONET
			M.loc = null

	key = copytext(key, max(findtext(key, "@"), 1))

	if(!saveslot)
		saveslot = SScharacter_setup.find_character_save_slot(occupant, key)

	//Ignore all items not on the preservation list.
	var/list/items = occupant.contents.Copy()

	for(var/obj/item/W in items)

		var/preserve = null
		// Snowflaaaake.
		if(istype(W, /obj/item/device/mmi))
			var/obj/item/device/mmi/brain = W
			if(brain.brainmob && brain.brainmob.client && brain.brainmob.key)
				preserve = 1
			else
				continue
		else
			for(var/T in preserve_items)
				if(istype(W,T))
					preserve = 1
					break

		if(preserve)
			if(control_computer)
				control_computer.add_retrievable(W, src)
			else
				W.forceMove(get_turf(src))


	//Update any existing objectives involving this mob.
	for(var/datum/objective/O in all_objectives)
		// We don't want revs to get objectives that aren't for heads of staff. Letting
		// them win or lose based on cryo is silly so we remove the objective.
		if(O.target == character.mind)
			if(O.owner && O.owner.current)
				to_chat(O.owner.current, "<span class='warning'>You get the feeling your target is no longer within your reach...</span>")
			qdel(O)

	//Handle job slot/tater cleanup.
	if(character.mind)
		if(character.mind.assigned_job)
			character.mind.assigned_job.clear_slot()

		if(character.mind.objectives.len)
			character.mind.objectives = null
			character.mind.special_role = null

	// Titles should really be fetched from data records
	//  and records should not be fetched by name as there is no guarantee names are unique
	var/role_alt_title =  (islace)? "LMI" : ((character.mind)? character.mind.role_alt_title : "Unknown")

	if(control_computer)
		control_computer.frozen_crew += "[character.real_name], [role_alt_title] - [stationtime2text()]"
		control_computer._admin_logs += "[key_name(character)] ([role_alt_title]) at [stationtime2text()]"
	log_and_message_admins("[key_name(character)] ([role_alt_title]) entered cryostorage.")

	announce.autosay("[character.real_name] [on_store_message]", "[on_store_name]", character.GetFaction())
	visible_message("<span class='notice'>\The [initial(name)] hums and hisses as it moves [character.real_name] into storage.</span>", 3)

	//Lace retrieval?
	if(islace && control_computer)
		control_computer.add_lace(occupant, src)

	SScharacter_setup.save_character(saveslot, key, character)
	if(req_access_faction == "betaquad")
		var/savefile/E = new(beta_path(key, "[saveslot].sav"))
		to_file(E["name"], name)
		to_file(E["mob"], character)
		to_file(E["records"], Retrieve_Record(name))
	if(req_access_faction == "exiting")
		var/savefile/E = new(beta_path(key, "[saveslot].sav"))
		to_file(E["name"], name)
		to_file(E["mob"], character)
		to_file(E["records"], Retrieve_Record(name))

	SetName(initial(src.name))
	icon_state = base_icon_state
	var/mob/new_player/player = new()
	player.key = key
	QDEL_NULL(occupant)


/*
 * Cryogenic refrigeration unit. Basically a despawner.
 * Stealing a lot of concepts/code from sleepers due to massive laziness.
 * The despawn tick will only fire if it's been more than time_till_despawned ticks
 * since time_entered, which is world.time when the occupant moves in.
 * ~ Zuhayr
 */


//Main cryopod console.

/obj/machinery/computer/cryopod
	name = "cryogenic oversight console"
	desc = "An interface between crew and the cryogenic storage oversight systems."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "cellconsole"
	circuit = /obj/item/weapon/circuitboard/cryopodcontrol
	density = FALSE
	var/mode = null

	//Used for logging people entering cryosleep and important items they are carrying.
	var/list/frozen_crew = list()
	var/list/frozen_items = list()
	var/list/_admin_logs = list() // _ so it shows first in VV

	var/storage_type = "crewmembers"
	var/storage_name = "Cryogenic Oversight Control"
	var/allow_items = TRUE

/obj/machinery/computer/cryopod/robot
	name = "robotic storage console"
	desc = "An interface between crew and the robotic storage systems."
	icon = 'icons/obj/robot_storage.dmi'
	icon_state = "console"
	circuit = /obj/item/weapon/circuitboard/robotstoragecontrol

	storage_type = "cyborgs"
	storage_name = "Robotic Storage Control"
	allow_items = 0

/obj/machinery/computer/cryopod/New()
	..()
	ADD_SAVED_VAR(frozen_items)

	ADD_SKIP_EMPTY(frozen_items)

/obj/machinery/computer/cryopod/after_load()
	. = ..()
	//#FIXME: Since saving the frozen crew list isn't going to be accurate, we really should populate the list by network

/obj/machinery/computer/cryopod/attack_ai()
	src.attack_hand()

/obj/machinery/computer/cryopod/proc/add_retrievable(var/obj/I, var/obj/machinery/cryopod/source)
	if(!allow_items)
		I.forceMove(get_turf(source))
		return
	//Confiscate items that are to be saved
	frozen_items += I
	I.forceMove(null)

/obj/machinery/computer/cryopod/proc/add_lace(var/obj/item/organ/internal/stack/lace, var/obj/machinery/cryopod/source)
	//#TODO if we go ahead with lace retrieval

/obj/machinery/computer/cryopod/attack_hand(mob/user = usr)
	if(stat & (NOPOWER|BROKEN))
		return
	..()

	user.set_machine(src)

	var/dat

	dat += "<hr/><br/><b>[storage_name]</b><br/>"
	dat += "<i>Welcome, [user.real_name].</i><br/><br/><hr/>"
	dat += "<a href='?src=\ref[src];log=1'>View storage log</a>.<br>"
	if(allow_items)
		dat += "<a href='?src=\ref[src];view=1'>View objects</a>.<br>"
		dat += "<a href='?src=\ref[src];item=1'>Recover object</a>.<br>"
		dat += "<a href='?src=\ref[src];allitems=1'>Recover all objects</a>.<br>"

	user << browse(dat, "window=cryopod_console")
	onclose(user, "cryopod_console")

/obj/machinery/computer/cryopod/OnTopic(user, href_list, state)
	if(href_list["log"])
		var/dat = "<b>Recently stored [storage_type]</b><br/><hr/><br/>"
		for(var/person in frozen_crew)
			dat += "[person]<br/>"
		dat += "<hr/>"
		show_browser(user, dat, "window=cryolog")
		. = TOPIC_REFRESH

	else if(href_list["view"])
		if(!allow_items) return

		var/dat = "<b>Recently stored objects</b><br/><hr/><br/>"
		for(var/obj/item/I in frozen_items)
			dat += "[I.name]<br/>"
		dat += "<hr/>"

		show_browser(user, dat, "window=cryoitems")
		. = TOPIC_HANDLED

	else if(href_list["item"])
		if(!allow_items) return

		if(frozen_items.len == 0)
			to_chat(user, "<span class='notice'>There is nothing to recover from storage.</span>")
			return TOPIC_HANDLED

		var/obj/item/I = input(user, "Please choose which object to retrieve.","Object recovery",null) as null|anything in frozen_items
		if(!I || !CanUseTopic(user, state))
			return TOPIC_HANDLED

		if(!(I in frozen_items))
			to_chat(user, "<span class='notice'>\The [I] is no longer in storage.</span>")
			return TOPIC_HANDLED

		visible_message("<span class='notice'>The console beeps happily as it disgorges \the [I].</span>", 3)

		I.dropInto(loc)
		frozen_items -= I
		. = TOPIC_REFRESH

	else if(href_list["allitems"])
		if(!allow_items) return TOPIC_HANDLED

		if(frozen_items.len == 0)
			to_chat(user, "<span class='notice'>There is nothing to recover from storage.</span>")
			return TOPIC_HANDLED

		visible_message("<span class='notice'>The console beeps happily as it disgorges the desired objects.</span>", 3)

		for(var/obj/item/I in frozen_items)
			I.dropInto(loc)
			frozen_items -= I
		. = TOPIC_REFRESH

	attack_hand(user)

/obj/item/weapon/circuitboard/cryopodcontrol
	name = "Circuit board (Cryogenic Oversight Console)"
	build_path = /obj/machinery/computer/cryopod
	origin_tech = list(TECH_DATA = 3)

/obj/item/weapon/circuitboard/robotstoragecontrol
	name = "Circuit board (Robotic Storage Console)"
	build_path = /obj/machinery/computer/cryopod/robot
	origin_tech = list(TECH_DATA = 3)

//Decorative structures to go alongside cryopods.
/obj/structure/cryofeed

	name = "cryogenic feed"
	desc = "A bewildering tangle of machinery and pipes."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "cryo_rear"
	anchored = 1
	dir = WEST

/obj/machinery/cryopod/robot
	name = "robotic storage unit"
	desc = "A storage unit for robots."
	icon = 'icons/obj/robot_storage.dmi'
	icon_state = "pod_0"
	base_icon_state = "pod_0"
	occupied_icon_state = "pod_1"
	on_store_message = "has entered robotic storage."
	on_store_name = "Robotic Storage Oversight"
	on_enter_occupant_message = "The storage unit broadcasts a sleep signal to you. Your systems start to shut down, and you enter low-power mode."
	allow_occupant_types = list(/mob/living/silicon/robot)
	disallow_occupant_types = list(/mob/living/silicon/robot/drone)
	applies_stasis = 0

/obj/machinery/cryopod/lifepod
	name = "life pod"
	desc = "A man-sized pod for entering suspended animation. Dubbed 'cryocoffin' by more cynical spacers, it is pretty barebone, counting on stasis system to keep the victim alive rather than packing extended supply of food or air. Can be ordered with symbols of common religious denominations to be used in space funerals too."
	on_store_name = "Life Pod Oversight"
	time_till_despawn = 20 MINUTES
	icon_state = "redpod0"
	base_icon_state = "redpod0"
	occupied_icon_state = "redpod1"
	var/launched = 0
	var/datum/gas_mixture/airtank

/obj/machinery/cryopod/lifepod/Initialize()
	. = ..()
	airtank = new()
	airtank.temperature = T0C
	airtank.adjust_gas("oxygen", MOLES_O2STANDARD, 0)
	airtank.adjust_gas("nitrogen", MOLES_N2STANDARD)

/obj/machinery/cryopod/lifepod/return_air()
	return airtank

/obj/machinery/cryopod/lifepod/proc/launch()
	launched = 1
	for(var/d in GLOB.cardinal)
		var/turf/T = get_step(src,d)
		var/obj/machinery/door/blast/B = locate() in T
		if(B && B.density)
			B.force_open()
			break

	var/list/possible_locations = list()
	if(GLOB.using_map.use_overmap)
		var/obj/effect/overmap/O = map_sectors["[z]"]
		for(var/obj/effect/overmap/OO in range(O,2))
			if(OO.in_space || istype(OO,/obj/effect/overmap/sector/exoplanet))
				possible_locations |= text2num(level)

	var/newz = GLOB.using_map.get_empty_zlevel()
	if(possible_locations.len && prob(10))
		newz = pick(possible_locations)
	var/turf/nloc = locate(rand(TRANSITIONEDGE, world.maxx-TRANSITIONEDGE), rand(TRANSITIONEDGE, world.maxy-TRANSITIONEDGE),newz)
	if(!istype(nloc, /turf/space))
		explosion(nloc, 1, 2, 3)
	playsound(loc,'sound/effects/rocket.ogg',100)
	forceMove(nloc)

//Don't use these for in-round leaving
/obj/machinery/cryopod/lifepod/Process()
	if(evacuation_controller && evacuation_controller.state >= EVAC_LAUNCHING)
		if(occupant && !launched)
			launch()
		..()
