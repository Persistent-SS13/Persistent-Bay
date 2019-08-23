/****************************************************
				INTERNAL ORGANS DEFINES
****************************************************/
/obj/item/organ/internal
	var/dead_icon // Icon to use when the organ has died.
	var/surface_accessible = FALSE
	var/relative_size = 25   // Relative size of the organ. Roughly % of space they take in the target projection :D
	var/min_bruised_damage = 10       // Damage before considered bruised
	var/damage_reduction = 0.5     //modifier for internal organ injury

/obj/item/organ/internal/New(var/mob/living/carbon/holder)
	if(max_health)
		min_bruised_damage = Floor(max_health / 4)
	..()
	if(istype(holder))
		holder.internal_organs |= src

		var/mob/living/carbon/human/H = holder
		if(istype(H))
			var/obj/item/organ/external/E = H.get_organ(parent_organ)
			if(!E)
				CRASH("[src] spawned in [holder] without a parent organ: [parent_organ].")
			E.internal_organs |= src
			E.cavity_max_w_class = max(E.cavity_max_w_class, w_class)

/obj/item/organ/internal/after_load()
	var/mob/living/carbon/human/H = loc
	if(istype(H))
		var/obj/item/organ/external/E = H.get_organ(parent_organ)
		E.cavity_max_w_class = max(E.cavity_max_w_class, w_class)
	..()
/obj/item/organ/internal/Destroy()
	if(owner)
		owner.internal_organs.Remove(src)
		owner.internal_organs_by_name[organ_tag] = null
		owner.internal_organs_by_name -= organ_tag
		while(null in owner.internal_organs)
			owner.internal_organs -= null
		var/obj/item/organ/external/E = owner.organs_by_name[parent_organ]
		if(istype(E)) E.internal_organs -= src
	return ..()

/obj/item/organ/internal/set_dna(var/datum/dna/new_dna)
	..()
	if(species && species.organs_icon)
		icon = species.organs_icon

//disconnected the organ from it's owner but does not remove it, instead it becomes an implant that can be removed with implant surgery
//TODO move this to organ/internal once the FPB port comes through
/obj/item/organ/proc/cut_away(var/mob/living/user)
	var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
	if(istype(parent)) //TODO ensure that we don't have to check this.
		removed(user, 0)
		parent.implants += src

/obj/item/organ/internal/removed(var/mob/living/user, var/drop_organ=1, var/detach=1)
	if(owner)
		owner.internal_organs_by_name[organ_tag] = null
		owner.internal_organs_by_name -= organ_tag
		owner.internal_organs_by_name -= null
		owner.internal_organs -= src

		if(detach)
			var/obj/item/organ/external/affected = owner.get_organ(parent_organ)
			if(affected)
				affected.internal_organs -= src
				status |= ORGAN_CUT_AWAY
	..()

/obj/item/organ/internal/replaced(var/mob/living/carbon/human/target, var/obj/item/organ/external/affected)

	if(!istype(target))
		return 0

	if(status & ORGAN_CUT_AWAY)
		return 0 //organs don't work very well in the body when they aren't properly attached

	// robotic organs emulate behavior of the equivalent flesh organ of the species
	if(BP_IS_ROBOTIC(src) || !species)
		species = target.species

	..()

	STOP_PROCESSING(SSobj, src)
	target.internal_organs |= src
	affected.internal_organs |= src
	target.internal_organs_by_name[organ_tag] = src
	return 1

/obj/item/organ/internal/die()
	..()
	if((status & ORGAN_DEAD) && dead_icon)
		icon_state = dead_icon

/obj/item/organ/internal/remove_rejuv()
	if(owner)
		owner.internal_organs -= src
		owner.internal_organs_by_name[organ_tag] = null
		owner.internal_organs_by_name -= organ_tag
		while(null in owner.internal_organs)
			owner.internal_organs -= null
		var/obj/item/organ/external/E = owner.organs_by_name[parent_organ]
		if(istype(E)) E.internal_organs -= src
	..()

/obj/item/organ/internal/is_usable()
	return ..() && !is_broken()

/obj/item/organ/internal/robotize()
	..()
	min_bruised_damage += 5
	min_broken_damage += 10

/obj/item/organ/internal/proc/getToxLoss()
	if(BP_IS_ROBOTIC(src))
		return get_damages() * 0.5
	return get_damages()

/obj/item/organ/internal/proc/bruise()
	if(get_damages() < min_bruised_damage)
		rem_health(min_bruised_damage - get_damages())

/obj/item/organ/internal/proc/is_bruised()
	return get_damages() >= min_bruised_damage

/obj/item/organ/internal/proc/set_max_health(var/nhealth)
	max_health = Floor(nhealth)
	min_broken_damage = Floor(0.75 * nhealth)
	min_bruised_damage = Floor(0.25 * nhealth)

/obj/item/organ/internal/take_general_damage(var/amount, var/silent = FALSE)
	take_internal_damage(amount, silent)

/obj/item/organ/internal/proc/take_internal_damage(var/amount, var/silent = FALSE)
	if(BP_IS_ROBOTIC(src))
		rem_health(amount * 0.8)
	else
		rem_health(amount)

		//only show this if the organ is not robotic
		if(owner && can_feel_pain() && parent_organ && (amount > 5 || prob(10)))
			var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
			if(parent && !silent)
				var/degree = ""
				if(is_bruised())
					degree = " a lot"
				if(get_damages() < 5)
					degree = " a bit"
				owner.custom_pain("Something inside your [parent.name] hurts[degree].", amount, affecting = parent)

/obj/item/organ/internal/proc/get_visible_state()
	if(health <= 0)
		. = "bits and pieces of a destroyed "
	else if(is_broken())
		. = "broken "
	else if(is_bruised())
		. = "badly damaged "
	else if(get_damages() > 5)
		. = "damaged "
	if(status & ORGAN_DEAD)
		if(can_recover())
			. = "decaying [.]"
		else
			. = "necrotic [.]"
	. = "[.][name]"

/obj/item/organ/internal/Process()
	..()
	handle_regeneration()

// Organs will heal very minor damage on their own without much work
// As long as no toxins are present in the system
/obj/item/organ/internal/proc/handle_regeneration()
	if(!isdamaged() || BP_IS_ROBOTIC(src) || !owner || owner.chem_effects[CE_TOXIN] || owner.is_asystole())
		return
	if(get_damages() < min_bruised_damage) // If it's not even bruised, it will just heal very slowly.
		heal_damage(0.01)
	else if(is_bruised()) // If it is bruised, it will heal a little faster, but it will scar if it's not aided by medication or surgery
		heal_damage(0.02)

/obj/item/organ/internal/proc/surgical_fix(mob/user)
	var/damages = get_damages()
	if(damages > min_broken_damage)
		var/scarring = damages/max_health
		scarring = 1 - 0.3 * scarring ** 2 // Between ~15 and 30 percent loss
		var/new_max_dam = Floor(scarring * max_health)
		if(new_max_dam < max_health)
			to_chat(user, "<span class='warning'>Not every part of [src] could be saved, some dead tissue had to be removed, making it more suspectable to damage in the future.</span>")
			set_max_health(new_max_dam)
	heal_damage(damages)

/obj/item/organ/internal/proc/get_scarring_level()
	. = (initial(max_health) - max_health)/initial(max_health)

/obj/item/organ/internal/get_scan_results()
	. = ..()
	var/scar_level = get_scarring_level()
	if(scar_level > 0.01)
		. += "[get_wound_severity(get_scarring_level())] scarring"

/obj/item/organ/internal/emp_act(severity)
	if(!BP_IS_ROBOTIC(src))
		return
	switch (severity)
		if (1)
			take_internal_damage(9)
		if (2)
			take_internal_damage(3)
		if (3)
			take_internal_damage(1)
