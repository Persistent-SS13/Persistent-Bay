GLOBAL_LIST_EMPTY(maze_map_data)

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
	
	var/difficulty = 0 // used for exploration/base establishment objectives
	
	var/list/monster_types = list() // types of monsters that will occur on this map.
	var/monster_quantity = 0 // and how many will occur/respawn
	
	var/list/current_monsters = list()
	var/list/despawning = list()
	
	var/coord = "(0,0)"
	var/name = "Nexus"

/datum/zlevel_data/proc/replenish_monsters()
	if(current_monsters.len < monster_quantity)
		var/difference = monster_quantity - current_monsters.len
		for(var/i = 1 to difference)
			var/turf/T = locate(rand(TRANSITIONEDGE, world.maxx - TRANSITIONEDGE - 1),rand(TRANSITIONEDGE, world.maxy - TRANSITIONEDGE - 1),z)
			if(!istype(T, /turf/space)) continue
			var/monster_type = pick(monster_types)
			var/mob/living/simple_animal/monster = new monster_type(T)
			current_monsters |= monster
			monster.faction = "spawned"
			
/datum/zlevel_data/one
	z = 1
	
/datum/zlevel_data/two
	z = 2
	
/datum/zlevel_data/three
	z = 3
	N_connect = 4
	S_connect = 9
	
/datum/zlevel_data/four
	z = 4
	coord = "(0,1)"
	name = "Due North"
	S_connect = 3
	N_connect = 5

/datum/zlevel_data/five
	z = 5
	coord = "(0,2)"
	name = "Julian's Corner"
	N_connect = 4
	W_connect = 6
	
/datum/zlevel_data/six
	z = 6
	coord = "(-1,2)"
	name = "Lost Greed"
	E_connect = 5
	W_connect = 7
	S_connect = 8
	
/datum/zlevel_data/seven
	z = 7
	coord = "(-2,2)"
	name = "Shadowlands"
	E_connect = 6
	
/datum/zlevel_data/eight
	z = 8
	coord = "(-1,1)"
	name = "Blue Effigy"
	N_connect = 6	
	
/datum/zlevel_data/nine
	z = 9
	coord = "(0,-1)"
	name = "Due South"
	N_connect = 3
	E_connect = 10

/datum/zlevel_data/ten
	z = 10
	coord = "(1,-1)"
	name = "Gerald's Zone"
	W_connect = 9
	N_connect = 11
	
/datum/zlevel_data/eleven
	z = 11
	coord = "(1,0)"
	name = "Tokens and Dice"
	S_connect = 10
	N_connect = 12
	W_connect = 13
	
	
/datum/zlevel_data/twelve
	z = 12
	coord = "(1,1)"
	name = "Hinterlands"
	S_connect = 11

/datum/zlevel_data/thirteen
	z = 13
	coord = "(2,0)"
	name = "Far Reach"
	E_connect = 11
	


