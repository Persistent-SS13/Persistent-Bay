//definitions

/obj/item/organ/internal/lungs/phorosian
	name = "phoronized lungs" 
	icon_state = "lungs-plasma"
	desc = "A set of lungs seemingly made out of fleshy phoron."
	breath_type = "phoron"
	poison_type = "oxygen" //It burns to breathe!

/obj/item/organ/internal/liver/phorosian
	name = "phoron processor"
	desc = "A fleshy hunk of phoron that looks a little like a liver."
	parent_organ = BP_CHEST
	color = "#7e4ba0"
	
/obj/item/organ/internal/heart/phorosian
	name = "phoron pump"
	parent_organ = BP_CHEST
	color = "#7e4ba0"
	
/obj/item/organ/internal/brain/phorosian
	name = "Crystallized brain"
	desc = "A brain seemingly made out of both crystallized phoron and brain matter."
	parent_organ = BP_HEAD
	color = "#7e4ba0"

/obj/item/organ/internal/eyes/phorosian
	name = "Crystallized eyeballs"
	desc = "A pair of crystal spheres in the shape of eyes. They give off a faint glow."
	phoron_guard = 1
	
/obj/item/organ/internal/eyes/phorosian/New()
	update_colour()
	
	

//lung stuff - makes phorosians gain blood depending on intake of phoron. Also makes their lungs burn if they breathe oxygen.

/obj/item/organ/internal/lungs/phorosian/handle_breath(datum/gas_mixture/breath, var/forced) //Turns out breathing the stuff everyone dislikes means you need your own breathing proc
	if(!owner)
		return 1
	if(!breath)
		breath_fail_ratio = 1
		handle_failed_breath()
		return 1

	var/breath_pressure = breath.total_moles*R_IDEAL_GAS_EQUATION*breath.temperature/BREATH_VOLUME
	//exposure to extreme pressures can rupture lungs
	if(breath_pressure < species.hazard_low_pressure || breath_pressure > species.hazard_high_pressure)
		var/datum/gas_mixture/environment = loc.return_air_for_internal_lifeform()
		var/env_pressure = environment.return_pressure()
		var/lung_rupture_prob =  robotic >= ORGAN_ROBOT ? prob(2.5) : prob(5) //Robotic lungs are less likely to rupture.
		if(env_pressure < species.hazard_low_pressure || env_pressure > species.hazard_high_pressure)
			if(!is_bruised() && lung_rupture_prob) //only rupture if NOT already ruptured
				rupture()
	if(breath.total_moles == 0)
		breath_fail_ratio = 1
		handle_failed_breath()
		return 1

	var/safe_pressure_min = min_breath_pressure // Minimum safe partial pressure of breathable gas in kPa
	// Lung damage increases the minimum safe pressure.
	safe_pressure_min *= 1 + rand(1,4) * damage/max_damage

	if(!forced && owner.chem_effects[CE_BREATHLOSS] && !owner.chem_effects[CE_STABLE]) //opiates are bad mmkay
		safe_pressure_min *= 1 + rand(1,4) * owner.chem_effects[CE_BREATHLOSS]

	var/failed_inhale = 0
	var/failed_exhale = 0

	var/inhaling = breath.gas[breath_type]
	var/poison = breath.gas[poison_type]
	var/exhaling = exhale_type ? breath.gas[exhale_type] : 0

	var/inhale_pp = (inhaling/breath.total_moles)*breath_pressure
	var/toxins_pp = (poison/breath.total_moles)*breath_pressure
	var/exhaled_pp = (exhaling/breath.total_moles)*breath_pressure

	var/inhale_efficiency
	if(safe_pressure_min)
		inhale_efficiency = min(round(inhale_pp/safe_pressure_min, 0.001), 3)
	else
		inhale_efficiency = 3
	// Not enough to breathe
	if(inhale_efficiency < 1)
		if(prob(20) && active_breathing)
			owner.emote("gasp")

		breath_fail_ratio = 1 - inhale_efficiency
		failed_inhale = 1
	else
		breath_fail_ratio = 0

	owner.oxygen_alert = failed_inhale * 2

	var/inhaled_gas_used = inhaling/6
	breath.adjust_gas(breath_type, -inhaled_gas_used, update = 0) //update afterwards

	if(exhale_type)
		breath.adjust_gas_temp(exhale_type, inhaled_gas_used, owner.bodytemperature, update = 0) //update afterwards
		// Too much exhaled gas in the air
		var/word
		var/warn_prob
		var/oxyloss
		var/alert

		if(exhaled_pp > safe_exhaled_max)
			word = pick("extremely dizzy","short of breath","faint","confused")
			warn_prob = 15
			oxyloss = HUMAN_MAX_OXYLOSS
			alert = 1
			failed_exhale = 1
		else if(exhaled_pp > safe_exhaled_max * 0.7)
			word = pick("dizzy","short of breath","faint","momentarily confused")
			warn_prob = 1
			alert = 1
			failed_exhale = 1
			var/ratio = 1.0 - (safe_exhaled_max - exhaled_pp)/(safe_exhaled_max*0.3)
			if (owner.getOxyLoss() < 50*ratio)
				oxyloss = HUMAN_MAX_OXYLOSS
		else if(exhaled_pp > safe_exhaled_max * 0.6)
			word = pick("a little dizzy","short of breath")
			warn_prob = 1
		else
			owner.co2_alert = 0

		if(!owner.co2_alert && word && prob(warn_prob))
			to_chat(owner, "<span class='warning'>You feel [word].</span>")
			owner.adjustOxyLoss(oxyloss)
			owner.co2_alert = alert

	// Too much poison in the air.
	if(toxins_pp > safe_toxins_max)
		take_damage(1)
		to_chat(owner, "<span class='warning'>Your lungs feel like they're burning!</span>")
		breath.adjust_gas(poison_type, -poison/6, update = 0) //update after
		owner.phoron_alert = 1
	else
		owner.phoron_alert = 0

	// If there's some other shit in the air lets deal with it here.
	if(breath.gas["sleeping_agent"])
		var/SA_pp = (breath.gas["sleeping_agent"] / breath.total_moles) * breath_pressure
		if(SA_pp > SA_para_min)		// Enough to make us paralysed for a bit
			owner.Paralyse(3)	// 3 gives them one second to wake up and run away a bit!
			if(SA_pp > SA_sleep_min)	// Enough to make us sleep as well
				owner.Sleeping(5)
		else if(SA_pp > 0.15)	// There is sleeping gas in their lungs, but only a little, so give them a bit of a warning
			if(prob(20))
				owner.emote(pick("giggle", "laugh"))

		breath.adjust_gas("sleeping_agent", -breath.gas["sleeping_agent"]/6, update = 0) //update after

	// Were we able to breathe?
	var/failed_breath = failed_inhale || failed_exhale
	if(failed_breath)
		if(isnull(last_failed_breath))
			last_failed_breath = world.time
	else
		last_failed_breath = null
		owner.adjustOxyLoss(-5 * inhale_efficiency)
		if(robotic < ORGAN_ROBOT && species.breathing_sound && is_below_sound_pressure(get_turf(owner)))
			if(breathing || owner.shock_stage >= 10)
				sound_to(owner, sound(species.breathing_sound,0,0,0,5))
				breathing = 0
			else
				breathing = 1

	handle_temperature_effects(breath)
	breath.update_values()

	if(failed_breath)
		handle_failed_breath()
	else
		owner.oxygen_alert = 0
	return failed_breath
	
	
	//blood regen from phoron
	if (inhale_pp>16 && inhale_pp<=100)
		owner.add_chemical_effect(CE_BLOODRESTORE, inhale_pp-16/10)
	else if (inhale_pp>100)
		owner.add_chemical_effect(CE_BLOODRESTORE, 8.4)
		
/obj/item/organ/internal/lungs/phorosian/handle_failed_breath() //It's not the lack of air killing them, it's the lack of blood.
	if(prob(15) && !owner.nervous_system_failure())
		if(!owner.is_asystole())
			if(active_breathing)
				owner.emote("gasp")
		else
			owner.emote(pick("shiver","twitch"))
		owner.remove_blood(HUMAN_MAX_OXYLOSS*breath_fail_ratio)
	
//Brain stuff - Only difference is that you don't paralyse at low blood to stop you from dropping your tank, 'cause that would suck.
/obj/item/organ/internal/brain/phorosian/Process()

	if(owner)
		if(damage > max_damage / 2 && healed_threshold)
			spawn()
				alert(owner, "You have taken massive brain damage! You will not be able to remember the events leading up to your injury.", "Brain Damaged")
			healed_threshold = 0

		if(damage < (max_damage / 4))
			healed_threshold = 1

		if(owner.paralysis < 1) // Skip it if we're already down.

			if((owner.disabilities & EPILEPSY) && prob(1))
				to_chat(owner, "<span class='warning'>You have a seizure!</span>")
				owner.visible_message("<span class='danger'>\The [owner] starts having a seizure!</span>")
				owner.Paralyse(10)
				owner.make_jittery(1000)
			else if((owner.disabilities & TOURETTES) && prob(10))
				owner.Stun(10)
				switch(rand(1, 3))
					if(1)
						owner.emote("twitch")
					if(2 to 3)
						owner.say("[prob(50) ? ";" : ""][pick("SHIT", "PISS", "FUCK", "CUNT", "COCKSUCKER", "MOTHERFUCKER", "TITS")]")
				owner.make_jittery(100)
			else if((owner.disabilities & NERVOUS) && prob(10))
				owner.stuttering = max(10, owner.stuttering)

			if(owner.stat == CONSCIOUS)
				if(damage > 0 && prob(1))
					owner.custom_pain("Your head feels numb and painful.",10)
				if(is_bruised() && prob(1) && owner.eye_blurry <= 0)
					to_chat(owner, "<span class='warning'>It becomes hard to see for some reason.</span>")
					owner.eye_blurry = 10
				if(is_broken() && prob(1) && owner.get_active_hand())
					to_chat(owner, "<span class='danger'>Your hand won't respond properly, and you drop what you are holding!</span>")
					owner.drop_item()
				if((damage >= (max_damage * 0.75)))
					if(!owner.lying)
						to_chat(owner, "<span class='danger'>You black out!</span>")
					owner.Paralyse(10)

		// Brain damage from low oxygenation or lack of blood.
		if(owner.should_have_organ(BP_HEART))

			// No heart? You are going to have a very bad time. Not 100% lethal because heart transplants should be a thing.
			var/blood_volume = owner.get_blood_oxygenation()

			if(owner.is_asystole()) // Heart is missing or isn't beating and we're not breathing (hardcrit)
				owner.Paralyse(3)
			var/can_heal = damage && damage < max_damage && (damage % damage_threshold_value || owner.chem_effects[CE_BRAIN_REGEN] || (!past_damage_threshold(3) && owner.chem_effects[CE_STABLE]))
			var/damprob
			//Effects of bloodloss
			switch(blood_volume)

				if(BLOOD_VOLUME_SAFE to INFINITY)
					if(can_heal)
						damage--
				if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
					if(prob(1))
						to_chat(owner, "<span class='warning'>You feel [pick("dizzy","woozy","faint")]...</span>")
					damprob = owner.chem_effects[CE_STABLE] ? 30 : 60
					if(!past_damage_threshold(2) && prob(damprob))
						take_damage(1)
				if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
					owner.eye_blurry = max(owner.eye_blurry,6)
					damprob = owner.chem_effects[CE_STABLE] ? 40 : 80
					if(!past_damage_threshold(4) && prob(damprob))
						take_damage(1)
						to_chat(owner, "<span class='warning'>You feel extremely [pick("dizzy","woozy","faint")]...</span>")
				if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
					owner.eye_blurry = max(owner.eye_blurry,6)
					damprob = owner.chem_effects[CE_STABLE] ? 60 : 100
					if(!past_damage_threshold(6) && prob(damprob))
						take_damage(1)
						to_chat(owner, "<span class='warning'>You feel extremely [pick("dizzy","woozy","faint")]...</span>")
				if(-(INFINITY) to BLOOD_VOLUME_SURVIVE) // Also see heart.dm, being below this point puts you into cardiac arrest.
					owner.eye_blurry = max(owner.eye_blurry,6)
					damprob = owner.chem_effects[CE_STABLE] ? 80 : 100
					if(prob(damprob))
						take_damage(1)
	..()
	
//Phoron reinforced bones woo.
/obj/item/organ/external/head/phorosian
	min_broken_damage = 45	

/obj/item/organ/external/chest/phorosian
	min_broken_damage = 45

/obj/item/organ/external/groin/phorosian
	min_broken_damage = 45

/obj/item/organ/external/arm/phorosian
	min_broken_damage = 40

/obj/item/organ/external/arm/right/phorosian
	min_broken_damage = 40

/obj/item/organ/external/leg/phorosian
	min_broken_damage = 40

/obj/item/organ/external/leg/right/phorosian
	min_broken_damage = 40

/obj/item/organ/external/foot/phorosian
	min_broken_damage = 25

/obj/item/organ/external/foot/right/phorosian
	min_broken_damage = 25

/obj/item/organ/external/hand/phorosian
	min_broken_damage = 25

/obj/item/organ/external/hand/right/phorosian
	min_broken_damage = 25
	