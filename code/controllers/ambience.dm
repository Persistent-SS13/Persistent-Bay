var/datum/controller/ambient_controller/ambient_controller


/datum/music_file
	var/length
	var/path

// ACTION
/datum/music_file/crystal_space
	length = 4 MINUTES + 52 SECONDS
	path = 'sound/ambience/new/action/crystal space (long, exciting).ogg'
/datum/music_file/planetrise
	length = 3 MINUTES + 10 SECONDS
	path = 'sound/ambience/new/action/Planetrise v1_0 (medium, exciting).ogg'
// DARK
/datum/music_file/darkambience
	length = 38 SECONDS
	path = 'sound/ambience/new/dark/Iwan Gabovitch - Dark Ambience Loop (super short, tensedark).ogg'
/datum/music_file/caveambience
	length = 2 MINUTES + 3 SECONDS
	path = 'sound/ambience/new/dark/radakan - cave ambience (short, mysterious).ogg'
//FUN
/datum/music_file/restoration
	length = 4 MINUTES + 50 SECONDS
	path = 'sound/ambience/new/fun/restoration completed (long, jazzy).ogg'
/datum/music_file/urban
	length = 3 MINUTES + 32 SECONDS
	path = 'sound/ambience/new/fun/UrbanTheme (medium, jazzy).ogg'
// NEUTRAL
/datum/music_file/bazaarnet
	length = 5 MINUTES + 14 SECONDS
	path = 'sound/ambience/new/neutral/bazaarnet (long, neutral).ogg'
/datum/music_file/factory
	length = 2 MINUTES + 3 SECONDS
	path = 'sound/ambience/new/neutral/Factory (short, neutral).ogg'
/datum/music_file/jewels
	length = 1 MINUTES + 26 SECONDS
	path = 'sound/ambience/new/neutral/music_jewels (short, neutral).ogg'
/datum/music_file/theclient
	length = 4 MINUTES + 48 SECONDS
	path = 'sound/ambience/new/neutral/the client (long, neutral).ogg'


/datum/music_controller
	var/tone = "none"
	var/timetostop = 0
	var/datum/music_file/lastplayed
/datum/music_controller/proc/should_play()
	if(timetostop < world.time && tone != "none")
		return tone
/datum/controller/ambient_controller
	var/list/zlevel_data
	var/list/neutral
	var/list/dark
	var/list/fun
	var/list/action
/datum/controller/ambient_controller/New()
	action = list()
	action |= new /datum/music_file/crystal_space()
	action |= new /datum/music_file/planetrise()
	dark = list()
	dark |= new /datum/music_file/darkambience()
	dark |= new /datum/music_file/caveambience()
	fun = list()
	fun |= new /datum/music_file/restoration()
	fun |= new /datum/music_file/urban()
	neutral = list()
	neutral |= new /datum/music_file/bazaarnet()
	neutral |= new /datum/music_file/factory()
	neutral |= new /datum/music_file/jewels()
	neutral |= new /datum/music_file/theclient()

	zlevel_data = list()
	zlevel_data["2"] = new /datum/music_controller()
	zlevel_data["4"] = new /datum/music_controller()
	zlevel_data["6"] = new /datum/music_controller()
	zlevel_data["8"] = new /datum/music_controller()
	zlevel_data["10"] = new /datum/music_controller()
	zlevel_data["12"] = new /datum/music_controller()
	zlevel_data["14"] = new /datum/music_controller()
	zlevel_data["16"] = new /datum/music_controller()
	zlevel_data["18"] = new /datum/music_controller()
	zlevel_data["20"] = new /datum/music_controller()
	zlevel_data["22"] = new /datum/music_controller()
	zlevel_data["24"] = new /datum/music_controller()
	zlevel_data["26"] = new /datum/music_controller()
	zlevel_data["28"] = new /datum/music_controller()
	zlevel_data["30"] = new /datum/music_controller()
	zlevel_data["32"] = new /datum/music_controller()
	zlevel_data["34"] = new /datum/music_controller()
	zlevel_data["36"] = new /datum/music_controller()
	zlevel_data["38"] = new /datum/music_controller()
	zlevel_data["40"] = new /datum/music_controller()
	zlevel_data["42"] = new /datum/music_controller()
	zlevel_data["44"] = new /datum/music_controller()
	zlevel_data["46"] = new /datum/music_controller()
	zlevel_data["48"] = new /datum/music_controller()
	zlevel_data["50"] = new /datum/music_controller()
	START_PROCESSING(SSprocessing, src)

/datum/controller/ambient_controller/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	. = ..()


/datum/controller/ambient_controller/Process()
	var/list/to_play = list()
	var/any_play = 0
	for(var/x in zlevel_data)
		var/datum/music_controller/controller = zlevel_data[x]
		if(controller)
			var/tone = controller.should_play()
			if(tone)
				any_play = 1
				to_play[x] = tone
			else
				to_play[x] = "none"
		else
			zlevel_data[x] = new /datum/music_controller()
			to_play[x] = "none"
	if(any_play)
		for(var/x in to_play)
			var/datum/music_controller/controller = zlevel_data[x]
			switch(to_play[x])
				if("neutral")
					var/list/choices = neutral.Copy()
					if(choices.len > 1)
						choices -= controller.lastplayed
					to_play[x] = pick(choices)
					to_play["[text2num(x)-1]"] = to_play[x]
					controller.lastplayed = to_play[x]
					controller.timetostop = controller.lastplayed.length + world.time
				if("fun")
					var/list/choices = fun.Copy()
					if(choices.len > 1)
						choices -= controller.lastplayed
					to_play[x] = pick(choices)
					to_play["[text2num(x)-1]"] = to_play[x]
					controller.lastplayed = to_play[x]
					controller.timetostop = controller.lastplayed.length + world.time
				if("dark")
					var/list/choices = dark.Copy()
					if(choices.len > 1)
						choices -= controller.lastplayed
					to_play[x] = pick(choices)
					to_play["[text2num(x)-1]"] = to_play[x]
					controller.lastplayed = to_play[x]
					controller.timetostop = controller.lastplayed.length + world.time
				if("action")
					var/list/choices = action.Copy()
					if(choices.len > 1)
						choices -= controller.lastplayed
					to_play[x] = pick(choices)
					to_play["[text2num(x)-1]"] = to_play[x]
					controller.lastplayed = to_play[x]
					controller.timetostop = controller.lastplayed.length + world.time
		for(var/client/C in GLOB.clients)
			if(!(C && C.get_preference_value(/datum/client_preference/play_ambiance) == GLOB.PREF_YES))	continue
			var/mob/M = C.mob
			if(M && to_play["[M.z]"] && C.get_preference_value(/datum/client_preference/play_ambiance) == GLOB.PREF_YES)
				var/turf/T = M.loc
				var/datum/music_file/file = to_play["[M.z]"]
				if(file)
					M.playsound_local(T, sound(file.path, repeat = 0, wait = 0, volume = 15, channel = 1))
				else
					M.playsound_local(T, sound(null, repeat = 0, wait = 0, volume = 15, channel = 1))