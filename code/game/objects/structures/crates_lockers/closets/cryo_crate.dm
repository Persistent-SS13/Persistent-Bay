/obj/structure/cryo_crate
	name = "cryogenic crate"
	desc = "A crate which can sustain life and preserve objects in space, this one is still sealed."
	icon = 'icons/obj/closets/cryocrate.dmi'
	icon_state = "sealed"
	w_class = ITEM_SIZE_NO_CONTAINER
	health = 300
	density = TRUE
	anchored = FALSE
	mass = 15
	var/content_path = null
	var/symbol = null
	var/sealed = TRUE
	var/amount = 1

/obj/structure/cryo_crate/proc/select_cont()
	var/datum/t_picked = pick(100;/datum/rarity/critters, 100;/datum/rarity/seeds)
		
	///datum/rarity/artifacts
	///datum/rarity/datadisks
	///datum/rarity/paper		
	
	var/datum/rarity/type_p = new t_picked
	var/list/r_picked = list()

	if(prob(1) && type_p.special)
		r_picked = type_p.special
		symbol = "black star"
	
	else if(prob(10)&& type_p.rare)
		r_picked = type_p.rare
		symbol = "yellow diamond"

	else if(prob(45)&& type_p.uncommon)
		r_picked = type_p.uncommon
		symbol = "green square"

	else
		r_picked = type_p.common
		symbol = "pink circle"
		amount = rand(1,3)

	return pick(r_picked)

/obj/structure/cryo_crate/New()
	if(sealed)
		content_path = select_cont()
	
	..()

/obj/structure/cryo_crate/attack_hand(mob/user)
	if(src.sealed == TRUE) 
		var/choice = alert("Caution! [src]'s seal is still unbroken, are you sure you want to open it?",,"No","Yes")
		if(choice == "Yes")
			name = "unsealed cryogenic crate"
			desc = "[src] once perserved cargo in the void of space, now its only scrap metal."
			flick("cryocrate_opening",src)
			visible_message("<span class='warning'>[src] opens with a hiss as the pressure equalizes and its systems shut down!</span>")
			playsound(src,'sound/machines/hiss.ogg',40,1)
			var/datum/effect/effect/system/steam_spread/steam = new /datum/effect/effect/system/steam_spread()
			steam.set_up(10, 0, get_turf(src))
			steam.attach(src)
			steam.start()
			sealed = FALSE
			icon_state = "unsealed"
			sleep(10)
			//Check so that its not accidently opened in space, effects, etc.
			for(var/i = 1, i <= amount, i++)
				new content_path(loc)	//Spawn the contents		
		if(choice == "No")
			return

/obj/structure/cryo_crate/attackby(obj/item/W as obj, mob/user as mob)
	if(isWelder(W))
		var/obj/item/weapon/tool/weldingtool/WT = W
		if(WT.remove_fuel(5,user))
			playsound(loc, 'sound/items/Welder.ogg', 50, 1)
			to_chat(user, "<span class='notice'>You begin to deconstruct \the [src]...</span>")
			if (do_after(user, 40, src))
				playsound(loc, 'sound/items/Welder2.ogg', 50, 1)
				user.visible_message( \
					"<span class='notice'>\The [user] deconstructs \the [src].</span>", \
					"<span class='notice'>You have deconstructed \the [src].</span>")
				new /obj/item/stack/material/steel(loc, 5)
				qdel(src)
	else
		..()

/obj/structure/cryo_crate/examine(mob/user)
	to_chat(user, "[desc]")
	if(get_dist(user, src) < 3 && sealed == TRUE)
		to_chat(user, "On [src]'s hatch is emblazoned a small [symbol].")
	//Gives some indication of the contents while remaining mysterious.

/obj/structure/cryo_crate/attack_ghost(mob/ghost)
	if(ghost.client && ghost.client.inquisitive_ghost)
		ghost.examinate(src)
		to_chat(ghost, "It contains: [content_path].")

