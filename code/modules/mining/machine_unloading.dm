/**********************Unloading unit**************************/
/obj/machinery/mineral/unloading_machine
	name = "unloading machine"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "unloader"
	density = 1
	anchored = 1.0

/obj/machinery/mineral/unloading_machine/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/unloading_machine(src)
	component_parts += new /obj/item/stack/material/steel(src)
	component_parts += new /obj/item/stack/material/steel(src)
	component_parts += new /obj/item/stack/material/steel(src)
	component_parts += new /obj/item/stack/material/steel(src)
	component_parts += new /obj/item/stack/material/steel(src)
	RefreshParts()

/obj/machinery/mineral/unloading_machine/attackby(var/obj/O as obj, var/mob/user as mob)
	if(default_deconstruction_screwdriver(user, O))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	var/obj/item/device/multitool/M = O
	if(istype(M))
		dir = angle2dir(dir2angle(dir) + 45)
		user.visible_message("<span class='notice'>You change the output dir of \the [src] to [dir2text(dir)]</span>")
	..()
	return

/obj/machinery/mineral/unloading_machine/Bumped(var/atom/movable/A)
	var/obj/structure/ore_box/BOX = A
	if (istype(BOX))
		var/i = 0
		for (var/obj/item/weapon/ore/O in BOX.contents)
			BOX.contents -= O
			O.loc = get_step(loc, dir)
			i++
			if (i>=10)
				return
		return
	A.forceMove(get_step(loc, dir))
	return