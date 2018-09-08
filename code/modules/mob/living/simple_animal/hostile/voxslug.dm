/*VOX SLUG
Small, little HP, poisonous.
*/

/mob/living/simple_animal/hostile/voxslug
	name = "glutslug"
	desc = "A viscious little creature, it has a mouth of razors and a it writhes like mad it can sense blood."
	icon_state = "voxslug"
	icon_living = "voxslug"
	item_state = "voxslug"
	icon_dead = "voxslug_dead"
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stamps on"
	destroy_surroundings = 0
	health = 6
	maxHealth = 6
	speed = 2 // May return back to 3, we'll see if 2 is enough.
	move_to_delay = 0
	density = 0
	mob_size = MOB_MINISCULE
	pass_flags = PASSTABLE
	holder_type = /obj/item/weapon/holder/voxslug

	melee_damage_lower = 3
	melee_damage_upper = 7
	attacktext = "bitten"
	attack_sound = 'sound/weapons/bite.ogg'

	min_gas = null // Immune to space
	max_gas = null
	minbodytemp = 0

	faction = "asteroid"

/mob/living/simple_animal/hostile/voxslug/Move()
	. = ..()
	if(.)
		pixel_x = rand(-10,10)
		pixel_y = rand(-10,10)
/mob/living/simple_animal/hostile/voxslug/ListTargets(var/dist = 7)
	var/list/L = list()
	for(var/a in hearers(src, dist))
	//	if(istype(a,/mob/living/carbon/human))
		//	var/mob/living/carbon/human/H = a
		//	if(H.species.get_bodytype() == SPECIES_VOX)
		//		continue
		if(isliving(a))
			var/mob/living/M = a
			if(M.faction == faction)
				continue
		L += a

	for (var/obj/mecha/M in mechas_list)
		if (M.z == src.z && get_dist(src, M) <= dist)
			L += M

	return L

/mob/living/simple_animal/hostile/voxslug/Allow_Spacemove(var/check_drift = 0)
	return 1 // Ripped from space carp, no more floating

/mob/living/simple_animal/hostile/voxslug/get_scooped(var/mob/living/carbon/grabber)
//	if(grabber.species.get_bodytype() != SPECIES_VOX)
	to_chat(grabber, "<span class='warning'>\The [src] wriggles out of your hands before you can pick it up!</span>")
	return
//	else return ..()

/mob/living/simple_animal/hostile/voxslug/proc/attach(var/mob/living/carbon/human/H)
	var/obj/item/organ/external/chest = H.organs_by_name["chest"]
	var/obj/item/weapon/holder/voxslug/holder = new(get_turf(src))
	src.forceMove(holder)
	chest.embed(holder,0,"\The [src] latches itself onto \the [H]!")
	H.phoronation += 3
	holder.sync(src)

/mob/living/simple_animal/hostile/voxslug/AttackingTarget()
	. = ..()
	if(istype(., /mob/living/carbon/human))
		var/mob/living/carbon/human/H = .
		if(prob(H.getBruteLoss()/4))
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