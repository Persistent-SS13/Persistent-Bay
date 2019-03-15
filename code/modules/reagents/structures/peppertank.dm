/obj/structure/reagent_dispensers/wall/peppertank
	name = "Pepper Spray Refiller"
	desc = "Refills pepper spray canisters."
	icon = 'icons/obj/objects.dmi'
	icon_state = "peppertank"
	amount_per_transfer_from_this = 45
	initial_reagent_types = list(/datum/reagent/capsaicin/condensed = 1)

/obj/structure/reagent_dispensers/wall/peppertank/empty
	initial_reagent_types = null

/obj/structure/reagent_dispensers/wall/peppertank/dismantle()
	new /obj/item/frame/plastic/peppertank(loc)
	qdel(src)
