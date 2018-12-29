// Station voidsuits

//Engineering
/obj/item/clothing/head/helmet/space/void/engineering
	name = "engineering voidsuit helmet"
	desc = "A sturdy looking voidsuit helmet rated to protect against radiation."
	icon_state = "rig0-engineering"
	item_state = "eng_helm"
	item_state_slots = list(
		slot_l_hand_str = "eng_helm",
		slot_r_hand_str = "eng_helm",
		)
	armor  = list(
		DAM_BLUNT 	= 30,
		DAM_PIERCE 	= 20,
		DAM_CUT 	= 30,
		DAM_BULLET 	= 10,
		DAM_LASER 	= 10,
		DAM_ENERGY 	= 5,
		DAM_BURN 	= 25,
		DAM_BOMB 	= 35,
		DAM_EMP 	= 5,
		DAM_BIO 	= 100,
		DAM_RADS 	= 80,
		DAM_STUN 	= 0)

/obj/item/clothing/suit/space/void/engineering
	name = "engineering voidsuit"
	desc = "A run-of-the-mill service voidsuit with all the plating and radiation protection required for industrial work in vacuum."
	icon_state = "rig-engineering"
	item_state_slots = list(
		slot_l_hand_str = "eng_voidsuit",
		slot_r_hand_str = "eng_voidsuit",
	)
	armor  = list(
		DAM_BLUNT 	= 30,
		DAM_PIERCE 	= 20,
		DAM_CUT 	= 30,
		DAM_BULLET 	= 10,
		DAM_LASER 	= 10,
		DAM_ENERGY 	= 5,
		DAM_BURN 	= 25,
		DAM_BOMB 	= 35,
		DAM_EMP 	= 5,
		DAM_BIO 	= 100,
		DAM_RADS 	= 80,
		DAM_STUN 	= 0)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/toolbox,/obj/item/weapon/storage/briefcase/inflatable,/obj/item/device/t_scanner,/obj/item/weapon/rcd)

/obj/item/clothing/suit/space/void/engineering/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 1

/obj/item/clothing/suit/space/void/engineering/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/engineering
	boots = /obj/item/clothing/shoes/magboots

//Mining
/obj/item/clothing/head/helmet/space/void/mining
	name = "mining voidsuit helmet"
	desc = "A scuffed voidsuit helmet with a boosted communication system and reinforced armor plating."
	icon_state = "rig0-mining"
	item_state = "mining_helm"
	item_state_slots = list(
		slot_l_hand_str = "mining_helm",
		slot_r_hand_str = "mining_helm",
		)
	armor  = list(
		DAM_BLUNT 	= 50,
		DAM_PIERCE 	= 40,
		DAM_CUT 	= 50,
		DAM_BULLET 	= 10,
		DAM_LASER 	= 20,
		DAM_ENERGY 	= 10,
		DAM_BURN 	= 25,
		DAM_BOMB 	= 55,
		DAM_EMP 	= 5,
		DAM_BIO 	= 100,
		DAM_RADS 	= 40,
		DAM_STUN 	= 2)
	light_overlay = "helmet_light_dual"

/obj/item/clothing/suit/space/void/mining
	icon_state = "rig-mining"
	name = "mining voidsuit"
	desc = "A grimy, decently armored voidsuit with purple blazes and extra insulation."
	item_state_slots = list(
		slot_l_hand_str = "mining_voidsuit",
		slot_r_hand_str = "mining_voidsuit",
	)
	armor  = list(
		DAM_BLUNT 	= 50,
		DAM_PIERCE 	= 40,
		DAM_CUT 	= 50,
		DAM_BULLET 	= 10,
		DAM_LASER 	= 20,
		DAM_ENERGY 	= 10,
		DAM_BURN 	= 25,
		DAM_BOMB 	= 55,
		DAM_EMP 	= 5,
		DAM_BIO 	= 100,
		DAM_RADS 	= 40,
		DAM_STUN 	= 2)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/stack/flag,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/ore,/obj/item/device/t_scanner,/obj/item/weapon/pickaxe, /obj/item/weapon/rcd)

/obj/item/clothing/suit/space/void/mining/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/mining
	boots = /obj/item/clothing/shoes/magboots

//Medical
/obj/item/clothing/head/helmet/space/void/medical
	name = "medical voidsuit helmet"
	desc = "A bulbous voidsuit helmet with minor radiation shielding and a massive visor."
	icon_state = "rig0-medical"
	item_state = "medical_helm"
	item_state_slots = list(
		slot_l_hand_str = "medical_helm",
		slot_r_hand_str = "medical_helm",
		)
	armor  = list(
		DAM_BLUNT 	= 20,
		DAM_PIERCE 	= 10,
		DAM_CUT 	= 20,
		DAM_BULLET 	= 5,
		DAM_LASER 	= 10,
		DAM_ENERGY 	= 5,
		DAM_BURN 	= 10,
		DAM_BOMB 	= 5,
		DAM_EMP 	= 5,
		DAM_BIO 	= 100,
		DAM_RADS 	= 60,
		DAM_STUN 	= 0)

/obj/item/clothing/suit/space/void/medical
	icon_state = "rig-medical"
	name = "medical voidsuit"
	desc = "A sterile voidsuit with minor radiation shielding and a suite of self-cleaning technology."
	item_state_slots = list(
		slot_l_hand_str = "medical_voidsuit",
		slot_r_hand_str = "medical_voidsuit",
	)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/firstaid,/obj/item/device/healthanalyzer,/obj/item/stack/medical)
	armor  = list(
		DAM_BLUNT 	= 20,
		DAM_PIERCE 	= 10,
		DAM_CUT 	= 20,
		DAM_BULLET 	= 5,
		DAM_LASER 	= 10,
		DAM_ENERGY 	= 5,
		DAM_BURN 	= 10,
		DAM_BOMB 	= 5,
		DAM_EMP 	= 5,
		DAM_BIO 	= 100,
		DAM_RADS 	= 60,
		DAM_STUN 	= 0)

/obj/item/clothing/suit/space/void/medical/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/medical
	boots = /obj/item/clothing/shoes/magboots

//Security
/obj/item/clothing/head/helmet/space/void/security
	name = "security voidsuit helmet"
	desc = "A comfortable voidsuit helmet with cranial armor and eight-channel surround sound."
	icon_state = "rig0-sec"
	item_state = "sec_helm"
	item_state_slots = list(
		slot_l_hand_str = "sec_helm",
		slot_r_hand_str = "sec_helm",
		)
	armor  = list(
		DAM_BLUNT 	= 65,
		DAM_PIERCE 	= 55,
		DAM_CUT 	= 65,
		DAM_BULLET 	= 15,
		DAM_LASER 	= 30,
		DAM_ENERGY 	= 5,
		DAM_BURN 	= 20,
		DAM_BOMB 	= 55,
		DAM_EMP 	= 0,
		DAM_BIO 	= 100,
		DAM_RADS 	= 10,
		DAM_STUN 	= 5)
	siemens_coefficient = 0.7
	light_overlay = "helmet_light_dual"

/obj/item/clothing/suit/space/void/security
	icon_state = "rig-sec"
	name = "security voidsuit"
	desc = "A somewhat clumsy voidsuit layered with impact and laser-resistant armor plating. Specially designed to dissipate minor electrical charges."
	item_state_slots = list(
		slot_l_hand_str = "sec_voidsuit",
		slot_r_hand_str = "sec_voidsuit",
	)
	armor  = list(
		DAM_BLUNT 	= 65,
		DAM_PIERCE 	= 55,
		DAM_CUT 	= 65,
		DAM_BULLET 	= 15,
		DAM_LASER 	= 30,
		DAM_ENERGY 	= 5,
		DAM_BURN 	= 20,
		DAM_BOMB 	= 55,
		DAM_EMP 	= 0,
		DAM_BIO 	= 100,
		DAM_RADS 	= 10,
		DAM_STUN 	= 5)
	allowed = list(/obj/item/weapon/gun,/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/melee/baton)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/space/void/security/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/security
	boots = /obj/item/clothing/shoes/magboots

//Atmospherics
/obj/item/clothing/head/helmet/space/void/atmos
	desc = "A flame-retardant voidsuit helmet with a self-repairing visor and light anti-radiation shielding."
	name = "atmospherics voidsuit helmet"
	icon_state = "rig0-atmos"
	item_state = "atmos_helm"
	item_state_slots = list(
		slot_l_hand_str = "atmos_helm",
		slot_r_hand_str = "atmos_helm",
		)
	armor  = list(
		DAM_BLUNT 	= 30,
		DAM_PIERCE 	= 20,
		DAM_CUT 	= 30,
		DAM_BULLET 	= 15,
		DAM_LASER 	= 20,
		DAM_ENERGY 	= 20,
		DAM_BURN 	= 50,
		DAM_BOMB 	= 35,
		DAM_EMP 	= 5,
		DAM_BIO 	= 100,
		DAM_RADS 	= 50,
		DAM_STUN 	= 0)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	light_overlay = "helmet_light_dual"

/obj/item/clothing/suit/space/void/atmos
	desc = "A durable voidsuit with advanced temperature-regulation systems as well as minor radiation protection. Well worth the price."
	icon_state = "rig-atmos"
	name = "atmos voidsuit"
	item_state_slots = list(
		slot_l_hand_str = "atmos_voidsuit",
		slot_r_hand_str = "atmos_voidsuit",
	)
	armor  = list(
		DAM_BLUNT 	= 30,
		DAM_PIERCE 	= 20,
		DAM_CUT 	= 30,
		DAM_BULLET 	= 15,
		DAM_LASER 	= 20,
		DAM_ENERGY 	= 20,
		DAM_BURN 	= 50,
		DAM_BOMB 	= 35,
		DAM_EMP 	= 5,
		DAM_BIO 	= 100,
		DAM_RADS 	= 50,
		DAM_STUN 	= 0)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/toolbox,/obj/item/weapon/storage/briefcase/inflatable,/obj/item/device/t_scanner,/obj/item/weapon/rcd)

/obj/item/clothing/suit/space/void/atmos/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/atmos
	boots = /obj/item/clothing/shoes/magboots

//Surplus Voidsuits

//Engineering
/obj/item/clothing/head/helmet/space/void/engineering/alt
	name = "reinforced engineering voidsuit helmet"
	desc = "A heavy, radiation-shielded voidsuit helmet with a surprisingly comfortable interior."
	icon_state = "rig0-engineeringalt"
	item_state = "engalt_helm"
	armor  = list(
		DAM_BLUNT 	= 40,
		DAM_PIERCE 	= 30,
		DAM_CUT 	= 40,
		DAM_BULLET 	= 10,
		DAM_LASER 	= 20,
		DAM_ENERGY 	= 20,
		DAM_BURN 	= 40,
		DAM_BOMB 	= 45,
		DAM_EMP 	= 10,
		DAM_BIO 	= 100,
		DAM_RADS 	= 100,
		DAM_STUN 	= 1)
	light_overlay = "helmet_light_dual"

/obj/item/clothing/suit/space/void/engineering/alt
	name = "reinforced engineering voidsuit"
	desc = "A bulky industrial voidsuit. It's a few generations old, but a reliable design and radiation shielding make up for the lack of climate control."
	icon_state = "rig-engineeringalt"
	armor  = list(
		DAM_BLUNT 	= 40,
		DAM_PIERCE 	= 30,
		DAM_CUT 	= 40,
		DAM_BULLET 	= 10,
		DAM_LASER 	= 20,
		DAM_ENERGY 	= 20,
		DAM_BURN 	= 40,
		DAM_BOMB 	= 45,
		DAM_EMP 	= 10,
		DAM_BIO 	= 100,
		DAM_RADS 	= 100,
		DAM_STUN 	= 1)

/obj/item/clothing/suit/space/void/engineering/alt/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 2

/obj/item/clothing/suit/space/void/engineering/alt/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/engineering/alt
	boots = /obj/item/clothing/shoes/magboots

//Mining
/obj/item/clothing/head/helmet/space/void/mining/alt
	name = "reinforced mining voidsuit helmet"
	desc = "An armored voidsuit helmet. Someone must have thought they were pretty cool when they designed a mohawk on it."
	icon_state = "rig0-miningalt"
	item_state = "miningalt_helm"
	armor  = list(
		DAM_BLUNT 	= 65,
		DAM_PIERCE 	= 55,
		DAM_CUT 	= 65,
		DAM_BULLET 	= 20,
		DAM_LASER 	= 20,
		DAM_ENERGY 	= 25,
		DAM_BURN 	= 30,
		DAM_BOMB 	= 55,
		DAM_EMP 	= 0,
		DAM_BIO 	= 100,
		DAM_RADS 	= 40,
		DAM_STUN 	= 5)

/obj/item/clothing/suit/space/void/mining/alt
	icon_state = "rig-miningalt"
	name = "reinforced mining voidsuit"
	desc = "A heavily armored prospecting voidsuit. What it lacks in comfort it makes up for in armor plating and reliability."
	armor  = list(
		DAM_BLUNT 	= 65,
		DAM_PIERCE 	= 55,
		DAM_CUT 	= 65,
		DAM_BULLET 	= 20,
		DAM_LASER 	= 20,
		DAM_ENERGY 	= 25,
		DAM_BURN 	= 30,
		DAM_BOMB 	= 55,
		DAM_EMP 	= 0,
		DAM_BIO 	= 100,
		DAM_RADS 	= 40,
		DAM_STUN 	= 5)

/obj/item/clothing/suit/space/void/mining/alt/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/mining/alt
	boots = /obj/item/clothing/shoes/magboots

//Medical
/obj/item/clothing/head/helmet/space/void/medical/alt
	name = "streamlined medical voidsuit helmet"
	desc = "A lightweight, radiation-shielded voidsuit helmet trimmed in a fetching blue."
	icon_state = "rig0-medicalalt"
	item_state = "medicalalt_helm"
	armor  = list(
		DAM_BLUNT 	= 30,
		DAM_PIERCE 	= 20,
		DAM_CUT 	= 30,
		DAM_BULLET 	= 5,
		DAM_LASER 	= 15,
		DAM_ENERGY 	= 10,
		DAM_BURN 	= 20,
		DAM_BOMB 	= 5,
		DAM_EMP 	= 10,
		DAM_BIO 	= 100,
		DAM_RADS 	= 70,
		DAM_STUN 	= 1)
	light_overlay = "helmet_light_dual_green"

/obj/item/clothing/suit/space/void/medical/alt
	icon_state = "rig-medicalalt"
	name = "streamlined medical voidsuit"
	desc = "A very sleekly designed voidsuit, featuring the latest in radiation shielding technology, without sacrificing comfort or style."
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/firstaid,/obj/item/device/healthanalyzer,/obj/item/stack/medical)
	armor  = list(
		DAM_BLUNT 	= 30,
		DAM_PIERCE 	= 20,
		DAM_CUT 	= 30,
		DAM_BULLET 	= 5,
		DAM_LASER 	= 15,
		DAM_ENERGY 	= 10,
		DAM_BURN 	= 20,
		DAM_BOMB 	= 5,
		DAM_EMP 	= 10,
		DAM_BIO 	= 100,
		DAM_RADS 	= 70,
		DAM_STUN 	= 1)

/obj/item/clothing/suit/space/void/medical/alt/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 0

/obj/item/clothing/suit/space/void/medical/alt/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/medical/alt
	boots = /obj/item/clothing/shoes/magboots

//Security
/obj/item/clothing/head/helmet/space/void/security/alt
	name = "riot security voidsuit helmet"
	desc = "A somewhat tacky voidsuit helmet, a fact mitigated by heavy armor plating."
	icon_state = "rig0-secalt"
	item_state = "secalt_helm"
	armor  = list(
		DAM_BLUNT 	= 70,
		DAM_PIERCE 	= 60,
		DAM_CUT 	= 70,
		DAM_BULLET 	= 40,
		DAM_LASER 	= 45,
		DAM_ENERGY 	= 20,
		DAM_BURN 	= 25,
		DAM_BOMB 	= 55,
		DAM_EMP 	= 10,
		DAM_BIO 	= 100,
		DAM_RADS 	= 10,
		DAM_STUN 	= 5)

/obj/item/clothing/suit/space/void/security/alt
	icon_state = "rig-secalt"
	name = "riot security voidsuit"
	desc = "A heavily armored voidsuit, designed to intimidate people who find black intimidating. Surprisingly slimming."
	armor  = list(
		DAM_BLUNT 	= 70,
		DAM_PIERCE 	= 60,
		DAM_CUT 	= 70,
		DAM_BULLET 	= 40,
		DAM_LASER 	= 45,
		DAM_ENERGY 	= 20,
		DAM_BURN 	= 25,
		DAM_BOMB 	= 55,
		DAM_EMP 	= 10,
		DAM_BIO 	= 100,
		DAM_RADS 	= 10,
		DAM_STUN 	= 5)
	allowed = list(/obj/item/weapon/gun,/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/melee/baton)

/obj/item/clothing/suit/space/void/security/alt/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/security/alt
	boots = /obj/item/clothing/shoes/magboots

//Atmospherics
/obj/item/clothing/head/helmet/space/void/atmos/alt
	desc = "A voidsuit helmet plated with an expensive heat and radiation resistant ceramic."
	name = "heavy duty atmospherics voidsuit helmet"
	icon_state = "rig0-atmosalt"
	item_state = "atmosalt_helm"
	armor  = list(
		DAM_BLUNT 	= 40,
		DAM_PIERCE 	= 30,
		DAM_CUT 	= 40,
		DAM_BULLET 	= 10,
		DAM_LASER 	= 25,
		DAM_ENERGY 	= 30,
		DAM_BURN 	= 80,
		DAM_BOMB 	= 45,
		DAM_EMP 	= 20,
		DAM_BIO 	= 100,
		DAM_RADS 	= 55,
		DAM_STUN 	= 1)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	light_overlay = "hardhat_light"

/obj/item/clothing/suit/space/void/atmos/alt
	desc = "An expensive voidsuit, rated to withstand extreme heat and even minor radiation without exceeding room temperature within."
	icon_state = "rig-atmosalt"
	name = "heavy duty atmos voidsuit"
	armor  = list(
		DAM_BLUNT 	= 40,
		DAM_PIERCE 	= 30,
		DAM_CUT 	= 40,
		DAM_BULLET 	= 10,
		DAM_LASER 	= 25,
		DAM_ENERGY 	= 30,
		DAM_BURN 	= 80,
		DAM_BOMB 	= 45,
		DAM_EMP 	= 20,
		DAM_BIO 	= 100,
		DAM_RADS 	= 55,
		DAM_STUN 	= 1)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/space/void/atmos/alt/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/atmos/alt
	boots = /obj/item/clothing/shoes/magboots

//Exploration
/obj/item/clothing/head/helmet/space/void/exploration
	name = "purple voidsuit helmet"
	desc = "A lightweight helmet designed to accommodate only the most opulent space explorers."
	icon_state = "helm_explorer"
	item_state = "helm_explorer"
	armor  = list(
		DAM_BLUNT 	= 50,
		DAM_PIERCE 	= 40,
		DAM_CUT 	= 50,
		DAM_BULLET 	= 10,
		DAM_LASER 	= 25,
		DAM_ENERGY 	= 20,
		DAM_BURN 	= 15,
		DAM_BOMB 	= 55,
		DAM_EMP 	= 20,
		DAM_BIO 	= 100,
		DAM_RADS 	= 50,
		DAM_STUN 	= 0)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	light_overlay = "explorer_light"

/obj/item/clothing/suit/space/void/exploration
	name = "purple voidsuit"
	desc = "A lightweight, general use voidsuit padded with soft cushioning to provide maximum comfort in the depths of space."
	icon_state = "void_explorer"
	item_state = "void_explorer"
	armor  = list(
		DAM_BLUNT 	= 50,
		DAM_PIERCE 	= 40,
		DAM_CUT 	= 50,
		DAM_BULLET 	= 10,
		DAM_LASER 	= 25,
		DAM_ENERGY 	= 20,
		DAM_BURN 	= 15,
		DAM_BOMB 	= 55,
		DAM_EMP 	= 20,
		DAM_BIO 	= 100,
		DAM_RADS 	= 50,
		DAM_STUN 	= 0)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/stack/flag,/obj/item/device/healthanalyzer,/obj/item/device/gps,/obj/item/device/beacon_locator,/obj/item/device/radio/beacon,/obj/item/weapon/material/hatchet/machete,/obj/item/weapon/shovel)

/obj/item/clothing/suit/space/void/exploration/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/exploration
	boots = /obj/item/clothing/shoes/magboots

//Misc
/obj/item/clothing/head/helmet/space/void/engineering/salvage
	name = "salvaged voidsuit helmet"
	desc = "A hand-me-down salvage voidsuit helmet. It has obviously had a lot of repair work done to it, and is fitted with radiation shielding."
	icon_state = "rig0-salvage"
	item_state = "salvage_helm"
	item_state_slots = list(
		slot_l_hand_str = "eng_helm",
		slot_r_hand_str = "eng_helm",
		)
	armor  = list(
		DAM_BLUNT 	= 25,
		DAM_PIERCE 	= 20,
		DAM_CUT 	= 25,
		DAM_BULLET 	= 10,
		DAM_LASER 	= 15,
		DAM_ENERGY 	= 10,
		DAM_BURN 	= 25,
		DAM_BOMB 	= 20,
		DAM_EMP 	= 0,
		DAM_BIO 	= 100,
		DAM_RADS 	= 50,
		DAM_STUN 	= 0)

/obj/item/clothing/suit/space/void/engineering/salvage
	name = "salvaged voidsuit"
	desc = "A hand-me-down salvage voidsuit. It has obviously had a lot of repair work done to it, and is fitted with radiation shielding."
	icon_state = "rig-salvage"
	item_state_slots = list(
		slot_l_hand_str = "eng_voidsuit",
		slot_r_hand_str = "eng_voidsuit",
	)
	armor  = list(
		DAM_BLUNT 	= 25,
		DAM_PIERCE 	= 20,
		DAM_CUT 	= 25,
		DAM_BULLET 	= 10,
		DAM_LASER 	= 15,
		DAM_ENERGY 	= 10,
		DAM_BURN 	= 25,
		DAM_BOMB 	= 20,
		DAM_EMP 	= 0,
		DAM_BIO 	= 100,
		DAM_RADS 	= 50,
		DAM_STUN 	= 0)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/toolbox,/obj/item/weapon/storage/briefcase/inflatable,/obj/item/device/t_scanner,/obj/item/weapon/rcd)

/obj/item/clothing/suit/space/void/engineering/salvage/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/engineering/salvage
	boots = /obj/item/clothing/shoes/magboots

//Pilot
/obj/item/clothing/head/helmet/space/void/pilot
	desc = "A general use voidsuit helmet for space exploration."
	name = "red voidsuit helmet"
	icon_state = "rig0_pilot"
	item_state = "pilot_helm"
	armor  = list(
		DAM_BLUNT 	= 40,
		DAM_PIERCE 	= 30,
		DAM_CUT 	= 40,
		DAM_BULLET 	= 10,
		DAM_LASER 	= 20,
		DAM_ENERGY 	= 10,
		DAM_BURN 	= 20,
		DAM_BOMB 	= 20,
		DAM_EMP 	= 5,
		DAM_BIO 	= 100,
		DAM_RADS 	= 50,
		DAM_STUN 	= 0)
	light_overlay = "helmet_light_dual"

/obj/item/clothing/suit/space/void/pilot
	desc = "A general use voidsuit for space exploration."
	icon_state = "rig-pilot"
	item_state = "rig-pilot"
	name = "red voidsuit"
	armor  = list(
		DAM_BLUNT 	= 40,
		DAM_PIERCE 	= 30,
		DAM_CUT 	= 40,
		DAM_BULLET 	= 10,
		DAM_LASER 	= 20,
		DAM_ENERGY 	= 10,
		DAM_BURN 	= 20,
		DAM_BOMB 	= 20,
		DAM_EMP 	= 5,
		DAM_BIO 	= 100,
		DAM_RADS 	= 50,
		DAM_STUN 	= 0)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/toolbox,/obj/item/weapon/storage/briefcase/inflatable,/obj/item/device/t_scanner,/obj/item/weapon/rcd)

/obj/item/clothing/suit/space/void/pilot/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/pilot
	boots = /obj/item/clothing/shoes/magboots
