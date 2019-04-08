/obj/structure/window
	name = "window"
	desc = "A window."
	icon = 'icons/obj/window.dmi'
	density = 1
	w_class = ITEM_SIZE_NORMAL

	layer = SIDE_WINDOW_LAYER
	anchored = 1.0
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CHECKS_BORDER
	alpha = 180
	var/material/reinf_material
	var/init_material = MATERIAL_GLASS
	var/init_reinf_material = null
	max_health = 30
	var/damage_per_fire_tick = 2.0 		// Amount of damage per fire tick. Regular windows are not fireproof so they might as well break quickly.
	var/construction_state = 2
	var/ini_dir = null
	var/polarized = 0
	var/basestate = "window"
	var/reinf_basestate = "rwindow"
	blend_objects = list(/obj/machinery/door, /turf/simulated/wall) // Objects which to blend with
	noblend_objects = list(/obj/machinery/door/window)
	sound_hit = 'sound/effects/Glasshit.ogg'
	sound_destroyed = "shatter"
	
	armor = list(
		DAM_BLUNT  	= 10,
		DAM_PIERCE 	= 5,
		DAM_CUT 	= 20,
		DAM_BULLET 	= 5,
		DAM_ENERGY 	= 5,
		DAM_BURN 	= 30,
		DAM_BOMB 	= 10,
		DAM_EMP 	= MaxArmorValue,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)
	damthreshold_brute 	= 5
	damthreshold_burn = 5

	atmos_canpass = CANPASS_PROC

/obj/structure/window/get_material()
	return material

/obj/structure/window/New(Loc, start_dir=null, constructed=0, var/new_material, var/new_reinf_material)
	..()
	ADD_SAVED_VAR(state)
	ADD_SAVED_VAR(reinf_material)
	ADD_SAVED_VAR(init_material)
	ADD_SAVED_VAR(init_reinf_material)
	ADD_SAVED_VAR(reinf_basestate)

/obj/structure/window/Initialize(mapload, start_dir=null, constructed=0, var/new_material, var/new_reinf_material)
	. = ..()
	if(!new_material)
		new_material = init_material
		if(!new_material)
			new_material = MATERIAL_GLASS
	if(!new_reinf_material)
		new_reinf_material = init_reinf_material
	material = SSmaterials.get_material_by_name(new_material)
	if(!istype(material))
		return INITIALIZE_HINT_QDEL

	if(new_reinf_material)
		reinf_material = SSmaterials.get_material_by_name(new_reinf_material)

	name = "[reinf_material ? "reinforced " : ""][material.display_name] window"
	desc = "A window pane made from [material.display_name]."
	color =  material.icon_colour

	if (start_dir)
		set_dir(start_dir)

	max_health = material.integrity
	if(reinf_material)
		max_health += 0.25 * reinf_material.integrity

	if(is_fulltile())
		max_health *= 4
		layer = FULL_WINDOW_LAYER

	health = max_health

	set_anchored(!constructed)
	update_connections(1)
	update_icon()
	update_nearby_tiles(need_rebuild=1)

/obj/structure/window/Destroy()
	set_density(0)
	update_nearby_tiles()
	var/turf/location = loc
	. = ..()
	for(var/obj/structure/window/W in orange(location, 1))
		W.update_icon()

/obj/structure/window/examine(mob/user)
	. = ..(user)
	if(reinf_material)
		to_chat(user, "<span class='notice'>It is reinforced with the [reinf_material.display_name] lattice.</span>")
	if(health == max_health)
		to_chat(user, "<span class='notice'>It looks fully intact.</span>")
	else
		var/perc = health / max_health
		if(perc > 0.75)
			to_chat(user, "<span class='notice'>It has a few cracks.</span>")
		else if(perc > 0.5)
			to_chat(user, "<span class='warning'>It looks slightly damaged.</span>")
		else if(perc > 0.25)
			to_chat(user, "<span class='warning'>It looks moderately damaged.</span>")
		else
			to_chat(user, "<span class='danger'>It looks heavily damaged.</span>")

/obj/structure/window/after_load()
	dir = saved_dir
	ini_dir = dir
	update_nearby_tiles(need_rebuild=1)
	..()
	update_icon()

/obj/structure/window/CanFluidPass(var/coming_from)
	return (!is_fulltile() && coming_from != dir)

/obj/structure/window/Write(savefile/f)
	saved_dir = dir
	..()

/obj/structure/window/damage_description(var/mob/user)
	. = ..() + "\n"
	if(silicate)
		if (silicate < 30)
			. += SPAN_NOTICE("It has a thin layer of silicate.")
		else if (silicate < 70)
			. +=  SPAN_NOTICE("It is covered in silicate.")
		else
			. += SPAN_NOTICE("There is a thick layer of silicate covering it.")

/obj/structure/window/take_damage(damage, damtype, armorbypass, damsrc)
	var/initialhealth = health
	if(silicate)
		damage = damage * (1 - silicate / max_silicate)
	..(damage, damtype, armorbypass, damsrc)
	if(health < get_max_health() / 4 && initialhealth >= get_max_health() / 4)
		visible_message(SPAN_WARNING("[src] looks like it's about to shatter!"))
	else if(health < get_max_health() / 2 && initialhealth >= get_max_health() / 2)
		visible_message(SPAN_WARNING("[src] looks seriously damaged!"))
	else if(health < get_max_health() * 3/4 && initialhealth >= get_max_health() * 3/4)
		visible_message("Cracks begin to appear in [src]!" )

/obj/structure/window/proc/apply_silicate(var/amount)
	if(isdamaged()) // Mend the damage
		add_health(amount * 3)
		if(!isdamaged())
			visible_message(SPAN_NOTICE("[src] looks fully repaired."))
	else // Reinforce
		silicate = min(silicate + amount, max_silicate)
		updateSilicate()

/obj/structure/window/proc/updateSilicate()
	if (overlays)
		overlays.Cut()

	var/image/img = image(src.icon, src.icon_state)
	img.color = "#ffffff"
	img.alpha = silicate * 255 / max_silicate
	overlays += img

/obj/structure/window/destroyed()
	visible_message(SPAN_DANGER("[src] shatters!"))
	cast_new(shardtype, is_fulltile() ? 4 : 1, loc)
	if(reinf)
		cast_new(/obj/item/stack/rods, is_fulltile() ? 4 : 1, loc)
	..()

//TODO: Make full windows a separate type of window.
//Once a full window, it will always be a full window, so there's no point
//having the same type for both.
/obj/structure/window/proc/is_full_window()
	return (dir == SOUTHWEST || dir == SOUTHEAST || dir == NORTHWEST || dir == NORTHEAST)

/obj/structure/window/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASS_FLAG_GLASS))
		return 1
	if(is_fulltile())
		return 0	//full tile window, you can't move into it!
	if(get_dir(loc, target) & dir)
		return !density
	else
		return 1

/obj/structure/window/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASS_FLAG_GLASS))
		return 1
	if(get_dir(O.loc, target) == dir)
		return 0
	return 1


/obj/structure/window/hitby(AM as mob|obj, speed = THROWFORCE_SPEED_DIVISOR)
	var/tforce = 0
	if(ismob(AM)) // All mobs have a multiplier and a size according to mob_defines.dm
		var/mob/I = AM
		tforce = I.mob_size * 2 * I.throw_multiplier
	else if(isobj(AM))
		var/obj/item/I = AM
		tforce = I.throwforce
	if(reinf_material) tforce *= 0.25
	if(health - tforce <= 7 && !reinf_material)
		set_anchored(FALSE)
		step(src, get_dir(AM, src))
	..(AM,speed,tforce)

/obj/structure/window/attack_tk(mob/user as mob)
	user.visible_message(SPAN_NOTICE("Something knocks on [src]."))
	playsound(loc, sound_hit, vol=50, vary=1, extrarange=8, falloff=6)

/obj/structure/window/attack_hand(mob/user as mob)
	if(MUTATION_HULK in user.mutations)
		..(user,100)
		return 1
	else if (usr.a_intent == I_HURT)
		if (istype(usr,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = usr
			if(H.species.can_shred(H))
				..(H,25)
				return 1
		
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		playsound(src.loc, 'sound/effects/glassknock.ogg', vol=100, vary=1, extrarange=12, falloff=10)
		user.do_attack_animation(src)
		usr.visible_message("<span class='danger'>\The [usr] bangs against \the [src]!</span>",
							"<span class='danger'>You bang against \the [src]!</span>",
							"You hear a banging sound.")
		return 1
	else if (usr.a_intent == I_HELP)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		playsound(src.loc, 'sound/effects/glassknock.ogg', vol=80, vary=1, extrarange=8, falloff=6)
		usr.visible_message("[usr.name] knocks on the [src.name].",
							"You knock on the [src.name].",
							"You hear a knocking sound.")
		return 1
	return ..()

/obj/structure/window/attack_generic(var/mob/user, var/damage, var/attack_verb, var/environment_smash)
	if(environment_smash >= 1)
		damage = max(damage, 10)
	if(damage >= 10)
		visible_message(SPAN_DANGER("[user] [attack_verb] into [src]!"))
		return ..(user, damage, attack_verb, environment_smash)
	else
		visible_message(SPAN_NOTICE("\The [user] bonks \the [src] harmlessly."))
		if(istype(user))
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			user.do_attack_animation(src)
	return 1

/obj/structure/window/attackby(obj/item/W as obj, mob/user as mob)
	if(isScrewdriver(W))
		if(reinf && state >= 1)
			state = 3 - state
			update_nearby_icons()
			playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
			to_chat(user, (state == 1 ? "<span class='notice'>You have unfastened the window from the frame.</span>" : "<span class='notice'>You have fastened the window to the frame.</span>"))
		else if(reinf && state == 0)
			set_anchored(!anchored)
			playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
			to_chat(user, (anchored ? "<span class='notice'>You have fastened the frame to the floor.</span>" : "<span class='notice'>You have unfastened the frame from the floor.</span>"))
		else if(!reinf)
			set_anchored(!anchored)
			playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
			to_chat(user, (anchored ? "<span class='notice'>You have fastened the window to the floor.</span>" : "<span class='notice'>You have unfastened the window.</span>"))
		return 1
	else if(isCrowbar(W) && reinf && state <= 1)
		state = 1 - state
		playsound(loc, 'sound/items/Crowbar.ogg', 75, 1)
		to_chat(user, (state ? "<span class='notice'>You have pried the window into the frame.</span>" : "<span class='notice'>You have pried the window out of the frame.</span>"))
		return 1
	else if(isWrench(W) && !anchored && (!state || !reinf))
		if(!glasstype)
			to_chat(user, "<span class='notice'>You're not sure how to dismantle \the [src] properly.</span>")
		else
			playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
			visible_message("<span class='notice'>[user] dismantles \the [src].</span>")
			if(dir == SOUTHWEST)
				var/obj/item/stack/material/mats = new glasstype(loc)
				mats.amount = is_fulltile() ? 4 : 2
			else
				new glasstype(loc)
			qdel(src)
		return 1
	else if(isCoil(W) && reinf && !polarized)
		var/obj/item/stack/cable_coil/C = W
		if (C.use(1))
			playsound(src.loc, 'sound/effects/sparks1.ogg', 75, 1)
			var/obj/structure/window/reinforced/polarized/P = new(loc)
			P.set_dir(dir)
			P.health = health
			P.state = state
			P.icon_state = icon_state
			P.basestate = basestate
			P.update_icon()
			qdel(src)
		return 1
	else
		return ..()

/obj/structure/window/AltClick()
	rotate()

/obj/structure/window/proc/rotate()
	set name = "Rotate Window Counter-Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if(anchored)
		to_chat(usr, "It is fastened to the floor therefore you can't rotate it!")
		return 0

	update_nearby_tiles(need_rebuild=1) //Compel updates before
	set_dir(turn(dir, 90))
	updateSilicate()
	update_nearby_tiles(need_rebuild=1)
	return


/obj/structure/window/proc/revrotate()
	set name = "Rotate Window Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if(anchored)
		to_chat(usr, "It is fastened to the floor therefore you can't rotate it!")
		return 0

	update_nearby_tiles(need_rebuild=1) //Compel updates before
	set_dir(turn(dir, 270))
	updateSilicate()
	update_nearby_tiles(need_rebuild=1)
	return


/obj/structure/window/Move()
	var/ini_dir = dir
	update_nearby_tiles(need_rebuild=1)
	..()
	set_dir(ini_dir)
	update_nearby_tiles(need_rebuild=1)

//checks if this window is full-tile one
/obj/structure/window/proc/is_fulltile()
	if(dir & (dir - 1))
		return 1
	return 0

/obj/structure/window/set_anchored(var/new_anchored)
	if(anchored == new_anchored)
		return
	..()
	update_verbs()
	update_nearby_icons()
	update_connections(1)

//This proc is used to update the icons of nearby windows. It should not be confused with update_nearby_tiles(), which is an atmos proc!
/obj/structure/window/proc/update_nearby_icons()
	update_icon()
	for(var/obj/structure/window/W in orange(src, 1))
		W.update_icon()

//Updates the availabiliy of the rotation verbs
/obj/structure/window/proc/update_verbs()
	if(anchored)
		verbs -= /obj/structure/window/proc/rotate
		verbs -= /obj/structure/window/proc/revrotate
	else
		verbs += /obj/structure/window/proc/rotate
		verbs += /obj/structure/window/proc/revrotate


// Visually connect with every type of window as long as it's full-tile.
/obj/structure/window/can_visually_connect()
	return ..() && is_fulltile()

/obj/structure/window/can_visually_connect_to(var/obj/structure/S)
	return istype(S, /obj/structure/window)

//merges adjacent full-tile windows into one (blatant ripoff from game/smoothwall.dm)
/obj/structure/window/on_update_icon()
	//A little cludge here, since I don't know how it will work with slim windows. Most likely VERY wrong.
	//this way it will only update full-tile ones
	if(reinf_material)
		basestate = reinf_basestate
	else
		basestate = initial(basestate)
	overlays.Cut()
	layer = FULL_WINDOW_LAYER
	if(!is_fulltile())
		layer = SIDE_WINDOW_LAYER
		icon_state = basestate
		return

	var/image/I
	icon_state = ""
	if(is_on_frame())
		for(var/i = 1 to 4)
			if(other_connections[i] != "0")
				I = image(icon, "[basestate]_other_onframe[connections[i]]", dir = 1<<(i-1))
			else
				I = image(icon, "[basestate]_onframe[connections[i]]", dir = 1<<(i-1))
			overlays += I
	else
		for(var/i = 1 to 4)
			if(other_connections[i] != "0")
				I = image(icon, "[basestate]_other[connections[i]]", dir = 1<<(i-1))
			else
				I = image(icon, "[basestate][connections[i]]", dir = 1<<(i-1))
			overlays += I

/obj/structure/window/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	var/melting_point = material.melting_point
	if(reinf_material)
		melting_point += 0.25*reinf_material.melting_point
	if(exposed_temperature > melting_point)
		hit(damage_per_fire_tick, 0)
	..()

/obj/structure/window/basic
	desc = "It looks thin and flimsy. A few knocks with... anything, really should shatter it."
	icon_state = "window"
	glasstype = /obj/item/stack/material/glass
	maximal_heat = T0C + 100
	damage_per_fire_tick = 2.0
	max_health = 60
	material_color = GLASS_COLOR
	color = GLASS_COLOR

/obj/structure/window/basic/full
	dir = 5
	icon_state = "window_full"

/obj/structure/window/phoronbasic
	name = "phoron window"
	desc = "A borosilicate alloy window. It seems to be quite strong."
	icon_state = "phoronwindow"
	max_health = 80
	color = GLASS_COLOR_PHORON
	init_material = MATERIAL_PHORON_GLASS
	armor = list(
		DAM_BLUNT  	= 50,
		DAM_PIERCE 	= 55,
		DAM_CUT 	= 85,
		DAM_BULLET 	= 50,
		DAM_ENERGY 	= 50,
		DAM_BURN 	= 95,
		DAM_BOMB 	= 80,
		DAM_EMP 	= MaxArmorValue,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)
	damthreshold_brute 	= 10
	damthreshold_burn = 10

/obj/structure/window/phoronbasic/full
	dir = 5
	icon_state = "window_full"

/obj/structure/window/phoronreinforced
	name = "reinforced borosilicate window"
	desc = "A borosilicate alloy window, with rods supporting it. It seems to be very strong."
	icon_state = "rwindow"
	max_health = 200
	color = GLASS_COLOR_PHORON
	init_material = MATERIAL_PHORON_GLASS
	init_reinf_material = MATERIAL_STEEL
	armor = list(
		DAM_BLUNT  	= 85,
		DAM_PIERCE 	= 85,
		DAM_CUT 	= MaxArmorValue,
		DAM_BULLET 	= 80,
		DAM_ENERGY 	= 80,
		DAM_BURN 	= MaxArmorValue,
		DAM_BOMB 	= 80,
		DAM_EMP 	= MaxArmorValue,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)
	damthreshold_brute 	= 10
	damthreshold_burn = 10

/obj/structure/window/phoronreinforced/full
	dir = 5
	icon_state = "window_full"

/obj/structure/window/reinforced
	name = "reinforced window"
	desc = "It looks rather strong. Might take a few good hits to shatter it."
	icon_state = "rwindow"
	init_material = MATERIAL_GLASS
	init_reinf_material = MATERIAL_STEEL
	max_health = 90
	armor = list(
		DAM_BLUNT  	= 40,
		DAM_PIERCE 	= 35,
		DAM_CUT 	= 50,
		DAM_BULLET 	= 40,
		DAM_ENERGY 	= 30,
		DAM_BURN 	= 50,
		DAM_BOMB 	= 30,
		DAM_EMP 	= MaxArmorValue,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)
	damthreshold_brute 	= 10
	damthreshold_burn = 5

/obj/structure/window/fiberglass
	name = "fiberglass window"
	desc = "It looks strong and sleek. It may not even shatter."
	icon_state = "rwindow"
	basestate = "rwindow"
	max_health = 120
	maximal_heat = T0C + 90
	damage_per_fire_tick = 5.0 // These windows are not built for fire
	shardtype = /obj/item/weapon/material/shard/fiberglass
	glasstype = /obj/item/stack/material/glass/fiberglass
	material_color = GLASS_COLOR_FROSTED
	color = GLASS_COLOR_FROSTED
	armor = list(
		DAM_BLUNT  	= MaxArmorValue,
		DAM_PIERCE 	= MaxArmorValue,
		DAM_CUT 	= MaxArmorValue,
		DAM_BULLET 	= 90,
		DAM_ENERGY 	= 30,
		DAM_BURN 	= 10,
		DAM_BOMB 	= 40,
		DAM_EMP 	= MaxArmorValue,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)
	damthreshold_brute 	= 15
	damthreshold_burn = 2

/obj/structure/window/New(Loc, constructed=0)
	..()

	//player-constructed windows
	if (constructed)
		state = 0
	update_connections(1)

/obj/structure/window/Initialize()
	. = ..()
	layer = is_full_window() ? FULL_WINDOW_LAYER : SIDE_WINDOW_LAYER

/obj/structure/window/reinforced/full
	dir = 5
	icon_state = "rwindow_full"

/obj/structure/window/reinforced/tinted
	name = "tinted window"
	desc = "It looks rather strong and opaque. Might take a few good hits to shatter it."
	icon_state = "window"
	opacity = 1
	color = GLASS_COLOR_TINTED

/obj/structure/window/reinforced/tinted/frosted
	name = "frosted window"
	desc = "It looks rather strong and frosted over. Looks like it might take a few less hits than a normal reinforced window."
	icon_state = "window"
	color = GLASS_COLOR_FROSTED

/obj/structure/window/shuttle
	name = "shuttle window"
	desc = "It looks rather strong. Might take a few good hits to shatter it."
	icon = 'icons/obj/podwindows.dmi'
	max_health = 200
	reinf_basestate = "w"
	dir = 5
	armor = list(
		DAM_BLUNT  	= 50,
		DAM_PIERCE 	= 50,
		DAM_CUT 	= 60,
		DAM_BULLET 	= 90,
		DAM_ENERGY 	= 40,
		DAM_BURN 	= 80,
		DAM_BOMB 	= 50,
		DAM_EMP 	= MaxArmorValue,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)
	damthreshold_brute 	= 10
	damthreshold_burn = 10

/obj/structure/window/reinforced/polarized
	name = "electrochromic window"
	desc = "Adjusts its tint with voltage. Might take a few good hits to shatter it."
	basestate = "rwindow"
	var/id
	polarized = 1

/obj/structure/window/reinforced/polarized/full
	dir = 5
	icon_state = "rwindow_full"

/obj/structure/window/reinforced/polarized/attackby(obj/item/W as obj, mob/user as mob)
	if(isMultitool(W))
		var/t = sanitizeSafe(input(user, "Enter the ID for the window.", src.name, null), MAX_NAME_LEN)
		if (user.get_active_hand() != W)
			return
		if (!in_range(src, user) && src.loc != user)
			return
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if (t)
			src.id = t
			to_chat(user, "<span class='notice'>The new ID of the window is [id]</span>")
		return
	..()

/obj/structure/window/reinforced/polarized/proc/toggle()
	if(opacity)
		animate(src, color=material_color, time=5)
		set_opacity(0)
	else
		animate(src, color=GLASS_COLOR_TINTED, time=5)
		set_opacity(1)

/obj/structure/window/reinforced/crescent/attack_hand()
	return

/obj/structure/window/reinforced/crescent/attackby()
	return

/obj/structure/window/reinforced/crescent/ex_act()
	return

/obj/structure/window/reinforced/crescent/hitby()
	return

/obj/structure/window/reinforced/crescent/take_damage()
	return

/obj/structure/window/reinforced/crescent/destroyed()
	return


/obj/structure/window/proc/update_onframe()
	var/success = FALSE
	var/turf/T = get_turf(src)
	for(var/obj/O in T)
		if(istype(O, /obj/structure/wall_frame))
			success = TRUE
		if(success)
			break
	if(success)
		on_frame = TRUE
	else
		on_frame = FALSE
