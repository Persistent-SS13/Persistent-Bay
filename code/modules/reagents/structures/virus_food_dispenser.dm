/obj/structure/reagent_dispensers/virusfood
	name = "Virus Food Dispenser"
	desc = "A dispenser of virus food."
	icon = 'icons/obj/objects.dmi'
	icon_state = "virusfoodtank"
	amount_per_transfer_from_this = 10
	anchored = 1
	density = 0
	initial_reagent_types = list(/datum/reagent/nutriment/virus_food = 1)

/obj/structure/reagent_dispensers/virusfood/empty
	initial_reagent_types = null

/obj/structure/reagent_dispensers/virusfood/dismantle()
	new /obj/item/frame/plastic/virusfoodtank(loc)
	qdel(src)

/obj/structure/reagent_dispensers/virusfood/attackby(var/obj/item/weapon/W as obj, mob/user as mob)
	if(default_deconstruction_wrench(W))
		return 1
	else
		return ..()