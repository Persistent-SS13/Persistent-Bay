/obj/item/weapon/robot_module/janitor
	name = "janitorial robot module"
	display_name = "Janitor"
	channels = list(
		"Service" = TRUE
	)
	sprites = list(
		"Basic" = "JanBot2",
		"Mopbot"  = "janitorrobot",
		"Mop Gear Rex" = "mopgearrex"
	)
	equipment = list(
		/obj/item/borg/sight/hud/jani,
		/obj/item/device/flash,
		/obj/item/weapon/soap/deluxe,
		/obj/item/weapon/storage/bag/trash,
		/obj/item/weapon/mop/advanced,
		/obj/item/device/lightreplacer,
		/obj/item/device/plunger/robot,
		/obj/item/holosign_creator,
		/obj/item/weapon/gripper/clerical,
		/obj/item/robot_rack/body_bag,
		/obj/item/weapon/reagent_containers/spray/cleaner/drone,
		/obj/item/weapon/tool/crowbar,
		/obj/item/weapon/tool/wrench,
		/obj/item/weapon/tool/screwdriver,
		/obj/item/weapon/extinguisher,
	)
	emag = /obj/item/weapon/reagent_containers/spray

/obj/item/weapon/robot_module/janitor/finalize_emag()
	. = ..()
	emag.reagents.add_reagent(/datum/reagent/lube, 250)
	emag.SetName("Lube spray")

/obj/item/weapon/robot_module/janitor/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	..()
	var/obj/item/device/lightreplacer/LR = locate() in equipment
	LR.Charge(R, amount)
	if(emag)
		var/obj/item/weapon/reagent_containers/spray/S = emag
		S.reagents.add_reagent(/datum/reagent/lube, 20 * amount)
