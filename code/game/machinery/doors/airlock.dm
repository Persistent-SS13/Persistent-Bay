#define BOLTS_FINE 0
#define BOLTS_EXPOSED 1
#define BOLTS_CUT 2

#define AIRLOCK_CLOSED	1
#define AIRLOCK_CLOSING	2
#define AIRLOCK_OPEN	3
#define AIRLOCK_OPENING	4
#define AIRLOCK_DENY	5
#define AIRLOCK_EMAG	6

#define AIRLOCK_PAINTABLE 1
#define AIRLOCK_STRIPABLE 2
#define AIRLOCK_DETAILABLE 4

var/list/airlock_overlays = list()

/obj/machinery/door/airlock
	name = "airlock"
	icon = 'icons/obj/doors/station/door.dmi'
	icon_state = "closed"
	power_channel = ENVIRON
	autoclose = TRUE
	normalspeed = 1
	explosion_resistance = 10
	armor = list(
		DAM_BLUNT  	= 90,
		DAM_PIERCE 	= 80,
		DAM_CUT 	= MaxArmorValue,
		DAM_BULLET 	= 70,
		DAM_ENERGY 	= 70,
		DAM_BURN 	= 90,
		DAM_BOMB 	= 60,
		DAM_EMP 	= 50,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)

	//Radio stuff
	id_tag 				= null
	frequency 			= null
	range 				= AIRLOCK_CONTROL_RANGE
	radio_filter_in 	= RADIO_AIRLOCK
	radio_filter_out 	= RADIO_AIRLOCK
	radio_check_id 		= TRUE

	//Airlock controller
	var/shockedby 		= list()
	var/cur_command 	= null	//the command the door is currently attempting to complete

	//Wires/hacking stuff
	var/aiControlDisabled 			= FALSE 	//If 1, AI control is disabled until the AI hacks back in and disables the lock. If 2, the AI has bypassed the lock. If -1, the control is enabled but the AI had bypassed it earlier, so if it is disabled again the AI would have no trouble getting back in.
	var/hackProof 					= FALSE 	// if 1, this door can't be hacked by the AI
	var/electrified_until 			= 0			//World time when the door is no longer electrified. -1 if it is permanently electrified until someone fixes it.
	var/main_power_lost_until 		= 0	 		//World time when main power is restored.
	var/backup_power_lost_until 	= -1		//World time when backup power is restored.
	var/next_beep_at 				= 0			//World time when we may next beep due to doors being blocked by mobs
	var/spawnPowerRestoreRunning 	= 0
	var/lights 						= 1 		// bolt lights show by default
	var/aiDisabledIdScanner 		= FALSE
	var/aiHacking 					= FALSE
	var/lockdownbyai 				= FALSE
	var/justzap 					= FALSE
	var/safe 						= TRUE
	var/hasShocked 					= FALSE 	//Prevents multiple shocks from happening
	var/secured_wires 				= FALSE
	var/datum/wires/airlock/wires 	= null

	//Door state
	var/welded 			= null
	var/locked 			= FALSE
	var/lock_cut_state 	= BOLTS_FINE
	var/haskeypad 		= FALSE

	//Cycle linking
	var/obj/machinery/door/airlock/closeOther = null	//Ref to other door entity to close/open when this one opens/closes
	var/closeOtherDir = 0								//Direction to look in for another door to close/open when this one opens/closes
	var/closeOtherId = null								//id of door(s) to open/close when this one closes/opens

	//Sounds
	var/open_sound_powered 			= 'sound/machines/airlock_open.ogg'
	var/open_sound_unpowered 		= 'sound/machines/airlock_open_force.ogg'
	var/open_failure_access_denied 	= 'sound/machines/buzz-two.ogg'
	var/close_sound_powered 		= 'sound/machines/airlock_close.ogg'
	var/close_sound_unpowered 		= 'sound/machines/airlock_close_force.ogg'
	var/close_failure_blocked 		= 'sound/machines/triple_beep.ogg'
	var/bolts_dropping 				= 'sound/machines/Custom_bolts.ogg'
	var/bolts_rising 				= 'sound/machines/Custom_boltsup.ogg'

	var/door_crush_damage = DOOR_CRUSH_DAMAGE

	//WIFI
	var/_wifi_id
	var/datum/wifi/receiver/button/door/wifi_receiver
	var/obj/item/weapon/airlock_brace/brace = null
	var/obj/machinery/airlock_controller_norad/norad_controller // For the no radio controller (code/modules/norad_controller)
	var/norad_UID

	//Airlock 2.0 Aesthetics Properties
	//The variables below determine what color the airlock and decorative stripes will be -Cakey
	var/airlock_type = "Standard"
	var/global/list/airlock_icon_cache = list()
	var/paintable = AIRLOCK_PAINTABLE|AIRLOCK_STRIPABLE //0 = Not paintable, 1 = Paintable, 3 = Paintable and Stripable, 7 for Paintable, Stripable and Detailable.
	var/door_color = null
	var/stripe_color = null
	var/symbol_color = null

	var/fill_file 				= 'icons/obj/doors/station/fill_steel.dmi'
	var/color_file 				= 'icons/obj/doors/station/color.dmi'
	var/color_fill_file 		= 'icons/obj/doors/station/fill_color.dmi'
	var/stripe_file 			= 'icons/obj/doors/station/stripe.dmi'
	var/stripe_fill_file 		= 'icons/obj/doors/station/fill_stripe.dmi'
	var/glass_file 				= 'icons/obj/doors/station/fill_glass.dmi'
	var/bolts_file 				= 'icons/obj/doors/station/lights_bolts.dmi'
	var/deny_file 				= 'icons/obj/doors/station/lights_deny.dmi'
	var/lights_file 			= 'icons/obj/doors/station/lights_green.dmi'
	var/panel_file 				= 'icons/obj/doors/station/panel.dmi'
	var/sparks_damaged_file 	= 'icons/obj/doors/station/sparks_damaged.dmi'
	var/sparks_broken_file 		= 'icons/obj/doors/station/sparks_broken.dmi'
	var/welded_file 			= 'icons/obj/doors/station/welded.dmi'
	var/emag_file 				= 'icons/obj/doors/station/emag.dmi'
	var/obj/item/weapon/airlock_electronics/electronics = null
	var/assembly_type = /obj/structure/door_assembly
	var/mineral = null


/obj/machinery/door/airlock/New(var/newloc, var/obj/structure/door_assembly/assembly=null)
	..()
	ADD_SAVED_VAR(aiControlDisabled)
	ADD_SAVED_VAR(haskeypad)
	ADD_SAVED_VAR(hackProof)
	ADD_SAVED_VAR(door_color)
	ADD_SAVED_VAR(stripe_color)
	ADD_SAVED_VAR(symbol_color)
	ADD_SAVED_VAR(_wifi_id)
	ADD_SAVED_VAR(secured_wires)
	ADD_SAVED_VAR(brace)
	ADD_SAVED_VAR(safe)
	ADD_SAVED_VAR(justzap)
	ADD_SAVED_VAR(electronics)
	ADD_SAVED_VAR(mineral)
	ADD_SAVED_VAR(lockdownbyai)
	ADD_SAVED_VAR(closeOtherId)
	ADD_SAVED_VAR(closeOtherDir)
	ADD_SAVED_VAR(aiControlDisabled)
	ADD_SAVED_VAR(hackProof)
	ADD_SAVED_VAR(electrified_until)
	ADD_SAVED_VAR(welded)
	ADD_SAVED_VAR(locked)
	ADD_SAVED_VAR(lock_cut_state)
	ADD_SAVED_VAR(lights)
	ADD_SAVED_VAR(aiDisabledIdScanner)
	ADD_SAVED_VAR(aiHacking)
	ADD_SAVED_VAR(autoclose)

	ADD_SKIP_EMPTY(brace)
	ADD_SKIP_EMPTY(closeOtherId)
	ADD_SKIP_EMPTY(closeOtherDir)
	ADD_SKIP_EMPTY(_wifi_id)
	ADD_SKIP_EMPTY(welded)

	//if assembly is given, create the new door from the assembly
	if (assembly && istype(assembly))
		assembly_type = assembly.type

		electronics = assembly.electronics
		electronics.forceMove(src)

		//update the door's access to match the electronics'
		secured_wires = electronics.secure
		if(electronics.business_name)
			if(electronics.one_access)
				req_one_access_business_list = src.electronics.business_access	//for some reason we were inverting them

			else
				req_access_business_list = src.electronics.business_access
			req_access_business = electronics.business_name

		else if(istype(electronics, /obj/item/weapon/airlock_electronics/personal_electronics))
			var/obj/item/weapon/airlock_electronics/personal_electronics/pe = electronics
			req_access_personal_list = pe.registered_names

		else
			if(electronics.one_access)
				req_access.Cut()
				req_one_access = src.electronics.conf_access

			else
				req_one_access.Cut()
				req_access = src.electronics.conf_access
			req_access_faction = electronics.req_access_faction
		//get the name from the assembly
		if(assembly.created_name)
			name = assembly.created_name
		else
			name = "[istext(assembly.glass) ? "[assembly.glass] airlock" : assembly.base_name]"

		//get the dir from the assembly
		set_dir(assembly.dir)

	//wires
	var/turf/T = get_turf(newloc)
	if(T && (T.z in GLOB.using_map.admin_levels))
		secured_wires = 1
	if (secured_wires)
		wires = new/datum/wires/airlock/secure(src)
	else
		wires = new/datum/wires/airlock(src)

/obj/machinery/door/airlock/Initialize()
	if(QDELETED(src) || !loc) //Don't waste time initing if its been deleted already
		return INITIALIZE_HINT_QDEL
	//wireless connection
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)
	var/turf/T = loc
	var/obj/item/weapon/airlock_brace/A = locate(/obj/item/weapon/airlock_brace) in T
	if(!brace && A)
		brace = A
		brace.airlock = src
		brace.forceMove(src)
	update_connections()
	. = ..()
	queue_icon_update()
	return INITIALIZE_HINT_LATELOAD

//Later on during init check for a nearby door
/obj/machinery/door/airlock/LateInitialize()
	. = ..()
	if(src.closeOtherId != null)
		for (var/obj/machinery/door/airlock/A in world)
			if(A.closeOtherId == src.closeOtherId && A != src)
				src.closeOther = A
				break
	if (src.closeOtherDir)
		cyclelinkairlock()
	


/obj/machinery/door/airlock/Destroy()
	QDEL_NULL(wires)
	QDEL_NULL(wifi_receiver)
	if(brace)
		QDEL_NULL(brace)
	return ..()

/obj/machinery/door/airlock/get_material()
	if(mineral)
		return SSmaterials.get_material_by_name(mineral)
	return SSmaterials.get_material_by_name(MATERIAL_STEEL)


/obj/machinery/door/airlock/personal
	door_color = COLOR_WHITE
	name = "Personal Airlock"
	desc = "A door with a personal access lock for an individual(s)."
	assembly_type = /obj/structure/door_assembly/door_assembly_personal

/obj/machinery/door/airlock/personal/attackby(var/obj/item/C, var/mob/user)
	if(istype(C, /obj/item/weapon/card/id/))
		var/obj/item/weapon/card/id/ID = C
		if(req_access_personal_list.len && ID.registered_name == req_access_personal_list[1])
			if(locked)
				unlock()
			else
				lock()
			to_chat(user, SPAN_NOTICE("You [locked ? "lock" : "unlock"]  \the [src]."))
	..()
/obj/machinery/door/airlock/attack_generic(var/mob/user, var/damage)
	if(inoperable())
		if(damage >= 10)
			if(src.density)
				visible_message("<span class='danger'>\The [user] forces \the [src] open!</span>")
				open(1)
			else
				visible_message("<span class='danger'>\The [user] forces \the [src] closed!</span>")
				close(1)
		else
			visible_message("<span class='notice'>\The [user] strains fruitlessly to force \the [src] [density ? "open" : "closed"].</span>")
		return
	..()


/obj/machinery/door/airlock/Process()
	if (arePowerSystemsOn())
		execute_current_command()

	if(main_power_lost_until > 0 && world.time >= main_power_lost_until)
		regainMainPower()

	if(backup_power_lost_until > 0 && world.time >= backup_power_lost_until)
		regainBackupPower()

	else if(electrified_until > 0 && world.time >= electrified_until)
		electrify(0)
	..()

/*
About the new airlock wires panel:
*	An airlock wire dialog can be accessed by the normal way or by using wirecutters or a multitool on the door while the wire-panel is open. This would show the following wires, which you can either wirecut/mend or send a multitool pulse through. There are 9 wires.
*		one wire from the ID scanner. Sending a pulse through this flashes the red light on the door (if the door has power). If you cut this wire, the door will stop recognizing valid IDs. (If the door has 0000 access, it still opens and closes, though)
*		two wires for power. Sending a pulse through either one causes a breaker to trip, disabling the door for 10 seconds if backup power is connected, or 1 minute if not (or until backup power comes back on, whichever is shorter). Cutting either one disables the main door power, but unless backup power is also cut, the backup power re-powers the door in 10 seconds. While unpowered, the door may be open, but bolts-raising will not work. Cutting these wires may electrocute the user.
*		one wire for door bolts. Sending a pulse through this drops door bolts (whether the door is powered or not) or raises them (if it is). Cutting this wire also drops the door bolts, and mending it does not raise them. If the wire is cut, trying to raise the door bolts will not work.
*		two wires for backup power. Sending a pulse through either one causes a breaker to trip, but this does not disable it unless main power is down too (in which case it is disabled for 1 minute or however long it takes main power to come back, whichever is shorter). Cutting either one disables the backup door power (allowing it to be crowbarred open, but disabling bolts-raising), but may electocute the user.
*		one wire for opening the door. Sending a pulse through this while the door has power makes it open the door if no access is required.
*		one wire for AI control. Sending a pulse through this blocks AI control for a second or so (which is enough to see the AI control light on the panel dialog go off and back on again). Cutting this prevents the AI from controlling the door unless it has hacked the door through the power connection (which takes about a minute). If both main and backup power are cut, as well as this wire, then the AI cannot operate or hack the door at all.
*		one wire for electrifying the door. Sending a pulse through this electrifies the door for 30 seconds. Cutting this wire electrifies the door, so that the next person to touch the door without insulated gloves gets electrocuted. (Currently it is also STAYING electrified until someone mends the wire)
*		one wire for controling door safetys.  When active, door does not close on someone.  When cut, door will ruin someone's shit.  When pulsed, door will immedately ruin someone's shit.
*		one wire for controlling door speed.  When active, dor closes at normal rate.  When cut, door does not close manually.  When pulsed, door attempts to close every tick.
*/

/obj/machinery/door/airlock/bumpopen(mob/living/user as mob) //Airlocks now zap you when you 'bump' them open when they're electrified. --NeoFite
	if(!issilicon(usr))
		if(src.isElectrified())
			if(!src.justzap)
				if(src.shock(user, 100))
					src.justzap = 1
					spawn (10)
						src.justzap = 0
					return
			else /*if(src.justzap)*/
				return
		else if(prob(10) && src.operating == 0)
			var/mob/living/carbon/C = user
			if(istype(C) && C.hallucination_power > 25)
				to_chat(user, "<span class='danger'>You feel a powerful shock course through your body!</span>")
				user.adjustHalLoss(10)
				user.Stun(10)
				return
	..(user)

/obj/machinery/door/airlock/bumpopen(mob/living/simple_animal/user as mob)
	..(user)

/obj/machinery/door/airlock/Bumped(atom/AM)
	..(AM)
	if(istype(AM, /obj/mecha))
		var/obj/mecha/mecha = AM
		if(density && has_transmitter() && mecha.occupant && (src.allowed(mecha.occupant) || src.check_access_list(mecha.operation_req_access)))
			send_status(1)
	return

/obj/machinery/door/airlock/proc/isElectrified()
	if(src.electrified_until != 0)
		return 1
	return 0

/obj/machinery/door/airlock/proc/isWireCut(var/wireIndex)
	// You can find the wires in the datum folder.
	if(!wires)
		if (secured_wires)
			wires = new/datum/wires/airlock/secure(src)
		else
			wires = new/datum/wires/airlock(src)
	return wires.IsIndexCut(wireIndex)

/obj/machinery/door/airlock/proc/canAIControl()
	return ((src.aiControlDisabled!=1) && (!src.isAllPowerLoss()));

/obj/machinery/door/airlock/proc/canAIHack()
	return ((src.aiControlDisabled==1) && (!hackProof) && (!src.isAllPowerLoss()));

/obj/machinery/door/airlock/proc/arePowerSystemsOn()
	if (inoperable())
		return FALSE
	return (src.main_power_lost_until==0 || src.backup_power_lost_until==0)

/obj/machinery/door/airlock/requiresID()
	return !(src.isWireCut(AIRLOCK_WIRE_IDSCAN) || aiDisabledIdScanner)

/obj/machinery/door/airlock/proc/isAllPowerLoss()
	if(inoperable())
		return TRUE
	if(mainPowerCablesCut() && backupPowerCablesCut())
		return TRUE
	return FALSE

/obj/machinery/door/airlock/proc/mainPowerCablesCut()
	return src.isWireCut(AIRLOCK_WIRE_MAIN_POWER1) || src.isWireCut(AIRLOCK_WIRE_MAIN_POWER2)

/obj/machinery/door/airlock/proc/backupPowerCablesCut()
	return src.isWireCut(AIRLOCK_WIRE_BACKUP_POWER1) || src.isWireCut(AIRLOCK_WIRE_BACKUP_POWER2)

/obj/machinery/door/airlock/proc/loseMainPower()
	main_power_lost_until = mainPowerCablesCut() ? -1 : world.time + SecondsToTicks(60)

	// If backup power is permanently disabled then activate in 10 seconds if possible, otherwise it's already enabled or a timer is already running
	if(backup_power_lost_until == -1 && !backupPowerCablesCut())
		backup_power_lost_until = world.time + SecondsToTicks(10)

	// Disable electricity if required
	if(electrified_until && isAllPowerLoss())
		electrify(0)

	update_icon()

/obj/machinery/door/airlock/proc/loseBackupPower()
	backup_power_lost_until = backupPowerCablesCut() ? -1 : world.time + SecondsToTicks(60)

	// Disable electricity if required
	if(electrified_until && isAllPowerLoss())
		electrify(0)

	update_icon()

/obj/machinery/door/airlock/proc/regainMainPower()
	if(!mainPowerCablesCut())
		main_power_lost_until = 0
		// If backup power is currently active then disable, otherwise let it count down and disable itself later
		if(!backup_power_lost_until)
			backup_power_lost_until = -1

	update_icon()

/obj/machinery/door/airlock/proc/regainBackupPower()
	if(!backupPowerCablesCut())
		// Restore backup power only if main power is offline, otherwise permanently disable
		backup_power_lost_until = main_power_lost_until == 0 ? -1 : 0

	update_icon()

/obj/machinery/door/airlock/proc/electrify(var/duration, var/feedback = 0)
	var/message = ""
	if(src.isWireCut(AIRLOCK_WIRE_ELECTRIFY) && arePowerSystemsOn())
		message = text("The electrification wire is cut - Door permanently electrified.")
		src.electrified_until = -1
		. = 1
	else if(duration && !arePowerSystemsOn())
		message = text("The door is unpowered - Cannot electrify the door.")
		src.electrified_until = 0
	else if(!duration && electrified_until != 0)
		message = "The door is now un-electrified."
		src.electrified_until = 0
	else if(duration)	//electrify door for the given duration seconds
		if(usr)
			shockedby += text("\[[time_stamp()]\] - [key_name(usr)]")
			admin_attacker_log(usr, "electrified \the [name] [duration == -1 ? "permanently" : "for [duration] second\s"]")
		else
			shockedby += text("\[[time_stamp()]\] - EMP)")
		message = "The door is now electrified [duration == -1 ? "permanently" : "for [duration] second\s"]."
		src.electrified_until = duration == -1 ? -1 : world.time + SecondsToTicks(duration)
		. = 1

	if(feedback && message)
		to_chat(usr, message)
	if(.)
		playsound(src, 'sound/effects/sparks3.ogg', 30, 0, -6)

/obj/machinery/door/airlock/proc/set_idscan(var/activate, var/feedback = 0)
	var/message = ""
	if(src.isWireCut(AIRLOCK_WIRE_IDSCAN))
		message = "The IdScan wire is cut - IdScan feature permanently disabled."
	else if(activate && src.aiDisabledIdScanner)
		src.aiDisabledIdScanner = 0
		message = "IdScan feature has been enabled."
	else if(!activate && !src.aiDisabledIdScanner)
		src.aiDisabledIdScanner = 1
		message = "IdScan feature has been disabled."

	if(feedback && message)
		to_chat(usr, message)

/obj/machinery/door/airlock/proc/set_safeties(var/activate, var/feedback = 0)
	var/message = ""
	// Safeties!  We don't need no stinking safeties!
	if (src.isWireCut(AIRLOCK_WIRE_SAFETY))
		message = text("The safety wire is cut - Cannot enable safeties.")
	else if (!activate && src.safe)
		safe = 0
	else if (activate && !src.safe)
		safe = 1

	if(feedback && message)
		to_chat(usr, message)

// shock user with probability prb (if all connections & power are working)
// returns 1 if shocked, 0 otherwise
// The preceding comment was borrowed from the grille's shock script
/obj/machinery/door/airlock/shock(mob/user, prb)
	if(!arePowerSystemsOn())
		return 0
	if(hasShocked)
		return 0	//Already shocked someone recently?
	if(..())
		hasShocked = 1
		sleep(10)
		hasShocked = 0
		return 1
	else
		return 0

/obj/machinery/door/airlock/update_icon(state=0, override=0)
	update_connections()
	switch(state)
		if(0)
			if(density)
				icon_state = "closed"
				state = AIRLOCK_CLOSED
			else
				icon_state = "open"
				state = AIRLOCK_OPEN
		if(AIRLOCK_OPEN)
			icon_state = "open"
		if(AIRLOCK_CLOSED)
			icon_state = "closed"
		if(AIRLOCK_OPENING, AIRLOCK_CLOSING, AIRLOCK_EMAG, AIRLOCK_DENY)
			icon_state = ""

	set_airlock_overlays(state)

/obj/machinery/door/airlock/proc/set_airlock_overlays(state)
	var/icon/color_overlay
	var/icon/filling_overlay
	var/icon/stripe_overlay
	var/icon/stripe_filling_overlay
	var/icon/lights_overlay
	var/icon/panel_overlay
	var/icon/weld_overlay
	var/icon/damage_overlay
	var/icon/sparks_overlay
	var/icon/brace_overlay

	set_light(0)

	if(door_color && !(door_color == "none"))
		var/ikey = "[airlock_type]-[door_color]-color"
		color_overlay = airlock_icon_cache["[ikey]"]
		if(!color_overlay)
			color_overlay = new(color_file)
			color_overlay.Blend(door_color, ICON_MULTIPLY)
			airlock_icon_cache["[ikey]"] = color_overlay
	if(glass)
		filling_overlay = glass_file
	else
		if(door_color && !(door_color == "none"))
			var/ikey = "[airlock_type]-[door_color]-fillcolor"
			filling_overlay = airlock_icon_cache["[ikey]"]
			if(!filling_overlay)
				filling_overlay = new(color_fill_file)
				filling_overlay.Blend(door_color, ICON_MULTIPLY)
				airlock_icon_cache["[ikey]"] = filling_overlay
		else
			filling_overlay = fill_file
	if(stripe_color && !(stripe_color == "none"))
		var/ikey = "[airlock_type]-[stripe_color]-stripe"
		stripe_overlay = airlock_icon_cache["[ikey]"]
		if(!stripe_overlay)
			stripe_overlay = new(stripe_file)
			stripe_overlay.Blend(stripe_color, ICON_MULTIPLY)
			airlock_icon_cache["[ikey]"] = stripe_overlay
		if(!glass)
			var/ikey2 = "[airlock_type]-[stripe_color]-fillstripe"
			stripe_filling_overlay = airlock_icon_cache["[ikey2]"]
			if(!stripe_filling_overlay)
				stripe_filling_overlay = new(stripe_fill_file)
				stripe_filling_overlay.Blend(stripe_color, ICON_MULTIPLY)
				airlock_icon_cache["[ikey2]"] = stripe_filling_overlay

	switch(state)
		if(AIRLOCK_CLOSED)
			if(p_open)
				panel_overlay = panel_file
			if(welded)
				weld_overlay = welded_file
			if(stat & BROKEN)
				damage_overlay = sparks_broken_file
			else if(health < max_health * 3/4)
				damage_overlay = sparks_damaged_file
			if(lights && src.arePowerSystemsOn())
				if(locked)
					lights_overlay = bolts_file
					set_light(0.25, 0.1, 1, 2, COLOR_RED_LIGHT)

		if(AIRLOCK_DENY)
			if(!src.arePowerSystemsOn())
				return
			if(p_open)
				panel_overlay = panel_file
			if(stat & BROKEN)
				damage_overlay = sparks_broken_file
			else if(health < max_health * 3/4)
				damage_overlay = sparks_damaged_file
			if(welded)
				weld_overlay = welded_file
			if(lights && src.arePowerSystemsOn())
				lights_overlay = deny_file
				set_light(0.25, 0.1, 1, 2, COLOR_RED_LIGHT)

		if(AIRLOCK_EMAG)
			sparks_overlay = emag_file
			if(p_open)
				panel_overlay = panel_file
			if(stat & BROKEN)
				damage_overlay = sparks_broken_file
			else if(health < max_health * 3/4)
				damage_overlay = sparks_damaged_file
			if(welded)
				weld_overlay = welded_file

		if(AIRLOCK_CLOSING)
			if(lights && src.arePowerSystemsOn())
				lights_overlay = lights_file
				set_light(0.25, 0.1, 1, 2, COLOR_LIME)
			if(p_open)
				panel_overlay = panel_file

		if(AIRLOCK_OPEN)
			if(stat & BROKEN)
				damage_overlay = sparks_broken_file
			else if(health < max_health * 3/4)
				damage_overlay = sparks_damaged_file

		if(AIRLOCK_OPENING)
			if(lights && src.arePowerSystemsOn())
				lights_overlay = lights_file
				set_light(0.25, 0.1, 1, 2, COLOR_LIME)
			if(p_open)
				panel_overlay = panel_file

	if(brace)
		brace.update_icon()
		brace_overlay += image(brace.icon, brace.icon_state)

	overlays.Cut()

	overlays += color_overlay
	overlays += filling_overlay
	overlays += stripe_overlay
	overlays += stripe_filling_overlay
	overlays += panel_overlay
	overlays += weld_overlay
	overlays += brace_overlay
	overlays += lights_overlay
	overlays += sparks_overlay
	overlays += damage_overlay

/obj/machinery/door/airlock/do_animate(animation)
	if(overlays)
		overlays.Cut()

	switch(animation)
		if("opening")
			set_airlock_overlays(AIRLOCK_OPENING)
			flick("opening", src)//[stat ? "_stat":]
			update_icon(AIRLOCK_OPEN)
		if("closing")
			set_airlock_overlays(AIRLOCK_CLOSING)
			flick("closing", src)
			update_icon(AIRLOCK_CLOSED)
		if("deny")
			if(density && src.arePowerSystemsOn())
				set_airlock_overlays(AIRLOCK_DENY)
				flick("deny", src)
				if(secured_wires)
					playsound(src.loc, open_failure_access_denied, 50, 0)
				update_icon(AIRLOCK_CLOSED)
		if("emag")
			if(density && src.arePowerSystemsOn())
				set_airlock_overlays(AIRLOCK_EMAG)
				flick("deny", src)
		else
			update_icon()
	return

/obj/machinery/door/airlock/attack_ai(mob/user as mob)
	ui_interact(user)


/obj/machinery/door/airlock/attack_robot(mob/user as mob)
	if(Adjacent(user))
		bumpopen(user)

/obj/machinery/door/airlock/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/data[0]

	data["main_power_loss"]		= round(main_power_lost_until 	> 0 ? max(main_power_lost_until - world.time,	0) / 10 : main_power_lost_until,	1)
	data["backup_power_loss"]	= round(backup_power_lost_until	> 0 ? max(backup_power_lost_until - world.time,	0) / 10 : backup_power_lost_until,	1)
	data["electrified"] 		= round(electrified_until		> 0 ? max(electrified_until - world.time, 	0) / 10 	: electrified_until,		1)
	data["open"] = !density

	var/commands[0]
	commands[++commands.len] = list("name" = "IdScan",					"command"= "idscan",				"active" = !aiDisabledIdScanner,	"enabled" = "Enabled",	"disabled" = "Disable",		"danger" = 0, "act" = 1)
	commands[++commands.len] = list("name" = "Bolts",					"command"= "bolts",					"active" = !locked,					"enabled" = "Raised ",	"disabled" = "Dropped",		"danger" = 0, "act" = 0)
	commands[++commands.len] = list("name" = "Lights",					"command"= "lights",				"active" = lights,					"enabled" = "Enabled",	"disabled" = "Disable",		"danger" = 0, "act" = 1)
	commands[++commands.len] = list("name" = "Safeties",				"command"= "safeties",				"active" = safe,					"enabled" = "Nominal",	"disabled" = "Overridden",	"danger" = 1, "act" = 0)
	commands[++commands.len] = list("name" = "Timing",					"command"= "timing",				"active" = normalspeed,				"enabled" = "Nominal",	"disabled" = "Overridden",	"danger" = 1, "act" = 0)
	commands[++commands.len] = list("name" = "Door State",				"command"= "open",					"active" = density,					"enabled" = "Closed",	"disabled" = "Opened", 		"danger" = 0, "act" = 0)

	data["commands"] = commands

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "door_control.tmpl", "Door Controls", 450, 350, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/door/airlock/proc/hack(mob/user as mob)
	if(src.aiHacking==0)
		src.aiHacking=1
		spawn(20)
			//TODO: Make this take a minute
			to_chat(user, "Airlock AI control has been blocked. Beginning fault-detection.")
			sleep(50)
			if(src.canAIControl())
				to_chat(user, "Alert cancelled. Airlock control has been restored without our assistance.")
				src.aiHacking=0
				return
			else if(!src.canAIHack(user))
				to_chat(user, "We've lost our connection! Unable to hack airlock.")
				src.aiHacking=0
				return
			to_chat(user, "Fault confirmed: airlock control wire disabled or cut.")
			sleep(20)
			to_chat(user, "Attempting to hack into airlock. This may take some time.")
			sleep(200)
			if(src.canAIControl())
				to_chat(user, "Alert cancelled. Airlock control has been restored without our assistance.")
				src.aiHacking=0
				return
			else if(!src.canAIHack(user))
				to_chat(user, "We've lost our connection! Unable to hack airlock.")
				src.aiHacking=0
				return
			to_chat(user, "Upload access confirmed. Loading control program into airlock software.")
			sleep(170)
			if(src.canAIControl())
				to_chat(user, "Alert cancelled. Airlock control has been restored without our assistance.")
				src.aiHacking=0
				return
			else if(!src.canAIHack(user))
				to_chat(user, "We've lost our connection! Unable to hack airlock.")
				src.aiHacking=0
				return
			to_chat(user, "Transfer complete. Forcing airlock to execute program.")
			sleep(50)
			//disable blocked control
			src.aiControlDisabled = 2
			to_chat(user, "Receiving control information from airlock.")
			sleep(10)
			//bring up airlock dialog
			src.aiHacking = 0
			if (user)
				src.attack_ai(user)

/obj/machinery/door/airlock/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (src.isElectrified())
		if (istype(mover, /obj/item))
			var/obj/item/i = mover
			if (i.matter && (MATERIAL_STEEL in i.matter) && i.matter[MATERIAL_STEEL] > 0)
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(5, 1, src)
				s.start()
	return ..()

/obj/machinery/door/airlock/attack_hand(mob/user as mob)
	if(!istype(usr, /mob/living/silicon))
		if(src.isElectrified())
			if(src.shock(user, 100))
				return

	if(src.p_open)
		user.set_machine(src)
		wires.Interact(user)
	else
		..(user)
	return

/obj/machinery/door/airlock/CanUseTopic(var/mob/user)
	if(operating < 0) //emagged
		to_chat(user, "<span class='warning'>Unable to interface: Internal error.</span>")
		return STATUS_CLOSE
	if(issilicon(user) && !src.canAIControl())
		if(src.canAIHack(user))
			src.hack(user)
		else
			if (src.isAllPowerLoss()) //don't really like how this gets checked a second time, but not sure how else to do it.
				to_chat(user, "<span class='warning'>Unable to interface: Connection timed out.</span>")
			else
				to_chat(user, "<span class='warning'>Unable to interface: Connection refused.</span>")
		return STATUS_CLOSE

	return ..()

//Radio signal handling
/obj/machinery/door/airlock/OnSignal(var/datum/signal/signal)
	. = ..()
	log_debug("[src]\ref[src] got signal [signal.data["command"]]")
	OnTopic(usr, signal.data, GLOB.default_state)

/obj/machinery/door/airlock/OnTopic(mob/user, href_list, datum/topic_state/state)
	if(..())
		return 1

	var/activate = text2num(href_list["activate"])
	switch (href_list["command"])
		if("idscan")
			set_idscan(activate, 1)
		if("main_power")
			if(!main_power_lost_until)
				src.loseMainPower()
		if("backup_power")
			if(!backup_power_lost_until)
				src.loseBackupPower()
		if("bolts")
			if(src.isWireCut(AIRLOCK_WIRE_DOOR_BOLTS))
				to_chat(usr, "The door bolt control wire is cut - Door bolts permanently dropped.")
			else if(activate && src.lock())
				to_chat(usr, "The door bolts have been dropped.")
			else if(!activate && src.unlock())
				to_chat(usr, "The door bolts have been raised.")
		if("electrify_temporary")
			electrify(30 * activate, 1)
		if("electrify_permanently")
			electrify(-1 * activate, 1)
		if("open", "close")
			if(src.welded)
				to_chat(usr, text("The airlock has been welded shut!"))
			else if(src.locked)
				to_chat(usr, text("The door bolts are down!"))
			else if(activate && density)
				open()
			else if(!activate && !density)
				close()
		if("safeties")
			set_safeties(!activate, 1)
		if("timing")
			// Door speed control
			if(src.isWireCut(AIRLOCK_WIRE_SPEED))
				to_chat(usr, text("The timing wire is cut - Cannot alter timing."))
			else if (activate && src.normalspeed)
				normalspeed = 0
			else if (!activate && !src.normalspeed)
				normalspeed = 1
		if("lights")
			// Lights
			if(src.isWireCut(AIRLOCK_WIRE_LIGHT))
				to_chat(usr, "The bolt lights wire is cut - The door bolt lights are permanently disabled.")
			else if (!activate && src.lights)
				lights = 0
				to_chat(usr, "The door bolt lights have been disabled.")
			else if (activate && !src.lights)
				lights = 1
				to_chat(usr, "The door bolt lights have been enabled.")

	update_icon()
	return 1

//returns 1 on success, 0 on failure
/obj/machinery/door/airlock/proc/cut_bolts(var/obj/item/item, var/mob/user)
	var/cut_delay = (15 SECONDS)
	var/cut_verb
	var/cut_sound

	if(isWelder(item))
		var/obj/item/weapon/tool/weldingtool/WT = item
		if(!WT.isOn())
			return 0
		if(!WT.remove_fuel(0,user))
			to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
			return 0
		cut_verb = "cutting"
		cut_sound = 'sound/items/Welder.ogg'
	else if(istype(item,/obj/item/weapon/gun/energy/plasmacutter)) //They could probably just shoot them out, but who cares!
		cut_verb = "cutting"
		cut_sound = 'sound/items/Welder.ogg'
		cut_delay *= 0.66
	else if(istype(item,/obj/item/weapon/melee/energy/blade) || istype(item,/obj/item/weapon/melee/energy/sword))
		cut_verb = "slicing"
		cut_sound = "sparks"
		cut_delay *= 0.66
	else if(istype(item,/obj/item/weapon/circular_saw))
		cut_verb = "sawing"
		cut_sound = 'sound/weapons/circsawhit.ogg'
		cut_delay *= 1.5

	else if(istype(item,/obj/item/weapon/material/twohanded/fireaxe))
		//special case - zero delay, different message
		if (src.lock_cut_state == BOLTS_EXPOSED)
			return 0 //can't actually cut the bolts, go back to regular smashing
		var/obj/item/weapon/material/twohanded/fireaxe/F = item
		if (!F.wielded)
			return 0
		user.visible_message(
			"<span class='danger'>\The [user] smashes the bolt cover open!</span>",
			"<span class='warning'>You smash the bolt cover open!</span>"
			)
		playsound(src, 'sound/weapons/smash.ogg', 100, 1)
		src.lock_cut_state = BOLTS_EXPOSED
		return 0

	else
		// I guess you can't cut bolts with that item. Never mind then.
		return 0

	if (src.lock_cut_state == BOLTS_FINE)
		user.visible_message(
			"<span class='notice'>\The [user] begins [cut_verb] through the bolt cover on [src].</span>",
			"<span class='notice'>You begin [cut_verb] through the bolt cover.</span>"
			)

		playsound(src, cut_sound, 100, 1)
		if (do_after(user, cut_delay, src))
			user.visible_message(
				"<span class='notice'>\The [user] removes the bolt cover from [src]</span>",
				"<span class='notice'>You remove the cover and expose the door bolts.</span>"
				)
			src.lock_cut_state = BOLTS_EXPOSED
		return 1

	if (src.lock_cut_state == BOLTS_EXPOSED)
		user.visible_message(
			"<span class='notice'>\The [user] begins [cut_verb] through [src]'s bolts.</span>",
			"<span class='notice'>You begin [cut_verb] through the door bolts.</span>"
			)
		playsound(src, cut_sound, 100, 1)
		if (do_after(user, cut_delay, src))
			user.visible_message(
				"<span class='notice'>\The [user] severs the door bolts, unlocking [src].</span>",
				"<span class='notice'>You sever the door bolts, unlocking the door.</span>"
				)
			src.lock_cut_state = BOLTS_CUT
			src.unlock(1) //force it
		return 1

/obj/machinery/door/airlock/attackby(var/obj/item/C, var/mob/user)
	// Brace is considered installed on the airlock, so interacting with it is protected from electrification.
	if(brace && (istype(C.GetIdCard(), /obj/item/weapon/card/id/) || istype(C, /obj/item/weapon/tool/crowbar/brace_jack)))
		return brace.attackby(C, user)

	if(!brace && istype(C, /obj/item/weapon/airlock_brace))
		var/obj/item/weapon/airlock_brace/A = C
		if(!density)
			to_chat(user, "<span class='warning'>You must close \the [src] before installing \the [A]!</span>")
			return

		if((!length(A.req_access) && !A.req_one_access) && (alert("\the [A]'s 'Access Not Set' light is flashing. Install it anyway?", "Access not set", "Yes", "No") == "No"))
			return

		if(do_after(user, 50, src) && density && A && user.unEquip(A, src))
			to_chat(user, SPAN_NOTICE("You successfully install \the [A]. \The [src] has been locked."))
			brace = A
			brace.airlock = src
			update_icon()
		return

	if(!istype(usr, /mob/living/silicon))
		if(src.isElectrified())
			if(src.shock(user, 75))
				return
	if(istype(C, /obj/item/taperoll))
		return

	if (!repairing && (stat & BROKEN) && src.locked) //bolted and broken
		if (!cut_bolts(C,user))
			..()
		return

	if(!repairing && isWelder(C) && !( src.operating > 0 ) && src.density)
		var/obj/item/weapon/tool/weldingtool/W = C
		if(W.use_tool(user, src, 1))
			src.welded = !src.welded
			src.update_icon()
		return
	else if(isScrewdriver(C))
		if (src.p_open)
			if (stat & BROKEN)
				to_chat(user, "<span class='warning'>The panel is broken, and cannot be closed.</span>")
			else
				src.p_open = 0
		else
			if(allowed(usr))
				src.p_open = 1
			else
				to_chat(usr, "<span class='warning'>You begin to carefully pry open the access panel on the [src]...</span>")
				if(do_after(user,40,src))
					if(prob(70))
						usr.visible_message("[usr] forcefully prys open the access panel on the [src]!", "You manage to pry open the access panel on the [src]!")
						src.p_open = 1
					else
						to_chat(usr, "<span class='warning'>Your hand slips!</span>")
		src.update_icon()
	else if(isWirecutter(C))
		return src.attack_hand(user)
	else if(isMultitool(C))
		var/obj/item/device/multitool/mt = C
		if (istype(mt.get_buffer(), /obj/machinery/airlock_controller_norad))
			var/obj/machinery/airlock_controller_norad/link = mt.get_buffer()
			if (!istype(link) )
				return 0
			//checks if the linked airlock_controller_norad is in range.
			if (!(link in view(NORAD_MAX_RANGE) ) )
				to_chat(user, "<span class='warning'>\The [link] is too far away. Its effective range should be around [NORAD_MAX_RANGE] tiles.</span>")
				return
			//the actual (un)linkage below
			if (norad_controller)
				to_chat(user, "<span class='warning'>You unlink \the [src] from \the [norad_controller].</span>")
				if (norad_controller.tag_exterior_door == src)
					norad_controller.tag_exterior_door = null
				if (norad_controller.tag_interior_door == src)
					norad_controller.tag_interior_door = null
				norad_controller = null
			else
				norad_controller = link
				var/sensor_type = input("Select a sensor type.","Airlock Sensor", "cycle") in list("exterior","interior")
				if (sensor_type == "exterior")
					if (norad_controller.tag_exterior_door)
						sensor_type = "cycle"
					else
						norad_controller.tag_exterior_door = src
				if (sensor_type == "interior")
					if (norad_controller.tag_interior_door)
						sensor_type = "cycle"
					else
						norad_controller.tag_interior_door = src

				if (sensor_type == "cycle")
					norad_controller = null
					to_chat(user, "<span class='warning'>You attempted to link \the [src] to \the [link], but it failed.</span>")
					return
				to_chat(user, "<span class='notice'>You link \the [src] to \the [link].</span>")
			return
		return src.attack_hand(user)
	else if(istype(C, /obj/item/device/assembly/signaler))
		return src.attack_hand(user)
	else if(istype(C, /obj/item/weapon/pai_cable))	// -- TLE
		var/obj/item/weapon/pai_cable/cable = C
		cable.plugin(src, user)
	else if(!repairing && isCrowbar(C))
		if(src.p_open && (operating < 0 || (!operating && welded && !src.arePowerSystemsOn() && density && !src.locked)) && !brace)
			playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
			user.visible_message("[user] removes the electronics from the airlock assembly.", "You start to remove electronics from the airlock assembly.")
			if(do_after(user,40,src))
				to_chat(user, "<span class='notice'>You've removed the airlock electronics!</span>")
				deconstruct(user)
				return
		else if(arePowerSystemsOn())
			to_chat(user, "<span class='notice'>The airlock's motors resist your efforts to force it.</span>")
		else if(locked)
			to_chat(user, "<span class='notice'>The airlock's bolts prevent it from being forced.</span>")
		else if(brace)
			to_chat(user, "<span class='notice'>The airlock's brace holds it firmly in place.</span>")
		else
			if(density)
				spawn(0)	open(1)
			else
				spawn(0)	close(1)

			//if door is unbroken, but at half health or less, hit with fire axe using harm intent
	else if (istype(C, /obj/item/weapon/material/twohanded/fireaxe) && !(stat & BROKEN) && (src.health <= src.max_health / 2) && user.a_intent == I_HURT)
		var/obj/item/weapon/material/twohanded/fireaxe/F = C
		if (F.wielded)
			playsound(src, 'sound/weapons/smash.ogg', 100, 1)
			user.visible_message("<span class='danger'>[user] smashes \the [C] into the airlock's control panel! It explodes in a shower of sparks!</span>", "<span class='danger'>You smash \the [C] into the airlock's control panel! It explodes in a shower of sparks!</span>")
			health = 0
			set_broken(TRUE)
		else
			..()
			return

	else if(istype(C, /obj/item/weapon/material/twohanded/fireaxe) && !arePowerSystemsOn())
		if(locked)
			to_chat(user, "<span class='notice'>The airlock's bolts prevent it from being forced.</span>")
		else if( !welded && !operating )
			if(density)
				var/obj/item/weapon/material/twohanded/fireaxe/F = C
				if(F.wielded)
					spawn(0)	open(1)
				else
					to_chat(user, "<span class='warning'>You need to be wielding \the [C] to do that.</span>")
			else
				var/obj/item/weapon/material/twohanded/fireaxe/F = C
				if(F.wielded)
					spawn(0)	close(1)
				else
					to_chat(user, "<span class='warning'>You need to be wielding \the [C] to do that.</span>")

	else if(istype(C, /obj/item/device/floor_painter))
		return

	else
		..()
	return

/obj/machinery/door/airlock/deconstruct(mob/user, var/moved = FALSE)
	var/obj/structure/door_assembly/da = new assembly_type(src.loc)
	if (istype(da, /obj/structure/door_assembly/multi_tile))
		da.set_dir(src.dir)
	if(mineral)
		da.glass = mineral
	//else if(glass)
	else if(glass && !da.glass)
		da.glass = 1

	da.paintable = paintable
	da.door_color = door_color
	da.stripe_color = stripe_color
	da.symbol_color = symbol_color

	if(moved)
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start()
	else
		da.anchored = 1
	da.state = 1
	da.created_name = src.name
	da.update_state()

	if(operating == -1 || (stat & BROKEN))
		new /obj/item/weapon/circuitboard/broken(src.loc)
		operating = 0
	else
		if (!electronics) 
			create_electronics()

		electronics.dropInto(loc)
		electronics = null

	qdel(src)

	return da
/obj/machinery/door/airlock/phoron/attackby(C as obj, mob/user as mob)
	if(C)
		ignite(is_hot(C))
	..()

/obj/machinery/door/airlock/set_broken(new_state)
	. = ..()
	if(. && new_state)
		p_open = 1
		if (secured_wires)
			lock()
		visible_message("\The [src]'s control panel bursts open, sparks spewing out!")
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start()

/obj/machinery/door/airlock/open(var/forced=0)
	if(!can_open(forced))
		return 0
	use_power_oneoff(360)	//360 W seems much more appropriate for an actuator moving an industrial door capable of crushing people

	//if the door is unpowered then it doesn't make sense to hear the woosh of a pneumatic actuator
	if(arePowerSystemsOn())
		playsound(src.loc, open_sound_powered, 100, 1)
	else
		playsound(src.loc, open_sound_unpowered, 100, 1)

	if(src.closeOther != null && istype(src.closeOther, /obj/machinery/door/airlock/) && !src.closeOther.density)
		src.closeOther.close()
	if(!forced)
		send_status()
	return ..()

/obj/machinery/door/airlock/can_open(var/forced=0)
	if(brace)
		return 0

	if(!forced)
		if(!arePowerSystemsOn() || isWireCut(AIRLOCK_WIRE_OPEN_DOOR))
			return 0

	if(locked || welded)
		return 0
	return ..()

/obj/machinery/door/airlock/can_close(var/forced=0)
	if(locked || welded)
		return 0

	if(!forced)
		//despite the name, this wire is for general door control.
		if(!arePowerSystemsOn() || isWireCut(AIRLOCK_WIRE_OPEN_DOOR))
			return	0

	return ..()

/obj/machinery/door/airlock/close(var/forced=0)
	if(!can_close(forced))
		return 0

	if(safe)
		for(var/turf/turf in locs)
			for(var/atom/movable/AM in turf)
				if(AM.blocks_airlock())
					if(world.time > next_beep_at)
						playsound(src.loc, close_failure_blocked, 30, 0, -3)
						next_beep_at = world.time + SecondsToTicks(10)
					close_door_at = world.time + 6
					return

	for(var/turf/turf in locs)
		for(var/atom/movable/AM in turf)
			if(AM.airlock_crush(door_crush_damage))
				take_damage(door_crush_damage)
				use_power_oneoff(door_crush_damage * 100)		// Uses bunch extra power for crushing the target.

	use_power_oneoff(360)	//360 W seems much more appropriate for an actuator moving an industrial door capable of crushing people
	if(arePowerSystemsOn())
		playsound(src.loc, close_sound_powered, 100, 1)
	else
		playsound(src.loc, close_sound_unpowered, 100, 1)
	if(!forced)
		send_status()
	..()

/obj/machinery/door/airlock/proc/lock(var/forced=0)
	if(locked)
		return 0

	if (operating && !forced) return 0

	if (lock_cut_state == BOLTS_CUT) return 0 //what bolts?

	src.locked = 1
	playsound(src, bolts_dropping, 30, 0, -6)
	audible_message("You hear a click from the bottom of the door.", hearing_distance = 1)
	update_icon()
	return 1

/obj/machinery/door/airlock/proc/unlock(var/forced=0)
	if(!src.locked)
		return

	if (!forced)
		if(operating || !src.arePowerSystemsOn() || isWireCut(AIRLOCK_WIRE_DOOR_BOLTS))
			return

	src.locked = 0
	playsound(src, bolts_rising, 30, 0, -6)
	audible_message("You hear a click from the bottom of the door.", hearing_distance = 1)
	update_icon()
	return 1

/obj/machinery/door/airlock/allowed(mob/M)
	if(locked && !norad_controller)
		return 0
	return ..(M)

/obj/machinery/door/airlock/proc/cyclelinkairlock()
	if (closeOther)
		closeOther.closeOther = null
		closeOther = null
	if (!closeOtherDir)
		return
	var/limit = world.view
	var/turf/T = get_turf(src)
	var/obj/machinery/door/airlock/FoundDoor
	do
		T = get_step(T, closeOtherDir)
		FoundDoor = locate() in T
		if (FoundDoor && FoundDoor.closeOtherDir != get_dir(FoundDoor, src))
			FoundDoor = null
		limit--
	while(!FoundDoor && limit)
	if (!FoundDoor)
		log_world("### MAP WARNING, [src] at [src.x],[src.y],[src.z] failed to find a valid airlock to cyclelink with!")
		return
	FoundDoor.closeOther = src
	closeOther = FoundDoor



// Most doors will never be deconstructed over the course of a round,
// so as an optimization defer the creation of electronics until
// the airlock is deconstructed
/obj/machinery/door/airlock/create_electronics()
	//create new electronics
	if (secured_wires)
		src.electronics = new/obj/item/weapon/airlock_electronics/secure( src.loc )

	if (haskeypad)
		src.electronics = new/obj/item/weapon/airlock_electronics/keypad_electronics(src.loc )

	else
		src.electronics = new/obj/item/weapon/airlock_electronics( src.loc )

	//update the electronics to match the door's access
	if(!src.req_access)
		src.check_access()
	if(src.req_access.len)
		electronics.conf_access = src.req_access
	else if (src.req_one_access.len)
		electronics.conf_access = src.req_one_access
		electronics.one_access = 1
	electronics.req_access_faction = req_access_faction

/obj/machinery/door/airlock/emp_act(var/severity)
	if(prob(20/severity))
		spawn(0)
			open()
	if(prob(40/severity))
		var/duration = SecondsToTicks(30 / severity)
		if(electrified_until > -1 && (duration + world.time) > electrified_until)
			electrify(duration)
	..()

/obj/machinery/door/airlock/power_change() //putting this is obj/machinery/door itself makes non-airlock doors turn invisible for some reason
	. = ..()
	if(stat & NOPOWER)
		// If we lost power, disable electrification
		electrified_until = 0

/obj/machinery/door/airlock/proc/prison_open()
	if(arePowerSystemsOn())
		src.unlock()
		src.open()
		src.lock()
	return

// Braces can act as an extra layer of armor - they will take damage first.
/obj/machinery/door/airlock/take_damage(damage, damagetype, armorbypass, used_weapon)
	if(brace)
		brace.take_damage(damage, damagetype, armorbypass, used_weapon)
	else
		..()
	update_icon()

/obj/machinery/door/airlock/examine()
	. = ..()
	if (lock_cut_state == BOLTS_EXPOSED)
		to_chat(usr, "The bolt cover has been cut open.")
	if (lock_cut_state == BOLTS_CUT)
		to_chat(usr, "The door bolts have been cut.")
	if(brace)
		to_chat(usr, "\The [brace] is installed on \the [src], preventing it from opening.")
		to_chat(usr, brace.examine_health())

/obj/machinery/door/airlock/autoname

/obj/machinery/door/airlock/autoname/New()
	var/area/A = get_area(src)
	name = A.name
	..()

/obj/machinery/door/airlock/proc/paint_airlock(var/paint_color)
	door_color = paint_color
	update_icon()

/obj/machinery/door/airlock/proc/stripe_airlock(var/paint_color)
	stripe_color = paint_color
	update_icon()

/obj/machinery/door/airlock/proc/command(var/new_command)
	cur_command = new_command

	//if there's no power, recieve the signal but just don't do anything. This allows airlocks to continue to work normally once power is restored
	if(arePowerSystemsOn())
		INVOKE_ASYNC(src, .proc/execute_current_command)
			//execute_current_command()

/obj/machinery/door/airlock/proc/execute_current_command()
	if(operating)
		return //emagged or busy doing something else

	if (!cur_command)
		return

	do_command(cur_command)
	if (command_completed(cur_command))
		cur_command = null

/obj/machinery/door/airlock/proc/do_command(var/command)
	switch(command)
		if("open")
			open()

		if("close")
			close()

		if("unlock")
			unlock()

		if("lock")
			lock()

		if("secure_open")
			unlock()

			sleep(2)
			open()

			lock()

		if("secure_close")
			unlock()
			close()

			lock()
			sleep(2)

	send_status()

/obj/machinery/door/airlock/proc/command_completed(var/command)
	switch(command)
		if("open")
			return (!density)

		if("close")
			return density

		if("unlock")
			return !locked

		if("lock")
			return locked

		if("secure_open")
			return (locked && !density)

		if("secure_close")
			return (locked && density)

	return 1	//Unknown command. Just assume it's completed.

/obj/machinery/door/airlock/proc/send_status(var/bumped = 0)
	if(!has_transmitter())
		return FALSE
	var/list/data[0]
	data["timestamp"] = world.time
	data["door_status"] = density?("closed"):("open")
	data["lock_status"] = locked?("locked"):("unlocked")
	if (bumped)
		data["bumped_with_access"] = 1
	post_signal(data)
