/obj/machinery/fabricator/autotailor/storage
	name = "auto-tailor (storage containers)"
	desc = "An advanced machine capable of printing many types of clothing, this one is loaded with storage clothing designs."
	circuit = /obj/item/weapon/circuitboard/fabricator/autotailor/storage
	build_type = AUTOTAILOR_STORAGE

/obj/machinery/fabricator/autotailor/storage/can_connect(var/datum/world_faction/trying, var/mob/M)
	if(!trying.limits) return 0
	if(M && !has_access(list(core_access_machine_linking), list(), M.GetAccess(req_access_faction)))
		to_chat(M, "You do not have access to link machines to [trying.name].")
		return 0
	if(trying.limits.limit_atstorage <= trying.limits.atstorages.len)
		if(M)
			to_chat(M, "[trying.name] cannot connect any more machines of this type.")
		return 0
	trying.limits.atstorages |= src
	req_access_faction = trying.uid
	connected_faction = src
	
/obj/machinery/fabricator/autotailor/storage/can_disconnect(var/datum/world_faction/trying, var/mob/M)
	if(!trying.limits) return 0
	trying.limits.atstorages -= src
	req_access_faction = ""
	connected_faction = null
	if(M) to_chat(M, "The machine has been disconnected.")


////////////////////////////////////////////////////
//////////////////////DESIGNS///////////////////////
////////////////////////////////////////////////////

/datum/design/item/autotailor/storage
	build_type = AUTOTAILOR_STORAGE
	category = "misc"
	req_tech = list(TECH_MATERIAL = 1)
	time = 30

//
//Back storage slots
//
/datum/design/item/autotailor/storage/backpacks
	category = "Backpacks"
	materials = list("cloth" = 10000)

/datum/design/item/autotailor/storage/backpacks/grey_back
	name = "Grey backpack"
	id = "grey_back"
	build_path = /obj/item/weapon/storage/backpack

/datum/design/item/autotailor/storage/backpacks/green_back
	name = "Green backpack"
	id = "green_back"
	build_path = /obj/item/weapon/storage/backpack/hydroponics

/datum/design/item/autotailor/storage/backpacks/clown_back
	name = "Clown backpack"
	id = "clown_back"
	build_path = /obj/item/weapon/storage/backpack/clown

/datum/design/item/autotailor/storage/backpacks/mime_back
	name = "Mime backpack"
	id = "mime_back"
	build_path = /obj/item/weapon/storage/backpack/mime

/datum/design/item/autotailor/storage/backpacks/grey_satch
	name = "Grey satchel"
	id = "grey_satch"
	build_path = /obj/item/weapon/storage/backpack/satchel/grey

/datum/design/item/autotailor/storage/backpacks/green_satch
	name = "Green satchel"
	id = "green_satch"
	build_path = /obj/item/weapon/storage/backpack/satchel_hyd

/datum/design/item/autotailor/storage/backpacks/brown_l_satchel	//can use custom colors
	name = "Brown leather satchel"
	id = "brown_l_satchel"
	build_path = /obj/item/weapon/storage/backpack/satchel/brown

/datum/design/item/autotailor/storage/backpacks/black_l_satchel
	name = "Black leather satchel"
	id = "black_l_satchel"
	build_path = /obj/item/weapon/storage/backpack/satchel/black

/datum/design/item/autotailor/storage/backpacks/black_pocketbook	//can use custom colors
	name = "Black small pocketbook"
	id = "black_pocketbook"
	build_path = /obj/item/weapon/storage/backpack/satchel/pocketbook
	materials = list("cloth" = 5000)

/datum/design/item/autotailor/storage/backpacks/mess_grey
	name = "Grey messenger bag"
	id = "mess_grey"
	build_path = /obj/item/weapon/storage/backpack/messenger

/datum/design/item/autotailor/storage/backpacks/green_mess
	name = "Green messenger bag"
	id = "green_mess"
	build_path = /obj/item/weapon/storage/backpack/messenger/hyd

/datum/design/item/autotailor/storage/backpacks/grey_duffle
	name = "Grey dufflebag"
	id = "grey_duffle"
	build_path = /obj/item/weapon/storage/backpack/dufflebag
	materials = list("cloth" = 15000)

/datum/design/item/autotailor/storage/backpacks/t_rack
	name = "Backpack - trophy rack"
	id = "t_rack"
	build_path = /obj/item/weapon/storage/backpack/cultpack

/datum/design/item/autotailor/storage/backpacks/indu_back
	name = "Industrial backpack"
	id = "indu_back"
	build_path = /obj/item/weapon/storage/backpack/industrial

/datum/design/item/autotailor/storage/backpacks/indu_satch
	name = "Industrial satchel"
	id = "indu_satch"
	build_path = /obj/item/weapon/storage/backpack/satchel_eng

/datum/design/item/autotailor/storage/backpacks/indu_mess
	name = "Industrial messenger bag"
	id = "indu_mess"
	build_path = /obj/item/weapon/storage/backpack/messenger/engi

/datum/design/item/autotailor/storage/backpacks/indu_duffle
	name = "Industrial dufflebag"
	id = "indu_duffle"
	build_path = /obj/item/weapon/storage/backpack/dufflebag/eng
	materials = list("cloth" = 15000)

/datum/design/item/autotailor/storage/backpacks/sci_back
	name = "Scientist backpack"
	id = "sci_back"
	build_path = /obj/item/weapon/storage/backpack/toxins

/datum/design/item/autotailor/storage/backpacks/sci_satch
	name = "Scientist satchel"
	id = "sci_satch"
	build_path = /obj/item/weapon/storage/backpack/satchel_tox

/datum/design/item/autotailor/storage/backpacks/sci_mess
	name = "Scientst messenger bag"
	id = "sci_mess"
	build_path = /obj/item/weapon/storage/backpack/messenger/tox

/datum/design/item/autotailor/storage/backpacks/med_back
	name = "Medical backpack"
	id = "med_back"
	build_path = /obj/item/weapon/storage/backpack/medic

/datum/design/item/autotailor/storage/backpacks/chem_back
	name = "Chemist backpack"
	id = "chem_back"
	build_path = /obj/item/weapon/storage/backpack/chemistry

/datum/design/item/autotailor/storage/backpacks/viro_back
	name = "Virologist backpack"
	id = "viro_back"
	build_path = /obj/item/weapon/storage/backpack/virology

/datum/design/item/autotailor/storage/backpacks/gene_back
	name = "Geneticist backpack"
	id = "gene_back"
	build_path = /obj/item/weapon/storage/backpack/genetics

/datum/design/item/autotailor/storage/backpacks/med_satch
	name = "Medical satchel"
	id = "med_satch"
	build_path = /obj/item/weapon/storage/backpack/satchel_med

/datum/design/item/autotailor/storage/backpacks/chem_satch
	name = "Chemist satchel"
	id = "chem_satch"
	build_path = /obj/item/weapon/storage/backpack/satchel_chem

/datum/design/item/autotailor/storage/backpacks/viro_satch
	name = "Virologist satchel"
	id = "viro_satch"
	build_path = /obj/item/weapon/storage/backpack/satchel_vir

/datum/design/item/autotailor/storage/backpacks/gene_satch
	name = "Geneticist satchel"
	id = "gene_satch"
	build_path = /obj/item/weapon/storage/backpack/satchel_gen

/datum/design/item/autotailor/storage/backpacks/med_mess
	name = "Medical messenger bag"
	id = "med_mess"
	build_path = /obj/item/weapon/storage/backpack/messenger/med

/datum/design/item/autotailor/storage/backpacks/chem_mess
	name = "Chemist messenger bag"
	id = "chem_mess"
	build_path = /obj/item/weapon/storage/backpack/messenger/chem

/datum/design/item/autotailor/storage/backpacks/viro_mess
	name = "Virologist messenger bag"
	id = "viro_messs"
	build_path = /obj/item/weapon/storage/backpack/messenger/viro

/datum/design/item/autotailor/storage/backpacks/med_duffle
	name = "Medical dufflebag"
	id = "med_duffle"
	build_path = /obj/item/weapon/storage/backpack/dufflebag/med
	materials = list("cloth" = 15000)

/datum/design/item/autotailor/storage/backpacks/sec_back
	name = "Security backpack"
	id = "sec_back"
	build_path = /obj/item/weapon/storage/backpack/security

/datum/design/item/autotailor/storage/backpacks/sec_satch
	name = "Security satchel"
	id = "sec_satch"
	build_path = /obj/item/weapon/storage/backpack/satchel_sec

/datum/design/item/autotailor/storage/backpacks/sec_mess
	name = "Security messenger bag"
	id = "sec_mess"
	build_path = /obj/item/weapon/storage/backpack/messenger/sec

/datum/design/item/autotailor/storage/backpacks/sec_duffle
	name = "Security dufflebag"
	id = "sec_duffle"
	build_path = /obj/item/weapon/storage/backpack/dufflebag/sec
	materials = list("cloth" = 15000)

/datum/design/item/autotailor/storage/backpacks/cap_back
	name = "Captain backpack"
	id = "cap_back"
	build_path = /obj/item/weapon/storage/backpack/captain

/datum/design/item/autotailor/storage/backpacks/cap_satch
	name = "Captain satchel"
	id = "cap_satch"
	build_path = /obj/item/weapon/storage/backpack/satchel_cap

/datum/design/item/autotailor/storage/backpacks/cap_mess
	name = "Captain messenger bag"
	id = "cap_mess"
	build_path = /obj/item/weapon/storage/backpack/messenger/com

/datum/design/item/autotailor/storage/backpacks/cap_duffle
	name = "Captain dufflebag"
	id = "cap_duffle"
	build_path = /obj/item/weapon/storage/backpack/dufflebag/captain
	materials = list("cloth" = 15000)

/datum/design/item/autotailor/storage/backpacks/ert_blueback
	name = "Blue ERT backpack"
	id = "ert_blue"
	build_path = /obj/item/weapon/storage/backpack/ert
	materials = list("cloth" = 5000, "phoron" = 2000)

/datum/design/item/autotailor/storage/backpacks/ert_engback
	name = "Yellow ERT backpack"
	id = "ert_engback"
	build_path = /obj/item/weapon/storage/backpack/ert/engineer
	materials = list("cloth" = 5000, "phoron" = 2000)

/datum/design/item/autotailor/storage/backpacks/ert_whiteback
	name = "White ERT backpack"
	id = "ert_white"
	build_path = /obj/item/weapon/storage/backpack/ert/medical
	materials = list("cloth" = 5000, "phoron" = 2000)

/datum/design/item/autotailor/storage/backpacks/ert_redback
	name = "Red ERT backpack"
	id = "ert_red"
	build_path = /obj/item/weapon/storage/backpack/ert/security
	materials = list("cloth" = 5000, "phoron" = 2000)

/datum/design/item/autotailor/storage/backpacks/tact_d_black
	name = "Tactical dufflebag - black"
	id = "tact_d_black"
	build_path = /obj/item/weapon/storage/backpack/dufflebag/syndie
	materials = list("cloth" = 15000, "phoron" = 4000)

/datum/design/item/autotailor/storage/backpacks/tact_d_med
	name = "Tactical dufflebag - medical"
	id = "tact_d_med"
	build_path = /obj/item/weapon/storage/backpack/dufflebag/syndie/med
	materials = list("cloth" = 15000, "phoron" = 4000)

/datum/design/item/autotailor/storage/backpacks/tact_d_ammo
	name = "Tactical dufflebag - ammo"
	id = "tact_d_ammo"
	build_path = /obj/item/weapon/storage/backpack/dufflebag/syndie/ammo
	materials = list("cloth" = 15000, "phoron" = 4000)

//
//belt slot
//

/datum/design/item/autotailor/storage/waist
	category = "Belt bags"
	materials = list("leather" = 5000, DEFAULT_WALL_MATERIAL = 1000)

//alot (all) of the new paradise ported belts have no mob sprites, i see no reason to exclude such a small sprite though, so they remain
/datum/design/item/autotailor/storage/waist/utility_brown
	name = "Brown utility belt"
	id = "utility_brown"
	build_path = /obj/item/weapon/storage/belt/utility

/datum/design/item/autotailor/storage/waist/utility_white
	name = "White utility belt"
	id = "utility_white"
	build_path = /obj/item/weapon/storage/belt/utility/chief

/datum/design/item/autotailor/storage/waist/peddler
	name = "Peddler belt"
	id = "peddler"
	build_path = /obj/item/weapon/storage/belt/peddler

/datum/design/item/autotailor/storage/waist/med_white
	name = "Medical belt"
	id = "med_white"
	build_path = /obj/item/weapon/storage/belt/medical

/datum/design/item/autotailor/storage/waist/med_emt
	name = "Medical EMT belt"
	id = "med_emt"
	build_path = /obj/item/weapon/storage/belt/medical/emt

/datum/design/item/autotailor/storage/waist/sci_excav
	name = "Scientist belt - excavation"
	id = "sci_excav"
	build_path = /obj/item/weapon/storage/belt/archaeology

/datum/design/item/autotailor/storage/waist/botany
	name = "Gardening belt"
	id = "botany"
	build_path = /obj/item/weapon/storage/belt/botany

/datum/design/item/autotailor/storage/waist/jani
	name = "Janitorial belt"
	id = "jani"
	build_path = /obj/item/weapon/storage/belt/janitor/large

/datum/design/item/autotailor/storage/waist/jani_alt
	name = "Janitorial belt - alt"
	id = "jani_alt"
	build_path = /obj/item/weapon/storage/belt/janitor

//combat belts might belong in security-tailor
/datum/design/item/autotailor/storage/waist/bandolier_belt
	name = "Ammunation bandolier"
	id = "bandolier_belt"
	build_path = /obj/item/weapon/storage/belt/bandolier

/datum/design/item/autotailor/storage/waist/sec_blackbelt
	name = "Security belt - black"
	id = "sec_blackbelt"
	build_path = /obj/item/weapon/storage/belt/security

/datum/design/item/autotailor/storage/waist/sec_tan
	name = "Security belt - tan"
	id = "sec_tan"
	build_path = /obj/item/weapon/storage/belt/security/tactical

/datum/design/item/autotailor/storage/waist/sec_combat
	name = "Security combat belt"
	id = "sec_combat"
	build_path = /obj/item/weapon/storage/belt/security/fed

/datum/design/item/autotailor/storage/waist/sec_combat_alt
	name = "Security combat belt - alt"
	id = "sec_combat_alt"
	build_path = /obj/item/weapon/storage/belt/security/assault

/datum/design/item/autotailor/storage/waist/sec_parade
	name = "Security parade belt"
	id = "sec_parade"
	build_path = /obj/item/weapon/storage/belt/security/military

/datum/design/item/autotailor/storage/waist/waistpack_white	//can use custom colors
	name = "White waistpack"
	id = "waistpack_white"
	build_path = /obj/item/weapon/storage/belt/waistpack

/datum/design/item/autotailor/storage/waist/waistpack_l_white
	name = "White large waistpack"
	id = "waistpack_l_white"
	build_path = /obj/item/weapon/storage/belt/waistpack/big
	materials = list("leather" = 10000, DEFAULT_WALL_MATERIAL = 2000)

/datum/design/item/autotailor/storage/waist/waistpack_alt_white	//can use custom colors
	name = "White fannypack"
	id = "waistpack_alt"
	build_path = /obj/item/weapon/storage/belt/fannypack/white

/datum/design/item/autotailor/storage/waist/waistpack_alt_black
	name = "Black fannypack"
	id = "waistpack_alt_black"
	build_path = /obj/item/weapon/storage/belt/fannypack/black

/datum/design/item/autotailor/storage/waist/waistpack_alt_brown
	name = "Brown fannypack"
	id = "waistpack_alt_brown"
	build_path = /obj/item/weapon/storage/belt/fannypack

/datum/design/item/autotailor/storage/waist/waistpack_alt_red
	name = "Red fannypack"
	id = "waistpack_alt_red"
	build_path = /obj/item/weapon/storage/belt/fannypack/red

/datum/design/item/autotailor/storage/waist/waistpack_alt_blue
	name = "Blue fannypack"
	id = "waistpack_alt_blue"
	build_path = /obj/item/weapon/storage/belt/fannypack/blue

/datum/design/item/autotailor/storage/waist/waistpack_alt_purp
	name = "Purple fannypack"
	id = "waistpack_alt_purp"
	build_path = /obj/item/weapon/storage/belt/fannypack/purple

/datum/design/item/autotailor/storage/waist/waistpack_alt_green
	name = "Green fannypack"
	id = "waistpack_alt_green"
	build_path = /obj/item/weapon/storage/belt/fannypack/green

/datum/design/item/autotailor/storage/waist/waistpack_alt_cyan
	name = "Cyan fannypack"
	id = "waistpack_alt_cyan"
	build_path = /obj/item/weapon/storage/belt/fannypack/cyan

/datum/design/item/autotailor/storage/waist/waistpack_alt_yellow
	name = "Yellow fannypack"
	id = "waistpack_alt_yellow"
	build_path = /obj/item/weapon/storage/belt/fannypack/yellow

/datum/design/item/autotailor/storage/waist/waistpack_alt_orange
	name = "Orange fannypack"
	id = "waistpack_alt_orange"
	build_path = /obj/item/weapon/storage/belt/fannypack/orange

/datum/design/item/autotailor/storage/waist/waistpack_alt_pink
	name = "Pink fannypack"
	id = "waistpack_alt_pink"
	build_path = /obj/item/weapon/storage/belt/fannypack/pink

//
//work storage
//
/datum/design/item/autotailor/storage/work/
	category = "Work storage boxes"
	materials = list(DEFAULT_WALL_MATERIAL = 10000)

/datum/design/item/autotailor/storage/work/toolbox_red
	name = "Red toolbox"
	id = "toolbox_red"
	build_path = /obj/item/weapon/storage/toolbox

/datum/design/item/autotailor/storage/work/toolbox_bl_red
	name = "Black & red toolbox"
	id = "toolbox_bl_red"
	build_path = /obj/item/weapon/storage/toolbox/syndicate

/datum/design/item/autotailor/storage/work/toolbox_blue
	name = "Blue toolbox"
	id = "toolbox_blue"
	build_path = /obj/item/weapon/storage/toolbox/mechanical

/datum/design/item/autotailor/storage/work/toolbox_yellow
	name = "Yellow toolbox"
	id = "toolbox_yellow"
	build_path = /obj/item/weapon/storage/toolbox/electrical

/datum/design/item/autotailor/storage/work/toolbox_surgery
	name = "Medical toolbox"
	id = "toolbox_surgery"
	build_path = /obj/item/weapon/storage/firstaid/surgery

/datum/design/item/autotailor/storage/work/medkit
	materials = list("plastic" = 2 SHEETS)
/datum/design/item/autotailor/storage/work/medkit/medkit_white
	name = "White medical kit"
	id = "medkit_white"
	build_path = /obj/item/weapon/storage/firstaid

/datum/design/item/autotailor/storage/work/medkit/medkit_brown
	name = "Brown medical kit"
	id = "medkit_brown"
	build_path = /obj/item/weapon/storage/firstaid/combat

/datum/design/item/autotailor/storage/work/medkit/medkit_red
	name = "Red medical kit"
	id = "medkit_red"
	build_path = /obj/item/weapon/storage/firstaid/adv

/datum/design/item/autotailor/storage/work/medkit/medkit_blue
	name = "Blue medical kit"
	id = "medkit_blue"
	build_path = /obj/item/weapon/storage/firstaid/o2

/datum/design/item/autotailor/storage/work/medkit/medkit_yellow
	name = "Yellow medical kit"
	id = "medkit_yellow"
	build_path = /obj/item/weapon/storage/firstaid/fire

/datum/design/item/autotailor/storage/work/medkit/medkit_green
	name = "Green medical kit"
	id = "medkit_green"
	build_path = /obj/item/weapon/storage/firstaid/toxin

/datum/design/item/autotailor/storage/work/pills
	name = "Pill bottle"
	id = "pills"
	build_path = /obj/item/weapon/storage/pill_bottle
	materials = list("plastic" = 0.1 SHEETS)

/datum/design/item/autotailor/storage/work/vials
	name = "Vial storage box"
	id = "vials"
	build_path = /obj/item/weapon/storage/fancy/vials
	materials = list("plastic" = 2 SHEETS)
	
/datum/design/item/autotailor/storage/work/vials_locked
	name = "Vial storage lockbox"
	id = "vials_locked"
	build_path = /obj/item/weapon/storage/lockbox/vials
	materials = list("plastic" = 2 SHEETS, MATERIAL_SILVER = 2 SHEET)

/datum/design/item/autotailor/storage/work/briefcase_grey
	name = "Grey briefcase"
	id = "briefcase_grey"
	build_path = /obj/item/weapon/storage/briefcase/crimekit
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_LEATHER = 1 SHEET)

/datum/design/item/autotailor/storage/work/briefcase_brown
	name = "Brown briefcase"
	id = "briefcase_brown"
	build_path = /obj/item/weapon/storage/briefcase
	materials = list("leather" = 2 SHEETS, DEFAULT_WALL_MATERIAL = 1 SHEET)

/datum/design/item/autotailor/storage/work/briefcase_inflate
	name = "Inflatables briefcase"
	id = "briefcase_inflate"
	build_path = /obj/item/weapon/storage/briefcase/inflatable
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_LEATHER = 1 SHEET)

/datum/design/item/autotailor/storage/work/securecase_black
	name = "Black secure briefcase"
	id = "securecase_black"
	build_path = /obj/item/weapon/storage/secure/briefcase
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_LEATHER = 2 SHEETS, MATERIAL_SILVER = 2 SHEETS)

/datum/design/item/autotailor/storage/work/plantbag
	name = "Plant carrybag"
	id = "plantbag"
	build_path = /obj/item/weapon/storage/plants
	materials = list("leather" = 2.5 SHEETS)

/datum/design/item/autotailor/storage/work/orebag
	name = "Ore carrybag"
	id = "orebag"
	build_path = /obj/item/weapon/storage/ore
	materials = list("leather" = 2.5 SHEETS)

/datum/design/item/autotailor/storage/work/artebag
	name = "Fossile carrybag"
	id = "artebag"
	build_path = /obj/item/weapon/storage/bag/fossils
	materials = list("leather" = 2.5 SHEETS)

/datum/design/item/autotailor/storage/work/fossilpickbag
	name = "Excavation pick carrybag"
	id = "fossilpickbag"
	build_path = /obj/item/weapon/storage/excavation
	materials = list("leather" = 2.5 SHEETS)

/datum/design/item/autotailor/storage/work/mineral_coverabag
	name = "Material coverbag"
	id = "mineral_coverbag"
	build_path = /obj/item/weapon/storage/sheetsnatcher
	materials = list("leather" = 2.5 SHEETS)

//
//Misc storage
//
/datum/design/item/autotailor/storage/gen
	category = "General storage containers"
	materials = list("cardboard" = 1000)

/datum/design/item/autotailor/storage/gen/wallet_multi	//can use custom colors
	name = "Polychromatic wallet"
	id = "wallet_white"
	build_path = /obj/item/weapon/storage/wallet/poly
	materials = list("leather" = 1.5 SHEET, MATERIAL_PHORON = 0.25 SHEETS)

/datum/design/item/autotailor/storage/gen/wallet_leather
	name = "Leather wallet"
	id = "wallet_leather"
	build_path = /obj/item/weapon/storage/wallet/leather
	materials = list("leather" = 1 SHEET)

/datum/design/item/autotailor/storage/gen/cardb_box
	name = "Cardboard box"
	id = "cardb_box"
	build_path = /obj/item/weapon/storage/box
	materials = list("cardboard" = 2000)	//if we remove handcrafting deconstruction we can make this cheaper

/datum/design/item/autotailor/storage/gen/eggs
	name = "Egg carton"
	id = "eggs"
	build_path = /obj/item/weapon/storage/fancy/egg_box/empty

/datum/design/item/autotailor/storage/gen/plast_bag	//can use custom colors, maybe
	name = "Small plastic bag"
	id = "plast_bag"
	build_path = /obj/item/weapon/storage/bag/plasticbag
	materials = list("plastic" = 1 SHEET)

/datum/design/item/autotailor/storage/gen/trash_bag
	name = "Trash bag"
	id = "trash_bag"
	build_path = /obj/item/weapon/storage/bag/trash
	materials = list("plastic" = 2.5 SHEETS)

/datum/design/item/autotailor/storage/gen/brown_bag
	name = "Leather bag"
	id = "brown_bag"
	build_path = /obj/item/weapon/storage/backpack/leathersack
	materials = list("leather" = 5 SHEETS)

/datum/design/item/autotailor/storage/gen/cash
	name = "Money bag"
	id = "cash"
	build_path = /obj/item/weapon/storage/bag/cash
	materials = list("leather" = 2.5 SHEETS)

/datum/design/item/autotailor/storage/gen/lunchbox_bl_red
	name = "Black & red lunchbox"
	id = "lunchbox_bl_red"
	build_path = /obj/item/weapon/storage/lunchbox/syndicate
	materials = list(DEFAULT_WALL_MATERIAL = 0.5 SHEETS)

/datum/design/item/autotailor/storage/gen/lunchbox_hearts
	name = "Pink hearts lunchbox"
	id = "lunchbox_hearts"
	build_path = /obj/item/weapon/storage/lunchbox/heart
	materials = list(DEFAULT_WALL_MATERIAL = 0.5 SHEETS)

/datum/design/item/autotailor/storage/gen/lunchbox_cats
	name = "Green cat lunchbox"
	id = "lunchbox_cats"
	build_path = /obj/item/weapon/storage/lunchbox/cat
	materials = list(DEFAULT_WALL_MATERIAL = 2000)

/datum/design/item/autotailor/storage/gen/lunchbox_cricket
	name = "Diona nymph lunchbox"
	id = "lunchbox_cricket"
	build_path = /obj/item/weapon/storage/lunchbox/nymph
	materials = list(DEFAULT_WALL_MATERIAL = 0.5 SHEETS)

/datum/design/item/autotailor/storage/gen/lunchbox_rainbow
	name = "Rainbow lunchbox"
	id = "lunchbox_rainbow"
	build_path = /obj/item/weapon/storage/lunchbox
	materials = list(DEFAULT_WALL_MATERIAL = 2000)

/datum/design/item/autotailor/storage/gen/lunchbox_tf
	name = "TF lunchbox"
	id = "lunchbox_tcc"
	build_path = /obj/item/weapon/storage/lunchbox/tf
	materials = list(DEFAULT_WALL_MATERIAL = 2000)

/datum/design/item/autotailor/storage/gen/lunchbox_cti
	name = "CTI lunchbox"
	id = "lunchbox_cti"
	build_path = /obj/item/weapon/storage/lunchbox/cti
	materials = list(DEFAULT_WALL_MATERIAL = 2000)

/datum/design/item/autotailor/storage/gen/lunchbox_mu
	name = "MU lunchbox"
	id = "lunchbox_mu"
	build_path = /obj/item/weapon/storage/lunchbox/mars
	materials = list(DEFAULT_WALL_MATERIAL = 2000)

/datum/design/item/autotailor/storage/gen/lunchbox_nt
	name = "Nt lunchbox"
	id = "lunchbox_nt"
	build_path = /obj/item/weapon/storage/lunchbox/nt
	materials = list(DEFAULT_WALL_MATERIAL = 2000)

/datum/design/item/autotailor/storage/gen/cig_generic
	name = "Generic cigarette cart"
	id = "cig_"
	build_path = /obj/item/weapon/storage/fancy/cigarettes/blank

/datum/design/item/autotailor/storage/gen/cig_lgreen
	name = "Light green cigarette cart"
	id = "cig_lgreen"
	build_path = /obj/item/weapon/storage/fancy/cigarettes/menthols/blank

/datum/design/item/autotailor/storage/gen/cig_green
	name = "Green cigarette cart"
	id = "cig_green"
	build_path = /obj/item/weapon/storage/fancy/cigarettes/carcinomas/blank

/datum/design/item/autotailor/storage/gen/cig_lgrey
	name = "Light grey cigarette cart"
	id = "cig_lgrey"
	build_path = /obj/item/weapon/storage/fancy/cigarettes/professionals/blank

/datum/design/item/autotailor/storage/gen/cig_grey
	name = "Grey cigarette cart"
	id = "cig_grey"
	build_path = /obj/item/weapon/storage/fancy/cigarettes/jerichos/blank

/datum/design/item/autotailor/storage/gen/cig_red
	name = "Red cigarette cart"
	id = "cig_red"
	build_path = /obj/item/weapon/storage/fancy/cigarettes/dromedaryco/blank

/datum/design/item/autotailor/storage/gen/cig_blue
	name = "Blue cigarette cart"
	id = "cig_blue"
	build_path = /obj/item/weapon/storage/fancy/cigarettes/killthroat/blank

/datum/design/item/autotailor/storage/gen/cig_gold
	name = "Gold cigarette cart"
	id = "cig_gold"
	build_path = /obj/item/weapon/storage/fancy/cigarettes/luckystars/blank

/datum/design/item/autotailor/storage/gen/cig_gar
	name = "Fancy cigar case"
	id = "cig_gar"
	build_path = /obj/item/weapon/storage/fancy/cigar/blank
	materials = list("leather" = 10000)

/datum/design/item/autotailor/storage/gen/photo
	name = "Photo album"
	id = "photo"
	build_path = /obj/item/weapon/storage/photo_album
	materials = list("leather" = 5000)

/datum/design/item/autotailor/storage/gen/candle
	name = "Candle box"
	id = "candle"
	build_path = /obj/item/weapon/storage/fancy/candle_box

/datum/design/item/autotailor/storage/gen/crayons
	name = "Crayon box"
	id = "crayons"
	build_path = /obj/item/weapon/storage/fancy/crayons/blank