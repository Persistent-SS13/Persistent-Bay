/mob/living/simple_animal/hostile/creature
	name = "greed"
	desc = "You cant bear the sight of her."
	icon = 'icons/mob/critter.dmi'
	speak_emote = list("gibbers")
	icon_state = "otherthing"
	icon_living = "otherthing"
	icon_dead = "otherthing-dead"
	health = 30
	maxHealth = 30
	speed = 8
	destroy_surroundings = 1

	melee_damage_lower = 25
	melee_damage_upper = 50
	attacktext = "chomped"
	attack_sound = 'sound/weapons/bite.ogg'

	faction = "asteroid"

	//Space carp aren't affected by atmos.
	min_gas = null
	max_gas = null
	minbodytemp = 0

/mob/living/simple_animal/hostile/creature/cult

	faction = "cult"

	min_gas = null
	max_gas = null
	minbodytemp = 0

	supernatural = 1

/mob/living/simple_animal/hostile/creature/cult/cultify()
	return
