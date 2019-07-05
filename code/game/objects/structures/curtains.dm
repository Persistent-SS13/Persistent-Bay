/obj/structure/curtain
	name = "curtain"
	icon = 'icons/obj/curtain.dmi'
	icon_state = "closed"
	plane = OBJ_PLANE
	layer = ABOVE_WINDOW_LAYER
	opacity = 1
	density = 0
	max_health = 20

/obj/structure/curtain/open
	icon_state = "open"
	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER
	opacity = 0

/obj/structure/curtain/attack_hand(mob/user)
	playsound(get_turf(loc), "rustle", 15, 1, -5)
	toggle()
	..()

/obj/structure/curtain/proc/toggle()
	set_opacity(!opacity)
	if(opacity)
		icon_state = "closed"
		plane = ABOVE_HUMAN_PLANE
		layer = ABOVE_WINDOW_LAYER
	else
		icon_state = "open"
		plane = OBJ_PLANE
		layer = ABOVE_WINDOW_LAYER

/obj/structure/curtain/black
	name = "black curtain"
	color = "#222222"

/obj/structure/curtain/medical
	name = "plastic curtain"
	color = "#b8f5e3"
	alpha = 200

/obj/structure/curtain/open/bed
	name = "bed curtain"
	color = "#854636"

/obj/structure/curtain/open/privacy
	name = "privacy curtain"
	color = "#b8f5e3"

/obj/structure/curtain/open/shower
	name = "shower curtain"
	color = "#acd1e9"
	alpha = 200

/obj/structure/curtain/open/shower/engineering
	color = "#ffa500"

/obj/structure/curtain/open/shower/security
	color = "#aa0000"

/obj/structure/curtain/attackby(obj/item/W as obj, mob/user as mob)
	if((isScrewdriver(W)) && (istype(loc, /turf/simulated) || anchored))
		playsound(loc, 'sound/items/Screwdriver.ogg', 100, 1)
		anchored = !anchored
		user.visible_message("<span class='notice'>[user] [anchored ? "fastens" : "unfastens"] the [src].</span>", \
								 "<span class='notice'>You have [anchored ? "fastened the [src] to" : "unfastened the [src] from"] the floor.</span>")
		return

	if(isWelder(W))
		var/obj/item/weapon/tool/weldingtool/WT = W
		if(WT.remove_fuel(0,user))
			var/obj/item/stack/material/plastic/new_item = new(usr.loc)
			new_item.add_to_stacks(usr)
			for (var/mob/M in viewers(src))
				M.show_message("<span class='notice'>Now slicing apart the [src]...</span>", 3, "<span class='notice'>You hear welding.</span>", 2)
		qdel(src)
		return
	return ..()
