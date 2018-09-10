var/datum/controller/aggression_controller/aggression_controller

/obj/structure/hostile_portal/red
	name = "hateful portal"
	desc = "Something is coming.."
	blend_mode = BLEND_SUBTRACT

/obj/structure/hostile_portal
	name = "bluespace portal"
	desc = "A small tear into bluespace."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "portal"
	density = 0
	unacidable = 1
	anchored = 1
	layer = -10
/datum/aggression_machine
	var/datum/controller/aggression_controller/parent
	var/list/affecting_zlevels = list()
	var/checkbuffer = 0
	var/asteroid_aggression = 0.0
	var/space_aggression = 0.0
	var/base_aggression = 0.0

	var/list/spawned_space_monsters = list()
	var/list/spawned_asteroid_monsters = list()
	var/list/spawned_base_monsters = list()
	var/list/dead_monsters = list()

	var/list/asteroid_targets = list()
	var/list/space_targets = list()
	var/list/base_targets = list()

	var/list/beacons = list()

	var/dissolve_time = 5 MINUTES

/datum/aggression_machine/proc/check_dead()
	for(var/mob/living/M in spawned_asteroid_monsters)
		if(M.stat == 2)
			spawned_asteroid_monsters -= M
			dead_monsters |= M
/datum/aggression_machine/proc/get_asteroid_spawn(var/atom/movable/A)
	for(var/turf/simulated/asteroid/asteroid in shuffle(orange(7, get_turf(A))))
		return asteroid

/datum/aggression_machine/proc/spawn_glutslug(var/turf/T)
//	if(spawned_asteroid_monsters.len > 100) return
	T.visible_message("<span class='danger'>The ground trembles as a vile glutslug burrows up!</span>")
	playsound(T, pick('sound/effects/asteroid/earthquake_short.ogg','sound/effects/asteroid/earthquake_short2.ogg'), 50, 1, 5)
	for(var/mob/M in view(T))
		if(M.client)
			shake_camera(M, 10, 2)

	spawn(rand(1 SECOND, 2 SECONDS))
		playsound(T, pick('sound/effects/asteroid/auger_bang.ogg','sound/effects/asteroid/bamf.ogg'), 50, 1, 5)
		spawned_asteroid_monsters |= new /mob/living/simple_animal/hostile/voxslug(T)

/datum/aggression_machine/proc/spawn_greed(var/turf/T)
//	if(spawned_asteroid_monsters.len > 100) return
	T.visible_message("<span class='danger'>A scream runs through your mind as a portal opens!</span>")
	var/obj/structure/hostile_portal/red/portal = new(T)
	playsound(T, 'sound/effects/ghost2.ogg', 50, 1, 5)
	spawn(rand(1 SECOND, 2 SECONDS))
		T.visible_message("<span class='danger'>And a terrible greed emerges!</span>")
		spawned_asteroid_monsters |= new /mob/living/simple_animal/hostile/creature(T)
		playsound(T, 'sound/voice/hiss5.ogg', 50, 1, 5)
		sleep(1 SECOND)
		portal.loc = null
		qdel(portal)
/datum/aggression_machine/proc/execute_asteroid_aggression(var/atom/movable/A, var/level)
	var/mob/M
	M = A
	switch(level)
		if(1)
			switch(pick(list(1,2)))
				if(1)
					if(istype(M))
						if(istype(M.loc, /turf/simulated))
							to_chat(M, "<span class='danger'>The ground lightly trembles beneath your feet...</span>")
							M.playsound_local(M.loc, pick('sound/effects/asteroid/earthquake_short.ogg','sound/effects/asteroid/earthquake_short2.ogg'), 30, 0)
							shake_camera(M, 5, 1)
				if(2)
					if(istype(M))
						to_chat(M, pick("You feel a sudden sense of dread...", "You feel shame... but you can't tell why..."))
						M.playsound_local(M.loc, pick('sound/ambience/ambigen5.ogg','sound/ambience/ambigen4.ogg'), 50, 0)
						M.phoronation += 0.05 // Mild sanity event


		if(2)
			switch(pick(list(1,2,3)))
				if(1)
					if(istype(M))
						if(istype(M.loc, /turf/simulated))
							to_chat(M, "<span class='danger'>The ground angrily trembles beneath your feet...</span>")
							M.playsound_local(M.loc, pick('sound/effects/asteroid/earthquake_short.ogg','sound/effects/asteroid/earthquake_short2.ogg'), 50, 0)
							shake_camera(M, 10, 2)
				if(2)
					if(istype(M))
						to_chat(M, pick("A whisper in your head... pain...", "Being on this asteroid is making you depressed..."))
						M.playsound_local(M.loc, pick('sound/ambience/ambigen5.ogg','sound/ambience/ambigen4.ogg'), 50, 0)
						M.phoronation += 0.1 // Sanity event

				if(3)
					var/turf/T = get_asteroid_spawn(A)
					spawn_glutslug(T)

		if(3)
			switch(pick(list(1,2,3)))
				if(1)
					if(istype(M))
						if(istype(M.loc, /turf/simulated))
							shake_camera(M, 25, 3)
							to_chat(M, "<span class='danger'>The asteroid rattles under you, you struggle to maintain balance!</span>")
							if(!prob(60))
								M.fall(1)
							M.playsound_local(M.loc, pick('sound/effects/asteroid/earthquake_short.ogg','sound/effects/asteroid/earthquake_short2.ogg'), 70, 0)
				if(2)
					if(istype(M))
						switch(pick(list(1,2)))
							if(1)
								to_chat(M, pick("<span class='userdanger>You want off of this asteroid, NOW! You can't contain your dread!</span>", "<span class='userdanger>The voices! You don't want to understand!</span>"))
							if(2)
								to_chat(M, pick("<span class='userdanger>Voices layered over themselves... you struggle to block out the noise!</span>", "<span class='userdanger>You've got to steel yourself against these terrors!</span>"))
						M.phoronation += 0.2 // Big sanity event
						M.playsound_local(M.loc, pick('sound/effects/yewbic_amb1.ogg', 'sound/effects/yewbic_amb2.ogg', 'sound/effects/yewbic_amb3.ogg', 'sound/effects/yewbic_amb4.ogg'), 50, 0)

				if(3)
					switch(pick(list(1,1,1,2)))
						if(1)
							var/slugs = rand(2,4)
							for(var/i=0; i<slugs; i++)
								var/turf/T = get_asteroid_spawn(A)
								spawn_glutslug(T)
						if(2)
							var/turf/T = get_asteroid_spawn(A)
							spawn_greed(T)
		if(4)
			switch(pick(list(1,2,3,3,3)))
				if(1)
					if(istype(M))
						if(istype(M.loc, /turf/simulated))
							shake_camera(M, 25, 3)
							to_chat(M, "<span class='danger'>The asteroid rattles under you, you struggle to maintain balance!</span>")
							if(!prob(60))
								M.fall(1)
							M.playsound_local(M.loc, pick('sound/effects/asteroid/earthquake_short.ogg','sound/effects/asteroid/earthquake_short2.ogg'), 70, 0)
				if(2)
					if(istype(M))
						switch(pick(list(1,2)))
							if(1)
								to_chat(M, pick("<span class='userdanger>You want off of this asteroid, NOW! You cant contain your dread!</span>", "<span class='userdanger>The voices! You dont want to understand!</span>"))
							if(2)
								to_chat(M, pick("<span class='userdanger>Voices layered over themselves.. You struggle to block out the noise!</span>", "<span class='userdanger>You've got to steel yourself against these terrors!</span>"))
						M.playsound_local(M.loc, pick('sound/effects/yewbic_amb1.ogg', 'sound/effects/yewbic_amb2.ogg', 'sound/effects/yewbic_amb3.ogg', 'sound/effects/yewbic_amb4.ogg'), 50, 0)


				if(3)
					switch(pick(list(1,1,1,2,3)))
						if(1)
							var/slugs = rand(2,5)
							for(var/i=0; i<slugs; i++)
								var/turf/T = get_asteroid_spawn(A)
								spawn_glutslug(T)
						if(2)
							var/turf/T = get_asteroid_spawn(A)
							spawn_greed(T)
							T = get_asteroid_spawn(A)
							spawn_greed(T)
						if(3)
							var/slugs = rand(2,5)
							var/turf/T = get_asteroid_spawn(A)
							spawn_greed(T)
							for(var/i=0; i<slugs; i++)
								var/turf/Te = get_asteroid_spawn(A)
								spawn_glutslug(Te)

/datum/aggression_machine/Process()
	if(round_duration_in_ticks > checkbuffer)
		checkbuffer = round_duration_in_ticks + rand(20 SECONDS, 35 SECONDS)
		check_dead()
		if(asteroid_aggression)
			switch(asteroid_aggression)
				if(51 to 100)
					var/list/potentials = asteroid_targets.Copy()
					var/targets = min(rand(1,3),asteroid_targets.len)
					for(var/i=1; i<targets; i++)
						if(potentials.len)
							execute_asteroid_aggression(pick_n_take(potentials),1)

				if(101 to 250)
					var/list/potentials = asteroid_targets.Copy()
					var/targets = min(rand(1,3),asteroid_targets.len)
					for(var/i=1; i<targets; i++)
						if(potentials.len)
							execute_asteroid_aggression(pick_n_take(potentials),2)

				if(251 to 500)
					checkbuffer -= 5 SECONDS
					var/list/potentials = asteroid_targets.Copy()
					var/targets = min(rand(3,6),asteroid_targets.len)
					for(var/i=1; i<targets; i++)
						if(potentials.len)
							execute_asteroid_aggression(pick_n_take(potentials),3)
				if(501 to INFINITY)
					checkbuffer -= 10 SECONDS
					var/list/potentials = asteroid_targets.Copy()
					var/targets = min(rand(5, 8), asteroid_targets.len)
					for(var/i=0; i<targets; i++)
						if(potentials.len)
							execute_asteroid_aggression(pick_n_take(potentials),4)
			asteroid_aggression = min(asteroid_aggression, 1000)
			asteroid_aggression = max(asteroid_aggression-0.5,0)
		for(var/atom/movable/A in asteroid_targets)
			if(!(A.z in affecting_zlevels) || !istype(A.loc, /turf/simulated/asteroid))
				asteroid_targets -= A
/datum/controller/aggression_controller
	var/checkbuffer = 0
	var/list/sectors = list()
	var/list/sectors_by_zlevel = list()
/datum/controller/aggression_controller/New()
	checkbuffer = 1 MINUTE
	for(var/i=1; i<25; i++)
		var/datum/aggression_machine/sector = new()
		sector.affecting_zlevels |= i*2
		sector.affecting_zlevels |= i*2-1
		sectors |= sector
		sectors_by_zlevel["[i*2]"] = sector
		sectors_by_zlevel["[i*2-1]"] = sector
	START_PROCESSING(SSprocessing, src)

/datum/controller/aggression_controller/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	. = ..()

/datum/controller/aggression_controller/Process()
	for(var/datum/aggression_machine/sector in sectors)
		sector.Process()