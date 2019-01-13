SUBSYSTEM_DEF(music)
	name = "Music"

	var/list/genres = list()			// Associative list of lists where genres[genre] is a list of music in that genre
	var/list/zLevelAmbience = list()	// Associative list where zLevelAmbience[z] is the z level music controller

/datum/controller/subsystem/music/Initialize()
	for(var/path in subtypesof(/datum/music_file))
		var/datum/music_file/musicFile = new path()
		for(var/genre in musicFile.genres)
			LAZYADD(genres[genre], musicFile)

	for(var/Z in 1 to world.maxz)
		var/datum/music_controller/musicPlayer = new()
		musicPlayer.genre = list()
		zLevelAmbience["[Z]"] = musicPlayer

	. = ..()

/datum/controller/subsystem/music/fire()
	var/list/toPlay = list()

	for(var/Z in 1 to world.maxz)
		var/datum/music_controller/musicPlayer = zLevelAmbience["[Z]"]
		if(musicPlayer.genre && musicPlayer.stopTime <= world.time)
			var/datum/music_file/musicFile = DEFAULTPICK(GetMusicByGenre(musicPlayer.genre) - musicPlayer.lastPlayed, null)
			if(musicFile)
				musicPlayer.lastPlayed = musicFile
				musicPlayer.stopTime = world.time + musicFile.length
				toPlay["[Z]"] = musicFile

	for(var/client/C in GLOB.clients)
		if(C.mob && C.get_preference_value(/datum/client_preference/play_ambience) == GLOB.PREF_YES)
			var/mob/M = C.mob
			if(M.z)
				var/datum/music_file/musicFile = toPlay["[M.z]"]

				if(musicFile)
					sound_to(M, sound(musicFile.path, repeat = 0, wait = 0, volume = 30, channel = 1))

/datum/controller/subsystem/music/proc/GetMusicByGenre(var/G)
	var/list/search = list()
	if(istext(G))
		search = genres[G]
		return search

	if(islist(G) && length(G))
		search = genres[pick(G)]
		for(var/genre in G)
			search &= genres[genre]

		return search
