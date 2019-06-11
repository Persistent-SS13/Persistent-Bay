/obj/item/clothing/suit/bio_suit/anomaly
	name = "Anomaly suit"
	desc = "A suit that protects against exotic alien energies and biological contamination."
	icon_state = "bio_anom"
	item_state = "bio_anom"
	armor  = list(
		DAM_BLUNT 	= 5,
		DAM_PIERCE 	= 1,
		DAM_CUT 	= 5,
		DAM_BULLET 	= 0,
		DAM_LASER 	= 0,
		DAM_ENERGY 	= 60,
		DAM_BURN 	= 50,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 50,
		DAM_BIO 	= 100,
		DAM_RADS 	= 100,
		DAM_STUN 	= 0)

/obj/item/clothing/head/bio_hood/anomaly
	name = "Anomaly hood"
	desc = "A hood that protects the head and face from exotic alien energies and biological contamination."
	icon_state = "bio_anom"
	item_state = "bio_anom"
	armor  = list(
		DAM_BLUNT 	= 5,
		DAM_PIERCE 	= 1,
		DAM_CUT 	= 5,
		DAM_BULLET 	= 0,
		DAM_LASER 	= 0,
		DAM_ENERGY 	= 60,
		DAM_BURN 	= 50,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 50,
		DAM_BIO 	= 100,
		DAM_RADS 	= 100,
		DAM_STUN 	= 0)

/obj/item/clothing/suit/space/void/excavation
	name = "Scientist voidsuit"
	desc = "A voidsuit specially designed to insulate radioactive energy."
	icon_state = "rig-excavation"
	armor  = list(
		DAM_BLUNT 	= 20,
		DAM_PIERCE 	= 15,
		DAM_CUT 	= 20,
		DAM_BULLET 	= 5,
		DAM_LASER 	= 5,
		DAM_ENERGY 	= 40,
		DAM_BURN 	= 30,
		DAM_BOMB 	= 20,
		DAM_EMP 	= 50,
		DAM_BIO 	= 100,
		DAM_RADS 	= 100,
		DAM_STUN 	= 0)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/stack/flag,/obj/item/weapon/storage/excavation,/obj/item/weapon/pickaxe,/obj/item/device/scanner/health,/obj/item/device/measuring_tape,/obj/item/device/ano_scanner,/obj/item/device/depth_scanner,/obj/item/device/core_sampler,/obj/item/device/gps,/obj/item/weapon/pinpointer/radio,/obj/item/device/radio/beacon,/obj/item/weapon/pickaxe/xeno/hand,/obj/item/weapon/storage/bag/fossils)

/obj/item/clothing/head/helmet/space/void/excavation
	name = "Scientist voidsuit helmet"
	desc = "A sophisticated voidsuit helmet, capable of protecting the wearer from radioactive energy."
	icon_state = "rig0-excavation"
	item_state = "excavation-helm"
	armor  = list(
		DAM_BLUNT 	= 20,
		DAM_PIERCE 	= 15,
		DAM_CUT 	= 20,
		DAM_BULLET 	= 5,
		DAM_LASER 	= 5,
		DAM_ENERGY 	= 40,
		DAM_BURN 	= 30,
		DAM_BOMB 	= 20,
		DAM_EMP 	= 50,
		DAM_BIO 	= 100,
		DAM_RADS 	= 100,
		DAM_STUN 	= 0)
	light_overlay = "hardhat_light"

/obj/item/clothing/suit/space/void/excavation/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/excavation
	boots = /obj/item/clothing/shoes/magboots

/obj/item/weapon/storage/belt/archaeology
	name = "excavation gear-belt"
	desc = "Can hold various excavation gear."
	icon_state = "gearbelt"
	item_state = ACCESSORY_SLOT_UTILITY
	can_hold = list(
		/obj/item/weapon/storage/box/samplebags,
		/obj/item/device/core_sampler,
		/obj/item/weapon/pinpointer/radio,
		/obj/item/device/radio/beacon,
		/obj/item/device/gps,
		/obj/item/device/measuring_tape,
		/obj/item/device/flashlight,
		/obj/item/weapon/pickaxe,
		/obj/item/device/depth_scanner,
		/obj/item/device/camera,
		/obj/item/weapon/paper,
		/obj/item/weapon/photo,
		/obj/item/weapon/folder,
		/obj/item/weapon/pen,
		/obj/item/weapon/folder,
		/obj/item/weapon/material/clipboard,
		/obj/item/weapon/anodevice,
		/obj/item/clothing/glasses,
		/obj/item/weapon/tool/wrench,
		/obj/item/weapon/storage/excavation,
		/obj/item/weapon/anobattery,
		/obj/item/device/ano_scanner,
		/obj/item/taperoll,
		/obj/item/weapon/pickaxe/xeno/hand)
