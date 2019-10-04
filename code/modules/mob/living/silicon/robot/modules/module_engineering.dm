/obj/item/weapon/robot_module/engineering
	name = "engineering robot module"
	display_name = "Engineering"
	channels = list(
		"Engineering" = 1
	)
	networks = list(
		NETWORK_ENGINEERING
	)
	subsystems = list(
		/datum/nano_module/power_monitor, 
		/datum/nano_module/supermatter_monitor
	)
	supported_upgrades = list(
		/obj/item/borg/upgrade/rcd
	)
	sprites = list(
		"Basic" = "Engineering",
		"Antique" = "engineerrobot",
		"Landmate" = "landmate",
		"Landmate - Treaded" = "engiborg+tread"
	)
	no_slip = 1
	equipment = list(
		/obj/item/device/flash,
		/obj/item/borg/sight/meson,
		/obj/item/weapon/extinguisher,
		/obj/item/weapon/tool/weldingtool/electric,
		/obj/item/weapon/tool/screwdriver,
		/obj/item/weapon/tool/wrench,
		/obj/item/weapon/tool/crowbar,
		/obj/item/weapon/tool/wirecutters,
		/obj/item/device/multitool,
		/obj/item/device/t_scanner,
		/obj/item/device/scanner/gas,
		/obj/item/device/geiger,
		/obj/item/taperoll/engineering,
		/obj/item/taperoll/atmos,
		/obj/item/weapon/gripper,
		/obj/item/weapon/gripper/no_use/loader,
		/obj/item/device/lightreplacer,
		/obj/item/device/pipe_painter,
		/obj/item/device/floor_painter,
		/obj/item/weapon/inflatable_dispenser/robot,
		/obj/item/inducer/borg,
		/obj/item/weapon/matter_decompiler,
		/obj/item/stack/material/cyborg/steel,
		/obj/item/stack/material/cyborg/aluminium,
		/obj/item/stack/material/rods/cyborg,
		/obj/item/stack/tile/floor/cyborg,
		/obj/item/stack/material/cyborg/glass,
		/obj/item/stack/material/cyborg/glass/reinforced,
		/obj/item/stack/cable_coil/cyborg,
		/obj/item/stack/material/cyborg/plasteel
	)
	synths = list(
		/datum/matter_synth/rechargeable/steel =    60000,
		/datum/matter_synth/rechargeable/aluminium = 60000,
		/datum/matter_synth/rechargeable/glass =    40000,
		/datum/matter_synth/rechargeable/rglass =   40000,
		/datum/matter_synth/rechargeable/plasteel = 20000,
		/datum/matter_synth/rechargeable/wire,
	)
	emag = /obj/item/weapon/melee/baton/robot/electrified_arm

/obj/item/weapon/robot_module/engineering/finalize_synths()

	var/datum/matter_synth/rechargeable/steel/metal =       locate() in synths
	var/datum/matter_synth/rechargeable/aluminium/aluminium =       locate() in synths
	var/datum/matter_synth/rechargeable/glass/glass =       locate() in synths
	var/datum/matter_synth/rechargeable/rglass/rglass =     locate() in synths
	var/datum/matter_synth/rechargeable/plasteel/plasteel = locate() in synths
	var/datum/matter_synth/rechargeable/wire/wire =         locate() in synths

	var/obj/item/weapon/matter_decompiler/MD = locate() in equipment
	MD.connect_matter_synth(MATERIAL_STEEL, metal)
	MD.connect_matter_synth(MATERIAL_ALUMINIUM, aluminium)
	MD.connect_matter_synth(MATERIAL_GLASS, glass)
	MD.connect_matter_synth(MATERIAL_REINFORCED_GLASS, rglass)
	MD.connect_matter_synth(MATERIAL_COPPER, wire)

	for(var/thing in list(
		 /obj/item/stack/material/cyborg/steel,
		 /obj/item/stack/material/rods/cyborg,
		 /obj/item/stack/tile/floor/cyborg,
		))
		var/obj/item/stack/stack = locate(thing) in equipment
		LAZYDISTINCTADD(stack.synths, metal)

	for(var/thing in list(
		 /obj/item/stack/material/cyborg/aluminium,
		))
		var/obj/item/stack/stack = locate(thing) in equipment
		LAZYDISTINCTADD(stack.synths, aluminium)

	for(var/thing in list(
		 /obj/item/stack/material/cyborg/glass
		))
		var/obj/item/stack/stack = locate(thing) in equipment
		LAZYDISTINCTADD(stack.synths, glass)

	for(var/thing in list(
		 /obj/item/stack/material/cyborg/glass/reinforced,
		))
		var/obj/item/stack/stack = locate(thing) in equipment
		LAZYDISTINCTADD(stack.synths, rglass)

	var/obj/item/stack/cable_coil/cyborg/C = locate() in equipment
	C.synths = list(wire)

	var/obj/item/stack/material/cyborg/plasteel/PL = locate() in equipment
	PL.synths = list(plasteel)

/obj/item/weapon/robot_module/engineering/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/device/lightreplacer/LR = locate() in equipment
	LR.Charge(R, amount)
	..()
