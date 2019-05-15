// the SMES
// stores power

#define SMESMAXCHARGELEVEL 250000
#define SMESMAXOUTPUT 250000

/obj/machinery/power/smes
	name = "power storage unit"
	desc = "A high-capacity superconducting magnetic energy storage (SMES) unit."
	icon_state = "smes"
	density = 1
	anchored = 1
	clicksound = "switch"

	var/capacity = 5e6 // maximum charge
	var/charge = 1e6 // actual charge

	var/input_attempt = 0 			// 1 = attempting to charge, 0 = not attempting to charge
	var/inputting = 0 				// 1 = actually inputting, 0 = not inputting
	var/input_level = 50000 		// amount of power the SMES attempts to charge by
	var/input_level_max = 200000 	// cap on input_level
	var/input_available = 0 		// amount of charge available from input last tick

	var/output_attempt = 0 			// 1 = attempting to output, 0 = not attempting to output
	var/outputting = 0 				// 1 = actually outputting, 0 = not outputting
	var/output_level = 50000		// amount of power the SMES attempts to output
	var/output_level_max = 200000	// cap on output_level
	var/output_used = 0				// amount of power actually outputted. may be less than output_level if the powernet returns excess power

	//Holders for powerout event.
	//var/last_output_attempt	= 0
	//var/last_input_attempt	= 0
	//var/last_charge			= 0

	//For icon overlay updates
	var/last_disp
	var/last_chrg
	var/last_onln

	var/damage = 0
	var/maxdamage = 500 // Relatively resilient, given how expensive it is, but once destroyed produces small explosion.

	var/input_cut = 0
	var/input_pulsed = 0
	var/output_cut = 0
	var/output_pulsed = 0
	var/failure_timer = 0			// Set by gridcheck event, temporarily disables the SMES.
	var/target_load = 0
	var/name_tag = null
	var/building_terminal = 0 //Suggestions about how to avoid clickspam building several terminals accepted!
	var/list/terminals = list()
	var/should_be_mapped = 0 // If this is set to 0 it will send out warning on New()

/obj/machinery/power/smes/drain_power(var/drain_check, var/surge, var/amount = 0)

	if(drain_check)
		return 1

	var/smes_amt = min((amount * CELLRATE), charge)
	charge -= smes_amt
	return smes_amt / CELLRATE


/obj/machinery/power/smes/New()
	..()
	if(!should_be_mapped)
		warning("Non-buildable or Non-magical SMES at [src.x]X [src.y]Y [src.z]Z")

/obj/machinery/power/smes/Initialize()
	. = ..()
	for(var/d in GLOB.cardinal)
		var/turf/T = get_step(src, d)
		for(var/obj/machinery/power/terminal/term in T)
			if(term && term.dir == turn(d, 180) && !term.master)
				terminals |= term
				term.master = src
				term.connect_to_network()
	if(!terminals.len)
		set_broken(TRUE)
		return
	update_icon()

/obj/machinery/power/smes/add_avail(var/amount)
	if(..(amount))
		powernet.smes_newavail += amount
		return 1
	return 0


/obj/machinery/power/smes/disconnect_terminal(var/obj/machinery/power/terminal/term)
	terminals -= term
	term.master = null

/obj/machinery/power/smes/on_update_icon()
	overlays.Cut()
	if(stat & BROKEN)	return

	overlays += image(src.icon, "smes-op[outputting]")

	if(inputting == 2)
		overlays += image(src.icon, "smes-oc2")
	else if (inputting == 1)
		overlays += image(src.icon, "smes-oc1")
	else if (input_attempt)
		overlays += image(src.icon, "smes-oc0")

	var/clevel = chargedisplay()
	if(clevel)
		overlays += image(src.icon, "smes-og[clevel]")

	if(outputting == 2)
		overlays += image(src.icon, "smes-op2")
	else if (outputting == 1)
		overlays += image(src.icon, "smes-op1")
	else
		overlays += image(src.icon, "smes-op0")

/obj/machinery/power/smes/proc/chargedisplay()
	return round(5.5*charge/(capacity ? capacity : 5e6))

/obj/machinery/power/smes/proc/input_power(var/percentage)
	var/to_input = target_load * (percentage/100)
	to_input = between(0, to_input, target_load)
	input_available = 0
	if(percentage == 100)
		inputting = 2
	else if(percentage)
		inputting = 1
	// else inputting = 0, as set in process()

	for(var/obj/machinery/power/terminal/term in terminals)
		if(!term.powernet)
			continue
		var/inputted = term.powernet.draw_power(to_input)
		add_charge(inputted)
		input_available += inputted

// Mostly in place due to child types that may store power in other way (PSUs)
/obj/machinery/power/smes/proc/add_charge(var/amount)
	charge += amount*CELLRATE

/obj/machinery/power/smes/proc/remove_charge(var/amount)
	charge -= amount*CELLRATE

/obj/machinery/power/smes/Process()
	if(stat & BROKEN)	return
	if(failure_timer)	// Disabled by gridcheck.
		failure_timer--
		return

	// only update icon if state changed
	if(last_disp != chargedisplay() || last_chrg != inputting || last_onln != outputting)
		update_icon()

	//store machine state to see if we need to update the icon overlays
	last_disp = chargedisplay()
	last_chrg = inputting
	last_onln = outputting

	input_available = 0
	//inputting
	if(input_attempt && (!input_pulsed && !input_cut))
		target_load = min((capacity-charge)/CELLRATE, input_level)	// Amount we will request from the powernet.
		var/input_available = FALSE
		for(var/obj/machinery/power/terminal/term in terminals)
			if(!term.powernet)
				continue
			input_available = TRUE
			term.powernet.smes_demand += target_load
			term.powernet.inputting.Add(src)
		if(!input_available)
			target_load = 0 // We won't input any power without powernet connection.
		inputting = 0

	output_used = 0
	//outputting
	if(output_attempt && (!output_pulsed && !output_cut) && powernet && charge)
		output_used = min( charge/CELLRATE, output_level)		//limit output to that stored
		remove_charge(output_used)			// reduce the storage (may be recovered in /restore() if excessive)
		add_avail(output_used)				// add output to powernet (smes side)
		outputting = 2
	else if(!powernet || !charge)
		outputting = 1
	else
		outputting = 0

// called after all power processes are finished
// restores charge level to smes if there was excess this ptick
/obj/machinery/power/smes/proc/restore(var/percent_load)
	if(stat & BROKEN)
		return

	if(!outputting)
		output_used = 0
		return

	var/total_restore = output_used * (percent_load / 100) // First calculate amount of power used from our output
	total_restore = between(0, total_restore, output_used) // Now clamp the value between 0 and actual output, just for clarity.
	total_restore = output_used - total_restore			   // And, at last, subtract used power from outputted power, to get amount of power we will give back to the SMES.

	// now recharge this amount

	var/clev = chargedisplay()

	add_charge(total_restore)				// restore unused power
	powernet.netexcess -= total_restore		// remove the excess from the powernet, so later SMESes don't try to use it

	output_used -= total_restore

	if(clev != chargedisplay() ) //if needed updates the icons overlay
		update_icon()
	return

//Will return 1 on failure
/obj/machinery/power/smes/proc/make_terminal(const/mob/user)
	if (user.loc == loc)
		to_chat(user, "<span class='warning'>You must not be on the same tile as the [src].</span>")
		return 1

	//Direction the terminal will face to
	var/tempDir = get_dir(user, src)
	switch(tempDir)
		if (NORTHEAST, SOUTHEAST)
			tempDir = EAST
		if (NORTHWEST, SOUTHWEST)
			tempDir = WEST
	var/turf/tempLoc = get_step(src, reverse_direction(tempDir))
	if (istype(tempLoc, /turf/space))
		to_chat(user, "<span class='warning'>You can't build a terminal on space.</span>")
		return 1
	else if (istype(tempLoc))
		if(!tempLoc.is_plating())
			to_chat(user, "<span class='warning'>You must remove the floor plating first.</span>")
			return 1
	if(check_terminal_exists(tempLoc, user, tempDir))
		return 1
	to_chat(user, "<span class='notice'>You start adding cable to the [src].</span>")
	if(do_after(user, 50, src))
		if(check_terminal_exists(tempLoc, user, tempDir))
			return 1
		var/obj/machinery/power/terminal/term = new/obj/machinery/power/terminal(tempLoc)
		term.set_dir(tempDir)
		term.master = src
		term.connect_to_network()
		terminals |= term
		return 0
	return 1


/obj/machinery/power/smes/proc/check_terminal_exists(var/turf/location, var/mob/user, var/direction)
	for(var/obj/machinery/power/terminal/term in location)
		if(term.dir == direction)
			to_chat(user, "<span class='notice'>There is already a terminal here.</span>")
			return 1
	return 0

/obj/machinery/power/smes/draw_power(var/amount)
	var/drained = 0
	for(var/obj/machinery/power/terminal/term in terminals)
		if(!term.powernet)
			continue
		if((amount - drained) <= 0)
			return 0
		drained += term.powernet.draw_power(amount - drained)
	return drained


/obj/machinery/power/smes/attack_ai(mob/user)
	add_hiddenprint(user)
	ui_interact(user)

/obj/machinery/power/smes/attack_hand(mob/user)
	add_fingerprint(user)
	ui_interact(user)


/obj/machinery/power/smes/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)

	if(default_deconstruction_screwdriver(user, W))
		return

	if (!panel_open)
		to_chat(user, "<span class='warning'>You need to open access hatch on [src] first!</span>")
		return 0

	if(isCoil(W) && !building_terminal)
		building_terminal = 1
		var/obj/item/stack/cable_coil/CC = W
		if (!CC.can_use(10))
			to_chat(user, "<span class='warning'>You need more cables.</span>")
			building_terminal = 0
			return 0
		if (make_terminal(user))
			building_terminal = 0
			return 0
		building_terminal = 0
		CC.use(10)
		user.visible_message(\
				"<span class='notice'>[user.name] has added cables to the [src].</span>",\
				"<span class='notice'>You added cables to the [src].</span>")
		stat = 0
		return 0

	if(isWelder(W))
		var/obj/item/weapon/tool/weldingtool/WT = W
		if(!WT.isOn())
			to_chat(user, "Turn on \the [WT] first!")
			return 0
		if(!damage)
			to_chat(user, "\The [src] is already fully repaired.")
			return 0
		if(WT.remove_fuel(0,user) && do_after(user, damage, src))
			to_chat(user, "You repair all structural damage to \the [src]")
			damage = 0
		return 0
	else if(isWirecutter(W) && !building_terminal)
		building_terminal = 1
		var/obj/machinery/power/terminal/term
		for(var/obj/machinery/power/terminal/T in get_turf(user))
			if(T.master == src)
				term = T
				break
		if(!term)
			to_chat(user, "<span class='warning'>There is no terminal on this tile.</span>")
			building_terminal = 0
			return 0
		var/turf/tempTDir = get_turf(term)
		if (istype(tempTDir))
			if(!tempTDir.is_plating())
				to_chat(user, "<span class='warning'>You must remove the floor plating first.</span>")
			else
				to_chat(user, "<span class='notice'>You begin to cut the cables...</span>")
				playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 50, 1)
				if(do_after(user, 50, src))
					if (prob(50) && electrocute_mob(usr, term.powernet, term))
						var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
						s.set_up(5, 1, src)
						s.start()
						if(usr.stunned)
							return 0
					new /obj/item/stack/cable_coil(loc,10)
					user.visible_message(\
						"<span class='notice'>[user.name] cut the cables and dismantled the power terminal.</span>",\
						"<span class='notice'>You cut the cables and dismantle the power terminal.</span>")
					terminals -= term
					qdel(term)
		building_terminal = 0
		return 0
	return ..()

/obj/machinery/power/smes/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	if(isbroken())
		return

	// this is the data which will be sent to the ui
	var/data[0]
	data["nameTag"] = name_tag
	data["storedCapacity"] = round(100.0*charge/capacity, 0.1)
	data["storedCapacityAbs"] = round(charge/1000, 0.1)
	data["storedCapacityMax"] = round(capacity/1000, 0.1)
	data["charging"] = inputting
	data["chargeMode"] = input_attempt
	data["chargeLevel"] = round(input_level/1000, 0.1)
	data["chargeMax"] = round(input_level_max/1000)
	data["chargeLoad"] = round(input_available/1000, 0.1)
	data["outputOnline"] = output_attempt
	data["outputLevel"] = round(output_level/1000, 0.1)
	data["outputMax"] = round(output_level_max/1000)
	data["outputLoad"] = round(output_used/1000, 0.1)
	data["failTime"] = failure_timer * 2
	data["outputting"] = outputting


	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "smes.tmpl", "SMES Unit", 540, 380)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update(1)

/obj/machinery/power/smes/proc/Percentage()
	if(!capacity)
		return 0
	return round(100.0*charge/capacity, 0.1)

/obj/machinery/power/smes/Topic(href, href_list)
	if(..())
		return 1

	if( href_list["cmode"] )
		inputting(!input_attempt)
		update_icon()
		return 1
	else if( href_list["online"] )
		outputting(!output_attempt)
		update_icon()
		return 1
	else if( href_list["reboot"] )
		failure_timer = 0
		update_icon()
		return 1
	else if( href_list["input"] )
		switch( href_list["input"] )
			if("min")
				input_level = 0
			if("max")
				input_level = input_level_max
			if("set")
				input_level = (input(usr, "Enter new input level (0-[input_level_max/1000] kW)", "SMES Input Power Control", input_level/1000) as num) * 1000
		input_level = max(0, min(input_level_max, input_level))	// clamp to range
		return 1
	else if( href_list["output"] )
		switch( href_list["output"] )
			if("min")
				output_level = 0
			if("max")
				output_level = output_level_max
			if("set")
				output_level = (input(usr, "Enter new output level (0-[output_level_max/1000] kW)", "SMES Output Power Control", output_level/1000) as num) * 1000
		output_level = max(0, min(output_level_max, output_level))	// clamp to range
		return 1


/obj/machinery/power/smes/proc/energy_fail(var/duration)
	failure_timer = max(failure_timer, duration)

/obj/machinery/power/smes/proc/inputting(var/do_input)
	input_attempt = do_input
	if(!input_attempt)
		inputting = 0

/obj/machinery/power/smes/proc/outputting(var/do_output)
	output_attempt = do_output
	if(!output_attempt)
		outputting = 0

/obj/machinery/power/smes/destroyed()
	visible_message(SPAN_DANGER("\The [src] explodes in large rain of sparks and smoke!"))
	// Depending on stored charge percentage cause damage.
	switch(Percentage())
		if(75 to INFINITY)
			explosion(get_turf(src), 1, 2, 4)
		if(40 to 74)
			explosion(get_turf(src), 0, 2, 3)
		if(5 to 39)
			explosion(get_turf(src), 0, 1, 2)
	qdel(src) // Either way we want to ensure the SMES is deleted.

/obj/machinery/power/smes/emp_act(severity)
	if(prob(50))
		inputting(rand(0,1))
		outputting(rand(0,1))
	if(prob(50))
		output_level = rand(0, output_level_max)
		input_level = rand(0, input_level_max)
	if(prob(50))
		charge -= 1e6/severity
		if (charge < 0)
			charge = 0
	if(prob(50))
		energy_fail(rand(0 + (severity * 30),30 + (severity * 30)))
	update_icon()
	..()

/obj/machinery/power/smes/examine(var/mob/user)
	. = ..()
	to_chat(user, "The service hatch is [panel_open ? "open" : "closed"].")
	if(!damage)
		return
	var/damage_percentage = round((get_damages() / get_max_health()) * 100)
	switch(damage_percentage)
		if(75 to INFINITY)
			to_chat(user, "<span class='danger'>It's casing is severely damaged, and sparking circuitry may be seen through the holes!</span>")
		if(50 to 74)
			to_chat(user, "<span class='notice'>It's casing is considerably damaged, and some of the internal circuits appear to be exposed!</span>")
		if(25 to 49)
			to_chat(user, "<span class='notice'>It's casing is quite seriously damaged.</span>")
		if(0 to 24)
			to_chat(user, "It's casing has some minor damage.")
