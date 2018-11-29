/obj/machinery/fabricator/autotailor/storage
	name = "auto-tailor (storage containers)"
	desc = "An advanced machine capable of printing many types of clothing, this one is loaded with storage clothing designs."
	circuit = /obj/item/weapon/circuitboard/fabricator/autotailor/storage
	build_type = AUTOTAILOR_STORAGE
	materials = list("cloth" = 0, "leather" = 0, DEFAULT_WALL_MATERIAL = 0, "glass" = 0, "diamond" = 0, "wood" = 0)
	req_access = list()

	icon_state = 	 "tailor-idle-top"
	icon_idle = 	 "tailor-idle-top"
	icon_open = 	 "tailor-idle-top"	//needs an opened icon
	overlay_active = "tailor-active-top"
	metal_load_anim = FALSE
	has_reagents = FALSE

////////////////////////////////////////////////////
//////////////////////DESIGNS///////////////////////
////////////////////////////////////////////////////

/datum/design/item/autotailor/storage
	build_type = AUTOTAILOR_STORAGE
	category = "misc"
	req_tech = list(TECH_MATERIAL = 1)
	time = 1	//40

/datum/design/item/autotailor/storage/backpacks
	category = "Backpacks"
	req_tech = list(TECH_MATERIAL = 1)
	time = 1	//40

/datum/design/item/autotailor/storage/backpacks/grey_back
	name = "Grey backpack"
	id = "grey_back"
	build_path = /obj/item/weapon/storage/backpack
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/green_back
	name = "Green backpack"
	id = "green_back"
	build_path = /obj/item/weapon/storage/backpack/hydroponics
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/clown_back
	name = "Clown backpack"
	id = "clown_back"
	build_path = /obj/item/weapon/storage/backpack/clown
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/mime_back	//fix item sprite
	name = "Mime backpack"
	id = "mime_back"
	build_path = /obj/item/weapon/storage/backpack/mime
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/grey_satch
	name = "Grey satchel"
	id = "grey_satch"
	build_path = /obj/item/weapon/storage/backpack/satchel/grey
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/green_satch
	name = "Green satchel"
	id = "green_satch"
	build_path = /obj/item/weapon/storage/backpack/satchel_hyd
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/brown_l_satchel	//looks like it uses custom colors
	name = "Brown leather satchel"
	id = "brown_l_satchel"
	build_path = /obj/item/weapon/storage/backpack/satchel/brown
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/black_l_satchel
	name = "Black leather satchel"
	id = "black_l_satchel"
	build_path = /obj/item/weapon/storage/backpack/satchel/black
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/black_pocketbook	//looks like it uses custom colors
	name = "Black small pocketbook"
	id = "black_pocketbook"
	build_path = /obj/item/weapon/storage/backpack/satchel/pocketbook
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/mess_grey
	name = "Grey messenger bag"
	id = "mess_grey"
	build_path = /obj/item/weapon/storage/backpack/messenger
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/green_mess
	name = "Green messenger bag"
	id = "green_mess"
	build_path = /obj/item/weapon/storage/backpack/messenger/hyd
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/grey_duffle
	name = "Grey dufflebag"
	id = "grey_duffle"
	build_path = /obj/item/weapon/storage/backpack/dufflebag
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/t_rack
	name = "Backpack - trophy rack"
	id = "t_rack"
	build_path = /obj/item/weapon/storage/backpack/cultpack
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/indu_back
	name = "Industrial backpack"
	id = "indu_back"
	build_path = /obj/item/weapon/storage/backpack/industrial
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/indu_satch
	name = "Industrial satchel"
	id = "indu_satch"
	build_path = /obj/item/weapon/storage/backpack/satchel_eng
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/indu_mess
	name = "Industrial messenger bag"
	id = "indu_mess"
	build_path = /obj/item/weapon/storage/backpack/messenger/engi
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/indu_duffle
	name = "Industrial dufflebag"
	id = "indu_duffle"
	build_path = /obj/item/weapon/storage/backpack/dufflebag/eng
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/sci_back
	name = "Scientist backpack"
	id = "sci_back"
	build_path = /obj/item/weapon/storage/backpack/toxins
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/sci_satch
	name = "Scientist satchel"
	id = "sci_satch"
	build_path = /obj/item/weapon/storage/backpack/satchel_tox
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/sci_mess
	name = "Scientst messenger bag"
	id = "sci_mess"
	build_path = /obj/item/weapon/storage/backpack/messenger/tox
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/med_back
	name = "Medical backpack"
	id = "med_back"
	build_path = /obj/item/weapon/storage/backpack/medic
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/chem_back
	name = "Chemist backpack"
	id = "chem_back"
	build_path = /obj/item/weapon/storage/backpack/chemistry
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/viro_back
	name = "Virologist backpack"
	id = "viro_back"
	build_path = /obj/item/weapon/storage/backpack/virology
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/gene_back
	name = "Geneticist backpack"
	id = "gene_back"
	build_path = /obj/item/weapon/storage/backpack/genetics
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/med_satch
	name = "Medical satchel"
	id = "med_satch"
	build_path = /obj/item/weapon/storage/backpack/satchel_med
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/chem_satch
	name = "Chemist satchel"
	id = "chem_satch"
	build_path = /obj/item/weapon/storage/backpack/satchel_chem
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/viro_satch
	name = "Virologist satchel"
	id = "viro_satch"
	build_path = /obj/item/weapon/storage/backpack/satchel_vir
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/gene_satch
	name = "Geneticist satchel"
	id = "gene_satch"
	build_path = /obj/item/weapon/storage/backpack/satchel_gen
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/med_mess
	name = "Medical messenger bag"
	id = "med_mess"
	build_path = /obj/item/weapon/storage/backpack/messenger/med
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/chem_mess
	name = "Chemist messenger bag"
	id = "chem_mess"
	build_path = /obj/item/weapon/storage/backpack/messenger/chem
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/viro_mess
	name = "Virologist messenger bag"
	id = "viro_messs"
	build_path = /obj/item/weapon/storage/backpack/messenger/viro
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/med_duffle
	name = "Medical dufflebag"
	id = "med_duffle"
	build_path = /obj/item/weapon/storage/backpack/dufflebag/med
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/sec_back
	name = "Security backpack"
	id = "sec_back"
	build_path = /obj/item/weapon/storage/backpack/security
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/sec_satch
	name = "Security satchel"
	id = "sec_satch"
	build_path = /obj/item/weapon/storage/backpack/satchel_sec
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/sec_mess
	name = "Security messenger bag"
	id = "sec_mess"
	build_path = /obj/item/weapon/storage/backpack/messenger/sec
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/sec_duffle
	name = "Security dufflebag"
	id = "sec_duffle"
	build_path = /obj/item/weapon/storage/backpack/dufflebag/sec
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/cap_back
	name = "Captain backpack"
	id = "cap_back"
	build_path = /obj/item/weapon/storage/backpack/captain
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/cap_satch
	name = "Captain satchel"
	id = "cap_satch"
	build_path = /obj/item/weapon/storage/backpack/satchel_cap
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/cap_mess
	name = "Captain messenger bag"
	id = "cap_mess"
	build_path = /obj/item/weapon/storage/backpack/messenger/com
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/cap_duffle
	name = "Captain dufflebag"
	id = "cap_duffle"
	build_path = /obj/item/weapon/storage/backpack/dufflebag/captain
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/ert_blue
	name = "Blue ERT backpack"
	id = "ert_blue"
	build_path = /obj/item/weapon/storage/backpack/ert
	materials = list("cloth" = 500)
//dupe^: /obj/item/weapon/storage/backpack/ert/commander 

/datum/design/item/autotailor/storage/backpacks/ert_eng
	name = "Yellow ERT backpack"
	id = "ert_eng"
	build_path = /obj/item/weapon/storage/backpack/ert/engineer
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/ert_white
	name = "White ERT backpack"
	id = "ert_white"
	build_path = /obj/item/weapon/storage/backpack/ert/medical
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/ert_red
	name = "Red ERT backpack"
	id = "ert_red"
	build_path = /obj/item/weapon/storage/backpack/ert/security
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/tact_d_black
	name = "Tactical dufflebag - black"
	id = "tact_d_black"
	build_path = /obj/item/weapon/storage/backpack/dufflebag/syndie
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/tact_d_med
	name = "Tactical dufflebag - medical"
	id = "tact_d_med"
	build_path = /obj/item/weapon/storage/backpack/dufflebag/syndie/med
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/backpacks/tact_d_ammo
	name = "Tactical dufflebag - ammo"
	id = "tact_d_ammo"
	build_path = /obj/item/weapon/storage/backpack/dufflebag/syndie/ammo
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/waist
	category = "Belt bags"
	req_tech = list(TECH_MATERIAL = 1)
	time = 1	//40
//alot (all) of the new paradise ported belts have no mob sprites, judging by the small item sprites its probably an easy fix
//also fannypacks need to use baystation inventory storaged
/datum/design/item/autotailor/storage/waist/utility_brown
	name = "Brown utility belt"
	id = "utility_brown"
	build_path = /obj/item/weapon/storage/belt/utility
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/waist/utility_white
	name = "White utility belt"
	id = "utility_white"
	build_path = /obj/item/weapon/storage/belt/utility/chief
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/waist/peddler
	name = "Peddler belt"
	id = "peddler"
	build_path = /obj/item/weapon/storage/belt/peddler
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/waist/med_white
	name = "Medical belt"
	id = "med_white"
	build_path = /obj/item/weapon/storage/belt/medical
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/waist/med_emt
	name = "Medical EMT belt"
	id = "med_emt"
	build_path = /obj/item/weapon/storage/belt/medical/emt
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/waist/sci_excav
	name = "Scientist belt - excavation"
	id = "sci_excav"
	build_path = /obj/item/weapon/storage/belt/archaeology
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/waist/botany
	name = "Gardening belt"
	id = "botany"
	build_path = /obj/item/weapon/storage/belt/botany
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/waist/jani	//retrofit to janitor belt, because its purple
	name = "Janitorial belt"
	id = "jani"
	build_path = /obj/item/weapon/storage/belt/soulstone
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/waist/jani_alt
	name = "Janitorial belt - alt"
	id = "jani_alt"
	build_path = /obj/item/weapon/storage/belt/janitor
	materials = list("cloth" = 500)

//might move combat belts to combattailor
/datum/design/item/autotailor/storage/waist/bandolier
	name = "Ammunation bandolier"
	id = "bandolier"
	build_path = /obj/item/weapon/storage/belt/bandolier
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/waist/sec_black
	name = "Security belt - black"
	id = "sec_black"
	build_path = /obj/item/weapon/storage/belt/security
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/waist/sec_tan
	name = "Security belt - tan"
	id = "sec_tan"
	build_path = /obj/item/weapon/storage/belt/security/tactical 
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/waist/sec_combat
	name = "Security combat belt"
	id = "sec_combat"
	build_path = /obj/item/weapon/storage/belt/security/fed
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/waist/sec_combat_alt
	name = "Security combat belt - alt"
	id = "sec_combat_alt"
	build_path = /obj/item/weapon/storage/belt/security/assault
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/waist/sec_parade
	name = "Security parade belt"
	id = "sec_parade"
	build_path = /obj/item/weapon/storage/belt/security/military
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/waist/waistpack_white	//custom colors
	name = "White waistpack"
	id = "waistpack_white"
	build_path = /obj/item/weapon/storage/belt/waistpack
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/waist/waistpack_l_white
	name = "White large waistpack"
	id = "waistpack_l_white"
	build_path = /obj/item/weapon/storage/belt/waistpack/big
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/waist/waistpack_alt_white	//custom colors
	name = "White fannypack"
	id = "waistpack_alt"
	build_path = /obj/item/weapon/storage/belt/fannypack/white
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/waist/waistpack_alt_black
	name = "Black fannypack"
	id = "waistpack_alt_black"
	build_path = /obj/item/weapon/storage/belt/fannypack/black
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/waist/waistpack_alt_brown
	name = "Brown fannypack"
	id = "waistpack_alt_brown"
	build_path = /obj/item/weapon/storage/belt/fannypack
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/waist/waistpack_alt_red
	name = "Red fannypack"
	id = "waistpack_alt_red"
	build_path = /obj/item/weapon/storage/belt/fannypack/red
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/waist/waistpack_alt_blue
	name = "Blue fannypack"
	id = "waistpack_alt_blue"
	build_path = /obj/item/weapon/storage/belt/fannypack/blue
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/waist/waistpack_alt_purp
	name = "Purple fannypack"
	id = "waistpack_alt_purp"
	build_path = /obj/item/weapon/storage/belt/fannypack/purple
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/waist/waistpack_alt_green
	name = "Green fannypack"
	id = "waistpack_alt_green"
	build_path = /obj/item/weapon/storage/belt/fannypack/green
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/waist/waistpack_alt_cyan
	name = "Cyan fannypack"
	id = "waistpack_alt_cyan"
	build_path = /obj/item/weapon/storage/belt/fannypack/cyan
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/waist/waistpack_alt_yellow
	name = "Yellow fannypack"
	id = "waistpack_alt_yellow"
	build_path = /obj/item/weapon/storage/belt/fannypack/yellow
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/waist/waistpack_alt_orange
	name = "Orange fannypack"
	id = "waistpack_alt_orange"
	build_path = /obj/item/weapon/storage/belt/fannypack/orange
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/waist/waistpack_alt_pink
	name = "Pink fannypack"
	id = "waistpack_alt_pink"
	build_path = /obj/item/weapon/storage/belt/fannypack/pink
	materials = list("cloth" = 500)

//////////////////////work storage//////////////////////////
/datum/design/item/autotailor/storage/work/
	category = "Work storage boxes"
	req_tech = list(TECH_MATERIAL = 1)
	time = 1	//40

/datum/design/item/autotailor/storage/work/toolbox_red
	name = "Red toolbox"
	id = "toolbox_red"
	build_path = /obj/item/weapon/storage/toolbox
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/work/toolbox_bl_red	//remove items
	name = "Black & red toolbox"
	id = "toolbox_bl_red"
	build_path = /obj/item/weapon/storage/toolbox/syndicate
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/work/toolbox_blue	//remove items
	name = "Blue toolbox"
	id = "toolbox_blue"
	build_path = /obj/item/weapon/storage/toolbox/mechanical
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/work/toolbox_yellow	//rmeove items
	name = "Yellow toolbox"
	id = "toolbox_yellow"
	build_path = /obj/item/weapon/storage/toolbox/electrical
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/work/toolbox_surgery	//remove items
	name = "Medical toolbox"
	id = "toolbox_surgery"
	build_path = /obj/item/weapon/storage/firstaid/surgery
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/work/medkit_white
	name = "White medical kit"
	id = "medkit_white"
	build_path = /obj/item/weapon/storage/firstaid
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/work/medkit_brown	//remove items
	name = "Brown medical kit"
	id = "medkit_brown"
	build_path = /obj/item/weapon/storage/firstaid/combat
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/work/medkit_red
	name = "Red medical kit"
	id = "medkit_red"
	build_path = /obj/item/weapon/storage/firstaid/adv
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/work/medkit_blue	//remove items
	name = "Blue medical kit"
	id = "medkit_blue"
	build_path = /obj/item/weapon/storage/firstaid/o2	//lol a number
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/work/medkit_yellow	//remove items
	name = "Yellow medical kit"
	id = "medkit_yellow"
	build_path = /obj/item/weapon/storage/firstaid/fire
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/work/medkit_green	//remove items
	name = "Green medical kit"
	id = "medkit_green"
	build_path = /obj/item/weapon/storage/firstaid/toxin
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/work/pills
	name = "Pill bottle"
	id = "pills"
	build_path = /obj/item/weapon/storage/pill_bottle
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/work/vials	//remove items
	name = "Vial storage box"
	id = "vials"
	build_path = /obj/item/weapon/storage/fancy/vials
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/work/briefcase_grey	//remove items
	name = "Grey briefcase"
	id = "briefcase_grey"
	build_path = /obj/item/weapon/storage/briefcase/crimekit
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/work/briefcase_brown
	name = "Brown briefcase"
	id = "briefcase_brown"
	build_path = /obj/item/weapon/storage/briefcase
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/work/briefcase_inflate	//remove items
	name = "Inflatables briefcase"
	id = "briefcase_inflate"
	build_path = /obj/item/weapon/storage/briefcase/inflatable
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/work/securecase_black
	name = "Black secure briefcase"
	id = "securecase_black"
	build_path = /obj/item/weapon/storage/secure/briefcase
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/work/securecase_grey	//seems to have a different locking system than above... fix if it doesnt work
	name = "Grey secure briefcase"
	id = "securecase_grey"
	build_path = /obj/item/weapon/storage/lockbox
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/work/plantbag
	name = "Plant carrybag"
	id = "plantbag"
	build_path = /obj/item/weapon/storage/plants
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/work/orebag
	name = "Ore carrybag"
	id = "orebag"
	build_path = /obj/item/weapon/storage/ore
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/work/artebag
	name = "Fossile carrybag"
	id = "artebag"
	build_path = /obj/item/weapon/storage/bag/fossils
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/work/fossilpickbag	//remove items
	name = "Excavation pick carrybag"
	id = "fossilpickbag"
	build_path = /obj/item/weapon/storage/excavation
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/work/mineral_coverabag	//only adding this to have a "safe" way of transporting phoron & uranium
	name = "Material coverbag"
	id = "mineral_coverbag"
	build_path = /obj/item/weapon/storage/sheetsnatcher
	materials = list("cloth" = 500)

//////////////////////Misc storage//////////////////////////
/datum/design/item/autotailor/storage/gen
	category = "General storage containers"
	req_tech = list(TECH_MATERIAL = 1)
	time = 1	//40

/datum/design/item/autotailor/storage/gen/wallet_white	//custom colors canidate, and a popular item!!
	name = "White wallet"
	id = "wallet_white"
	build_path = /obj/item/weapon/storage/wallet
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/gen/wallet_leather
	name = "Leather wallet"
	id = "wallet_leather"
	build_path = /obj/item/weapon/storage/wallet/leather
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/gen/cardb_box
	name = "Cardboard box"
	id = "cardb_box"
	build_path = /obj/item/weapon/storage/box
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/gen/eggs
	name = "Egg carton"
	id = "eggs"
	build_path = /obj/item/weapon/storage/fancy/egg_box/empty
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/gen/plast_bag	//custom colors?
	name = "Small plastic bag"
	id = "plast_bag"
	build_path = /obj/item/weapon/storage/bag/plasticbag
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/gen/trash_bag
	name = "Trash bag"
	id = "trash_bag"
	build_path = /obj/item/weapon/storage/bag/trash
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/gen/brown_bag	//nerf
	name = "Leather bag"
	id = "brown_bag"
	build_path = /obj/item/weapon/storage/backpack/santabag
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/gen/cash
	name = "Money bag"
	id = "cash"
	build_path = /obj/item/weapon/storage/bag/cash
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/gen/lunchbox_bl_red
	name = "Black & red lunchbox"
	id = "lunchbox_bl_red"
	build_path = /obj/item/weapon/storage/lunchbox/syndicate
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/gen/lunchbox_hearts
	name = "Pink hearts lunchbox"
	id = "lunchbox_hearts"
	build_path = /obj/item/weapon/storage/lunchbox/heart
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/gen/lunchbox_cats
	name = "Green cat lunchbox"
	id = "lunchbox_cats"
	build_path = /obj/item/weapon/storage/lunchbox/cat
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/gen/lunchbox_cricket
	name = "Cute cricket lunchbox"
	id = "lunchbox_cricket"
	build_path = /obj/item/weapon/storage/lunchbox/nymph
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/gen/lunchbox_rainbow
	name = "Rainbow lunchbox"
	id = "lunchbox_rainbow"
	build_path = /obj/item/weapon/storage/lunchbox
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/gen/lunchbox_tcc
	name = "TCC lunchbox"
	id = "lunchbox_tcc"
	build_path = /obj/item/weapon/storage/lunchbox/TCC	//uh oh it's blue and that's the correct parth
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/gen/lunchbox_cti
	name = "CTI lunchbox"
	id = "lunchbox_cti"
	build_path = /obj/item/weapon/storage/lunchbox/cti
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/gen/lunchbox_mu
	name = "MU lunchbox"
	id = "lunchbox_mu"
	build_path = /obj/item/weapon/storage/lunchbox/mars
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/gen/lunchbox_nt
	name = "Nt lunchbox"
	id = "lunchbox_nt"
	build_path = /obj/item/weapon/storage/lunchbox/nt
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/gen/cig_generic
	name = "Generic cigarette cart"
	id = "cig_"
	build_path = /obj/item/weapon/storage/fancy/cigarettes/blank
	materials = list("cloth" = 500)

//make all cig carts empty
/datum/design/item/autotailor/storage/gen/cig_lgreen
	name = "Light green cigarette cart"
	id = "cig_lgreen"
	build_path = /obj/item/weapon/storage/fancy/cigarettes/menthols
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/gen/cig_green
	name = "Green cigarette cart"
	id = "cig_green"
	build_path = /obj/item/weapon/storage/fancy/cigarettes/carcinomas
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/gen/cig_lgrey
	name = "Light grey cigarette cart"
	id = "cig_lgrey"
	build_path = /obj/item/weapon/storage/fancy/cigarettes/professionals
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/gen/cig_grey
	name = "Grey cigarette cart"
	id = "cig_grey"
	build_path = /obj/item/weapon/storage/fancy/cigarettes/jerichos
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/gen/cig_red
	name = "Red cigarette cart"
	id = "cig_red"
	build_path = /obj/item/weapon/storage/fancy/cigarettes/dromedaryco
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/gen/cig_blue
	name = "Blue cigarette cart"
	id = "cig_blue"
	build_path = /obj/item/weapon/storage/fancy/cigarettes/killthroat
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/gen/cig_gold
	name = "Gold cigarette cart"
	id = "cig_gold"
	build_path = /obj/item/weapon/storage/fancy/cigarettes/luckystars
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/gen/cig_gar	//empty
	name = "Fancy cigar case"
	id = "cig_gar"
	build_path = /obj/item/weapon/storage/fancy/cigar
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/gen/photo
	name = "Photo album"
	id = "photo"
	build_path = /obj/item/weapon/storage/photo_album
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/gen/candle	//empty
	name = "Candle box"
	id = "candle"
	build_path = /obj/item/weapon/storage/fancy/candle_box
	materials = list("cloth" = 500)

/datum/design/item/autotailor/storage/gen/crayons	//empty
	name = "Crayon box"
	id = "crayons"
	build_path = /obj/item/weapon/storage/fancy/crayons
	materials = list("cloth" = 500)