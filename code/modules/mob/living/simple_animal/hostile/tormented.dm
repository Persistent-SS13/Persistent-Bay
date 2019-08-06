/mob/living/simple_animal/hostile/tormented
	name = "Tormented"
	desc = "The wounds on its body don't look self inflicted."
	icon_state = "tormented"
	icon_living = "tormented"
	icon_dead = "tormented_dead"
	speak_chance = 0
	turns_per_move = 5
	response_help = "passes through"
	response_disarm = "shoves"
	response_harm = "hits"
	maxHealth = 50
	health = 50

	harm_intent_damage = 10
	melee_damage_lower = 15
	melee_damage_upper = 25
	attacktext = "slashed"
	attack_sound = 'sound/weapons/pierce.ogg'

	min_gas = null
	max_gas = null
	minbodytemp = 0
	speed = 3

/mob/living/simple_animal/hostile/tormented/Allow_Spacemove(var/check_drift = 0)
	return 1

/mob/living/simple_animal/hostile/tormented/FindTarget()
	. = ..()
	if(.)
		audible_emote("growls at [.]")
	playsound(src.loc, 'sound/hallucinations/growl1.ogg', 50, 0)
/mob/living/simple_animal/hostile/tormented/AttackingTarget()
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(8))
			L.Weaken(3)
			L.visible_message("<span class='danger'>\the [src] knocks down \the [L]!</span>")
