/obj/structure/closet/crate/cryo
	name = "cryogenic crate"
	desc = "A crate which can sustain life and preserve objects in space, this one is still sealed."
	//closet_appearance = /decl/closet_appearance/large_crate/critter
	icon = 'icons/obj/closets/cryocrate.dmi'
	icon_state = "cryocrate_sealed"
	health = 300
	var/content_path = null
	var/symbol = null
	var/sealed = TRUE
	var/amount = 1

/obj/structure/closet/crate/cryo/proc/select_cont()
	var/datum/t_picked = pick(100;/datum/rarity/critters, 100;/datum/rarity/seeds)
		
		///datum/rarity/artifacts,
		///datum/rarity/datadisks,
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

/obj/structure/closet/crate/cryo/New()
	if(sealed)
		content_path = select_cont()

	if(content_path)
		for(var/i = 1, i <= amount, i++)
			var/mob/cold_critt = new content_path(src)
			if(cold_critt in SSmobs.mob_list)
				STOP_PROCESSING(SSmobs, cold_critt)
	//..()

/obj/structure/closet/crate/cryo/attack_hand(mob/user)
	if(src.opened == 0 && src.sealed == TRUE) 
		var/choice = alert("[src]'s seal is still unbroken, are you sure you want to open it?",,"No","Yes")
		if(choice == "Yes")
			name = "unsealed cryogenic crate"
			desc = "A crate which can sustain life and preserve objects in space, this one's already unsealed."
			flick("cryocrate_opening",src)
			visible_message("<span class='warning'>[src] opens with a hiss as the pressure equalizes and its systems shut down!</span>")
			playsound(src,'sound/machines/hiss.ogg',40,1)
			var/datum/effect/effect/system/steam_spread/steam = new /datum/effect/effect/system/steam_spread()
			steam.set_up(10, 0, get_turf(src))
			steam.attach(src)
			steam.start()
			sealed = FALSE

			for(var/mob/warm_critt in src)
				if(!(warm_critt in SSmobs.mob_list))
					START_PROCESSING(SSmobs, warm_critt)

			..()
			icon_state = "cryocrate_unsealed"
			//Check so that its not accidently opened in space, effects, etc.
		if(choice == "No")
			return
	//else
		//. = ..()

/obj/structure/closet/crate/cryo/examine(mob/user)
	. = ..()
	if(get_dist(user, src) < 3)
		to_chat(user, "On [src]'s door is emblazoned a [symbol].")
	//Gives some indication of the contents while remaining mysterious.
