/obj/effect/overmap/sector/exoplanet/desert
	name = "desert exoplanet"
	desc = "An arid exoplanet with sparse biological resources but rich mineral deposits underground."
	color = "#d6cca4"

/obj/effect/overmap/sector/exoplanet/desert/generate_map()
	if(prob(70))
		lightlevel = rand(5,10)/10	//deserts are usually :lit:
	for(var/zlevel in map_z)
		var/datum/random_map/noise/exoplanet/M = new /datum/random_map/noise/exoplanet/desert(md5(world.time + rand(-100,1000)),1,1,zlevel,maxx,maxy,0,1,1)
		get_biostuff(M)
		new /datum/random_map/noise/ore/rich(md5(world.time + rand(-100,1000)),1,1,zlevel,maxx,maxy,0,1,1)

/obj/effect/overmap/sector/exoplanet/desert/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.temperature = T20C + rand(20, 100)
		atmosphere.update_values()

/obj/effect/overmap/sector/exoplanet/desert/adapt_seed(var/datum/seed/S)
	..()
	if(prob(90))
		S.set_trait(TRAIT_REQUIRES_WATER,0)
	else
		S.set_trait(TRAIT_REQUIRES_WATER,1)
		S.set_trait(TRAIT_WATER_CONSUMPTION,1)
	if(prob(15))
		S.set_trait(TRAIT_STINGS,1)

/datum/random_map/noise/exoplanet/desert
	descriptor = "desert exoplanet"
	smoothing_iterations = 4
	land_type = /turf/simulated/floor/exoplanet/desert
	planetary_area = /area/exoplanet/desert
	plantcolors = list("#efdd6f","#7b4a12","#e49135","#ba6222","#5c755e","#120309")

	flora_prob = 10
	large_flora_prob = 0
	flora_diversity = 4
	fauna_types = list(/mob/living/simple_animal/thinbug, /mob/living/simple_animal/tindalos)

/datum/random_map/noise/exoplanet/desert/get_additional_spawns(var/value, var/turf/T)
	..()
	var/v = noise2value(value)
	if(v > 6)
		T.icon_state = "desert[v-1]"
		if(prob(10))
			new/obj/structure/quicksand(T)

/datum/random_map/noise/ore/rich
	deep_val = 0.7
	rare_val = 0.5

/datum/random_map/noise/ore/rich/apply_to_turf(var/x,var/y)

	var/tx = ((origin_x-1)+x)*chunk_size
	var/ty = ((origin_y-1)+y)*chunk_size

	for(var/i=0,i<chunk_size,i++)
		for(var/j=0,j<chunk_size,j++)
			var/turf/simulated/T = locate(tx+j, ty+i, origin_z)
			if(!istype(T) || !T.has_resources)
				continue
			if(!priority_process)
				CHECK_TICK
			T.resources = list()
			T.resources["silicates"] = rand(3,5)
			T.resources["carbonaceous rock"] = rand(3,5)

			var/tmp_cell
			TRANSLATE_AND_VERIFY_COORD(x, y)

			if(tmp_cell < rare_val)      // Surface metals.
				T.resources["iron"] =     rand(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX)
				T.resources["copper"] =   rand(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX)
				T.resources["salt"] =     rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources["aluminum"] = rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources["tin"] =      rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources["zinc"] =     rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources["lead"] =     rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources["sulfur"] =   rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources["gold"] =     rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources["silver"] =   rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources["uranium"] =  rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources["ice"] = 	  rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources["dryice"] =   rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources["diamond"] =  0
				T.resources["phoron"] =   0
				T.resources["osmium"] =   0
				T.resources["tungsten"] = 0
				T.resources["hydrogen"] = 0
				T.resources["bluespace crystal"] = 0
			else if(tmp_cell < deep_val) // Rare metals.
				T.resources["tin"] =      rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources["zinc"] =     rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources["lead"] =     rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources["sulfur"] =   rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources["gold"] =     rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources["silver"] =   rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources["uranium"] =  rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources["phoron"] =   rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources["osmium"] =   rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources["tungsten"] = 0
				T.resources["hydrogen"] = 0
				if(prob(1)) // 1 percent
					T.resources["bluespace crystal"] = 1
				else
					T.resources["bluespace crystal"] = 0
				T.resources["diamond"] =  0
				T.resources["iron"] =     0
				T.resources["copper"] =   0
				T.resources["aluminum"] = 0
				T.resources["salt"] =     0
				T.resources["ice"] = 	  0
				T.resources["dryice"] =   0
			else                             // Deep metals.
				T.resources["uranium"] =  rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources["diamond"] =  rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources["tungsten"] = rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources["phoron"] =   rand(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX)
				T.resources["osmium"] =   rand(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX)
				T.resources["hydrogen"] = rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				if(prob(5)) // 5 percent
					T.resources["bluespace crystal"] = 1
				else
					T.resources["bluespace crystal"] = 0
				T.resources["iron"] =     0
				T.resources["copper"] =   0
				T.resources["aluminum"] = 0
				T.resources["tin"] =      0
				T.resources["zinc"] =     0
				T.resources["sulfur"] =   0
				T.resources["lead"] =     0
				T.resources["gold"] =     0
				T.resources["silver"] =   0
				T.resources["salt"] =     0
				T.resources["ice"] = 	  0
				T.resources["dryice"] =   0
	
	
	
/area/exoplanet/desert
	ambience = list('sound/effects/wind/desert0.ogg','sound/effects/wind/desert1.ogg','sound/effects/wind/desert2.ogg','sound/effects/wind/desert3.ogg','sound/effects/wind/desert4.ogg','sound/effects/wind/desert5.ogg')
	base_turf = /turf/simulated/floor/exoplanet/desert

/turf/simulated/floor/exoplanet/desert
	name = "sand"

/turf/simulated/floor/exoplanet/desert/New()
	icon_state = "desert[rand(0,5)]"
	..()

/turf/simulated/floor/exoplanet/desert/fire_act(datum/gas_mixture/air, temperature, volume)
	if((temperature > T0C + 1700 && prob(5)) || temperature > T0C + 3000)
		name = "molten silica"
		icon_state = "sandglass"
		diggable = 0

/obj/structure/quicksand
	name = "sand"
	icon = 'icons/obj/quicksand.dmi'
	icon_state = "intact0"
	density = 0
	anchored = 1
	can_buckle = 1
	buckle_dir = SOUTH
	var/exposed = 0
	var/busy

/obj/structure/quicksand/New()
	icon_state = "intact[rand(0,2)]"
	..()

/obj/structure/quicksand/user_unbuckle_mob(mob/user)
	if(buckled_mob && !user.stat && !user.restrained())
		if(busy)
			to_chat(user, "<span class='wanoticerning'>[buckled_mob] is already getting out, be patient.</span>")
			return
		var/delay = 60
		if(user == buckled_mob)
			delay *=2
			user.visible_message(
				"<span class='notice'>\The [user] tries to climb out of \the [src].</span>",
				"<span class='notice'>You begin to pull yourself out of \the [src].</span>",
				"<span class='notice'>You hear water sloushing.</span>"
				)
		else
			user.visible_message(
				"<span class='notice'>\The [user] begins pulling \the [buckled_mob] out of \the [src].</span>",
				"<span class='notice'>You begin to pull \the [buckled_mob] out of \the [src].</span>",
				"<span class='notice'>You hear water sloushing.</span>"
				)
		busy = 1
		if(do_after(user, delay, src))
			busy = 0
			if(user == buckled_mob)
				if(prob(80))
					to_chat(user, "<span class='warning'>You slip and fail to get out!</span>")
					return
				user.visible_message("<span class='notice'>\The [buckled_mob] pulls himself out of \the [src].</span>")
			else
				user.visible_message("<span class='notice'>\The [buckled_mob] has been freed from \the [src] by \the [user].</span>")
			unbuckle_mob()

/obj/structure/quicksand/unbuckle_mob()
	..()
	update_icon()

/obj/structure/quicksand/buckle_mob(var/mob/L)
	..()
	update_icon()

/obj/structure/quicksand/update_icon()
	if(!exposed)
		return
	icon_state = "open"
	overlays.Cut()
	if(buckled_mob)
		overlays += buckled_mob
		var/image/I = image(icon,icon_state="overlay")
		I.plane = ABOVE_HUMAN_PLANE
		I.layer = ABOVE_HUMAN_LAYER
		overlays += I

/obj/structure/quicksand/proc/expose()
	if(exposed)
		return
	visible_message("<span class='warning'>The upper crust breaks, exposing treacherous quicksands underneath!</span>")
	name = "quicksand"
	desc = "There is no candy at the bottom."
	exposed = 1
	update_icon()

/obj/structure/quicksand/attackby(obj/item/weapon/W, mob/user)
	if(!exposed && W.force)
		expose()
	else
		..()

/obj/structure/quicksand/Crossed(AM)
	if(isliving(AM))
		var/mob/living/L = AM
		buckle_mob(L)
		if(!exposed)
			expose()
		to_chat(L, "<span class='danger'>You fall into \the [src]!</span>")