/obj/machinery/computer/area_atmos
	name = "Area Air Control"
	desc = "A computer used to control the stationary scrubbers and pumps in the area."
	icon_keyboard = "atmos_key"
	icon_screen = "area_atmos"
	light_color = "#e6ffff"
	circuit = /obj/item/weapon/circuitboard/area_atmos

	id_tag 			= null
	frequency 		= ATMOS_CONTROL_FREQ
	range 			= 25
	radio_filter_in = RADIO_ATMOSIA
	radio_filter_out= RADIO_ATMOSIA
	//Simple variable to prevent me from doing attack_hand in both this and the child computer
	var/zone = "This computer is working on a wireless range, the range is currently limited to 25 meters."
	var/list/connectedscrubbers = new()
	var/status = ""

/obj/machinery/computer/area_atmos/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer/area_atmos/LateInitialize()
	. = ..()
	scanscrubbers()

/obj/machinery/computer/area_atmos/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/area_atmos/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nano_ui/master_ui, datum/topic_state/state)
	var/data[0]
	data["status"] = status
	data["zone"] = zone

	var/list/scrubdata[0]
	for(var/obj/machinery/portable_atmospherics/powered/scrubber/huge/S in connectedscrubbers)
		var/list/scr[0]
		scr["name"] 	= S.name
		scr["id"]		= "\ref[S]"
		scr["pressure"] = round(S.air_contents.return_pressure(), 0.01)
		scr["flowrate"] = round(S.last_flow_rate,0.1)
		scr["load"]		= round(S.last_power_draw)
		scr["power"]	= S.ison()
		scrubdata[S.name] = scr.Copy()
	data["scrubbers"] = scrubdata.Copy()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "area_atmos_computer.tmpl", src.name, 480, 400)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/area_atmos/OnTopic(mob/user, href_list, datum/topic_state/state)
	if(..())
		return
	if(href_list["scan"])
		scanscrubbers()
	else if(href_list["toggle"])
		var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber = locate(href_list["scrub"])

		if(!validscrubber(scrubber))
			spawn(20)
				status = "ERROR: Couldn't connect to scrubber! (timeout)"
				connectedscrubbers -= scrubber
				src.updateUsrDialog()
			return
		if(scrubber.isactive())
			scrubber.turn_idle()
		else
			scrubber.turn_active()


/obj/machinery/computer/area_atmos/proc/validscrubber( var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber as obj )
	if(!isobj(scrubber) || get_dist(scrubber.loc, src.loc) > src.range || scrubber.loc.z != src.loc.z)
		return FALSE
	return TRUE

/obj/machinery/computer/area_atmos/proc/scanscrubbers()
	qdel(connectedscrubbers)
	connectedscrubbers = list()
	var/found = FALSE
	for(var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber in range(range, src.loc))
		if(istype(scrubber))
			found = TRUE
			connectedscrubbers += scrubber
	if(!found)
		status = "ERROR: No scrubber found!"
	src.updateUsrDialog()

//
//	Area limited
//
/obj/machinery/computer/area_atmos/area
	zone = "This computer is working in a wired network limited to this area."

/obj/machinery/computer/area_atmos/area/validscrubber( var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber as obj )
	if(!isobj(scrubber))
		return FALSE
	var/area/srca = get_area(src)
	var/area/scra = get_area(scrubber)
	if(!srca || !scra || (srca && scra && srca != scra))
		return FALSE
	return TRUE

/obj/machinery/computer/area_atmos/area/scanscrubbers()
	connectedscrubbers = new()
	var/found = FALSE
	var/area/A = get_area(src)
	if(!A)
		return
	for(var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber in world )
		var/area/A2 = get_area(scrubber)
		if(istype(A2) && A2 == A)
			connectedscrubbers += scrubber
			found = TRUE
	if(!found)
		status = "ERROR: No scrubber found!"
	src.updateUsrDialog()
