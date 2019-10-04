/obj/machinery/fabricator/autotailor/accessories
	name = "auto-tailor (accessories & storage)"
	desc = "An advanced machine capable of printing many types of clothing, this one is loaded with accessory type designs."
	circuit_type = /obj/item/weapon/circuitboard/fabricator/autotailor/accessories
	build_type = AUTOTAILOR_ACCESSORIES

/obj/machinery/fabricator/autotailor/accessories/can_connect(var/datum/world_faction/trying, var/mob/M)
	var/datum/machine_limits/limits = trying.get_limits()
	if(M && !has_access(list(core_access_machine_linking), list(), M.GetAccess(trying.uid)))
		to_chat(M, "You do not have access to link machines to [trying.name].")
		return 0
	if(limits.limit_ataccessories <= limits.ataccessories.len)
		if(M)
			to_chat(M, "[trying.name] cannot connect any more machines of this type.")
		return 0
	limits.ataccessories |= src
	req_access_faction = trying.uid
	connected_faction = trying

/obj/machinery/fabricator/autotailor/accessories/can_disconnect(var/datum/world_faction/trying, var/mob/M)
	var/datum/machine_limits/limits = trying.get_limits()
	limits.ataccessories -= src
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
	materials = list(MATERIAL_CLOTH = 500)

//
//casual shirts
//
/datum/design/item/autotailor/accessories/casual
	category = "Casual wear"
	materials = list(MATERIAL_CLOTH = 1000)

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
	materials = list(MATERIAL_CLOTH = 1000, MATERIAL_PHORON = 500)

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
	materials = list(MATERIAL_CLOTH = 1000, MATERIAL_GOLD = 500)

/datum/design/item/autotailor/accessories/attach/cane
	name = "Walking cane"
	id = "cane"
	build_path = /obj/item/weapon/cane
	materials = list(MATERIAL_WOOD = 1.5 SHEETS)

/datum/design/item/autotailor/accessories/attach/canefancy
	build_path = /obj/item/weapon/staff/gentcane
	materials = list(MATERIAL_WOOD = 1.5 SHEETS, MATERIAL_GOLD = 1 SHEET)

/datum/design/item/autotailor/accessories/attach/staff
	build_path = /obj/item/weapon/staff
	materials = list(MATERIAL_WOOD = 1.5 SHEETS)


/datum/design/item/autotailor/accessories/attach/canefancy
	build_path = /obj/item/weapon/staff/gentcane
	materials = list(MATERIAL_WOOD = 1.5 SHEETS, MATERIAL_GOLD = 1 SHEET)



/datum/design/item/autotailor/accessories/attach/tie_white	//custom colors
	name = "Tie - white"
	id = "tie_white"
	build_path = /obj/item/clothing/accessory/white
	materials = list(MATERIAL_CLOTH = 1000, MATERIAL_GOLD = 500)

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

/datum/design/item/autotailor/accessories/attach/cliptie_nt
	name = "Tie - NT"
	id = "cliptie_nt"
	build_path = /obj/item/clothing/accessory/corptie/nanotrasen

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
	materials = list(MATERIAL_CLOTH = 500)

/datum/design/item/autotailor/accessories/attach/armband_red
	name = "Armband - red"
	id = "armband_red"
	build_path = /obj/item/clothing/accessory/armband
	materials = list(MATERIAL_CLOTH = 500)

/datum/design/item/autotailor/accessories/attach/armband_cargo
	name = "Armband - supply"
	id = "armband_cargo"
	build_path = /obj/item/clothing/accessory/armband/cargo
	materials = list(MATERIAL_CLOTH = 500)

/datum/design/item/autotailor/accessories/attach/armband_eng
	name = "Armband - engineering"
	id = "armband_eng"
	build_path = /obj/item/clothing/accessory/armband/engine
	materials = list(MATERIAL_CLOTH = 500)

/datum/design/item/autotailor/accessories/attach/armband_med
	name = "Armband - medical"
	id = "armband_med"
	build_path = /obj/item/clothing/accessory/armband/medblue
	materials = list(MATERIAL_CLOTH = 500)

/datum/design/item/autotailor/accessories/attach/armband_emt
	name = "Armband - EMT"
	id = "armband_emt"
	build_path = /obj/item/clothing/accessory/armband/medgreen
	materials = list(MATERIAL_CLOTH = 500)

/datum/design/item/autotailor/accessories/attach/armband_sec
	name = "Armband - security"
	id = "armband_sec"
	build_path = /obj/item/clothing/accessory/armband/whitered
	materials = list(MATERIAL_CLOTH = 500)

/datum/design/item/autotailor/accessories/attach/armband_peace
	name = "Armband - peacekeeper"
	id = "armband_peace"
	build_path = /obj/item/clothing/accessory/armband/bluegold
	materials = list(MATERIAL_CLOTH = 500)

/datum/design/item/autotailor/accessories/attach/armband_botany
	name = "Armband - botanist"
	id = "armband_botany"
	build_path = /obj/item/clothing/accessory/armband/hydro
	materials = list(MATERIAL_CLOTH = 500)

/datum/design/item/autotailor/accessories/attach/scarf_white	//custom colors
	name = "Scarf - white"
	id = "scarf_white"
	build_path = /obj/item/clothing/accessory/scarf
	materials = list(MATERIAL_CLOTH = 2000)

/datum/design/item/autotailor/accessories/attach/necklace_white	//custom colors
	name = "Necklace - white"
	id = "necklace_white"
	build_path = /obj/item/clothing/accessory/necklace
	materials = list(MATERIAL_STEEL = 500)

/datum/design/item/autotailor/accessories/attach/lockette_silver	//techincally custom colors, but no mob sprite to show
	name = "Lockette - silver"
	id = "lockette_silver"
	build_path = /obj/item/clothing/accessory/locket
	materials = list(MATERIAL_SILVER = 500)

/datum/design/item/autotailor/accessories/attach/kneepads
	name = "Kneepads"
	id = "kneepads"
	build_path = /obj/item/clothing/accessory/kneepads
	materials = list(MATERIAL_LEATHER = 2000)

/datum/design/item/autotailor/accessories/attach/medal_iron
	name = "Iron medal"
	id = "medal_iron"
	build_path = /obj/item/clothing/accessory/medal/iron
	materials = list(MATERIAL_IRON = 500)

/datum/design/item/autotailor/accessories/attach/medal_bronze
	name = "Bronze medal"
	id = "medal_bronze"
	build_path = /obj/item/clothing/accessory/medal/bronze
	materials = list(MATERIAL_COPPER = 500)	//i don't think bronze is obtainable

/datum/design/item/autotailor/accessories/attach/medal_silver
	name = "Silver medal"
	id = "medal_silver"
	build_path = /obj/item/clothing/accessory/medal/silver
	materials = list(MATERIAL_SILVER = 500)

/datum/design/item/autotailor/accessories/attach/medal_gold
	name = "Gold medal"
	id = "medal_gold"
	build_path = /obj/item/clothing/accessory/medal/gold
	materials = list(MATERIAL_GOLD = 500)

//
//Shoes
//
/datum/design/item/autotailor/accessories/shoes
	category = "Shoes"
	materials = list(MATERIAL_LEATHER = 1000)

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
	materials = list(MATERIAL_WOOD = 1000)

/datum/design/item/autotailor/accessories/shoes/caligae_white
	name = "Caligae - white"
	id = "caligae_white"
	build_path = /obj/item/clothing/shoes/sandal/xeno/caligae/white
	materials = list(MATERIAL_WOOD = 1000)

/datum/design/item/autotailor/accessories/shoes/caligae_grey
	name = "Caligae - grey"
	id = "caligae_grey"
	build_path = /obj/item/clothing/shoes/sandal/xeno/caligae/grey
	materials = list(MATERIAL_WOOD = 1000)

/datum/design/item/autotailor/accessories/shoes/caligae_black
	name = "Caligae - black"
	id = "Caligae - black"
	build_path = /obj/item/clothing/shoes/sandal/xeno/caligae/black
	materials = list(MATERIAL_WOOD = 1000)

/datum/design/item/autotailor/accessories/shoes/sandal_brown
	name = "Sandals"
	id = "sandal_brown"
	build_path = /obj/item/clothing/shoes/sandal
	materials = list(MATERIAL_WOOD = 1000)

/datum/design/item/autotailor/accessories/shoes/sandal_xeno	//these are exactly the same sprite as above on humans, remove if its the case with xenos too
	name = "Sandals - xenos"
	id = "sandal_xeno"
	build_path = /obj/item/clothing/shoes/sandal/xeno
	materials = list(MATERIAL_WOOD = 1000)

/datum/design/item/autotailor/accessories/shoes/dressshoes_white	//custom colors?
	name = "Dress shoes - white"
	id = "dressshoes_white"
	build_path = /obj/item/clothing/shoes/dress/white
	materials = list(MATERIAL_LEATHER = 500, MATERIAL_GOLD = 500)

/datum/design/item/autotailor/accessories/shoes/dress_black
	name = "Dress shoes - black"
	id = "dress_black"
	build_path = /obj/item/clothing/shoes/dress
	materials = list(MATERIAL_LEATHER = 500, MATERIAL_GOLD = 500)

/datum/design/item/autotailor/accessories/shoes/jackb_black
	name = "Jackboots - black"
	id = "jackb_black"
	build_path = /obj/item/clothing/shoes/jackboots
	materials = list(MATERIAL_LEATHER = 500, MATERIAL_STEEL = 1000)

/datum/design/item/autotailor/accessories/shoes/jackb_black_notoe
	name = "Jackboots - black toeless"
	id = "jackb_black_notoe"
	build_path = /obj/item/clothing/shoes/jackboots/unathi
	materials = list(MATERIAL_LEATHER = 500, MATERIAL_STEEL = 1000)

/datum/design/item/autotailor/accessories/shoes/jackb_grey	//item sprite looks arcane-y, but mob sprite looks normal for everyday use
	name = "Jackboots - grey"
	id = "jackb_grey"
	build_path = /obj/item/clothing/shoes/cult
	materials = list(MATERIAL_LEATHER = 500, MATERIAL_STEEL = 1000)

/datum/design/item/autotailor/accessories/shoes/jackb_tan
	name = "Jackboots - tan"
	id = "jackb_tan"
	build_path = /obj/item/clothing/shoes/desertboots
	materials = list(MATERIAL_LEATHER = 500, MATERIAL_STEEL = 1000)

/datum/design/item/autotailor/accessories/shoes/jackb_brown
	name = "jackboots - brown"
	id = "jackb_brown"
	build_path = /obj/item/clothing/shoes/jungleboots
	materials = list(MATERIAL_LEATHER = 500, MATERIAL_STEEL = 1000)

/datum/design/item/autotailor/accessories/shoes/workboot
	name = "Industrial workboots"
	id = "workboot"
	build_path = /obj/item/clothing/shoes/workboots
	materials = list(MATERIAL_LEATHER = 500, MATERIAL_STEEL = 1000)

/datum/design/item/autotailor/accessories/shoes/workboot_notoe	//hopefully unique sprite on unanthe, same sprite as above on human, also outdated object sprite
	name = "Industrial workboots - toeless"
	id = "workboot_notoe"
	build_path = /obj/item/clothing/shoes/workboots/toeless
	materials = list(MATERIAL_LEATHER = 500, MATERIAL_STEEL = 1000)

/datum/design/item/autotailor/accessories/shoes/galoshes_yellow
	name = "Galoshes"
	id = "galoshes_yellow"
	build_path = /obj/item/clothing/shoes/galoshes
	materials = list(MATERIAL_PLASTIC = 2000)

/datum/design/item/autotailor/accessories/shoes/slippers_bunny
	name = "Bunny slippers"
	id = "slippers_bunny"
	build_path = /obj/item/clothing/shoes/slippers
	materials = list(MATERIAL_CLOTH = 1000)

/datum/design/item/autotailor/accessories/shoes/slippers_bunny_worn	//if we ever add clothing states, make this the snowflake item with its own dirty icon
	name = "Bunny slippers - worn"
	id = "slippers_bunny_worn"
	build_path = /obj/item/clothing/shoes/slippers_worn
	materials = list(MATERIAL_CLOTH = 500)

//
//Ears,anemities fab will hopefully make this list more precisely named
//
/datum/design/item/autotailor/accessories/ears
	category = "Ears"
	materials = list(MATERIAL_PLASTIC = 1000)

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
	materials = list(MATERIAL_PLASTIC = 500)

/datum/design/item/autotailor/accessories/ears/dangle_wood
	name = "Dangle earrings - wood"
	id = "dangle_wood"
	build_path = /obj/item/clothing/ears/earring/dangle/wood
	materials = list(MATERIAL_WOOD = 500)

/datum/design/item/autotailor/accessories/ears/dangle_glass
	name = "Dangle earrings - glass"
	id = "dangle_glass"
	build_path = /obj/item/clothing/ears/earring/dangle/glass
	materials = list(MATERIAL_GLASS = 500)

/datum/design/item/autotailor/accessories/ears/dangle_iron
	name = "Dangle earrings - iron"
	id = "dangle_iron"
	build_path = /obj/item/clothing/ears/earring/dangle/iron
	materials = list(MATERIAL_IRON = 500)

/datum/design/item/autotailor/accessories/ears/dangle_steel
	name = "Dangle earrings - steel"
	id = "dangle_steel"
	build_path = /obj/item/clothing/ears/earring/dangle/steel
	materials = list(MATERIAL_STEEL = 500)

/datum/design/item/autotailor/accessories/ears/dangle_silver
	name = "Dangle earrings - silver"
	id = "dangle_silver"
	build_path = /obj/item/clothing/ears/earring/dangle/silver
	materials = list(MATERIAL_SILVER = 500)

/datum/design/item/autotailor/accessories/ears/dangle_platinum
	name = "Dangle earrings - platinum"
	id = "dangle_platinum"
	build_path = /obj/item/clothing/ears/earring/dangle/platinum
	materials = list(MATERIAL_PLATINUM = 500)

/datum/design/item/autotailor/accessories/ears/dangle_gold
	name = "Dangle earrings - gold"
	id = "dangle_gold"
	build_path = /obj/item/clothing/ears/earring/dangle/gold
	materials = list(MATERIAL_GOLD = 500)

/datum/design/item/autotailor/accessories/ears/dangle_diamond
	name = "Dangle earrings - diamond"
	id = "dangle_diamond"
	build_path = /obj/item/clothing/ears/earring/dangle/diamond
	materials = list(MATERIAL_DIAMOND = 500)

/datum/design/item/autotailor/accessories/ears/stud_pearl	//custom colors
	name = "Stud earrings - pearl"
	id = "stud_pearl"
	build_path = /obj/item/clothing/ears/earring/stud
	materials = list(MATERIAL_PLASTIC = 500)

/datum/design/item/autotailor/accessories/ears/stud_wood
	name = "Stud earrings - wood"
	id = "stud_wood"
	build_path = /obj/item/clothing/ears/earring/stud/wood
	materials = list(MATERIAL_WOOD = 500)

/datum/design/item/autotailor/accessories/ears/stud_glass
	name = "Stud earrings - glass"
	id = "stud_glass"
	build_path = /obj/item/clothing/ears/earring/stud/glass
	materials = list(MATERIAL_GLASS = 500)

/datum/design/item/autotailor/accessories/ears/stud_iron
	name = "Stud earrings - iron"
	id = "stud_iron"
	build_path = /obj/item/clothing/ears/earring/stud/iron
	materials = list(MATERIAL_IRON = 500)

/datum/design/item/autotailor/accessories/ears/stud_steel
	name = "Stud earrings - steel"
	id = "stud_steel"
	build_path = /obj/item/clothing/ears/earring/stud/steel
	materials = list(MATERIAL_STEEL = 500)

/datum/design/item/autotailor/accessories/ears/stud_silver
	name = "Stud earrings - silver"
	id = "stud_silver"
	build_path = /obj/item/clothing/ears/earring/stud/silver
	materials = list(MATERIAL_SILVER = 500)

/datum/design/item/autotailor/accessories/ears/stud_platinum
	name = "Stud earrings - platinum"
	id = "stud_platinum"
	build_path = /obj/item/clothing/ears/earring/stud/platinum
	materials = list(MATERIAL_PLATINUM = 500)

/datum/design/item/autotailor/accessories/ears/stud_gold
	name = "Stud earrings - gold"
	id = "stud_gold"
	build_path = /obj/item/clothing/ears/earring/stud/gold
	materials = list(MATERIAL_GOLD = 500)

/datum/design/item/autotailor/accessories/ears/stud_diamond
	name = "Stud earrings - diamond"
	id = "stud_diamond"
	build_path = /obj/item/clothing/ears/earring/stud/diamond
	materials = list(MATERIAL_DIAMOND = 500)

//
//eye slots, does not include high tech items like mesons
//
/datum/design/item/autotailor/accessories/eyes
	category = "Glasses"
	materials = list(MATERIAL_STEEL = 100, MATERIAL_GLASS = 500)

/datum/design/item/autotailor/accessories/eyes/prescription
	name = "Prescription glasses"
	id = "prescription"
	build_path = /obj/item/clothing/glasses/regular

/datum/design/item/autotailor/accessories/eyes/prescription_hipster
	name = "Prescription glasses - alternate"
	id = "prescription_hipster"
	build_path = /obj/item/clothing/glasses/regular/hipster
	materials = list(MATERIAL_STEEL = 500, MATERIAL_GLASS = 1000)

/datum/design/item/autotailor/accessories/eyes/prescription_sun
	name = "Prescription glasses - sunglasses"
	id = "prescription_sun"
	build_path = /obj/item/clothing/glasses/sunglasses/prescription
	materials = list(MATERIAL_STEEL = 100, MATERIAL_GLASS = 1000, MATERIAL_FIBERGLASS = 7000)

/datum/design/item/autotailor/accessories/eyes/sunglasses
	name = "Sunglasses"
	id = "sunglasses"
	build_path = /obj/item/clothing/glasses/sunglasses
	materials = list(MATERIAL_STEEL = 100, MATERIAL_FIBERGLASS = 5000)

/datum/design/item/autotailor/accessories/eyes/sunglasses_large
	name = "Sunglasses - large"
	id = "sunglasses_large"
	build_path = /obj/item/clothing/glasses/sunglasses/big
	materials = list(MATERIAL_STEEL = 1000, MATERIAL_FIBERGLASS = 10000)

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
	materials = list(MATERIAL_STEEL = 100, MATERIAL_GLASS = 500, MATERIAL_PHORON = 500)

/datum/design/item/autotailor/accessories/eyes/default_veil
	name = "Decorative veil"
	id = "default_veil"
	build_path = /obj/item/clothing/glasses/veil
	materials = list(MATERIAL_STEEL = 100, MATERIAL_GLASS = 500, MATERIAL_PHORON = 5000)

//
//gloves
//
/datum/design/item/autotailor/accessories/gloves
	category = "Gloves"
	materials = list(MATERIAL_LEATHER = 2000)

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
	materials = list(MATERIAL_LEATHER = 2000, MATERIAL_PHORON = 4000)

/datum/design/item/autotailor/accessories/gloves/black_thick
	name = "Gloves - thick black"
	id = "black_thick"
	build_path = /obj/item/clothing/gloves/thick
	materials = list(MATERIAL_LEATHER = 4000)

// /datum/design/item/autotailor/accessories/gloves/brown_thick
// 	name = "Gloves - thick brown"
// 	id = "brown_thick"
// 	build_path = /obj/item/clothing/gloves/duty
// 	materials = list(MATERIAL_LEATHER = 4000)

/datum/design/item/autotailor/accessories/gloves/leather_thick
	name = "Gloves - thick leather"
	id = "leather_thick"
	build_path = /obj/item/clothing/gloves/thick/botany
	materials = list(MATERIAL_LEATHER = 4000)

/datum/design/item/autotailor/accessories/gloves/latex
	name = "Medical gloves - latex"
	id = "latex"
	build_path = /obj/item/clothing/gloves/latex
	materials = list(MATERIAL_PLASTIC = 2000)
	build_type = list(AUTOTAILOR_ACCESSORIES, MEDICALFAB)
/datum/design/item/autotailor/accessories/gloves/nitrile
	name = "Medical gloves - nitrile"
	id = "nitrile"
	build_path = /obj/item/clothing/gloves/latex/nitrile
	materials = list(MATERIAL_PLASTIC = 1 SHEET)
	build_type = list(AUTOTAILOR_ACCESSORIES, MEDICALFAB)

/datum/design/item/autotailor/accessories/gloves/dressgloves_white	//custom colors
	name = "Evening gloves - white"
	id = "dressgloves_white"
	build_path = /obj/item/clothing/gloves/color/evening
	materials = list(MATERIAL_LEATHER = 2000, MATERIAL_PHORON = 10000)

/datum/design/item/autotailor/accessories/gloves/eng_vox
	name = "Insulated gloves - vox"
	id = "work_vox"
	build_path = /obj/item/clothing/gloves/vox
	materials = list(MATERIAL_LEATHER = 2000, MATERIAL_TITANIUM = 5000)

/datum/design/item/autotailor/accessories/gloves/eng
	name = "Insulated gloves"
	id = "eng"
	build_path = /obj/item/clothing/gloves/insulated
	materials = list(MATERIAL_LEATHER = 2000, MATERIAL_TITANIUM = 5000)	//not sure if this generates on roid, change if not
	
/datum/design/item/autotailor/accessories/gloves/forensic
	name = "Forensic gloves"
	id = "forensic"
	build_path = /obj/item/clothing/gloves/forensic
	materials = list(MATERIAL_LEATHER = 2000, MATERIAL_PHORON = 60000)	//these gloves have very unique threads, making them cheap makes it not very unique

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
	materials = list(MATERIAL_PLASTIC = 2000)

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
	materials = list(MATERIAL_PLASTIC = 2000, MATERIAL_STEEL = 2000)

/datum/design/item/autotailor/accessories/masks/breath_vox
	name = "Breath mask - vox"
	id = "breath_vox"
	build_path = /obj/item/clothing/mask/gas/vox
	materials = list(MATERIAL_PLASTIC = 5000)

/datum/design/item/autotailor/accessories/masks/gas_generic
	name = "Gas mask"
	id = "gas_generic"
	build_path = /obj/item/clothing/mask/gas
	materials = list(MATERIAL_PLASTIC = 5000)

/datum/design/item/autotailor/accessories/masks/gas_tactical
	name = "Gas mask - tactical"
	id = "gas_tactical"
	build_path = /obj/item/clothing/mask/gas/syndicate
	materials = list(MATERIAL_PLASTIC = 5000)

/datum/design/item/autotailor/accessories/masks/gas_tact_vox
	name = "Gas mask - tactical vox"
	id = "gas_tact_vox"
	build_path = /obj/item/clothing/mask/gas/swat/vox
	materials = list(MATERIAL_PLASTIC = 5000)

/datum/design/item/autotailor/accessories/masks/balac_black
	name = "Balaclava - black"
	id = "balac_black"
	build_path = /obj/item/clothing/mask/balaclava
	materials = list(MATERIAL_CLOTH = 2000)

/datum/design/item/autotailor/accessories/masks/balac_green
	name = "Balaclava - green"
	id = "balac_green"
	build_path = /obj/item/clothing/mask/balaclava/tactical
	materials = list(MATERIAL_CLOTH = 2000)

/datum/design/item/autotailor/accessories/masks/balac_blue
	name = "Balaclava - blue"
	id = "balac_blue"
	build_path = /obj/item/clothing/mask/balaclava/blue
	materials = list(MATERIAL_CLOTH = 2000)

/datum/design/item/autotailor/accessories/masks/sterile_mask
	name = "Sterile face mask"
	id = "sterile mask"
	build_path = /obj/item/clothing/mask/surgical
	materials = list(MATERIAL_PLASTIC = 2000)
	build_type = list(AUTOTAILOR_ACCESSORIES, MEDICALFAB)

/datum/design/item/autotailor/accessories/masks/pipe_fancy	//temporary until a more fitting fabricator is made
	name = "Smoking pipe - fancy"
	id = "pipe_fancy"
	build_path = /obj/item/clothing/mask/smokable/pipe
	materials = list(MATERIAL_WOOD = 10000)

/datum/design/item/autotailor/accessories/masks/pipe_cob	//temporary until a more fitting fabricator is made
	name = "Smoking pipe - corncob"
	id = "pipe_cob"
	build_path = /obj/item/clothing/mask/smokable/pipe/cobpipe
	materials = list(MATERIAL_WOOD = 1000)

//
//softhats
//
/datum/design/item/autotailor/accessories/hats
	category = "Soft hats"
	materials = list(MATERIAL_CLOTH = 500)

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
	materials = list(MATERIAL_LEATHER = 500)

/datum/design/item/autotailor/accessories/hats/beret_grey
	name = "Flat cap - grey"
	id = "flat_grey"
	build_path = /obj/item/clothing/head/wizard/cap/fake
	materials = list(MATERIAL_LEATHER = 500)

/datum/design/item/autotailor/accessories/hats/trilby_blue
	name = "Trilby - blue feathered"
	id = "trilby_blue"
	build_path = /obj/item/clothing/head/feathertrilby
	materials = list(MATERIAL_LEATHER = 500)

/datum/design/item/autotailor/accessories/hats/fedora_black
	name = "Fedora - black"
	id = "fedora - black"
	build_path = /obj/item/clothing/head/fedora
	materials = list(MATERIAL_LEATHER = 500)

/datum/design/item/autotailor/accessories/hats/fedora_grey
	name = "Fedora - grey"
	id = "fedora_grey"
	build_path = /obj/item/clothing/head/det/grey/noarmor
	materials = list(MATERIAL_LEATHER = 500)

/datum/design/item/autotailor/accessories/hats/fedora_brown
	name = "Fedora - brown"
	id = "fedora_brown"
	build_path = /obj/item/clothing/head/det/noarmor
	materials = list(MATERIAL_LEATHER = 500)

/datum/design/item/autotailor/accessories/hats/bowler_black
	name = "Bowler hat - black"
	id = "bowler_black"
	build_path = /obj/item/clothing/head/bowlerhat
	materials = list(MATERIAL_LEATHER = 500)

/datum/design/item/autotailor/accessories/hats/tophat_black
	name = "Top-hat - black"
	id = "tophat_black"
	build_path = /obj/item/clothing/head/that
	materials = list(MATERIAL_LEATHER = 500)

/datum/design/item/autotailor/accessories/hats/beaver_navy
	name = "Top-hat - beaver navy"
	id = "beaver_navy"
	build_path = /obj/item/clothing/head/beaverhat
	materials = list(MATERIAL_LEATHER = 500)

/datum/design/item/autotailor/accessories/hats/boat_vanilla
	name = "Boater hat - vanilla"
	id = "boat_vanilla"
	build_path = /obj/item/clothing/head/boaterhat
	materials = list(MATERIAL_LEATHER = 500)

/datum/design/item/autotailor/accessories/hats/gold_hat
	name = "Fancy golden hat"
	id = "gold_hat"
	build_path = /obj/item/clothing/head/collectable/petehat
	materials = list(MATERIAL_LEATHER = 500, MATERIAL_GOLD = 5000)

/datum/design/item/autotailor/accessories/hats/cowboy_brown
	name = "Cowboy hat - brown"
	id = "Cowboy_brown"
	build_path = /obj/item/clothing/head/cowboy_hat
	materials = list(MATERIAL_LEATHER = 500)

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
	build_path = /obj/item/clothing/head/bandana/orange

/datum/design/item/autotailor/accessories/hats/bandana_green
	name = "Bandana - green"
	id = "bandana_green"
	build_path = /obj/item/clothing/head/bandana/green

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
	materials = list(MATERIAL_CLOTH = 5000, MATERIAL_LEATHER = 5000)

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





//
//Back storage slots
//
/datum/design/item/autotailor/accessories/backpacks
	category = "Backpacks"
	materials = list(MATERIAL_CLOTH = 10000)

/datum/design/item/autotailor/accessories/backpacks/grey_back
	name = "Grey backpack"
	id = "grey_back"
	build_path = /obj/item/weapon/storage/backpack

/datum/design/item/autotailor/accessories/backpacks/green_back
	name = "Green backpack"
	id = "green_back"
	build_path = /obj/item/weapon/storage/backpack/hydroponics

/datum/design/item/autotailor/accessories/backpacks/clown_back
	name = "Clown backpack"
	id = "clown_back"
	build_path = /obj/item/weapon/storage/backpack/clown

/datum/design/item/autotailor/accessories/backpacks/mime_back
	name = "Mime backpack"
	id = "mime_back"
	build_path = /obj/item/weapon/storage/backpack/mime

/datum/design/item/autotailor/accessories/backpacks/grey_satch
	name = "Grey satchel"
	id = "grey_satch"
	build_path = /obj/item/weapon/storage/backpack/satchel/grey

/datum/design/item/autotailor/accessories/backpacks/green_satch
	name = "Green satchel"
	id = "green_satch"
	build_path = /obj/item/weapon/storage/backpack/satchel/hyd

/datum/design/item/autotailor/accessories/backpacks/brown_l_satchel	//can use custom colors
	name = "Brown leather satchel"
	id = "brown_l_satchel"
	build_path = /obj/item/weapon/storage/backpack/satchel/leather

/datum/design/item/autotailor/accessories/backpacks/black_l_satchel
	name = "Black leather satchel"
	id = "black_l_satchel"
	build_path = /obj/item/weapon/storage/backpack/satchel/leather/black

/datum/design/item/autotailor/accessories/backpacks/black_pocketbook	//can use custom colors
	name = "Black small pocketbook"
	id = "black_pocketbook"
	build_path = /obj/item/weapon/storage/backpack/satchel/pocketbook
	materials = list(MATERIAL_CLOTH = 5000)

/datum/design/item/autotailor/accessories/backpacks/mess_grey
	name = "Grey messenger bag"
	id = "mess_grey"
	build_path = /obj/item/weapon/storage/backpack/messenger

/datum/design/item/autotailor/accessories/backpacks/green_mess
	name = "Green messenger bag"
	id = "green_mess"
	build_path = /obj/item/weapon/storage/backpack/messenger/hyd

/datum/design/item/autotailor/accessories/backpacks/grey_duffle
	name = "Grey dufflebag"
	id = "grey_duffle"
	build_path = /obj/item/weapon/storage/backpack/dufflebag
	materials = list(MATERIAL_CLOTH = 15000)

/datum/design/item/autotailor/accessories/backpacks/t_rack
	name = "Backpack - trophy rack"
	id = "t_rack"
	build_path = /obj/item/weapon/storage/backpack/cultpack

/datum/design/item/autotailor/accessories/backpacks/indu_back
	name = "Industrial backpack"
	id = "indu_back"
	build_path = /obj/item/weapon/storage/backpack/industrial

/datum/design/item/autotailor/accessories/backpacks/indu_satch
	name = "Industrial satchel"
	id = "indu_satch"
	build_path = /obj/item/weapon/storage/backpack/satchel/eng

/datum/design/item/autotailor/accessories/backpacks/indu_mess
	name = "Industrial messenger bag"
	id = "indu_mess"
	build_path = /obj/item/weapon/storage/backpack/messenger/engi

/datum/design/item/autotailor/accessories/backpacks/indu_duffle
	name = "Industrial dufflebag"
	id = "indu_duffle"
	build_path = /obj/item/weapon/storage/backpack/dufflebag/eng
	materials = list(MATERIAL_CLOTH = 15000)

/datum/design/item/autotailor/accessories/backpacks/sci_back
	name = "Scientist backpack"
	id = "sci_back"
	build_path = /obj/item/weapon/storage/backpack/toxins

/datum/design/item/autotailor/accessories/backpacks/sci_satch
	name = "Scientist satchel"
	id = "sci_satch"
	build_path = /obj/item/weapon/storage/backpack/satchel/tox

/datum/design/item/autotailor/accessories/backpacks/sci_mess
	name = "Scientst messenger bag"
	id = "sci_mess"
	build_path = /obj/item/weapon/storage/backpack/messenger/tox

/datum/design/item/autotailor/accessories/backpacks/med_back
	name = "Medical backpack"
	id = "med_back"
	build_path = /obj/item/weapon/storage/backpack/medic

/datum/design/item/autotailor/accessories/backpacks/chem_back
	name = "Chemist backpack"
	id = "chem_back"
	build_path = /obj/item/weapon/storage/backpack/chemistry

/datum/design/item/autotailor/accessories/backpacks/viro_back
	name = "Virologist backpack"
	id = "viro_back"
	build_path = /obj/item/weapon/storage/backpack/virology

/datum/design/item/autotailor/accessories/backpacks/gene_back
	name = "Geneticist backpack"
	id = "gene_back"
	build_path = /obj/item/weapon/storage/backpack/genetics

/datum/design/item/autotailor/accessories/backpacks/med_satch
	name = "Medical satchel"
	id = "med_satch"
	build_path = /obj/item/weapon/storage/backpack/satchel/med

/datum/design/item/autotailor/accessories/backpacks/chem_satch
	name = "Chemist satchel"
	id = "chem_satch"
	build_path = /obj/item/weapon/storage/backpack/satchel/chem

/datum/design/item/autotailor/accessories/backpacks/viro_satch
	name = "Virologist satchel"
	id = "viro_satch"
	build_path = /obj/item/weapon/storage/backpack/satchel/vir

/datum/design/item/autotailor/accessories/backpacks/gene_satch
	name = "Geneticist satchel"
	id = "gene_satch"
	build_path = /obj/item/weapon/storage/backpack/satchel/gen

/datum/design/item/autotailor/accessories/backpacks/med_mess
	name = "Medical messenger bag"
	id = "med_mess"
	build_path = /obj/item/weapon/storage/backpack/messenger/med

/datum/design/item/autotailor/accessories/backpacks/chem_mess
	name = "Chemist messenger bag"
	id = "chem_mess"
	build_path = /obj/item/weapon/storage/backpack/messenger/chem

/datum/design/item/autotailor/accessories/backpacks/viro_mess
	name = "Virologist messenger bag"
	id = "viro_messs"
	build_path = /obj/item/weapon/storage/backpack/messenger/viro

/datum/design/item/autotailor/accessories/backpacks/med_duffle
	name = "Medical dufflebag"
	id = "med_duffle"
	build_path = /obj/item/weapon/storage/backpack/dufflebag/med
	materials = list(MATERIAL_CLOTH = 15000)

/datum/design/item/autotailor/accessories/backpacks/sec_back
	name = "Security backpack"
	id = "sec_back"
	build_path = /obj/item/weapon/storage/backpack/security

/datum/design/item/autotailor/accessories/backpacks/sec_satch
	name = "Security satchel"
	id = "sec_satch"
	build_path = /obj/item/weapon/storage/backpack/satchel/sec

/datum/design/item/autotailor/accessories/backpacks/sec_mess
	name = "Security messenger bag"
	id = "sec_mess"
	build_path = /obj/item/weapon/storage/backpack/messenger/sec

/datum/design/item/autotailor/accessories/backpacks/sec_duffle
	name = "Security dufflebag"
	id = "sec_duffle"
	build_path = /obj/item/weapon/storage/backpack/dufflebag/sec
	materials = list(MATERIAL_CLOTH = 15000)

/datum/design/item/autotailor/accessories/backpacks/cap_back
	name = "Captain backpack"
	id = "cap_back"
	build_path = /obj/item/weapon/storage/backpack/captain

/datum/design/item/autotailor/accessories/backpacks/cap_satch
	name = "Captain satchel"
	id = "cap_satch"
	build_path = /obj/item/weapon/storage/backpack/satchel/cap

/datum/design/item/autotailor/accessories/backpacks/cap_mess
	name = "Captain messenger bag"
	id = "cap_mess"
	build_path = /obj/item/weapon/storage/backpack/messenger/com

/datum/design/item/autotailor/accessories/backpacks/cap_duffle
	name = "Captain dufflebag"
	id = "cap_duffle"
	build_path = /obj/item/weapon/storage/backpack/dufflebag/captain
	materials = list(MATERIAL_CLOTH = 15000)

/datum/design/item/autotailor/accessories/backpacks/ert_blueback
	name = "Blue ERT backpack"
	id = "ert_blue"
	build_path = /obj/item/weapon/storage/backpack/ert
	materials = list(MATERIAL_CLOTH = 5000, MATERIAL_PHORON = 2000)

/datum/design/item/autotailor/accessories/backpacks/ert_engback
	name = "Yellow ERT backpack"
	id = "ert_engback"
	build_path = /obj/item/weapon/storage/backpack/ert/engineer
	materials = list(MATERIAL_CLOTH = 5000, MATERIAL_PHORON = 2000)

/datum/design/item/autotailor/accessories/backpacks/ert_whiteback
	name = "White ERT backpack"
	id = "ert_white"
	build_path = /obj/item/weapon/storage/backpack/ert/medical
	materials = list(MATERIAL_CLOTH = 5000, MATERIAL_PHORON = 2000)

/datum/design/item/autotailor/accessories/backpacks/ert_redback
	name = "Red ERT backpack"
	id = "ert_red"
	build_path = /obj/item/weapon/storage/backpack/ert/security
	materials = list(MATERIAL_CLOTH = 5000, MATERIAL_PHORON = 2000)

/datum/design/item/autotailor/accessories/backpacks/tact_d_black
	name = "Tactical dufflebag - black"
	id = "tact_d_black"
	build_path = /obj/item/weapon/storage/backpack/dufflebag/syndie
	materials = list(MATERIAL_CLOTH = 15000, MATERIAL_PHORON = 4000)

/datum/design/item/autotailor/accessories/backpacks/tact_d_med
	name = "Tactical dufflebag - medical"
	id = "tact_d_med"
	build_path = /obj/item/weapon/storage/backpack/dufflebag/syndie/med
	materials = list(MATERIAL_CLOTH = 15000, MATERIAL_PHORON = 4000)

/datum/design/item/autotailor/accessories/backpacks/tact_d_ammo
	name = "Tactical dufflebag - ammo"
	id = "tact_d_ammo"
	build_path = /obj/item/weapon/storage/backpack/dufflebag/syndie/ammo
	materials = list(MATERIAL_CLOTH = 15000, MATERIAL_PHORON = 4000)

//
//belt slot
//

/datum/design/item/autotailor/accessories/waist
	category = "Belt bags"
	materials = list(MATERIAL_LEATHER = 5000, MATERIAL_STEEL = 1000)

//alot (all) of the new paradise ported belts have no mob sprites, i see no reason to exclude such a small sprite though, so they remain
/datum/design/item/autotailor/accessories/waist/utility_brown
	name = "Brown utility belt"
	id = "utility_brown"
	build_path = /obj/item/weapon/storage/belt/utility

/datum/design/item/autotailor/accessories/waist/utility_white
	name = "White utility belt"
	id = "utility_white"
	build_path = /obj/item/weapon/storage/belt/utility/chief

/datum/design/item/autotailor/accessories/waist/peddler
	name = "Peddler belt"
	id = "peddler"
	build_path = /obj/item/weapon/storage/belt/peddler

/datum/design/item/autotailor/accessories/waist/med_white
	name = "Medical belt"
	id = "med_white"
	build_path = /obj/item/weapon/storage/belt/medical

/datum/design/item/autotailor/accessories/waist/med_emt
	name = "Medical EMT belt"
	id = "med_emt"
	build_path = /obj/item/weapon/storage/belt/medical/emt

/datum/design/item/autotailor/accessories/waist/sci_excav
	name = "Scientist belt - excavation"
	id = "sci_excav"
	build_path = /obj/item/weapon/storage/belt/archaeology

/datum/design/item/autotailor/accessories/waist/botany
	name = "Gardening belt"
	id = "botany"
	build_path = /obj/item/weapon/storage/belt/botany

/datum/design/item/autotailor/accessories/waist/jani
	name = "Janitorial belt"
	id = "jani"
	build_path = /obj/item/weapon/storage/belt/janitor/large

/datum/design/item/autotailor/accessories/waist/jani_alt
	name = "Janitorial belt - alt"
	id = "jani_alt"
	build_path = /obj/item/weapon/storage/belt/janitor

//combat belts might belong in security-tailor
/datum/design/item/autotailor/accessories/waist/bandolier_belt
	name = "Ammunation bandolier"
	id = "bandolier_belt"
	build_path = /obj/item/weapon/storage/belt/bandolier

/datum/design/item/autotailor/accessories/waist/sec_blackbelt
	name = "Security belt - black"
	id = "sec_blackbelt"
	build_path = /obj/item/weapon/storage/belt/security

/datum/design/item/autotailor/accessories/waist/sec_tan
	name = "Security belt - tan"
	id = "sec_tan"
	build_path = /obj/item/weapon/storage/belt/holster/security/tactical

/datum/design/item/autotailor/accessories/waist/sec_combat
	name = "Security combat belt"
	id = "sec_combat"
	build_path = /obj/item/weapon/storage/belt/security/fed

// /datum/design/item/autotailor/accessories/waist/sec_combat_alt
// 	name = "Security combat belt - alt"
// 	id = "sec_combat_alt"
// 	build_path = /obj/item/weapon/storage/belt/security/assault

// /datum/design/item/autotailor/accessories/waist/sec_parade
// 	name = "Security parade belt"
// 	id = "sec_parade"
// 	build_path = /obj/item/weapon/storage/belt/security/military

/datum/design/item/autotailor/accessories/waist/waistpack_white	//can use custom colors
	name = "White waistpack"
	id = "waistpack_white"
	build_path = /obj/item/weapon/storage/belt/waistpack

/datum/design/item/autotailor/accessories/waist/waistpack_l_white
	name = "White large waistpack"
	id = "waistpack_l_white"
	build_path = /obj/item/weapon/storage/belt/waistpack/big
	materials = list(MATERIAL_LEATHER = 10000, MATERIAL_STEEL = 2000)

/datum/design/item/autotailor/accessories/waist/waistpack_alt_white	//can use custom colors
	name = "White fannypack"
	id = "waistpack_alt"
	build_path = /obj/item/weapon/storage/belt/fannypack/white

/datum/design/item/autotailor/accessories/waist/waistpack_alt_black
	name = "Black fannypack"
	id = "waistpack_alt_black"
	build_path = /obj/item/weapon/storage/belt/fannypack/black

/datum/design/item/autotailor/accessories/waist/waistpack_alt_brown
	name = "Brown fannypack"
	id = "waistpack_alt_brown"
	build_path = /obj/item/weapon/storage/belt/fannypack

/datum/design/item/autotailor/accessories/waist/waistpack_alt_red
	name = "Red fannypack"
	id = "waistpack_alt_red"
	build_path = /obj/item/weapon/storage/belt/fannypack/red

/datum/design/item/autotailor/accessories/waist/waistpack_alt_blue
	name = "Blue fannypack"
	id = "waistpack_alt_blue"
	build_path = /obj/item/weapon/storage/belt/fannypack/blue

/datum/design/item/autotailor/accessories/waist/waistpack_alt_purp
	name = "Purple fannypack"
	id = "waistpack_alt_purp"
	build_path = /obj/item/weapon/storage/belt/fannypack/purple

/datum/design/item/autotailor/accessories/waist/waistpack_alt_green
	name = "Green fannypack"
	id = "waistpack_alt_green"
	build_path = /obj/item/weapon/storage/belt/fannypack/green

/datum/design/item/autotailor/accessories/waist/waistpack_alt_cyan
	name = "Cyan fannypack"
	id = "waistpack_alt_cyan"
	build_path = /obj/item/weapon/storage/belt/fannypack/cyan

/datum/design/item/autotailor/accessories/waist/waistpack_alt_yellow
	name = "Yellow fannypack"
	id = "waistpack_alt_yellow"
	build_path = /obj/item/weapon/storage/belt/fannypack/yellow

/datum/design/item/autotailor/accessories/waist/waistpack_alt_orange
	name = "Orange fannypack"
	id = "waistpack_alt_orange"
	build_path = /obj/item/weapon/storage/belt/fannypack/orange

/datum/design/item/autotailor/accessories/waist/waistpack_alt_pink
	name = "Pink fannypack"
	id = "waistpack_alt_pink"
	build_path = /obj/item/weapon/storage/belt/fannypack/pink

//
//work storage
//
/datum/design/item/autotailor/accessories/work/
	category = "Work storage boxes"
	materials = list(MATERIAL_STEEL = 10000)

/datum/design/item/autotailor/accessories/work/toolbox_red
	name = "Red toolbox"
	id = "toolbox_red"
	build_path = /obj/item/weapon/storage/toolbox

/datum/design/item/autotailor/accessories/work/toolbox_bl_red
	name = "Black & red toolbox"
	id = "toolbox_bl_red"
	build_path = /obj/item/weapon/storage/toolbox/syndicate

/datum/design/item/autotailor/accessories/work/toolbox_blue
	name = "Blue toolbox"
	id = "toolbox_blue"
	build_path = /obj/item/weapon/storage/toolbox/mechanical

/datum/design/item/autotailor/accessories/work/toolbox_yellow
	name = "Yellow toolbox"
	id = "toolbox_yellow"
	build_path = /obj/item/weapon/storage/toolbox/electrical

/datum/design/item/autotailor/accessories/work/toolbox_surgery
	name = "Medical toolbox"
	id = "toolbox_surgery"
	build_path = /obj/item/weapon/storage/firstaid/surgery

/datum/design/item/autotailor/accessories/work/medkit
	materials = list(MATERIAL_PLASTIC = 2 SHEETS)
/datum/design/item/autotailor/accessories/work/medkit/medkit_white
	name = "White medical kit"
	id = "medkit_white"
	build_path = /obj/item/weapon/storage/firstaid

/datum/design/item/autotailor/accessories/work/medkit/medkit_brown
	name = "Brown medical kit"
	id = "medkit_brown"
	build_path = /obj/item/weapon/storage/firstaid/combat

/datum/design/item/autotailor/accessories/work/medkit/medkit_red
	name = "Red medical kit"
	id = "medkit_red"
	build_path = /obj/item/weapon/storage/firstaid/adv

/datum/design/item/autotailor/accessories/work/medkit/medkit_blue
	name = "Blue medical kit"
	id = "medkit_blue"
	build_path = /obj/item/weapon/storage/firstaid/o2

/datum/design/item/autotailor/accessories/work/medkit/medkit_yellow
	name = "Yellow medical kit"
	id = "medkit_yellow"
	build_path = /obj/item/weapon/storage/firstaid/fire

/datum/design/item/autotailor/accessories/work/medkit/medkit_green
	name = "Green medical kit"
	id = "medkit_green"
	build_path = /obj/item/weapon/storage/firstaid/toxin

/datum/design/item/autotailor/accessories/work/pills
	name = "Pill bottle"
	id = "pills"
	build_path = /obj/item/weapon/storage/pill_bottle
	materials = list(MATERIAL_PLASTIC = 0.1 SHEETS)

/datum/design/item/autotailor/accessories/work/vials
	name = "Vial storage box"
	id = "vials"
	build_path = /obj/item/weapon/storage/fancy/vials
	materials = list(MATERIAL_PLASTIC = 2 SHEETS)

/datum/design/item/autotailor/accessories/work/vials_locked
	name = "Vial storage lockbox"
	id = "vials_locked"
	build_path = /obj/item/weapon/storage/lockbox/vials
	materials = list(MATERIAL_PLASTIC = 2 SHEETS, MATERIAL_SILVER = 2 SHEET)

/datum/design/item/autotailor/accessories/work/briefcase_grey
	name = "Grey briefcase"
	id = "briefcase_grey"
	build_path = /obj/item/weapon/storage/briefcase/crimekit
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_LEATHER = 1 SHEET)

/datum/design/item/autotailor/accessories/work/briefcase_brown
	name = "Brown briefcase"
	id = "briefcase_brown"
	build_path = /obj/item/weapon/storage/briefcase
	materials = list(MATERIAL_LEATHER = 2 SHEETS, MATERIAL_STEEL = 1 SHEET)

/datum/design/item/autotailor/accessories/work/briefcase_inflate
	name = "Inflatables briefcase"
	id = "briefcase_inflate"
	build_path = /obj/item/weapon/storage/briefcase/inflatable
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_LEATHER = 1 SHEET)

/datum/design/item/autotailor/accessories/work/securecase_black
	name = "Black secure briefcase"
	id = "securecase_black"
	build_path = /obj/item/weapon/storage/secure/briefcase
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_LEATHER = 2 SHEETS, MATERIAL_SILVER = 2 SHEETS)

/datum/design/item/autotailor/accessories/work/plantbag
	name = "Plant carrybag"
	id = "plantbag"
	build_path = /obj/item/weapon/storage/plants
	materials = list(MATERIAL_LEATHER = 2.5 SHEETS)

/datum/design/item/autotailor/accessories/work/orebag
	name = "Ore carrybag"
	id = "orebag"
	build_path = /obj/item/weapon/storage/ore
	materials = list(MATERIAL_LEATHER = 2.5 SHEETS)

/datum/design/item/autotailor/accessories/work/artebag
	name = "Fossile carrybag"
	id = "artebag"
	build_path = /obj/item/weapon/storage/bag/fossils
	materials = list(MATERIAL_LEATHER = 2.5 SHEETS)

/datum/design/item/autotailor/accessories/work/fossilpickbag
	name = "Excavation pick carrybag"
	id = "fossilpickbag"
	build_path = /obj/item/weapon/storage/excavation
	materials = list(MATERIAL_LEATHER = 2.5 SHEETS)

/datum/design/item/autotailor/accessories/work/mineral_coverabag
	name = "Material coverbag"
	id = "mineral_coverbag"
	build_path = /obj/item/weapon/storage/sheetsnatcher
	materials = list(MATERIAL_LEATHER = 2.5 SHEETS)

//
//Misc storage
//
/datum/design/item/autotailor/accessories/gen
	category = "General storage containers"
	materials = list(MATERIAL_CARDBOARD = 1000)

/datum/design/item/autotailor/accessories/gen/wallet_multi	//can use custom colors
	name = "Polychromatic wallet"
	id = "wallet_white"
	build_path = /obj/item/weapon/storage/wallet/poly
	materials = list(MATERIAL_LEATHER = 1.5 SHEET, MATERIAL_PHORON = 0.25 SHEETS)

/datum/design/item/autotailor/accessories/gen/wallet_leather
	name = "Leather wallet"
	id = "wallet_leather"
	build_path = /obj/item/weapon/storage/wallet/leather
	materials = list(MATERIAL_LEATHER = 1 SHEET)

/datum/design/item/autotailor/accessories/gen/cardb_box
	name = "Cardboard box"
	id = "cardb_box"
	build_path = /obj/item/weapon/storage/box
	materials = list(MATERIAL_CARDBOARD = 2000)	//if we remove handcrafting deconstruction we can make this cheaper

/datum/design/item/autotailor/accessories/gen/eggs
	name = "Egg carton"
	id = "eggs"
	build_path = /obj/item/weapon/storage/fancy/egg_box/empty

/datum/design/item/autotailor/accessories/gen/plast_bag	//can use custom colors, maybe
	name = "Small plastic bag"
	id = "plast_bag"
	build_path = /obj/item/weapon/storage/bag/plasticbag
	materials = list(MATERIAL_PLASTIC = 1 SHEET)

/datum/design/item/autotailor/accessories/gen/trash_bag
	name = "Trash bag"
	id = "trash_bag"
	build_path = /obj/item/weapon/storage/bag/trash
	materials = list(MATERIAL_PLASTIC = 2.5 SHEETS)

/datum/design/item/autotailor/accessories/gen/brown_bag
	name = "Leather bag"
	id = "brown_bag"
	build_path = /obj/item/weapon/storage/backpack/leathersack
	materials = list(MATERIAL_LEATHER = 5 SHEETS)

/datum/design/item/autotailor/accessories/gen/cash
	name = "Money bag"
	id = "cash"
	build_path = /obj/item/weapon/storage/bag/cash
	materials = list(MATERIAL_LEATHER = 2.5 SHEETS)

/datum/design/item/autotailor/accessories/gen/lunchbox_bl_red
	name = "Black & red lunchbox"
	id = "lunchbox_bl_red"
	build_path = /obj/item/weapon/storage/lunchbox/syndicate
	materials = list(MATERIAL_STEEL = 0.5 SHEETS)

/datum/design/item/autotailor/accessories/gen/lunchbox_hearts
	name = "Pink hearts lunchbox"
	id = "lunchbox_hearts"
	build_path = /obj/item/weapon/storage/lunchbox/heart
	materials = list(MATERIAL_STEEL = 0.5 SHEETS)

/datum/design/item/autotailor/accessories/gen/lunchbox_cats
	name = "Green cat lunchbox"
	id = "lunchbox_cats"
	build_path = /obj/item/weapon/storage/lunchbox/cat
	materials = list(MATERIAL_STEEL = 2000)

/datum/design/item/autotailor/accessories/gen/lunchbox_cricket
	name = "Diona nymph lunchbox"
	id = "lunchbox_cricket"
	build_path = /obj/item/weapon/storage/lunchbox/nymph
	materials = list(MATERIAL_STEEL = 0.5 SHEETS)

/datum/design/item/autotailor/accessories/gen/lunchbox_rainbow
	name = "Rainbow lunchbox"
	id = "lunchbox_rainbow"
	build_path = /obj/item/weapon/storage/lunchbox
	materials = list(MATERIAL_STEEL = 2000)

/datum/design/item/autotailor/accessories/gen/lunchbox_tf
	name = "TF lunchbox"
	id = "lunchbox_tcc"
	build_path = /obj/item/weapon/storage/lunchbox/tf
	materials = list(MATERIAL_STEEL = 2000)

/datum/design/item/autotailor/accessories/gen/lunchbox_cti
	name = "CTI lunchbox"
	id = "lunchbox_cti"
	build_path = /obj/item/weapon/storage/lunchbox/cti
	materials = list(MATERIAL_STEEL = 2000)

/datum/design/item/autotailor/accessories/gen/lunchbox_mu
	name = "MU lunchbox"
	id = "lunchbox_mu"
	build_path = /obj/item/weapon/storage/lunchbox/mars
	materials = list(MATERIAL_STEEL = 2000)

/datum/design/item/autotailor/accessories/gen/lunchbox_nt
	name = "Nt lunchbox"
	id = "lunchbox_nt"
	build_path = /obj/item/weapon/storage/lunchbox/nt
	materials = list(MATERIAL_STEEL = 2000)

/datum/design/item/autotailor/accessories/gen/cig_generic
	name = "Generic cigarette cart"
	id = "cig_"
	build_path = /obj/item/weapon/storage/fancy/cigarettes/blank

/datum/design/item/autotailor/accessories/gen/cig_lgreen
	name = "Light green cigarette cart"
	id = "cig_lgreen"
	build_path = /obj/item/weapon/storage/fancy/cigarettes/menthols/blank

/datum/design/item/autotailor/accessories/gen/cig_green
	name = "Green cigarette cart"
	id = "cig_green"
	build_path = /obj/item/weapon/storage/fancy/cigarettes/carcinomas/blank

/datum/design/item/autotailor/accessories/gen/cig_lgrey
	name = "Light grey cigarette cart"
	id = "cig_lgrey"
	build_path = /obj/item/weapon/storage/fancy/cigarettes/professionals/blank

/datum/design/item/autotailor/accessories/gen/cig_grey
	name = "Grey cigarette cart"
	id = "cig_grey"
	build_path = /obj/item/weapon/storage/fancy/cigarettes/jerichos/blank

/datum/design/item/autotailor/accessories/gen/cig_red
	name = "Red cigarette cart"
	id = "cig_red"
	build_path = /obj/item/weapon/storage/fancy/cigarettes/dromedaryco/blank

/datum/design/item/autotailor/accessories/gen/cig_blue
	name = "Blue cigarette cart"
	id = "cig_blue"
	build_path = /obj/item/weapon/storage/fancy/cigarettes/killthroat/blank

/datum/design/item/autotailor/accessories/gen/cig_gold
	name = "Gold cigarette cart"
	id = "cig_gold"
	build_path = /obj/item/weapon/storage/fancy/cigarettes/luckystars/blank

/datum/design/item/autotailor/accessories/gen/cig_gar
	name = "Fancy cigar case"
	id = "cig_gar"
	build_path = /obj/item/weapon/storage/fancy/cigar/blank
	materials = list(MATERIAL_LEATHER = 10000)

/datum/design/item/autotailor/accessories/gen/photo
	name = "Photo album"
	id = "photo"
	build_path = /obj/item/weapon/storage/photo_album
	materials = list(MATERIAL_LEATHER = 5000)

/datum/design/item/autotailor/accessories/gen/candle
	name = "Candle box"
	id = "candle"
	build_path = /obj/item/weapon/storage/fancy/candle_box

/datum/design/item/autotailor/accessories/gen/crayons
	name = "Crayon box"
	id = "crayons"
	build_path = /obj/item/weapon/storage/fancy/crayons/blank
