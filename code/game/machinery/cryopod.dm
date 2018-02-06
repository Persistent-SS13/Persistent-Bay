
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

/obj/item/weapon/circuitboard/cryopodcontrol
	name = "Circuit board (Cryogenic Oversight Console)"
	build_path = "/obj/machinery/computer/cryopod"
	origin_tech = list(TECH_DATA = 3)

/obj/item/weapon/circuitboard/robotstoragecontrol
	name = "Circuit board (Robotic Storage Console)"
	build_path = "/obj/machinery/computer/cryopod/robot"
	origin_tech = list(TECH_DATA = 3)

/obj/item/weapon/circuitboard/dormscontrol
	name = "Circuit board (Residential Oversight Console)"
	build_path = "/obj/machinery/computer/cryopod/door/dorms"
	origin_tech = list(TECH_DATA = 3)

/obj/item/weapon/circuitboard/travelcontrol
	name = "Circuit board (Travel Oversight Console - Docks)"
	build_path = "/obj/machinery/computer/cryopod/door/travel"
	origin_tech = list(TECH_DATA = 3)

/obj/item/weapon/circuitboard/gatewaycontrol
	name = "Circuit board (Travel Oversight Console - Gateway)"
	build_path = "/obj/machinery/computer/cryopod/door/gateway"
	origin_tech = list(TECH_DATA = 3)

/obj/machinery/computer/cryopod/robot
	name = "robotic storage console"
	desc = "An interface between crew and the robotic storage systems."
	icon = 'icons/obj/robot_storage.dmi'
	icon_state = "console"
	circuit = /obj/item/weapon/circuitboard/robotstoragecontrol

	storage_type = "cyborgs"
	storage_name = "Robotic Storage Control"
	allow_items = 0

/obj/machinery/computer/cryopod/dorms
	name = "residential oversight console"
	desc = "An interface between visitors and the residential oversight systems tasked with keeping track of all visitors in the deeper section of the colony."
	icon = 'icons/obj/robot_storage.dmi' //placeholder
	icon_state = "console" //placeholder
	circuit = "/obj/item/weapon/circuitboard/robotstoragecontrol"

	storage_type = "visitors"
	storage_name = "Residential Oversight Control"
	allow_items = 1

/obj/machinery/computer/cryopod/travel
	name = "docking oversight console"
	desc = "An interface between visitors and the docking oversight systems tasked with keeping track of all visitors who enter or exit from the docks."
	icon = 'icons/obj/robot_storage.dmi' //placeholder
	icon_state = "console" //placeholder
	circuit = "/obj/item/weapon/circuitboard/robotstoragecontrol"

	storage_type = "visitors"
	storage_name = "Travel Oversight Control"
	allow_items = 1

/obj/machinery/computer/cryopod/gateway
	name = "gateway oversight console"
	desc = "An interface between visitors and the gateway oversight systems tasked with keeping track of all visitors who enter or exit from the gateway."
	icon = 'icons/obj/robot_storage.dmi' //placeholder
	icon_state = "console" //placeholder
	circuit = "/obj/item/weapon/circuitboard/robotstoragecontrol"

	storage_type = "visitors"
	storage_name = "Travel Oversight Control"
	allow_items = 1

//Decorative structures to go alongside cryopods.
/obj/structure/cryofeed

	name = "cryogenic feed"
	desc = "A bewildering tangle of machinery and pipes."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "cryo_rear"
	anchored = 1
	dir = WEST

/obj/machinery/cryopod/robot/door/dorms
	name = "Residential District Elevator"
	desc = "A small elevator that goes down to the deeper section of the colony."
	on_store_message = "has departed for the residential district."
	on_store_name = "Residential Oversight"
	on_enter_occupant_message = "The elevator door closes slowly, ready to bring you down to the residential district."
	on_store_visible_message_1 = "makes a ding as it moves"
	on_store_visible_message_2 = "to the residential district."

/obj/machinery/cryopod/robot/door/travel
	name = "Passenger Elevator"
	desc = "A small elevator that goes down to the passenger section of the vessel."
	on_store_message = "is slated to depart from the colony."
	on_store_name = "Travel Oversight"
	on_enter_occupant_message = "The elevator door closes slowly, ready to bring you down to the hell that is economy class travel."
	on_store_visible_message_1 = "makes a ding as it moves"
	on_store_visible_message_2 = "to the passenger deck."

/obj/machinery/cryopod/robot/door/gateway
	name = "Gateway"
	desc = "The gateway you might've came in from.  You could leave the colony easily using this."
	icon = 'icons/obj/machines/gateway.dmi'
	icon_state = "offcenter"
	base_icon_state = "offcenter"
	occupied_icon_state = "oncenter"
	on_store_message = "has departed from the colony."
	on_store_name = "Travel Oversight"
	on_enter_occupant_message = "The gateway activates, and you step into the swirling portal."
	on_store_visible_message_1 = "'s portal disappears just after"
	on_store_visible_message_2 = "finishes walking across it."

	time_till_despawn = 60 //1 second, because gateway.

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
	var/on_enter_visible_message = "starts climbing into the"
	var/on_store_visible_message_1 = "hums and hisses as it moves" //We need two variables because byond doesn't let us have variables inside strings at compile-time.
	var/on_store_visible_message_2 = "into storage."
	var/allow_occupant_types = list(/mob/living/carbon/human)
	var/disallow_occupant_types = list()

	var/faction = ""
	var/mob/occupant = null       // Person waiting to be despawned.
	var/time_till_despawn = 1800  // 3 minutes till despawn
	var/time_entered = 0          // Used to keep track of the safe period.

	var/obj/machinery/computer/cryopod/control_computer
	var/last_no_computer_message = 0


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

		if(!occupant.client && occupant.stat<2) //Occupant is living and has no client.
			if(!control_computer)
				if(!find_control_computer(urgent=1))
					return

			despawn_occupant()

/mob/var/stored_ckey = ""


// This function can not be undone; do not call this unless you are sure
// Also make sure there is a valid control computer
/obj/machinery/cryopod/proc/despawn_occupant()
	occupant.loc = null
	var/mob/new_player/M = new /mob/new_player()
	occupant.stored_ckey = occupant.ckey
	M.loc = null
	M.key = occupant.key
	var/role_alt_title = occupant.mind ? occupant.mind.role_alt_title : "Unknown"
	if(control_computer)
		control_computer.frozen_crew += "[occupant.real_name], [role_alt_title] - [stationtime2text()]"
		control_computer._admin_logs += "[key_name(occupant)] ([role_alt_title]) at [stationtime2text()]"
	log_and_message_admins("[key_name(occupant)] ([role_alt_title]) entered cryostorage.")

	visible_message("<span class='notice'>\The [initial(name)] hums and hisses as it moves [occupant.real_name] into storage.</span>", 3)
	GLOB.all_cryo_mobs |= occupant
	set_occupant(null)


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

		if(M.client)
			if(alert(M,"Would you like to enter long-term storage?",,"Yes","No") == "Yes")
				if(!M || !grab || !grab.affecting) return
				willing = 1
		else
			willing = 1

		if(willing)

			visible_message("[user] starts putting [grab.affecting:name] into \the [src].", 3)

			if(do_after(user, 20, src))
				if(!M || !grab || !grab.affecting) return

				M.forceMove(src)

				if(M.client)
					M.client.perspective = EYE_PERSPECTIVE
					M.client.eye = src

			icon_state = occupied_icon_state

			to_chat(M, "<span class='notice'>[on_enter_occupant_message]</span>")
			to_chat(M, "<span class='notice'><b>If you ghost, log out or close your client now, your character will shortly be saved and removed from the round.</b></span>")
			set_occupant(M)
			time_entered = world.time
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
	var/list/items = src.contents
	if(occupant) items -= occupant

	for(var/obj/item/W in items)
		W.forceMove(get_turf(src))

	src.go_out()
	add_fingerprint(usr)

	name = initial(name)
	return

/obj/machinery/cryopod/verb/move_inside()
	set name = "Enter Pod"
	set category = "Object"
	set src in oview(1)

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

		usr.stop_pulling()
		usr.client.perspective = EYE_PERSPECTIVE
		usr.client.eye = src
		usr.forceMove(src)
		set_occupant(usr)
		icon_state = occupied_icon_state

		to_chat(usr, "<span class='notice'>[on_enter_occupant_message]</span>")
		to_chat(usr, "<span class='notice'><b>If you ghost, log out or close your client now, your character will shortly be saved and removed from the round.</b></span>")

		time_entered = world.time

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

/obj/machinery/cryopod/proc/set_occupant(var/occupant)
	src.occupant = occupant
	name = initial(name)
	if(occupant)
		name = "[name] ([occupant])"


/obj/machinery/cryopod/robot/door/gateway/move_inside()
	..()
	//locate(/obj/machinery/computer/cryopod) in range(6,src)
	for(var/obj/machinery/gateway/G in range(1,src))
		G.icon_state = "on"

/obj/machinery/cryopod/robot/door/gateway/go_out()
	..()
	for(var/obj/machinery/gateway/G in range(1,src))
		G.icon_state = "off"