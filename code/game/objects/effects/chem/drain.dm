/obj/machinery/drain
	name = "DEPRECATED DRAIN - DECONSTRUCT"
	desc = "DEPRECATED - DECONSTRUCT IT. OBTAIN A NEW IMPROVED DRAIN ON PIPE DISPENSER."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "drain"
	layer = 2
	density = 0
	anchored = 1
	use_power = 0

	var/is_deleted //might as well check if it was deleted since it does on process and we never know how long it takes to qdel right..

/obj/machinery/drain/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if(isWelder(W))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.remove_fuel(1,user))
			playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
			to_chat(user, "<span class='notice'>You begin to unweld \the [src]...</span>")
			if (do_after(user, 40, src))
				playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
				user.visible_message( \
					"<span class='notice'>\The [user] unwelds \the [src].</span>", \
					"<span class='notice'>You have unwelded \the [src].</span>", \
					"You hear a ratchet.")
				new /obj/item/stack/material/steel( src.loc, 2 )
				qdel(src)

/obj/machinery/drain/Process() //Its deprecated, drop those precious sheets and kill yourself, drain.
	if(!is_deleted && !QDELETED(src) )
		is_deleted = 1
		new /obj/item/stack/material/steel( src.loc, 2 )
		qdel(src)
