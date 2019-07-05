/obj/item/clothing/head/helmet/space/rig/merc
	light_overlay = "helmet_light_dual_green"
	camera = /obj/machinery/camera/network/mercenary

/obj/item/weapon/rig/merc
	name = "crimson hardsuit control module"
	desc = "A blood-red hardsuit module with heavy armour plates."
	icon_state = "merc_rig"
	suit_type = "crimson hardsuit"
	armor  = list(
		DAM_BLUNT 	= 80,
		DAM_PIERCE 	= 70,
		DAM_CUT 	= 80,
		DAM_BULLET 	= 65,
		DAM_LASER 	= 65,
		DAM_ENERGY 	= 15,
		DAM_BURN 	= 45,
		DAM_BOMB 	= 80,
		DAM_EMP 	= 5,
		DAM_BIO 	= 100,
		DAM_RADS 	= 60,
		DAM_STUN 	= 0)
	online_slowdown = 1
	offline_slowdown = 3
	offline_vision_restriction = TINT_HEAVY

	helm_type = /obj/item/clothing/head/helmet/space/rig/merc
	glove_type = /obj/item/clothing/gloves/rig/merc
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy/sword,/obj/item/weapon/handcuffs)

	initial_modules = list(
		/obj/item/rig_module/mounted/lcannon,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/fabricator/energy_net
		)

/obj/item/clothing/gloves/rig/merc
	item_flags = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_NOCUFFS

//Has most of the modules removed
/obj/item/weapon/rig/merc/empty
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/electrowarfare_suite,
		)

/obj/item/weapon/rig/merc/heavy
	name = "crimson EOD hardsuit control module"
	desc = "A blood-red hardsuit with heavy armoured plates. Judging by the abnormally thick plates, this one is for working with explosives."
	icon_state = "merc_rig_heavy"
	armor  = list(
		DAM_BLUNT 	= 90,
		DAM_PIERCE 	= 80,
		DAM_CUT 	= 90,
		DAM_BULLET 	= 80,
		DAM_LASER 	= 80,
		DAM_ENERGY 	= 25,
		DAM_BURN 	= 65,
		DAM_BOMB 	= 90,
		DAM_EMP 	= 10,
		DAM_BIO 	= 100,
		DAM_RADS 	= 70,
		DAM_STUN 	= 5)
	online_slowdown = 3
	offline_slowdown = 4

/obj/item/weapon/rig/merc/heavy/empty
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/electrowarfare_suite,
		)
