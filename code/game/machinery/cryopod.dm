
GLOBAL_LIST_EMPTY(all_cryo_mobs)
/*
 * Cryogenic refrigeration unit. Basically a despawner.
 */

//Main cryopod console.

/obj/machinery/computer/cryopod
	name = "cryogenic oversight console"
	desc = "An interface between crew and the cryogenic storage oversight systems."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "cellconsole"
	circuit = /obj/item/weapon/circuitboard/cryopodcontrol
	density = 0
	interact_offline = 1

	//Used for logging people entering cryosleep and important items they are carrying.
	var/list/frozen_crew = list()
	var/list/_admin_logs = list() // _ so it shows first in VV

	var/storage_type = "crewmembers"
	var/storage_name = "Cryogenic Oversight Control"
	var/allow_items = 1


/obj/machinery/computer/cryopod/robot
	name = "robotic storage console"
	desc = "An interface between crew and the robotic storage systems."
	icon = 'icons/obj/robot_storage.dmi'
	icon_state = "console"
	circuit = /obj/item/weapon/circuitboard/robotstoragecontrol

	storage_type = "cyborgs"
	storage_name = "Robotic Storage Control"
	allow_items = 0


/obj/machinery/computer/cryopod/attack_ai()
	src.attack_hand()


/obj/machinery/computer/cryopod/attack_hand(mob/user = usr)
	if(stat & (NOPOWER|BROKEN))
		return

	user.set_machine(src)
	src.add_fingerprint(usr)

	var/dat

	if (!( ticker ))
		return

	dat += "<hr/><br/><b>[storage_name]</b><br/>"
	dat += "<i>Welcome, [user.real_name].</i><br/><br/><hr/>"
	dat += "<a href='?src=\ref[src];log=1'>View storage log</a>.<br>"

	user << browse(dat, "window=cryopod_console")
	onclose(user, "cryopod_console")


/obj/machinery/computer/cryopod/Topic(href, href_list)
	if((. = ..()))
		return

	var/mob/user = usr

	src.add_fingerprint(user)

	if(href_list["log"])

		var/dat = "<b>Recently stored [storage_type]</b><br/><hr/><br/>"
		for(var/person in frozen_crew)
			dat += "[person]<br/>"
		dat += "<hr/>"

		user << browse(dat, "window=cryolog")

	src.updateUsrDialog()
	return


/obj/item/weapon/circuitboard/cryopodcontrol
	name = "Circuit board (Cryogenic Oversight Console)"
	build_path = /obj/machinery/computer/cryopod
	origin_tech = list(TECH_DATA = 3)


/obj/item/weapon/circuitboard/robotstoragecontrol
	name = "Circuit board (Robotic Storage Console)"
	build_path = /obj/machinery/computer/cryopod/robot
	origin_tech = list(TECH_DATA = 3)

//Cryopods themselves.

/obj/machinery/cryopod
	name = "cryogenic freezer"
	desc = "A man-sized pod for entering suspended animation. Takes three minutes to enter stasis."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "body_scanner_0"
	density = 1
	anchored = 1
	dir = WEST

	var/base_icon_state = "body_scanner_0"
	var/occupied_icon_state = "body_scanner_1"
	var/on_store_message = "has entered long-term storage."
	var/on_store_name = "Cryogenic Oversight"
	var/on_enter_occupant_message = "You feel cool air surround you. You go numb as your senses turn inward."
	var/allow_occupant_types = list(/mob/living/carbon/human)
	var/disallow_occupant_types = list()

	var/mob/occupant = null       // Person waiting to be despawned.
	var/time_till_despawn = 1 MINUTE  // 3 minutes till despawn
	var/time_entered = 0          // Used to keep track of the safe period.
	var/obj/item/device/radio/intercom/announce //

	var/obj/machinery/computer/cryopod/control_computer
	var/last_no_computer_message = 0
	var/super_locked = 1
	req_access = list(core_access_command_programs)
	var/datum/world_faction/faction

/obj/machinery/cryopod/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/cryopod(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
	RefreshParts()

/obj/machinery/cryopod/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(!occupant)
		if(default_deconstruction_screwdriver(user, O))
			return
		if(default_deconstruction_crowbar(user, O))
			return
	..()

/obj/machinery/cryopod/attack_hand(mob/user = usr)
	if(stat & (NOPOWER|BROKEN))
		return

	user.set_machine(src)
	src.add_fingerprint(usr)

	var/dat

	if (!( ticker ))
		return
	if(req_access_faction && req_access_faction != "" || (faction && faction.uid != req_access_faction))
		faction = get_faction(req_access_faction)
	dat += "<hr/><br/><b>Cryopod Control</b><br/>"
	dat += "This cryopod is connected to: [faction ? faction.name : "Not connected"]<br/><br/><hr/>"
	if(faction)
		dat += "<a href='?src=\ref[src];enter=1'>Enter pod</a><br><a href='?src=\ref[src];eject=1'>Eject Occupant</a><br><br>"
		dat += "Those authorized can <a href='?src=\ref[src];disconnect=1'>disconnect this pod from the network</a>"
	else
		dat += "Those authorized can <a href='?src=\ref[src];connect=1'>connect this pod to a network</a>"

	user << browse(dat, "window=cryopod")
	onclose(user, "cryopod")

/obj/machinery/cryopod/MouseDrop_T(var/mob/target, var/mob/user)
	if(!istype(target))
		return
	if (!CanMouseDrop(target, user))
		return
	if (src.occupant)
		to_chat(user, "<span class='warning'>The cryopod is already occupied!</span>")
		return
	if (target.buckled)
		to_chat(user, "<span class='warning'>Unbuckle the subject before attempting to move them.</span>")
		return
	if(!req_access_faction || req_access_faction == "")
		to_chat(usr, "<span class='notice'><B>\The [src] is not connected to a network.</B></span>")
		return
	if(!check_occupant_allowed(target))
		return
	user.visible_message("<span class='notice'>\The [user] begins placing \the [target] into \the [src].</span>", "<span class='notice'>You start placing \the [target] into \the [src].</span>")
	if(!do_after(user, 30, src))
		return
	if(src.occupant)
		to_chat(usr, "<span class='notice'><B>\The [src] is in use.</B></span>")
		return
	target.stop_pulling()
	if(target.client)
		target.client.perspective = EYE_PERSPECTIVE
		target.client.eye = src
	target.forceMove(src)
	set_occupant(target)
	icon_state = occupied_icon_state
	target.spawn_loc = req_access_faction
	to_chat(target, "<span class='notice'>[on_enter_occupant_message]</span>")
	to_chat(target, "<span class='notice'><b>Simply wait one full minute to be sent back to the lobby where you can switch characters.</b></span>")
	time_entered = world.time
	src.add_fingerprint(user)



/obj/machinery/cryopod/Topic(href, href_list)
	if((. = ..()))
		return

	var/mob/user = usr

	src.add_fingerprint(user)

	if(href_list["enter"])
		if(faction)
			move_inside_proc(usr)
	if(href_list["eject"])
		eject_proc(usr)
	if(href_list["disconnect"])
		if(allowed(usr))
			faction = null
			req_access_faction = null
	if(href_list["connect"])
		faction = get_faction(usr.GetFaction())
		if(faction)
			req_access_faction = faction.uid
			if(!allowed(usr))
				faction = null
				req_access_faction = ""
			else
				req_access_faction = faction.uid
	src.updateUsrDialog()
	return


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



/obj/machinery/cryopod/New()
	GLOB.cryopods |= src
	announce = new /obj/item/device/radio/intercom(src)
	..()


/obj/machinery/cryopod/Destroy()
	if(occupant)
		occupant.forceMove(loc)
		occupant.resting = 1
	return ..()


/obj/machinery/cryopod/Initialize()
	. = ..()
	find_control_computer()


/obj/machinery/cryopod/after_load()
	find_control_computer()


/obj/machinery/cryopod/proc/find_control_computer()
	var/turf/T = src.loc
	if(!T)
		return

	for(var/obj/machinery/computer/cryopod/C in T.loc)
		control_computer = C
		break

	return control_computer != null


/obj/machinery/cryopod/proc/check_occupant_allowed(mob/M)
	var/correct_type = 0
	for(var/type in allow_occupant_types)
		if(istype(M, type))
			correct_type = 1
			break

	if(!correct_type)
		return 0

	for(var/type in disallow_occupant_types)
		if(istype(M, type))
			return 0

	return 1


/obj/machinery/cryopod/Process()
	if(!loc)
		GLOB.cryopods -= src
		qdel(src)

	if(occupant)

		if(world.time - time_entered < time_till_despawn)
			return
		despawn_occupant()

/mob/var/stored_ckey = ""


// This function can not be undone; do not call this unless you are sure
// Also make sure there is a valid control computer
/obj/machinery/cryopod/proc/despawn_occupant()
	occupant.loc = null
	var/mob/new_player/M = new /mob/new_player()
	M.loc = locate(100,100,28)
	occupant.stored_ckey = occupant.ckey
	M.key = occupant.key
	var/role_alt_title = occupant.mind ? occupant.mind.role_alt_title : "Unknown"
	if(control_computer)
		control_computer.frozen_crew += "[occupant.real_name], [role_alt_title] - [stationtime2text()]"
		control_computer._admin_logs += "[key_name(occupant)] ([role_alt_title]) at [stationtime2text()]"
	log_and_message_admins("[key_name(occupant)] ([role_alt_title]) entered cryostorage.")

	announce.autosay("[occupant.real_name], [role_alt_title], [on_store_message]", "[on_store_name]")
	visible_message("<span class='notice'>\The [initial(name)] hums and hisses as it moves [occupant.real_name] into storage.</span>", 3)
	GLOB.all_cryo_mobs |= occupant
	set_occupant(null)
	icon_state = base_icon_state

/obj/machinery/cryopod/attackby(var/obj/item/weapon/G as obj, var/mob/user as mob)
	if(isMultitool(G))
		to_chat(user, "<span class='notice'>\The [src] was [find_control_computer() ? "" : "unable to be"] linked to a control computer</span>")

	if(istype(G, /obj/item/grab))
		var/obj/item/grab/grab = G
		if(occupant)
			to_chat(user, "<span class='notice'>\The [src] is in use.</span>")
			return

		if(!ismob(grab.affecting))
			return

		if(!check_occupant_allowed(grab.affecting))
			return

		var/willing = null //We don't want to allow people to be forced into despawning.
		var/mob/M = G:affecting

		willing = 1
		if(willing)

			visible_message("[user] starts putting [grab.affecting:name] into \the [src].", 3)

			if(do_after(user, 20, src))
				if(!M || !grab || !grab.affecting) return

			set_occupant(M)

			var/turf/location = get_turf(src)
			log_admin("[key_name_admin(M)] has entered a stasis pod. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[location.x];Y=[location.y];Z=[location.z]'>JMP</a>)")
			message_admins("<span class='notice'>[key_name_admin(M)] has entered a stasis pod.</span>")

			//Despawning occurs when process() is called with an occupant without a client.
			src.add_fingerprint(M)

/obj/machinery/cryopod/verb/eject()
	set name = "Eject Pod"
	set category = "Object"
	set src in oview(1)
	if(usr.stat != 0)
		return

	icon_state = base_icon_state

	//Eject any items that aren't meant to be in the pod.
	/**
	var/list/items = src.contents
	if(occupant) items -= occupant
	if(announce) items -= announce

	for(var/obj/item/W in items)
		W.forceMove(get_turf(src))
	**/
	src.go_out()
	add_fingerprint(usr)

	name = initial(name)
	return
/obj/machinery/cryopod/proc/eject_proc(var/mob/usr)
	set name = "Eject Pod"
	set category = "Object"
	set src in oview(1)
	if(usr.stat != 0)
		return

	icon_state = base_icon_state
	/**
	//Eject any items that aren't meant to be in the pod.
	var/list/items = src.contents
	if(occupant) items -= occupant
	if(announce) items -= announce

	for(var/obj/item/W in items)
		W.forceMove(get_turf(src))
	**/
	src.go_out()
	add_fingerprint(usr)

	name = initial(name)
	return
/obj/machinery/cryopod/proc/move_inside_proc(var/mob/usr)
	if(usr.stat != 0 || !check_occupant_allowed(usr))
		return
	if(!req_access_faction || req_access_faction == "")
		to_chat(usr, "<span class='notice'><B>\The [src] is not connected to a network.</B></span>")
		return
	if(src.occupant)
		to_chat(usr, "<span class='notice'><B>\The [src] is in use.</B></span>")
		return

	for(var/mob/living/carbon/slime/M in range(1,usr))
		if(M.Victim == usr)
			to_chat(usr, "You're too busy getting your life sucked out of you.")
			return

	visible_message("[usr] starts climbing into \the [src].", 3)

	if(do_after(usr, 20, src))

		if(!usr || !usr.client)
			return

		if(src.occupant)
			to_chat(usr, "<span class='notice'><B>\The [src] is in use.</B></span>")
			return

		usr.stop_pulling()
		usr.client.perspective = EYE_PERSPECTIVE
		usr.client.eye = src
		usr.forceMove(src)
		set_occupant(usr)
		usr.spawn_loc = req_access_faction
		icon_state = occupied_icon_state

		to_chat(usr, "<span class='notice'>[on_enter_occupant_message]</span>")
		to_chat(usr, "<span class='notice'><b>Simply wait one full minute to be sent back to the lobby where you can switch characters.</b></span>")

		time_entered = world.time

		src.add_fingerprint(usr)

	return


/obj/machinery/cryopod/verb/move_inside()
	set name = "Enter Pod"
	set category = "Object"
	set src in oview(1)
	if(!req_access_faction || req_access_faction == "")
		to_chat(usr, "<span class='notice'><B>\The [src] is not connected to a network.</B></span>")
		return
	if(usr.stat != 0 || !check_occupant_allowed(usr))
		return

	if(src.occupant)
		to_chat(usr, "<span class='notice'><B>\The [src] is in use.</B></span>")
		return

	for(var/mob/living/carbon/slime/M in range(1,usr))
		if(M.Victim == usr)
			to_chat(usr, "You're too busy getting your life sucked out of you.")
			return

	visible_message("[usr] starts climbing into \the [src].", 3)

	if(do_after(usr, 20, src))

		if(!usr || !usr.client)
			return

		if(src.occupant)
			to_chat(usr, "<span class='notice'><B>\The [src] is in use.</B></span>")
			return

		set_occupant(usr)

		src.add_fingerprint(usr)

	return

/obj/machinery/cryopod/proc/go_out()

	if(!occupant)
		return

	if(occupant.client)
		occupant.client.eye = src.occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE

	occupant.forceMove(get_turf(src))
	set_occupant(null)

	icon_state = base_icon_state

	return

/obj/machinery/cryopod/proc/set_occupant(var/mob/living/carbon/occupant)
	src.occupant = occupant
	if(!occupant)
		name = initial(name)
		return

	occupant.stop_pulling()
	if(occupant.client)
		usr.spawn_loc = req_access_faction
		to_chat(usr, "<span class='notice'>[on_enter_occupant_message]</span>")
		to_chat(usr, "<span class='notice'><b>Simply wait one full minute to be sent back to the lobby where you can switch characters.</b></span>")
		occupant.client.perspective = EYE_PERSPECTIVE
		occupant.client.eye = src

	occupant.forceMove(src)
	time_entered = world.time

	name = "[name] ([occupant])"
	icon_state = occupied_icon_state

/obj/structure/frontier_beacon
	name = "Frontier Beacon"
	desc = "A huge bluespace beacon. The technology is unlike anything you've ever seen, but its apparent that this recieves teleportation signals from the gateway outside the frontier."
	icon = 'icons/obj/machines/antimatter.dmi'
	icon_state = "shield"
	anchored = 1
	density = 1
/obj/structure/frontier_beacon/New()
	..()
	GLOB.frontierbeacons |= src


