//TODO: We want to make this thing need 0 maintenance when adding new gases and etc.. 
//	    So have the filter list auto-generate and also use strings to set filter types instead of a set of constants
//		- Psy_commando

/obj/machinery/atmospherics/trinary/filter
	name = "Gas filter"
	desc = "Device able to extract a specific gas from an arbitrary gas mix."
	icon = 'icons/atmos/filter.dmi'
	icon_state = "map"
	density = FALSE
	level = 1
	//Power
	use_power = POWER_USE_IDLE
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 15000	//This also doubles as a measure of how powerful the filter is, in Watts. 7500 W ~ 10 HP
	//Radio
	frequency 		= null
	id_tag 			= null
	radio_filter_in = RADIO_ATMOSIA
	radio_filter_out= RADIO_ATMOSIA
	radio_check_id 	= TRUE

	var/temp = null // -- TLE
	var/set_flow_rate = ATMOS_DEFAULT_VOLUME_FILTER

	/*
	Filter types:
	-1: Nothing
	 0: Phoron: Phoron, Oxygen Agent B
	 1: Oxygen: Oxygen ONLY
	 2: Nitrogen: Nitrogen ONLY
	 3: Carbon Dioxide: Carbon Dioxide ONLY
	 4: Sleeping Agent (N2O)
	 5: Hydrogen (H2)
	 6: Reagent Gases
	*/
	var/filter_type = -1
	var/list/filtered_out = list()

/obj/machinery/atmospherics/trinary/filter/New()
	..()
	update_filtering()
	air1.volume = ATMOS_DEFAULT_VOLUME_FILTER
	air2.volume = ATMOS_DEFAULT_VOLUME_FILTER
	air3.volume = ATMOS_DEFAULT_VOLUME_FILTER
	ADD_SAVED_VAR(set_flow_rate)
	ADD_SAVED_VAR(filter_type)
	ADD_SAVED_VAR(filtered_out)

/obj/machinery/atmospherics/trinary/filter/on_update_icon()
	if(istype(src, /obj/machinery/atmospherics/trinary/filter/m_filter))
		icon_state = "m"
	else
		icon_state = ""

	if(!powered())
		icon_state += "off"
	else if(node2 && node3 && node1)
		icon_state += use_power ? "on" : "off"
	else
		icon_state += "off"
		//update_use_power(POWER_USE_OFF)

/obj/machinery/atmospherics/trinary/filter/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return

		add_underlay(T, node1, turn(dir, -180))
		if(istype(src, /obj/machinery/atmospherics/trinary/filter/m_filter))
			add_underlay(T, node2, turn(dir, 90))
		else
			add_underlay(T, node2, turn(dir, -90))
		add_underlay(T, node3, dir)

/obj/machinery/atmospherics/trinary/filter/hide(var/i)
	update_underlays()

/obj/machinery/atmospherics/trinary/filter/Process()
	..()
	last_power_draw = 0
	last_flow_rate = 0
	if(inoperable())
		update_use_power(POWER_USE_OFF)
		return
	if(isoff())
		return

	//Figure out the amount of moles to transfer
	var/transfer_moles = (set_flow_rate/air1.volume)*air1.total_moles
	var/power_draw = -1
	if (transfer_moles > MINIMUM_MOLES_TO_FILTER)
		power_draw = filter_gas(src, filtered_out, air1, air2, air3, transfer_moles, power_rating)
		if(network2)
			network2.update = 1
		if(network3)
			network3.update = 1
		if(network1)
			network1.update = 1
	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power_oneoff(power_draw)

	return 1

/obj/machinery/atmospherics/trinary/filter/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if(!isWrench(W))
		return ..()
	var/datum/gas_mixture/int_air = return_air()
	var/datum/gas_mixture/env_air = loc.return_air()
	if ((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
		to_chat(user, "<span class='warning'>You cannot unwrench \the [src], it too exerted due to internal pressure.</span>")
		add_fingerprint(user)
		return 1
	playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
	to_chat(user, "<span class='notice'>You begin to unfasten \the [src]...</span>")
	if (do_after(user, 40, src))
		user.visible_message( \
			"<span class='notice'>\The [user] unfastens \the [src].</span>", \
			"<span class='notice'>You have unfastened \the [src].</span>", \
			"You hear a ratchet.")
		new /obj/item/pipe(loc, make_from=src)
		qdel(src)


/obj/machinery/atmospherics/trinary/filter/attack_hand(user as mob) // -- TLE
	if(..())
		return

	if(!src.allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return

	var/dat
	var/current_filter_type
	switch(filter_type)
		if(0)
			current_filter_type = "Phoron"
		if(1)
			current_filter_type = "Oxygen"
		if(2)
			current_filter_type = "Nitrogen"
		if(3)
			current_filter_type = "Carbon Dioxide"
		if(4)
			current_filter_type = "Nitrous Oxide"
		if(5)
			current_filter_type = "Hydrogen"
		if(6)
			current_filter_type = "Any Reagents (Mostly liquids)"
		if(7)
			current_filter_type = "Specific Reagent ([filtered_out[1]])"
		if(-1)
			current_filter_type = "Nothing"
		else
			current_filter_type = "ERROR - Report this bug to the admin, please!"

	dat += {"
			<b>Power: </b><a href='?src=\ref[src];power=1'>[use_power?"On":"Off"]</a><br>
			<b>Filtering: </b>[current_filter_type]<br><HR>
			<h4>Set Filter Type:</h4>
			<A href='?src=\ref[src];filterset=0'>Phoron</A><BR>
			<A href='?src=\ref[src];filterset=1'>Oxygen</A><BR>
			<A href='?src=\ref[src];filterset=2'>Nitrogen</A><BR>
			<A href='?src=\ref[src];filterset=3'>Carbon Dioxide</A><BR>
			<A href='?src=\ref[src];filterset=4'>Nitrous Oxide</A><BR>
			<A href='?src=\ref[src];filterset=5'>Hydrogen</A><BR>
			<A href='?src=\ref[src];filterset=6'>Any Reagents (Mostly liquids)</a><BR>
			<A href='?src=\ref[src];filterset=7'>Specific Reagent</a><BR>
			<A href='?src=\ref[src];filterset=-1'>Nothing</A><BR>
			<HR>
			<B>Set Flow Rate Limit:</B>
			[src.set_flow_rate]L/s | <a href='?src=\ref[src];set_flow_rate=1'>Change</a><BR>
			<B>Flow rate: </B>[round(last_flow_rate, 0.1)]L/s
			"}

	show_browser(user, "<HEAD><TITLE>[src.name] control</TITLE></HEAD><TT>[dat]</TT>", "window=atmo_filter")
	onclose(user, "atmo_filter")
	return

/obj/machinery/atmospherics/trinary/filter/Topic(href, href_list) // -- TLE
	if(..())
		return 1
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(href_list["filterset"])
		filter_type = text2num(href_list["filterset"])

		filtered_out.Cut()	//no need to create new lists unnecessarily
		switch(filter_type)
			if(0) //removing hydrocarbons
				filtered_out += GAS_PHORON
			if(1) //removing O2
				filtered_out += GAS_OXYGEN
			if(2) //removing N2
				filtered_out += GAS_NITROGEN
			if(3) //removing CO2
				filtered_out += GAS_CO2
			if(4)//removing N2O
				filtered_out += GAS_N2O
			if(5)//removing H2
				filtered_out += GAS_HYDROGEN
			if(6)//removing reagent gases
				for(var/g in gas_data.gases) //This only fires when initially selecting the filter type, so impact on performance is minimal
					if(gas_data.flags[g] & XGM_GAS_REAGENT_GAS)
						to_chat(usr, "<span class='notice'>[g]</span>")
						filtered_out += g
			if(7)
				var/list/matches = new()
				for(var/g in gas_data.gases) //This only fires when initially selecting the filter type, so impact on performance is minimal
					if(gas_data.flags[g] & XGM_GAS_REAGENT_GAS)
						matches += g
				filtered_out += input("Specify the reagent", "Reagents", matches[1]) as null|anything in matches
	if (href_list["temp"])
		src.temp = null
	if(href_list["set_flow_rate"])
		var/new_flow_rate = input(usr,"Enter new flow rate (0-[air1.volume]L/s)","Flow Rate Control",src.set_flow_rate) as num
		src.set_flow_rate = max(0, min(air1.volume, new_flow_rate))
	if(href_list["power"])
		update_use_power(!use_power)
	src.update_icon()
	src.updateUsrDialog()
/*
	for(var/mob/M in viewers(1, src))
		if ((M.client && M.machine == src))
			src.attack_hand(M)
*/
	return

/obj/machinery/atmospherics/trinary/filter/proc/update_filtering()
	switch(filter_type)
		if(0) //removing hydrocarbons
			filtered_out = list(GAS_PHORON)
		if(1) //removing O2
			filtered_out = list(GAS_OXYGEN)
		if(2) //removing N2
			filtered_out = list(GAS_NITROGEN)
		if(3) //removing CO2
			filtered_out = list(GAS_CO2)
		if(4)//removing N2O
			filtered_out = list(GAS_N2O)
		if(5)//removing H2
			filtered_out = list(GAS_HYDROGEN)
		if(6)//removing reagent gases
			for(var/g in gas_data.gases)
				if(gas_data.flags[g] & XGM_GAS_REAGENT_GAS)
					filtered_out = gas_data.gases[g]

/obj/machinery/atmospherics/trinary/filter/m_filter
	icon_state = "mmap"
	dir = SOUTH
	initialize_directions = SOUTH|NORTH|EAST

obj/machinery/atmospherics/trinary/filter/m_filter/setup_initialize_directions()
	switch(dir)
		if(NORTH)
			initialize_directions = WEST|NORTH|SOUTH
		if(SOUTH)
			initialize_directions = SOUTH|EAST|NORTH
		if(EAST)
			initialize_directions = EAST|WEST|NORTH
		if(WEST)
			initialize_directions = WEST|SOUTH|EAST

/obj/machinery/atmospherics/trinary/filter/m_filter/Initialize()
	. = ..()

/obj/machinery/atmospherics/trinary/filter/m_filter/atmos_init()
	..()
	if(node1 && node2 && node3) 
		return
	var/node1_connect = turn(dir, -180)
	var/node2_connect = turn(dir, 90)
	var/node3_connect = dir
	for(var/obj/machinery/atmospherics/target in get_step(src,node1_connect))
		if(target.initialize_directions & get_dir(target,src))
			node1 = target
			break
	for(var/obj/machinery/atmospherics/target in get_step(src,node2_connect))
		if(target.initialize_directions & get_dir(target,src))
			node2 = target
			break
	for(var/obj/machinery/atmospherics/target in get_step(src,node3_connect))
		if(target.initialize_directions & get_dir(target,src))
			node3 = target
			break
	queue_icon_update()
	update_underlays()
