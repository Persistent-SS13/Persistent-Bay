/* Diffrent misc types of tiles
 * Contains:
 *		Prototype
 *		Grass
 *		Wood
 *		Linoleum
 *		Carpet
 */

/obj/item/stack/tile
	name = "tile"
	singular_name = "tile"
	desc = "A non-descript floor tile."
	randpixel = 7
	w_class = ITEM_SIZE_NORMAL
	max_amount = 100
	icon = 'icons/obj/tiles.dmi'

	force = 1
	throwforce = 1
	throw_speed = 5
	throw_range = 20
	item_flags = 0
	obj_flags = 0

/*
 * Grass
 */
/obj/item/stack/tile/grass
	name = "grass tile"
	singular_name = "grass floor tile"
	desc = "A patch of grass like they often use on golf courses."
	icon_state = "tile_grass"
	origin_tech = list(TECH_BIO = 1)

/*
 * Wood
 */
/obj/item/stack/tile/wood
	name = "wood floor tile"
	singular_name = "wood floor tile"
	desc = "An easy to fit wooden floor tile."
	icon_state = "tile-wood"
	color = WOOD_COLOR_GENERIC
	matter = list(MATERIAL_WOOD = 450)

/obj/item/stack/tile/wood/cyborg
	name = "wood floor tile synthesizer"
	desc = "A device that makes wood floor tiles."
	uses_charge = 1
	charge_costs = list(250)
	stacktype = /obj/item/stack/tile/wood
	build_type = /obj/item/stack/tile/wood

/obj/item/stack/tile/mahogany
	name = "mahogany floor tile"
	singular_name = "mahogany floor tile"
	desc = "An easy to fit mahogany wood floor tile."
	icon_state = "tile-wood"
	color = WOOD_COLOR_RICH
	matter = list(MATERIAL_WOOD = 450)

/obj/item/stack/tile/maple
	name = "maple floor tile"
	singular_name = "maple floor tile"
	desc = "An easy to fit maple wood floor tile."
	icon_state = "tile-wood"
	color = WOOD_COLOR_PALE
	matter = list(MATERIAL_WOOD = 450)

/obj/item/stack/tile/ebony
	name = "ebony floor tile"
	singular_name = "ebony floor tile"
	desc = "An easy to fit ebony floor tile."
	icon_state = "tile-wood"
	color = WOOD_COLOR_BLACK
	matter = list(MATERIAL_WOOD = 450)

/obj/item/stack/tile/walnut
	name = "walnut floor tile"
	singular_name = "walnut floor tile"
	desc = "An easy to fit walnut wood floor tile."
	icon_state = "tile-wood"
	color = WOOD_COLOR_CHOCOLATE
	matter = list(MATERIAL_WOOD = 450)

/obj/item/stack/tile/bamboo
	name = "bamboo floor tile"
	singular_name = "bamboo floor tile"
	desc = "An easy to fit bamboo wood floor tile."
	icon_state = "tile-wood"
	color = WOOD_COLOR_PALE2
	matter = list(MATERIAL_WOOD = 450)

/obj/item/stack/tile/yew
	name = "yew floor tile"
	singular_name = "yew floor tile"
	desc = "An easy to fit yew wood floor tile."
	icon_state = "tile-wood"
	color = WOOD_COLOR_YELLOW
	matter = list(MATERIAL_WOOD = 450)

/obj/item/stack/tile/floor
	name = "steel floor tile"
	singular_name = "steel floor tile"
	desc = "Those could work as a pretty decent throwing weapon." //why?
	icon_state = "tile"
	force = 6
	matter = list(MATERIAL_STEEL = 0.04 SHEETS)
	throwforce = 15
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/mono
	name = "steel mono tile"
	singular_name = "steel mono tile"
	icon_state = "tile"
	matter = list(MATERIAL_STEEL = 0.04 SHEETS)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/mono/dark
	name = "dark mono tile"
	singular_name = "dark mono tile"
	icon_state = "tile"
	matter = list(MATERIAL_STEEL = 0.04 SHEETS)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/mono/white
	name = "white mono tile"
	singular_name = "white mono tile"
	icon_state = "tile"
	matter = list(MATERIAL_STEEL = 0.04 SHEETS)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/grid
	name = "grey grid tile"
	singular_name = "grey grid tile"
	icon_state = "tile_grid"
	matter = list(MATERIAL_STEEL = 0.04 SHEETS)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/ridge
	name = "grey ridge tile"
	singular_name = "grey ridge tile"
	icon_state = "tile_ridged"
	matter = list(MATERIAL_STEEL = 0.04 SHEETS)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/techgrey
	name = "grey techfloor tile"
	singular_name = "grey techfloor tile"
	icon_state = "techtile_grey"
	matter = list(MATERIAL_STEEL = 0.04 SHEETS)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/techgrid
	name = "grid techfloor tile"
	singular_name = "grid techfloor tile"
	icon_state = "techtile_grid"
	matter = list(MATERIAL_STEEL = 0.04 SHEETS)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/techmaint
	name = "dark techfloor tile"
	singular_name = "dark techfloor tile"
	icon_state = "techtile_maint"
	matter = list(MATERIAL_STEEL = 0.04 SHEETS)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/floor_white
	name = "white floor tile"
	singular_name = "white floor tile"
	icon_state = "tile_white"
	matter = list(MATERIAL_PLASTIC = 0.04 SHEETS)

/obj/item/stack/tile/floor_white/fifty
	amount = 50

/obj/item/stack/tile/floor_dark
	name = "dark floor tile"
	singular_name = "dark floor tile"
	icon_state = "fr_tile"
	matter = list(MATERIAL_PLASTEEL = 0.04 SHEETS)

/obj/item/stack/tile/floor_dark/fifty
	amount = 50

/obj/item/stack/tile/floor_freezer
	name = "freezer floor tile"
	singular_name = "freezer floor tile"
	icon_state = "tile_freezer"
	matter = list(MATERIAL_PLASTIC = 0.04 SHEETS)

/obj/item/stack/tile/floor_freezer/fifty
	amount = 50

/obj/item/stack/tile/floor/cyborg
	name = "floor tile synthesizer"
	desc = "A device that makes floor tiles."
	gender = NEUTER
	matter = null
	uses_charge = 1
	charge_costs = list(250)
	stacktype = /obj/item/stack/tile/floor
	build_type = /obj/item/stack/tile/floor

/obj/item/stack/tile/linoleum
	name = "linoleum"
	singular_name = "linoleum"
	desc = "A piece of linoleum. It is the same size as a normal floor tile!"
	icon_state = "tile_linoleum"
	matter = list(MATERIAL_PLASTIC = 0.04 SHEETS)

/obj/item/stack/tile/linoleum/fifty
	amount = 50

/obj/item/stack/tile/stone
	name = "stone slabs"
	singular name = "stone slab"
	desc = "A smooth, flat slab of some kind of stone."
	icon_state = "tile_stone"

/obj/item/stack/tile/new_tile
	name = "old tiles"
	singular_name = "old tile"
	desc = "A worn down floor tile."
	icon_state = "tile_full"
	matter = list(MATERIAL_PLASTIC = 0.04 SHEETS)
/obj/item/stack/tile/new_tile/fifty
	amount = 50

/obj/item/stack/tile/new_tile/gray
	name = "old gray tiles"
	singular_name = "old gray tile"
	color = COLOR_GRAY
/obj/item/stack/tile/new_tile/gray/fifty
	amount = 50

/obj/item/stack/tile/old_cargo
	name = "old mono tiles"
	singular_name = "old mono tile"
	desc = "A worn down mono floor tile."
	icon_state = "cargo_one_full"
	matter = list(MATERIAL_PLASTIC = 0.04 SHEETS)
/obj/item/stack/tile/old_cargo/fifty
	amount = 50

/obj/item/stack/tile/old_cargo/gray
	name = "old gray mono tiles"
	singular_name = "old gray mono tile"
	color = COLOR_GRAY
/obj/item/stack/tile/old_cargo/gray/fifty
	amount = 50

/obj/item/stack/tile/kafel
	name = "kafel tile"
	singular_name = "kafel tile"
	icon_state = "kafel_full"
	matter = list(MATERIAL_PLASTEEL = 0.045 SHEETS)
/obj/item/stack/tile/kafel/fifty
	amount = 50

/*
 * Carpets
 */
/obj/item/stack/tile/carpet
	name = "brown carpet"
	singular_name = "brown carpet"
	desc = "A piece of brown carpet."
	icon_state = "tile_carpetbrown"
	matter = list(MATERIAL_CLOTH = 0.04 SHEETS)

/obj/item/stack/tile/carpet/fifty
	amount = 50

/obj/item/stack/tile/carpetblue
	name = "blue carpet"
	desc = "A piece of blue and gold carpet."
	singular_name = "blue carpet"
	icon_state = "tile_carpetblue"

/obj/item/stack/tile/carpetblue/fifty
	amount = 50

/obj/item/stack/tile/carpetblue2
	name = "pale blue carpet"
	desc = "A piece of blue and silver carpet."
	singular_name = "pale blue carpet"
	icon_state = "tile_carpetblue2"

/obj/item/stack/tile/carpetblue2/fifty
	amount = 50

/obj/item/stack/tile/carpetblue3
	name = "sea blue carpet"
	desc = "A piece of blue and green carpet."
	singular_name = "sea blue carpet"
	icon_state = "tile_carpetblue3"

/obj/item/stack/tile/carpetblue3/fifty
	amount = 50

/obj/item/stack/tile/carpetmagenta
	name = "magenta carpet"
	desc = "A piece of magenta carpet."
	singular_name = "magenta carpet"
	icon_state = "tile_carpetmagenta"

/obj/item/stack/tile/carpetmagenta/fifty
	amount = 50

/obj/item/stack/tile/carpetpurple
	name = "purple carpet"
	desc = "A piece of purple carpet."
	singular_name = "purple carpet"
	icon_state = "tile_carpetpurple"

/obj/item/stack/tile/carpetpurple/fifty
	amount = 50

/obj/item/stack/tile/carpetorange
	name = "orange carpet"
	desc = "A piece of orange carpet."
	singular_name = "orange carpet"
	icon_state = "tile_carpetorange"

/obj/item/stack/tile/carpetorange/fifty
	amount = 50

/obj/item/stack/tile/carpetgreen
	name = "green carpet"
	desc = "A piece of green carpet."
	singular_name = "green carpet"
	icon_state = "tile_carpetgreen"

/obj/item/stack/tile/carpetgreen/fifty
	amount = 50

/obj/item/stack/tile/carpetred
	name = "red carpet"
	desc = "A piece of red carpet."
	singular_name = "red carpet"
	icon_state = "tile_carpetred"

/obj/item/stack/tile/carpetred/fifty
	amount = 50

//
// Circuits
//
/obj/item/stack/tile/floor_bcircuit
	name = "blue circuit flooring"
	desc = "A tile of fancy circuit like lit flooring."
	singular_name = "blue circuit tile"
	icon_state = "bcircuit"
	icon = 'icons/turf/flooring/circuit.dmi'

/obj/item/stack/tile/floor_bcircuit/fifty
	amount = 50

/obj/item/stack/tile/floor_gcircuit
	name = "green circuit flooring"
	desc = "A tile of fancy circuit like lit flooring."
	singular_name = "green circuit tile"
	icon_state = "gcircuit"
	icon = 'icons/turf/flooring/circuit.dmi'

/obj/item/stack/tile/floor_gcircuit/fifty
	amount = 50

/obj/item/stack/tile/floor_rcircuit
	name = "red circuit flooring"
	desc = "A tile of fancy circuit like lit flooring."
	singular_name = "red circuit tile"
	icon_state = "rcircuit"
	icon = 'icons/turf/flooring/circuit.dmi'

/obj/item/stack/tile/floor_rcircuit/fifty
	amount = 50

//
//shuttle flooring
//
/obj/item/stack/tile/shuttle
	matter = list(MATERIAL_TITANIUM = 0.04 SHEETS)
/obj/item/stack/tile/shuttle/blue
	name = "blue shuttle floor"
	desc = "Blue shuttle flooring."
	singular_name = "blue shuttle tile"
	icon_state = "tile_blue_shuttle"
/obj/item/stack/tile/shuttle/blue/fifty
	amount = 50

/obj/item/stack/tile/shuttle/yellow
	name = "yellow shuttle floor"
	desc = "Yellow shuttle flooring."
	singular_name = "yellow shuttle tile"
	icon_state = "tile_yellow_shuttle"
/obj/item/stack/tile/shuttle/yellow/fifty
	amount = 50

/obj/item/stack/tile/shuttle/white
	name = "white shuttle floor"
	desc = "White shuttle flooring."
	singular_name = "white shuttle tile"
	icon_state = "tile_white_shuttle"
/obj/item/stack/tile/shuttle/white/fifty
	amount = 50

/obj/item/stack/tile/shuttle/red
	name = "red shuttle floor"
	desc = "Red shuttle flooring."
	singular_name = "red shuttle tile"
	icon_state = "tile_red_shuttle"
/obj/item/stack/tile/shuttle/red/fifty
	amount = 50

/obj/item/stack/tile/shuttle/purple
	name = "purple shuttle floor"
	desc = "Purple shuttle flooring."
	singular_name = "purple shuttle tile"
	icon_state = "tile_purple_shuttle"
/obj/item/stack/tile/shuttle/purple/fifty
	amount = 50

/obj/item/stack/tile/shuttle/darkred
	name = "dark red shuttle floor"
	desc = "Dark red shuttle flooring."
	singular_name = "dark red shuttle tile"
	icon_state = "tile_darkred_shuttle"
/obj/item/stack/tile/shuttle/darkred/fifty
	amount = 50

/obj/item/stack/tile/shuttle/black
	name = "black shuttle floor"
	desc = "Black shuttle flooring."
	singular_name = "black shuttle tile"
	icon_state = "tile_black_shuttle"
/obj/item/stack/tile/shuttle/black/fifty
	amount = 50

/obj/item/stack/tile/shuttle/plates
	name = "plated shuttle floor"
	desc = "Plated flooring."
	singular_name = "plated shuttle tile"
	icon_state = "tile_plated_shuttle"
/obj/item/stack/tile/shuttle/plates/fifty
	amount = 50

//
// Misc
//
/obj/item/stack/tile/concrete
	name = "concrete"
	singular_name = "concrete"
	desc = "A piece of concrete flooring. It is the same size as a normal floor tile!"
	icon_state = "tile_concrete"
	matter = list(MATERIAL_SAND = 0.025 SHEETS, MATERIAL_SANDSTONE = 0.025 SHEETS)
/obj/item/stack/tile/concrete/fifty
	amount = 50

/obj/item/stack/tile/rockvault
	name = "vault tiles"
	singular_name = "vault tile"
	icon_state = "tile_rockvault"
	matter = list(MATERIAL_PLASTEEL = 0.05 SHEETS)
/obj/item/stack/tile/rockvault
	amount = 50

/obj/item/stack/tile/sandstonevault
	name = "sandstone vault tiles"
	singular_name = "sandstone vault tile"
	icon_state = "tile-sandstonevault"
	matter = list(MATERIAL_SANDSTONE = 0.05 SHEETS)
