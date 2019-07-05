#define EVENT_SHAKE 1
#define EVENT_PHORON 2
#define EVENT_DEPRESSION 4
#define EVENT_COLLAPSE 8

#define EVENT_A "A"
#define EVENT_B "B"

#define DRILL "DRILL"

SUBSYSTEM_DEF(asteroid)
	name = "Asteroid"
	wait = 5 MINUTES

	var/current = 1

	var/list/monsters = list()
	var/list/dead_monsters = list()

	var/list/mob_targets = list()
	var/list/drill_targets = list()

	var/list/asteroid_aggression = list()

/datum/controller/subsystem/asteroid/Initialize()
	for(var/I = 1; I <= WORLD_LENGTH * WORLD_WIDTH; I++)
		mob_targets["[I]"] = list()
		drill_targets["[I]"] = list()
		asteroid_aggression["[I]"] = 0
	for(var/I = 1; I <= 100; I++)
		var/list/L = list(new /mob/living/simple_animal/hostile/voxslug(), new /mob/living/simple_animal/hostile/scarybat(), new /mob/living/simple_animal/hostile/creature())
		for(var/mob/living/M in L)
			M.stat = DEAD
			dead_monsters |= M
	return ..()


/datum/controller/subsystem/asteroid/stat_entry()
	var/string = "Monsters: [length(monsters)] \n"
	var/mobs = 0
	var/drills = 0
	for(var/Z in mob_targets)
		mobs += length(mob_targets["[Z]"])
	for(var/Z in drill_targets)
		drills += length(drill_targets["[Z]"])
	string += "Targets: Mobs [mobs] | Drills [drills] \n"
	string += "Aggresion:"
	for(var/Z in asteroid_aggression)
		string += " | [Z] : [asteroid_aggression["[Z]"]]"
	..(string)

/datum/controller/subsystem/asteroid/fire()
	/**
	for(var/mob/living/M in monsters)
		if(M.stat == DEAD || !asteroid_aggression["[M.z]"])
			monsters -= M
			dead_monsters |= M
			M.forceMove(null)

	for(var/Z in mob_targets)
		for(var/mob/living/M in mob_targets[Z])
			if(M.stat || !istype(get_turf(M), /turf/simulated/floor/asteroid))
				mob_targets[Z] -= M

	for(var/Z in drill_targets)
		for(var/obj/machinery/D in drill_targets[Z])
			if(D.stat || !istype(get_turf(D), /turf/simulated/floor/asteroid))
				drill_targets[Z] -= D

	mob_targets["[current]"] = shuffle(mob_targets["[current]"])
	asteroid_aggression["[current]"] = max(0, asteroid_aggression["[current]"] - 5)

	while(current <= WORLD_WIDTH * WORLD_LENGTH)
		var/list/mobs = mob_targets["[current]"].Copy()
		var/list/drills = drill_targets["[current]"].Copy()
		var/list/messages = list()
		var/list/sounds = list()
		var/list/events = list()

		var/intensity = 1
		var/genre = 0
		var/aggression = asteroid_aggression["[current]"]

		if(length(mobs))
			switch(aggression)
				if(0)
					// We look pretty, gosh. Mostly
				if(1 to 50)
					mobs.len = ceil(mobs.len / 3)
					genre = list(MUSIC_GENRE_ASTEROID_4)

					// Event A
					LAZYDISTINCTADD(messages[EVENT_A], "The ground trembles lightly beneath your feet...")
					LAZYDISTINCTADD(sounds[EVENT_A], list('sound/effects/asteroid/earthquake_short.ogg', 'sound/effects/asteroid/earthquake_short2.ogg'))
					events[EVENT_A] |= EVENT_SHAKE	// Bitflag, not a list

					// Event B
					LAZYDISTINCTADD(messages[EVENT_B], list("You feel a tingle in the back of your mind...", "You feel an odd emptyness..."))

					// Drill
					LAZYDISTINCTADD(messages[DRILL], list("A steady vibration under your feet lets you know theirs more coming.", "The ground lightly trembles below you, and you get a sense of dread."))
					LAZYDISTINCTADD(sounds[DRILL], list('sound/effects/asteroid/earthquake_short.ogg', 'sound/effects/asteroid/earthquake_short2.ogg'))

				if(51 to 100)
					mobs.len = ceil(mobs.len / 3)
					intensity = 2
					genre = list(MUSIC_GENRE_ASTEROID_4)

					// Event A
					LAZYDISTINCTADD(messages[EVENT_A], SPAN_DANGER("The ground trembles beneath your feet..."))
					LAZYDISTINCTADD(sounds[EVENT_A], list('sound/effects/asteroid/earthquake_short.ogg', 'sound/effects/asteroid/earthquake_short2.ogg'))
					events[EVENT_A] |= EVENT_SHAKE

					// Event B
					LAZYDISTINCTADD(messages[EVENT_B], list("You feel a sudden sense of dread...", "You feel shame... but you can't tell why..."))
					LAZYDISTINCTADD(sounds[EVENT_B], list('sound/ambience/ambigen5.ogg', 'sound/ambience/ambigen4.ogg'))
					events[EVENT_B] |= EVENT_PHORON

					// Drill
					LAZYDISTINCTADD(messages[DRILL], list("The ground trembles under you. Must be more coming.", "The ground quakes and vile creatures start to emerge."))
					LAZYDISTINCTADD(sounds[DRILL], list('sound/effects/asteroid/earthquake_short.ogg', 'sound/effects/asteroid/earthquake_short2.ogg'))

				if(101 to 150)
					mobs.len = ceil(mobs.len / 3)
					intensity = 4
					genre = list(MUSIC_GENRE_ASTEROID_3)

					// Event A
					LAZYDISTINCTADD(messages[EVENT_A], SPAN_DANGER("The ground trembles heavily beneath your feet...!"))
					LAZYDISTINCTADD(sounds[EVENT_A], list('sound/effects/asteroid/earthquake_short.ogg', 'sound/effects/asteroid/earthquake_short2.ogg'))
					events[EVENT_A] |= EVENT_SHAKE

					// Event B
					LAZYDISTINCTADD(messages[EVENT_B], list("A whisper in your head... pain...", "You feel like a developer didn't finish this line... Hmm..."))
					LAZYDISTINCTADD(sounds[EVENT_B], list('sound/ambience/ambigen5.ogg', 'sound/ambience/ambigen4.ogg'))
					events[EVENT_B] |= EVENT_PHORON | EVENT_DEPRESSION

					// Drill
					LAZYDISTINCTADD(messages[DRILL], list("The ground rattles under you and you struggle to maintain balance.", "Another round of vile creatures crawl our of the ground.."))
					LAZYDISTINCTADD(sounds[DRILL], list('sound/effects/asteroid/earthquake_short.ogg', 'sound/effects/asteroid/earthquake_short2.ogg'))

				if(151 to 200)
					mobs.len = ceil(mobs.len / 2)
					intensity = 6
					genre = list(MUSIC_GENRE_ASTEROID_2)

					// Event A
					LAZYDISTINCTADD(messages[EVENT_A], SPAN_DANGER("You struggle to maintain balance as the asteroid rattles under you!"))
					LAZYDISTINCTADD(sounds[EVENT_A], list('sound/effects/asteroid/earthquake_short.ogg', 'sound/effects/asteroid/earthquake_short2.ogg'))
					events[EVENT_A] |= EVENT_SHAKE | EVENT_COLLAPSE

					// Event B
					LAZYDISTINCTADD(messages[EVENT_B], list(SPAN_DANGER("Voices layered over themselves... you struggle to block out the noise!"), \
						SPAN_DANGER("The voices! You don't want to understand!"), SPAN_DANGER("You want to flee! You want to escape!"), \
						SPAN_DANGER("You want off this asteroid NOW! You can't contain your dread!")))
					LAZYDISTINCTADD(sounds[EVENT_B], list('sound/effects/yewbic_amb1.ogg', 'sound/effects/yewbic_amb2.ogg', 'sound/effects/yewbic_amb3.ogg', 'sound/effects/yewbic_amb4.ogg'))
					events[EVENT_B] |= EVENT_PHORON | EVENT_DEPRESSION | EVENT_SHAKE

					// Drill
					LAZYDISTINCTADD(messages[DRILL], list("Voices in your head bellow as the next wave of creatures threatens to overwhelm!", "You dont want to die on this asteroid! You feel the urge to flee!"))
					LAZYDISTINCTADD(sounds[DRILL], list('sound/effects/asteroid/earthquake_short.ogg', 'sound/effects/asteroid/earthquake_short2.ogg'))

				else
					intensity = 8
					genre = list(MUSIC_GENRE_ASTEROID_1)

					// Event A
					LAZYDISTINCTADD(messages[EVENT_A], SPAN_DANGER("You struggle to maintain balance as the asteroid rattles under you!"))
					LAZYDISTINCTADD(sounds[EVENT_A], list('sound/effects/asteroid/earthquake_short.ogg', 'sound/effects/asteroid/earthquake_short2.ogg'))
					events[EVENT_A] |= EVENT_SHAKE | EVENT_COLLAPSE

					// Event B
					LAZYDISTINCTADD(messages[EVENT_B], list(SPAN_DANGER("Voices layered over themselves... you struggle to block out the noise!"), \
						SPAN_DANGER("The voices! You don't want to understand!"), SPAN_DANGER("You want to flee! You want to escape!"), \
						SPAN_DANGER("You want off this asteroid NOW! You can't contain your dread!"), SPAN_DANGER("AAAAAHHHH!")))
					LAZYDISTINCTADD(sounds[EVENT_B], list('sound/effects/yewbic_amb1.ogg', 'sound/effects/yewbic_amb2.ogg', 'sound/effects/yewbic_amb3.ogg', 'sound/effects/yewbic_amb4.ogg'))
					events[EVENT_B] |= EVENT_PHORON | EVENT_DEPRESSION | EVENT_SHAKE

					// Drill
					LAZYDISTINCTADD(messages[DRILL], list("You struggle to block out the voices! More monsters-- More quakes-- You smell phoron!", "You feel the ground cascade under you! You need to get off this rock now!"))
					LAZYDISTINCTADD(sounds[DRILL], list('sound/effects/asteroid/earthquake_short.ogg', 'sound/effects/asteroid/earthquake_short2.ogg'))

		// Music
		for(var/Z = 0; Z < WORLD_HEIGHT; Z++)
			var/datum/music_controller/music_player = SSmusic.zLevelAmbience["[current + Z]"]
			if(!genre)
				genre = list(MUSIC_GENRE_NEUTRAL, MUSIC_GENRE_AMBIENT)
			if(music_player && music_player.genre ~= genre)
				music_player.genre = genre
				music_player.stopTime = 0

		// Generic affects
		for(var/mob/M in mobs)
			var/turf/T = get_turf(M)
			var/event = pick(EVENT_A, EVENT_B)

			if(length(messages[event]))
				to_chat(M, pick(messages[event]))
			if(length(sounds[event]))
				M.playsound_local(T, pick(sounds[event]), intensity * 10, 0)

			// Events
			if(events[event] & EVENT_SHAKE)
				shake_camera(M, intensity * 2, Clamp(round(intensity) / 2, 1, 3))
			if(events[event] & EVENT_PHORON)
				M.phoronation += intensity / 4
			if(events[event] & EVENT_COLLAPSE)
				if(prob(intensity * 5))
					M.fall(1)
			if(events[event] & EVENT_DEPRESSION)
				// TODO Make this have long lasting affects and counterable by antidepressants
				if(prob(intensity * 5))
					to_chat(M, pick("The world feels dark and lonely...", "Life is just a waste of time..."))

		spawn(30 SECONDS)	// Sleeping is fine in subsystems, they won't fire until they return and the wait time has passed

			// Wave starts
			for(var/mob/M in mobs)
				var/turf/T = get_turf(M)

				if(length(messages[DRILL]))
					to_chat(M, pick(messages[DRILL]))
				if(length(sounds[DRILL]))
					M.playsound_local(T, pick(sounds[DRILL]), intensity * 10, 0)
				if(prob(intensity * 10))
					spawn_monster(get_asteroid_spawn(T), intensity)

				shake_camera(M, intensity * 2, Clamp(round(intensity) / 2, 1, 3))

			for(var/obj/machinery/drill in drills)
				for(var/I = 1; I <= intensity; I++)
					var/turf/T = get_asteroid_spawn(drill)
					spawn_monster(T, intensity)
					if(prob(intensity * 10))
						spawn_monster(T, intensity)
				sleep(1)

		current++
		if(MC_TICK_CHECK)
			return

	current = 1
	**/
/datum/controller/subsystem/asteroid/proc/spawn_monster(var/turf/T, var/intensity)
	var/mob/M = pick(dead_monsters)

	if(!M)
		return

	if(istype(M, /mob/living/simple_animal/hostile/voxslug))
		T.visible_message("<span class='danger'>The ground trembles as a vile glutslug burrows up!</span>")
		playsound(T, pick('sound/effects/asteroid/earthquake_short.ogg','sound/effects/asteroid/earthquake_short2.ogg'), 75, 1, 5)
		spawn(rand(1 SECOND, 2 SECONDS))
			playsound(T, pick('sound/effects/asteroid/auger_bang.ogg','sound/effects/asteroid/bamf.ogg'), 100, 1, 5)
			M.forceMove(T)

	else if(istype(M, /mob/living/simple_animal/hostile/scarybat))
		T.visible_message("<span class='danger'>A swarm of locusectums fly up out of the ground!</span>")
		spawn(rand(1 SECOND, 2 SECONDS))
			playsound(T, 'sound/effects/mobs/game-creature.ogg', 100, 1, 5)
			M.forceMove(T)

	else if(istype(M, /mob/living/simple_animal/hostile/creature))
		T.visible_message("<span class='danger'>A scream runs through your mind as a portal opens!</span>")
		var/obj/effect/asteroid_portal/P = new(T)
		playsound(T, 'sound/effects/ghost2.ogg', 100, 1, 5)
		spawn(rand(1 SECOND, 2 SECONDS))
			T.visible_message("<span class='danger'>And a terrible greed emerges!</span>")
			M.forceMove(T)
			playsound(T, 'sound/effects/mobs/creature-roar-1.ogg', 100, 1, 5)
			sleep(1 SECOND)
			P.loc = null
			qdel(P)

	M.stat = 0
	dead_monsters -= M
	monsters |= M

/datum/controller/subsystem/asteroid/proc/get_asteroid_spawn(var/atom/movable/A)
	var/turf/simulated/floor/asteroid/T = locate() in shuffle(orange(7, get_turf(A)))
	return T

/datum/controller/subsystem/asteroid/proc/agitate(var/atom/movable/A, var/amount = 0)
	if(A)

		if(istype(A, /obj/machinery/mining/drill))
			LAZYDISTINCTADD(drill_targets["[ceil(A.z / WORLD_HEIGHT)]"], A)
		if(istype(A, /mob))
			LAZYDISTINCTADD(mob_targets["[ceil(A.z / WORLD_HEIGHT)]"], A)

		asteroid_aggression["[ceil(A.z / WORLD_HEIGHT)]"] += amount
		return 1

	return 0

/obj/effect/asteroid_portal
	name = "portal"
	desc = "Something is coming..."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "portal"
	density = 0
	unacidable = 1
	anchored = 1
	layer = -10
	blend_mode = BLEND_SUBTRACT
