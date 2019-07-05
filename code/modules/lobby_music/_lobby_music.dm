// Include the lobby music tracks to automatically add them to the random selection.

/lobby_music
	var/artist
	var/title
	var/album
	var/license
	var/song
	var/url // Remember to include http:// or https://

/lobby_music/proc/play_to(var/listener)
	if(!song)
		return
	to_chat(listener, "<span class='good'>Now Playing:</span>")
	to_chat(listener, "<span class='good'>[title][artist ? " by [artist]" : ""][album ? " ([album])" : ""]</span>")
	if(url)
		to_chat(listener, url)
	if(license)
		var/license_url = license_to_url[license]
		to_chat(listener, "<span class='good'>License: [license_url ? "<a href='[license_url]'>[license]</a>" : license]</span>")
	var/sound/track = sound(song, repeat = 1, wait = 0, volume = 30, channel = GLOB.lobby_sound_channel)
	track.priority = 254 //Should take over anything else trying to play stuff on the lobby channel
	track.status = SOUND_STREAM //Better for playing music, uses less resources
	track.environment = 0 //Avoid having the music affected by areas on the map (was a bug)
	track.echo = null
	sound_to(listener, track)
