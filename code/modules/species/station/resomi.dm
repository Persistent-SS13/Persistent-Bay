/datum/species/resomi
	name = SPECIES_RESOMI
	name_plural = "Resomii"
	icobase = 'icons/mob/human_races/species/resomi/body.dmi'
	deform = 'icons/mob/human_races/species/resomi/body.dmi'
	damage_overlays = 'icons/mob/human_races/species/resomi/damage_overlay_resomi.dmi'
	damage_mask = 'icons/mob/human_races/species/resomi/damage_mask_resomi.dmi'
	blood_mask = 'icons/mob/human_races/species/resomi/blood_mask_resomi.dmi'
	husk_icon = 'icons/mob/human_races/species/resomi/husk.dmi'
	tail = "resomitail"
	tail_hair = "feathers"
	limb_blend = ICON_MULTIPLY
	tail_blend = ICON_MULTIPLY
	hidden_from_codex = FALSE

	unarmed_types = list(/datum/unarmed_attack/bite/sharp, /datum/unarmed_attack/claws, /datum/unarmed_attack/stomp/weak)
	darksight_range = 6
	darksight_tint = DARKTINT_GOOD
	total_health = 150
	brute_mod = 1.20
	burn_mod = 1.20
	flash_mod = 1.5
	mob_size = MOB_SMALL
	holder_type = /obj/item/weapon/holder/human
	gluttonous = GLUT_TINY
	strength = STR_HIGH
	slowdown = -0.75
	blood_volume = 460
	pass_flags = PASS_FLAG_TABLE

	health_hud_intensity = 3
	hunger_factor = DEFAULT_HUNGER_FACTOR * 2

	min_age = 12
	max_age = 52

	description = "A race of feathered raptors who developed on an arctic moon orbiting\
	a gas giant. Small and lithe, their society developed with a strong inclination\
	towards tightly-knit social units known as packs. Hailing from a far-flung star in\
	a distant arm of the galaxy, Resomi have only recently made themselves known on the\
	galactic stage following contact with their exploration frigates."


	cold_level_1 = 180 //Default 260 - Lower is better
	cold_level_2 = 130 //Default 200
	cold_level_3 = 70 //Default 120

	heat_level_1 = 320 //Default 360 - Higher is better
	heat_level_2 = 370 //Default 400
	heat_level_3 = 600 //Default 1000

	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED
	spawns_with_stack = TRUE
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_EYE_COLOR
	bump_flag = MONKEY
	swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	push_flags = MONKEY|SLIME|SIMPLE_ANIMAL|ALIEN

	flesh_color = "#5f7bb0"
	reagent_tag = IS_RESOMI
	blood_color = "#d514f7"
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

	breath_pressure = 14

	inherent_verbs = list(
		/mob/living/carbon/human/proc/sonar_ping,
		/mob/living/proc/hide
		)

	descriptors = list(
		/datum/mob_descriptor/height = -2,
		/datum/mob_descriptor/build = -2
		)
		
	available_cultural_info = list(
		TAG_CULTURE = list(
			CULTURE_RESOMI
		),
		TAG_AMBITION = list(
			AMBITION_FREEDOM,
			AMBITION_OPPORTUNITY,
			AMBITION_KNOWLEDGE
		)
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
		
/datum/species/resomi/equip_survival_gear(var/mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H),slot_shoes)
