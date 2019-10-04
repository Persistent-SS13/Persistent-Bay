/* Slime cores */

/datum/chemical_reaction/slime
	var/required = null

/datum/chemical_reaction/slime/can_happen(var/datum/reagents/holder)
	if(holder.my_atom && istype(holder.my_atom, required))
		var/obj/item/slime_extract/T = holder.my_atom
		if(T.Uses > 0)
			return ..()
	return 0

/datum/chemical_reaction/slime/on_reaction(var/datum/reagents/holder)
	var/obj/item/slime_extract/T = holder.my_atom
	T.Uses--
	if(T.Uses <= 0)
		T.visible_message("\icon[T]<span class='notice'>\The [T]'s power is consumed in the reaction.</span>")
		T.name = "used slime extract"
		T.desc = "This extract has been used up."

//Grey
/datum/chemical_reaction/slime/spawn
	name = "Slime Spawn"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/grey

/datum/chemical_reaction/slime/spawn/on_reaction(var/datum/reagents/holder)
	holder.my_atom.visible_message("<span class='warning'>Infused with phoron, the core begins to quiver and grow, and soon a new baby slime emerges from it!</span>")
	var/mob/living/carbon/slime/S = new /mob/living/carbon/slime
	S.loc = get_turf(holder.my_atom)
	..()

/datum/chemical_reaction/slime/monkey
	name = "Slime Monkey"
	result = null
	required_reagents = list(/datum/reagent/blood = 1)
	result_amount = 1
	required = /obj/item/slime_extract/grey

/datum/chemical_reaction/slime/monkey/on_reaction(var/datum/reagents/holder)
	for(var/i = 1, i <= 3, i++)
		var /obj/item/weapon/reagent_containers/food/snacks/monkeycube/M = new /obj/item/weapon/reagent_containers/food/snacks/monkeycube
		M.loc = get_turf(holder.my_atom)
	..()

//Green
//datum/chemical_reaction/slime/mutate
	//name = "Mutation Toxin"
	//result = /datum/reagent/slimetoxin
	//required_reagents = list(/datum/reagent/toxin/phoron = 1)
	//result_amount = 1
	//required = /obj/item/slime_extract/green

//Metal
/datum/chemical_reaction/slime/metal
	name = "Slime Metal"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/metal

/datum/chemical_reaction/slime/metal/on_reaction(var/datum/reagents/holder)
	var/obj/item/stack/material/steel/M = new /obj/item/stack/material/steel
	M.amount = 15
	M.loc = get_turf(holder.my_atom)
	var/obj/item/stack/material/plasteel/P = new /obj/item/stack/material/plasteel
	P.amount = 5
	P.loc = get_turf(holder.my_atom)
	..()

//Gold
/datum/chemical_reaction/slime/crit
	name = "Slime Crit"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/gold
	var/list/possible_mobs = list(
							/mob/living/simple_animal/cat,
							/mob/living/simple_animal/cat/kitten,
							/mob/living/simple_animal/corgi,
							/mob/living/simple_animal/corgi/puppy,
							/mob/living/simple_animal/cow,
							/mob/living/simple_animal/chick,
							/mob/living/simple_animal/chicken
							)

/datum/chemical_reaction/slime/crit/on_reaction(var/datum/reagents/holder)
	var/type = pick(possible_mobs)
	new type(get_turf(holder.my_atom))
	..()

//Silver
/datum/chemical_reaction/slime/bork
	name = "Slime Bork"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/silver

/datum/chemical_reaction/slime/bork/on_reaction(var/datum/reagents/holder)
	var/list/borks = typesof(/obj/item/weapon/reagent_containers/food/snacks) - /obj/item/weapon/reagent_containers/food/snacks
	playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)
	for(var/mob/living/carbon/human/M in viewers(get_turf(holder.my_atom), null))
		if(M.eyecheck() < FLASH_PROTECTION_MODERATE)
			M.flash_eyes()

	for(var/i = 1, i <= 4 + rand(1,2), i++)
		var/chosen = pick(borks)
		var/obj/B = new chosen
		if(B)
			B.loc = get_turf(holder.my_atom)
			if(prob(50))
				for(var/j = 1, j <= rand(1, 3), j++)
					step(B, pick(NORTH, SOUTH, EAST, WEST))
	..()

//Blue
/datum/chemical_reaction/slime/frost
	name = "Slime Frost Oil"
	result = /datum/reagent/frostoil
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 10
	required = /obj/item/slime_extract/blue

//Dark Blue
/datum/chemical_reaction/slime/freeze
	name = "Slime Freeze"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/darkblue
	mix_message = "The slime extract begins to vibrate violently!"

/datum/chemical_reaction/slime/freeze/on_reaction(var/datum/reagents/holder)
	set waitfor = 0
	..()
	sleep(50)
	playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)
	for(var/mob/living/M in range (get_turf(holder.my_atom), 7))
		M.bodytemperature -= 140
		to_chat(M, "<span class='warning'>You feel a chill!</span>")

//Orange
/datum/chemical_reaction/slime/casp
	name = "Slime Capsaicin Oil"
	result = /datum/reagent/capsaicin
	required_reagents = list(/datum/reagent/blood = 1)
	result_amount = 10
	required = /obj/item/slime_extract/orange

/datum/chemical_reaction/slime/fire
	name = "Slime fire"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/orange
	mix_message = "The slime extract begins to vibrate violently!"

/datum/chemical_reaction/slime/fire/on_reaction(var/datum/reagents/holder)
	set waitfor = 0
	..()
	sleep(50)
	if(!(holder.my_atom && holder.my_atom.loc))
		return

	var/turf/location = get_turf(holder.my_atom)
	location.assume_gas(GAS_PHORON, 250, 1400)
	location.hotspot_expose(700, 400)

//Yellow
/datum/chemical_reaction/slime/overload
	name = "Slime EMP"
	result = null
	required_reagents = list(/datum/reagent/blood = 1)
	result_amount = 1
	required = /obj/item/slime_extract/yellow

/datum/chemical_reaction/slime/overload/on_reaction(var/datum/reagents/holder, var/created_volume)
	..()
	empulse(get_turf(holder.my_atom), 3, 7)

/datum/chemical_reaction/slime/cell
	name = "Slime Powercell"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/yellow

/datum/chemical_reaction/slime/cell/on_reaction(var/datum/reagents/holder, var/created_volume)
	..()
	new /obj/item/weapon/cell/slime(get_turf(holder.my_atom))

/datum/chemical_reaction/slime/glow
	name = "Slime Glow"
	result = null
	required_reagents = list(/datum/reagent/water = 1)
	result_amount = 1
	required = /obj/item/slime_extract/yellow
	mix_message = "The contents of the slime core harden and begin to emit a warm, bright light."

/datum/chemical_reaction/slime/glow/on_reaction(var/datum/reagents/holder, var/created_volume)
	..()
	new /obj/item/device/flashlight/slime(get_turf(holder.my_atom))

//Purple
/datum/chemical_reaction/slime/psteroid
	name = "Slime Steroid"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/purple

/datum/chemical_reaction/slime/psteroid/on_reaction(var/datum/reagents/holder, var/created_volume)
	..()
	var/obj/item/weapon/slimesteroid/P = new /obj/item/weapon/slimesteroid
	P.loc = get_turf(holder.my_atom)

/datum/chemical_reaction/slime/jam
	name = "Slime Jam"
	result = /datum/reagent/slimejelly
	required_reagents = list(/datum/reagent/sugar = 1)
	result_amount = 10
	required = /obj/item/slime_extract/purple

//Dark Purple
/datum/chemical_reaction/slime/plasma
	name = "Slime Plasma"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/darkpurple

/datum/chemical_reaction/slime/plasma/on_reaction(var/datum/reagents/holder)
	..()
	var/obj/item/stack/material/phoron/P = new /obj/item/stack/material/phoron
	P.amount = 10
	P.loc = get_turf(holder.my_atom)

//Red
/datum/chemical_reaction/slime/glycerol
	name = "Slime Glycerol"
	result = /datum/reagent/glycerol
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 8
	required = /obj/item/slime_extract/red

/datum/chemical_reaction/slime/bloodlust
	name = "Bloodlust"
	result = null
	required_reagents = list(/datum/reagent/blood = 1)
	result_amount = 1
	required = /obj/item/slime_extract/red

/datum/chemical_reaction/slime/bloodlust/on_reaction(var/datum/reagents/holder)
	..()
	for(var/mob/living/carbon/slime/slime in viewers(get_turf(holder.my_atom), null))
		slime.rabid = 1
		slime.visible_message("<span class='warning'>The [slime] is driven into a frenzy!</span>")

//Pink
/datum/chemical_reaction/slime/ppotion
	name = "Slime Potion"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/pink

/datum/chemical_reaction/slime/ppotion/on_reaction(var/datum/reagents/holder)
	..()
	var/obj/item/weapon/slimepotion/P = new /obj/item/weapon/slimepotion
	P.loc = get_turf(holder.my_atom)

//Black
//datum/chemical_reaction/slime/mutate2
	//name = "Advanced Mutation Toxin"
	//result = /datum/reagent/aslimetoxin
	//required_reagents = list(/datum/reagent/toxin/phoron = 1)
	//result_amount = 1
	//required = /obj/item/slime_extract/black

//Oil
//datum/chemical_reaction/slime/explosion
	//name = "Slime Explosion"
	//result = null
	//required_reagents = list(/datum/reagent/toxin/phoron = 1)
	//result_amount = 1
	//required = /obj/item/slime_extract/oil
	//mix_message = "The slime extract begins to vibrate violently!"

//datum/chemical_reaction/slime/explosion/on_reaction(var/datum/reagents/holder)
	//set waitfor = 0
	//..()
	//sleep(50)
	//explosion(get_turf(holder.my_atom), 1, 3, 6)

//Light Pink
/datum/chemical_reaction/slime/potion2
	name = "Slime Potion 2"
	result = null
	result_amount = 1
	required = /obj/item/slime_extract/lightpink
	required_reagents = list(/datum/reagent/toxin/phoron = 1)

/datum/chemical_reaction/slime/potion2/on_reaction(var/datum/reagents/holder)
	..()
	new /obj/item/weapon/slimepotion2(get_turf(holder.my_atom))

//Adamantine
/datum/chemical_reaction/slime/golem
	name = "Slime Golem"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/adamantine

/datum/chemical_reaction/slime/golem/on_reaction(var/datum/reagents/holder)
	..()
	var/obj/effect/golemrune/Z = new /obj/effect/golemrune(get_turf(holder.my_atom))
	Z.announce_to_ghosts()

//Sepia
/datum/chemical_reaction/slime/film
	name = "Slime Film"
	result = null
	required_reagents = list(/datum/reagent/blood = 1)
	result_amount = 2
	required = /obj/item/slime_extract/sepia

/datum/chemical_reaction/slime/film/on_reaction(var/datum/reagents/holder)
	for(var/i in 1 to result_amount)
		new /obj/item/device/camera_film(get_turf(holder.my_atom))
	..()

/datum/chemical_reaction/slime/camera
	name = "Slime Camera"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/sepia

/datum/chemical_reaction/slime/camera/on_reaction(var/datum/reagents/holder)
	new /obj/item/device/camera(get_turf(holder.my_atom))
	..()

//Bluespace
/datum/chemical_reaction/slime/teleport
	name = "Slime Teleport"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	required = /obj/item/slime_extract/bluespace
	reaction_sound = 'sound/effects/teleport.ogg'

/datum/chemical_reaction/slime/teleport/on_reaction(var/datum/reagents/holder)
	var/list/turfs = list()
	for(var/turf/T in orange(holder.my_atom,6))
		turfs += T
	for(var/atom/movable/a in viewers(holder.my_atom,2))
		if(!a.simulated)
			continue
		a.forceMove(pick(turfs))
	..()

//pyrite
/datum/chemical_reaction/slime/paint
	name = "Slime Paint"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	required = /obj/item/slime_extract/pyrite

/datum/chemical_reaction/slime/paint/on_reaction(var/datum/reagents/holder)
	new /obj/item/weapon/reagent_containers/glass/paint/random(get_turf(holder.my_atom))
	..()

//cerulean
/datum/chemical_reaction/slime/extract_enhance
	name = "Extract Enhancer"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	required = /obj/item/slime_extract/cerulean

/datum/chemical_reaction/slime/extract_enhance/on_reaction(var/datum/reagents/holder)
	new /obj/item/weapon/slimesteroid2(get_turf(holder.my_atom))
	..()
