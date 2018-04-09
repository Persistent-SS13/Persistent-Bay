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
	anchored = 1
	density = 0
	var/enabled = 0
	var/lethal = 0
	var/locked = 1
	var/area/control_area //can be area name, path or nothing.
	var/mob/living/silicon/ai/master_ai

	req_access = list(access_ai_upload)

/obj/machinery/turretid/stun
	enabled = 1
	icon_state = "control_stun"

/obj/machinery/turretid/lethal
	enabled = 1
	lethal = 1
	icon_state = "control_kill"

/obj/machinery/turretid/Destroy()
	if(control_area)
		var/area/A = control_area
		if(A && istype(A))
			A.turret_controls -= src
	. = ..()

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

/obj/machinery/turretid/proc/isLocked(mob/user)

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
	if(stat & BROKEN)
		return

	if(istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/device/pda))
		if(src.allowed(usr))
			if(emagged)
				to_chat(user, "<span class='notice'>The turret control is unresponsive.</span>")
			else
				locked = !locked
				to_chat(user, "<span class='notice'>You [ locked ? "lock" : "unlock"] the panel.</span>")
		return
	return ..()

/obj/machinery/turretid/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		to_chat(user, "<span class='danger'>You short out the turret controls' access analysis module.</span>")
		emagged = 1
		locked = 0
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
	data["locked"] = locked
	data["enabled"] = enabled
	data["lethal"] = lethal
	data["ui_mode"] = 0

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "turret_control.tmpl", "Turret Controls", 500, 300)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

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

		if(!isnull(log_action))
			log_admin("[key_name(usr)] has [log_action]")
			message_admins("[key_name_admin(usr)] has [log_action]", 1)

		updateTurrets()
		return 1

/obj/machinery/turretid/proc/updateTurrets()
	var/datum/turret_checks/TC = new
	TC.enabled = enabled
	TC.lethal = lethal

	if(istype(control_area))
		for (var/obj/machinery/porta_turret/aTurret in control_area)
			aTurret.setState(TC)

	update_icon()

/obj/machinery/turretid/power_change()
	. = ..()
	if(.)
		updateTurrets()

/obj/machinery/turretid/update_icon()
	..()
	if(stat & NOPOWER)
		icon_state = "control_off"
		set_light(0)
	else if (enabled)
		if (lethal)
			icon_state = "control_kill"
			set_light(1.5, 1,"#990000")
		else
			icon_state = "control_stun"
			set_light(1.5, 1,"#ff9900")
	else
		icon_state = "control_standby"
		set_light(1.5, 1,"#003300")

/obj/machinery/turretid/emp_act(severity)
	if(enabled)
		//if the turret is on, the EMP no matter how severe disables the turret for a while

		enabled=0
		updateTurrets()

		spawn(rand(60,600))
			if(!enabled)
				enabled=1
				updateTurrets()

	..()


/obj/machinery/turretid/malf_upgrade(var/mob/living/silicon/ai/user)
	..()
	malf_upgraded = 1
	locked = 1
	to_chat(user, "\The [src] has been upgraded. It has been locked and can not be tampered with by anyone but you and your cyborgs.")
	master_ai = user
	return 1