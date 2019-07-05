/obj/structure/reagent_dispensers/wall/acid
	name = "Sulphuric Acid Dispenser"
	desc = "A dispenser of acid for industrial processes."
	icon = 'icons/obj/objects.dmi'
	icon_state = "acidtank"
	amount_per_transfer_from_this = 10
	initial_reagent_types = list(/datum/reagent/acid = 1)

/obj/structure/reagent_dispensers/wall/acid/empty
	initial_reagent_types = null

/obj/structure/reagent_dispensers/wall/acid/dismantle()
	new /obj/item/frame/plastic/acidtank(loc)
	qdel(src)
