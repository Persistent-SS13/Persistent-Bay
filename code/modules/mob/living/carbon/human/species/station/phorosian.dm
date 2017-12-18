/datum/species/phorosian
	name = SPECIES_PHOROSIAN
	name_plural = "Phorosians"
	icobase = 'icons/mob/human_races/r_phorosian_sb.dmi'
	deform = 'icons/mob/human_races/r_phorosian_pb.dmi'  // TODO: Need deform.
	rarity_value = 5
	blurb = "Todo"

	meat_type = /obj/item/stack/sheet/mineral/phoron
	taste_sensitivity = TASTE_DULL //Question is how could they taste anything in the first place?
	virus_immune = 1 // Their cells don't exactly work like normal humanoids.
	has_floating_eyes = 1 
	hunger_factor = 0  
	breath_type = "phoron"
	poison_type = null //nothing really poisons them, but without phoron their body shuts down.
	siemens_coefficient = 0.7
	flags = NO_SCAN | NO_BLOOD | NO_POISON | NO_PAIN  
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED
	appearance_flags = HAS_EYE_COLOR
	brute_mod =     0.7 //Phoron has made them resistant to damage
	burn_mod =      1.5 //Shame they burn good though.
	death_message = "seizes up and falls limp, their eyes going dim..."

	flesh_color = "#3b1077"
	
	cold_level_1 = 240 //Default 260 - Lower is better
	cold_level_2 = 180 //Default 200
	cold_level_3 = 100 //Default 120

	heat_level_1 = 370 //Default 360 - Higher is better
	heat_level_2 = 480 //Default 400
	heat_level_3 = 1100 //Default 1000
	
	var/heal_rate = 3 // Temp. Regen per tick.
	
	body_temperature = 330
	heat_discomfort_level = 340                   // Aesthetic messages about feeling warm.
	cold_discomfort_level = 270	
	heat_discomfort_strings = list(
		"You feel uncomfortably warm.",
		)
	cold_discomfort_strings = list(
		"You feel chilled to the bone.",
		"You shiver suddenly.",
		"Your teeth chatter."
		)

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
		)


	has_organ = list(
		BP_HEART =    /obj/item/organ/internal/heart,
		BP_LUNGS =    /obj/item/organ/internal/lungs/phorosian,
		BP_LIVER =    /obj/item/organ/internal/liver/phorosian,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys,
		BP_BRAIN =    /obj/item/organ/internal/brain,
		BP_EYES =     /obj/item/organ/internal/eyes,
		)


/datum/species/phorosian/equip_survival_gear(var/mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath(H), slot_wear_mask)

	if(istype(H.get_equipped_item(slot_back), /obj/item/weapon/storage/backpack))
		H.equip_to_slot_or_del(new /obj/item/weapon/tank/nitrogen(H), slot_r_hand)
		H.internal = H.r_hand
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/tank/nitrogen(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/vox(H), slot_r_hand)
		H.internal = H.back

	if(H.internals)
		H.internals.icon_state = "internal1"
	
/datum/species/proc/handle_death(var/mob/living/carbon/human/H) //Handles any species-specific death events (such as dionaea nymph spawns).
	H.has_floating_eyes=0
	

/datum/species/phorosian/handle_environment_special(var/mob/living/carbon/human/H)

	if(!istype(H.wear_suit, H.item_flags & AIRTIGHT) || !istype(H.head, H.item_flags & AIRTIGHT)) //as long as they're wearing something air tight oxygen won't do its thing
		var/datum/gas_mixture/environment = H.loc.return_air()
		if(environment && environment.oxygen && environment.oxygen >= 0.5) //Phorosians so long as there's enough oxygen (0.5 moles, same as it takes to burn gaseous phoron).
			H.adjust_fire_stacks(0.5)
			if(!H.on_fire && H.fire_stacks > 0)
				H.visible_message("<span class='danger'>[H]'s body reacts with the atmosphere and bursts into flames!</span>","<span class='userdanger'>Your body reacts with the atmosphere and bursts into flame!</span>")
			H.IgniteMob()

	// We need a handle_life() proc for this stuff.

	//regenerate health depending on phoron intake.
	
	for(var/obj/item/organ/I in H.internal_organs)
		if(I.damage > 0)
			I.damage = max(I.damage - heal_rate, 0)
			return 1

	// Heal remaining damage.
	if (H.getBruteLoss() || H.getFireLoss() || H.getOxyLoss() || H.getToxLoss())
		H.adjustBruteLoss(-heal_rate)
		H.adjustFireLoss(-heal_rate)
		H.adjustOxyLoss(-heal_rate)
		H.adjustToxLoss(-heal_rate)
		return 1
