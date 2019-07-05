////////////////////////
//Turret Control Panel//
////////////////////////

/area
	// Turrets use this list to see if individual power/lethal settings are allowed
	var/list/turret_controls = list()

/obj/machinery/turretid
	name = "turret control panel"
	desc = "Used to control a room's automated defenses."
	icon = 'icons/obj/machines/turret_control.dmi'
	icon_state = "control_standby"
	anchored = TRUE
	density = FALSE
	req_access = list(access_ai_upload)
	frame_type = /obj/item/frame/turret_control
	var/enabled = FALSE
	var/lethal = FALSE
	var/locked = TRUE
	var/area/control_area //can be area name, path or nothing.
	var/tmp/area/saving_control_area = null //Stores the area during saving
	var/mob/living/silicon/ai/master_ai

	var/check_arrest = 1	//checks if the perp is set to arrest
	var/check_records = 1	//checks if a security record exists at all
	var/check_weapons = 0	//checks if it can shoot people that have a weapon they aren't authorized to have
	var/check_access = 1	//if this is active, the turret shoots everything that does not meet the access requirements
	var/check_anomalies = 1	//checks if it can shoot at unidentified lifeforms (ie xenos)
	var/check_synth = 0 	//if active, will shoot at anything not an AI or cyborg
	var/ailock = 0 	//Silicons cannot use this

/obj/machinery/turretid/stun
	enabled = TRUE
	icon_state = "control_stun"

/obj/machinery/turretid/lethal
	enabled = TRUE
	lethal = TRUE
	icon_state = "control_kill"

/obj/machinery/turretid/New()
	. = ..()
	ADD_SAVED_VAR(enabled)
	ADD_SAVED_VAR(lethal)
	ADD_SAVED_VAR(locked)
	ADD_SAVED_VAR(ailock)
	ADD_SAVED_VAR(check_arrest)
	ADD_SAVED_VAR(check_records)
	ADD_SAVED_VAR(check_weapons)
	ADD_SAVED_VAR(check_access)
	ADD_SAVED_VAR(check_anomalies)
	ADD_SAVED_VAR(check_synth)
	ADD_SAVED_VAR(control_area)

	ADD_SKIP_EMPTY(control_area)

/obj/machinery/turretid/Destroy()
	if(control_area)
		var/area/A = control_area
		if(A && istype(A))
			A.turret_controls -= src
	. = ..()

//Since we can't save references to areas, we'll do a little trick to
// save only the area name, and then restore it on save load.
/obj/machinery/turretid/before_save()
	. = ..()
	if(istype(control_area))
		saving_control_area = control_area
		control_area = control_area.name
/obj/machinery/turretid/after_save()
	. = ..()
	if(istype(saving_control_area))
		control_area = saving_control_area
		saving_control_area = null

/obj/machinery/turretid/after_load()
	. = ..()
	if(istext(control_area))
		control_area = get_area(control_area)

/obj/machinery/turretid/Initialize()
	if(!control_area)
		control_area = get_area(src)
	else if(istext(control_area))
		for(var/area/A in world)
			if(A.name && A.name==control_area)
				control_area = A
				break

	if(control_area)
		var/area/A = control_area
		if(istype(A))
			A.turret_controls += src
		else
			control_area = null

	power_change() //Checks power and initial settings
	. = ..()

/obj/machinery/turretid/Destroy()
	if(control_area)
		var/area/A = control_area
		if(A && istype(A))
			A.turret_controls -= src
	. = ..()

/obj/machinery/turretid/proc/isLocked(mob/user)
	if(ailock && issilicon(user))
		to_chat(user, "<span class='notice'>There seems to be a firewall preventing you from accessing this device.</span>")
		return 1

	if(malf_upgraded && master_ai)
		if((user == master_ai) || (user in master_ai.connected_robots))
			return 0
		return 1

	if(locked && !issilicon(user))
		to_chat(user, "<span class='notice'>Access denied.</span>")
		return 1

	return 0

/obj/machinery/turretid/CanUseTopic(mob/user)
	if(isLocked(user))
		return STATUS_CLOSE

	return ..()

/obj/machinery/turretid/attackby(obj/item/weapon/W, mob/user)
	if(default_deconstruction_screwdriver(user,W))
		return TRUE
	if(default_deconstruction_crowbar(user,W))
		return TRUE
	if(isbroken())
		return

	if(istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/modular_computer))
		if(src.allowed(usr))
			if(emagged)
				to_chat(user, SPAN_NOTICE("The turret control is unresponsive."))
			else
				locked = !locked
				to_chat(user, SPAN_NOTICE("You [ locked ? "lock" : "unlock"] the panel."))
		return
	return ..()

/obj/machinery/turretid/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		to_chat(user, SPAN_DANGER("You short out the turret controls' access analysis module."))
		emagged = TRUE
		locked = FALSE
		ailock = FALSE
		return 1

/obj/machinery/turretid/attack_ai(mob/user as mob)
	if(isLocked(user))
		return
	ui_interact(user)

/obj/machinery/turretid/attack_hand(mob/user as mob)
	if(isLocked(user))
		return
	ui_interact(user)

/obj/machinery/turretid/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	data["access"] = !isLocked(user)
	data["locked"] = locked
	data["enabled"] = enabled
	data["is_lethal"] = 1
	data["lethal"] = lethal

	if(data["access"])
		var/settings[0]
		settings[++settings.len] = list("category" = "Neutralize All Non-Synthetics", "setting" = "check_synth", "value" = check_synth)
		settings[++settings.len] = list("category" = "Check Weapon Authorization", "setting" = "check_weapons", "value" = check_weapons)
		settings[++settings.len] = list("category" = "Check Security Records", "setting" = "check_records", "value" = check_records)
		settings[++settings.len] = list("category" = "Check Arrest Status", "setting" = "check_arrest", "value" = check_arrest)
		settings[++settings.len] = list("category" = "Check Access Authorization", "setting" = "check_access", "value" = check_access)
		settings[++settings.len] = list("category" = "Check misc. Lifeforms", "setting" = "check_anomalies", "value" = check_anomalies)
		data["settings"] = settings

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "turret_control.tmpl", "Turret Controls", 500, 300)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)

/obj/machinery/turretid/Topic(href, href_list)
	if(..())
		return 1


	if(href_list["command"] && href_list["value"])
		var/log_action = null

		var/list/toggle = list("disabled","enabled")

		var/value = text2num(href_list["value"])
		if(href_list["command"] == "enable")
			enabled = value
			log_action = "[toggle[enabled+1]] the turrets"
		else if(href_list["command"] == "lethal")
			lethal = value
			log_action = "[toggle[lethal+1]] the turrets lethal mode."
		else if(href_list["command"] == "check_synth")
			check_synth = value
		else if(href_list["command"] == "check_weapons")
			check_weapons = value
		else if(href_list["command"] == "check_records")
			check_records = value
		else if(href_list["command"] == "check_arrest")
			check_arrest = value
		else if(href_list["command"] == "check_access")
			check_access = value
		else if(href_list["command"] == "check_anomalies")
			check_anomalies = value

		if(!isnull(log_action))
			log_admin("[key_name(usr)] has [log_action]")
			message_admins("[key_name_admin(usr)] has [log_action]", 1)

		updateTurrets()
		return 1

/obj/machinery/turretid/proc/updateTurrets()
	var/datum/turret_checks/TC = new
	TC.enabled = enabled
	TC.lethal = lethal
	TC.check_synth = check_synth
	TC.check_access = check_access
	TC.check_records = check_records
	TC.check_arrest = check_arrest
	TC.check_weapons = check_weapons
	TC.check_anomalies = check_anomalies
	TC.ailock = ailock

	if(istype(control_area))
		for (var/obj/machinery/porta_turret/aTurret in control_area)
			aTurret.setState(TC)

	queue_icon_update()

/obj/machinery/turretid/power_change()
	. = ..()
	if(.)
		updateTurrets()

/obj/machinery/turretid/on_update_icon()
	..()
	switch(dir)
		if(NORTH)
			src.pixel_x = 0
			src.pixel_y = -30
		if(SOUTH)
			src.pixel_x = 0
			src.pixel_y = 30
		if(EAST)
			src.pixel_x = -30
			src.pixel_y = 0
		if(WEST)
			src.pixel_x = 30
			src.pixel_y = 0
	if(!ispowered())
		icon_state = "control_off"
		set_light(0)
	else if (enabled)
		if (lethal)
			icon_state = "control_kill"
			set_light(1, 0.5, 2, 2, "#990000")
		else
			icon_state = "control_stun"
			set_light(1, 0.5, 2, 2, "#ff9900")
	else
		icon_state = "control_standby"
		set_light(1, 0.5, 2, 2, "#003300")

/obj/machinery/turretid/emp_act(severity)
	if(enabled)
		//if the turret is on, the EMP no matter how severe disables the turret for a while
		//and scrambles its settings, with a slight chance of having an emag effect

		check_arrest = pick(0, 1)
		check_records = pick(0, 1)
		check_weapons = pick(0, 1)
		check_access = pick(0, 0, 0, 0, 1)	// check_access is a pretty big deal, so it's least likely to get turned on
		check_anomalies = pick(0, 1)
		enabled=FALSE
		updateTurrets()
		spawn(rand(60,600))
			if(!enabled)
				enabled=TRUE
				updateTurrets()
	..()

/obj/machinery/turretid/malf_upgrade(var/mob/living/silicon/ai/user)
	..()
	malf_upgraded = TRUE
	locked = TRUE
	ailock = FALSE
	to_chat(user, "\The [src] has been upgraded. It has been locked and can not be tampered with by anyone but you and your cyborgs.")
	master_ai = user
	return 1
