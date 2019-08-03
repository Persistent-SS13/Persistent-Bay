/obj/machinery/mining
	icon = 'icons/obj/mining_drill.dmi'
	anchored = 0
	use_power = POWER_USE_OFF //The drill takes power directly from a cell.
	density = 1
	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER //So it draws over mobs in the tile north of it.
	var/statu = 0

	var/braces_needed = 2
	var/list/supports = list()
	var/supported = 0
	var/base_power_usage = 10 KILOWATTS // Base power usage when the drill is running.
	var/actual_power_usage = 10 KILOWATTS // Actual power usage, with upgrades in mind.
	var/active = 0
	var/list/resource_field = list()
	max_health = 100
	var/stacks_needed = 0

	//Upgrades
	var/harvest_speed
	var/base_capacity
	var/capacity
	var/obj/item/weapon/cell/cell = null

	//Flags
	var/need_update_field = 0
	var/need_player_check = 0

	var/datum/world_faction/connected_faction
	var/saved_faction //We really shouldn't save a copy of a faction

/obj/machinery/mining/New()
	. = ..()
	ADD_SAVED_VAR(statu)
	ADD_SAVED_VAR(active)
	ADD_SAVED_VAR(cell)
	ADD_SAVED_VAR(saved_faction)

/obj/machinery/mining/before_save()
	. = ..()
	if(connected_faction)
		saved_faction = connected_faction.uid
/obj/machinery/mining/after_save()
	. = ..()
	saved_faction = null

/obj/machinery/mining/after_load()
	. = ..()
	if(saved_faction)
		connected_faction = get_faction(saved_faction)

/obj/machinery/mining/get_cell()
	return cell

/obj/machinery/mining/proc/drop_contents()
	return

/obj/machinery/mining/drill/can_connect(var/datum/world_faction/trying, var/mob/M)
	var/datum/machine_limits/limits = trying.get_limits()
	if(M && !has_access(list(core_access_machine_linking), list(), M.GetAccess(trying.uid)))
		to_chat(M, "You do not have access to link machines to [trying.name].")
		return 0
	if(limits.limit_drills <= limits.drills.len)
		if(M)
			to_chat(M, "[trying.name] cannot connect any more machines of this type.")
		return 0
	limits.drills |= src
	req_access_faction = trying.uid
	connected_faction = trying


/obj/machinery/mining/drill/can_disconnect(var/datum/world_faction/trying, var/mob/M)
	var/datum/machine_limits/limits = trying.get_limits()
	limits.drills -= src
	req_access_faction = ""
	connected_faction = null
	if(M) to_chat(M, "The machine has been disconnected.")


/obj/machinery/mining/attack_generic(var/mob/user, var/damage)
	health = max(0, health-damage)
	if(!health)
		drop_contents(loc)
		src.visible_message("<span class='notice'>\The [src] is smashed open and spills its contents everywhere!</span>")
		statu = 2
		active = 0
		need_player_check = 1
		stacks_needed = rand(5, 10)
		update_icon()
		if(istype(user, /mob/living/simple_animal/hostile))
			var/mob/living/simple_animal/hostile/attacker = user
			attacker.target_mob = null

/obj/machinery/mining/attackby(obj/item/O as obj, mob/user as mob)
	if(O.GetIdCard())			// trying to unlock the interface with an ID card
		if(!connected_faction)
			var/obj/item/weapon/card/id/id = O.GetIdCard()
			if(id)
				var/datum/world_faction/faction = get_faction(id.selected_faction)
				if(faction)
					can_connect(faction, user)
		else
			can_disconnect(connected_faction, user)
	if(statu == 2)
		if(stacks_needed && istype(O, /obj/item/stack/material) && O.get_material_name() == MATERIAL_STEEL)
			var/obj/item/stack/material/sheets = O
			if(sheets.amount >= stacks_needed)
				sheets.use(stacks_needed)
				stacks_needed = 0
			else
				stacks_needed -= sheets.amount
				sheets.use(sheets.amount)
		if(isWelder(O))
			if(stacks_needed)
				to_chat(user, "\The [src] still requires [stacks_needed] steel sheets to start the patch.")
				return
			var/obj/item/weapon/tool/weldingtool/WT = O
			if (WT.get_fuel() < 3)
				to_chat(user, "<span class='warning'>You need more welding fuel to complete this task.</span>")
				return
			user.visible_message("<span class='warning'>[user.name] patches [src].</span>", \
								"You start patching \the [src]...", \
								"You hear welding.")
			playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
			if(do_after(user, 50, src))
				if(!src || !WT.remove_fuel(3, user)) return
				health = 100
				statu = 0
				need_player_check = 0
				update_icon()
				return
	if(!active)
		if(default_deconstruction_screwdriver(user, O))
			return
		if(default_deconstruction_crowbar(user, O))
			return
		if(default_part_replacement(user, O))
			return
	if(!panel_open || active) return ..()

	if(istype(O, /obj/item/weapon/cell))
		if(cell)
			to_chat(user, "\The [src] already has a cell installed.")
		else
			user.drop_item()
			O.loc = src
			cell = O
			component_parts += O
			to_chat(user, "You install \the [O].")
		return
	..()

/obj/machinery/mining/attack_hand(mob/user as mob)
	check_supports()
	if (panel_open && cell && user.Adjacent(src))
		to_chat(user, "You take out \the [cell].")
		cell.loc = get_turf(user)
		component_parts -= cell
		cell = null
		return
	if(statu == 2)
		to_chat(user, "\The [src] is damaged and needs repair.")
		if(stacks_needed)
			to_chat(user, "Apply [stacks_needed] steel sheets and then weld the drill.")
		else
			to_chat(user, "Weld \the [src].")
		return
	else if(need_player_check)
		to_chat(user, "You hit the manual override and reset the drill's error checking.")
		need_player_check = 0
		if(anchored)
			get_resource_field()
		update_icon()
		return
	else if(supported && !panel_open)
		if(!connected_faction)
			to_chat(user,"<span class='notice'>\The [src] is not connected to a organization.</span>")
		if(use_cell_power())
			active = !active
			if(active)
				visible_message("<span class='notice'>\The [src] lurches downwards, grinding noisily.</span>")
				need_update_field = 1
			else
				visible_message("<span class='notice'>\The [src] shudders to a grinding halt.</span>")
		else
			to_chat(user, "<span class='notice'>\The [src] is unpowered.</span>")
	else
		to_chat(user, "<span class='notice'>Turning on a piece of industrial machinery without sufficient bracing or wires exposed is a bad idea.</span>")

	update_icon()

/obj/machinery/mining/RefreshParts()
	..()
	harvest_speed = 0
	capacity = 0
	var/charge_multiplier = 0

	for(var/obj/item/weapon/stock_parts/P in component_parts)
		if(istype(P, /obj/item/weapon/stock_parts/micro_laser))
			harvest_speed = P.rating
		if(istype(P, /obj/item/weapon/stock_parts/matter_bin))
			capacity = base_capacity * P.rating
		if(istype(P, /obj/item/weapon/stock_parts/capacitor))
			charge_multiplier += P.rating
	cell = locate(/obj/item/weapon/cell) in component_parts
	if(charge_multiplier)
		actual_power_usage = base_power_usage / charge_multiplier
	else
		actual_power_usage = base_power_usage

/obj/machinery/mining/proc/check_supports()

	supported = 0

	if((!supports || !supports.len) && initial(anchored) == 0)
		anchored = 0
		active = 0
	else
		anchored = 1

	if(supports && supports.len >= braces_needed)
		supported = 1

	update_icon()

/obj/machinery/mining/proc/system_error(var/error)

	if(error)
		src.visible_message("<span class='notice'>\The [src] flashes a '[error]' warning.</span>")
	need_player_check = 1
	active = 0
	update_icon()

/obj/machinery/mining/proc/get_resource_field()

	resource_field = list()
	need_update_field = 0

	var/turf/T = get_turf(src)
	if(!istype(T)) return

	var/tx = T.x - 2
	var/ty = T.y - 2
	var/turf/simulated/mine_turf
	for(var/iy = 0,iy < 5, iy++)
		for(var/ix = 0, ix < 5, ix++)
			mine_turf = locate(tx + ix, ty + iy, T.z)
			if(istype(mine_turf, /turf/simulated))
				if(mine_turf.has_resources || mine_turf.has_gas_resources)
					resource_field += mine_turf

	if(!resource_field.len)
		system_error("resources depleted")

/obj/machinery/mining/proc/use_cell_power()
	return cell && cell.checked_use(actual_power_usage * CELLRATE)

/obj/machinery/mining/drill
	name = "mining drill head"
	desc = "An enormous drill."
	icon_state = "mining_drill"
	circuit_type = /obj/item/weapon/circuitboard/miningdrill
	base_capacity = 200

	var/list/ore_types = list(
		MATERIAL_PITCHBLENDE,
		MATERIAL_PLATINUM,
		MATERIAL_HEMATITE,
		MATERIAL_GRAPHITE,
		MATERIAL_DIAMOND,
		MATERIAL_GOLD,
		MATERIAL_SILVER,
		MATERIAL_PHORON,
		MATERIAL_QUARTZ,
		MATERIAL_PYRITE,
		MATERIAL_SPODUMENE,
		MATERIAL_CINNABAR,
		MATERIAL_PHOSPHORITE,
		MATERIAL_ROCK_SALT,
		MATERIAL_POTASH,
		MATERIAL_BAUXITE,
		MATERIAL_TUNGSTEN,
		MATERIAL_SAND,
		MATERIAL_TETRAHEDRITE,
		MATERIAL_FREIBERGITE,
		MATERIAL_BSPACE_CRYSTAL,
		MATERIAL_ILMENITE,
		MATERIAL_GALENA,
		MATERIAL_CASSITERITE,
		MATERIAL_SPHALERITE,
		MATERIAL_HYDROGEN,
		MATERIAL_BORON,
		MATERIAL_ICES_ACETONE,
		MATERIAL_ICES_AMONIA,
		MATERIAL_ICES_CARBON_DIOXIDE,
		MATERIAL_ICES_HYDROGEN,
		MATERIAL_ICES_METHANE,
		MATERIAL_ICES_NITROGEN,
		MATERIAL_ICES_SULFUR_DIOXIDE,
		MATERIAL_ICES_WATER,
		)


/obj/machinery/mining/drill/drop_contents(var/location)
	for(var/obj/item/stack/ore/O in contents)
		O.forceMove(location) //Drop to stack fails for some reasons
		O.drop_to_stacks(location)

/obj/machinery/mining/drill/Process()

	if(need_player_check)
		return

	check_supports()

	if(!connected_faction)
		system_error("drill is not connected to an organization.")
		return
	if(!active) return

	if(!use_cell_power())
		system_error("drill is out of charge/battery error")
		return

	if(!anchored)
		system_error("drill is not anchored correctly.")
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

	//Dig out the tasty ores.
	if(resource_field.len)
		var/turf/simulated/harvesting = pick(resource_field)

		while(resource_field.len && !harvesting.resources)
			harvesting.has_resources = 0
			harvesting.resources = null
			resource_field -= harvesting
			if(resource_field.len)
				harvesting = pick(resource_field)

		if(!harvesting) return

		var/total_harvest = harvest_speed //Ore harvest-per-tick.
		var/found_resource = 0 //If this doesn't get set, the area is depleted and the drill errors out.
		var/list/random_ore_types = shuffle(ore_types.Copy())
		for(var/metal in random_ore_types)

			if(contents.len >= capacity)
				system_error("insufficient storage space")
				active = 0
				need_player_check = 1
				update_icon()
				return

			if(contents.len + total_harvest >= capacity)
				total_harvest = capacity - contents.len

			if(total_harvest <= 0) break
			if(harvesting.resources[metal])

				found_resource  = 1

				var/create_ore = 0
				if(harvesting.resources[metal] >= total_harvest)
					harvesting.resources[metal] -= total_harvest
					create_ore = total_harvest
					total_harvest = 0
				else
					total_harvest -= harvesting.resources[metal]
					create_ore = harvesting.resources[metal]
					harvesting.resources[metal] = 0

				for(var/i=1, i <= create_ore, i++)
					switch(metal)
						if(MATERIAL_PHORON)
							SSasteroid.agitate(src, 5)
						if(MATERIAL_BSPACE_CRYSTAL)
							SSasteroid.agitate(src, 25)
						if(MATERIAL_PLATINUM)
							SSasteroid.agitate(src, 0.25)
						if(MATERIAL_DIAMOND)
							SSasteroid.agitate(src, 0.25)
						if(MATERIAL_PITCHBLENDE)
							SSasteroid.agitate(src, 0.25)
						if(MATERIAL_GOLD)
							SSasteroid.agitate(src, 0.25)

					if(metal == MATERIAL_BSPACE_CRYSTAL)
						new /obj/item/bluespace_crystal(get_turf(src))
					else
						var/obj/item/stack/ore/st = new(src, metal)
						st.drop_to_stacks(src)

		if(!found_resource)
			harvesting.has_resources = 0
			harvesting.resources = null
			resource_field -= harvesting
	else
		active = 0
		need_player_check = 1
		update_icon()

/obj/machinery/mining/drill/on_update_icon()
	if(need_player_check)
		icon_state = "mining_drill_error"
	else if(active)
		icon_state = "mining_drill_active"
	else if(supported)
		icon_state = "mining_drill_braced"
	else
		icon_state = "mining_drill"
	return

/obj/machinery/mining/drill/verb/unload()
	set name = "Unload Drill"
	set category = "Object"
	set src in oview(1)

	if(usr.stat) return

	var/obj/structure/ore_box/B = locate() in orange(1)
	if(B)
		drop_contents(B)
		to_chat(usr, "<span class='notice'>You unload the drill's storage cache into the ore box.</span>")
	else
		to_chat(usr, "<span class='notice'>You must move an ore box up to the drill before you can unload it.</span>")

/obj/machinery/mining/brace
	name = "mining drill brace"
	desc = "A machinery brace for an industrial drill. It looks easily two feet thick."
	icon_state = "mining_brace"
	circuit_type = /obj/item/weapon/circuitboard/miningdrillbrace
	var/obj/machinery/mining/drill/connected

/obj/machinery/mining/brace/New()
	..()

/obj/machinery/mining/brace/after_load()
	. = ..()
	connect()

/obj/machinery/mining/brace/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(connected && connected.active)
		to_chat(user, "<span class='notice'>You can't work with the brace of a running drill!</span>")
		return

	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return

	if(isWrench(W))

		if(istype(get_turf(src), /turf/space))
			to_chat(user, "<span class='notice'>You can't anchor something to empty space. Idiot.</span>")
			return

		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
		to_chat(user, "<span class='notice'>You [anchored ? "un" : ""]anchor the brace.</span>")

		anchored = !anchored
		if(anchored)
			connect()
		else
			disconnect()

/obj/machinery/mining/brace/proc/connect()

	var/turf/T = get_step(get_turf(src), src.dir)
	if(T)
		for(var/thing in T.contents)
			if(istype(thing, /obj/machinery/mining/))
				connected = thing
				break

	if(!connected)
		return

	if(!connected.supports)
		connected.supports = list()

	icon_state = "mining_brace_active"

	connected.supports += src
	connected.check_supports()

/obj/machinery/mining/brace/proc/disconnect()

	if(!connected) return

	if(!connected.supports) connected.supports = list()

	icon_state = "mining_brace"

	connected.supports -= src
	connected.check_supports()
	connected = null

/obj/machinery/mining/brace/AltClick()
	rotate()
