/*

Overview:
	Each zone is a self-contained area where gas values would be the same if tile-based equalization were run indefinitely.
	If you're unfamiliar with ZAS, FEA's air groups would have similar functionality if they didn't break in a stiff breeze.

Class Vars:
	name - A name of the format "Zone [#]", used for debugging.
	invalid - True if the zone has been erased and is no longer eligible for processing.
	needs_update - True if the zone has been added to the update list.
	edges - A list of edges that connect to this zone.
	air - The gas mixture that any turfs in this zone will return. Values are per-tile with a group multiplier.

Class Procs:
	add(turf/simulated/T)
		Adds a turf to the contents, sets its zone and merges its air.

	remove(turf/simulated/T)
		Removes a turf, sets its zone to null and erases any gas graphics.
		Invalidates the zone if it has no more tiles.

	c_merge(zone/into)
		Invalidates this zone and adds all its former contents to into.

	c_invalidate()
		Marks this zone as invalid and removes it from processing.

	rebuild()
		Invalidates the zone and marks all its former tiles for updates.

	add_tile_air(turf/simulated/T)
		Adds the air contained in T.air to the zone's air supply. Called when adding a turf.

	tick()
		Called only when the gas content is changed. Archives values and changes gas graphics.

	dbg_data(mob/M)
		Sends M a printout of important figures for the zone.

*/


/zone/var/name
/zone/var/invalid = 0
/zone/var/list/contents = list()
/zone/var/list/fire_tiles = list()
/zone/var/list/fuel_objs = list()

/zone/var/needs_update = 0
/zone/var/condense_buffer = 0

/zone/var/list/edges = list()

/zone/var/datum/gas_mixture/air = new

/zone/var/list/graphic_add = list()
/zone/var/list/graphic_remove = list()
/zone/var/invalid_for = 0
/zone/var/list/turf_coords = list() // used for save/loading zones :V
/zone/New()
	SSair.add_zone(src)
	air.temperature = TCMB
	air.group_multiplier = 1
	air.volume = CELL_VOLUME

/zone/proc/add(turf/simulated/T)
#ifdef ZASDBG
	ASSERT(!invalid)
	ASSERT(istype(T))
	ASSERT(!SSair.has_valid_zone(T))
#endif

	var/datum/gas_mixture/turf_air = T.return_air()
	add_tile_air(turf_air)
	T.zone = src
	contents.Add(T)
	if(T.fire)
		var/obj/effect/decal/cleanable/liquid_fuel/fuel = locate() in T
		fire_tiles.Add(T)
		SSair.active_fire_zones |= src
		if(fuel) fuel_objs += fuel
	T.update_graphic(air.graphic)

/zone/proc/remove(turf/simulated/T)
#ifdef ZASDBG
	ASSERT(!invalid)
	ASSERT(istype(T))
	ASSERT(T.zone == src)
	soft_assert(T in contents, "Lists are weird broseph")
#endif
	contents.Remove(T)
	fire_tiles.Remove(T)
	if(T.fire)
		var/obj/effect/decal/cleanable/liquid_fuel/fuel = locate() in T
		fuel_objs -= fuel
	T.zone = null
	T.update_graphic(graphic_remove = air.graphic)
	if(contents.len)
		air.group_multiplier = contents.len
	else
		c_invalidate()

/zone/proc/c_merge(zone/into)
#ifdef ZASDBG
	ASSERT(!invalid)
	ASSERT(istype(into))
	ASSERT(into != src)
	ASSERT(!into.invalid)
#endif
	c_invalidate()
	for(var/turf/simulated/T in contents)
		into.add(T)
		T.update_graphic(graphic_remove = air.graphic)
		#ifdef ZASDBG
		T.dbg(merged)
		#endif

	//rebuild the old zone's edges so that they will be possessed by the new zone
	for(var/connection_edge/E in edges)
		if(E.contains_zone(into))
			continue //don't need to rebuild this edge
		for(var/turf/T in E.connecting_turfs)
			SSair.mark_for_update(T)

/zone/proc/c_invalidate()
	invalid = 1
	SSair.remove_zone(src)
	#ifdef ZASDBG
	for(var/turf/simulated/T in contents)
		T.dbg(invalid_zone)
	#endif
/zone/proc/rebuild()
	c_invalidate()
	for(var/turf/simulated/T in contents)
		T.update_graphic(graphic_remove = air.graphic) //we need to remove the overlays so they're not doubled when the zone is rebuilt
		//T.dbg(invalid_zone)
		T.needs_air_update = 0 //Reset the marker so that it will be added to the list.
		SSair.mark_for_update(T)

/zone/proc/add_tile_air(datum/gas_mixture/tile_air)
	//air.volume += CELL_VOLUME
	air.group_multiplier = 1
	air.multiply(contents.len)
	air.merge(tile_air)
	air.divide(contents.len+1)
	air.group_multiplier = contents.len+1

/zone/proc/tick()
	if(invalid)
		invalid_for++
		if(invalid_for > 10)
			invalid = 0
			rebuild()
	if(air.temperature >= PHORON_FLASHPOINT && !(src in SSair.active_fire_zones) && air.check_combustability() && contents.len)
		var/turf/T = pick(contents)
		if(istype(T))
			T.create_fire(vsc.fire_firelevel_multiplier)

	if(air.check_tile_graphic(graphic_add, graphic_remove))
		for(var/turf/simulated/T in contents)
			T.update_graphic(graphic_add, graphic_remove)
		graphic_add.len = 0
		graphic_remove.len = 0

	for(var/connection_edge/E in edges)
		if(E.sleeping)
			E.recheck()
	condensation_check()

// Yet another spaget by Stigma. This code is run everytime air suffers changes.
// At the same time we might as well just check for any needs of condesating (? english)
// TO-DO : Perhaps polish it a bit if it starts to lag
/zone/proc/condensation_check()
	if (world.time < condense_buffer)
		return
	condense_buffer = world.time + 15 // 1.5 seconds between condensing
	var/datum/gas_mixture/air_data = air //So i was sleepy and I decided not to change every "air_data" back to just air
	if(air_data)
		var/turf/location = pick(contents)
		if(!isturf(location)) //should already be a turf but double check tho cuz weird shit happened on testing
			location = pick(location.contents)
		for(var/gas in air_data.gas)
			if(!gas_data.component_reagents[gas])
				continue	//we don't need to (nor we can) proceed if the gas wasn't made out of a 'known' reagent.

			var/list/component_reagents = gas_data.component_reagents[gas]

			var/possible_transfers = air_data.get_gas(gas)
			if(!possible_transfers) //If we're out of gas boi. Shouldn't probably happen to be honest as the gas should be removed from the list
				break //Doesnt mean we shouldn't prevent condensating non existent gas anyways so fuck it.

			for(var/R in component_reagents)
				var/datum/reagent/reagent_data = new R() //hacky
				var/base_boil_point = reagent_data.base_boil_point
				var/boilPoint = base_boil_point+(BOIL_PRESSURE_MULTIPLIER*(air_data.return_pressure() - ONE_ATMOSPHERE))
				if (air_data.temperature < boilPoint *0.99) //99% just to make it so fluids dont flicker between states
					//START CONDENSATION PROCESS
					var/obj/effect/decal/cleanable/puddle_chem/R_HOLDER = new(location) // game / objects / effects / chem / chempuddle.dm - Its basically liquid state substance.
					R_HOLDER.reagents.add_reagent(R, possible_transfers*component_reagents[R]*REAGENT_GAS_EXCHANGE_FACTOR) // Get those sweet gas reagents back to liquid state by creating em on the puddlez
					air_data.adjust_gas(gas, -possible_transfers, 1) //Removes from gas from the atmosphere. Doesn't work on farts doe you gotta vent the place.
				qdel(reagent_data)


/zone/proc/dbg_data(mob/M)
	to_chat(M, name)
	for(var/g in air.gas)
		to_chat(M, "[gas_data.name[g]]: [air.gas[g]]")
	to_chat(M, "P: [air.return_pressure()] kPa V: [air.volume]L T: [air.temperature]°K ([air.temperature - T0C]°C)")
	to_chat(M, "O2 per N2: [(air.gas["nitrogen"] ? air.gas["oxygen"]/air.gas["nitrogen"] : "N/A")] Moles: [air.total_moles]")
	to_chat(M, "Simulated: [contents.len] ([air.group_multiplier])")
//	to_chat(M, "Unsimulated: [unsimulated_contents.len]")
//	to_chat(M, "Edges: [edges.len]")
	if(invalid) to_chat(M, "Invalid!")
	var/zone_edges = 0
	var/space_edges = 0
	var/space_coefficient = 0
	for(var/connection_edge/E in edges)
		if(E.type == /connection_edge/zone) zone_edges++
		else
			space_edges++
			space_coefficient += E.coefficient
			to_chat(M, "[E:air:return_pressure()]kPa")

	to_chat(M, "Zone Edges: [zone_edges]")
	to_chat(M, "Space Edges: [space_edges] ([space_coefficient] connections)")

	//for(var/turf/T in unsimulated_contents)
//		to_chat(M, "[T] at ([T.x],[T.y])")
