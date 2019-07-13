/obj/machinery/beehive
	name = "apiary"
	icon = 'icons/obj/beekeeping.dmi'
	icon_state = "beehive-0"
	desc = "A wooden box designed specifically to house our buzzling buddies. Far more efficient than traditional hives. Just insert a frame and a queen, close it up, and you're good to go!"
	density = 1
	anchored = 1
	layer = BELOW_OBJ_LAYER
	mass = 5
	max_health = 100
	damthreshold_brute 	= 2
	
	var/closed = 0
	var/bee_count = 0 // Percent
	var/smoked = 0 // Timer
	var/honeycombs = 0 // Percent
	var/frames = 0
	var/maxFrames = 5

/obj/machinery/beehive/New()
	. = ..()
	ADD_SAVED_VAR(closed)
	ADD_SAVED_VAR(bee_count)
	ADD_SAVED_VAR(smoked)
	ADD_SAVED_VAR(honeycombs)
	ADD_SAVED_VAR(frames)

/obj/machinery/beehive/Initialize()
	. = ..()
	queue_icon_update()

/obj/machinery/beehive/on_update_icon()
	overlays.Cut()
	icon_state = "beehive-[closed]"
	if(closed)
		overlays += "lid"
	if(frames)
		overlays += "empty[frames]"
	if(honeycombs >= 100)
		overlays += "full[round(honeycombs / 100)]"
	if(!smoked)
		switch(bee_count)
			if(1 to 20)
				overlays += "bees1"
			if(21 to 40)
				overlays += "bees2"
			if(41 to 60)
				overlays += "bees3"
			if(61 to 80)
				overlays += "bees4"
			if(81 to 100)
				overlays += "bees5"

/obj/machinery/beehive/examine(var/mob/user)
	. = ..()
	if(!closed)
		to_chat(user, "The lid is open.")

/obj/machinery/beehive/attackby(var/obj/item/I, var/mob/user)
	if(isCrowbar(I))
		closed = !closed
		user.visible_message("<span class='notice'>\The [user] [closed ? "closes" : "opens"] \the [src].</span>", "<span class='notice'>You [closed ? "close" : "open"] \the [src].</span>")
		update_icon()
		return 1
	else if(isWrench(I))
		anchored = !anchored
		user.visible_message("<span class='notice'>\The [user] [anchored ? "wrenches" : "unwrenches"] \the [src].</span>", "<span class='notice'>You [anchored ? "wrench" : "unwrench"] \the [src].</span>")
		return 1
	else if(istype(I, /obj/item/bee_smoker))
		if(closed)
			to_chat(user, "<span class='notice'>You need to open \the [src] with a crowbar before smoking the bees.</span>")
			return 1
		user.visible_message("<span class='notice'>\The [user] smokes the bees in \the [src].</span>", "<span class='notice'>You smoke the bees in \the [src].</span>")
		smoked = 30
		update_icon()
		return 1
	else if(istype(I, /obj/item/honey_frame))
		if(closed)
			to_chat(user, "<span class='notice'>You need to open \the [src] with a crowbar before inserting \the [I].</span>")
			return 1
		if(frames >= maxFrames)
			to_chat(user, "<span class='notice'>There is no place for an another frame.</span>")
			return 1
		var/obj/item/honey_frame/H = I
		if(H.honey)
			to_chat(user, "<span class='notice'>\The [I] is full with beeswax and honey, empty it in the extractor first.</span>")
			return 1
		++frames
		user.visible_message("<span class='notice'>\The [user] loads \the [I] into \the [src].</span>", "<span class='notice'>You load \the [I] into \the [src].</span>")
		update_icon()
		user.drop_from_inventory(I)
		qdel(I)
		return 1
	else if(istype(I, /obj/item/bee_pack))
		var/obj/item/bee_pack/B = I
		if(B.full && bee_count)
			to_chat(user, "<span class='notice'>\The [src] already has bees inside.</span>")
			return 1
		if(!B.full && bee_count < 90)
			to_chat(user, "<span class='notice'>\The [src] is not ready to split.</span>")
			return 1
		if(!B.full && !smoked)
			to_chat(user, "<span class='notice'>Smoke \the [src] first!</span>")
			return 1
		if(closed)
			to_chat(user, "<span class='notice'>You need to open \the [src] with a crowbar before moving the bees.</span>")
			return 1
		if(B.full)
			user.visible_message("<span class='notice'>\The [user] puts the queen and the bees from \the [I] into \the [src].</span>", "<span class='notice'>You put the queen and the bees from \the [I] into \the [src].</span>")
			bee_count = 20
			B.empty()
		else
			user.visible_message("<span class='notice'>\The [user] puts bees and larvae from \the [src] into \the [I].</span>", "<span class='notice'>You put bees and larvae from \the [src] into \the [I].</span>")
			bee_count /= 2
			B.fill()
		update_icon()
		return 1
	else if(istype(I, /obj/item/device/scanner/plant))
		to_chat(user, "<span class='notice'>Scan result of \the [src]...</span>")
		to_chat(user, "Beehive is [bee_count ? "[round(bee_count)]% full" : "empty"].[bee_count > 90 ? " Colony is ready to split." : ""]")
		if(frames)
			to_chat(user, "[frames] frames installed, [round(honeycombs / 100)] filled.")
			if(honeycombs < frames * 100)
				to_chat(user, "Next frame is [round(honeycombs % 100)]% full.")
		else
			to_chat(user, "No frames installed.")
		if(smoked)
			to_chat(user, "The hive is smoked.")
		return 1
	else if(isScrewdriver(I))
		var/obj/item/weapon/tool/S = I
		if(bee_count)
			to_chat(user, "<span class='notice'>You can't dismantle \the [src] with these bees inside.</span>")
			return 1
		to_chat(user, "<span class='notice'>You start dismantling \the [src]...</span>")
		playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
		if(S.use_tool(user, src, 5 SECONDS))
			user.visible_message("<span class='notice'>\The [user] dismantles \the [src].</span>", "<span class='notice'>You dismantle \the [src].</span>")
			dismantle()
		return 1
	else
		return ..()

/obj/machinery/beehive/dismantle()
	new /obj/item/beehive_assembly(get_turf(src))
	qdel(src)

/obj/machinery/beehive/attack_hand(var/mob/user)
	if(!closed)
		if(honeycombs < 100)
			to_chat(user, "<span class='notice'>There are no filled honeycombs.</span>")
			return
		if(!smoked && bee_count)
			to_chat(user, "<span class='notice'>The bees won't let you take the honeycombs out like this, smoke them first.</span>")
			return
		user.visible_message("<span class='notice'>\The [user] starts taking the honeycombs out of \the [src].</span>", "<span class='notice'>You start taking the honeycombs out of \the [src]...</span>")
		while(honeycombs >= 100 && do_after(user, 30, src))
			new /obj/item/honey_frame/filled(loc)
			honeycombs -= 100
			--frames
			update_icon()
		if(honeycombs < 100)
			to_chat(user, "<span class='notice'>You take all filled honeycombs out.</span>")
		return

/obj/machinery/beehive/Process()
	if(closed && !smoked && bee_count)
		pollinate_flowers()
		queue_icon_update()
	smoked = max(0, smoked - 1)
	if(!smoked && bee_count)
		bee_count = min(bee_count * 1.005, 100)
		queue_icon_update()

/obj/machinery/beehive/proc/pollinate_flowers()
	var/coef = bee_count / 100
	var/trays = 0
	for(var/obj/machinery/portable_atmospherics/hydroponics/H in view(7, src))
		if(H.seed && !H.dead)
			H.health += 0.05 * coef
			++trays
	honeycombs = min(honeycombs + 0.1 * coef * min(trays, 5), frames * 100)

/obj/machinery/honey_extractor
	name = "honey extractor"
	desc = "A machine used to extract honey and wax from a beehive frame."
	icon = 'icons/obj/virology.dmi'
	icon_state = "centrifuge"
	anchored = 1
	density = 1
	circuit_type = /obj/item/weapon/circuitboard/honey_extractor

	var/processing = 0
	var/honey = 0
	var/time_end_processing = 0 //Time at which the centrifuge is done

/obj/machinery/honey_extractor/New()
	. = ..()
	ADD_SAVED_VAR(processing)
	ADD_SAVED_VAR(honey)
	ADD_SAVED_VAR(time_end_processing)

//Convert time to absolute on save, and restore it after saving
/obj/machinery/honey_extractor/before_save()
	. = ..()
	time_end_processing = max(time_end_processing - world.time, 0)
/obj/machinery/honey_extractor/after_save()
	. = ..()
	if(time_end_processing > 0)
		time_end_processing = time_end_processing + world.time
/obj/machinery/honey_extractor/after_load()
	. = ..()
	if(time_end_processing > 0)
		time_end_processing = time_end_processing + world.time
	queue_icon_update()

/obj/machinery/honey_extractor/Process()
	. = ..()
	if(processing)
		if(world.time >= time_end_processing)
			new /obj/item/honey_frame(loc)
			new /obj/item/stack/material/edible/beeswax(loc)
			honey += processing
			processing = 0
			time_end_processing = 0
			update_use_power(POWER_USE_IDLE)

/obj/machinery/honey_extractor/attackby(var/obj/item/I, var/mob/user)
	if(default_deconstruction_screwdriver(user, I))
		return 1
	else if(default_deconstruction_crowbar(user, I))
		return 1
	else if(default_part_replacement(user, I))
		return 1
	else if(istype(I, /obj/item/honey_frame))
		if(processing)
			to_chat(user, "<span class='notice'>\The [src] is currently spinning, wait until it's finished.</span>")
			return 
		var/obj/item/honey_frame/H = I
		if(!H.honey)
			to_chat(user, "<span class='notice'>\The [H] is empty, put it into a beehive.</span>")
			return
		user.visible_message("<span class='notice'>\The [user] loads \the [H] into \the [src] and turns it on.</span>", "<span class='notice'>You load \the [H] into \the [src] and turn it on.</span>")
		processing = H.honey
		qdel(H)
		time_end_processing = world.time + 60 SECONDS
		update_icon()
		update_use_power(POWER_USE_ACTIVE)
		return 1
	else if(istype(I, /obj/item/weapon/reagent_containers/glass))
		if(processing)
			to_chat(user, "<span class='notice'>\The [src] is currently spinning, wait until it's finished.</span>")
			return 
		if(!honey)
			to_chat(user, "<span class='notice'>There is no honey in \the [src].</span>")
			return
		var/obj/item/weapon/reagent_containers/glass/G = I
		var/transferred = min(G.reagents.maximum_volume - G.reagents.total_volume, honey)
		G.reagents.add_reagent(/datum/reagent/nutriment/honey, transferred)
		honey -= transferred
		user.visible_message("<span class='notice'>\The [user] collects honey from \the [src] into \the [G].</span>", "<span class='notice'>You collect [transferred] units of honey from \the [src] into \the [G].</span>")
		return 1

	return ..()

/obj/machinery/honey_extractor/on_update_icon()
	. = ..()
	if(processing)
		icon_state = "[initial(icon_state)]_moving"
	else
		icon_state = initial(icon_state)

/obj/item/bee_smoker
	name = "bee smoker"
	desc = "A device used to calm down bees before harvesting honey."
	icon = 'icons/obj/device.dmi'
	icon_state = "battererburnt"
	w_class = ITEM_SIZE_SMALL

/obj/item/honey_frame
	name = "beehive frame"
	desc = "A frame for the beehive that the bees will fill with honeycombs."
	icon = 'icons/obj/beekeeping.dmi'
	icon_state = "honeyframe"
	w_class = ITEM_SIZE_SMALL
	var/honey = 0

/obj/item/honey_frame/New()
	. = ..()
	ADD_SAVED_VAR(honey)

/obj/item/honey_frame/Initialize()
	. = ..()
	queue_icon_update()

/obj/item/honey_frame/on_update_icon()
	. = ..()
	overlays.Cut()
	if(honey > 0)
		overlays += "honeycomb"

/obj/item/honey_frame/filled
	name = "filled beehive frame"
	desc = "A frame for the beehive that the bees have filled with honeycombs."
	honey = 20

/obj/item/beehive_assembly
	name = "beehive assembly"
	desc = "Contains everything you need to build a beehive."
	icon = 'icons/obj/apiary_bees_etc.dmi'
	icon_state = "apiary"
	matter = list(MATERIAL_WOOD = 4 SHEETS)

/obj/item/beehive_assembly/attack_self(var/mob/user)
	to_chat(user, "<span class='notice'>You start assembling \the [src]...</span>")
	if(do_after(user, 30, src))
		user.visible_message("<span class='notice'>\The [user] constructs a beehive.</span>", "<span class='notice'>You construct a beehive.</span>")
		new /obj/machinery/beehive(get_turf(user))
		user.drop_from_inventory(src)
		qdel(src)
	return

// /obj/item/stack/wax
// 	name = "wax"
// 	singular_name = "wax piece"
// 	desc = "Soft substance produced by bees. Used to make candles."
// 	icon = 'icons/obj/beekeeping.dmi'
// 	icon_state = "wax"

// /obj/item/stack/wax/New()
// 	..()
// 	recipes = wax_recipes

// var/global/list/datum/stack_recipe/wax_recipes = list(
// 	new/datum/stack_recipe/candle
// )

/obj/item/bee_pack
	name = "bee pack"
	desc = "Contains a queen bee and some worker bees. Everything you'll need to start a hive!"
	icon = 'icons/obj/beekeeping.dmi'
	icon_state = "beepack"
	var/full = 1

/obj/item/bee_pack/New()
	..()
	ADD_SAVED_VAR(full)

/obj/item/bee_pack/Initialize()
	. = ..()
	queue_icon_update()
	
/obj/item/bee_pack/on_update_icon()
	. = ..()
	overlays.Cut()
	if(full)
		overlays += "beepack-full"
		SetName(initial(name))
		desc = initial(desc)
	else
		overlays += "beepack-empty"
		name = "empty bee pack"
		desc = "A stasis pack for moving bees. It's empty."
		

/obj/item/bee_pack/proc/empty()
	full = 0
	update_icon()

/obj/item/bee_pack/proc/fill()
	full = initial(full)
	update_icon()

/obj/structure/closet/crate/hydroponics/beekeeping
	name = "beekeeping crate"
	desc = "All you need to set up your own beehive."
	
/obj/structure/closet/crate/hydroponics/beekeeping/WillContain()
	return list(/obj/item/beehive_assembly = 1,
		/obj/item/bee_smoker = 1,
		/obj/item/honey_frame = 5,
		/obj/item/bee_pack = 1,
		/obj/item/weapon/tool/crowbar = 1)
