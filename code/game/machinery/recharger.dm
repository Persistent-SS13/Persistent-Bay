#define allowed_devices list(/obj/item/weapon/gun/energy, /obj/item/weapon/gun/magnetic/railgun, /obj/item/weapon/melee/baton, /obj/item/weapon/cell, /obj/item/modular_computer/, /obj/item/device/suit_sensor_jammer, /obj/item/weapon/computer_hardware/battery_module, /obj/item/weapon/shield_diffuser)
#define disallowed_devices list(/obj/item/weapon/gun/energy/plasmacutter, /obj/item/weapon/gun/energy/staff, /obj/item/weapon/gun/energy/gun/nuclear, /obj/item/weapon/gun/energy/crossbow)

/obj/machinery/recharger
	name = "recharger"
	desc = "An all-purpose recharger for a variety of devices."
	icon = 'icons/obj/machines/rechargers.dmi'
	icon_state = "recharger0"
	anchored = TRUE
	idle_power_usage = 4
	active_power_usage = 30 KILOWATTS
	circuit_type = /obj/item/weapon/circuitboard/machinery/recharger
	var/obj/item/charging = null
	var/icon_state_charged = "recharger2"
	var/icon_state_charging = "recharger1"
	var/icon_state_idle = "recharger0" //also when unpowered
	var/portable = 1
	var/tmp/time_next_update = 0 //Since we reaaaaally don't need to update our state every single ticks, use this

/obj/machinery/recharger/New()
	..()
	ADD_SAVED_VAR(charging)
	ADD_SKIP_EMPTY(charging)

/obj/machinery/recharger/Initialize()
	. = ..()
	queue_icon_update()

/obj/machinery/recharger/Destroy()
	if(charging)
		charging.forceMove(get_turf(src))
	charging = null
	return ..()

obj/machinery/recharger/attackby(obj/item/weapon/G as obj, mob/user as mob)
	if(default_deconstruction_screwdriver(user, G))
		updateUsrDialog()
		return 1
	if(default_deconstruction_crowbar(user, G))
		return 1
	if(default_part_replacement(user, G))
		return 1
	if(portable && default_wrench_floor_bolts(user, G, 1 SECOND))
		return 1

	for(var/disallowed_type in disallowed_devices)
		if(istype(G, disallowed_type)) return // Could potentially just use if(G.type in disallowed_devices), but we want to check for subtypes

	for (var/allowed_type in allowed_devices)
		if(istype(G, allowed_type))
			if(charging)
				to_chat(user, SPAN_WARNING("\A [charging] is already charging here."))
				return
			// Checks to make sure he's not in space doing it, and that the area got proper power.
			if(!powered())
				to_chat(user, SPAN_WARNING("The [name] blinks red as you try to insert the item!"))
				return
			if(istype(G, /obj/item/modular_computer))
				var/obj/item/modular_computer/C = G
				if(!C.battery_module)
					to_chat(user, "This device does not have a battery installed.")
					return
			if(istype(G, /obj/item/device/suit_sensor_jammer))
				var/obj/item/device/suit_sensor_jammer/J = G
				if(!J.bcell)
					to_chat(user, "This device does not have a battery installed.")
					return
			if(istype(G, /obj/item/weapon/gun/magnetic/railgun))
				var/obj/item/weapon/gun/magnetic/railgun/RG = G
				if(!RG.cell)
					to_chat(user, "This device does not have a battery installed.")
					return

			if(user.unEquip(G))
				G.forceMove(src)
				charging = G
				update_icon()
				return

/obj/machinery/recharger/attack_hand(mob/user as mob)
	if(istype(user,/mob/living/silicon))
		return

	add_fingerprint(user)

	if(charging)
		charging.update_icon()
		user.put_in_hands(charging)
		charging = null
		update_icon()

/obj/machinery/recharger/power_change()
	. = ..()
	if(powered())
		update_use_power(POWER_USE_IDLE)
	else
		update_use_power(POWER_USE_OFF)
	queue_icon_update()

/obj/machinery/recharger/set_anchored(new_anchored)
	. = ..()
	if(anchored && operable())
		update_use_power(POWER_USE_IDLE)
	else
		update_use_power(POWER_USE_OFF)

/obj/machinery/recharger/Process()
	if(inoperable() || !anchored)
		return
	//Since a lot of these are on the map, and don't change that often, we really don't care about updating each ticks..
	if(charging && time_next_update <= world.time)
		var/obj/item/weapon/cell/C = get_charging_cell()
		if(istype(C))
			if(!C.fully_charged())
				C.give(active_power_usage*CELLRATE)
				update_use_power(POWER_USE_ACTIVE)
				queue_icon_update()
			else if(!isidle()) //Don't spam updates if its already idle...
				update_use_power(POWER_USE_IDLE)
				queue_icon_update()
		time_next_update = world.time + 2 SECONDS

/obj/machinery/recharger/emp_act(severity)
	if(inoperable() || !anchored)
		..(severity)
		return
	var/obj/item/weapon/cell/C = get_charging_cell()
	if(istype(C))
		C.emp_act(severity)
		C.charge = 0
	..(severity)

//Utiliy proc until we got a unified power supply datum or something
/obj/machinery/recharger/proc/get_charging_cell()
	if(!charging)
		return
	. = charging.get_cell()
	// if(istype(charging, /obj/item/device/suit_sensor_jammer))
	// 	var/obj/item/device/suit_sensor_jammer/J = charging
	// 	. = J.bcell
	// else if(istype(charging, /obj/item/weapon/melee/baton))
	// 	var/obj/item/weapon/melee/baton/B = charging
	// 	. = B.bcell
	// else if(istype(charging, /obj/item/modular_computer))
	// 	var/obj/item/modular_computer/C = charging
	// 	. = C.battery_module.battery
	// else if(istype(charging, /obj/item/weapon/gun/energy))
	// 	var/obj/item/weapon/gun/energy/E = charging
	// 	. = E.power_supply
	// else if(istype(charging, /obj/item/weapon/computer_hardware/battery_module))
	// 	var/obj/item/weapon/computer_hardware/battery_module/BM = charging
	// 	. = BM.battery
	// else if(istype(charging, /obj/item/weapon/shield_diffuser))
	// 	var/obj/item/weapon/shield_diffuser/SD = charging
	// 	. = SD.cell
	// else if(istype(charging, /obj/item/weapon/gun/magnetic/railgun))
	// 	var/obj/item/weapon/gun/magnetic/railgun/RG = charging
	// 	. = RG.cell

/obj/machinery/recharger/on_update_icon()	//we have an update_icon() in addition to the stuff in process to make it feel a tiny bit snappier.
	if(charging)
		var/obj/item/weapon/cell/C = get_charging_cell()
		if(C && C.fully_charged())
			icon_state = icon_state_charged
		else
			icon_state = icon_state_charging
	else
		icon_state = icon_state_idle

obj/machinery/recharger/examine(mob/user)
	. = ..()
	if(!. || isnull(charging))
		return

	else
		var/obj/item/weapon/cell/C = charging.get_cell()
		if(!isnull(C))
			to_chat(user, "Item's charge at [round(C.percent())]%.")

/obj/machinery/recharger/wallcharger
	name = "wall recharger"
	desc = "A heavy duty wall recharger specialized for energy weaponry."
	icon_state = "wrecharger0"
	active_power_usage = 50 KILOWATTS	//It's more specialized than the standalone recharger (guns and batons only) so make it more powerful
	icon_state_charged = "wrecharger2"
	icon_state_charging = "wrecharger1"
	icon_state_idle = "wrecharger0"
	portable = 0
	circuit_type = /obj/item/weapon/circuitboard/machinery/rechargerwall

/obj/machinery/recharger/wallcharger/on_update_icon()
	..()
	switch(dir)
		if(NORTH)
			src.pixel_x = 0
			src.pixel_y = -24
		if(SOUTH)
			src.pixel_x = 0
			src.pixel_y = 24
		if(EAST)
			src.pixel_x = -24
			src.pixel_y = 0
		if(WEST)
			src.pixel_x = 24
			src.pixel_y = 0

#undef allowed_devices
#undef disallowed_devices
