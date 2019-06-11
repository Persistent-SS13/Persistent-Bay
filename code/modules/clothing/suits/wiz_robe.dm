/obj/item/clothing/head/wizard
	name = "wizard hat"
	desc = "Strange-looking hat-wear that most certainly belongs to a real magic user."
	icon_state = "wizard"
	item_state_slots = list(
		slot_l_hand_str = "wizhat",
		slot_r_hand_str = "wizhat",
		)
	//Not given any special protective value since the magic robes are full-body protection --NEO
	siemens_coefficient = 0.8
	body_parts_covered = 0
	wizard_garb = 1

/obj/item/clothing/head/wizard/red
	name = "red wizard hat"
	desc = "Strange-looking, red, hat-wear that most certainly belongs to a real magic user."
	icon_state = "redwizard"
	siemens_coefficient = 0.8

/obj/item/clothing/head/wizard/fake
	name = "wizard hat"
	desc = "It has WIZZARD written across it in sequins. Comes with a cool beard."
	icon_state = "wizard-fake"
	body_parts_covered = HEAD|FACE

/obj/item/clothing/head/wizard/marisa
	name = "Witch Hat"
	desc = "Strange-looking hat-wear, makes you want to cast fireballs."
	icon_state = "marisa"
	siemens_coefficient = 0.8

/obj/item/clothing/head/wizard/magus
	name = "Magus Helm"
	desc = "A mysterious helmet that hums with an unearthly power."
	icon_state = "magus"
	item_state = "magus"
	item_state_slots = list(
		slot_l_hand_str = "helmet",
		slot_r_hand_str = "helmet",
		)
	siemens_coefficient = 0.8
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/head/wizard/amp
	name = "psychic amplifier"
	desc = "A crown-of-thorns psychic amplifier. Kind of looks like a tiara having sex with an industrial robot."
	icon_state = "amp"
	item_state_slots = list(
		slot_l_hand_str = "helmet",
		slot_r_hand_str = "helmet",
		)

/obj/item/clothing/head/wizard/cap
	name = "Gentlemans Cap"
	desc = "A checkered gray flat cap woven together with the rarest of threads."
	icon_state = "gentcap"
	item_state_slots = list(
		slot_l_hand_str = "det_hat",
		slot_r_hand_str = "det_hat",
		)
	siemens_coefficient = 0.8

/obj/item/clothing/suit/wizrobe
	name = "wizard robe"
	desc = "A magnificant, gem-lined robe that seems to radiate power."
	icon_state = "wizard"
	item_state = "wizrobe"
	gas_transfer_coefficient = 0.01 // IT'S MAGICAL OKAY JEEZ +1 TO NOT DIE
	permeability_coefficient = 0.01
	armor  = list(
		DAM_BLUNT 	= 30,
		DAM_PIERCE 	= 20,
		DAM_CUT 	= 30,
		DAM_BULLET 	= 20,
		DAM_LASER 	= 20,
		DAM_ENERGY 	= 20,
		DAM_BURN 	= 10,
		DAM_BOMB 	= 20,
		DAM_EMP 	= 0,
		DAM_BIO 	= 20,
		DAM_RADS 	= 20,
		DAM_STUN 	= 0)
	allowed = list(/obj/item/weapon/teleportation_scroll)
	siemens_coefficient = 0.8
	wizard_garb = 1

/obj/item/clothing/suit/wizrobe/red
	name = "red wizard robe"
	desc = "A magnificant, red, gem-lined robe that seems to radiate power."
	icon_state = "redwizard"
	item_state = "redwizrobe"


/obj/item/clothing/suit/wizrobe/marisa
	name = "Witch Robe"
	desc = "Magic is all about the spell power, ZE!"
	icon_state = "marisa"
	item_state = "marisarobe"

/obj/item/clothing/suit/wizrobe/magusblue
	name = "Magus Robe"
	desc = "A set of armoured robes that seem to radiate a dark power."
	icon_state = "magusblue"
	item_state = "magusblue"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS|LEGS|FEET

/obj/item/clothing/suit/wizrobe/magusred
	name = "Magus Robe"
	desc = "A set of armoured robes that seem to radiate a dark power."
	icon_state = "magusred"
	item_state = "magusred"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS|LEGS|FEET

/obj/item/clothing/suit/wizrobe/psypurple
	name = "purple robes"
	desc = "Heavy, royal purple robes threaded with psychic amplifiers and weird, bulbous lenses. Do not machine wash."
	icon_state = "psyamp"
	item_state = "psyamp"
	gender = PLURAL

/obj/item/clothing/suit/wizrobe/gentlecoat
	name = "Gentlemans Coat"
	desc = "A heavy threaded tweed gray jacket. For a different sort of Gentleman."
	icon_state = "gentlecoat"
	item_state = "gentlecoat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

//Cosmetic wizard wear below
/obj/item/clothing/head/wizard/fake
	siemens_coefficient = 1.0

/obj/item/clothing/suit/wizrobe/old/fake
	name = "wizard robe"
	desc = "A rather dull, blue robe meant to mimick real wizard robes."
	icon_state = "wizard"
	item_state = "wizrobe"
	gas_transfer_coefficient = 1
	permeability_coefficient = 1
	armor  = list(
		DAM_BLUNT 	= 0,
		DAM_PIERCE 	= 0,
		DAM_CUT 	= 2,
		DAM_BULLET 	= 0,
		DAM_LASER 	= 0,
		DAM_ENERGY 	= 0,
		DAM_BURN 	= 2,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)
	siemens_coefficient = 1.0

/obj/item/clothing/suit/wizrobe/fake
	name = "wizard robe"
	desc = "A rather dull, blue robe meant to mimick real wizard robes."
	icon_state = "wizard-fake"
	item_state = "wizrobe"
	gas_transfer_coefficient = 1
	permeability_coefficient = 1
	armor  = list(
		DAM_BLUNT 	= 0,
		DAM_PIERCE 	= 0,
		DAM_CUT 	= 2,
		DAM_BULLET 	= 0,
		DAM_LASER 	= 0,
		DAM_ENERGY 	= 0,
		DAM_BURN 	= 2,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)
	siemens_coefficient = 1.0

/obj/item/clothing/head/wizard/red/fake
	siemens_coefficient = 1.0

/obj/item/clothing/suit/wizrobe/red/fake
	gas_transfer_coefficient = 1
	permeability_coefficient = 1
	armor  = list(
		DAM_BLUNT 	= 0,
		DAM_PIERCE 	= 0,
		DAM_CUT 	= 2,
		DAM_BULLET 	= 0,
		DAM_LASER 	= 0,
		DAM_ENERGY 	= 0,
		DAM_BURN 	= 2,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)
	siemens_coefficient = 1.0

/obj/item/clothing/head/wizard/marisa/fake
	name = "Witch Hat"
	desc = "Strange-looking hat-wear, makes you want to cast fireballs."
	icon_state = "marisa"
	siemens_coefficient = 1.0

/obj/item/clothing/suit/wizrobe/marisa/fake
	name = "Witch Robe"
	desc = "Magic is all about the spell power, ZE!"
	icon_state = "marisa"
	item_state = "marisarobe"
	gas_transfer_coefficient = 1
	permeability_coefficient = 1
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	armor  = list(
		DAM_BLUNT 	= 0,
		DAM_PIERCE 	= 0,
		DAM_CUT 	= 2,
		DAM_BULLET 	= 0,
		DAM_LASER 	= 0,
		DAM_ENERGY 	= 0,
		DAM_BURN 	= 2,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)
	siemens_coefficient = 1.0

/obj/item/clothing/head/wizard/magus/fake
	siemens_coefficient = 1.0

/obj/item/clothing/suit/wizrobe/magusblue/fake
	gas_transfer_coefficient = 1
	permeability_coefficient = 1
	armor  = list(
		DAM_BLUNT 	= 0,
		DAM_PIERCE 	= 0,
		DAM_CUT 	= 2,
		DAM_BULLET 	= 0,
		DAM_LASER 	= 0,
		DAM_ENERGY 	= 0,
		DAM_BURN 	= 2,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)
	siemens_coefficient = 1.0

/obj/item/clothing/suit/wizrobe/magusred/fake
	gas_transfer_coefficient = 1
	permeability_coefficient = 1
	armor  = list(
		DAM_BLUNT 	= 0,
		DAM_PIERCE 	= 0,
		DAM_CUT 	= 2,
		DAM_BULLET 	= 0,
		DAM_LASER 	= 0,
		DAM_ENERGY 	= 0,
		DAM_BURN 	= 2,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)
	siemens_coefficient = 1.0

/obj/item/clothing/head/wizard/amp/fake
	siemens_coefficient = 1.0

/obj/item/clothing/suit/wizrobe/psypurple/fake
	gas_transfer_coefficient = 1
	permeability_coefficient = 1
	armor  = list(
		DAM_BLUNT 	= 0,
		DAM_PIERCE 	= 0,
		DAM_CUT 	= 2,
		DAM_BULLET 	= 0,
		DAM_LASER 	= 0,
		DAM_ENERGY 	= 0,
		DAM_BURN 	= 2,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)
	siemens_coefficient = 1.0

/obj/item/clothing/head/wizard/cap/fake
	siemens_coefficient = 1.0

/obj/item/clothing/suit/wizrobe/gentlecoat/fake
	gas_transfer_coefficient = 1
	permeability_coefficient = 1
	armor  = list(
		DAM_BLUNT 	= 0,
		DAM_PIERCE 	= 0,
		DAM_CUT 	= 2,
		DAM_BULLET 	= 0,
		DAM_LASER 	= 0,
		DAM_ENERGY 	= 0,
		DAM_BURN 	= 2,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)
	siemens_coefficient = 1.0
