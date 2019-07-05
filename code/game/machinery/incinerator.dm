#define INCINERATOR_BURN_TIME 	 		 30 SECONDS
#define INCINERATOR_CHECK_INTERVAL		 5 SECONDS
var/const/RADIO_INCINERATORS = "radio_incinerators"

//--------------------------------
//	Generic incinerator
//--------------------------------
/obj/machinery/incinerator
	name = "incinerator"
	desc = "An incinerator, for burning unwanted trash."
	icon = 'icons/obj/machines/cremator.dmi'
	icon_state = "crema1"
	density = TRUE
	anchored = TRUE
	use_power = POWER_USE_IDLE
	idle_power_usage = 10 //10 Watts for idle
	active_power_usage = 4 KILOWATTS //4,000w when active
	circuit_type = /obj/item/weapon/circuitboard/incinerator

	//Radio
	id_tag = null
	frequency = null
	radio_filter_in = RADIO_INCINERATOR
	radio_filter_out = RADIO_INCINERATOR
	radio_check_id = TRUE

	var/incinerating = FALSE
	var/locked = FALSE
	var/burnend = 0 //world time at which the machine is done burning
	var/timenextcheck = 0 //world time before the machine checks again if it should auto-incinerate
	var/datum/gas_mixture/burn_chamber_air
	var/input_dir = WEST
	var/const/maxCapacity = 50 //need entities inside before it auto-incinerates
	var/autoincinerate = TRUE //If true, the incinerator will start automatically to incinerate its content when it reach max capacity
	//var/datum//datum/extension/interactive/radio_transmitter = null
	var/icon_state_incinerating = "crema_active"
	var/icon_state_filled = "crema2"
	var/icon_state_empty = "crema1"
	var/max_power_rating = 4 KILOWATTS //4,000w when active
	var/set_temperature = T20C	//thermostat

/obj/machinery/incinerator/New()
	..()
	burn_chamber_air = new()
	burn_chamber_air.volume = 100
	if(loc)
		burn_chamber_air.merge(loc.return_air().remove_volume(burn_chamber_air.volume))
	if(id_tag && !frequency)
		frequency = INCINERATOR_FREQ
	ADD_SAVED_VAR(burn_chamber_air)
	ADD_SAVED_VAR(input_dir)
	ADD_SAVED_VAR(autoincinerate)

/obj/machinery/incinerator/Initialize()
	. = ..()

/obj/machinery/incinerator/Destroy()
	if(loc && loc.return_air())
		loc.return_air().merge(burn_chamber_air)
	QDEL_NULL(burn_chamber_air)
	return ..()

/obj/machinery/incinerator/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.forceMove(src.loc)
				ex_act(severity)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(src.loc)
					ex_act(severity)
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(src.loc)
					ex_act(severity)
				qdel(src)
				return

/obj/machinery/incinerator/Process()
	if(inoperable())
		incinerating = FALSE
		return

	if(incinerating)
		if(burn_chamber_air.total_moles && burn_chamber_air.temperature < set_temperature)
			burn_chamber_air.add_thermal_energy(max_power_rating * 4)
			burn_chamber_air.react()
		if(nothing_left_to_burn() || world.time >= burnend)
			incinerate_end()
			return
		for(var/mob/living/critter in InsertedContents())
			incinerate_mob(critter)
		for(var/obj/thing in InsertedContents())
			incinerate_object(thing)
	else if(autoincinerate && world.time >= timenextcheck)
		timenextcheck = world.time + INCINERATOR_CHECK_INTERVAL
		if(InsertedContents().len >= maxCapacity)
			incinerate_start()

/obj/machinery/incinerator/proc/nothing_left_to_burn()
	for(var/atom/movable/AM in InsertedContents())
		if(can_burn(AM))
			return FALSE
	return TRUE

/obj/machinery/incinerator/proc/can_burn(var/atom/movable/AM)
	if(istype(AM, /obj/item/organ/internal/stack) || istype(AM, /obj/effect/decal/cleanable/ash)) //Don't burn ashes or laces
		return FALSE
	if(istype(AM, /mob/living) || istype(AM, /obj))
		return TRUE
	return FALSE

/obj/machinery/incinerator/proc/incinerate_object(var/obj/O)
	if(!istype(O) || istype(O,/obj/effect/decal/cleanable/ash) || istype(O, /obj/item/organ/internal/stack))
		return
	O.melt()
	if(O && !QDELETED(O))
		qdel(O)
	new /obj/effect/decal/cleanable/ash(src)

/obj/machinery/incinerator/proc/incinerate_mob(var/mob/living/L)
	if(!istype(L))
		return

	//Give the mob a chance to do something first
	L.apply_damages(100, DAM_BURN)
	L.IgniteMob()

	//If its dead, just dust it
	if(L.is_dead())
		L.dust()

/obj/machinery/incinerator/proc/incinerate_start()
	if(incinerating)
		return
	update_use_power(POWER_USE_ACTIVE)
	incinerating = TRUE
	playsound(src.loc, 'sound/machines/flameon.ogg', 50, 0, 8, 3)
	update_icon()
	burnend = world.time + INCINERATOR_BURN_TIME //Maximum time we'll try to incinerate the content
	//burn_chamber_air.add_thermal_energy(8000)
	for (var/mob/M in viewers(src))
		M.show_message(SPAN_WARNING("You hear a roar as the [src] activates."), 1)

/obj/machinery/incinerator/proc/incinerate_end()
	update_use_power(POWER_USE_IDLE)
	burnend = 0
	incinerating = FALSE
	playsound(src.loc, 'sound/machines/flamehiss.ogg', 50, 0, 8, 3)
	//burn_chamber_air.add_thermal_energy(-8000)
	update_icon()

/obj/machinery/incinerator/proc/moles_for_pressure(var/pressure)
	return (pressure * burn_chamber_air.volume) / (R_IDEAL_GAS_EQUATION * burn_chamber_air.temperature)

/obj/machinery/incinerator/return_air()
	return burn_chamber_air

//Allow live mobs to escape
/obj/machinery/incinerator/relaymove(mob/user as mob)
	if (user.incapacitated() || locked)
		return
	user.dropInto(src.loc)

/obj/machinery/incinerator/Bumped(var/atom/movable/AM)
	if(QDELETED(AM) || inoperable() || incinerating)
		return
	var/move_dir = get_dir(loc, AM.loc)
	if(move_dir == input_dir)
		if(can_burn(AM))
			AM.loc = src
			playsound(src.loc, 'sound/effects/extin.ogg', 10, 1, 4, 1)
		else // Can't recycle
			playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
			AM.loc = src.loc

/obj/machinery/incinerator/attackby(P as obj, mob/user as mob)
	if(default_deconstruction_crowbar(P))
		return
	else if(default_deconstruction_screwdriver(P))
		return
	else if(default_part_replacement(P))
		return
	return ..()

/obj/machinery/incinerator/update_icon()
	if (src.incinerating)
		src.icon_state = icon_state_incinerating
	else if (src.contents.len)
		src.icon_state = icon_state_filled
	else
		src.icon_state = icon_state_empty

/obj/machinery/incinerator/OnTopic(mob/user, href_list, datum/topic_state/state)
	. = ..()
	if(href_list["activate"] || href_list["incinerate"])
		incinerate_start()
		return


//--------------------------------
//	People incinerator
//--------------------------------
/obj/machinery/incinerator/crematorium
	name = "crematorium"
	desc = "A human incinerator. Works well on barbeque nights."
	icon = 'icons/obj/machines/cremator.dmi'
	icon_state = "crema1"
	autoincinerate = FALSE
	var/obj/structure/c_tray/connected = null

/obj/machinery/incinerator/crematorium/Destroy()
	if(connected)
		QDEL_NULL(connected)
	return ..()

/obj/machinery/incinerator/crematorium/update_icon()
	if(is_tray_opened())
		src.icon_state = "crema0"
	else
		..()

/obj/machinery/incinerator/crematorium/proc/toggle_tray()
	if(is_tray_opened())
		close_tray()
	else
		open_tray()

/obj/machinery/incinerator/crematorium/proc/open_tray()
	if(src.connected)
		return
	playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
	src.connected = new /obj/structure/c_tray( src.loc )
	step(src.connected, SOUTH)
	src.connected.layer = OBJ_LAYER
	var/turf/T = get_step(src, SOUTH)
	//Move the crap in the incinerator to the tray
	if (T.contents.Find(src.connected))
		src.connected.connected = src
		for(var/atom/movable/A as mob|obj in InsertedContents())
			A.forceMove(src.connected.loc)
		src.connected.icon_state = "cremat"
	else
		QDEL_NULL(src.connected)
	update_icon()

/obj/machinery/incinerator/crematorium/proc/close_tray()
	if(!src.connected)
		return
	if(src.connected && src.connected.loc)
		//Move the crap on the tray inside the incinerator
		for(var/atom/movable/A as mob|obj in src.connected.loc)
			if (!( A.anchored ))
				A.forceMove(src)
	playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
	QDEL_NULL(connected)
	update_icon()

/obj/machinery/incinerator/crematorium/proc/is_tray_opened()
	return src.connected? TRUE : FALSE

/obj/machinery/incinerator/crematorium/incinerate_start()
	if(is_tray_opened())
		to_chat(usr, SPAN_WARNING("Close \the [src]'s tray first!"))
		return
	..()

/obj/machinery/incinerator/crematorium/attack_hand(mob/user as mob)
	if(incinerating)
		to_chat(usr, SPAN_WARNING("It's incinerating! The hatch is locked!"))
		return
	if(!locked)
		toggle_tray()
	else
		to_chat(usr, SPAN_WARNING("The hatch is locked."))
	src.add_fingerprint(user)

/obj/machinery/incinerator/crematorium/attackby(var/obj/item/P, mob/living/user)
	if(incinerating && isCrowbar(P))
		user.visible_message(SPAN_WARNING("You begin forcing \the [src]'s hatch open!"),SPAN_WARNING("[user] begins forcing \the [src]'s hatch open!"))
		if(do_after(user, 10 SECONDS, src))
			user.visible_message(SPAN_WARNING("You force \the [src]'s hatch open! A scorching blaze rushes at you!"),SPAN_WARNING("[user] forced \the [src]'s hatch open!"))
			user.IgniteMob()
			open_tray()
			incinerate_end()

	if (istype(P, /obj/item/weapon/pen))
		var/t = input(user, "What would you like the label to be?", text("[]", src.name), null)  as text
		if(user.get_active_hand() != P)
			return
		if((!in_range(src, usr) > 1 && src.loc != user))
			return
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if(t)
			src.name = text("Crematorium- '[]'", t)
		src.add_fingerprint(user)
		return
	return ..()

/obj/machinery/incinerator/crematorium/relaymove(mob/user as mob)
	if(..())
		open_tray()

/obj/machinery/incinerator/crematorium/Bumped(var/atom/movable/AM)
	return

/obj/machinery/incinerator/crematorium/incinerate_end()
	..()
	playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)

/obj/machinery/incinerator/crematorium/receive_signal(var/datum/signal/signal)
	if(!signal || signal.encryption)
		return
	var/datum/extension/interactive/radio_transmitter/RT = get_transmitter()
	if(!RT || !RT.match_id(signal))
		return
	if(signal.data["activate"])
		incinerate_start()

/obj/machinery/incinerator/crematorium/Process()
	. = ..()
	if(is_tray_opened())
		burn_chamber_air.equalize(loc.return_air())

/obj/machinery/incinerator/crematorium/relaymove(mob/user as mob)
	if (user.incapacitated() || locked)
		return
	user.visible_message(SPAN_WARNING("You begin beating \the [src]'s hatch open!"),SPAN_WARNING("[user] begins beating \the [src]'s hatch open from inside!"))
	if(do_after(user, 5 SECONDS, src))
		user.visible_message(SPAN_WARNING("You force \the [src]'s hatch open!"),SPAN_WARNING("[user] forced \the [src]'s hatch open!"))
		open_tray()
		incinerate_end()

/*
 * Crematorium tray
 */
/obj/structure/c_tray
	name = "crematorium tray"
	desc = "Apply body before burning."
	icon = 'icons/obj/machines/cremator.dmi'
	icon_state = "cremat"
	density = 1
	layer = BELOW_OBJ_LAYER
	var/obj/machinery/incinerator/crematorium/connected = null
	anchored = 1
	throwpass = 1

/obj/structure/c_tray/Destroy()
	if(connected && connected.connected == src)
		connected.connected = null
	connected = null
	return ..()

/obj/structure/c_tray/attack_hand(mob/user as mob)
	if (src.connected)
		for(var/atom/movable/A as mob|obj in src.loc)
			if (!( A.anchored ))
				A.forceMove(src.connected)
		src.connected.connected = null
		src.connected.update_icon()
		add_fingerprint(user)
		qdel(src)
		return
	return

/obj/structure/c_tray/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/grab/normal))
		var/obj/item/grab/normal/G = O
		if(ismob(G.affecting))
			var/mob/M = G.affecting
			M.forceMove(src.loc)
			user.visible_message(SPAN_DANGER("[user] stuffs [M] into \the [src]."))
			qdel(G)
		return
	return ..()

/obj/structure/c_tray/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
	if ((!( istype(O, /atom/movable) ) || O.anchored || get_dist(user, src) > 1 || get_dist(user, O) > 1 || user.contents.Find(src) || user.contents.Find(O)))
		return
	if (!ismob(O) && !istype(O, /obj/structure/closet/body_bag))
		return
	if (!ismob(user) || user.stat || user.lying || user.stunned)
		return
	O.forceMove(src.loc)
	if (user != O)
		for(var/mob/B in viewers(user, 3))
			if ((B.client && !( B.blinded )))
				to_chat(B, text("<span class='warning'>[] stuffs [] into []!</span>", user, O, src))

#undef INCINERATOR_BURN_TIME
#undef INCINERATOR_CHECK_INTERVAL