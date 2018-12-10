/datum/species/human/gravworlder
	name = "Grav-Adapted Human"
	name_plural = "Grav-Adapted Humans"
	blurb = "Heavier and stronger than a baseline human, gravity-adapted people have \
	thick radiation-resistant skin with a high lead content, denser bones, and recessed \
	eyes beneath a prominent brow in order to shield them from the glare of a dangerously \
	bright, alien sun. This comes at the cost of mobility, flexibility, and increased \
	oxygen requirements to support their robust metabolism."
	icobase =     'icons/mob/human_races/species/human/subspecies/gravworlder_body.dmi'
	preview_icon= 'icons/mob/human_races/species/human/subspecies/gravworlder_preview.dmi'
	health_hud_intensity = 3

	flash_mod =     0.9
	oxy_mod =       1.1
	radiation_mod = 0.5
	brute_mod =     0.85
	slowdown =      1

	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_TONE_GRAV | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR
	spawn_flags = SPECIES_IS_RESTRICTED
/datum/species/human/spacer
	name = "Space-Adapted Human"
	name_plural = "Space-Adapted Humans"
	blurb = "Lithe and frail, these sickly folk were engineered for work in environments that \
	lack both light and atmosphere. As such, they're quite resistant to asphyxiation as well as \
	toxins, but they suffer from weakened bone structure and a marked vulnerability to bright lights."
	icobase =     'icons/mob/human_races/species/human/subspecies/spacer_body.dmi'
	preview_icon= 'icons/mob/human_races/species/human/subspecies/spacer_preview.dmi'

	oxy_mod =    0.8
	toxins_mod = 0.9
	flash_mod =  1.2
	brute_mod =  1.1
	burn_mod =   1.1
	darksight =  6

	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_TONE_SPCR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR
	spawn_flags = SPECIES_IS_RESTRICTED
/datum/species/human/vatgrown
	name = "Vat-Grown Human"
	name_plural = "Vat-Grown Humans"
	blurb = "Months after the colonists began to arrive in the frontier, a series of numbered humans \
	followed in their footsteps, thrown as an afterthought through the portal. There is something not \
	quite right about them; a hauntedness in their eyes - like something in their very soul is missing. \
	It is well-known that Vatgrown humans cannot be cloned, as they do not possess laces."
	icobase =     'icons/mob/human_races/species/human/subspecies/vatgrown_body.dmi'
	preview_icon= 'icons/mob/human_races/species/human/subspecies/vatgrown_preview.dmi'

	toxins_mod =   1.1
	has_organ = list(
		BP_HEART =    /obj/item/organ/internal/heart,
		BP_LUNGS =    /obj/item/organ/internal/lungs,
		BP_LIVER =    /obj/item/organ/internal/liver,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys,
		BP_BRAIN =    /obj/item/organ/internal/brain,
		BP_EYES =     /obj/item/organ/internal/eyes
		)
	appearance_flags = IS_VATGROWN | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED | SPECIES_HAS_VATCHIP
	backgrounds = list("Vatgrown" = "You were manufactured in a lacing lab under the oversight of the Vox-Nanotrasen Partnership. While you never saw the lacing process, you've come to understand that you were a byproduct of it. Unlike most colonists, you don't possess a lace - and you are keenly aware of your own mortality.")

/datum/species/human/vatgrown/sanitize_name(name)
	return sanitizeName(name, allow_numbers=TRUE)

/datum/species/human/vatgrown/get_random_name(gender)
	// #defines so it's easier to read what's actually being generated
	#define LTR ascii2text(rand(65,90)) // A-Z
	#define NUM ascii2text(rand(48,57)) // 0-9
	#define NAME capitalize(pick(GLOB.vatgrown_names))
	switch(rand(1,2))
		if(1) return "[NAME]-[NUM][NUM]"
		if(2) return "[NAME]-[LTR][NUM][NUM]"
	. = 1 // Never executed, works around http://www.byond.com/forum/?post=2072419
	#undef LTR
	#undef NUM
	#undef NAME
/*
// These guys are going to need full resprites of all the suits/etc so I'm going to
// define them and commit the sprites, but leave the clothing for another day.
/datum/species/human/chimpanzee
	name = "uplifted Chimpanzee"
	name_plural = "uplifted Chimpanzees"
	blurb = "Ook ook."
	icobase = 'icons/mob/human_races/subspecies/r_upliftedchimp.dmi'
*/
