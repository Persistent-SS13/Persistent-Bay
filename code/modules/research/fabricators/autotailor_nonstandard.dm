/obj/machinery/fabricator/autotailor/nonstandard
	name = "auto-tailor (costumes & special wear)"
	desc = "An advanced machine capable of printing many types of clothing, this one is loaded with non-standard clothing designs."
	circuit_type = /obj/item/weapon/circuitboard/fabricator/autotailor/nonstandard
	build_type = AUTOTAILOR_NONSTANDARD


/obj/machinery/fabricator/autotailor/nonstandard/can_connect(var/datum/world_faction/trying, var/mob/M)
	var/datum/machine_limits/limits = trying.get_limits()
	if(M && !has_access(list(core_access_machine_linking), list(), M.GetAccess(trying.uid)))
		to_chat(M, "You do not have access to link machines to [trying.name].")
		return 0
	if(limits.limit_atnonstandard <= limits.atnonstandards.len)
		if(M)
			to_chat(M, "[trying.name] cannot connect any more machines of this type.")
		return 0
	limits.atnonstandards |= src
	req_access_faction = trying.uid
	connected_faction = trying

/obj/machinery/fabricator/autotailor/nonstandard/can_disconnect(var/datum/world_faction/trying, var/mob/M)
	var/datum/machine_limits/limits = trying.get_limits()
	limits.atnonstandards -= src
	req_access_faction = ""
	connected_faction = null
	if(M) to_chat(M, "The machine has been disconnected.")







////////////////////////////////////////////////////
//////////////////////DESIGNS///////////////////////
////////////////////////////////////////////////////

/datum/design/item/autotailor/nonstandard
	build_type = AUTOTAILOR_NONSTANDARD
	category = "misc"
	req_tech = list(TECH_MATERIAL = 1)
	time = 30

//
//nonstandard clothing
//
/datum/design/item/autotailor/nonstandard/under
	category = "Undersuits - Nonstandard"
	materials = list(MATERIAL_CLOTH = 5000)

/datum/design/item/autotailor/nonstandard/under/vox_casual
	name = "Vox clothing - casual"
	id = "vox_casual"
	build_path = /obj/item/clothing/under/vox/vox_casual
	materials = list(MATERIAL_CLOTH = 10000, MATERIAL_LEATHER = 5000)

/datum/design/item/autotailor/nonstandard/under/vox_robes
	name = "Vox clothing - robes"
	id = "vox_robes"
	build_path = /obj/item/clothing/under/vox/vox_robes

/datum/design/item/autotailor/nonstandard/under/pjs_red
	name = "Classic PJ's - red"
	id = "pjs_red"
	build_path = /obj/item/clothing/under/pj/red

/datum/design/item/autotailor/nonstandard/under/pjs_blue
	name = "Classic PJ's - blue"
	id = "pjs_blue"
	build_path = /obj/item/clothing/under/pj/blue

/datum/design/item/autotailor/nonstandard/under/scrubs_white	//can use custom colors
	name = "Scrubs - white"
	id = "scrubs_white"
	build_path = /obj/item/clothing/under/rank/medical/scrubs

/datum/design/item/autotailor/nonstandard/under/scrubhood_white	//can use custom colors
	name = "Scrubs hat - white"
	id = "scrubhood_white"
	build_path = /obj/item/clothing/head/surgery

/datum/design/item/autotailor/nonstandard/under/scrubs_black
	name = "Scrubs - black"
	id = "scrubs_black"
	build_path = /obj/item/clothing/under/rank/medical/scrubs/black

/datum/design/item/autotailor/nonstandard/under/scrubhood_black
	name = "Scrubs hat - black"
	id = "scrubhood_black"
	build_path = /obj/item/clothing/head/surgery/black

/datum/design/item/autotailor/nonstandard/under/scrubs_purple
	name = "Scrubs - purple"
	id = "scrubs_purple"
	build_path = /obj/item/clothing/under/rank/medical/scrubs/purple

/datum/design/item/autotailor/nonstandard/under/scrubhood_purple
	name = "Scrubs hat - purple"
	id = "scrubhood_purple"
	build_path = /obj/item/clothing/head/surgery/purple

/datum/design/item/autotailor/nonstandard/under/scrubs_blue
	name = "Scrubs - blue"
	id = "scrubs_blue"
	build_path = /obj/item/clothing/under/rank/medical/scrubs/blue

/datum/design/item/autotailor/nonstandard/under/scrubhood_blue
	name = "Scrubs hat - blue"
	id = "scrubhood_blue"
	build_path = /obj/item/clothing/head/surgery/blue

/datum/design/item/autotailor/nonstandard/under/scrubs_green
	name = "Scrubs - green"
	id = "scrubs_green"
	build_path = /obj/item/clothing/under/rank/medical/scrubs/green

/datum/design/item/autotailor/nonstandard/under/scrubhood_green
	name = "Scrubs hat - green"
	id = "scrubhood_green"
	build_path = /obj/item/clothing/head/surgery/green

/datum/design/item/autotailor/nonstandard/under/scrubs_teal
	name = "Scrubs - teal"
	id = "scrubs_teal"
	build_path = /obj/item/clothing/under/rank/medical/scrubs/teal

/datum/design/item/autotailor/nonstandard/under/scrubhood_teal
	name = "Scrubs hat - teal"
	id = "scrubhood_teal"
	build_path = /obj/item/clothing/head/surgery/teal

/datum/design/item/autotailor/nonstandard/under/scrubs_heliodor
	name = "Scrubs - heliodor"
	id = "scrubs_heliodor"
	build_path = /obj/item/clothing/under/rank/medical/scrubs/heliodor

/datum/design/item/autotailor/nonstandard/under/scrubhood_heliodor
	name = "Scrubs hat - heliodor"
	id = "scrubhood_heliodor"
	build_path = /obj/item/clothing/head/surgery/heliodor

/datum/design/item/autotailor/nonstandard/under/scrubs_navyblue
	name = "Scrubs - navy blue"
	id = "scrubs_navyblue"
	build_path = /obj/item/clothing/under/rank/medical/scrubs/navyblue

/datum/design/item/autotailor/nonstandard/under/scrubhood_navyblue
	name = "Scrubs hat - navy blue"
	id = "scrubhood_navyblue"
	build_path = /obj/item/clothing/head/surgery/navyblue

/datum/design/item/autotailor/nonstandard/under/scrubs_lilac
	name = "Scrubs - lilac"
	id = "scrubs_lilac"
	build_path = /obj/item/clothing/under/rank/medical/scrubs/lilac

/datum/design/item/autotailor/nonstandard/under/scrubhood_lilac
	name = "Scrubs hat - lilac"
	id = "scrubhood_lilac"
	build_path = /obj/item/clothing/head/surgery/lilac

/datum/design/item/autotailor/nonstandard/under/swim_black
	name = "swimsuit - female black"
	id = "swim_black"
	build_path = /obj/item/clothing/under/swimsuit/black

/datum/design/item/autotailor/nonstandard/under/swim_green
	name = "swimsuit - female green"
	id = "swim_green"
	build_path = /obj/item/clothing/under/swimsuit/green

/datum/design/item/autotailor/nonstandard/under/swim_red
	name = "swimsuit - female red"
	id = "swim_red"
	build_path = /obj/item/clothing/under/swimsuit/red

/datum/design/item/autotailor/nonstandard/under/swim_blue
	name = "swimsuit - female blue"
	id = "swim_blue"
	build_path = /obj/item/clothing/under/swimsuit/blue

/datum/design/item/autotailor/nonstandard/under/swim_purple
	name = "swimsuit - female purple"
	id = "swim_purple"
	build_path = /obj/item/clothing/under/swimsuit/purple

/datum/design/item/autotailor/nonstandard/under/mankini
	name = "swimsuit - mankini"
	id = "mankini"
	build_path = /obj/item/clothing/under/stripper/mankini

/datum/design/item/autotailor/nonstandard/under/resomi_smock
	name = "small grey smock"
	build_path = /obj/item/clothing/under/resomi/smock

/datum/design/item/autotailor/nonstandard/under/resomi_smock_white
	name = "small white smock"
	build_path = /obj/item/clothing/under/resomi/smock/white

/datum/design/item/autotailor/nonstandard/under/resomi_smock_red
	name = "small red smock"
	build_path = /obj/item/clothing/under/resomi/smock/red

/datum/design/item/autotailor/nonstandard/under/resomi_smock_yellow
	name = "small yellow smock"
	build_path = /obj/item/clothing/under/resomi/smock/yellow

/datum/design/item/autotailor/nonstandard/under/resomi_smock_medical
	name = "small medical uniform"
	build_path = /obj/item/clothing/under/resomi/smock/medical

/datum/design/item/autotailor/nonstandard/under/resomi_smock_science
	name = "small science uniform"
	build_path = /obj/item/clothing/under/resomi/smock/science

/datum/design/item/autotailor/nonstandard/under/resomi_smock_rainbow
	name = "small rainbow smock"
	build_path = /obj/item/clothing/under/resomi/smock/rainbow

/datum/design/item/autotailor/nonstandard/under/resomi_smock_black
	name = "small black smock"
	build_path = /obj/item/clothing/under/resomi/smock/black

/datum/design/item/autotailor/nonstandard/under/resomi_smock_black_red
	name = "small black and red smock"
	build_path = /obj/item/clothing/under/resomi/smock/black_red

/datum/design/item/autotailor/nonstandard/under/resomi_smock_hazard
	name = "small hazard smock"
	build_path = /obj/item/clothing/under/resomi/smock/hazard

/datum/design/item/autotailor/nonstandard/under/resomi_smock_white_blue
	name = "small white and blue smock"
	build_path = /obj/item/clothing/under/resomi/smock/white_blue

/datum/design/item/autotailor/nonstandard/under/resomi_smock_white_purple
	name = "small white and purplesmock"
	build_path = /obj/item/clothing/under/resomi/smock/white_purple

/datum/design/item/autotailor/nonstandard/under/resomi_black_orange
	name = "black and orange undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/standard/black_orange

/datum/design/item/autotailor/nonstandard/under/resomi_black_grey
	name = "black and grey undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/standard/black_grey

/datum/design/item/autotailor/nonstandard/under/resomi_black_midgrey
	name = "black and medium grey undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/standard/black_midgrey

/datum/design/item/autotailor/nonstandard/under/resomi_black_lightgrey
	name = "black and light grey undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/standard/black_lightgrey

/datum/design/item/autotailor/nonstandard/under/resomi_black_red
	name = "black and red undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/standard/black_red

/datum/design/item/autotailor/nonstandard/under/resomi_black
	name = "black undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/standard/black

/datum/design/item/autotailor/nonstandard/under/resomi_black_white
	name = "black and white cloak"
	build_path = /obj/item/clothing/under/resomi/undercoat/standard/black_white

/datum/design/item/autotailor/nonstandard/under/resomi_black_yellow
	name = "black and yellow undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/standard/black_yellow

/datum/design/item/autotailor/nonstandard/under/resomi_black_green
	name = "black and green undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/standard/black_green

/datum/design/item/autotailor/nonstandard/under/resomi_black_blue
	name = "black and blue undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/standard/black_blue

/datum/design/item/autotailor/nonstandard/under/resomi_black_purple
	name = "black and purple undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/standard/black_purple

/datum/design/item/autotailor/nonstandard/under/resomi_black_pink
	name = "black and pink undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/standard/black_pink

/datum/design/item/autotailor/nonstandard/under/resomi_black_brown
	name = "black and brown undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/standard/black_brown

/datum/design/item/autotailor/nonstandard/under/resomi_orange_grey
	name = "orange and grey undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/standard/orange_grey

/datum/design/item/autotailor/nonstandard/under/resomi_rainbow
	name = "rainbow undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/standard/rainbow

/datum/design/item/autotailor/nonstandard/under/resomi_lightgrey_grey
	name = "light grey and grey undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/standard/lightgrey_grey

/datum/design/item/autotailor/nonstandard/under/resomi_white_grey
	name = "white and grey undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/standard/white_grey

/datum/design/item/autotailor/nonstandard/under/resomi_red_grey
	name = "red and grey undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/standard/red_grey

/datum/design/item/autotailor/nonstandard/under/resomi_orange
	name = "orange undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/standard/orange

/datum/design/item/autotailor/nonstandard/under/resomi_yellow_grey
	name = "yellow and grey undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/standard/yellow_grey

/datum/design/item/autotailor/nonstandard/under/resomi_green_grey
	name = "green and grey undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/standard/green_grey

/datum/design/item/autotailor/nonstandard/under/resomi_blue_grey
	name = "blue and grey undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/standard/blue_grey

/datum/design/item/autotailor/nonstandard/under/resomi_purple_grey
	name = "purple and grey undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/standard/purple_grey

/datum/design/item/autotailor/nonstandard/under/resomi_pink_grey
	name = "pink and grey undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/standard/pink_grey

/datum/design/item/autotailor/nonstandard/under/resomi_brown_grey
	name = "brown and grey undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/standard/brown_grey

/datum/design/item/autotailor/nonstandard/under/resomi_cargo
	name = "cargo undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/jobs/cargo

/datum/design/item/autotailor/nonstandard/under/resomi_mining
	name = "mining undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/jobs/mining

/datum/design/item/autotailor/nonstandard/under/resomi_command
	name = "command undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/jobs/command

/datum/design/item/autotailor/nonstandard/under/resomi_command_g
	name = "gold accented command undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/jobs/command_g

/datum/design/item/autotailor/nonstandard/under/resomi_ce
	name = "chief engineer undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/jobs/ce

/datum/design/item/autotailor/nonstandard/under/resomi_ce_w
	name = "white chief engineer undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/jobs/ce_w

/datum/design/item/autotailor/nonstandard/under/resomi_engineer
	name = "engineering undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/jobs/engineer

/datum/design/item/autotailor/nonstandard/under/resomi_atmos
	name = "atmospherics undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/jobs/atmos

/datum/design/item/autotailor/nonstandard/under/resomi_cmo
	name = "chief medical officer undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/jobs/cmo

/datum/design/item/autotailor/nonstandard/under/resomi_medical
	name = "medical undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/jobs/medical

/datum/design/item/autotailor/nonstandard/under/resomi_chemistry
	name = "chemistry undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/jobs/chemistry

/datum/design/item/autotailor/nonstandard/under/resomi_viro
	name = "virologist undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/jobs/viro

/datum/design/item/autotailor/nonstandard/under/resomi_para
	name = "paramedic undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/jobs/para

/datum/design/item/autotailor/nonstandard/under/resomi_sci
	name = "science undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/jobs/sci

/datum/design/item/autotailor/nonstandard/under/resomi_robo
	name = "robotics undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/jobs/robo

/datum/design/item/autotailor/nonstandard/under/resomi_sec
	name = "security undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/jobs/sec

/datum/design/item/autotailor/nonstandard/under/resomi_qm
	name = "quartermaster undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/jobs/qm

/datum/design/item/autotailor/nonstandard/under/resomi_service
	name = "service undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/jobs/service

/datum/design/item/autotailor/nonstandard/under/resomi_iaa
	name = "internal affairs undercoat"
	build_path = /obj/item/clothing/under/resomi/undercoat/jobs/iaa

//
//nonstandard oversuits
//
/datum/design/item/autotailor/nonstandard/suit
	category = "Nonstandard Oversuits"
	materials = list(MATERIAL_CLOTH = 10000)

/datum/design/item/autotailor/nonstandard/suit/vox_armor
	name = "Vox makeshift armor"
	id = "vox_armor"
	build_path = /obj/item/clothing/suit/armor/vox_scrap
	materials = list(MATERIAL_CLOTH = 3000, MATERIAL_LEATHER = 5000, MATERIAL_STEEL = 10000)

/datum/design/item/autotailor/nonstandard/suit/fur	//maybe remove, or put as costume
	name = "alien fur coat"
	id = "fur"
	build_path = /obj/item/clothing/suit/xeno/furs

/datum/design/item/autotailor/nonstandard/suit/pjs_ian
	name = "Corgi PJs"
	id = "pjs_ian"
	build_path = /obj/item/clothing/suit/ianshirt
	materials = list(MATERIAL_CLOTH = 5000)

/datum/design/item/autotailor/nonstandard/suit/resomi_black_orange
	name = "black and orange cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/standard/black_orange

/datum/design/item/autotailor/nonstandard/suit/resomi_black_grey
	name = "black and grey cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/standard/black_grey

/datum/design/item/autotailor/nonstandard/suit/resomi_black_midgrey
	name = "black and medium grey cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/standard/black_midgrey

/datum/design/item/autotailor/nonstandard/suit/resomi_black_lightgrey
	name = "black and light grey cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/standard/black_lightgrey

/datum/design/item/autotailor/nonstandard/suit/resomi_black_white
	name = "black and white cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/standard/black_white

/datum/design/item/autotailor/nonstandard/suit/resomi_black_red
	name = "black and red cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/standard/black_red

/datum/design/item/autotailor/nonstandard/suit/resomi_black
	name = "black cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/standard/black

/datum/design/item/autotailor/nonstandard/suit/resomi_black_yellow
	name = "black and yellow cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/standard/black_yellow

/datum/design/item/autotailor/nonstandard/suit/resomi_black_green
	name = "black and green cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/standard/black_green

/datum/design/item/autotailor/nonstandard/suit/resomi_black_blue
	name = "black and blue cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/standard/black_blue

/datum/design/item/autotailor/nonstandard/suit/resomi_black_purple
	name = "black and purple cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/standard/black_purple

/datum/design/item/autotailor/nonstandard/suit/resomi_black_pink
	name = "black and pink cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/standard/black_pink

/datum/design/item/autotailor/nonstandard/suit/resomi_black_brown
	name = "black and brown cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/standard/black_brown

/datum/design/item/autotailor/nonstandard/suit/resomi_orange_grey
	name = "orange and grey cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/standard/orange_grey

/datum/design/item/autotailor/nonstandard/suit/resomi_rainbow
	name = "rainbow cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/standard/rainbow

/datum/design/item/autotailor/nonstandard/suit/resomi_lightgrey_grey
	name = "light grey and grey cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/standard/lightgrey_grey

/datum/design/item/autotailor/nonstandard/suit/resomi_white_grey
	name = "white and grey cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/standard/white_grey

/datum/design/item/autotailor/nonstandard/suit/resomi_red_grey
	name = "red and grey cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/standard/red_grey

/datum/design/item/autotailor/nonstandard/suit/resomi_orange
	name = "orange cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/standard/orange

/datum/design/item/autotailor/nonstandard/suit/resomi_yellow_grey
	name = "yellow and grey cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/standard/yellow_grey

/datum/design/item/autotailor/nonstandard/suit/resomi_green_grey
	name = "green and grey cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/standard/green_grey

/datum/design/item/autotailor/nonstandard/suit/resomi_blue_grey
	name = "blue and grey cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/standard/blue_grey

/datum/design/item/autotailor/nonstandard/suit/resomi_purple_grey
	name = "purple and grey cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/standard/purple_grey

/datum/design/item/autotailor/nonstandard/suit/resomi_pink_grey
	name = "pink and grey cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/standard/pink_grey

/datum/design/item/autotailor/nonstandard/suit/resomi_brown_grey
	name = "brown and grey cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/standard/brown_grey

/datum/design/item/autotailor/nonstandard/suit/resomi_cargo
	name = "cargo cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/jobs/cargo

/datum/design/item/autotailor/nonstandard/suit/resomi_mining
	name = "mining cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/jobs/mining

/datum/design/item/autotailor/nonstandard/suit/resomi_command
	name = "command cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/jobs/command

/datum/design/item/autotailor/nonstandard/suit/resomi_ce
	name = "chief engineer cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/jobs/ce

/datum/design/item/autotailor/nonstandard/suit/resomi_engineer
	name = "engineering cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/jobs/eningeer

/datum/design/item/autotailor/nonstandard/suit/resomi_atmos
	name = "atmospherics cloac"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/jobs/atmos

/datum/design/item/autotailor/nonstandard/suit/resomi_cmo
	name = "chief medical officer cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/jobs/cmo

/datum/design/item/autotailor/nonstandard/suit/resomi_medical
	name = "medical cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/jobs/medical

/datum/design/item/autotailor/nonstandard/suit/resomi_chemistry
	name = "chemistry cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/jobs/chemistry

/datum/design/item/autotailor/nonstandard/suit/resomi_viro
	name = "virologist cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/jobs/viro

/datum/design/item/autotailor/nonstandard/suit/resomi_para
	name = "paramedic cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/jobs/para

/datum/design/item/autotailor/nonstandard/suit/resomi_sci
	name = "science cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/jobs/sci

/datum/design/item/autotailor/nonstandard/suit/resomi_robo
	name = "robotics cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/jobs/robo

/datum/design/item/autotailor/nonstandard/suit/resomi_sec
	name = "security cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/jobs/sec

/datum/design/item/autotailor/nonstandard/suit/resomi_qm
	name = "quartermaster cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/jobs/qm

/datum/design/item/autotailor/nonstandard/suit/resomi_service
	name = "service cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/jobs/service

/datum/design/item/autotailor/nonstandard/suit/resomi_iaa
	name = "internal affairs cloak"
	build_path = /obj/item/clothing/suit/storage/resomi/cloak/jobs/iaa

//
//costumes
//i might be too harsh on considering some of these to be costumes
/datum/design/item/autotailor/nonstandard/costume
	category = "Costumes"
	materials = list(MATERIAL_CLOTH = 10000)

/datum/design/item/autotailor/nonstandard/costume/harness
	name = "gear harness"
	id = "gear harness"
	build_path = /obj/item/clothing/under/harness
	materials = list(MATERIAL_LEATHER = 500)

/datum/design/item/autotailor/nonstandard/costume/wetsuit
	name = "tactical wetsuit"
	id = "wetsuit"
	build_path = /obj/item/clothing/under/wetsuit
	materials = list(MATERIAL_LEATHER = 500)

/datum/design/item/autotailor/nonstandard/costume/snorkel
	name = "Snorkel"
	id = "snorkel"
	build_path = /obj/item/clothing/mask/snorkel
	materials = list(MATERIAL_PLASTIC = 2000)

/datum/design/item/autotailor/nonstandard/costume/fins
	name = "Swimming fins"
	id = "fins"
	build_path = /obj/item/clothing/shoes/swimmingfins
	materials = list(MATERIAL_PLASTIC = 2000)

/datum/design/item/autotailor/nonstandard/costume/savage_hunter
	name = "savage hunter's hides"
	id = "savage_hunter"
	build_path = /obj/item/clothing/under/savage_hunter
	materials = list(MATERIAL_LEATHER = 5000)

/datum/design/item/autotailor/nonstandard/costume/savage_huntress
	name = "savage huntress's hides"
	id = "savage_huntress"
	build_path = /obj/item/clothing/under/savage_hunter/female
	materials = list(MATERIAL_LEATHER = 5000)

/datum/design/item/autotailor/nonstandard/costume/eastern
	name = "Eastern dress"
	id = "eastern"
	build_path = /obj/item/clothing/under/dress/ysing

/datum/design/item/autotailor/nonstandard/costume/gladiator
	name = "Gladiator's robes"
	id = "gladiator"
	build_path = /obj/item/clothing/under/gladiator
	materials = list(MATERIAL_LEATHER = 5000)

/datum/design/item/autotailor/nonstandard/costume/gladiator_head
	name = "Gladiator's helmet"
	id = "gladiator_head"
	build_path = /obj/item/clothing/head/helmet/gladiator/costume
	materials = list(MATERIAL_STEEL = 2000)

/datum/design/item/autotailor/nonstandard/costume/schoolgirl
	name = "schoolgirl uniform"
	id = "schoolgirl"
	build_path = /obj/item/clothing/under/schoolgirl

/datum/design/item/autotailor/nonstandard/costume/pirate
	name = "pirate uniform"
	id = "pirate"
	build_path = /obj/item/clothing/under/pirate

/datum/design/item/autotailor/nonstandard/costume/soviet
	name = "soviet uniform"
	id = "soviet"
	build_path = /obj/item/clothing/under/soviet

/datum/design/item/autotailor/nonstandard/costume/soviet_ushanka
	name = "soviet ushanka"
	id = "soviet_ushanka"
	build_path = /obj/item/clothing/head/ushanka
	materials = list(MATERIAL_CLOTH = 2000)

/datum/design/item/autotailor/nonstandard/costume/johnny	//this can be moved over to standard jumpsuits if renamed
	name = "johnny jumpsuit"
	id = "johnny"
	build_path = /obj/item/clothing/under/johnny

/datum/design/item/autotailor/nonstandard/costume/owl
	name = "Owl costume"
	id = "owl"
	build_path = /obj/item/clothing/under/owl

/datum/design/item/autotailor/nonstandard/costume/redcoat
	name = "Redcoat uniform"
	id = "redcoat"
	build_path = /obj/item/clothing/under/redcoat
	materials = list(MATERIAL_LEATHER = 5000)

/datum/design/item/autotailor/nonstandard/costume/redcoat_hat
	name = "Redcoat hat"
	id = "redcoat_hat"
	build_path = /obj/item/clothing/head/redcoat
	materials = list(MATERIAL_CLOTH = 2000)

/datum/design/item/autotailor/nonstandard/costume/rogue
	name = "rogue uniform"
	id = "rogue"
	build_path = /obj/item/clothing/under/captain_fly

/datum/design/item/autotailor/nonstandard/costume/psysuit
	name = "Dark uniform"
	id = "psysuit"
	build_path = /obj/item/clothing/under/psysuit

/datum/design/item/autotailor/nonstandard/costume/mime
	name = "Mime uniform"
	id = "mime"
	build_path = /obj/item/clothing/under/mime

/datum/design/item/autotailor/nonstandard/costume/mime_mask
	name = "Mime mask"
	id = "mime_mask"
	build_path = /obj/item/clothing/mask/gas/mime
	materials = list(MATERIAL_PLASTIC = 5000)

/datum/design/item/autotailor/nonstandard/costume/mime_sexy
	name = "Sexy mime uniform"
	id = "mime_sexy"
	build_path = /obj/item/clothing/under/sexymime

/datum/design/item/autotailor/nonstandard/costume/mime_maskf
	name = "Female mime mask"
	id = "mime_maskf"
	build_path = /obj/item/clothing/mask/gas/sexymime
	materials = list(MATERIAL_PLASTIC = 5000)

/datum/design/item/autotailor/nonstandard/costume/mime_susp
	name = "Mime Suspendors"
	id = "mime_susp"
	build_path = /obj/item/clothing/accessory/suspenders

/datum/design/item/autotailor/nonstandard/costume/clown
	name = "Clown uniform"
	id = "clown"
	build_path = /obj/item/clothing/under/rank/clown

/datum/design/item/autotailor/nonstandard/costume/clown_mask
	name = "Clown mask"
	id = "clown_mask"
	build_path = /obj/item/clothing/mask/gas/clown_hat
	materials = list(MATERIAL_PLASTIC = 5000)

/datum/design/item/autotailor/nonstandard/costume/clown_sexy
	name = "Sexy clown uniform"
	id = "clown_sexy"
	build_path = /obj/item/clothing/under/sexyclown

/datum/design/item/autotailor/nonstandard/costume/clown_maskf
	name = "Female clown mask"
	id = "clwon_maskf"
	build_path = /obj/item/clothing/mask/gas/sexyclown
	materials = list(MATERIAL_PLASTIC = 5000)

/datum/design/item/autotailor/nonstandard/costume/clown_shoe
	name = "Clown shoes"
	id = "clown_shoe"
	build_path = /obj/item/clothing/shoes/clown_shoes
	materials = list(MATERIAL_LEATHER = 2000, MATERIAL_PLASTIC = 1000)

/datum/design/item/autotailor/nonstandard/costume/pirate_coat
	name = "Pirate coat"
	id = "pirate_coat"
	build_path = /obj/item/clothing/suit/pirate

/datum/design/item/autotailor/nonstandard/costume/pirate_coat_admiral
	name = "Pirate admiral coat"
	id = "pirate_coat_admiral"
	build_path = /obj/item/clothing/suit/hgpirate

/datum/design/item/autotailor/nonstandard/costume/pirate_hat_admiral
	name = "Pirate admiral hat"
	id = "pirate_hat_admiral"
	build_path = /obj/item/clothing/head/hgpiratecap
	materials = list(MATERIAL_CLOTH = 2000)

/datum/design/item/autotailor/nonstandard/costume/pirate_bandana
	name = "Pirate bandana"
	id = "pirate_bandana"
	build_path = /obj/item/clothing/head/bandana
	materials = list(MATERIAL_CLOTH = 2000)

/datum/design/item/autotailor/nonstandard/costume/pirate_hat
	name = "Pirate hat"
	id = "pirate_hat"
	build_path = /obj/item/clothing/head/pirate
	materials = list(MATERIAL_CLOTH = 2000)

/datum/design/item/autotailor/nonstandard/costume/old_robes
	name = "Ancient robes"
	id = "old_robes"
	build_path = /obj/item/clothing/suit/unathi/robe

/datum/design/item/autotailor/nonstandard/costume/torn_cloak
	name = "War-torn cloak"
	id = "torn_cloak"
	build_path = /obj/item/clothing/suit/unathi/mantle
	materials = list(MATERIAL_LEATHER = 4000)

/datum/design/item/autotailor/nonstandard/costume/armored_cult
	name = "cultist robes - armored"
	id = "armored_cult"
	build_path = /obj/item/clothing/suit/cultrobes/costume
	materials = list(MATERIAL_LEATHER = 5000, MATERIAL_STEEL = 500)

/datum/design/item/autotailor/nonstandard/costume/sorcery_cult_r
	name = "cultist robes - red sorcerer"
	id = "sorcery_cult_r"
	build_path = /obj/item/clothing/suit/cultrobes/magusred/costume

/datum/design/item/autotailor/nonstandard/costume/sorcery_cult_b
	name = "cultist robes - blue sorcerer"
	id = "sorcery_cult_b"
	build_path = /obj/item/clothing/suit/wizrobe/magusblue/fake

/datum/design/item/autotailor/nonstandard/costume/cult
	name = "cultist robes - standard"
	id = "cult"
	build_path = /obj/item/clothing/suit/cultrobes/alt/costume

/datum/design/item/autotailor/nonstandard/costume/cult_head_grey
	name = "cultist hood - grey"
	id = "cult_head_grey"
	build_path = /obj/item/clothing/head/culthood/alt/costume
	materials = list(MATERIAL_CLOTH = 2000)

/datum/design/item/autotailor/nonstandard/costume/cult_head_red
	name = "cultist hood - red"
	id = "cult_head_red"
	build_path = /obj/item/clothing/head/culthood/costume
	materials = list(MATERIAL_CLOTH = 2000)

/datum/design/item/autotailor/nonstandard/costume/cult_head_warrior
	name = "cultist helmet - warrior"
	id = "cult_head_warrior"
	build_path = /obj/item/clothing/head/culthood/magus/costume
	materials = list(MATERIAL_CLOTH = 2000)

/datum/design/item/autotailor/nonstandard/costume/red_suit_armor
	name = "Armored suit - red team"
	id = "red_suit_armor"
	build_path = /obj/item/clothing/suit/armor/tdome/red
	materials = list(MATERIAL_STEEL = 10000)

/datum/design/item/autotailor/nonstandard/costume/green_suit_armor
	name = "Armored suit - green team"
	id = "green_suit_armor"
	build_path = /obj/item/clothing/suit/armor/tdome/green
	materials = list(MATERIAL_STEEL = 10000)

/datum/design/item/autotailor/nonstandard/costume/armor_suit_head
	name = "Armored suit helmet"
	id = "green_suit_head"
	build_path = /obj/item/clothing/head/helmet/thunderdome/costume
	materials = list(MATERIAL_STEEL = 2000)

/datum/design/item/autotailor/nonstandard/costume/cardboard
	name = "Cardboard suit"
	id = "cardboard"
	build_path = /obj/item/clothing/suit/cardborg
	materials = list("cardboard" = 2000)

/datum/design/item/autotailor/nonstandard/costume/cardboard_head
	name = "Cardboard helmet"
	id = "cardboard_head"
	build_path = /obj/item/clothing/head/cardborg
	materials = list("cardboard" = 6000)

/datum/design/item/autotailor/nonstandard/costume/purple_robe
	name = "Robes - embelished purple"
	id = "purple_robe"
	build_path = /obj/item/clothing/suit/wizrobe/psypurple/fake
	materials = list(MATERIAL_CLOTH = 10000, MATERIAL_PHORON = 4000)

/datum/design/item/autotailor/nonstandard/costume/purple_robe_head
	name = "Robes - embelished purple head"
	id = "purple_robe_head"
	build_path = /obj/item/clothing/head/wizard/amp/fake
	materials = list(MATERIAL_CLOTH = 2000, MATERIAL_PHORON = 1000)

/datum/design/item/autotailor/nonstandard/costume/red_robe
	name = "Robes - red"
	id = "red_robe"
	build_path = /obj/item/clothing/suit/wizrobe/red/fake

/datum/design/item/autotailor/nonstandard/costume/red_robe_head
	name = "Robes - red hat"
	id = "red_robe_hat"
	build_path = /obj/item/clothing/head/wizard/red/fake
	materials = list(MATERIAL_CLOTH = 2000)

/datum/design/item/autotailor/nonstandard/costume/blue_basic_robe
	name = "Robes - basic blue"
	id = "blue_basic_robe"
	build_path = /obj/item/clothing/suit/wizrobe/old/fake

/datum/design/item/autotailor/nonstandard/costume/blue_robe
	name = "Robes - blue"
	id = "blue_robe"
	build_path = /obj/item/clothing/suit/wizrobe/fake

/datum/design/item/autotailor/nonstandard/costume/blue_robe_head
	name = "Robes - blue hat"
	id = "blue_robe_head"
	build_path = /obj/item/clothing/head/wizard
	materials = list(MATERIAL_CLOTH = 2000)

/datum/design/item/autotailor/nonstandard/costume/blue_robe_headbeard
	name = "Robes - blue hat w. beard"
	id = "blue_robe_headbeard"
	build_path = /obj/item/clothing/head/wizard/fake
	materials = list(MATERIAL_CLOTH = 3000)

/datum/design/item/autotailor/nonstandard/costume/witch_robe
	name = "Robes - witch"
	id = "witch_robe"
	build_path = /obj/item/clothing/suit/wizrobe/marisa/fake

/datum/design/item/autotailor/nonstandard/costume/witch_robe_head
	name = "Robes - witch hat"
	id = "witch_robe_head"
	build_path = /obj/item/clothing/head/wizard/marisa/fake
	materials = list(MATERIAL_CLOTH = 2000)

/datum/design/item/autotailor/nonstandard/costume/witch_robe_redhead
	name = "Robes - redhead witch hat"
	id = "witch_robe_redhead"
	build_path = /obj/item/clothing/head/witchwig
	materials = list(MATERIAL_CLOTH = 3000)

/datum/design/item/autotailor/nonstandard/costume/rubber_human
	name = "Rubber suit - human"
	id = "rubber_human"
	build_path = /obj/item/clothing/suit/rubber
	materials = list(MATERIAL_PLASTIC = 20000)

/datum/design/item/autotailor/nonstandard/costume/human_mask_generic
	name = "Rubber suit mask - generic human"
	id = "human_mask_generic"
	build_path = /obj/item/clothing/mask/rubber/species
	materials = list(MATERIAL_PLASTIC = 2000)

/datum/design/item/autotailor/nonstandard/costume/human_mask_gotee
	name = "Rubber suit mask - gotee human"
	id = "human_mask_gotee"
	build_path = /obj/item/clothing/mask/rubber/trasen
	materials = list(MATERIAL_PLASTIC = 2000)

/datum/design/item/autotailor/nonstandard/costume/human_mask_shaved
	name = "Rubber suit mask - shaved human"
	id = "human_mask_shaved"
	build_path = /obj/item/clothing/mask/rubber/turner
	materials = list(MATERIAL_PLASTIC = 2000)

/datum/design/item/autotailor/nonstandard/costume/human_mask_moustache
	name = "Rubber suit mask - moustache human"
	id = "human_mask_moustache"
	build_path = /obj/item/clothing/mask/rubber/admiral
	materials = list(MATERIAL_PLASTIC = 2000)

/datum/design/item/autotailor/nonstandard/costume/human_mask_female
	name = "Rubber suit mask - female human"
	id = "human_mask_female"
	build_path = /obj/item/clothing/mask/rubber/barros
	materials = list(MATERIAL_PLASTIC = 2000)

/datum/design/item/autotailor/nonstandard/costume/rubber_skrell
	name = "Rubber suit - skrell"
	id = "rubber_skrell"
	build_path = /obj/item/clothing/suit/rubber/skrell
	materials = list(MATERIAL_PLASTIC = 20000)

/datum/design/item/autotailor/nonstandard/costume/skrell_mask
	name = "Rubber suit mask - skrell"
	id = "skrell_mask"
	build_path = /obj/item/clothing/mask/rubber/species/skrell
	materials = list(MATERIAL_PLASTIC = 2000)

/datum/design/item/autotailor/nonstandard/costume/rubber_lizard
	name = "Rubber suit - lizard"
	id = "rubber_lizard"
	build_path = /obj/item/clothing/suit/rubber/unathi
	materials = list(MATERIAL_PLASTIC = 20000)

/datum/design/item/autotailor/nonstandard/costume/lizard_mask
	name = "Rubber suit mask - lizard"
	id = "lizard_mask"
	build_path = /obj/item/clothing/mask/rubber/species/unathi
	materials = list(MATERIAL_PLASTIC = 2000)

/datum/design/item/autotailor/nonstandard/costume/rubber_cat
	name = "Rubber suit - cat"
	id = "rubber_cat"
	build_path = /obj/item/clothing/suit/rubber/cat
	materials = list(MATERIAL_PLASTIC = 20000)

/datum/design/item/autotailor/nonstandard/costume/cat_mask
	name = "Rubber suit mask - cat"
	id = "cat_mask"
	build_path = /obj/item/clothing/mask/rubber/species/cat
	materials = list(MATERIAL_PLASTIC = 2000)

/datum/design/item/autotailor/nonstandard/costume/rubber_sumo
	name = "Rubber suit - sumo wrestler"
	id = "rubber_sumo"
	build_path = /obj/item/clothing/suit/sumo
	materials = list(MATERIAL_PLASTIC = 20000)

/datum/design/item/autotailor/nonstandard/costume/body_monkey
	name = "Body suit - monkey"
	id = "body_monkey"
	build_path = /obj/item/clothing/suit/monkeysuit

/datum/design/item/autotailor/nonstandard/costume/monkey_mask
	name = "Body suit mask - monkey"
	id = "monkey_mask"
	build_path = /obj/item/clothing/mask/gas/monkeymask
	materials = list(MATERIAL_CLOTH = 2000)

/datum/design/item/autotailor/nonstandard/costume/body_chicken
	name = "Body suit - chicken"
	id = "body_chicken"
	build_path = /obj/item/clothing/suit/chickensuit
	materials = list(MATERIAL_PLASTIC = 20000)

/datum/design/item/autotailor/nonstandard/costume/head_chicken
	name = "Body suit hat - chicken"
	id = "head_chicken"
	build_path = /obj/item/clothing/head/chicken
	materials = list(MATERIAL_PLASTIC = 2000)

/datum/design/item/autotailor/nonstandard/costume/ltag_blue
	name = "Laser tag armor - blue team"
	id = "ltag_blue"
	build_path = /obj/item/clothing/suit/bluetag
	materials = list(MATERIAL_STEEL = 2000)

/datum/design/item/autotailor/nonstandard/costume/ltag_red
	name = "Laster tag armor - red team"
	id = "ltag_red"
	materials = list(MATERIAL_STEEL = 2000)

/datum/design/item/autotailor/nonstandard/costume/labcoat_madlad
	name = "Labcoat - mad scientist"
	id = "labcoat_madlad"
	build_path = /obj/item/clothing/suit/storage/toggle/labcoat/mad
	materials = list(MATERIAL_LEATHER = 5000)

/datum/design/item/autotailor/nonstandard/costume/techno_monk
	name = "Robes - imperium monk"
	id = "techno_monk"
	build_path = /obj/item/clothing/suit/imperium_monk
	materials = list(MATERIAL_CLOTH = 10000, MATERIAL_PHORON = 4000)

/datum/design/item/autotailor/nonstandard/costume/hastur
	name = "Hastur robes"
	id = "hastur"
	build_path = /obj/item/clothing/suit/hastur
	materials = list(MATERIAL_CLOTH = 10000, MATERIAL_PHORON = 4000)

/datum/design/item/autotailor/nonstandard/costume/hastur_hood
	name = "Hastur hood"
	id = "hastur_hood"
	build_path = /obj/item/clothing/head/hasturhood
	materials = list(MATERIAL_CLOTH = 2000, MATERIAL_PHORON = 1000)

/datum/design/item/autotailor/nonstandard/costume/plague_doc
	name = "Plague doctor suit"
	id = "plague_doc"
	build_path = /obj/item/clothing/suit/bio_suit/plaguedoctorsuit/costume
	materials = list(MATERIAL_LEATHER = 20000)

/datum/design/item/autotailor/nonstandard/costume/plague_doc_hat
	name = "Plague doctor hat"
	id = "plague_doc_hat"
	build_path = /obj/item/clothing/head/plaguedoctorhat
	materials = list(MATERIAL_LEATHER = 2000)

/datum/design/item/autotailor/nonstandard/costume/hero_justice
	name = "Justice suit"
	id = "hero_justic"
	build_path = /obj/item/clothing/suit/justice

//most of the following suits below really should be modified or removed, they take up head, feets, eye, etc. slots without occupying them
/datum/design/item/autotailor/nonstandard/costume/maxman
	name = "Dr maxman costume"
	id = "maxman"
	build_path = /obj/item/clothing/suit/maxman

/datum/design/item/autotailor/nonstandard/costume/minekini
	name = "Sexy miner costume"
	id = "minekini"
	build_path = /obj/item/clothing/suit/sexyminer

/datum/design/item/autotailor/nonstandard/costume/engkini
	name = "Sexy engineer costume"
	id = "engkini"
	build_path = /obj/item/clothing/suit/engicost

/datum/design/item/autotailor/nonstandard/costume/ia_sexy
	name = "Sexy internal affairs costume"
	id = "ia_sexy"
	build_path = /obj/item/clothing/suit/iasexy

/datum/design/item/autotailor/nonstandard/costume/lumber_sexy
	name = "Sexy lumberjack costume"
	id = "lumber_sexy"
	build_path = /obj/item/clothing/suit/lumber

/datum/design/item/autotailor/nonstandard/costume/skeleton
	name = "Spooky skeleton costume"
	id = "skeleton"
	build_path = /obj/item/clothing/suit/skeleton

/datum/design/item/autotailor/nonstandard/costume/hackerman
	name = "Clasic hacker costume"
	id = "hackerman"
	build_path = /obj/item/clothing/suit/hackercost

/datum/design/item/autotailor/nonstandard/costume/rooster_hat
	name = "Rooster face mask"
	id = "rooster_hat"
	build_path = /obj/item/clothing/head/richard
	materials = list(MATERIAL_PLASTIC = 2000)

/datum/design/item/autotailor/nonstandard/costume/pumpkin
	name = "Carved pumpkin mask"
	id = "pumpkin"
	build_path = /obj/item/clothing/head/pumpkinhead
	materials = list(MATERIAL_PLASTIC = 2000)

/datum/design/item/autotailor/nonstandard/costume/bday_hat
	name = "Birthday cake hat"
	id = "bday_hat"
	build_path = /obj/item/clothing/head/cakehat
	materials = list(MATERIAL_PLASTIC = 2000)

/datum/design/item/autotailor/nonstandard/costume/crown
	name = "Royal crown"
	id = "crown"
	build_path = /obj/item/clothing/head/crown
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_PHORON = 5000)

/datum/design/item/autotailor/nonstandard/costume/paper_crown
	name = "Paper crown - rainbow"
	id = "paper_crown"
	build_path = /obj/item/clothing/head/festive
	materials = list("cardboard" = 2000)

/datum/design/item/autotailor/nonstandard/costume/paper_hat	//can use custom colors
	name = "Paper hat"
	id = "paper_hat"
	build_path = /obj/item/clothing/head/collectable/paper
	materials = list("cardboard" = 2000)

/datum/design/item/autotailor/nonstandard/costume/rabbitears	//remove tail
	name = "Rabbit ears"
	id = "rabbitears"
	build_path = /obj/item/clothing/head/rabbitears

/datum/design/item/autotailor/nonstandard/costume/catears	//remove tail
	name = "kitty ears"
	id = "catears"
	build_path = /obj/item/clothing/head/kitty

/datum/design/item/autotailor/nonstandard/costume/wig
	name = "Powdered wig"
	id = "wig"
	build_path = /obj/item/clothing/head/powdered_wig
	materials = list(MATERIAL_CLOTH = 2000)

/datum/design/item/autotailor/nonstandard/costume/big_wig
	name = "Philospher's wig"
	id = "big_wig"
	build_path = /obj/item/clothing/head/philosopher_wig

/datum/design/item/autotailor/nonstandard/costume/white_ball	//can use custom colors
	name = "Cueball - white"
	id = "white_ball"
	build_path = /obj/item/clothing/head/cueball
	materials = list(MATERIAL_PLASTIC = 10000)

/datum/design/item/autotailor/nonstandard/costume/wresling_luchador
	name = "Wreslting mask - luchador"
	id = "wresling_luchador"
	build_path = /obj/item/clothing/mask/luchador
	materials = list(MATERIAL_CLOTH = 2000)

/datum/design/item/autotailor/nonstandard/costume/wresling_rudos
	name = "Wresling mask - rudos"
	id = "wresling_rudos"
	build_path = /obj/item/clothing/mask/luchador/rudos
	materials = list(MATERIAL_CLOTH = 2000)

/datum/design/item/autotailor/nonstandard/costume/wresling_tecnicos
	name = "Wresling mask - tecnicos"
	id = "wresling_technicos"
	build_path = /obj/item/clothing/mask/luchador/tecnicos
	materials = list(MATERIAL_CLOTH = 2000)

/datum/design/item/autotailor/nonstandard/costume/wresling_belt
	name = "Championship belt"
	id = "wresling_belt"
	build_path = /obj/item/weapon/storage/belt/champion
	materials = list(MATERIAL_LEATHER = 2000, MATERIAL_PHORON = 20000)

/datum/design/item/autotailor/nonstandard/costume/pig_mask
	name = "Entertainment - pig"
	id = "pig_mask"
	build_path = /obj/item/clothing/mask/pig
	materials = list(MATERIAL_PLASTIC = 2000)

/datum/design/item/autotailor/nonstandard/costume/horse_mask
	name = "Entertainment - silly horse"
	id = "horse_mask"
	build_path = /obj/item/clothing/mask/horsehead
	materials = list(MATERIAL_PLASTIC = 2000)

/datum/design/item/autotailor/nonstandard/costume/fake_moustache
	name = "Entertainment - moustache"
	id = "fake_moustache"
	build_path = /obj/item/clothing/mask/fakemoustache
	materials = list(MATERIAL_PLASTIC = 2000)

/datum/design/item/autotailor/nonstandard/costume/tribal
	name = "Tribal mask"
	id = "tribal"
	build_path = /obj/item/clothing/mask/spirit
	materials = list(MATERIAL_WOOD = 5000)

/datum/design/item/autotailor/nonstandard/costume/slime_green
	name = "Slime hat - green"
	id = "slime_green"
	build_path = /obj/item/clothing/head/collectable/slime
	materials = list(MATERIAL_PLASTIC = 2000)

//
//hazard suits
//
/datum/design/item/autotailor/nonstandard/hazard
	category = "Hazard suits"

/datum/design/item/autotailor/nonstandard/hazard/bio_orange
	name = "Biosuit - orange stripe"
	id = "bio_orange"
	build_path = /obj/item/clothing/suit/bio_suit/general
	materials = list(MATERIAL_LEATHER = 20000, MATERIAL_PLASTEEL = 30000)

/datum/design/item/autotailor/nonstandard/hazard/biohood_orange
	name = "Biosuit hood - orange stripe"
	id = "biohood_orange"
	build_path = /obj/item/clothing/head/bio_hood/general
	materials = list(MATERIAL_LEATHER = 5000, MATERIAL_PLASTEEL = 10000)

/datum/design/item/autotailor/nonstandard/hazard/bio_blue
	name = "Biosuit - blue stripe"
	id = "bio_blue"
	build_path = /obj/item/clothing/suit/bio_suit/cmo
	materials = list(MATERIAL_LEATHER = 20000, MATERIAL_PLASTEEL = 30000)

/datum/design/item/autotailor/nonstandard/hazard/biohood_blue
	name = "Biosuit hood - blue stripe"
	id = "biohood_blue"
	build_path = /obj/item/clothing/head/bio_hood/cmo
	materials = list(MATERIAL_LEATHER = 5000, MATERIAL_PLASTEEL = 10000)

/datum/design/item/autotailor/nonstandard/hazard/bio_green
	name = "Biosuit - green stripe"
	id = "bio_green"
	build_path = /obj/item/clothing/suit/bio_suit/virology
	materials = list(MATERIAL_LEATHER = 20000, MATERIAL_PLASTEEL = 30000)

/datum/design/item/autotailor/nonstandard/hazard/biohood_green
	name = "Biosuit hood - green stripe"
	id = "biohood_green"
	build_path = /obj/item/clothing/head/bio_hood/virology
	materials = list(MATERIAL_LEATHER = 5000, MATERIAL_PLASTEEL = 10000)

/datum/design/item/autotailor/nonstandard/hazard/bio_purp
	name = "Biosuit - purple"
	id = "bio_purp"
	build_path = /obj/item/clothing/suit/bio_suit/scientist
	materials = list(MATERIAL_LEATHER = 20000, MATERIAL_PLASTEEL = 30000)

/datum/design/item/autotailor/nonstandard/hazard/biohood_purple
	name = "Biosuit hood - purple"
	id = "biohood_purple"
	build_path = /obj/item/clothing/head/bio_hood/scientist
	materials = list(MATERIAL_LEATHER = 5000, MATERIAL_PLASTEEL = 10000)

/datum/design/item/autotailor/nonstandard/hazard/bio_purpgrey
	name = "Biosuit - grey w. purple stripe"
	id = "bio_purpgrey"
	build_path = /obj/item/clothing/suit/bio_suit/janitor
	materials = list(MATERIAL_LEATHER = 20000, MATERIAL_PLASTEEL = 30000)

/datum/design/item/autotailor/nonstandard/hazard/biohood_purpgrey
	name = "Biosuit hood - grey w. purple stripe"
	id = "biohood_purpgrey"
	build_path = /obj/item/clothing/head/bio_hood/janitor
	materials = list(MATERIAL_LEATHER = 5000, MATERIAL_PLASTEEL = 10000)

/datum/design/item/autotailor/nonstandard/hazard/bio_red
	name = "Biosuit - red stripe"
	id = "bio_red"
	build_path = /obj/item/clothing/suit/bio_suit/security
	materials = list(MATERIAL_LEATHER = 20000, MATERIAL_PLASTEEL = 30000)

/datum/design/item/autotailor/nonstandard/hazard/biohood_red
	name = "Biosuit hood - red stripe"
	id = "biohood_red"
	build_path = /obj/item/clothing/head/bio_hood/security
	materials = list(MATERIAL_LEATHER = 5000, MATERIAL_PLASTEEL = 10000)

/datum/design/item/autotailor/nonstandard/hazard/bio_adv
	name = "Biosuit - advanced"
	id = "bio_adv"
	build_path = /obj/item/clothing/suit/bio_suit/anomaly
	materials = list(MATERIAL_LEATHER = 20000, MATERIAL_PLASTEEL = 30000)

/datum/design/item/autotailor/nonstandard/hazard/biohood_adv
	name = "Biosuit hood - advanced"
	id = "biohood_adv"
	build_path = /obj/item/clothing/head/bio_hood/anomaly
	materials = list(MATERIAL_LEATHER = 5000, MATERIAL_PLASTEEL = 10000)

/datum/design/item/autotailor/nonstandard/hazard/rad_yellow
	name = "Radiation suit - yellow"
	id = "rad_yellow"
	build_path = /obj/item/clothing/suit/radiation
	materials = list(MATERIAL_LEATHER = 20000, MATERIAL_OSMIUM_CARBIDE_PLASTEEL = 30000)

/datum/design/item/autotailor/nonstandard/hazard/radhood_yellow
	name = "Radiation hood - yellow"
	id = "radhood_yellow"
	build_path = /obj/item/clothing/head/radiation
	materials = list(MATERIAL_LEATHER = 5000, MATERIAL_OSMIUM_CARBIDE_PLASTEEL = 10000)

/datum/design/item/autotailor/nonstandard/hazard/firesuit
	name = "Firesuit"
	id = "firesuit"
	build_path = /obj/item/clothing/suit/fire/firefighter
	materials = list(MATERIAL_LEATHER = 20000, MATERIAL_OSMIUM_CARBIDE_PLASTEEL = 30000)
