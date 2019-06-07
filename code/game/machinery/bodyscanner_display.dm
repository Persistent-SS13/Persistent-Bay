/obj/machinery/body_scan_display
	name = "Body Scan Display"
	desc = "A wall-mounted display linked to a body scanner."
	icon = 'icons/obj/modular_telescreen.dmi'
	icon_state = "operating"
	var/icon_state_unpowered = "telescreen"
	anchored = TRUE
	density = 0
	idle_power_usage = 75
	active_power_usage = 300
	w_class = ITEM_SIZE_HUGE
	circuit_type = /obj/item/weapon/circuitboard/bodyscannerdisplay
	max_health = 80
	var/list/bodyscans = list()
	var/selected = 0

/obj/machinery/body_scan_display/New()
	. = ..()
	ADD_SAVED_VAR(bodyscans)
	ADD_SAVED_VAR(selected)

/obj/machinery/body_scan_display/proc/add_new_scan(var/list/scan)
	bodyscans += list(scan.Copy())
	updateUsrDialog()

/obj/machinery/body_scan_display/OnTopic(mob/user as mob, href_list)
	if(href_list["view"])
		var/selection = text2num(href_list["view"])
		if(is_valid_index(selection, bodyscans))
			selected = selection
			return TOPIC_REFRESH
		return TOPIC_HANDLED
	if(href_list["delete"])
		var/selection = text2num(href_list["delete"])
		if(!is_valid_index(selection, bodyscans))
			return TOPIC_HANDLED
		if(selected == selection)
			selected = 0
		else if(selected > selection)
			selected--
		bodyscans -= list(bodyscans[selection])
		return TOPIC_REFRESH

/obj/machinery/bodyscanner/attackby(obj/item/grab/normal/G, user as mob)
	if(default_deconstruction_screwdriver(user, G))
		updateUsrDialog()
		return
	else if(default_deconstruction_crowbar(user, G))
		return
	else if(default_part_replacement(user, G))
		return
	return ..()

/obj/machinery/body_scan_display/attack_ai(user as mob)
	return attack_hand(user)

/obj/machinery/body_scan_display/attack_hand(mob/user)
	if(..())
		return
	if(inoperable())
		return
	ui_interact(user)

/obj/machinery/body_scan_display/ui_interact(var/mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open=1)
	var/list/data = list()
	data["scans"] = bodyscans
	data["selected"] = selected

	if(selected > 0)
		data["scan_header"] = display_medical_data_header(bodyscans[selected], user.get_skill_value(SKILL_MEDICAL))
		data["scan_health"] = display_medical_data_health(bodyscans[selected], user.get_skill_value(SKILL_MEDICAL))
		data["scan_body"] = display_medical_data_body(bodyscans[selected], user.get_skill_value(SKILL_MEDICAL))
	else
		data["scan_header"] = "&nbsp;"
		data["scan_health"] = "&nbsp;"
		data["scan_body"] = "&nbsp;"
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "body_scan_display.tmpl", "Body Scan Display Console", 600, 800)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/body_scan_display/on_update_icon()
	..()
	if(!ispowered())
		icon_state = icon_state_unpowered
	else
		icon_state = initial(icon_state)

	src.pixel_x = 0
	src.pixel_y = 0
	switch(dir)
		if(NORTH)
			src.pixel_y = -24
		if(SOUTH)
			src.pixel_y = 24
		if(EAST)
			src.pixel_x = -30
		if(WEST)
			src.pixel_x = 30