/obj/item/weapon/robot_module/miner
	name = "miner robot module"
	display_name = "Miner"
	subsystems = list(
		/datum/nano_module/program/materialmarket,
	)
	channels = list(
		"Supply" = TRUE,
		"Science" = TRUE
	)
	networks = list(
		NETWORK_MINE
	)
	sprites = list(
		"Basic" = "Miner_old",
		"Advanced Droid" = "droid-miner",
		"Treadhead" = "Miner"
	)
	supported_upgrades = list(
		/obj/item/borg/upgrade/jetpack,
		/obj/item/borg/upgrade/floodlight,
	)
	equipment = list(
		/obj/item/device/flash,
		/obj/item/borg/sight/meson,
		/obj/item/weapon/storage/ore,
		/obj/item/weapon/pickaxe/borgdrill,
		/obj/item/weapon/storage/sheetsnatcher/borg,
		/obj/item/weapon/gripper/miner,
		/obj/item/device/scanner/mining,
		/obj/item/weapon/tool/crowbar,
		/obj/item/weapon/tool/wrench,
		/obj/item/weapon/tool/screwdriver,
		/obj/item/weapon/gun/energy/gun/mounted,
		/obj/item/weapon/gun/energy/plasmacutter/mounted,
	)
	emag = /obj/item/weapon/gun/energy/gun/nuclear

// /obj/item/weapon/robot_module/miner/handle_emagged()
// 	var/obj/item/weapon/pickaxe/D = locate(/obj/item/weapon/pickaxe/borgdrill) in equipment
// 	if(D)
// 		equipment -= D
// 		qdel(D)
// 	D = new /obj/item/weapon/pickaxe/diamonddrill(src)
// 	D.canremove = FALSE
// 	equipment += D
