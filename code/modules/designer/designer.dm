//Yet another spaget cooked by Stigma. The HTML file is at html/designer.html. -- https://github.com/ingles98

/atom/proc/GetDesign(var/icon/design) //Adds a general proc so any atom may be able to hook into the designer feature.

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
	design.Design()

/obj/item/design_item/GetDesign(var/icon/ico)
	if (!ico || !istype(ico) )
		return
	var/offset_x = text2num( input("Offset X:", "Designer DEBUG", 0) )
	var/offset_y = text2num( input("Offset Y:", "Designer DEBUG", 0) )
	ico.Shift(EAST, offset_x)
	ico.Shift(SOUTH, offset_y)
	icon = ico

/datum/designer
	var/pixel_width = 8
	var/pixel_height = 8

	var/atom/my_atom

	var/list/colors
	var/icon/icon_custom

/datum/designer/New(source = null)
	if (source)
		my_atom = source


/datum/designer/proc/Design()
	usr << browse(file("html/designer.html"), "window=designer;size=600x400;can_close=1" )
	spawn(10)usr << output("href='?src=\ref[src];[pixel_width];[pixel_height]","designer.browser:getData")

/datum/designer/Topic(href,href_list[])
	switch(href_list["action"])
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
		if ("stop")
			finishIcon()

/datum/designer/proc/processIcon(var/color,var/x,var/y)
	set background = 1
	icon_custom.DrawBox(color,x, y)
	sleep(-1)

/datum/designer/proc/finishIcon()
	icon_custom.Flip(NORTH)

	if (my_atom)
		my_atom.GetDesign(icon_custom)

/*
client
    var
        browser
        browser_version
    verb
        setBrowser(Browser as text,Version as num)
            set hidden = 1
            browser = Browser
            browser_version = Version

mob/living/verb/DESIGNER()
    set name = "Designer tool by Stigma"

    usr << browse(file("html/designer.html"), "window=hiddenbrowser;size=600x400;can_close=1" )
*/
