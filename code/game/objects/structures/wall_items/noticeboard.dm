var/const/NBOARD_MAX_NOTICES = 5
/obj/structure/noticeboard
	name = "notice board"
	desc = "A board for pinning important notices upon."
	icon = 'icons/obj/structures/noticeboard.dmi'
	icon_state = "nboard00"
	density = FALSE
	anchored = TRUE
	layer = ABOVE_WINDOW_LAYER
	mass = 3
	max_health = 30
	var/list/notices
	var/base_icon_state = "nboard0"
	var/const/max_notices = 5

/obj/structure/noticeboard/New()
	..()
	ADD_SAVED_VAR(notices)
	ADD_SKIP_EMPTY(notices)

/obj/structure/noticeboard/Initialize()
	. = ..()
	queue_icon_update()

/obj/structure/noticeboard/on_update_icon()
	switch(dir)
		if(NORTH)
			src.pixel_x = 0
			src.pixel_y = -30
		if(SOUTH)
			src.pixel_x = 0
			src.pixel_y = 30
		if(EAST)
			src.pixel_x = -30
			src.pixel_y = 0
		if(WEST)
			src.pixel_x = 30
			src.pixel_y = 0
	icon_state = "[base_icon_state][LAZYLEN(notices)]"

/obj/structure/noticeboard/proc/add_paper(var/atom/movable/paper, var/skip_icon_update)
	if(istype(paper))
		LAZYDISTINCTADD(notices, paper)
		paper.forceMove(src)
		if(!skip_icon_update)
			update_icon()

/obj/structure/noticeboard/proc/remove_paper(var/atom/movable/paper, var/skip_icon_update)
	if(istype(paper) && paper.loc == src)
		paper.dropInto(loc)
		LAZYREMOVE(notices, paper)
//		SSpersistence.forget_value(paper, /datum/persistent/paper)
		if(!skip_icon_update)
			update_icon()

//attaching papers!!
/obj/structure/noticeboard/attackby(var/obj/item/weapon/O as obj, var/mob/user as mob)
	if(isWrench(O))
		to_chat(user, "You remove the [src] from the wall!")
		new /obj/item/frame/noticeboard(get_turf(user))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		qdel(src)
		return
	else if(istype(O, /obj/item/weapon/paper) || istype(O, /obj/item/weapon/photo))
		if(jobban_isbanned(user, "Graffiti"))
			to_chat(user, SPAN_WARNING("You are banned from leaving notes."))
		else
			if(LAZYLEN(notices) < max_notices && user.unEquip(O, src))
				add_fingerprint(user)
				add_paper(O)
				to_chat(user, SPAN_NOTICE("You pin \the [O] to \the [src]."))
				//SSpersistence.track_value(O, /datum/persistent/paper)
			else
				to_chat(user, SPAN_WARNING("You hesitate, certain \the [O] will not be seen among the many others already attached to \the [src]."))
		return
	else
		return ..()


/obj/structure/noticeboard/attack_hand(var/mob/user)
	examine(user)


/obj/structure/noticeboard/attack_ai(var/mob/user)
	examine(user)

/obj/structure/noticeboard/attack_hand(var/mob/user)
	examine(user)

/obj/structure/noticeboard/examine(var/mob/user)
	. = ..()
	if(!user.Adjacent(src))
		to_chat(user, "You're too far to read the board..")
		return 
	if(.)
		var/list/dat = list("<table>")
		for(var/thing in notices)
			LAZYADD(dat, "<tr><td>[thing]</td><td>")
			if(istype(thing, /obj/item/weapon/paper))
				LAZYADD(dat, "<a href='?src=\ref[src];read=\ref[thing]'>Read</a><a href='?src=\ref[src];write=\ref[thing]'>Write</a>")
			else if(istype(thing, /obj/item/weapon/photo))
				LAZYADD(dat, "<a href='?src=\ref[src];look=\ref[thing]'>Look</a>")
			LAZYADD(dat, "<a href='?src=\ref[src];remove=\ref[thing]'>Remove</a></td></tr>")
		var/datum/browser/popup = new(user, "noticeboard-\ref[src]", "Noticeboard")
		popup.set_content(jointext(dat, null))
		popup.open()

/obj/structure/noticeboard/OnTopic(var/mob/user, var/list/href_list)

	if(href_list["read"])
		var/obj/item/weapon/paper/P = locate(href_list["read"])
		if(P && P.loc == src)
			P.show_content(user)
		. = TOPIC_HANDLED

	if(href_list["look"])
		var/obj/item/weapon/photo/P = locate(href_list["look"])
		if(P && P.loc == src)
			P.show(user)
		. = TOPIC_HANDLED

	if(href_list["remove"])
		remove_paper(locate(href_list["remove"]))
		add_fingerprint(user)
		. = TOPIC_REFRESH

	if(href_list["write"])
		var/obj/item/P = locate(href_list["write"])
		if(!P)
			return
		var/obj/item/weapon/pen/pen = user.r_hand
		if(!istype(pen))
			pen = user.l_hand
		if(istype(pen))
			add_fingerprint(user)
			P.attackby(pen, user)
		else
			to_chat(user, SPAN_WARNING("You need a pen to write on \the [P]."))
		. = TOPIC_REFRESH

	if(. == TOPIC_REFRESH)
		interact(user)

