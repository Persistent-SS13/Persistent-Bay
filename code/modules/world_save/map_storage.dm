var/global/list/found_vars = list()
var/global/list/all_loaded = list()
var/global/list/saved = list()


/obj/item/map_storage_debugger
	name = "DEBUG ITEM"
	desc = "DEBUG ITEM"
	icon = 'icons/obj/device.dmi'
	icon_state = "eftpos"
	var/list/spawned = list()

/obj/item/map_storage_debugger/attack_self(mob/user)
	var/type_path = input(user, "Enter the typepath you want spawned", "debugger","") as text|null
	var/datum/D = new type_path()
	if(D)
		spawned |= D
	else
		to_chat(user, "No datum of type [type_path]")
/datum
	var/should_save = 1
	var/map_storage_saved_vars = ""

/atom/movable/lighting_overlay
	should_save = 0

/turf
	map_storage_saved_vars = "density;icon_state;name;pixel_x;pixel_y;contents;dir"

/obj
	map_storage_saved_vars = "density;icon_state;name;pixel_x;pixel_y;contents;dir"

/area
	map_storage_saved_vars = "name;power_equip;power_light;power_environ;always_unpowered;uid;global_uid"

/datum/proc/after_load()
	return

/datum/proc/before_load()
	return

/turf/after_load()
	..()
	lighting_build_overlay()

/atom/movable/lighting_overlay/after_load()
	loc = null
	qdel(src)
/mob/living/carbon/human/after_load()
	..()
	regenerate_icons()
	redraw_inv()
/datum/SaveList
	var/list/InList

/datum/SaveList/New(var/num)
	if(num)
		InList = new(num)
	else
		InList = new()

/datum/SaveList/proc/Add(var/object)
	InList.Add(object)

/datum/SaveList/Write(savefile/f)
	for(var/turf/T in InList)
		f["[T.x]-[T.y]-[T.z]"] << T
/datum/SaveList/Read(savefile/f)
	var/v = null
	for(var/variable in f.dir)
		f[variable] >> v
	
/datum/proc/StandardWrite(var/savefile/f)
	var/list/saving
	if(found_vars.Find("[type]"))
		saving = found_vars["[type]"]
	else
		saving = get_saved_vars()
		found_vars["[type]"] = saving

	for(var/ind in 1 to saving.len)
		var/variable = saving[ind]
		if(vars[variable] == initial(vars[variable]))
			continue
		f["[variable]"] << vars[variable]

/datum/Write(savefile/f)
	var/list/saving
	if(found_vars.Find("[type]"))
		saving = found_vars["[type]"]
	else
		saving = get_saved_vars()
		found_vars["[type]"] = saving

	for(var/ind in 1 to saving.len)
		var/variable = saving[ind]
		if(vars[variable] == initial(vars[variable]))
			continue
		f["[variable]"] << vars[variable]


/atom/Write(savefile/f)
	var/list/saving
	if(found_vars.Find("[type]"))
		saving = found_vars["[type]"]
	else
		saving = get_saved_vars()
		found_vars["[type]"] = saving

	for(var/ind in 1 to saving.len)
		var/variable = saving[ind]
		if(vars[variable] == initial(vars[variable]))
			continue
		f["[variable]"] << vars[variable]


/atom/movable/Write(savefile/f)
	var/list/saving
	if(found_vars.Find("[type]"))
		saving = found_vars["[type]"]
	else
		saving = get_saved_vars()
		found_vars["[type]"] = saving

	for(var/ind in 1 to saving.len)
		var/variable = saving[ind]
		if(vars[variable] == initial(vars[variable]))
			continue
		f["[variable]"] << vars[variable]


/obj/Write(savefile/f)
	var/list/saving
	if(found_vars.Find("[type]"))
		saving = found_vars["[type]"]
	else
		saving = get_saved_vars()
		found_vars["[type]"] = saving

	for(var/ind in 1 to saving.len)
		var/variable = saving[ind]
		if(vars[variable] == initial(vars[variable]))
			continue
		f["[variable]"] << vars[variable]

/turf/Write(savefile/f)
	var/list/saving
	if(found_vars.Find("[type]"))
		saving = found_vars["[type]"]
	else
		saving = get_saved_vars()
		found_vars["[type]"] = saving

	for(var/ind in 1 to saving.len)
		var/variable = saving[ind]
		if(vars[variable] == initial(vars[variable]))
			continue
		f["[variable]"] << vars[variable]


/mob/Write(savefile/f)
	var/list/saving
	if(found_vars.Find("[type]"))
		saving = found_vars["[type]"]
	else
		saving = get_saved_vars()
		found_vars["[type]"] = saving

	for(var/ind in 1 to saving.len)
		var/variable = saving[ind]
		if(vars[variable] == initial(vars[variable]))
			continue
		f["[variable]"] << vars[variable]
/area/Write(savefile/f)
	var/list/saving
	if(found_vars.Find("[type]"))
		saving = found_vars["[type]"]
	else
		saving = get_saved_vars()
		found_vars["[type]"] = saving

	for(var/ind in 1 to saving.len)
		var/variable = saving[ind]
		if(vars[variable] == initial(vars[variable]))
			continue
		f["[variable]"] << vars[variable]

/datum/proc/StandardRead(var/savefile/f)
	var/list/loading
	all_loaded |= src
	if(found_vars.Find("[type]"))
		loading = found_vars["[type]"]
	else
		loading = get_saved_vars()
		found_vars["[type]"] = loading

	for(var/ind in 1 to loading.len)
		var/variable = loading[ind]
		f["[variable]"] >> vars[variable]

/datum/Read(savefile/f)
	var/list/loading
	all_loaded |= src
	if(found_vars.Find("[type]"))
		loading = found_vars["[type]"]
	else
		loading = get_saved_vars()
		found_vars["[type]"] = loading

	for(var/ind in 1 to loading.len)
		var/variable = loading[ind]
		f["[variable]"] >> vars[variable]

/turf/Read(savefile/f)
	var/list/loading
	all_loaded |= src
	if(found_vars.Find("[type]"))
		loading = found_vars["[type]"]
	else
		loading = get_saved_vars()
		found_vars["[type]"] = loading

	for(var/ind in 1 to loading.len)
		var/variable = loading[ind]
		f["[variable]"] >> vars[variable]

/area/Read(savefile/f)
	var/list/loading
	all_loaded |= src
	if(found_vars.Find("[type]"))
		loading = found_vars["[type]"]
	else
		loading = get_saved_vars()
		found_vars["[type]"] = loading

	for(var/ind in 1 to loading.len)
		var/variable = loading[ind]
		f["[variable]"] >> vars[variable]
/proc/Save_Chunk(var/xi, var/yi, var/zi, var/savefile/f)
	var/z = zi
	xi = (xi - (xi % 20) + 1)
	yi = (yi - (yi % 20) + 1)
	var/list/lis = list()
	for(var/y in yi to yi + 20)
		for(var/x in xi to xi + 20)
			var/turf/T = locate(x,y,z)
			if(!T || (T.type == /turf/space && (!T.contents || !T.contents.len)))
				continue
			f << T
/proc/Save_World()
	world << "The World has paused to write to file; Remain connected, this process usually takes less than 30 seconds."
	var/starttime = REALTIMEOFDAY
	fdel("map_saves/game.sav")
	var/savefile/f = new("map_saves/game.sav")
	var/datum/SaveList/L = new()
	found_vars = list()
	for(var/z in 1 to 5)
		var/starttime2 = REALTIMEOFDAY
		var/list/turfs = block(locate(1,1,z),locate(world.maxx,world.maxy,z))
		for(var/turf/T in turfs)
			if(T.type == /turf/space && (!T.contents || !T.contents.len))
				turfs -= T
		
		f << turfs
		message_admins("Z: [z] saved in [(REALTIMEOFDAY - starttime2)/10] seconds.")
		CHECK_TICK
	f.cd = "/extras"
	f["records"] << GLOB.all_crew_records
	world << "Saving Completed in [(REALTIMEOFDAY - starttime)/10] seconds!"
	world << "Saving Complete"

	return 1

/proc/Load_World()
	var/starttime = REALTIMEOFDAY
	if(!fexists("map_saves/game.sav")) return
	var/savefile/f = new("map_saves/game.sav")
	all_loaded = list()
	found_vars = list()
	var/v = null
	var/ind2 = 0
	while(!f.eof)
		ind2++
		var/starttime2 = REALTIMEOFDAY
		f >> v
		message_admins("Z: [ind2] loaded in [(REALTIMEOFDAY - starttime2)/10] seconds.")
		CHECK_TICK
	for(var/ind in 1 to all_loaded.len)
		var/datum/dat = all_loaded[ind]
		dat.after_load()
		if(istype(dat,/atom/))
			var/atom/A = dat
			A.Initialize()
	all_loaded = list()
	SSmachines.makepowernets()
	f.cd = "/extras"
	f["records"] >> GLOB.all_crew_records
	world << "Loading Completed in [(REALTIMEOFDAY - starttime)/10] seconds!"
	world << "Loading Complete"
	return 1

/proc/Load_Chunk(var/xi, var/yi, var/zi, var/savefile/f)
	var/z = zi
	xi = (xi - (xi % 20) + 1)
	yi = (yi - (yi % 20) + 1)
	f.cd = "/[z]/Chunk|[yi]|[xi]"
	for(var/y in yi to yi + 20)
		for(var/x in xi to xi + 20)
			var/turf/T = locate(x,y,z)
			f["[x]-[y]"] >> T

/proc/Load_Initialize()
	for(var/ind in 1 to all_loaded.len)
		var/datum/dat = all_loaded[ind]
		dat.after_load()
		if(istype(dat,/atom/))
			var/atom/A = dat
			A.Initialize()
	SSmachines.makepowernets()

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
		dat += "[x] <a href='?_src_=vars;Remove_Var=[ind];Varsx=\ref[src]'>(Remove)</a><br>"
	dat += "<hr><br>"
	dat += "<a href='?_src_=vars;Varsx=\ref[src];Add_Var=1'>(Add new var)</a>"
	M << browse(dat, "window=roundstats;size=500x600")
