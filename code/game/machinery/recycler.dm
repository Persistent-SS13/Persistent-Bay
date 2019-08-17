#define RECYCLER_MAX_SANE_CONTAINER_DEPTH 50 //Used to prevent ending up with an infinite recursion when adding up contained items

var/const/SAFETY_COOLDOWN = 100
var/const/OUTPUT_DELAY = 5 SECONDS //intervals between material being outputed by the machine

/obj/machinery/recycler
	name = "crusher"
	desc = "A large crushing machine which is used to recycle small items ineffeciently; there are lights on the side of it."
	icon = 'icons/obj/recycling.dmi'
	icon_state = "grinder-o0"
	layer = MOB_LAYER+1 // Overhead
	anchored = 1
	density = 1
	circuit_type = /obj/item/weapon/circuitboard/recycler
	var/safety_mode = 0 // Temporality stops the machine if it detects a mob
	var/grinding = 0
	var/icon_name = "grinder-o"
	var/blood = 0
	var/eat_dir = WEST
	var/amount_produced = 1
	var/list/stored_material = list()
	var/efficiency = 0.5 //Percentage of materials recovered from the recycled item
	var/timelastoutput = 0
	var/sound_idle = 'sound/machines/creaky_loop.ogg'
	var/sound_processing = 'sound/machines/machine_wirr.ogg'
	var/sound_outputs = 'sound/machines/hiss.ogg'
	var/datum/sound_token/sound_looping = null
	var/const/soundid = "Recyclers"

	use_power = POWER_USE_IDLE
	idle_power_usage = 100 //Watts
	active_power_usage = 800 //Watts

	//Radio stuff
	id_tag 				= null
	frequency 			= MISC_MACHINE_FREQ
	radio_filter_in 	= RADIO_RECYCLER
	radio_filter_out 	= RADIO_RECYCLER
	radio_check_id 		= TRUE

/obj/machinery/recycler/New()
	..()
	ADD_SAVED_VAR(blood)
	ADD_SAVED_VAR(stored_material)
	ADD_SAVED_VAR(eat_dir)
	ADD_SAVED_VAR(efficiency)

/obj/machinery/recycler/SetupReagents()
	. = ..()
	if(!reagents)
		create_reagents(500)

/obj/machinery/recycler/Initialize()
	. = ..()
	assign_uid() //used for looping sound
	queue_icon_update()

/obj/machinery/recycler/Destroy()
	dump_materials()
	QDEL_NULL(sound_looping)
	return ..()

/obj/machinery/recycler/examine()
	set src in view()
	..()
	to_chat(usr, "The power light is [(stat & NOPOWER) ? "off" : "on"].")
	to_chat(usr, "The safety-mode light is [safety_mode ? "on" : "off"].")
	to_chat(usr, "The safety-sensors status light is [emagged ? "off" : "on"].")

/obj/machinery/recycler/power_change()
	..()
	update_icon()
	update_sound()

/obj/machinery/recycler/proc/update_sound()
	if(operable() && !safety_mode)
		if(!sound_looping)
			sound_looping = GLOB.sound_player.PlayLoopingSound(src, soundid, sound_idle, 25, 5, 2)
		else
			sound_looping.Unpause()
	else if(sound_looping)
		sound_looping.Pause()

/obj/machinery/recycler/emag_act(mob/user)
	if(!emagged)
		emagged = 1
		if(safety_mode)
			safety_mode = 0
			update_icon()
		playsound(loc, "sparks", 75, 1, -1)
		to_chat(user, "<span class='notice'>You use the cryptographic sequencer on the [name].</span>")

/obj/machinery/recycler/on_update_icon()
	..()
	var/is_powered = operable()
	if(safety_mode)
		is_powered = 0
	icon_state = icon_name + "[is_powered]" + "[(blood ? "bld" : "")]" // add the blood tag at the end

// This is purely for admin possession !FUN!.
/obj/machinery/recycler/Bump(var/atom/movable/AM)
	..()
	if(AM)
		Bumped(AM)

/obj/machinery/recycler/Bumped(var/atom/movable/AM)
	if(QDELETED(AM))
		return
	if(inoperable())
		return
	if(safety_mode)
		return
	// If we're not already grinding something.
	if(!grinding)
		grinding = 1
	else
		return

	var/move_dir = get_dir(loc, AM.loc)
	if(move_dir == eat_dir)
		update_use_power(POWER_USE_ACTIVE)
		if(isliving(AM))
			if(can_crush(AM))
				eat(AM)
			else
				stop(AM)
		else if(can_recycle(AM))
			recycle(AM)
		else // Can't recycle
			playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
			AM.loc = src.loc
		update_use_power(POWER_USE_IDLE)
	grinding = 0

/obj/machinery/recycler/proc/extract_reagents(var/obj/thing)
	if(!thing || (thing && !thing.reagents))
		return

	if(thing.reagents.total_volume < 1)
		return //Don't bother if its a tiny quantity
	var/overflow = max(0, (thing.reagents.total_volume + reagents.total_volume) - reagents.maximum_volume)
	thing.reagents.trans_to_obj(src, efficiency * min(thing.reagents.total_volume, reagents.maximum_volume))
	if(overflow && src.loc)
		thing.reagents.splash(src.loc, overflow) //splash around the thing


/obj/machinery/recycler/proc/extract_materials(var/obj/thing, var/depth = 0)
	if(!thing || (thing && !thing.matter) || depth > RECYCLER_MAX_SANE_CONTAINER_DEPTH)
		return

	//First deal with the content recursively
	for(var/subthing in thing.contents)
		extract_materials(subthing, ++depth)
		extract_reagents(subthing)

	//Then recycle the thing itself
	for(var/mat in thing.matter)
		var/material/M = SSmaterials.get_material_by_name(mat)
		if(!istype(M))
			continue
		stored_material[mat] += efficiency * thing.matter[mat]
	extract_reagents(thing)


/obj/machinery/recycler/proc/recycle(var/obj/I, var/sound = 1)
	I.loc = src.loc
	if(istype(I, /obj/item/organ/internal/stack)) //Don't eat laces
		return

	if(istype(I, /obj/item))
		extract_materials(I)
	else if(istype(I, /obj/structure/closet) && !I.anchored) //Opened closets/crates
		var/obj/structure/closet/thatcloset = I
		if(thatcloset.opened)
			extract_materials(I)
	else if(istype(I, /obj/structure) && !I.anchored) //loose structures, etc..
		extract_materials(I)
	else if(istype(I, /obj/machinery) && !I.anchored) //loose machines
		extract_materials(I)
	else if(istype(I,/obj/effect/decal) && !I.anchored) //Wreckages/junk
		extract_materials(I)
	else
		return //Nothing for us

	qdel(I)
	if(sound)
		playsound(src.loc, sound_processing, 50, vary=TRUE, extrarange=8, falloff=3)
	output_materials()

/obj/machinery/recycler/proc/stop(var/mob/living/L)
	playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 40, vary=FALSE, extrarange=8, falloff=3)
	safety_mode = 1
	update_icon()
	L.loc = src.loc

	spawn(SAFETY_COOLDOWN)
		ping()
		//playsound(src.loc, 'sound/machines/ping.ogg', 30, vary=FALSE, extrarange=8, falloff=3)
		safety_mode = 0
		update_icon()
		update_sound()

/obj/machinery/recycler/proc/eat(var/mob/living/L)
	L.loc = src.loc
	var/gib = can_gib(L)

	if(!issilicon(L))
		add_blood(L)
		L.emote("scream")
		if(!blood)
			blood = 1
			update_icon()
		playsound(src.loc, 'sound/effects/splat.ogg', 50, 1)
	else
		playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
	playsound(src.loc, sound_processing, 30, vary=TRUE, extrarange=8, falloff=3)

	L.Weaken(5)
	L.adjustBruteLoss(200)

	// Remove and recycle the equipped items.
	for(var/obj/item/I in L.get_equipped_items())
		if(L.unEquip(I))
			recycle(I, 0)
	if(gib)
		L.loc = eat_dir
		L.gib()
		if(!issilicon(L))
			stored_material["pinkgoo"] += L.getMaxHealth() * 2 //Generate a bit of goop from the health of the mob
	output_materials()

/obj/machinery/recycler/Process()
	if(operable())
		output_materials()

/obj/machinery/recycler/proc/output_materials()
	if((timelastoutput + OUTPUT_DELAY) > world.time) //Wait a bit first
		return
	for(var/material_key in stored_material)
		var/material/M = SSmaterials.get_material_by_name(material_key)
		var/nbstored = stored_material[material_key]
		if(!M || !nbstored)
			continue
		if(nbstored >= M.units_per_sheet)
			var/nbheets = round(nbstored / M.units_per_sheet)
			stored_material[material_key] -= nbheets * M.units_per_sheet
			M.place_sheet(get_turf(src), nbheets)
			use_power_oneoff(500) //Use some more power to output the stuff
			playsound(src, sound_outputs, 30, vary=TRUE, extrarange=8, falloff=3)
			break //Only output one kind of material per call

	timelastoutput = world.time

//Dump out all contained materials and reagents
/obj/machinery/recycler/proc/dump_materials()
	for(var/material_key in stored_material)
		var/material/M = SSmaterials.get_material_by_name(material_key)
		var/nbstored = stored_material[material_key]
		if(!M || !nbstored)
			continue
		//OUTPUT TO DUST

//Since there are no sprites for other dir, we improvise
/obj/machinery/recycler/rotate()
	var/mob/living/user = usr

	if(usr.incapacitated())
		return
	if(anchored)
		to_chat(usr, "[src] is fastened to the floor!")
		return 0
	eat_dir = turn(eat_dir, 270)
	to_chat(user, "<span class='notice'>[src] will now accept items from [dir2text(eat_dir)].</span>")
	return 1

/obj/machinery/recycler/verb/rotateccw()
	set name = "Rotate Counter Clockwise"
	set category = "Object"
	set src in oview(1)

	var/mob/living/user = usr

	if(usr.incapacitated())
		return
	if(anchored)
		to_chat(usr, "[src] is fastened to the floor!")
		return 0
	eat_dir = turn(eat_dir, 90)
	to_chat(user, "<span class='notice'>[src] will now accept items from [dir2text(eat_dir)].</span>")
	return 1

/obj/machinery/recycler/attackby(var/obj/item/O as obj, var/mob/user as mob)
	add_fingerprint(user)
	if(istype(O, /obj/item/weapon/tool/wrench))
		if(!anchored)
			usr.visible_message("<span class='notice'>[user] secures the bolts of the [src]</span>", "<span class='notice'>You secure the bolts of the [src]</span>", "Someone's securing some bolts")
			src.anchored = 1
		else
			usr.visible_message("<span class='danger'>[user] unsecures the bolts of the [src]!</span>", "<span class='notice'>You unsecure the bolts of the [src]</span>", "Someone's unsecuring some bolts")
			src.anchored = 0

	if(default_deconstruction_screwdriver(user, O))
		updateUsrDialog()
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	else if(istype(O, /obj/item/weapon/reagent_containers/glass))
		var/obj/item/weapon/reagent_containers/glass/thatcontainer = O
		if(thatcontainer.reagents.total_volume >= thatcontainer.reagents.maximum_volume || reagents.total_volume < 1)
			return
		reagents.trans_to_obj(thatcontainer, thatcontainer.reagents.maximum_volume)
		to_chat(user, SPAN_NOTICE("You transfer some waste liquid from [src] to the [thatcontainer]."))
		return
	return ..()


/obj/machinery/recycler/proc/can_process(var/atom/movable/AM)
	return can_recycle(AM) || can_crush(AM)

//Don't let human/xenos get crushed, unless they're fodder animals(monkeys, stok, etc..)
/obj/machinery/recycler/proc/can_crush(var/atom/movable/AM)
	return istype(AM, /mob/living) &&\
		(!istype(AM, /mob/living/carbon/human) ||\
		(istype(AM, /mob/living/carbon/human/monkey) || istype(AM, /mob/living/carbon/human/stok) || istype(AM, /mob/living/carbon/human/farwa) || istype(AM, /mob/living/carbon/human/neaera))\
		)

/obj/machinery/recycler/proc/can_recycle(var/atom/movable/AM)
	if(istype(AM, /obj/item/organ/internal/stack)) //Don't eat laces
		return FALSE
	if(AM.anchored)
		return FALSE
	else if(istype(AM, /obj/structure/closet)) //Opened closets/crates
		var/obj/structure/closet/thatcloset = AM
		if(!thatcloset.opened)
			return FALSE
	return TRUE

/obj/machinery/recycler/proc/can_gib(var/atom/movable/AM)
	return isanimal(AM) || issilicon(AM)||\
		istype(AM, /mob/living/bot) ||\
		istype(AM, /mob/living/carbon/human/monkey) ||\
		istype(AM, /mob/living/carbon/human/stok) ||\
		istype(AM, /mob/living/carbon/human/farwa) ||\
		istype(AM, /mob/living/carbon/human/neaera) ||\
		isslime(AM)? TRUE : FALSE

/obj/machinery/recycler/OnSignal(datum/signal/signal)
	. = ..()
	if(signal.data["activate"])
		if(ison())
			turn_off()
		else if(isoff())
			turn_idle()
		update_sound()

#undef RECYCLER_MAX_SANE_CONTAINER_DEPTH