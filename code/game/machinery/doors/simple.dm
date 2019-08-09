#define SIMPLE_DOOR_HEALTH_MULTIPLIER 10
#define SIMPLE_DOOR_DAMAGE_CAP 100
#define SIMPLE_DOOR_SOUND_VOL 20

/obj/machinery/door/unpowered/simple
	name 		= "door"
	icon 		= 'icons/obj/doors/material_doors.dmi'
	icon_state 	= "metal"
	sound_hit 	= 'sound/weapons/genhit.ogg'
	autoset_access = FALSE // Doesn't even use access

	var/material/material
	var/icon_base
	var/datum/lock/lock
	var/initial_lock_value //for mapping purposes. Basically if this value is set, it sets the lock to this value.

/obj/machinery/door/unpowered/simple/New(var/newloc, var/material_name, var/locked)
	..()
	if(!material_name)
		material_name = MATERIAL_STEEL
	material = SSmaterials.get_material_by_name(material_name)
	if(!material)
		qdel(src)
		return
	//Material is handled in the UpdateMaterial proc
	if(initial_lock_value)
		locked = initial_lock_value
	if(locked)
		lock = new(src,locked)

	if(material.opacity < 0.5)
		glass = 1
		set_opacity(0)
	else
		set_opacity(1)
	queue_icon_update()

/obj/machinery/door/unpowered/simple/Initialize(mapload, d)
	. = ..()
	update_material()

/obj/machinery/door/unpowered/simple/Destroy()
	QDEL_NULL(lock)
	return ..()

/obj/machinery/door/unpowered/simple/requiresID()
	return FALSE

/obj/machinery/door/unpowered/simple/get_material()
	return material

/obj/machinery/door/unpowered/simple/get_material_name()
	return material.name

/obj/machinery/door/unpowered/simple/proc/update_material()
	name = "[material.display_name] door"
	max_health = max(100, material.integrity * SIMPLE_DOOR_HEALTH_MULTIPLIER)
	health = max_health
	broken_threshold = max_health / 3
	sound_hit = material.hitsound

	armor = list(
		DAM_BLUNT  	= material.brute_armor * MaxArmorValue,
		DAM_PIERCE 	= round(material.hardness * 0.90),
		DAM_CUT 	= material.hardness,
		DAM_BULLET 	= material.brute_armor * MaxArmorValue,
		DAM_ENERGY 	= material.burn_armor * MaxArmorValue,
		DAM_BURN 	= material.burn_armor * MaxArmorValue,
		DAM_BOMB 	= material.burn_armor * MaxArmorValue,
		DAM_EMP 	= MaxArmorValue,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue) 	//Resistance for various types of damages

	if(!icon_base)
		icon_base = material.door_icon_base
	color = material.icon_colour
	if(material.opacity < 0.5)
		glass = TRUE
		set_opacity(0)
	else
		set_opacity(1)
	update_icon()

/obj/machinery/door/unpowered/simple/bullet_act(var/obj/item/projectile/Proj)
	var/damage = Proj.get_structure_damage()
	if(damage)
		//cap projectile damage so that there's still a minimum number of hits required to break the door
		take_damage(min(damage, SIMPLE_DOOR_DAMAGE_CAP), Proj.damtype, Proj.armor_penetration, Proj)

/obj/machinery/door/unpowered/simple/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	TemperatureAct(exposed_temperature)

/obj/machinery/door/unpowered/simple/proc/TemperatureAct(temperature)
	take_damage(100*material.combustion_effect(get_turf(src),temperature, 0.3))


/obj/machinery/door/unpowered/simple/on_update_icon()
	if(density)
		icon_state = "[icon_base]"
	else
		icon_state = "[icon_base]open"
	return

/obj/machinery/door/unpowered/simple/do_animate(animation)
	switch(animation)
		if("opening")
			flick("[icon_base]opening", src)
		if("closing")
			flick("[icon_base]closing", src)
	return

/obj/machinery/door/unpowered/simple/inoperable(var/additional_flags = 0)
	return (stat & (BROKEN|additional_flags))

/obj/machinery/door/unpowered/simple/close(var/forced = FALSE)
	if(!can_close(forced))
		return
	playsound(src.loc, material.dooropen_noise, SIMPLE_DOOR_SOUND_VOL, TRUE)
	..()

/obj/machinery/door/unpowered/simple/open(var/forced = FALSE)
	if(!can_open(forced))
		return
	playsound(src.loc, material.dooropen_noise, SIMPLE_DOOR_SOUND_VOL, TRUE)
	..()

/obj/machinery/door/unpowered/simple/deconstruct(mob/user, moved = FALSE)
	material.place_dismantled_product(get_turf(src))
	qdel(src)

/obj/machinery/door/unpowered/simple/attack_ai(mob/user as mob) //those aren't machinery, they're just big fucking slabs of a mineral
	if(isAI(user)) //so the AI can't open it
		return
	else if(isrobot(user)) //but cyborgs can
		if(Adjacent(user)) //not remotely though
			return attack_hand(user)

/obj/machinery/door/unpowered/simple/attackby(obj/item/I as obj, mob/user as mob)
	src.add_fingerprint(user, 0, I)
	if((isScrewdriver(I)) && (istype(loc, /turf/simulated) && (!lock.isLocked() || anchored)))
		var/obj/item/weapon/tool/T = I
		if(T.use_tool(user, src, 1 SECOND))
			anchored = !anchored
			user.visible_message(SPAN_NOTICE("[user] [anchored ? "fastens" : "unfastens"] the [src]."), \
									SPAN_NOTICE("You have [anchored ? "fastened the [src] to" : "unfastened the [src] from"] the floor."))
		return

	else if(isCrowbar(I) && (!lock.isLocked()))
		var/obj/item/weapon/tool/T = I
		if(T.use_tool(user, src, 1 SECOND))
			to_chat(user, SPAN_DANGER("You destroy the [src] salvaging nothing!"))
			qdel(src)
			return
	if(istype(I, /obj/item/weapon/key) && lock)
		var/obj/item/weapon/key/K = I
		if(!lock.toggle(I))
			to_chat(user, SPAN_WARNING("\The [K] does not fit in the lock!"))
		return
	if(lock && lock.pick_lock(I,user))
		return

	if(istype(I,/obj/item/weapon/material/lock_construct))
		if(lock)
			to_chat(user, SPAN_WARNING("\The [src] already has a lock."))
		else
			var/obj/item/weapon/material/lock_construct/L = I
			lock = L.create_lock(src,user)
		return

	if(istype(I, /obj/item/stack/material) && I.get_material_name() == src.get_material_name())
		if(isbroken())
			to_chat(user, SPAN_NOTICE("It looks like \the [src] is pretty busted. It's going to need more than just patching up now."))
			return
		if(health >= max_health)
			to_chat(user, SPAN_NOTICE("Nothing to fix!"))
			return
		if(!density)
			to_chat(user, SPAN_WARNING("\The [src] must be closed before you can repair it."))
			return

		//figure out how much metal we need
		var/obj/item/stack/stack = I
		var/amount_needed = ceil((max_health - health)/DOOR_REPAIR_AMOUNT)
		var/used = min(amount_needed,stack.amount)
		if (used)
			to_chat(user, SPAN_NOTICE("You fit [used] [stack.singular_name]\s to damaged and broken parts on \the [src]."))
			stack.use(used)
			health = between(health, health + used * DOOR_REPAIR_AMOUNT, max_health)
		return

	//psa to whoever coded this, there are plenty of objects that need to call attack() on doors without bludgeoning them.
	if(src.density && istype(I, /obj/item/weapon) && user.a_intent == I_HURT && !istype(I, /obj/item/weapon/card))
		var/obj/item/weapon/W = I
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(IsDamageTypeBrute(W.damtype) || IsDamageTypeBurn(W.damtype))
			user.do_attack_animation(src)
			// if(W.force < damthreshold_brute)
			// 	user.visible_message("<span class='danger'>\The [user] hits \the [src] with \the [W] with no visible effect.</span>")
			// else
			// 	user.visible_message("<span class='danger'>\The [user] forcefully strikes \the [src] with \the [W]!</span>")
			playsound(src.loc, sound_hit, 100, TRUE)
			take_damage(W.force, W.damtype, W.armor_penetration, W)
		return

	if(src.operating) 
		return

	if(lock && lock.isLocked())
		to_chat(user, "\The [src] is locked!")

	if(operable())
		if(src.density)
			open()
		else
			close()
		return

	return

/obj/machinery/door/unpowered/simple/examine(mob/user)
	if(..(user,1) && lock)
		to_chat(user, SPAN_NOTICE("It appears to have a lock."))

/obj/machinery/door/unpowered/simple/can_open()
	if(!..() || (lock && lock.isLocked()))
		return 0
	return 1


//------------------------------------
//	Subtypes
//------------------------------------
/obj/machinery/door/unpowered/simple/iron/New(var/newloc,var/material_name,var/complexity)
	..(newloc, MATERIAL_IRON, complexity)

/obj/machinery/door/unpowered/simple/silver/New(var/newloc,var/material_name,var/complexity)
	..(newloc, MATERIAL_SILVER, complexity)

/obj/machinery/door/unpowered/simple/gold/New(var/newloc,var/material_name,var/complexity)
	..(newloc, MATERIAL_GOLD, complexity)

/obj/machinery/door/unpowered/simple/uranium/New(var/newloc,var/material_name,var/complexity)
	..(newloc, MATERIAL_URANIUM, complexity)

/obj/machinery/door/unpowered/simple/sandstone/New(var/newloc,var/material_name,var/complexity)
	..(newloc, MATERIAL_SANDSTONE, complexity)

/obj/machinery/door/unpowered/simple/diamond/New(var/newloc,var/material_name,var/complexity)
	..(newloc, MATERIAL_DIAMOND, complexity)

/obj/machinery/door/unpowered/simple/wood
	icon_state = "wood"
	color = "#824b28"

/obj/machinery/door/unpowered/simple/wood/New(var/newloc,var/material_name,var/complexity)
	..(newloc, MATERIAL_WOOD, complexity)

/obj/machinery/door/unpowered/simple/mahogany/New(var/newloc,var/material_name,var/complexity)
	..(newloc, MATERIAL_MAHOGANY, complexity)

/obj/machinery/door/unpowered/simple/maple/New(var/newloc,var/material_name,var/complexity)
	..(newloc, MATERIAL_MAPLE, complexity)

/obj/machinery/door/unpowered/simple/ebony/New(var/newloc,var/material_name,var/complexity)
	..(newloc, MATERIAL_EBONY, complexity)

/obj/machinery/door/unpowered/simple/walnut/New(var/newloc,var/material_name,var/complexity)
	..(newloc, MATERIAL_WALNUT, complexity)

/obj/machinery/door/unpowered/simple/wood/saloon
	icon_base = "saloon"
	autoclose = TRUE
	normalspeed = 0

/obj/machinery/door/unpowered/simple/wood/saloon/New(var/newloc,var/material_name,var/complexity)
	..(newloc, MATERIAL_WOOD, complexity)
	glass = TRUE
	set_opacity(0)

/obj/machinery/door/unpowered/simple/resin/New(var/newloc,var/material_name,var/complexity)
	..(newloc, MATERIAL_RESIN, complexity)

/obj/machinery/door/unpowered/simple/cult/New(var/newloc,var/material_name,var/complexity)
	..(newloc, MATERIAL_CULT, complexity)

#undef SIMPLE_DOOR_HEALTH_MULTIPLIER
#undef SIMPLE_DOOR_DAMAGE_CAP
#undef SIMPLE_DOOR_SOUND_VOL
