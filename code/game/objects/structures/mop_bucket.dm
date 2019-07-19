/obj/structure/mopbucket
	name = "mop bucket"
	desc = "Fill it with water, but don't forget a mop!"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "mopbucket"
	density = 1
	w_class = ITEM_SIZE_NORMAL
	atom_flags = ATOM_FLAG_CLIMBABLE | ATOM_FLAG_OPEN_CONTAINER
	mass = 5
	max_health = 50
	var/amount_per_transfer_from_this = 5	//shit I dunno, adding this so syringes stop runtime erroring. --NeoFite
	matter = list(MATERIAL_PLASTIC = 3000)

/obj/structure/mopbucket/New()
	..()

/obj/structure/mopbucket/SetupReagents()
	..()
	create_reagents(250)

/obj/structure/mopbucket/examine(mob/user)
	if(..(user, 1))
		to_chat(user, "[src] \icon[src] contains [reagents.total_volume] unit\s of water!")

/obj/structure/mopbucket/proc/fill_from_bucket(var/obj/item/I, var/mob/user)
	if(I.reagents.total_volume >= I.reagents.maximum_volume)
		return
	if(reagents.total_volume < 1)
		to_chat(user, "<span class='warning'>[src] is out of water!</span>")
	else
		reagents.trans_to_obj(I, I.reagents.maximum_volume)
		to_chat(user, "<span class='notice'>You wet [I] in [src].</span>")
		playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		return

/obj/structure/mopbucket/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/mop))
		fill_from_bucket(I, user)
	else if(istype(I, /obj/item/weapon/soap))
		fill_from_bucket(I, user)
	else if(istype(I, /obj/item/weapon/reagent_containers/glass/rag))
		fill_from_bucket(I, user)
	else if(istype(I, /obj/item/weapon/reagent_containers/glass))
		return //pour away but don't hit the thing
	else if(isWrench(I))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		to_chat(user, "<span class='notice'>You deconstruct \the [src]</span>")
		new /obj/item/stack/material/plastic(src.loc, 3)
		qdel(src)
	else
		return ..()
