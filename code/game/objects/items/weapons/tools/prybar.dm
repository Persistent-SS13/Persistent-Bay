/obj/item/weapon/tool/crowbar/prybar
	name = "pry bar"
	desc = "A steel bar with a wedge. It comes in a variety of configurations and colours - collect them all."
	icon_state = "prybar_preview"
	item_state = "crowbar"
	force = 4
	throwforce = 6
	throw_range = 5
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_STEEL = 80)

	var/prybar_types = list("1","2","3","4","5")
	var/valid_colours = list(COLOR_RED_GRAY, COLOR_BLUE_GRAY, COLOR_BOTTLE_GREEN, COLOR_MAROON, COLOR_DARK_BROWN, COLOR_VIOLET, COLOR_GRAY20)

/obj/item/weapon/tool/crowbar/prybar/Initialize()
	var/shape = pick(prybar_types)
	icon_state = "bar[shape]_handle"
	color = pick(valid_colours)
	overlays += overlay_image(icon, "bar[shape]_hardware", flags=RESET_COLOR)
	. = ..()
