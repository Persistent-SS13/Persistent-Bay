/****************************************************
			   DAMAGE PROCS
****************************************************/

/obj/item/organ/external/proc/is_damageable(var/additional_damage = 0)
	//Continued damage to vital organs can kill you, and robot organs don't count towards total damage so no need to cap them.
	return ((robotic >= ORGAN_ROBOT) || brute_dam + burn_dam + additional_damage < max_health * 4)

/obj/item/organ/external/proc/calc_spillover(var/brute, var/burn)
	if(!is_damageable(brute + burn))
		var/spillover =  brute_dam + burn_dam + brute - max_health
		if(spillover > 0)
			brute = max(brute - spillover, 0)
		else
			spillover = brute_dam + burn_dam + brute + burn - max_health
			if(spillover > 0)
				burn = max(burn - spillover, 0)
		return spillover

/obj/item/organ/external/proc/handle_wounds(var/damage, var/damtype)
	if(!damage || (!IsDamageTypeBrute(damtype) && !IsDamageTypeBurn(damtype)) )
		return null //no wounds from those

	// If the limbs can break, make sure we don't exceed the maximum damage a limb can take before breaking
	var/should_cut = ISDAMTYPE(damtype, DAM_CUT) || (ISDAMTYPE(damtype, DAM_BLUNT) && damage > 15 && !(species.species_flags & SPECIES_FLAG_NO_MINOR_CUT)) //Some blunt weapons can break skin
	var/to_create = BRUISE

	//Translate change to the corresponding damage types.
	to_create = should_cut? CUT : DamageTypeToOrganEffect(damtype)

	if(to_create == LASER && prob(40))
		owner.IgniteMob()
	. = createwound(to_create, damage)
	return .

/obj/item/organ/external/take_damage(damage = 0 as num, damtype = DAM_BLUNT, armorbypass = 0 as num, list/damlist = null, damflags = 0 as num, damsrc = null)
	var/brute = 0
	var/burn = 0
	var/sharp = FALSE
	var/laser = FALSE
	var/dismemeber = 0
	var/blunt = 0
	var/can_cut = 0
	var/pure_brute = 0
	var/wound_damtype = null //Wounds don't seem to handle both burn and brute at the same time for some reasons..So we gotta override it.

	if(damlist)
		for(var/key in damlist)
			if(IsDamageTypeBrute(key))
				brute += round(damlist[key]* brute_mod, 0.1)
				sharp |= ISDAMTYPE(key, DAM_CUT) || ISDAMTYPE(key, DAM_PIERCE)
				dismemeber  |= sharp && damage >= DT_EDGE_DMG_THRESHOLD
				can_cut |= (prob(brute*2) || sharp) && (robotic < ORGAN_ROBOT)
				if(!wound_damtype)
					wound_damtype = key
			else if(IsDamageTypeBurn(key))
				burn += round(burn * burn_mod, 0.1)
				laser |= ISDAMTYPE(key, DAM_LASER)
				if(!wound_damtype)
					wound_damtype = key
		pure_brute = brute

	else if(damage && damtype)
		brute = (IsDamageTypeBrute(damtype))? damage : 0
		burn  = (IsDamageTypeBurn(damtype))?  damage : 0
		sharp = ISDAMTYPE(damtype, DAM_CUT) || ISDAMTYPE(damtype, DAM_PIERCE)
		dismemeber  = sharp && damage >= DT_EDGE_DMG_THRESHOLD
		laser = ISDAMTYPE(damtype, DAM_LASER)
		blunt = ISDAMTYPE(damtype, DAM_BLUNT) || (!dismemeber && !sharp)
		can_cut = (prob(brute*2) || sharp) && (robotic < ORGAN_ROBOT)
		pure_brute = brute
		wound_damtype = damtype
	else
		return 0

	if((brute <= 0) && (burn <= 0))
		return 0

	if(damsrc)
		add_autopsy_data("[damsrc]", brute + burn)
	var/spillover = calc_spillover(brute, burn)

	//If limb took enough damage, try to cut or tear it off
	if(owner && loc == owner)
		owner.updatehealth() //droplimb will call updatehealth() again if it does end up being called
		if(!is_stump() && (limb_flags & ORGAN_FLAG_CAN_AMPUTATE) && config.limbs_can_break)
			var/total_damage = brute_dam + burn_dam + brute + burn + spillover
			var/threshold = max_health * config.organ_health_multiplier
			if(total_damage > threshold)
				if(attempt_dismemberment(pure_brute, burn, dismemeber, damsrc, spillover, total_damage > threshold*6))
					return

	// High brute damage or sharp objects may damage internal organs
	if(internal_organs && internal_organs.len)
		var/damage_amt = brute
		var/cur_damage = brute_dam
		if(laser)
			damage_amt += burn
			cur_damage += burn_dam
		var/organ_damage_threshold = 10
		if(sharp)
			organ_damage_threshold *= 0.5
		var/organ_damage_prob = 5 * damage_amt/organ_damage_threshold //more damage, higher chance to damage
		if(encased && !(status & ORGAN_BROKEN)) //ribs protect
			organ_damage_prob *= 0.5
		if ((cur_damage + damage_amt >= max_health || damage_amt >= organ_damage_threshold) && prob(organ_damage_prob))
			// Damage an internal organ
			var/list/victims = list()
			for(var/obj/item/organ/internal/I in internal_organs)
				if(I.get_health() > 0 && prob(I.relative_size))
					victims += I
			if(!victims.len)
				victims += pick(internal_organs)
			for(var/obj/item/organ/victim in victims)
				brute /= 2
				if(laser)
					burn /= 2
				damage_amt /= 2
				victim.take_damage(damage_amt)

	//Handle pain
	if(status & ORGAN_BROKEN && brute)
		jostle_bone(brute)
		if(can_feel_pain() && prob(40))
			owner.emote("scream")	//getting hit on broken hand hurts
	add_pain(0.6*burn + 0.4*brute)

	//Fractures
	if(brute_dam > min_broken_damage && prob(brute_dam + brute * (1+blunt)) ) //blunt damage is gud at fracturing
		fracture()

	//Wounds
	var/datum/wound/created_wound = handle_wounds(brute + burn, wound_damtype)

	//If there are still hurties to dispense
	if (spillover)
		owner.shock_stage += spillover * config.organ_damage_spillover_multiplier

	// sync the organ's damage with its wounds
	src.update_damages()
	owner.updatehealth()

	if(owner && update_damstate())
		owner.UpdateDamageIcon()

	return created_wound

/obj/item/organ/external/heal_damage(brute, burn, internal = 0, robo_repair = 0)
	if(robotic >= ORGAN_ROBOT && !robo_repair)
		return

	//Heal damage on the individual wounds
	for(var/datum/wound/W in wounds)
		if(brute == 0 && burn == 0)
			break

		// heal brute damage
		if(W.damage_type == BURN)
			burn = W.heal_damage(burn)
		else
			brute = W.heal_damage(brute)

	if(internal)
		status &= ~ORGAN_BROKEN

	//Sync the organ's damage with its wounds
	src.update_damages()
	owner.updatehealth()

	return update_damstate()

// Brute/burn
/obj/item/organ/external/proc/get_brute_damage()
	return brute_dam

/obj/item/organ/external/proc/get_burn_damage()
	return burn_dam

// Geneloss/cloneloss.
/obj/item/organ/external/proc/get_genetic_damage()
	return ((species && (species.species_flags & SPECIES_FLAG_NO_SCAN)) || robotic >= ORGAN_ROBOT) ? 0 : genetic_degradation

/obj/item/organ/external/proc/remove_genetic_damage(var/amount)
	if((species.species_flags & SPECIES_FLAG_NO_SCAN) || robotic >= ORGAN_ROBOT)
		genetic_degradation = 0
		status &= ~ORGAN_MUTATED
		return
	var/last_gene_dam = genetic_degradation
	genetic_degradation = min(100,max(0,genetic_degradation - amount))
	if(genetic_degradation <= 30)
		if(status & ORGAN_MUTATED)
			unmutate()
			to_chat(src, "<span class = 'notice'>Your [name] is shaped normally again.</span>")
	return -(genetic_degradation - last_gene_dam)

/obj/item/organ/external/proc/add_genetic_damage(var/amount)
	if((species.species_flags & SPECIES_FLAG_NO_SCAN) || robotic >= ORGAN_ROBOT)
		genetic_degradation = 0
		status &= ~ORGAN_MUTATED
		return
	var/last_gene_dam = genetic_degradation
	genetic_degradation = min(100,max(0,genetic_degradation + amount))
	if(genetic_degradation > 30)
		if(!(status & ORGAN_MUTATED) && prob(genetic_degradation))
			mutate()
			to_chat(owner, "<span class = 'notice'>Something is not right with your [name]...</span>")
	return (genetic_degradation - last_gene_dam)

/obj/item/organ/external/proc/mutate()
	if(src.robotic >= ORGAN_ROBOT)
		return
	src.status |= ORGAN_MUTATED
	if(owner) owner.update_body()

/obj/item/organ/external/proc/unmutate()
	src.status &= ~ORGAN_MUTATED
	if(owner) owner.update_body()

// Pain/halloss
/obj/item/organ/external/proc/get_pain()
	if(!can_feel_pain() || robotic >= ORGAN_ROBOT)
		return 0
	var/lasting_pain = 0
	if(is_broken())
		lasting_pain += 10
	else if(is_dislocated())
		lasting_pain += 5
	var/tox_dam = 0
	for(var/obj/item/organ/internal/I in internal_organs)
		tox_dam += I.getToxLoss()
	return pain + lasting_pain + 0.7 * brute_dam + 0.8 * burn_dam + 0.3 * tox_dam + 0.5 * get_genetic_damage()

/obj/item/organ/external/proc/remove_pain(var/amount)
	if(!can_feel_pain() || robotic >= ORGAN_ROBOT)
		pain = 0
		return
	var/last_pain = pain
	pain = max(0,min(max_health,pain-amount))
	return -(pain-last_pain)

/obj/item/organ/external/proc/add_pain(var/amount)
	if(!can_feel_pain() || robotic >= ORGAN_ROBOT)
		pain = 0
		return
	var/last_pain = pain
	pain = max(0,min(max_health,pain+amount))
	if(owner && ((amount > 15 && prob(20)) || (amount > 30 && prob(60))))
		owner.emote("scream")
	return pain-last_pain

/obj/item/organ/external/proc/stun_act(var/stun_amount, var/agony_amount)
	return

/obj/item/organ/external/proc/get_agony_multiplier()
	return 1

/obj/item/organ/external/proc/sever_artery()
	if(species && species.has_organ[BP_HEART])
		var/obj/item/organ/internal/heart/O = species.has_organ[BP_HEART]
		if(robotic < ORGAN_ROBOT && !(status & ORGAN_ARTERY_CUT) && !initial(O.open))
			status |= ORGAN_ARTERY_CUT
			return TRUE
	return FALSE

/obj/item/organ/external/proc/sever_tendon()
	if(has_tendon() && robotic < ORGAN_ROBOT && !(status & ORGAN_TENDON_CUT))
		status |= ORGAN_TENDON_CUT
		return TRUE
	return FALSE

//organs can come off in three cases
//1. If the damage source is edge_eligible and the brute damage dealt exceeds the edge threshold, then the organ is cut off.
//2. If the damage amount dealt exceeds the disintegrate threshold, the organ is completely obliterated.
//3. If the organ has already reached or would be put over it's max damage amount (currently redundant),
//   and the brute damage dealt exceeds the tearoff threshold, the organ is torn off.
/obj/item/organ/external/proc/attempt_dismemberment(brute, burn, edge, used_weapon, spillover, force_droplimb)
	//Check edge eligibility
	var/edge_eligible = 0
	if(edge)
		if(istype(used_weapon,/obj/item))
			var/obj/item/W = used_weapon
			if(W.w_class >= w_class)
				edge_eligible = 1
		else
			edge_eligible = 1

	if(force_droplimb)
		if(burn)
			droplimb(0, DROPLIMB_BURN)
		else if(brute)
			droplimb(0, edge_eligible ? DROPLIMB_EDGE : DROPLIMB_BLUNT)
		return TRUE

	if(edge_eligible && brute >= max_health / DROPLIMB_THRESHOLD_EDGE)
		if(prob(brute))
			droplimb(0, DROPLIMB_EDGE)
			return TRUE
	else if(burn >= max_health / DROPLIMB_THRESHOLD_DESTROY)
		if(prob(burn/3))
			droplimb(0, DROPLIMB_BURN)
			return TRUE
	else if(brute >= max_health / DROPLIMB_THRESHOLD_DESTROY)
		if(prob(brute))
			droplimb(0, DROPLIMB_BLUNT)
			return TRUE
	else if(brute >= max_health / DROPLIMB_THRESHOLD_TEAROFF)
		if(prob(brute/3))
			droplimb(0, DROPLIMB_EDGE)
			return TRUE