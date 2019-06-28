/datum/species/phorosian
	name = SPECIES_PHOROSIAN
	name_plural = "Phorosians"
	icobase =      'icons/mob/human_races/species/phorosian/body.dmi'
	deform =       'icons/mob/human_races/species/phorosian/deformed_body.dmi'  // TODO: Need deform.
	husk_icon =    'icons/mob/human_races/species/phorosian/husk.dmi'
	preview_icon = 'icons/mob/human_races/species/phorosian/preview.dmi'

	rarity_value = 5
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch)
	description = "Victims of Phoron Restructurant Syndrome, Phorosians are forced \
	to use containment suits on oxygen-based stations as they burn when exposed.\
	Problems with short term and long term memory alongside other mental \
	impairments are rampant among them,and they often have to go through many \
	months of therapy to relearn how to do many tasks."

	meat_type = /material/phoron
	hud_type = /datum/hud_data/phorosian //This hud disables the hunger indicator

	virus_immune = 1
	breath_type = GAS_PHORON
	poison_types = list(GAS_OXYGEN = TRUE) //Getting oxygen into your lungs HURTS
	exhale_type = GAS_HYDROGEN
	siemens_coefficient = 0.7

	hunger_factor = 0
	taste_sensitivity = TASTE_DULL //Question is how could they taste anything in the first place?
	gluttonous = GLUT_NONE

	species_flags = SPECIES_FLAG_NO_POISON | SPECIES_FLAG_NO_PAIN | SPECIES_FLAG_NO_HUNGER //They're sorta made out of poison
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED
	appearance_flags = HAS_EYE_COLOR

	brute_mod =     0.7 //Phoron has made them resistant to damage
	burn_mod =      1.5 //Shame they burn good though.

	death_message = "seizes up and falls limp, their eyes going dim..."
	flesh_color = "#3b1077"
	blood_color = "#4d224d"
	reagent_tag = IS_PHOROSIAN

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

	descriptors = list(
		/datum/mob_descriptor/height = -1,
		/datum/mob_descriptor/build = 1
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
		BP_BRAIN =    /obj/item/organ/internal/brain/phorosian,
		BP_EYES =     /obj/item/organ/internal/eyes/phorosian,
		)

	available_cultural_info = list(
		TAG_CULTURE = list(
			CULTURE_PHOROSIAN,
		),
		TAG_AMBITION = list(
			AMBITION_FREEDOM,
			AMBITION_OPPORTUNITY,
			AMBITION_KNOWLEDGE
		)
	)
	default_cultural_info = list(
		TAG_CULTURE = CULTURE_PHOROSIAN,
		TAG_AMBITION = AMBITION_FREEDOM,
	)
	// force_cultural_info = list(
	// 	TAG_CULTURE = list(
	// 		CULTURE_PHOROSIAN,
	// 	)
	// )
	spawns_with_stack = TRUE


/mob/living/carbon/human/phorosian/pl_effects() //you're made of the stuff why would it hurt you?
	return

/mob/living/carbon/human/phorosian/vomit(var/toxvomit = 0, var/timevomit = 1, var/level = 3) //nothing to really vomit out, considering they don't eat
	return


/mob/living/carbon/human/phorosian/get_breath_volume()
	return 2 //gives them more time between tank refills


/datum/species/phorosian/get_blood_name()
	return "phoronic plasma"

/datum/species/phorosian/equip_survival_gear(var/mob/living/carbon/human/H, extendedtank)
	. = ..()
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/phorosian(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/space/phorosian(H), slot_wear_suit)
	if(extendedtank)
		H.equip_to_slot_or_del(new /obj/item/weapon/tank/phoron/phorosian(H), slot_s_store)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/tank/phoron(H), slot_s_store)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/phoron(H.back), slot_in_backpack)
	if(H.internals)
		H.internals.icon_state = "internal1"


/datum/species/phorosian/handle_environment_special(var/mob/living/carbon/human/H)
	//Should they get exposed to oxygen, things get heated.
	if(H.get_pressure_weakness()>0.6) //If air gets in, then well there's a problem.
		var/datum/gas_mixture/environment = H.loc.return_air()
		if(environment && environment.gas[GAS_OXYGEN] && environment.gas[GAS_OXYGEN] >= 0.5) //Phorosians so long as there's enough oxygen (0.5 moles, same as it takes to burn gaseous phoron).
			if(!H.oxyburn)
				if(H.get_pressure_weakness() !=1)
					H.visible_message("<span class='warning'>The internal seals on [H]'s suit break open! </span>","<span class='warning'>The internal seals on your suit break open!</span>")
				H.visible_message("<span class='warning'>[H]'s body reacts with the atmosphere and starts to sizzle and burn!</span>","<span class='warning'>Your body reacts with the atmosphere and starts to sizzle and burn!</span>")
				H.oxyburn=1
			H.burn_skin(H.get_pressure_weakness())
			H.updatehealth()
	else
		H.oxyburn=0

/datum/hud_data/phorosian
	has_nutrition = 0