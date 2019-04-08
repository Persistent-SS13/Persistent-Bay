
/*
	apply_damage() args
	damage - How much damage to take
	damage_type - What type of damage to take, brute, burn
	def_zone - Where to take the damage if its brute or burn

	Returns
	standard 0 if fail
*/
/mob/living/proc/apply_damage(var/damage = 0,var/damagetype = BRUTE, var/def_zone = null, var/damage_flags = 0, var/used_weapon = null, var/armor_pen, var/silent = FALSE)
	if(!damage)
		return 0

	var/list/after_armor = modify_damage_by_armor(def_zone, damage, damagetype, damage_flags, src, armor_pen, silent)
	damage = after_armor[1]
	damagetype = after_armor[2]
	damage_flags = after_armor[3] // args modifications in case of parent calls
	if(!damage)
		return 0
	log_debug("[src] took [damage] [damagetype] damage from the [used_weapon]. [blocked] was blocked")

	if(IsDamageTypeBrute(damagetype))
		adjustBruteLoss(damage * blocked_mult(blocked))
	else if(IsDamageTypeBurn(damagetype))
		if(MUTATION_COLD_RESISTANCE in mutations)
			damage = 0
		adjustFireLoss(damage * blocked_mult(blocked))
	else if(ISDAMTYPE(damagetype, DAM_BIO))
		adjustToxLoss(damage * blocked_mult(blocked))
	else if(ISDAMTYPE(damagetype, DAM_OXY))
		adjustOxyLoss(damage * blocked_mult(blocked))
	else if(ISDAMTYPE(damagetype, DAM_CLONE))
		adjustCloneLoss(damage * blocked_mult(blocked))
	else if(ISDAMTYPE(damagetype, DAM_PAIN))
		adjustHalLoss(damage * blocked_mult(blocked))
	else if(ISDAMTYPE(damagetype, DAM_ELECTRIC))
		electrocute_act(damage, used_weapon, 1.0, def_zone)
	else  if(ISDAMTYPE(damagetype, IRRADIATE))
		radiation += damage

	updatehealth()
	return 1


/mob/living/proc/apply_damages(var/brute = 0, var/burn = 0, var/tox = 0, var/oxy = 0, var/clone = 0, var/halloss = 0, var/def_zone = null, var/damage_flags = 0)
	if(brute)	apply_damage(brute, DAM_BLUNT, def_zone)
	if(burn)	apply_damage(burn, DAM_BURN, def_zone)
	if(tox)		apply_damage(tox, DAM_BIO, def_zone)
	if(oxy)		apply_damage(oxy, DAM_OXY, def_zone)
	if(clone)	apply_damage(clone, DAM_CLONE, def_zone)
	if(halloss) apply_damage(halloss, DAM_PAIN, def_zone)
	return 1


/mob/living/proc/apply_effect(var/effect = 0,var/effecttype = STUN, var/blocked = 0)
	if(!effect || (blocked >= 100))	return 0

	switch(effecttype)
		if(STUN)
			Stun(effect * blocked_mult(blocked))
		if(WEAKEN)
			Weaken(effect * blocked_mult(blocked))
		if(PARALYZE)
			Paralyse(effect * blocked_mult(blocked))
		if(PAIN)
			adjustHalLoss(effect * blocked_mult(blocked))
		if(IRRADIATE)
			radiation += effect * blocked_mult(blocked)
		if(STUTTER)
			if(status_flags & CANSTUN) // stun is usually associated with stutter - TODO CANSTUTTER flag?
				stuttering = max(stuttering, effect * blocked_mult(blocked))
		if(EYE_BLUR)
			eye_blurry = max(eye_blurry, effect * blocked_mult(blocked))
		if(DROWSY)
			drowsyness = max(drowsyness, effect * blocked_mult(blocked))
	updatehealth()
	return 1


/mob/living/proc/apply_effects(var/stun = 0, var/weaken = 0, var/paralyze = 0, var/irradiate = 0, var/stutter = 0, var/eyeblur = 0, var/drowsy = 0, var/agony = 0, var/blocked = 0)
	if(blocked >= 2)	return 0
	if(stun)		apply_effect(stun,      STUN, blocked)
	if(weaken)		apply_effect(weaken,    WEAKEN, blocked)
	if(paralyze)	apply_effect(paralyze,  PARALYZE, blocked)
	if(irradiate)	apply_effect(irradiate, IRRADIATE, blocked)
	if(stutter)		apply_effect(stutter,   STUTTER, blocked)
	if(eyeblur)		apply_effect(eyeblur,   EYE_BLUR, blocked)
	if(drowsy)		apply_effect(drowsy,    DROWSY, blocked)
	if(agony)		apply_effect(agony,     PAIN, blocked)
	return 1

//Handles all armor damage type conversion effects at the same place
/mob/living/proc/HandleArmorDamTypeConversion(var/dtype, var/armor as num)
	. = dtype
	if(prob(armor))
		//Armor eats dangerous damages and turn them to blunt and burn
		if(ISDAMTYPE(dtype,DAM_CUT) || ISDAMTYPE(dtype,DAM_PIERCE))
			. = DAM_BLUNT
		else if(ISDAMTYPE(dtype,DAM_LASER) ||  ISDAMTYPE(dtype,DAM_ENERGY))
			. = DAM_BURN
	return .
