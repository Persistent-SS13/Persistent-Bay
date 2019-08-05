#define SAVECHUNK_SIZEX 16
#define SAVECHUNK_SIZEY 16

var/global/list/found_vars = list()
var/global/list/all_loaded = list()
var/global/list/saved = list()
var/global/list/areas_to_save = list()
var/global/list/zones_to_save = list()
var/global/list/debug_data = list()
/proc/Prepare_Atmos_For_Saving()
	for(var/datum/pipe_network/net in SSmachines.pipenets)
		for(var/datum/pipeline/line in net.line_members)
			line.temporarily_store_air()

/datum/area_holder
	var/area_type = "/area"
	var/name
	var/list/turfs = list()
	map_storage_saved_vars = "area_type;name;turfs;shuttle"
	var/shuttle
/obj/item/map_storage_debugger
	name = "DEBUG ITEM"
	desc = "DEBUG ITEM"
	icon = 'icons/obj/device.dmi'
	icon_state = "eftpos"
	var/list/spawned = list()

/obj/item/map_storage_debugger/proc/spawn_debug(var/mob/user, var/type_path)
	if(!type_path)
		type_path = input(user, "Enter the typepath you want spawned", "debugger","") as text|null
	var/datum/D = new type_path()
	if(D)
		spawned |= D
		return D
	else if(user)
		to_chat(user, "No datum of type [type_path]")

/obj/item/map_storage_debugger/attack_self(mob/user)
	return spawn_debug(user)

/datum
	var/should_save = 1
	var/map_storage_saved_vars = ""
	var/skip_empty = ""
	var/skip_icon_state = 0
	var/map_storage_loaded = 0 // this is special instructions for problematic Initialize()
/mob
	var/stored_ckey = ""

/atom/movable/lighting_overlay
	should_save = 0



/turf/space
	map_storage_saved_vars = "contents"



/turf/space/after_load()
	..()
	for(var/atom/movable/lighting_overlay/overlay in contents)
		overlay.loc = null
		qdel(overlay)

/turf
	map_storage_saved_vars = "density;icon_state;name;pixel_x;pixel_y;contents;dir"
	skip_empty = "contents;saved_decals;req_access;req_access_personal_list;req_one_access;req_one_access_business_list"

/obj
	map_storage_saved_vars = "density;icon_state;name;pixel_x;pixel_y;contents;dir"

/obj/after_load()
	..()
	queue_icon_update()
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


/datum/chunk_holder/StandardRead(var/savefile/f)
	..()
	var/ve
	while(!f.eof)
		from_file(f, ve)

/datum/chunk_holder/StandardWrite(var/savefile/f)
	..()
	for(var/x in turfs)
		to_file(f, x)


/turf/after_load()
	..()
	decals = saved_decals.Copy()
	queue_icon_update()
	if(dynamic_lighting)
		lighting_build_overlay()
	else
		lighting_clear_overlay()

/atom/movable/lighting_overlay/after_load()
	loc = null
	qdel(src)

/datum/proc/before_save()
	return
/datum/proc/after_save() //Sometimes we change the value of some variables for saving purpose only.. and want to change them back after
	return

/datum/proc/StandardWrite(var/savefile/f)
	if(QDELETED(src) && !istype(src, /datum/money_account))	// If we are deleted, we shouldn't be saving
		return
	before_save()
	var/list/saving
	if(found_vars.Find("[type]"))
		saving = found_vars["[type]"]
	else
		saving = get_saved_vars()
		found_vars["[type]"] = saving
	if(skip_icon_state) saving -= "icon_state"
	for(var/ind in 1 to saving.len)
		var/variable = saving[ind]
		if(!hasvar(src, variable))
			continue
		if(vars[variable] == initial(vars[variable]))
			continue
		if(istype(vars[variable], /datum))
			var/datum/D = vars[variable]
			if(QDELETED(D))
				continue
			if(!D.should_save(src))
				continue
		if(istype(vars[variable], /list))
			if(variable in params2list(skip_empty))
				var/list/lis = vars[variable]
				if(!lis.len) continue
			var/list/C = vars[variable]
			var/list/D = C.Copy()
			for(var/datum/dat in D)
				if(!dat.should_save(src))
					D -= dat
			to_file(f["[variable]"],D)
		else
			to_file(f["[variable]"],vars[variable])
	after_save()

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
/turf/StandardWrite(f)
	var/starttime = REALTIMEOFDAY
	..()
	if((REALTIMEOFDAY - starttime)/10 > 2)
		to_world("[src.type] took [(REALTIMEOFDAY - starttime)/10] seconds to save at [x] [y] [z]")
/mob/Write(savefile/f)
	StandardWrite(f)
	if(ckey)
		to_file(f["ckey"], ckey)
	else
		to_file(f["ckey"], stored_ckey)

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
	var/starttime = REALTIMEOFDAY
	map_storage_loaded = 1
	before_load()
	var/list/loading
	if(all_loaded)
		all_loaded += src

	if(found_vars.Find("[type]"))
		loading = found_vars["[type]"]
	else
		loading = get_saved_vars()
		found_vars["[type]"] = loading

	for(var/ind in 1 to loading.len)
		var/variable = loading[ind]
		if(hasvar(src, variable) && f.dir.Find("[variable]"))
			from_file(f["[variable]"],vars[variable])
	if("[src.type]" in debug_data)
		var/amount = debug_data["[src.type]"][1]
		var/time = debug_data["[src.type]"][2]
		debug_data["[src.type]"] = list(amount++,time+((REALTIMEOFDAY - starttime)/10))
	else
		debug_data["[src.type]"] = list(1,(REALTIMEOFDAY - starttime)/10)

/turf/StandardRead(var/savefile/f)
	var/starttime = REALTIMEOFDAY
	map_storage_loaded = 1
	before_load()
	var/list/loading
	if(all_loaded)
		all_loaded += src

	if(found_vars.Find("[type]"))
		loading = found_vars["[type]"]
	else
		loading = get_saved_vars()
		found_vars["[type]"] = loading

	for(var/ind in 1 to loading.len)
		var/variable = loading[ind]
		if("[variable]" == "x" || "[variable]" == "y" || "[variable]" == "z") continue
		if(variable in f.dir)
			from_file(f["[variable]"],vars[variable])
	if("[src.type]" in debug_data)
		var/amount = debug_data["[src.type]"][1]
		var/time = debug_data["[src.type]"][2]
		debug_data["[src.type]"] = list(amount+1,time+((REALTIMEOFDAY - starttime)/10))
	else
		debug_data["[src.type]"] = list(1,(REALTIMEOFDAY - starttime)/10)
	if((REALTIMEOFDAY - starttime)/10 > 29)
		to_world("[src.type] took [(REALTIMEOFDAY - starttime)/10] seconds to load at [x] [y] [z]")

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

/obj/Read(savefile/f)
	for(var/atom/movable/am in contents)
		am.loc = null
	StandardRead(f)

/mob/Read(savefile/f)
	StandardRead(f)
	from_file(f["ckey"], stored_ckey)

/turf/Read(savefile/f)
	StandardRead(f)

/area/Read(savefile/f)
	return 0

/datum/chunk_holder
	var/list/turfs = list()

/proc/Save_Chunk(var/xi, var/yi, var/zi, var/savefile/f)
	var/z = zi
	xi = (xi - (xi % SAVECHUNK_SIZEX) + 1)
	yi = (yi - (yi % SAVECHUNK_SIZEY) + 1)
	var/datum/chunk_holder/holder = new()
	for(var/y in yi to yi + SAVECHUNK_SIZEY)
		for(var/x in xi to xi + SAVECHUNK_SIZEX)
			var/turf/T = locate(x,y,z)
			if(!T || ((T.type == /turf/space || T.type == /turf/simulated/open) && (!T.contents || !T.contents.len)))
				continue
			holder.turfs |= T
	to_file(f,holder)

/proc/Save_Records(var/backup_dir)
	to_world("<font size=3 color='green'>Saving crew records..</font>")
	for(var/datum/computer_file/report/crew_record/L in GLOB.all_crew_records)
		var/key = L.get_name()
		fcopy("record_saves/[key].sav", "backups/[backup_dir]/records/[key].sav")
		fdel("record_saves/[key].sav")
		var/savefile/f = new("record_saves/[key].sav")
		to_file(f, L)
		if(!L.linked_account)
			message_admins("RECORD [key] HAS NO LINKED ACCOUNT!!! GENERATING ONE")
			L.linked_account = create_account(L.get_name(), 0, null)
			L.linked_account.remote_access_pin = rand(1111,9999)
			L.linked_account = L.linked_account.after_load()
			L.linked_account.money = DEFAULT_NEW_CHARACTER_MONEY
		to_file(f, L.linked_account)
		f = null
		var/key3 = L.get_fingerprint()
		fdel("record_saves/[key3].sav")
		var/savefile/fe = new("record_saves/[key3].sav")
		to_file(fe, L)
		to_file(fe, L.linked_account)
		fe = null
	to_world("<font size=3 color='green'>Saving faction records..</font>")
	for(var/datum/world_faction/faction in GLOB.all_world_factions)
		var/list/records = faction.get_records()
		for(var/datum/computer_file/report/crew_record/L in records)
			var/key = L.get_name()
			fcopy("record_saves/[faction.uid]/[key].sav", "backups/[backup_dir]/records/[faction.uid]/[key].sav")
			fdel("record_saves/[faction.uid]/[key].sav")
			var/savefile/f = new("record_saves/[faction.uid]/[key].sav")
			to_file(f, L)
			f = null
/proc/Save_World()
	to_world("<font size=4 color='green'>The world is saving! Characters are frozen and you won't be able to join at this time.</font>")
	sleep(20)
	var/reallow = 0
	if(config.enter_allowed) reallow = 1
	config.enter_allowed = 0
	Prepare_Atmos_For_Saving()
	areas_to_save = list()
	zones_to_save = list()
	var/starttime = REALTIMEOFDAY
	var/backup = 0
	var/dir = 1

	while(!backup)
		if(fexists("backups/[dir]/z1.sav"))
			dir++
		else
			backup = 1
	found_vars = list()
	to_world("<font size=3 color='green'>Saving chunks..</font>")
	for(var/z in 1 to SAVED_ZLEVELS)
		fcopy("map_saves/z[z].sav", "backups/[dir]/z[z].sav")
		fdel("map_saves/z[z].sav")
		var/savefile/f = new("map_saves/z[z].sav")
		for(var/x in 1 to world.maxx step SAVECHUNK_SIZEX)
			for(var/y in 1 to world.maxy step SAVECHUNK_SIZEY)
				Save_Chunk(x,y,z,f)
		f = null
	fcopy("map_saves/extras.sav", "backups/[dir]/extras.sav")
	fdel("map_saves/extras.sav")
	var/savefile/f = new("map_saves/extras.sav")
	var/list/formatted_areas = list()
	to_world("<font size=3 color='green'>Saving areas..</font>")
	for(var/area/A in areas_to_save)
		if(istype(A, /area/space)) continue
		var/datum/area_holder/holder = new()
		holder.area_type = A.type
		holder.name = A.name
		holder.turfs = A.get_turf_coords()
		holder.shuttle = A.shuttle
		formatted_areas += holder
	var/list/zones = list()
	to_world("<font size=3 color='green'>Saving zones..</font>")
	
	for(var/zone/Z in zones_to_save)
		try	
			Z.turf_coords = Z.get_turf_coords()
			zones |= Z
		catch(var/exception/e)
			message_admins("error [e]")		
	to_world("<font size=3 color='green'>Saving factions..</font>")
	to_file(f["factions"],GLOB.all_world_factions)
	to_world("<font size=3 color='green'>Saving marketplace..</font>")
	to_file(f["material_marketplace"],GLOB.material_marketplace)
	to_file(f["contract_database"],GLOB.contract_database)
	to_file(f["zones"],zones)
	to_file(f["areas"],formatted_areas)
	to_world("<font size=3 color='green'>Saving designer system..</font>")
	to_file(f["designer_system"],GLOB.designer_system)
	Save_Records(dir)

	to_file(f["next_account_number"],next_account_number)
	if(reallow) config.enter_allowed = 1
	to_world("Saving Completed in [(REALTIMEOFDAY - starttime)/10] seconds!")
	to_world("Saving Complete")
	f = null
	found_vars = list()
	all_loaded = list()
	saved = list()
	areas_to_save = list()
	zones_to_save = list()
	debug_data = list()
	return 1


/proc/Send_Email(var/key, var/sender = "Unknown", var/subject, var/body)
	var/datum/computer_file/report/crew_record/record = Retrieve_Record(key)
	if(record && record.email)
		var/datum/computer_file/data/email_message/message = new()
		message.title = subject
		message.stored_data = body
		message.source = sender
		var/datum/computer_file/data/email_account/recipient = record.email
		if(!istype(recipient))
			return 0
		if(!recipient.receive_mail(message))
			return
		return 1


/proc/Get_Email_Account(var/key) // 2 = ATM account
	var/datum/computer_file/report/crew_record/record = Retrieve_Record(key)
	if(record && record.email)
		return record.email

/proc/Retrieve_Record(var/key, var/func = 1) // 2 = ATM account
	for(var/datum/computer_file/report/crew_record/record2 in GLOB.all_crew_records)
		if(record2.get_name() == key)
			return record2
	if(!fexists("record_saves/[key].sav")) return
	var/savefile/f = new("record_saves/[key].sav")
	var/datum/computer_file/report/crew_record/v
	from_file(f, v)
	var/datum/money_account/account
	from_file(f, account)
	if(!v)
		message_admins("fucked up record [key]")
		if(func == 1)
			v = new()
			v.set_name(key)
		else
			return
	if(!account)
		message_admins("broken account for [key]")
		v.linked_account = create_account(v.get_name(), 0, null)
		v.linked_account.remote_access_pin = rand(1111,9999)
		v.linked_account = v.linked_account.after_load()
		v.linked_account.money = 1000
	else
		v.linked_account = account
	if(v.linked_account)
		v.linked_account = v.linked_account.after_load()
		v.linked_account.owner_name = v.get_name()
	GLOB.all_crew_records |= v
	return v


/proc/Retrieve_Record_Faction(var/key, var/datum/world_faction/faction)
	if(!faction) return
	for(var/datum/computer_file/report/crew_record/record2 in faction.records.faction_records)
		if(record2.get_name() == key)
			return record2
	if(!fexists("record_saves/[faction.uid]/[key].sav")) return
	var/savefile/f = new("record_saves/[faction.uid]/[key].sav")
	var/v
	from_file(f, v)
	var/list/records = faction.get_records()
	records |= v
	return v


/proc/Load_World()
	set background = TRUE
	var/starttime = REALTIMEOFDAY
	var/savefile/f
	all_loaded = list()
	found_vars = list()
	debug_data = list()
	var/turf/ve = null
	for(var/z in 1 to SAVED_ZLEVELS)
		var/starttime2 = REALTIMEOFDAY
		f = new("map_saves/z[z].sav")
		while(!f.eof)
			from_file(f,ve)
		message_admins("Loading Zlevel [z] Completed in [(REALTIMEOFDAY - starttime2)/10] seconds!")
		f = null
	f = new("map_saves/extras.sav")	
	from_file(f["email"],ntnet_global.email_accounts)
	from_file(f["records"],GLOB.all_crew_records)
	LAZYINITLIST(GLOB.all_crew_records)
	from_file(f["factions"],GLOB.all_world_factions)
	from_file(f["material_marketplace"],GLOB.material_marketplace)
	from_file(f["designer_system"],GLOB.designer_system)
	if(!GLOB.material_marketplace)
		GLOB.material_marketplace = new()
	if(!GLOB.designer_system)
		log_and_message_admins("Couldn't find save for designer_system. Initializing a new one.")
		GLOB.designer_system = new()
	from_file(f["contract_database"],GLOB.contract_database)
	if(!GLOB.contract_database)
		GLOB.contract_database = new()

	from_file(f["next_account_number"],next_account_number)
	var/list/areas
	from_file(f["areas"],areas)
	for(var/datum/area_holder/holder in areas)
		try
			var/area/A = new holder.area_type
			A.name = holder.name
			A.shuttle = holder.shuttle
			var/list/turfs = list()
			for(var/ind in 1 to holder.turfs.len)
				var/list/coords = holder.turfs[ind]
				var/turf/T = locate(text2num(coords[1]),text2num(coords[2]),text2num(coords[3]))
				if(!T)
					message_admins("No turf found for area load")
				turfs |= T
			A.contents.Add(turfs)
		catch(var/exception/e)
			message_admins("error [e]")
	var/list/zones

	from_file(f["zones"],zones)
	for(var/zone/Z in zones)
		for(var/ind in 1 to Z.turf_coords.len)
			var/list/coords = Z.turf_coords[ind]
			var/turf/simulated/T = locate(text2num(coords[1]),text2num(coords[2]),text2num(coords[3]))
			if(!T || !istype(T))
				message_admins("No turf found for zone load")
				continue
			T.zone = Z
			Z.contents |= T

	for(var/zone/Z in zones)
		Z.rebuild()

	for(var/ind in 1 to all_loaded.len)
		var/datum/dat = all_loaded[ind]
		dat.after_load()

	all_loaded.Cut()
	found_vars.Cut()
	SSmachines.makepowernets()

	for(var/x in debug_data)
		to_world("Loaded [debug_data[x][1]] [x] in [debug_data[x][2]] seconds!")
	debug_data.Cut()
	to_world("Loading Completed in [(REALTIMEOFDAY - starttime)/10] seconds!")
	to_world("Loading Complete")
	return 1


/proc/Load_Chunk(var/xi, var/yi, var/zi, var/savefile/f)
	var/z = zi
	xi = (xi - (xi % SAVECHUNK_SIZEX) + 1)
	yi = (yi - (yi % SAVECHUNK_SIZEY) + 1)
	f.cd = "/[z]/Chunk|[yi]|[xi]"
	for(var/y in yi to yi + SAVECHUNK_SIZEY)
		for(var/x in xi to xi + SAVECHUNK_SIZEX)
			var/turf/T = locate(x,y,z)
			from_file(f["[x]-[y]"],T)
//TODO; make this better.
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
	show_browser(M, dat, "window=roundstats;size=500x600")

#undef SAVECHUNK_SIZEX
#undef SAVECHUNK_SIZEY
