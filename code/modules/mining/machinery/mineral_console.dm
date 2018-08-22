/obj/machinery/computer/mining
	name = "ore processing console"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "console"
	req_access = list(core_access_engineering_programs)
	circuit = /obj/item/weapon/circuitboard/mineral_processing
	var/list/connected

/obj/machinery/computer/mining/attack_hand(var/mob/user)
	if(!LAZYLEN(connected))
		to_chat(user, "<span class='warning'>\The [src] is not connected to a processing machine. <a href='?src=\ref[src];scan_for_machine=1'>Scan</a></span>")
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
		for(var/O in orange(7, src))
			if(istype(O, /obj/machinery/mineral))
				var/obj/machinery/mineral/M = O
				if(M && ispath(M.console) && istype(src, M.console))
					M.console = src
					connected += M
		return TRUE

/obj/machinery/computer/mining/Destroy()
	if(LAZYLEN(connected))
		for(var/obj/machinery/mineral/M in connected)
			if(M.console == src)
				M.console = initial(M.console)

		connected.Cut()
	. = ..()
