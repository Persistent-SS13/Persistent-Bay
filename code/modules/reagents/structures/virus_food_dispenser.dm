/obj/structure/reagent_dispensers/wall/virusfood
	name = "Virus Food Dispenser"
	desc = "A dispenser of virus food."
	icon = 'icons/obj/objects.dmi'
	icon_state = "virusfoodtank"
	amount_per_transfer_from_this = 10
	initial_reagent_types = list(/datum/reagent/nutriment/virus_food = 1)

/obj/structure/reagent_dispensers/wall/virusfood/empty
	initial_reagent_types = null

/obj/structure/reagent_dispensers/wall/virusfood/dismantle()
	new /obj/item/frame/plastic/virusfoodtank(loc)
	qdel(src)
