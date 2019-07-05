/obj/machinery/portable_atmospherics/gas_generator
	name = "gas generator"
	desc = "A complex machine used to produce gas from liquid reagents"
	icon = 'icons/obj/atmos.dmi'
	icon_state = "gas_generator:0"
	density = 1
	w_class = ITEM_SIZE_GARGANTUAN
	anchored = 0
	interact_offline = 0
	volume = 500
	circuit_type = /obj/item/weapon/circuitboard/gasgenerator
	var/valve_open = 0
	var/release_pressure = ONE_ATMOSPHERE
	var/release_flow_rate = ATMOS_DEFAULT_VOLUME_PUMP
	var/obj/item/weapon/reagent_containers/container
	var/release_log = ""

/obj/machinery/portable_atmospherics/gas_generator/New()
	..()
	ADD_SAVED_VAR(container)
	ADD_SAVED_VAR(valve_open)
	ADD_SAVED_VAR(release_pressure)
	ADD_SAVED_VAR(release_flow_rate)

	ADD_SKIP_EMPTY(container)

/obj/machinery/portable_atmospherics/gas_generator/Process()
	. = ..()

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
				queue_icon_update()


/obj/machinery/portable_atmospherics/gas_generator/attackby(var/obj/item/weapon/O as obj, var/mob/usr as mob)

	if(istype(O, /obj/item/weapon/reagent_containers))
		if(container)
			to_chat(usr, "<span class='warning'>\The [src] already has \the [container] loaded!</span>")
		else
			src.container = O
			usr.drop_item()
			O.forceMove(src)
			to_chat(usr, "<span class='notice'>You load \the [O] into \the [src]</span>")

		update_icon()
	if(isScrewdriver(O))
		default_deconstruction_screwdriver(usr, O)
	if(isCrowbar(O))
		default_deconstruction_crowbar(usr, O)

	..()

/obj/machinery/portable_atmospherics/gas_generator/attack_ai(var/mob/usr)
	src.add_hiddenprint(usr)
	return src.attack_hand(usr)

/obj/machinery/portable_atmospherics/gas_generator/attack_ghost(var/mob/usr)
	return src.attack_hand(usr)

/obj/machinery/portable_atmospherics/gas_generator/attack_hand(var/mob/usr)
	ui_interact(usr)


/obj/machinery/portable_atmospherics/gas_generator/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	//Reagent container and gas generation
	var/data[0]
	data["containerLoaded"] = container ? 1 : 0

	var container_reagents[0]
	if(container && container.reagents && container.reagents.reagent_list.len)
		for(var/datum/reagent/R in container.reagents.reagent_list)
			container_reagents[++container_reagents.len] = list("name" = R.name, "volume" = R.volume)
	data["containerReagents"] = container_reagents

	var gases[0]

	if(container && container.reagents)
		var/datum/reagents/reagents = container.reagents
		gas_iteration_loop:
			for(var/gas in gas_data.gases)
				var/list/component_reagents = gas_data.component_reagents[gas]
				if(component_reagents)//Only gases with component reagents
					for(var/R in component_reagents)
						if(!reagents.get_reagent_amount(R)) //We won't list gases that can't be generated to keep the ui clean
							continue gas_iteration_loop		//So if we're missing a component_reagent, we continue onto the next gas.
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

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "gas_generator.tmpl", "Gas Generator", 480, 400)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


/obj/machinery/portable_atmospherics/gas_generator/OnTopic(user, href_list)

	if(href_list["generateGas"])// Producing gas from reagents.
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
			air_contents.adjust_gas_temp(gas, possible_reactions/REAGENT_GAS_EXCHANGE_FACTOR, T20C, 1)//Adds the proper amount of moles to the container
		else
			visible_message("<span class='notice'>\The [src] flashes an 'Insufficient Reagents' error</span>")
		return TOPIC_REFRESH

	if(href_list["condense"]) //Reverting gas back into reagents.
		if(!container || !container.reagents)
			return TOPIC_HANDLED
		if(!container.reagents.get_free_space())
			to_chat(user, "<span class='notice'>The container is full.</span>")
			return TOPIC_HANDLED
		for(var/gas in air_contents.gas)
			if(!gas_data.component_reagents[gas])
				continue

			var/list/component_reagents = gas_data.component_reagents[gas]
			var/datum/reagents/container_reagents = container.reagents
			var/free_space = container_reagents.get_free_space()

			var/possible_transfers = min(free_space/REAGENT_GAS_EXCHANGE_FACTOR, air_contents.get_gas(gas))

			if(!possible_transfers) //If we're out of free space, stop the loop
				break

			for(var/R in component_reagents)
				container_reagents.add_reagent(R, possible_transfers*component_reagents[R]*REAGENT_GAS_EXCHANGE_FACTOR) //Adding reagents back into the container

			air_contents.adjust_gas(gas, -possible_transfers, 1)//Removes the proper amount of moles from the container


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

/obj/machinery/portable_atmospherics/gas_generator/on_update_icon()
	overlays.Cut()

	if(connected_port)
		overlays += "gas-generator-connector"

	if(container)
		icon_state = "gas_generator:1"
	else
		icon_state = "gas_generator:0"