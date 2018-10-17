/*  Any questions and suggestions, you can find me at github.com/ingles98 (aka Stigma).
	Code originally created for Persistent-SS13/Persistent-Bay.
	Feel free to credit back to us... Or don't :c
	Currently the code is pretty much spaget so i'd be really glad if you told me any changes you make or simple suggestions.

	TO-DO: Comment in all the changes and where this is applied.

	This proc has been moved from Chemistry-Holder.dm to here since it made more sense. */
/datum/reagents/proc/create_puddle(var/atom/target, var/amount = 1, var/multiplier = 1, var/copy = 0, var/force_solid = null)
	if (!target || amount < 3)
		return
	var/hasLiquid = 0
	for(var/datum/reagent/R in reagent_list)		//Checks if the current container has any liquid reagents
		if (R.reagent_state == LIQUID)
			hasLiquid = 1
	if(!hasLiquid && !force_solid)					//Otherwise we simply don't create a puddle out of SOLID only reagents
		return
	//The actual puddle creation below.
	if (!isturf(target))
		target = target.loc
	var/obj/effect/decal/cleanable/puddle_chem/P
	for (var/obj/effect/decal/cleanable/puddle_chem/puddle in target)
		P = puddle
		break
	if (!P)
		P = new /obj/effect/decal/cleanable/puddle_chem(target)

	trans_to(P, amount, multiplier, copy)
	P.update_neighbours()

	P.mix_with_neighbours()

/obj/effect/decal/cleanable/puddle_chem // -Stigma's proudly spagget code- puddle of chem reagents
	name = "puddle"
	desc = "Unclean chemistry, because SCIENCE!"
	gender = PLURAL
	density = 0
	anchored = 1
	light_range = 1

	icon = 'icons/effects/puddle_chem.dmi'
	icon_state = "def1"
	var/icon_def = "def1"
	var/icon_corner = "corner"
	var/icon_side = "side"
	var/icon_uni = "uni"
	var/icon_straight = "straight"
	var/icon_fill = "fill"
	var/high_volume = 0

	initialized = 0
	alpha = 255
	var/volume = 700
	var/divide_treshold = 150
	var/direc = (NORTH|SOUTH|EAST|WEST) //forces new lone puddles to have their icons updated once created
	var/old_direc = (NORTH|SOUTH|EAST|WEST) //prevents spaget code from running unnecessarily if we dont need to change icon states
	var/evaporation_treshold_high = 0.1
	var/evaporation_treshold_low = 0.02
	var/max_drain_dist = 2

	//timer for the drain attraction movement
	var/timer_delay = 5
	var/timer_last = 0

	//timer for state checking proccess
	var/statecheck_timer_delay = 5
	var/statecheck_timer_last = 0

	//timer for icon updating proccess
	var/icon_timer_delay = 5
	var/icon_timer_last = 0

	var/islooping = 0
	var/hibernate = 0
	var/mix_hibernate = 0
	var/active = 0

	var/last_hibernate = 0

	var/mark_icon_update = 0

/obj/effect/decal/cleanable/puddle_chem/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/decal/cleanable/puddle_chem/proc/destroy() //should probably just remove this shit outta here.
	islooping = 0
	qdel(src)

/obj/effect/decal/cleanable/puddle_chem/New()
	create_reagents(volume)
	var/icon/I = new(icon)
	if (reagents.total_volume > 60)
		alpha = 95 + (reagents.total_volume *(150))/reagents.maximum_volume
	else
		alpha = 10 + (reagents.total_volume *(85))/60
	icon = I
	icon_state = icon_def
	if (loc && loc.density == 1)
		icon_state = "wall1"
		alpha += 20
		divide_treshold = 60
		var/tempDir = get_dir(usr,loc)
		switch(tempDir)
			if (NORTHEAST || SOUTHEAST)
				tempDir = EAST
			if (NORTHWEST || SOUTHWEST)
				tempDir = WEST
		switch(tempDir)
			if(NORTH)
				I.Turn(rand(15,30) )
				if (prob(50))
					I.Flip(WEST)
			if(SOUTH)
				I.Turn(rand(15,30) )
				I.Flip(NORTH)
				if (prob(50))
					I.Flip(WEST)
			if(WEST)
				I.Turn(rand(15,30) )
				I.Turn(-90)
				if (prob(50))
					I.Flip(NORTH)
			if(EAST)
				I.Turn(rand(15,30) )
				I.Turn(-90)
				I.Flip(EAST)
				if (prob(50))
					I.Flip(NORTH)
		dir = tempDir
		icon = I
	qdel(I)
	START_PROCESSING(SSobj, src)

/obj/effect/decal/cleanable/puddle_chem/after_load()
	initialized = 0
	on_reagent_change()
	START_PROCESSING(SSobj, src)

/obj/effect/decal/cleanable/puddle_chem/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/decal/cleanable/puddle_chem/on_reagent_change()
	if (isnull(reagents) || reagents.total_volume < 3)
		update_neighbours()
		destroy()
		return
	if (reagents.total_volume >= divide_treshold)
		divide()
	update_icon()

/obj/effect/decal/cleanable/puddle_chem/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/mop))
		reagents.trans_to_obj(I, reagents.total_volume/4)

/obj/effect/decal/cleanable/puddle_chem/Cross(var/mob/living/O)
	if (!istype(O))
		return
	if(O.buckled || (O.m_intent == "walk" && prob(95) || prob(20) ) ) //95% chance of not slipping if walking, 20% chance of chance to not slip while running
		return
	O.slip("the [src.name]",4)

/obj/effect/decal/cleanable/puddle_chem/Crossed(var/mob/living/O) //the beauty of the puddles
	if(!istype(O))
		return
	if ( !O.lying ) //the mob is standing, just damage the feet
		var/targetPart = FEET
		var/havePart = 0
		var/blocked = 100
		for(var/obj/item/clothing/C in O.get_equipped_items())
			if(C.permeability_coefficient == 1 || !C.body_parts_covered)
				continue
			if(C.body_parts_covered & targetPart)
				havePart = 1
				blocked -= 100*C.permeability_coefficient
				break
		if (!havePart) blocked = 0 //sets to 0% of damage being blocked. Better get at least a rag to protect those feet
		if (blocked < 100)
			for(var/datum/reagent/current in reagents.reagent_list)
				var/amount = current.volume*0.30
				current.touch_target(O, amount, pick(BP_L_FOOT, BP_R_FOOT), blocked )
	if(O.lying) //the mob is lying, probably wants to sip on that puddle. Serve his drinks.
		if (!O.reagents || O.reagents.total_volume < reagents.total_volume -50)
			reagents.trans_to(O, reagents.total_volume *0.03)

/obj/effect/decal/cleanable/puddle_chem/update_icon()
	if (!reagents)
		return
	color = reagents.get_color()
	old_direc = direc
	direc = 0
	if (!high_volume && reagents.total_volume >= 170)
		initialized = 0
		high_volume = 1
	else if (high_volume && reagents.total_volume < 170)
		high_volume = 0
		initialized = 0
	if (reagents.total_volume > 60)
		alpha = 95 + (reagents.total_volume *(150))/reagents.maximum_volume
	else
		alpha = 10 + (reagents.total_volume *(85))/60
	for(var/direction in GLOB.cardinal)
		var/turf/T = get_step(src, direction)
		if(!T) continue
		if(T.density)
			direc |= direction
		for (var/obj/effect/decal/cleanable/puddle_chem/P in T)
			if (!P) continue
			if (!P.dir) continue
			direc |= direction
	if (direc == old_direc && initialized)
		return
	if (loc && loc.density == 1)
		alpha += 20
		icon_state = "wall1"
		return
	icon = 'icons/effects/puddle_chem.dmi'
	var/icon/I = new(icon)
	if (loc && loc.density == 1)
		icon = I
		icon_state = "wall1"
		var/tempDir = dir
		switch(tempDir)
			if (NORTHEAST || SOUTHEAST)
				tempDir = EAST
			if (NORTHWEST || SOUTHWEST)
				tempDir = WEST
		switch(tempDir)
			if(NORTH)
				I.Turn(rand(15,30) )
				if (prob(50))
					I.Flip(WEST)
			if(SOUTH)
				I.Turn(rand(15,30) )
				I.Flip(NORTH)
				if (prob(50))
					I.Flip(WEST)
			if(WEST)
				I.Turn(rand(15,30) )
				I.Turn(-90)
				if (prob(50))
					I.Flip(NORTH)
			if(EAST)
				I.Turn(rand(15,30) )
				I.Turn(-90)
				I.Flip(EAST)
				if (prob(50))
					I.Flip(NORTH)
		icon = I
		qdel(I)
		return

	var/ALLDIR = (NORTH|SOUTH|EAST|WEST)
	if (direc == 0)							//too much spaghetti  in here. There are probably better ways of doing this but fuck it
		icon_state = icon_def
	else if (direc == NORTHEAST)
		icon_state = icon_corner
	else if (direc == NORTHWEST)
		icon_state = icon_corner
		I.Flip(WEST)
	else if (direc == SOUTHWEST)
		icon_state = icon_corner
		I.Flip(WEST)
		I.Flip(SOUTH)
	else if (direc == SOUTHEAST)
		icon_state = icon_corner
		I.Flip(SOUTH)

	else if (direc == NORTH)
		icon_state = icon_uni
	else if (direc == SOUTH)
		icon_state = icon_uni
		I.Flip(SOUTH)
	else if (direc == EAST)
		icon_state = icon_uni
		I.Turn(90)
		I.Flip(NORTH)
	else if (direc == WEST)
		icon_state = icon_uni
		I.Turn(-90)

	else if (direc == (EAST|WEST) )
		icon_state = icon_straight
		I.Turn(pick(-90,90))
	else if (direc == (NORTH|SOUTH) )
		icon_state = icon_straight
		if (prob(50))
			I.Flip(NORTH)

	else if (direc == ALLDIR - WEST)
		icon_state = icon_side
		if (prob(50))
			I.Flip(NORTH)
	else if (direc == ALLDIR - EAST)
		icon_state = icon_side
		I.Flip(EAST)
		if (prob(50))
			I.Flip(NORTH)
	else if (direc == ALLDIR - NORTH)
		icon_state = icon_side
		I.Turn(90)
		if (prob(50))
			I.Flip(EAST)
	else if (direc == ALLDIR - SOUTH)
		icon_state = icon_side
		I.Turn(-90)
		if (prob(50))
			I.Flip(EAST)

	else if (direc == ALLDIR )
		icon_state = icon_fill
		if (prob(50))
			I.Flip(NORTH)
		if (prob(50))
			I.Flip(EAST)
	else
		icon_state = icon_def
		if (prob(50))
			I.Flip(NORTH)
		if (prob(50))
			I.Flip(EAST)


	if (reagents.total_volume >= 170)
		icon_state += "_hv"
	icon = I
	if (!initialized)
		initialized = 1

/obj/effect/decal/cleanable/puddle_chem/proc/divide() //increases in size by creating a new puddle on a non-dense turf with half the current volume. Should only happen if the total reagent volume gets too much
	var/list/sides = new ()
	for(var/direction in GLOB.cardinal)
		var/turf/T = get_step(src, direction)
		var/dense = 0
		if(!T || T.density) continue
		for (var/obj/OBJ in T)
			if (OBJ.density)
				dense = 1
				break
		if (dense) continue
		var/filled  = 0
		for (var/obj/effect/decal/cleanable/puddle_chem/PUDDLE in T)
			if (PUDDLE.reagents.total_volume + reagents.total_volume/2 > PUDDLE.divide_treshold)
				filled = 1
				break
		if (filled) continue
		sides.Add(T)

	if (sides.len < 1)
		return
	var/turf/target = pick(sides)
	reagents.create_puddle(target, reagents.total_volume/2)

/obj/effect/decal/cleanable/puddle_chem/proc/update_neighbours()
	for(var/direction in GLOB.cardinal)
		var/turf/T = get_step(src, direction)
		if(!T) continue
		for (var/obj/effect/decal/cleanable/puddle_chem/P in T)
			P.update_icon()

/obj/effect/decal/cleanable/puddle_chem/Process() //this loop is meant to repeatedly try to proc touch() whatever the hell is in the puddle and to also perform a few checks
	if (hibernate) return 0
	if (isnull(reagents) || reagents.total_volume < 2) // random low capacity number to simply not matter the existence of a puddle
		destroy()
		return 0

	active = 0

	//handles events of the effects of the reagents on Mobs/Objs/Turfs
	for (var/atom/O in loc)
		if (ismob(O))	//Either only touches the mob, or else it transfers some contents to the object that is currently in the puddle
			Crossed(O) //keep harrassing that mob who thinks he can chill on sulphoric acid
			active = 1
		else if (!istype(O, /obj/effect/decal/cleanable/puddle_chem) )  //We don't want it to interact with a second puddle on the same turf as it may lead to issues since we're already merging the new puddle with the old one, but that does not happen entirely instantly
			if ( O.is_open_container() && O.reagents.total_volume < reagents.maximum_volume/250 )
				reagents.trans_to(O, reagents.total_volume*0.02 ) //Transfers some of the contents to open containers on the ground SLOWLY and up to a low ammount.
			else if(!O.is_open_container() && !istype(O,/obj/machinery/shower) )
				reagents.trans_to(O, reagents.total_volume*0.05 ) //molests whatever object or turf that is on the puddle (or whatever the puddle is on). It transfers 5% of the currect contents of the puddle. It might be absolutely aborved by whatever the atom on it is, but will probably only proc touch reactions
	//handles basic liquid physics/interactions between neighbouring puddles
	mix_with_neighbours()

	//handles movement to drain
	process_drain_attraction()

	//handles evaporation
	process_evaporation()

	//updates icon. only from time to time, and if something marks it for update during the Process()
	if (world.time - icon_timer_last >= icon_timer_delay)
		mark_icon_update = 1
		icon_timer_last = world.time
	if (mark_icon_update)	update_icon()
	mark_icon_update = 0
	if(!active)
		hibernate = 1
		var/min_timer = 10
		var/max_timer = 30
		if (last_hibernate) //punish those puddles in case they weren't active again
			min_timer = max_timer
			max_timer = 50
		spawn(rand(min_timer, max_timer))
			hibernate = 0
			last_hibernate = 1
	else
		last_hibernate = 0

/obj/effect/decal/cleanable/puddle_chem/proc/mix_with_neighbours()
	if (!reagents || mix_hibernate)
		return
	mix_hibernate = 1 // skips the mixing process for some ticks (200 to 700 miliseconds)
	spawn( rand(0,5) ) mix_hibernate = 0

	var/list/shuffledCardinal = shuffle(GLOB.cardinal)
	for(var/direction in shuffledCardinal)	//finds the puddle's equal neighbours and mixes a lil(10%) bit with each of them (a maximum of 5% of the initial solution will be lost to the neighbours, which then is retrieved as a mixed solution of those neighbours)
		var/turf/T = get_step(src, direction)
		if(!T) continue
		for (var/obj/effect/decal/cleanable/puddle_chem/neighbour in T)
			var/multiplier = 1
			if (!reagents) //sometimes we just seize to exist without noticing.
				break
			if (reagents.total_volume <= 10 && neighbour.reagents.total_volume > reagents.total_volume)
				if(!reagents) // and sometimes we need to recheck if we didn't seize to exist, again. (trust me, it happens...)
					break
				else if(!neighbour || !neighbour.reagents) //Those around us might not still be there in a blink of an eye. We never know. Embrace them while you can.
					continue
				reagents.trans_to(neighbour, 15) //we give ourselves to the bigger one, we simply give up existing for the greater good.
				break
			if ( abs(reagents.total_volume - neighbour.reagents.total_volume) < reagents.total_volume*0.05) //stop flickering if there is only 5% difference
				continue
			if ( abs(reagents.total_volume - neighbour.reagents.total_volume) < reagents.total_volume*0.11) // flickering needs to stop somehow. hacky all the way until one day i polish this until it shines brighter than the sun.
				if (reagents.total_volume > neighbour.reagents.total_volume)
					reagents.trans_to(neighbour, abs(reagents.total_volume - neighbour.reagents.total_volume))
				else
					neighbour.reagents.trans_to(src, abs(reagents.total_volume - neighbour.reagents.total_volume))
				continue
			var/amountMixed = reagents.total_volume*0.1 //hardcoded numbers!
			if (reagents.total_volume > neighbour.reagents.total_volume) //badly simulates higher-pressure-to-lower movement of the volumes
				multiplier = reagents.total_volume/neighbour.reagents.total_volume
			if(!reagents)
				break
			else if(!neighbour || !neighbour.reagents)
				continue
			reagents.trans_to(neighbour, amountMixed*multiplier)
			active = 1
			spawn(2) // need to stop with the spawns but I guess making a proc to queue these events won't do any better will it
				if (!neighbour || !neighbour.reagents || !src || !amountMixed)
					break
				mark_icon_update = 1
				neighbour.reagents.trans_to(src, amountMixed) //just imagine a little wave of splash going out and then coming back in with mixed reagents.

/obj/effect/decal/cleanable/puddle_chem/proc/process_evaporation()
	if (reagents && reagents.reagent_list && world.time - statecheck_timer_last >= statecheck_timer_delay)
		statecheck_timer_last = world.time

		var/turf/T = loc
		if (!T || !T.air)	return -1 //happens on server init.

		var/datum/gas_mixture/air_data = T.return_air()

		for(var/datum/reagent/R in reagents.reagent_list)

			var/xgm_id = lowertext(R.name)
			if(!xgm_id in gas_data.gases)
				continue

			var/possible_transfers = R.volume*0.1
			if (!possible_transfers || possible_transfers < 0.1)
				continue

			var/boilPoint = gas_data.base_boil_point[xgm_id]+(BOIL_PRESSURE_MULTIPLIER*(air_data.return_pressure() - ONE_ATMOSPHERE))
			//if(xgm_id == "oxygen")
				//message_admins("boilpoint: [boilPoint] base: [gas_data.base_boil_point[xgm_id]] pressure_delta: [air_data.return_pressure() - ONE_ATMOSPHERE] current_air_temp: [air_data.temperature]")
			if (air_data.temperature > boilPoint*1.0009) //101% for preventing flickering between states
				reagents.remove_reagent(R.type, possible_transfers)
				//var/datum/gas_mixture/GM = new (_temperature = air_data.temperature)
				//GM.gas[xgm_id] = possible_transfers/REAGENT_GAS_EXCHANGE_FACTOR
				air_data.adjust_gas(xgm_id, possible_transfers/REAGENT_GAS_EXCHANGE_FACTOR, update=0)
				//air_data.merge(GM)
				active = 1

		air_data.update_values()

/obj/effect/decal/cleanable/puddle_chem/proc/process_drain_attraction()
	if (reagents && reagents.reagent_list && world.time - timer_last >= timer_delay)
		timer_last = world.time
		var/at_drain
		for (var/obj/machinery/atmospherics/unary/drain/D in loc)
			at_drain = D
		if (!at_drain)
			var/list/possible_drains = new/list()
			for (var/obj/machinery/atmospherics/unary/drain/D in oview(max_drain_dist,src))
				if (get_dist(src, D) > max_drain_dist )
					return
				possible_drains |= D
				if (possible_drains.len == 1)
					continue
				if (get_dist(src, D) < get_dist(src, possible_drains[1]) )
					possible_drains.Swap(possible_drains[1], possible_drains[possible_drains.len])
			if (possible_drains.len)
				active = 1
				var/obj/effect/decal/cleanable/dummy = new /obj/effect/decal/cleanable(loc)
				var/contains_puddle
				step_to(dummy, possible_drains[1])
				for (var/obj/effect/decal/cleanable/puddle_chem/puddle in dummy.loc)
					contains_puddle = 1
					break
				if (!contains_puddle)
					step_to(src, possible_drains[1])
				qdel(dummy)
