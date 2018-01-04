var/global/list/found_vars = list()
var/global/list/all_loaded = list()
var/global/list/saved = list()
var/global/list/areas_to_save = list()
var/global/list/zones_to_save = list()

/datum/area_holder
	var/area_type = "/area"
	var/name
	var/list/turfs = list()
	map_storage_saved_vars = "area_type;name;turfs"

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
	map_storage_saved_vars = ""
/datum/proc/should_save(var/datum/saver)
	return should_save

/datum/proc/after_load()
	return
/area/after_load()
	power_change()
/datum/proc/before_load()
	return

/turf/after_load()
	..()
	update_icon()
	lighting_build_overlay()

/atom/movable/lighting_overlay/after_load()
	loc = null
	qdel(src)
/mob/living/carbon/human/after_load()
	..()
	regenerate_icons()
	redraw_inv()

/datum/proc/StandardWrite(var/savefile/f)
	var/list/saving
	if(found_vars.Find("[type]"))
		saving = found_vars["[type]"]
	else
		saving = get_saved_vars()
		found_vars["[type]"] = saving

	for(var/ind in 1 to saving.len)
		var/variable = saving[ind]
		if(!hasvar(src, variable))
			continue
		if(vars[variable] == initial(vars[variable]))
			continue
		var/list/return_this = list()
		if(istype(vars[variable], /datum))
			var/datum/D = vars[variable]
			if(!D.should_save(src))
				continue
		if(istype(vars[variable], /list))
			var/list/D = vars[variable]
			for(var/datum/dat in D)
				if(!dat.should_save(src))
					D -= dat
					return_this += dat
		f["[variable]"] << vars[variable]
		if(return_this.len)
			var/list/D = vars[variable]
			D += return_this

/datum/Write(savefile/f)
	StandardWrite(f)

/atom/Write(savefile/f)
	StandardWrite(f)

/atom/movable/Write(savefile/f)
	StandardWrite(f)

/obj/Write(savefile/f)
	StandardWrite(f)

/turf/Write(savefile/f)
	areas_to_save |= loc
	StandardWrite(f)
/turf/simulated/Write(savefile/f)
	if(zone)
		zones_to_save |= zone
	areas_to_save |= loc
	StandardWrite(f)

/mob/Write(savefile/f)
	if(StandardWrite(f))
		return

/area/proc/get_turf_coords()
	var/list/coord_list = list()
	var/ind = 0
	for(var/turf/T in contents)
		ind++
		coord_list += "[ind]"
		coord_list[ind] = list(T.x, T.y, T.z)
	return coord_list
/zone/proc/get_turf_coords()
	var/list/coord_list = list()
	var/ind = 0
	for(var/turf/T in contents)
		ind++
		coord_list += "[ind]"
		coord_list[ind] = list(T.x, T.y, T.z)
	return coord_list

/datum/proc/StandardRead(var/savefile/f)
	before_load()
	var/list/loading
	if(all_loaded)
		all_loaded |= src

	if(found_vars.Find("[type]"))
		loading = found_vars["[type]"]
	else
		loading = get_saved_vars()
		found_vars["[type]"] = loading

	for(var/ind in 1 to loading.len)
		var/variable = loading[ind]
		if(f.dir.Find("[variable]"))
			try
				f["[variable]"] >> vars[variable]
			catch

/datum/Read(savefile/f)
	StandardRead(f)
/atom/movable/Read(savefile/f)
	contents = list()
	StandardRead(f)
/obj/item/weapon/storage/Read(savefile/f)
	for(var/atom/movable/am in contents)
		am.loc = null
	startswith = list()
	StandardRead(f)
/turf/Read(savefile/f)
	StandardRead(f)

/area/Read(savefile/f)
	return 0
	
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
			lis |= T
	f << lis
/proc/Save_World()
	areas_to_save = list()
	zones_to_save = list()
	var/starttime = REALTIMEOFDAY
	fdel("map_saves/game.sav")
	var/savefile/f = new("map_saves/game.sav")
	found_vars = list()
	for(var/z in 1 to 11)
		f.cd = "/map/[z]"
		for(var/x in 1 to world.maxx step 20)
			for(var/y in 1 to world.maxy step 20)
				Save_Chunk(x,y,z, f)
				CHECK_TICK
	f.cd = "/extras"
	var/list/formatted_areas = list()
	for(var/area/A in areas_to_save)
		if(istype(A, /area/space)) continue
		var/datum/area_holder/holder = new()
		holder.area_type = A.type
		holder.name = A.name
		holder.turfs = A.get_turf_coords()
		formatted_areas += holder
	var/list/zones = list()
	for(var/zone/Z in zones_to_save)
		Z.turf_coords = Z.get_turf_coords()
		zones |= Z
	f["zones"] << zones
	f["areas"] << formatted_areas
	f["turbolifts"] << turbolifts
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
	f.cd = "/extras"
	f["records"] >> GLOB.all_crew_records
	var/list/areas
	f["areas"] >> areas
	for(var/datum/area_holder/holder in areas)
		var/area/A = new holder.area_type
		A.name = holder.name
		var/list/turfs = list()
		for(var/ind in 1 to holder.turfs.len)
			var/list/coords = holder.turfs[ind]
			var/turf/T = locate(text2num(coords[1]),text2num(coords[2]),text2num(coords[3]))
			if(!T)
				message_admins("No turf found for area load")
			turfs |= T
		A.contents.Add(turfs)
	f.cd = "/"
	for(var/z in 1 to 11)
		f.cd = "/map/[z]"
		while(!f.eof)
			f >> v
			CHECK_TICK
		world << "Loading.. [((1/(12-z))*100)]% Complete"
	f.cd = "/extras"
	f["turbolifts"] >> turbolifts
	var/list/zones
	f["zones"] >> zones
	for(var/zone/Z in zones)
		for(var/ind in 1 to Z.turf_coords.len)
			var/list/coords = Z.turf_coords[ind]
			var/turf/simulated/T = locate(text2num(coords[1]),text2num(coords[2]),text2num(coords[3]))
			if(!T)
				message_admins("No turf found for zone load")
			T.zone = Z
			Z.contents |= T

	for(var/ind in 1 to all_loaded.len)
		var/datum/dat = all_loaded[ind]
		dat.after_load()
	all_loaded = list()
	SSmachines.makepowernets()
	
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
			var/list/saved_vars = params2list(savedvarparams)
			if(saved_vars && saved_vars.len)
				found_vars |= saved_vars
			subtypes += x
	var/savedvarparams = file2text("saved_vars/[C].txt")
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
