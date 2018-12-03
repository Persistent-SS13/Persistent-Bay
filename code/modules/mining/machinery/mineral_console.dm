/obj/machinery/computer/mining
	name = "ore processing console"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "console"
	req_access = list(core_access_engineering_programs)
	circuit = /obj/item/weapon/circuitboard/mineral_processing
	var/list/connected
	var/list/connected_coordinates //Saves/loads the coordinates of the connected machines to be restored on load

/obj/machinery/computer/mining/New()
	..()
	map_storage_saved_vars += ";connected_coordinates"

/obj/machinery/computer/mining/before_save()
	..()
	connected_coordinates = list()
	for(var/obj/machinery/mineral/mach in connected)
		connected_coordinates += list(list("x" = mach.x, "y" = mach.y, "z" = mach.z))

/obj/machinery/computer/mining/after_load()
	connected = list()
	for(var/list/coords in connected_coordinates)
		var/turf/location = locate(coords["x"], coords["y"], coords["z"])
		connect_machine(locate(/obj/machinery/mineral) in location)
	..()

/obj/machinery/computer/mining/Destroy()
	disconnect_all()
	. = ..()

/obj/machinery/computer/mining/proc/connect_machine(var/obj/machinery/mineral/mach)
	if(!connected)
		connected = list()
	if(mach && istype(mach))
		mach.console = src
		connected |= mach
		return TRUE
	return FALSE

/obj/machinery/computer/mining/proc/disconnect_machine(var/obj/machinery/mineral/mach)
	if(mach.console == src)
		mach.console = initial(mach.console)
	connected -= mach

/obj/machinery/computer/mining/proc/disconnect_all()
	if(LAZYLEN(connected))
		for(var/obj/machinery/mineral/M in connected)
			if(M.console == src)
				M.console = initial(M.console)

		connected.Cut()

/obj/machinery/computer/mining/attackby(var/obj/item/O, var/mob/user)
	if(isMultitool(O))
		var/obj/item/device/multitool/mt = O
		var/obj/machinery/mineral/mach = mt.get_buffer(/obj/machinery/mineral)
		if(mach)
			mt.set_buffer(null)
			if(connect_machine(mach))
				to_chat(user, "<span class='notice'>You connect \the [src] to \the [mach]!</span>")
			else
				to_chat(user, "<span class='warning'>Nothing happens..</span>")
		else
			mt.set_buffer(src)
			to_chat(user, "<span class='notice'>You set \the [mt]'s buffer to \the [src]!</span>")
		return
	. = ..()

/obj/machinery/computer/mining/attack_hand(var/mob/user)
	if(!LAZYLEN(connected))
		to_chat(user, "<span class='warning'>\The [src] is not connected to a processing machine. Link some machines to it with a multitool!</span>")
		return
	var/datum/browser/popup = new(user, "mining-[name]", "[src] Control Panel")
	for(var/obj/machinery/mineral/M in connected)
		popup.add_content(jointext(M.get_console_data(), "<br>"))
		popup.add_content("<hr>")
	popup.open()

/obj/machinery/computer/mining/Topic(href, href_list)
	if((. = ..()))
		return
	if(href_list["scan_for_machine"])
		connected = list()
		for(var/obj/machinery/O in orange(7, src))
			if(istype(O, /obj/machinery/mineral))
				var/obj/machinery/mineral/M = O
				if(M /*&& ispath(M.console) && istype(src, M.console)*/)
					connect_machine(M)
		SSnano.update_uis(src)
		return TRUE
