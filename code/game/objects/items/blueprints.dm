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
		to_chat(M, "This stack of blue paper means nothing to you.")//monkeys cannot into projecting
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
			create_area()
		if ("edit_area")
			edit_area()
		if("merge_area")
			merge_area()
		if("add_to_area")
			add_to_area()
		if ("remove_area")
			delete_area()

/obj/item/blueprints/interact()
	var/area/A = getArea(usr)
	var/text = "<HTML><head><title>[src]</title></head><BODY>"
	text += "<p>According to the blueprints, you are now in <b>[A.name]</b>.</p>"
	if(!istype(A, /area/turbolift))
		text += "<br>" + (isspace(A) ? "<a href='?src=\ref[src];action=create_area'>Create Area</a>" : "Create Area - An area already exists here")
		text += "<br>" + (isspace(A) ? "Modify Area - You can't edit space!" : "<a href='?src=\ref[src];action=edit_area'>Modify Area</a>")
		text += "<br>" + (isspace(A) ? "Merge Areas - You can't combine space!" : A.apc || A.aro ? "Merge Areas - The APC/ARO must be removed first" : getAdjacentAreas() ? "<a href='?src=\ref[src];action=merge_area'>Merge Areas</a>" : "Merge Areas - There are no valid areas to merge with")
		text += "<br>" + (isspace(A) ? "Add to Area - You can't add to space!" : A.apc || A.aro ? "Add to Area - The APC/ARO must be removed first" : getAdjacentAreas(1) ? "<a href='?src=\ref[src];action=add_to_area'>Add to Area</a>" : "Add to Area - There are no valid areas to add tiles from")
		text += "<br>" + (isspace(A) ? "Remove Area - You can't remove space!" : A.apc || A.aro ? "Remove Area - The APC/ARO must be removed first" : "<a href='?src=\ref[src];action=remove_area'>Remove Area</a>")
	else
		text += "You may not touch turbolifts"
		text += "</BODY></HTML>"
	usr << browse(text, "window=blueprints")
	onclose(usr, "blueprints")

/obj/item/blueprints/proc/getArea(var/o)
	var/turf/T = get_turf(o)
	var/area/A = T.loc
	return A

/obj/item/blueprints/proc/create_area()
//	log_debug("create_area")

	var/res = detect_room(get_turf(usr))
	if(!istype(res,/list))
		switch(res)
			if(ROOM_ERR_SPACE)
				to_chat(usr, "<span class='warning'>The new area must be completely airtight!</span>")
				return
			if(ROOM_ERR_TOOLARGE)
				to_chat(usr, "<span class='warning'>The new area too large!</span>")
				return
			else
				to_chat(usr, "<span class='warning'>Error! Please notify administration!</span>")
				return
	var/list/turf/turfs = res
	var/str = sanitizeSafe(input("New area name:","Blueprint Editing", ""), MAX_NAME_LEN)
	if(!str || !length(str)) //cancel
		return
	if(length(str) > 50)
		to_chat(usr, "<span class='warning'>Name too long.</span>")
		return
	var/area/A = new
	A.name = str
	//var/ma
	//ma = A.master ? "[A.master]" : "(null)"
//	log_debug(create_area: <br>A.name=[A.name]<br>A.tag=[A.tag]<br>A.master=[ma]")

	A.power_equip = 0
	A.power_light = 0
	A.power_environ = 0
	A.always_unpowered = 0
	move_turfs_to_area(turfs, A)

	A.always_unpowered = 0

	spawn(5)
		//ma = A.master ? "[A.master]" : "(null)"
//		log_debug)create_area(5): <br>A.name=[A.name]<br>A.tag=[A.tag]<br>A.master=[ma]")

		interact()
	return


/obj/item/blueprints/proc/move_turfs_to_area(var/list/turf/turfs, var/area/A)
	A.contents.Add(turfs)


/obj/item/blueprints/proc/edit_area()
	var/area/A = getArea(usr)
//	log_debug(edit_area")

	var/prevname = "[A.name]"
	var/str = sanitizeSafe(input("New area name:","Blueprint Editing", prevname), MAX_NAME_LEN)
	if(!str || !length(str) || str==prevname) //cancel
		return
	if(length(str) > 50)
		to_chat(usr, "<span class='warning'>Text too long.</span>")
		return
	set_area_machinery_title(A,str,prevname)
	A.name = str
	to_chat(usr, "<span class='notice'>You set the area '[prevname]' title to '[str]'.</span>")
	interact()
	return

/obj/item/blueprints/proc/merge_area()
	var/area/A = getArea(usr)
	var/list/areas = getAdjacentAreas()
	if(areas)
		var/area/oldArea = input("Choose area to merge into [A.name]", "Area") as null|anything in areas
		if(!oldArea)
			interact()
			return
		for(var/turf/T in oldArea.contents)
			move_turfs_to_area(T, A)
		to_chat(usr, "<span class='notice'>You merge [oldArea.name] into [A.name]</span>")
		deleteArea(oldArea)
	else
		to_chat(usr, "<span class='notice'>No valid areas could be found. Make sure they don't have an APC.</span>")
	interact()
	return

/obj/item/blueprints/proc/add_to_area()
	var/area/A = getArea(usr)
	var/list/turfs = list()
	for(var/dir in GLOB.cardinal)
		var/turf/T = get_step(usr, dir)
		var/area/area = getArea(T)
		if(area && !area.apc && !area.aro && area != A && !istype(area, /area/turbolift))
			turfs["[dir2text(dir)]"] = T
	var/turf/T = turfs[input("Choose turf to merge into [A.name]", "Area") as null|anything in turfs]
	if(!T)
		interact()
		return
	var/area/ar = T.loc
	move_turfs_to_area(T, A)
	if(!ar.contents.len)
		deleteArea(ar)
	interact()
	return

/obj/item/blueprints/proc/getAdjacentAreas(var/n = 0)
	var/area/A = getArea(usr)
	var/list/areas = list()
	for(var/dir in GLOB.cardinal)
		var/turf/T = get_step(usr, dir)
		var/area/area = getArea(T)
		if(area && !area.apc && !area.aro && area != A && !istype(area, /area/turbolift))
			if(n || !isspace(area))
				areas.Add(area)
	if(!areas.len)
		return 0
	else
		return areas

/obj/item/blueprints/proc/delete_area()
	var/area/A = getArea(usr)
	if (isspace(A) || (A.apc || A.aro) ) //let's just check this one last time, just in case
		interact()
		return
	to_chat(usr, "<span class='notice'>You scrub [A.name] off the blueprint.</span>")
	log_and_message_admins("deleted area [A.name] via station blueprints.")
	deleteArea(A)
	interact()

/obj/item/blueprints/proc/deleteArea(var/area/A)
	var/area/newArea = locate(world.area)
	for(var/turf/T in A.contents)
		move_turfs_to_area(T, newArea)
	spawn(10)
		A.contents.Cut()
		qdel(A)


/obj/item/blueprints/proc/set_area_machinery_title(var/area/A,var/title,var/oldtitle)
	if (!oldtitle) // or replacetext goes to infinite loop
		return

	for(var/obj/machinery/alarm/M in A)
		M.name = replacetext(M.name,oldtitle,title)
	for(var/obj/machinery/power/apc/M in A)
		M.name = replacetext(M.name,oldtitle,title)
	for(var/obj/machinery/atmospherics/unary/vent_scrubber/M in A)
		M.name = replacetext(M.name,oldtitle,title)
	for(var/obj/machinery/atmospherics/unary/vent_pump/M in A)
		M.name = replacetext(M.name,oldtitle,title)
	for(var/obj/machinery/door/M in A)
		M.name = replacetext(M.name,oldtitle,title)
	//TODO: much much more. Unnamed airlocks, cameras, etc.

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
			return BORDER_BETWEEN
		if (W.dir in list(NORTHEAST,SOUTHEAST,NORTHWEST,SOUTHWEST))
			return BORDER_2NDTILE
	for(var/obj/machinery/door/window/D in T2)
		if(turn(dir,180) == D.dir)
			return BORDER_BETWEEN
	if (locate(/obj/machinery/door) in T2)
		return BORDER_2NDTILE

	return BORDER_NONE

/obj/item/blueprints/proc/detect_room(var/turf/first)
	var/list/turf/found = new
	var/list/turf/pending = list(first)
	while(pending.len)
		if (found.len+pending.len > 300)
			return ROOM_ERR_TOOLARGE
		var/turf/T = pending[1] //why byond havent list::pop()?
		pending -= T
		for (var/dir in GLOB.cardinal)
			var/skip = 0
			for (var/obj/structure/window/W in T)
				if(dir == W.dir || (W.dir in list(NORTHEAST,SOUTHEAST,NORTHWEST,SOUTHWEST)))
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
					//do nothing, may be later i'll add 'rejected' list as optimization
				if(BORDER_2NDTILE)
					found+=NT //tile included to new area, but we dont seek more
				if(BORDER_SPACE)
					return ROOM_ERR_SPACE
		found+=T
	return found