/obj/item/stack/animalhide/human
	name = "human skin"
	desc = "The by-product of human farming."
	singular_name = "human skin piece"
	icon = 'icons/obj/items.dmi'
	icon_state = "sheet-hide"

/obj/item/stack/animalhide/bear
	name = "bear skin"
	desc = "The by-product of bear farming."
	singular_name = "bear skin piece"
	icon = 'icons/obj/items.dmi'
	icon_state = "sheet-hide"
	color = COLOR_GRAY40

/obj/item/stack/animalhide/corgi
	name = "corgi hide"
	desc = "The by-product of corgi farming."
	singular_name = "corgi hide piece"
	icon = 'icons/obj/items.dmi'
	icon_state = "sheet-corgi"

/obj/item/stack/animalhide/cat
	name = "cat hide"
	desc = "The by-product of cat farming."
	singular_name = "cat hide piece"
	icon = 'icons/obj/items.dmi'
	icon_state = "sheet-cat"

/obj/item/stack/animalhide/monkey
	name = "monkey hide"
	desc = "The by-product of monkey farming."
	singular_name = "monkey hide piece"
	icon = 'icons/obj/items.dmi'
	icon_state = "sheet-monkey"

/obj/item/stack/animalhide/lizard
	name = "lizard skin"
	desc = "Sssssss..."
	singular_name = "lizard skin piece"
	icon = 'icons/obj/items.dmi'
	icon_state = "sheet-lizard"

/obj/item/stack/animalhide/xeno
	name = "alien hide"
	desc = "The skin of a terrible creature."
	singular_name = "alien hide piece"
	icon = 'icons/obj/items.dmi'
	icon_state = "sheet-xeno"

//don't see anywhere else to put these, maybe together they could be used to make the xenos suit?
/obj/item/stack/xenochitin
	name = "alien chitin"
	desc = "A piece of the hide of a terrible creature."
	singular_name = "alien hide piece"
	icon = 'icons/mob/alien.dmi'
	icon_state = "chitin"

/obj/item/xenos_claw
	name = "alien claw"
	desc = "The claw of a terrible creature."
	icon = 'icons/mob/alien.dmi'
	icon_state = "claw"

/obj/item/weed_extract
	name = "weed extract"
	desc = "A piece of slimy, purplish weed."
	icon = 'icons/mob/alien.dmi'
	icon_state = "weed_extract"

/obj/item/stack/hairlesshide
	name = "hairless hide"
	desc = "This hide was stripped of it's hair, but still needs tanning."
	icon = 'icons/obj/items.dmi'
	singular_name = "hairless hide piece"
	icon_state = "sheet-hairlesshide"

#define MAX_LEATHER_WETNESS 30
/obj/item/stack/wetleather
	name = "wet leather"
	desc = "This leather has been cleaned but still needs to be dried."
	icon = 'icons/obj/items.dmi'
	singular_name = "wet leather piece"
	icon_state = "sheet-wetleather"
	temperature_coefficient = 0.5 //Something like that
	var/wetness = MAX_LEATHER_WETNESS //Reduced when exposed to high temperautres
	var/drying_threshold_temperature = 100 CELSIUS //Reduced from 500 kelvin, because currently its hard to make a fire
	var/tmp/time_last_dry = 0 //Keep track of the last time we reduced wetness, so we don't dry too fast
	var/drying_factor = 2.0 //Drying rate is multiplied to this number, to make drying faster or slower

//Step one - dehairing.
/obj/item/stack/animalhide/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/material/knife) || isHatchet(W))

		//visible message on mobs is defined as visible_message(var/message, var/self_message, var/blind_message)
		usr.visible_message("<span class='notice'>\The [usr] starts cutting hair off \the [src]</span>", "<span class='notice'>You start cutting the hair off \the [src]</span>", "You hear the sound of a knife rubbing against flesh")
		if(do_after(user,50))
			to_chat(usr, "<span class='notice'>You cut the hair from this [src.singular_name]</span>")
			//Try locating an exisitng stack on the tile and add to there if possible
			for(var/obj/item/stack/hairlesshide/HS in usr.loc)
				if(HS.amount < 50)
					HS.amount++
					src.use(1)
					break
			//If it gets to here it means it did not find a suitable stack on the tile.
			var/obj/item/stack/hairlesshide/HS = new(usr.loc)
			HS.amount = 1
			src.use(1)
	else
		..()


//Step two - washing..... it's actually in washing machine code.

//Step three - drying

/obj/item/stack/wetleather/New(loc, amount)
	. = ..()
	ADD_SAVED_VAR(wetness)

/obj/item/stack/wetleather/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/stack/wetleather/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/stack/wetleather/Process()
	if (world.time > (time_last_dry + 1.5 SECONDS))
		if(wetness > 0)
			var/drying_this_tick = ((max(temperature, T0C) * 100) / drying_threshold_temperature) * drying_factor //Lets just use a simple linear percentage..
			wetness = max(0, wetness - drying_this_tick)
		else if(wetness <= 0)
			dry_one_sheet()
		time_last_dry = world.time
	return amount > 0? 0 : PROCESS_KILL //We don't need to process anymore when we're empty

/obj/item/stack/wetleather/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	..()
	if(exposed_temperature >= drying_threshold_temperature)
		wetness--
		if(wetness == 0)
			dry_one_sheet()

/obj/item/stack/wetleather/proc/dry_one_sheet()
	var/material/M = SSmaterials.get_material_by_name(MATERIAL_LEATHER)
	if(!istype(M))
		log_error("[src]\ref[src] ([x], [y], [z]) couldn't get leather material!!!")
		return FALSE
	M.place_sheet(get_turf(src))
	
	//If there's another sheet of wetleather restart at full wetness for the next one!
	wetness = MAX_LEATHER_WETNESS
	use(1)
	return TRUE

#undef MAX_LEATHER_WETNESS