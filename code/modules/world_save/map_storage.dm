/datum
	var/should_save = 1
	var/map_storage_saved_vars = ""

/turf
	map_storage_saved_vars = "density;icon_state;name;pixel_x;pixel_y;contents"
/obj
	map_storage_saved_vars = "density;icon_state;name;pixel_x;pixel_y;contents"
/client/verb/SaveWorld()
	Save_World()
/client/verb/LoadWorld()
	Load_World()
var/atom/movable/lighting_overlay/should_save = 0
/datum/Write(savefile/f)
	var/list/saving
	if(found_vars.Find("[type]"))
		saving = found_vars["[type]"]
	else
		saving = get_saved_vars()
		found_vars["[type]"] = saving
	for(var/ind in 1 to saving.len)
		var/variable = saving[ind]
		CHECK_TICK
		if(vars[variable] == initial(vars[variable]))
			continue
		f["[variable]"] << vars[variable]
	return

/atom/Write(savefile/f)
	if(!should_save)
		return 0
	var/list/saving
	if(found_vars.Find("[type]"))
		saving = found_vars["[type]"]
	else
		saving = get_saved_vars()
		found_vars["[type]"] = saving
	for(var/ind in 1 to saving.len)
		var/variable = saving[ind]
		CHECK_TICK
		if(vars[variable] == initial(vars[variable]))
			continue
		f["[variable]"] << vars[variable]
	return
/atom/movable/Write(savefile/f)
	if(!should_save)
		return 0
	var/list/saving
	if(found_vars.Find("[type]"))
		saving = found_vars["[type]"]
	else
		saving = get_saved_vars()
		found_vars["[type]"] = saving
	for(var/ind in 1 to saving.len)
		var/variable = saving[ind]
		CHECK_TICK
		if(vars[variable] == initial(vars[variable]))
			continue
		f["[variable]"] << vars[variable]
	return
/obj/Write(savefile/f)
	if(!should_save)
		return 0
	var/list/saving
	if(found_vars.Find("[type]"))
		saving = found_vars["[type]"]
	else
		saving = get_saved_vars()
		found_vars["[type]"] = saving
	for(var/ind in 1 to saving.len)
		var/variable = saving[ind]
		CHECK_TICK
		if(vars[variable] == initial(vars[variable]))
			continue
		f["[variable]"] << vars[variable]
	return

/turf/Write(savefile/f)
	if(!should_save)
		return 0
	var/list/saving
	if(found_vars.Find("[type]"))
		saving = found_vars["[type]"]
	else
		saving = get_saved_vars()
		found_vars["[type]"] = saving
	for(var/ind in 1 to saving.len)
		var/variable = saving[ind]
		CHECK_TICK
		if(vars[variable] == initial(vars[variable]))
			continue
		f["[variable]"] << vars[variable]
	return
/mob/Write(savefile/f)
	if(!should_save)
		return 0
	var/list/saving
	var/starttime = REALTIMEOFDAY
	if(found_vars.Find("[type]"))
		saving = found_vars["[type]"]
	else
		saving = get_saved_vars()
		found_vars["[type]"] = saving
	for(var/ind in 1 to saving.len)
		var/variable = saving[ind]
		CHECK_TICK
		if(vars[variable] == initial(vars[variable]))
			continue
		f["[variable]"] << vars[variable]
	return

/datum/Read(savefile/f)
	for(var/ind in 1 to f.dir.len)
		var/variable = f.dir[ind]
		var/to_set
		f.dir[variable] >> to_set
		vars[variable] = to_set

var/global/list/found_vars = list()
/proc/Save_World()
	var/starttime = REALTIMEOFDAY
	spawn(0)
		fdel("map_saves/game.sav")
		var/savefile/f = new("map_saves/game.sav")
		found_vars = list()
		for(var/z = 1, z <= 3, z++)
			for(var/x = 1, x <= 200, x += 20)
				for(var/y = 1, y <= 200, y += 20)
					Save_Chunk(x,y,z, f)
					sleep(1)


		world << "Saving Completed in [(REALTIMEOFDAY - starttime)/10] seconds!"
		world << "Saving Complete"
	return 1

/proc/Save_Chunk(var/xi, var/yi, var/zi, var/savefile/f)

	var/z = zi
	xi = (xi - (xi % 20) + 1)
	yi = (yi - (yi % 20) + 1)
	f.cd = "/[z]/Chunk([yi]|[xi])"
	var/list/L = new()
	for(var/y = yi, y <= yi + 20, y++)
		for(var/x = xi, x <= xi + 20, x++)
			var/turf/T = locate(x,y,z)
			if(!T || (T.type == /turf/space && (!T.contents || !T.contents.len)))
				continue
			L["[x]-[y]"] = T
	f["L"] << L


/proc/Load_World()
	spawn(5)
		for(var/z = 1, z <= 3, z++)
			for(var/x = 1, x <= 200, x += 20)
				sleep(10)
				for(var/y = 1, y <= 200, y += 20)
					Load_Chunk(x,y,z)
					world << "Loaded [x]-[y]-[z]"
					CHECK_TICK
		world << "Loading Complete"
	return 1
/proc/Load_Chunk(var/xi, var/yi, var/zi, var/savefile/f = new("map_saves/game.sav"))
	var/z = zi
	for(var/x = xi, x <= xi + 20, x++)
		for(var/y = yi, y <= yi + 20, y++)
			f.cd = "/[z]"
			var/turf/T = locate(x,y,z)
			for(var/o in T.contents)
				qdel(o)
			f["[x]-[y]"] >> T

/datum/proc/remove_saved(var/ind)
	var/A = src.type
	var/B = replacetext("[A]", "/", "-")
	var/savedvarparams = file2text("saved_vars/[B].txt")
	if(!savedvarparams)
		savedvarparams = ""
	var/list/saved_vars = params2list(savedvarparams)
	if(saved_vars.len < ind)
		message_admins("remove_saved saved_vars less than ind [src]")
		return
	saved_vars.Cut(ind, ind+1)
	savedvarparams = list2params(saved_vars)
	fdel("saved_vars/[B].txt")
	text2file(savedvarparams, "saved_vars/[B].txt")
/datum/proc/add_saved(var/mob/M)
	if(!check_rights(R_ADMIN, 1, M))
		return
	var/input = input(M, "Enter the name of the var you want to save", "Add var","") as text|null
	if(!hasvar(src, input))
		to_chat(M, "The [src] does not have this var")
		return

	var/A = src.type
	var/B = replacetext("[A]", "/", "-")
	var/C = B
	var/savedvarparams = file2text("saved_vars/[B].txt")
	message_admins("savedvarparams: | [savedvarparams] | saved_vars/[B].txt")
	if(!savedvarparams)
		savedvarparams = ""
	var/list/savedvars = params2list(savedvarparams)
	var/list/newvars = list()
	if(savedvars && savedvars.len)
		newvars = savedvars.Copy()
	var/list/found_vars = list()
	var/list/split = splittext(B, "-")
	var/list/subtypes = list()
	if(split && split.len)
		for(var/x in split)
			if(x == "") continue
			var/subtypes_text = ""
			for(var/xa in subtypes)
				subtypes_text += "-[xa]"
			var/savedvarparamss = file2text("saved_vars/[subtypes_text]-[x].txt")
			message_admins("savedvarparamss: [savedvarparamss] dir: saved_vars/[subtypes_text]-[x].txt")
			var/list/saved_vars = params2list(savedvarparamss)
			if(saved_vars && saved_vars.len)
				found_vars |= saved_vars
			subtypes += x
	if(found_vars && found_vars.len)
		savedvars |= found_vars
	if(savedvars.Find(input))
		to_chat(M, "The [src] already saves this var")
		return
	newvars |= input
	savedvarparams = list2params(newvars)
	fdel("saved_vars/[C].txt")
	text2file(savedvarparams, "saved_vars/[C].txt")
/datum/proc/get_saved_vars()
	var/list/to_save = list()
	to_save |= params2list(map_storage_saved_vars)
	var/A = src.type
	var/B = replacetext("[A]", "/", "-")
	var/savedvarparams = file2text("saved_vars/[B].txt")
	if(!savedvarparams)
		savedvarparams = ""
	var/list/savedvars = params2list(savedvarparams)
	if(savedvars && savedvars.len)

	for(var/v in savedvars)
		if(findtext(v, "\n"))
			var/list/split2 = splittext(v, "\n")
			to_save |= split2[1]
		else
			to_save |= v
	var/list/found_vars = list()
	var/list/split = splittext(B, "-")
	var/list/subtypes = list()
	if(split && split.len)
		for(var/x in split)
			if(x == "") continue
			var/subtypes_text = ""
			for(var/xa in subtypes)
				subtypes_text += "-[xa]"
			var/savedvarparamss = file2text("saved_vars/[subtypes_text]-[x].txt")
			var/list/saved_vars = params2list(savedvarparamss)
			for(var/v in saved_vars)
				if(findtext(v, "\n"))
					var/list/split2 = splittext(v, "\n")
					found_vars |= split2[1]
				else
					found_vars |= v
			subtypes += x
	if(found_vars && found_vars.len)
		to_save |= found_vars
	return to_save
/datum/proc/add_saved_var(var/mob/M)
	if(!check_rights(R_ADMIN, 1, M))
		return
	var/A = src.type
	var/B = replacetext("[A]", "/", "-")
	var/C = B
	var/found = 1
	var/list/found_vars = list()
	var/list/split = splittext(B, "-")
	var/list/subtypes = list()
	if(split && split.len)
		for(var/x in split)
			if(x == "") continue
			var/subtypes_text = ""
			for(var/xa in subtypes)
				subtypes_text += "-[xa]"
			var/savedvarparams = file2text("saved_vars/[subtypes_text]-[x].txt")
			message_admins("savedvarparams: [savedvarparams] dir: saved_vars/[subtypes_text]-[x].txt")
			var/list/saved_vars = params2list(savedvarparams)
			if(saved_vars && saved_vars.len)
				found_vars |= saved_vars
			subtypes += x
	var/savedvarparams = file2text("saved_vars/[C].txt")
	message_admins("savedvarparams: [savedvarparams] saved_vars/[C].txt")
	if(!savedvarparams)
		savedvarparams = ""
	var/list/saved_vars = params2list(savedvarparams)
	var/dat = "<b>Saved Vars:</b><br><hr>"
	dat += "<b><u>Inherited</u></b><br><hr>"
	for(var/x in found_vars)
		dat += "[x]<br>"
	dat += "<b><u>For this Object</u></b><br><hr>"
	var/ind = 0
	for(var/x in saved_vars)
		ind++
		dat += "[x] <a href='?_src_=savevars;Remove=[ind];Vars=\ref[src]'>(Remove)</a><br>"
	dat += "<hr><br>"
	dat += "<a href='?_src_=savevars;Vars=\ref[src];Add=1'>(Add new var)</a>"
	M << browse(dat, "window=roundstats;size=500x600")
