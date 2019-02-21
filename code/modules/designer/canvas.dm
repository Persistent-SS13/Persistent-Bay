/obj/item/canvas //test item
	name = "Canvas"
	desc = "Such avant-garde, much art."
	gender = NEUTER
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "canvas"
	var/icon/icon_custom
	var/list/pixel_list
	var/datum/designer/design

	var/icon_offset_x = 1
	var/icon_offset_y = 1

/obj/item/canvas/New()
	design = new(source = src)
	icon_custom = icon

/obj/item/canvas/attack_self(mob/user)
	design.pixel_width = 30
	design.pixel_height = 30
	design.Design(icon_custom, icon_offset_x, icon_offset_y)

/obj/item/canvas/GetDesign(var/icon/ico, ckey)
	if (!ico || !istype(ico) )
		return
	ico.Shift(EAST, icon_offset_x)
	ico.Shift(SOUTH, icon_offset_y)
	icon_custom = ico
	overlays.Cut()
	overlays += icon_custom

	if (ckey)
		designer_creator_ckey = ckey

	var/title_consent = input("Do you want to give it a title?", "Designer", "No") in list("Yes", "No")
	if (title_consent == "Yes")
		design.title = input("Title:", "Designer", "")
		if (length(design.title) >= 1)
			src.name = "\"[design.title]\""
			var/author_consent = input("Do you Also want to sign it?", "Designer", "Yes") in list("Yes", "No")
			if (author_consent == "Yes")
				src.name += " by [usr.real_name]"
