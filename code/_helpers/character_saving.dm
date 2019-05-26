/proc/load_path(ckey,filename="preferences.sav")
	if(!ckey)	return
	return "data/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename]"

/proc/beta_path(ckey,filename="preferences.sav")
	if(!ckey) return
	return "exports/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename]"

/proc/exit_path(ckey,filename="preferences.sav")
	if(!ckey)	return
	return "exits/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename]"

#define CHAR_SAVE_FILE_PATH(slot, ckey) load_path(ckey, "[slot].sav")
#define CHAR_SAVE_FILE(slot, ckey) new(CHAR_SAVE_FILE_PATH(slot, ckey))

// /proc/UpdateCharacter(var/ind, var/ckey)
// 	var/savefile/F = CHAR_SAVE_FILE(ind, ckey)
// 	var/mob/M
// 	from_file(F, M)
// 	fdel(F)
// 	to_file(F["name"], M.real_name)
// 	to_file(F["mob"], M)
// 	qdel(M)
	
// /proc/Character(var/ind, var/ckey)
// 	if(!fexists(CHAR_SAVE_FILE_PATH(ind, ckey)))
// 		return

// 	var/savefile/F = CHAR_SAVE_FILE(ind, ckey)
// 	var/mob/M
// 	if(!F.dir.Find("mob"))
// 		from_file(F, M)
// 		sleep(10)
// 		return M
// 	from_file(F["mob"], M)
// 	return M

// /proc/CharacterName(var/ind, var/ckey)
// 	if(!fexists(CHAR_SAVE_FILE_PATH(ind, ckey)))
// 		return

// 	var/savefile/F = CHAR_SAVE_FILE(ind, ckey)
// 	var/name
// 	if(!F.dir.Find("name"))
// 		var/mob/M
// 		from_file(F, M)
// 		sleep(10)
// 		return M.real_name
// 	from_file(F["name"], name)
// 	return name

// /proc/CharacterIcon(var/ind, var/ckey)
// 	if(!fexists(CHAR_SAVE_FILE_PATH(ind, ckey)))
// 		return

// 	var/mob/M = Character(ind, ckey)
// 	M.regenerate_icons()
// 	var/icon/I = get_preview_icon(M)
// 	qdel(M)
// 	return I