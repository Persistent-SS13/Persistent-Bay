//Unathi clothing.

/obj/item/clothing/suit/unathi/robe
	name = "roughspun robes"
	desc = "A traditional Unathi garment."
	icon_state = "robe-unathi"
	item_state = "robe-unathi"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/clothing/suit/unathi/mantle
	name = "hide mantle"
	desc = "A rather grisly selection of cured hides and skin, sewn together to form a ragged mantle."
	icon_state = "mantle-unathi"
	item_state = "mantle-unathi"
	body_parts_covered = UPPER_TORSO

//Misc Xeno clothing.

/obj/item/clothing/suit/xeno/furs
	name = "heavy furs"
	desc = "A traditional Zhan-Khazan garment."
	icon_state = "zhan_furs"
	item_state = "zhan_furs"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS

/obj/item/clothing/head/xeno/scarf
	name = "headscarf"
	desc = "A scarf of coarse fabric. Seems to have ear-holes."
	icon_state = "zhan_scarf"
	body_parts_covered = HEAD|FACE

/obj/item/clothing/shoes/sandal/xeno/caligae
	name = "caligae"
	desc = "A pair of sandals modelled after the ancient Roman caligae."
	icon_state = "caligae"
	item_state = "caligae"
	body_parts_covered = FEET|LEGS

/obj/item/clothing/shoes/sandal/xeno/caligae/white
	desc = "A pair of sandals modelled after the ancient Roman caligae. This one has a white covering."
	icon_state = "whitecaligae"
	item_state = "whitecaligae"

/obj/item/clothing/shoes/sandal/xeno/caligae/grey
	desc = "A pair of sandals modelled after the ancient Roman caligae. This one has a grey covering."
	icon_state = "greycaligae"
	item_state = "greycaligae"

/obj/item/clothing/shoes/sandal/xeno/caligae/black
	desc = "A pair of sandals modelled after the ancient Roman caligae. This one has a black covering."
	icon_state = "blackcaligae"
	item_state = "blackcaligae"

/obj/item/clothing/accessory/shouldercape
	name = "shoulder cape"
	desc = "A simple shoulder cape."
	icon_state = "gruntcape"
	slot = ACCESSORY_SLOT_INSIGNIA // Adding again in case we want to change it in the future.

/obj/item/clothing/accessory/shouldercape/grunt
	name = "cape"
	desc = "A simple looking cape with a couple of runes woven into the fabric."
	icon_state = "gruntcape" // Again, just in case it is changed.

/obj/item/clothing/accessory/shouldercape/officer
	name = "officer's cape"
	desc = "A decorated cape. Runed patterns have been woven into the fabric."
	icon_state = "officercape"

/obj/item/clothing/accessory/shouldercape/command
	name = "command cape"
	desc = "A heavily decorated cape with rank emblems on the shoulders signifying prestige. An ornate runed design has been woven into the fabric of it"
	icon_state = "commandcape"

/obj/item/clothing/accessory/shouldercape/general
	name = "general's cape"
	desc = "An extremely decorated cape with an intricately runed design has been woven into the fabric of this cape with great care."
	icon_state = "leadercape"

//Voxclothing

/obj/item/clothing/suit/armor/vox_scrap
	name = "rusted metal armor"
	desc = "A hodgepodge of various pieces of metal scrapped together into a rudimentary vox-shaped piece of armor."
	allowed = list(/obj/item/weapon/gun, /obj/item/weapon/tank)
	armor  = list(
		DAM_BLUNT 	= 70,
		DAM_PIERCE 	= 60,
		DAM_CUT 	= 70,
		DAM_BULLET 	= 30,
		DAM_LASER 	= 20,
		DAM_ENERGY 	= 10,
		DAM_BURN 	= 20,
		DAM_BOMB 	= 40,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)
	icon_state = "vox-scrap"
	icon_state = "vox-scrap"
	body_parts_covered = UPPER_TORSO|ARMS|LOWER_TORSO|LEGS
	species_restricted = list(SPECIES_VOX, SPECIES_VOX_ARMALIS)
	siemens_coefficient = 1 //Its literally metal

//Resomi Clothing

/obj/item/clothing/suit/storage/resomi/cloak
	name = "broken cloak"
	desc = "It drapes over a Resomi's shoulders and closes at the neck with pockets convienently placed inside."
	icon = 'icons/mob/species/resomi/teshari_cloak.dmi'
	icon_override = 'icons/mob/species/resomi/teshari_cloak.dmi'
	icon_state = "tesh_cloak_bo"
	item_state = "tesh_cloak_bo"
	species_restricted = list(SPECIES_RESOMI)
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/storage/resomi/cloak/standard/black_orange
	name = "black and orange cloak"
	icon_state = "tesh_cloak_bo"
	item_state = "tesh_cloak_bo"

/obj/item/clothing/suit/storage/resomi/cloak/standard/black_grey
	name = "black and grey cloak"
	icon_state = "tesh_cloak_bg"
	item_state = "tesh_cloak_bg"

/obj/item/clothing/suit/storage/resomi/cloak/standard/black_midgrey
	name = "black and medium grey cloak"
	icon_state = "tesh_cloak_bmg"
	item_state = "tesh_cloak_bmg"

/obj/item/clothing/suit/storage/resomi/cloak/standard/black_lightgrey
	name = "black and light grey cloak"
	icon_state = "tesh_cloak_blg"
	item_state = "tesh_cloak_blg"

/obj/item/clothing/suit/storage/resomi/cloak/standard/black_white
	name = "black and white cloak"
	icon_state = "tesh_cloak_bw"
	item_state = "tesh_cloak_bw"

/obj/item/clothing/suit/storage/resomi/cloak/standard/black_red
	name = "black and red cloak"
	icon_state = "tesh_cloak_br"
	item_state = "tesh_cloak_br"

/obj/item/clothing/suit/storage/resomi/cloak/standard/black
	name = "black cloak"
	icon_state = "tesh_cloak_bn"
	item_state = "tesh_cloak_bn"

/obj/item/clothing/suit/storage/resomi/cloak/standard/black_yellow
	name = "black and yellow cloak"
	icon_state = "tesh_cloak_by"
	item_state = "tesh_cloak_by"

/obj/item/clothing/suit/storage/resomi/cloak/standard/black_green
	name = "black and green cloak"
	icon_state = "tesh_cloak_bgr"
	item_state = "tesh_cloak_bgr"

/obj/item/clothing/suit/storage/resomi/cloak/standard/black_blue
	name = "black and blue cloak"
	icon_state = "tesh_cloak_bbl"
	item_state = "tesh_cloak_bbl"

/obj/item/clothing/suit/storage/resomi/cloak/standard/black_purple
	name = "black and purple cloak"
	icon_state = "tesh_cloak_bp"
	item_state = "tesh_cloak_bp"

/obj/item/clothing/suit/storage/resomi/cloak/standard/black_pink
	name = "black and pink cloak"
	icon_state = "tesh_cloak_bpi"
	item_state = "tesh_cloak_bpi"

/obj/item/clothing/suit/storage/resomi/cloak/standard/black_brown
	name = "black and brown cloak"
	icon_state = "tesh_cloak_bbr"
	item_state = "tesh_cloak_bbr"

/obj/item/clothing/suit/storage/resomi/cloak/standard/orange_grey
	name = "orange and grey cloak"
	icon_state = "tesh_cloak_og"
	item_state = "tesh_cloak_og"

/obj/item/clothing/suit/storage/resomi/cloak/standard/rainbow
	name = "rainbow cloak"
	icon_state = "tesh_cloak_rainbow"
	item_state = "tesh_cloak_rainbow"

/obj/item/clothing/suit/storage/resomi/cloak/standard/lightgrey_grey
	name = "light grey and grey cloak"
	icon_state = "tesh_cloak_lgg"
	item_state = "tesh_cloak_lgg"

/obj/item/clothing/suit/storage/resomi/cloak/standard/white_grey
	name = "white and grey cloak"
	icon_state = "tesh_cloak_wg"
	item_state = "tesh_cloak_wg"

/obj/item/clothing/suit/storage/resomi/cloak/standard/red_grey
	name = "red and grey cloak"
	icon_state = "tesh_cloak_rg"
	item_state = "tesh_cloak_rg"

/obj/item/clothing/suit/storage/resomi/cloak/standard/orange
	name = "orange cloak"
	icon_state = "tesh_cloak_on"
	item_state = "tesh_cloak_on"

/obj/item/clothing/suit/storage/resomi/cloak/standard/yellow_grey
	name = "yellow and grey cloak"
	icon_state = "tesh_cloak_yg"
	item_state = "tesh_cloak_yg"

/obj/item/clothing/suit/storage/resomi/cloak/standard/green_grey
	name = "green and grey cloak"
	icon_state = "tesh_cloak_gg"
	item_state = "tesh_cloak_gg"

/obj/item/clothing/suit/storage/resomi/cloak/standard/blue_grey
	name = "blue and grey cloak"
	icon_state = "tesh_cloak_blug"
	item_state = "tesh_cloak_blug"

/obj/item/clothing/suit/storage/resomi/cloak/standard/purple_grey
	name = "purple and grey cloak"
	icon_state = "tesh_cloak_pg"
	item_state = "tesh_cloak_pg"

/obj/item/clothing/suit/storage/resomi/cloak/standard/pink_grey
	name = "pink and grey cloak"
	icon_state = "tesh_cloak_pig"
	item_state = "tesh_cloak_pig"

/obj/item/clothing/suit/storage/resomi/cloak/standard/brown_grey
	name = "brown and grey cloak"
	icon_state = "tesh_cloak_brg"
	item_state = "tesh_cloak_brg"

/obj/item/clothing/suit/storage/resomi/cloak/jobs
	icon = 'icons/mob/species/resomi/deptcloak.dmi'
	icon_override = 'icons/mob/species/resomi/deptcloak.dmi'

/obj/item/clothing/suit/storage/resomi/cloak/jobs/cargo
	name = "cargo cloak"
	desc = "A soft Resomi cloak made for the Cargo department"
	icon_state = "tesh_cloak_car"
	item_state = "tesh_cloak_car"

/obj/item/clothing/suit/storage/resomi/cloak/jobs/mining
	name = "mining cloak"
	desc = "A soft Resomi cloak made for Mining"
	icon_state = "tesh_cloak_mine"
	item_state = "tesh_cloak_mine"

/obj/item/clothing/suit/storage/resomi/cloak/jobs/command
	name = "command cloak"
	desc = "A soft Resomi cloak made for the Command department"
	icon_state = "tesh_cloak_comm"
	item_state = "tesh_cloak_comm"

/obj/item/clothing/suit/storage/resomi/cloak/jobs/ce
	name = "cheif engineer cloak"
	desc = "A soft Resomi cloak made the Chief Engineer"
	icon_state = "tesh_cloak_ce"
	item_state = "tesh_cloak_ce"

/obj/item/clothing/suit/storage/resomi/cloak/jobs/eningeer
	name = "engineering cloak"
	desc = "A soft Resomi cloak made for the Engineering department"
	icon_state = "tesh_cloak_engie"
	item_state = "tesh_cloak_engie"

/obj/item/clothing/suit/storage/resomi/cloak/jobs/atmos
	name = "atmospherics cloak"
	desc = "A soft Resomi cloak made for the Atmospheric Technician"
	icon_state = "tesh_cloak_atmos"
	item_state = "tesh_cloak_atmos"

/obj/item/clothing/suit/storage/resomi/cloak/jobs/cmo
	name = "chief medical officer cloak"
	desc = "A soft Resomi cloak made the Cheif Medical Officer"
	icon_state = "tesh_cloak_cmo"
	item_state = "tesh_cloak_cmo"

/obj/item/clothing/suit/storage/resomi/cloak/jobs/medical
	name = "medical cloak"
	desc = "A soft Resomi cloak made for the Medical department"
	icon_state = "tesh_cloak_doc"
	item_state = "tesh_cloak_doc"

/obj/item/clothing/suit/storage/resomi/cloak/jobs/chemistry
	name = "chemist cloak"
	desc = "A soft Resomi cloak made for the Chemist"
	icon_state = "tesh_cloak_chem"
	item_state = "tesh_cloak_chem"

/obj/item/clothing/suit/storage/resomi/cloak/jobs/viro
	name = "virologist cloak"
	desc = "A soft Resomi cloak made for the Virologist"
	icon_state = "tesh_cloak_viro"
	item_state = "tesh_cloak_viro"

/obj/item/clothing/suit/storage/resomi/cloak/jobs/para
	name = "paramedic cloak"
	desc = "A soft Resomi cloak made for the Paramedic"
	icon_state = "tesh_cloak_para"
	item_state = "tesh_cloak_para"

/obj/item/clothing/suit/storage/resomi/cloak/jobs/sci
	name = "scientist cloak"
	desc = "A soft Resomi cloak made for the Science department"
	icon_state = "tesh_cloak_sci"
	item_state = "tesh_cloak_sci"

/obj/item/clothing/suit/storage/resomi/cloak/jobs/robo
	name = "roboticist cloak"
	desc = "A soft Resomi cloak made for the Roboticist"
	icon_state = "tesh_cloak_robo"
	item_state = "tesh_cloak_robo"

/obj/item/clothing/suit/storage/resomi/cloak/jobs/sec
	name = "security cloak"
	desc = "A soft Resomi cloak made for the Security department"
	icon_state = "tesh_cloak_sec"
	item_state = "tesh_cloak_sec"

/obj/item/clothing/suit/storage/resomi/cloak/jobs/qm
	name = "quartermaster cloak"
	desc = "A soft Resomi cloak made for the Quartermaster"
	icon_state = "tesh_cloak_qm"
	item_state = "tesh_cloak_qm"

/obj/item/clothing/suit/storage/resomi/cloak/jobs/service
	name = "service cloak"
	desc = "A soft Resomi cloak made for the Service department"
	icon_state = "tesh_cloak_serv"
	item_state = "tesh_cloak_serv"

/obj/item/clothing/suit/storage/resomi/cloak/jobs/iaa
	name = "internal affairs cloak"
	desc = "A soft Resomi cloak made for the Internal Affairs Agent"
	icon_state = "tesh_cloak_iaa"
	item_state = "tesh_cloak_iaa"
