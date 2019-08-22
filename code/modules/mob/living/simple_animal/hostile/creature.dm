/mob/living/simple_animal/hostile/creature
	name = "GREED" // never uncapitalize GREED
	desc = "A sanity-destroying otherthing."
	icon = 'icons/mob/critter.dmi'
	speak_emote = list("gibbers")
	icon_state = "otherthing"
	icon_living = "otherthing"
	icon_dead = "otherthing-dead"
	health = 60
	maxHealth = 60
	speed = 12
	move_to_delay = 12
	destroy_surroundings = 1

	melee_damage_lower = 20
	melee_damage_upper = 30
	attacktext = "chomped"
	attack_sound = 'sound/weapons/bite.ogg'

	faction = "asteroid"

	//Space carp aren't affected by atmos.
	min_gas = null
	max_gas = null
	minbodytemp = 0

	should_save = 0
	meat_amount = 10
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/xenomeat

/mob/living/simple_animal/hostile/creature/Found(var/atom/A)
	if(istype(A, /obj/machinery/mining/drill))
		var/obj/machinery/mining/drill/drill = A
		if(!drill.statu)
			stance = HOSTILE_STANCE_ATTACK
			return A
	if(istype(A, /obj/structure/ore_box))
		stance = HOSTILE_STANCE_ATTACK
		return A
	if(istype(A, /obj/item/stack/ore))
		stance = HOSTILE_STANCE_ATTACK
		return A


/mob/living/simple_animal/hostile/creature/Allow_Spacemove(var/check_drift = 0)
	return 1 // Ripped from space carp, no more floating


/mob/living/simple_animal/hostile/creature/New()
	..()

/mob/living/simple_animal/hostile/creature/cult
	faction = "cult"
	min_gas = null
	max_gas = null
	minbodytemp = 0

	supernatural = 1

/mob/living/simple_animal/hostile/creature/cult/cultify()
	return
