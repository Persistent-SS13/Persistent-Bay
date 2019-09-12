/obj/machinery/fabricator/consumer_fabricator
	// Things that must be adjusted for each fabricator
	name = "Consumer Goods Fabricator" // Self-explanatory
	desc = "A machine used for the production of a variety of consumer goods like furniture, toys, games ." // Self-explanatory
	circuit_type = /obj/item/weapon/circuitboard/fabricator/consumerfab // Circuit for the machine. These, as well as their designs, should be defined in fabricator_circuits.dm
	build_type = CONSUMERFAB // The identifer for what gets built in what fabricator. A new one *MUST* be defined in _defines/research.dm for each fabricator.
						 					 // More than one can be assigned per design, however, if you want something to be able to be built in more than one fabricator eg. Power Cells
	metal_load_anim = TRUE				// Determines if a sheet loading animation will be applied when loading metals. If you're using a non-standard icon and don't
										// want to sprite a new loading animation as well, set this to FALSE.

	has_reagents = FALSE				// Defaults to FALSE, but added here for explanation. If this is set to true, than you require designs to use reagents
										// in addition to any material costs.

/obj/machinery/fabricator/consumer_fabricator/can_connect(var/datum/world_faction/trying, var/mob/M)
	var/datum/machine_limits/limits = trying.get_limits()
	if(M && !has_access(list(core_access_machine_linking), list(), M.GetAccess(trying.uid)))
		to_chat(M, "You do not have access to link machines to [trying.name].")
		return 0
	if(limits.limit_consumerfab <= limits.consumerfabs.len)
		if(M)
			to_chat(M, "[trying.name] cannot connect any more machines of this type.")
		return 0
	limits.consumerfabs |= src
	req_access_faction = trying.uid
	connected_faction = trying

/obj/machinery/fabricator/consumer_fabricator/can_disconnect(var/datum/world_faction/trying, var/mob/M)
	var/datum/machine_limits/limits = trying.get_limits()
	if(limits)
		limits.consumerfabs -= src
	req_access_faction = ""
	connected_faction = null
	if(M) to_chat(M, "The machine has been disconnected.")

////////////////////////////////////////////////////
//////////////////////DESIGNS///////////////////////
////////////////////////////////////////////////////

//Voidsuits
/datum/design/item/consumerfab
	build_type = CONSUMERFAB 			   // This must match the build_type of the fabricator(s)
	category = "Misc"	 			   // The design will appear under this in the UI. Each design must have a category, or it will not display properly.
	req_tech = list(TECH_MATERIAL = 1) // The tech required for the design. Note that anything above 1 for *ANY* tech will require a RnD console for the item to be
									   // fabricated.
	time = 5						   // Time in seconds for the item to be produced - This changes based off the components used in the fabricator


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Consumer Goods

/datum/design/item/consumerfab/consumer
	category = "Consumer Goods"
	materials = list(MATERIAL_PLASTIC = 0.1 SHEETS)
/datum/design/item/consumerfab/consumer/toys
	category = "Toys"

/datum/design/item/consumerfab/consumer/games
	category = "Games"

/datum/design/item/consumerfab/consumer/recreation
	category = "Recreation"

/datum/design/item/consumerfab/consumer/Decoration
	category = "Decoration"
////////////////////////////////////////////////////////////////////

/datum/design/item/consumerfab/consumer/plastic_bag
	build_path = /obj/item/weapon/storage/bag/plasticbag
	materials = list(MATERIAL_PLASTIC = 0.5 SHEETS)

/datum/design/item/consumerfab/consumer/package_wrap_paper
	build_path = /obj/item/stack/package_wrap/twenty_five
	materials = list(MATERIAL_WOOD = 0.5 SHEETS)

/datum/design/item/consumerfab/consumer/wrapping_paper/gift
	build_path = /obj/item/weapon/wrapping_paper
	materials = list(MATERIAL_WOOD = 0.5 SHEETS)

/datum/design/item/consumerfab/consumer/latexballoon
	build_path = /obj/item/latexballon
	materials = list(MATERIAL_PLASTIC = 0.2 SHEETS)

/datum/design/item/consumerfab/consumer/bikehorn
	build_path = /obj/item/weapon/bikehorn
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_PLASTIC = 2 SHEETS)

/datum/design/item/consumerfab/consumer/poster
	build_path = /obj/item/weapon/contraband/poster
	materials = list(MATERIAL_PLASTIC = 1 SHEETS)

/datum/design/item/consumerfab/consumer/violin
	build_path = /obj/item/device/violin
	materials = list(MATERIAL_WOOD = 2.5 SHEETS, MATERIAL_STEEL = 1 SHEET, MATERIAL_COPPER = 1 SHEET)

/datum/design/item/consumerfab/consumer/guitar
	build_path = /obj/item/instrument/guitar
	materials = list(MATERIAL_WOOD = 1 SHEETS, MATERIAL_STEEL = 1 SHEET)

/datum/design/item/consumerfab/consumer/canvas
	build_path = /obj/item/frame/canvas/size_m
	materials = list(MATERIAL_WOOD = 1.5 SHEETS)
	build_type = list(CONSUMERFAB, SERVICEFAB)
/datum/design/item/consumerfab/consumer/canvas/portrait
	build_path = /obj/item/frame/canvas/size_m/portrait

/datum/design/item/consumerfab/consumer/canvas/landscape
	build_path = /obj/item/frame/canvas/size_m/landscape

/datum/design/item/consumerfab/consumer/basketball
	build_path = /obj/item/weapon/basketball
	materials = list(MATERIAL_PLASTIC = 1 SHEETS)

/datum/design/item/consumerfab/consumer/beach_ball
	build_path = /obj/item/weapon/beach_ball
	materials = list(MATERIAL_PLASTIC = 1 SHEETS)

/datum/design/item/consumerfab/consumer/megaphone
	build_path = /obj/item/device/megaphone
	materials = list(MATERIAL_STEEL = 2 SHEETS, MATERIAL_COPPER = 1 SHEET)

/datum/design/item/consumerfab/consumer/scissors
	build_path = /obj/item/weapon/tool/scissors
	materials = list(MATERIAL_ALUMINIUM = 500)
/datum/design/item/consumerfab/consumer/scissors/barber
	build_path = /obj/item/weapon/tool/scissors/barber
	materials = list(MATERIAL_STEEL = 800)
/datum/design/item/consumerfab/consumer/scissors/craft
	build_path = /obj/item/weapon/tool/scissors/craft
	materials = list(MATERIAL_PLASTIC = 500)

/datum/design/item/consumerfab/consumer/rsf // tier 3
	build_path = /obj/item/weapon/rsf
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_COPPER = 4 SHEETS, MATERIAL_GLASS = 4 SHEETS, MATERIAL_DIAMOND = 4 SHEETS, MATERIAL_PHORON = 2 SHEETS)

/datum/design/item/consumerfab/consumer/TVAssembly
	build_path = /obj/item/weapon/TVAssembly
	materials = list(MATERIAL_STEEL = 2 SHEETS)

/datum/design/item/consumerfab/consumer/towel
	build_path = /obj/item/weapon/towel
	materials = list(MATERIAL_CLOTH = 0.25 SHEETS)

/datum/design/item/consumerfab/consumer/mirror
	name = "hand mirror"
	build_path = /obj/item/weapon/mirror
	materials = list(MATERIAL_GLASS = 0.25 SHEETS, MATERIAL_STEEL = 0.25 SHEETS)

/datum/design/item/consumerfab/consumer/lighter
	name = "cheap lighter"
	build_path = /obj/item/weapon/flame/lighter/random
	materials = list(MATERIAL_PLASTIC = 0.25 SHEETS, MATERIAL_STEEL = 0.25 SHEETS)

/datum/design/item/consumerfab/consumer/lighter/zippo
	build_path = /obj/item/weapon/flame/lighter/zippo
	materials = list(MATERIAL_STEEL = 0.5 SHEETS, MATERIAL_SILVER = 0.5 SHEETS)

/datum/design/item/consumerfab/consumer/lighter/candle
	build_path = /obj/item/weapon/flame/candle
	materials = list(MATERIAL_PLASTIC = 0.25 SHEETS)

/datum/design/item/consumerfab/consumer/glowstick
	build_path = /obj/item/device/flashlight/flare/glowstick
	materials = list(MATERIAL_PLASTIC = 0.5 SHEETS, MATERIAL_COPPER = 0.15)

/datum/design/item/consumerfab/consumer/glowstick/red
	build_path = /obj/item/device/flashlight/flare/glowstick/red

/datum/design/item/consumerfab/consumer/glowstick/blue
	build_path = /obj/item/device/flashlight/flare/glowstick/blue

/datum/design/item/consumerfab/consumer/glowstick/orange
	build_path = /obj/item/device/flashlight/flare/glowstick/orange


/datum/design/item/consumerfab/consumer/glowstick/yellow
	build_path = /obj/item/device/flashlight/flare/glowstick/yellow

/datum/design/item/consumerfab/consumer/hollowbook
	name = "hollowed out book"
	build_path = /obj/item/weapon/storage/fakebook/empty
	materials = list(MATERIAL_PLASTIC = 1 SHEET, MATERIAL_WOOD = 1 SHEET)


/datum/design/item/consumerfab/consumer/labeler
	name = "hand labeler"
	build_path = /obj/item/weapon/hand_labeler
	materials = list(MATERIAL_PLASTIC = 1 SHEETS, MATERIAL_COPPER = 0.15)
/datum/design/item/consumerfab/consumer/ecigcartridge
	name = "ecigarette cartridge (empty)"
	build_path = /obj/item/weapon/reagent_containers/ecig_cartridge/blank
	materials = list(MATERIAL_STEEL = 0.1 SHEETS)
/datum/design/item/consumerfab/consumer/ecig
	// We get it, you vape
	name = "ecigarette"
	build_path = /obj/item/clothing/mask/smokable/ecig/lathed
	materials = list(MATERIAL_STEEL = 0.1 SHEETS)

/datum/design/item/consumerfab/consumer/cleaning
	category = "Cleaning Supplies"
	build_type = list(CONSUMERFAB, SERVICEFAB)


/datum/design/item/consumerfab/consumer/cleaning/trashcart
	build_path = /obj/structure/closet/crate/trashcart
	materials = list(MATERIAL_STEEL = 2 SHEETS)


/datum/design/item/consumerfab/consumer/cleaning/mop
	name = "mop"
	build_path = /obj/item/weapon/mop
	materials = list(MATERIAL_STEEL = 1.5 SHEETS, MATERIAL_CLOTH = 0.25 SHEETS)

/datum/design/item/consumerfab/consumer/cleaning/mop/advanced
	name = "advanced mop"
	build_path = /obj/item/weapon/mop/advanced
	materials = list(MATERIAL_ALUMINIUM = 4.5 SHEETS, MATERIAL_CLOTH = 1 SHEETS, MATERIAL_PHORON = 2)

/datum/design/item/consumerfab/consumer/cleaning/rag
	build_path = /obj/item/weapon/reagent_containers/glass/rag
	materials = list(MATERIAL_CLOTH = 0.5 SHEETS)

/datum/design/item/consumerfab/consumer/cleaning/laundry_basket
	build_path = /obj/item/weapon/storage/laundry_basket
	materials = list(MATERIAL_PLASTIC = 0.5 SHEETS)

/datum/design/item/consumerfab/consumer/cleaning/trash_bag
	build_path = /obj/item/weapon/storage/bag/trash
	materials = list(MATERIAL_PLASTIC = 1 SHEETS)

/datum/design/item/consumerfab/consumer/cleaning/wet_floor
	build_path = /obj/item/weapon/caution
	materials = list(MATERIAL_PLASTIC = 1 SHEETS)

/datum/design/item/consumerfab/consumer/cleaning/holowet
	name = "holographic wet sign projector"
	build_path = /obj/item/holosign_creator
	materials = list(MATERIAL_COPPER = 5 SHEETS, MATERIAL_ALUMINIUM = 10 SHEETS, MATERIAL_GOLD = 2 SHEETS, MATERIAL_PLASTIC = 5 SHEETS)

/datum/design/item/consumerfab/consumer/cleaning/mouestrap
	build_path = /obj/item/device/assembly/mousetrap
	materials = list(MATERIAL_STEEL = 0.25 SHEETS, MATERIAL_WOOD = 0.25 SHEETS)

/datum/design/item/consumerfab/consumer/cleaning/chemsprayer // tier 1
	materials = list(MATERIAL_STEEL = 3 SHEETS, MATERIAL_GLASS = 3 SHEETS, MATERIAL_SILVER = 1 SHEETS)
	build_path = /obj/item/weapon/reagent_containers/spray/chemsprayer

/datum/design/item/consumerfab/consumer/cleaning/ironingiron
	name = "ironing iron"
	materials = list(MATERIAL_ALUMINIUM = 1 SHEET, MATERIAL_COPPER = 1 SHEET)
	build_path = /obj/item/weapon/ironingiron

/datum/design/item/consumerfab/consumer/cleaning/ironingboard
	name = "ironing board"
	materials = list(MATERIAL_ALUMINIUM = 2 SHEET)
	build_path = /obj/item/roller/ironingboard

/datum/design/item/consumerfab/consumer/cleaning/janitorcart
	materials = list(MATERIAL_ALUMINIUM = 10 SHEET, MATERIAL_PLASTIC = 5)
	build_path = /obj/structure/janitorialcart

/datum/design/item/consumerfab/consumer/cleaning/plunger
	materials = list(MATERIAL_WOOD = 500, MATERIAL_PLASTIC = 250)
	build_path = /obj/item/clothing/mask/plunger


/datum/design/item/consumerfab/consumer/lipstick
	name = "red lipstick"
	build_path = /obj/item/weapon/lipstick
	materials = list(MATERIAL_PLASTIC = 0.25 SHEETS)
/datum/design/item/consumerfab/consumer/lipstick/purple
	name = "purple lipstick"
	build_path = /obj/item/weapon/lipstick/purple

/datum/design/item/consumerfab/consumer/lipstick/jade
	name = "jade lipstick"
	build_path = /obj/item/weapon/lipstick/jade

/datum/design/item/consumerfab/consumer/lipstick/black
	name = "black lipstick"
	build_path = /obj/item/weapon/lipstick/black

/datum/design/item/consumerfab/consumer/comb
	name = "comb"
	build_path = /obj/item/weapon/haircomb
	materials = list(MATERIAL_PLASTIC = 0.25 SHEETS)
/datum/design/item/consumerfab/consumer/picket_sign
	name = "Picket sign"
	build_path = /obj/item/weapon/picket_sign
	materials = list(MATERIAL_WOOD = 0.25 SHEETS)

/datum/design/item/consumerfab/consumer/water_flower
	name = "water flower"
	build_path = /obj/item/weapon/reagent_containers/spray/waterflower
	materials = list(MATERIAL_PLASTIC = 1 SHEETS)

//toys

/datum/design/item/consumerfab/consumer/toys/xmas_cracker
	materials = list(MATERIAL_PLASTIC = 0.5 SHEETS)
	build_path = /obj/item/weapon/toy/xmas_cracker




/datum/design/item/consumerfab/consumer/toys/prize // mecha figures
	category = "Figurines"
	materials = list(MATERIAL_PLASTIC = 0.25 SHEETS)




/datum/design/item/consumerfab/consumer/toys/prize/ripley // tier 0
	build_path = /obj/item/toy/prize/ripley

/datum/design/item/consumerfab/consumer/toys/prize/fireripley // tier 1
	build_path = /obj/item/toy/prize/fireripley
	research = "figures_1"

/datum/design/item/consumerfab/consumer/toys/prize/deathripley // tier 1
	build_path = /obj/item/toy/prize/deathripley
	research = "figures_1"
/datum/design/item/consumerfab/consumer/toys/prize/gygax // tier 1
	build_path = /obj/item/toy/prize/gygax
	research = "figures_1"
/datum/design/item/consumerfab/consumer/toys/prize/durand //tier 2
	build_path = /obj/item/toy/prize/durand
	research = "figures_2"
/datum/design/item/consumerfab/consumer/toys/prize/honk // tier 2
	build_path = /obj/item/toy/prize/honk
	research = "figures_2"
/datum/design/item/consumerfab/consumer/toys/prize/marauder // tier 2
	build_path = /obj/item/toy/prize/marauder
	research = "figures_2"
/datum/design/item/consumerfab/consumer/toys/prize/seraph // tier 3
	build_path = /obj/item/toy/prize/seraph
	research = "figures_3"
/datum/design/item/consumerfab/consumer/toys/prize/mauler // tier 3
	build_path = /obj/item/toy/prize/mauler
	research = "figures_3"
/datum/design/item/consumerfab/consumer/toys/prize/odysseus // tier 3
	build_path = /obj/item/toy/prize/odysseus
	research = "figures_3"
/datum/design/item/consumerfab/consumer/toys/prize/phazon // tier 4
	build_path = /obj/item/toy/prize/phazon
	research = "figures_4"
/datum/design/item/consumerfab/consumer/toys/figure //  figures
	materials = list(MATERIAL_PLASTIC = 0.15 SHEETS)
	category = "Figurines"

/datum/design/item/consumerfab/consumer/toys/figure/assistant // tier 0
	build_path = /obj/item/toy/figure/assistant

/datum/design/item/consumerfab/consumer/toys/figure/bartender // tier 0
	build_path = /obj/item/toy/figure/bartender

/datum/design/item/consumerfab/consumer/toys/figure/gardener // tier 0
	build_path = /obj/item/toy/figure/gardener

/datum/design/item/consumerfab/consumer/toys/figure/chef // tier 0
	build_path = /obj/item/toy/figure/chef

/datum/design/item/consumerfab/consumer/toys/figure/librarian // tier 0
	build_path = /obj/item/toy/figure/librarian

/datum/design/item/consumerfab/consumer/toys/figure/janitor // tier 0
	build_path = /obj/item/toy/figure/janitor

/datum/design/item/consumerfab/consumer/toys/figure/cargotech // tier 0
	build_path = /obj/item/toy/figure/cargotech

/datum/design/item/consumerfab/consumer/toys/figure/engineer // tier 1
	build_path = /obj/item/toy/figure/engineer
	research = "figures_1"
/datum/design/item/consumerfab/consumer/toys/figure/miner // tier 1
	build_path = /obj/item/toy/figure/miner
	research = "figures_1"
/datum/design/item/consumerfab/consumer/toys/figure/md // tier 1
	build_path = /obj/item/toy/figure/md
	research = "figures_1"
/datum/design/item/consumerfab/consumer/toys/figure/secofficer // tier 1
	build_path = /obj/item/toy/figure/secofficer
	research = "figures_1"
/datum/design/item/consumerfab/consumer/toys/figure/scientist // tier 1
	build_path = /obj/item/toy/figure/scientist
	research = "figures_1"
/datum/design/item/consumerfab/consumer/toys/figure/chaplain // tier 1
	build_path = /obj/item/toy/figure/chaplain
	research = "figures_1"
/datum/design/item/consumerfab/consumer/toys/figure/atmos // tier 1
	build_path = /obj/item/toy/figure/atmos
	research = "figures_1"
/datum/design/item/consumerfab/consumer/toys/figure/psychologist // tier 1
	build_path = /obj/item/toy/figure/psychologist
	research = "figures_1"
/datum/design/item/consumerfab/consumer/toys/figure/paramedic // tier 1
	build_path = /obj/item/toy/figure/paramedic
	research = "figures_1"
/datum/design/item/consumerfab/consumer/toys/figure/roboticist // tier 1
	build_path = /obj/item/toy/figure/roboticist
	research = "figures_1"
/datum/design/item/consumerfab/consumer/toys/figure/geneticist // tier 1
	build_path = /obj/item/toy/figure/geneticist
	research = "figures_1"
/datum/design/item/consumerfab/consumer/toys/figure/chemist // tier 1
	build_path = /obj/item/toy/figure/chemist
	research = "figures_1"
/datum/design/item/consumerfab/consumer/toys/figure/cmo // tier 2
	build_path = /obj/item/toy/figure/cmo

/datum/design/item/consumerfab/consumer/toys/figure/ce // tier 2
	build_path = /obj/item/toy/figure/ce
	research = "figures_2"
/datum/design/item/consumerfab/consumer/toys/figure/detective // tier 2
	build_path = /obj/item/toy/figure/detective
	research = "figures_2"
/datum/design/item/consumerfab/consumer/toys/figure/hop // tier 2
	build_path = /obj/item/toy/figure/hop
	research = "figures_2"
/datum/design/item/consumerfab/consumer/toys/figure/hos // tier 2
	build_path = /obj/item/toy/figure/hos
	research = "figures_2"
/datum/design/item/consumerfab/consumer/toys/figure/qm // tier 2
	build_path = /obj/item/toy/figure/qm
	research = "figures_2"
/datum/design/item/consumerfab/consumer/toys/figure/rd // tier 2
	build_path = /obj/item/toy/figure/rd
	research = "figures_2"
/datum/design/item/consumerfab/consumer/toys/figure/warden // tier 2
	build_path = /obj/item/toy/figure/warden
	research = "figures_2"
/datum/design/item/consumerfab/consumer/toys/figure/borg // tier 3
	build_path = /obj/item/toy/figure/borg
	research = "figures_3"
/datum/design/item/consumerfab/consumer/toys/figure/captain // tier 3
	build_path = /obj/item/toy/figure/captain
	research = "figures_3"
/datum/design/item/consumerfab/consumer/toys/figure/clown // tier 3
	build_path = /obj/item/toy/figure/clown
	research = "figures_3"
/datum/design/item/consumerfab/consumer/toys/figure/corgi // tier 3
	build_path = /obj/item/toy/figure/corgi
	research = "figures_3"
/datum/design/item/consumerfab/consumer/toys/figure/mime // tier 3
	build_path = /obj/item/toy/figure/mime
	research = "figures_3"
/datum/design/item/consumerfab/consumer/toys/figure/ninja // tier 3
	build_path = /obj/item/toy/figure/ninja
	research = "figures_3"
/datum/design/item/consumerfab/consumer/toys/figure/wizard // tier 3
	build_path = /obj/item/toy/figure/wizard
	research = "figures_3"
/datum/design/item/consumerfab/consumer/toys/figure/agent // tier 3
	build_path = /obj/item/toy/figure/agent
	research = "figures_3"
/datum/design/item/consumerfab/consumer/toys/figure/dsquad // tier 4
	build_path = /obj/item/toy/figure/dsquad
	research = "figures_4"
/datum/design/item/consumerfab/consumer/toys/figure/syndie // tier 4
	build_path = /obj/item/toy/figure/syndie
	research = "figures_4"
/datum/design/item/consumerfab/consumer/toys/figure/ert // tier 4
	build_path = /obj/item/toy/figure/ert
	research = "figures_4"



/datum/design/item/consumerfab/consumer/toys/plushie // tier 1
	materials = list(MATERIAL_CLOTH = 1 SHEETS, MATERIAL_PLASTIC = 0.25 SHEETS)
	research = "plushie"
/datum/design/item/consumerfab/consumer/toys/plushie/nymph
	build_path = /obj/item/toy/plushie/nymph

/datum/design/item/consumerfab/consumer/toys/plushie/mouse
	build_path = /obj/item/toy/plushie/mouse

/datum/design/item/consumerfab/consumer/toys/plushie/kitten
	build_path = /obj/item/toy/plushie/kitten

/datum/design/item/consumerfab/consumer/toys/plushie/lizard
	build_path = /obj/item/toy/plushie/lizard

/datum/design/item/consumerfab/consumer/toys/plushie/spider
	build_path = /obj/item/toy/plushie/spider



/datum/design/item/consumerfab/consumer/toys/doll
	materials = list(MATERIAL_CLOTH = 0.5 SHEETS, MATERIAL_PLASTIC = 0.1 SHEETS)
/datum/design/item/consumerfab/consumer/toys/doll/red_doll
	name = "red doll"
	build_path = /obj/item/toy/therapy_red

/datum/design/item/consumerfab/consumer/toys/doll/purple_doll
	name = "purple doll"
	build_path = /obj/item/toy/therapy_purple

/datum/design/item/consumerfab/consumer/toys/doll/blue_doll
	name = "blue doll"
	build_path = /obj/item/toy/therapy_blue

/datum/design/item/consumerfab/consumer/toys/doll/yellow_doll
	name = "yellow doll"
	build_path = /obj/item/toy/therapy_yellow



/datum/design/item/consumerfab/consumer/toys/doll/green_doll
	name = "green doll"
	build_path = /obj/item/toy/therapy_green

/datum/design/item/consumerfab/consumer/toys/water_balloon
	name = "water balloon"
	build_path = /obj/item/toy/water_balloon
	materials = list(MATERIAL_PLASTIC = 0.25 SHEETS)

/datum/design/item/consumerfab/consumer/toys/ntballoon
	name = "nanotrasen balloon"
	build_path = /obj/item/toy/balloon/nanotrasen
	materials = list(MATERIAL_PLASTIC = 0.25 SHEETS)

/datum/design/item/consumerfab/consumer/toys/inflatableduck
	build_path = /obj/item/weapon/inflatable_duck
	materials = list(MATERIAL_PLASTIC = 0.5 SHEETS)


/datum/design/item/consumerfab/consumer/toys/blink
	name = "electronic blink toy game"
	build_path = /obj/item/toy/blink
	materials = list(MATERIAL_STEEL = 0.25 SHEETS)

/datum/design/item/consumerfab/consumer/toys/spinningtoy
	name = "gravitational singularity toy"
	build_path = /obj/item/toy/spinningtoy
	materials = list(MATERIAL_STEEL = 0.25 SHEETS, MATERIAL_CLOTH = 0.25 SHEETS)

/datum/design/item/consumerfab/consumer/toys/crossbow
	name = "foam dart crossbow"
	build_path = /obj/item/toy/crossbow
	materials = list(MATERIAL_STEEL = 1 SHEETS)

/datum/design/item/consumerfab/consumer/toys/ammo/crossbow
	name = "foam dart"
	build_path = /obj/item/toy/ammo/crossbow
	materials = list(MATERIAL_STEEL = 0.01 SHEETS)

/datum/design/item/consumerfab/consumer/toys/snappop
	name = "snap pop"
	build_path = /obj/item/toy/snappop
	materials = list(MATERIAL_STEEL = 0.01 SHEETS)

/datum/design/item/consumerfab/consumer/games/dice/normal
	name = "bag of 7 dice (d6)"
	build_path = /obj/item/weapon/storage/pill_bottle/dice
	materials = list(MATERIAL_PLASTIC = 0.8 SHEETS)

/datum/design/item/consumerfab/consumer/games/dice/nerd
	name = "bag of 7 dice (tabletop set)"
	build_path = /obj/item/weapon/storage/pill_bottle/dice_nerd
	materials = list(MATERIAL_PLASTIC = 0.8 SHEETS)


/datum/design/item/consumerfab/consumer/games/cards
	name = "playing cards"
	build_path = /obj/item/weapon/deck/cards
	materials = list(MATERIAL_PLASTIC = 0.5 SHEETS)

/datum/design/item/consumerfab/consumer/games/tarot
	name = "tarot cards"
	build_path = /obj/item/weapon/deck/tarot
	materials = list(MATERIAL_PLASTIC = 0.25 SHEETS)

/datum/design/item/consumerfab/consumer/games/board
	name = "checkerboard"
	build_path = /obj/item/weapon/board
	materials = list(MATERIAL_WOOD = 0.25 SHEETS)
/datum/design/item/consumerfab/consumer/games/checker
	name = "black checker"
	build_path = /obj/item/weapon/reagent_containers/food/snacks/checker

/datum/design/item/consumerfab/consumer/games/redchecker
	name = "red checker"
	build_path = /obj/item/weapon/reagent_containers/food/snacks/checker/red

/datum/design/item/consumerfab/consumer/games/pawn
	name = "black pawn"
	build_path = /obj/item/weapon/reagent_containers/food/snacks/checker/pawn

/datum/design/item/consumerfab/consumer/games/redpawn
	name = "red pawn"
	build_path = /obj/item/weapon/reagent_containers/food/snacks/checker/pawn/red

/datum/design/item/consumerfab/consumer/games/knight
	name = "black knight"
	build_path = /obj/item/weapon/reagent_containers/food/snacks/checker/knight

/datum/design/item/consumerfab/consumer/games/redknight
	name = "red knight"
	build_path = /obj/item/weapon/reagent_containers/food/snacks/checker/knight/red

/datum/design/item/consumerfab/consumer/games/bishop
	name = "black bishop"
	build_path = /obj/item/weapon/reagent_containers/food/snacks/checker/bishop

/datum/design/item/consumerfab/consumer/games/redbishop
	name = "red bishop"
	build_path = /obj/item/weapon/reagent_containers/food/snacks/checker/bishop/red

/datum/design/item/consumerfab/consumer/games/rook
	name = "black rook"
	build_path = /obj/item/weapon/reagent_containers/food/snacks/checker/rook

/datum/design/item/consumerfab/consumer/games/redrook
	name = "red rook"
	build_path = /obj/item/weapon/reagent_containers/food/snacks/checker/rook/red

/datum/design/item/consumerfab/consumer/games/queen
	name = "black queen"
	build_path = /obj/item/weapon/reagent_containers/food/snacks/checker/queen

/datum/design/item/consumerfab/consumer/games/redqueen
	name = "red queen"
	build_path = /obj/item/weapon/reagent_containers/food/snacks/checker/queen/red

/datum/design/item/consumerfab/consumer/games/king
	name = "black king"
	build_path = /obj/item/weapon/reagent_containers/food/snacks/checker/king

/datum/design/item/consumerfab/consumer/games/redking
	name = "red king"
	build_path = /obj/item/weapon/reagent_containers/food/snacks/checker/king/red

/datum/design/item/consumerfab/consumer/games/cardemon
	name = "cardemon booster pack"
	build_path = /obj/item/weapon/pack/cardemon
	materials = list(MATERIAL_PLASTIC = 0.25 SHEETS)

/datum/design/item/consumerfab/consumer/games/spaceball
	name = "spaceball booster pack"
	build_path = /obj/item/weapon/pack/spaceball
	materials = list(MATERIAL_PLASTIC = 0.25 SHEETS)

////////////////////////////////////////////////////
//////////////////////VEHICLES//////////////////////
////////////////////////////////////////////////////

/datum/design/item/consumerfab/vehicles
	category = "Vehicles"
	time = 50

/datum/design/item/consumerfab/vehicles/bike
	name = "Motor bike"
	id = "m_bike"
	materials = list(MATERIAL_STEEL = 40000, MATERIAL_TUNGSTEN = 20000, MATERIAL_GLASS = 20000, MATERIAL_GOLD = 20000)
	build_path = /obj/vehicle/bike

	////////////////////////////////////////////////////
	//////////////////////RECREATION//////////////////////
	////////////////////////////////////////////////////

/datum/design/item/consumerfab/consumer/recreation
	category = "Recreation"



/datum/design/item/consumerfab/consumer/recreation/basketball
	name = "Basketball"
	materials = list(MATERIAL_PLASTIC = 1 SHEETS)
	build_path = /obj/item/weapon/basketball

/datum/design/item/consumerfab/consumer/recreation/basketballhoop
	name = "Basketball Hoop"
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_PLASTIC = 1 SHEET)
	build_path = /obj/structure/basketballhoop

/datum/design/item/consumerfab/consumer/recreation/Weightlifting
	name = "Weightlifting Machine"
	materials = list(MATERIAL_STEEL = 4 SHEETS, MATERIAL_PLASTIC = 2 SHEETS, MATERIAL_ALUMINIUM = 4 SHEETS)
	build_path = /obj/structure/fitness/weightlifter

/datum/design/item/consumerfab/consumer/recreation/punchbag
	name = "Punching Bag"
	materials = list(MATERIAL_WOOD = 2 SHEETS, MATERIAL_PLASTIC = 2 SHEETS, MATERIAL_STEEL = 2 SHEETS)
	build_path = /obj/structure/fitness/punchingbag

/datum/design/item/consumerfab/consumer/recreation/beachball
	name = "Beach Ball"
	materials = list(MATERIAL_PLASTIC = 5 SHEETS)
	build_path = /obj/item/weapon/beach_ball

	////////////////////////////////////////////////////
	//////////////////////Decoration//////////////////////
	////////////////////////////////////////////////////

/datum/design/item/consumerfab/consumer/Decoration
	category = "Decoration"
 
/datum/design/item/consumerfab/consumer/Decoration/fern
	name = "Fern"
	materials = list(MATERIAL_WOOD = 2.5 SHEETS)
	build_path = /obj/structure/flora/pottedplant/fern

/datum/design/item/consumerfab/consumer/Decoration/overgrown
	name = "overgrown"
	materials = list(MATERIAL_WOOD = 5 SHEETS)
	build_path = /obj/structure/flora/pottedplant/overgrown


/datum/design/item/consumerfab/consumer/Decoration/bamboo

	name = "bamboo"
	materials = list(MATERIAL_WOOD = 5 SHEETS)
	build_path = /obj/structure/flora/pottedplant/bamboo


/datum/design/item/consumerfab/consumer/Decoration/largebush
	name = "largebush"
	materials = list(MATERIAL_WOOD = 2.5 SHEETS)
	build_path = /obj/structure/flora/pottedplant/largebush


/datum/design/item/consumerfab/consumer/Decoration/thinbush
	name = "thinbush"
	materials = list(MATERIAL_WOOD = 2.5 SHEETS)
	build_path = /obj/structure/flora/pottedplant/thinbush


/datum/design/item/consumerfab/consumer/Decoration/mysterious
	name = "mysterious"
	materials = list(MATERIAL_WOOD = 5 SHEETS)
	build_path = /obj/structure/flora/pottedplant/mysterious
	research = "unusal_trees"

/datum/design/item/consumerfab/consumer/Decoration/smalltree
	name = "smalltree"
	materials = list(MATERIAL_WOOD = 5 SHEETS)
	build_path = /obj/structure/flora/pottedplant/smalltree


/datum/design/item/consumerfab/consumer/Decoration/unusual
	name = "unusual"
	materials = list(MATERIAL_WOOD = 5 SHEETS , MATERIAL_PHORON = 0.25)
	build_path = /obj/structure/flora/pottedplant/unusual
	research = "unusal_trees"

/datum/design/item/consumerfab/consumer/Decoration/orientaltree
	name = "orientaltree"
	materials = list(MATERIAL_WOOD = 5 SHEETS)
	build_path = /obj/structure/flora/pottedplant/orientaltree


/datum/design/item/consumerfab/consumer/Decoration/smallcactus
	name = "smallcactus"
	materials = list(MATERIAL_WOOD = 2.5 SHEETS)
	build_path = /obj/structure/flora/pottedplant/smallcactus


/datum/design/item/consumerfab/consumer/Decoration/tall
	name = "tall"
	materials = list(MATERIAL_WOOD = 5 SHEETS)
	build_path = /obj/structure/flora/pottedplant/tall


/datum/design/item/consumerfab/consumer/Decoration/sticky
	name = "sticky"
	materials = list(MATERIAL_WOOD = 1.5 SHEETS , MATERIAL_PLASTIC = 0.25)
	build_path = /obj/structure/flora/pottedplant/sticky
	research = "unusal_trees"


/datum/design/item/consumerfab/consumer/Decoration/smelly
	name = "smelly"
	materials = list(MATERIAL_WOOD = 2.5 SHEETS)
	build_path = /obj/structure/flora/pottedplant/smelly
	research = "unusal_trees"


/datum/design/item/consumerfab/consumer/Decoration/small
	name = "small"
	materials = list(MATERIAL_WOOD = 2 SHEETS)
	build_path = /obj/structure/flora/pottedplant/small

/datum/design/item/consumerfab/consumer/Decoration/aquatic
	name = "aquatic"
	materials = list(MATERIAL_WOOD = 5 SHEETS)
	build_path = /obj/structure/flora/pottedplant/aquatic
	research = "unusal_trees"


/datum/design/item/consumerfab/consumer/Decoration/shoot
	name = "shoot"
	materials = list(MATERIAL_WOOD = 1 SHEETS)
	build_path = /obj/structure/flora/pottedplant/shoot


/datum/design/item/consumerfab/consumer/Decoration/flower
	name = "flower"
	materials = list(MATERIAL_WOOD = 1.5 SHEETS)
	build_path = /obj/structure/flora/pottedplant/flower


/datum/design/item/consumerfab/consumer/Decoration/crystal
	name = "crystal"
	materials = list(MATERIAL_WOOD = 2.5 SHEETS , MATERIAL_DIAMOND = 0.25)
	build_path = /obj/structure/flora/pottedplant/crystal
	research = "unusal_trees"


/datum/design/item/consumerfab/consumer/Decoration/subterranean
	name = "subterranean"
	materials = list(MATERIAL_WOOD = 5 SHEETS , MATERIAL_PHORON = 0.25)
	build_path = /obj/structure/flora/pottedplant/subterranean
	research = "unusal_trees"


/datum/design/item/consumerfab/consumer/Decoration/minitree
	name = "minitree"
	materials = list(MATERIAL_WOOD = 5.5 SHEETS)
	build_path = /obj/structure/flora/pottedplant/minitree


/datum/design/item/consumerfab/consumer/Decoration/stoutbush
	name = "stoutbush"
	materials = list(MATERIAL_WOOD = 2.5 SHEETS)
	build_path = /obj/structure/flora/pottedplant/stoutbush

/datum/design/item/consumerfab/consumer/Decoration/drooping
	name = "drooping"
	materials = list(MATERIAL_WOOD = 5 SHEETS)
	build_path = /obj/structure/flora/pottedplant/drooping


/datum/design/item/consumerfab/consumer/Decoration/tropical
	name = "tropical"
	materials = list(MATERIAL_WOOD = 5 SHEETS)
	build_path = /obj/structure/flora/pottedplant/tropical


/datum/design/item/consumerfab/consumer/Decoration/dead
	name = "dead"
	materials = list(MATERIAL_PLASTIC = 1 SHEETS)
	build_path = /obj/structure/flora/pottedplant/dead


/datum/design/item/consumerfab/consumer/Decoration/large
	name = "large"
	materials = list(MATERIAL_WOOD = 6 SHEETS)
	build_path = /obj/structure/flora/pottedplant/large


/datum/design/item/consumerfab/consumer/Decoration/decorative
	name = "decorative apple brush"
	materials = list(MATERIAL_WOOD = 5 SHEETS)
	build_path = /obj/structure/flora/pottedplant/decorative
	research = "unusal_trees"


/datum/design/item/consumerfab/consumer/Decoration/deskfern
	name = "deskfern"
	materials = list(MATERIAL_WOOD = 1 SHEETS)
	build_path = /obj/structure/flora/pottedplant/deskfern


/datum/design/item/consumerfab/consumer/Decoration/floorleaf
	name = "floorleaf"
	materials = list(MATERIAL_WOOD = 3 SHEETS)
	build_path = /obj/structure/flora/pottedplant/floorleaf


/datum/design/item/consumerfab/consumer/Decoration/deskleaf
	name = "deskleaf"
	materials = list(MATERIAL_WOOD = 1 SHEETS)
	build_path = /obj/structure/flora/pottedplant/deskleaf


/datum/design/item/consumerfab/consumer/Decoration/deskferntrim
	name = "deskferntrim"
	materials = list(MATERIAL_WOOD = 5 SHEETS)
	build_path = /obj/structure/flora/pottedplant/deskferntrim
	research = "unusal_trees"
