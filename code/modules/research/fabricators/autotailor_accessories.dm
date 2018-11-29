/obj/machinery/fabricator/autotailor/accessories
	name = "auto-tailor (accessories)"
	desc = "An advanced machine capable of printing many types of clothing, this one is loaded with accessory type designs."
	circuit = /obj/item/weapon/circuitboard/fabricator/autotailor/accessories
	build_type = AUTOTAILOR_ACCESSORIES
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

/datum/design/item/autotailor/accessories
	build_type = AUTOTAILOR_ACCESSORIES
	category = "Casual wear"
	time = 1	//40

//////////////////////casual shirts///////////////////////
/datum/design/item/autotailor/accessories/casual
	category = "Casual wear"
	req_tech = list(TECH_MATERIAL = 1)
	time = 1	//40

/datum/design/item/autotailor/accessories/casual/access_flannel_white	//custom colors, appearntly
	name = "Accessory - white flannel"
	id = "access_flannel_white"
	build_path = /obj/item/clothing/accessory/toggleable/flannel
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/casual/access_flannel_red
	name = "Accessory - red flannel"
	id = "access_flannel_red"
	build_path = /obj/item/clothing/accessory/toggleable/flannel/red
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/casual/access_flower_blue
	name = "Accessory - blue flower shirt"
	id = "access_flower_blue"
	build_path = /obj/item/clothing/accessory/toggleable/hawaii
	materials = list("cloth" = 500)
//remove the random shirt
/datum/design/item/autotailor/accessories/casual/access_flower_red
	name = "Accessory - red flower shirt"
	id = "access_flower_red"
	build_path = /obj/item/clothing/accessory/toggleable/hawaii/red
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/casual/access_tneck
	name = "Accessory - grey turtleneck"
	id = "access_tneck"
	build_path = /obj/item/clothing/accessory/sweater
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/casual/access_dashiki_bla
	name = "Accessory - black dashiki"
	id = "access_dashiki_bla"
	build_path = /obj/item/clothing/accessory/dashiki
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/casual/access_dashiki_blue
	name = "Accessory - blue dashiki"
	id = "access_dashiki_blue"
	build_path = /obj/item/clothing/accessory/dashiki/blue
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/casual/access_dashiki_red
	name = "Accessory - red dashiki"
	id = "access_dashiki_red"
	build_path = /obj/item/clothing/accessory/dashiki/red
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/casual/access_qipao	//custom colors?
	name = "Accessory - white qipao"
	id = "access_qipao"
	build_path = /obj/item/clothing/accessory/qipao
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/casual/access_thawb_white	//custom colors
	name = "Accessory - white thawb"
	id = "access_thawb_white"
	build_path = /obj/item/clothing/accessory/thawb
	materials = list("cloth" = 500)

//////////////////////fancy suit jackets///////////////////////
/datum/design/item/autotailor/accessories/fancy
	category = "Fancy suits"
	req_tech = list(TECH_MATERIAL = 1)
	time = 1	//40

/datum/design/item/autotailor/accessories/fancy/access_tangzuang	//custom colors
	name = "Accessory - tangzhuang jacket"
	id = "access_tangzhuang"
	build_path = /obj/item/clothing/accessory/tangzhuang
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/fancy/access_zhongshan	//custom colors
	name = "Accessory - Zhonshan jacket"
	id = "access_zhongshan"
	build_path = /obj/item/clothing/accessory/toggleable/zhongshan
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/fancy/access_sherwani
	name = "Accessory - sherwani"
	id = "access_sherwani"
	build_path = /obj/item/clothing/accessory/sherwani
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/fancy/access_bl_waistcoat
	name = "Accessory - waistcoat black"
	id = "access_bl_waistcoat"
	build_path = /obj/item/clothing/accessory/wcoat
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/fancy/access_bl_vest
	name = "Accessory - vest black"
	id = "access_bl_vest"
	build_path = /obj/item/clothing/accessory/toggleable/vest
	materials = list("cloth" = 500)

//////////////////////non-shirt accessories///////////////////////
/datum/design/item/autotailor/accessories/attach
	category = "Clothing attachments"
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/autotailor/accessories/attach/cane
	name = "Walking cane"
	id = "cane"
	build_path = /obj/item/weapon/cane
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/tie_white	//custom colors
	name = "Tie - white"
	id = "tie_white"
	build_path = /obj/item/clothing/accessory/black	//this tie is actually white lol
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/tie_black
	name = "Tie - black"
	id = "tie_black"
	build_path = /obj/item/clothing/accessory/black/expensive
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/tie_red
	name = "Tie - red"
	id = "tie_red"
	build_path = /obj/item/clothing/accessory/red
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/tie_blue
	name = "Tie - blue"
	id = "tie_blue"
	build_path = /obj/item/clothing/accessory/blue
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/tie_navy
	name = "Tie - navy"
	id = "tie_navy"
	build_path = /obj/item/clothing/accessory/navy
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/stie_white	//custom colors
	name = "Tie - striped white"
	id = "stie_white"
	build_path = /obj/item/clothing/accessory/long
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/stie_brown
	name = "Tie - striped brown"
	id = "stie_brown"
	build_path = /obj/item/clothing/accessory/brown
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/stie_red
	name = "Tie - striped red"
	id = "stie_red"
	build_path = /obj/item/clothing/accessory/red_long
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/stie_yellow
	name = "Tie - striped yellow"
	id = "stie_yellow"
	build_path = /obj/item/clothing/accessory/yellow
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/cliptie_red_black
	name = "Tie - red & black w. clip"
	id = "cliptie_red_black"
	build_path = /obj/item/clothing/accessory/nt
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/cliptie_blue
	name = "Tie - blue w. clip"
	id = "cliptie_blue"
	build_path = /obj/item/clothing/accessory/blue_clip
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/fattie_yellow
	name = "Tie - fat yellow"
	id = "fattie_yellow"
	build_path = /obj/item/clothing/accessory/horrible
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/bowtie_white	//custom colors
	name = "Bowtie - white"
	id = "bowtie_white"
	build_path = /obj/item/clothing/accessory/bowtie/color
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/bowtie_yellow_purp
	name = "Bowtie - yellow & purple"
	id = "bowtie_yellow_purp"
	build_path = /obj/item/clothing/accessory/bowtie/ugly
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/armband_white	//custom colors, needs rename
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

/datum/design/item/autotailor/accessories/attach/armband_sec	//rename
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
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/necklace_white	//custom colors
	name = "Necklace - white"
	id = "necklace_white"
	build_path = /obj/item/clothing/accessory/necklace
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/lockette_silver	//techincally custom colors, but no mob sprite to show
	name = "Lockette - silver"
	id = "lockette_silver"
	build_path = /obj/item/clothing/accessory/locket
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/kneepads
	name = "Kneepads"
	id = "kneepads"
	build_path = /obj/item/clothing/accessory/kneepads
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/medal_iron
	name = "Iron medal"
	id = "medal_iron"
	build_path = /obj/item/clothing/accessory/medal/iron
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/medal_bronze
	name = "Bronze medal"
	id = "medal_bronze"
	build_path = /obj/item/clothing/accessory/medal/bronze
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/medal_silver
	name = "Silver medal"
	id = "medal_silver"
	build_path = /obj/item/clothing/accessory/medal/silver
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/attach/medal_gold
	name = "Gold medal"
	id = "medal_gold"
	build_path = /obj/item/clothing/accessory/medal/gold
	materials = list("cloth" = 500)
//remove all nt variants^

//////////////////////Shoes///////////////////////
/datum/design/item/autotailor/accessories/shoes
	category = "Shoes"
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/autotailor/accessories/shoes/sneaker_white	//custom colors?
	name = "Sneakers - white"
	id = "sneaker_white"
	build_path = /obj/item/clothing/shoes/white
	materials = list("cloth" = 500)
//dupe^:/obj/item/clothing/shoes/mime
/datum/design/item/autotailor/accessories/shoes/sneaker_black
	name = "Sneakers - black"
	id = "sneaker_black"
	build_path = /obj/item/clothing/shoes/black
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/sneaker_brown
	name = "Sneakers - brown"
	id = "sneaker_brown"
	build_path = /obj/item/clothing/shoes/brown
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/sneaker_red
	name = "Sneakers - red"
	id = "sneaker_red"
	build_path = /obj/item/clothing/shoes/red
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/sneaker_purple
	name = "Sneakers - purple"
	id = "sneaker_purple"
	build_path = /obj/item/clothing/shoes/purple
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/sneaker_lgreen
	name = "Sneakers - lime green"
	id = "sneaker_lgreen"
	build_path = /obj/item/clothing/shoes/green
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/sneaker_sblue
	name = "Sneakers - sky blue"
	id = "sneaker_sblue"
	build_path = /obj/item/clothing/shoes/blue
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/sneaker_yellow
	name = "Sneakers - yellow"
	id = "sneaker_yellow"
	build_path = /obj/item/clothing/shoes/yellow
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/sneaker_orange
	name = "Sneakers - orange"
	id = "sneaker_orange"
	build_path = /obj/item/clothing/shoes/orange
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/sneaker_rainbow
	name = "Sneakers - rainbow"
	id = "sneaker_rainbow"
	build_path = /obj/item/clothing/shoes/rainbow
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/sneaker_leather
	name = "Sneakers - leather"
	id = "sneaker_leather"
	build_path = /obj/item/clothing/shoes/leather
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/sneaker_athwhite
	name = "Sneakers - Athletic white"
	id = "sneaker_athwhite"
	build_path = /obj/item/clothing/shoes/athletic
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/flats_white	//custom colors
	name = "Flats - white"
	id = "flats_white"
	build_path = /obj/item/clothing/shoes/flats
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/sneaker_blackalt	//rename
	name = "Sneakers - cyborg costume"
	id = "sneaker_blackalt"
	build_path = /obj/item/clothing/shoes/cyborg
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/hitop_white	//custom color maybe
	name = "Hightops - white"
	id = "hitop_white"
	build_path = /obj/item/clothing/shoes/hightops
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/hitop_black
	name = "Hightops - black"
	id = "hitop_black"
	build_path = /obj/item/clothing/shoes/hightops/black
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/hitop_brown
	name = "Hightops - brown"
	id = "hitop_brown"
	build_path = /obj/item/clothing/shoes/hightops/brown
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/hitop_red
	name = "Hightops - red"
	id = "hitop_red"
	build_path = /obj/item/clothing/shoes/hightops/red
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/hitop_purple
	name = "Hightops - purple"
	id = "hitop_purple"
	build_path = /obj/item/clothing/shoes/hightops/purple
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/hitop_lgreen
	name = "Hightops - lime green"
	id = "hitop_lgreen"
	build_path = /obj/item/clothing/shoes/hightops/green
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/hitop_sblue
	name = "Hightops - sky blue"
	id = "hitop_sblue"
	build_path = /obj/item/clothing/shoes/hightops/blue
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/hitop_yellow
	name = "Hightops - yellow"
	id = "hitop_yellow"
	build_path = /obj/item/clothing/shoes/hightops/yellow
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/hitop_orange
	name = "Hightops - orange"
	id = "hitop_orange"
	build_path = /obj/item/clothing/shoes/hightops/orange
	materials = list("cloth" = 500)

//these are supposed to be xeno shoes, maybe remove
/datum/design/item/autotailor/accessories/shoes/caligae_bare
	name = "Caligae - bare"
	id = "caligae_bare"
	build_path = /obj/item/clothing/shoes/sandal/xeno/caligae
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/caligae_white
	name = "Caligae - white"
	id = "caligae_white"
	build_path = /obj/item/clothing/shoes/sandal/xeno/caligae/white
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/caligae_grey
	name = "Caligae - grey"
	id = "caligae_grey"
	build_path = /obj/item/clothing/shoes/sandal/xeno/caligae/grey
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/caligae_black
	name = "Caligae - black"
	id = "Caligae - black"
	build_path = /obj/item/clothing/shoes/sandal/xeno/caligae/black
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/sandal_brown
	name = "Sandals"
	id = "sandal_brown"
	build_path = /obj/item/clothing/shoes/sandal
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/sandal_xeno	//these are exactly the same sprite as above on humans, remove if its the case with xenos too
	name = "Sandals - xenos"
	id = "sandal_xeno"
	build_path = /obj/item/clothing/shoes/sandal/xeno
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/dress_white	//custom colors?
	name = "Dress shoes - white"
	id = "dress_white"
	build_path = /obj/item/clothing/shoes/dress/white
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/dress_black
	name = "Dress shoes - black"
	id = "dress_black"
	build_path = /obj/item/clothing/shoes/dress
	materials = list("cloth" = 500)
//dupe^: /obj/item/clothing/shoes/laceup\

/datum/design/item/autotailor/accessories/shoes/jackb_black
	name = "Jackboots - black"
	id = "jackb_black"
	build_path = /obj/item/clothing/shoes/jackboots
	materials = list("cloth" = 500)
//dupe^: /obj/item/clothing/shoes/dutyboots , /obj/item/clothing/shoes/swat

/datum/design/item/autotailor/accessories/shoes/jackb_black_notoe
	name = "Jackboots - black toeless"
	id = "jackb_black_notoe"
	build_path = /obj/item/clothing/shoes/jackboots/unathi
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/jackb_grey	//item sprite looks arcane-y, but mob sprite looks normal for everyday use
	name = "Jackboots - grey"
	id = "jackb_grey"
	build_path = /obj/item/clothing/shoes/cult
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/jackb_tan
	name = "Jackboots - tan"
	id = "jackb_tan"
	build_path = /obj/item/clothing/shoes/desertboots
	materials = list("cloth" = 500)
//dupe^: /obj/item/clothing/shoes/tactical
/datum/design/item/autotailor/accessories/shoes/jackb_brown
	name = "jackboots - brown"
	id = "jackb_brown"
	build_path = /obj/item/clothing/shoes/jungleboots
	materials = list("cloth" = 500)
//dupe^: /obj/item/clothing/shoes/combat
/datum/design/item/autotailor/accessories/shoes/workboot
	name = "Industrial workboots"
	id = "workboot"
	build_path = /obj/item/clothing/shoes/workboots
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/workboot_notoe	//hopefully unique sprite on unanthe, same sprite as above on human, also outdated object sprite
	name = "Industrial workboots - toeless"
	id = "workboot_notoe"
	build_path = /obj/item/clothing/shoes/workboots/toeless
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/galoshes_yellow
	name = "Galoshes"
	id = "galoshes_yellow"
	build_path = /obj/item/clothing/shoes/galoshes
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/fins	//these have a slowdown, make sure they don't have noslip
	name = "Swimming fins"
	id = "fins"
	build_path = /obj/item/clothing/shoes/swimmingfins
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/clown_shoe
	name = "Clown shoes"
	id = "clown_shoe"
	build_path = /obj/item/clothing/shoes/clown_shoes
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/slippers_bunny
	name = "Bunny slippers"
	id = "slippers_bunny"
	build_path = /obj/item/clothing/shoes/slippers
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/shoes/slippers_bunny_worn	//if we ever add clothing states, merge this with above to be the worn out/dirty version
	name = "Bunny slippers - worn"
	id = "slippers_bunny_worn"
	build_path = /obj/item/clothing/shoes/slippers_worn
	materials = list("cloth" = 500)

//////////////////////Ears,anemities fab will hopefully make this list more precisely named///////////////////////
/datum/design/item/autotailor/accessories/ears
	category = "ears"
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/autotailor/accessories/ears/headphones
	name = "headphones"
	id = "headphones"
	build_path = /obj/item/clothing/ears/earmuffs/headphones
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/ears/earmuffs
	name = "earmuffs"
	id = "earmuffs"
	build_path = /obj/item/clothing/ears/earmuffs
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/ears/dangle_white	//canidate for custom colors
	name = "Dangle earrings - white"
	id = "Dangle earrings - white"
	build_path = /obj/item/clothing/ears/earring/dangle
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/ears/dangle_wood
	name = "Dangle earrings - wood"
	id = "dangle_wood"
	build_path = /obj/item/clothing/ears/earring/dangle/wood
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/ears/dangle_glass
	name = "Dangle earrings - glass"
	id = "dangle_glass"
	build_path = /obj/item/clothing/ears/earring/dangle/glass
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/ears/dangle_iron
	name = "Dangle earrings - iron"
	id = "dangle_iron"
	build_path = /obj/item/clothing/ears/earring/dangle/iron
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/ears/dangle_steel
	name = "Dangle earrings - steel"
	id = "dangle_steel"
	build_path = /obj/item/clothing/ears/earring/dangle/steel
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/ears/dangle_silver
	name = "Dangle earrings - silver"
	id = "dangle_silver"
	build_path = /obj/item/clothing/ears/earring/dangle/silver
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/ears/dangle_platinum
	name = "Dangle earrings - platinum"
	id = "dangle_platinum"
	build_path = /obj/item/clothing/ears/earring/dangle/platinum
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/ears/dangle_gold
	name = "Dangle earrings - gold"
	id = "dangle_gold"
	build_path = /obj/item/clothing/ears/earring/dangle/gold
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/ears/dangle_diamond
	name = "Dangle earrings - diamond"
	id = "dangle_diamond"
	build_path = /obj/item/clothing/ears/earring/dangle/diamond
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/ears/stud_pearl	//canidate for custom colors
	name = "Stud earrings - pearl"
	id = "stud_pearl"
	build_path = /obj/item/clothing/ears/earring/stud
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/ears/stud_wood
	name = "Stud earrings - wood"
	id = "dangle_wood"
	build_path = /obj/item/clothing/ears/earring/stud/wood
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/ears/stud_glass
	name = "Stud earrings - glass"
	id = "dangle_glass"
	build_path = /obj/item/clothing/ears/earring/stud/glass
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/ears/stud_iron
	name = "Stud earrings - iron"
	id = "dangle_iron"
	build_path = /obj/item/clothing/ears/earring/stud/iron
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/ears/stud_steel
	name = "Stud earrings - steel"
	id = "dangle_steel"
	build_path = /obj/item/clothing/ears/earring/stud/steel
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/ears/stud_silver
	name = "Stud earrings - silver"
	id = "dangle_silver"
	build_path = /obj/item/clothing/ears/earring/stud/silver
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/ears/stud_platinum
	name = "Stud earrings - platinum"
	id = "dangle_platinum"
	build_path = /obj/item/clothing/ears/earring/stud/platinum
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/ears/stud_gold
	name = "Stud earrings - gold"
	id = "dangle_gold"
	build_path = /obj/item/clothing/ears/earring/stud/gold
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/ears/stud_diamond
	name = "Stud earrings - diamond"
	id = "dangle_diamond"
	build_path = /obj/item/clothing/ears/earring/stud/diamond
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/ears/skrell	//there are ALOT of skrell ear clothing, but it doesn't seem to fit our current lore, im putting this here until i get clarification if they should or shoudn't exist
	name = "Skrell headtail cloth"
	id = "skrell"
	build_path = /obj/item/clothing/ears/skrell/cloth_male
	materials = list("cloth" = 500)

//////////////////////eye slots, does not include high tech items like mesons///////////////////////
/datum/design/item/autotailor/accessories/eyes
	category = "Glasses"
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/autotailor/accessories/eyes/prescription
	name = "Prescription glasses"
	id = "prescription"
	build_path = /obj/item/clothing/glasses/regular
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/eyes/prescription_hipster
	name = "Prescription glasses - alternate"
	id = "prescription_hipster"
	build_path = /obj/item/clothing/glasses/regular/hipster
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/eyes/prescription_sun
	name = "Prescription glasses - sunglasses"
	id = "prescription_sun"
	build_path = /obj/item/clothing/glasses/sunglasses/prescription
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/eyes/sunglasses
	name = "Sunglasses"
	id = "sunglasses"
	build_path = /obj/item/clothing/glasses/sunglasses
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/eyes/sunglasses_large
	name = "Sunglasses - large"
	id = "sunglasses_large"
	build_path = /obj/item/clothing/glasses/sunglasses/big
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/eyes/gglasses
	name = "Glasses - green"
	id = "gglasses"
	build_path = /obj/item/clothing/glasses/gglasses
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/eyes/three_d_glasses
	name = "Glasses - 3D"
	id = "three_d_glasses"
	build_path = /obj/item/clothing/glasses/threedglasses
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/eyes/monocle
	name = "Monocle"
	id = "monocle"
	build_path = /obj/item/clothing/glasses/monocle
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/eyes/default_veil
	name = "Decorative veil"
	id = "default_veil"
	build_path = /obj/item/clothing/glasses/veil
	materials = list("cloth" = 500)

//////////////////////gloves///////////////////////
/datum/design/item/autotailor/accessories/gloves
	category = "Gloves"
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/autotailor/accessories/gloves/white	//custom colors
	name = "Gloves - white"
	id = "white"
	build_path = /obj/item/clothing/gloves/color
	materials = list("cloth" = 500)
//dupe^: /obj/item/clothing/gloves/white

/datum/design/item/autotailor/accessories/gloves/rainbow
	name = "Gloves - rainbow"
	id = "rainbow"
	build_path = /obj/item/clothing/gloves/rainbow
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/gloves/pink
	name = "Gloves - pink"
	id = "pink"
	build_path = /obj/item/clothing/gloves/wizard
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/gloves/emb_blue
	name = "Gloves - embroidered blue"
	id = "emb_blue"
	build_path = /obj/item/clothing/gloves/captain
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/gloves/black_thick
	name = "Gloves - thick black"
	id = "black_thick"
	build_path = /obj/item/clothing/gloves/thick
	materials = list("cloth" = 500)
//dupe?: /obj/item/clothing/gloves/thick/swat , /obj/item/clothing/gloves/cyborg

/datum/design/item/autotailor/accessories/gloves/brown_thick
	name = "Gloves - thick brown"
	id = "brown_thick"
	build_path = /obj/item/clothing/gloves/duty
	materials = list("cloth" = 500)
//dupe?: /obj/item/clothing/gloves/thick/combat ,/obj/item/clothing/gloves/tactical

/datum/design/item/autotailor/accessories/gloves/leather_thick
	name = "Gloves - thick leather"
	id = "leather_thick"
	build_path = /obj/item/clothing/gloves/thick/botany
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/gloves/latex
	name = "Medical gloves - latex"
	id = "latex"
	build_path = /obj/item/clothing/gloves/latex
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/gloves/nitrile
	name = "Medical gloves - nitrile"
	id = "nitrile"
	build_path = /obj/item/clothing/gloves/latex/nitrile
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/gloves/dress_white	//custom colors
	name = "Evening gloves - white"
	id = "dress_white"
	build_path = /obj/item/clothing/gloves/color/evening
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/gloves/eng_vox
	name = "Insulated gloves - vox"
	id = "work_vox"
	build_path = /obj/item/clothing/gloves/vox
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/gloves/eng
	name = "Insulated gloves"
	id = "eng"
	build_path = /obj/item/clothing/gloves/insulated
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/gloves/eng_cheap	//lets remove the rng and just make them weaker insulated
	name = "Insulated gloves - cheap"
	id = "eng_cheap"
	build_path = /obj/item/clothing/gloves/insulated/cheap
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/gloves/forensic //prohibitivly expensive
	name = "Forensic gloves"
	id = "forensic"
	build_path = /obj/item/clothing/gloves/forensic
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/gloves/boxing_red
	name = "Boxing gloves - red"
	id = "boxing_red"
	build_path = /obj/item/clothing/gloves/boxing
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/gloves/boxing_blue
	name = "Boxing gloves - blue"
	id = "boxing_blue"
	build_path = /obj/item/clothing/gloves/boxing/blue
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/gloves/boxing_green
	name = "Boxing gloves - green"
	id = "boxing_green"
	build_path = /obj/item/clothing/gloves/boxing/green
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/gloves/boxing_yellow
	name = "Boxing gloves - yellow"
	id = "boxing_yellow"
	build_path = /obj/item/clothing/gloves/boxing/yellow
	materials = list("cloth" = 500)

//////////////////////Masks///////////////////////
/datum/design/item/autotailor/accessories/masks
	category = "Masks"
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/autotailor/accessories/masks/breath
	name = "Breath mask"
	id = "breath"
	build_path = /obj/item/clothing/mask/breath
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/masks/breath_m
	name = "Breath mask - medical"
	id = "breath_m"
	build_path = /obj/item/clothing/mask/breath/medical
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/masks/breath_tact
	name = "Breath mask - tactical"
	id = "breath_tact"
	build_path = /obj/item/clothing/mask/gas/half
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/masks/breath_vox
	name = "Breath mask - vox"
	id = "breath_vox"
	build_path = /obj/item/clothing/mask/gas/vox
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/masks/gas_generic
	name = "Gas mask"
	id = "gas_generic"
	build_path = /obj/item/clothing/mask/gas
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/masks/gas_tactical
	name = "Gas mask - tactical"
	id = "gas_tactical"
	build_path = /obj/item/clothing/mask/gas/syndicate
	materials = list("cloth" = 500)
//dupe^: /obj/item/clothing/mask/gas/swat

/datum/design/item/autotailor/accessories/masks/gas_tact_vox
	name = "Gas mask - tactical vox"
	id = "gas_tact_vox"
	build_path = /obj/item/clothing/mask/gas/swat/vox
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/masks/balac_black
	name = "Balaclava - black"
	id = "balac_black"
	build_path = /obj/item/clothing/mask/balaclava
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/masks/sterile_mask
	name = "Sterile face mask"
	id = "sterile mask"
	build_path = /obj/item/clothing/mask/surgical
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/masks/pipe_fancy	//doesn't really belong here, temporary
	name = "Smoking pipe - fancy"
	id = "pipe_fancy"
	build_path = /obj/item/clothing/mask/smokable/pipe
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/masks/pipe_cob	//doesn't really belong here, temporary
	name = "Smoking pipe - corncob"
	id = "pipe_cob"
	build_path = /obj/item/clothing/mask/smokable/pipe/cobpipe
	materials = list("cloth" = 500)

//////////////////////softhats///////////////////////
/datum/design/item/autotailor/accessories/hats
	category = "Soft hats"
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/autotailor/accessories/hats/cap_white	//custom colors
	name = "Cap - white"
	id = "cap_white"
	build_path = /obj/item/clothing/head/soft/mime
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/cap_black
	name = "Cap - black"
	id = "cap_black"
	build_path = /obj/item/clothing/head/soft/black
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/cap_grey
	name = "Cap - grey"
	id = "cap_grey"
	build_path = /obj/item/clothing/head/soft/grey
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/cap_yellow
	name = "Cap - yellow"
	id = "cap_yellow"
	build_path = /obj/item/clothing/head/soft/yellow
	materials = list("cloth" = 500)
//very similar to cargo cap^: /obj/item/clothing/head/soft

/datum/design/item/autotailor/accessories/hats/cap_purple
	name = "Cap - purple"
	id = "cap_purple"
	build_path = /obj/item/clothing/head/soft/purple
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/cap_green
	name = "Cap - green"
	id = "cap_green"
	build_path = /obj/item/clothing/head/soft/green
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/cap_orange
	name = "Cap - orange"
	id = "cap_orange"
	build_path = /obj/item/clothing/head/soft/orange
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/cap_blue
	name = "Cap - blue"
	id = "cap_blue"
	build_path = /obj/item/clothing/head/soft/blue
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/cap_red
	name = "Cap - red"
	id = "cap_red"
	build_path = /obj/item/clothing/head/soft/red
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/cap_rainbow
	name = "Cap - rainbow"
	id = "cap_rainbow"
	build_path = /obj/item/clothing/head/soft/rainbow
	materials = list("cloth" = 500)

//the hats below do not block your eyes on mob sprite, might be removed if too similar to above
/datum/design/item/autotailor/accessories/hats/cap_s_red
	name = "Short visor cap - red"
	id = "cap_s_red"
	build_path = /obj/item/clothing/head/soft/sec
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/cap_s_darkred
	name = "Short visor cap - dark red"
	id = "cap_s_darkred"
	build_path = /obj/item/clothing/head/soft/mbill
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/cap_s_camo
	name = "Short visor cap - camo"
	id = "cap_s_camo"
	build_path = /obj/item/clothing/head/soft/fed
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/cap_s_bl_logo	//rename
	name = "Short visor cap - black logo"
	id = "cap_s_bl_logo"
	build_path = /obj/item/clothing/head/soft/sec/corp
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/cap_s_wh_logo	//rename
	name = "Short visor cap - white logo"
	id = "cap_s_wh_logo"
	build_path = /obj/item/clothing/head/soft/sec/corp/guard
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/beret_white	//custom colors
	name = "Beret - white"
	id = "beret_white"
	build_path = /obj/item/clothing/head/beret/plaincolor
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/beret_red
	name = "Beret - red"
	id = "beret_red"
	build_path = /obj/item/clothing/head/beret
	materials = list("cloth" = 500)
//centcomm beret is dupe,also /obj/item/clothing/head/collectable/beret
/datum/design/item/autotailor/accessories/hats/beret_purple
	name = "Beret - purple"
	id = "beret_purple"
	build_path = /obj/item/clothing/head/beret/purple
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/beret_wh_bluelogo
	name = "Beret - white w. blue logo"
	id = "beret_wh_bluelogo"
	build_path = /obj/item/clothing/head/beret/centcom/captain
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/beret_wh_redlogo
	name = "Beret - white w. red logo"
	id = "beret_wh_redlogo"
	build_path = /obj/item/clothing/head/beret/guard
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/beret_bl_redlogo
	name = "Beret - black w. red logo"
	id = "beret_wh_redlogo"
	build_path = /obj/item/clothing/head/beret/sec/corporate/officer
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/beret_bl_whlogo
	name = "Beret - black w. white logo"
	id = "beret_bl_whlogo"
	build_path = /obj/item/clothing/head/beret/sec/corporate/warden
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/beret_bl_goldlogo
	name = "Beret - black w. gold logo"
	id = "beret_bl_goldlogo"
	build_path = /obj/item/clothing/head/beret/sec/corporate/hos
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/beret_red_whlogo
	name = "Beret - red w. white logo"
	id = "beret_red_whlogo"
	build_path = /obj/item/clothing/head/beret/sec
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/beret_navy_whlogo
	name = "Beret - navy w. white logo"
	id = "beret_navy_whlogo"
	build_path = /obj/item/clothing/head/beret/centcom/officer
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/beret_navy_redlogo
	name = "Beret - navy w. red logo"
	id = "beret_navy_redlogo"
	build_path = /obj/item/clothing/head/beret/sec/navy/officer
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/beret_navy_bluelogo
	name = "Beret - navy w. blue logo"
	id = "beret_navy_bluelogo"
	build_path = /obj/item/clothing/head/beret/sec/navy/warden
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/beret_navy_goldlogo
	name = "Beret - navy w. gold logo"
	id = "beret_navy_goldlogo"
	build_path = /obj/item/clothing/head/beret/sec/navy/hos
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/flat_brown
	name = "Flat cap - brown"
	id = "flat_brown"
	build_path = /obj/item/clothing/head/flatcap
	materials = list("cloth" = 500)
//dupe^: /obj/item/clothing/head/collectable/flatcap
/datum/design/item/autotailor/accessories/hats/beret_grey
	name = "Flat cap - grey"
	id = "flat_grey"
	build_path = /obj/item/clothing/head/wizard/cap
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/trilby_blue
	name = "Trilby - blue feathered"
	id = "trilby_blue"
	build_path = /obj/item/clothing/head/feathertrilby
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/fedora_black	//maybe rename to bowler hat
	name = "Fedora - black"
	id = "fedora - black"
	build_path = /obj/item/clothing/head/fedora
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/fedora_grey	//wheezing at armor value
	name = "Fedora - grey"
	id = "fedora_grey"
	build_path = /obj/item/clothing/head/det/grey
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/fedora_brown	//also wheezing at armor value
	name = "Fedora - brown"
	id = "fedora_brown"
	build_path = /obj/item/clothing/head/det
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/bowler_black
	name = "Bowler hat - black"
	id = "bowler_black"
	build_path = /obj/item/clothing/head/bowlerhat
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/tophat_black
	name = "Top-hat - black"
	id = "tophat_black"
	build_path = /obj/item/clothing/head/that
	materials = list("cloth" = 500)
//dupe^: /obj/item/clothing/head/collectable/tophat

/datum/design/item/autotailor/accessories/hats/beaver_navy
	name = "Top-hat - beaver navy"
	id = "beaver_navy"
	build_path = /obj/item/clothing/head/beaverhat
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/boat_vanilla
	name = "Boater hat - vanilla"
	id = "boat_vanilla"
	build_path = /obj/item/clothing/head/boaterhat
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/gold_hat
	name = "Fancy golden hat"
	id = "gold_hat"
	build_path = /obj/item/clothing/head/collectable/petehat
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/cowboy_brown
	name = "Cowboy hat - brown"
	id = "Cowboy_brown"
	build_path = /obj/item/clothing/head/cowboy_hat
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/kippa_large_black	//rename
	name = "Kippa - black"
	id = "kippa_large_black"
	build_path = /obj/item/clothing/head/bowler
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/kippa_small_white	//custom colors
	name = "Kippa - small white"
	id = "kippa_small_white"
	build_path = /obj/item/clothing/head/kippa
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/fez_red
	name = "Fez - red"
	id = "fez_red"
	build_path = /obj/item/clothing/head/fez
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/bandana_orange
	name = "Bandana - orange"
	id = "bandana_orange"
	build_path = /obj/item/clothing/head/orangebandana
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/bandana_green
	name = "Bandana - green"
	id = "bandana_green"
	build_path = /obj/item/clothing/head/greenbandana
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/headscarf_white	//custom colors?, also xeno sprite gives it some clipping on humans
	name = "Headscarf - white"
	id = "headscarf_white"
	build_path = /obj/item/clothing/head/xeno/scarf
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/taqiyah_white	//custom colors
	name = "Taqiyah - white"
	id = "taqiya_white"
	build_path = /obj/item/clothing/head/taqiyah
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/hijab_white	//custom colors
	name = "Hijab - white"
	id = "hijab_white"
	build_path = /obj/item/clothing/head/hijab
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/turban_white	//custom colors
	name = "Turban - white"
	id = "turban_white"
	build_path = /obj/item/clothing/head/turban
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/hairbow_white	//custom colors
	name = "Hairbow - white"
	id = "hairbow_white"
	build_path = /obj/item/clothing/head/hairflower/bow
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/bearpelt
	name = "Fuzzy bear pelt"
	id = "bearpelt"
	build_path = /obj/item/clothing/head/bearpelt
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/hairpin_blue
	name = "Hair flower pin - blue"
	id = "hairpin_blue"
	build_path = /obj/item/clothing/head/hairflower/blue
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/hairpin_pink
	name = "Hair flower pin - pink"
	id = "hairpin_pink"
	build_path = /obj/item/clothing/head/hairflower/pink
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/hairpin_yellow
	name = "Hair flower pin - yellow"
	id = "hairpin_yellow"
	build_path = /obj/item/clothing/head/hairflower/yellow
	materials = list("cloth" = 500)

/datum/design/item/autotailor/accessories/hats/hairpin_red
	name = "Hair flower pin - red"
	id = "hairpin_red"
	build_path = /obj/item/clothing/head/hairflower
	materials = list("cloth" = 500)