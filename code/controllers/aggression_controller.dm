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

	var/list/mob_targets = list()
	var/list/drill_targets = list()
	
	var/list/beacons = list()

	var/dissolve_time = 5 MINUTES

	var/asteroid_stage = 0
	var/events_since_stage_change = 0
	var/wavebuffer = 0
	
/datum/aggression_machine/proc/check_dead()
	for(var/mob/living/M in spawned_asteroid_monsters)
		if(M.stat == 2)
			spawned_asteroid_monsters -= M
			dead_monsters |= M
		
/datum/aggression_machine/proc/check_targets()	
	for(var/mob/living/M in mob_targets)
		if(M.stat || !M.z in affecting_zlevels || !istype(M.loc, /turf/simulated/asteroid))
			mob_targets -= M
	for(var/obj/machinery/ob in drill_targets)
		if(ob.stat || !ob.z in affecting_zlevels || !istype(ob.loc, /turf/simulated/asteroid))
			drill_targets -= ob
	
/datum/aggression_machine/proc/clear_targets()
	mob_targets = list()
	drill_targets = list()
	asteroid_targets = list()
	
	
/datum/aggression_machine/proc/get_asteroid_spawn(var/atom/movable/A)
	for(var/turf/simulated/asteroid/asteroid in shuffle(orange(7, get_turf(A))))
		return asteroid

/datum/aggression_machine/proc/spawn_glutslug(var/turf/T)
	if(spawned_asteroid_monsters.len > 100) return
	T.visible_message("<span class='danger'>The ground trembles as a vile glutslug burrows up!</span>")
	playsound(T, pick('sound/effects/asteroid/earthquake_short.ogg','sound/effects/asteroid/earthquake_short2.ogg'), 75, 1, 5)
	for(var/mob/M in view(T))
		if(M.client)
			shake_camera(M, 10, 2)

	spawn(rand(1 SECOND, 2 SECONDS))
		playsound(T, pick('sound/effects/asteroid/auger_bang.ogg','sound/effects/asteroid/bamf.ogg'), 100, 1, 5)
		spawned_asteroid_monsters |= new /mob/living/simple_animal/hostile/voxslug(T)
		
/datum/aggression_machine/proc/spawn_locus(var/turf/T)
	if(spawned_asteroid_monsters.len > 100) return
	T.visible_message("<span class='danger'>A swarm of locusectums fly up out of the ground!</span>")
	spawn(rand(1 SECOND, 2 SECONDS))
		playsound(T, 'sound/effects/mobs/game-creature.ogg', 100, 1, 5)
		spawned_asteroid_monsters |= new /mob/living/simple_animal/hostile/scarybat(T)

		
/datum/aggression_machine/proc/spawn_greed(var/turf/T)
	if(spawned_asteroid_monsters.len > 100) return
	T.visible_message("<span class='danger'>A scream runs through your mind as a portal opens!</span>")
	var/obj/structure/hostile_portal/red/portal = new(T)
	playsound(T, 'sound/effects/ghost2.ogg', 100, 1, 5)
	spawn(rand(1 SECOND, 2 SECONDS))
		T.visible_message("<span class='danger'>And a terrible greed emerges!</span>")
		spawned_asteroid_monsters |= new /mob/living/simple_animal/hostile/creature(T)
		playsound(T, 'sound/effects/mobs/creature-roar-1.ogg', 100, 1, 5)
		sleep(1 SECOND)
		portal.loc = null
		qdel(portal)
		

/datum/aggression_machine/proc/trigger_event()	
	switch(asteroid_stage)
		if(1)
			var/targets = ceil(mob_targets.len/3)
			for(var/i=0; i<=targets; i++)
				for(var/mob/living/M in shuffle(mob_targets))
					switch(rand(1,2))
						if(1)
							if(istype(M.loc, /turf/simulated))
								to_chat(M, "<span class='danger'>The ground lightly vibrates..</span>")
								M.playsound_local(M.loc, pick('sound/effects/asteroid/earthquake_short.ogg','sound/effects/asteroid/earthquake_short2.ogg'), 10, 0)
								shake_camera(M, 3, 1)
						if(2)
							to_chat(M, pick("You feel a tingle in the back of your mind..", "You feel an odd emptyness.."))
		
		if(2)
			var/targets = ceil(mob_targets.len/3)
			for(var/i=0; i<=targets; i++)
				for(var/mob/living/M in shuffle(mob_targets))
					switch(rand(1,2))
						if(1)
							if(istype(M.loc, /turf/simulated))
								to_chat(M, "<span class='danger'>The ground lightly trembles beneath your feet...</span>")
								M.playsound_local(M.loc, pick('sound/effects/asteroid/earthquake_short.ogg','sound/effects/asteroid/earthquake_short2.ogg'), 30, 0)
								shake_camera(M, 5, 1)
						if(2)
							to_chat(M, pick("You feel a sudden sense of dread...", "You feel shame... but you can't tell why..."))
							M.playsound_local(M.loc, pick('sound/ambience/ambigen5.ogg','sound/ambience/ambigen4.ogg'), 50, 0)
							M.phoronation += 0.1 // Mild sanity event
		if(3)
			var/targets = ceil(mob_targets.len/3)
			for(var/i=0; i<=targets; i++)
				for(var/mob/living/M in shuffle(mob_targets))
					switch(rand(1,2))
						if(1)
							if(istype(M.loc, /turf/simulated))
								to_chat(M, "<span class='danger'>The ground angrily trembles beneath your feet...</span>")
								M.playsound_local(M.loc, pick('sound/effects/asteroid/earthquake_short.ogg','sound/effects/asteroid/earthquake_short2.ogg'), 50, 0)
								shake_camera(M, 10, 2)
						if(2)
							to_chat(M, pick("A whisper in your head... pain...", "Being on this asteroid is making you depressed..."))
							M.playsound_local(M.loc, pick('sound/ambience/ambigen5.ogg','sound/ambience/ambigen4.ogg'), 50, 0)
							M.phoronation += 0.5 // Sanity event
					
		if(4)
			var/targets = ceil(mob_targets.len/2)
			for(var/i=0; i<=targets; i++)
				for(var/mob/living/M in shuffle(mob_targets))
					switch(rand(1,2))
						if(1)
							if(istype(M.loc, /turf/simulated))
								shake_camera(M, 25, 3)
								to_chat(M, "<span class='danger'>The asteroid rattles under you, you struggle to maintain balance!</span>")
								if(!prob(60))
									M.fall(1)
								M.playsound_local(M.loc, pick('sound/effects/asteroid/earthquake_short.ogg','sound/effects/asteroid/earthquake_short2.ogg'), 70, 0)
						if(2)
							switch(pick(list(1,2)))
								if(1)
									to_chat(M, pick("<span class='danger'>You want off of this asteroid, NOW! You can't contain your dread!</span>", "<span class='danger'>The voices! You don't want to understand!</span>"))
								if(2)
									to_chat(M, pick("<span class='danger'>Voices layered over themselves... you struggle to block out the noise!</span>", "<span class='danger'>You want to flee! You want to escape!</span>"))
							M.phoronation += 1 // Big sanity event
							M.playsound_local(M.loc, pick('sound/effects/yewbic_amb1.ogg', 'sound/effects/yewbic_amb2.ogg', 'sound/effects/yewbic_amb3.ogg', 'sound/effects/yewbic_amb4.ogg'), 50, 0)


		if(5)
			var/targets = ceil(mob_targets.len)
			for(var/i=0; i<=targets; i++)
				for(var/mob/living/M in shuffle(mob_targets))
					switch(rand(1,2))
						if(1)
							if(istype(M.loc, /turf/simulated))
								shake_camera(M, 25, 3)
								to_chat(M, "<span class='danger'>The asteroid rattles under you, you struggle to maintain balance!</span>")
								if(!prob(60))
									M.fall(1)
								M.playsound_local(M.loc, pick('sound/effects/asteroid/earthquake_short.ogg','sound/effects/asteroid/earthquake_short2.ogg'), 70, 0)
						if(2)
							switch(pick(list(1,2)))
								if(1)
									to_chat(M, pick("<span class='danger'>You want off of this asteroid, NOW! You can't contain your dread!</span>", "<span class='danger'>The voices! You don't want to understand!</span>"))
								if(2)
									to_chat(M, pick("<span class='danger'>Voices layered over themselves... you struggle to block out the noise!</span>", "<span class='danger'>AHHHHHHHHHHHHHH!</span>"))
							M.phoronation += 2 // Big sanity event
							M.playsound_local(M.loc, pick('sound/effects/yewbic_amb1.ogg', 'sound/effects/yewbic_amb2.ogg', 'sound/effects/yewbic_amb3.ogg', 'sound/effects/yewbic_amb4.ogg'), 50, 0)
					
	events_since_stage_change++				
/datum/aggression_machine/proc/trigger_wave()
	switch(asteroid_stage)
		if(1)
			for(var/mob/M in mob_targets)
				to_chat(M, pick("A steady vibration under your feet lets you know theirs more coming.", "The ground lightly trembles below you, and you get a sense of dread."))
				M.playsound_local(M.loc, pick('sound/effects/earthquake_short.ogg','sound/effects/earthquake_short2.ogg'), 20, 0)
				shake_camera(M, 5, 2)
			if(drill_targets.len || mob_targets.len)
				var/forced_spawns = 2
				var/recursions = 0
				while(forced_spawns > 0 && recursions < 5 && (drill_targets.len || mob_targets.len))
					recursions++
					if(drill_targets.len)
						for(var/obj/O in shuffle(drill_targets))
							if(forced_spawns || prob(40))
								if(forced_spawns) forced_spawns--	
								var/turf/T = get_asteroid_spawn(O)
								spawn_locus(T)
								if(prob(20))
									T = get_asteroid_spawn(O)
									spawn_greed(T)
								else if(prob(50))
									T = get_asteroid_spawn(O)
									spawn_glutslug(T)
					if(mob_targets.len)
						for(var/mob/M in shuffle(mob_targets))
							if(forced_spawns || prob(20))
								if(forced_spawns) forced_spawns--	
								var/turf/T = get_asteroid_spawn(M)
								spawn_glutslug(T)
		if(2)
			for(var/mob/M in mob_targets)
				to_chat(M, pick("The ground trembles under you. Must be more coming.", "The ground quakes and vile creatures start to emerge."))
				M.playsound_local(M.loc, pick('sound/effects/earthquake_short.ogg','sound/effects/earthquake_short2.ogg'), 30, 0)
				shake_camera(M, 15, 2)
			if(drill_targets.len || mob_targets.len)
				var/forced_spawns = 3
				var/recursions = 0
				while(forced_spawns > 0 && recursions < 5 && (drill_targets.len || mob_targets.len))
					recursions++
					if(drill_targets.len)
						for(var/obj/O in shuffle(drill_targets))
							if(forced_spawns || prob(40))
								if(forced_spawns) forced_spawns--	
								var/turf/T = get_asteroid_spawn(O)
								spawn_glutslug(T)			
								spawn_glutslug(T)
								if(prob(20))
									T = get_asteroid_spawn(O)
									spawn_greed(T)
								else if(prob(50))
									T = get_asteroid_spawn(O)
									spawn_glutslug(T)
					if(mob_targets.len)
						for(var/mob/M in shuffle(mob_targets))
							if(forced_spawns || prob(20))
								if(forced_spawns) forced_spawns--	
								var/turf/T = get_asteroid_spawn(M)
								spawn_locus(T)
								if(prob(10))
									T = get_asteroid_spawn(M)
									spawn_greed(T)
								else if(prob(40))
									T = get_asteroid_spawn(M)
									spawn_locus(T)
		if(3)
			for(var/mob/M in mob_targets)
				to_chat(M, pick("The ground rattles under you and you struggle to maintain balance.", "Another round of vile creatures crawl our of the ground.."))
				M.playsound_local(M.loc, pick('sound/effects/earthquake_short.ogg','sound/effects/earthquake_short2.ogg'), 40, 0)
				shake_camera(M, 20, 3)
			if(drill_targets.len || mob_targets.len)
				var/forced_spawns = 5
				var/recursions = 0
				while(forced_spawns > 0 && recursions < 5 && (drill_targets.len || mob_targets.len))
					recursions++
					if(drill_targets.len)
						for(var/obj/O in shuffle(drill_targets))
							if(forced_spawns || prob(60))
								if(forced_spawns) forced_spawns--	
								var/turf/T = get_asteroid_spawn(O)
								spawn_glutslug(T)			
								spawn_glutslug(T)
								if(prob(50))
									T = get_asteroid_spawn(O)
									spawn_greed(T)
								else if(prob(70))
									T = get_asteroid_spawn(O)
									spawn_glutslug(T)
					if(mob_targets.len)
						for(var/mob/M in shuffle(mob_targets))
							if(forced_spawns || prob(40))
								if(forced_spawns) forced_spawns--	
								var/turf/T = get_asteroid_spawn(M)
								spawn_locus(T)			
								if(prob(25))
									T = get_asteroid_spawn(M)
									spawn_greed(T)
								else if(prob(60))
									T = get_asteroid_spawn(M)
									spawn_glutslug(T)
		if(4)
			for(var/mob/M in mob_targets)
				to_chat(M, pick("Voices in your head bellow as the next wave of creatures threatens to overwhelm!", "You dont want to die on this asteroid! You feel the urge to flee!"))
				M.playsound_local(M.loc, pick('sound/effects/earthquake_short.ogg','sound/effects/earthquake_short2.ogg'), 60, 0)
				shake_camera(M, 30, 4)
		
				
			if(drill_targets.len || mob_targets.len)
				var/forced_spawns = 7
				var/recursions = 0
				while(forced_spawns > 0 && recursions < 5 && (drill_targets.len || mob_targets.len))
					recursions++
					if(drill_targets.len)
						for(var/obj/O in shuffle(drill_targets))
							if(forced_spawns || prob(60))
								if(forced_spawns) forced_spawns--	
								var/turf/T = get_asteroid_spawn(O)
								spawn_glutslug(T)			
								spawn_greed(T)
								T = get_asteroid_spawn(O)
								spawn_glutslug(T)	
								if(prob(70))
									T = get_asteroid_spawn(O)
									spawn_greed(T)
								else
									T = get_asteroid_spawn(O)
									spawn_glutslug(T)
					if(mob_targets.len)			
						for(var/mob/M in shuffle(mob_targets))
							if(forced_spawns || prob(40))
								if(forced_spawns) forced_spawns--	
								var/turf/T = get_asteroid_spawn(M)
								spawn_glutslug(T)
								spawn_locus(T)
								if(prob(40))
									T = get_asteroid_spawn(M)
									spawn_greed(T)
								else if(prob(70))
									T = get_asteroid_spawn(M)
									spawn_glutslug(T)
		if(5)
			for(var/mob/M in mob_targets)
				to_chat(M, pick("You struggle to block out the voices! More monsters-- More quakes-- You smell phoron!", "You feel the ground cascade under you! You need to get off this rock now!"))
				M.playsound_local(M.loc, pick('sound/effects/earthquake_short.ogg','sound/effects/earthquake_short2.ogg'), 90, 0)
				shake_camera(M, 40, 4)
			
			if(drill_targets.len || mob_targets.len)
				var/forced_spawns = 10
				var/recursions = 0
				while(forced_spawns > 0 && recursions < 5 && (drill_targets.len || mob_targets.len))
					recursions++
					if(drill_targets.len)
						for(var/obj/O in shuffle(drill_targets))
							if(forced_spawns) forced_spawns--	
							var/turf/T = get_asteroid_spawn(O)
							spawn_glutslug(T)			
							spawn_greed(T)
							T = get_asteroid_spawn(O)
							spawn_glutslug(T)	
							T = get_asteroid_spawn(O)
							spawn_greed(T)
							T = get_asteroid_spawn(O)
							spawn_glutslug(T)
					if(mob_targets.len)			
						for(var/mob/M in shuffle(mob_targets))
							if(forced_spawns || prob(70))
								if(forced_spawns) forced_spawns--	
								var/turf/T = get_asteroid_spawn(M)
								spawn_glutslug(T)
								spawn_locus(T)
								if(prob(70))
									T = get_asteroid_spawn(M)
									spawn_greed(T)
								T = get_asteroid_spawn(M)
								spawn_locus(T)
	events_since_stage_change++
	clear_targets()						
/datum/aggression_machine/proc/trigger_change(var/level)
	var/music_z = affecting_zlevels[1]
	var/datum/music_controller/affecting_music
	if(ambient_controller)
		affecting_music = ambient_controller.zlevel_data["[music_z]"]
	asteroid_stage = level
	switch(level)
		if(0)
			if(affecting_music)
				affecting_music.override = 0
				affecting_music.timetostop = 0
			for(var/mob/M in mob_targets)
				to_chat(M, "The asteroid seems to have returned to normal. You feel relief.")
		if(1)
			if(affecting_music)
				if(affecting_music.override != 1)
					affecting_music.override = 1
					affecting_music.timetostop = 0
			for(var/mob/M in mob_targets)
				to_chat(M, pick("Theirs a mild tension on the asteroid.. An occasional tremor", "The ground lightly trembles below you, and you get a sense of dread."))
				M.playsound_local(M.loc, pick('sound/effects/earthquake_short.ogg','sound/effects/earthquake_short2.ogg'), 20, 0)
				shake_camera(M, 5, 2)
				
		if(2)
			if(affecting_music)
				if(affecting_music.override != 1)
					affecting_music.override = 1
					affecting_music.timetostop = 0
			for(var/mob/M in mob_targets)
				to_chat(M, pick("The ground trembles below you, you feel as if your worst fears are coming true.", "You dont want to die on this asteroid!"))
				M.playsound_local(M.loc, pick('sound/effects/earthquake_short.ogg','sound/effects/earthquake_short2.ogg'), 40, 0)
				sound_to(M, 'sound/ambience/ambigen5.ogg')
				shake_camera(M, 15, 3)
			if(drill_targets.len || mob_targets.len)
				var/forced_spawns = 3
				var/recursions = 0
				while(forced_spawns > 0 && recursions < 5 && (drill_targets.len || mob_targets.len))
					recursions++
					if(drill_targets.len)
						for(var/obj/O in shuffle(drill_targets))
							if(forced_spawns || prob(40))
								if(forced_spawns) forced_spawns--	
								var/turf/T = get_asteroid_spawn(O)
								spawn_glutslug(T)			
								spawn_glutslug(T)
								if(prob(20))
									T = get_asteroid_spawn(O)
									spawn_greed(T)
								else if(prob(50))
									T = get_asteroid_spawn(O)
									spawn_glutslug(T)
					if(mob_targets.len)
						for(var/mob/M in shuffle(mob_targets))
							if(forced_spawns || prob(20))
								if(forced_spawns) forced_spawns--	
								var/turf/T = get_asteroid_spawn(M)
								spawn_glutslug(T)			
								if(prob(10))
									T = get_asteroid_spawn(M)
									spawn_greed(T)
								else if(prob(40))
									T = get_asteroid_spawn(M)
									spawn_glutslug(T)
		if(3)
			if(affecting_music)
				if(affecting_music.override != 2)
					affecting_music.override = 2
					affecting_music.timetostop = 0
			for(var/mob/M in mob_targets)
				to_chat(M, pick("<span class='danger'>A constant drone in your ear suddenly manifests as a flurry of thoughts an emotions, overlapping so you cant make any sense of it. You feel you are being driven mad!</span>", "<span class='danger'>You imagine your own gruesome death at the hands of a creature of abject hatred!</span>"))
				M.playsound_local(M.loc, pick('sound/effects/earthquake_short.ogg','sound/effects/earthquake_short2.ogg'), 60, 0)
				sound_to(M, 'sound/ambience/ambigen11.ogg')
				shake_camera(M, 20, 4)
				
			if(drill_targets.len || mob_targets.len)
				var/forced_spawns = 5
				var/recursions = 0
				while(forced_spawns > 0 && recursions < 5 && (drill_targets.len || mob_targets.len))
					recursions++
					if(drill_targets.len)
						for(var/obj/O in shuffle(drill_targets))
							if(forced_spawns || prob(60))
								if(forced_spawns) forced_spawns--	
								var/turf/T = get_asteroid_spawn(O)
								spawn_glutslug(T)			
								spawn_glutslug(T)
								if(prob(50))
									T = get_asteroid_spawn(O)
									spawn_greed(T)
								else if(prob(70))
									T = get_asteroid_spawn(O)
									spawn_glutslug(T)
					if(mob_targets.len)
						for(var/mob/M in shuffle(mob_targets))
							if(forced_spawns || prob(40))
								if(forced_spawns) forced_spawns--	
								var/turf/T = get_asteroid_spawn(M)
								spawn_glutslug(T)			
								if(prob(25))
									T = get_asteroid_spawn(M)
									spawn_greed(T)
								else if(prob(60))
									T = get_asteroid_spawn(M)
									spawn_glutslug(T)
		if(4)
			if(affecting_music)
				if(affecting_music.override != 3)
					affecting_music.override = 3
					affecting_music.timetostop = 0
			for(var/mob/M in mob_targets)
				to_chat(M, pick("<span class='danger'>'You are violating creation itself. Your death will be a mercy' One of the voices booms, and you feel queezy</span>", "<span class='danger'>You get an incredible sense of the pain that these monsters will cause! Block out the voices!</span>"))
				M.playsound_local(M.loc, pick('sound/effects/earthquake_short.ogg','sound/effects/earthquake_short2.ogg'), 75, 0)
				sound_to(M, 'sound/ambience/yewbic_ambience.ogg')
				shake_camera(M, 30, 4)
				
			if(drill_targets.len || mob_targets.len)
				var/forced_spawns = 7
				var/recursions = 0
				while(forced_spawns > 0 && recursions < 5 && (drill_targets.len || mob_targets.len))
					recursions++
					if(drill_targets.len)
						for(var/obj/O in shuffle(drill_targets))
							if(forced_spawns || prob(60))
								if(forced_spawns) forced_spawns--	
								var/turf/T = get_asteroid_spawn(O)
								spawn_glutslug(T)			
								spawn_greed(T)
								T = get_asteroid_spawn(O)
								spawn_glutslug(T)	
								if(prob(70))
									T = get_asteroid_spawn(O)
									spawn_greed(T)
								else
									T = get_asteroid_spawn(O)
									spawn_glutslug(T)
					if(mob_targets.len)				
						for(var/mob/M in shuffle(mob_targets))
							if(forced_spawns || prob(40))
								if(forced_spawns) forced_spawns--	
								var/turf/T = get_asteroid_spawn(M)
								spawn_glutslug(T)
								spawn_glutslug(T)
								if(prob(40))
									T = get_asteroid_spawn(M)
									spawn_greed(T)
								else if(prob(70))
									T = get_asteroid_spawn(M)
									spawn_glutslug(T)
		if(5)
			if(affecting_music)
				if(affecting_music.override != 4)
					affecting_music.override = 4
					affecting_music.timetostop = 0
			for(var/mob/M in mob_targets)
				to_chat(M, pick("<span class='danger'>'YOU SAVAGE! YOU WELP! YOU DESERVE THE END THAT IS COMING!', Block the voices out! Block them out!</span>", "<span class='danger'>'A POX ON CREATION, AN END TO ALL THINGS! VOID--..' You don't want to understand! Your mind recoils into itself!</span>"))
				M.playsound_local(M.loc, pick('sound/effects/earthquake_short.ogg','sound/effects/earthquake_short2.ogg'), 100, 0)
				sound_to(M, 'sound/ambience/yewbic_ambience2.ogg')
				shake_camera(M, 45, 4)
				
			if(drill_targets.len || mob_targets.len)
				var/forced_spawns = 10
				var/recursions = 0
				while(forced_spawns > 0 && recursions < 5 && (drill_targets.len || mob_targets.len))
					recursions++
					if(drill_targets.len)
						for(var/obj/O in shuffle(drill_targets))
							if(forced_spawns) forced_spawns--	
							var/turf/T = get_asteroid_spawn(O)
							spawn_glutslug(T)			
							spawn_greed(T)
							T = get_asteroid_spawn(O)
							spawn_glutslug(T)	
							T = get_asteroid_spawn(O)
							spawn_greed(T)
							T = get_asteroid_spawn(O)
							spawn_glutslug(T)
					if(mob_targets.len)				
						for(var/mob/M in shuffle(mob_targets))
							if(forced_spawns || prob(70))
								if(forced_spawns) forced_spawns--	
								var/turf/T = get_asteroid_spawn(M)
								spawn_glutslug(T)
								spawn_glutslug(T)
								if(prob(70))
									T = get_asteroid_spawn(M)
									spawn_greed(T)
								T = get_asteroid_spawn(M)
								spawn_glutslug(T)
	events_since_stage_change = 0
	clear_targets()
/datum/aggression_machine/Process()
	if(world.time > checkbuffer)
		checkbuffer = world.time + rand(20 SECONDS, 35 SECONDS)
		check_dead()
		trigger_event()	
	if(world.time > wavebuffer)
		wavebuffer = world.time + rand(45 SECONDS, 75 SECONDS)
		check_targets()
		switch(asteroid_stage)
			if(0)
				if(asteroid_aggression)
					return trigger_change(1)
			if(1)
				if(!asteroid_aggression)
					return trigger_change(0)
				if(asteroid_aggression >= 50)
					return trigger_change(2)
					
			if(2)
				if(events_since_stage_change >= 5)
					if(asteroid_aggression < 50)
						return trigger_change(1)
					if(asteroid_aggression >= 100)
						return trigger_change(3)
			
			if(3)
				if(events_since_stage_change >= 5)
					if(asteroid_aggression < 100)
						return trigger_change(2)
					if(asteroid_aggression >= 150)
						return trigger_change(4)
			if(4)
				if(events_since_stage_change >= 10)
					if(asteroid_aggression < 150)
						return trigger_change(3)
					if(asteroid_aggression >= 200)
						return trigger_change(5)
			if(5)
				if(events_since_stage_change >= 10)
					if(asteroid_aggression < 200)
						return trigger_change(4)
		trigger_wave(asteroid_stage)			
		clear_targets()
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
