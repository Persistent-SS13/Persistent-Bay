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

/obj/item/weapon/circuitboard/fabricator/mechfab
	name = "Circuit board (Exosuit Fabricator)"
	build_path = /obj/machinery/fabricator/mecha_part_fabricator

/datum/design/circuit/mechfab
	name = "exosuit fabricator"
	id = "mechfab"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/fabricator/mechfab
	sort_string = "FABAA"

/obj/item/weapon/circuitboard/fabricator/voidfab
	name = "Circuit board (Voidsuit Fabricator)"
	build_path = /obj/machinery/fabricator/voidsuit_fabricator

/datum/design/circuit/voidfab
	name = "voidsuit fabricator"
	id = "voidfab"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/fabricator/voidfab
	sort_string = "FABAB"

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

/datum/design/circuit/circuitfab
	name = "circuit imprinter"
	id = "circuitfab"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/fabricator/circuitfab
	sort_string = "FABAC"

/obj/item/weapon/circuitboard/fabricator/ammofab
	name = "Circuit board (Ammunition Fabricator)"
	build_path = /obj/machinery/fabricator/ammo_fabricator

/datum/design/circuit/ammofab
	name = "ammunition fabricator"
	id = "ammofab"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1, TECH_COMBAT = 1)
	build_path = /obj/item/weapon/circuitboard/fabricator/ammofab
	sort_string = "FABAD"

/obj/item/weapon/circuitboard/fabricator/autotailor
	name = "circuit board (auto-tailor - standard wear)"
	build_path = /obj/machinery/fabricator/autotailor
	origin_tech = list(TECH_DATA = 1)

	var/list/names_paths = list(/obj/machinery/fabricator/autotailor = "auto-tailor  (standard wear)",
							/obj/machinery/fabricator/autotailor/nonstandard = "circuit board (auto-tailor - non-standard wear)",
							/obj/machinery/fabricator/autotailor/accessories = "circuit board (auto-tailor - accessories)",
							/obj/machinery/fabricator/autotailor/combat = "circuit board (auto-tailor - tactical wear)",
							/obj/machinery/fabricator/autotailor/storage = "circuit board (auto-tailor - storage containers)")

/obj/item/weapon/circuitboard/fabricator/autotailor/attackby(obj/item/I, mob/user, params)
	if(isScrewdriver(I))
		set_type(pick(names_paths), user)

/obj/item/weapon/circuitboard/fabricator/autotailor/proc/set_type(typepath, mob/user)
	build_path = typepath
	name = ("[names_paths[build_path]]")
	to_chat(user, "<span class='notice'>You set the board to [names_paths[build_path]].</span>")

/obj/item/weapon/circuitboard/fabricator/autotailor/nonstandard
	name = "circuit board (auto-tailor - non-standard wear)"
	build_path = /obj/machinery/fabricator/autotailor/nonstandard

/obj/item/weapon/circuitboard/fabricator/autotailor/accessories
	name = "circuit board (auto-tailor - accessories)"
	build_path = /obj/machinery/fabricator/autotailor/accessories

/obj/item/weapon/circuitboard/fabricator/autotailor/combat
	name = "circuit board (auto-tailor - tactical wear)"
	build_path = /obj/machinery/fabricator/autotailor/combat

/obj/item/weapon/circuitboard/fabricator/autotailor/storage
	name = "circuit board (auto-tailor - storage containers)"
	build_path = /obj/machinery/fabricator/autotailor/storage

/datum/design/circuit/autotailor_standard
	name = "auto-tailor - standard"
	id = "autotailor_standard"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/weapon/circuitboard/fabricator/autotailor
	sort_string = "FABAE"
	

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

