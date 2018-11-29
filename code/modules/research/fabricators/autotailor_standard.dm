/obj/machinery/fabricator/autotailor
	name = "auto-tailor (standard wear)"
	desc = "An advanced machine capable of printing many types of clothing, this one is loaded with standard clothing designs."
	circuit = /obj/item/weapon/circuitboard/fabricator/autotailor
	build_type = AUTOTAILOR
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
//~400 designs per machine seems to be the limit before UI interaction causes endless clientside lag
//if you're adding more clothing make sure you don't exceed this number!!!

/datum/design/item/autotailor	//anything here is broken or unsorted clothes
	build_type = AUTOTAILOR
	category = "broken clothing"
	req_tech = list(TECH_MATERIAL = 1)
	time = 1	//40

/*
//undersuits//
/datum/design/item/autotailor/bouqet	//broken mob sprite
	name = "bouqet"
	id = "bouqet"
	build_path = /obj/item/clothing/under/bouqet
	materials = list("cloth" = 500)

/datum/design/item/autotailor/dress_yellow	//broken wearing sprite
	name = "yellow dress"
	id = "dress_yellow"
	build_path = /obj/item/clothing/under/dress/dress_yellow
	materials = list("cloth" = 500)

/datum/design/item/autotailor/cloud	//???????????? no sprite, weird text
	name = "cloud"
	id = "cloud"
	build_path = /obj/item/clothing/under/cloud
	materials = list("cloth" = 500)

/datum/design/item/autotailor/green_swim	//no sprite
	name = "green swimsuit"
	id = "green_swim"
	build_path = /obj/item/clothing/under/stripper/stripper_green
	materials = list("cloth" = 500)

/datum/design/item/autotailor/pink_swim	//no sprite
	name = "pink swimsuit"
	id = "pink_swim"
	build_path = /obj/item/clothing/under/stripper/stripper_pink
	materials = list("cloth" = 500)

/datum/design/item/autotailor/nasa	//broken mob sprite
	name = "NASA jumpsuit"
	id = "nasa"
	build_path = /obj/item/clothing/under/space
	materials = list("cloth" = 500)

/datum/design/item/autotailor/isu	//broken mob sprite
	name = "intelligence service uniform"
	id = "isu"
	build_path = /obj/item/clothing/under/service/mirania/intelligence
	materials = list("cloth" = 500)

/datum/design/item/autotailor/isuu	//broken mob sprite
	name = "intelligence service utility uniform"
	id = "isuu"
	build_path = /obj/item/clothing/under/utility/mirania/intelligence
	materials = list("cloth" = 500)

/datum/design/item/autotailor/isdu	//broken mob sprite
	name = "intelligence service dress uniform"
	id = "isdu"
	build_path = /obj/item/clothing/under/mildress/mirania/intelligence
	materials = list("cloth" = 500)

/datum/design/item/autotailor/seizure	//way too flashy to be added as real clothing, also remove /color/
	name = "broken chamelon suit"
	id = "seizure"
	build_path = /obj/item/clothing/under/psyche
	materials = list("cloth" = 500)

/datum/design/item/autotailor/chameleon	//nope
	name = "chameleon jumsuit"
	id = "chameleon"
	build_path = /obj/item/clothing/under/chameleon
	materials = list("cloth" = 500)

/datum/design/item/autotailor/godmode	//NEVER ADD THIS CLOTHING, IT HAS 100% PROTECTION ON EVERYTHING
	name = "ADMIN NODAMAGE SUIT"
	id = "godmode"
	build_path = /obj/item/clothing/under/acj
	materials = list("cloth" = 500)

/datum/design/item/autotailor/gene_alt	//no mob sprite
	name = "medical jumpsuit - generics alternate"
	id = "gene_alt"
	build_path = /obj/item/clothing/under/rank/geneticist_new
	materials = list("cloth" = 500)
//oversuits//
/datum/design/item/autotailor/chameleon	//no
	name = "chameleon oversuit"
	id = "chameleon"
	build_path = /obj/item/clothing/suit/chameleon
	materials = list("cloth" = 500)

/datum/design/item/autotailor/teleport	//kinda memey armor, maybe put in rnd if anything
	name = "teleporting armor"
	id = "teleport"
	build_path = /obj/item/clothing/suit/armor/reactive
	materials = list("cloth" = 500)

/datum/design/item/autotailor/cyborg_suit	//no mob sprite
	name = "Cyborg suit"
	id = "cyborg suit"
	build_path = /obj/item/clothing/suit/cyborg_suit
	materials = list("cloth" = 500)

/datum/design/item/autotailor/greatcoat	//no mob sprite
	name = "Great coat"
	id = "greatcoat"
	build_path = /obj/item/clothing/suit/greatcoat
	materials = list("cloth" = 500)

/datum/design/item/autotailor/johnny_coat	//no mob sprite, needs renamed too
	name = "Johnny coat"
	id = "johnny_coat"
	build_path = /obj/item/clothing/suit/johnny_coat
	materials = list("cloth" = 500)

/datum/design/item/autotailor/tact_jacket	//no mob sprite, needs renamed too
	name = "Tactical jacket"
	id = "tact_jacket"
	build_path = /obj/item/clothing/suit/fed
	materials = list("cloth" = 500)

/datum/design/item/autotailor/fire_one	//omegabad sprite
	name = "Firesuit - basic"
	id = "fire_one"
	build_path = /obj/item/clothing/suit/fire
	materials = list("cloth" = 500)

/datum/design/item/autotailor/fire_two	//omegabad sprite
	name = "Firesuit - heavy duty"
	id = "fire_two"
	build_path = /obj/item/clothing/suit/fire/heavy
	materials = list("cloth" = 500)
//masks//
/datum/design/item/autotailor/camera_interface	//too op
	name = "camera network interface"
	id = "camera_interface"
	build_path = /obj/item/clothing/mask/ai
	materials = list("cloth" = 500)

/datum/design/item/autotailor/owl_mask	//no mob sprite
	name = "Owl mask"
	id = "owl_mask"
	build_path = /obj/item/clothing/mask/gas/owl_mask
	materials = list("cloth" = 500)

/datum/design/item/autotailor/plague_mask	//no mob sprite
	name = "Plague doctor mask"
	id = "plague_mask"
	build_path = /obj/item/clothing/mask/gas/plaguedoctor
	materials = list("cloth" = 500)

/datum/design/item/autotailor/cyborg_mask	//no mob sprite
	name = "Cyborg visor"
	id = "cyborg_mask"
	build_path = /obj/item/clothing/mask/gas/cyborg
	materials = list("cloth" = 500)

/datum/design/item/autotailor/poltergeist	//no sprite
	name = "Poltergeist mask"
	id = "poltergeist"
	build_path = /obj/item/clothing/mask/gas/poltergeist
	materials = list("cloth" = 500)

/datum/design/item/autotailor/ert_mask	//no sprite
	name = "ERT gas mask"
	id = "ert_mas"
	build_path = /obj/item/clothing/mask/gas/death_commando
	materials = list("cloth" = 500)

/datum/design/item/autotailor/scarf_ninja	//no sprite
	name = "Scarf - ninja"
	id = "scard_ninja"
	build_path = /obj/item/clothing/mask/ninjascarf
	materials = list("cloth" = 500)

/datum/design/item/autotailor/scarf_blue	//no sprite
	name = "Scarf - blue"
	id = "scarf_blue"
	build_path = /obj/item/clothing/mask/bluescarf
	materials = list("cloth" = 500)

/datum/design/item/autotailor/scarf_red	//no sprite
	name = "Scarf - red"
	id = "scarf_red"
	build_path = /obj/item/clothing/mask/redscarf
	materials = list("cloth" = 500)

/datum/design/item/autotailor/scarf_green	//no sprite
	name = "Scarf - green"
	id = "scarf_green"
	build_path = /obj/item/clothing/mask/greenscarf
	materials = list("cloth" = 500)

/datum/design/item/autotailor/balac_green	//no mob sprite
	name = "Balaclava - green"
	id = "balac_green"
	build_path = /obj/item/clothing/mask/balaclava/tactical
	materials = list("cloth" = 500)
//helmets and hats//
/datum/design/item/autotailor/justice_yellow	//no mob sprite
	name = "Justice hat - yellow"
	id = "justice_yellow"
	build_path = /obj/item/clothing/head/justice/yellow
	materials = list("cloth" = 500)

/datum/design/item/autotailor/justice_red	//no mob sprite
	name = "Justce hat - red"
	id = "justice_red"
	build_path = /obj/item/clothing/head/justice
	materials = list("cloth" = 500)

/datum/design/item/autotailor/justice_blue	//no mob sprite
	name = "Justice hat - blue"
	id = "justice_blue"
	build_path = /obj/item/clothing/head/justice/blue
	materials = list("cloth" = 500)

/datum/design/item/autotailor/justice_green	//no mob sprite
	name = "Justice hat - green"
	id = "justice_green"
	build_path = /obj/item/clothing/head/justice/green
	materials = list("cloth" = 500)

/datum/design/item/autotailor/justice_pink	//no mob sprite
	name = "Justice hat - pink"
	id = "justice_pink"
	build_path = /obj/item/clothing/head/justice/pink
	materials = list("cloth" = 500)

/datum/design/item/autotailor/ert_beret	//no sprite
	name = "Beret - ERT"
	id = "ert_beret"
	build_path = /obj/item/clothing/head/beret/deathsquad
	materials = list("cloth" = 500)

/datum/design/item/autotailor/eng_beret	//no sprite
	name = "Beret - engineering"
	id = "eng_beret"
	build_path = /obj/item/clothing/head/beret/engineering
	materials = list("cloth" = 500)

/datum/design/item/autotailor/int_beret	//no sprite
	name = "Beret - intelligence service"
	id = "int_beret"
	build_path = /obj/item/clothing/head/beret/mirania
	materials = list("cloth" = 500)
*/
//////////////////////general jumpsuits///////////////////////
/datum/design/item/autotailor/under/jumpsuit
	category = "Undersuits - Jumpsuits"
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/autotailor/under/jumpsuit/br_overalls
	name = "Overalls - brown"
	id = "br_overalls"
	build_path = /obj/item/clothing/under/serviceoveralls
	materials = list("cloth" = 500)
//remove grayson, it's a duplicate of above^
/datum/design/item/autotailor/under/jumpsuit/blue_overalls
	name = "Overalls - blue"
	id = "blue_overalls"
	build_path = /obj/item/clothing/under/frontier
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/jumpsuit/earthslum
	name = "Low class earth wear"
	id = "earthslum"
	build_path = /obj/item/clothing/under/assistantformal
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/jumpsuit/agartha
	name = "Agarthan uniform"
	id = "agartha"
	build_path = /obj/item/clothing/under/saare
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/jumpsuit/tconfed
	name = "Terran Confederacy uniform"
	id = "tconfed"
	build_path = /obj/item/clothing/under/confederacy
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/jumpsuit/mbill
	name = "Major Bill's uniform"
	id = "mbill"
	build_path = /obj/item/clothing/under/mbill
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/jumpsuit/bblazer
	name = "Blue blazer"
	id = "bblazer"
	build_path = /obj/item/clothing/under/blazer
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/jumpsuit/wh_jskirt //candidate for custom colors
	name = "Jumpskirt - white"
	id = "wh_jskirt"
	build_path = /obj/item/clothing/under/shortjumpskirt
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/jumpsuit/bl_jskirt
	name = "Jumpskirt - black"
	id = "bl_jskirt"
	build_path = /obj/item/clothing/under/blackjumpskirt
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/jumpsuit/wardt
	name = "Black and Gold Uniform"
	id = "wardt"
	build_path = /obj/item/clothing/under/wardt
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/jumpsuit/heph
	name = "Grey and Blue Uniform"
	id = "heph"
	build_path = /obj/item/clothing/under/hephaestus
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/jumpsuit/white_generic	//canidate for custom colors
	name = "Generic jumpsuit - white"
	id = "white_generic"
	build_path = /obj/item/clothing/under/color/white
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/jumpsuit/grey_generic
	name = "Generic jumpsuit - grey"
	id = "grey_generic"
	build_path = /obj/item/clothing/under/color/grey
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/jumpsuit/black_generic
	name = "Generic jumpsuit - black"
	id = "black_generic"
	build_path = /obj/item/clothing/under/color/black
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/jumpsuit/brown_generic
	name = "Generic jumpsuit - brown"
	id = "black_generic"
	build_path = /obj/item/clothing/under/color/brown
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/jumpsuit/lpurple_generic
	name = "Generic jumpsuit - light purple"
	id = "lpurple_generic"
	build_path = /obj/item/clothing/under/color/lightpurple
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/jumpsuit/pink_generic
	name = "Generic jumpsuit - pink"
	id = "pink_generic"
	build_path = /obj/item/clothing/under/color/pink
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/jumpsuit/red_generic
	name = "Generic jumpsuit - red"
	id = "red_generic"
	build_path = /obj/item/clothing/under/color/red
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/jumpsuit/blue_generic
	name = "Generic jumpsuit - blue"
	id = "blue_generic"
	build_path = /obj/item/clothing/under/color/blue
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/jumpsuit/green_generic
	name = "Generic jumpsuit - green"
	id = "green_generic"
	build_path = /obj/item/clothing/under/color/green
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/jumpsuit/yellow_generic
	name = "Generic jumpsuit - yellow"
	id = "yellow_generic"
	build_path = /obj/item/clothing/under/color/yellow
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/jumpsuit/rainbow_generic
	name = "Jumpsuit - generic rainbow"
	id = "rainbow_generic"
	build_path = /obj/item/clothing/under/color/rainbow
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/jumpsuit/prison_orange	//shouldn't really have the /color/ path but ok
	name = "Jumpsuit - prisoner orange"
	id = "prison_orange"
	build_path = /obj/item/clothing/under/color/orange
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/jumpsuit/black_shorts
	name = "Jumpsuit shorts - black"
	id = "black_shorts"
	build_path = /obj/item/clothing/under/color/blackjumpshorts	//shouldn't really have the /color/ path but ok
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/jumpsuit/white_generic_f	//NEEDS CUSTOM COLORS
	name = "Jumpsuit - female generic white"
	id = "white_generic_f"
	build_path = /obj/item/clothing/under/fcolor
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/jumpsuit/grey_turtleneck
	name = "Turtleneck - grey"
	id = "grey_turtleneck"
	build_path = /obj/item/clothing/under/rank/psych/turtleneck/sweater
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/jumpsuit/turqouise_turtleneck
	name = "Turtleneck - turqouise"
	id = "turqouise_turtleneck"
	build_path = /obj/item/clothing/under/rank/psych/turtleneck
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/jumpsuit/kilt
	name = "Kilt"
	id = "kilt"
	build_path = /obj/item/clothing/under/kilt
	materials = list("cloth" = 500)

//////////////////////Work clothing///////////////////////
/datum/design/item/autotailor/under/worksuits
	category = "Undersuits - Work"
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/autotailor/under/worksuits/atmos_one
	name = "Atmospherics jumpsuit"
	id = "atmos_one"
	build_path = /obj/item/clothing/under/rank/atmospheric_technician
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/atmos_two
	name = "Atmospherics alternate jumpsuit"
	id = "atmos_two"
	build_path = /obj/item/clothing/under/aether
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/chief_eng
	name = "Chief engineer jumpsuit"
	id = "chief_eng"
	build_path = /obj/item/clothing/under/rank/chief_engineer
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/eng_one
	name = "Engineering jumpsuit"
	id = "eng_one"
	build_path = /obj/item/clothing/under/rank/engineer
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/eng_two
	name = "Engineering altnerate jumpsuit"
	id = "eng_two"
	build_path = /obj/item/clothing/under/focal
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/hazard
	name = "Hazard jumpsuit"
	id = "hazard"
	build_path = /obj/item/clothing/under/hazard
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/labor_purple	//rename
	name = "Laborer overalls - purple"
	id = "labor_purple"
	build_path = /obj/item/clothing/under/rank/miner
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/labor_blue
	name = "laborer overalls - blue"
	id = "labor_blue"
	build_path = /obj/item/clothing/under/overalls
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/cmo
	name = "Medical jumpsuit - CMO"
	id = "cmo"
	build_path = /obj/item/clothing/under/sterile
	materials = list("cloth" = 500)
//cmo same sprite^
/datum/design/item/autotailor/under/worksuits/doc
	name = "Medical jumpsuit"
	id = "doc"
	build_path = /obj/item/clothing/under/rank/medical
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/doc_short	//delete this, essentially a dupe of above
	name = "Medical jumpsuit - short sleeved"
	id = "doc_short"
	build_path = /obj/item/clothing/under/rank/medical/paramedic
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/med_psych
	name = "Medical jumpsuit - psychiatrist"
	id = "med_psych"
	build_path = /obj/item/clothing/under/rank/psych
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/med_viro
	name = "Medical jumpsuit - virologist"
	id = "med_viro"
	build_path = /obj/item/clothing/under/rank/virologist
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/med_viro_alt
	name = "Medcial jumpsuit - virologist alternate"
	id = "med_viro_alt"
	build_path = /obj/item/clothing/under/rank/virologist_new
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/med_chem
	name = "Medical jumpsuit - chemist"
	id = "med_chem"
	build_path = /obj/item/clothing/under/rank/chemist
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/med_chem_alt
	name = "Medical jumpsuit - chemist alternate"
	id = "med_chem_alt"
	build_path = /obj/item/clothing/under/rank/chemist_new
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/med_gene	//maybe rename to cmo or standard uniform
	name = "Medical jumpsuit - geneticist"
	id = "med_gene"
	build_path = /obj/item/clothing/under/rank/geneticist
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/med_ord
	name = "Medical uniform - orderly"
	id = "med_ord"
	build_path = /obj/item/clothing/under/rank/orderly
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/med_nurse_dress
	name = "Medical nurse dress"
	id = "med_nurse_dress"
	build_path = /obj/item/clothing/under/rank/nurse
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/med_nurse_hat
	name = "Medical nurse hat"
	id = "med_nurse_hat"
	build_path = /obj/item/clothing/head/nursehat
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/med_nurse_suit
	name = "Medical jumpsuit - Nurse"
	id = "med_nurse_suit"
	build_path = /obj/item/clothing/under/rank/nursesuit
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/sci
	name = "Scientist jumpsuit"
	id = "sci"
	build_path = /obj/item/clothing/under/rank/scientist
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/sci_jacket
	name = "Scientist tunic"
	id = "sci_jacket"
	build_path = /obj/item/clothing/accessory/nt_tunic
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/sci_exec
	name = "Scientist jumpsuit - executive"
	id = "sci_exec"
	build_path = /obj/item/clothing/under/rank/scientist/executive
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/sci_exec_jacket
	name = "Scientist tunic - executive"
	id = "sci_exec_jacket"
	build_path = /obj/item/clothing/accessory/nt_tunic/exec
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/sci_casual
	name = "Scientist jumpsuit - casual"
	id = "sci_casual"
	build_path = /obj/item/clothing/under/rank/scientist_new
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/sci_robotics
	name = "Scientist jumpsuit - robotics"
	id = "sci_robotics"
	build_path = /obj/item/clothing/under/rank/roboticist
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/sci_robotics_f
	name = "Scientist jumpskirt - robotics"
	id = "sci_robotics_f"
	build_path = /obj/item/clothing/under/rank/roboticist/skirt
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/rd_uniform
	name = "Scientist uniform - RD"
	id = "rd_uniform"
	build_path = /obj/item/clothing/under/rank/research_director
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/rd_dress
	name = "Scientist dress uniform - RD"
	id = "rd_dress"
	build_path = /obj/item/clothing/under/rank/research_director/dress_rd
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/rd_uniform_alt
	name = "Scientist uniform - alternate RD"
	id = "rd_uniform_alt"
	build_path = /obj/item/clothing/under/rank/research_director/rdalt
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/cargo_qm
	name = "Cargo jumpsuit - QM"
	id = "cargo_qm"
	build_path = /obj/item/clothing/under/rank/cargo
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/cargo_officer
	name = "Cargo jumpsuit - worker"
	id = "cargo_officer"
	build_path = /obj/item/clothing/under/rank/cargotech
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/cap_uniform
	name = "Captain uniform"
	id = "cap_uniform"
	build_path = /obj/item/clothing/under/gimmick/rank/captain/suit
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/cap_jumpsuit
	name = "Captain jumpsuit"
	id = "cap_jumpsuit"
	build_path = /obj/item/clothing/under/rank/captain
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/cap_jumphat
	name = "Captain jumpsuit hat"
	id = "cap_jumphat"
	build_path = /obj/item/clothing/head/caphat
	materials = list("cloth" = 500)
//dupe^: /obj/item/clothing/head/collectable/captain

/datum/design/item/autotailor/under/worksuits/hop_uniform
	name = "HoP uniform"
	id = "hop_uniform"
	build_path = /obj/item/clothing/under/gimmick/rank/head_of_personnel/suit
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/hop_uniform_alt
	name = "HoP uniform - alternate"
	id = "hop_uniform_alt"
	build_path = /obj/item/clothing/under/rank/head_of_personnel_whimsy
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/hop_jumpsuit
	name = "HoP jumpsuit"
	id = "hop_jumpsuit"
	build_path = /obj/item/clothing/under/rank/head_of_personnel
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/hop_hat
	name = "HoP hat"
	id = "hop_hat"
	build_path = /obj/item/clothing/head/caphat/hop
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/ia_white
	name = "Internal affairs uniform"
	id = "ia_white"
	build_path = /obj/item/clothing/under/rank/internalaffairs
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/bartender
	name = "Service uniform - bartender"
	id = "bartender"
	build_path = /obj/item/clothing/under/rank/bartender
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/waiter
	name = "Service uniform - waiter"
	id = "waiter"
	build_path = /obj/item/clothing/under/waiter
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/chef
	name = "Service uniform - chef"
	id = "chef"
	build_path = /obj/item/clothing/under/rank/chef
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/botanist
	name = "Service uniform - botanist"
	id = "botanist"
	build_path = /obj/item/clothing/under/rank/hydroponics
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/chaplain	//would make a badass general use uniform
	name = "Service uniform - chaplain"
	id = "chaplain"
	build_path = /obj/item/clothing/under/rank/chaplain
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/janitor
	name = "Service uniform - janitor"
	id = "janitor"
	build_path = /obj/item/clothing/under/rank/janitor
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/messanger	//ehhh maybe a costume
	name = "Service uniform - messanger"
	id = "messanger"
	build_path = /obj/item/clothing/under/rank/mailman
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/messanger_hat	//ehhh maybe a costume
	name = "Service uniform - messanger hat"
	id = "messanger_hat"
	build_path = /obj/item/clothing/head/mailman
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/vice	//rename and probably place somewhere else
	name = "Vice officer jumpsuit"
	id = "vice"
	build_path = /obj/item/clothing/under/rank/vice
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/coveralls_tan	//rename
	name = "Coveralls - tan"
	id = "coveralls_tan"
	build_path = /obj/item/clothing/under/rank/ntwork
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/coveralls_red	//rename and remove nt sprite
	name = "Coveralls - red"
	id = "coveralls_red"
	build_path = /obj/item/clothing/under/rank/ntpilot
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/cap_dress
	name = "Captain dress uniform - female"
	id = "cap_dress"
	build_path = /obj/item/clothing/under/dress/dress_cap
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/hop_dress
	name = "HoP dress uniform - female"
	id = "hop_dress"
	build_path = /obj/item/clothing/under/dress/dress_hop
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/hr_dress
	name = "HR dress uniform - female"
	id = "hr_dress"
	build_path = /obj/item/clothing/under/dress/dress_hr
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/secskirt
	name = "Security officer skirt"
	id = "secskirt"
	build_path = /obj/item/clothing/under/secskirt
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/maid
	name = "Maid uniform - simple"
	id = "maid"
	build_path = /obj/item/clothing/under/maid
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/maidapron
	name = "Maid accessory - apron"
	id = "maidapron"
	build_path = /obj/item/clothing/accessory/maidapron
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/worksuits/finemaid
	name = "Maid uniform - fine"
	id = "finemaid"
	build_path = /obj/item/clothing/under/finemaid
	materials = list("cloth" = 500)

//////////////////////Formalwear///////////////////////
/datum/design/item/autotailor/under/dressclothes
	category = "Undersuits - Formal"
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/autotailor/under/dressclothes/det_suit
	name = "Detective's suit"
	id = "det_suit"
	build_path = /obj/item/clothing/under/det
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/det_suit_black
	name = "Black detective's suit"
	id = "det_suit_black"
	build_path = /obj/item/clothing/under/det/black
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/blue_suit
	name = "White and blue suit"
	id = "blue_suit"
	build_path = /obj/item/clothing/under/lawyer/bluesuit
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/det_suit_tan
	name = "Tan detective's suit"
	id = "det_suit_tan"
	build_path = /obj/item/clothing/under/det/grey
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/sensible
	name = "Red sensible suit"
	id = "sensible suit"
	build_path = /obj/item/clothing/under/librarian
	materials = list("cloth" = 500)
///obj/item/clothing/under/suit_jacket/red" duplicate^
/datum/design/item/autotailor/under/dressclothes/det_suit_black
	name = "Black detective's suit"
	id = "det_suit_black"
	build_path = /obj/item/clothing/under/det/black
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/oldman
	name = "Old man's suit"
	id = "oldman"
	build_path = /obj/item/clothing/under/lawyer/oldman
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/purple
	name = "Purple suit"
	id = "purple_suit"
	build_path = /obj/item/clothing/under/lawyer/purpsuit
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/bluesuit
	name = "Blue lawyer's suit"
	id = "blue_suit"
	build_path = /obj/item/clothing/under/lawyer/blue
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/redsuit
	name = "Red lawyer's suit"
	id = "red_suit"
	build_path = /obj/item/clothing/under/lawyer/red
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/lawyerblack
	name = "Black lawyer's suit"
	id = "black_lawyer"
	build_path = /obj/item/clothing/under/lawyer/black
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/lawyerblack_f
	name = "black judge suit"
	id = "black_judge"
	build_path = /obj/item/clothing/under/lawyer/female
	materials = list("cloth" = 500)
//duplicate^: /obj/item/clothing/under/suit_jacket/female
/datum/design/item/autotailor/under/dressclothes/tux_blackpurple
	name = "Black and purple tuxedo"
	id = "blackpurple_tux"
	build_path = /obj/item/clothing/under/purpleweddingtux
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/tux_purple
	name = "Purple tuxedo"
	id = "purple_tux"
	build_path = /obj/item/clothing/under/shinypurple
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/tux_black
	name = "black tuxedo"
	id = "black_tux"
	build_path = /obj/item/clothing/under/blacktux
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/cap_formal
	name = "Captain's formal suit"
	id = "cap_formal"
	build_path = /obj/item/clothing/under/captainformal
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/cap_formal_hat
	name = "Captain's formal suit hat"
	id = "cap_formal_hat"
	build_path = /obj/item/clothing/head/caphat/cap
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/hos_formal_m
	name = "HoS formal suit - male"
	id = "hos_formal_m"
	build_path = /obj/item/clothing/under/hosformalmale
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/hos_formal_f
	name = "HoS formal suit - female"
	id = "hos_formal_f"
	build_path = /obj/item/clothing/under/hosformalfem
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/silk_gown	//canidate for custom colors
	name = "silk gown"
	id = "silk_gown"
	build_path = /obj/item/clothing/under/skirt_c/dress/long/gown
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/maxi_white	//canidate for custom colors, also need a resprite so you don't see your nipples
	name = "maxi dress - white"
	id = "maxi_white"
	build_path = /obj/item/clothing/under/skirt_c/dress/long
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/maxi_black
	name = "maxi dress - black"
	id = "maxi_black"
	build_path = /obj/item/clothing/under/skirt_c/dress/long/black
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/maxi_mint
	name = "maxi dress - mint"
	id = "maxi_mint"
	build_path = /obj/item/clothing/under/skirt_c/dress/long/mintcream
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/maxi_eggshell
	name = "maxi dress - eggshell"
	id = "maxi_eggshell"
	build_path = /obj/item/clothing/under/skirt_c/dress/long/eggshell
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/silk_dress
	name = "silk dress"
	id = "silk_dress"
	build_path = /obj/item/clothing/under/tulleddress
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/purple_bride
	name = "bridesmaid dress - purple"
	id = "purple_bride"
	build_path = /obj/item/clothing/under/bridesmaid
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/whitepurple_wedding
	name = "wedding dress - white and purple"
	id = "whitepurple_wedding"
	build_path = /obj/item/clothing/under/koudress
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/pink_wedding
	name = "wedding dress - pink"
	id = "pink_wedding"
	build_path = /obj/item/clothing/under/maydress
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/green_wedding
	name = "wedding dress - green"
	id = "green_wedding"
	build_path = /obj/item/clothing/under/greendress
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/frillygreen_wedding
	name = "wedding dress - frilly green"
	id = "frillygreen_wedding"
	build_path = /obj/item/clothing/under/weddingfrill
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/frillypurple_wedding
	name = "wedding dress - frilly purple"
	id = "frillypurple_wedding"
	build_path = /obj/item/clothing/under/purpfrill
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/orange_puffy
	name = "Puffy wedding dress - orange"
	id = "orange_puffy"
	build_path = /obj/item/clothing/under/wedding/bride_orange
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/blue_puffy
	name = "Puffy wedding dress - blue"
	id = "blue_puffy"
	build_path = /obj/item/clothing/under/wedding/bride_blue
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/red_puffy
	name = "Puffy wedding dress - red"
	id = "red_puffy"
	build_path = /obj/item/clothing/under/wedding/bride_red
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/purple_puffy
	name = "Puffy wedding dress - purple"
	id = "purple_puffy"
	build_path = /obj/item/clothing/under/wedding/bride_purple
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/wedding_silky
	name = "Silky wedding dress"
	id = "wedding_silky"
	build_path = /obj/item/clothing/under/wedding/bride_white
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/orange_fancy
	name = "Fancy dress - orange"
	id = "orange_fancy"
	build_path = /obj/item/clothing/under/dress/dress_orange
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/eveninggown_red
	name = "Evening gown - red"
	id = "eveninggown_red"
	build_path = /obj/item/clothing/under/dress/red_evening_gown
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/blueplaid
	name = "jumpskirt - blue plaid"
	id = "blueplaid"
	build_path = /obj/item/clothing/under/dress/plaid_blue
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/redplaid
	name = "jumpskirt - red plaid"
	id = "redplaid"
	build_path = /obj/item/clothing/under/dress/plaid_red
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/purpleplaid
	name = "jumpskirt - purple plaid"
	id = "purpleplaid"
	build_path = /obj/item/clothing/under/skirt/plaid_purple
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/black_suit
	name = "black suit"
	id = "black_suit"
	build_path = /obj/item/clothing/under/suit_jacket
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/black_suitskirt
	name = "black suit-skirt"
	id = "black_suitskirt"
	build_path = /obj/item/clothing/under/blackskirt
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/draculass
	name = "Sexy black dresscoat"
	id = "draculass"
	build_path = /obj/item/clothing/under/dress/draculass
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/geisha
	name = "Geisha"
	id = "geisha"
	build_path = /obj/item/clothing/under/dress/geisha
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/plain_white
	name = "Plain white suit"
	id = "plain_white"
	build_path = /obj/item/clothing/under/rank/internalaffairs/plain
	materials = list("cloth" = 500)
//duplicate:/obj/item/clothing/under/rank/internalaffairs/plain/nt

/datum/design/item/autotailor/under/dressclothes/exec_black
	name = "Executive suit - black"
	id = "exec_black"
	build_path = /obj/item/clothing/under/suit_jacket/really_black
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/earth_suit
	name = "Earthborn uniform"
	id = "earth_suit"
	build_path = /obj/item/clothing/under/gentlesuit
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/white_host
	name = "Host's white suit"
	id = "white_host"
	build_path = /obj/item/clothing/under/scratch
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/white_simple	//rename other than amish
	name = "Simple white suit"
	id = "white_simple"
	build_path = /obj/item/clothing/under/sl_suit
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/bup_black	//rename
	name = "button up suit - black"
	id = "bup_black"
	build_path = /obj/item/clothing/under/suit_jacket/nt
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/jacket_black	//rename
	name = "Suit jacket - black"
	id = "jacket_black"
	build_path = /obj/item/clothing/accessory/toggleable/nanotrasen_jacket
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/bup_checkered
	name = "button up suit - checkered"
	id = "bup_checkered"
	build_path = /obj/item/clothing/under/suit_jacket/checkered
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/jacket_checkered
	name = "Suit jacket - checkered"
	id = "jacket_checkered"
	build_path = /obj/item/clothing/accessory/toggleable/checkered_jacket
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/bup_charcoal
	name = "button up suit - charcoal"
	id = "bup_charcoal"
	build_path = /obj/item/clothing/under/suit_jacket/charcoal
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/jacket_charcoal
	name = "Suit jacket - charcoal"
	id = "jacket_charcoal"
	build_path = /obj/item/clothing/accessory/toggleable/charcoal_jacket
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/bup_tan
	name = "button up suit - tan"
	id = "bup_tan"
	build_path = /obj/item/clothing/under/suit_jacket/tan
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/jacket_tan
	name = "Suit jacket - tan"
	id = "jacket_tan"
	build_path = /obj/item/clothing/accessory/toggleable/tan_jacket
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/bup_navy
	name = "button up suit - navy"
	id = "bup_navy"
	build_path = /obj/item/clothing/under/suit_jacket/navy
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/jacket_navy
	name = "Suit jacket - navy"
	id = "jacket_navy"
	build_path = /obj/item/clothing/accessory/toggleable/navy_jacket
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/bup_burgundy
	name = "button up suit - burgundy"
	id = "bup_burgundy"
	build_path = /obj/item/clothing/under/suit_jacket/burgundy
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/dressclothes/jacket_burgundy
	name = "Suit jacket - burgundy"
	id = "jacket_burgundy"
	build_path = /obj/item/clothing/accessory/toggleable/burgundy_jacket
	materials = list("cloth" = 500)

//////////////////////clothes that don't have shirts, pants only///////////////////////
/datum/design/item/autotailor/under/shorts
	category = "Undersuits - Pants"
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/autotailor/under/shorts/ath_white	//candidate for custom colors
	name = "shorts - athletic white"
	id = "ath_white"
	build_path = /obj/item/clothing/under/shorts
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/track_white	//candidate for custom colors
	name = "shorts - track white"
	id = "track_white"
	build_path = /obj/item/clothing/under/casual_pants/track/white
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/ath_blue
	name = "shorts - athletic blue"
	id = "ath_blue"
	build_path = /obj/item/clothing/under/shorts/blue
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/track_blue
	name = "shorts - track blue"
	id = "track_blue"
	build_path = /obj/item/clothing/under/casual_pants/track/blue
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/ath_black
	name = "shorts - athletic black"
	id = "ath_black"
	build_path = /obj/item/clothing/under/shorts/black
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/track_black
	name = "shorts - track black"
	id = "track_black"
	build_path = /obj/item/clothing/under/casual_pants/track
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/track_black
	name = "shorts - baggy track black"
	id = "track_black_baggy"
	build_path = /obj/item/clothing/under/casual_pants/baggy/track
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/ath_red
	name = "shorts - athletic red"
	id = "ath_read"
	build_path = /obj/item/clothing/under/shorts/red
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/track_red
	name = "shorts - track red"
	id = "track_read"
	build_path = /obj/item/clothing/under/casual_pants/track/red
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/ath_green	//need to change color to green
	name = "shorts - athletic green"
	id = "ath_green"
	build_path = /obj/item/clothing/under/shorts/green
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/track_green
	name = "shorts - track green"
	id = "track_green"
	build_path = /obj/item/clothing/under/casual_pants/track/green
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/ath_grey
	name = "shorts - athletic grey"
	id = "ath_grey"
	build_path = /obj/item/clothing/under/shorts/grey
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/khaki
	name = "khaki pants"
	id = "khaki"
	build_path = /obj/item/clothing/under/formal_pants/khaki
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/khaki_baggy
	name = "khaki baggy pants"
	id = "khaki_baggy"
	build_path = /obj/item/clothing/under/formal_pants/baggy/khaki
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/khaki_shorts
	name = "khaki shorts"
	id = "khaki_shorts"
	build_path = /obj/item/clothing/under/shorts/khaki
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/khaki_s_shorts
	name = "khaki short shorts"
	id = "khaki_s_shorts"
	build_path = /obj/item/clothing/under/shorts/khaki/female
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/jeans
	name = "Jeans"
	id = "jeans"
	build_path = /obj/item/clothing/under/casual_pants
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/jeans_baggy
	name = "Jeans - baggy"
	id = "jeans_baggy"
	build_path = /obj/item/clothing/under/casual_pants/baggy
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/jeans_shorts
	name = "jeans shorts"
	id = "jeans_shorts"
	build_path = /obj/item/clothing/under/shorts/jeans
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/jeans_s_shorts
	name = "jeans short shorts"
	id = "jeans_s_shorts"
	build_path = /obj/item/clothing/under/shorts/jeans/female
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/jeans_grey
	name = "jeans - grey"
	id = "jeans_grey"
	build_path = /obj/item/clothing/under/casual_pants/greyjeans
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/jeans_baggy_grey
	name = "jeans - baggy grey"
	id = "jeans_baggy_grey"
	build_path = /obj/item/clothing/under/casual_pants/baggy/greyjeans
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/jeans_shorts_grey
	name = "jeans shorts - grey"
	id = "jeans_shorts_grey"
	build_path = /obj/item/clothing/under/shorts/jeans/grey
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/jeans_s_shorts_grey
	name = "jean short shorts - grey"
	id = "jeans_s_short_grey"
	build_path = /obj/item/clothing/under/shorts/jeans/grey/female
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/jeans_black
	name = "jeans - black"
	id = "jeans_black"
	build_path = /obj/item/clothing/under/casual_pants/blackjeans
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/jeans_baggy_black
	name = "jeans - baggy black"
	id = "jeans_baggy_black"
	build_path = /obj/item/clothing/under/casual_pants/baggy/blackjeans
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/jeans_shorts_black
	name = "jeans shorts - black"
	id = "jeans_shorts_black"
	build_path = /obj/item/clothing/under/shorts/jeans/black
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/jeans_s_shorts_black
	name = "jeans short shorts - black"
	id = "jeans_s_shorts_black"
	build_path = /obj/item/clothing/under/shorts/jeans/black/female
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/jeans_denim
	name = "jeans - denim"
	id = "jeans_denim"
	build_path = /obj/item/clothing/under/casual_pants/classicjeans
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/jeans_baggy_denim
	name = "jeans baggy - denim"
	id = "jeans_baggy_denim"
	build_path = /obj/item/clothing/under/casual_pants/baggy/classicjeans
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/jeans_shorts_denim
	name = "jeans shorts - denim"
	id = "jeans_shorts_denim"
	build_path = /obj/item/clothing/under/shorts/jeans/classic
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/jeans_s_shorts_denim
	name = "jeans short shorts - denim"
	id = "jeans_s_shorts_denim"
	build_path = /obj/item/clothing/under/shorts/jeans/classic/female
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/jeans_lightdenim	//holy fuck someone had to have held their keyboard upside down while blindfolded on LSD to mispell mustang so badly on this
	name = "jeans - light denim"
	id = "jeans_lightdenim"
	build_path = /obj/item/clothing/under/casual_pants/mustangjeans
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/jeans_baggy_lightdenim	//see above
	name = "jeans - baggy light denim"
	id = "jeans_baggy_lightdenim"
	build_path = /obj/item/clothing/under/casual_pants/baggy/mustangjeans
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/jeans_shorts_lightdenim
	name = "jeans shorts - light denim"
	id = "jeans_lightdenim"
	build_path = /obj/item/clothing/under/shorts/jeans/mustang
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/jeans_s_shorts_lightdenim
	name = "jeans short shorts - light denim"
	id = "jeans_shorts_lightdenim"
	build_path = /obj/item/clothing/under/shorts/jeans/mustang/female
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/jeans_young	//might be a duplicate of classic
	name = "jeans - youngfolk"
	id = "jeans_young"
	build_path = /obj/item/clothing/under/casual_pants/youngfolksjeans
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/jeans_baggy_young	//might be a duplicate of classic
	name = "jeans - baggy youngfolk"
	id = "jeans_baggy_young"
	build_path = /obj/item/clothing/under/casual_pants/baggy/youngfolksjeans
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/jeans_shorts_young	//might be a duplicate of classic
	name = "jeans shorts - youngfolk"
	id = "jeans_shorts_young"
	build_path = /obj/item/clothing/under/shorts/jeans/youngfolks
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/jeans_s_shorts_young	//might be a duplicate of classic
	name = "jeans short shorts - yongfolk"
	id = "jeans_s_shorts_young"
	build_path = /obj/item/clothing/under/shorts/jeans/youngfolks/female
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/camo
	name = "camo pants"
	id = "camo"
	build_path = /obj/item/clothing/under/casual_pants/camo
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/camo_baggy
	name = "camo pants - baggy"
	id = "camo_baggy"
	build_path = /obj/item/clothing/under/casual_pants/baggy/camo
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/white_suit	//canidate for custom colors
	name = "Suit pants - white"
	id = "white_suit"
	build_path = /obj/item/clothing/under/formal_pants
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/white_suit_baggy	//canidate for custom colors
	name = "Suit pants - baggy white"
	id = "white_suit_baggy"
	build_path = /obj/item/clothing/under/formal_pants/baggy
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/black_suit
	name = "Suit pants - black"
	id = "black_suit"
	build_path = /obj/item/clothing/under/formal_pants/black
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/black_suit_baggy
	name = "Suit pants - baggy black"
	id = "black_suit_baggy"
	build_path = /obj/item/clothing/under/formal_pants/baggy/black
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/tan_suit
	name = "Suit pants - tan"
	id = "tan_suit"
	build_path = /obj/item/clothing/under/formal_pants/tan
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/tan_suit_baggy
	name = "Suit pants - baggy tan"
	id = "tan_suit_baggy"
	build_path = /obj/item/clothing/under/formal_pants/baggy/tan
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/red_suit
	name = "Suit pants - red"
	id = "red_suit"
	build_path = /obj/item/clothing/under/formal_pants/red
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/red_suit_baggy
	name = "Suit pants - baggy red"
	id = "red_suit_baggy"
	build_path = /obj/item/clothing/under/formal_pants/baggy/red
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/skirt_wh	//canidate for custom colors
	name = "short skirt - white"
	id = "skirt_wh"
	build_path = /obj/item/clothing/under/skirt_c
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/khaki_skirt
	name = "khaki skirt"
	id = "khaki_skirt"
	build_path = /obj/item/clothing/under/skirt/khaki
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/shorts/skirt_swept
	name = "swept skirt - black"
	id = "skirt_swept"
	build_path = /obj/item/clothing/under/skirt/swept
	materials = list("cloth" = 500)

//////////////////////Casual dresses///////////////////////
/datum/design/item/autotailor/under/casual_dress
	category = "Undersuits - Casual Dresses"
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/autotailor/under/casual_dress/short_white	//canidate for custom colors
	name = "short dress - white"
	id = "short_white"
	build_path = /obj/item/clothing/under/skirt_c/dress
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/casual_dress/short_black
	name = "short dress - black"
	id = "short_black"
	build_path = /obj/item/clothing/under/skirt_c/dress/black
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/casual_dress/short_eggshell
	name = "short dress - eggshell"
	id = "short_eggshell"
	build_path = /obj/item/clothing/under/skirt_c/dress/eggshell
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/casual_dress/short_mint
	name = "short dress - mint"
	id = "short_mint"
	build_path = /obj/item/clothing/under/skirt_c/dress/mintcream
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/casual_dress/sun_white
	name = "sundress - white"
	id = "sun_white"
	build_path = /obj/item/clothing/under/sundress_white
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/casual_dress/sun_black
	name = "sundress - black"
	id = "sun_black"
	build_path = /obj/item/clothing/under/sundress
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/casual_dress/cheongsam
	name = "cheongsam"
	id = "cheongsam"
	build_path = /obj/item/clothing/under/cheongsam
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/casual_dress/abaya
	name = "abaya"
	id = "abaya"
	build_path = /obj/item/clothing/under/abaya
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/casual_dress/skirt_purple
	name = "Skirt - purple"
	id = "skirt_purple"
	build_path = /obj/item/clothing/under/purpleskirt
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/casual_dress/skirt_blue
	name = "Skirt - blue"
	id = "skirt_blue"
	build_path = /obj/item/clothing/under/blueskirt
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/casual_dress/skirt_red
	name = "Skirt - red"
	id = "skirt_red"
	build_path = /obj/item/clothing/under/redskirt
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/casual_dress/saloon
	name = "Saloon girl dress"
	id = "saloon"
	build_path = /obj/item/clothing/under/dress/dress_saloon
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/casual_dress/striped
	name = "Striped dress"
	id = "striped"
	build_path = /obj/item/clothing/under/dress/striped_dress
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/casual_dress/sailor
	name = "Sailor dress"
	id = "sailor"
	build_path = /obj/item/clothing/under/dress/sailor_dress
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/casual_dress/purple_strapless
	name = "Strapless dress - purple"
	id = "purple_strapless"
	build_path = /obj/item/clothing/under/dress/dress_purple
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/casual_dress/green_strapless
	name = "Strapless dress - green"
	id = "green_strapless"
	build_path = /obj/item/clothing/under/dress/dress_green
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/casual_dress/pink_strapless
	name = "Strapless dress - pink"
	id = "pink_strapless"
	build_path = /obj/item/clothing/under/dress/dress_pink
	materials = list("cloth" = 500)

/datum/design/item/autotailor/under/casual_dress/flame_dress
	name = "Dress - blue flames"
	id = "flame_dress"
	build_path = /obj/item/clothing/under/dress/dress_fire
	materials = list("cloth" = 500)

//////////////////////overcoats///////////////////////
/datum/design/item/autotailor/suit/overcoats
	category = "Oversuits - Coats"
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/autotailor/suit/overcoats/brown_trench	//remove armor
	name = "Trenchcoat - brown"
	id = "brown_trench"
	build_path = /obj/item/clothing/suit/storage/det_trench
	materials = list("cloth" = 500)
//dupe: /obj/item/clothing/suit/armor/swat/officer
/datum/design/item/autotailor/suit/overcoats/grey_trench
	name = "Trenchcoat - grey"
	id = "grey_trench"
	build_path = /obj/item/clothing/suit/storage/det_trench/grey
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/red_casual	//resprite
	name = "Casual jacket - red"
	id = "red_casual"
	build_path = /obj/item/clothing/suit/storage/forensics/red
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/blue_casual
	name = "Casual jacket - blue"
	id = "blue_casual"
	build_path = /obj/item/clothing/suit/storage/forensics/blue
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/white_suit	//canidate for custom colors
	name = "Suit jacket - white"
	id = "white_suit"
	build_path = /obj/item/clothing/suit/storage/toggle/suit
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/black_suit
	name = "Suit jacket - black"
	id = "black_suit"
	build_path = /obj/item/clothing/suit/storage/toggle/suit/black
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/blue_suit
	name = "Suit jacket - blue"
	id = "blue_suit"
	build_path = /obj/item/clothing/suit/storage/toggle/suit/blue
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/purple_suit
	name = "Suit jacket - purple"
	id = "purple_suit"
	build_path = /obj/item/clothing/suit/storage/toggle/suit/purple
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/bomber_brown
	name = "bomber jacket - brown"
	id = "bomber_brown"
	build_path = /obj/item/clothing/suit/storage/toggle/bomber
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/leather_brown	//remove nt version
	name = "leather jacket - brown"
	id = "leather_brown"
	build_path = /obj/item/clothing/suit/storage/toggle/brown_jacket
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/leather_black	//remove nt version
	name = "leather jacket - black"
	id = "leather_black"
	build_path = /obj/item/clothing/suit/storage/leather_jacket
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/leather_coat_black
	name = "leather coat - black"
	id = "leather_coat_black"
	build_path = /obj/item/clothing/suit/leathercoat
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/hoodie_white	//canidate for custom colors
	name = "Hoodie - white"
	id = "hoodie_white"
	build_path = /obj/item/clothing/suit/storage/toggle/hoodie
	materials = list("cloth" = 500)
//obsolete dupe^: /obj/item/clothing/suit/storage/hooded/hoodie

/datum/design/item/autotailor/suit/overcoats/hoodie_black
	name = "Hoodie - black"
	id = "hoodie_black"
	build_path = /obj/item/clothing/suit/storage/toggle/hoodie/black
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/hoodie_blue	//remove nt logo
	name = "Hoodie - blue"
	id = "hoodie_blue"
	build_path = /obj/item/clothing/suit/storage/toggle/hoodie/nt
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/hoodie_cti	//remove cti logo
	name = "Hoodie - black CTI"
	id = "hoodie_cti"
	build_path = /obj/item/clothing/suit/storage/toggle/hoodie/cti
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/hoodie_mu	//remove mu logo
	name = "Hoodie - grey MU"
	id = "hoodie_mu"
	build_path = /obj/item/clothing/suit/storage/toggle/hoodie/mu
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/hoodie_mw
	name = "Hoodie - Mountain Wind"
	id = "hoodie_mw"
	build_path = /obj/item/clothing/suit/storage/toggle/hoodie/smw
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/poncho_red
	name = "Poncho - red"
	id = "poncho_red"
	build_path = /obj/item/clothing/suit/poncho/colored/red
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/poncho_purple
	name = "Poncho - purple"
	id = "poncho_purple"
	build_path = /obj/item/clothing/suit/poncho/colored/purple
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/poncho_green
	name = "Poncho - green"
	id = "poncho_green"
	build_path = /obj/item/clothing/suit/poncho/colored/green
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/poncho_tan
	name = "Poncho - tan"
	id = "poncho_tan"
	build_path = /obj/item/clothing/suit/poncho/colored
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/poncho_blue
	name = "Poncho - blue"
	id = "poncho_blue"
	build_path = /obj/item/clothing/suit/poncho/colored/blue
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/track_j_white	//custom colors maybe
	name = "Track jacket - white"
	id = "track_j_white"
	build_path = /obj/item/clothing/suit/storage/toggle/track/white
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/track_j_black
	name = "Track jacket - black"
	id = "track_j_black"
	build_path = /obj/item/clothing/suit/storage/toggle/track
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/track_j_blue
	name = "Track jacket - blue"
	id = "track_j_black"
	build_path = /obj/item/clothing/suit/storage/toggle/track/blue
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/track_j_red
	name = "Track jacket - red"
	id = "track_j_red"
	build_path = /obj/item/clothing/suit/storage/toggle/track/red
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/track_j_green
	name = "Track jacket - green"
	id = "track_j_green"
	build_path = /obj/item/clothing/suit/storage/toggle/track/green
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/mbill_jacket
	name = "Major Bill's shipping jacket"
	id = "mbill_jacket"
	build_path = /obj/item/clothing/suit/storage/mbill
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/winter_grey
	name = "Winter coat - grey"
	id = "winter_grey"
	build_path = /obj/item/clothing/suit/storage/hooded/wintercoat
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/gentle_coat	//remove armor
	name = "Gentleman's coat"
	id = "gentle_coat"
	build_path = /obj/item/clothing/suit/wizrobe/gentlecoat
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/priest_robes
	name = "Holiday Priest robes"
	id = "priest_robes"
	build_path = /obj/item/clothing/suit/holidaypriest
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/overalls_blue
	name = "overalls - blue"
	id = "overalls_blue"
	build_path = /obj/item/clothing/suit/apron/overalls
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/overcoats/apron_blue
	name = "apron - blue"
	id = "apron_blue"
	build_path = /obj/item/clothing/suit/apron
	materials = list("cloth" = 500)

//////////////////////work overcoats///////////////////////
/datum/design/item/autotailor/suit/work
	category = "Oversuits - Work"
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/autotailor/suit/work/hazard_orange
	name = "Hazard vest - orange"
	id = "hazard_orange"
	build_path = /obj/item/clothing/suit/storage/hazardvest
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/hazard_green
	name = "Hazard vest - green"
	id = "hazard_green"
	build_path = /obj/item/clothing/suit/storage/hazardvest/green
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/hazard_blue
	name = "Hazard vest - blue"
	id = "hazard_blue"
	build_path = /obj/item/clothing/suit/storage/hazardvest/blue
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/hazard_doc
	name = "Hazard vest - medical"
	id = "hazard_doc"
	build_path = /obj/item/clothing/suit/storage/hazardvest/white
	materials = list("cloth" = 500)
//ponchos and wcoats could be converted to non-job specific
/datum/design/item/autotailor/suit/work/poncho_engineering
	name = "Poncho - engineering"
	id = "poncho_engineering"
	build_path = /obj/item/clothing/suit/poncho/roles/engineering
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/poncho_medical
	name = "Poncho - medical"
	id = "poncho_medical"
	build_path = /obj/item/clothing/suit/poncho/roles/medical
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/poncho_science
	name = "Poncho - science"
	id = "poncho_science"
	build_path = /obj/item/clothing/suit/poncho/roles/science
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/poncho_cargo
	name = "Poncho - cargo"
	id = "poncho_cargo"
	build_path = /obj/item/clothing/suit/poncho/roles/cargo
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/poncho_sec
	name = "Poncho - security"
	id = "poncho_sec"
	build_path = /obj/item/clothing/suit/poncho/roles/security
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/winter_engineering
	name = "Winter coat - engineering"
	id = "winter_engineering"
	build_path = /obj/item/clothing/suit/storage/hooded/wintercoat/engineering
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/winter_atmos
	name = "Winter coat - atmospherics"
	id = "winter_atmos"
	build_path = /obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/winter_medical
	name = "Winter coat - medical"
	id = "winter_medical"
	build_path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/winter_cap
	name = "Winter coat - captain"
	id = "winter_cap"
	build_path = /obj/item/clothing/suit/storage/hooded/wintercoat/captain
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/winter_miner
	name = "Winter coat - miner"
	id = "winter_miner"
	build_path = /obj/item/clothing/suit/storage/hooded/wintercoat/miner
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/winter_hydro
	name = "Winter coat - hydroponics"
	id = "winter_hydro"
	build_path = /obj/item/clothing/suit/storage/hooded/wintercoat/hydro
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/winter_sec
	name = "Winter coat - security"
	id = "winter_sec"
	build_path = /obj/item/clothing/suit/storage/hooded/wintercoat/security
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/winter_cargo
	name = "Winter coat - cargo"
	id = "winter_cargo"
	build_path = /obj/item/clothing/suit/storage/hooded/wintercoat/cargo
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/winter_sci
	name = "Winter coat - science"
	id = "winter_sci"
	build_path = /obj/item/clothing/suit/storage/hooded/wintercoat/science
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/lab_white	//canidate for custom colors
	name = "Labcoat - white"
	id = "lab_white"
	build_path = /obj/item/clothing/suit/storage/toggle/labcoat
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/lab_blue
	name = "Labcoat - blue-edged"
	id = "lab_blue"
	build_path = /obj/item/clothing/suit/storage/toggle/labcoat/blue
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/lab_sci	//rename
	name = "Labcoat - scientist"
	id = "lab_sci"
	build_path = /obj/item/clothing/suit/storage/toggle/labcoat/science
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/lab_viro
	name = "Labcoat - virologist"
	id = "lab_viro"
	build_path = /obj/item/clothing/suit/storage/toggle/labcoat/virologist
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/lab_gene
	name = "Labocat - geneticist"
	id = "lab_gene"
	build_path = /obj/item/clothing/suit/storage/toggle/labcoat/genetics
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/lab_chem
	name = "Labcoat - chemist"
	id = "lab_chem"
	build_path = /obj/item/clothing/suit/storage/toggle/labcoat/chemist
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/lab_cmo_white
	name = "Labcoat - CMO white"
	id = "lab_cmo_white"
	build_path = /obj/item/clothing/suit/storage/toggle/labcoat/cmoalt
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/lab_cmo_blue
	name = "Labcoat - CMO blue"
	id = "lab_cmo_blue"
	build_path = /obj/item/clothing/suit/storage/toggle/labcoat/cmo
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/coatlab_cmo
	name = "Labcoat coat - CMO"
	id = "coatlab_cmo"
	build_path = /obj/item/clothing/suit/storage/toggle/labcoat/coat_cmo
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/coatlab_rd
	name = "Labcoat coat - RD"
	id = "coatlab_rd"
	build_path = /obj/item/clothing/suit/storage/toggle/labcoat/rd
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/jacket_cap
	name = "Casual jacket - captain"
	id = "jacket_cap"
	build_path = /obj/item/clothing/suit/captunic/capjacket
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/tunic_cap
	name = "Tunic - captain"
	id = "tunic_cap"
	build_path = /obj/item/clothing/suit/captunic
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/tunic_cap_hat
	name = "Tunic - captain hat"
	id = "tunic_cap_hat"
	build_path = /obj/item/clothing/head/caphat/formal
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/judge_robes
	name = "Judge robe"
	id = "judge_robes"
	build_path = /obj/item/clothing/suit/judgerobe
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/judgeeccentric
	name = "Judge robe - eccentric"
	id = "judgeeccentric"
	build_path = /obj/item/clothing/suit/eccentricjudge
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/chef_coat
	name = "Chef coat"
	id = "chef_coat"
	build_path = /obj/item/clothing/suit/chef
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/chef_apron
	name = "Chef apron"
	id = "chef_apron"
	build_path = /obj/item/clothing/suit/chef/classic
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/chef_hat	//technically custom color, but custom colors shouldn't be called chef hats
	name = "Chef hat"
	id = "chef_hat"
	build_path = /obj/item/clothing/head/chefhat
	materials = list("cloth" = 500)
//dupe^: /obj/item/clothing/head/collectable/chef

/datum/design/item/autotailor/suit/work/chaplain_coat
	name = "Chaplain coat"
	id = "chaplain_coat"
	build_path = /obj/item/clothing/suit/chaplain_hoodie
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/chaplain_hat
	name = "Chaplain hat - dark"
	id = "chaplain_hat"
	build_path = /obj/item/clothing/head/chaplain_hood
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/nun_robe
	name = "Nun robe"
	id = "nun_robe"
	build_path = /obj/item/clothing/suit/nun
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/nun_hood
	name = "Nun hood"
	id = "nun_hood"
	build_path = /obj/item/clothing/head/nun_hood
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/patient_gown
	name = "Medical - patient gown"
	id = "patient_gown"
	build_path = /obj/item/clothing/suit/patientgown
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/surgery_apron
	name = "Medical - surgical apron"
	id = "surgery_apron"
	build_path = /obj/item/clothing/suit/surgicalapron
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/ems_jacket
	name = "Medical - EMS jacket"
	id = "ems_jacket"
	build_path = /obj/item/clothing/suit/storage/toggle/fr_jacket/ems
	materials = list("cloth" = 500)

/datum/design/item/autotailor/suit/work/ems_jacket_green
	name = "Medical - green EMS jacket"
	id = "ems_jacket_green"
	build_path = /obj/item/clothing/suit/storage/toggle/fr_jacket
	materials = list("cloth" = 500)

//////////////////////Industrial equipment///////////////////////
/datum/design/item/autotailor/hats/industrial
	category = "Industrial equipment"
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/autotailor/hats/industrial/hardhat_yellow
	name = "Hardhat - yellow"
	id = "hardhat_yellow"
	build_path = /obj/item/clothing/head/hardhat
	materials = list("cloth" = 500)
//dupe^: /obj/item/clothing/head/collectable/hardhat

/datum/design/item/autotailor/hats/industrial/hardhat_orange
	name = "Hardhat - orange"
	id = "hardhat_orange"
	build_path = /obj/item/clothing/head/hardhat/orange
	materials = list("cloth" = 500)

/datum/design/item/autotailor/hats/industrial/hardhat_white
	name = "Hardhat - white"
	id = "hardhat_white"
	build_path = /obj/item/clothing/head/hardhat/white
	materials = list("cloth" = 500)

/datum/design/item/autotailor/hats/industrial/hardhat_blue
	name = "Hardhat - blue"
	id = "hardhat_blue"
	build_path = /obj/item/clothing/head/hardhat/dblue
	materials = list("cloth" = 500)

/datum/design/item/autotailor/hats/industrial/hardhat_red
	name = "Hardhat - red"
	id = "hardhat_red"
	build_path = /obj/item/clothing/head/hardhat/red
	materials = list("cloth" = 500)

/datum/design/item/autotailor/hats/industrial/welding_goggles
	name = "Welding goggles"
	id = "welding_goggles"
	build_path = /obj/item/clothing/glasses/welding
	materials = list("cloth" = 500)

/datum/design/item/autotailor/hats/industrial/welding_goggles_adv
	name = "Welding goggles - advanced"
	id = "welding_goggles_adv"
	build_path = /obj/item/clothing/glasses/welding/superior
	materials = list("cloth" = 500)

/datum/design/item/autotailor/hats/industrial/welding_grey
	name = "Welding hat - grey"
	id = "welding_grey"
	build_path = /obj/item/clothing/head/welding
	materials = list("cloth" = 500)
//dupe but maybe keep^: /obj/item/clothing/head/collectable/welding

/datum/design/item/autotailor/hats/industrial/welding_yellow
	name = "Welding hat - yellow"
	id = "welding_yellow"
	build_path = /obj/item/clothing/head/welding/engie
	materials = list("cloth" = 500)

/datum/design/item/autotailor/hats/industrial/welding_knight
	name = "Welding hat - knight"
	id = "welding_knight"
	build_path = /obj/item/clothing/head/welding/knight
	materials = list("cloth" = 500)

/datum/design/item/autotailor/hats/industrial/welding_fancy
	name = "Welding hat - fancy black"
	id = "welding_fancy"
	build_path = /obj/item/clothing/head/welding/fancy
	materials = list("cloth" = 500)

/datum/design/item/autotailor/hats/industrial/welding_demon
	name = "Welding hat - demon"
	id = "welding_demon"
	build_path = /obj/item/clothing/head/welding/demon
	materials = list("cloth" = 500)

/datum/design/item/autotailor/hats/industrial/welding_carp
	name = "Welding hat - carp"
	id = "welding_carp"
	build_path = /obj/item/clothing/head/welding/carp
	materials = list("cloth" = 500)

/datum/design/item/autotailor/hats/industrial/webbing_small
	name = "Webbing vest - small"
	id = "webbing_small"
	build_path = /obj/item/clothing/accessory/storage/webbing
	materials = list("cloth" = 500)

/datum/design/item/autotailor/hats/industrial/webbing_med
	name = "Webbing vest - medium"
	id = "webbing_med"
	build_path = /obj/item/clothing/accessory/storage/webbing_large
	materials = list("cloth" = 500)

/datum/design/item/autotailor/hats/industrial/webbing_l_brown
	name = "Webbing vest - large brown"
	id = "webbing_l_brown"
	build_path = /obj/item/clothing/accessory/storage/brown_vest
	materials = list("cloth" = 500)

/datum/design/item/autotailor/hats/industrial/webbing_l_black
	name = "Webbing vest - large black"
	id = "webbing_l_black"
	build_path = /obj/item/clothing/accessory/storage/black_vest
	materials = list("cloth" = 500)

/datum/design/item/autotailor/hats/industrial/webbing_l_white	//custom colors?
	name = "Webing vest - large white"
	id = "webbing_l_white"
	build_path = /obj/item/clothing/accessory/storage/white_vest
	materials = list("cloth" = 500)

/datum/design/item/autotailor/hats/industrial/pouch_brown
	name = "Drop pouches - brown"
	id = "pouch_brown"
	build_path = /obj/item/clothing/accessory/storage/drop_pouches/brown
	materials = list("cloth" = 500)

/datum/design/item/autotailor/hats/industrial/pouch_black
	name = "Drop pouches - black"
	id = "pouch_black"
	build_path = /obj/item/clothing/accessory/storage/drop_pouches/black
	materials = list("cloth" = 500)

/datum/design/item/autotailor/hats/industrial/pouch_white	//custom colors?
	name = "Drop pouches - white"
	id = "pouch white"
	build_path = /obj/item/clothing/accessory/storage/drop_pouches/white
	materials = list("cloth" = 500)