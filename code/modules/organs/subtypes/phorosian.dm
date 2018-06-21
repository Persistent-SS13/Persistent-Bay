//INTERNAL ORGANS
/obj/item/organ/internal/lungs/phorosian
	name = "phoronized lungs"
	icon_state = "lungs-plasma"
	desc = "A set of lungs seemingly made out of fleshy phoron."
	breath_type = "phoron"
	poison_type = "oxygen" //It burns to breathe!
	exhale_type = "hydrogen"

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
	name = "crystallized brain"
	desc = "A brain seemingly made out of both crystallized phoron and brain matter."
	parent_organ = BP_HEAD
	color = "#7e4ba0"

/obj/item/organ/internal/eyes/phorosian
	name = "crystallized eyeballs"
	desc = "A pair of crystal spheres in the shape of eyes. They give off a faint glow."
	phoron_guard = 1

/obj/item/organ/internal/eyes/phorosian/New()
	update_colour()



//lung stuff - makes phorosians gain blood depending on intake of phoron. Also makes their lungs burn if they breathe oxygen.

/obj/item/organ/internal/lungs/phorosian/handle_breath(datum/gas_mixture/breath, var/forced)
	if(!owner || !loc)
		return 1
	if(!breath)
		breath_fail_ratio = 1
		handle_failed_breath()
		return 1

	var/breath_pressure = breath.return_pressure()
	check_rupturing(breath_pressure)
	var/datum/gas_mixture/enviroment = loc.return_air_for_internal_lifeform()
	last_ext_pressure = enviroment.return_pressure()
	last_int_pressure = breath_pressure

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
		message_admins("no safe_pressure_min [safe_pressure_min] [owner] [owner.x] [owner.y] [owner.z]")
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

	var/inhaled_gas_used = inhaling / 4
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
			warn_prob = 10
			alert = 1
			failed_exhale = 1
			var/ratio = 1.0 - (safe_exhaled_max - exhaled_pp)/(safe_exhaled_max*0.3)
			if (owner.getOxyLoss() < 50*ratio)
				oxyloss = HUMAN_MAX_OXYLOSS
		else if(exhaled_pp > safe_exhaled_max * 0.4)
			word = pick("a little dizzy","short of breath")
			warn_prob = 10
		else
			owner.co2_alert = 0

		if(word)
			if(!owner.co2_alert)
				owner.co2_alert = alert
			if(prob(warn_prob))
				to_chat(owner, "<span class='warning'>You feel [word].</span>")

		owner.adjustOxyLoss(oxyloss)

	// Too much poison in the air.

	if(toxins_pp > safe_toxins_max)
		take_damage(0.5)
		if(prob(20))
			to_chat(owner, "<span class='warning'>Your lungs feel like they are burning!</span>")
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

		breath.adjust_gas("sleeping_agent", -breath.gas["sleeping_agent"], update = 0) //update after

	// Were we able to breathe?
	var/failed_breath = failed_inhale || failed_exhale
	if(failed_breath)
		if(isnull(last_failed_breath))
			last_failed_breath = world.time
	else
		var/blood_volume_raw = owner.vessel.get_reagent_amount(/datum/reagent/blood)
		if(blood_volume_raw < species.blood_volume)
			var/datum/reagent/blood/B = owner.get_blood(owner.vessel)
			if(istype(B))
				B.volume += 0.2 + owner.chem_effects[CE_BLOODRESTORE] // regenerate blood VERY slowly
		heal_damage(0.1)
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

/obj/item/organ/internal/lungs/phorosian/handle_failed_breath()
	if(prob(15) && !owner.nervous_system_failure())
		if(!owner.is_asystole())
			if(active_breathing)
				owner.emote("gasp")
		else
			owner.emote(pick("shiver","twitch"))

	if(damage || owner.chem_effects[CE_BREATHLOSS] || world.time > last_failed_breath + 2 MINUTES)
		owner.remove_blood(HUMAN_MAX_OXYLOSS*breath_fail_ratio)

	owner.oxygen_alert = max(owner.oxygen_alert, 2)
	last_int_pressure = 0


//EXTERNAL ORGANS
//Phoron reinforced bones woo.
/obj/item/organ/external/head/phorosian
	min_broken_damage = 50

/obj/item/organ/external/chest/phorosian
	min_broken_damage = 50

/obj/item/organ/external/groin/phorosian
	min_broken_damage = 50

/obj/item/organ/external/arm/phorosian
	min_broken_damage = 45

/obj/item/organ/external/arm/right/phorosian
	min_broken_damage = 45

/obj/item/organ/external/leg/phorosian
	min_broken_damage = 45

/obj/item/organ/external/leg/right/phorosian
	min_broken_damage = 45

/obj/item/organ/external/foot/phorosian
	min_broken_damage = 30

/obj/item/organ/external/foot/right/phorosian
	min_broken_damage = 30

/obj/item/organ/external/hand/phorosian
	min_broken_damage = 30

/obj/item/organ/external/hand/right/phorosian
	min_broken_damage = 30
