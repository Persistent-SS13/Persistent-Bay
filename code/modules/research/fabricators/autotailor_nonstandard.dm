/obj/machinery/fabricator/autotailor/nonstandard
	name = "auto-tailor (non-standard wear)"
	desc = "An advanced machine capable of printing many types of clothing, this one is loaded with non-standard clothing designs."
	circuit = /obj/item/weapon/circuitboard/fabricator/autotailor/nonstandard
	build_type = AUTOTAILOR_NONSTANDARD
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

/datum/design/item/autotailor/nonstandard	//anything here is broken or unsorted clothes
	build_type = AUTOTAILOR_NONSTANDARD
	category = "misc"
	req_tech = list(TECH_MATERIAL = 1)
	time = 1	//40

//////////////////////nonstandard clothing///////////////////////
/datum/design/item/autotailor/nonstandard/under
	category = "Undersuits - Nonstandard"
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/autotailor/nonstandard/under/vox_casual
	name = "Vox clothing - casual"
	id = "vox_casual"
	build_path = /obj/item/clothing/under/vox/vox_casual
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/under/vox_robes
	name = "Vox clothing - robes"
	id = "vox_robes"
	build_path = /obj/item/clothing/under/vox/vox_robes
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/under/pjs_red
	name = "Classic PJ's - red"
	id = "pjs_red"
	build_path = /obj/item/clothing/under/pj/red
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/under/pjs_blue
	name = "Classic PJ's - blue"
	id = "pjs_blue"
	build_path = /obj/item/clothing/under/pj/blue
	materials = list("cloth" = 500)
//blue and red have duplcicate "pyjamas"^

/datum/design/item/autotailor/nonstandard/under/scrubs_white	//canidate for custom colors
	name = "Scrubs - white"
	id = "scrubs_white"
	build_path = /obj/item/clothing/under/rank/medical/scrubs
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/under/scrubhood_white	//canidate for custom colors
	name = "Scrubs hat - white"
	id = "scrubhood_white"
	build_path = /obj/item/clothing/head/surgery
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/under/scrubs_black
	name = "Scrubs - black"
	id = "scrubs_black"
	build_path = /obj/item/clothing/under/rank/medical/scrubs/black
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/under/scrubhood_black
	name = "Scrubs hat - black"
	id = "scrubhood_black"
	build_path = /obj/item/clothing/head/surgery/black
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/under/scrubs_purple //is this actually purple?
	name = "Scrubs - purple"
	id = "scrubs_purple"
	build_path = /obj/item/clothing/under/rank/medical/scrubs/purple
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/under/scrubhood_purple	//see comment above
	name = "Scrubs hat - purple"
	id = "scrubhood_purple"
	build_path = /obj/item/clothing/head/surgery/purple
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/under/scrubs_blue
	name = "Scrubs - blue"
	id = "scrubs_blue"
	build_path = /obj/item/clothing/under/rank/medical/scrubs/blue
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/under/scrubhood_blue
	name = "Scrubs hat - blue"
	id = "scrubhood_blue"
	build_path = /obj/item/clothing/head/surgery/blue
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/under/scrubs_green
	name = "Scrubs - green"
	id = "scrubs_green"
	build_path = /obj/item/clothing/under/rank/medical/scrubs/green
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/under/scrubhood_green
	name = "Scrubs hat - green"
	id = "scrubs_green"
	build_path = /obj/item/clothing/head/surgery/green
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/under/scrubs_teal
	name = "Scrubs - teal"
	id = "scrubs_teal"
	build_path = /obj/item/clothing/under/rank/medical/scrubs/teal
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/under/scrubhood_teal
	name = "Scrubs hat - teal"
	id = "scrubhood_teal"
	build_path = /obj/item/clothing/head/surgery/teal
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/under/scrubs_heliodor
	name = "Scrubs - heliodor"
	id = "scrubs_heliodor"
	build_path = /obj/item/clothing/under/rank/medical/scrubs/heliodor
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/under/scrubhood_heliodor
	name = "Scrubs hat - heliodor"
	id = "scrubhood_heliodor"
	build_path = /obj/item/clothing/head/surgery/heliodor
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/under/scrubs_navyblue
	name = "Scrubs - navy blue"
	id = "scrubs_navyblue"
	build_path = /obj/item/clothing/under/rank/medical/scrubs/navyblue
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/under/scrubhood_navyblue
	name = "Scrubs hat - navy blue"
	id = "scrubhood_navyblue"
	build_path = /obj/item/clothing/head/surgery/navyblue
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/under/scrubs_lilac
	name = "Scrubs - lilac"
	id = "scrubs_lilac"
	build_path = /obj/item/clothing/under/rank/medical/scrubs/lilac
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/under/scrubhood_lilac
	name = "Scrubs hat - lilac"
	id = "scrubhood_lilac"
	build_path = /obj/item/clothing/head/surgery/lilac
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/under/swim_black
	name = "swimsuit - female black"
	id = "swim_black"
	build_path = /obj/item/clothing/under/swimsuit/black
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/under/swim_green
	name = "swimsuit - female green"
	id = "swim_green"
	build_path = /obj/item/clothing/under/swimsuit/green
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/under/swim_red
	name = "swimsuit - female red"
	id = "swim_red"
	build_path = /obj/item/clothing/under/swimsuit/red
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/under/swim_blue
	name = "swimsuit - female blue"
	id = "swim_blue"
	build_path = /obj/item/clothing/under/swimsuit/blue
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/under/swim_purple
	name = "swimsuit - female purple"
	id = "swim_purple"
	build_path = /obj/item/clothing/under/swimsuit/purple
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/under/mankini
	name = "swimsuit - mankini"
	id = "mankini"
	build_path = /obj/item/clothing/under/stripper/mankini
	materials = list("cloth" = 500)

//////////////////////nonstandard oversuits///////////////////////
/datum/design/item/autotailor/nonstandard/suit
	category = "Nonstandard Oversuits"
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/autotailor/nonstandard/suit/vox_armor
	name = "Vox makeshift armor"
	id = "vox_armor"
	build_path = /obj/item/clothing/suit/armor/vox_scrap
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/suit/fur	//probably remove
	name = "alien fur coat"
	id = "fur"
	build_path = /obj/item/clothing/suit/xeno/furs
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/suit/pjs_ian
	name = "Corgi PJs"
	id = "pjs_ian"
	build_path = /obj/item/clothing/suit/ianshirt
	materials = list("cloth" = 500)

//////////////////////costumes///////////////////////
//i might be too harsh on considering some of these to be costumes
/datum/design/item/autotailor/nonstandard/costume
	category = "Costumes"
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/autotailor/nonstandard/costume/harness
	name = "gear harness"
	id = "gear harness"
	build_path = /obj/item/clothing/under/harness
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/wetsuit
	name = "tactical wetsuit"
	id = "wetsuit"
	build_path = /obj/item/clothing/under/wetsuit
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/savage_hunter
	name = "savage hunter's hides"
	id = "savage_hunter"
	build_path = /obj/item/clothing/under/savage_hunter
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/savage_huntress
	name = "savage huntress's hides"
	id = "savage_huntress"
	build_path = /obj/item/clothing/under/savage_hunter/female
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/eastern
	name = "Eastern dress"
	id = "eastern"
	build_path = /obj/item/clothing/under/dress/ysing
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/gladiator
	name = "Gladiator's robes"
	id = "gladiator"
	build_path = /obj/item/clothing/under/gladiator
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/gladiator_head	//NERF NERF NERF
	name = "Gladiator's helmet"
	id = "gladiator_head"
	build_path = /obj/item/clothing/head/helmet/gladiator
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/schoolgirl
	name = "schoolgirl uniform"
	id = "schoolgirl"
	build_path = /obj/item/clothing/under/schoolgirl
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/pirate
	name = "pirate uniform"
	id = "pirate"
	build_path = /obj/item/clothing/under/pirate
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/soviet
	name = "soviet uniform"
	id = "soviet"
	build_path = /obj/item/clothing/under/soviet
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/soviet_ushanka
	name = "soviet ushanka"
	id = "soviet_ushanka"
	build_path = /obj/item/clothing/head/ushanka
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/johnny	//this can be moved over to standard jumpsuits if renamed
	name = "johnny jumpsuit"
	id = "johnny"
	build_path = /obj/item/clothing/under/johnny
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/owl
	name = "Owl costume"
	id = "owl"
	build_path = /obj/item/clothing/under/owl
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/redcoat
	name = "Redcoat uniform"
	id = "redcoat"
	build_path = /obj/item/clothing/under/redcoat
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/redcoat_hat
	name = "Redcoat hat"
	id = "redcoat_hat"
	build_path = /obj/item/clothing/head/redcoat
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/rogue
	name = "rogue uniform"
	id = "rogue"
	build_path = /obj/item/clothing/under/captain_fly
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/psysuit
	name = "Dark uniform"
	id = "psysuit"
	build_path = /obj/item/clothing/under/psysuit
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/mime
	name = "Mime uniform"
	id = "mime"
	build_path = /obj/item/clothing/under/mime
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/mime_mask
	name = "Mime mask"
	id = "mime_mask"
	build_path = /obj/item/clothing/mask/gas/mime
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/mime_sexy
	name = "Sexy mime uniform"
	id = "mime_sexy"
	build_path = /obj/item/clothing/under/sexymime
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/mime_maskf
	name = "Female mime mask"
	id = "mime_maskf"
	build_path = /obj/item/clothing/mask/gas/sexymime
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/mime_susp
	name = "Mime Suspendors"
	id = "mime_susp"
	build_path = /obj/item/clothing/accessory/suspenders
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/clown
	name = "Clown uniform"
	id = "clown"
	build_path = /obj/item/clothing/under/rank/clown
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/clown_mask
	name = "Clown mask"
	id = "clown_mask"
	build_path = /obj/item/clothing/mask/gas/clown_hat
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/clown_sexy
	name = "Sexy clown uniform"
	id = "clown_sexy"
	build_path = /obj/item/clothing/under/sexyclown
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/clown_maskf
	name = "Female clown mask"
	id = "clwon_maskf"
	build_path = /obj/item/clothing/mask/gas/sexyclown
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/pirate_coat
	name = "Pirate coat"
	id = "pirate_coat"
	build_path = /obj/item/clothing/suit/pirate
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/pirate_coat_admiral
	name = "Pirate admiral coat"
	id = "pirate_coat"
	build_path = /obj/item/clothing/suit/hgpirate
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/pirate_hat_admiral
	name = "Pirate admiral hat"
	id = "pirate_hat_admiral"
	build_path = /obj/item/clothing/head/hgpiratecap
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/pirate_bandana
	name = "Pirate bandana"
	id = "pirate_bandana"
	build_path = /obj/item/clothing/head/bandana
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/pirate_hat
	name = "Pirate hat"
	id = "pirate_hat"
	build_path = /obj/item/clothing/head/pirate
	materials = list("cloth" = 500)
//dupe^: /obj/item/clothing/head/helmet/pirate, /obj/item/clothing/head/collectable/pirate

/datum/design/item/autotailor/nonstandard/costume/old_robes
	name = "Ancient robes"
	id = "old_robes"
	build_path = /obj/item/clothing/suit/unathi/robe
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/torn_cloak
	name = "War-torn cloak"
	id = "torn_cloak"
	build_path = /obj/item/clothing/suit/unathi/mantle
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/armored_cult	//remove armor
	name = "cultist robes - armored"
	id = "armored_cult"
	build_path = /obj/item/clothing/suit/cultrobes
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/sorcery_cult_r //REMOVE ARMOR
	name = "cultist roves - red sorcerer"
	id = "sorcery_cult_r"
	build_path = /obj/item/clothing/suit/cultrobes/magusred
	materials = list("cloth" = 500)
//dupe: /obj/item/clothing/suit/wizrobe/magusred

/datum/design/item/autotailor/nonstandard/costume/sorcery_cult_b //REMOVE ARMOR
	name = "cultist roves - blue sorcerer"
	id = "sorcery_cult_b"
	build_path = /obj/item/clothing/suit/wizrobe/magusblue
	materials = list("cloth" = 500)
//need proper path

/datum/design/item/autotailor/nonstandard/costume/cult	//remove armor
	name = "cultist robes - standard"
	id = "cult"
	build_path = /obj/item/clothing/suit/cultrobes/alt
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/cult_head_grey //REMOVE ARMOR
	name = "cultist hood - grey"
	id = "cult_head_grey"
	build_path = /obj/item/clothing/head/culthood/alt
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/cult_head_red //REMOVE ARMOR
	name = "cultist hood - red"
	id = "cult_head_red"
	build_path = /obj/item/clothing/head/culthood
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/cult_head_warrior //REMOVE ARMOR
	name = "cultist helmet - warrior"
	id = "cult_head_warrior"
	build_path = /obj/item/clothing/head/culthood/magus
	materials = list("cloth" = 500)
//dupe^: /obj/item/clothing/head/wizard/magus

/datum/design/item/autotailor/nonstandard/costume/red_suit_armor
	name = "Armored suit - red team"
	id = "red_suit_armor"
	build_path = /obj/item/clothing/suit/armor/tdome/red
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/green_suit_armor
	name = "Armored suit - green team"
	id = "green_suit_armor"
	build_path = /obj/item/clothing/suit/armor/tdome/green
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/armor_suit_head
	name = "Armored suit helmet"
	id = "green_suit_armor"
	build_path = /obj/item/clothing/head/helmet/thunderdome
	materials = list("cloth" = 500)
//dupe^: /obj/item/clothing/head/collectable/thunderdome

/datum/design/item/autotailor/nonstandard/costume/cardboard
	name = "Cardboard suit"
	id = "cardboard"
	build_path = /obj/item/clothing/suit/cardborg
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/cardboard_head
	name = "Cardboard helmet"
	id = "cardboard_head"
	build_path = /obj/item/clothing/head/cardborg
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/purple_robe
	name = "Robes - embelished purple"
	id = "purple_robe"
	build_path = /obj/item/clothing/suit/wizrobe/psypurple
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/purple_robe_head
	name = "Robes - embelished purple head"
	id = "purple_robe_head"
	build_path = /obj/item/clothing/head/wizard/amp
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/red_robe
	name = "Robes - red"
	id = "red_robe"
	build_path = /obj/item/clothing/suit/wizrobe/red
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/red_robe_head
	name = "Robes - red hat"
	id = "red_robe_hat"
	build_path = /obj/item/clothing/head/wizard/red
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/blue_basic_robe
	name = "Robes - basic blue"
	id = "blue_basic_robe"
	build_path = /obj/item/clothing/suit/wizrobe/fake
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/blue_robe
	name = "Robes - blue"
	id = "blue_robe"
	build_path = /obj/item/clothing/suit/wizrobe
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/blue_robe_head
	name = "Robes - blue hat"
	id = "blue_robe_head"
	build_path = /obj/item/clothing/head/wizard
	materials = list("cloth" = 500)
//dupe^: /obj/item/clothing/head/collectable/wizard

/datum/design/item/autotailor/nonstandard/costume/blue_robe_headbeard
	name = "Robes - blue hat w. beard"
	id = "blue_robe_headbeard"
	build_path = /obj/item/clothing/head/wizard/fake
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/witch_robe
	name = "Robes - witch"
	id = "witch_robe"
	build_path = /obj/item/clothing/suit/wizrobe/marisa/fake
	materials = list("cloth" = 500)
//dupe: /obj/item/clothing/suit/wizrobe/marisa

/datum/design/item/autotailor/nonstandard/costume/witch_robe_head
	name = "Robes - witch hat"
	id = "witch_robe_head"
	build_path = /obj/item/clothing/head/wizard/marisa/fake
	materials = list("cloth" = 500)
//dupe: /obj/item/clothing/head/wizard/marisa

/datum/design/item/autotailor/nonstandard/costume/witch_robe_redhead
	name = "Robes - redhead witch hat"
	id = "witch_robe_redhead"
	build_path = /obj/item/clothing/head/witchwig
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/rubber_human
	name = "Rubber suit - human"
	id = "rubber_human"
	build_path = /obj/item/clothing/suit/rubber
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/human_mask_generic
	name = "Rubber suit mask - generic human"
	id = "human_mask_generic"
	build_path = /obj/item/clothing/mask/rubber/species
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/human_mask_gotee
	name = "Rubber suit mask - gotee human"
	id = "human_mask_gotee"
	build_path = /obj/item/clothing/mask/rubber/trasen
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/human_mask_shaved
	name = "Rubber suit mask - shaved human"
	id = "human_mask_shaved"
	build_path = /obj/item/clothing/mask/rubber/turner
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/human_mask_moustache
	name = "Rubber suit mask - moustache human"
	id = "human_mask_moustache"
	build_path = /obj/item/clothing/mask/rubber/admiral
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/human_mask_female
	name = "Rubber suit mask - female human"
	id = "human_mask_female"
	build_path = /obj/item/clothing/mask/rubber/barros
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/rubber_skrell
	name = "Rubber suit - skrell"
	id = "rubber_skrell"
	build_path = /obj/item/clothing/suit/rubber/skrell
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/skrell_mask
	name = "Rubber suit mask - skrell"
	id = "skrell_mask"
	build_path = /obj/item/clothing/mask/rubber/species/skrell
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/rubber_lizard
	name = "Rubber suit - lizard"	//outdated unathi sprite
	id = "rubber_lizard"
	build_path = /obj/item/clothing/suit/rubber/unathi
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/lizard_mask
	name = "Rubber suit mask - lizard"
	id = "lizard_mask"
	build_path = /obj/item/clothing/mask/rubber/species/unathi
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/rubber_cat
	name = "Rubber suit - cat"
	id = "rubber_cat"
	build_path = /obj/item/clothing/suit/rubber/cat
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/cat_mask
	name = "Rubber suit mask - cat"
	id = "cat_mask"
	build_path = /obj/item/clothing/mask/rubber/species/cat
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/rubber_sumo
	name = "Rubber suit - sumo wrestler"
	id = "rubber_sumo"
	build_path = /obj/item/clothing/suit/sumo
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/body_monkey
	name = "Body suit - monkey"
	id = "body_monkey"
	build_path = /obj/item/clothing/suit/monkeysuit
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/monkey_mask
	name = "Body suit mask - monkey"
	id = "monkey_mask"
	build_path = /obj/item/clothing/mask/gas/monkeymask
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/body_chicken
	name = "Body suit - chicken"
	id = "body_chicken"
	build_path = /obj/item/clothing/suit/chickensuit
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/head_chicken
	name = "Body suit hat - chicken"
	id = "head_chicken"
	build_path = /obj/item/clothing/head/chicken
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/body_alien
	name = "Body suit - generic alien"
	id = "body_alien"
	build_path = /obj/item/clothing/suit/xenos
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/head_alien
	name = "Body suit hat - generic alien"
	id = "head_alien"
	build_path = /obj/item/clothing/head/xenos
	materials = list("cloth" = 500)
//dupe^: /obj/item/clothing/head/collectable/xenom

/datum/design/item/autotailor/nonstandard/costume/ltag_blue
	name = "Laser tag armor - blue team"
	id = "ltag_blue"
	build_path = /obj/item/clothing/suit/bluetag
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/ltag_red
	name = "Laster tag armor - red team"
	id = "ltag_red"
	build_path = /obj/item/clothing/suit/redtag
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/labcoat_madlad
	name = "Labcoat - mad scientist"
	id = "labcoat_madlab"
	build_path = /obj/item/clothing/suit/storage/toggle/labcoat/mad
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/fake_space	//probably remove
	name = "Replica space suit - red"
	id = "fake_space"
	build_path = /obj/item/clothing/suit/syndicatefake
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/fake_space_head	//probably remove
	name = "Replica space helmet - red"
	id = "fake_space_head"
	build_path = /obj/item/clothing/head/syndicatefake
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/techno_monk
	name = "Robes - imperium monk"
	id = "techno_monk"
	build_path = /obj/item/clothing/suit/imperium_monk
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/hastur	//wtf is a hastur
	name = "Hastur robes"
	id = "hastur"
	build_path = /obj/item/clothing/suit/hastur
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/hastur_hood	//wtf is a hastur
	name = "Hastur hood"
	id = "hastur_hood"
	build_path = /obj/item/clothing/head/hasturhood
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/plague_doc	//remove protection
	name = "Plague doctor suit"
	id = "plague_doc"
	build_path = /obj/item/clothing/suit/bio_suit/plaguedoctorsuit
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/plague_doc_hat
	name = "Plague doctor hat"
	id = "plague_doc_hat"
	build_path = /obj/item/clothing/head/plaguedoctorhat
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/hero_justice
	name = "Justice suit"
	id = "hero_justic"
	build_path = /obj/item/clothing/suit/justice
	materials = list("cloth" = 500)

//most of the following suits below really should be modified or removed.. we have helmet, eye,etc. slots for a reason...
/datum/design/item/autotailor/nonstandard/costume/maxman
	name = "Dr maxman costume"
	id = "maxman"
	build_path = /obj/item/clothing/suit/maxman
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/minekini
	name = "Sexy miner costume"
	id = "minekini"
	build_path = /obj/item/clothing/suit/sexyminer
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/engkini
	name = "Sexy engineer costume"
	id = "engkini"
	build_path = /obj/item/clothing/suit/engicost
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/ia_sexy
	name = "Sexy internal affairs costume"
	id = "ia_sexy"
	build_path = /obj/item/clothing/suit/iasexy
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/lumber_sexy
	name = "Sexy lumberjack costume"
	id = "lumber_sexy"
	build_path = /obj/item/clothing/suit/lumber
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/skeleton
	name = "Spooky skeleton costume"
	id = "skeleton"
	build_path = /obj/item/clothing/suit/skeleton
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/hackerman
	name = "Clasic hacker costume"
	id = "hackerman"
	build_path = /obj/item/clothing/suit/hackercost
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/rooster_hat
	name = "Rooster face mask"
	id = "rooster_hat"
	build_path = /obj/item/clothing/head/richard
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/pumpkin	//why does this have a helmet light?
	name = "Carved pumpkin mask"
	id = "pumpkin"
	build_path = /obj/item/clothing/head/pumpkinhead
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/bday_hat
	name = "Birthday cake hat"
	id = "bday_hat"
	build_path = /obj/item/clothing/head/cakehat
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/crown
	name = "Royal crown"
	id = "crown"
	build_path = /obj/item/clothing/head/crown
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/paper_crown
	name = "Paper crown - rainbow"
	id = "paper_crown"
	build_path = /obj/item/clothing/head/festive
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/paper_hat	//custom colors.. technically
	name = "Paper hat"
	id = "paper_hat"
	build_path = /obj/item/clothing/head/collectable/paper
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/rabbitears	//remove tail
	name = "Rabbit ears"
	id = "rabbitears"
	build_path = /obj/item/clothing/head/rabbitears
	materials = list("cloth" = 500)
//dupe^: /obj/item/clothing/head/collectable/rabbitears

/datum/design/item/autotailor/nonstandard/costume/catears	//remove tail
	name = "kitty ears"
	id = "catears"
	build_path = /obj/item/clothing/head/kitty
	materials = list("cloth" = 500)
//dupe^: /obj/item/clothing/head/collectable/kitty

/datum/design/item/autotailor/nonstandard/costume/wig
	name = "Powdered wig"
	id = "wig"
	build_path = /obj/item/clothing/head/powdered_wig
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/big_wig
	name = "Philospher's wig"
	id = "big_wig"
	build_path = /obj/item/clothing/head/philosopher_wig
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/white_ball	//canidate for colors
	name = "Cueball - white"
	id = "white_ball"
	build_path = /obj/item/clothing/head/cueball
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/wresling_luchador
	name = "Wreslting mask - luchador"
	id = "wresling_luchador"
	build_path = /obj/item/clothing/mask/luchador
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/wresling_rudos
	name = "Wresling mask - rudos"
	id = "wresling_rudos"
	build_path = /obj/item/clothing/mask/luchador/rudos
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/wresling_tecnicos
	name = "Wresling mask - tecnicos"
	id = "wresling_technicos"
	build_path = /obj/item/clothing/mask/luchador/tecnicos
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/wresling_belt
	name = "Championship belt"
	id = "wresling_belt"
	build_path = /obj/item/weapon/storage/belt/champion
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/pig_mask
	name = "Entertainment - pig"
	id = "pig_mask"
	build_path = /obj/item/clothing/mask/pig
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/horse_mask
	name = "Entertainment - silly horse"
	id = "horse_mask"
	build_path = /obj/item/clothing/mask/horsehead
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/fake_moustache
	name = "Entertainment - moustache"
	id = "fake_moustache"
	build_path = /obj/item/clothing/mask/fakemoustache
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/tribal
	name = "Tribal mask"
	id = "tribal"
	build_path = /obj/item/clothing/mask/spirit
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/snorkel
	name = "Snorkel"
	id = "snorkel"
	build_path = /obj/item/clothing/mask/snorkel
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/costume/slime_green
	name = "Slime hat - green"
	id = "slime_green"
	build_path = /obj/item/clothing/head/collectable/slime
	materials = list("cloth" = 500)

//////////////////////restraints,probably move to secure fab///////////////////////
/datum/design/item/autotailor/nonstandard/restaint
	category = "Restraints"
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/autotailor/nonstandard/restaint/straitjacket
	name = "Straitjacket"
	id = "straitjacket"
	build_path = /obj/item/clothing/suit/straight_jacket
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/restaint/muzzle	//this sprite is akwardly large
	name = "Muzzle"
	id = "muzzle"
	build_path = /obj/item/clothing/mask/muzzle
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/restaint/blindfold
	name = "Blindfold"
	id = "blindfold"
	build_path = /obj/item/clothing/glasses/sunglasses/blindfold
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/restaint/facecover
	name = "Face cover"
	id = "facecover"
	build_path = /obj/item/clothing/head/helmet/facecover
	materials = list("cloth" = 500)

//////////////////////hazard suits///////////////////////
/datum/design/item/autotailor/nonstandard/hazard
	category = "Hazard suits"
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/autotailor/nonstandard/hazard/bio_orange
	name = "Biosuit - orange stripe"
	id = "bio_orange"
	build_path = /obj/item/clothing/suit/bio_suit/general
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/hazard/biohood_orange
	name = "Biosuit hood - orange stripe"
	id = "biohood_orange"
	build_path = /obj/item/clothing/head/bio_hood/general
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/hazard/bio_blue
	name = "Biosuit - blue stripe"
	id = "bio_blue"
	build_path = /obj/item/clothing/suit/bio_suit/cmo
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/hazard/biohood_blue
	name = "Biosuit hood - blue stripe"
	id = "biohood_blue"
	build_path = /obj/item/clothing/head/bio_hood/cmo
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/hazard/bio_green
	name = "Biosuit - green stripe"
	id = "bio_green"
	build_path = /obj/item/clothing/suit/bio_suit/virology
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/hazard/biohood_green
	name = "Biosuit hood - green stripe"
	id = "biohood_green"
	build_path = /obj/item/clothing/head/bio_hood/virology
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/hazard/bio_purp
	name = "Biosuit - purple"
	id = "bio_purp"
	build_path = /obj/item/clothing/suit/bio_suit/scientist
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/hazard/biohood_purple	//not really purple.. but its supposed to match the purple suit
	name = "Biosuit hood - purple"
	id = "biohood_purple"
	build_path = /obj/item/clothing/head/bio_hood/scientist
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/hazard/bio_purpgrey
	name = "Biosuit - grey w. purple stripe"
	id = "bio_purpgrey"
	build_path = /obj/item/clothing/suit/bio_suit/janitor
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/hazard/biohood_purpgrey
	name = "Biosuit hood - grey w. purple stripe"
	id = "biohood_purpgrey"
	build_path = /obj/item/clothing/head/bio_hood/janitor
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/hazard/bio_red
	name = "Biosuit - red stripe"
	id = "bio_red"
	build_path = /obj/item/clothing/suit/bio_suit/security
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/hazard/biohood_red
	name = "Biosuit hood - red stripe"
	id = "biohood_red"
	build_path = /obj/item/clothing/head/bio_hood/security
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/hazard/bio_adv
	name = "Biosuit - advanced"
	id = "bio_adv"
	build_path = /obj/item/clothing/suit/bio_suit/anomaly
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/hazard/biohood_adv
	name = "Biosuit hood - advanced"
	id = "biohood_adv"
	build_path = /obj/item/clothing/head/bio_hood/anomaly
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/hazard/rad_yellow
	name = "Radiation suit - yellow"
	id = "rad_yellow"
	build_path = /obj/item/clothing/suit/radiation
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/hazard/radhood_yellow
	name = "Radiation hood - yellow"
	id = "radhood_yellow"
	build_path = /obj/item/clothing/head/radiation
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nonstandard/hazard/firesuit
	name = "Firesuit"
	id = "firesuit"
	build_path = /obj/item/clothing/suit/fire/firefighter
	materials = list("cloth" = 500)