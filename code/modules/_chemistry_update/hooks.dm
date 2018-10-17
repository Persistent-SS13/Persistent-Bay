#define ZONE_CONDENSATION_DELAY		15	//How often does a zone process condensation checks

/var/global/datum/state_of_matter/state_of_matter = new()

/datum/state_of_matter/
	var/can_condense = 1 //Whether the next condensation checks will be ran (setting to 0 prevents any condensation)

/*-------------------------------------------------------------------------------------------------------------------------------
				The Condesation mechanisms

General condensation for vents, canisters, dpvent and injectors only. Should be merged into the main condensation proc tho.*/
/proc/condense_before_pump(var/obj/machinery/source, var/datum/gas_mixture/air_contents, var/transfer_moles = 0) // checks for liquid/solid state reagents before pumping them out from the canisters/vents
	if (!transfer_moles)
		return 0
	if (!state_of_matter.can_condense)
		return transfer_moles
	var/turf/local = source.loc
	if (!isturf(local))
		local = get_turf(local)

	var/datum/gas_mixture/environment = local.return_air()

	var/air_initial_moles = air_contents.total_moles //Its as if we're grabbing all those moles at the same time, not prioritizing gases over others
	var/update_values = 0

	for(var/gas in air_contents.gas)
		if ( !gas_data.dense_product[gas] )
			continue
		var/reagent_type = gas_data.dense_product[gas]

		var/base_boil_point = gas_data.base_boil_point[gas]
		var/boilPoint = base_boil_point+(BOIL_PRESSURE_MULTIPLIER*(environment.return_pressure() - ONE_ATMOSPHERE))

		var/possible_transfers = transfer_moles * (air_contents.gas[gas]/air_initial_moles) //original transfer_moles multiplied by the ratio of the gas
		if(!possible_transfers) //If we're out of gas boi. Shouldn't probably happen to be honest as the gas should be removed from the list
			continue //Doesnt mean we shouldn't prevent condensating non existent gas anyways so fuck it.

		if (air_contents.temperature < boilPoint *0.9991) //99% just to make it so fluids dont flicker between states
			var/obj/effect/decal/cleanable/puddle_chem/R_HOLDER
			var/has_puddle = 0
			for (var/obj/effect/decal/cleanable/puddle_chem/puddle in local.contents)
				has_puddle += 1
				if(puddle.reagents.total_volume + possible_transfers*REAGENT_GAS_EXCHANGE_FACTOR <= puddle.reagents.maximum_volume )
					R_HOLDER = puddle
				break

			if (has_puddle && !R_HOLDER)
				continue // skip, the tile is full.
			if (!has_puddle)
				R_HOLDER = new(local)

			air_contents.adjust_gas(gas, -possible_transfers, update=0) //Removes from gas from the atmosphere. Doesn't work on farts doe you gotta vent the place.
			R_HOLDER.reagents.add_reagent(reagent_type, possible_transfers*REAGENT_GAS_EXCHANGE_FACTOR)
			transfer_moles -= possible_transfers
			update_values = 1

	if (update_values)
		air_contents.update_values()
	return transfer_moles
//The actual condensation from atmosphere.
// Yet another spaget by Stigma. This code is run everytime air suffers changes.
// At the same time we might as well just check for any needs of condesating (? english)
// TO-DO : Perhaps polish it a bit if it starts to lag
/zone/proc/condensation_check()
	if (!state_of_matter.can_condense)
		return -1
	if (world.time < condense_buffer)
		return
	condense_buffer = world.time + ZONE_CONDENSATION_DELAY
	var/datum/gas_mixture/air_data = air //So i was sleepy and I decided not to change every "air_data" back to just air
	if(air_data)
		var/update_values = 0
		var/turf/location = pick(contents)
		if(!isturf(location)) //should already be a turf but double check tho cuz weird shit happened on testing
			location = pick(location.contents)

		for(var/gas in air_data.gas)
			if ( !gas_data.dense_product[gas] )
				continue
			var/reagent_type = gas_data.dense_product[gas]

			var/base_boil_point = gas_data.base_boil_point[gas]
			var/boilPoint = base_boil_point+(BOIL_PRESSURE_MULTIPLIER*(air_data.return_pressure() - ONE_ATMOSPHERE))

			var/possible_transfers = air_data.get_gas(gas)/3
			if(!possible_transfers) //If we're out of gas boi. Shouldn't probably happen to be honest as the gas should be removed from the list
				continue //Doesnt mean we shouldn't prevent condensating non existent gas anyways so fuck it.

			if (air_data.temperature < boilPoint *0.9991) //99% just to make it so fluids dont flicker between states
				var/obj/effect/decal/cleanable/puddle_chem/R_HOLDER = new(location) // game / objects / effects / chem / chempuddle.dm - Its basically liquid state substance.
				R_HOLDER.reagents.add_reagent(reagent_type, possible_transfers*REAGENT_GAS_EXCHANGE_FACTOR) // Get those sweet gas reagents back to liquid state by creating em on the puddlez
				air_data.adjust_gas(gas, -possible_transfers, update=0) //Removes from gas from the atmosphere. Doesn't work on farts doe you gotta vent the place.
				update_values = 1

		if (update_values)
			air_data.update_values()

/*-------------------------------------------------------------------------------------------------------------------------------
				The Area Reagent Outlet mechanisms

General condensation for vents, canisters, dpvent and injectors only. Should be merged into the main condensation proc tho.*/

/area/proc/get_aro() // Is it needed tbh?
	return aro

/atom/proc/aro_pump_request() // The general request proc. No default set as everything should have an actual different behaviour
	return null

/atom/proc/aro_pump_receive(var/type, var/amount) // The receive behaviour. No matter how it is set, ARO expects the amount transfered to actually be returned.
	if (!reagents) return 0
	amount = min(amount, reagents.get_free_space())
	reagents.add_reagent(type, amount)
	return amount
