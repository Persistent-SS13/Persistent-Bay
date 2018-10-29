//Engineering softsuit
/obj/item/clothing/head/helmet/space/engineering
	name = "engineering softsuit helmet"
	icon_state = "eng_softhelm"
	desc = "A flimsy helmet with basic radiation shielding. Its visor protects the user from bright UV lights."
	item_state_slots = list(
		slot_l_hand_str = "eng_helm",
		slot_r_hand_str = "eng_helm",
		)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 30)

/obj/item/clothing/suit/space/engineering
	name = "engineering softsuit"
	icon_state = "eng_softsuit"
	desc = "A general use softsuit. The cloth fibers on this suit can protect the user from minor amounts of radiation."
	item_state_slots = list(
		slot_l_hand_str = "eng_voidsuit",
		slot_r_hand_str = "eng_voidsuit",
	)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 30)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/toolbox,/obj/item/weapon/storage/briefcase/inflatable,/obj/item/device/t_scanner)

//Security softsuit
/obj/item/clothing/head/helmet/space/security
	name = "security softsuit helmet"
	icon_state = "sec_softhelm"
	desc = "A flimsy helmet equipped with heat-resistent fabric."
	item_state_slots = list(
		slot_l_hand_str = "sec_helm",
		slot_r_hand_str = "sec_helm",
		)
	armor = list(melee = 5, bullet = 0, laser = 10, energy = 0, bomb = 0, bio = 50, rad = 0) //soft fabric will not stop bullets
	siemens_coefficient = 0.8 //barely stronger than average softsuits, slightly weaker than sec voidsuits

/obj/item/clothing/suit/space/security
	name = "security softsuit"
	icon_state = "sec_softsuit"
	desc = "A general use softsuit equipped with heat-resistent fabric."
	item_state_slots = list(
		slot_l_hand_str = "sec_voidsuit",
		slot_r_hand_str = "sec_voidsuit",
	)
	armor = list(melee = 5, bullet = 0, laser = 10, energy = 0, bomb = 0, bio = 50, rad = 0) //soft fabric will not stop bullets
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency,/obj/item/device/suit_cooling_unit,/obj/item/weapon/melee/baton) //maybe allow small weapons to fit in the suit slot
	siemens_coefficient = 0.8 //barely stronger than average softsuits, slightly weaker than sec voidsuits

//Medical softsuit
/obj/item/clothing/head/helmet/space/medical
	name = "medical softsuit helmet"
	icon_state = "med_softhelm"
	desc = "A flimsy helmet that protects the user just enough to be considered spaceworthy."
	item_state_slots = list(
		slot_l_hand_str = "medical_helm",
		slot_r_hand_str = "medical_helm",
		)
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 100, rad = 0)

/obj/item/clothing/suit/space/medical
	name = "medical softsuit"
	icon_state = "med_softsuit"
	desc = "A general use softsuit that sacrafices some (presumably) non-essential systems in turn for enhanced mobility."
	item_state_slots = list(
		slot_l_hand_str = "medical_voidsuit",
		slot_r_hand_str = "medical_voidsuit",
	)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/firstaid,/obj/item/device/healthanalyzer,/obj/item/stack/medical)
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 100, rad = 0)

/obj/item/clothing/suit/space/void/medical/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 0.5

//Mining softsuit
/obj/item/clothing/head/helmet/space/mining
	name = "mining softsuit helmet"
	icon_state = "miner_softhelm"
	desc = "A flimsy helmet with extra thick fabric, you still aren't if it'll be enough to protect you."
	item_state_slots = list(
		slot_l_hand_str = "mining_helm",
		slot_r_hand_str = "mining_helm",
		)
	armor = list(melee = 15, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 50, rad = 0) //might need a buff if too many miners are dying from single hits from slugs/locusectums

/obj/item/clothing/suit/space/mining
	name = "mining softsuit"
	icon_state = "miner_softsuit"
	desc = "A general use softsuit with extra thick fabric. Something tells you its not thick enough."
	item_state_slots = list(
		slot_l_hand_str = "mining_voidsuit",
		slot_r_hand_str = "mining_voidsuit",
	)
	armor = list(melee = 15, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 50, rad = 0) //might need a buff if too many miners are dying from single hits from slugs/locusectums
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency,/obj/item/stack/flag,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/ore,/obj/item/weapon/pickaxe)

//Science softsuit, we don't have xenoarch but that's the only thing i can base its stats off of
/obj/item/clothing/head/helmet/space/science
	name = "scientist softsuit helmet"
	icon_state = "sci_softhelm"
	desc = "A flimsy helmet that provides basic protection from radiation."
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 10, bomb = 0, bio = 100, rad = 20)

/obj/item/clothing/suit/space/science
	name = "scientist softsuit"
	icon_state = "sci_softsuit"
	desc = "A general use softsuit retrofitted with basic radiation shielding."
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 10, bomb = 0, bio = 100, rad = 20)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency,/obj/item/device/suit_cooling_unit,/obj/item/stack/flag,/obj/item/weapon/storage/excavation,/obj/item/weapon/pickaxe,/obj/item/device/healthanalyzer,/obj/item/device/measuring_tape,/obj/item/device/ano_scanner,/obj/item/device/depth_scanner,/obj/item/device/core_sampler,/obj/item/device/gps,/obj/item/device/beacon_locator,/obj/item/device/radio/beacon,/obj/item/weapon/pickaxe/hand,/obj/item/weapon/storage/bag/fossils)

//Emergency softsuit 
/obj/item/clothing/head/helmet/space/emergency
	name = "emergency softsuit"
	icon_state = "crisis_softhelm"
	desc = "A simple helmet with a built in light, smells like mothballs."
	flash_protection = FLASH_PROTECTION_NONE

/obj/item/clothing/suit/space/emergency
	name = "emergency softsuit"
	icon_state = "crisis_softsuit"
	desc = "A thin, ungainly softsuit colored in blaze orange for rescuers to easily locate, looks pretty fragile."
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 50, rad = 0)
	allowed = list(/obj/item/weapon/tank/emergency)

/obj/item/clothing/suit/space/emergency/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 4
