GLOBAL_LIST_EMPTY(maze_map_data)

#define ZLEVEL_INACTIVE		0	//Inactive - Dont process nor spawn any mobs
#define ZLEVEL_DORMANT		1	//Dormant - It is still active, but it no longer spawns mobs (Failed one check)
#define ZLEVEL_ACTIVE		2	//Active - This zlevel currently has players in it.
#define ZLEVELDATA_MONSTER_HEALTH_MULT_PER_DIFFICULTY	0.05
#define ZLEVELDATA_MONSTER_DAMAGE_MULT_PER_DIFFICULTY	0.04

/obj/structure/transition_barrier
	name = "bluespace barrier"
	desc = "These barriers split the regions of the nexus quadrant into a maze."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldwall"
	density = 0
	anchored = 1
	dir = NORTH
	should_save = 0


/datum/zlevel_data
	var/z // which z this datum controls

	var/N_connect // these control
	var/W_connect // which zlevel is accessed
	var/E_connect // by traveling in
	var/S_connect // the correspodning direction

	var/state = ZLEVEL_INACTIVE //Used to check whether this zlevel is worth processing at all
	var/difficulty = 1 // used for exploration/base establishment objectives

	var/list/monster_types = list(/mob/living/simple_animal/hostile/carp) // types of monsters that will occur on this map.
	var/monster_quantity = 5 // and how many will occur/respawn
	var/list/obj_types = list(/obj/structure/cryo_crate)
	var/obj_quantity = 5

	var/list/current_monsters = list()
	var/list/current_obj = list()
	var/list/despawning = list()

	var/coord = "(0,0)"
	var/name = "Nexus"
	var/last_occupied = 0

/datum/zlevel_data/proc/update()
	if (isWild())
		replenish_monsters()
		replenish_obj()

/datum/zlevel_data/proc/spawn_monster(var/turf/location, var/monster_type, var/diff = difficulty)
	if (!location || !monster_type || !diff)
		return 0
	if(diff > 1)
		diff = rand(1, diff)
	var/mob/living/simple_animal/monster = new monster_type(location)
	var/mult_health = 1 + (diff == 1 ? 0 : diff) * ZLEVELDATA_MONSTER_HEALTH_MULT_PER_DIFFICULTY
	var/mult_damage = 1 + (diff == 1 ? 0 : diff) * ZLEVELDATA_MONSTER_DAMAGE_MULT_PER_DIFFICULTY
	monster.maxHealth = ceil(monster.maxHealth * mult_health)
	monster.health = monster.maxHealth
	monster.melee_damage_lower = ceil(monster.melee_damage_lower * mult_damage)
	monster.melee_damage_upper = ceil(monster.melee_damage_upper * mult_damage)

	current_monsters |= monster
	monster.faction = "spawned"
	var/matrix/M = matrix()
	if(diff > 1)
		M.Scale(1+(0.2*diff)-0.2)
	monster.transform = M

/datum/zlevel_data/proc/replenish_monsters()
	if(current_monsters.len < monster_quantity)
		var/difference = monster_quantity - current_monsters.len
		for(var/i = 1 to difference)
			var/turf/T = locate(rand(TRANSITIONEDGE, world.maxx - TRANSITIONEDGE - 1),rand(TRANSITIONEDGE, world.maxy - TRANSITIONEDGE - 1),z)
			if(!istype(T, /turf/space)) continue
			var/monster_type = pick(monster_types)
			spawn_monster(T,monster_type)

/datum/zlevel_data/proc/isWild()
	if (difficulty == 0)
		return FALSE
	else
		return TRUE

/datum/zlevel_data/proc/check_occupied()
	for(var/mob/M in SSmobs.mob_list)
		if(M.key && M.z == z)
			last_occupied = world.time
			return 1

/datum/zlevel_data/proc/lower_state()
	if (state == ZLEVEL_INACTIVE)
		return 0
	else if (state == ZLEVEL_ACTIVE)
		set_state(ZLEVEL_DORMANT)
	else
		set_state(ZLEVEL_INACTIVE)
	return 1

/datum/zlevel_data/proc/set_active()
	set_state(ZLEVEL_ACTIVE)
	return 1

/datum/zlevel_data/proc/set_state(var/target_state)
	if (target_state == state)
		return 0
	else if (target_state == ZLEVEL_ACTIVE && state == ZLEVEL_INACTIVE) //Need to spawn dem bois
		on_active()
	else if (target_state == ZLEVEL_INACTIVE)
		on_inactive()
	state = target_state
	return 1

/datum/zlevel_data/proc/on_inactive()
	for(var/mob/m in current_monsters)
		STOP_PROCESSING(SSmobs, m)
	for(var/obj/structure/cryo_crate/O in current_obj) //Despawn unsealed abandoned crates
		if(O.sealed == FALSE)
			current_obj -= O
			qdel(O)

/datum/zlevel_data/proc/on_active()
	if (!isWild())
		return
	for(var/mob/m in current_monsters)
		START_PROCESSING(SSmobs, m)
	replenish_monsters()
	replenish_obj()

//////////////////////////////////////////////////////////////////////////////////////////
//Object Spawns///////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

/datum/zlevel_data/proc/spawn_obj(var/turf/location, var/obj_type)
	if (!location || !obj_type)
		return 0
	var/obj/o = new obj_type(location)
	current_obj |= o

/datum/zlevel_data/proc/replenish_obj()
	if(current_obj.len < obj_quantity)
		var/o_difference = obj_quantity - current_obj.len
		for(var/i = 1 to o_difference)
			var/turf/E = locate(rand(TRANSITIONEDGE, world.maxx - TRANSITIONEDGE - 1),rand(TRANSITIONEDGE, world.maxy - TRANSITIONEDGE - 1),z)
			if(!istype(E, /turf/space)) continue
			var/obj_type = pick(obj_types)
			spawn_obj(E,obj_type)


//////////////////////////////////////////////////////////////////////////////////////////
/datum/zlevel_data/one
	z = 1
	difficulty = 0
	N_connect = 4

/datum/zlevel_data/two
	z = 2
	difficulty = 0

/datum/zlevel_data/three
	z = 3
	difficulty = 0

/datum/zlevel_data/four
	z = 4
	coord = "(0,1)"
	name = "Due North"
	S_connect = 1
	N_connect = 5
	monster_types = list(
		/mob/living/simple_animal/hostile/carp,
		) // types of monsters that will occur on this map.
	monster_quantity = 25 // and how many will occur/respawn
	obj_quantity = 0
	difficulty = 2

/datum/zlevel_data/five
	z = 5
	coord = "(0,2)"
	name = "Julian's Corner"
	S_connect = 4
	W_connect = 6
	monster_types = list(
		/mob/living/simple_animal/hostile/carp, 
		/mob/living/simple_animal/hostile/carp/pike, 
		/mob/living/simple_animal/hostile/scarybat,
		/mob/living/simple_animal/hostile/bear,
		) // types of monsters that will occur on this map.
	monster_quantity = 75 // and how many will occur/respawn
	obj_types = list(/obj/structure/cryo_crate)
	obj_quantity = 1
	difficulty = 4

/datum/zlevel_data/six
	z = 6
	coord = "(-1,2)"
	name = "Ambition's Toll"
	E_connect = 5
	W_connect = 7
	monster_types = list(
		/mob/living/simple_animal/hostile/tormented, 
		/mob/living/simple_animal/hostile/voxslug, 
		/mob/living/simple_animal/hostile/scarybat, 
		/mob/living/simple_animal/hostile/creature,
		/mob/living/simple_animal/hostile/carp/pike, 
		/mob/living/simple_animal/hostile/vagrant,
		/mob/living/simple_animal/hostile/bear,
		) // types of monsters that will occur on this map.
	monster_quantity = 150 // and how many will occur/respawn
	obj_types = list(/obj/structure/cryo_crate)
	obj_quantity = 10
	difficulty = 5

/datum/zlevel_data/seven
	z = 7
	coord = "(-2,2)"
	name = "Shadowlands"
	E_connect = 6
	monster_types = list(
		/mob/living/simple_animal/hostile/tormented, 
		/mob/living/simple_animal/hostile/creature, 
		/mob/living/simple_animal/hostile/faithless,
		/mob/living/simple_animal/hostile/voxslug,
		/mob/living/simple_animal/hostile/scarybat,
		/mob/living/simple_animal/hostile/carp/pike, 
		/mob/living/simple_animal/hostile/bear,
		/mob/living/simple_animal/hostile/pirate/ranged,
		) // types of monsters that will occur on this map.
	monster_quantity = 150 // and how many will occur/respawn
	obj_types = list(/obj/structure/cryo_crate)
	obj_quantity = 10
	difficulty = 6

/datum/zlevel_data/seventeen
	z = 17
	coord = "Unknown"
	name = "Crash Site"
	monster_types = list(
		/mob/living/simple_animal/hostile/tormented, 
		/mob/living/simple_animal/hostile/creature, 
		/mob/living/simple_animal/hostile/faithless,
		/mob/living/simple_animal/hostile/voxslug,
		/mob/living/simple_animal/hostile/scarybat,
		/mob/living/simple_animal/hostile/carp/pike, 
		/mob/living/simple_animal/hostile/hivebot,
		/mob/living/simple_animal/hostile/viscerator,
		) // types of monsters that will occur on this map.
	monster_quantity = 150 // and how many will occur/respawn
	obj_types = list(/obj/structure/cryo_crate)
	obj_quantity = 0
	difficulty = 6



#undef ZLEVEL_INACTIVE
#undef ZLEVEL_DORMANT
#undef ZLEVEL_ACTIVE
#undef ZLEVELDATA_MONSTER_HEALTH_MULT_PER_DIFFICULTY
#undef ZLEVELDATA_MONSTER_DAMAGE_MULT_PER_DIFFICULTY
