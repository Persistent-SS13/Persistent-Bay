/obj/machinery/portable_atmospherics/sublimator
	name = "sublimator"
	desc = "A complex machine that takes in minerals and converts them to their gaseous state"
	icon = 'icons/obj/atmos.dmi'
	icon_state = "sublimator:0"
	density = 1
	w_class = ITEM_SIZE_GARGANTUAN

	var/valve_open = 0
	var/release_pressure = ONE_ATMOSPHERE
	var/release_flow_rate = ATMOS_DEFAULT_VOLUME_PUMP

	volume = 500 //shouldn't just be a better canister

	anchored = 0
	use_power = 0
	interact_offline = 1
	var/release_log = ""
	var/update_flag = 0

/obj/machinery/portable_atmospherics/sublimator/proc/check_change()
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
	else if(tank_pressure < 15*ONE_ATMOSPHERE)
		update_flag |= 16
	else
		update_flag |= 32

	if(update_flag == old_flag)
		return 1
	else
		return 0

/obj/machinery/portable_atmospherics/sublimator/update_icon()
/*
update_flag
1 = holding
2 = connected_port
4 = tank_pressure < 10
8 = tank_pressure < ONE_ATMOS
16 = tank_pressure < 15*ONE_ATMOS
32 = tank_pressure go boom.
*/

	if(check_change()) //Returns 1 if no change needed to icons.
		return

	src.overlays = 0
	if(update_flag & 1)
		overlays += "siphon-open"
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

/obj/machinery/portable_atmospherics/sublimator/Process()

	..()

	if(valve_open)
		var/datum/gas_mixture/environment
		if(holding)
			environment = holding.air_contents
		else
			environment = loc.return_air()

		var/env_pressure = environment.return_pressure()
		var/pressure_delta = release_pressure - env_pressure

		if((air_contents.temperature > 0) && (pressure_delta > 0))
			var/transfer_moles = calculate_transfer_moles(air_contents, environment, pressure_delta)
			transfer_moles = min(transfer_moles, (release_flow_rate/air_contents.volume)*air_contents.total_moles) //Limits based off flow rate

			var/return_val = pump_gas_passive(src, air_contents, environment, transfer_moles)
			if(return_val >= 0)
				src.update_icon()


/obj/machinery/portable_atmospherics/sublimator/attackby(var/obj/item/weapon/O as obj, var/mob/usr as mob)

	if(istype(O, /obj/item/stack/material))
		var/obj/item/stack/stack = O
		var/material/stack_material = stack.get_material()
		var/list/gaseous_products = stack_material.gaseous_products
		var/moles_per_sheet = 0 	//Total amount of moles in a single sheet of material
		var/pressure_per_sheet = 0

		var/remaining_pressure = maximum_pressure - air_contents.return_pressure()

		if(!stack_material.gaseous_products)
			to_chat(usr, "<span class='notice'>This material contains no useful gasses. </span>")
			return

		for(var/product in gaseous_products)
			moles_per_sheet += gaseous_products[product]

		pressure_per_sheet = ((moles_per_sheet*R_IDEAL_GAS_EQUATION*T0C)/volume)//we'll assume all sheets are at STP for convenience

		if(maximum_pressure - (air_contents.return_pressure() + pressure_per_sheet) <= 0) //cannot add if less than one sheet of pressure remaining
			to_chat(usr, "<span class='notice'>The [src]'s pressure is too high, pump out some of the gas.</span>")
			return

		var/amount_to_take = max(0,min (stack.amount,round(remaining_pressure/pressure_per_sheet)))

		for(var/product in gaseous_products)
			air_contents.adjust_gas(product, gaseous_products[product]*amount_to_take, 1)//Adds the proper amount of moles to the container

		to_chat(usr, "<span class='notice'>You add [amount_to_take] sheet\s to the [src.name].</span>")
		flick("sublimator:1", src) //plays material feeding animation.
		playsound(src.loc, 'sound/machines/blender.ogg', 50, 1)
		update_icon()

		stack.use(amount_to_take)
		return
	..()

/obj/machinery/portable_atmospherics/sublimator/attack_ai(var/mob/usr)
	src.add_hiddenprint(usr)
	return src.attack_hand(usr)

/obj/machinery/portable_atmospherics/sublimator/attack_ghost(var/mob/usr)
	return src.attack_hand(usr)

/obj/machinery/portable_atmospherics/sublimator/attack_hand(var/mob/usr)
	ui_interact(usr)


/obj/machinery/portable_atmospherics/sublimator/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	//Mostly canister UI
	var/data[0]
	data["name"] = name
	data["portConnected"] = connected_port ? 1 : 0
	data["tankPressure"] = round(air_contents.return_pressure() ? air_contents.return_pressure() : 0)
	data["releasePressure"] = round(release_pressure ? release_pressure : 0)
	data["minReleasePressure"] = round(ONE_ATMOSPHERE/10)
	data["maxReleasePressure"] = round(10*ONE_ATMOSPHERE)
	data["valveOpen"] = valve_open ? 1 : 0

	data["hasHoldingTank"] = holding ? 1 : 0
	if (holding)
		data["holdingTank"] = list("name" = holding.name, "tankPressure" = round(holding.air_contents.return_pressure()))

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "sublimator.tmpl", "Sublimator", 480, 400)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/portable_atmospherics/sublimator/Topic(href, href_list)

	if(..())
		return 1
	else if(href_list["toggle"])
		if (valve_open)
			if (holding)
				release_log += "Valve was <b>closed</b> by [usr] ([usr.ckey]), stopping the transfer into the [holding]<br>"
			else
				release_log += "Valve was <b>closed</b> by [usr] ([usr.ckey]), stopping the transfer into the <font color='red'><b>air</b></font><br>"
		else
			if (holding)
				release_log += "Valve was <b>opened</b> by [usr] ([usr.ckey]), starting the transfer into the [holding]<br>"
			else
				release_log += "Valve was <b>opened</b> by [usr] ([usr.ckey]), starting the transfer into the <font color='red'><b>air</b></font><br>"
				log_open()
		valve_open = !valve_open
		. = 1

	else if (href_list["remove_tank"])
		if(!holding)
			return 0
		if (valve_open)
			valve_open = 0
			release_log += "Valve was <b>closed</b> by [usr] ([usr.ckey]), stopping the transfer into the [holding]<br>"
		if(istype(holding, /obj/item/weapon/tank))
			holding.manipulated_by = usr.real_name
		holding.forceMove(get_turf(src))
		holding = null
		update_icon()
		. = 1

	else if (href_list["pressure_adj"])
		var/diff = text2num(href_list["pressure_adj"])
		if(diff > 0)
			release_pressure = min(10*ONE_ATMOSPHERE, release_pressure+diff)
		else
			release_pressure = max(ONE_ATMOSPHERE/10, release_pressure+diff)
		. = 1