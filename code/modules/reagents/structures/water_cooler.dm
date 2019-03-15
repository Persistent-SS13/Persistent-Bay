/obj/structure/reagent_dispensers/water_cooler
	name = "Water-Cooler"
	desc = "A machine that dispenses water to drink."
	amount_per_transfer_from_this = 5
	icon = 'icons/obj/vending.dmi'
	icon_state = "water_cooler"
	possible_transfer_amounts = null
	matter = list(MATERIAL_STEEL = 200)
	anchored = 0
	initial_capacity = 500
	initial_reagent_types = list(/datum/reagent/water = 1)

/obj/structure/reagent_dispensers/water_cooler/empty
	initial_reagent_types = list()

/obj/structure/reagent_dispensers/water_cooler/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(isWrench(W))
		src.add_fingerprint(user)
		if(anchored)
			user.visible_message("\The [user] begins unsecuring \the [src] from the floor.", "You start unsecuring \the [src] from the floor.")
		else
			user.visible_message("\The [user] begins securing \the [src] to the floor.", "You start securing \the [src] to the floor.")

		if(do_after(user, 20, src))
			if(!src) return
			to_chat(user, "<span class='notice'>You [anchored? "un" : ""]secured \the [src]!</span>")
			anchored = !anchored
		return
	else if(isScrewdriver(W))
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