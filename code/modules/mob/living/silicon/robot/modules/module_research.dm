/obj/item/weapon/robot_module/research
	name = "research module"
	display_name = "Research"
	channels = list(
		"Science" = TRUE
	)
	networks = list(
		NETWORK_RESEARCH
	)
	sprites = list(
		"Droid" = "droid-science"
	)
	equipment = list(
		/obj/item/device/flash,
		/obj/item/weapon/portable_destructive_analyzer,
		/obj/item/weapon/gripper/research,
		/obj/item/weapon/gripper/no_use/loader,
		/obj/item/device/robotanalyzer,
		/obj/item/device/ano_scanner,
		/obj/item/device/scanner/spectrometer/adv,
		/obj/item/device/scanner/reagent/adv,
		/obj/item/device/scanner/plant,
		/obj/item/device/scanner/xenobio,
		/obj/item/device/multitool,
		/obj/item/weapon/card/robot,
		/obj/item/weapon/tool/wrench,
		/obj/item/weapon/tool/screwdriver,
		/obj/item/weapon/tool/weldingtool/electric,
		/obj/item/weapon/tool/wirecutters,
		/obj/item/weapon/tool/crowbar,
		/obj/item/weapon/scalpel/laser3,
		/obj/item/weapon/circular_saw,
		/obj/item/weapon/extinguisher/mini,
		/obj/item/weapon/reagent_containers/syringe,
		/obj/item/weapon/reagent_containers/dropper/industrial,
		/obj/item/weapon/reagent_containers/spray/chemsprayer,
		/obj/item/weapon/reagent_containers/glass/beaker/large,
		/obj/item/weapon/gripper/chemistry,
		/obj/item/stack/nanopaste,
	)
	synths = list(
		/datum/matter_synth/rechargeable/nanite = 10000
	)
	//emag = /obj/prefab/hand_teleporter

/obj/item/weapon/robot_module/research/finalize_equipment()
	. = ..()
	var/obj/item/stack/nanopaste/N = locate() in equipment
	N.uses_charge = 1
	N.charge_costs = list(1000)

/obj/item/weapon/robot_module/research/finalize_synths()
	. = ..()
	var/datum/matter_synth/rechargeable/nanite/nanite = locate() in synths
	var/obj/item/stack/nanopaste/N = locate() in equipment
	N.synths = list(nanite)
