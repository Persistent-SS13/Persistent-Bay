/obj/item/weapon/robot_module/syndicate
	name = "illegal robot module"
	display_name = "Illegal"
	hide_on_manifest = 1
	upgrade_locked = TRUE
	sprites = list(
		"Dread" = "securityrobot"
	)
	equipment = list(
		/obj/item/device/flash,
		/obj/item/weapon/melee/energy/sword,
		/obj/item/weapon/gun/energy/pulse_rifle/mounted,
		/obj/item/weapon/tool/crowbar,
		/obj/item/weapon/tool/screwdriver,
		/obj/item/weapon/tool/wrench,
		/obj/item/weapon/tool/wirecutters,
		/obj/item/device/multitool,
		/obj/item/weapon/tool/weldingtool/electric,
		/obj/item/weapon/card/emag,
		/obj/item/modular_computer/laptop/preset/custom_loadout/advanced,
		/obj/item/weapon/tank/jetpack/carbondioxide
	)
	var/id

/obj/item/weapon/robot_module/syndicate/build_equipment(var/mob/living/silicon/robot/R)
	. = ..()
	id = R.idcard
	equipment += id

/obj/item/weapon/robot_module/syndicate/finalize_equipment(var/mob/living/silicon/robot/R)
	var/obj/item/weapon/tank/jetpack/carbondioxide/jetpack = locate() in equipment
	R.internals = jetpack
	. = ..()

/obj/item/weapon/robot_module/syndicate/Destroy()
	equipment -= id
	id = null
	. = ..()
