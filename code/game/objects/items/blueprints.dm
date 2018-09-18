#define ROOM_ERR_SPACE 0
#define ROOM_ERR_TOOLARGE 1
#define BORDER_NONE 0
#define BORDER_SPACE 1
#define BORDER_BETWEEN 2
#define BORDER_2NDTILE 3

/obj/item/blueprints
	name = "blueprints"
	desc = "Blueprints for building a station. There is a \"Classified\" stamp and several coffee stains on it."
	icon = 'icons/obj/items.dmi'
	icon_state = "blueprints"
	attack_verb = list("attacked", "bapped", "hit")


/obj/item/blueprints/attack_self(mob/M as mob)
	if(!istype(M,/mob/living/carbon/human))
		to_chat(M, "This stack of blue paper means nothing to you.")	// Monkeys cannot into projecting
		return

	interact()
	return

/obj/item/blueprints/Topic(href, href_list)
	..()
	if ((usr.restrained() || usr.stat || usr.get_active_hand() != src))
		return
	if (!href_list["action"])
		return

	switch(href_list["action"])
		if("create_area")
			createArea()
		if ("edit_area")
			editArea()
		if("merge_area")
			mergeArea()
		if("add_to_area")
			addToArea()
		if ("remove_area")
			deleteArea()

/obj/item/blueprints/interact()
	var/area/A = get_area(usr)
	var/text = "<HTML><head><title>[src]</title></head><BODY>"
	text += "<p>According to the blueprints, you are now in <b>[A.name]</b>.</p>"
	if(!istype(A, /area/turbolift))
		text += "<br>" + (isspace(A) ? "<a href='?src=\ref[src];action=create_area'>Create Area</a>" : "Create Area - An area already exists here")
		text += "<br>" + (isspace(A) ? "Modify Area - You can't edit space!" : "<a href='?src=\ref[src];action=edit_area'>Modify Area</a>")
		text += "<br>" + (isspace(A) ? "Merge Areas - You can't combine space!" : A.apc ? "Merge Areas - The APC must be removed first" : getAdjacentAreas() ? "<a href='?src=\ref[src];action=merge_area'>Merge Areas</a>" : "Merge Areas - There are no valid areas to merge with")
		text += "<br>" + (isspace(A) ? "Add to Area - You can't add to space!" : A.apc ? "Add to Area - The APC must be removed first" : getAdjacentAreas(1) ? "<a href='?src=\ref[src];action=add_to_area'>Add to Area</a>" : "Add to Area - There are no valid areas to add tiles from")
		text += "<br>" + (isspace(A) ? "Remove Area - You can't remove space!" : A.apc ? "Remove Area - The APC must be removed first" : "<a href='?src=\ref[src];action=remove_area'>Remove Area</a>")
	else
		text += "You may not touch turbolifts"
		text += "</BODY></HTML>"
	usr << browse(text, "window=blueprints")
	onclose(usr, "blueprints")

/obj/item/blueprints/proc/createArea()
	var/reason = detectRoom(get_turf(usr))

	if(!istype(reason, /list))
		switch(reason)
			if(ROOM_ERR_SPACE)
				to_chat(usr, "<span class='warning'>The new area must be completely airtight!</span>")
				return
			if(ROOM_ERR_TOOLARGE)
				to_chat(usr, "<span class='warning'>The new area too large!</span>")
				return
			else
				to_chat(usr, "<span class='warning'>Error! Please notify administration!</span>")
				return

	var/string = sanitizeSafe(input("New area name:","Blueprint Editing", ""), MAX_NAME_LEN)
	if(!string)	// Cancled
		return

	var/list/turfs = reason
	var/area/A = new()
	A.name = string
	A.power_equip = 0
	A.power_light = 0
	A.power_environ = 0
	A.always_unpowered = 0
	A.contents.Add(turfs)

	interact()

/obj/item/blueprints/proc/editArea()
	var/area/A = get_area(usr)
	var/prevname = "[A.name]"
	var/newname = sanitizeSafe(input("New area name:","Blueprint Editing", prevname), MAX_NAME_LEN)

	if(!newname || newname == prevname) //cancel
		return

	A.name = newname
	updateMachinery(A)
	to_chat(usr, "<span class='notice'>You set the area '[prevname]' title to '[newname]'.</span>")
	interact()

/obj/item/blueprints/proc/mergeArea()
	var/area/A = get_area(usr)
	var/list/areas = getAdjacentAreas()
	if(areas)
		var/area/oldArea = input("Choose area to merge into [A.name]", "Area") as null|anything in areas
		if(!oldArea)
			interact()
			return
		A.contents.Add(oldArea.contents)
		to_chat(usr, "<span class='notice'>You merge [oldArea.name] into [A.name]</span>")
		deleteArea(oldArea)
	else
		to_chat(usr, "<span class='notice'>No valid areas could be found. Make sure they don't have an APC and are adjacent to you.</span>")
	interact()

/obj/item/blueprints/proc/addToArea()
	var/area/A = get_area(usr)
	var/area/oldArea
	var/list/turfs = list()
	for(var/dir in GLOB.cardinal)
		var/turf/T = get_step(usr, dir)
		oldArea = get_area(T)
		if(oldArea && !oldArea.apc && oldArea != A && !istype(oldArea, /area/turbolift))
			turfs["[dir2text(dir)]"] = T
	var/turf/T = turfs[input("Choose turf to merge into [A.name]", "Area") as null|anything in turfs]
	if(!T)
		interact()
		return
	A.contents.Add(T)
	updateMachinery(oldArea)
	if(!oldArea.contents)
		deleteArea(oldArea)

	updateMachinery()
	interact()
	return

/obj/item/blueprints/proc/getAdjacentAreas(var/includeSpace = 0)
	var/area/A = get_area(usr)
	var/list/areas = list()
	for(var/dir in GLOB.cardinal)
		var/area/selectedArea = get_area(get_step(usr, dir))
		if(selectedArea && !selectedArea.apc && selectedArea != A && !istype(selectedArea, /area/turbolift))
			if(includeSpace || !isspace(selectedArea))
				areas.Add(selectedArea)

	return areas.len ? areas : 0

/obj/item/blueprints/proc/deleteArea()
	var/area/A = get_area(usr)
	if (isspace(A) || A.apc)	// Let's just check this one last time, just in case
		interact()
		return
	var/area/newArea = locate(/area/space)
	newArea.contents.Add(A.contents)
	sleep(20)
	A.contents.Cut()
	qdel(A)
	to_chat(usr, "<span class='notice'>You scrub [A.name] off the blueprint.</span>")
	log_and_message_admins("deleted area [A.name] via station blueprints.")
	interact()


/obj/item/blueprints/proc/updateMachinery(var/area/A)
	for(var/obj/machinery/alarm/O in A)
		O.name = "[A.name] Air Alarm"
	for(var/obj/machinery/power/apc/O)
		O.name = "[A.name] APC"

	for(var/obj/machinery/atmospherics/unary/vent_scrubber/O in A)
		if(O.initial_loc)
			O.initial_loc.air_vent_info -= O.id_tag
			O.initial_loc.air_vent_names -= O.id_tag
		O.initial_loc = A
		O.area_uid = O.initial_loc.uid
		O.broadcast_status()

	for(var/obj/machinery/atmospherics/unary/vent_pump/O in A)
		if(O.initial_loc)
			O.initial_loc.air_vent_info -= O.id_tag
			O.initial_loc.air_vent_names -= O.id_tag
		O.initial_loc = A
		O.area_uid = O.initial_loc.uid
		O.broadcast_status()

	LAZYCLEARLIST(A.all_doors)
	for(var/obj/machinery/door/firedoor/F in A.contents)
		LAZYADD(A.all_doors, F)

/obj/item/blueprints/proc/check_tile_is_border(var/turf/T2,var/dir)
	if (istype(T2, /turf/space))
		return BORDER_SPACE //omg hull breach we all going to die here
	if (istype(T2, /turf/simulated/shuttle))
		return BORDER_SPACE
	if (!isspace(T2.loc))
		return BORDER_BETWEEN
	if (istype(T2, /turf/simulated/wall))
		return BORDER_2NDTILE
	if (!istype(T2, /turf/simulated))
		return BORDER_BETWEEN

	for (var/obj/structure/window/W in T2)
		if(turn(dir,180) == W.dir)
			return BORDER_2NDTILE
		if (W.dir in list(NORTHEAST,SOUTHEAST,NORTHWEST,SOUTHWEST))
			return BORDER_2NDTILE
	for(var/obj/machinery/door/window/D in T2)
		if(turn(dir,180) == D.dir)
			return BORDER_2NDTILE
	if (locate(/obj/machinery/door) in T2)
		return BORDER_2NDTILE

	return BORDER_NONE

/obj/item/blueprints/proc/detectRoom(var/turf/first)
	var/list/turf/found = new
	var/list/turf/pending = list(first)
	var/list/turf/rejected = list()
	while(pending.len)
		if (found.len+pending.len > 1000)
			return ROOM_ERR_TOOLARGE
		var/turf/T = pending[1] //why byond havent list::pop()?
		pending -= T
		if(T in rejected) continue
		if(T in found) continue
		for (var/dir in GLOB.cardinal)
			var/skip = 0
			for (var/obj/structure/window/W in T)
				if(dir == W.dir || (W.dir in list(NORTHEAST,SOUTHEAST,NORTHWEST,SOUTHWEST)))
					pending += T
					skip = 1; break
			if (skip) continue
			for(var/obj/machinery/door/window/D in T)
				if(dir == D.dir)
					skip = 1; break
			if (skip) continue

			var/turf/NT = get_step(T,dir)
			if (!isturf(NT) || (NT in found) || (NT in pending))
				continue

			switch(check_tile_is_border(NT,dir))
				if(BORDER_NONE)
					pending+=NT
				if(BORDER_BETWEEN)
					rejected +=NT//do nothing, may be later i'll add 'rejected' list as optimization
				if(BORDER_2NDTILE)
					found+=NT //tile included to new area, but we dont seek more
				if(BORDER_SPACE)
					return ROOM_ERR_SPACE
		found+=T
	return found
