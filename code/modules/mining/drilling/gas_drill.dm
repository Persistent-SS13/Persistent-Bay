#define GAS_MINING_MULTIPLIER 10

/obj/machinery/mining/gas_drill
	name = "gas drill head"
	desc = "An enormous drill designed for extruding gas deposits from asteroids."
	icon_state = "gas_drill"
	circuit_type = /obj/item/weapon/circuitboard/gasdrill
	var/datum/gas_mixture/air_contents
	var/volume = 1000

	base_capacity = 2000 //moles

	var/gas_types = list(
		GAS_OXYGEN,
		GAS_HYDROGEN,
		GAS_PHORON,
		GAS_NITROGEN,
		GAS_CO2,
		GAS_N2O,
		// Fusion Fuel
		GAS_DEUTERIUM,
		GAS_TRITIUM,
		GAS_HELIUM,
		)

/obj/machinery/mining/gas_drill/New()
	..()
	ADD_SAVED_VAR(air_contents)

/obj/machinery/mining/gas_drill/SetupParts()
	. = ..()
	if(!air_contents)
		air_contents = new
		air_contents.volume = volume
		air_contents.temperature = T20C

/obj/machinery/mining/gas_drill/Destroy()
	QDEL_NULL(air_contents)
	. = ..()

/obj/machinery/mining/gas_drill/Process()

	if(need_player_check)
		return

	check_supports()

	if(!active) return

	if(!anchored || !use_cell_power())
		system_error("system configuration or charge error")
		return

	if(need_update_field)
		get_resource_field()

	if(world.time % 10 == 0)
		update_icon()

	if(!active)
		return

	//Drill through the flooring, if any.
	if(istype(get_turf(src), /turf/simulated/floor/asteroid))
		var/turf/simulated/floor/asteroid/T = get_turf(src)
		if(!T.dug)
			T.gets_dug()
	else if(istype(get_turf(src), /turf/simulated/floor/exoplanet))
		var/turf/simulated/floor/exoplanet/T = get_turf(src)
		if(T.diggable)
			new /obj/structure/pit(T)
			T.diggable = 0
	else if(istype(get_turf(src), /turf/simulated/floor))
		var/turf/simulated/floor/T = get_turf(src)
		T.ex_act(2.0)

	//Slurp up the gas.
	if(resource_field.len)
		var/turf/simulated/harvesting = pick(resource_field)

		while(resource_field.len && !harvesting.gas_resources)
			harvesting.has_gas_resources = 0
			harvesting.gas_resources = null
			resource_field -= harvesting
			if(resource_field.len)
				harvesting = pick(resource_field)

		if(!harvesting) return

		var/total_harvest = harvest_speed * GAS_MINING_MULTIPLIER //Gas mole harvest-per-tick.
		var/found_resource = 0 //If this doesn't get set, the area is depleted and the drill errors out.

		for(var/gas in gas_types)

			if(air_contents.total_moles >= capacity)
				system_error("insufficient storage space")
				active = 0
				need_player_check = 1
				update_icon()
				return

			if(air_contents.total_moles + total_harvest >= capacity)
				total_harvest = capacity - air_contents.total_moles

			if(total_harvest <= 0) break
			if(harvesting.gas_resources[gas])

				found_resource  = 1

				var/create_gas = 0
				if(harvesting.gas_resources[gas] >= total_harvest)
					harvesting.gas_resources[gas] -= total_harvest
					create_gas = total_harvest
					total_harvest = 0
				else
					total_harvest -= harvesting.gas_resources[gas]
					create_gas = harvesting.gas_resources[gas]
					harvesting.gas_resources[gas] = 0

				air_contents.adjust_gas(gas, create_gas, update = 1)

				switch(gas) // Numbers should be adjusted; for now this will ensure gas mining doesn't immediately flood the asteroid with monsters
					if(GAS_PHORON)
						SSasteroid.agitate(src, 5)
					if(GAS_TRITIUM)
						SSasteroid.agitate(src, 1)
					if(GAS_HYDROGEN)
						SSasteroid.agitate(src, 1)
					if(GAS_DEUTERIUM)
						SSasteroid.agitate(src, 1)
					if(GAS_OXYGEN)
						SSasteroid.agitate(src, 1)

		if(!found_resource)
			harvesting.has_gas_resources = 0
			harvesting.gas_resources = null
			resource_field -= harvesting
	else
		active = 0
		need_player_check = 1
		update_icon()

/obj/machinery/mining/gas_drill/verb/unload()
	set name = "Unload Gas Drill"
	set category = "Object"
	set src in oview(1)

	if(usr.stat) return

	var/obj/machinery/portable_atmospherics/canister/C = locate() in orange(1)
	if(C)
		C.air_contents.merge(air_contents)
		air_contents.gas.Cut()
		air_contents.update_values()
		to_chat(usr, "<span class='notice'>You unload the gas drill's pressure tank into the canister.</span>")
	else
		to_chat(usr, "<span class='notice'>You must move a canister up to the drill before you can unload it.</span>")

/obj/machinery/mining/gas_drill/update_icon()
	if(need_player_check)
		icon_state = "gas_drill_error"
	else if(active)
		icon_state = "gas_drill_active"
	else if(supported)
		icon_state = "gas_drill_braced"
	else
		icon_state = "gas_drill"
	return

/obj/machinery/mining/gas_drill/drop_contents()
	var/atom/location = src.loc
	location.assume_air(air_contents)

#undef GAS_MINING_MULTIPLIER