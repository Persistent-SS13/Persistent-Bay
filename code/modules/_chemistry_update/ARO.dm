/*  Any questions and suggestions, you can find me at github.com/ingles98 (aka Stigma).
	Code originally created for Persistent-SS13/Persistent-Bay.
	Feel free to credit back to us... Or don't :c
	Currently the code is pretty much spaget so i'd be really glad if you told me any changes you make or simple suggestions.

	Uses the same concept as APC's, by supplying the whole area with reagents "wirelessly" or should I say "pipelessly" heh..
*/
#define ARO_BASEINPUT_GAS         	100		//Input in MOLS
#define ARO_BASEOUTPUT_REAGENT    	20		//Output in UNITS, transfered reagents to machines that need it
#define ARO_MAX_QUEUE_TIME			100		//Max time in seconds a machine will persist on the queue before being removed

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
	var/list/machines_queue_time = new()

/obj/machinery/atmospherics/unary/aro/New()
	..()
	create_reagents(max_volume) //holds up to *max_volume* amounts of water
	if (!area)
		area = get_area(src)
		if (area)	area.aro = src
	if (!area.aro) //really just to make sure tbh
		area.aro = src

/obj/machinery/atmospherics/unary/aro/Destroy()
	reagents.splash(loc, reagents.total_volume)
	. = ..()

/obj/machinery/atmospherics/unary/aro/after_load()
	..()
	if (!area)
		area = get_area(src)
		area.aro = src
	if (!area.aro) //really just to make sure tbh
		area.aro = src

	if (isnull(machines_to_pump))
		machines_to_pump = new()
	if (isnull(machines_queue_time))
		machines_queue_time = new()

/obj/machinery/atmospherics/unary/aro/Process()
	..()
	if (hibernate)
		return

	var/active = 0
	var/update_network = 0 //update gas flow on network IF WE ACTUALLY PUMPED SOMETHING

	var/world_time = world.time								//so we don't call it a bunch of times.
	for (var/atom/holder in machines_to_pump) 				//no longer just the reagent holder
		if ( QDELETED(holder) || isnull(holder) || isnull(holder.reagents) )
			machines_to_pump.Remove(holder)
			machines_queue_time.Remove(holder)
			continue
		if (world_time >= machines_queue_time[holder] )		//Removes the machine if the time in the queue had exceeded.
			machines_to_pump.Remove(holder)
			machines_queue_time.Remove(holder)
			continue

		active = 1 											//Will remain active as long as there is machines in the queue
		var/type = machines_to_pump[holder]

		if (type == "any")									//It's asking for anything the ARO has, pump all the gases/liquids inside at their current ratio
			var/free_vol_moles = holder.reagents.get_free_space() / REAGENT_GAS_EXCHANGE_FACTOR
			var/air_contents_moles = air_contents.total_moles
			for(var/gas in air_contents.gas)
				var/reagent_type
				if ( (!gas_data.generated_from_reagent[gas] && gas_data.component_reagents[gas].len == 1) ) //Not generated from reagents but is the gas state of one
					for (var/r in gas_data.component_reagents[gas])
						reagent_type = r
				else if ( (!gas_data.generated_from_reagent[gas] && gas_data.component_reagents[gas].len != 1) )
					air_contents_moles -= air_contents.gas[gas] //removes the amount of moles to calculate from this gas
					continue //Not a reagent gas nor its made outta only one reagent so, proceed to the next.
				else
					reagent_type = gas_data.reagent_idToType[gas]

				var/ratio = air_contents.gas[gas]/air_contents_moles
				var/transfer = min(ratio*free_vol_moles, ratio*air_contents_moles) * REAGENT_GAS_EXCHANGE_FACTOR

				transfer = holder.aro_pump_receive(reagent_type, transfer) 	//'transfer' should mostly not change here but still double check
				air_contents.adjust_gas(gas,- transfer/REAGENT_GAS_EXCHANGE_FACTOR)
				update_network = 1

			machines_to_pump.Remove(holder)
			machines_queue_time.Remove(holder)
			continue										//"ANY" TYPE PROCESSED SUCCESSFULY, MOVE ON

		var/reagent_gas_id = gas_data.reagent_typeToId[type]

		//checks if the specified reagent gas exists in the current pipeline
		if ( !air_contents.gas[ reagent_gas_id ] )
			continue

		//checks for the minimum amount that can be transfered - skips if none, without removing from queue.
		var/transfer = min(holder.reagents.get_free_space() , max_reagent_output, air_contents.gas[ reagent_gas_id ]*REAGENT_GAS_EXCHANGE_FACTOR )
		if (!transfer)
			continue

		//perfoms the exchange
		transfer = holder.aro_pump_receive(type, transfer) 	//'transfer' should mostly not change here but still double check
		air_contents.adjust_gas(reagent_gas_id,- transfer/REAGENT_GAS_EXCHANGE_FACTOR)
		update_network = 1

		//removes the 'sink' from the queue.
		machines_to_pump.Remove(holder)
		machines_queue_time.Remove(holder)

	if (update_network)
		network.update = 1
	if (!active)
		hibernate = 1
		update_underlays()
		spawn (rand(10,50))
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
		var/datum/gas_mixture/air_data = air_contents
		TEMP_HOLDER.maximum_volume = air_data.total_moles*REAGENT_GAS_EXCHANGE_FACTOR
		for(var/gas in air_data.gas)
			if(!gas_data.component_reagents[gas])
				continue	//we don't need to (nor we can) proceed if the gas wasn't made out of a 'known' reagent.

			var/list/component_reagents = gas_data.component_reagents[gas]

			var/possible_transfers = air_data.get_gas(gas)
			if(!possible_transfers) //If we're out of gas boi. Shouldn't probably happen to be honest as the gas should be removed from the list
				break //Doesnt mean we shouldn't prevent condensating non existent gas anyways so fuck it.

			for(var/R in component_reagents)
				TEMP_HOLDER.add_reagent(R, possible_transfers*component_reagents[R]*REAGENT_GAS_EXCHANGE_FACTOR) // Get those sweet gas reagents back to liquid state by creating em on the puddlez

		var/image/under = image('icons/obj/watercloset.dmi', src, "aro_underlay")
		under.alpha = 165
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

// Queues up whatever requested it for a 'reagent' supply. Returns 1 if it sucessfuly queued, does not confirm if it will actually get supplied.
/obj/machinery/atmospherics/unary/aro/proc/request_reagent(var/atom/holder, var/reagent)
	if (!holder || !reagent || !holder.reagents)
		return 0
	if ( machines_to_pump[holder] ) return 0
	machines_to_pump[holder] = reagent
	machines_queue_time[holder] = world.time + ARO_MAX_QUEUE_TIME
	hibernate = 0
	return 1







#undef ARO_BASEINPUT_GAS
#undef ARO_BASEOUTPUT_REAGENT
#undef ARO_MAX_QUEUE_TIME
