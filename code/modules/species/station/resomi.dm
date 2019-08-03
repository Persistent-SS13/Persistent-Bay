/datum/species/resomi
	name = SPECIES_RESOMI
	name_plural = "Resomii"
	icobase = 'icons/mob/human_races/species/seromi/body.dmi'
	deform = 'icons/mob/human_races/species/seromi/body.dmi'
	damage_overlays = 'icons/mob/human_races/species/seromi/damage_overlay_seromi.dmi'
	damage_mask = 'icons/mob/human_races/species/seromi/damage_mask_seromi.dmi'
	blood_mask = 'icons/mob/human_races/species/seromi/blood_mask_resomi.dmi'
	husk_icon = 'icons/mob/human_races/species/seromi/husk.dmi'
	tail = "resomitail"
	tail_hair = "feathers"
	hidden_from_codex = FALSE

	unarmed_types = list(/datum/unarmed_attack/bite/sharp, /datum/unarmed_attack/claws, /datum/unarmed_attack/stomp/weak)
	darksight_range = 5
	total_health = 50
	brute_mod = 1.35
	burn_mod = 1.35
	flash_mod = 1.5
	metabolism_mod = 2.0
	mob_size = MOB_SMALL
	holder_type = /obj/item/weapon/holder/human
	gluttonous = GLUT_TINY
	slowdown = -1
	blood_volume = 400
	pass_flags = PASS_FLAG_TABLE
	
	health_hud_intensity = 3
	hunger_factor = DEFAULT_HUNGER_FACTOR * 2

	min_age = 12
	max_age = 50

	description = "A race of feathered raptors who developed on a cold world, almost \
	outside of the Goldilocks zone. Extremely fragile, they developed hunting skills \
	that emphasized taking out their prey without themselves getting hit. They are an \
	advanced culture with a focus on technology and tight-knit social groups."

	cold_level_1 = 180 //Default 260 - Lower is better
	cold_level_2 = 130 //Default 200
	cold_level_3 = 70 //Default 120
	
	heat_level_1 = 320 //Default 360 - Higher is better
	heat_level_2 = 370 //Default 400
	heat_level_3 = 600 //Default 1000
  
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_EYE_COLOR
	bump_flag = MONKEY
	swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	push_flags = MONKEY|SLIME|SIMPLE_ANIMAL|ALIEN
	
	flesh_color = "#5F7BB0"
	reagent_tag = IS_RESOMI
	blood_color = "#D514F7"
	base_color = "#001144"
	
	move_trail = /obj/effect/decal/cleanable/blood/tracks/claw
	
	heat_discomfort_level = 296
	heat_discomfort_strings = list(
  	"Your feathers prickle in the heat.",
  	"You feel uncomfortably warm.")
	
	cold_discomfort_level = 180
	cold_discomfort_strings = list(
  	"Your feathers bristle in the cold.",
  	"Your feathers puff out, insulating you from the cold.",
  	"You shiver for warmth.")
  
	inherent_verbs = list(
		/mob/living/carbon/human/proc/sonar_ping,
		/mob/living/proc/hide
		)
	
	descriptors = list(
		/datum/mob_descriptor/height = -1.5,
		/datum/mob_descriptor/build = -1.5
		)

	override_organ_types = list(
		BP_R_HAND = /obj/item/organ/external/hand/right/resomi,
		BP_L_HAND = /obj/item/organ/external/hand/resomi,
		BP_R_FOOT = /obj/item/organ/external/foot/right/resomi,
		BP_L_FOOT = /obj/item/organ/external/foot/resomi,
		BP_LIVER = /obj/item/organ/internal/liver/resomi,
		BP_KIDNEYS = /obj/item/organ/internal/kidneys/resomi,
		BP_EYES = /obj/item/organ/internal/eyes/resomi
		)
