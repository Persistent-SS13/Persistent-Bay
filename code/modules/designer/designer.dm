//Yet another spaget cooked by Stigma. The HTML file is at html/designer.html. -- https://github.com/ingles98

/atom/var/designer_creator_ckey = "None - This icon wasn't created by the Designer feature."	//For blaming reasons
/atom/proc/GetDesign(var/icon/design, var/ckey) //Adds a general proc so any atom may be able to hook into the designer feature.

/obj/item/design_item //test item
	name = "designs"
	desc = "Test it out. ~Stigma"
	gender = NEUTER
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper"
	var/icon/icon_custom
	var/list/pixel_list
	var/datum/designer/design

/obj/item/design_item/New()
	design = new(source = src)

/obj/item/design_item/verb/Design()
	set name = "Design tool by Stigma - DEBUG"
	set category = "Debug"
	design.pixel_width = text2num( input("Max Width:", "Designer DEBUG", 32) )
	design.pixel_height = text2num( input("Max Width:", "Designer DEBUG", 32) )
	design.Design(icon_custom)

/obj/item/design_item/GetDesign(var/icon/ico, ckey)
	if (!ico || !istype(ico) )
		return
	var/offset_x = text2num( input("Offset X:", "Designer DEBUG", 0) )
	var/offset_y = text2num( input("Offset Y:", "Designer DEBUG", 0) )
	ico.Shift(EAST, offset_x)
	ico.Shift(SOUTH, offset_y)
	icon_custom = ico
	icon = icon_custom

	if (ckey)
		designer_creator_ckey = ckey

/datum/designer
	var/pixel_width = 8
	var/pixel_height = 8

	var/atom/my_atom

	var/list/colors
	var/icon/icon_custom

	var/creator_ckey
	var/title = ""

/datum/designer/New(source = null)
	if (source)
		my_atom = source


/datum/designer/proc/Design(var/icon/icon_custom = null, offset_x = 0, offset_y = 0)
	usr << browse(file("html/designer.html"), "window=designer;size=600x400;can_close=1" )
	sleep(5)
	usr << output("href='?src=\ref[src];[pixel_width];[pixel_height]","designer.browser:getData")
	if (length(title) >= 1)
		usr << output("[title]","designer.browser:setTitle")

	var/list/pixel_list
	if (icon_custom)
		icon_custom.Shift(EAST, -offset_x)
		icon_custom.Shift(SOUTH, -offset_y)
		pixel_list = new/list(icon_custom.Width(),icon_custom.Height())
		for ( var/x = 1 to icon_custom.Width() )
			for ( var/y = 1 to icon_custom.Height() )
				var/list/color = ReadRGB(icon_custom.GetPixel(x,y))
				if (!color || !color.len ||color.len < 3)
					continue
				pixel_list[x][y] = color
		spawn(2) usr << output("[json_encode(pixel_list)]","designer.browser:getIconAsJSON")

/datum/designer/Topic(href,href_list[])
	switch(href_list["action"])
		/*
			The 'if("getIcon")' below is WIP and should never be executed. It is the response from the WIP
			'new_saveIcon()' JS function in designer.html
			Also, its worth mentioning that the execution is completely untested, its just a very quick prediction
			of what should happen when 'new_saveIcon()' is up and running.
		*/
		if ("getIcon")
			icon_custom = icon('icons/effects/effects.dmi', "icon_state"="nothing")
			creator_ckey = usr.ckey
			message_admins("The icon width is [icon_custom.Width()]")

			var/icon_array = json_decode(href_list["json_string"])
			for ( var/x = 1 to icon_custom.Width() )
				for ( var/y = 1 to icon_custom.Height() )
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

/datum/designer/proc/processIcon(var/color,var/x,var/y)
	set background = 1
	icon_custom.DrawBox(color,x, y)
	sleep(-1)

/datum/designer/proc/finishIcon()
	icon_custom.Flip(NORTH)

	if (my_atom)
		my_atom.GetDesign(icon_custom, ckey = creator_ckey)
