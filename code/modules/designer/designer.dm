//Yet another spaget cooked by Stigma. The HTML file is at html/designer.html. -- https://github.com/ingles98

//Any proc can have a designer_unit attached. The way they handle it is highly derivative
/atom/var/datum/designer_unit/designer_unit

//A general proc so any atom may be able to hook into the designer feature. It is called after a design change
/atom/proc/designer_update_icon()

//Associates the target design to the current atom.
/atom/proc/designer_associate(var/datum/designer_unit/design)
	designer_unit = design
	if (!(src in design.associated_atoms))
		design.associated_atoms += src

/atom/proc/designer_disassociate()
	if (designer_unit)
		designer_unit.associated_atoms -= src
		designer_unit = null


//The global designer_system var. Stores all designs in its list/designs.
var/global/datum/designer_system/designer_system = new()
//The actual designer_system datum
/datum/designer_system
	var/list/designs = list()

// Whenever a new design is created (probably when first creating a canvas item or anything else hooked to designer)
// It calls our dear designer_system so it can be inserted on its designs list, and also get an unique ID.
/datum/designer_system/proc/newDesign(var/datum/designer_unit/unit)
	designs.Insert(designs.len +1, unit)
	unit.id = designs.len -1 > 0 ? designs[designs.len -1].id +1 : 1

//A DEBUG verb, more for admemeing than that to be honest.
// Doesn't actually delete designs, it deletes their icons.
/datum/designer_system/proc/delete_designs()
	set category = "Debug"
	set desc = "Deletes all designs made by an individual. (Only replaces the design's icons and updates atoms, does not delete them.)"
	set name = "Designer: Delete Designs by Ckey"

	var/ckey = input("Input the CKEY you want all associated designs removed:", "Designer", "")
	var/count = 0

	usr << "Searching for designs made by ckey: [ckey]"
	for (var/datum/designer_unit/design in designer_system.designs)
		if (design.creator_ckey == lowertext(ckey))
			design.delete_icon()
			count++
	usr << "[count] designs made by [ckey] have been purged, only their associated atoms were left behind."

//Our dear design holder. Almost everything related to designer happens under this datum.
/datum/designer_unit
	var/id

	var/icon_width = 0
	var/icon_height = 0

	var/icon_offset_x = 0
	var/icon_offset_y = 0

	var/list/colors
	var/icon/icon_custom

	var/creator_ckey
	var/title = ""

	var/list/associated_atoms = list()

//On new design_unit, add itself to the global list of designs.
/datum/designer_unit/New()
	designer_system.newDesign(src)

//The general proc to use when you want to draw to this design_unit
/datum/designer_unit/proc/Design(var/atom/source)
	source.designer_associate(src)

	usr << browse(file("html/designer.html"), "window=designer;size=600x400;can_close=1" )
	sleep(5)
	usr << output("href='?src=\ref[src];[icon_width];[icon_height]","designer.browser:getData")
	if (length(title) >= 1)
		usr << output("[title]","designer.browser:setTitle")

	var/list/pixel_list
	if (icon_custom)
		var/icon/ico = new(icon_custom)
		ico.Shift(EAST, -icon_offset_x)
		ico.Shift(SOUTH, -icon_offset_y)
		pixel_list = new/list(ico.Width(),ico.Height())
		for ( var/x = 1 to ico.Width() )
			for ( var/y = 1 to ico.Height() )
				var/list/color = ReadRGB(ico.GetPixel(x,y))
				if (!color || !color.len ||color.len < 3)
					continue
				pixel_list[x][y] = color
		spawn(2) usr << output("[json_encode(pixel_list)]","designer.browser:getIconAsJSON")

// Handles retrieval of pixel data from the client browser.
// Not very optimized, but it actually happens very fast, i'd say instantly right after the browser is done processing the icon on its side.
// Still conceptualizing an optimized alternative.
/datum/designer_unit/Topic(href,href_list[])
	switch(href_list["action"])
		/*
			The 'if("getIcon")' below is WIP and should never be executed. It is the response from the WIP
			'new_saveIcon()' JS function in designer.html
			Also, its worth mentioning that the execution is completely untested, its just a very quick prediction
			of what should happen when 'new_saveIcon()' is up and running.
		*/
		if ("getIcon")
			icon_custom = new()
			creator_ckey = usr.ckey

			var/icon_array = json_decode(href_list["json_string"])
			for ( var/x = 1 to icon_width )
				for ( var/y = 1 to icon_height )
					var/color = rgb(icon_array[x][y][0], icon_array[x][y][1], icon_array[x][y][2], icon_array[x][y][3])
					processIcon(x,y,color)
			finishIcon()
		if ("pixel")
			var/x = text2num(href_list["x"])
			var/y = text2num(href_list["y"])

			var/r = text2num(href_list["r"])
			var/g = text2num(href_list["g"])
			var/b = text2num(href_list["b"])
			var/alpha = text2num(href_list["a"])

			var/color = rgb(r,g,b,alpha)

			processIcon(color,x,y)
		if ("start")
			icon_custom = icon('icons/effects/effects.dmi', "icon_state"="nothing")
			creator_ckey = usr.ckey
		if ("stop")
			finishIcon()

//Processes individual pixel.
/datum/designer_unit/proc/processIcon(var/color,var/x,var/y)
	set background = 1
	icon_custom.DrawBox(color,x, y)
	sleep(-1)

// When finishing the icon, it needs to flip around the Y axis cause the way we deal with
// passing the icon data from BYOND to the client browser and back.
// It applies the offsets and updates all associated atoms afterwards
/datum/designer_unit/proc/finishIcon()
	icon_custom.Flip(NORTH)
	icon_custom.Shift(EAST, icon_offset_x)
	icon_custom.Shift(SOUTH, icon_offset_y)
	update_associated_atoms()

/datum/designer_unit/proc/update_associated_atoms()
	for (var/atom/obj in associated_atoms)
		obj.designer_update_icon()

// General proc for replacing the icon. Currently replaces with a red 'X'.
// Used for moderating purposes. Doesn't actually delete the associated atoms.
/datum/designer_unit/proc/delete_icon()
	icon_custom = new('icons/Testing/Zone.dmi',icon_state = "fullblock")
	update_associated_atoms()

// Same as delete_icon, but this time it actually deletes the design datum and ALL associated atoms.
// WARNING USE WITH CAUTION
/datum/designer_unit/proc/purge_atoms()
	delete_icon()
	for (var/atom/obj in associated_atoms)
		qdel(obj)
	designer_system.designs -= src
	qdel(src)

//-----------------------------------------------------------------------------------------

// A debug item to test the designer system.
/obj/item/design_item
	name = "designs"
	desc = "Test it out."
	gender = NEUTER
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper"

/obj/item/design_item/verb/Design()
	set name = "Design tool - DEBUG"
	set category = "Debug"
	if (!designer_unit)
		designer_unit = new()
	designer_unit.icon_width = text2num( input("Max Width:", "Designer DEBUG", 32) )
	designer_unit.icon_height = text2num( input("Max Height:", "Designer DEBUG", 32) )
	designer_unit.Design(src)

/obj/item/design_item/verb/Clone()
	set name = "Clone - DEBUG"
	set category = "Debug"
	var/obj/item/design_item/new_item = new(get_turf(src))
	new_item.designer_associate(src.designer_unit)
	new_item.designer_update_icon()

/obj/item/design_item/designer_update_icon()
	icon = designer_unit.icon_custom
