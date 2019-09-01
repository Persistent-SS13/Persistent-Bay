/mob/living/simple_animal/hostile/scarybat
	name = "locusectums"
	desc = "A swarm of of terrible locusectum."
	icon = 'icons/mob/bats.dmi'
	icon_state = "bat"
	icon_living = "bat"
	icon_dead = "bat_dead"
	icon_gib = "bat_dead"
	speak_chance = 0
	turns_per_move = 3
	meat_amount = 2
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	speed = 2
	maxHealth = 20
	health = 20

	harm_intent_damage = 8
	melee_damage_lower = 4
	melee_damage_upper = 12
	attacktext = "bites"
	attack_sound = 'sound/weapons/bite.ogg'

	min_gas = null
	max_gas = null
	minbodytemp = 0

	environment_smash = 1

	faction = "asteroid"
	var/mob/living/owner

/mob/living/simple_animal/hostile/scarybat/New(loc, mob/living/L as mob)
	..()
	if(istype(L))
		owner = L

/mob/living/simple_animal/hostile/scarybat/Destroy()
	owner = null
	return ..()

/mob/living/simple_animal/hostile/scarybat/Allow_Spacemove(var/check_drift = 0)
	return 1 // Ripped from space carp, no more floating

/mob/living/simple_animal/hostile/scarybat/FindTarget()
	. = ..()
	if(.)
		emote("jets towards [.]")

/mob/living/simple_animal/hostile/scarybat/Found(var/atom/A)//This is here as a potential override to pick a specific target if available
	if(istype(A) && A == owner)
		return 0
	return ..()

/mob/living/simple_animal/hostile/scarybat/AttackingTarget()
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(25))
			L.Stun(1)
			L.visible_message("<span class='danger'>One of \the [src] stings \the [L]!</span>")

/mob/living/simple_animal/hostile/scarybat/cult
	faction = "cult"
	supernatural = 1

/mob/living/simple_animal/hostile/scarybat/cult/cultify()
	return
