/obj/item/frame/canvas
	name = "Canvas"
	desc = "Such avant-garde, much art."
	gender = NEUTER
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "canvas"
	build_machine_type = /obj/structure/canvas

	var/icon_offset_x = 1
	var/icon_offset_y = 1
	var/icon_width = 30
	var/icon_height = 30



/obj/item/frame/canvas/examine(mob/user)
	show(user)
	..()

/obj/item/frame/canvas/proc/show(mob/user as mob)
	if(designer_unit && designer_unit.icon_custom)
		user << browse_rsc(designer_unit.icon_custom, "tmp_canvas_\ref[src].png")
		user << browse("<html><head><title>[name]</title></head>" \
			+ "<body style='overflow:hidden;margin:0;text-align:center'>" \
			+ "<img src='tmp_canvas_\ref[src].png' width='128' style='-ms-interpolation-mode:nearest-neighbor' />" \
			+ "</body></html>", "window=book;size=128x128")
		onclose(user, "[name]")
		return



/obj/item/frame/canvas/New()
	desc += "This canvas has a size of [icon_width] by [icon_height]."

/obj/item/frame/canvas/Destroy()
	designer_disassociate()
	. = ..()

/obj/item/frame/canvas/attack_self(mob/user)
	if (!designer_unit)
		designer_unit = new()
	// Set size and offset
	designer_unit.icon_width = icon_width
	designer_unit.icon_height = icon_height
	designer_unit.icon_offset_x = icon_offset_x
	designer_unit.icon_offset_y = icon_offset_y

	var/title_consent = input("Do you want to give it a title?", "Designer", "No") in list("Yes", "No")
	if (title_consent == "Yes")
		designer_unit.title = input("Title:", "Designer", "")
		if (length(designer_unit.title) >= 1)
			src.name = "\"[designer_unit.title]\""
			var/author_consent = input("Do you Also want to sign it?", "Designer", "Yes") in list("Yes", "No")
			if (author_consent == "Yes")
				src.name += " by [usr.real_name]"
	designer_unit.Design(src)

/obj/item/frame/canvas/designer_update_icon()
	overlays.Cut()
	overlays += designer_unit.icon_custom

////////// WALL CANVAS STRUCTURE

/obj/structure/canvas
	name = "Mounted canvas"
	desc = "Such avant-garde, much art."
	gender = NEUTER
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "canvas"

	var/canvas_item = /obj/item/frame/canvas


/obj/structure/canvas/examine(mob/user)
	show(user)
	..()

/obj/structure/canvas/proc/show(mob/user as mob)
	if(designer_unit && designer_unit.icon_custom)
		user << browse_rsc(designer_unit.icon_custom, "tmp_canvas_\ref[src].png")
		user << browse("<html><head><title>[name]</title></head>" \
			+ "<body style='overflow:hidden;margin:0;text-align:center'>" \
			+ "<img src='tmp_canvas_\ref[src].png' width='128' style='-ms-interpolation-mode:nearest-neighbor' />" \
			+ "</body></html>", "window=book;size=128x128")
		onclose(user, "[name]")
		return


/obj/structure/canvas/New(loc, dir, atom/frame)
	..(loc)

	if(dir)
		src.set_dir(dir)

	if(istype(frame))
		pixel_x = (src.dir & 3)? 0 : (src.dir == 4 ? -32 : 32)
		pixel_y = (src.dir & 3)? (src.dir ==1 ? -32 : 32) : 0
		frame.transfer_fingerprints_to(src)

	icon = frame.icon
	icon_state = frame.icon_state
	name = frame.name
	desc = frame.desc
	canvas_item = frame.type
	designer_associate(frame.designer_unit)
	designer_update_icon()
	anchored = 1

/obj/structure/canvas/Destroy()
		designer_disassociate()
		. = ..()

/obj/structure/canvas/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if (isCrowbar(O))
		//PUT SOUND HERE... LATA.
		var/obj/item/frame/canvas/c_item = new canvas_item (loc)
		c_item.designer_associate(designer_unit)
		c_item.name = name
		c_item.dir = SOUTH
		c_item.designer_update_icon()
		qdel(src)

/obj/structure/canvas/designer_update_icon()
	overlays.Cut()
	var/icon/ico = new(designer_unit.icon_custom)
	switch(dir)
		if (NORTH)
			ico.Turn(180)
		if (EAST)
			ico.Turn(-90)
		if (WEST)
			ico.Turn(90)
	overlays += ico
