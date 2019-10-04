/obj/machinery/fabricator/general_fabricator
	// Things that must be adjusted for each fabricator
	name = "General Fabricator" // Self-explanatory
	desc = "A general purpose fabricator that can produce a variety of simple equipment." // Self-explanatory
	circuit_type = /obj/item/weapon/circuitboard/fabricator/genfab // Circuit for the machine. These, as well as their designs, should be defined in fabricator_circuits.dm
	build_type = GENERALFAB // The identifer for what gets built in what fabricator. A new one *MUST* be defined in _defines/research.dm for each fabricator.
						  // More than one can be assigned per design, however, if you want something to be able to be built in more than one fabricator eg. Power Cells
							// Determines if a sheet loading animation will be applied when loading metals. If you're using a non-standard icon and don't
										// want to sprite a new loading animation as well, set this to FALSE.

	has_reagents = FALSE				// Defaults to FALSE, but added here for explanation. If this is set to true, than you require designs to use reagents
										// in addition to any material costs.
	icon_state = 	 "circuitfab-idle"
	icon_idle = 	 "circuitfab-idle"
	icon_open = 	 "circuitfab-o"
	overlay_active = "circuitfab-active"
	metal_load_anim = FALSE

/obj/machinery/fabricator/general_fabricator/can_connect(var/datum/world_faction/trying, var/mob/M)
	var/datum/machine_limits/limits = trying.get_limits()
	if(M && !has_access(list(core_access_machine_linking), list(), M.GetAccess(trying.uid)))
		to_chat(M, "You do not have access to link machines to [trying.name].")
		return 0
	if(limits.limit_genfab <= limits.genfabs.len)
		if(M)
			to_chat(M, "[trying.name] cannot connect any more machines of this type.")
		return 0
	limits.genfabs |= src
	req_access_faction = trying.uid
	connected_faction = trying

/obj/machinery/fabricator/general_fabricator/can_disconnect(var/datum/world_faction/trying, var/mob/M)
	var/datum/machine_limits/limits = trying.get_limits()
	limits.genfabs -= src
	req_access_faction = ""
	connected_faction = null
	if(M) to_chat(M, "The machine has been disconnected.")


////////////////////////////////////////////////////
//////////////////////DESIGNS///////////////////////
////////////////////////////////////////////////////

/datum/design/item/genfab
	build_type = GENERALFAB 			   // This must match the build_type of the fabricator(s)
	category = "Misc"	 			   // The design will appear under this in the UI. Each design must have a category, or it will not display properly.

	time = 10						   // Time in seconds for the item to be produced - This changes based off the components used in the fabricator


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CONTAINERS
/datum/design/item/genfab/container
	category = "Containers"
	materials = list(MATERIAL_GLASS = 0.1 SHEET)
	build_type = list(GENERALFAB, MEDICALFAB, CONSUMERFAB)

/datum/design/item/genfab/container/sci
	build_type = list(MEDICALFAB)
/datum/design/item/genfab/container/catering
	materials = list(MATERIAL_GLASS = 0.2 SHEET) // these catering bottles are larger and more elaborate

//////////////////////////////////////////////////////////////////////////////////////////////////

//
//Bottles
//
/datum/design/item/genfab/container/catering
	build_type = SERVICEFAB
/datum/design/item/genfab/container/catering/bottle/gin
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/gin/empty

/datum/design/item/genfab/container/catering/bottle/whiskey
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey/empty

/datum/design/item/genfab/container/catering/bottle/specialwhiskey
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/specialwhiskey/empty

/datum/design/item/genfab/container/catering/bottle/vodka
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/vodka/empty

/datum/design/item/genfab/container/catering/bottle/premiumvodka
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/premiumvodka/empty

/datum/design/item/genfab/container/catering/bottle/tequilla
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/tequilla/empty

/datum/design/item/genfab/container/catering/bottle/bottleofnothing
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/bottleofnothing/empty

/datum/design/item/genfab/container/catering/bottle/patron
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/patron/empty

/datum/design/item/genfab/container/catering/bottle/rum
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/rum/empty

/datum/design/item/genfab/container/catering/bottle/tequilla
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/tequilla/empty

/datum/design/item/genfab/container/catering/bottle/vermouth
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/vermouth/empty

/datum/design/item/genfab/container/catering/bottle/kahlua
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/kahlua/empty

/datum/design/item/genfab/container/catering/bottle/goldschlager
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/goldschlager/empty

/datum/design/item/genfab/container/catering/bottle/cognac
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/cognac/empty

/datum/design/item/genfab/container/catering/bottle/wine
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/wine/empty

/datum/design/item/genfab/container/catering/bottle/premiumwine
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/premiumwine/empty

/datum/design/item/genfab/container/catering/bottle/absinthe
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/absinthe/empty

/datum/design/item/genfab/container/catering/bottle/melonliquor
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/melonliquor/empty

/datum/design/item/genfab/container/catering/bottle/bluecuracao
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/bluecuracao/empty

/datum/design/item/genfab/container/catering/bottle/herbal
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/herbal/empty

/datum/design/item/genfab/container/catering/bottle/grenadine
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/grenadine/empty

/datum/design/item/genfab/container/catering/bottle/cola
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/cola/empty

/datum/design/item/genfab/container/catering/bottle/space_up
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/space_up/empty

/datum/design/item/genfab/container/catering/bottle/space_mountain_wind
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/space_mountain_wind/empty

/datum/design/item/genfab/container/catering/bottle/pwine
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/pwine/empty
	name = "bottle of wine (skull label)"

/datum/design/item/genfab/container/catering/bottle/oiljug
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/oiljug/empty

//
//Condiment Bottles
//
/datum/design/item/genfab/container/catering/condiment
	materials = list(MATERIAL_PLASTIC = 0.1 SHEETS)
	build_path = /obj/item/weapon/reagent_containers/food/condiment

/datum/design/item/genfab/container/catering/condiment/enzyme
	build_path = /obj/item/weapon/reagent_containers/food/condiment/enzyme/empty
/datum/design/item/genfab/container/catering/condiment/barbecue
	build_path = /obj/item/weapon/reagent_containers/food/condiment/barbecue/empty
/datum/design/item/genfab/container/catering/condiment/sugar
	build_path = /obj/item/weapon/reagent_containers/food/condiment/sugar/empty
/datum/design/item/genfab/container/catering/condiment/ketchup
	build_path = /obj/item/weapon/reagent_containers/food/condiment/ketchup/empty
/datum/design/item/genfab/container/catering/condiment/cornoil
	build_path = /obj/item/weapon/reagent_containers/food/condiment/cornoil/empty
/datum/design/item/genfab/container/catering/condiment/vinegar
	build_path = /obj/item/weapon/reagent_containers/food/condiment/vinegar/empty
/datum/design/item/genfab/container/catering/condiment/mayo
	build_path = /obj/item/weapon/reagent_containers/food/condiment/mayo/empty
/datum/design/item/genfab/container/catering/condiment/frostoil
	build_path = /obj/item/weapon/reagent_containers/food/condiment/frostoil/empty
/datum/design/item/genfab/container/catering/condiment/capsaicin
	build_path = /obj/item/weapon/reagent_containers/food/condiment/capsaicin/empty

/datum/design/item/genfab/container/catering/condiment/small
	materials = list(MATERIAL_PLASTIC = 0.05 SHEETS)
	build_path = /obj/item/weapon/reagent_containers/food/condiment/small/empty
/datum/design/item/genfab/container/catering/condiment/small/saltshaker
	build_path = /obj/item/weapon/reagent_containers/food/condiment/small/saltshaker/empty
/datum/design/item/genfab/container/catering/condiment/small/peppermill
	build_path = /obj/item/weapon/reagent_containers/food/condiment/small/peppermill/empty
/datum/design/item/genfab/container/catering/condiment/small/sugar
	build_path = /obj/item/weapon/reagent_containers/food/condiment/small/sugar/empty

//
//Cartons
//
/datum/design/item/genfab/container/catering/carton
	materials = list(MATERIAL_CARDBOARD = 0.1 SHEETS)

/datum/design/item/genfab/container/catering/carton/orangejuice
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/orangejuice/empty

/datum/design/item/genfab/container/catering/carton/cream
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/cream/empty

/datum/design/item/genfab/container/catering/carton/tomatojuice
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/tomatojuice/empty

/datum/design/item/genfab/container/catering/carton/limejuice
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/limejuice/empty

/datum/design/item/genfab/container/catering/carton/milk
	build_path = /obj/item/weapon/reagent_containers/food/drinks/milk/empty

/datum/design/item/genfab/container/catering/carton/milk/smallcarton
	materials = list(MATERIAL_CARDBOARD = 0.05 SHEETS)
	build_path = /obj/item/weapon/reagent_containers/food/drinks/milk/smallcarton/empty

/datum/design/item/genfab/container/catering/carton/milk/smallcarton/chocolate
	build_path = /obj/item/weapon/reagent_containers/food/drinks/milk/smallcarton/chocolate/empty

/datum/design/item/genfab/container/catering/carton/soymilk
	build_path = /obj/item/weapon/reagent_containers/food/drinks/soymilk/empty

//
//Small Bottles
//
/datum/design/item/genfab/container/catering/bottle/small
	materials = list(MATERIAL_GLASS = 0.1 SHEETS)

/datum/design/item/genfab/container/catering/bottle/small/beer
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/small/beer/empty

/datum/design/item/genfab/container/catering/bottle/small/ale
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/small/ale/empty


//
//Sci stuff
//
/datum/design/item/genfab/container/sci/spraybottle
	build_path = /obj/item/weapon/reagent_containers/spray

/datum/design/item/genfab/container/sci/chem_disp_cartridge
	build_path = /obj/item/weapon/reagent_containers/chem_disp_cartridge


/datum/design/item/genfab/container/sci/bucket
	build_path = /obj/item/weapon/reagent_containers/glass/bucket

/datum/design/item/genfab/container/glassjar
	build_path = /obj/item/glass_jar

/datum/design/item/genfab/container/jar
	build_path = /obj/item/weapon/reagent_containers/food/drinks/jar

/datum/design/item/genfab/container/sci/beaker
	build_path = /obj/item/weapon/reagent_containers/glass/beaker

/datum/design/item/genfab/container/sci/beaker_large
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/large

/datum/design/item/genfab/container/sci/vial
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/vial

/datum/design/item/genfab/container/sci/pillbottle
	build_path = /obj/item/weapon/storage/pill_bottle
	materials = list(MATERIAL_PLASTIC = 0.1 SHEET)

/datum/design/item/genfab/container/sci/syringe
	build_path = /obj/item/weapon/reagent_containers/syringe

/datum/design/item/genfab/container/beerkeg
	build_path = /obj/structure/reagent_dispensers/beerkeg/empty
	materials = list(MATERIAL_ALUMINIUM = 20 SHEET)

/datum/design/item/genfab/container/pitcher
	build_path = /obj/item/weapon/reagent_containers/food/drinks/pitcher

/datum/design/item/genfab/container/carafe
	build_path = /obj/item/weapon/reagent_containers/food/drinks/glass2/carafe

//------------
// CUPS
//------------
/datum/design/item/genfab/container/coffeecup
	research = "coffeecups"
	build_type = list(CONSUMERFAB, SERVICEFAB)
	materials = list(MATERIAL_PLASTIC = 0.2 SHEETS)
/datum/design/item/genfab/container/coffeecup/simple
	research = null
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup
	build_type = list(CONSUMERFAB, SERVICEFAB, GENERALFAB)
/datum/design/item/genfab/container/coffeecup/simple/black
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup/black

/datum/design/item/genfab/container/coffeecup/simple/green
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup/green

/datum/design/item/genfab/container/coffeecup/tall
	materials = list(MATERIAL_PLASTIC = 0.4 SHEETS)
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup/tall

/datum/design/item/genfab/container/coffeecup/heart
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup/heart

/datum/design/item/genfab/container/coffeecup/metal
	materials = list(MATERIAL_ALUMINIUM = 0.2 SHEETS)
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup/metal

/datum/design/item/genfab/container/coffeecup/punitelli
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup/punitelli/empty

/datum/design/item/genfab/container/coffeecup/rainbow
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup/rainbow

/datum/design/item/genfab/container/coffeecup/NT
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup/NT

/datum/design/item/genfab/container/coffeecup/STC
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup/STC

/datum/design/item/genfab/container/coffeecup/SCG
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup/SCG

/datum/design/item/genfab/container/coffeecup/one
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup/one

/datum/design/item/genfab/container/coffeecup/pawn
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup/pawn

/datum/design/item/genfab/container/coffeecup/britcup
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup/britcup

/datum/design/item/genfab/container/coffeecup/diona
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup/diona

/datum/design/item/genfab/container/coffeecup/corp
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup/corp

/datum/design/item/genfab/container/coffeecup/golden_cup
	build_path = /obj/item/weapon/reagent_containers/food/drinks/golden_cup
	materials = list(MATERIAL_GOLD = 0.5 SHEET)

/datum/design/item/genfab/container/coffeecup/teacup
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffeecup/teacup
	materials = list(MATERIAL_SAND = 0.2 SHEETS)

/datum/design/item/genfab/container/coffeecup/teacup/tall
	build_path = /obj/item/weapon/reagent_containers/food/drinks/tea
	materials = list(MATERIAL_PLASTIC = 0.4 SHEETS)


//-------
//Glasses
//-------
/datum/design/item/genfab/container/drinkingglass
	build_type = list(CONSUMERFAB, SERVICEFAB)

/datum/design/item/genfab/container/drinkingglass
	build_path = /obj/item/weapon/reagent_containers/food/drinks/glass2/square
	build_type = list(CONSUMERFAB, SERVICEFAB, GENERALFAB)
/datum/design/item/genfab/container/drinkingglass/rocks
	build_path = /obj/item/weapon/reagent_containers/food/drinks/glass2/rocks

/datum/design/item/genfab/container/drinkingglass/shake
	build_path = /obj/item/weapon/reagent_containers/food/drinks/glass2/shake

/datum/design/item/genfab/container/drinkingglass/cocktail
	build_path = /obj/item/weapon/reagent_containers/food/drinks/glass2/cocktail

/datum/design/item/genfab/container/drinkingglass/shot
	build_path = /obj/item/weapon/reagent_containers/food/drinks/glass2/shot

/datum/design/item/genfab/container/drinkingglass/pint
	build_path = /obj/item/weapon/reagent_containers/food/drinks/glass2/pint

/datum/design/item/genfab/container/drinkingglass/mug
	build_path = /obj/item/weapon/reagent_containers/food/drinks/glass2/mug

/datum/design/item/genfab/container/drinkingglass/wine
	build_path = /obj/item/weapon/reagent_containers/food/drinks/glass2/wine

/datum/design/item/genfab/container/drinkingglass/plastic_cup
	build_path = /obj/item/weapon/reagent_containers/food/drinks/coffee/empty
	materials = list(MATERIAL_PLASTIC = 0.1 SHEET)

/datum/design/item/genfab/container/drinkingglass/plastic_cup/hotchoco
	build_path = /obj/item/weapon/reagent_containers/food/drinks/h_chocolate/empty

/datum/design/item/genfab/container/drinkingglass/paper_cup
	build_path = /obj/item/weapon/reagent_containers/food/drinks/sillycup
	materials = list(MATERIAL_WOOD = 0.1 SHEET)

//---------
//Others
//--------
/datum/design/item/genfab/container/drinkingglass/shaker
	build_path = /obj/item/weapon/reagent_containers/food/drinks/shaker
	materials = list(MATERIAL_ALUMINIUM = 0.45 SHEET)

/datum/design/item/genfab/container/drinkingglass/teapot
	build_path = /obj/item/weapon/reagent_containers/food/drinks/teapot
	materials = list(MATERIAL_STEEL = 0.5 SHEET)

/datum/design/item/genfab/container/drinkingglass/pitcher
	build_path = /obj/item/weapon/reagent_containers/food/drinks/pitcher
	materials = list(MATERIAL_STEEL = 0.25 SHEET)

//-------
//Flasks
//-------
/datum/design/item/genfab/container/drinkingglass/flask
	build_path = /obj/item/weapon/reagent_containers/food/drinks/flask
	materials = list(MATERIAL_ALUMINIUM = 0.2 SHEET)
	research = "flasks"
/datum/design/item/genfab/container/drinkingglass/flask/shiny
	build_path = /obj/item/weapon/reagent_containers/food/drinks/flask/shiny

/datum/design/item/genfab/container/drinkingglass/flask/lithium
	build_path = /obj/item/weapon/reagent_containers/food/drinks/flask/lithium

/datum/design/item/genfab/container/drinkingglass/flask/detflask
	build_path = /obj/item/weapon/reagent_containers/food/drinks/flask/detflask

/datum/design/item/genfab/container/drinkingglass/flask/barflask
	build_path = /obj/item/weapon/reagent_containers/food/drinks/flask/barflask

/datum/design/item/genfab/container/drinkingglass/flask/vacuumflask
	materials = list(MATERIAL_ALUMINIUM = 0.2 SHEET, MATERIAL_GLASS = 0.1 SHEET)
	build_path = /obj/item/weapon/reagent_containers/food/drinks/flask/vacuumflask

/datum/design/item/genfab/container/drinkingglass/flask/fitnessflask
	build_path = /obj/item/weapon/reagent_containers/food/drinks/glass2/fitnessflask

/datum/design/item/genfab/container/drinkingglass/flask/holyflask
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/holywater/empty

/datum/design/item/genfab/container/sci/pills
	build_path = /obj/item/weapon/reagent_containers/pill
	materials = list(MATERIAL_PLASTIC = 0.1 SHEET)


/datum/design/item/genfab/container/sci/beaker/noreact
	req_tech = list(TECH_MATERIAL = 2)
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_PHORON = 1 SHEET)
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/noreact
	research = "cryostasis_beaker"
/datum/design/item/genfab/container/sci/beaker/bluespace
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 6)
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_PHORON = 2 SHEETS, MATERIAL_DIAMOND = 1 SHEET)
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/bluespace
	research = "bluespace_beaker"


//-----------
//Soda Cans
//-----------
/datum/design/item/genfab/container/cans
	materials = list(MATERIAL_ALUMINIUM = 0.4 SHEETS)

/datum/design/item/genfab/container/cans/cola
	build_path = /obj/item/weapon/reagent_containers/food/drinks/cans/cola/empty

/datum/design/item/genfab/container/cans/waterbottle
	materials = list(MATERIAL_PLASTIC = 0.4 SHEETS)
	build_path = /obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle/empty

/datum/design/item/genfab/container/cans/space_mountain_wind
	build_path = /obj/item/weapon/reagent_containers/food/drinks/cans/space_mountain_wind/empty

/datum/design/item/genfab/container/cans/thirteenloko
	build_path = /obj/item/weapon/reagent_containers/food/drinks/cans/thirteenloko/empty

/datum/design/item/genfab/container/cans/dr_gibb
	build_path = /obj/item/weapon/reagent_containers/food/drinks/cans/dr_gibb/empty

/datum/design/item/genfab/container/cans/starkist
	build_path = /obj/item/weapon/reagent_containers/food/drinks/cans/starkist/empty

/datum/design/item/genfab/container/cans/space_up
	build_path = /obj/item/weapon/reagent_containers/food/drinks/cans/space_up/empty

/datum/design/item/genfab/container/cans/lemon_lime
	build_path = /obj/item/weapon/reagent_containers/food/drinks/cans/lemon_lime/empty

/datum/design/item/genfab/container/cans/iced_tea
	build_path = /obj/item/weapon/reagent_containers/food/drinks/cans/iced_tea/empty

/datum/design/item/genfab/container/cans/iced_tea
	build_path = /obj/item/weapon/reagent_containers/food/drinks/cans/iced_tea/empty

/datum/design/item/genfab/container/cans/iced_tea
	build_path = /obj/item/weapon/reagent_containers/food/drinks/cans/iced_tea/empty

/datum/design/item/genfab/container/cans/grape_juice
	build_path = /obj/item/weapon/reagent_containers/food/drinks/cans/grape_juice/empty

/datum/design/item/genfab/container/cans/tonic
	build_path = /obj/item/weapon/reagent_containers/food/drinks/cans/tonic/empty

/datum/design/item/genfab/container/cans/sodawater
	build_path = /obj/item/weapon/reagent_containers/food/drinks/cans/sodawater/empty

/datum/design/item/genfab/container/cans/syndicolax
	build_path = /obj/item/weapon/reagent_containers/food/drinks/cans/syndicolax/empty

/datum/design/item/genfab/container/cans/artbru
	build_path = /obj/item/weapon/reagent_containers/food/drinks/cans/artbru/empty

/datum/design/item/genfab/container/cans/syndicola
	build_path = /obj/item/weapon/reagent_containers/food/drinks/cans/syndicola/empty

/datum/design/item/genfab/container/cans/boda
	build_path = /obj/item/weapon/reagent_containers/food/drinks/glass2/square/boda/empty

/datum/design/item/genfab/container/cans/bodaplus
	build_path = /obj/item/weapon/reagent_containers/food/drinks/glass2/square/bodaplus/empty

/datum/design/item/genfab/container/cans/speer
	build_path = /obj/item/weapon/reagent_containers/food/drinks/cans/speer/empty

/datum/design/item/genfab/container/cans/ale
	build_path = /obj/item/weapon/reagent_containers/food/drinks/cans/ale/empty

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// COMPUTER EQUIPMENT

/datum/design/item/genfab/computer
	category = "Computer Equipment"

/datum/design/item/genfab/computer/adv


///////////////////////////////////////////////////////////////////////////////
// Hard drives
/datum/design/item/genfab/computer/disk/normal // tier 0
	name = "basic hard drive"
	materials = list(MATERIAL_STEEL = 1 SHEET, MATERIAL_COPPER = 1 SHEET)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/

/datum/design/item/genfab/computer/adv/disk/advanced // tier 1
	name = "advanced hard drive"
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_COPPER = 1.5 SHEET)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/advanced
	research = "computer_1"
/datum/design/item/genfab/computer/adv/disk/super // tier 2
	name = "super hard drive"
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_COPPER = 2 SHEETS, MATERIAL_SILVER = 0.5 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/super
	research = "computer_2"
/datum/design/item/genfab/computer/adv/disk/cluster // tier 3
	name = "cluster hard drive"
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_COPPER = 3 SHEETS, MATERIAL_SILVER = 2 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/cluster
	research = "computer_3"
/datum/design/item/genfab/computer/adv/disk/small // tier 0
	name = "small hard drive"
	materials = list(MATERIAL_STEEL = 0.5 SHEET, MATERIAL_COPPER = 0.75 SHEET)

	build_path = /obj/item/weapon/computer_hardware/hard_drive/small

/datum/design/item/genfab/computer/adv/disk/micro // tier 0
	name = "micro hard drive"
	materials = list(MATERIAL_STEEL = 0.5 SHEET, MATERIAL_COPPER = 1 SHEET)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/micro

// Card slot
/datum/design/item/genfab/computer/adv/cardslot // tier 0
	name = "RFID card slot"
	materials = list(MATERIAL_STEEL = 1 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/card_slot


// Nano printer
/datum/design/item/genfab/computer/adv/nanoprinter // tier 0
	name = "nano printer"
	materials = list(MATERIAL_STEEL = 1 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/nano_printer

// Tesla Link
/datum/design/item/genfab/computer/adv/teslalink // tier 0
	name = "tesla link"
	materials = list(MATERIAL_STEEL = 1 SHEETS, MATERIAL_COPPER = 1 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/tesla_link


/datum/design/item/genfab/computer/adv/reagent_scanner
	name = "reagent scanner module"
	materials = list(MATERIAL_STEEL = 1 SHEETS, MATERIAL_COPPER = 1 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/scanner/reagent

/datum/design/item/genfab/computer/adv/paper_scanner
	name = "paper scanner module"
	materials = list(MATERIAL_STEEL = 1 SHEETS, MATERIAL_COPPER = 1 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/scanner/paper

/datum/design/item/genfab/computer/adv/atmos_scanner
	name = "atmospheric scanner module"
	materials = list(MATERIAL_STEEL = 1 SHEETS, MATERIAL_COPPER = 1 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/scanner/atmos

/datum/design/item/genfab/computer/adv/medical_scanner
	name = "medical scanner module"
	materials = list(MATERIAL_STEEL = 1 SHEETS, MATERIAL_COPPER = 1 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/scanner/medical

// Batteries
/datum/design/item/genfab/computer/adv/battery/normal // tier 0
	name = "standard battery module"
	materials = list(MATERIAL_STEEL = 1 SHEETS, MATERIAL_COPPER = 1 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/battery_module

/datum/design/item/genfab/computer/adv/battery/advanced // tier 1
	name = "advanced battery module"
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_COPPER = 2 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/battery_module/advanced
	research = "computer_1"
/datum/design/item/genfab/computer/adv/battery/super // tier 2
	name = "super battery module"
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_COPPER = 3 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/battery_module/super
	research = "computer_2"
/datum/design/item/genfab/computer/adv/battery/ultra // tier 3
	name = "ultra battery module"
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_COPPER = 4 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/battery_module/ultra
	research = "computer_3"
/datum/design/item/genfab/computer/battery/nano // tier 0
	name = "nano battery module"
	materials = list(MATERIAL_STEEL = 0.5 SHEETS, MATERIAL_COPPER = 0.5 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/battery_module/nano

/datum/design/item/genfab/computer/adv/micro // tier 0
	name = "micro battery module"
	materials = list(MATERIAL_STEEL = 0.5 SHEETS, MATERIAL_COPPER = 0.5 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/battery_module/micro

/**
/datum/design/item/genfab/computer/adv/logistic_processor
	name = "Advanced Logistic Processor"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 4)
	materials = list(MATERIAL_STEEL = 5000, MATERIAL_GLASS = 1000, MATERIAL_PHORON = 3000, MATERIAL_DIAMOND = 3000, MATERIAL_URANIUM = 3000)
	build_path = /obj/item/weapon/computer_hardware/logistic_processor


/datum/design/item/genfab/computer/adv/dna_scanner // tier 0
 	name = "DNA scanner port"
 	materials = list(MATERIAL_STEEL = 01 SHEETS, MATERIAL_COPPER = 0.5 SHEETS)
 	build_path = /obj/item/weapon/computer_hardware/dna_scanner
**/



// Processor unit
/datum/design/item/genfab/computer/cpu/
	name = "computer processor unit"
	id = "cpu_normal"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 1600)
	build_path = /obj/item/weapon/computer_hardware/processor_unit

/datum/design/item/genfab/computer/cpu/small
	name = "computer microprocessor unit"
	id = "cpu_small"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_COPPER = 5 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/processor_unit/small

/datum/design/item/genfab/computer/adv/cpu/photonic
	name = "computer photonic processor unit"
	id = "pcpu_normal"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 4)
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_COPPER = 5 SHEETS, MATERIAL_PHORON = 1 SHEET)
	build_path = /obj/item/weapon/computer_hardware/processor_unit/photonic

/datum/design/item/genfab/computer/adv/cpu/photonic/small
	name = "computer photonic microprocessor unit"
	id = "pcpu_small"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3)
	materials = list(MATERIAL_STEEL = 2, MATERIAL_COPPER = 2 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/processor_unit/photonic/small

/datum/design/item/genfab/computer/netcard/basic
	name = "basic network card"
	id = "netcard_basic"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 1)
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_COPPER = 1 SHEET)
	build_path = /obj/item/weapon/computer_hardware/network_card

/datum/design/item/genfab/computer/adv/netcard/advanced
	name = "advanced network card"
	id = "netcard_advanced"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_COPPER = 2 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/network_card/advanced

/datum/design/item/genfab/computer/adv/netcard/wired
	name = "wired network card"
	id = "netcard_wired"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 3)
	materials = list(MATERIAL_STEEL = 5 SHEETS, MATERIAL_COPPER = 5 SHEETS)
	build_path = /obj/item/weapon/computer_hardware/network_card/wired

// /datum/design/item/genfab/computer/adv/pda
// 	name = "PDA design"
// 	desc = "Cheaper than whiny non-digital assistants."
// 	req_tech = list(TECH_ENGINEERING = 2, TECH_POWER = 3)
// 	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_GLASS = 1 SHEET, MATERIAL_COPPER = 1.5 SHEETS)
// 	build_path = /obj/item/modular_computer/pda
// 	research = "computer_1"
// Cartridges
/**
/datum/design/item/genfab/computer/adv/pda_cartridge
	req_tech = list(TECH_ENGINEERING = 2, TECH_POWER = 3)
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50)

/datum/design/item/genfab/computer/adv/pda_cartridge/AssembleDesignName()
	..()
	name = "PDA accessory ([item_name])"

/datum/design/item/genfab/computer/adv/cart_basic
	id = "cart_basic"
	build_path = /obj/item/weapon/cartridge
	sort_string = "VBAAA"

/datum/design/item/genfab/computer/adv/engineering
	id = "cart_engineering"
	build_path = /obj/item/weapon/cartridge/engineering
	sort_string = "VBAAB"

/datum/design/item/genfab/computer/adv/atmos
	id = "cart_atmos"
	build_path = /obj/item/weapon/cartridge/atmos
	sort_string = "VBAAC"

/datum/design/item/genfab/computer/adv/medical
	id = "cart_medical"
	build_path = /obj/item/weapon/cartridge/medical
	sort_string = "VBAAD"

/datum/design/item/genfab/computer/adv/chemistry
	id = "cart_chemistry"
	build_path = /obj/item/weapon/cartridge/chemistry
	sort_string = "VBAAE"

/datum/design/item/genfab/computer/adv/security
	id = "cart_security"
	build_path = /obj/item/weapon/cartridge/security
	sort_string = "VBAAF"

/datum/design/item/genfab/computer/adv/janitor
	id = "cart_janitor"
	build_path = /obj/item/weapon/cartridge/janitor
	sort_string = "VBAAG"

/datum/design/item/genfab/computer/adv/science
	id = "cart_science"
	build_path = /obj/item/weapon/cartridge/signal/science
	sort_string = "VBAAH"

/datum/design/item/genfab/computer/adv/quartermaster
	id = "cart_quartermaster"
	build_path = /obj/item/weapon/cartridge/quartermaster
	sort_string = "VBAAI"

/datum/design/item/genfab/computer/adv/hop
	id = "cart_hop"
	build_path = /obj/item/weapon/cartridge/hop
	sort_string = "VBAAJ"

/datum/design/item/genfab/computer/adv/hos
	id = "cart_hos"
	build_path = /obj/item/weapon/cartridge/hos
	sort_string = "VBAAK"

/datum/design/item/genfab/computer/adv/ce
	id = "cart_ce"
	build_path = /obj/item/weapon/cartridge/ce
	sort_string = "VBAAL"

/datum/design/item/genfab/computer/adv/cmo
	id = "cart_cmo"
	build_path = /obj/item/weapon/cartridge/cmo
	sort_string = "VBAAM"

/datum/design/item/genfab/computer/adv/rd
	id = "cart_rd"
	build_path = /obj/item/weapon/cartridge/rd
	sort_string = "VBAAN"

/datum/design/item/genfab/computer/adv/captain
	id = "cart_captain"
	build_path = /obj/item/weapon/cartridge/captain
	sort_string = "VBAAO"
**/

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Communication Equipment

/datum/design/item/genfab/communication
	category = "Communication Equipment"


////////////////////////////////////////////////////////////////////

/datum/design/item/genfab/communication/radio_headset
	name = "radio headset"
	build_path = /obj/item/device/radio/headset
	materials = list(MATERIAL_STEEL = 0.5 SHEETS)

/datum/design/item/genfab/communication/radio_bounced
	name = "shortwave radio"
	build_path = /obj/item/device/radio/off
	materials = list(MATERIAL_STEEL = 0.5 SHEETS)

/datum/design/item/genfab/communication/taperecorder
	name = "tape recorder"
	build_path = /obj/item/device/taperecorder/empty
	materials = list(MATERIAL_STEEL = 1 SHEETS)

/datum/design/item/genfab/communication/camera_film
	name = "camera film"
	build_path = /obj/item/device/camera_film
	materials = list(MATERIAL_COPPER = 0.25 SHEETS)

/datum/design/item/genfab/communication/tape
	name = "tape recorder tape"
	build_path = /obj/item/device/tape
	materials = list(MATERIAL_STEEL = 0.5 SHEETS)

/datum/design/item/genfab/communication/camera
	name = "photo camera"
	build_path = /obj/item/device/camera/empty
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_COPPER = 0.25 SHEETS, MATERIAL_SILVER = 0.25 SHEETS)


/datum/design/item/genfab/communication/pen
	materials = list(MATERIAL_PLASTIC = 0.2 SHEETS)
/datum/design/item/genfab/communication/pen/blackpen
	name = "black ink pen"
	build_path = /obj/item/weapon/pen

/datum/design/item/genfab/communication/pen/bluepen
	name = "blue ink pen"
	build_path = /obj/item/weapon/pen/blue

/datum/design/item/genfab/communication/pen/redpen
	name = "red ink pen"
	build_path = /obj/item/weapon/pen/red

/datum/design/item/genfab/communication/pen/multipen // tier 1
	name = "multi-color ink pen"
	build_path = /obj/item/weapon/pen/multi
	materials = list(MATERIAL_PLASTIC = 0.2 SHEETS, MATERIAL_PHORON = 0.1 SHEETS)
	research = "color_comms_1"
/datum/design/item/genfab/communication/pen/crayon/red // tier 1
	name = "red crayon"
	build_path = /obj/item/weapon/pen/crayon/red
	research = "color_comms_1"
/datum/design/item/genfab/communication/pen/crayon/orange // tier 1
	name = "orange crayon"
	build_path = /obj/item/weapon/pen/crayon/orange
	research = "color_comms_1"
/datum/design/item/genfab/communication/pen/crayon/yellow // tier 1
	name = "yellow crayon"
	build_path = /obj/item/weapon/pen/crayon/yellow
	research = "color_comms_1"
/datum/design/item/genfab/communication/pen/crayon/green // tier 1
	name = "green crayon"
	build_path = /obj/item/weapon/pen/crayon/green
	research = "color_comms_1"
/datum/design/item/genfab/communication/pen/crayon/blue // tier 1
	name = "blue crayon"
	build_path = /obj/item/weapon/pen/crayon/blue
	research = "color_comms_1"
/datum/design/item/genfab/communication/pen/crayon/purple // tier 1
	name = "purple crayon"
	build_path = /obj/item/weapon/pen/crayon/purple
	research = "color_comms_1"
/datum/design/item/genfab/communication/pen/crayon/mime // tier 2
	name = "mime crayon"
	build_path = /obj/item/weapon/pen/crayon/mime
	materials = list(MATERIAL_PLASTIC = 0.2 SHEETS, MATERIAL_DIAMOND = 0.1 SHEETS)
	research = "color_comms_2"
/datum/design/item/genfab/communication/pen/crayon/rainbow // tier 2
	name = "rainbow crayon"
	build_path = /obj/item/weapon/pen/crayon/rainbow
	materials = list(MATERIAL_PLASTIC = 0.2 SHEETS, MATERIAL_PHORON = 0.1 SHEETS)
	research = "color_comms_2"

/datum/design/item/genfab/communication/clipboard
	name = "clipboard"
	build_path = /obj/item/weapon/material/clipboard
	materials = list(MATERIAL_WOOD = 0.05 SHEET)
/datum/design/item/genfab/communication/folder
	name = "grey folder"
	build_path = /obj/item/weapon/folder
	materials = list(MATERIAL_WOOD = 0.05 SHEET)
/datum/design/item/genfab/communication/folder/blue
	name = "blue folder"
	build_path = /obj/item/weapon/folder/blue
	materials = list(MATERIAL_WOOD = 0.05 SHEET)
/datum/design/item/genfab/communication/folder/red
	name = "red folder"
	build_path = /obj/item/weapon/folder/red
	materials = list(MATERIAL_WOOD = 0.05 SHEET)
/datum/design/item/genfab/communication/folder/yellow
	name = "yellow folder"
	build_path = /obj/item/weapon/folder/yellow
	materials = list(MATERIAL_WOOD = 0.05 SHEET)
/datum/design/item/genfab/communication/paper
	name = "sheet of paper"
	build_path = /obj/item/weapon/paper
	materials = list(MATERIAL_WOOD = 0.05 SHEET) // 20 papers per sheet
/datum/design/item/genfab/communication/paper/carbon
	name = "sheet of carbon paper"
	build_path = /obj/item/weapon/paper/carbon
	materials = list(MATERIAL_WOOD = 0.1 SHEET) // 10 papers per sheet

/datum/design/item/genfab/communication/paper/sticky
	name = "sticky notepad"
	build_path = /obj/item/sticky_pad/random
	materials = list(MATERIAL_WOOD = 0.1 SHEET) // 10 papers per sheet

/datum/design/item/genfab/communication/hand_labeler
	name = "hand labeler"
	build_path = /obj/item/weapon/hand_labeler

/datum/design/item/genfab/communication/paper_bin
	name = "paper bin"
	build_path = /obj/item/weapon/paper_bin
	materials = list(MATERIAL_STEEL = 1 SHEET)






/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Furniture
/datum/design/item/genfab/furniture
	category = "Furniture"

/////////////////////////////////////

/datum/design/item/genfab/furniture/lamp
	build_path = /obj/item/device/flashlight/lamp
	materials = list(MATERIAL_STEEL = 0.5 SHEETS, MATERIAL_GLASS = 0.25 SHEETS)

/datum/design/item/genfab/furniture/lamp/green
	build_path = /obj/item/device/flashlight/lamp/green
	materials = list(MATERIAL_STEEL = 0.5 SHEETS, MATERIAL_GLASS = 0.25 SHEETS)



/datum/design/item/genfab/furniture/ashtray_glass
	name = "glass ashtray"
	build_path = /obj/item/weapon/material/ashtray/glass
	materials = list(MATERIAL_GLASS = 0.25 SHEET)
/datum/design/item/genfab/furniture/ashtray_bronze
	name = "metal ashtray"
	build_path = /obj/item/weapon/material/ashtray/bronze
	materials = list(MATERIAL_STEEL = 0.25 SHEET)
/datum/design/item/genfab/furniture/ashtray_plastic
	name = "plastic ashtray"
	build_path = /obj/item/weapon/material/ashtray/plastic
	materials = list(MATERIAL_PLASTIC = 0.25 SHEET)

/datum/design/item/genfab/furniture/desklamp
	name = "desk lamp"
	build_path = /obj/item/device/flashlight/lamp
	materials = list(MATERIAL_STEEL = 0.25 SHEET)

/datum/design/item/genfab/furniture/floor_light
	name = "floor light"
	build_path = /obj/machinery/floor_light
	materials = list(MATERIAL_GLASS = 1 SHEET)


/datum/design/item/genfab/furniture/bedsheet
	build_path = /obj/item/weapon/bedsheet
	materials = list(MATERIAL_CLOTH = 1 SHEETS)

/datum/design/item/genfab/furniture/bedsheet/typed
	materials = list(MATERIAL_CLOTH = 1.25 SHEETS)

/datum/design/item/genfab/furniture/bedsheet/typed/blue
	name = "blue bedsheet"
	build_path = /obj/item/weapon/bedsheet/blue

/datum/design/item/genfab/furniture/bedsheet/typed/green
	name = "green bedsheet"
	build_path = /obj/item/weapon/bedsheet/green

/datum/design/item/genfab/furniture/bedsheet/typed/orange
	name = "orange bedsheet"
	build_path = /obj/item/weapon/bedsheet/orange

/datum/design/item/genfab/furniture/bedsheet/typed/purple
	name = "purple bedsheet"
	build_path = /obj/item/weapon/bedsheet/purple

/datum/design/item/genfab/furniture/bedsheet/typed/rainbow
	name = "rainbow bedsheet"
	build_path = /obj/item/weapon/bedsheet/rainbow

/datum/design/item/genfab/furniture/bedsheet/typed/red
	name = "red bedsheet"
	build_path = /obj/item/weapon/bedsheet/red

/datum/design/item/genfab/furniture/bedsheet/typed/yellow
	name = "yellow bedsheet"
	build_path = /obj/item/weapon/bedsheet/yellow

/datum/design/item/genfab/furniture/bedsheet/typed/mime
	name = "mime bedsheet"
	build_path = /obj/item/weapon/bedsheet/mime

/datum/design/item/genfab/furniture/bedsheet/typed/clown
	name = "clown bedsheet"
	build_path = /obj/item/weapon/bedsheet/clown

/datum/design/item/genfab/furniture/bedsheet/typed/captain
	name = "captain bedsheet"
	build_path = /obj/item/weapon/bedsheet/captain

/datum/design/item/genfab/furniture/bedsheet/typed/research
	name = "research bedsheet"
	build_path = /obj/item/weapon/bedsheet/rd

/datum/design/item/genfab/furniture/bedsheet/typed/medical
	name = "medical bedsheet"
	build_path = /obj/item/weapon/bedsheet/medical

/datum/design/item/genfab/furniture/bedsheet/typed/security
	name = "security bedsheet"
	build_path = /obj/item/weapon/bedsheet/hos

/datum/design/item/genfab/furniture/bedsheet/typed/hop
	name = "command bedsheet"
	build_path = /obj/item/weapon/bedsheet/hop

/datum/design/item/genfab/furniture/bedsheet/typed/ce
	name = "engineering bedsheet"
	build_path = /obj/item/weapon/bedsheet/ce

/datum/design/item/genfab/furniture/bedsheet/typed/brown
	name = "brown bedsheet"
	build_path = /obj/item/weapon/bedsheet/brown


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// SCIENCE EQUIPMENT


/datum/design/item/genfab/science
	category = "Science Equipment"

/datum/design/item/genfab/science/adv


/////////////////////////////////////////////

/datum/design/item/genfab/science/adv/ano_scanner
	name = "Alden-Saraspova counter"
	desc = "Aids in triangulation of exotic particles."
	req_tech = list(TECH_BLUESPACE = 3, TECH_MAGNET = 3)
	materials = list(MATERIAL_STEEL = 3 SHEETS,MATERIAL_GLASS = 2 SHEETS, MATERIAL_SILVER = 1 SHEET)
	build_path = /obj/item/device/ano_scanner

/datum/design/item/genfab/science/adv/core_sampler
	build_path = /obj/item/device/core_sampler

/datum/design/item/genfab/science/samplebags
	name = "box of sample bags."
	build_path = /obj/item/weapon/storage/box/evidence
	materials = list(MATERIAL_PLASTIC = 1.5 SHEET)


/**
/datum/design/item/genfab/science/adv/binaryencrypt
	name = "Binary encryption key"
	desc = "Allows for deciphering the binary channel on-the-fly."
	req_tech = list(TECH_ILLEGAL = 2)
	materials = list(MATERIAL_STEEL = 300, MATERIAL_GLASS = 300, MATERIAL_PHORON = 10000)
	build_path = /obj/item/device/encryptionkey/binary
**/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
