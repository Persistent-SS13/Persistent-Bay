// Unobtainable
/obj/item/weapon/circuitboard/fabricator
	name = "Circuit board (Fabricator)"
	build_path = /obj/machinery/fabricator/
	board_type = "machine"
	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 2,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)
	var/list/unlocked_techs = list()




/obj/item/weapon/circuitboard/fabricator/medicalfab
	name = "Circuit board (Medical Fabricator)"
	build_path = /obj/machinery/fabricator/medical_fabricator
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 2,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1,
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/weapon/reagent_containers/glass/beaker = 1
							)

/datum/design/circuit/medicalfab
	name = "medical fabricator"
	id = "medicalfab"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/fabricator/medicalfab




/obj/item/weapon/circuitboard/fabricator/consumerfab
	name = "Circuit board (Consumer Goods Fabricator)"
	build_path = /obj/machinery/fabricator/consumer_fabricator

/datum/design/circuit/consumerfab
	name = "consumer fabricator"
	id = "consumerfab"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/fabricator/consumerfab


/obj/item/weapon/circuitboard/fabricator/storagefab
	name = "Circuit board (Storage Fabricator)"
	build_path = /obj/machinery/fabricator/storage_fabricator


/datum/design/circuit/vending
	name = "vending machine"
	id = "vending machine"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/vending_machine


/datum/design/circuit/storagefabricator
	name = "storage fabricator"
	build_path = /obj/item/weapon/circuitboard/fabricator/storagefab

/obj/item/weapon/circuitboard/fabricator/sciencefab
	name = "Circuit board (Science Fabricator)"
	build_path = /obj/machinery/fabricator/science_fabricator


/datum/design/circuit/sciencefabricator
	name = "science fabricator"
	build_path = /obj/item/weapon/circuitboard/fabricator/sciencefab



/obj/item/weapon/circuitboard/fabricator/servicefab
	name = "Circuit board (Service Fabricator)"
	build_path = /obj/machinery/fabricator/service_fabricator

/datum/design/circuit/servicefabricator
	name = "service fabricator"
	id = "servicefab"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/fabricator/servicefab


/obj/item/weapon/circuitboard/fabricator/weaponfab
	name = "Circuit board (Weapon Fabricator)"
	build_path = /obj/machinery/fabricator/weapon_fabricator

/datum/design/circuit/weaponfabricator
	name = "weapon fabricator"
	id = "weaponfab"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/fabricator/weaponfab


/obj/item/weapon/circuitboard/fabricator/evafab
	name = "Circuit board (EVA Equipment Fabricator)"
	build_path = /obj/machinery/fabricator/eva_fabricator

/datum/design/circuit/evafab
	name = "eva equipment fabricator"
	id = "evafab"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/fabricator/evafab

/obj/item/weapon/circuitboard/fabricator/circuitfab
	name = "Circuit board (Circuit Imprinter)"
	build_path = /obj/machinery/fabricator/circuit_fabricator
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 2,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1,
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/weapon/reagent_containers/glass/beaker = 1
							)
/**
/datum/design/circuit/circuitfab
	name = "circuit imprinter"
	id = "circuitfab"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/fabricator/circuitfab
	sort_string =
	"FABAC"
**/


/obj/item/weapon/circuitboard/fabricator/autotailor
	name = "circuit board (auto-tailor - standard wear)"
	build_path = /obj/machinery/fabricator/autotailor
	origin_tech = list(TECH_DATA = 1)

/obj/item/weapon/circuitboard/fabricator/autotailor/nonstandard
	name = "circuit board (auto-tailor - non-standard wear)"
	build_path = /obj/machinery/fabricator/autotailor/nonstandard

/obj/item/weapon/circuitboard/fabricator/autotailor/accessories
	name = "circuit board (auto-tailor - accessories)"
	build_path = /obj/machinery/fabricator/autotailor/accessories

/datum/design/circuit/autotailor_standard
	name = "auto-tailor - standard"
	build_path = /obj/item/weapon/circuitboard/fabricator/autotailor

/datum/design/circuit/autotailor_nonstandard
	name = "auto-tailor - costumes & special"
	build_path = /obj/item/weapon/circuitboard/fabricator/autotailor/nonstandard

/datum/design/circuit/autotailor_accessories
	name = "auto-tailor - accessories and storage"
	build_path = /obj/item/weapon/circuitboard/fabricator/autotailor/accessories

/obj/item/weapon/circuitboard/fabricator/engfab
	name = "Circuit board (Engineering Fabricator)"
	build_path = /obj/machinery/fabricator/engineering_fabricator

/datum/design/circuit/engfab
	name = "engineering fabricator"
	id = "engfab"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/fabricator/engfab
	sort_string = "FABAF"

/obj/item/weapon/circuitboard/fabricator/genfab
	name = "Circuit board (General Fabricator)"
	build_path = /obj/machinery/fabricator/general_fabricator

/datum/design/circuit/genfab
	name = "general fabricator"
	id = "genfab"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/fabricator/genfab
	sort_string = "FABAG"

