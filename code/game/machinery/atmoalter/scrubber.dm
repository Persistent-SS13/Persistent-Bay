/obj/machinery/portable_atmospherics/powered/scrubber
	name = "Portable Air Scrubber"
	desc = "Portable air contaminant scrubber. Works on rechargeable power cells."
	icon = 'icons/obj/atmos.dmi'
	icon_state = "pscrubber:0"
	density = 1
	w_class = ITEM_SIZE_NORMAL

	var/on = 0
	var/volume_rate = 800

	volume = 750

	power_rating = 7500 //7500 W ~ 10 HP
	power_losses = 150

	var/minrate = 0
	var/maxrate = 10 * ONE_ATMOSPHERE

	var/list/scrubbing_gas

/obj/machinery/portable_atmospherics/powered/scrubber/New()
	. = ..()
	ADD_SAVED_VAR(on)
	ADD_SAVED_VAR(volume_rate)
	ADD_SAVED_VAR(scrubbing_gas)

/obj/machinery/portable_atmospherics/powered/scrubber/make_cell()
	return new/obj/item/weapon/cell/apc(src)

/obj/machinery/portable_atmospherics/powered/scrubber/Initialize()
	. = ..()
	if(!scrubbing_gas)
		scrubbing_gas = list()
		for(var/g in gas_data.gases)
			if(g != GAS_OXYGEN && g != GAS_NITROGEN)
				scrubbing_gas += g

/obj/machinery/portable_atmospherics/powered/scrubber/turn_on()
	. = ..()
	START_PROCESSING(SSmachines, src)

/obj/machinery/portable_atmospherics/powered/scrubber/turn_off()
	. = ..()
	STOP_PROCESSING(SSmachines, src)

/obj/machinery/portable_atmospherics/powered/scrubber/proc/toggle()
	on = !on
	if(on)
		START_PROCESSING(SSmachines, src)
	else
		STOP_PROCESSING(SSmachines, src)
	update_icon()

/obj/machinery/portable_atmospherics/powered/scrubber/emp_act(severity)
	if(inoperable())
		..(severity)
		return

	if(prob(50/severity))
		toggle()

	..(severity)

/obj/machinery/portable_atmospherics/powered/scrubber/on_update_icon()
	overlays.Cut()

	if(on && cell && cell.charge)
		icon_state = "pscrubber:1"
	else
		icon_state = "pscrubber:0"

	if(holding)
		overlays += "scrubber-open"

	if(connected_port)
		overlays += "scrubber-connector"

	return

/obj/machinery/portable_atmospherics/powered/scrubber/Process()
	//No point in running in nullspace!
	if(isnull(loc) || QDELETED(src))
		return PROCESS_KILL
	..()

	var/power_draw = -1

	if(on && ( powered() || (cell && cell.charge) ) )
		var/datum/gas_mixture/environment
		if(holding)
			environment = holding.air_contents
		else
			environment = loc.return_air()

		var/transfer_moles = min(1, volume_rate/environment.volume)*environment.total_moles

		power_draw = scrub_gas(src, scrubbing_gas, environment, air_contents, transfer_moles, power_rating)

	if (power_draw < 0)
		last_flow_rate = 0
		last_power_draw = 0
	else
		power_draw = max(power_draw, power_losses)
		if(!powered())
			cell.use(power_draw * CELLRATE)
		else
			use_power_oneoff(power_draw)
		last_power_draw = power_draw

		update_connected_network()

		//ran out of charge
		if (!cell.charge && !powered())
			power_change()
			queue_icon_update()
		if(holding)
			holding.queue_icon_update()

	//src.update_icon()
	src.updateDialog()

/obj/machinery/portable_atmospherics/powered/scrubber/attack_ai(var/mob/user)
	src.add_hiddenprint(user)
	return src.attack_hand(user)

/obj/machinery/portable_atmospherics/powered/scrubber/attack_ghost(var/mob/user)
	return src.attack_hand(user)

/obj/machinery/portable_atmospherics/powered/scrubber/attack_hand(var/mob/user)
	ui_interact(user)
	return

/obj/machinery/portable_atmospherics/powered/scrubber/ui_interact(mob/user, ui_key = "rcon", datum/nanoui/ui=null, force_open=1)
	var/list/data[0]
	data["portConnected"] = connected_port ? 1 : 0
	data["tankPressure"] = round(air_contents.return_pressure() > 0 ? air_contents.return_pressure() : 0)
	data["rate"] = round(volume_rate)
	data["minrate"] = round(minrate)
	data["maxrate"] = round(maxrate)
	data["powerDraw"] = round(last_power_draw)
	data["cellCharge"] = cell ? cell.charge : 0
	data["cellMaxCharge"] = cell ? cell.maxcharge : 1
	data["on"] = on ? 1 : 0

	data["hasHoldingTank"] = holding ? 1 : 0
	if (holding)
		data["holdingTank"] = list("name" = holding.name, "tankPressure" = round(holding.air_contents.return_pressure() > 0 ? holding.air_contents.return_pressure() : 0))

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "portscrubber.tmpl", "Portable Scrubber", 480, 400, state = GLOB.physical_state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


/obj/machinery/portable_atmospherics/powered/scrubber/OnTopic(user, href_list)
	if(href_list["power"])
		toggle()
		. = TOPIC_REFRESH
	if (href_list["remove_tank"])
		if(holding)
			holding.dropInto(loc)
			holding = null
		. = TOPIC_REFRESH
	if (href_list["volume_adj"])
		var/diff = text2num(href_list["volume_adj"])
		volume_rate = Clamp(volume_rate+diff, minrate, maxrate)
		. = TOPIC_REFRESH

	if(.)
		update_icon()

//
//Huge scrubber
//
/obj/machinery/portable_atmospherics/powered/scrubber/huge
	name = "Huge Air Scrubber"
	desc = "A larger variant of the smaller portable scrubber. Work on APC power, controlled via Area Air Control Console."
	icon_state = "scrubber:0"
	anchored = TRUE
	volume = 50000
	volume_rate = 5000

	use_power = POWER_USE_IDLE
	idle_power_usage = 500		//internal circuitry, friction losses and stuff
	active_power_usage = 100000	//100 kW ~ 135 HP

	id_tag = null
	frequency = ATMOS_CONTROL_FREQ
	radio_filter_in = RADIO_ATMOSIA
	radio_filter_out = RADIO_ATMOSIA
	cell = null

/obj/machinery/portable_atmospherics/powered/scrubber/huge/New()
	..()
	id_tag = make_loc_string_id("HAScr")
	if(name == initial(name))
		name = "[name]([id_tag])"

/obj/machinery/portable_atmospherics/powered/scrubber/huge/make_cell()
	return null

/obj/machinery/portable_atmospherics/powered/scrubber/huge/attack_hand(var/mob/user as mob)
		to_chat(usr, "<span class='notice'>You can't directly interact with this machine. Use the scrubber control console.</span>")

/obj/machinery/portable_atmospherics/powered/scrubber/huge/update_icon()
	src.overlays.Cut()
	if(ison() && operable())
		icon_state = "scrubber:1"
	else
		icon_state = "scrubber:0"

/obj/machinery/portable_atmospherics/powered/scrubber/huge/power_change()
	var/old_stat = stat
	..()
	if (old_stat != stat)
		queue_icon_update()

/obj/machinery/portable_atmospherics/powered/scrubber/huge/Process()
	if(isnull(loc) || QDELETED(src))
		return PROCESS_KILL
	if(!ison() || inoperable())
		update_use_power(POWER_USE_OFF)
		last_flow_rate = 0
		last_power_draw = 0
		return 0

	var/power_draw = -1
	var/datum/gas_mixture/environment = loc.return_air()
	var/transfer_moles = min(1, volume_rate/environment.volume)*environment.total_moles

	power_draw = scrub_gas(src, scrubbing_gas, environment, air_contents, transfer_moles, active_power_usage)

	if (power_draw < 0)
		last_flow_rate = 0
		last_power_draw = 0
	else
		use_power_oneoff(power_draw)
		update_connected_network()

/obj/machinery/portable_atmospherics/powered/scrubber/huge/default_wrench_floor_bolts(mob/user, obj/item/weapon/tool/W, delay)
	if(ison())
		to_chat(user, SPAN_WARNING("Turn \the [src] off first!"))
		return FALSE
	. = ..()
	
/obj/machinery/portable_atmospherics/powered/scrubber/huge/attackby(var/obj/item/I as obj, var/mob/user as mob)
	if(default_wrench_floor_bolts(user, I))
		return
	//doesn't use power cells
	if(istype(I, /obj/item/weapon/cell))
		return
	if(isScrewdriver(I))
		return
	//doesn't hold tanks
	if(istype(I, /obj/item/weapon/tank))
		return
	return ..()

//
//	Stationary
//
/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary
	name = "Stationary Air Scrubber"

/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/attackby(var/obj/item/I as obj, var/mob/user as mob)
	if(isWrench(I))
		to_chat(user, SPAN_WARNING("The bolts are too tight for you to unscrew!"))
		return
	..()
