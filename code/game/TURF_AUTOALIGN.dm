// maps: COG2 causes nornwalls, DESTINY causes gannetwalls, anything else doesn't get saved
#define P_INDEX 1
#define P_IMAGE 2
#define P_ISTATE 3

/atom/var/list/overlay_refs = list()

/atom/proc/UpdateOverlays(var/image/I, var/key, var/force=0, var/retain_cache = 0)
	if(!key)
		CRASH("UpdateOverlays called without a key.")

	var/list/prev_data
	//List to store info about the last state of the icon
	prev_data = overlay_refs[key]
	if(!prev_data && I) //Ok, we don't have previous data, but we will add an overlay
		prev_data = list()
		prev_data.len = 3
	else if(!prev_data) //We don't have data and we won't add an overlay
		return 0

	var/hash = hash_image(I)
	var/image/prev_overlay = prev_data[P_IMAGE] //overlay_refs[key]
	if(!force && (prev_overlay == I) && hash == prev_data[P_ISTATE] ) //If it's the same image as the other one and the hashes match then do not update
		return 0

	var/index = prev_data[P_INDEX]
	if(index > 0) //There is an existing overlay in place in this slot, remove it
		src.overlays.Cut(index, index+1) //Fuck yoooou byond (this gotta be by index or it'll fail if the same thing's in overlays several times)
		prev_data[P_INDEX] = 0
		for(var/ikey in overlay_refs) //Because we're storing the position of each overlay in the list we need to shift our indices down to stay synched
			var/list/L = overlay_refs[ikey]
			if(!isnull(L) && L.len > 0 && L[P_INDEX] >= index) L[P_INDEX]--

	if(I)
		src.overlays += I
		index = src.overlays.len
		prev_data[P_INDEX] = index

		prev_data[P_IMAGE] = I
		prev_data[P_ISTATE] = hash//I.icon_state

		overlay_refs[key] = prev_data
	else
		if(retain_cache) //Keep the cached image available?
			prev_data[P_INDEX] = 0	//Clear the index
			prev_data[P_ISTATE] = 0	//Clear the hash

			//overlay_refs[key] = prev_data //Update our list <- Pointers, dumbass /Spy
		else
			overlay_refs -= key
	return 1

/atom/proc/ClearAllOverlays(var/retain_cache=0) //Some men just want to watch the world burn
	if(src.overlays.len)
		src.overlays.Cut()
		if(retain_cache)
			for(var/key in src.overlay_refs)
				var/list/pd = overlay_refs[key]
				pd[P_INDEX] = 0
				pd[P_ISTATE] = 0
				overlay_refs[key] = pd
		else
			src.overlay_refs.Cut()
		return 1

/atom/proc/ClearSpecificOverlays(var/retain_cache=0)
	var/tally = 0
	var/keep_cache = isnum(retain_cache) && retain_cache //Maybe someone forgets to include this argument and goes straight for the list, let's handle that case
	for(var/key in args)
		if(istext(key)) //The retain_cache value will be here as well, so skip it
			tally += src.UpdateOverlays(null, key, 0, keep_cache)
	return tally


/atom/proc/GetOverlayImage(var/key)
	//Never rely on this proc returning an image.
	var/list/ov_data = overlay_refs[key]

	if(ov_data)
		. = ov_data[P_IMAGE]
	else
		. = null

/atom/proc/SafeGetOverlayImage(var/key, var/image_file as file, var/icon_state as text, var/layer as num|null)
	var/image/I = GetOverlayImage(key)
	if(!I)
		I = image(image_file, icon_state, layer)
	else
		//Ok, apparently modifying anything pertaining to the image appearance causes a hubbub, thanks byand
		if(I.icon != image_file)
			I.icon = image_file

		if(icon_state != I.icon_state)
			I.icon_state = icon_state

		if(layer && layer != I.layer)
			I.layer = layer
	return I

/////////////////////////////////////////////
//helper procs
/////////////////////////////////////////////
/proc/hash_image(var/image/I)
	if(I)
		. = md5("\ref[I][I.icon_state][I.overlays ? I.overlays.len : 0][I.color][I.alpha]")
	else
		. = null


#undef P_INDEX
#undef P_IMAGE
#undef P_ISTATE

var/global/map_setting = null

/obj/landmark/map
	name = "map_setting"
	icon_state = "x3"
	invisibility = 101

	New()
		if (src.name && (src.name == "COG2" || src.name == "DESTINY"))
			map_setting = src.name
		qdel(src)

/* =================================================== */
/* -------------------- SIMULATED -------------------- */
/* =================================================== */

/turf/simulated/wall/auto
	icon = 'icons/turf/walls_auto.dmi'
	var/mod = null
	var/light_mod = null
	var/connect_overlay = 0 // do we have wall connection overlays, ex nornwalls?
	var/list/connects_to = list(/turf/simulated/wall/auto)
	var/list/connects_with_overlay = list()
	var/image/connect_image = null
	var/d_state = 0

	New()
		..()
		spawn(0)
			src.update_icon()

	// ty to somepotato for assistance with making this proc actually work right :I
	update_icon()
		var/builtdir = 0
		var/overlaydir = 0
		for (var/dir in GLOB.cardinal)
			var/turf/T = get_step(src, dir)
			if (T.type == src.type || (T.type in connects_to))
				builtdir |= dir
			else if (connects_to)
				for (var/i=1, i <= connects_to.len, i++)
					var/atom/A = locate(connects_to[i]) in T
					if (!isnull(A))
						if (istype(A, /atom/movable))
							var/atom/movable/M = A
							if (!M.anchored)
								continue
						builtdir |= dir
						break
			if (connect_overlay && connects_with_overlay)
				if (T.type in connects_with_overlay)
					overlaydir |= dir
				else
					for (var/i=1, i <= connects_with_overlay.len, i++)
						var/atom/A = locate(connects_with_overlay[i]) in T
						if (!isnull(A))
							if (istype(A, /atom/movable))
								var/atom/movable/M = A
								if (!M.anchored)
									continue
							overlaydir |= dir

		src.icon_state = "[mod][builtdir][src.d_state ? "C" : null]"


		if (connect_overlay)
			if (overlaydir)
				if (!src.connect_image)
					src.connect_image = image(src.icon, "connect[overlaydir]")
				else
					src.connect_image.icon_state = "connect[overlaydir]"
				src.UpdateOverlays(src.connect_image, "connect")
			else
				src.UpdateOverlays(null, "connect")

/turf/simulated/wall/auto/reinforced
	name = "reinforced wall"
	explosion_resistance = 7
	mod = "R"
	icon_state = "mapwall_r"
	connects_to = list(/turf/simulated/wall/auto/reinforced)


/*
	/* ----- Deconstruction ----- */
		if (istype(W, /obj/item/weapon/wirecutters))
			if (src.d_state == 0)
				playsound(src.loc, "sound/items/Wirecutter.ogg", 100, 1)
				src.d_state = 1
				var/atom/A = new /obj/item/stack/rods(src)
				if (src.material)
					A.setMaterial(src.material)
				else
					A.setMaterial(getCachedMaterial("steel"))
				src.update_icon()

		else if (istype(W, /obj/item/weapon/screwdriver))
			if (src.d_state == 1)
				var/turf/T = user.loc
				playsound(src.loc, "sound/items/Screwdriver.ogg", 100, 1)
				to_chat(user, "<span style=\"color:blue\">Removing support lines.</span>")
				sleep(40)
				if ((user.loc == T && user.equipped() == W))
					src.d_state = 2
					to_chat(user, "<span style=\"color:blue\">You removed the support lines.</span>")
				else if((istype(user, /mob/living/silicon/robot) && (user.loc == T)))
					src.d_state = 2
					to_chat(user, "<span style=\"color:blue\">You removed the support lines.</span>")

		else if (istype(W, /obj/item/weapon/weldingtool) && W:welding)
			var/obj/item/weldingtool/Weld = W
			var/turf/T = user.loc
			if (!(istype(T, /turf)))
				return

			if (src.d_state == 2)
				to_chat(user, "<span style=\"color:blue\">Slicing metal cover.</span>")
				playsound(src.loc, "sound/items/Welder.ogg", 100, 1)
				sleep(60)
				if ((user.loc == T && user.equipped() == W))
					src.d_state = 3
					to_chat(user, "<span style=\"color:blue\">You removed the metal cover.</span>")
				else if((istype(user, /mob/living/silicon/robot) && (user.loc == T)))
					src.d_state = 3
					to_chat(user, "<span style=\"color:blue\">You removed the metal cover.</span>")

			else if (src.d_state == 5)
				to_chat(user, "<span style=\"color:blue\">Removing support rods.</span>")
				playsound(src.loc, "sound/items/Welder.ogg", 100, 1)
				sleep(100)
				if ((user.loc == T && user.equipped() == W))
					src.d_state = 6
					var/atom/A = new /obj/item/stack/rods( src )
					if (src.material)
						A.setMaterial(src.material)
					else
						A.setMaterial(getCachedMaterial("steel"))
					to_chat(user, "<span style=\"color:blue\">You removed the support rods.</span>")
				else if ((istype(user, /mob/living/silicon/robot) && (user.loc == T)))
					src.d_state = 6
					var/atom/A = new /obj/item/stack/rods( src )
					if (src.material)
						A.setMaterial(src.material)
					else
						A.setMaterial(getCachedMaterial("steel"))
					to_chat(user, "<span style=\"color:blue\">You removed the support rods.</span>")

		else if (istype(W, /obj/item/weapon/crowbar))
			if (src.d_state == 3)
				var/turf/T = user.loc
				to_chat(user, "<span style=\"color:blue\">Prying cover off.</span>")
				playsound(src.loc, "sound/items/Crowbar.ogg", 100, 1)
				sleep(100)
				if ((user.loc == T && user.equipped() == W))
					src.d_state = 4
					to_chat(user, "<span style=\"color:blue\">You removed the cover.</span>")
				else if((istype(user, /mob/living/silicon/robot) && (user.loc == T)))
					src.d_state = 4
					to_chat(user, "<span style=\"color:blue\">You removed the cover.</span>")

			else if (src.d_state == 6)
				var/turf/T = user.loc
				to_chat(user, "<span style=\"color:blue\">Prying outer sheath off.</span>")
				playsound(src.loc, "sound/items/Crowbar.ogg", 100, 1)
				sleep(100)
				if ((user.loc == T && user.equipped() == W))
					to_chat(user, "<span style=\"color:blue\">You removed the outer sheath.</span>")
					logTheThing("station", user, null, "dismantles a Reinforced Wall in [user.loc.loc] ([showCoords(user.x, user.y, user.z)])")
					dismantle_wall()
					return
				else if ((istype(user, /mob/living/silicon/robot) && (user.loc == T)))
					to_chat(user, "<span style=\"color:blue\">You removed the outer sheath.</span>")
					logTheThing("station", user, null, "dismantles a Reinforced Wall in [user.loc.loc] ([showCoords(user.x, user.y, user.z)])")
					dismantle_wall()
					return

		else if (istype(W, /obj/item/wrench))
			if (src.d_state == 4)
				var/turf/T = user.loc
				to_chat(user, "<span style=\"color:blue\">Detaching support rods.</span>")
				playsound(src.loc, "sound/items/Ratchet.ogg", 100, 1)
				sleep(40)
				if ((user.loc == T && user.equipped() == W))
					src.d_state = 5
					to_chat(user, "<span style=\"color:blue\">You detach the support rods.</span>")
				else if((istype(user, /mob/living/silicon/robot) && (user.loc == T)))
					src.d_state = 5
					to_chat(user, "<span style=\"color:blue\">You detach the support rods.</span>")


		else if (istype(W, /obj/item/device/key/haunted))
			var/obj/item/device/key/haunted/H = W
			//Okay, create a temporary false wall.
			if (H.last_use && ((H.last_use + 300) >= world.time))
				to_chat(user, "<span style=\"color:red\">The key won't fit in all the way!</span>")
				return
			user.visible_message("<span style=\"color:red\">[user] inserts [W] into [src]!</span>","<span style=\"color:red\">The key seems to phase into the wall.</span>")
			H.last_use = world.time
			blink(src)
			var/turf/simulated/wall/false_wall/temp/fakewall = new /turf/simulated/wall/false_wall/temp(src)
			fakewall.was_rwall = 1
			fakewall.opacity = 0
			fakewall.RL_SetOpacity(1) //Lighting rebuild.
			return

		else if (istype(W, /obj/item/sheet) && src.d_state)
			var/obj/item/sheet/S = W
			var/turf/T = user.loc
			to_chat(user, "<span style=\"color:blue\">Repairing wall.</span>")
			sleep(100)
			if (user.loc == T && user.equipped() == S)
				src.d_state = 0
				src.icon_state = initial(src.icon_state)
				if (S.material)
					src.setMaterial(S.material)
				else
					var/datum/material/M = getCachedMaterial("steel")
					src.setMaterial(M)
				to_chat(user, "<span style=\"color:blue\">You repaired the wall.</span>")
				if (S.amount > 1)
					S.amount--
				else
					qdel(W)
			else if (istype(user, /mob/living/silicon/robot) && user.loc == T)
				src.d_state = 0
				src.icon_state = initial(src.icon_state)
				if (W.material)
					src.setMaterial(S.material)
				to_chat(user, "<span style=\"color:blue\">You repaired the wall.</span>")
				if (S.amount > 1)
					S.amount--
				else
					qdel(W)

		else if (istype(W, /obj/item/grab))
			var/obj/item/grab/G = W
			if (!grab_smash(G, user))
				return ..(W, user)
			else
				return

		if (src.material)
			var/fail = 0
			if (prob(src.material.getProperty(PROP_INSTABILITY)))
				fail = 1
			if (src.material.quality < 0) if(prob(abs(src.material.quality)))
				fail = 1
			if (fail)
				user.visible_message("<span style=\"color:red\">You hit the wall and it [getMatFailString(src.material.material_flags)]!</span>","<span style=\"color:red\">[user] hits the wall and it [getMatFailString(src.material.material_flags)]!</span>")
				playsound(src.loc, "sound/weapons/Genhit.ogg", 25, 1)
				del(src)
				return

		src.take_hit(W)
*/
/turf/simulated/wall/auto/supernorn
	icon = 'icons/turf/walls_supernorn.dmi'
	light_mod = "wall-"
	connect_overlay = 1
	connects_to = list(/turf/simulated/wall/auto/supernorn, /turf/simulated/wall/auto/reinforced/supernorn, /obj/machinery/door,
	/obj/structure/window/)
	connects_with_overlay = list(/turf/simulated/wall/auto/reinforced/supernorn, /obj/machinery/door,
	/obj/structure/window/)

/turf/simulated/wall/auto/reinforced/supernorn
	icon = 'icons/turf/walls_supernorn.dmi'
	light_mod = "wall-"
	connect_overlay = 1
	connects_to = list(/turf/simulated/wall/auto/supernorn, /turf/simulated/wall/auto/reinforced/supernorn, /obj/machinery/door,
	/obj/structure/window/)
	connects_with_overlay = list(/turf/simulated/wall/auto/supernorn, /obj/machinery/door,
	/obj/structure/window/)
