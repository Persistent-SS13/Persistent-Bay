/obj/item/clothing/head/helmet
	name = "helmet"
	desc = "Reinforced headgear. Protects the head from impacts."
	icon_state = "helmet"
	item_state_slots = list(
		slot_l_hand_str = "helmet",
		slot_r_hand_str = "helmet",
		)
	valid_accessory_slots = list(ACCESSORY_SLOT_HELM_C)
	restricted_accessory_slots = list(ACCESSORY_SLOT_HELM_C)
	item_flags = ITEM_FLAG_THICKMATERIAL
	body_parts_covered = HEAD
	flags_inv = HIDEEARS|BLOCKHEADHAIR
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	w_class = ITEM_SIZE_NORMAL
	species_restricted = list("exclude", SPECIES_NABBER, SPECIES_ADHERENT)
	armor  = list(
		DAM_BLUNT 	= 50,
		DAM_PIERCE 	= 40,
		DAM_CUT 	= 50,
		DAM_BULLET 	= 50,
		DAM_LASER 	= 50,
		DAM_ENERGY 	= 25,
		DAM_BURN 	= 25,
		DAM_BOMB 	= 30,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)

/obj/item/clothing/head/helmet/nt
	name = "\improper corporate security helmet"
	desc = "A helmet with 'CORPORATE SECURITY' printed on the back in red lettering."
	icon_state = "helmet_nt"

/obj/item/clothing/head/helmet/pcrc
	name = "\improper PCRC helmet"
	desc = "A helmet with 'PRIVATE SECURITY' printed on the back in cyan lettering."
	icon_state = "helmet_pcrc"

/obj/item/clothing/head/helmet/nt/guard
	starting_accessories = list(/obj/item/clothing/accessory/armor/helmcover/nt)

/obj/item/clothing/head/helmet/tactical
	name = "tactical helmet"
	desc = "A tan helmet made from advanced ceramic. Comfortable and robust."
	icon_state = "helmet_tac"
	siemens_coefficient = 0.6
	armor  = list(
		DAM_BLUNT 	= 50,
		DAM_PIERCE 	= 40,
		DAM_CUT 	= 50,
		DAM_BULLET 	= 60,
		DAM_LASER 	= 60,
		DAM_ENERGY 	= 45,
		DAM_BURN 	= 30,
		DAM_BOMB 	= 30,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)

/obj/item/clothing/head/helmet/merc
	name = "combat helmet"
	desc = "A heavily reinforced helmet painted with red markings. Feels like it could take a lot of punishment."
	icon_state = "helmet_merc"
	siemens_coefficient = 0.5
	armor  = list(
		DAM_BLUNT 	= 70,
		DAM_PIERCE 	= 60,
		DAM_CUT 	= 70,
		DAM_BULLET 	= 70,
		DAM_LASER 	= 70,
		DAM_ENERGY 	= 35,
		DAM_BURN 	= 35,
		DAM_BOMB 	= 30,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)

/obj/item/clothing/head/helmet/riot
	name = "riot helmet"
	desc = "It's a helmet specifically designed to protect against close range attacks."
	icon_state = "helmet_riot"
	valid_accessory_slots = null
	body_parts_covered = HEAD|FACE|EYES //face shield
	siemens_coefficient = 0.7
	action_button_name = "Toggle Visor"
	armor  = list(
		DAM_BLUNT 	= 82,
		DAM_PIERCE 	= 72,
		DAM_CUT 	= 82,
		DAM_BULLET 	= 30,
		DAM_LASER 	= 20,
		DAM_ENERGY 	= 10,
		DAM_BURN 	= 10,
		DAM_BOMB 	= 20,
		DAM_EMP 	= 0,
		DAM_BIO 	= 10,
		DAM_RADS 	= 10,
		DAM_STUN 	= 30)

/obj/item/clothing/head/helmet/riot/attack_self(mob/user as mob)
	if(src.icon_state == initial(icon_state))
		src.icon_state = "[icon_state]_up"
		to_chat(user, "You raise the visor on the [src].")
	else
		src.icon_state = initial(icon_state)
		to_chat(user, "You lower the visor on the [src].")
	update_clothing_icon()

/obj/item/clothing/head/helmet/ablative
	name = "ablative helmet"
	desc = "A helmet made from advanced materials which protects against concentrated energy weapons."
	icon_state = "helmet_reflect"
	valid_accessory_slots = null
	siemens_coefficient = 0
	armor  = list(
		DAM_BLUNT 	= 15,
		DAM_PIERCE 	= 5,
		DAM_CUT 	= 15,
		DAM_BULLET 	= 5,
		DAM_LASER 	= 82,
		DAM_ENERGY 	= 50,
		DAM_BURN 	= 82,
		DAM_BOMB 	= 30,
		DAM_EMP 	= 0,
		DAM_BIO 	= 5,
		DAM_RADS 	= 0,
		DAM_STUN 	= 10)

/obj/item/clothing/head/helmet/ballistic
	name = "ballistic helmet"
	desc = "A helmet with reinforced plating to protect against ballistic projectiles."
	icon_state = "helmet_bulletproof"
	valid_accessory_slots = null
	siemens_coefficient = 0.7
	armor  = list(
		DAM_BLUNT 	= 60,
		DAM_PIERCE 	= 50,
		DAM_CUT 	= 60,
		DAM_BULLET 	= 82,
		DAM_LASER 	= 30,
		DAM_ENERGY 	= 5,
		DAM_BURN 	= 15,
		DAM_BOMB 	= 30,
		DAM_EMP 	= 0,
		DAM_BIO 	= 2,
		DAM_RADS 	= 0,
		DAM_STUN 	= 10)

/obj/item/clothing/head/helmet/swat
	name = "\improper SWAT helmet"
	desc = "They're often used by highly trained Swat Members."
	icon_state = "helmet_merc"
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.5
	armor  = list(
		DAM_BLUNT 	= 80,
		DAM_PIERCE 	= 70,
		DAM_CUT 	= 80,
		DAM_BULLET 	= 60,
		DAM_LASER 	= 50,
		DAM_ENERGY 	= 25,
		DAM_BURN 	= 25,
		DAM_BOMB 	= 50,
		DAM_EMP 	= 0,
		DAM_BIO 	= 10,
		DAM_RADS 	= 0,
		DAM_STUN 	= 10)

/obj/item/clothing/head/helmet/thunderdome
	name = "\improper Thunderdome helmet"
	desc = "<i>'Let the battle commence!'</i>"
	icon_state = "thunderdome"
	valid_accessory_slots = null
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 1
	armor  = list(
		DAM_BLUNT 	= 80,
		DAM_PIERCE 	= 70,
		DAM_CUT 	= 80,
		DAM_BULLET 	= 60,
		DAM_LASER 	= 50,
		DAM_ENERGY 	= 10,
		DAM_BURN 	= 25,
		DAM_BOMB 	= 25,
		DAM_EMP 	= 0,
		DAM_BIO 	= 10,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)

/obj/item/clothing/head/helmet/thunderdome/costume
	armor  = list(
		DAM_BLUNT 	= 8,
		DAM_PIERCE 	= 5,
		DAM_CUT 	= 5,
		DAM_BULLET 	= 0,
		DAM_LASER 	= 0,
		DAM_ENERGY 	= 0,
		DAM_BURN 	= 0,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 0,
		DAM_BIO 	= 5,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)

/obj/item/clothing/head/helmet/gladiator
	name = "gladiator helmet"
	desc = "Ave, Imperator, morituri te salutant."
	icon_state = "gladiator"
	valid_accessory_slots = null
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	body_parts_covered = HEAD|FACE
	siemens_coefficient = 1

/obj/item/clothing/head/helmet/gladiator/costume
	armor  = list(
		DAM_BLUNT 	= 10,
		DAM_PIERCE 	= 5,
		DAM_CUT 	= 5,
		DAM_BULLET 	= 0,
		DAM_LASER 	= 1,
		DAM_ENERGY 	= 0,
		DAM_BURN 	= 0,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 0,
		DAM_BIO 	= 5,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)

/*
/obj/item/clothing/head/helmet/tactical
	name = "tactical helmet"
	desc = "An armored helmet capable of being fitted with a multitude of attachments."
	icon_state = "swathelm"
	valid_accessory_slots = null
	sprite_sheets = list(
		SPECIES_TAJARA = 'icons/mob/species/tajaran/helmet.dmi',
		SPECIES_UNATHI = 'icons/mob/species/unathi/helmet.dmi'
		)

	flags_inv = HIDEEARS
	siemens_coefficient = 0.7
	armor  = list(
		DAM_BLUNT 	= 62,
		DAM_PIERCE 	= 52,
		DAM_CUT 	= 62,
		DAM_BULLET 	= 50,
		DAM_LASER 	= 50,
		DAM_ENERGY 	= 35,
		DAM_BURN 	= 25,
		DAM_BOMB 	= 10,
		DAM_EMP 	= 0,
		DAM_BIO 	= 10,
		DAM_RADS 	= 5,
		DAM_STUN 	= 10)
*/

/obj/item/clothing/head/helmet/augment
	name = "Augment Array"
	desc = "A helmet with optical and cranial augments coupled to it."
	icon_state = "v62"
	valid_accessory_slots = null
	flags_inv = HIDEEARS|HIDEEYES
	body_parts_covered = HEAD|EYES|BLOCKHEADHAIR
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.5
	armor  = list(
		DAM_BLUNT 	= 80,
		DAM_PIERCE 	= 70,
		DAM_CUT 	= 80,
		DAM_BULLET 	= 60,
		DAM_LASER 	= 50,
		DAM_ENERGY 	= 25,
		DAM_BURN 	= 25,
		DAM_BOMB 	= 50,
		DAM_EMP 	= 0,
		DAM_BIO 	= 10,
		DAM_RADS 	= 0,
		DAM_STUN 	= 5)

//Non-hardsuit ERT helmets.
//Commander
/obj/item/clothing/head/helmet/ert
	name = "asset protection command helmet"
	desc = "An in-atmosphere helmet worn by many corporate and private asset protection forces. Has blue highlights."
	icon_state = "erthelmet_cmd"
	valid_accessory_slots = null
	item_state_slots = list(
		slot_l_hand_str = "syndicate-helm-green",
		slot_r_hand_str = "syndicate-helm-green",
		)
	armor  = list(
		DAM_BLUNT 	= 62,
		DAM_PIERCE 	= 52,
		DAM_CUT 	= 62,
		DAM_BULLET 	= 50,
		DAM_LASER 	= 50,
		DAM_ENERGY 	= 35,
		DAM_BURN 	= 40,
		DAM_BOMB 	= 10,
		DAM_EMP 	= 5,
		DAM_BIO 	= 5,
		DAM_RADS 	= 10,
		DAM_STUN 	= 5)

//Security
/obj/item/clothing/head/helmet/ert/security
	name = "asset protection security helmet"
	desc = "An in-atmosphere helmet worn by many corporate and private asset protection forces. Has red highlights."
	icon_state = "erthelmet_sec"

//Engineer
/obj/item/clothing/head/helmet/ert/engineer
	name = "asset protection engineering helmet"
	desc = "An in-atmosphere helmet worn by many corporate and private asset protection forces. Has orange highlights."
	icon_state = "erthelmet_eng"

//Medical
/obj/item/clothing/head/helmet/ert/medical
	name = "asset protection medical helmet"
	desc = "An in-atmosphere helmet worn by many corporate and private asset protection forces. Has red and white highlights."
	icon_state = "erthelmet_med"

/obj/item/clothing/head/helmet/tactical/mirania
	name = "bundeforz tactical helmet"
	desc = "A light grey helmet made from advanced ceramic. Comfortable and robust."
	icon_state = "m_helmet"

/obj/item/clothing/head/helmet/nt/pilot
	name = "corporate pilot's helmet"
	desc = "A corporate pilot's helmet for operating the cockpit in style for a hefty paycheck."
	icon_state = "pilotnt"

/obj/item/clothing/head/helmet/skrell
	name = "skrellian helmet"
	desc = "A helmet built for use by a Skrell. This one appears to be fairly standard and reliable."
	icon_state = "helmet_skrell"
	valid_accessory_slots = null
/obj/item/clothing/head/helmet/guard
	name = "guard helmet"
	desc = "A royal blue helmet designed for both ceremonial and practical use."
	icon_state = "helmet_guard"
	armor = list(melee = 50, bullet = 60, laser = 60, energy = 45, bomb = 30, bio = 0, rad = 0)
	siemens_coefficient = 0.6
