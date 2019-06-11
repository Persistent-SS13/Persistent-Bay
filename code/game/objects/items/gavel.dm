// Contains:
// Gavel Hammer
// Gavel Block

/obj/item/gavelhammer
	name = "gavel hammer"
	desc = "Order, order! No bombs in my courthouse."
	icon = 'icons/obj/items/gavelhammer.dmi'
	icon_state = "gavelhammer"
	force = 5
	throwforce = 6
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("bashed", "battered", "judged", "whacked")

/obj/item/gavelblock
	name = "gavel block"
	desc = "Smack it with a gavel hammer when the assistants get rowdy."
	icon = 'icons/obj/items/gavelhammer.dmi'
	icon_state = "gavelblock"
	force = 2
	throwforce = 2
	w_class = ITEM_SIZE_SMALL

/obj/item/gavelblock/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/gavelhammer))
		playsound(loc, 'sound/items/gavel.ogg', 100, 1)
		user.visible_message("<span class='warning'>[user] strikes [src] with [I].</span>")
	else
		return ..()