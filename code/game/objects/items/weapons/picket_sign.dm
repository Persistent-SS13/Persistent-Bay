/obj/item/weapon/picket_sign
	icon = 'icons/obj/weapons.dmi'
	icon_state = "picket"
	item_state = "picket"
	name = "blank picket sign"
	desc = "It's blank."
	force = 5
	w_class = ITEM_SIZE_HUGE
	attack_verb = list("bashed","smacked")
	obj_flags = OBJ_FLAG_CONDUCTIBLE

	var/label = ""
	var/last_wave = 0

/obj/item/weapon/picket_sign/proc/retext(mob/user)
	if(!label)
		var/txt = sanitizeSafe(input(user, "What would you like to write on the sign?", "Sign Label",""), 30)
		if(txt)
			label = txt
			name = "[label] sign"
			desc =	"It reads: [label]"

	else if(label)
		user.visible_message("<span class='notice'>\"[label]\" is already written on the sign.</span>")

/obj/item/weapon/picket_sign/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/weapon/pen))
		retext(user)
		add_fingerprint(user)

	else if(isWirecutter(W))
		if(do_after(user, 10, src))
			playsound(loc, 'sound/items/Wirecutter.ogg', 50, 1)
			to_chat(user, "<span class='notice'>[user] takes apart the [src].</span>")
			new /obj/item/stack/material/rods(user.loc, 1)
			new /obj/item/stack/material/cardboard(user.loc, 2)
			qdel(src)

	else
		return ..()

/obj/item/weapon/picket_sign/attack_self(mob/living/carbon/human/user)
	if( last_wave + 20 < world.time )
		last_wave = world.time
		if(label)
			user.visible_message("<span class='warning'>[user] waves around the \"[label]\" sign.</span>")
		else
			user.visible_message("<span class='warning'>[user] waves around a blank sign.</span>")
