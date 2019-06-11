/*VOX SLUG
Small, little HP, poisonous.
*/

/mob/living/simple_animal/hostile/voxslug
	name = "glutslug"
	desc = "A viscious little creature, its teeth are razor sharp."
	icon_state = "voxslug"
	icon_living = "voxslug"
	item_state = "voxslug"
	icon_dead = "voxslug_dead"
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stamps on"
	destroy_surroundings = 1
	health = 20
	maxHealth = 20
	speed = 10 // May return back to 3, we'll see if 2 is enough.
	move_to_delay = 10
	density = 0
	min_gas = null
	max_gas = null
	mob_size = MOB_MINISCULE
	can_escape = 1
	pass_flags = PASS_FLAG_TABLE
	melee_damage_lower = 3
	melee_damage_upper = 6
	holder_type = /obj/item/weapon/holder/voxslug
	faction = "asteroid"
	attack_sound = 'sound/weapons/bite.ogg'
	attacktext = "bitten"
	minbodytemp = 0
	should_save = 0

/mob/living/simple_animal/hostile/voxslug/ListTargets(var/dist = 7)
	var/list/L = list()
	for(var/a in hearers(src, dist))
		if(istype(a,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = a
			if(H.species.get_bodytype() == SPECIES_VOX)
				continue
		if(isliving(a))
			var/mob/living/M = a
			if(M.faction == faction)
				continue
		L += a

	for (var/obj/mecha/M in mechas_list)
		if (M.z == src.z && get_dist(src, M) <= dist)
			L += M

	return L

/mob/living/simple_animal/hostile/voxslug/Move()
	. = ..()
	if(.)
		pixel_x = rand(-10,10)
		pixel_y = rand(-10,10)

/mob/living/simple_animal/hostile/voxslug/Found(var/atom/A)
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

/mob/living/simple_animal/hostile/voxslug/Allow_Spacemove(var/check_drift = 0)
	return 1 // Ripped from space carp, no more floating

/mob/living/simple_animal/hostile/voxslug/get_scooped(var/mob/living/carbon/grabber)
	if(grabber.species.get_bodytype() != SPECIES_VOX)
		to_chat(grabber, "<span class='warning'>\The [src] wriggles out of your hands before you can pick it up!</span>")
		return
	else return ..()

/mob/living/simple_animal/hostile/voxslug/proc/attach(var/mob/living/carbon/human/H)
	var/obj/item/clothing/suit/space/S = H.get_covering_equipped_item_by_zone(BP_CHEST)
	if(istype(S) && !length(S.breaches))
		S.create_breaches(DAM_PIERCE, 20)
		if(!length(S.breaches)) //unable to make a hole
			return
	var/obj/item/organ/external/chest = H.organs_by_name[BP_CHEST]
	var/obj/item/weapon/holder/voxslug/holder = new(get_turf(src))
	src.forceMove(holder)
	chest.embed(holder,0,"\The [src] latches itself onto \the [H]!")
	H.phoronation += 3
	holder.sync(src)

/mob/living/simple_animal/hostile/voxslug/AttackingTarget()
	. = ..()
	if(istype(., /mob/living/carbon/human))
		var/mob/living/carbon/human/H = .
		if(H.getBruteLoss() > 30 && prob(H.getBruteLoss()/4))
			attach(H)

/mob/living/simple_animal/hostile/voxslug/Life()
	. = ..()
	if(. && istype(src.loc, /obj/item/weapon/holder) && isliving(src.loc.loc)) //We in somebody
		var/mob/living/L = src.loc.loc
		if(src.loc in L.get_visible_implants(0))
			if(prob(1))
				to_chat(L, "<span class='warning'>You feel strange as \the [src] pulses...</span>")
			var/datum/reagents/R = L.reagents
			R.add_reagent(/datum/reagent/cryptobiolin, 0.1)

/obj/item/weapon/holder/voxslug/attack(var/mob/target, var/mob/user)
	var/mob/living/simple_animal/hostile/voxslug/V = contents[1]
	if(!V.stat && istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		if(!do_mob(user, H, 30))
			return
		user.drop_from_inventory(src)
		V.attach(H)
		qdel(src)
		return
	..()
