/obj/structure/reagent_dispensers/beerkeg
	name = "beer keg"
	desc = "A beer keg."
	icon = 'icons/obj/objects.dmi'
	icon_state = "beertankTEMP"
	amount_per_transfer_from_this = 10
	matter = list(MATERIAL_ALUMINIUM = 20 SHEET)
	initial_reagent_types = list(/datum/reagent/ethanol/beer = 1)
	atom_flags = ATOM_FLAG_CLIMBABLE

/obj/structure/reagent_dispensers/beerkeg/empty
	initial_reagent_types = list()

/obj/structure/reagent_dispensers/beerkeg/dismantle()
	refund_matter()
	qdel(src)

/obj/structure/reagent_dispensers/beerkeg/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(default_deconstruction_screwdriver(W, user, 2 SECONDS))
		
		if(reagents.total_volume == 0)
			to_chat(user, "<span class='notice'>You begin dismantling \the [src].</span>")
			if(do_after(user, 20, src))
				if(!src) return
				to_chat(user, "<span class='notice'>You finish dismantling \the [src].</span>")

		else
			to_chat(user, "<span class='notice'>Empty it first!</span>")
	else
		return ..()