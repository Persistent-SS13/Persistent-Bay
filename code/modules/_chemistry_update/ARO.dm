/*  Any questions and suggestions, you can find me at github.com/ingles98 (aka Stigma).
    Code originally created for Persistent-SS13/Persistent-Bay.
    Feel free to credit back to us... Or don't :c
	Currently the code is pretty much spaget so i'd be really glad if you told me any changes you make or simple suggestions.

	Uses the same concept as APC's, by supplying the whole area with reagents "wirelessly" or should I say "pipelessly" heh..
*/
#define ARO_BASEINPUT_GAS         100		//Input in MOLS
#define ARO_BASEOUTPUT_REAGENT    20		//Output in UNITS, transfered water to machines that need it
/area/proc/get_aro()
	return aro

/obj/machinery/atmospherics/unary/aro
	name = "Area Reagent Outlet"
	desc = "Distributes water to local sinks."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "aro"
	density = 0
	anchored = 1
	use_power = 0
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SCRUBBER

	idle_power_usage = 0		//outlet_waters don't use power, for now
	power_rating = 7500
	level = 2
	layer = 2

	var/hibernate = 0
	var/max_volume = 80 //buffer for instant requests. Keep in mind that these shouldn't happen and it only exists for the sink right now.
	var/max_input = ARO_BASEINPUT_GAS //max input per tick in MOLS
	var/max_reagent_output = ARO_BASEOUTPUT_REAGENT
	var/area/area
	var/list/machines_to_pump = new()

/obj/machinery/atmospherics/unary/aro/New()
	..()
	create_reagents(max_volume) //holds up to *max_volume* amounts of water
	if (!area)
		area = get_area(src)
		area.aro = src
	if (!area.aro) //really just to make sure tbh
		area.aro = src

/obj/machinery/atmospherics/unary/aro/after_load()
	..()
	if (!area)
		area = get_area(src)
		area.aro = src
	if (!area.aro) //really just to make sure tbh
		area.aro = src

	if (isnull(machines_to_pump))
		machines_to_pump = new()

/obj/machinery/atmospherics/unary/aro/Process()
	..()
	if (hibernate)
		return

	var/active = 0
	var/update_network = 0

	//stores water for structures that request water like "sink" (/obj/structure/sink) that doesn't have Process() and needs instant reagent access.
	if (reagents.total_volume < reagents.maximum_volume *0.80) //we worry about getting more water if we're actually using it
		if (air_contents.gas["water"])
			var/water_input = air_contents.gas["water"]
			var/free_volume = reagents.get_free_space()
			var/transfer = min(max_input, water_input, free_volume/REAGENT_GAS_EXCHANGE_FACTOR)
			air_contents.adjust_gas("water",- transfer)
			reagents.add_reagent(/datum/reagent/water, transfer*REAGENT_GAS_EXCHANGE_FACTOR)
			active = 1
			update_network = 1

	for (var/datum/reagents/holder in machines_to_pump) //not actual machines, but their holders but yeah..
		active = 1 // will remain active as long as there is machines in the queue
		var/datum/reagent/reagent = machines_to_pump[holder]
		var/datum/reagent/TEMP = new reagent()
		//checks if the specified reagent gas exists in the current pipeline
		if ( !air_contents.gas[ lowertext(TEMP.name) ] )
			qdel(TEMP)
			continue

		//checks for the minimum amount that can be transfered - skips if none, without removing from queue.
		var/transfer = min(holder.get_free_space() , max_reagent_output, air_contents.gas[ lowertext(TEMP.name) ]*REAGENT_GAS_EXCHANGE_FACTOR )
		if (!transfer)
			qdel(TEMP)
			continue

		//perfoms the exchange
		holder.add_reagent(reagent, transfer)
		air_contents.adjust_gas(lowertext(TEMP.name),- transfer/REAGENT_GAS_EXCHANGE_FACTOR)

		//removes the 'sink' from the queue.
		machines_to_pump.Remove(holder)
		qdel(TEMP)

	if (update_network)
		network.update = 1
	if (!active)
		hibernate = 1
		update_underlays()
		spawn (rand(50,100))
			if (hibernate) hibernate = 0

/obj/machinery/atmospherics/unary/aro/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		if(!T.is_plating() && node && node.level == 1 && istype(node, /obj/machinery/atmospherics/pipe))
			return
		else
			if(node)
				add_underlay(T, node, dir, node.icon_connect_type)
			else
				add_underlay(T,, dir)

		var/datum/reagents/TEMP_HOLDER = new()
		TEMP_HOLDER.maximum_volume = 0
		var/datum/gas_mixture/air_data = air_contents
		for(var/gas in air_data.gas)
			if(!gas_data.component_reagents[gas])
				continue	//we don't need to (nor we can) proceed if the gas wasn't made out of a 'known' reagent.

			var/list/component_reagents = gas_data.component_reagents[gas]

			var/possible_transfers = air_data.get_gas(gas)
			if(!possible_transfers) //If we're out of gas boi. Shouldn't probably happen to be honest as the gas should be removed from the list
				break //Doesnt mean we shouldn't prevent condensating non existent gas anyways so fuck it.

			for(var/R in component_reagents)
				var/datum/reagent/reagent_data = new R() //hacky
				TEMP_HOLDER.maximum_volume += possible_transfers*component_reagents[R]*REAGENT_GAS_EXCHANGE_FACTOR
				TEMP_HOLDER.add_reagent(R, possible_transfers*component_reagents[R]*REAGENT_GAS_EXCHANGE_FACTOR) // Get those sweet gas reagents back to liquid state by creating em on the puddlez
				qdel(reagent_data)

		var/image/under = image('icons/obj/watercloset.dmi', src, "aro_underlay")
		under.alpha = 135
		under.color = reagents.get_color()
		underlays += under
		qdel(TEMP_HOLDER)

/obj/machinery/atmospherics/unary/aro/hide()
	update_icon()
	update_underlays()

/obj/machinery/atmospherics/unary/aro/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if(!isWrench(W))
		return ..()
	if (!(stat & NOPOWER) && use_power)
		to_chat(user, "<span class='warning'>You cannot unwrench \the [src], turn it off first.</span>")
		return 1
	var/turf/T = src.loc
	if (node && node.level==1 && isturf(T) && !T.is_plating())
		to_chat(user, "<span class='warning'>You must remove the plating first.</span>")
		return 1
	var/datum/gas_mixture/int_air = return_air()
	var/datum/gas_mixture/env_air = loc.return_air()
	if ((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
		to_chat(user, "<span class='warning'>You cannot unwrench \the [src], it is too exerted due to internal pressure.</span>")
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
		area.aro = null
		qdel(src)

/obj/machinery/atmospherics/unary/aro/attack_hand(mob/user as mob)
	to_chat(user, "<span class='notice'>You read the meter. The [src] currently has a total [reagents.total_volume] unit\s of water in the buffer. (Buffers only store water and are only required for Sinks to function. Everything else is exchanged and queued on the fly. Removing this note once there is a complete information on the Wiki around this.)</span>")

// Queues up whatever requested it for a 'reagent' supply. Returns 1 if it sucessfuly queued, does not confirm if it will actually get supplied.
/obj/machinery/atmospherics/unary/aro/proc/request_reagent(var/datum/reagents/holder, var/datum/reagent/reagent)
	if (!holder || !reagent || !istype(holder) )
		return 0
	if ( machines_to_pump[holder] ) return 0
	machines_to_pump[holder] = reagent
	hibernate = 0
	return 1







#undef ARO_BASEINPUT_GAS
#undef ARO_BASEOUTPUT_REAGENT
