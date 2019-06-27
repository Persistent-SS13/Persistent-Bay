
/obj/effect/mist
	name = "mist"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mist"
	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER
	anchored = 1
	mouse_opacity = 0
	should_save = 0

/obj/structure/hygiene/shower
	name = "shower"
	desc = "The best in class HS-451 shower unit has three temperature settings, one more than the HS-450 which preceded it."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "shower"
	density = 0
	anchored = 1
	mass = 5
	max_health = 130
	damthreshold_brute 	= 5
	var/on = 0
	var/obj/effect/mist/mymist = null
	var/watertemp = "normal"	//freezing, normal, or boiling
	var/list/temperature_settings = list("normal" = 310, "boiling" = T0C+100, "freezing" = T0C)
	var/time_to_remove_mist = 0 //world time when to delete the mist

/obj/structure/hygiene/shower/New()
	..()
	create_reagents(50)

/obj/structure/hygiene/shower/Destroy()
	if(mymist)
		QDEL_NULL(mymist)
	..()

/obj/structure/hygiene/shower/attack_hand(mob/M as mob)
	on = !on
	update_mist()
	update_icon()

/obj/structure/hygiene/shower/attackby(obj/item/I as obj, mob/user as mob)
	if(I.type == /obj/item/device/scanner/gas)
		to_chat(user, "<span class='notice'>The water temperature seems to be [watertemp].</span>")
	if(isWrench(I))
		var/newtemp = input(user, "What setting would you like to set the temperature valve to?", "Water Temperature Valve") in temperature_settings
		to_chat(user, "<span class='notice'>You begin to adjust the temperature valve with \the [I].</span>")
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, 50, src))
			watertemp = newtemp
			user.visible_message("<span class='notice'>\The [user] adjusts \the [src] with \the [I].</span>", "<span class='notice'>You adjust the shower with \the [I].</span>")
			add_fingerprint(user)

	if(isScrewdriver(I))
		if(on)
			to_chat(usr, "Turn \the [src] off first!")
			return
		to_chat(usr, "<span class='notice'>You begin to unscrew \the [src] from the wall.</span>")
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 75, 1)
		if(do_after(usr, 30, src))
			if(!src) return
			to_chat(usr, "<span class='notice'>You finish dismantling \the [src].</span>")
			new /obj/item/frame/plastic/shower(src.loc)
			qdel(src)
			return

//Only call once when toggling the shower on and off
/obj/structure/hygiene/shower/proc/update_mist()
	if(on)
		if(!mymist && temperature_settings[watertemp] > T20C)
			mymist = new /obj/effect/mist(loc)
	else
		time_to_remove_mist = world.time + 25 SECONDS

/obj/structure/hygiene/shower/update_icon()	//this is terribly unreadable, but basically it makes the shower mist up
	overlays.Cut()					//once it's been on for a while, in addition to handling the water overlay.
	if(on)
		overlays += image('icons/obj/watercloset.dmi', src, "water", MOB_LAYER + 1, dir)

/obj/structure/hygiene/shower/Process()
	if(!on && !mymist)
		return
	if(mymist && !on && world.time > time_to_remove_mist)
		QDEL_NULL(mymist)
		return

	for(var/thing in loc)
		var/atom/movable/AM = thing
		var/mob/living/L = thing
		if(istype(AM) && AM.simulated)
			wash(AM)
			if(istype(L))
				process_heat(L)
	wash_floor()
	reagents.add_reagent(/datum/reagent/water, reagents.get_free_space()) //Change this once we get fluid pipes

/obj/structure/hygiene/shower/proc/process_heat(mob/living/M)
	if(!on || !istype(M)) return

	var/temperature = temperature_settings[watertemp]
	var/temp_adj = between(BODYTEMP_COOLING_MAX, temperature - M.bodytemperature, BODYTEMP_HEATING_MAX)
	M.bodytemperature += temp_adj

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(temperature >= H.species.heat_level_1)
			to_chat(H, "<span class='danger'>The water is searing hot!</span>")
		else if(temperature <= H.species.cold_level_1)
			to_chat(H, "<span class='warning'>The water is freezing cold!</span>")

/obj/structure/hygiene/shower/proc/wash_floor()
	if(isturf(loc))
		var/turf/T = get_turf(src)
		reagents.splash(T, reagents.total_volume)
		T.clean(src)

//Yes, showers are super powerful as far as washing goes.
/obj/structure/hygiene/shower/proc/wash(var/atom/movable/washing)
	if(!on)
		return

	wash_mob(washing)
	if(isturf(loc))
		var/turf/tile = loc
		for(var/obj/effect/E in tile)
			if(istype(E,/obj/effect/decal/cleanable) || istype(E,/obj/effect/overlay))
				qdel(E)
	reagents.splash(washing, 10)
