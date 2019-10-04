/*
 * Welding Tool
 */
/obj/item/weapon/tool/weldingtool
	name = "welding tool"
	icon = 'icons/obj/tools.dmi'
	icon_state = "welder"
	item_state = "welder"
	desc = "A heavy but portable welding gun with its own interchangeable fuel tank. It features a simple toggle switch and a port for attaching an external tank."
	description_info = "Use in your hand to toggle the welder on and off. Hold in one hand and click with an empty hand to remove its internal tank. Click on an object to try to weld it. You can seal airlocks, attach heavy-duty machines like emitters and disposal chutes, and repair damaged walls - these are only a few of its uses. Each use of the welder will consume a unit of fuel. Be sure to wear protective equipment such as goggles, a mask, or certain voidsuit helmets to prevent eye damage. You can refill the welder with a welder tank by clicking on it, but be sure to turn it off first!"
	description_fluff = "One of many tools of ancient design, still used in today's busy world of engineering with only minor tweaks here and there. Compact machinery and innovations in fuel storage have allowed for conveniences like this one-piece, handheld welder to exist."
	description_antag = "You can use a welder to rapidly seal off doors, ventilation ducts, and scrubbers. It also makes for a devastating weapon. Modify it with a screwdriver and stick some metal rods on it, and you've got the beginnings of a flamethrower."
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	center_of_mass = "x=14;y=15"

	//Amount of OUCH when it's thrown
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL

	//Cost to make in the autolathe
	matter = list(MATERIAL_STEEL = 210, MATERIAL_GLASS = 90)

	//R&D tech level
	origin_tech = list(TECH_ENGINEERING = 1)

	//Welding tool specific stuff
	var/welding = 0 	//Whether or not the welding tool is off(0), on(1) or currently welding(2)
	var/status = 1 		//Whether the welder is secured or unsecured (able to attach rods to it to make a flamethrower)

	var/obj/item/weapon/welder_tank/tank = new /obj/item/weapon/welder_tank() // where the fuel is stored
	var/fuel_rate = 0.05 //The idle fuel burn rate while the welder is on
	var/fuel_cost_use = 1 //The initial fuel cost for various actions
	var/welding_efficiency = 1.0 //Base welding multiplier for fuel use
	var/welding_resource = /datum/reagent/fuel

/obj/item/weapon/tool/weldingtool/empty
	tank = new /obj/item/weapon/welder_tank/empty()

/obj/item/weapon/tool/weldingtool/New()
	..()
	ADD_SAVED_VAR(tank)

/obj/item/weapon/tool/weldingtool/Initialize()
	set_extension(src, /datum/extension/base_icon_state, /datum/extension/base_icon_state, icon_state)
	. = ..()
	queue_icon_update()

/obj/item/weapon/tool/weldingtool/Destroy()
	if(welding)
		STOP_PROCESSING(SSobj, src)
	QDEL_NULL(tank)
	return ..()

/obj/item/weapon/tool/weldingtool/examine(mob/user)
	if(..(user, 0))
		show_fuel(user)

/obj/item/weapon/tool/weldingtool/proc/show_fuel(var/mob/user)
	if(tank)
		to_chat(user, "\icon[tank] \The [tank] contains [get_fuel()]/[tank.tank_volume] units of [welding_resource]!")
	else
		to_chat(user, "There is no tank attached.")

/obj/item/weapon/tool/weldingtool/MouseDrop(atom/over)
	if(!CanMouseDrop(over, usr))
		return

	if(istype(over, /obj/item/weapon/weldpack))
		var/obj/item/weapon/weldpack/wp = over
		if(wp.welder)
			to_chat(usr, SPAN_WARNING("\The [wp] already has \a [wp.welder] attached."))
		else
			usr.drop_from_inventory(src, wp)
			wp.welder = src
			usr.visible_message("[usr] attaches \the [src] to \the [wp].", "You attach \the [src] to \the [wp].")
			wp.update_icon()
		return

	..()

/obj/item/weapon/tool/weldingtool/attackby(obj/item/W as obj, mob/user as mob)
	if(welding)
		to_chat(user, SPAN_DANGER("Stop welding first!"))
		return 0

	if(isScrewdriver(W))
		status = !status
		if(status)
			to_chat(user, SPAN_NOTICE("You secure the welder."))
		else
			to_chat(user, SPAN_NOTICE("The welder can now be attached and modified."))
		src.add_fingerprint(user)
		return 1

	if((!status) && (istype(W,/obj/item/stack/material/rods)))
		var/obj/item/stack/material/rods/R = W
		R.use(1)
		var/obj/item/weapon/flamethrower/F = new/obj/item/weapon/flamethrower(user.loc)
		src.loc = F
		F.weldtool = src
		if (user.client)
			user.client.screen -= src
		if (user.r_hand == src)
			user.remove_from_mob(src)
		else
			user.remove_from_mob(src)
		src.master = F
		src.reset_plane_and_layer()
		user.remove_from_mob(src)
		if (user.client)
			user.client.screen -= src
		src.loc = F
		src.add_fingerprint(user)
		return 1

	if(istype(W, /obj/item/weapon/welder_tank))
		if(tank)
			to_chat(user, SPAN_WARNING("Remove the current tank first."))
			return 0

		if(W.w_class >= w_class)
			to_chat(user, SPAN_WARNING("\The [W] is too large to fit in \the [src]."))
			return 0

		if(user.unEquip(W))
			W.forceMove(src)
			tank = W
			user.visible_message("[user] slots \a [W] into \the [src].", "You slot \a [W] into \the [src].")
			update_icon()
		return 1

	return ..()

/obj/item/weapon/tool/weldingtool/attack_hand(mob/user as mob)
	if(tank && user.get_inactive_hand() == src)
		if(!welding)
			if(tank.can_remove)
				user.visible_message("[user] removes \the [tank] from \the [src].", "You remove \the [tank] from \the [src].")
				user.put_in_hands(tank)
				tank = null
				update_icon()
			else
				to_chat(user, SPAN_WARNING("\The [tank] can't be removed."))
		else
			to_chat(user, SPAN_DANGER("Stop welding first!"))

	else
		return ..()

/obj/item/weapon/tool/weldingtool/water_act()
	if(welding && !waterproof)
		setWelding(0)

/obj/item/weapon/tool/weldingtool/Process()
	if(welding)
		if(!remove_fuel(fuel_rate))
			setWelding(0)

/obj/item/weapon/tool/weldingtool/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(!proximity) return
	if (O.is_open_container() && get_dist(src,O) <= 1 && !src.welding)
		if(!tank)
			to_chat(user, SPAN_WARNING("\The [src] has no tank attached!"))
			return
		O.reagents.trans_to_obj(tank, tank.tank_volume)
		to_chat(user, SPAN_NOTICE("You refuel \the [tank]."))
		playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
		return
	if (src.welding && remove_fuel(fuel_cost_use))
		var/turf/location = get_turf(user)
		if(isliving(O))
			var/mob/living/L = O
			L.IgniteMob()
		if (istype(location, /turf))
			location.hotspot_expose(700, 50, 1)
	return


/obj/item/weapon/tool/weldingtool/attack_self(mob/user as mob)
	setWelding(!welding, usr)
	return

//Returns the amount of fuel in the welder
/obj/item/weapon/tool/weldingtool/proc/get_fuel()
	return tank ? tank.reagents.get_reagent_amount(welding_resource) : 0


//Removes fuel from the welding tool. If a mob is passed, it will perform an eyecheck on the mob. This should probably be renamed to use()
/obj/item/weapon/tool/weldingtool/proc/remove_fuel(var/amount = 1, var/mob/M = null)
	if(!welding)
		return 0
	if(get_fuel() >= amount)
		burn_fuel(amount)
		if(M)
			eyecheck(M)
		return 1
	else
		if(M)
			to_chat(M, SPAN_NOTICE("You need more [welding_resource] to complete this task."))
		return 0

/obj/item/weapon/tool/weldingtool/proc/burn_fuel(var/amount)
	if(!tank)
		return

	var/mob/living/in_mob = null

	//consider ourselves in a mob if we are in the mob's contents and not in their hands
	if(isliving(src.loc))
		var/mob/living/L = src.loc
		if(!(L.l_hand == src || L.r_hand == src))
			in_mob = L

	if(in_mob)
		amount = max(amount, 2)
		tank.reagents.trans_type_to(in_mob, welding_resource, amount)
		in_mob.IgniteMob()

	else
		tank.reagents.remove_reagent(welding_resource, amount)
		var/turf/location = get_turf(src.loc)
		if(location)
			location.hotspot_expose(700, 5)

//Returns whether or not the welding tool is currently on.
/obj/item/weapon/tool/weldingtool/proc/isOn()
	return src.welding

/obj/item/weapon/tool/weldingtool/get_storage_cost()
	if(isOn())
		return ITEM_SIZE_NO_CONTAINER
	return ..()

/obj/item/weapon/tool/weldingtool/on_update_icon()
	..()
	icon_state = initial(icon_state) + (tank ? "_" + tank.icon_state : "") + (welding ? "_on" : "")
	item_state = welding ? "welder1" : "welder"
	//update_tank_underlay()
	var/mob/M = loc
	if(istype(M))
		M.update_inv_l_hand()
		M.update_inv_r_hand()

/obj/item/weapon/tool/weldingtool/proc/update_tank_underlay()
	underlays.Cut()
	if(istype(tank))
		var/image/tank_image = image(tank.icon, icon_state = tank.icon_state)
		tank_image.pixel_z = 0
		underlays += tank_image

//Sets the welding state of the welding tool. If you see W.welding = 1 anywhere, please change it to W.setWelding(1)
//so that the welding tool updates accordingly
/obj/item/weapon/tool/weldingtool/proc/setWelding(var/set_welding, var/mob/M)
	if(!status)	return

	var/turf/T = get_turf(src)
	//If we're turning it on
	if(set_welding && !welding)
		if (get_fuel() > 0)
			if(M)
				to_chat(M, SPAN_NOTICE("You switch the [src] on."))
			else if(T)
				T.visible_message(SPAN_DANGER("\The [src] turns on."))
			src.force = 15
			src.damtype = DAM_BURN
			welding = 1
			update_icon()
			START_PROCESSING(SSobj, src)
		else
			if(M)
				to_chat(M, SPAN_NOTICE("You need more welding fuel to complete this task."))
			return
	//Otherwise
	else if(!set_welding && welding)
		STOP_PROCESSING(SSobj, src)
		if(M)
			to_chat(M, SPAN_NOTICE("You switch \the [src] off."))
		else if(T)
			T.visible_message(SPAN_WARNING("\The [src] turns off."))
		src.force = initial(src.force)
		src.damtype = initial(src.damtype)
		src.welding = 0
		update_icon()

//Decides whether or not to damage a player's eyes based on what they're wearing as protection
//Note: This should probably be moved to mob
/obj/item/weapon/tool/weldingtool/proc/eyecheck(mob/user as mob)
	if(!iscarbon(user))	return 1
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[BP_EYES]
		if(!E)
			return
		var/safety = H.eyecheck()
		switch(safety)
			if(FLASH_PROTECTION_MODERATE)
				to_chat(H, SPAN_WARNING("Your eyes sting a little."))
				E.take_damage(rand(1, 2))
				if(E.get_damages() > 12)
					H.eye_blurry += rand(3,6)
			if(FLASH_PROTECTION_NONE)
				to_chat(H, SPAN_WARNING("Your eyes burn."))
				E.take_damage(rand(2, 4))
				if(E.get_damages() > 10)
					E.take_damage(rand(4,10))
			if(FLASH_PROTECTION_REDUCED)
				to_chat(H, SPAN_DANGER("Your equipment intensifies the welder's glow. Your eyes itch and burn severely."))
				H.eye_blurry += rand(12,20)
				E.take_damage(rand(12, 16))
		if(safety<FLASH_PROTECTION_MAJOR)
			if(E.get_damages() > 10)
				to_chat(user, SPAN_WARNING("Your eyes are really starting to hurt. This can't be good for you!"))
			else if (E.get_damages() >= E.min_bruised_damage)
				to_chat(H, SPAN_DANGER("It gets hard to see!"))
				H.eye_blind = 15
				H.eye_blurry = 5
				// We don't want this to cure nearsightedness accidentally
				if(!(H.disabilities & NEARSIGHTED))
					H.disabilities |= NEARSIGHTED
					spawn(100)
						H.disabilities &= ~NEARSIGHTED

/obj/item/weapon/tool/weldingtool/attack(mob/living/M, mob/living/user, target_zone)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/S = H.organs_by_name[target_zone]

		if(!S || !BP_IS_ROBOTIC(S) || user.a_intent != I_HELP)
			return ..()

		if(!welding)
			to_chat(user, SPAN_WARNING("You'll need to turn [src] on to patch the damage on [M]'s [S.name]!"))
			return 1

		if(S.robo_repair(15, DAM_BLUNT, "some dents", src, user))
			remove_fuel(1, user)
	else
		return ..()

//Returns the ammount of fuel needed to do a job based on the efficiency factor
/obj/item/weapon/tool/weldingtool/proc/apply_fuel_efficiency(var/fuel_needed)
	return fuel_needed * welding_efficiency

/obj/item/weapon/tool/weldingtool/apply_duration_efficiency(var/defduration)
	return  max(1, defduration * welding_efficiency)

/obj/item/weapon/tool/weldingtool/use_tool(var/mob/living/user, var/obj/target, var/time = 0, var/output_message = null, var/required_skill = null, var/required_fuel = 0 )
	if(!isOn())
		to_chat(user, SPAN_NOTICE("The welding tool must be on to complete this task."))
		return FALSE
	if(required_fuel && (apply_fuel_efficiency(required_fuel) < get_fuel()))
		to_chat(user, SPAN_NOTICE("You need more fuel to complete this task."))
		return FALSE
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	play_tool_sound()
	if(output_message)
		to_chat(user, SPAN_NOTICE("[output_message]"))

	var/done = (required_skill)? user.do_skilled(apply_duration_efficiency(time), required_skill, target) : do_after(user, apply_duration_efficiency(time), target)
	if(required_skill && prob(user.skill_fail_chance(required_skill, 1)))
		eyecheck(user)
		to_chat(user, SPAN_DANGER("You're not very good at this and fail the task.."))
		return FALSE  //There's a chance to screw up if not skilled enough
	if(done && isOn())
		eyecheck(user)
		remove_fuel(apply_fuel_efficiency(required_fuel), user)
		return TRUE
	else
		//The user moved and cancelled
		return FALSE

/obj/item/weapon/tool/weldingtool/play_tool_sound()
	playsound(get_turf(src), 'sound/items/Welder.ogg', 50, 1)

//===================================
//	Small welder tool tank
//===================================
/obj/item/weapon/welder_tank
	name = "welding fuel tank"
	desc = "An interchangeable fuel tank meant for a welding tool."
	icon = 'icons/obj/tools.dmi'
	icon_state = "tank_normal"
	w_class = ITEM_SIZE_SMALL
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	var/tank_volume = 40
	var/starting_fuel = 40
	var/can_remove = 1
	var/fuel_type = /datum/reagent/fuel
	matter = list(MATERIAL_STEEL = 20)

/obj/item/weapon/welder_tank/empty
	starting_fuel = 0

/obj/item/weapon/welder_tank/Initialize()
	if(!map_storage_loaded)
		create_reagents(tank_volume)
		reagents.add_reagent(fuel_type, starting_fuel)
	. = ..()

/obj/item/weapon/welder_tank/examine(mob/user)
	if(..(user, 0))
		to_chat(user, SPAN_NOTICE("There is [reagents.total_volume]/[tank_volume] units of liquid remaining."))

/obj/item/weapon/welder_tank/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(!proximity) return
	if (istype(O, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,O) <= 1)
		O.reagents.trans_to_obj(src, tank_volume)
		to_chat(user, SPAN_NOTICE("You refuel \the [src]."))
		playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
		return
	return ..()

/obj/item/weapon/welder_tank/proc/get_tank_volume()
	return tank_volume
