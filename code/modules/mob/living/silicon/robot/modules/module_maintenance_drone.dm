/obj/item/weapon/robot_module/drone
	name = "drone module"
	hide_on_manifest = 1
	no_slip = 1
	networks = list(
		NETWORK_ENGINEERING
	)
	equipment = list(
		/obj/item/weapon/tool/weldingtool/electric,
		/obj/item/weapon/tool/screwdriver,
		/obj/item/weapon/tool/wrench,
		/obj/item/weapon/tool/crowbar,
		/obj/item/weapon/tool/wirecutters,
		/obj/item/device/multitool,
		/obj/item/device/lightreplacer,
		/obj/item/weapon/gripper,
		/obj/item/weapon/soap,
		/obj/item/weapon/gripper/no_use/loader,
		/obj/item/weapon/extinguisher/mini,
		/obj/item/device/pipe_painter,
		/obj/item/device/floor_painter,
		/obj/item/inducer/borg,
		/obj/item/device/plunger/robot,
		/obj/item/weapon/inflatable_dispenser/robot,
		/obj/item/weapon/reagent_containers/spray/cleaner/drone,
		/obj/item/borg/sight/hud/jani,
		/obj/item/weapon/tank/jetpack/carbondioxide,
		/obj/item/weapon/matter_decompiler,
		/obj/item/stack/material/cyborg/steel,
		/obj/item/stack/material/rods/cyborg,
		/obj/item/stack/tile/floor/cyborg,
		/obj/item/stack/material/cyborg/glass,
		/obj/item/stack/material/cyborg/glass/reinforced,
		/obj/item/stack/tile/wood/cyborg,
		/obj/item/stack/material/cyborg/wood,
		/obj/item/stack/cable_coil/cyborg,
		/obj/item/stack/material/cyborg/plastic
	)
	synths = list(
		/datum/matter_synth/rechargeable/steel =   25000,
		/datum/matter_synth/rechargeable/glass =   25000,
		/datum/matter_synth/rechargeable/rglass =   25000,
		/datum/matter_synth/rechargeable/wood =    2000,
		/datum/matter_synth/rechargeable/plastic = 1000,
		/datum/matter_synth/rechargeable/wire =    30
	)
	emag = /obj/item/weapon/gun/energy/plasmacutter

/obj/item/weapon/robot_module/drone/finalize_equipment(var/mob/living/silicon/robot/R)
	. = ..()
	if(istype(R))
		R.internals = locate(/obj/item/weapon/tank/jetpack/carbondioxide) in equipment

/obj/item/weapon/robot_module/drone/finalize_emag()
	. = ..()
	emag.SetName("Plasma Cutter")

/obj/item/weapon/robot_module/drone/finalize_synths()
	. = ..()
	var/datum/matter_synth/rechargeable/steel/metal =     locate() in synths
	var/datum/matter_synth/rechargeable/glass/glass =     locate() in synths
	var/datum/matter_synth/rechargeable/glass/rglass =     locate() in synths
	var/datum/matter_synth/rechargeable/wood/wood =       locate() in synths
	var/datum/matter_synth/rechargeable/plastic/plastic = locate() in synths
	var/datum/matter_synth/rechargeable/wire/wire =       locate() in synths

	var/obj/item/weapon/matter_decompiler/MD = locate() in equipment
	MD.connect_matter_synth(MATERIAL_STEEL, metal)
	MD.connect_matter_synth(MATERIAL_GLASS, glass)
	MD.connect_matter_synth(MATERIAL_REINFORCED_GLASS, rglass)
	MD.connect_matter_synth(MATERIAL_WOOD, wood)
	MD.connect_matter_synth(MATERIAL_PLASTIC, plastic)
	MD.connect_matter_synth(MATERIAL_COPPER, wire)

	for(var/thing in list(
		 /obj/item/stack/material/cyborg/steel,
		 /obj/item/stack/material/rods/cyborg,
		 /obj/item/stack/tile/floor/cyborg,
		 /obj/item/stack/material/cyborg/glass/reinforced
		))
		var/obj/item/stack/stack = locate(thing) in equipment
		LAZYDISTINCTADD(stack.synths, metal)

	for(var/thing in list(
		 /obj/item/stack/material/cyborg/glass,
		))
		var/obj/item/stack/stack = locate(thing) in equipment
		LAZYDISTINCTADD(stack.synths, glass)

	for(var/thing in list(
		 /obj/item/stack/material/cyborg/glass/reinforced
		))
		var/obj/item/stack/stack = locate(thing) in equipment
		LAZYDISTINCTADD(stack.synths, rglass)

	for(var/thing in list(
		 /obj/item/stack/tile/wood/cyborg,
		 /obj/item/stack/material/cyborg/wood
		))
		var/obj/item/stack/stack = locate(thing) in equipment
		LAZYDISTINCTADD(stack.synths, wood)
	
	var/obj/item/stack/cable_coil/cyborg/C = locate() in equipment
	C.synths = list(wire)

	var/obj/item/stack/material/cyborg/plastic/P = locate() in equipment
	P.synths = list(plastic)

/obj/item/weapon/robot_module/drone/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	..()
	var/obj/item/weapon/reagent_containers/spray/cleaner/drone/SC = locate() in equipment
	SC.reagents.add_reagent(/datum/reagent/space_cleaner, 8 * amount)

/obj/item/weapon/robot_module/drone/construction
	name = "construction drone module"
	hide_on_manifest = 1
	channels = list(
		"Engineering" = 1
	)
	languages = list()

/obj/item/weapon/robot_module/drone/construction/Initialize()
	equipment += /obj/item/weapon/rcd/borg
	. = ..()

/obj/item/weapon/robot_module/drone/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/device/lightreplacer/LR = locate() in equipment
	LR.Charge(R, amount)
	..()
