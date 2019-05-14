/proc/UpdateCharacter(var/ind, var/ckey)
	var/savefile/F = new(load_path(ckey, "[ind].sav"))
	var/mob/M
	from_file(F, M)
	fdel(F)
	to_file(F["name"], M.real_name)
	to_file(F["mob"], M)
	qdel(M)
	
/proc/Character(var/ind, var/ckey)
	if(!fexists(load_path(ckey, "[ind].sav")))
		return

	var/savefile/F = new(load_path(ckey, "[ind].sav"))
	var/mob/M
	if(!F.dir.Find("mob"))
		from_file(F, M)
		sleep(10)
		return M
	from_file(F["mob"], M)
	return M

/proc/CharacterName(var/ind, var/ckey)
	if(!fexists(load_path(ckey, "[ind].sav")))
		return

	var/savefile/F = new(load_path(ckey, "[ind].sav"))
	var/name
	if(!F.dir.Find("name"))
		var/mob/M
		from_file(F, M)
		sleep(10)
		return M.real_name
	from_file(F["name"], name)
	return name

/proc/CharacterIcon(var/ind, var/ckey)
	if(!fexists(load_path(ckey, "[ind].sav")))
		return

	var/mob/M = Character(ind, ckey)
	M.regenerate_icons()
	var/icon/I = get_preview_icon(M)
	qdel(M)
	return I