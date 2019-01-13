/obj/item/canvas //test item
	name = "Canvas"
	desc = "Such avant-garde, much art."
	gender = NEUTER
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "canvas"
	var/image/icon_custom
	var/list/pixel_list
	var/datum/designer/design

/obj/item/canvas/New()
	design = new(source = src)

/obj/item/canvas/attack_self(mob/user)
	design.pixel_width = 31
	design.pixel_height = 31
	design.Design()

/obj/item/canvas/GetDesign(var/icon/ico, ckey)
	if (!ico || !istype(ico) )
		return
	var/offset_x = 1
	var/offset_y = 1
	ico.Shift(EAST, offset_x)
	ico.Shift(SOUTH, offset_y)
	icon_custom = image(ico)
	overlays.Cut()
	overlays += icon_custom.icon

	if (ckey)
		designer_creator_ckey = ckey

/obj/item/canvas/after_load()
	if(icon_custom)
		overlays += icon_custom.icon
	..()