/datum/poster
	// Name suffix. Poster - [name]
	var/name=""
	// Description suffix
	var/desc=""
	var/icon_state=""

/obj/structure/sign/poster
	name = "poster"
	desc = "A large piece of space-resistant printed paper."
	icon = 'icons/obj/contraband.dmi'
	anchored = 1
	mass = 0.5
	max_health = 5
	damthreshold_brute 	= 0
	damthreshold_burn 	= 0
	var/serial_number	//Will hold the value of src.loc if nobody initialises it
	var/poster_type		//So mappers can specify a desired poster
	var/ruined = 0

/obj/structure/sign/poster/New(var/newloc, var/placement_dir=null, var/serial=null)
	..(newloc)

	if(!serial)
		serial = rand(1, poster_designs.len) //use a random serial if none is given

	serial_number = serial
	var/datum/poster/design = poster_designs[serial_number]
	set_poster(design)

	switch (placement_dir)
		if (NORTH)
			pixel_x = 0
			pixel_y = 32
		if (SOUTH)
			pixel_x = 0
			pixel_y = -32
		if (EAST)
			pixel_x = 32
			pixel_y = 0
		if (WEST)
			pixel_x = -32
			pixel_y = 0

/obj/structure/sign/poster/Initialize()
	if(!map_storage_loaded)
		if (poster_type)
			var/path = ispath(poster_type) ? poster_type : text2path(poster_type)
			var/datum/poster/design = new path
			set_poster(design)
	. = ..()

/obj/structure/sign/poster/proc/set_poster(var/datum/poster/design)
	name = "[initial(name)] - [design.name]"
	desc = "[initial(desc)] [design.desc]"
	icon_state = design.icon_state // poster[serial_number]

/obj/structure/sign/poster/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(isWirecutter(W) || isScissors(W))
		playsound(loc, 'sound/items/Wirecutter.ogg', 100, 1)
		if(ruined)
			to_chat(user, "<span class='notice'>You remove the remnants of the poster.</span>")
			qdel(src)
		else
			to_chat(user, "<span class='notice'>You carefully remove the poster from the wall.</span>")
			roll_and_drop(user.loc)
		return


/obj/structure/sign/poster/attack_hand(mob/user as mob)
	if(ruined)
		return
	if(alert("Do I want to rip the poster from the wall?","You think...","Yes","No") == "Yes")
		if(ruined || !user.Adjacent(src))
			return
		visible_message("<span class='warning'>\The [user] rips \the [src] in a single, decisive motion!</span>" )
		playsound(src.loc, 'sound/items/poster_ripped.ogg', 100, 1)
		ruined = 1
		icon_state = "poster_ripped"
		name = "ripped poster"
		desc = "You can't make out anything from the poster's original print. It's ruined."
		add_fingerprint(user)

/obj/structure/sign/poster/proc/roll_and_drop(turf/newloc)
	var/obj/item/weapon/contraband/poster/P = new(src, serial_number)
	P.loc = newloc
	src.loc = P
	qdel(src)