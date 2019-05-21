/*
 * Wrench
 */
/obj/item/weapon/tool/wrench
	name = "wrench"
	desc = "A good, durable combination wrench, with self-adjusting, universal open- and ring-end mechanisms to match a wide variety of nuts and bolts."
	description_info = "This versatile tool is used for dismantling machine frames, anchoring or unanchoring heavy objects like vending machines and emitters, and much more. In general, if you want something to move or stop moving entirely, you ought to use a wrench on it."
	description_fluff = "The classic open-end wrench (or spanner, if you prefer) hasn't changed significantly in shape in over 500 years, though these days they employ a bit of automated trickery to match various bolt sizes and configurations."
	description_antag = "Not only is this handy tool good for making off with machines, but it even makes a weapon in a pinch!"
	icon = 'icons/obj/tools.dmi'
	icon_state = "wrench"
	item_state = "wrench"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	force = 5.0
	throwforce = 7.0
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 150)
	center_of_mass = "x=17;y=16"
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")

/obj/item/weapon/tool/wrench/Initialize()
	icon_state = "wrench[pick("","_red","_black","_green","_blue")]"
	. = ..()

/obj/item/weapon/tool/wrench/play_tool_sound()
	playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
