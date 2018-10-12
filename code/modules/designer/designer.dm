//Yet another spaget cooked by Stigma. The HTML file is at html/designer.html. -- https://github.com/ingles98
/obj/item/designs
	name = "designs"
	desc = "Test it out. ~Stigma"
	gender = NEUTER
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper"
	var/icon/icon_custom
	var/list/pixel_list

/obj/item/designs/verb/Design()
	set name = "Design tool by Stigma - DEBUG"
	set category = "Debug"
	usr << browse(file("html/designer.html"), "window=designer;size=600x400;can_close=1" )
	spawn(10)usr << output("href='?src=\ref[src];","designer.browser:getRef")

/obj/item/designs/Topic(href,href_list[])
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
			icon_custom = new(icon)
		if ("stop")
			finishIcon()

/obj/item/designs/proc/processIcon(var/color,var/x,var/y)
	set background = 1
	icon_custom.DrawBox(color,x, y)
	sleep(-1)

/obj/item/designs/proc/finishIcon()
	icon_custom.Flip(NORTH)
	icon_custom.Flip(EAST)
	icon = icon_custom

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
