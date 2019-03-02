/obj/machinery/fabricator/autotailor/accessories
	name = "auto-tailor (accessories)"
	desc = "An advanced machine capable of printing many types of clothing, this one is loaded with accessory type designs."
	circuit = /obj/item/weapon/circuitboard/fabricator/autotailor/accessories
	build_type = AUTOTAILOR_ACCESSORIES

/obj/machinery/fabricator/autotailor/accessories/can_connect(var/datum/world_faction/trying, var/mob/M)
	if(!trying.limits) return 0
	if(M && !has_access(list(core_access_machine_linking), list(), M.GetAccess(req_access_faction)))
		to_chat(M, "You do not have access to link machines to [trying.name].")
		return 0
	if(trying.limits.limit_ataccessories <= trying.limits.ataccessories.len)
		if(M)
			to_chat(M, "[trying.name] cannot connect any more machines of this type.")
		return 0
	trying.limits.ataccessories |= src
	req_access_faction = trying.uid
	connected_faction = src
	
/obj/machinery/fabricator/autotailor/accessories/can_disconnect(var/datum/world_faction/trying, var/mob/M)
	if(!trying.limits) return 0
	trying.limits.ataccessories -= src
	req_access_faction = ""
	connected_faction = null
	if(M) to_chat(M, "The machine has been disconnected.")


////////////////////////////////////////////////////
//////////////////////DESIGNS///////////////////////
////////////////////////////////////////////////////

/datum/design/item/autotailor/accessories
	build_type = AUTOTAILOR_ACCESSORIES
	category = "Casual wear"
	req_tech = list(TECH_MATERIAL = 1)
	time = 30
	materials = list("cloth" = 500)

//
//casual shirts
//
/datum/design/item/autotailor/accessories/casual
	category = "Casual wear"
	materials = list("cloth" = 1000)

/datum/design/item/autotailor/accessories/casual/access_flannel_white	//custom colors, appearntly
	name = "Accessory - white flannel"
	id = "access_flannel_white"
	build_path = /obj/item/clothing/accessory/toggleable/flannel

/datum/design/item/autotailor/accessories/casual/access_flannel_red
	name = "Accessory - red flannel"
	id = "access_flannel_red"
	build_path = /obj/item/clothing/accessory/toggleable/flannel/red

/datum/design/item/autotailor/accessories/casual/access_flower_blue
	name = "Accessory - blue flower shirt"
	id = "access_flower_blue"
	build_path = /obj/item/clothing/accessory/toggleable/hawaii

/datum/design/item/autotailor/accessories/casual/access_flower_red
	name = "Accessory - red flower shirt"
	id = "access_flower_red"
	build_path = /obj/item/clothing/accessory/toggleable/hawaii/red

/datum/design/item/autotailor/accessories/casual/access_tneck
	name = "Accessory - grey turtleneck"
	id = "access_tneck"
	build_path = /obj/item/clothing/accessory/sweater

/datum/design/item/autotailor/accessories/casual/access_dashiki_bla
	name = "Accessory - black dashiki"
	id = "access_dashiki_bla"
	build_path = /obj/item/clothing/accessory/dashiki

/datum/design/item/autotailor/accessories/casual/access_dashiki_blue
	name = "Accessory - blue dashiki"
	id = "access_dashiki_blue"
	build_path = /obj/item/clothing/accessory/dashiki/blue

/datum/design/item/autotailor/accessories/casual/access_dashiki_red
	name = "Accessory - red dashiki"
	id = "access_dashiki_red"
	build_path = /obj/item/clothing/accessory/dashiki/red

/datum/design/item/autotailor/accessories/casual/access_qipao	//custom colors?
	name = "Accessory - white qipao"
	id = "access_qipao"
	build_path = /obj/item/clothing/accessory/qipao

/datum/design/item/autotailor/accessories/casual/access_thawb_white	//custom colors
	name = "Accessory - white thawb"
	id = "access_thawb_white"
	build_path = /obj/item/clothing/accessory/thawb

//
//fancy suit jackets
//
/datum/design/item/autotailor/accessories/fancy
	category = "Fancy suits"
	materials = list("cloth" = 1000, "phoron" = 500)

/datum/design/item/autotailor/accessories/fancy/access_tangzuang	//custom colors
	name = "Accessory - tangzhuang jacket"
	id = "access_tangzhuang"
	build_path = /obj/item/clothing/accessory/tangzhuang

/datum/design/item/autotailor/accessories/fancy/access_zhongshan	//custom colors
	name = "Accessory - Zhonshan jacket"
	id = "access_zhongshan"
	build_path = /obj/item/clothing/accessory/toggleable/zhongshan

/datum/design/item/autotailor/accessories/fancy/access_sherwani
	name = "Accessory - sherwani"
	id = "access_sherwani"
	build_path = /obj/item/clothing/accessory/sherwani

/datum/design/item/autotailor/accessories/fancy/access_bl_waistcoat
	name = "Accessory - waistcoat black"
	id = "access_bl_waistcoat"
	build_path = /obj/item/clothing/accessory/wcoat

/datum/design/item/autotailor/accessories/fancy/access_bl_vest
	name = "Accessory - vest black"
	id = "access_bl_vest"
	build_path = /obj/item/clothing/accessory/toggleable/vest

//
//non-shirt accessories
//
/datum/design/item/autotailor/accessories/attach
	category = "Clothing attachments"
	materials = list("cloth" = 1000, "gold" = 500)

/datum/design/item/autotailor/accessories/attach/cane
	name = "Walking cane"
	id = "cane"
	build_path = /obj/item/weapon/cane
	materials = list("wood" = 1.5 SHEETS)

/datum/design/item/autotailor/accessories/attach/canefancy
	build_path = /obj/item/weapon/staff/gentcane
	materials = list("wood" = 1.5 SHEETS, MATERIAL_GOLD = 1 SHEET)

/datum/design/item/autotailor/accessories/attach/staff
	build_path = /obj/item/weapon/staff
	materials = list("wood" = 1.5 SHEETS)


/datum/design/item/autotailor/accessories/attach/canefancy
	build_path = /obj/item/weapon/staff/gentcane
	materials = list("wood" = 1.5 SHEETS, MATERIAL_GOLD = 1 SHEET)



/datum/design/item/autotailor/accessories/attach/tie_white	//custom colors
	name = "Tie - white"
	id = "tie_white"
	build_path = /obj/item/clothing/accessory/white
	materials = list("cloth" = 1000, "gold" = 500)

/datum/design/item/autotailor/accessories/attach/tie_black
	name = "Tie - black"
	id = "tie_black"
	build_path = /obj/item/clothing/accessory/black

/datum/design/item/autotailor/accessories/attach/tie_red
	name = "Tie - red"
	id = "tie_red"
	build_path = /obj/item/clothing/accessory/red

/datum/design/item/autotailor/accessories/attach/tie_blue
	name = "Tie - blue"
	id = "tie_blue"
	build_path = /obj/item/clothing/accessory/blue

/datum/design/item/autotailor/accessories/attach/tie_navy
	name = "Tie - navy"
	id = "tie_navy"
	build_path = /obj/item/clothing/accessory/navy

/datum/design/item/autotailor/accessories/attach/stie_white	//custom colors
	name = "Tie - striped white"
	id = "stie_white"
	build_path = /obj/item/clothing/accessory/long

/datum/design/item/autotailor/accessories/attach/stie_brown
	name = "Tie - striped brown"
	id = "stie_brown"
	build_path = /obj/item/clothing/accessory/brown

/datum/design/item/autotailor/accessories/attach/stie_red
	name = "Tie - striped red"
	id = "stie_red"
	build_path = /obj/item/clothing/accessory/red_long

/datum/design/item/autotailor/accessories/attach/stie_yellow
	name = "Tie - striped yellow"
	id = "stie_yellow"
	build_path = /obj/item/clothing/accessory/yellow

/datum/design/item/autotailor/accessories/attach/cliptie_red_black
	name = "Tie - red & black w. clip"
	id = "cliptie_red_black"
	build_path = /obj/item/clothing/accessory/nt

/datum/design/item/autotailor/accessories/attach/cliptie_blue
	name = "Tie - blue w. clip"
	id = "cliptie_blue"
	build_path = /obj/item/clothing/accessory/blue_clip

/datum/design/item/autotailor/accessories/attach/fattie_yellow
	name = "Tie - fat yellow"
	id = "fattie_yellow"
	build_path = /obj/item/clothing/accessory/horrible

/datum/design/item/autotailor/accessories/attach/bowtie_white	//custom colors
	name = "Bowtie - white"
	id = "bowtie_white"
	build_path = /obj/item/clothing/accessory/bowtie/color

/datum/design/item/autotailor/accessories/attach/bowtie_yellow_purp
	name = "Bowtie - yellow & purple"
	id = "bowtie_yellow_purp"
	build_path = /obj/item/clothing/accessory/bowtie/ugly

/datum/design/item/autotailor/accessories/attach/armband_white	//custom colors
	name = "Armband - white"
	id = "armband_white"
	build_path = /obj/item/clothing/accessory/armband/med
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/armband_red
	name = "Armband - red"
	id = "armband_red"
	build_path = /obj/item/clothing/accessory/armband
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/armband_cargo
	name = "Armband - supply"
	id = "armband_cargo"
	build_path = /obj/item/clothing/accessory/armband/cargo
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/armband_eng
	name = "Armband - engineering"
	id = "armband_eng"
	build_path = /obj/item/clothing/accessory/armband/engine
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/armband_med
	name = "Armband - medical"
	id = "armband_med"
	build_path = /obj/item/clothing/accessory/armband/medblue
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/armband_emt
	name = "Armband - EMT"
	id = "armband_emt"
	build_path = /obj/item/clothing/accessory/armband/medgreen
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/armband_sec
	name = "Armband - security"
	id = "armband_sec"
	build_path = /obj/item/clothing/accessory/armband/whitered
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/armband_peace
	name = "Armband - peacekeeper"
	id = "armband_peace"
	build_path = /obj/item/clothing/accessory/armband/bluegold
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/armband_botany
	name = "Armband - botanist"
	id = "armband_botany"
	build_path = /obj/item/clothing/accessory/armband/hydro
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/scarf_white	//custom colors
	name = "Scarf - white"
	id = "scarf_white"
	build_path = /obj/item/clothing/accessory/scarf
	materials = list("cloth" = 2000)

/datum/design/item/autotailor/accessories/attach/necklace_white	//custom colors
	name = "Necklace - white"
	id = "necklace_white"
	build_path = /obj/item/clothing/accessory/necklace
	materials = list(DEFAULT_WALL_MATERIAL = 500)

/datum/design/item/autotailor/accessories/attach/lockette_silver	//techincally custom colors, but no mob sprite to show
	name = "Lockette - silver"
	id = "lockette_silver"
	build_path = /obj/item/clothing/accessory/locket
	materials = list("silver" = 500)

/datum/design/item/autotailor/accessories/attach/kneepads
	name = "Kneepads"
	id = "kneepads"
	build_path = /obj/item/clothing/accessory/kneepads
	materials = list("leather" = 2000)

/datum/design/item/autotailor/accessories/attach/medal_iron
	name = "Iron medal"
	id = "medal_iron"
	build_path = /obj/item/clothing/accessory/medal/iron
	materials = list("iron" = 500)

/datum/design/item/autotailor/accessories/attach/medal_bronze
	name = "Bronze medal"
	id = "medal_bronze"
	build_path = /obj/item/clothing/accessory/medal/bronze
	materials = list("copper" = 500)	//i don't think bronze is obtainable

/datum/design/item/autotailor/accessories/attach/medal_silver
	name = "Silver medal"
	id = "medal_silver"
	build_path = /obj/item/clothing/accessory/medal/silver
	materials = list("silver" = 500)

/datum/design/item/autotailor/accessories/attach/medal_gold
	name = "Gold medal"
	id = "medal_gold"
	build_path = /obj/item/clothing/accessory/medal/gold
	materials = list("gold" = 500)

//
//Shoes
//
/datum/design/item/autotailor/accessories/shoes
	category = "Shoes"
	materials = list("leather" = 1000)

/datum/design/item/autotailor/accessories/shoes/sneaker_white	//custom colors?
	name = "Sneakers - white"
	id = "sneaker_white"
	build_path = /obj/item/clothing/shoes/white

/datum/design/item/autotailor/accessories/shoes/sneaker_black
	name = "Sneakers - black"
	id = "sneaker_black"
	build_path = /obj/item/clothing/shoes/black

/datum/design/item/autotailor/accessories/shoes/sneaker_brown
	name = "Sneakers - brown"
	id = "sneaker_brown"
	build_path = /obj/item/clothing/shoes/brown

/datum/design/item/autotailor/accessories/shoes/sneaker_red
	name = "Sneakers - red"
	id = "sneaker_red"
	build_path = /obj/item/clothing/shoes/red

/datum/design/item/autotailor/accessories/shoes/sneaker_purple
	name = "Sneakers - purple"
	id = "sneaker_purple"
	build_path = /obj/item/clothing/shoes/purple

/datum/design/item/autotailor/accessories/shoes/sneaker_lgreen
	name = "Sneakers - lime green"
	id = "sneaker_lgreen"
	build_path = /obj/item/clothing/shoes/green

/datum/design/item/autotailor/accessories/shoes/sneaker_sblue
	name = "Sneakers - sky blue"
	id = "sneaker_sblue"
	build_path = /obj/item/clothing/shoes/blue

/datum/design/item/autotailor/accessories/shoes/sneaker_yellow
	name = "Sneakers - yellow"
	id = "sneaker_yellow"
	build_path = /obj/item/clothing/shoes/yellow

/datum/design/item/autotailor/accessories/shoes/sneaker_orange
	name = "Sneakers - orange"
	id = "sneaker_orange"
	build_path = /obj/item/clothing/shoes/orange

/datum/design/item/autotailor/accessories/shoes/sneaker_rainbow
	name = "Sneakers - rainbow"
	id = "sneaker_rainbow"
	build_path = /obj/item/clothing/shoes/rainbow

/datum/design/item/autotailor/accessories/shoes/sneaker_leather
	name = "Sneakers - leather"
	id = "sneaker_leather"
	build_path = /obj/item/clothing/shoes/leather

/datum/design/item/autotailor/accessories/shoes/sneaker_athwhite
	name = "Sneakers - Athletic white"
	id = "sneaker_athwhite"
	build_path = /obj/item/clothing/shoes/athletic

/datum/design/item/autotailor/accessories/shoes/flats_white	//custom colors
	name = "Flats - white"
	id = "flats_white"
	build_path = /obj/item/clothing/shoes/flats

/datum/design/item/autotailor/accessories/shoes/sneaker_blackalt
	name = "Sneakers - black alt"
	id = "sneaker_blackalt"
	build_path = /obj/item/clothing/shoes/cyborg

/datum/design/item/autotailor/accessories/shoes/hitop_white	//custom color maybe
	name = "Hightops - white"
	id = "hitop_white"
	build_path = /obj/item/clothing/shoes/hightops

/datum/design/item/autotailor/accessories/shoes/hitop_black
	name = "Hightops - black"
	id = "hitop_black"
	build_path = /obj/item/clothing/shoes/hightops/black

/datum/design/item/autotailor/accessories/shoes/hitop_brown
	name = "Hightops - brown"
	id = "hitop_brown"
	build_path = /obj/item/clothing/shoes/hightops/brown

/datum/design/item/autotailor/accessories/shoes/hitop_red
	name = "Hightops - red"
	id = "hitop_red"
	build_path = /obj/item/clothing/shoes/hightops/red

/datum/design/item/autotailor/accessories/shoes/hitop_purple
	name = "Hightops - purple"
	id = "hitop_purple"
	build_path = /obj/item/clothing/shoes/hightops/purple

/datum/design/item/autotailor/accessories/shoes/hitop_lgreen
	name = "Hightops - lime green"
	id = "hitop_lgreen"
	build_path = /obj/item/clothing/shoes/hightops/green

/datum/design/item/autotailor/accessories/shoes/hitop_sblue
	name = "Hightops - sky blue"
	id = "hitop_sblue"
	build_path = /obj/item/clothing/shoes/hightops/blue

/datum/design/item/autotailor/accessories/shoes/hitop_yellow
	name = "Hightops - yellow"
	id = "hitop_yellow"
	build_path = /obj/item/clothing/shoes/hightops/yellow

/datum/design/item/autotailor/accessories/shoes/hitop_orange
	name = "Hightops - orange"
	id = "hitop_orange"
	build_path = /obj/item/clothing/shoes/hightops/orange

//these are supposed to be xeno shoes, maybe remove
/datum/design/item/autotailor/accessories/shoes/caligae_bare
	name = "Caligae - bare"
	id = "caligae_bare"
	build_path = /obj/item/clothing/shoes/sandal/xeno/caligae
	materials = list("wood" = 1000)

/datum/design/item/autotailor/accessories/shoes/caligae_white
	name = "Caligae - white"
	id = "caligae_white"
	build_path = /obj/item/clothing/shoes/sandal/xeno/caligae/white
	materials = list("wood" = 1000)

/datum/design/item/autotailor/accessories/shoes/caligae_grey
	name = "Caligae - grey"
	id = "caligae_grey"
	build_path = /obj/item/clothing/shoes/sandal/xeno/caligae/grey
	materials = list("wood" = 1000)

/datum/design/item/autotailor/accessories/shoes/caligae_black
	name = "Caligae - black"
	id = "Caligae - black"
	build_path = /obj/item/clothing/shoes/sandal/xeno/caligae/black
	materials = list("wood" = 1000)

/datum/design/item/autotailor/accessories/shoes/sandal_brown
	name = "Sandals"
	id = "sandal_brown"
	build_path = /obj/item/clothing/shoes/sandal
	materials = list("wood" = 1000)

/datum/design/item/autotailor/accessories/shoes/sandal_xeno	//these are exactly the same sprite as above on humans, remove if its the case with xenos too
	name = "Sandals - xenos"
	id = "sandal_xeno"
	build_path = /obj/item/clothing/shoes/sandal/xeno
	materials = list("wood" = 1000)

/datum/design/item/autotailor/accessories/shoes/dressshoes_white	//custom colors?
	name = "Dress shoes - white"
	id = "dressshoes_white"
	build_path = /obj/item/clothing/shoes/dress/white
	materials = list("leather" = 500, "gold" = 500)

/datum/design/item/autotailor/accessories/shoes/dress_black
	name = "Dress shoes - black"
	id = "dress_black"
	build_path = /obj/item/clothing/shoes/dress
	materials = list("leather" = 500, "gold" = 500)

/datum/design/item/autotailor/accessories/shoes/jackb_black
	name = "Jackboots - black"
	id = "jackb_black"
	build_path = /obj/item/clothing/shoes/jackboots
	materials = list("leather" = 500, DEFAULT_WALL_MATERIAL = 1000)

/datum/design/item/autotailor/accessories/shoes/jackb_black_notoe
	name = "Jackboots - black toeless"
	id = "jackb_black_notoe"
	build_path = /obj/item/clothing/shoes/jackboots/unathi
	materials = list("leather" = 500, DEFAULT_WALL_MATERIAL = 1000)

/datum/design/item/autotailor/accessories/shoes/jackb_grey	//item sprite looks arcane-y, but mob sprite looks normal for everyday use
	name = "Jackboots - grey"
	id = "jackb_grey"
	build_path = /obj/item/clothing/shoes/cult
	materials = list("leather" = 500, DEFAULT_WALL_MATERIAL = 1000)

/datum/design/item/autotailor/accessories/shoes/jackb_tan
	name = "Jackboots - tan"
	id = "jackb_tan"
	build_path = /obj/item/clothing/shoes/desertboots
	materials = list("leather" = 500, DEFAULT_WALL_MATERIAL = 1000)

/datum/design/item/autotailor/accessories/shoes/jackb_brown
	name = "jackboots - brown"
	id = "jackb_brown"
	build_path = /obj/item/clothing/shoes/jungleboots
	materials = list("leather" = 500, DEFAULT_WALL_MATERIAL = 1000)

/datum/design/item/autotailor/accessories/shoes/workboot
	name = "Industrial workboots"
	id = "workboot"
	build_path = /obj/item/clothing/shoes/workboots
	materials = list("leather" = 500, DEFAULT_WALL_MATERIAL = 1000)

/datum/design/item/autotailor/accessories/shoes/workboot_notoe	//hopefully unique sprite on unanthe, same sprite as above on human, also outdated object sprite
	name = "Industrial workboots - toeless"
	id = "workboot_notoe"
	build_path = /obj/item/clothing/shoes/workboots/toeless
	materials = list("leather" = 500, DEFAULT_WALL_MATERIAL = 1000)

/datum/design/item/autotailor/accessories/shoes/galoshes_yellow
	name = "Galoshes"
	id = "galoshes_yellow"
	build_path = /obj/item/clothing/shoes/galoshes
	materials = list("plastic" = 2000)

/datum/design/item/autotailor/accessories/shoes/slippers_bunny
	name = "Bunny slippers"
	id = "slippers_bunny"
	build_path = /obj/item/clothing/shoes/slippers
	materials = list("cloth" = 1000)

/datum/design/item/autotailor/accessories/shoes/slippers_bunny_worn	//if we ever add clothing states, make this the snowflake item with its own dirty icon
	name = "Bunny slippers - worn"
	id = "slippers_bunny_worn"
	build_path = /obj/item/clothing/shoes/slippers_worn
	materials = list("cloth" = 500)

//
//Ears,anemities fab will hopefully make this list more precisely named
//
/datum/design/item/autotailor/accessories/ears
	category = "Ears"
	materials = list("plastic" = 1000)

/datum/design/item/autotailor/accessories/ears/headphones
	name = "headphones"
	id = "headphones"
	build_path = /obj/item/clothing/ears/earmuffs/headphones

/datum/design/item/autotailor/accessories/ears/earmuffs
	name = "earmuffs"
	id = "earmuffs"
	build_path = /obj/item/clothing/ears/earmuffs

/datum/design/item/autotailor/accessories/ears/dangle_white	//custom colors
	name = "Dangle earrings - white"
	id = "Dangle earrings - white"
	build_path = /obj/item/clothing/ears/earring/dangle
	materials = list("plastic" = 500)

/datum/design/item/autotailor/accessories/ears/dangle_wood
	name = "Dangle earrings - wood"
	id = "dangle_wood"
	build_path = /obj/item/clothing/ears/earring/dangle/wood
	materials = list("wood" = 500)

/datum/design/item/autotailor/accessories/ears/dangle_glass
	name = "Dangle earrings - glass"
	id = "dangle_glass"
	build_path = /obj/item/clothing/ears/earring/dangle/glass
	materials = list("glass" = 500)

/datum/design/item/autotailor/accessories/ears/dangle_iron
	name = "Dangle earrings - iron"
	id = "dangle_iron"
	build_path = /obj/item/clothing/ears/earring/dangle/iron
	materials = list("iron" = 500)

/datum/design/item/autotailor/accessories/ears/dangle_steel
	name = "Dangle earrings - steel"
	id = "dangle_steel"
	build_path = /obj/item/clothing/ears/earring/dangle/steel
	materials = list(DEFAULT_WALL_MATERIAL = 500)

/datum/design/item/autotailor/accessories/ears/dangle_silver
	name = "Dangle earrings - silver"
	id = "dangle_silver"
	build_path = /obj/item/clothing/ears/earring/dangle/silver
	materials = list("silver" = 500)

/datum/design/item/autotailor/accessories/ears/dangle_platinum
	name = "Dangle earrings - platinum"
	id = "dangle_platinum"
	build_path = /obj/item/clothing/ears/earring/dangle/platinum
	materials = list("platinum" = 500)

/datum/design/item/autotailor/accessories/ears/dangle_gold
	name = "Dangle earrings - gold"
	id = "dangle_gold"
	build_path = /obj/item/clothing/ears/earring/dangle/gold
	materials = list("gold" = 500)

/datum/design/item/autotailor/accessories/ears/dangle_diamond
	name = "Dangle earrings - diamond"
	id = "dangle_diamond"
	build_path = /obj/item/clothing/ears/earring/dangle/diamond
	materials = list("diamond" = 500)

/datum/design/item/autotailor/accessories/ears/stud_pearl	//custom colors
	name = "Stud earrings - pearl"
	id = "stud_pearl"
	build_path = /obj/item/clothing/ears/earring/stud
	materials = list("plastic" = 500)

/datum/design/item/autotailor/accessories/ears/stud_wood
	name = "Stud earrings - wood"
	id = "stud_wood"
	build_path = /obj/item/clothing/ears/earring/stud/wood
	materials = list("wood" = 500)

/datum/design/item/autotailor/accessories/ears/stud_glass
	name = "Stud earrings - glass"
	id = "stud_glass"
	build_path = /obj/item/clothing/ears/earring/stud/glass
	materials = list("glass" = 500)

/datum/design/item/autotailor/accessories/ears/stud_iron
	name = "Stud earrings - iron"
	id = "stud_iron"
	build_path = /obj/item/clothing/ears/earring/stud/iron
	materials = list("iron" = 500)

/datum/design/item/autotailor/accessories/ears/stud_steel
	name = "Stud earrings - steel"
	id = "stud_steel"
	build_path = /obj/item/clothing/ears/earring/stud/steel
	materials = list(DEFAULT_WALL_MATERIAL = 500)

/datum/design/item/autotailor/accessories/ears/stud_silver
	name = "Stud earrings - silver"
	id = "stud_silver"
	build_path = /obj/item/clothing/ears/earring/stud/silver
	materials = list("silver" = 500)

/datum/design/item/autotailor/accessories/ears/stud_platinum
	name = "Stud earrings - platinum"
	id = "stud_platinum"
	build_path = /obj/item/clothing/ears/earring/stud/platinum
	materials = list("platinum" = 500)

/datum/design/item/autotailor/accessories/ears/stud_gold
	name = "Stud earrings - gold"
	id = "stud_gold"
	build_path = /obj/item/clothing/ears/earring/stud/gold
	materials = list("gold" = 500)

/datum/design/item/autotailor/accessories/ears/stud_diamond
	name = "Stud earrings - diamond"
	id = "stud_diamond"
	build_path = /obj/item/clothing/ears/earring/stud/diamond
	materials = list("diamond" = 500)

//
//eye slots, does not include high tech items like mesons
//
/datum/design/item/autotailor/accessories/eyes
	category = "Glasses"
	materials = list(DEFAULT_WALL_MATERIAL = 100, "glass" = 500)

/datum/design/item/autotailor/accessories/eyes/prescription
	name = "Prescription glasses"
	id = "prescription"
	build_path = /obj/item/clothing/glasses/regular

/datum/design/item/autotailor/accessories/eyes/prescription_hipster
	name = "Prescription glasses - alternate"
	id = "prescription_hipster"
	build_path = /obj/item/clothing/glasses/regular/hipster
	materials = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 1000)

/datum/design/item/autotailor/accessories/eyes/prescription_sun
	name = "Prescription glasses - sunglasses"
	id = "prescription_sun"
	build_path = /obj/item/clothing/glasses/sunglasses/prescription
	materials = list(DEFAULT_WALL_MATERIAL = 100, "glass" = 1000, "fiberglass" = 7000)

/datum/design/item/autotailor/accessories/eyes/sunglasses
	name = "Sunglasses"
	id = "sunglasses"
	build_path = /obj/item/clothing/glasses/sunglasses
	materials = list(DEFAULT_WALL_MATERIAL = 100, "fiberglass" = 5000)

/datum/design/item/autotailor/accessories/eyes/sunglasses_large
	name = "Sunglasses - large"
	id = "sunglasses_large"
	build_path = /obj/item/clothing/glasses/sunglasses/big
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "fiberglass" = 10000)

/datum/design/item/autotailor/accessories/eyes/gglasses
	name = "Glasses - green"
	id = "gglasses"
	build_path = /obj/item/clothing/glasses/gglasses

/datum/design/item/autotailor/accessories/eyes/three_d_glasses
	name = "Glasses - 3D"
	id = "three_d_glasses"
	build_path = /obj/item/clothing/glasses/threedglasses

/datum/design/item/autotailor/accessories/eyes/monocle
	name = "Monocle"
	id = "monocle"
	build_path = /obj/item/clothing/glasses/monocle
	materials = list(DEFAULT_WALL_MATERIAL = 100, "glass" = 500, "phoron" = 500)

/datum/design/item/autotailor/accessories/eyes/default_veil
	name = "Decorative veil"
	id = "default_veil"
	build_path = /obj/item/clothing/glasses/veil
	materials = list(DEFAULT_WALL_MATERIAL = 100, "glass" = 500, "phoron" = 5000)

//
//gloves
//
/datum/design/item/autotailor/accessories/gloves
	category = "Gloves"
	materials = list("leather" = 2000)

/datum/design/item/autotailor/accessories/gloves/white	//custom colors
	name = "Gloves - white"
	id = "white"
	build_path = /obj/item/clothing/gloves/color

/datum/design/item/autotailor/accessories/gloves/rainbow
	name = "Gloves - rainbow"
	id = "rainbow"
	build_path = /obj/item/clothing/gloves/rainbow

/datum/design/item/autotailor/accessories/gloves/pink
	name = "Gloves - pink"
	id = "pink"
	build_path = /obj/item/clothing/gloves/wizard

/datum/design/item/autotailor/accessories/gloves/emb_blue
	name = "Gloves - embroidered blue"
	id = "emb_blue"
	build_path = /obj/item/clothing/gloves/captain
	materials = list("leather" = 2000, "phoron" = 4000)

/datum/design/item/autotailor/accessories/gloves/black_thick
	name = "Gloves - thick black"
	id = "black_thick"
	build_path = /obj/item/clothing/gloves/thick
	materials = list("leather" = 4000)

/datum/design/item/autotailor/accessories/gloves/brown_thick
	name = "Gloves - thick brown"
	id = "brown_thick"
	build_path = /obj/item/clothing/gloves/duty
	materials = list("leather" = 4000)

/datum/design/item/autotailor/accessories/gloves/leather_thick
	name = "Gloves - thick leather"
	id = "leather_thick"
	build_path = /obj/item/clothing/gloves/thick/botany
	materials = list("leather" = 4000)

/datum/design/item/autotailor/accessories/gloves/latex
	name = "Medical gloves - latex"
	id = "latex"
	build_path = /obj/item/clothing/gloves/latex
	materials = list("plastic" = 2000)

/datum/design/item/autotailor/accessories/gloves/nitrile
	name = "Medical gloves - nitrile"
	id = "nitrile"
	build_path = /obj/item/clothing/gloves/latex/nitrile
	materials = list("plastic" = 10000)

/datum/design/item/autotailor/accessories/gloves/dressgloves_white	//custom colors
	name = "Evening gloves - white"
	id = "dressgloves_white"
	build_path = /obj/item/clothing/gloves/color/evening
	materials = list("leather" = 2000, "phoron" = 10000)

/datum/design/item/autotailor/accessories/gloves/eng_vox
	name = "Insulated gloves - vox"
	id = "work_vox"
	build_path = /obj/item/clothing/gloves/vox
	materials = list("leather" = 2000, "titanium" = 5000)

/datum/design/item/autotailor/accessories/gloves/eng
	name = "Insulated gloves"
	id = "eng"
	build_path = /obj/item/clothing/gloves/insulated
	materials = list("leather" = 2000, "titanium" = 5000)	//not sure if this generates on roid, change if not

/datum/design/item/autotailor/accessories/gloves/forensic
	name = "Forensic gloves"
	id = "forensic"
	build_path = /obj/item/clothing/gloves/forensic
	materials = list("leather" = 2000, "phoron" = 60000)	//these gloves have very unique threads, making them cheap makes it not very unique

/datum/design/item/autotailor/accessories/gloves/boxing_red
	name = "Boxing gloves - red"
	id = "boxing_red"
	build_path = /obj/item/clothing/gloves/boxing

/datum/design/item/autotailor/accessories/gloves/boxing_blue
	name = "Boxing gloves - blue"
	id = "boxing_blue"
	build_path = /obj/item/clothing/gloves/boxing/blue

/datum/design/item/autotailor/accessories/gloves/boxing_green
	name = "Boxing gloves - green"
	id = "boxing_green"
	build_path = /obj/item/clothing/gloves/boxing/green

/datum/design/item/autotailor/accessories/gloves/boxing_yellow
	name = "Boxing gloves - yellow"
	id = "boxing_yellow"
	build_path = /obj/item/clothing/gloves/boxing/yellow

//
//Masks
//
/datum/design/item/autotailor/accessories/masks
	category = "Masks"
	materials = list("plastic" = 2000)

/datum/design/item/autotailor/accessories/masks/breath
	name = "Breath mask"
	id = "breath"
	build_path = /obj/item/clothing/mask/breath

/datum/design/item/autotailor/accessories/masks/breath_m
	name = "Breath mask - medical"
	id = "breath_m"
	build_path = /obj/item/clothing/mask/breath/medical

/datum/design/item/autotailor/accessories/masks/breath_tact
	name = "Breath mask - tactical"
	id = "breath_tact"
	build_path = /obj/item/clothing/mask/gas/half
	materials = list("plastic" = 2000, DEFAULT_WALL_MATERIAL = 2000)

/datum/design/item/autotailor/accessories/masks/breath_vox
	name = "Breath mask - vox"
	id = "breath_vox"
	build_path = /obj/item/clothing/mask/gas/vox
	materials = list("plastic" = 5000)

/datum/design/item/autotailor/accessories/masks/gas_generic
	name = "Gas mask"
	id = "gas_generic"
	build_path = /obj/item/clothing/mask/gas
	materials = list("plastic" = 5000)

/datum/design/item/autotailor/accessories/masks/gas_tactical
	name = "Gas mask - tactical"
	id = "gas_tactical"
	build_path = /obj/item/clothing/mask/gas/syndicate
	materials = list("plastic" = 5000)

/datum/design/item/autotailor/accessories/masks/gas_tact_vox
	name = "Gas mask - tactical vox"
	id = "gas_tact_vox"
	build_path = /obj/item/clothing/mask/gas/swat/vox
	materials = list("plastic" = 5000)

/datum/design/item/autotailor/accessories/masks/balac_black
	name = "Balaclava - black"
	id = "balac_black"
	build_path = /obj/item/clothing/mask/balaclava
	materials = list("cloth" = 2000)

/datum/design/item/autotailor/accessories/masks/balac_green
	name = "Balaclava - green"
	id = "balac_green"
	build_path = /obj/item/clothing/mask/balaclava/tactical
	materials = list("cloth" = 2000)

/datum/design/item/autotailor/accessories/masks/balac_blue
	name = "Balaclava - blue"
	id = "balac_blue"
	build_path = /obj/item/clothing/mask/balaclava/blue
	materials = list("cloth" = 2000)

/datum/design/item/autotailor/accessories/masks/sterile_mask
	name = "Sterile face mask"
	id = "sterile mask"
	build_path = /obj/item/clothing/mask/surgical
	materials = list("plastic" = 2000)

/datum/design/item/autotailor/accessories/masks/pipe_fancy	//temporary until a more fitting fabricator is made
	name = "Smoking pipe - fancy"
	id = "pipe_fancy"
	build_path = /obj/item/clothing/mask/smokable/pipe
	materials = list("wood" = 10000)

/datum/design/item/autotailor/accessories/masks/pipe_cob	//temporary until a more fitting fabricator is made
	name = "Smoking pipe - corncob"
	id = "pipe_cob"
	build_path = /obj/item/clothing/mask/smokable/pipe/cobpipe
	materials = list("wood" = 1000)

//
//softhats
//
/datum/design/item/autotailor/accessories/hats
	category = "Soft hats"
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/cap_white	//custom colors
	name = "Cap - white"
	id = "cap_white"
	build_path = /obj/item/clothing/head/soft/mime

/datum/design/item/autotailor/accessories/hats/cap_black
	name = "Cap - black"
	id = "cap_black"
	build_path = /obj/item/clothing/head/soft/black

/datum/design/item/autotailor/accessories/hats/cap_grey
	name = "Cap - grey"
	id = "cap_grey"
	build_path = /obj/item/clothing/head/soft/grey

/datum/design/item/autotailor/accessories/hats/cap_yellow
	name = "Cap - yellow"
	id = "cap_yellow"
	build_path = /obj/item/clothing/head/soft/yellow

/datum/design/item/autotailor/accessories/hats/cap_purple
	name = "Cap - purple"
	id = "cap_purple"
	build_path = /obj/item/clothing/head/soft/purple

/datum/design/item/autotailor/accessories/hats/cap_green
	name = "Cap - green"
	id = "cap_green"
	build_path = /obj/item/clothing/head/soft/green

/datum/design/item/autotailor/accessories/hats/cap_orange
	name = "Cap - orange"
	id = "cap_orange"
	build_path = /obj/item/clothing/head/soft/orange

/datum/design/item/autotailor/accessories/hats/cap_blue
	name = "Cap - blue"
	id = "cap_blue"
	build_path = /obj/item/clothing/head/soft/blue

/datum/design/item/autotailor/accessories/hats/cap_red
	name = "Cap - red"
	id = "cap_red"
	build_path = /obj/item/clothing/head/soft/red

/datum/design/item/autotailor/accessories/hats/cap_rainbow
	name = "Cap - rainbow"
	id = "cap_rainbow"
	build_path = /obj/item/clothing/head/soft/rainbow

//the hats below do not block your eyes on mob sprite, might be removed if too similar to above
/datum/design/item/autotailor/accessories/hats/cap_s_red
	name = "Short visor cap - red"
	id = "cap_s_red"
	build_path = /obj/item/clothing/head/soft/sec

/datum/design/item/autotailor/accessories/hats/cap_s_darkred
	name = "Short visor cap - dark red"
	id = "cap_s_darkred"
	build_path = /obj/item/clothing/head/soft/mbill

/datum/design/item/autotailor/accessories/hats/cap_s_camo
	name = "Short visor cap - camo"
	id = "cap_s_camo"
	build_path = /obj/item/clothing/head/soft/fed

/datum/design/item/autotailor/accessories/hats/cap_s_bl_logo	//nt item
	name = "Short visor cap - black logo"
	id = "cap_s_bl_logo"
	build_path = /obj/item/clothing/head/soft/sec/corp

/datum/design/item/autotailor/accessories/hats/cap_s_wh_logo	//nt item
	name = "Short visor cap - white logo"
	id = "cap_s_wh_logo"
	build_path = /obj/item/clothing/head/soft/sec/corp/guard

/datum/design/item/autotailor/accessories/hats/beret_white	//custom colors
	name = "Beret - white"
	id = "beret_white"
	build_path = /obj/item/clothing/head/beret/plaincolor

/datum/design/item/autotailor/accessories/hats/beret_red
	name = "Beret - red"
	id = "beret_red"
	build_path = /obj/item/clothing/head/beret

/datum/design/item/autotailor/accessories/hats/beret_purple
	name = "Beret - purple"
	id = "beret_purple"
	build_path = /obj/item/clothing/head/beret/purple

/datum/design/item/autotailor/accessories/hats/beret_wh_bluelogo
	name = "Beret - white w. blue logo"
	id = "beret_wh_bluelogo"
	build_path = /obj/item/clothing/head/beret/centcom/captain

/datum/design/item/autotailor/accessories/hats/beret_wh_redlogo
	name = "Beret - white w. red logo"
	id = "beret_wh_redlogo"
	build_path = /obj/item/clothing/head/beret/guard

/datum/design/item/autotailor/accessories/hats/beret_bl_redlogo
	name = "Beret - black w. red logo"
	id = "beret_bl_redlogo"
	build_path = /obj/item/clothing/head/beret/sec/corporate/officer

/datum/design/item/autotailor/accessories/hats/beret_bl_whlogo
	name = "Beret - black w. white logo"
	id = "beret_bl_whlogo"
	build_path = /obj/item/clothing/head/beret/sec/corporate/warden

/datum/design/item/autotailor/accessories/hats/beret_bl_goldlogo
	name = "Beret - black w. gold logo"
	id = "beret_bl_goldlogo"
	build_path = /obj/item/clothing/head/beret/sec/corporate/hos

/datum/design/item/autotailor/accessories/hats/beret_red_whlogo
	name = "Beret - red w. white logo"
	id = "beret_red_whlogo"
	build_path = /obj/item/clothing/head/beret/sec

/datum/design/item/autotailor/accessories/hats/beret_navy_whlogo
	name = "Beret - navy w. white logo"
	id = "beret_navy_whlogo"
	build_path = /obj/item/clothing/head/beret/centcom/officer

/datum/design/item/autotailor/accessories/hats/beret_navy_redlogo
	name = "Beret - navy w. red logo"
	id = "beret_navy_redlogo"
	build_path = /obj/item/clothing/head/beret/sec/navy/officer

/datum/design/item/autotailor/accessories/hats/beret_navy_bluelogo
	name = "Beret - navy w. blue logo"
	id = "beret_navy_bluelogo"
	build_path = /obj/item/clothing/head/beret/sec/navy/warden

/datum/design/item/autotailor/accessories/hats/beret_navy_goldlogo
	name = "Beret - navy w. gold logo"
	id = "beret_navy_goldlogo"
	build_path = /obj/item/clothing/head/beret/sec/navy/hos

/datum/design/item/autotailor/accessories/hats/flat_brown
	name = "Flat cap - brown"
	id = "flat_brown"
	build_path = /obj/item/clothing/head/flatcap
	materials = list("leather" = 500)

/datum/design/item/autotailor/accessories/hats/beret_grey
	name = "Flat cap - grey"
	id = "flat_grey"
	build_path = /obj/item/clothing/head/wizard/cap/fake
	materials = list("leather" = 500)

/datum/design/item/autotailor/accessories/hats/trilby_blue
	name = "Trilby - blue feathered"
	id = "trilby_blue"
	build_path = /obj/item/clothing/head/feathertrilby
	materials = list("leather" = 500)

/datum/design/item/autotailor/accessories/hats/fedora_black
	name = "Fedora - black"
	id = "fedora - black"
	build_path = /obj/item/clothing/head/fedora
	materials = list("leather" = 500)

/datum/design/item/autotailor/accessories/hats/fedora_grey
	name = "Fedora - grey"
	id = "fedora_grey"
	build_path = /obj/item/clothing/head/det/grey/noarmor
	materials = list("leather" = 500)

/datum/design/item/autotailor/accessories/hats/fedora_brown
	name = "Fedora - brown"
	id = "fedora_brown"
	build_path = /obj/item/clothing/head/det/noarmor
	materials = list("leather" = 500)

/datum/design/item/autotailor/accessories/hats/bowler_black
	name = "Bowler hat - black"
	id = "bowler_black"
	build_path = /obj/item/clothing/head/bowlerhat
	materials = list("leather" = 500)

/datum/design/item/autotailor/accessories/hats/tophat_black
	name = "Top-hat - black"
	id = "tophat_black"
	build_path = /obj/item/clothing/head/that
	materials = list("leather" = 500)

/datum/design/item/autotailor/accessories/hats/beaver_navy
	name = "Top-hat - beaver navy"
	id = "beaver_navy"
	build_path = /obj/item/clothing/head/beaverhat
	materials = list("leather" = 500)

/datum/design/item/autotailor/accessories/hats/boat_vanilla
	name = "Boater hat - vanilla"
	id = "boat_vanilla"
	build_path = /obj/item/clothing/head/boaterhat
	materials = list("leather" = 500)

/datum/design/item/autotailor/accessories/hats/gold_hat
	name = "Fancy golden hat"
	id = "gold_hat"
	build_path = /obj/item/clothing/head/collectable/petehat
	materials = list("leather" = 500, "gold" = 5000)

/datum/design/item/autotailor/accessories/hats/cowboy_brown
	name = "Cowboy hat - brown"
	id = "Cowboy_brown"
	build_path = /obj/item/clothing/head/cowboy_hat
	materials = list("leather" = 500)

/datum/design/item/autotailor/accessories/hats/kippa_large_black
	name = "Kippa - black"
	id = "kippa_large_black"
	build_path = /obj/item/clothing/head/bowler

/datum/design/item/autotailor/accessories/hats/kippa_small_white
	name = "Kippa - small white"
	id = "kippa_small_white"
	build_path = /obj/item/clothing/head/kippa

/datum/design/item/autotailor/accessories/hats/fez_red
	name = "Fez - red"
	id = "fez_red"
	build_path = /obj/item/clothing/head/fez

/datum/design/item/autotailor/accessories/hats/bandana_orange
	name = "Bandana - orange"
	id = "bandana_orange"
	build_path = /obj/item/clothing/head/orangebandana

/datum/design/item/autotailor/accessories/hats/bandana_green
	name = "Bandana - green"
	id = "bandana_green"
	build_path = /obj/item/clothing/head/greenbandana

/datum/design/item/autotailor/accessories/hats/headscarf_white	//custom colors?, also xeno sprite gives it some clipping on humans
	name = "Headscarf - white"
	id = "headscarf_white"
	build_path = /obj/item/clothing/head/xeno/scarf

/datum/design/item/autotailor/accessories/hats/taqiyah_white	//custom colors
	name = "Taqiyah - white"
	id = "taqiya_white"
	build_path = /obj/item/clothing/head/taqiyah

/datum/design/item/autotailor/accessories/hats/hijab_white	//custom colors
	name = "Hijab - white"
	id = "hijab_white"
	build_path = /obj/item/clothing/head/hijab

/datum/design/item/autotailor/accessories/hats/turban_white	//custom colors
	name = "Turban - white"
	id = "turban_white"
	build_path = /obj/item/clothing/head/turban

/datum/design/item/autotailor/accessories/hats/hairbow_white	//custom colors
	name = "Hairbow - white"
	id = "hairbow_white"
	build_path = /obj/item/clothing/head/hairflower/bow

/datum/design/item/autotailor/accessories/hats/bearpelt
	name = "Fuzzy bear pelt"
	id = "bearpelt"
	build_path = /obj/item/clothing/head/bearpelt
	materials = list("cloth" = 5000, "leather" = 5000)

/datum/design/item/autotailor/accessories/hats/hairpin_blue
	name = "Hair flower pin - blue"
	id = "hairpin_blue"
	build_path = /obj/item/clothing/head/hairflower/blue

/datum/design/item/autotailor/accessories/hats/hairpin_pink
	name = "Hair flower pin - pink"
	id = "hairpin_pink"
	build_path = /obj/item/clothing/head/hairflower/pink

/datum/design/item/autotailor/accessories/hats/hairpin_yellow
	name = "Hair flower pin - yellow"
	id = "hairpin_yellow"
	build_path = /obj/item/clothing/head/hairflower/yellow

/datum/design/item/autotailor/accessories/hats/hairpin_red
	name = "Hair flower pin - red"
	id = "hairpin_red"
	build_path = /obj/item/clothing/head/hairflower