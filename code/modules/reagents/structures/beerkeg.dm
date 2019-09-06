/obj/structure/reagent_dispensers/beerkeg
	name = "beer keg"
	desc = "A beer keg."
	icon = 'icons/obj/objects.dmi'
	icon_state = "beertankTEMP"
	amount_per_transfer_from_this = 10
	matter = list(MATERIAL_ALUMINIUM = 5 SHEET)
	initial_reagent_types = list(/datum/reagent/ethanol/beer = 1)
	atom_flags = ATOM_FLAG_CLIMBABLE

/obj/structure/reagent_dispensers/beerkeg/empty
	initial_reagent_types = list()

/obj/structure/reagent_dispensers/beerkeg/default_deconstruction_screwdriver(obj/item/weapon/tool/screwdriver/S, mob/living/user, deconstruct_time)
	if(reagents.total_volume == 0)
		. = ..()
	else
		to_chat(user, "<span class='notice'>Empty it first!</span>")

/obj/structure/reagent_dispensers/beerkeg/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(default_deconstruction_screwdriver(W, user, 2 SECONDS))
		return
	return ..()