/obj/item/weapon/folder/envelope
	name = "envelope"
	desc = "A thick envelope. You can't see what's inside."
	icon = 'icons/obj/envelope.dmi'
	icon_state = "envelope_sealed"
	var/sealed = 1

/obj/item/weapon/folder/envelope/New()
	. = ..()
	ADD_SAVED_VAR(sealed)

/obj/item/weapon/folder/envelope/update_icon()
	if(sealed)
		icon_state = "envelope_sealed"
	else
		icon_state = "envelope[contents.len > 0]"

/obj/item/weapon/folder/envelope/examine(var/user)
	..()
	to_chat(user, "The seal is [sealed ? "intact" : "broken"].")

/obj/item/weapon/folder/envelope/proc/sealcheck(user)
	var/ripperoni = alert("Are you sure you want to break the seal on \the [src]?", "Confirmation","Yes", "No")
	if(ripperoni == "Yes")
		visible_message("[user] breaks the seal on \the [src], and opens it.")
		sealed = 0
		update_icon()
		return 1

/obj/item/weapon/folder/envelope/attack_self(mob/user as mob)
	if(sealed)
		sealcheck(user)
		return
	else
		..()

/obj/item/weapon/folder/envelope/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(sealed)
		sealcheck(user)
		return
	else
		..()