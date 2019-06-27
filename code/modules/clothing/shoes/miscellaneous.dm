/obj/item/clothing/shoes/syndigaloshes
	desc = "A pair of brown shoes. They seem to have extra grip."
	name = "brown shoes"
	icon_state = "brown"
	item_state = "brown"
	permeability_coefficient = 0.05
	item_flags = ITEM_FLAG_NOSLIP
	origin_tech = list(TECH_ILLEGAL = 3)
	var/list/clothing_choices = list()
	siemens_coefficient = 0.8
	species_restricted = null

/obj/item/clothing/shoes/mime
	name = "mime shoes"
	icon_state = "mime"

/obj/item/clothing/shoes/swat
	name = "\improper SWAT boots"
	desc = "When you want to turn up the heat."
	icon_state = "swat"
	force = 3
	item_flags = ITEM_FLAG_NOSLIP
	siemens_coefficient = 0.6
	can_hold_knife = 1
	armor  = list(
		DAM_BLUNT 	= 80,
		DAM_PIERCE 	= 70,
		DAM_CUT 	= 80,
		DAM_BULLET 	= 60,
		DAM_LASER 	= 60,
		DAM_ENERGY 	= 25,
		DAM_BURN 	= 40,
		DAM_BOMB 	= 50,
		DAM_EMP 	= 10,
		DAM_BIO 	= 10,
		DAM_RADS 	= 0,
		DAM_STUN 	= 10)

/obj/item/clothing/shoes/combat //Basically SWAT shoes combined with galoshes.
	name = "combat boots"
	desc = "When you REALLY want to turn up the heat."
	icon_state = "jungle"
	force = 5
	item_flags = ITEM_FLAG_NOSLIP
	siemens_coefficient = 0.6
	can_hold_knife = 1

	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE
	armor  = list(
		DAM_BLUNT 	= 80,
		DAM_PIERCE 	= 70,
		DAM_CUT 	= 80,
		DAM_BULLET 	= 60,
		DAM_LASER 	= 60,
		DAM_ENERGY 	= 25,
		DAM_BURN 	= 40,
		DAM_BOMB 	= 50,
		DAM_EMP 	= 10,
		DAM_BIO 	= 10,
		DAM_RADS 	= 0,
		DAM_STUN 	= 5)

/obj/item/clothing/shoes/eod
	name = "bomb boots"
	desc = "A pair of boot reinforced to provide some explosion protection."
	icon_state = "swat"
	force = 2
	item_flags = ITEM_FLAG_NOSLIP
	siemens_coefficient = 0.6
	can_hold_knife = 1
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE
	armor  = list(
		DAM_BLUNT 	= 70,
		DAM_PIERCE 	= 60,
		DAM_CUT 	= 70,
		DAM_BULLET 	= 15,
		DAM_LASER 	= 30,
		DAM_ENERGY 	= 50,
		DAM_BURN 	= 60,
		DAM_BOMB 	= 90,
		DAM_EMP 	= 10,
		DAM_BIO 	= 5,
		DAM_RADS 	= 0,
		DAM_STUN 	= 5)

/obj/item/clothing/shoes/jungleboots
	name = "jungle boots"
	desc = "A pair of durable brown boots. Waterproofed for use planetside."
	icon_state = "jungle"
	force = 3
	siemens_coefficient = 0.7
	can_hold_knife = 1
	armor  = list(
		DAM_BLUNT 	= 30,
		DAM_PIERCE 	= 20,
		DAM_CUT 	= 30,
		DAM_BULLET 	= 10,
		DAM_LASER 	= 10,
		DAM_ENERGY 	= 15,
		DAM_BURN 	= 10,
		DAM_BOMB 	= 20,
		DAM_EMP 	= 0,
		DAM_BIO 	= 10,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)

/obj/item/clothing/shoes/desertboots
	name = "desert boots"
	desc = "A pair of durable tan boots. Designed for use in hot climates."
	icon_state = "desert"
	force = 3
	siemens_coefficient = 0.7
	can_hold_knife = 1
	armor  = list(
		DAM_BLUNT 	= 30,
		DAM_PIERCE 	= 20,
		DAM_CUT 	= 30,
		DAM_BULLET 	= 10,
		DAM_LASER 	= 10,
		DAM_ENERGY 	= 15,
		DAM_BURN 	= 10,
		DAM_BOMB 	= 20,
		DAM_EMP 	= 0,
		DAM_BIO 	= 10,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)

/obj/item/clothing/shoes/dutyboots
	name = "duty boots"
	desc = "A pair of steel-toed synthleather boots with a mirror shine."
	icon_state = "duty"
	siemens_coefficient = 0.7
	can_hold_knife = 1
	armor  = list(
		DAM_BLUNT 	= 40,
		DAM_PIERCE 	= 30,
		DAM_CUT 	= 40,
		DAM_BULLET 	= 0,
		DAM_LASER 	= 0,
		DAM_ENERGY 	= 15,
		DAM_BURN 	= 10,
		DAM_BOMB 	= 20,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 20,
		DAM_STUN 	= 0)

/obj/item/clothing/shoes/tactical
	name = "tactical boots"
	desc = "Tan boots with extra padding and armor."
	icon_state = "desert"
	force = 3
	siemens_coefficient = 0.7
	can_hold_knife = 1
	armor  = list(
		DAM_BLUNT 	= 40,
		DAM_PIERCE 	= 30,
		DAM_CUT 	= 40,
		DAM_BULLET 	= 30,
		DAM_LASER 	= 40,
		DAM_ENERGY 	= 25,
		DAM_BURN 	= 25,
		DAM_BOMB 	= 50,
		DAM_EMP 	= 5,
		DAM_BIO 	= 5,
		DAM_RADS 	= 0,
		DAM_STUN 	= 2)

/obj/item/clothing/shoes/dress
	name = "dress shoes"
	desc = "The height of fashion, and they're pre-polished!"
	icon_state = "laceups"

/obj/item/clothing/shoes/dress/white
	name = "white dress shoes"
	desc = "Brilliantly white shoes, not a spot on them."
	icon_state = "whitedress"

/obj/item/clothing/shoes/sandal
	desc = "A pair of rather plain, wooden sandals."
	name = "sandals"
	icon_state = "wizard"
	species_restricted = null
	body_parts_covered = 0

	wizard_garb = 1

/obj/item/clothing/shoes/sandal/marisa
	desc = "A pair of magic, black shoes."
	name = "magic shoes"
	icon_state = "black"
	body_parts_covered = FEET

/obj/item/clothing/shoes/clown_shoes
	desc = "The prankster's standard-issue clowning shoes. Damn they're huge!"
	name = "clown shoes"
	icon_state = "clown"
	item_state = "clown"
	force = 0
	var/footstep = 1	//used for squeeks whilst walking
	species_restricted = null

/obj/item/clothing/shoes/clown_shoes/New()
	..()
	slowdown_per_slot[slot_shoes]  = 1

/obj/item/clothing/shoes/clown_shoes/handle_movement(var/turf/walking, var/running)
	if(running)
		if(footstep >= 2)
			footstep = 0
			playsound(src, "clownstep", 50, 1) // this will get annoying very fast.
		else
			footstep++
	else
		playsound(src, "clownstep", 20, 1)

/obj/item/clothing/shoes/cult
	name = "boots"
	desc = "A pair of oddly designed boots that stare into your soul."
	icon_state = "cult"
	item_state = "cult"

/obj/item/clothing/shoes/cyborg
	name = "cyborg boots"
	desc = "Shoes for a cyborg costume."
	icon_state = "boots"

/obj/item/clothing/shoes/slippers
	name = "bunny slippers"
	desc = "Fluffy!"
	icon_state = "slippers"
	item_state = "slippers"
	force = 0
	species_restricted = null
	w_class = ITEM_SIZE_SMALL

/obj/item/clothing/shoes/slippers_worn
	name = "worn bunny slippers"
	desc = "Fluffy..."
	icon_state = "slippers_worn"
	item_state = "slippers_worn"
	force = 0
	w_class = ITEM_SIZE_SMALL

/obj/item/clothing/shoes/laceup
	name = "laceup shoes"
	desc = "The height of fashion, and they're pre-polished!"
	icon_state = "laceups"

/obj/item/clothing/shoes/swimmingfins
	desc = "Help you swim good."
	name = "swimming fins"
	icon_state = "flippers"
	item_flags = ITEM_FLAG_NOSLIP
	species_restricted = null

/obj/item/clothing/shoes/swimmingfins/New()
	..()
	slowdown_per_slot[slot_shoes] = 1

/obj/item/clothing/shoes/athletic
	name = "athletic shoes"
	desc = "A pair of sleek atheletic shoes. Made by and for the sporty types."
	icon_state = "sportshoe"

/obj/item/clothing/shoes/laceup/sneakies
	desc = "The height of fashion, and they're pre-polished. Upon further inspection, the soles appear to be on backwards. They look uncomfortable."
	species_restricted = list(SPECIES_HUMAN, SPECIES_IPC)
	move_trail = /obj/effect/decal/cleanable/blood/tracks/footprints/reversed
	item_flags = ITEM_FLAG_SILENT

/obj/item/clothing/shoes/heels
	name = "high heels"
	icon_state = "heels"
	desc = "A pair of colourable high heels."

/obj/item/clothing/shoes/heels/black
	name = "black high heels"
	desc = "A pair of black high heels."
	color = COLOR_GRAY15

obj/item/clothing/shoes/heels/red
	name = "red high heels"
	desc = "A pair of red high heels."
	color = COLOR_RED
