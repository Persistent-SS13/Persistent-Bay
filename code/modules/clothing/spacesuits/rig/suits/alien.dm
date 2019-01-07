/obj/item/weapon/rig/unathi
	name = "NT breacher chassis control module"
	desc = "A cheap NT knock-off of an Unathi battle-rig. Looks like a fish, moves like a fish, steers like a cow."
	suit_type = "NT breacher"
	icon_state = "breacher_rig_cheap"
	armor  = list(
		DAM_BLUNT 	= 60,
		DAM_PIERCE 	= 50,
		DAM_CUT 	= 60,
		DAM_BULLET 	= 60,
		DAM_LASER 	= 60,
		DAM_ENERGY 	= 60,
		DAM_BURN 	= 50,
		DAM_BOMB 	= 70,
		DAM_EMP 	= 20,
		DAM_BIO 	= 100,
		DAM_RADS 	= 50,
		DAM_STUN 	= 5)
	emp_protection = -20
	online_slowdown = 6
	offline_slowdown = 10
	vision_restriction = TINT_HEAVY
	offline_vision_restriction = TINT_BLIND

	chest_type = /obj/item/clothing/suit/space/rig/unathi
	helm_type = /obj/item/clothing/head/helmet/space/rig/unathi
	boot_type = /obj/item/clothing/shoes/magboots/rig/unathi
	glove_type = /obj/item/clothing/gloves/rig/unathi

/obj/item/weapon/rig/unathi/fancy
	name = "breacher chassis control module"
	desc = "An authentic Unathi breacher chassis. Huge, bulky and absurdly heavy. It must be like wearing a tank."
	suit_type = "breacher chassis"
	icon_state = "breacher_rig"
	armor = list(
		DAM_BLUNT  	= 90,
		DAM_PIERCE 	= 90,
		DAM_CUT 	= 85,
		DAM_BULLET 	= 90,
		DAM_ENERGY 	= 90,
		DAM_BURN 	= 90,
		DAM_BOMB 	= 90,
		DAM_EMP 	= 50,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= 80,
		DAM_STUN 	= 70,
		DAM_PAIN	= 70,
		DAM_CLONE   = 70) //Takes TEN TIMES as much damage to stop someone in a breacher. In exchange, it's slow.
	vision_restriction = TINT_NONE //Still blind when offline. It is fully armoured after all

/obj/item/clothing/head/helmet/space/rig/unathi
	species_restricted = list(SPECIES_UNATHI)
	force = 5
	sharpness = 1 //poking people with the horn
	damtype = DAM_PIERCE

/obj/item/clothing/suit/space/rig/unathi
	species_restricted = list(SPECIES_UNATHI)

/obj/item/clothing/shoes/magboots/rig/unathi
	species_restricted = list(SPECIES_UNATHI)
	
/obj/item/clothing/gloves/rig/unathi
	species_restricted = list(SPECIES_UNATHI)
