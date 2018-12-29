/obj/machinery/portable_atmospherics/canister
	name = "\improper Canister: \[CAUTION\]"
	icon = 'icons/obj/atmos.dmi'
	icon_state = "yellow"
	density = 1
	var/health = 100.0
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_GARGANTUAN

	var/valve_open = 0
	var/release_pressure = ONE_ATMOSPHERE
	var/release_flow_rate = ATMOS_DEFAULT_VOLUME_PUMP //in L/s

	var/canister_color = "yellow"
	var/can_label = 1
	start_pressure = 148 * ONE_ATMOSPHERE
	var/temperature_resistance = 1000 + T0C
	volume = 1000
	use_power = 0
	interact_offline = 1 // Allows this to be used when not in powered area.
	var/release_log = ""
	var/update_flag = 0
	var/heat_capacity = 31250
	var/heat = 9160937.5//T20C * heat_capacity
	temperature = T20C
	var/upgraded = 1
	var/upgrade_stack_type = /obj/item/stack/material/plasteel
	var/upgrade_stack_amount = 20

/obj/machinery/portable_atmospherics/canister/after_load()
	..()
	update_icon()

/obj/machinery/portable_atmospherics/canister/drain_power()
	return -1

/obj/machinery/portable_atmospherics/canister/proc/check_change()
	if(!air_contents)
		return 1

	var/old_flag = update_flag
	update_flag = 0
	if(holding)
		update_flag |= 1
	if(connected_port)
		update_flag |= 2

	var/tank_pressure = air_contents.return_pressure()
	if(tank_pressure < 10)
		update_flag |= 4
	else if(tank_pressure < ONE_ATMOSPHERE)
		update_flag |= 8
	else if(tank_pressure < (start_pressure/2))
		update_flag |= 16
	else
		update_flag |= 32

	if(update_flag == old_flag)
		return 1
	else
		return 0

/obj/machinery/portable_atmospherics/canister/update_icon()
/*
update_flag
1 = holding
2 = connected_port
4 = tank_pressure < 10
8 = tank_pressure < ONE_ATMOS
16 = tank_pressure < 15*ONE_ATMOS
32 = tank_pressure go boom.
*/

	if (src.destroyed)
		src.overlays = 0
		src.icon_state = text("[]-1", src.canister_color)
		return

	if(icon_state != "[canister_color]")
		icon_state = "[canister_color]"

	if(check_change()) //Returns 1 if no change needed to icons.
		return

	src.overlays = 0

	if(update_flag & 1)
		overlays += "can-open"
	if(update_flag & 2)
		overlays += "can-connector"
	if(update_flag & 4)
		overlays += "can-o0"
	if(update_flag & 8)
		overlays += "can-o1"
	else if(update_flag & 16)
		overlays += "can-o2"
	else if(update_flag & 32)
		overlays += "can-o3"
	return

/obj/machinery/portable_atmospherics/canister/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > temperature_resistance)
		health -= 5
		healthcheck()

/obj/machinery/portable_atmospherics/canister/proc/healthcheck()
	if(destroyed)
		return 1

	if (src.health <= 10)
		disconnect()
		var/atom/location = src.loc
		location.assume_air(air_contents)

		src.destroyed = 1
		playsound(src.loc, 'sound/effects/spray.ogg', 10, 1, -3)
		src.set_density(0)
		update_icon()

		if (src.holding)
			src.holding.dropInto(loc)
			src.holding = null

		return 1
	else
		return 1

/obj/machinery/portable_atmospherics/canister/Process()
	if (destroyed)
		return
	..()
	if(loc)
		handle_heat_exchange()
	if(valve_open)
		var/datum/gas_mixture/environment
		if(holding && holding.air_contents)
			environment = holding.air_contents
		else
			environment = loc.return_air()

		var/env_pressure = environment.return_pressure()
		var/pressure_delta = release_pressure - env_pressure

		if((air_contents.temperature > 0) && (pressure_delta > 0))
			var/transfer_moles = calculate_transfer_moles(air_contents, environment, pressure_delta)
			transfer_moles = min(transfer_moles, (release_flow_rate/air_contents.volume)*air_contents.total_moles) //flow rate limit

			var/returnval = pump_gas_passive(src, air_contents, environment, transfer_moles)
			if(returnval >= 0)
				src.update_icon()

	if(!air_contents || air_contents.return_pressure() < 1)
		can_label = 1
	else
		can_label = 0

	air_contents.react() //cooking up air cans - add phoron and oxygen, then heat above PHORON_MINIMUM_BURN_TEMPERATURE

/obj/machinery/portable_atmospherics/canister/proc/handle_heat_exchange()
	if(istype(src.loc, /turf/space))
		heat -= COSMIC_RADIATION_TEMPERATURE * CANISTER_HEAT_TRANSFER_COEFFICIENT
		return
	exchange_heat(loc.return_air())
	if(!upgraded)
		exchange_heat(air_contents)
	if(temperature > temperature_resistance)
		health -= 1
		healthcheck()


/obj/machinery/portable_atmospherics/canister/proc/exchange_heat(var/datum/gas_mixture/environment)
	var/relative_density = (environment.total_moles/environment.volume) / (MOLES_CELLSTANDARD/CELL_VOLUME)
	if(relative_density > 0.02) //don't bother if we are in vacuum or near-vacuum
		var/loc_temp = environment.temperature
		if(loc_temp == temperature)
			return
		var/loc_heat = environment.heat_capacity()
		var/transferred_heat = QUANTIZE(((loc_heat / loc_temp) * (loc_temp - temperature)) * CANISTER_HEAT_TRANSFER_COEFFICIENT)
		//This if else keeps the can from heating/cooling more than 1K per tick.
		if(transferred_heat > 0)
			transferred_heat = min(transferred_heat, heat_capacity)
		else
			transferred_heat = max(transferred_heat, -heat_capacity)
		environment.add_thermal_energy(-transferred_heat)
		heat += transferred_heat

		temperature = QUANTIZE(heat / heat_capacity)

/obj/machinery/portable_atmospherics/canister/proc/return_temperature()
	var/datum/gas_mixture/GM = src.return_air()
	if(GM && GM.volume>0)
		return GM.temperature
	return 0

/obj/machinery/portable_atmospherics/canister/proc/return_pressure()
	var/datum/gas_mixture/GM = src.return_air()
	if(GM && GM.volume>0)
		return GM.return_pressure()
	return 0

/obj/machinery/portable_atmospherics/canister/bullet_act(var/obj/item/projectile/Proj)
	if(!(Proj.damage_type == BRUTE || Proj.damage_type == BURN))
		return

	if(Proj.damage)
		src.health -= round(Proj.damage / 2)
		healthcheck()
	..()

/obj/machinery/portable_atmospherics/canister/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if(!isWrench(W) && !istype(W, /obj/item/weapon/tank) && !istype(W, /obj/item/device/analyzer) && !istype(W, /obj/item/device/pda))
		visible_message("<span class='warning'>\The [user] hits \the [src] with \a [W]!</span>")
		src.health -= W.force
		src.add_fingerprint(user)
		healthcheck()

	if(istype(user, /mob/living/silicon/robot) && istype(W, /obj/item/weapon/tank/jetpack))
		var/datum/gas_mixture/thejetpack = W:air_contents
		var/env_pressure = thejetpack.return_pressure()
		var/pressure_delta = min(10*ONE_ATMOSPHERE - env_pressure, (air_contents.return_pressure() - env_pressure)/2)
		//Can not have a pressure delta that would cause environment pressure > tank pressure
		var/transfer_moles = 0
		if((air_contents.temperature > 0) && (pressure_delta > 0))
			transfer_moles = pressure_delta*thejetpack.volume/(air_contents.temperature * R_IDEAL_GAS_EQUATION)//Actually transfer the gas
			var/datum/gas_mixture/removed = air_contents.remove(transfer_moles)
			thejetpack.merge(removed)
			to_chat(user, "You pulse-pressurize your jetpack from the tank.")
		return
	var/obj/item/stack/P = W
	if(istype(P, upgrade_stack_type))
		if(!upgraded)
			if(P.amount < upgrade_stack_amount)
				user.visible_message("You need at least [upgrade_stack_amount] sheets of [P] to upgrade \the [src]")
			else
				user.visible_message("You start insulating \the [src]...")
				if(do_after(50, user, src) && P.amount >= upgrade_stack_amount)
					P.use(upgrade_stack_amount)
					user.visible_message("You finish insulating \the [src].")
					upgraded = 1
		else
			user.visible_message("\The [src] has already been insulated.")
	..()

/obj/machinery/portable_atmospherics/canister/attackby(obj/item/W as obj, mob/user as mob)
	if(isWelder(W) && src.destroyed)
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.remove_fuel(0,user))
			var/obj/item/stack/material/steel/new_item = new(usr.loc)
			new_item.add_to_stacks(usr)
			//!initial allows me to implement this payback on destroy without giving everyone free plasteel.
			if(upgraded && !initial(upgraded))
				var/obj/item/stack/P = new upgrade_stack_type(usr.loc)
				P.add(upgrade_stack_amount)
				P.add_to_stacks(usr)
			for (var/mob/M in viewers(src))
				M.show_message("<span class='notice'>[src] is shaped into metal by [user.name] with the weldingtool.</span>", 3, "<span class='notice'>You hear welding.</span>", 2)
			qdel(src)
		return
	..()

	SSnano.update_uis(src) // Update all NanoUIs attached to src

/obj/machinery/portable_atmospherics/canister/attack_ai(var/mob/user as mob)
	ui_interact(user)

/obj/machinery/portable_atmospherics/canister/attack_hand(var/mob/user as mob)
	ui_interact(user)

/obj/machinery/portable_atmospherics/canister/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	// this is the data which will be sent to the ui
	var/data[0]
	data["name"] = name
	data["canLabel"] = can_label ? 1 : 0
	data["portConnected"] = connected_port ? 1 : 0
	data["tankPressure"] = round(air_contents.return_pressure() ? air_contents.return_pressure() : 0)
	data["releasePressure"] = round(release_pressure ? release_pressure : 0)
	data["minReleasePressure"] = round(ONE_ATMOSPHERE/10)
	data["maxReleasePressure"] = round(10*ONE_ATMOSPHERE)
	data["valveOpen"] = valve_open ? 1 : 0

	data["hasHoldingTank"] = holding ? 1 : 0
	if (holding)
		data["holdingTank"] = list("name" = holding.name, "tankPressure" = round(holding.air_contents.return_pressure()))

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "canister.tmpl", "Canister", 480, 400)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/portable_atmospherics/canister/OnTopic(var/mob/user, href_list, state)
	if(href_list["toggle"])
		if (valve_open)
			if (holding)
				release_log += "Valve was <b>closed</b> by [user] ([user.ckey]), stopping the transfer into the [holding]<br>"
			else
				release_log += "Valve was <b>closed</b> by [user] ([user.ckey]), stopping the transfer into the <font color='red'><b>air</b></font><br>"
		else
			if (holding)
				release_log += "Valve was <b>opened</b> by [user] ([user.ckey]), starting the transfer into the [holding]<br>"
			else
				release_log += "Valve was <b>opened</b> by [user] ([user.ckey]), starting the transfer into the <font color='red'><b>air</b></font><br>"
				log_open()
		valve_open = !valve_open
		. = TOPIC_REFRESH

	else if (href_list["remove_tank"])
		if(!holding)
			return TOPIC_HANDLED
		if (valve_open)
			valve_open = 0
			release_log += "Valve was <b>closed</b> by [user] ([user.ckey]), stopping the transfer into the [holding]<br>"
		if(istype(holding, /obj/item/weapon/tank))
			holding.manipulated_by = user.real_name
		holding.dropInto(loc)
		holding = null
		update_icon()
		. = TOPIC_REFRESH

	else if (href_list["pressure_adj"])
		var/diff = text2num(href_list["pressure_adj"])
		if(diff > 0)
			release_pressure = min(10*ONE_ATMOSPHERE, release_pressure+diff)
		else
			release_pressure = max(ONE_ATMOSPHERE/10, release_pressure+diff)
		. = TOPIC_REFRESH

	else if (href_list["relabel"])
		if (!can_label)
			return 0
		var/list/colors = list(\
			"\[N2O\]" = "redws", \
			"\[N2\]" = "red", \
			"\[O2\]" = "blue", \
			"\[Hydrogen\]" = "purple", \
			"\[Phoron\]" = "orange", \
			"\[CO2\]" = "black", \
			"\[Air\]" = "grey", \
			"\[CAUTION\]" = "yellow", \
			"\[Reagents\]" = "cyanws", \
		)
		var/label = input(user, "Choose canister label", "Gas canister") as null|anything in colors
		if (label && CanUseTopic(user, state))
			canister_color = colors[label]
			icon_state = colors[label]
			name = "\improper Canister: [label]"
		update_icon()
		. = TOPIC_REFRESH

/obj/machinery/portable_atmospherics/canister/CanUseTopic()
	if(destroyed)
		return STATUS_CLOSE
	return ..()

//--------------------------------------------------------
// N2O Canister
//--------------------------------------------------------
/obj/machinery/portable_atmospherics/canister/sleeping_agent
	name = "\improper Canister: \[N2O\]"
	icon_state = "redws"
	canister_color = "redws"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/sleeping_agent/init_air_content()
	..()
	air_contents.adjust_gas("sleeping_agent", MolesForPressure())
	src.update_icon()

//--------------------------------------------------------
// N2 Canister
//--------------------------------------------------------
/obj/machinery/portable_atmospherics/canister/nitrogen
	name = "\improper Canister: \[N2\]"
	icon_state = "red"
	canister_color = "red"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/nitrogen/init_air_content()
	..()
	src.air_contents.adjust_gas("nitrogen", MolesForPressure())
	src.update_icon()

//--------------------------------------------------------
// N2O Pre-Chilled Canister
//--------------------------------------------------------
/obj/machinery/portable_atmospherics/canister/nitrogen/prechilled
	name = "\improper Canister: \[N2 (Cooling)\]"

/obj/machinery/portable_atmospherics/canister/nitrogen/prechilled/init_air_content()
	..()
	src.air_contents.temperature = 80
	src.update_icon()

//--------------------------------------------------------
// O2 Canister
//--------------------------------------------------------
/obj/machinery/portable_atmospherics/canister/oxygen
	name = "\improper Canister: \[O2\]"
	icon_state = "blue"
	canister_color = "blue"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/oxygen/init_air_content()
	..()
	src.air_contents.adjust_gas("oxygen", MolesForPressure())
	src.update_icon()

//--------------------------------------------------------
// O2 Pre-Chilled Canister
//--------------------------------------------------------
/obj/machinery/portable_atmospherics/canister/oxygen/prechilled
	name = "\improper Canister: \[O2 (Cryo)\]"
	start_pressure = 20 * ONE_ATMOSPHERE

/obj/machinery/portable_atmospherics/canister/oxygen/prechilled/init_air_content()
	..()
	src.air_contents.temperature = 80
	src.update_icon()

//--------------------------------------------------------
// H2 Canister
//--------------------------------------------------------
/obj/machinery/portable_atmospherics/canister/hydrogen
	name = "\improper Canister: \[Hydrogen\]"
	icon_state = "purple"
	canister_color = "purple"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/hydrogen/init_air_content()
	..()
	src.air_contents.adjust_gas("hydrogen", MolesForPressure())
	src.update_icon()

//--------------------------------------------------------
// Phoron Canister
//--------------------------------------------------------
/obj/machinery/portable_atmospherics/canister/phoron
	name = "\improper Canister \[Phoron\]"
	icon_state = "orange"
	canister_color = "orange"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/phoron/init_air_content()
	..()
	src.air_contents.adjust_gas("phoron", MolesForPressure())
	src.update_icon()

//--------------------------------------------------------
// CO2 Canister
//--------------------------------------------------------
/obj/machinery/portable_atmospherics/canister/carbon_dioxide
	name = "\improper Canister \[CO2\]"
	icon_state = "black"
	canister_color = "black"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/carbon_dioxide/init_air_content()
	..()
	src.air_contents.adjust_gas("carbon_dioxide", MolesForPressure())
	src.update_icon()

//--------------------------------------------------------
// Air Canister
//--------------------------------------------------------
/obj/machinery/portable_atmospherics/canister/air
	name = "\improper Canister \[Air\]"
	icon_state = "grey"
	canister_color = "grey"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/air/init_air_content()
	..()
	var/list/air_mix = StandardAirMix()
	src.air_contents.adjust_multi("oxygen", air_mix["oxygen"], "nitrogen", air_mix["nitrogen"])
	src.update_icon()

//--------------------------------------------------------
// Airlock Air Canister
//--------------------------------------------------------
/obj/machinery/portable_atmospherics/canister/air/airlock
	start_pressure = 3 * ONE_ATMOSPHERE


//--------------------------------------------------------
// N2O Roomfiller Canister
//--------------------------------------------------------
//Dirty way to fill room with gas. However it is a bit easier to do than creating some floor/engine/n2o -rastaf0
/obj/machinery/portable_atmospherics/canister/sleeping_agent/roomfiller/init_air_content()
	..()
	air_contents.gas["sleeping_agent"] = 9*4000
	spawn(10)
		var/turf/simulated/location = src.loc
		if (istype(src.loc))
			while (!location.air)
				sleep(10)
			location.assume_air(air_contents)
			air_contents = new

//--------------------------------------------------------
// N2 Engine Setup Canister
//--------------------------------------------------------
// Special types used for engine setup admin verb, they contain double amount of that of normal canister.
/obj/machinery/portable_atmospherics/canister/nitrogen/engine_setup/init_air_content()
	..()
	src.air_contents.adjust_gas("nitrogen", MolesForPressure())
	src.update_icon()

//--------------------------------------------------------
// CO2 Engine Setup Canister
//--------------------------------------------------------
/obj/machinery/portable_atmospherics/canister/carbon_dioxide/engine_setup/init_air_content()
	..()
	src.air_contents.adjust_gas("carbon_dioxide", MolesForPressure())
	src.update_icon()

//--------------------------------------------------------
// Phoron Engine Setup Canister
//--------------------------------------------------------
/obj/machinery/portable_atmospherics/canister/phoron/engine_setup/init_air_content()
	..()
	src.air_contents.adjust_gas("phoron", MolesForPressure())
	src.update_icon()

//--------------------------------------------------------
// Empty Canister
//--------------------------------------------------------
/obj/machinery/portable_atmospherics/canister/empty
	start_pressure = 0
	can_label = 1
	var/obj/machinery/portable_atmospherics/canister/canister_type = /obj/machinery/portable_atmospherics/canister

/obj/machinery/portable_atmospherics/canister/empty/New()
	..()
	name = 	initial(canister_type.name)
	icon_state = 	initial(canister_type.icon_state)
	canister_color = 	initial(canister_type.canister_color)

/obj/machinery/portable_atmospherics/canister/empty/Initialize()
	. = ..()
	if(!map_storage_loaded)
		name = 	initial(canister_type.name)
		icon_state = initial(canister_type.icon_state)
		canister_color = initial(canister_type.canister_color)

/obj/machinery/portable_atmospherics/canister/empty/air
	icon_state = "grey"
	canister_type = /obj/machinery/portable_atmospherics/canister/air
/obj/machinery/portable_atmospherics/canister/empty/oxygen
	icon_state = "blue"
	canister_type = /obj/machinery/portable_atmospherics/canister/oxygen
/obj/machinery/portable_atmospherics/canister/empty/phoron
	icon_state = "orange"
	canister_type = /obj/machinery/portable_atmospherics/canister/phoron
/obj/machinery/portable_atmospherics/canister/empty/nitrogen
	icon_state = "red"
	canister_type = /obj/machinery/portable_atmospherics/canister/nitrogen
/obj/machinery/portable_atmospherics/canister/empty/carbon_dioxide
	icon_state = "black"
	canister_type = /obj/machinery/portable_atmospherics/canister/carbon_dioxide
/obj/machinery/portable_atmospherics/canister/empty/sleeping_agent
	icon_state = "redws"
	canister_type = /obj/machinery/portable_atmospherics/canister/sleeping_agent
/obj/machinery/portable_atmospherics/canister/empty/hydrogen
	icon_state = "purple"
	canister_type = /obj/machinery/portable_atmospherics/canister/hydrogen
