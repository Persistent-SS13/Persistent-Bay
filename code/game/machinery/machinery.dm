/*
Overview:
   Used to create objects that need a per step proc call.  Default definition of 'New()'
   stores a reference to src machine in global 'machines list'.  Default definition
   of 'Destroy' removes reference to src machine in global 'machines list'.

Class Variables:
   use_power (num)
	  current state of auto power use.
	  Possible Values:
		 0 -- no auto power use
		 1 -- machine is using power at its idle power level
		 2 -- machine is using power at its active power level

   active_power_usage (num)
	  Value for the amount of power to use when in active power mode

   idle_power_usage (num)
	  Value for the amount of power to use when in idle power mode

   power_channel (num)
	  What channel to draw from when drawing power for power mode
	  Possible Values:
		 EQUIP:0 -- Equipment Channel
		 LIGHT:2 -- Lighting Channel
		 ENVIRON:3 -- Environment Channel

   component_parts (list)
	  A list of component parts of machine used by frame based machines.

   panel_open (num)
	  Whether the panel is open

   uid (num)
	  Unique id of machine across all machines.

   gl_uid (global num)
	  Next uid value in sequence

   stat (bitflag)
	  Machine status bit flags.
	  Possible bit flags:
		 BROKEN:1 -- Machine is broken
		 NOPOWER:2 -- No power is being supplied to machine.
		 POWEROFF:4 -- tbd
		 MAINT:8 -- machine is currently under going maintenance.
		 EMPED:16 -- temporary broken by EMP pulse

Class Procs:
   New()					 'game/machinery/machine.dm'

   Destroy()					 'game/machinery/machine.dm'

   auto_use_power()			'game/machinery/machine.dm'
	  This proc determines how power mode power is deducted by the machine.
	  'auto_use_power()' is called by the 'machines' subsystem every tick.

	  Return Value:
		 return:1 -- if object is powered
		 return:0 -- if object is not powered.

	  Default definition uses 'use_power', 'power_channel', 'active_power_usage',
	  'idle_power_usage', 'powered()', and 'use_power()' implement behavior.

   powered(chan = EQUIP)		 'modules/power/power.dm'
	  Checks to see if area that contains the object has power available for power
	  channel given in 'chan'.

   use_power(amount, chan=EQUIP, autocalled)   'modules/power/power.dm'
	  Deducts 'amount' from the power channel 'chan' of the area that contains the object.
	  If it's autocalled then everything is normal, if something else calls use_power we are going to
	  need to recalculate the power two ticks in a row.

   power_change()			   'modules/power/power.dm'
	  Called by the area that contains the object when ever that area under goes a
	  power state change (area runs out of power, or area channel is turned off).

   RefreshParts()			   'game/machinery/machine.dm'
	  Called to refresh the variables in the machine that are contributed to by parts
	  contained in the component_parts list. (example: glass and material amounts for
	  the autolathe)

	  Default definition does nothing.

   assign_uid()			   'game/machinery/machine.dm'
	  Called by machine to assign a value to the uid variable.

   process()				  'game/machinery/machine.dm'
	  Called by the 'machines' subsystem once per game tick for each machine that is listed in the 'machines' list.


	Compiled by Aygar
*/

/obj/machinery
	name = "machinery"
	icon = 'icons/obj/stationobjs.dmi'
	w_class = ITEM_SIZE_NO_CONTAINER
	obj_flags = OBJ_FLAG_DAMAGEABLE
	layer = 2.9
	var/stat = 0
	var/emagged = 0
	var/malf_upgraded = 0
	var/use_power = POWER_USE_IDLE
		//0 = dont run the auto
		//1 = run auto, use idle
		//2 = run auto, use active
	var/idle_power_usage = 0
	var/active_power_usage = 0
	var/power_channel = EQUIP //EQUIP, ENVIRON or LIGHT
	var/list/component_parts = null //list of all the parts used to build it, if made from certain kinds of frames.
	var/uid
	var/panel_open = 0
	var/global/gl_uid = 1
	var/interact_offline = 0 // Can the machine be interacted with while de-powered.
	var/clicksound			// sound played on succesful interface use by a carbon lifeform
	var/clickvol = 40		// sound played on succesful interface use
	var/multiplier = 0
	var/datum/world_faction/faction
	var/faction_uid
	//Damage handling
	max_health = 100
	var/break_threshold = 0.5 //Percentage of health remaining at which the machine goes into broken state
	var/time_emped = 0		  //Time left being emped
	var/emped_disabled_max_time = 5 MINUTES //Maximum time this machine can be disabled by EMP(Aka for severity 1)
	var/frame_type = /obj/machinery/constructable_frame/machine_frame //The type of frame that will be left behind after deconstruction
	//Radio stuff
	var/id_tag						//Mappervar: Sets the initial id_tag.
	var/frequency 		 	= null	//Mappervar: Sets the initial radio listening frequency.
	var/range 				= null	//Mappervar: Sets the initial radio range.
	var/radio_filter_out 	= null	//Mappervar: Sets the initial output radio filter.
	var/radio_filter_in 	= null	//Mappervar: Sets the initial listening radio filter.
	var/radio_check_id 		= TRUE //Whether the machine checks it own id against the target id of a radio command before executing the command.

/obj/machinery/New()
	..()
	ADD_SAVED_VAR(extensions)
	ADD_SAVED_VAR(time_emped)
	ADD_SAVED_VAR(panel_open)
	ADD_SAVED_VAR(component_parts)
	ADD_SAVED_VAR(use_power)
	ADD_SAVED_VAR(malf_upgraded)
	ADD_SAVED_VAR(emagged)
	ADD_SAVED_VAR(stat)

	ADD_SKIP_EMPTY(extensions)
	ADD_SKIP_EMPTY(component_parts)

/obj/machinery/after_load()
	..()
	RefreshParts()
	update_health()

/obj/machinery/Initialize(mapload, d=0)
	. = ..()
	init_transmitter()
	if(d)
		set_dir(d)
	START_PROCESSING(SSmachines, src)

/obj/machinery/Destroy()
	STOP_PROCESSING(SSmachines, src)
	if(component_parts)
		for(var/atom/A in component_parts)
			if(A.loc == src) // If the components are inside the machine, delete them.
				qdel(A)
			else // Otherwise we assume they were dropped to the ground during deconstruction, and were not removed from the component_parts list by deconstruction code.
				component_parts -= A
	if(has_transmitter())
		delete_transmitter()
	. = ..()

/obj/machinery/proc/RefreshParts() //Placeholder proc for machines that are built using frames.
	return

/obj/machinery/InsertedContents()
	return (contents - component_parts)

/obj/machinery/proc/assign_uid()
	uid = gl_uid
	gl_uid++

/obj/machinery/Process()//If you dont use process or power why are you here
	if(time_emped && world.realtime >= time_emped)
		time_emped = 0
		set_emped(FALSE)
		emp_end()

	if(!(use_power || idle_power_usage || active_power_usage) && !interact_offline)
		return PROCESS_KILL

//-----------------------------------------
// Machine State
//-----------------------------------------
/proc/is_operable(var/obj/machinery/M, var/mob/user)
	return istype(M) && M.operable()

/obj/machinery/proc/operable(var/additional_flags = 0)
	return !inoperable(additional_flags)

/obj/machinery/proc/inoperable(var/additional_flags = 0)
	return (stat & (NOPOWER|BROKEN|additional_flags))

/obj/machinery/proc/set_broken(var/state)
	src.stat = state? (src.stat | BROKEN) : (stat & ~BROKEN)
	update_icon()

/obj/machinery/proc/set_emped(var/state)
	src.stat = state? (src.stat | EMPED) : (stat & ~EMPED)
	update_icon()

/obj/machinery/proc/set_maintenance(var/state)
	src.stat = state? (src.stat | MAINT) : (stat & ~MAINT)
	update_icon()

/obj/machinery/proc/ison()
	return use_power == POWER_USE_ACTIVE

/obj/machinery/proc/isidle()
	return use_power == POWER_USE_IDLE

/obj/machinery/proc/isoff()
	return use_power == POWER_USE_OFF

/obj/machinery/proc/turn_on()
	update_use_power(POWER_USE_ACTIVE)
	update_icon()

/obj/machinery/proc/turn_idle()
	update_use_power(POWER_USE_IDLE)
	update_icon()

/obj/machinery/proc/turn_off()
	update_use_power(POWER_USE_OFF)
	update_icon()

//Flags
/obj/machinery/proc/isbroken()
	return (stat & BROKEN)

/obj/machinery/proc/ispowered()
	return !(stat & NOPOWER)

/obj/machinery/proc/ismaintenance()
	return (stat & MAINT)

/obj/machinery/proc/isemped()
	return (stat & EMPED)

//Defined at machinery level so that it can be used everywhere with little effort.
/obj/machinery/proc/HasMultiplier()
	return initial(multiplier) > 0

//-----------------------------------------
// Power System
//-----------------------------------------
//sets the use_power var
/obj/machinery/proc/update_use_power(var/new_use_power)
	use_power = new_use_power

/obj/machinery/proc/auto_use_power()
	if(!powered(power_channel))
		return 0
	if(src.use_power == POWER_USE_IDLE)
		use_power(idle_power_usage,power_channel, 1)
	else if(src.use_power >= POWER_USE_ACTIVE)
		use_power(active_power_usage,power_channel, 1)
	return 1

// returns true if the area has power on given channel (or doesn't require power), defaults to power_channel.
// May also optionally specify an area, otherwise defaults to src.loc.loc
/obj/machinery/proc/powered(var/chan = -1, var/area/check_area = null)
	if(!src.loc)
		return FALSE
	if(!check_area)
		check_area = src.loc.loc		// make sure it's in an area
	if(!check_area || !isarea(check_area))
		return FALSE				// if not, then not powered
	if(chan == -1)
		chan = power_channel
	return check_area.powered(chan)			// return power status of the area

// increment the power usage stats for an area
/obj/machinery/proc/use_power(var/amount, var/chan = -1) // defaults to power_channel
	var/area/A = get_area(src)		// make sure it's in an area
	if(!A || !isarea(A))
		return
	if(chan == -1)
		chan = power_channel
	A.use_power(amount, chan)

// called whenever the power settings of the containing area change
// by default, check equipment channel & set flag can override if needed
/obj/machinery/proc/power_change()
	var/oldstat = stat

	if(powered(power_channel))
		stat &= ~NOPOWER
	else
		stat |= NOPOWER

	. = (stat != oldstat)
	if(.)
		update_icon()

//----------------------------------------
// Interactions
//----------------------------------------
/obj/machinery/proc/can_connect(var/datum/world_faction/trying)
	return 1

/obj/machinery/proc/can_disconnect(var/datum/world_faction/trying, var/mob/M)
	return 1

/obj/machinery/CanUseTopic(var/mob/user)
	if(isbroken())
		return STATUS_CLOSE

	if(!interact_offline && !ispowered())
		return STATUS_CLOSE

	return ..()

/obj/machinery/CouldUseTopic(var/mob/user)
	..()
	user.set_machine(src)

/obj/machinery/CouldNotUseTopic(var/mob/user)
	user.unset_machine()

/obj/machinery/attack_ai(mob/user as mob)
	if(isrobot(user))
		// For some reason attack_robot doesn't work
		// This is to stop robots from using cameras to remotely control machines.
		if(user.client && user.client.eye == user)
			return src.attack_hand(user)
	else
		return src.attack_hand(user)

/obj/machinery/attack_hand(mob/user as mob)
	if(inoperable(MAINT))
		return TRUE
	if(user.lying || user.stat)
		return TRUE
	if (!(istype(usr, /mob/living/carbon/human) || istype(usr, /mob/living/silicon)))
		to_chat(usr, SPAN_WARNING("You don't have the dexterity to do this!"))
		return TRUE

	if (ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.getBrainLoss() >= 55)
			visible_message(SPAN_WARNING("[H] stares cluelessly at \the [src]."))
			return TRUE
		else if(prob(H.getBrainLoss()))
			to_chat(user, SPAN_WARNING("You momentarily forget how to use \the [src]."))
			return TRUE

	return ..()

/obj/machinery/proc/state(var/msg)
	for(var/mob/O in hearers(src, null))
		O.show_message("\icon[src] <span class = 'notice'>[msg]</span>", 2)

/obj/machinery/proc/ping(text=null)
	if (!text)
		text = "\The [src] pings."
	state(text, "blue")
	playsound(src.loc, 'sound/machines/ping.ogg', 50, 0)

/obj/machinery/proc/shock(mob/user, prb)
	if(inoperable())
		return 0
	if(!prob(prb))
		return 0
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(5, 1, src)
	s.start()
	if(electrocute_mob(user, get_area(src), src, 0.7))
		var/area/temp_area = get_area(src)
		if(temp_area)
			var/obj/machinery/power/apc/temp_apc = temp_area.get_apc()

			if(temp_apc && temp_apc.terminal && temp_apc.terminal.powernet)
				temp_apc.terminal.powernet.trigger_warning()
		if(user.stunned)
			return 1
	return 0

/obj/machinery/proc/dismantle()
	playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
	for(var/obj/I in component_parts)
		I.forceMove(get_turf(src))
	var/obj/M = new frame_type(get_turf(src), state = MACHINE_FRAME_CABLED)
	M.set_dir(src.dir)
	qdel(src)
	return 1

/datum/proc/apply_visual(mob/M)
	return

/datum/proc/remove_visual(mob/M)
	return

/obj/machinery/proc/malf_upgrade(var/mob/living/silicon/ai/user)
	return 0

/obj/machinery/CouldUseTopic(var/mob/user)
	..()
	if(clicksound && istype(user, /mob/living/carbon))
		playsound(src, clicksound, clickvol)

/obj/machinery/proc/GetMultiplierForm(var/obj/machinery/M)
	var/dat = ""
	if(!M.HasMultiplier())
		return dat
	dat += {"<form name='update_mult' action='?src=\ref[M]'>
				<input type='hidden' name='src' value='\ref[M]'>
				<input type='hidden' name='update_mult' value='input'>
				Multiplier:
				<input type='text' name='input' value='[M:multiplier]' size='3'>
				<input type='submit' class='button' value='Enter'>
				<A href='?src=\ref[M];update_mult=1;input=1'>X</A>
			</form>"}
	dat += "<hr>"
	return dat

/obj/machinery/proc/ProcessMultiplierForm(var/obj/machinery/M, var/list/href_list)
	if(!M.HasMultiplier())
		return 0
	var/new_mult = text2num(href_list["input"])
	if(isnum(new_mult))
		new_mult = min(25, max(1, round(new_mult, 1))) //multiplier has to be at least 1, maximum of 20
		M.multiplier = new_mult
		return 1
	return 0

//----------------------------------
//	Default Interaction Procs
//----------------------------------
/obj/machinery/proc/default_deconstruction_crowbar(var/mob/user, var/obj/item/weapon/tool/crowbar/C)
	if(!istype(C))
		return 0
	if(!panel_open)
		return 0
	. = dismantle()

/obj/machinery/proc/default_deconstruction_screwdriver(var/mob/user, var/obj/item/weapon/tool/screwdriver/S)
	if(!istype(S))
		return 0
	playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
	panel_open = !panel_open
	to_chat(user, SPAN_NOTICE("You [panel_open ? "open" : "close"] the maintenance hatch of \the [src]."))
	update_icon()
	return 1

/obj/machinery/proc/default_part_replacement(var/mob/user, var/obj/item/weapon/storage/part_replacer/R)
	if(!istype(R))
		return 0
	if(!component_parts)
		return 0
	if(panel_open)
		var/obj/item/weapon/circuitboard/CB = locate(/obj/item/weapon/circuitboard) in component_parts
		var/P
		for(var/obj/item/weapon/stock_parts/A in component_parts)
			for(var/T in CB.req_components)
				if(ispath(A.type, T))
					P = T
					break
			for(var/obj/item/weapon/stock_parts/B in R.contents)
				if(istype(B, P) && istype(A, P))
					if(B.rating > A.rating)
						R.remove_from_storage(B, src)
						R.handle_item_insertion(A, 1)
						component_parts -= A
						component_parts += B
						B.loc = null
						to_chat(user, SPAN_NOTICE("[A.name] replaced with [B.name]."))
						break
			update_icon()
			RefreshParts()
	else
		to_chat(user, SPAN_NOTICE("Following parts detected in the machine:"))
		for(var/var/obj/item/C in component_parts)
			to_chat(user, SPAN_NOTICE("	[C.name]"))
	return 1

//----------------------------------
//	Radio Remote Control
//----------------------------------

//Default code to initialize the transmitter
/obj/machinery/proc/init_transmitter()
	if(!has_transmitter() && frequency && (radio_filter_in || radio_filter_out))
		create_transmitter(id_tag, frequency, radio_filter_in, range, radio_filter_out)

/obj/machinery/proc/has_transmitter()
	return src.HasExtension(RADIO_TRANSMITTER_TYPE)

/obj/machinery/proc/get_transmitter()
	return src.GetExtension(RADIO_TRANSMITTER_TYPE)

/obj/machinery/proc/transmitter_ready()
	var/datum/extension/interactive/radio_transmitter/T = get_transmitter()
	return T && T.is_connected()

/obj/machinery/proc/create_transmitter(var/id, var/frequency = 0, var/filter = RADIO_DEFAULT, var/range = null, var/filterout = null)
	if(has_transmitter())
		delete_transmitter()
	set_extension(src, RADIO_TRANSMITTER_TYPE, RADIO_TRANSMITTER_TYPE, frequency, id, range, filter, filterout)
	//log_debug("Created radio transmitter for [src] \ref[src]. id: '[id]', frequency: [frequency], filter: [filter], range: [range? range : "null"], filterout: [filterout? filterout : filter]")

/obj/machinery/proc/delete_transmitter()
	var/datum/extension/interactive/radio_transmitter/T = get_transmitter()
	if(T)
		qdel(T)

/obj/machinery/proc/set_radio_frequency(var/freq as num)
	src.frequency = freq
	var/datum/extension/interactive/radio_transmitter/T = get_transmitter()
	if(T)
		return T.set_frequency(freq)

/obj/machinery/proc/get_radio_frequency()
	var/datum/extension/interactive/radio_transmitter/T = get_transmitter()
	if(T)
		return T.get_frequency()
	return null

/obj/machinery/proc/set_radio_id(var/id as text)
	src.id_tag = id
	var/datum/extension/interactive/radio_transmitter/T = get_transmitter()
	if(T)
		return T.set_id(id)

/obj/machinery/proc/get_radio_id()
	var/datum/extension/interactive/radio_transmitter/T = get_transmitter()
	if(T)
		return T.get_id()
	return null

/obj/machinery/proc/check_radio_match_id(var/datum/signal/signal)
	var/datum/extension/interactive/radio_transmitter/T = get_transmitter()
	if(T)
		return T.match_id(signal)
	return FALSE

//Returns the target id_tag of the specified signal
// /obj/machinery/proc/signal_target_id(var/datum/signal/signal)
// 	var/datum/extension/interactive/radio_transmitter/T = get_transmitter()
// 	if(T)
// 		return T.match_target(signal)
// 	return null

/obj/machinery/proc/set_radio_filter(var/filter as text)
	src.radio_filter_in = filter
	var/datum/extension/interactive/radio_transmitter/T = get_transmitter()
	if(T)
		return T.set_filter(filter)

/obj/machinery/proc/set_radio_filter_out(var/filter as text)
	src.radio_filter_out = filter
	var/datum/extension/interactive/radio_transmitter/T = get_transmitter()
	if(T)
		return T.set_filter_out(filter)

/obj/machinery/proc/get_radio_filter()
	var/datum/extension/interactive/radio_transmitter/T = get_transmitter()
	if(T)
		return T.get_filter()
	return null

/obj/machinery/proc/get_radio_filter_out()
	var/datum/extension/interactive/radio_transmitter/T = get_transmitter()
	if(T)
		return T.get_filter_out()
	return null

/obj/machinery/proc/set_radio_range(var/range as num)
	src.range = range
	var/datum/extension/interactive/radio_transmitter/T = get_transmitter()
	if(T)
		return T.set_range(range)

/obj/machinery/proc/get_radio_range()
	var/datum/extension/interactive/radio_transmitter/T = get_transmitter()
	if(T)
		return T.get_range()
	return null

//Send a signal using the radio transmitter to the target id tag, or to the same id_tag as the src machine
/obj/machinery/proc/post_signal(var/list/data, var/overridefilter = null, var/overridetag = null, var/overridefreq = null)
	var/datum/extension/interactive/radio_transmitter/T = get_transmitter()
	if(!T)
		log_debug("[src]\ref[src] tried to send a signal and there is no radio transmitter instantiated!")
		return null

	var/datum/signal/signal = new
	signal.transmission_method = TRANSMISSION_RADIO //radio signal
	signal.source = src
	signal.data = data.Copy()
	T.post_signal(signal, overridefilter, overridetag, overridefreq)
	return TRUE

//Sends a signal without a target id over a frequency and filter
/obj/machinery/proc/broadcast_signal(var/list/data, var/overridefilter = null, var/overridefreq = null)
	var/datum/extension/interactive/radio_transmitter/T = get_transmitter()
	if(!T)
		log_debug("[src]\ref[src] tried to send a signal and there is no radio transmitter instantiated!")
		return null
	var/datum/signal/signal = new
	signal.transmission_method = TRANSMISSION_RADIO //radio signal
	signal.source = src
	signal.data = data.Copy()
	T.broadcast_signal(signal, overridefilter, overridefreq)
	return TRUE

//Signals received go straight to the machine's topic handling, so handling radio signal is seamless.
/obj/machinery/receive_signal(var/datum/signal/signal, var/receive_method, var/receive_param)
	if(!signal || !has_transmitter() || inoperable() || (signal && signal.source == src))
		return
	if( (radio_check_id && check_radio_match_id(signal)) || !radio_check_id)
		//log_debug("[src]\ref[src] received signal from [signal.source]\ref[signal.source]. Signal tag is '[signal_target_id(signal)]', and our tag is '[get_radio_id()]'")
		return OnSignal(signal)

//Signals received by default go straight to the machine's topic handling, so handling radio signal is seamless.
/obj/machinery/proc/OnSignal(var/datum/signal/signal)
	return
//	return OnTopic(usr, signal.data, GLOB.default_state)

//Used to emit status updates to any machines listening to this one
// /obj/machinery/proc/broadcast_status()
// 	return

//Used to generate a id_tag that would be unique to the machine at that specific coordinate
/obj/machinery/proc/make_loc_string_id(var/prefix)
	return "[prefix]([x]:[y]:[z])"

//----------------------------------
// Damage procs
//----------------------------------
/obj/machinery/update_health(var/damagetype)
	..(damagetype)
	//Determine if we're broken or not
	if(health <= (max_health * break_threshold))
		broken(damagetype)

//Called when the machine is broken
/obj/machinery/proc/broken(var/damagetype)
	set_broken(TRUE)
	update_icon()

/obj/machinery/emp_act(severity)
	if(use_power && operable())
		set_emped(TRUE)
		time_emped = (emped_disabled_max_time / severity)
		use_power(7500/severity)

		var/obj/effect/overlay/pulse2 = new /obj/effect/overlay(loc)
		pulse2.icon = 'icons/effects/effects.dmi'
		pulse2.icon_state = "empdisable"
		pulse2.name = "emp sparks"
		pulse2.anchored = 1
		pulse2.set_dir(pick(GLOB.cardinal))

		spawn(10)
			qdel(pulse2)
	..()

//Called in process after the emp wears off. Override in your subclass
/obj/machinery/proc/emp_end()
	update_icon()
