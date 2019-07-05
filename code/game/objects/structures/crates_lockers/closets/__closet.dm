/obj/structure/closet
	name = "closet"
	desc = "It's a basic storage unit."
	icon = 'icons/obj/closets/bases/closet.dmi'
	icon_state = "base"
	density = TRUE
	w_class = ITEM_SIZE_NO_CONTAINER
	obj_flags = OBJ_FLAG_ANCHORABLE | OBJ_FLAG_DAMAGEABLE
	anchored = FALSE
	mass = 15 //kg
	max_health = 200
	damthreshold_brute 	= 10
	armor = list(
		DAM_BLUNT  	= 80,
		DAM_PIERCE 	= 90,
		DAM_CUT 	= 90,
		DAM_BULLET 	= 50,
		DAM_ENERGY 	= 50,
		DAM_BURN 	= 30,
		DAM_BOMB 	= 15,
		DAM_EMP 	= 0,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)
	var/welded = FALSE
	var/large = 1
	var/wall_mounted = FALSE //never solid (You can always pass over it)
	var/breakout = 0 //if someone is currently breaking out. mutex
	var/storage_capacity = 2 * MOB_MEDIUM //This is so that someone can't pack hundreds of items in a locker/crate
							  //then open it in a populated area to crash clients.
	var/open_sound = 'sound/effects/closet_open.ogg'
	var/close_sound = 'sound/effects/closet_close.ogg'

	var/storage_types = CLOSET_STORAGE_ALL
	var/setup = CLOSET_CAN_BE_WELDED
	var/closet_appearance = /decl/closet_appearance

	// TODO: Turn these into flags. Skipped it for now because it requires updating 100+ locations...
	var/broken = FALSE
	var/opened = FALSE
	var/locked = FALSE

/obj/structure/closet/Initialize()
	..()

	if((setup & CLOSET_HAS_LOCK))
		verbs += /obj/structure/closet/proc/togglelock_verb

	if(ispath(closet_appearance))
		var/decl/closet_appearance/app = decls_repository.get_decl(closet_appearance)
		if(app)
			icon = app.icon
			color = null
			queue_icon_update()

	return INITIALIZE_HINT_LATELOAD

/obj/structure/closet/LateInitialize(mapload, ...)
	if(!map_storage_loaded)
		var/list/will_contain = WillContain()
		if(will_contain)
			create_objects_in_loc(get_turf(src), will_contain)

		if(!opened && mapload) // if closed and it's the map loading phase, relevant items at the crate's loc are put in the contents
			store_contents()

/obj/structure/closet/proc/WillContain()
	return null

/obj/structure/closet/examine(mob/user)
	if(..(user, 1) && !opened)
		var/content_size = 0
		for(var/atom/movable/AM in src.contents)
			if(!AM.anchored)
				content_size += content_size(AM)
		if(!content_size)
			to_chat(user, "It is empty.")
		else if(storage_capacity > content_size*4)
			to_chat(user, "It is barely filled.")
		else if(storage_capacity > content_size*2)
			to_chat(user, "It is less than half full.")
		else if(storage_capacity > content_size)
			to_chat(user, "There is still some free space.")
		else
			to_chat(user, "It is full.")

/obj/structure/closet/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0 || wall_mounted)) return 1
	return (!density)

/obj/structure/closet/proc/can_open()
	if((setup & CLOSET_HAS_LOCK) && locked)
		return 0
	if((setup & CLOSET_CAN_BE_WELDED) && welded)
		return 0
	return 1

/obj/structure/closet/proc/can_close()
	for(var/obj/structure/closet/closet in get_turf(src))
		if(closet != src)
			return 0
	return 1

/obj/structure/closet/proc/dump_contents()
	for(var/mob/M in src)
		M.dropInto(loc)
		if(M.client)
			M.client.eye = M.client.mob
			M.client.perspective = MOB_PERSPECTIVE

	for(var/atom/movable/AM in src)
		AM.dropInto(loc)

/obj/structure/closet/proc/store_contents()
	var/stored_units = 0

	if(storage_types & CLOSET_STORAGE_ITEMS)
		stored_units += store_items(stored_units)
	if(storage_types & CLOSET_STORAGE_MOBS)
		stored_units += store_mobs(stored_units)
	if(storage_types & CLOSET_STORAGE_STRUCTURES)
		stored_units += store_structures(stored_units)

/obj/structure/closet/proc/open()
	if(src.opened)
		return 0

	if(!src.can_open())
		return 0

	src.dump_contents()

	src.opened = 1
	playsound(src.loc, open_sound, 15, 1, -3)
	density = 0
	update_icon()
	return 1

/obj/structure/closet/proc/close()
	if(!src.opened)
		return 0
	if(!src.can_close())
		return 0

	store_contents()
	src.opened = 0

	playsound(src.loc, close_sound, 25, 0, -3)
	density = 1

	update_icon()

	return 1

#define CLOSET_CHECK_TOO_BIG(x) (stored_units + . + x > storage_capacity)
/obj/structure/closet/proc/store_items(var/stored_units)
	. = 0

	for(var/obj/effect/dummy/chameleon/AD in loc)
		if(CLOSET_CHECK_TOO_BIG(1))
			break
		.++
		AD.forceMove(src)

	for(var/obj/item/I in loc)
		if(I.anchored)
			continue
		var/item_size = content_size(I)
		if(CLOSET_CHECK_TOO_BIG(item_size))
			break
		. += item_size
		I.forceMove(src)
		I.pixel_x = 0
		I.pixel_y = 0
		I.pixel_z = 0

/obj/structure/closet/proc/store_mobs(var/stored_units)
	. = 0
	for(var/mob/living/M in loc)
		if(M.buckled || M.pinned.len || M.anchored)
			continue
		var/mob_size = content_size(M)
		if(CLOSET_CHECK_TOO_BIG(mob_size))
			break
		. += mob_size
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.forceMove(src)

/obj/structure/closet/proc/store_structures(var/stored_units)
	. = 0

	for(var/obj/structure/S in loc)
		if(S == src)
			continue
		if(S.anchored)
			continue
		var/structure_size = content_size(S)
		if(CLOSET_CHECK_TOO_BIG(structure_size))
			break
		. += structure_size
		S.forceMove(src)

	for(var/obj/machinery/M in loc)
		if(M.anchored)
			continue
		var/structure_size = content_size(M)
		if(CLOSET_CHECK_TOO_BIG(structure_size))
			break
		. += structure_size
		M.forceMove(src)

#undef CLOSET_CHECK_TOO_BIG

// If you adjust any of the values below, please also update /proc/unit_test_weight_of_path(var/path)
/obj/structure/closet/proc/content_size(atom/movable/AM)
	if(ismob(AM))
		var/mob/M = AM
		return M.mob_size
	if(istype(AM, /obj/item))
		var/obj/item/I = AM
		return (I.w_class / 2)
	if(istype(AM, /obj/structure) || istype(AM, /obj/machinery))
		return MOB_LARGE
	return 0

/obj/structure/closet/proc/toggle(mob/user as mob)
	if(locked)
		togglelock(user)
	else if(!(src.opened ? src.close() : src.open()))
		to_chat(user, "<span class='notice'>It won't budge!</span>")
		update_icon()

// this should probably use dump_contents()
/obj/structure/closet/ex_act(severity)
	switch(severity)
		if(1)
			for(var/atom/movable/A in src)//pulls everything out of the locker and hits it with an explosion
				A.forceMove(src.loc)
				A.ex_act(severity + 1)
		if(2)
			if(prob(50))
				for (var/atom/movable/A in src)
					A.forceMove(src.loc)
					A.ex_act(severity + 1)
		if(3)
			if(prob(5))
				for(var/atom/movable/A in src)
					A.forceMove(src.loc)
	return ..()

/obj/structure/closet/bullet_act(var/obj/item/projectile/Proj)
	if(Proj.penetrating)
		var/distance = get_dist(Proj.starting, get_turf(loc))
		for(var/mob/living/L in contents)
			Proj.attack_mob(L, distance)
			if(!(--Proj.penetrating))
				break
	return ..()

/obj/structure/closet/dismantle()
	dump_contents()
	return ..()

/obj/structure/closet/destroyed()
	dump_contents()
	return ..()

/obj/structure/closet/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(src.opened)
		if(istype(W, /obj/item/grab))
			var/obj/item/grab/G = W
			src.MouseDrop_T(G.affecting, user)      //act like they were dragged onto the closet
			return 0
		if(istype(W,/obj/item/tk_grab))
			return 0
		if(isWelder(W))
			slice_into_parts(W, user)
			return
		if(istype(W, /obj/item/weapon/storage/laundry_basket) && W.contents.len)
			var/obj/item/weapon/storage/laundry_basket/LB = W
			var/turf/T = get_turf(src)
			for(var/obj/item/I in LB.contents)
				LB.remove_from_storage(I, T, 1)
			LB.finish_bulk_removal()
			user.visible_message("<span class='notice'>[user] empties \the [LB] into \the [src].</span>", \
								 "<span class='notice'>You empty \the [LB] into \the [src].</span>", \
								 "<span class='notice'>You hear rustling of clothes.</span>")
			return

		if(user.unEquip(W, loc))
			W.pixel_x = 0
			W.pixel_y = 0
			W.pixel_z = 0
			W.pixel_w = 0
		return 1
	else if(istype(W, /obj/item/weapon/melee/energy/blade))
		if(emag_act(INFINITY, user, "<span class='danger'>The locker has been sliced open by [user] with \an [W]</span>!", "<span class='danger'>You hear metal being sliced and sparks flying.</span>"))
			var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
			spark_system.set_up(5, 0, src.loc)
			spark_system.start()
			playsound(src.loc, 'sound/weapons/blade1.ogg', 50, 1)
			playsound(src.loc, "sparks", 50, 1)
			open()

	else if(isMultitool(W))
		if(locked)
			to_chat(user, "You cannot reprogram a locked container.")
			return

		user.visible_message("<span class='notice'>\The [user] begins reprogramming \the [src].</span>", "<span class='notice'>You begin reprogramming \the [src].</span>")
		if(do_after(usr, 40, src))
			ui_interact(user)

	else if(isWrench(W))
		var/obj/item/weapon/tool/T = W
		if(locked)
			to_chat(user, "You cannot wrench a locked container.")
			return
		if (src.anchored==1)
			to_chat(user, "<span class='notice'>You begin to unsecure \the [src] from the floor...</span>")
			if (T.use_tool(user, src, 40))
				user.visible_message( \
					"<span class='notice'>\The [user] unsecures \the [src].</span>", \
					"<span class='notice'>You have unsecured \the [src]. Now it can be pulled somewhere else.</span>", \
					"You hear ratchet.")
				src.anchored = 0
		else
			to_chat(user, "<span class='notice'>You begin to secure \the [src] to the floor...</span>")
			if (T.use_tool(user, src, 20))
				user.visible_message( \
					"<span class='notice'>\The [user] secures \the [src].</span>", \
					"<span class='notice'>You have secured \the [src].</span>", \
					"You hear ratchet.")
				src.anchored = 1
		return
	else if(isWelder(W) && (setup & CLOSET_CAN_BE_WELDED))
		var/obj/item/weapon/tool/T = W
		if(T.use_tool(user, src, 3 SECONDS))
			src.welded = !src.welded
			src.update_icon()
			user.visible_message("<span class='warning'>\The [src] has been [welded?"welded shut":"unwelded"] by \the [user].</span>", blind_message = "You hear welding.", range = 3)
		return 1
	else if(setup & CLOSET_HAS_LOCK)
		src.togglelock(user, W)
		return 1
	return ..()

/obj/structure/closet/proc/slice_into_parts(var/obj/item/weapon/tool/weldingtool/WT, mob/user)
	if(WT.use_tool(user, src, 5 SECONDS))
		user.visible_message("<span class='notice'>\The [src] has been cut apart by [user] with \the [WT].</span>", \
			"<span class='notice'>You have cut \the [src] apart with \the [WT].</span>", \
			"You hear welding.")
		dismantle()

/obj/structure/closet/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
	if(istype(O, /obj/screen))	//fix for HUD elements making their way into the world	-Pete
		return
	if(O.loc == user)
		return
	if(ismob(O) && src.large)
		return
	if(user.restrained() || user.stat || user.weakened || user.stunned || user.paralysis)
		return
	if((!( istype(O, /atom/movable) ) || O.anchored || !Adjacent(user) || !Adjacent(O) || !user.Adjacent(O) || user.contents.Find(src)))
		return
	if(!isturf(user.loc)) // are you in a container/closet/pod/etc?
		return
	if(!src.opened)
		return
	if(istype(O, /obj/structure/closet))
		return
	step_towards(O, src.loc)
	if(user != O)
		user.show_viewers("<span class='danger'>[user] stuffs [O] into [src]!</span>")
	src.add_fingerprint(user)
	return

/obj/structure/closet/attack_ai(mob/user)
	if(istype(user, /mob/living/silicon/robot) && Adjacent(user)) // Robots can open/close it, but not the AI.
		attack_hand(user)

/obj/structure/closet/relaymove(mob/user as mob)
	if(user.stat || !isturf(src.loc))
		return

	if(!src.open())
		to_chat(user, "<span class='notice'>It won't budge!</span>")

/obj/structure/closet/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	src.toggle(user)

// tk grab then use on self
/obj/structure/closet/attack_self_tk(mob/user as mob)
	src.add_fingerprint(user)
	if(!src.toggle())
		to_chat(usr, "<span class='notice'>It won't budge!</span>")

/obj/structure/closet/attack_ghost(mob/ghost)
	if(ghost.client && ghost.client.inquisitive_ghost)
		ghost.examinate(src)
		if (!src.opened)
			to_chat(ghost, "It contains: [english_list(contents)].")

/obj/structure/closet/verb/verb_toggleopen()
	set src in oview(1)
	set category = "Object"
	set name = "Toggle Open"

	if(!CanPhysicallyInteract(usr))
		return

	if(ishuman(usr))
		src.add_fingerprint(usr)
		src.toggle(usr)
	else
		to_chat(usr, "<span class='warning'>This mob type can't use this verb.</span>")

/obj/structure/closet/on_update_icon()
	if(opened)
		icon_state = "open"
		overlays.Cut()
	else
		if(broken)
			icon_state = "closed_emagged[welded ? "_welded" : ""]"
		else
			if(locked)
				icon_state = "closed_locked[welded ? "_welded" : ""]"
			else
				icon_state = "closed_unlocked[welded ? "_welded" : ""]"
			overlays.Cut()

/obj/structure/closet/proc/req_breakout()
	if(opened)
		return 0 //Door's open... wait, why are you in it's contents then?
	if((setup & CLOSET_HAS_LOCK) && locked)
		return 1 // Closed and locked
	return (!welded) //closed but not welded...

/obj/structure/closet/proc/mob_breakout(var/mob/living/escapee)
	var/breakout_time = 2 //2 minutes by default

	if(breakout || !req_breakout())
		return

	escapee.setClickCooldown(100)

	//okay, so the closet is either welded or locked... resist!!!
	to_chat(escapee, "<span class='warning'>You lean on the back of \the [src] and start pushing the door open. (this will take about [breakout_time] minutes)</span>")

	visible_message("<span class='danger'>\The [src] begins to shake violently!</span>")

	breakout = 1 //can't think of a better way to do this right now.
	for(var/i in 1 to (6*breakout_time * 2)) //minutes * 6 * 5seconds * 2
		if(!do_after(escapee, 50, incapacitation_flags = INCAPACITATION_DEFAULT & ~INCAPACITATION_RESTRAINED)) //5 seconds
			breakout = 0
			return
		//Perform the same set of checks as above for weld and lock status to determine if there is even still a point in 'resisting'...
		if(!req_breakout())
			breakout = 0
			return

		playsound(src.loc, 'sound/effects/grillehit.ogg', 100, 1)
		shake_animation()
		add_fingerprint(escapee)

	//Well then break it!
	breakout = 0
	to_chat(escapee, "<span class='warning'>You successfully break out!</span>")
	visible_message("<span class='danger'>\The [escapee] successfully broke out of \the [src]!</span>")
	playsound(src.loc, 'sound/effects/grillehit.ogg', 100, 1)
	break_open()
	shake_animation()

/obj/structure/closet/proc/break_open()
	welded = 0

	if((setup & CLOSET_HAS_LOCK) && locked)
		make_broken()

	//Do this to prevent contents from being opened into nullspace (read: bluespace)
	if(istype(loc, /obj/structure/bigDelivery))
		var/obj/structure/bigDelivery/BD = loc
		BD.unwrap()
	open()

/obj/structure/closet/onDropInto(var/atom/movable/AM)
	return

// If we use the /obj/structure/closet/proc/togglelock variant BYOND asks the user to select an input for id_card, which is then mostly irrelevant.
/obj/structure/closet/proc/togglelock_verb()
	set src in oview(1) // One square distance
	set category = "Object"
	set name = "Toggle Lock"

	return togglelock(usr)

/obj/structure/closet/proc/togglelock(var/mob/user, var/obj/item/weapon/card/id/id_card)
	if(!(setup & CLOSET_HAS_LOCK))
		return FALSE
	if(!CanPhysicallyInteract(user))
		return FALSE
	if(src.opened)
		to_chat(user, "<span class='notice'>Close \the [src] first.</span>")
		return FALSE
	if(src.broken)
		to_chat(user, "<span class='warning'>\The [src] appears to be broken.</span>")
		return FALSE
	if(user.loc == src)
		to_chat(user, "<span class='notice'>You can't reach the lock from inside.</span>")
		return FALSE

	add_fingerprint(user)

	if(!id_card)
		id_card = user.GetIdCard()

	if(!user.IsAdvancedToolUser())
		to_chat(user, FEEDBACK_YOU_LACK_DEXTERITY)
		return FALSE

	if(CanToggleLock(user, id_card))
		locked = !locked
		visible_message("<span class='notice'>\The [src] has been [locked ? null : "un"]locked by \the [user].</span>", range = 3)
		update_icon()
		return TRUE
	else
		to_chat(user, "<span class='warning'>Access denied!</span>")
		return FALSE

/obj/structure/closet/proc/CanToggleLock(var/mob/user, var/obj/item/weapon/card/id/id_card)
	return allowed(user)

/obj/structure/closet/AltClick(var/mob/user)
	if(!src.opened)
		togglelock(user)
	else
		return ..()

/obj/structure/closet/CtrlAltClick(var/mob/user)
	verb_toggleopen()

/obj/structure/closet/emp_act(severity)
	for(var/obj/O in src)
		O.emp_act(severity)
	if(!broken && (setup & CLOSET_HAS_LOCK))
		if(prob(50/severity))
			locked = !locked
			src.update_icon()
		if(prob(20/severity) && !opened)
			if(!locked)
				open()
			else
				src.req_access = list()
				src.req_access += pick(get_all_station_access())
	..()

/obj/structure/closet/emag_act(var/remaining_charges, var/mob/user, var/emag_source, var/visual_feedback = "", var/audible_feedback = "")
	if(make_broken())
		update_icon()
		if(visual_feedback)
			visible_message(visual_feedback, audible_feedback)
		else if(user && emag_source)
			visible_message("<span class='warning'>\The [src] has been broken by \the [user] with \an [emag_source]!</span>", "You hear a faint electrical spark.")
		else
			visible_message("<span class='warning'>\The [src] sparks and breaks open!</span>", "You hear a faint electrical spark.")
		return 1
	else
		. = ..()

/obj/structure/closet/proc/make_broken()
	if(broken)
		return FALSE
	if(!(setup & CLOSET_HAS_LOCK))
		return FALSE
	broken = TRUE
	locked = FALSE
	desc += " It appears to be broken."
	return TRUE


/obj/structure/closet/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = list()
	data["name"] = name
	if(locked)
		return (SSnano && SSnano.close_uis(src))
	if(req_access_faction && req_access_faction != "")
		var/datum/world_faction/faction = get_faction(req_access_faction)
		data["connected_faction"] = faction.name
		var/datum/access_category/core/core = new()
		var/list/all_categories = list()
		all_categories |= core
		all_categories |= faction.access_categories
		var/list/access_categories[0]
		for(var/datum/access_category/category in all_categories)
			access_categories[++access_categories.len] = list("name" = category.name, "accesses" = list(), "ref" = "\ref[category]")
			for(var/x in category.accesses)
				var/name = category.accesses[x]
				if(!name) continue
				access_categories[access_categories.len]["accesses"] += list(list(
				"name" = sanitize("([x]) [name]"),
				"access" = x,
				"selected" = (text2num(x) in req_access)
				))
		data["access_categories"] = access_categories
	var/list/personal_access[0]
	for(var/x in req_access_personal_list)
		personal_access[++personal_access.len] = list("name" = x)
	data["personal_access"] = personal_access
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "closet.tmpl", "Container Programming", 800, 500, state = state)
		ui.set_initial_data(data)
		ui.open()


/obj/structure/closet/Topic(href, href_list)
	if(..())
		return 1
	. = SSnano.update_uis(src)
	if(locked)
		to_chat(usr, "The container is locked.")
		return
	switch(href_list["action"])
		if("change_name")
			var/chose_name = sanitize(input("Enter a new name for the container.", "Container Name", name), MAX_NAME_LEN)
			if(chose_name && usr.Adjacent(src) && !locked)
				name = chose_name
		if("add_name")
			var/chose_name = sanitize(input("Enter a new name to have personal access.", "Personal Access"), MAX_NAME_LEN)
			if(chose_name && usr.Adjacent(src) && !locked)
				req_access_personal_list |= chose_name
		if("remove_name")
			if(usr.Adjacent(src))
				var/chose_name = href_list["target"]
				req_access_personal_list -= chose_name
		if("remove_faction")
			if(usr.Adjacent(src))
				req_access_faction = ""
				req_access = list()
		if("pick_access")
			if(usr.Adjacent(src))
				if(text2num(href_list["selected_access"]) in req_access)
					req_access -= text2num(href_list["selected_access"])
				else
					req_access |= text2num(href_list["selected_access"])
		if("select_faction")
			var/obj/item/weapon/card/id/id_card = usr.GetIdCard()
			if(id_card)
				req_access_faction = id_card.selected_faction
