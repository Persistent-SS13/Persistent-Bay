/obj/structure/reagent_dispensers/watertank
	name = "watertank"
	desc = "A tank containing water."
	icon = 'icons/obj/objects.dmi'
	icon_state = "watertank"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = "10;25;50;100"
	initial_capacity = 50000
	initial_reagent_types = list(/datum/reagent/water = 1)
	atom_flags = ATOM_FLAG_CLIMBABLE

/obj/structure/reagent_dispensers/watertank/empty
	initial_reagent_types = list()

/obj/structure/reagent_dispensers/watertank/attackby(var/obj/item/weapon/W as obj, mob/user as mob)
	if(isScrewdriver(W))
		src.add_fingerprint(user)
		if(reagents.total_volume == 0)
			to_chat(user, "<span class='notice'>You begin dismantling \the [src].</span>")
			if(do_after(user, 20, src))
				if(!src) return
				to_chat(user, "<span class='notice'>You finish dismantling \the [src].</span>")
				new /obj/item/stack/material/steel(src.loc, 10)
				qdel(src)
		else
			to_chat(user, "<span class='notice'>Empty it first!</span>")
	else
		return ..()