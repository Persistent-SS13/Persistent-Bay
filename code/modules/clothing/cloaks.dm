//Cloaks. No, not THAT kind of cloak.

/obj/item/clothing/cloak	//Cloaks now have pockets! :D
	var/obj/item/weapon/storage/internal/pockets/pockets

/obj/item/clothing/cloak/New()
	..()
	pockets = new/obj/item/weapon/storage/internal/pockets(src, slots = 2, slot_size = 2) //two slots, fit only pocket sized items

/obj/item/clothing/cloak/Destroy()
	QDEL_NULL(pockets)
	. = ..()

/obj/item/clothing/cloak/attack_hand(mob/user as mob)
	if (pockets.handle_attack_hand(user))
		..(user)

/obj/item/clothing/cloak/MouseDrop(obj/over_object as obj)
	if (pockets.handle_mousedrop(usr, over_object))
		..(over_object)

/obj/item/clothing/cloak/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(!(W in accessories))		//Make sure that an accessory wasn't successfully attached to suit.
		pockets.attackby(W, user)

/obj/item/clothing/cloak/emp_act(severity)
	pockets.emp_act(severity)
	..()

/obj/item/clothing/cloak
	name = "black cloak"
	desc = "A dark-colored cloak. Appears to have 2 pockets inside."
	icon = 'icons/obj/clothing/cloaks.dmi'
	icon_state = "blackcloak"
	w_class = 3	//Classified as normal instead of small items to prevent infinite storage capabilities!!!
	slot_flags = SLOT_BACK
	cold_protection = UPPER_TORSO | ARMS | HANDS
	min_cold_protection_temperature = 257
//Cloaks keep your chest, arms, and hands toasty, but only slightly. For reference, humans start taking cold damage at 260.15K.

/obj/item/clothing/cloak/green
	name = "\improper Unathi cloak"
	desc = "A traditional green cloak worn commonly by the Unathi and by humans who have been gifted them."
	icon_state = "greencloak"

/obj/item/clothing/cloak/hos
	name = "\improper Head of Security's Cloak"
	desc = "A dark cloak lined with what could be red trimming, or blood. Worn by the Head of Security."
	icon_state = "hoscloak"

/obj/item/clothing/cloak/qm
	name = "quartermaster's cloak"
	desc = "Worn by the Quartermaster, in charge of supplying the station with the necessary tools for survival."
	icon_state = "qmcloak"

/obj/item/clothing/cloak/cmo
	name = "\improper Chief Medical Officer's Cloak"
	desc = "A cloak worn by the valiant men and women keeping pestilence at bay."
	icon_state = "cmocloak"

/obj/item/clothing/cloak/ce
	name = "\improper Chief Engineer's Cloak"
	desc = "An olive-colored, shimmering cloak worn by the Chief Engineer."
	icon_state = "cecloak"

/obj/item/clothing/cloak/rd
	name = "\improper Research Director's Cloak"
	desc = "A cloak worn by the thaumaturges and researchers of the universe."
	icon_state = "rdcloak"

/obj/item/clothing/cloak/cap
	name = "\improper Captain's Cloak"
	desc = "An elegant blue cloak with gold trimming. Worn by the commander of the station."
	icon_state = "capcloak"
