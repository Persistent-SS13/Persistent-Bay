/obj/item/weapon/rig/combat
	name = "combat hardsuit control module"
	desc = "A sleek and dangerous hardsuit for active combat."
	icon_state = "security_rig"
	suit_type = "combat hardsuit"
	armor  = list(
		DAM_BLUNT 	= 80,
		DAM_PIERCE 	= 70,
		DAM_CUT 	= 80,
		DAM_BULLET 	= 65,
		DAM_LASER 	= 55,
		DAM_ENERGY 	= 15,
		DAM_BURN 	= 40,
		DAM_BOMB 	= 80,
		DAM_EMP 	= 10,
		DAM_BIO 	= 100,
		DAM_RADS 	= 60,
		DAM_STUN 	= 5)
	online_slowdown = 1
	offline_slowdown = 3
	offline_vision_restriction = TINT_HEAVY
	allowed = list(/obj/item/device/flashlight, /obj/item/weapon/tank,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/handcuffs,/obj/item/device/t_scanner, /obj/item/weapon/rcd, /obj/item/weapon/tool/crowbar, \
	/obj/item/weapon/tool/screwdriver, /obj/item/weapon/tool/weldingtool, /obj/item/weapon/tool/wirecutters, /obj/item/weapon/tool/wrench, /obj/item/device/multitool, \
	/obj/item/device/radio, /obj/item/device/analyzer,/obj/item/weapon/storage/briefcase/inflatable, /obj/item/weapon/melee/baton, /obj/item/weapon/gun, \
	/obj/item/weapon/storage/firstaid, /obj/item/weapon/reagent_containers/hypospray, /obj/item/roller, /obj/item/device/suit_cooling_unit)

	chest_type = /obj/item/clothing/suit/space/rig/combat
	helm_type = /obj/item/clothing/head/helmet/space/rig/combat
	boot_type = /obj/item/clothing/shoes/magboots/rig/combat
	glove_type = /obj/item/clothing/gloves/rig/combat

/obj/item/clothing/head/helmet/space/rig/combat
	light_overlay = "helmet_light_dual_green"
	species_restricted = list(SPECIES_HUMAN)

/obj/item/clothing/suit/space/rig/combat
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL)

/obj/item/clothing/shoes/magboots/rig/combat
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL)

/obj/item/clothing/gloves/rig/combat
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL)

/obj/item/weapon/rig/combat/equipped
	initial_modules = list(
		/obj/item/rig_module/mounted/egun,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/chem_dispenser/combat
		)

//Extremely OP, hardly standard issue equipment
//Now a little less OP
/obj/item/weapon/rig/military
	name = "military hardsuit control module"
	desc = "An austere hardsuit used by paramilitary groups and real soldiers alike."
	icon_state = "military_rig"
	suit_type = "military hardsuit"
	armor  = list(
		DAM_BLUNT 	= 80,
		DAM_PIERCE 	= 75,
		DAM_CUT 	= 90,
		DAM_BULLET 	= 75,
		DAM_LASER 	= 60,
		DAM_ENERGY 	= 15,
		DAM_BURN 	= 40,
		DAM_BOMB 	= 80,
		DAM_EMP 	= 10,
		DAM_BIO 	= 100,
		DAM_RADS 	= 30,
		DAM_STUN 	= 5)
	online_slowdown = 1
	offline_slowdown = 3
	offline_vision_restriction = TINT_HEAVY
	allowed = list(/obj/item/device/flashlight, /obj/item/weapon/tank,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/handcuffs,/obj/item/device/t_scanner, /obj/item/weapon/rcd, /obj/item/weapon/tool/crowbar, \
	/obj/item/weapon/tool/screwdriver, /obj/item/weapon/tool/weldingtool, /obj/item/weapon/tool/wirecutters, /obj/item/weapon/tool/wrench, /obj/item/device/multitool, \
	/obj/item/device/radio, /obj/item/device/analyzer,/obj/item/weapon/storage/briefcase/inflatable, /obj/item/weapon/melee/baton, /obj/item/weapon/gun, \
	/obj/item/weapon/storage/firstaid, /obj/item/weapon/reagent_containers/hypospray, /obj/item/roller, /obj/item/device/suit_cooling_unit)

	chest_type = /obj/item/clothing/suit/space/rig/military
	helm_type = /obj/item/clothing/head/helmet/space/rig/military
	boot_type = /obj/item/clothing/shoes/magboots/rig/military
	glove_type = /obj/item/clothing/gloves/rig/military

/obj/item/clothing/head/helmet/space/rig/military
	light_overlay = "helmet_light_dual_green"
	species_restricted = list(SPECIES_HUMAN)

/obj/item/clothing/suit/space/rig/military
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL)

/obj/item/clothing/shoes/magboots/rig/military
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL)

/obj/item/clothing/gloves/rig/military
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL)

/obj/item/weapon/rig/military/equipped
	initial_modules = list(
		/obj/item/rig_module/mounted/egun,
		/obj/item/rig_module/vision/multi,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/chem_dispenser/injector
		)
