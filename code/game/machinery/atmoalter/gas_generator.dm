/proc/create_gas_data_for_reagent(var/datum/reagent/reagent)

	var/kill_later
	if(ispath(reagent))
		kill_later = TRUE
		reagent = new reagent

	if(!istype(reagent))
		return

	var/gas_id = lowertext(reagent.name)
	if(gas_id in gas_data.gases)
		return

	gas_data.gases +=                   gas_id
	gas_data.name[gas_id] =             reagent.name
	gas_data.specific_heat[gas_id] =    reagent.gas_specific_heat
	gas_data.molar_mass[gas_id] =       reagent.gas_molar_mass
	gas_data.overlay_limit[gas_id] =    reagent.gas_overlay_limit
	gas_data.flags[gas_id] =            reagent.gas_flags
	gas_data.burn_product[gas_id] =     reagent.gas_burn_product
	gas_data.breathed_product[gas_id] = reagent.type
																//component_reagents intentially left null

	if(reagent.gas_overlay)
		var/image/I = image('icons/effects/tile_effects.dmi', reagent.gas_overlay, FLY_LAYER)
		I.appearance_flags = RESET_COLOR
		I.color = initial(reagent.color)
		gas_data.tile_overlay[gas_id] = I

	if(kill_later)
		qdel(reagent)

/obj/machinery/portable_atmospherics/gas_generator
	name = "gas generator"
	desc = "A complex machine used to produce gas from liquid reagents"
	icon = 'icons/obj/atmos.dmi'
	icon_state = "gas_generator:0"
	density = 1
	w_class = ITEM_SIZE_GARGANTUAN

	var/valve_open = 0
	var/release_pressure = ONE_ATMOSPHERE
	var/release_flow_rate = ATMOS_DEFAULT_VOLUME_PUMP

	volume = 500
	var/obj/item/weapon/reagent_containers/container

	anchored = 0
	use_power = 1
	interact_offline = 0
	var/release_log = ""

/obj/machinery/portable_atmospherics/gas_generator/Process()
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


/obj/machinery/portable_atmospherics/gas_generator/attackby(var/obj/item/weapon/O as obj, var/mob/usr as mob)

	if(istype(O, /obj/item/weapon/reagent_containers))
		if(container)
			to_chat(usr, "<span class='warning'>\The [src] already has \the [container] loaded!")
		else
			src.container = O
			usr.drop_item()
			O.forceMove(src)
			to_chat(usr, "<span class='notice'>You load \the [O] into \the [src]")

		update_icon()
	..()

/obj/machinery/portable_atmospherics/gas_generator/attack_ai(var/mob/usr)
	src.add_hiddenprint(usr)
	return src.attack_hand(usr)

/obj/machinery/portable_atmospherics/gas_generator/attack_ghost(var/mob/usr)
	return src.attack_hand(usr)

/obj/machinery/portable_atmospherics/gas_generator/attack_hand(var/mob/usr)
	ui_interact(usr)


/obj/machinery/portable_atmospherics/gas_generator/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	//container and gas generation
	var/data[0]
	data["containerLoaded"] = container ? 1 : 0

	var container_reagents[0]
	if(container && container.reagents && container.reagents.reagent_list.len)
		for(var/datum/reagent/R in container.reagents.reagent_list)
			container_reagents[++container_reagents.len] = list("name" = R.name, "volume" = R.volume)
	data["containerReagents"] = container_reagents

	var gases[0]
	for(var/gas in gas_data.gases)
		if(gas_data.component_reagents[gas]) //Only gases with component reagents
			gases[++gases.len] = list("name" = gas_data.name[gas], "id" = gas)
	data["gases"] = gases

	//gas control
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
		ui = new(user, src, ui_key, "gas_generator.tmpl", "Gas Generator", 480, 400)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


/obj/machinery/portable_atmospherics/gas_generator/OnTopic(user, href_list)

	if(href_list["generateGas"])
		if(!container)
			return TOPIC_HANDLED
		var/gas = href_list["generateGas"]
		var/possible_reactions
		var/datum/reagents/container_reagents = container.reagents

		var/list/component_reagents = gas_data.component_reagents[gas]

		for(var/R in component_reagents)
			var/A = container_reagents.get_reagent_amount(R) / component_reagents[R]
			possible_reactions = possible_reactions ? min(possible_reactions, A) : A //Limits  gas production based off limiting reagent
		if(round(possible_reactions, 0.01) > 0)
			playsound(src.loc, 'sound/machines/blender.ogg', 50, 1)
			for(var/R in component_reagents)
				container_reagents.remove_reagent(R, possible_reactions*component_reagents[R])
			air_contents.adjust_gas(gas, possible_reactions/REAGENT_GAS_EXCHANGE_FACTOR, 1)//Adds the proper amount of moles to the container
		else
			visible_message("<span class='notice'>\The [src] flashes an 'Insufficient Reagents' error")
		return TOPIC_REFRESH
	if(href_list["aerosolize"]) //Turning reagents into a new type of gas
		if(!container || !container.reagents)
			return TOPIC_HANDLED
		for(var/datum/reagent/R in container.reagents.reagent_list)
			var/gas_id = lowertext(R.name)
			if(!(gas_id in gas_data.gases))
				create_gas_data_for_reagent(R)
			var/reagents_rmvd = container.reagents.get_reagent_amount(R.type)
			container.reagents.remove_reagent(R.type,reagents_rmvd)
			air_contents.adjust_gas(gas_id, reagents_rmvd/REAGENT_GAS_EXCHANGE_FACTOR, 1)

	else if(href_list["ejectContainer"])
		if(container)
			var/obj/item/weapon/reagent_containers/C = container
			C.dropInto(loc)
			container = null
			update_icon()
			return TOPIC_REFRESH
		else
			return TOPIC_HANDLED

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

		return TOPIC_REFRESH

	else if (href_list["remove_tank"])
		if(!holding)
			return TOPIC_HANDLED
		if (valve_open)
			valve_open = 0
			release_log += "Valve was <b>closed</b> by [usr] ([usr.ckey]), stopping the transfer into the [holding]<br>"
		if(istype(holding, /obj/item/weapon/tank))
			holding.manipulated_by = usr.real_name
		holding.forceMove(get_turf(src))
		holding = null
		update_icon()

		return TOPIC_REFRESH

	else if (href_list["pressure_adj"])
		var/diff = text2num(href_list["pressure_adj"])
		if(diff > 0)
			release_pressure = min(10*ONE_ATMOSPHERE, release_pressure+diff)
		else
			release_pressure = max(ONE_ATMOSPHERE/10, release_pressure+diff)
		return TOPIC_REFRESH

/obj/machinery/portable_atmospherics/gas_generator/update_icon()
	overlays.Cut()

	if(connected_port)
		overlays += "gas-generator-connector"

	if(container)
		icon_state = "gas_generator:1"
	else
		icon_state = "gas_generator:0"