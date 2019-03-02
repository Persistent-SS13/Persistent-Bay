/obj/item/canvas //test item
	name = "Canvas"
	desc = "Such avant-garde, much art."
	gender = NEUTER
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "canvas"
	var/icon_offset_x = 1
	var/icon_offset_y = 1

/obj/item/canvas/attack_self(mob/user)
	if (!designer_unit)
		designer_unit = new()
	designer_unit.pixel_width = 30
	designer_unit.pixel_height = 30
	var/title_consent = input("Do you want to give it a title?", "Designer", "No") in list("Yes", "No")
	if (title_consent == "Yes")
		designer_unit.title = input("Title:", "Designer", "")
		if (length(designer_unit.title) >= 1)
			src.name = "\"[designer_unit.title]\""
			var/author_consent = input("Do you Also want to sign it?", "Designer", "Yes") in list("Yes", "No")
			if (author_consent == "Yes")
				src.name += " by [usr.real_name]"
	designer_unit.Design(src, icon_offset_x, icon_offset_y)

/obj/item/canvas/designer_update_icon()
	overlays.Cut()
	overlays += designer_unit.icon_custom
