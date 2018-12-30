//Pouches
/obj/item/clothing/accessory/storage/pouches
	name = "storage pouches"
	desc = "A collection of black pouches that can be attached to a plate carrier. Carries up to two items."
	icon_override = 'icons/mob/modular_armor.dmi'
	icon = 'icons/obj/clothing/modular_armor.dmi'
	accessory_icons = list(slot_tie_str = 'icons/mob/modular_armor.dmi', slot_wear_suit_str = 'icons/mob/modular_armor.dmi')
	icon_state = "pouches"
	gender = PLURAL
	slot = ACCESSORY_SLOT_ARMOR_S
	slots = 2

/obj/item/clothing/accessory/storage/pouches/blue
	desc = "A collection of blue pouches that can be attached to a plate carrier. Carries up to two items."
	icon_state = "pouches_blue"

/obj/item/clothing/accessory/storage/pouches/navy
	desc = "A collection of navy blue pouches that can be attached to a plate carrier. Carries up to two items."
	icon_state = "pouches_navy"

/obj/item/clothing/accessory/storage/pouches/green
	desc = "A collection of green pouches that can be attached to a plate carrier. Carries up to two items."
	icon_state = "pouches_green"

/obj/item/clothing/accessory/storage/pouches/tan
	desc = "A collection of tan pouches that can be attached to a plate carrier. Carries up to two items."
	icon_state = "pouches_tan"

/obj/item/clothing/accessory/storage/pouches/large
	name = "large storage pouches"
	desc = "A collection of black pouches that can be attached to a plate carrier. Carries up to four items."
	icon_state = "lpouches"
	slots = 4

/obj/item/clothing/accessory/storage/pouches/large/blue
	desc = "A collection of blue pouches that can be attached to a plate carrier. Carries up to four items."
	icon_state = "lpouches_blue"

/obj/item/clothing/accessory/storage/pouches/large/navy
	desc = "A collection of navy blue pouches that can be attached to a plate carrier. Carries up to four items."
	icon_state = "lpouches_navy"

/obj/item/clothing/accessory/storage/pouches/large/green
	desc = "A collection of green pouches that can be attached to a plate carrier. Carries up to four items."
	icon_state = "lpouches_green"

/obj/item/clothing/accessory/storage/pouches/large/tan
	desc = "A collection of tan pouches that can be attached to a plate carrier. Carries up to four items."
	icon_state = "lpouches_tan"

//Armor plates
/obj/item/clothing/accessory/armorplate
	name = "light armor plate"
	desc = "A basic armor plate made of steel-reinforced synthetic fibers. Attaches to a plate carrier."
	icon = 'icons/obj/clothing/modular_armor.dmi'
	icon_state = "armor_light"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	armor  = list(
		DAM_BLUNT 	= 30,
		DAM_PIERCE 	= 25,
		DAM_CUT 	= 30,
		DAM_BULLET 	= 15,
		DAM_LASER 	= 40,
		DAM_ENERGY 	= 10,
		DAM_BURN 	= 10,
		DAM_BOMB 	= 25,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 1)
	slot = ACCESSORY_SLOT_ARMOR_C

/obj/item/clothing/accessory/armorplate/medium
	name = "medium armor plate"
	desc = "A plasteel-reinforced synthetic armor plate, providing good protection. Attaches to a plate carrier."
	icon_state = "armor_medium"
	armor  = list(
		DAM_BLUNT 	= 40,
		DAM_PIERCE 	= 35,
		DAM_CUT 	= 40,
		DAM_BULLET 	= 40,
		DAM_LASER 	= 50,
		DAM_ENERGY 	= 25,
		DAM_BURN 	= 10,
		DAM_BOMB 	= 30,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 2)

/obj/item/clothing/accessory/armorplate/tactical
	name = "tactical armor plate"
	desc = "A medium armor plate with additional ablative coating. Attaches to a plate carrier."
	icon_state = "armor_tactical"
	armor  = list(
		DAM_BLUNT 	= 40,
		DAM_PIERCE 	= 35,
		DAM_CUT 	= 40,
		DAM_BULLET 	= 40,
		DAM_LASER 	= 60,
		DAM_ENERGY 	= 40,
		DAM_BURN 	= 40,
		DAM_BOMB 	= 40,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 2)

/obj/item/clothing/accessory/armorplate/merc
	name = "heavy armor plate"
	desc = "A ceramics-reinforced synthetic armor plate, providing state of of the art protection. Attaches to a plate carrier."
	icon_state = "armor_heavy"
	armor  = list(
		DAM_BLUNT 	= 70,
		DAM_PIERCE 	= 65,
		DAM_CUT 	= 70,
		DAM_BULLET 	= 70,
		DAM_LASER 	= 60,
		DAM_ENERGY 	= 40,
		DAM_BURN 	= 35,
		DAM_BOMB 	= 40,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 5)

//Arm guards
/obj/item/clothing/accessory/armguards
	name = "arm guards"
	desc = "A pair of black arm pads reinforced with armor plating. Attaches to a plate carrier."
	icon_override = 'icons/mob/modular_armor.dmi'
	icon = 'icons/obj/clothing/modular_armor.dmi'
	accessory_icons = list(slot_tie_str = 'icons/mob/modular_armor.dmi', slot_wear_suit_str = 'icons/mob/modular_armor.dmi')
	icon_state = "armguards"
	gender = PLURAL
	body_parts_covered = ARMS
	armor  = list(
		DAM_BLUNT 	= 40,
		DAM_PIERCE 	= 35,
		DAM_CUT 	= 40,
		DAM_BULLET 	= 40,
		DAM_LASER 	= 40,
		DAM_ENERGY 	= 25,
		DAM_BURN 	= 25,
		DAM_BOMB 	= 30,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 5)
	slot = ACCESSORY_SLOT_ARMOR_A

/obj/item/clothing/accessory/armguards/blue
	desc = "A pair of blue arm pads reinforced with armor plating. Attaches to a plate carrier."
	icon_state = "armguards_blue"

/obj/item/clothing/accessory/armguards/navy
	desc = "A pair of navy blue arm pads reinforced with armor plating. Attaches to a plate carrier."
	icon_state = "armguards_navy"

/obj/item/clothing/accessory/armguards/green
	desc = "A pair of green arm pads reinforced with armor plating. Attaches to a plate carrier."
	icon_state = "armguards_green"

/obj/item/clothing/accessory/armguards/tan
	desc = "A pair of tan arm pads reinforced with armor plating. Attaches to a plate carrier."
	icon_state = "armguards_tan"

/obj/item/clothing/accessory/armguards/merc
	name = "heavy arm guards"
	desc = "A pair of red-trimmed black arm pads reinforced with heavy armor plating. Attaches to a plate carrier."
	icon_state = "armguards_merc"
	armor  = list(
		DAM_BLUNT 	= 60,
		DAM_PIERCE 	= 55,
		DAM_CUT 	= 60,
		DAM_BULLET 	= 60,
		DAM_LASER 	= 60,
		DAM_ENERGY 	= 40,
		DAM_BURN 	= 25,
		DAM_BOMB 	= 40,
		DAM_EMP 	= 5,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 10)

//Leg guards
/obj/item/clothing/accessory/legguards
	name = "leg guards"
	desc = "A pair of armored leg pads in black. Attaches to a plate carrier."
	icon_override = 'icons/mob/modular_armor.dmi'
	icon = 'icons/obj/clothing/modular_armor.dmi'
	accessory_icons = list(slot_tie_str = 'icons/mob/modular_armor.dmi', slot_wear_suit_str = 'icons/mob/modular_armor.dmi')
	icon_state = "legguards"
	gender = PLURAL
	body_parts_covered = LEGS
	armor  = list(
		DAM_BLUNT 	= 40,
		DAM_PIERCE 	= 35,
		DAM_CUT 	= 40,
		DAM_BULLET 	= 40,
		DAM_LASER 	= 40,
		DAM_ENERGY 	= 25,
		DAM_BURN 	= 25,
		DAM_BOMB 	= 30,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 5)
	slot = ACCESSORY_SLOT_ARMOR_L

/obj/item/clothing/accessory/legguards/blue
	desc = "A pair of armored leg pads in blue. Attaches to a plate carrier."
	icon_state = "legguards_blue"

/obj/item/clothing/accessory/legguards/navy
	desc = "A pair of armored leg pads in navy blue. Attaches to a plate carrier."
	icon_state = "legguards_navy"

/obj/item/clothing/accessory/legguards/green
	desc = "A pair of armored leg pads in green. Attaches to a plate carrier."
	icon_state = "legguards_green"

/obj/item/clothing/accessory/legguards/tan
	desc = "A pair of armored leg pads in tan. Attaches to a plate carrier."
	icon_state = "legguards_tan"

/obj/item/clothing/accessory/legguards/merc
	name = "heavy leg guards"
	desc = "A pair of heavily armored leg pads in red-trimmed black. Attaches to a plate carrier."
	icon_state = "legguards_merc"
	armor  = list(
		DAM_BLUNT 	= 60,
		DAM_PIERCE 	= 55,
		DAM_CUT 	= 60,
		DAM_BULLET 	= 60,
		DAM_LASER 	= 60,
		DAM_ENERGY 	= 40,
		DAM_BURN 	= 25,
		DAM_BOMB 	= 40,
		DAM_EMP 	= 5,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 10)


//Decorative attachments
/obj/item/clothing/accessory/armor/tag
	name = "master armor tag"
	desc = "A collection of various tags for placing on the front of a plate carrier."
	icon_override = 'icons/mob/modular_armor.dmi'
	icon = 'icons/obj/clothing/modular_armor.dmi'
	accessory_icons = list(slot_tie_str = 'icons/mob/modular_armor.dmi', slot_wear_suit_str = 'icons/mob/modular_armor.dmi')
	icon_state = "null"
	slot = ACCESSORY_SLOT_ARMOR_M

/obj/item/clothing/accessory/armor/tag/nt
	name = "\improper CORPORATE SECURITY tag"
	desc = "An armor tag with the words CORPORATE SECURITY printed in red lettering on it."
	icon_state = "nanotag"

/obj/item/clothing/accessory/armor/tag/pcrc
	name = "\improper PCRC tag"
	desc = "An armor tag with the words PROXIMA CENTAURI RISK CONTROL printed in cyan lettering on it."
	icon_state = "pcrctag"

/obj/item/clothing/accessory/armor/tag/saare
	name = "\improper SAARE tag"
	desc = "An armor tag with the acronym SAARE printed in olive-green lettering on it."
	icon_state = "saaretag"

/obj/item/clothing/accessory/armor/tag/press
	name = "\improper PRESS tag"
	desc = "A tag with the word PRESS printed in white lettering on it."
	icon_state = "presstag"
	slot_flags = SLOT_BELT

/obj/item/clothing/accessory/armor/tag/opos
	name = "\improper O+ blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as O POSITIVE."
	icon_state = "opostag"

/obj/item/clothing/accessory/armor/tag/oneg
	name = "\improper O- blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as O NEGATIVE."
	icon_state = "onegtag"

/obj/item/clothing/accessory/armor/tag/apos
	name = "\improper A+ blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as A POSITIVE."
	icon_state = "apostag"

/obj/item/clothing/accessory/armor/tag/aneg
	name = "\improper A- blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as A NEGATIVE."
	icon_state = "anegtag"

/obj/item/clothing/accessory/armor/tag/bpos
	name = "\improper B+ blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as B POSITIVE."
	icon_state = "bpostag"

/obj/item/clothing/accessory/armor/tag/bneg
	name = "\improper B- blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as B NEGATIVE."
	icon_state = "bnegtag"

/obj/item/clothing/accessory/armor/tag/abpos
	name = "\improper AB+ blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as AB POSITIVE."
	icon_state = "abpostag"

/obj/item/clothing/accessory/armor/tag/abneg
	name = "\improper AB- blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as AB NEGATIVE."
	icon_state = "abnegtag"
