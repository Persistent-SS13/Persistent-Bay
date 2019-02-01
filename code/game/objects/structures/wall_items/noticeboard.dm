var/const/NBOARD_MAX_NOTICES = 5
/obj/structure/noticeboard
	name = "notice board"
	desc = "A board for pinning important notices upon."
	icon = 'icons/obj/structures/noticeboard.dmi'
	icon_state = "nboard00"
	density = 0
	anchored = 1
	mass = 3
	max_health = 30
	var/notices = 0

/obj/structure/noticeboard/New(loc, dir, atom/frame, var/ndir)
	..(loc)
	if(ndir)
		set_dir(ndir)
		pixel_x = (src.dir & 3)? 0 : (src.dir == 4 ? 30 : -30)
		pixel_y = (src.dir & 3)? (src.dir ==1 ? 30 : -30) : 0

/obj/structure/noticeboard/Initialize()
	if(!map_storage_loaded)
		for(var/obj/item/I in loc)
			if(notices > 4) break
			if(istype(I, /obj/item/weapon/paper))
				I.forceMove(src)
				notices++
	. = ..()

/obj/structure/noticeboard/update_icon()
	notices = max(min(NBOARD_MAX_NOTICES,contents.len), 0)
	icon_state = "nboard0[notices]"

//attaching papers!!
/obj/structure/noticeboard/attackby(var/obj/item/weapon/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/weapon/paper) || istype(O, /obj/item/weapon/photo))
		if(notices < NBOARD_MAX_NOTICES)
			O.add_fingerprint(user)
			add_fingerprint(user)
			user.drop_from_inventory(O,src)
			update_icon()
			to_chat(user, "<span class='notice'>You pin the paper to the noticeboard.</span>")
		else
			to_chat(user, "<span class='notice'>You reach to pin your paper to the board but hesitate. You are certain your paper will not be seen among the many others already attached.</span>")
	else if(isWrench(O))
		to_chat(user, "You remove the [src] from the wall!")
		new /obj/item/frame/noticeboard(get_turf(user))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		qdel(src)
		return

/obj/structure/noticeboard/attack_hand(var/mob/user)
	examine(user)

// Since Topic() never seems to interact with usr on more than a superficial
// level, it should be fine to let anyone mess with the board other than ghosts.
/obj/structure/noticeboard/examine(var/mob/user)
	if(!user)
		user = usr
	if(user.Adjacent(src))
		var/dat = "<B>Noticeboard</B><BR>"
		for(var/obj/item/weapon/paper/P in src)
			dat += "<A href='?src=\ref[src];read=\ref[P]'>[P.name]</A> <A href='?src=\ref[src];write=\ref[P]'>Write</A> <A href='?src=\ref[src];remove=\ref[P]'>Remove</A><BR>"
		for(var/obj/item/weapon/photo/P in src)
			dat += "<A href='?src=\ref[src];look=\ref[P]'>[P.name]</A> <A href='?src=\ref[src]; <A href='?src=\ref[src];remove=\ref[P]'>Remove</A><BR>"
		user << browse("<HEAD><TITLE>Notices</TITLE></HEAD>[dat]","window=noticeboard")
		onclose(user, "noticeboard")
	else
		..()

/obj/structure/noticeboard/Topic(href, href_list)
	..()
	usr.set_machine(src)
	if(href_list["remove"])
		if((usr.stat || usr.restrained()))	//For when a player is handcuffed while they have the notice window open
			return
		var/obj/item/P = locate(href_list["remove"])
		if(P && P.loc == src)
			P.loc = get_turf(src)	//dump paper on the floor because you're a clumsy fuck
			P.add_fingerprint(usr)
			add_fingerprint(usr)
			update_icon()
	if(href_list["write"])
		if((usr.stat || usr.restrained())) //For when a player is handcuffed while they have the notice window open
			return
		var/obj/item/P = locate(href_list["write"])
		if((P && P.loc == src)) //ifthe paper's on the board
			if(istype(usr.r_hand, /obj/item/weapon/pen)) //and you're holding a pen
				add_fingerprint(usr)
				P.attackby(usr.r_hand, usr) //then do ittttt
			else
				if(istype(usr.l_hand, /obj/item/weapon/pen)) //check other hand for pen
					add_fingerprint(usr)
					P.attackby(usr.l_hand, usr)
				else
					to_chat(usr, "<span class='notice'>You'll need something to write with!</span>")
	if(href_list["read"])
		var/obj/item/weapon/paper/P = locate(href_list["read"])
		if((P && P.loc == src))
			P.show_content(usr)
	if(href_list["look"])
		var/obj/item/weapon/photo/P = locate(href_list["look"])
		if((P && P.loc == src))
			P.show(usr)
	return
