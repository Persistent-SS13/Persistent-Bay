/datum/music_file
	var/name
	var/genres = list()
	var/length = 0
	var/path

/datum/music_controller
	var/stopTime = 0
	var/genre = list()
	var/tmp/datum/music_file/lastPlayed
