/obj/item/clothing/head/helmet/space/civilian
	name = "EVA softsuit helmet"
	icon = 'icons/obj/clothing/head/softsuits.dmi'
	icon_state = "civ_softhelm"
	item_icons = list(
		slot_head_str = 'icons/mob/onmob/head/softsuits.dmi',
		)
	desc = "A flimsy helmet designed for work in a hazardous, low-pressure environment."
	permeability_coefficient = 0
	armor  = list(
		DAM_BLUNT 	= 10,
		DAM_PIERCE 	= 5,
		DAM_CUT 	= 5,
		DAM_BULLET 	= 5,
		DAM_LASER 	= 2,
		DAM_ENERGY 	= 10,
		DAM_BURN 	= 5,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 0,
		DAM_BIO 	= 100,
		DAM_RADS 	= 10,
		DAM_STUN 	= 0)

/obj/item/clothing/suit/space/civilian
	name = "EVA softsuit"
	desc = "Your average general use softsuit. Though lacking in protection that modern voidsuits give, its cheap cost and portable size makes it perfect for those still getting used to life on the frontier."
	icon = 'icons/obj/clothing/suit/softsuits.dmi'
	item_icons = list(
		slot_wear_suit_str = 'icons/mob/onmob/suit/softsuits.dmi',
		)
	icon_state = "civ_softsuit"
	item_state_slots = list(
		slot_l_hand_str = "s_suit",
		slot_r_hand_str = "s_suit",
	)
	armor  = list(
		DAM_BLUNT 	= 10,
		DAM_PIERCE 	= 5,
		DAM_CUT 	= 5,
		DAM_BULLET 	= 5,
		DAM_LASER 	= 2,
		DAM_ENERGY 	= 10,
		DAM_BURN 	= 5,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 0,
		DAM_BIO 	= 100,
		DAM_RADS 	= 10,
		DAM_STUN 	= 0)



//Engineering softsuit
/obj/item/clothing/head/helmet/space/engineering
	name = "engineering softsuit helmet"
	icon = 'icons/obj/clothing/head/softsuits.dmi'
	icon_state = "eng_softhelm"
	desc = "A flimsy helmet with basic radiation shielding. Its visor protects the user from bright UV lights."
	item_state_slots = list(
		slot_l_hand_str = "eng_helm",
		slot_r_hand_str = "eng_helm",
		)
	item_icons = list(
		slot_head_str = 'icons/mob/onmob/head/softsuits.dmi',
		)
	armor  = list(
		DAM_BLUNT 	= 10,
		DAM_PIERCE 	= 5,
		DAM_CUT 	= 10,
		DAM_BULLET 	= 5,
		DAM_LASER 	= 5,
		DAM_ENERGY 	= 20,
		DAM_BURN 	= 10,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 10,
		DAM_BIO 	= 50,
		DAM_RADS 	= 30,
		DAM_STUN 	= 0)

/obj/item/clothing/suit/space/engineering
	name = "engineering softsuit"
	icon = 'icons/obj/clothing/suit/softsuits.dmi'
	icon_state = "eng_softsuit"
	desc = "A general use softsuit. The cloth fibers on this suit can protect the user from minor amounts of radiation."
	item_icons = list(
		slot_wear_suit_str = 'icons/mob/onmob/suit/softsuits.dmi',
		)
	item_state_slots = list(
		slot_l_hand_str = "eng_voidsuit",
		slot_r_hand_str = "eng_voidsuit",
	)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/toolbox,/obj/item/weapon/storage/briefcase/inflatable,/obj/item/device/t_scanner)
	armor  = list(
		DAM_BLUNT 	= 10,
		DAM_PIERCE 	= 5,
		DAM_CUT 	= 10,
		DAM_BULLET 	= 5,
		DAM_LASER 	= 5,
		DAM_ENERGY 	= 20,
		DAM_BURN 	= 10,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 10,
		DAM_BIO 	= 50,
		DAM_RADS 	= 30,
		DAM_STUN 	= 0)

//Security softsuit
/obj/item/clothing/head/helmet/space/security
	name = "security softsuit helmet"
	icon = 'icons/obj/clothing/head/softsuits.dmi'
	icon_state = "sec_softhelm"
	desc = "A flimsy helmet equipped with heat-resistent fabric."
	item_state_slots = list(
		slot_l_hand_str = "sec_helm",
		slot_r_hand_str = "sec_helm",
		)
	item_icons = list(
		slot_head_str = 'icons/mob/onmob/head/softsuits.dmi',
		)
	siemens_coefficient = 0.8 //barely stronger than average softsuits, slightly weaker than sec voidsuits
	armor  = list(
		DAM_BLUNT 	= 15,
		DAM_PIERCE 	= 10,
		DAM_CUT 	= 15,
		DAM_BULLET 	= 5,
		DAM_LASER 	= 10,
		DAM_ENERGY 	= 5,
		DAM_BURN 	= 10,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 0,
		DAM_BIO 	= 50,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)

/obj/item/clothing/suit/space/security
	name = "security softsuit"
	icon = 'icons/obj/clothing/suit/softsuits.dmi'
	icon_state = "sec_softsuit"
	desc = "A general use softsuit equipped with heat-resistent fabric."
	item_icons = list(
		slot_wear_suit_str = 'icons/mob/onmob/suit/softsuits.dmi',
		)
	item_state_slots = list(
		slot_l_hand_str = "sec_voidsuit",
		slot_r_hand_str = "sec_voidsuit",
	)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency,/obj/item/device/suit_cooling_unit,/obj/item/weapon/melee/baton) //maybe allow small weapons to fit in the suit slot
	siemens_coefficient = 0.8 //barely stronger than average softsuits, slightly weaker than sec voidsuits
	armor  = list(
		DAM_BLUNT 	= 15,
		DAM_PIERCE 	= 10,
		DAM_CUT 	= 15,
		DAM_BULLET 	= 5,
		DAM_LASER 	= 10,
		DAM_ENERGY 	= 5,
		DAM_BURN 	= 10,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 0,
		DAM_BIO 	= 50,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)

//Medical softsuit
/obj/item/clothing/head/helmet/space/medical
	name = "medical softsuit helmet"
	icon = 'icons/obj/clothing/head/softsuits.dmi'
	icon_state = "med_softhelm"
	desc = "A flimsy helmet that protects the user just enough to be considered spaceworthy."
	item_state_slots = list(
		slot_l_hand_str = "medical_helm",
		slot_r_hand_str = "medical_helm",
		)
	item_icons = list(
		slot_head_str = 'icons/mob/onmob/head/softsuits.dmi',
		)
	armor  = list(
		DAM_BLUNT 	= 10,
		DAM_PIERCE 	= 5,
		DAM_CUT 	= 10,
		DAM_BULLET 	= 5,
		DAM_LASER 	= 5,
		DAM_ENERGY 	= 5,
		DAM_BURN 	= 5,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 0,
		DAM_BIO 	= 100,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)

/obj/item/clothing/suit/space/medical
	name = "medical softsuit"
	icon = 'icons/obj/clothing/suit/softsuits.dmi'
	icon_state = "med_softsuit"
	desc = "A general use softsuit that sacrafices some (presumably) non-essential systems in turn for enhanced mobility."
	item_icons = list(
		slot_wear_suit_str = 'icons/mob/onmob/suit/softsuits.dmi',
		)
	item_state_slots = list(
		slot_l_hand_str = "medical_voidsuit",
		slot_r_hand_str = "medical_voidsuit",
	)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/firstaid,/obj/item/device/scanner/health,/obj/item/stack/medical)
	armor  = list(
		DAM_BLUNT 	= 10,
		DAM_PIERCE 	= 5,
		DAM_CUT 	= 10,
		DAM_BULLET 	= 5,
		DAM_LASER 	= 5,
		DAM_ENERGY 	= 5,
		DAM_BURN 	= 5,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 0,
		DAM_BIO 	= 100,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)

/obj/item/clothing/suit/space/void/medical/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 0.5

//Mining softsuit
/obj/item/clothing/head/helmet/space/mining
	name = "mining softsuit helmet"
	icon = 'icons/obj/clothing/head/softsuits.dmi'
	icon_state = "miner_softhelm"
	desc = "A flimsy helmet with extra thick fabric, you still aren't sure if it'll be enough to protect you."
	item_state_slots = list(
		slot_l_hand_str = "mining_helm",
		slot_r_hand_str = "mining_helm",
		)
	item_icons = list(
		slot_head_str = 'icons/mob/onmob/head/softsuits.dmi',
		)
	armor  = list(
		DAM_BLUNT 	= 20,
		DAM_PIERCE 	= 10,
		DAM_CUT 	= 20,
		DAM_BULLET 	= 10,
		DAM_LASER 	= 10,
		DAM_ENERGY 	= 10,
		DAM_BURN 	= 5,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 0,
		DAM_BIO 	= 100,
		DAM_RADS 	= 10,
		DAM_STUN 	= 2)

/obj/item/clothing/suit/space/mining
	name = "mining softsuit"
	icon = 'icons/obj/clothing/suit/softsuits.dmi'
	icon_state = "miner_softsuit"
	desc = "A general use softsuit with extra thick fabric. Something tells you its not thick enough."
	item_icons = list(
		slot_wear_suit_str = 'icons/mob/onmob/suit/softsuits.dmi',
		)
	item_state_slots = list(
		slot_l_hand_str = "mining_voidsuit",
		slot_r_hand_str = "mining_voidsuit",
	)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency,/obj/item/stack/flag,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/ore,/obj/item/weapon/pickaxe)
	armor  = list(
		DAM_BLUNT 	= 20,
		DAM_PIERCE 	= 10,
		DAM_CUT 	= 20,
		DAM_BULLET 	= 10,
		DAM_LASER 	= 10,
		DAM_ENERGY 	= 10,
		DAM_BURN 	= 5,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 0,
		DAM_BIO 	= 100,
		DAM_RADS 	= 10,
		DAM_STUN 	= 2)

//Science softsuit, we don't have xenoarch but that's the only thing i can base its stats off of
/obj/item/clothing/head/helmet/space/science
	name = "scientist softsuit helmet"
	icon = 'icons/obj/clothing/head/softsuits.dmi'
	icon_state = "sci_softhelm"
	item_icons = list(
		slot_head_str = 'icons/mob/onmob/head/softsuits.dmi',
		)
	desc = "A flimsy helmet that provides basic protection from radiation."
	armor  = list(
		DAM_BLUNT 	= 10,
		DAM_PIERCE 	= 5,
		DAM_CUT 	= 10,
		DAM_BULLET 	= 5,
		DAM_LASER 	= 5,
		DAM_ENERGY 	= 20,
		DAM_BURN 	= 5,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 20,
		DAM_BIO 	= 100,
		DAM_RADS 	= 20,
		DAM_STUN 	= 0)

/obj/item/clothing/suit/space/science
	name = "scientist softsuit"
	icon = 'icons/obj/clothing/suit/softsuits.dmi'
	icon_state = "sci_softsuit"
	item_icons = list(
		slot_wear_suit_str = 'icons/mob/onmob/suit/softsuits.dmi',
		)
	desc = "A general use softsuit retrofitted with basic radiation shielding."
	armor  = list(
		DAM_BLUNT 	= 10,
		DAM_PIERCE 	= 5,
		DAM_CUT 	= 10,
		DAM_BULLET 	= 5,
		DAM_LASER 	= 5,
		DAM_ENERGY 	= 20,
		DAM_BURN 	= 5,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 20,
		DAM_BIO 	= 100,
		DAM_RADS 	= 20,
		DAM_STUN 	= 0)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency,/obj/item/device/suit_cooling_unit,/obj/item/stack/flag,/obj/item/weapon/storage/excavation,/obj/item/weapon/pickaxe,/obj/item/device/scanner/health,/obj/item/device/measuring_tape,/obj/item/device/ano_scanner,/obj/item/device/depth_scanner,/obj/item/device/core_sampler,/obj/item/device/gps,/obj/item/weapon/pinpointer/radio,/obj/item/device/radio/beacon,/obj/item/weapon/pickaxe/xeno/hand,/obj/item/weapon/storage/bag/fossils)

//Emergency softsuit
/obj/item/clothing/head/helmet/space/emergency/alt
	name = "emergency softsuit"
	icon = 'icons/obj/clothing/head/softsuits.dmi'
	icon_state = "crisis_softhelm"
	item_icons = list(
		slot_head_str = 'icons/mob/onmob/head/softsuits.dmi',
		)
	desc = "A simple helmet with a built in light, smells like mothballs."
	flash_protection = FLASH_PROTECTION_NONE

/obj/item/clothing/suit/space/emergency/alt
	name = "emergency softsuit"
	icon = 'icons/obj/clothing/suit/softsuits.dmi'
	icon_state = "crisis_softsuit"
	item_icons = list(
		slot_wear_suit_str = 'icons/mob/onmob/suit/softsuits.dmi',
		)
	desc = "A thin, ungainly softsuit colored in blaze orange for rescuers to easily locate, looks pretty fragile."
	armor  = list(
		DAM_BLUNT 	= 5,
		DAM_PIERCE 	= 1,
		DAM_CUT 	= 5,
		DAM_BULLET 	= 5,
		DAM_LASER 	= 2,
		DAM_ENERGY 	= 5,
		DAM_BURN 	= 5,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 0,
		DAM_BIO 	= 50,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)
	allowed = list(/obj/item/weapon/tank/emergency)

/obj/item/clothing/suit/space/emergency/alt/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 4
