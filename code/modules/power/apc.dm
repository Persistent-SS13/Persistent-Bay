

// The Area Power Controller (APC)
// Controls and provides power to most electronics in an area
// Only one required per area
// Requires a wire connection to a power network through a terminal
// Generates a terminal based on the direction of the APC on spawn

// There are three different power channels, lighting, equipment, and enviroment
// Each may have one of the following states

#define POWERCHAN_OFF		0	// Power channel is off
#define POWERCHAN_OFF_TEMP	1	// Power channel is off until there is power
#define POWERCHAN_OFF_AUTO	2	// Power channel is off until power passes a threshold
#define POWERCHAN_ON		3	// Power channel is on until there is no power
#define POWERCHAN_ON_AUTO	4	// Power channel is on until power drops below a threshold

// Power channels set to Auto change when power levels rise or drop below a threshold

#define AUTO_THRESHOLD_LIGHTING  50
#define AUTO_THRESHOLD_EQUIPMENT 25
// The ENVIRON channel stays on as long as possible, and doesn't have a threshold

#define CRITICAL_APC_EMP_PROTECTION 10	// EMP effect duration is divided by this number if the APC has "critical" flag
#define APC_UPDATE_ICON_COOLDOWN 100	// Time between automatically updating the icon (10 seconds)

// Used to check whether or not to update the icon_state
#define UPDATE_CELL_IN 1
#define UPDATE_OPENED1 2
#define UPDATE_OPENED2 4
#define UPDATE_MAINT 8
#define UPDATE_BROKE 16
#define UPDATE_BLUESCREEN 32
#define UPDATE_WIREEXP 64
#define UPDATE_ALLGOOD 128

// Used to check whether or not to update the overlay
#define APC_UPOVERLAY_CHARGEING0 1
#define APC_UPOVERLAY_CHARGEING1 2
#define APC_UPOVERLAY_CHARGEING2 4
#define APC_UPOVERLAY_LOCKED 8
#define APC_UPOVERLAY_OPERATING 16

// Alarm stuff
#define ALARM_THREAT	1
#define ALARM_WARN		2
#define ALARM_OFF		0

// Various APC types
/obj/machinery/power/apc/critical
	is_critical = 1

/obj/machinery/power/apc/high
	cell_type = /obj/item/weapon/cell/high

/obj/machinery/power/apc/high/inactive
	cell_type = /obj/item/weapon/cell/high
	lighting = 0
	equipment = 0
	environ = 0
	locked = 0
	coverlocked = 0

/obj/machinery/power/apc/super
	cell_type = /obj/item/weapon/cell/super

/obj/machinery/power/apc/super/critical
	is_critical = 1

/obj/machinery/power/apc/hyper
	cell_type = /obj/item/weapon/cell/hyper

/obj/machinery/power/apc/ai
	is_critical = 1
	cell_type = /obj/item/weapon/cell/hyper
	malf_upgraded = 1
	emp_hardened = 1

// Main APC code
/obj/machinery/power/apc
	name = "area power controller"
	desc = "A control terminal for the area electrical systems."

	icon_state = "apc0"
	icon = 'icons/obj/apc.dmi'
	plane = ABOVE_HUMAN_PLANE
	anchored = 1
	use_power = POWER_USE_OFF
	req_access = list(core_access_engineering_programs)
	clicksound = "switch"
	layer = ABOVE_WINDOW_LAYER
	var/needs_powerdown_sound
	var/area/area
	var/areastring = null
	var/obj/item/weapon/cell/cell
	var/chargelevel = 0.0005  // Cap for how fast APC cells charge, as a percentage-per-tick (0.01 means cellcharge is capped to 1% per second)
	var/cell_type = /obj/item/weapon/cell/apc
	var/opened = 0 //0=closed, 1=opened, 2=cover removed
	var/shorted = 0
	var/lighting = POWERCHAN_ON_AUTO
	var/equipment = POWERCHAN_ON_AUTO
	var/environ = POWERCHAN_ON_AUTO
	var/operating = 1
	var/charging = 0
	var/chargemode = 1
	var/chargecount = 0
	var/locked = 1
	var/coverlocked = 1
	var/aidisabled = 0
	var/obj/machinery/power/terminal/terminal = null
	var/lastused_light = 0
	var/lastused_equip = 0
	var/lastused_environ = 0
	var/lastused_charging = 0
	var/lastused_total = 0
	var/main_status = 0
	var/mob/living/silicon/ai/hacker = null // Malfunction var. If set AI hacked the APC and has full control.
	var/wiresexposed = 0
	powernet = 0		// set so that APCs aren't found as powernet nodes //Hackish, Horrible, was like this before I changed it :(
	var/debug= 0
	var/autoflag= 0		// 0 = off, 1= eqp and lights off, 2 = eqp off, 3 = all on.
	var/has_electronics = 0 // 0 - none, 1 - plugged in, 2 - secured by screwdriver
	var/beenhit = 0 // used for counting how many times it has been hit, used for Aliens at the moment
	var/longtermpower = 10
	var/datum/wires/apc/wires = null
	var/update_state = -1
	var/update_overlay = -1
	var/list/update_overlay_chan		// Used to determine if there is a change in channels
	var/is_critical = 0
	var/global/status_overlays = 0
	var/failure_timer = 0
	var/force_update = 0
	var/emp_hardened = 0
	var/global/list/status_overlays_lock
	var/global/list/status_overlays_charging
	var/global/list/status_overlays_equipment
	var/global/list/status_overlays_lighting
	var/global/list/status_overlays_environ

	var/datum/world_faction/connected_faction
	var/menu = 1

	var/alarm_status = 0
	var/alarm_access = 0
	var/alarm_alert = FALSE
	var/alarm_threat_warning = FALSE
	var/alarm_threat_warning_timebuffer
	var/alarm_threat_warning_timeout = 5 SECONDS

/obj/machinery/power/apc/New()
	..()
	ADD_SAVED_VAR(connected_faction)
	ADD_SAVED_VAR(locked)
	ADD_SAVED_VAR(coverlocked)
	ADD_SAVED_VAR(cell)
	ADD_SAVED_VAR(has_electronics)
	ADD_SAVED_VAR(autoflag)

	ADD_SKIP_EMPTY(connected_faction)
	ADD_SKIP_EMPTY(cell)

/obj/machinery/power/apc/get_cell()
	return cell

/obj/machinery/power/apc/updateDialog()
	if (stat & (BROKEN|MAINT))
		return
	..()

/obj/machinery/power/apc/can_connect(var/datum/world_faction/trying, var/mob/M)
	if(!area)
		return 0

	var/list/turfs = get_area_turfs(area)
	var/datum/machine_limits/limits = trying.get_limits()

	if(M && !has_access(list(core_access_engineering_programs), list(), M.GetAccess(req_access_faction)))
		to_chat(M, "You do not have access to link machines to [trying.name].")
		return 0

	if(limits.limit_area <= turfs.len + trying.get_claimed_area())
		if(M)
			to_chat(M, "[trying.name] cannot connect this APC as it will exceed its area limit.")
		return 0
	limits.apcs |= src
	req_access_faction = trying.uid
	connected_faction = trying
	trying.calculate_claimed_area()
	to_chat(M, "You successfuly connect this APC to [trying.name].")

/obj/machinery/power/apc/can_disconnect(var/datum/world_faction/trying, var/mob/M)
	var/datum/machine_limits/limits = trying.get_limits()
	limits.apcs -= src
	req_access_faction = ""
	connected_faction = null
	locked = 1
	trying.calculate_claimed_area()
	if(M) to_chat(M, "You successfuly disconnect this APC from [trying.name].")


/obj/machinery/power/apc/connect_to_network()
	//Override because the APC does not directly connect to the network; it goes through a terminal.
	//The terminal is what the power computer looks for anyway.
	if(terminal)
		terminal.connect_to_network()

/obj/machinery/power/apc/drain_power(var/drain_check, var/surge, var/amount = 0)

	if(drain_check)
		return 1

	// Prevents APCs from being stuck on 0% cell charge while reporting "Fully Charged" status.
	charging = 0

	// If the APC's interface is locked, limit the charge rate to 25%.
	if(locked)
		amount /= 4

	var/drained_energy = 0

	// First try to drain the power directly from attached power grid.
	if(terminal && terminal.powernet)
		terminal.powernet.trigger_warning()
		drained_energy += terminal.powernet.draw_power(amount)

	// If the power grid provided enough power, we're good. If not, take the rest from the power cell.
	if((drained_energy < amount) && cell)
		drained_energy += cell.use((amount - drained_energy) * CELLRATE)

	return drained_energy

/obj/machinery/power/apc/Initialize(mapload, var/ndir, var/building=0)

	wires = new(src)

	// offset 22 pixels in direction of dir
	// this allows the APC to be embedded in a wall, yet still inside an area
	if (building)
		set_dir(ndir)

	pixel_x = (src.dir & 3)? 0 : (src.dir == 4 ? 22 : -22)
	pixel_y = (src.dir & 3)? (src.dir ==1 ? 22 : -22) : 0

	if (building==0)
		init_round_start()
	else
		area = get_area(src)
		area.apc = src
		opened = 1
		operating = 0
		SetName("\improper [area.name] APC")
		stat |= MAINT
		src.update_icon()

	. = ..(mapload)

	if(operating)
		src.update()

/obj/machinery/power/apc/Destroy()
	src.update()
	if(area)
		area.apc = null
		area.power_light = 0
		area.power_equip = 0
		area.power_environ = 0
		area.power_change()
	qdel(wires)
	wires = null
	qdel(terminal)
	terminal = null
	if(cell)
		cell.forceMove(loc)
		cell = null

	// Malf AI, removes the APC from AI's hacked APCs list.
	if((hacker) && (hacker.hacked_apcs) && (src in hacker.hacked_apcs))
		hacker.hacked_apcs -= src

	return ..()

/obj/machinery/power/apc/proc/energy_fail(var/duration)
	if(emp_hardened)
		return
	failure_timer = max(failure_timer, round(duration))
	playsound(src, 'sound/machines/apc_nopower.ogg', 75, 0)

/obj/machinery/power/apc/after_load()
	. = ..()
	connect_to_network()

/obj/machinery/power/apc/proc/make_terminal()
	// create a terminal object at the same position as original turf loc
	// wires will attach to this
	terminal = new/obj/machinery/power/terminal(src.loc)
	terminal.set_dir(dir)
	terminal.master = src

/obj/machinery/power/apc/proc/init_round_start()
	has_electronics = 2 //installed and secured
	if(!terminal)
		make_terminal() //wired
	// is starting with a power cell installed, create it and set its charge level
	if(!map_storage_loaded)
		if(cell_type)
			src.cell = new cell_type(src)
		if(!loc)
			qdel(src)
			return
		if(!terminal)
			make_terminal() //This will create all the terminals for the APCs on initial map start.
	if(loc)
		var/area/A = src.loc.loc

		//if area isn't specified use current
		if(isarea(A) && src.areastring == null)
			src.area = A
			SetName("\improper [area.name] APC")
		else
			src.area = get_area_name(areastring)
			SetName("\improper [area.name] APC")
		area.apc = src
		update_icon()

/obj/machinery/power/apc/examine(mob/user)
	if(..(user, 1))
		if(stat & BROKEN)
			to_chat(user, "Looks broken.")
			return
		if(opened)
			if(has_electronics && terminal)
				to_chat(user, "The cover is [opened==2?"removed":"open"] and the power cell is [ cell ? "installed" : "missing"].")
			else if (!has_electronics && terminal)
				to_chat(user, "There are some wires but no any electronics.")
			else if (has_electronics && !terminal)
				to_chat(user, "Electronics installed but not wired.")
			else /* if (!has_electronics && !terminal) */
				to_chat(user, "There is no electronics nor connected wires.")

		else
			if (stat & MAINT)
				to_chat(user, "The cover is closed. Something wrong with it: it doesn't work.")
			else if (hacker && !hacker.hacked_apcs_hidden)
				to_chat(user, "The cover is locked.")
			else
				to_chat(user, "The cover is closed.")


// update the APC icon to show the three base states
// also add overlays for indicator lights
/obj/machinery/power/apc/on_update_icon()
	if (!status_overlays)
		status_overlays = 1
		status_overlays_lock = new
		status_overlays_charging = new
		status_overlays_equipment = new
		status_overlays_lighting = new
		status_overlays_environ = new

		status_overlays_lock.len = 2
		status_overlays_charging.len = 3
		status_overlays_equipment.len = 5
		status_overlays_lighting.len = 5
		status_overlays_environ.len = 5

		status_overlays_lock[1] = image(icon, "apcox-0")    // 0=blue 1=red
		status_overlays_lock[2] = image(icon, "apcox-1")

		status_overlays_charging[1] = image(icon, "apco3-0")
		status_overlays_charging[2] = image(icon, "apco3-1")
		status_overlays_charging[3] = image(icon, "apco3-2")

		var/list/channel_overlays = list(status_overlays_equipment, status_overlays_lighting, status_overlays_environ)
		var/channel = 0
		for(var/list/channel_leds in channel_overlays)
			channel_leds[POWERCHAN_OFF + 1] = overlay_image(icon,"apco[channel]",COLOR_RED)
			channel_leds[POWERCHAN_OFF_TEMP + 1] = overlay_image(icon,"apco[channel]",COLOR_ORANGE)
			channel_leds[POWERCHAN_OFF_AUTO + 1] = overlay_image(icon,"apco[channel]",COLOR_ORANGE)
			channel_leds[POWERCHAN_ON + 1] = overlay_image(icon,"apco[channel]",COLOR_LIME)
			channel_leds[POWERCHAN_ON_AUTO + 1] = overlay_image(icon,"apco[channel]",COLOR_BLUE)
			channel++

	if(update_state < 0)
		pixel_x = 0
		pixel_y = 0
		var/turf/T = get_step(get_turf(src), dir)
		if(istype(T) && T.density)
			if(dir == SOUTH)
				pixel_y = -22
			else if(dir == NORTH)
				pixel_y = 22
			else if(dir == EAST)
				pixel_x = 22
			else if(dir == WEST)
				pixel_x = -22

	var/update = check_updates() 		//returns 0 if no need to update icons.
						// 1 if we need to update the icon_state
						// 2 if we need to update the overlays

	if(!update)
		return

	if(update & 1) // Updating the icon state
		if(update_state & UPDATE_ALLGOOD)
			icon_state = "apc0"
		else if(update_state & (UPDATE_OPENED1|UPDATE_OPENED2))
			var/basestate = "apc[ cell ? "2" : "1" ]"
			if(update_state & UPDATE_OPENED1)
				if(update_state & (UPDATE_MAINT|UPDATE_BROKE))
					icon_state = "apcmaint" //disabled APC cannot hold cell
				else
					icon_state = basestate
			else if(update_state & UPDATE_OPENED2)
				icon_state = "[basestate]-nocover"
		else if(update_state & UPDATE_BROKE)
			icon_state = "apc-b"
		else if(update_state & UPDATE_BLUESCREEN)
			icon_state = "apcemag"
		else if(update_state & UPDATE_WIREEXP)
			icon_state = "apcewires"

	if(!(update_state & UPDATE_ALLGOOD))
		if(overlays.len)
			overlays.Cut()
			return

	if(update & 2)
		if(overlays.len)
			overlays.Cut()
		if(!(stat & (BROKEN|MAINT)) && update_state & UPDATE_ALLGOOD)
			overlays += status_overlays_lock[locked+1]
			overlays += status_overlays_charging[charging+1]
			if(operating)
				overlays += status_overlays_equipment[equipment+1]
				overlays += status_overlays_lighting[lighting+1]
				overlays += status_overlays_environ[environ+1]

	if(update & 3)
		if(update_state & (UPDATE_OPENED1|UPDATE_OPENED2|UPDATE_BROKE))
			set_light(0)
		else if(update_state & UPDATE_BLUESCREEN)
			set_light(0.8, 0.1, 1, 2, "#00ecff")
		else if(!(stat & (BROKEN|MAINT)) && update_state & UPDATE_ALLGOOD)
			var/color
			switch(charging)
				if(0)
					color = "#f86060"
				if(1)
					color = "#a8b0f8"
				if(2)
					color = "#82ff4c"
			set_light(0.8, 0.1, 1, l_color = color)
		else
			set_light(0)

/obj/machinery/power/apc/proc/check_updates()
	if(!update_overlay_chan)
		update_overlay_chan = new/list()
	var/last_update_state = update_state
	var/last_update_overlay = update_overlay
	var/list/last_update_overlay_chan = update_overlay_chan.Copy()
	update_state = 0
	update_overlay = 0
	if(cell)
		update_state |= UPDATE_CELL_IN
	if(stat & BROKEN)
		update_state |= UPDATE_BROKE
	if(stat & MAINT)
		update_state |= UPDATE_MAINT
	if(opened)
		if(opened==1)
			update_state |= UPDATE_OPENED1
		if(opened==2)
			update_state |= UPDATE_OPENED2
	else if(emagged || (hacker && !hacker.hacked_apcs_hidden) || failure_timer)
		update_state |= UPDATE_BLUESCREEN
	else if(wiresexposed)
		update_state |= UPDATE_WIREEXP
	if(update_state <= 1)
		update_state |= UPDATE_ALLGOOD

	if(operating)
		update_overlay |= APC_UPOVERLAY_OPERATING

	if(update_state & UPDATE_ALLGOOD)
		if(locked)
			update_overlay |= APC_UPOVERLAY_LOCKED

		if(!charging)
			update_overlay |= APC_UPOVERLAY_CHARGEING0
		else if(charging == 1)
			update_overlay |= APC_UPOVERLAY_CHARGEING1
		else if(charging == 2)
			update_overlay |= APC_UPOVERLAY_CHARGEING2


		update_overlay_chan["Equipment"] = equipment
		update_overlay_chan["Lighting"] = lighting
		update_overlay_chan["Enviroment"] = environ


	var/results = 0
	if(last_update_state == update_state && last_update_overlay == update_overlay && last_update_overlay_chan == update_overlay_chan)
		return 0
	if(last_update_state != update_state)
		results += 1
	if(last_update_overlay != update_overlay || last_update_overlay_chan != update_overlay_chan)
		results += 2
	return results

//attack with an item - open/close cover, insert cell, or (un)lock interface

/obj/machinery/power/apc/attackby(obj/item/W, mob/user)
	if (istype(user, /mob/living/silicon) && get_dist(src,user)>1)
		return src.attack_hand(user)
	src.add_fingerprint(user)
	if(istype(W, /obj/item/inducer)) return // inducer.dm afterattack handles this
	if(isCrowbar(W) && opened)
		if (has_electronics==1)
			if (terminal)
				to_chat(user, "<span class='warning'>Disconnect wires first.</span>")
				return
			playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
			to_chat(user, "You are trying to remove the power control board...")//lpeters - fixed grammar issues

			if(do_after(user, 50, src))
				if (has_electronics==1)
					has_electronics = 0
					if ((stat & BROKEN))
						user.visible_message(\
							"<span class='warning'>[user.name] has broken the power control board inside [src.name]!</span>",\
							"<span class='notice'>You broke the charred power control board and remove the remains.</span>",
							"You hear a crack!")
					else
						user.visible_message(\
							"<span class='warning'>[user.name] has removed the power control board from [src.name]!</span>",\
							"<span class='notice'>You remove the power control board.</span>")
						new /obj/item/weapon/module/power_control(loc)
		else if (opened!=2) //cover isn't removed
			opened = 0
			update_icon()
	else if(isCrowbar(W) && !((stat & BROKEN) || (hacker && !hacker.hacked_apcs_hidden)) )
		if(coverlocked && !(stat & MAINT))
			to_chat(user, "<span class='warning'>The cover is locked and cannot be opened.</span>")
			return
		else
			opened = 1
			update_icon()
	else if	(istype(W, /obj/item/weapon/cell) && opened)	// trying to put a cell inside
		if(cell)
			to_chat(user, "There is a power cell already installed.")
			return
		if (stat & MAINT)
			to_chat(user, "<span class='warning'>There is no connector for your power cell.</span>")
			return
		if(W.w_class != ITEM_SIZE_NORMAL)
			to_chat(user, "\The [W] is too [W.w_class < ITEM_SIZE_NORMAL? "small" : "large"] to fit here.")
			return

		if(!user.unEquip(W, src))
			return
		cell = W
		user.visible_message(\
			"<span class='warning'>[user.name] has inserted the power cell to [src.name]!</span>",\
			"<span class='notice'>You insert the power cell.</span>")
		chargecount = 0
		update_icon()
	else if(isScrewdriver(W))	// haxing
		if(opened)
			if (cell)
				to_chat(user, "<span class='warning'>Close the APC first.</span>")//Less hints more mystery!

				return
			else
				if (has_electronics==1 && terminal)
					has_electronics = 2
					stat &= ~MAINT
					playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
					to_chat(user, "You screw the circuit electronics into place.")
				else if (has_electronics==2)
					has_electronics = 1
					stat |= MAINT
					playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
					to_chat(user, "You unfasten the electronics.")
				else /* has_electronics==0 */
					to_chat(user, "<span class='warning'>There is nothing to secure.</span>")
					return
				update_icon()
		else
			wiresexposed = !wiresexposed
			to_chat(user, "The wires have been [wiresexposed ? "exposed" : "unexposed"]")
			update_icon()

	else if (W.GetIdCard())			// trying to unlock the interface with an ID card
		if(emagged)
			to_chat(user, "The interface is broken.")
		else if(!connected_faction)
			var/obj/item/weapon/card/id/id =  W.GetIdCard()
			if(id)
				var/datum/world_faction/faction = get_faction(id.selected_faction)
				if(faction)
					can_connect(faction, usr)
		else if(opened)
			to_chat(user, "You must close the cover to swipe an ID card.")
		else if(wiresexposed)
			to_chat(user, "You must close the panel")
		else if(stat & (BROKEN|MAINT))
			to_chat(user, "Nothing happens.")
		else if(hacker && !hacker.hacked_apcs_hidden)
			to_chat(user, "<span class='warning'>Access denied.</span>")
		else
			if(src.allowed(usr) && !isWireCut(APC_WIRE_IDSCAN))
				locked = !locked
				to_chat(user, "You [ locked ? "lock" : "unlock"] the APC interface.")
				update_icon()
			else
				to_chat(user, "<span class='warning'>Access denied.</span>")
	else if (istype(W, /obj/item/stack/cable_coil) && !terminal && opened && has_electronics!=2)
		var/turf/T = loc
		if(istype(T) && !T.is_plating())
			to_chat(user, "<span class='warning'>You must remove the floor plating in front of the APC first.</span>")
			return
		var/obj/item/stack/cable_coil/C = W
		if(!C.can_use(10))
			to_chat(user, "<span class='warning'>You need ten lengths of cable for APC.</span>")
			return
		user.visible_message("<span class='warning'>[user.name] adds cables to the APC frame.</span>", \
							"You start adding cables to the APC frame...")
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 20, src))
			if (C.can_use(10) && !terminal && opened && has_electronics != 2)
				var/obj/structure/cable/N = T.get_cable_node()
				if (prob(50) && electrocute_mob(usr, N, N))
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(5, 1, src)
					s.start()
					if(user.stunned)
						return
				C.use(10)
				user.visible_message(\
					"<span class='warning'>[user.name] has added cables to the APC frame!</span>",\
					"You add cables to the APC frame.")
				make_terminal()
				terminal.connect_to_network()
	else if(isWirecutter(W) && terminal && opened && has_electronics!=2)
		var/turf/T = loc
		if(istype(T) && !T.is_plating())
			to_chat(user, "<span class='warning'>You must remove the floor plating in front of the APC first.</span>")
			return
		user.visible_message("<span class='warning'>[user.name] dismantles the power terminal from [src].</span>", \
							"You begin to cut the cables...")
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 50, src))
			if(terminal && opened && has_electronics!=2)
				if (prob(50) && electrocute_mob(usr, terminal.powernet, terminal))
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(5, 1, src)
					s.start()
					if(usr.stunned)
						return
				new /obj/item/stack/cable_coil(loc,10)
				to_chat(user, "<span class='notice'>You cut the cables and dismantle the power terminal.</span>")
				QDEL_NULL(terminal)
	else if (istype(W, /obj/item/weapon/module/power_control) && opened && has_electronics==0 && !((stat & BROKEN)))
		user.visible_message("<span class='warning'>[user.name] inserts the power control board into [src].</span>", \
							"You start to insert the power control board into the frame...")
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 10, src))
			if(has_electronics==0)
				has_electronics = 1
				reboot() //completely new electronics
				to_chat(user, "<span class='notice'>You place the power control board inside the frame.</span>")
				qdel(W)
	else if (istype(W, /obj/item/weapon/module/power_control) && opened && has_electronics==0 && ((stat & BROKEN)))
		to_chat(user, "<span class='warning'>You cannot put the board inside, the frame is damaged.</span>")
		return
	else if(isWelder(W) && opened && has_electronics==0 && !terminal)
		var/obj/item/weapon/tool/weldingtool/WT = W
		if (WT.get_fuel() < 3)
			to_chat(user, "<span class='warning'>You need more welding fuel to complete this task.</span>")
			return
		user.visible_message("<span class='warning'>[user.name] welds [src].</span>", \
							"You start welding the APC frame...", \
							"You hear welding.")
		playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
		if(do_after(user, 50, src))
			if(!src || !WT.remove_fuel(3, user)) return
			if (emagged || (stat & BROKEN) || opened==2)
				new /obj/item/stack/material/steel(loc)
				user.visible_message(\
					"<span class='warning'>[src] has been cut apart by [user.name] with the weldingtool.</span>",\
					"<span class='notice'>You disassembled the broken APC frame.</span>",\
					"You hear welding.")
			else
				new /obj/item/frame/apc(loc)
				user.visible_message(\
					"<span class='warning'>[src] has been cut from the wall by [user.name] with the weldingtool.</span>",\
					"<span class='notice'>You cut the APC frame from the wall.</span>",\
					"You hear welding.")
			qdel(src)
			return
	else if (istype(W, /obj/item/frame/apc) && opened && emagged)
		emagged = 0
		if (opened==2)
			opened = 1
		user.visible_message(\
			"<span class='warning'>[user.name] has replaced the damaged APC frontal panel with a new one.</span>",\
			"<span class='notice'>You replace the damaged APC frontal panel with a new one.</span>")
		qdel(W)
		update_icon()
	else if (istype(W, /obj/item/frame/apc) && opened && ((stat & BROKEN) || (hacker && !hacker.hacked_apcs_hidden)))
		if (has_electronics)
			to_chat(user, "<span class='warning'>You cannot repair this APC until you remove the electronics still inside.</span>")
			return
		user.visible_message("<span class='warning'>[user.name] replaces the damaged APC frame with a new one.</span>",\
							"You begin to replace the damaged APC frame...")
		if(do_after(user, 50, src))
			user.visible_message(\
				"<span class='notice'>[user.name] has replaced the damaged APC frame with new one.</span>",\
				"You replace the damaged APC frame with new one.")
			qdel(W)
			set_broken(FALSE)
			// Malf AI, removes the APC from AI's hacked APCs list.
			if(hacker && hacker.hacked_apcs && (src in hacker.hacked_apcs))
				hacker.hacked_apcs -= src
				hacker = null
			if (opened==2)
				opened = 1
			queue_icon_update()
	else
		if (((stat & BROKEN) || (hacker && !hacker.hacked_apcs_hidden)) \
				&& !opened \
				&& W.force >= 5 \
				&& W.w_class >= 3.0 \
				&& prob(20) )
			opened = 2
			user.visible_message("<span class='danger'>The APC cover was knocked down with the [W.name] by [user.name]!</span>", \
				"<span class='danger'>You knock down the APC cover with your [W.name]!</span>", \
				"You hear a bang")
			update_icon()
		else
			if (istype(user, /mob/living/silicon))
				return src.attack_hand(user)
			if (!opened && wiresexposed && isMultitool(W) || isWirecutter(W) || istype(W, /obj/item/device/assembly/signaler))
				return src.attack_hand(user)
			user.visible_message("<span class='danger'>The [src.name] has been hit with the [W.name] by [user.name]!</span>", \
				"<span class='danger'>You hit the [src.name] with your [W.name]!</span>", \
				"You hear a bang")
			if(W.force >= 5 && W.w_class >= ITEM_SIZE_NORMAL && prob(W.force))
				var/roulette = rand(1,100)
				switch(roulette)
					if(1 to 10)
						locked = FALSE
						to_chat(user, "<span class='notice'>You manage to disable the lock on \the [src]!</span>")
					if(50 to 70)
						to_chat(user, "<span class='notice'>You manage to bash the lid open!</span>")
						opened = 1
					if(90 to 100)
						to_chat(user, "<span class='warning'>There's a nasty sound and \the [src] goes cold...</span>")
						set_broken(TRUE)
				queue_icon_update()
		playsound(get_turf(src), 'sound/weapons/smash.ogg', 75, 1)

// attack with hand - remove cell (if cover open) or interact with the APC

/obj/machinery/power/apc/emag_act(var/remaining_charges, var/mob/user)
	if (!(emagged || (hacker && !hacker.hacked_apcs_hidden)))		// trying to unlock with an emag card
		if(opened)
			to_chat(user, "You must close the cover to swipe an ID card.")
		else if(wiresexposed)
			to_chat(user, "You must close the panel first")
		else if(stat & (BROKEN|MAINT))
			to_chat(user, "Nothing happens.")
		else
			flick("apc-spark", src)
			if (do_after(user,6,src))
				if(prob(50))
					emagged = 1
					locked = 0
					to_chat(user, "<span class='notice'>You emag the APC interface.</span>")
					update_icon()
				else
					to_chat(user, "<span class='warning'>You fail to [ locked ? "unlock" : "lock"] the APC interface.</span>")
				return 1

/obj/machinery/power/apc/attack_hand(mob/user)
//	if (!can_use(user)) This already gets called in interact() and in topic()
//		return
	if(!user)
		return
	src.add_fingerprint(user)

	//Human mob special interaction goes here.
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user

		if(H.species.can_shred(H))
			user.visible_message("<span class='warning'>\The [user] slashes at \the [src]!</span>", "<span class='notice'>You slash at \the [src]!</span>")
			playsound(src.loc, 'sound/weapons/slash.ogg', 100, 1)

			var/allcut = wires.IsAllCut()

			if(beenhit >= pick(3, 4) && wiresexposed != 1)
				wiresexposed = 1
				src.update_icon()
				src.visible_message("<span class='warning'>\The The [src]'s cover flies open, exposing the wires!</span>")

			else if(wiresexposed == 1 && allcut == 0)
				wires.CutAll()
				src.update_icon()
				src.visible_message("<span class='warning'>\The [src]'s wires are shredded!</span>")
			else
				beenhit += 1
			return

	if(usr == user && opened && (!issilicon(user)))
		if(cell)
			user.put_in_hands(cell)
			cell.add_fingerprint(user)
			cell.update_icon()

			src.cell = null
			user.visible_message("<span class='warning'>[user.name] removes the power cell from [src.name]!</span>",\
								 "<span class='notice'>You remove the power cell.</span>")
//			to_chat(user, "You remove the power cell.")
			charging = 0
			src.update_icon()
		return
	if(stat & (BROKEN|MAINT))
		return
	// do APC interaction
	src.interact(user)

/obj/machinery/power/apc/interact(mob/user)
	if(!user)
		return

	if(wiresexposed && !istype(user, /mob/living/silicon/ai))
		wires.Interact(user)

	return ui_interact(user)


/obj/machinery/power/apc/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!user)
		return
	var/list/data = list(
		"pChan_Off" = POWERCHAN_OFF,
		"pChan_Off_T" = POWERCHAN_OFF_TEMP,
		"pChan_Off_A" = POWERCHAN_OFF_AUTO,
		"pChan_On" = POWERCHAN_ON,
		"pChan_On_A" = POWERCHAN_ON_AUTO,
		"locked" = (locked && !emagged) ? 1 : 0,
		"isOperating" = operating,
		"externalPower" = main_status,
		"powerCellStatus" = cell ? cell.percent() : null,
		"chargeMode" = chargemode,
		"chargingStatus" = charging,
		"totalLoad" = round(lastused_total),
		"totalCharging" = round(lastused_charging),
		"coverLocked" = coverlocked,
		"failTime" = failure_timer * 2,
		"siliconUser" = istype(user, /mob/living/silicon),
		"powerChannels" = list(
			list(
				"title" = "Equipment",
				"powerLoad" = lastused_equip,
				"status" = equipment,
				"topicParams" = list(
					"auto" = list("eqp" = 2),
					"on"   = list("eqp" = 1),
					"off"  = list("eqp" = 0)
				)
			),
			list(
				"title" = "Lighting",
				"powerLoad" = round(lastused_light),
				"status" = lighting,
				"topicParams" = list(
					"auto" = list("lgt" = 2),
					"on"   = list("lgt" = 1),
					"off"  = list("lgt" = 0)
				)
			),
			list(
				"title" = "Environment",
				"powerLoad" = round(lastused_environ),
				"status" = environ,
				"topicParams" = list(
					"auto" = list("env" = 2),
					"on"   = list("env" = 1),
					"off"  = list("env" = 0)
				)
			)
		)
	)
	if(connected_faction)
		data["connected_faction"] = connected_faction.name
	else
		menu = 1

	data["menu"] = menu
	if(menu == 2)
		data["alarm_status"] = alarm_status
		if(alarm_access)
			data["required"] = connected_faction.get_access_name(alarm_access)
		else
			data["required"] = "*Unset*"




	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "apc.tmpl", "[area.name] - APC", 520, data["siliconUser"] ? 465 : 440)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update(1)

/obj/machinery/power/apc/proc/report()
	return "[area.name] : [equipment]/[lighting]/[environ] ([lastused_equip+lastused_light+lastused_environ]) : [cell? cell.percent() : "N/C"] ([charging])"

/obj/machinery/power/apc/proc/update()
	if(!area) return
	if(operating && !shorted && !failure_timer)

		//prevent unnecessary updates to emergency lighting
		var/new_power_light = (lighting >= POWERCHAN_ON)
		if(area.power_light != new_power_light)
			area.power_light = new_power_light
			area.set_emergency_lighting(lighting == POWERCHAN_OFF_AUTO) //if lights go auto-off, emergency lights go on

		area.power_equip = (equipment >= POWERCHAN_ON)
		area.power_environ = (environ >= POWERCHAN_ON)
	else
		area.power_light = 0
		area.power_equip = 0
		area.power_environ = 0

	area.power_change()

	if(!cell || cell.charge <= 0)
		if(needs_powerdown_sound == TRUE)
			playsound(src, 'sound/machines/apc_nopower.ogg', 75, 0)
			needs_powerdown_sound = FALSE
		else
			needs_powerdown_sound = TRUE

/obj/machinery/power/apc/proc/isWireCut(var/wireIndex)
	return wires.IsIndexCut(wireIndex)


/obj/machinery/power/apc/proc/can_use(mob/user as mob, var/loud = 0) //used by attack_hand() and Topic()
	if (user.stat)
		to_chat(user, "<span class='warning'>You must be conscious to use [src]!</span>")
		return 0
	if(!user.client)
		return 0
	if(inoperable())
		return 0
	if(!user.IsAdvancedToolUser())
		return 0
	if(user.restrained())
		to_chat(user, "<span class='warning'>You must have free hands to use [src].</span>")
		return 0
	if(user.lying)
		to_chat(user, "<span class='warning'>You must stand to use [src]!</span>")
		return 0
	autoflag = 5
	if (istype(user, /mob/living/silicon))
		var/permit = 0 // Malfunction variable. If AI hacks APC it can control it even without AI control wire.
		var/mob/living/silicon/ai/AI = user
		var/mob/living/silicon/robot/robot = user
		if(hacker && !hacker.hacked_apcs_hidden)
			if(hacker == AI)
				permit = 1
			else if(istype(robot) && robot.connected_ai && robot.connected_ai == hacker) // Cyborgs can use APCs hacked by their AI
				permit = 1

		if(aidisabled && !permit)
			if(!loud)
				to_chat(user, "<span class='danger'>\The [src] have AI control disabled!</span>")
			return 0
	else
		if (!in_range(src, user) || !istype(src.loc, /turf))
			return 0
	var/mob/living/carbon/human/H = user
	if (istype(H) && prob(H.getBrainLoss()))
		to_chat(user, "<span class='danger'>You momentarily forget how to use [src].</span>")
		return 0
	return 1

/obj/machinery/power/apc/Topic(href, href_list)
	if(..())
		return 1

	if(!can_use(usr, 1))
		return 1

	if(!istype(usr, /mob/living/silicon) && (locked && !emagged))
		// Shouldn't happen, this is here to prevent href exploits
		to_chat(usr, "You must unlock the panel to use this!")
		return 1

	if (href_list["lock"])
		coverlocked = !coverlocked

	if (href_list["menu"])
		menu = text2num(href_list["menu"])

	if(href_list["arm"])
		if(!connected_faction) return
		if(src.allowed(usr) || isWireCut(APC_WIRE_IDSCAN))
			alarm_status = 1
	if(href_list["disarm"])
		if(!connected_faction) return
		if(src.allowed(usr) || isWireCut(APC_WIRE_IDSCAN))
			alarm_status = 0
			AlarmSet(ALARM_OFF)
	if(href_list["set_alarm"])
		if(!connected_faction) return
		var/list/choices = list()
		connected_faction.rebuild_all_access()
		for(var/x in connected_faction.all_access)
			choices[connected_faction.get_access_name(x)] = x
		var/choice = input(usr, "Choose which access the alarm should look for.", "Select Access") as null|anything in choices
		if(choice)
			alarm_access = choices[choice]
			to_chat(usr, "Alarm access set.")
	if(href_list["disconnect"])
		if(!connected_faction) return
		if(src.allowed(usr) || isWireCut(APC_WIRE_IDSCAN))
			can_disconnect(connected_faction, usr)
			return
	else if( href_list["reboot"] )
		failure_timer = 0
		update_icon()
		update()

	else if (href_list["breaker"])
		toggle_breaker()

	else if (href_list["cmode"])
		chargemode = !chargemode
		if(!chargemode)
			charging = 0
			update_icon()

	else if (href_list["eqp"])
		var/val = text2num(href_list["eqp"])
		equipment = setsubsystem(val)
		update_icon()
		update()

	else if (href_list["lgt"])
		var/val = text2num(href_list["lgt"])
		lighting = setsubsystem(val)
		update_icon()
		update()

	else if (href_list["env"])
		var/val = text2num(href_list["env"])
		environ = setsubsystem(val)
		update_icon()
		update()

	else if (href_list["overload"])
		if(istype(usr, /mob/living/silicon))
			src.overload_lighting()

	else if (href_list["toggleaccess"])
		if(istype(usr, /mob/living/silicon))
			if(emagged || (stat & (BROKEN|MAINT)))
				to_chat(usr, "The APC does not respond to the command.")
			else
				locked = !locked
				update_icon()

	return 0

/obj/machinery/power/apc/proc/toggle_breaker()
	operating = !operating
	src.update()
	update_icon()


/obj/machinery/power/apc/surplus()
	if(terminal)
		return terminal.surplus()
	else
		return 0

/obj/machinery/power/apc/proc/last_surplus()
	if(terminal && terminal.powernet)
		return terminal.powernet.last_surplus()
	else
		return 0

//Returns 1 if the APC should attempt to charge
/obj/machinery/power/apc/proc/attempt_charging()
	return (chargemode && charging == 1 && operating)


/obj/machinery/power/apc/draw_power(var/amount)
	if(terminal && terminal.powernet)
		return terminal.powernet.draw_power(amount)
	return 0

/obj/machinery/power/apc/avail()
	if(terminal)
		return terminal.avail()
	else
		return 0

/obj/machinery/power/apc/Process()
	if(!loc)
		qdel(src)
		return
	if(stat & (BROKEN|MAINT))
		return
	if(!area.requires_power)
		return
	if(failure_timer)
		update()
		queue_icon_update()
		failure_timer--
		force_update = 1
		return

	lastused_light = area.usage(LIGHT)
	lastused_equip = area.usage(EQUIP)
	lastused_environ = area.usage(ENVIRON)
	area.clear_usage()

	lastused_total = lastused_light + lastused_equip + lastused_environ

	//store states to update icon if any change
	var/last_lt = lighting
	var/last_eq = equipment
	var/last_en = environ
	var/last_ch = charging

	var/excess = surplus()

	if(!src.avail())
		main_status = 0
	else if(excess < 0)
		main_status = 1
	else
		main_status = 2

	if(debug)
		log_debug("Status: [main_status] - Excess: [excess] - Last Equip: [lastused_equip] - Last Light: [lastused_light] - Longterm: [longtermpower]")

	if(cell && !shorted)
		// draw power from cell as before to power the area
		var/cellused = min(cell.charge, CELLRATE * lastused_total)	// clamp deduction to a max, amount left in cell
		cell.use(cellused)

		if(excess > lastused_total)		// if power excess recharge the cell
										// by the same amount just used
			var/draw = draw_power(cellused/CELLRATE) // draw the power needed to charge this cell
			cell.give(draw * CELLRATE)
		else		// no excess, and not enough per-apc
			if( (cell.charge/CELLRATE + excess) >= lastused_total)		// can we draw enough from cell+grid to cover last usage?
				var/draw = draw_power(excess)
				cell.charge = min(cell.maxcharge, cell.charge + CELLRATE * draw)	//recharge with what we can
				charging = 0
			else	// not enough power available to run the last tick!
				charging = 0
				chargecount = 0
				// This turns everything off in the case that there is still a charge left on the battery, just not enough to run the room.
				equipment = autoset(equipment, 0)
				lighting = autoset(lighting, 0)
				environ = autoset(environ, 0)
				autoflag = 0


		// Set channels depending on how much charge we have left
		update_channels()

		// now trickle-charge the cell
		lastused_charging = 0 // Clear the variable for new use.
		if(src.attempt_charging())
			if(excess > 0)		// check to make sure we have enough to charge
				// Max charge is capped to % per second constant
				var/ch = min(excess*CELLRATE, cell.maxcharge*chargelevel)

				ch = draw_power(ch/CELLRATE) // Removes the power we're taking from the grid
				cell.give(ch*CELLRATE) // actually recharge the cell
				lastused_charging = ch
				lastused_total += ch // Sensors need this to stop reporting APC charging as "Other" load
			else
				charging = 0		// stop charging
				chargecount = 0

		// show cell as fully charged if so
		if(cell.charge >= cell.maxcharge)
			cell.charge = cell.maxcharge
			charging = 2

		if(chargemode)
			if(!charging)
				if(excess > cell.maxcharge*chargelevel)
					chargecount++
				else
					chargecount = 0

				if(chargecount >= 10)

					chargecount = 0
					charging = 1

		else // chargemode off
			charging = 0
			chargecount = 0

	else // no cell, switch everything off
		charging = 0
		chargecount = 0
		equipment = autoset(equipment, 0)
		lighting = autoset(lighting, 0)
		environ = autoset(environ, 0)
		power_alarm.triggerAlarm(loc, src)
		autoflag = 0

//	if(!connected_faction)
//		equipment = autoset(equipment, 0)
//		lighting = autoset(lighting, 0)

	// update icon & area power if anything changed
	if(last_lt != lighting || last_eq != equipment || last_en != environ || force_update)
		force_update = 0
		queue_icon_update()
		update()
	else if (last_ch != charging)
		queue_icon_update()

	AlarmUpdate()

/obj/machinery/power/apc/proc/update_channels()
	// Allow the APC to operate as normal if the cell can charge
	if(charging && longtermpower < 10)
		longtermpower += 1
	else if(longtermpower > -10)
		longtermpower -= 2

	if((cell.percent() > AUTO_THRESHOLD_LIGHTING) || longtermpower > 0)              // Put most likely at the top so we don't check it last, effeciency 101
		if(autoflag != 3)
			equipment = autoset(equipment, 1)
			lighting = autoset(lighting, 1)
			environ = autoset(environ, 1)
			autoflag = 3
			power_alarm.clearAlarm(loc, src)
	else if((cell.percent() <= AUTO_THRESHOLD_LIGHTING) && (cell.percent() > AUTO_THRESHOLD_EQUIPMENT) && longtermpower < 0)                       // <50%, turn off lighting
		if(autoflag != 2)
			equipment = autoset(equipment, 1)
			lighting = autoset(lighting, 2)
			environ = autoset(environ, 1)
			power_alarm.triggerAlarm(loc, src)
			autoflag = 2
	else if(cell.percent() <= AUTO_THRESHOLD_EQUIPMENT)        // <25%, turn off lighting & equipment
		if((autoflag > 1 && longtermpower < 0) || (autoflag > 1 && longtermpower >= 0))
			equipment = autoset(equipment, 2)
			lighting = autoset(lighting, 2)
			environ = autoset(environ, 1)
			power_alarm.triggerAlarm(loc, src)
			autoflag = 1
	else                                   // zero charge, turn all off
		if(autoflag != 0)
			equipment = autoset(equipment, 0)
			lighting = autoset(lighting, 0)
			environ = autoset(environ, 0)
			power_alarm.triggerAlarm(loc, src)
			autoflag = 0

// val 0=off, 1=off(auto) 2=on 3=on(auto)
// on 0=off, 1=on, 2=autooff
// defines a state machine, returns the new state
obj/machinery/power/apc/proc/autoset(var/cur_state, var/on)
	//autoset will never turn on a channel set to off
	switch(cur_state)
		if(POWERCHAN_OFF_TEMP)
			if(on == 1 || on == 2)
				return POWERCHAN_ON
		if(POWERCHAN_OFF_AUTO)
			if(on == 1)
				return POWERCHAN_ON_AUTO
		if(POWERCHAN_ON)
			if(on == 0)
				return POWERCHAN_OFF_TEMP
		if(POWERCHAN_ON_AUTO)
			if(on == 0 || on == 2)
				return POWERCHAN_OFF_AUTO

	return cur_state //leave unchanged


// damage and destruction acts
/obj/machinery/power/apc/emp_act(severity)
	if(emp_hardened)
		return
	// Fail for 8-12 minutes (divided by severity)
	// Division by 2 is required, because machinery ticks are every two seconds. Without it we would fail for 16-24 minutes.
	if(is_critical)
		// Critical APCs are considered EMP shielded and will be offline only for about half minute. Prevents AIs being one-shot disabled by EMP strike.
		// Critical APCs are also more resilient to cell corruption/power drain.
		energy_fail(rand(240, 360) / severity / CRITICAL_APC_EMP_PROTECTION)
		if(cell)
			cell.emp_act(severity+2)
	else
		// Regular APCs fail for normal time.
		energy_fail(rand(240, 360) / severity)
		if(cell)
			cell.emp_act(severity+1)

	update_icon()
	..()

/obj/machinery/power/apc/ex_act(severity)
	switch(severity)
		if(1.0)
			if (cell)
				cell.ex_act(1.0) // more lags woohoo
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				set_broken(TRUE)
				if (cell && prob(50))
					cell.ex_act(2.0)
		if(3.0)
			if (prob(25))
				set_broken(TRUE)
				if (cell && prob(25))
					cell.ex_act(3.0)
	return

/obj/machinery/power/apc/disconnect_terminal(var/obj/machinery/power/terminal/term)
	if(terminal)
		terminal.master = null
		terminal = null

/obj/machinery/power/apc/set_broken(var/state)
	if(state)
		// Aesthetically much better!
		src.visible_message("<span class='notice'>[src]'s screen flickers with warnings briefly!</span>")
		power_alarm.triggerAlarm(loc, src)
		spawn(rand(2,5))
			visible_message("<span class='notice'>[src]'s screen suddenly explodes in rain of sparks and small debris!</span>")
			..()
			operating = 0
			update_icon()
			update()
	else
		..()

/obj/machinery/power/apc/proc/reboot()
	//reset various counters so that process() will start fresh
	charging = initial(charging)
	chargecount = initial(chargecount)
	autoflag = initial(autoflag)
	longtermpower = initial(longtermpower)
	failure_timer = initial(failure_timer)

	//start with main breaker off, chargemode in the default state and all channels on auto upon reboot
	operating = 0
	chargemode = initial(chargemode)
	power_alarm.clearAlarm(loc, src)

	lighting = POWERCHAN_ON_AUTO
	equipment = POWERCHAN_ON_AUTO
	environ = POWERCHAN_ON_AUTO

	update_icon()
	update()

// overload the lights in this APC area
/obj/machinery/power/apc/proc/overload_lighting(var/chance = 100)
	if(/* !get_connection() || */ !operating || shorted)
		return
	if( cell && cell.charge>=20)
		cell.use(20);
		spawn(0)
			for(var/obj/machinery/light/L in area)
				if(prob(chance))
					L.turn_on()
					L.broken()
				sleep(1)

/obj/machinery/power/apc/proc/setsubsystem(val)
	if(cell && cell.charge > 0)
		switch(val)
			if(2) return POWERCHAN_ON_AUTO
			if(1) return POWERCHAN_ON
			else return POWERCHAN_OFF
	else
		switch(val)
			if(2) return POWERCHAN_OFF_AUTO
			if(1) return POWERCHAN_OFF_TEMP
			else return POWERCHAN_OFF



// Malfunction: Transfers APC under AI's control
/obj/machinery/power/apc/proc/ai_hack(var/mob/living/silicon/ai/A = null)
	if(!A || !A.hacked_apcs || hacker || aidisabled || A.stat == DEAD)
		return 0
	src.hacker = A
	A.hacked_apcs += src
	locked = 1
	update_icon()
	return 1

/obj/item/weapon/module/power_control
	name = "power control module"
	desc = "Heavy-duty switching circuits for power control."
	icon = 'icons/obj/module.dmi'
	icon_state = "power_mod"
	item_state = "electronic"
	matter = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50)
	w_class = ITEM_SIZE_SMALL
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/machinery/power/apc/malf_upgrade(var/mob/living/silicon/ai/user)
	..()
	malf_upgraded = 1
	emp_hardened = 1
	to_chat(user, "\The [src] has been upgraded. It is now protected against EM pulses.")
	return 1

// ALARM HANDLERS

/obj/machinery/power/apc/proc/AlarmOnEntered(var/mob/living/carbon/human/A)
	if (!istype(A))
		return
	if (text2num(alarm_access) in A.GetAccess(req_access_faction))
		return

	AlarmHandleThreat(A)

/obj/machinery/power/apc/proc/AlarmHandleThreat(var/mob/living/carbon/human/A)
	if (!alarm_status || alarm_threat_warning || alarm_alert)
		return
	playsound(src, 'sound/effects/compbeep3.ogg', 80, 1)
	to_chat(A, SPAN_DANGER("You detect what seems to be an alarm in this area. You have over [alarm_threat_warning_timeout/10] seconds to leave/deactivate the alarm.") )
	AlarmSet(ALARM_WARN)

/obj/machinery/power/apc/proc/AlarmCheckForThreats()
	for (var/mob/living/carbon/human/A in src.area)
		message_admins("Human found [A]")
		if ( ! (text2num(alarm_access) in A.GetAccess(req_access_faction)) )
			return AlarmSet(ALARM_THREAT)
	return AlarmSet(ALARM_OFF)

/obj/machinery/power/apc/proc/AlarmSet(var/status)
	switch (status)
		if (ALARM_WARN)
			alarm_threat_warning = TRUE
			alarm_threat_warning_timebuffer = world.time
			alarm_alert = FALSE
		if (ALARM_THREAT)
			alarm_threat_warning = FALSE
			alarm_threat_warning_timebuffer = null
			alarm_alert = TRUE
		if (ALARM_OFF)
			alarm_threat_warning = FALSE
			alarm_threat_warning_timebuffer = null
			alarm_alert = FALSE

/obj/machinery/power/apc/proc/AlarmUpdate()
	if (!operating || !alarm_status)
		AlarmSet(ALARM_OFF)
		return
	if (alarm_threat_warning)
		if (world.time >= alarm_threat_warning_timebuffer + alarm_threat_warning_timeout)
			AlarmCheckForThreats()
	if (alarm_alert)
		visible_message("** BEEP ** BEEP **** BEEP ** BEEP **")
		playsound(src, 'sound/machines/airalarm.ogg', 80, 1)

#undef APC_UPDATE_ICON_COOLDOWN

#undef ALARM_OFF
#undef ALARM_THREAT
#undef ALARM_WARN
