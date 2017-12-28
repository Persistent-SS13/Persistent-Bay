/datum/species/phorosian
	name = SPECIES_PHOROSIAN
	name_plural = "Phorosians"
	icobase = 'icons/mob/human_races/r_phorosian_sb.dmi'
	deform = 'icons/mob/human_races/r_phorosian_pb.dmi'  // TODO: Need deform.
	rarity_value = 5
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch, /datum/unarmed_attack/bite)
	blurb = "Todo"
	meat_type = /ore/phoron
	taste_sensitivity = TASTE_DULL //Question is how could they taste anything in the first place?
	virus_immune = 1 // Their cells don't exactly work like normal humanoids.
	has_floating_eyes = 1 
	hunger_factor = 0  
	breath_type = "phoron"
	poison_type = "oxygen" //Getting oxygen into your lungs HURTS
	exhale_type = null
	siemens_coefficient = 0.7
	flags = NO_POISON //They're sorta made out of poison
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED
	appearance_flags = HAS_EYE_COLOR
	brute_mod =     0.7 //Phoron has made them resistant to damage
	burn_mod =      1.5 //Shame they burn good though.
	death_message = "seizes up and falls limp, their eyes going dim..."
	flesh_color = "#3b1077"
	blood_color = "#4d224d"
	reagent_tag = IS_PHOROSIAN
	strength    = STR_LOW //they weak
	var/burning //used to check if they are already burning from oxygen exposure - doesn't check for fire
	
	var/list/eye_overlays = list()
	
	cold_level_1 = 240 //Default 260 - Lower is better
	cold_level_2 = 180 //Default 200
	cold_level_3 = 100 //Default 120

	heat_level_1 = 370 //Default 360 - Higher is better
	heat_level_2 = 480 //Default 400
	heat_level_3 = 1100 //Default 1000
	

	body_temperature = 330
	heat_discomfort_level = 360                   // Aesthetic messages about feeling warm.
	cold_discomfort_level = 250	
	heat_discomfort_strings = list(
		"You feel uncomfortably warm.",
		)
	cold_discomfort_strings = list(
		"You feel chilled to the bone.",
		"You shiver suddenly.",
		"Your teeth chatter."
		)

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/phorosian),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/phorosian),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/phorosian),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/phorosian),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/phorosian),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/phorosian),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/phorosian),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/phorosian),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/phorosian),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/phorosian),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/phorosian)
		)


	has_organ = list(
		BP_HEART =    /obj/item/organ/internal/heart/phorosian,
		BP_LUNGS =    /obj/item/organ/internal/lungs/phorosian,
		BP_LIVER =    /obj/item/organ/internal/liver/phorosian,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys,
		BP_BRAIN =    /obj/item/organ/internal/brain/phorosian,
		BP_EYES =     /obj/item/organ/internal/eyes/phorosian,
		)
/mob/living/carbon/human/phorosian/pl_effects() //you're made of the stuff why would it hurt you?
	return
	
/mob/living/carbon/human/phorosian/vomit(var/toxvomit = 0, var/timevomit = 1, var/level = 3) //nothing to really vomit out, considering they don't eat
	return


/datum/species/phorosian/get_blood_name()
	return "Phoronic plasma"
	
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

	
/datum/species/phorosian/handle_environment_special(var/mob/living/carbon/human/H)
	H.nutrition = 400 //if someone knows how to stop something from even needing nutrition, please change this.
	
	//Should they get exposed to oxygen, things get heated.
	if(H.get_pressure_weakness()>0.5) //If air gets in, then well there's a problem.
		var/datum/gas_mixture/environment = H.loc.return_air()
		if(environment && environment.gas["oxygen"] && environment.gas["oxygen"] >= 0.5) //Phorosians so long as there's enough oxygen (0.5 moles, same as it takes to burn gaseous phoron).
			if(!burning)
				H.visible_message("<span class='danger'>[H]'s body reacts with the atmosphere and starts to sizzle and burn!</span>","<span class='userdanger'>Your body reacts with the atmosphere and starts to sizzle and burn!</span>")
				burning=1
			H.burn_skin(H.get_pressure_weakness()*5)
			H.updatehealth()
	else
		burning=0

			
	//healing stuff	
	//for(var/obj/item/organ/I in H.internal_organs)
		//if(I.damage > 0)
			//I.damage = max(I.damage - 2, 0)
			//H.remove_blood(5)
			//return 1
			
	// Heal remaining damage.
	if (H.getBruteLoss())
		H.adjustBruteLoss(-2)
		H.remove_blood(3)
	if (H.getFireLoss())
		H.adjustFireLoss(-2)
		H.remove_blood(3)
	if (H.getOxyLoss())
		H.adjustOxyLoss(-2)
		H.remove_blood(3)
	if (H.getToxLoss())
		H.adjustToxLoss(-2)
		H.remove_blood(3)

