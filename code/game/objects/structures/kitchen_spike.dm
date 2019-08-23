//////Kitchen Spike

/obj/structure/kitchenspike_frame
	name = "meatspike frame"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "spikeframe"
	desc = "The frame of a meat spike."
	density = TRUE
	anchored = FALSE
	max_health = 100
	mass = 8

/obj/structure/kitchenspike_frame/attackby(obj/item/I, mob/user, params)
	add_fingerprint(user)
	if(isWrench(I))
		to_chat(user, "<span class='notice'>You begin [anchored ? "un" : ""]securing [src]...</span>")
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, 40, src))
			user.visible_message( \
				"<span class='notice'>\The [user] [anchored ? "un" : ""]secured \the [src].</span>", \
				"<span class='notice'>You have [anchored ? "un" : ""]secured \the [src].</span>", \
				"You hear ratchet.")
			src.anchored = !src.anchored

	else if(istype(I, /obj/item/stack/material/rods))
		var/obj/item/stack/material/rods/R = I
		if(R.get_amount() >= 4)
			R.use(4)
			to_chat(user, "<span class='notice'>You add spikes to the frame.</span>")
			var/obj/F = new /obj/structure/kitchenspike(src.loc)
			transfer_fingerprints_to(F)
			qdel(src)
	else if(isWelder(I))
		var/obj/item/weapon/tool/weldingtool/WT = I
		if(!WT.remove_fuel(0, user))
			to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
			return
		to_chat(user, "<span class='notice'>You begin cutting \the [src] apart...</span>")
		if(do_after(user, 50, src))
			visible_message("<span class='notice'>[user] slices apart \the [src].</span>",
				"<span class='notice'>You cut \the [src] apart with \the [I].</span>",
				"<span class='italics'>You hear welding.</span>")
			new /obj/item/stack/material/steel(src.loc, 4)
			qdel(src)
		return
	else
		return ..()

/obj/structure/kitchenspike
	name = "meat spike"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "spike"
	desc = "A spike for collecting meat from animals."
	density = 1
	anchored = 1
	var/meat = 0
	var/occupied
	var/meat_type
	var/victim_name = "corpse"

/obj/structure/kitchenspike/New()
	. = ..()
	ADD_SAVED_VAR(meat)
	ADD_SAVED_VAR(occupied)
	ADD_SAVED_VAR(meat_type)
	ADD_SAVED_VAR(victim_name)
	ADD_SAVED_VAR(icon_state)

/obj/structure/kitchenspike/dismantle()
	var/obj/F = new /obj/structure/kitchenspike_frame(src.loc)
	transfer_fingerprints_to(F)
	new /obj/item/stack/material/rods(loc, 4)
	qdel(src)

/obj/structure/kitchenspike/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I
		if(!G.affecting)
			return
		if(occupied)
			to_chat(user, "<span class = 'danger'>The spike already has something on it, finish collecting its meat first!</span>")
		else
			if(spike(G.affecting))
				visible_message("<span class = 'danger'>[user] has forced [G.affecting] onto the spike, killing them instantly!</span>")
				qdel(G.affecting)
				qdel(G)
			else
				to_chat(user, "<span class='danger'>They are too big for the spike, try something smaller!</span>")
	else if(isCrowbar(I))
		if(occupied)
			to_chat(user, "<span class='notice'>You can't do that while something's on the spike!</span>")
			return
		to_chat(user, "<span class='notice'>You begin prying the spikes out of the frame...</span>")
		if(do_after(user, 20, src))
			to_chat(user, "<span class='notice'>You pry the spikes out of the frame.</span>")
			dismantle()

/obj/structure/kitchenspike/proc/spike(var/mob/living/victim)

	if(!istype(victim))
		return

	if(istype(victim, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = victim
		if(!issmall(H))
			return 0
		meat_type = H.species.meat_type
		icon_state = "spikebloody"
	else if(istype(victim, /mob/living/carbon/alien))
		meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/xenomeat
		icon_state = "spikebloodygreen"
	else
		return 0

	victim_name = victim.name
	occupied = 1
	meat = 5
	return 1

/obj/structure/kitchenspike/attack_hand(mob/user as mob)
	if(..() || !occupied)
		return
	meat--
	new meat_type(get_turf(src))
	if(src.meat > 1)
		to_chat(user, "You remove some meat from \the [victim_name].")
	else if(src.meat == 1)
		to_chat(user, "You remove the last piece of meat from \the [victim_name]!")
		icon_state = "spike"
		occupied = 0
