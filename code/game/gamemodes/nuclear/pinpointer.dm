//Nuke ops locator
/obj/item/weapon/pinpointer/nukeop
	var/locate_shuttle = 0

/obj/item/weapon/pinpointer/nukeop/Process()
	var/new_mode
	if(!locate_shuttle && bomb_set)
		locate_shuttle = 1
		new_mode = "Shuttle Locator"
	else if (locate_shuttle && !bomb_set)
		locate_shuttle = 0
		new_mode = "Authentication Disk Locator"
	if(new_mode)
		playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)
		visible_message("<span class='notice'>[new_mode] active.</span>")
		target = acquire_target()
	..()

/obj/item/weapon/pinpointer/nukeop/acquire_target()
	if(locate_shuttle)
		var/obj/machinery/computer/shuttle_control/multi/syndicate/home = locate()
		return weakref(home)
	else
		return ..()

//Deathsquad locator

/obj/item/weapon/pinpointer/advpinpointer/verb/toggle_mode()
	set category = "Object"
	set name = "Toggle Pinpointer Mode"
	set src in view(1)

	var/selection = input(usr, "Please select the type of target to locate.", "Mode" , "") as null|anything in list("Location", "Disk Recovery", "DNA", "Other Signature")
	switch(selection)
		if("Disk Recovery")
			var/obj/item/weapon/disk/nuclear/the_disk = locate()
			target = weakref(the_disk)

		if("Location")
			var/locationx = input(usr, "Please input the x coordinate to search for.", "Location?" , "") as num
			if(!locationx || !(usr in view(1,src)))
				return
			var/locationy = input(usr, "Please input the y coordinate to search for.", "Location?" , "") as num
			if(!locationy || !(usr in view(1,src)))
				return

			var/turf/Z = get_turf(src)
			var/turf/location = locate(locationx,locationy,Z.z)

			to_chat(usr, "You set the pinpointer to locate [locationx],[locationy]")

			target = weakref(location)

		if("Other Signature")
			var/datum/objective/steal/itemlist
			itemlist = itemlist // To supress a 'variable defined but not used' error.
			var/targetitem = input("Select item to search for.", "Item Mode Select","") as null|anything in itemlist.possible_items
			if(!targetitem)
				return
			var/obj/item = locate(itemlist.possible_items[targetitem])
			if(!item)
				to_chat(usr, "Failed to locate [targetitem]!")
				return
			to_chat(usr, "You set the pinpointer to locate [targetitem]")
			target = weakref(item)

		if("DNA")
			var/DNAstring = input("Input DNA string to search for." , "Please Enter String." , "")
			if(!DNAstring)
				return
			for(var/mob/living/carbon/M in SSmobs.mob_list)
				if(!M.dna)
					continue
				if(M.dna.unique_enzymes == DNAstring)
					target = weakref(M)
					break
