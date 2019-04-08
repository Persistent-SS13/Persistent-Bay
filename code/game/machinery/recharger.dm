#define allowed_devices list(/obj/item/weapon/gun/energy, /obj/item/weapon/gun/magnetic/railgun, /obj/item/weapon/melee/baton, /obj/item/weapon/cell, /obj/item/modular_computer/, /obj/item/device/suit_sensor_jammer, /obj/item/weapon/computer_hardware/battery_module, /obj/item/weapon/shield_diffuser)
#define disallowed_devices list(/obj/item/weapon/gun/energy/plasmacutter, /obj/item/weapon/gun/energy/staff, /obj/item/weapon/gun/energy/gun/nuclear, /obj/item/weapon/gun/energy/crossbow)

/obj/machinery/recharger
	name = "recharger"
	desc = "An all-purpose recharger for a variety of devices."
	icon = 'icons/obj/machines/rechargers.dmi'
	icon_state = "recharger0"
	anchored = TRUE
	use_power = POWER_USE_IDLE
	idle_power_usage = 4
	active_power_usage = 30 KILOWATTS
	var/obj/item/charging = null
	var/icon_state_charged = "recharger2"
	var/icon_state_charging = "recharger1"
	var/icon_state_idle = "recharger0" //also when unpowered
	var/portable = 1

/obj/machinery/recharger/New()
	..()
	ADD_SAVED_VAR(charging)
	ADD_SKIP_EMPTY(charging)

/obj/machinery/recharger/Initialize()
	. = ..()
	//Create parts for Machine
	if(!map_storage_loaded)
		component_parts = list()
		component_parts += new /obj/item/weapon/circuitboard/machinery/recharger(src)
		component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
		component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
		component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
		component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	RefreshParts()
	update_icon()

/obj/machinery/recharger/Destroy()
	if(charging)
		charging.forceMove(get_turf(src))
	return ..()

obj/machinery/recharger/attackby(obj/item/weapon/G as obj, mob/user as mob)
	if(istype(user,/mob/living/silicon))
		return

	if(portable && isWrench(G))
		anchored = !anchored
		to_chat(user, "You [anchored ? "attached" : "detached"] the recharger.")
		playsound(loc, 'sound/items/Ratchet.ogg', 75, 1)
		return

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

/obj/machinery/recharger/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(default_deconstruction_screwdriver(user, O))
		updateUsrDialog()
		return 1
	if(default_deconstruction_crowbar(user, O))
		return 1
	if(default_part_replacement(user, O))
		return 1
	return ..()

/obj/machinery/recharger/attack_hand(mob/user as mob)
	if(istype(user,/mob/living/silicon))
		return

	add_fingerprint(user)

	if(charging)
		charging.update_icon()
		user.put_in_hands(charging)
		charging = null
		update_icon()

/obj/machinery/recharger/Process()
	if(inoperable() || !anchored)
		update_use_power(POWER_USE_OFF)
		update_icon()
		return

	if(!charging)
		update_use_power(POWER_USE_IDLE)
		update_icon()
	else
		var/obj/item/weapon/cell/C = get_charging_cell()
		if(istype(C))
			if(!C.fully_charged())
				C.give(active_power_usage*CELLRATE)
				update_use_power(POWER_USE_ACTIVE)
				update_icon()
			else
				update_use_power(POWER_USE_IDLE)
				update_icon()
			return

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
	. = charging
	if(istype(charging, /obj/item/device/suit_sensor_jammer))
		var/obj/item/device/suit_sensor_jammer/J = charging
		. = J.bcell
	else if(istype(charging, /obj/item/weapon/melee/baton))
		var/obj/item/weapon/melee/baton/B = charging
		. = B.bcell
	else if(istype(charging, /obj/item/modular_computer))
		var/obj/item/modular_computer/C = charging
		. = C.battery_module.battery
	else if(istype(charging, /obj/item/weapon/gun/energy))
		var/obj/item/weapon/gun/energy/E = charging
		. = E.power_supply
	else if(istype(charging, /obj/item/weapon/computer_hardware/battery_module))
		var/obj/item/weapon/computer_hardware/battery_module/BM = charging
		. = BM.battery
	else if(istype(charging, /obj/item/weapon/shield_diffuser))
		var/obj/item/weapon/shield_diffuser/SD = charging
		. = SD.cell
	else if(istype(charging, /obj/item/weapon/gun/magnetic/railgun))
		var/obj/item/weapon/gun/magnetic/railgun/RG = charging
		. = RG.cell

/obj/machinery/recharger/update_icon()	//we have an update_icon() in addition to the stuff in process to make it feel a tiny bit snappier.
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

/obj/machinery/recharger/wallcharger/update_icon()
	..()
	switch(dir)
		if(NORTH)
			src.pixel_x = 0
			src.pixel_y = -24
		if(SOUTH)
			src.pixel_x = 0
			src.pixel_y = 28
		if(EAST)
			src.pixel_x = -32
			src.pixel_y = 0
		if(WEST)
			src.pixel_x = 32
			src.pixel_y = 0

#undef allowed_devices
#undef disallowed_devices
