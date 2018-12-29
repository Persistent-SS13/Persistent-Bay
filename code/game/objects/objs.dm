/obj
	layer 			 = OBJ_LAYER //Determine over what the object's sprite will be drawn
	animate_movement = 2	//
	mass 			 = 5	//Kg or something
	//Properties
	var/obj_flags		//Flags changing the behavior of the object.
	var/list/matter		//Used to store information about the contents of the object.
	var/w_class 		// Size of the object.
	var/sharpness	= 0	// whether this object cuts, mainly used for tools

	//Damage effects
	var/throwforce 			= 1			//Damage power this object has on impact when thrown
	var/damtype 			= DAM_BLUNT //Type of damage done by this item on hit
	var/armor_penetration 	= 0			//How much armor units this item nullifies on hit
	var/unacidable 			= FALSE		//universal "unacidabliness" var, here so you can use it in any obj.

	//Damage handling
	var/health 				= 0		//Current health
	var/max_health 			= 0		//Maximum health
	var/min_health 			= 0 	//Minimum health. If you want negative health numbers, change this to a negative number! Used to determine at what health something "dies"
	var/const/MaxArmorValue = 100	//Maximum armor resistance possible for objects (Was hardcoded to 100 for mobs..)
	var/list/armor = list(
		DAM_BLUNT  	= RESIST_NONE,
		DAM_PIERCE 	= RESIST_NONE,
		DAM_CUT 	= RESIST_NONE,
		DAM_BULLET 	= RESIST_NONE,
		DAM_LASER 	= RESIST_NONE,
		DAM_ENERGY 	= RESIST_NONE,
		DAM_BURN 	= RESIST_NONE,
		DAM_BOMB 	= RESIST_NONE,
		DAM_EMP 	= RESIST_INVULNERABLE,
		DAM_BIO 	= RESIST_INVULNERABLE,
		DAM_RADS 	= RESIST_INVULNERABLE,
		DAM_STUN 	= RESIST_INVULNERABLE,
		DAM_PAIN	= RESIST_INVULNERABLE,
		DAM_CLONE   = RESIST_INVULNERABLE) 	//Resistance for various types of damages
	var/damthreshold_brute 		= 0		//Minimum amount of brute damages required before it damage the object. Damages of that type below this value have no effect.
	var/damthreshold_burn		= 0		//Minimum amount of burn damages required before it damage the object. Damages of that type below this value have no effect.
	var/explosion_base_damage 	= 5 	//The base of the severity exponent used. See ex_act for details
	var/emp_base_damage 		= 5 	//The base of the severity exponent used. See emp_act for details
	var/const/ThrowMissChance	= 15	//in percent, chances for things thrown at this object to miss it
	var/unarmed_damage			= 1 	//The damage taken from human unarmed attacks by default
	var/list/unarmedverbs		= list("punches", "hit","kicks","headbutts", "slaps", "bonks") //Verbs used when hitting this object unarmed

	//Sounds
	var/sound_hit 		= null	//Sound the obj does when hit or hitting something
	var/sound_destroyed = null	//Sound the object does when its health reaches 0

	//Fire handling
	var/burn_point 	= null		//Temperature at which the object catches fire.
	var/burning 	= FALSE			//Whether the object is on fire

	//Interaction State
	var/in_use		= 0 // If we have a user using us, this will be set on. We will check if the user has stopped using us, and thus stop updating and LAGGING EVERYTHING!
	var/anchor_fall = FALSE

/obj/New()
	..()
	if(!health)
		health = max_health
	ADD_SAVED_VAR(health)
	ADD_SAVED_VAR(burning)

/obj/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/proc/is_used_on(obj/O, mob/user)

/obj/assume_air(datum/gas_mixture/giver)
	if(loc)
		return loc.assume_air(giver)
	else
		return null

/obj/remove_air(amount)
	if(loc)
		return loc.remove_air(amount)
	else
		return null

/obj/return_air()
	if(loc)
		return loc.return_air()
	else
		return null

/obj/proc/updateUsrDialog()
	if(in_use)
		var/is_in_use = 0
		var/list/nearby = viewers(1, src)
		for(var/mob/M in nearby)
			if ((M.client && M.machine == src))
				is_in_use = 1
				src.attack_hand(M)
		if (istype(usr, /mob/living/silicon/ai) || istype(usr, /mob/living/silicon/robot))
			if (!(usr in nearby))
				if (usr.client && usr.machine==src) // && M.machine == src is omitted because if we triggered this by using the dialog, it doesn't matter if our machine changed in between triggering it and this - the dialog is probably still supposed to refresh.
					is_in_use = 1
					src.attack_ai(usr)

		// check for TK users

		if (istype(usr, /mob/living/carbon/human))
			if(istype(usr.l_hand, /obj/item/tk_grab) || istype(usr.r_hand, /obj/item/tk_grab/))
				if(!(usr in nearby))
					if(usr.client && usr.machine==src)
						is_in_use = 1
						src.attack_hand(usr)
		in_use = is_in_use

/obj/proc/updateDialog()
	// Check that people are actually using the machine. If not, don't update anymore.
	if(in_use)
		var/list/nearby = viewers(1, src)
		var/is_in_use = 0
		for(var/mob/M in nearby)
			if ((M.client && M.machine == src))
				is_in_use = 1
				src.interact(M)
		var/ai_in_use = AutoUpdateAI(src)

		if(!ai_in_use && !is_in_use)
			in_use = 0

/obj/attack_ghost(mob/user)
	ui_interact(user)
	tg_ui_interact(user)
	..()

/obj/proc/interact(mob/user)
	return

/mob/proc/unset_machine()
	src.machine = null

/mob/proc/set_machine(var/obj/O)
	if(src.machine)
		unset_machine()
	src.machine = O
	if(istype(O))
		O.in_use = 1

/obj/item/proc/updateSelfDialog()
	var/mob/M = src.loc
	if(istype(M) && M.client && M.machine == src)
		src.attack_self(M)

/obj/proc/hide(var/hide)
	set_invisibility(hide ? INVISIBILITY_MAXIMUM : initial(invisibility))

/obj/proc/hides_under_flooring()
	return level == 1

/obj/proc/hear_talk(mob/M as mob, text, verb, datum/language/speaking)
	if(talking_atom)
		talking_atom.catchMessage(text, M)
	return

/obj/proc/see_emote(mob/M as mob, text, var/emote_type)
	return

/obj/proc/show_message(msg, type, alt, alt_type)//Message, type of message (1 or 2), alternative message, alt message type (1 or 2)
	return

/obj/proc/wrench_floor_bolts(mob/user, delay=20)
	playsound(loc, 'sound/items/Ratchet.ogg', vol=50, vary=1, extrarange=4, falloff=2)
	if(anchored)
		user.visible_message("\The [user] begins unsecuring \the [src] from the floor.", "You start unsecuring \the [src] from the floor.")
	else
		user.visible_message("\The [user] begins securing \the [src] to the floor.", "You start securing \the [src] to the floor.")
	if(do_after(user, delay, src))
		if(!src) return
		to_chat(user, SPAN_NOTICE("You [anchored? "un" : ""]secured \the [src]!"))
		set_anchored(!anchored)
	return 1

/obj/proc/set_anchored(var/new_anchored)
	anchored = new_anchored
	update_icon()

//Whether object can be damaged/destroyed
/obj/proc/isdamageable()
	return obj_flags & OBJ_FLAG_DAMAGEABLE

//Returns true if the damage is over the brute or burn damage threshold
/obj/proc/pass_damage_threshold(var/damage, var/damtype)
	return (IsDamageTypeBrute(damtype) 	 && damage > damthreshold_brute) || \
		   (IsDamageTypeHeat(damtype)    && damage > damthreshold_burn)

/obj/proc/pass_damage_threshold_list(var/list/damlist)
	for(var/key in damlist)
		if(pass_damage_threshold(damlist[key], key))
			return TRUE
	return FALSE

//Used to calculate armor damage reduction. Returns the amount of damages absorbed
/obj/proc/armor_absorb(var/damage, var/ap, var/damagetype)
	if(!damagetype)
		log_warning("Null damage type was passed to armor_absorb for \the [src] object! With damage = [damage], and ap = [ap]!")
		return 0
	if(ap >= MaxArmorValue)
		return 0 //bypass armor

	//If the damage is below our minimum thresholds, reject it all
	if( !pass_damage_threshold(damage, damagetype) )
		return damage

	for(var/dmgkey in src.armor)
		if(damagetype == dmgkey && src.armor[dmgkey])
			var/resist = src.armor[dmgkey]
			if(ap >= resist)
				return 0 //bypass armor
			var/effective_armor = (resist - ap)/MaxArmorValue
			var/fullblock = (effective_armor*effective_armor) * ARMOR_BLOCK_CHANCE_MULT
			if(fullblock >= 1 || prob(fullblock*MaxArmorValue))
				return MaxArmorValue
			return round(((effective_armor - fullblock)/(1 - fullblock)*100), 1)

	return 0 //no resistance found

//Called whenever the object is receiving damages
// returns the amount of damages that was applied to the object
// - damlist: used when a hit inflicts more than one type of damage. Just make an entry for each damage type and give them the damage amount as value ex: list(DAM_BLUNT = 50)
// - damsrc: mostly for organs, contains the cause of the damage, aka weapon name and etc..
// - damflags : Used mainly by organs for DAM_EDGE and DAM_SHARP flags.. Will probably be removed in the future
/obj/proc/take_damage(var/damage =0, var/damtype = DAM_BLUNT, var/armorbypass = 0, var/list/damlist = null, var/damflags = 0, var/damsrc = null)
	if(!isdamageable())
		return 0

	if(!damlist)
		var/resultingdmg = max(0, damage - armor_absorb(damage, armorbypass, damtype))
		set_health(get_health() - resultingdmg)
		update_health(damtype)
		. = resultingdmg
	else
		for(var/key in damlist)
			damage = damlist[key]
			var/resultingdmg = max(0, damlist[key] - armor_absorb(damlist[key], armorbypass, key))
			set_health(get_health() - resultingdmg)
			update_health(key)
			. += resultingdmg
	return .

//Like take damage, but meant to instantly destroy the object from an external source
/obj/proc/kill(var/damagetype = DAM_BLUNT)
	if(!isdamageable())
		return
	set_health(min_health)
	update_health(damagetype)

//Handles checking if the object is destroyed and etc..
/obj/proc/update_health(var/damagetype, var/user = null)
	if(!isdamageable())
		return //Assume we don't care about damages
	if(health <= min_health)
		if(damagetype == DAM_BURN)
			melt(user)
		else
			destroyed(damagetype,user)
	update_icon()

//Called when the object's health reaches 0, with the last damage type that hit it
/obj/proc/destroyed(var/damagetype, var/user = null)
	health = min_health
	playsound(loc, sound_destroyed, vol=70, vary=1, extrarange=10, falloff=5)
	visible_message(SPAN_WARNING("\The [src] breaks appart!"))
	make_debris()
	qdel(src)

//Directly sets health, without updating object state
/obj/proc/set_health(var/newhealth)
	health = between(min_health, round(newhealth, 0.1), get_max_health()) //round(max(0, min(newhealth, max_health)), 0.1)
	update_health()

//Convenience proc to handle adding health to the object
/obj/proc/add_health(var/addhealth)
	set_health(addhealth + get_health())

//Convenience proc to handle removing health from the object
/obj/proc/rem_health(var/remhealth)
	set_health(get_health() - remhealth)

/obj/proc/get_health()
	return health

/obj/proc/get_max_health()
	return max_health

/obj/proc/get_min_health()
	return min_health

//Returns whether the object is damaged or not
/obj/proc/isdamaged()
	return  get_health() < get_max_health()

//Returns the damages the object took so far
/obj/proc/get_damages()
	return get_max_health() - get_health()

//
//	- If the attack is considered damaging, damageoverride will override the default unarmed damage
/obj/attack_hand(mob/user, var/damageoverride = null)
	. = ..()
	add_hiddenprint(user)
	add_fingerprint(user)
	//Handle punching the thing
	if(isdamageable() && user.a_intent == I_HURT)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		attack_generic(user, damageoverride? damageoverride : unarmed_damage, pick(unarmedverbs))
		return
	interact(user)
	ui_interact(user)
	tg_ui_interact(user)

/obj/attackby(obj/item/O as obj, mob/user as mob)
	if(obj_flags & OBJ_FLAG_ANCHORABLE)
		if(isWrench(O))
			wrench_floor_bolts(user)
			update_icon()
			return 1
	if(isdamageable() && user.a_intent == I_HURT && O.force > 0 && !(O.item_flags & ITEM_FLAG_NO_BLUDGEON))
		attack_melee(user, O)
		return 1
	return ..()

//Handle generic hits
/obj/attack_generic(var/mob/user, var/damage, var/attack_verb, var/wallbreaker, var/damtype = DAM_BLUNT)
	if(!isdamageable())
		return 0
	add_hiddenprint(user)
	add_fingerprint(user)

	var/hitsoundoverride = sound_hit //So we can override the sound for special cases
	var/damoverride = damtype
	var/mob/living/carbon/human/H = user
	if(HULK in user.mutations)
		user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!"))
		user.visible_message(SPAN_DANGER("[user] smashes through [src]!"))
	else if(H && H.species.can_shred(user))
		visible_message(SPAN_WARNING("[user] [pick("slashes", "swipes", "scratches")] at \the [src]!"))
		hitsoundoverride = 'sound/weapons/slash.ogg'
		damoverride = DAM_CUT
	else
		visible_message(SPAN_DANGER("[user] [attack_verb? pick(attack_verb) : pick(unarmedverbs)] \the [src]!"))
	attack_animation(user)

	//When damages don't go through the damage threshold, give player feedback
	if(!pass_damage_threshold(damage,damoverride))
		user.visible_message(SPAN_WARNING("[user] hit [src] without any visible effect.."))
		playsound(loc, hitsoundoverride, vol=30, vary=1, extrarange=2, falloff=1)
		return 0

	take_damage(damage, damoverride)
	playsound(loc, hitsoundoverride, vol=60, vary=1, extrarange=8, falloff=6)
	return 1

//Handle weapon attacks
/obj/proc/attack_melee(var/mob/user, var/obj/item/W)
	if(!isdamageable() || !istype(W))
		return

	var/cooldown = DEFAULT_ATTACK_COOLDOWN
	if(!istype(W, /obj/item/weapon)) // Some objects don't have click cooldowns/attack anims
		user.setClickCooldown(cooldown)
		if(W.sound_hit)
			playsound(loc, W.sound_hit, vol=60, vary=1, extrarange=8, falloff=6)
		attack_animation(user)
	else
		W.attack(src, user)

//	if(islist(W.damtype))
//		var/list/dlist = W.damtype
//		for(var/key in W.damtype)
//			dlist[key] = W.force
//		//When damages don't go through the damage threshold, give player feedback
//		if(!pass_damage_threshold_list(dlist))
//			visible_message(SPAN_WARNING("\The [src] was hit with \the [W] with no visible effect."))
//			playsound(loc, W.sound_hit, vol=30, vary=1, extrarange=2, falloff=1)
//			return 0
//		take_damage(damlist = W.damtype, armorbypass = W.armor_penetration)
//	else
//		//When damages don't go through the damage threshold, give player feedback
//		if(!pass_damage_threshold(W.force, W.damtype))
//			visible_message(SPAN_WARNING("\The [src] was hit with \the [W] with no visible effect."))
//			playsound(loc, W.sound_hit, vol=30, vary=1, extrarange=2, falloff=1)
//			return 0
//		take_damage(W.force, W.damtype, armorbypass = W.armor_penetration)
//
//	if(W.attack_verb && W.attack_verb.len)
//		visible_message(SPAN_WARNING("\The [src] have been [pick(W.attack_verb)] with \the [W][(user ? " by [user]." : ".")]"))
//	else
//		visible_message(SPAN_WARNING("\The [src] have been attacked with \the [W][(user ? " by [user]." : ".")]"))

//Called by a weapon's "afterattack" proc when an attack has succeeded. Returns blocked damage
/obj/hit_with_weapon(obj/item/W, mob/living/user, var/effective_force)
	..()
	if(islist(W.damtype))
		var/list/dlist = W.damtype
		for(var/key in W.damtype)
			dlist[key] = W.force
		//When damages don't go through the damage threshold, give player feedback
		if(!pass_damage_threshold_list(dlist))
			hit_deflected_by_armor(W, user)
			return 0
		take_damage(damlist = W.damtype, armorbypass = W.armor_penetration)
	else
		//When damages don't go through the damage threshold, give player feedback
		if(!pass_damage_threshold(W.force, W.damtype))
			hit_deflected_by_armor(W, user)
			return 0
		take_damage(effective_force, W.damtype, armorbypass = W.armor_penetration)
	playsound(loc, sound_hit, vol=40, vary=1, extrarange=4, falloff=1)

/obj/proc/hit_deflected_by_armor(obj/item/W, mob/living/user)
	visible_message(SPAN_WARNING("[user]'s hit wasn't enough to pierce [src]'s armor!"))
	playsound(loc, W.sound_hit, vol=30, vary=1, extrarange=2, falloff=1) //ricochet sound I guess

//Placed a "force" argument, so whenever we fix explosions so they do damages, it'll be ready
/obj/ex_act(var/severity, var/force = 0)
	. = ..()
	if(!isdamageable())
		return
	if(!force)
		force = (explosion_base_damage ** (4 - severity)) //Severity is a value from 1 to 3, with 1 being the strongest. So each severity level is
	take_damage(damage = force, damtype = DAM_BOMB)

/obj/emp_act(var/severity, var/force = 0)
	. = ..()
	if(!isdamageable())
		return
	if(!force)
		force = (emp_base_damage ** (4 - severity))
	take_damage(damage = force, damtype = DAM_EMP)

/obj/bullet_act(obj/item/projectile/P, def_zone)
	. = ..()
	if(!isdamageable())
		return
	var/bdam = P.get_structure_damage()
	//When damages don't go through the damage threshold, give player feedback
	if(!pass_damage_threshold(bdam, P.damage_type))
		visible_message(SPAN_WARNING("\The [src] was hit by \the [P] with no visible effect."))
		playsound(loc, sound_hit, vol=40, vary=1, extrarange=4, falloff=2)
		return 0
	take_damage(bdam, P.damage_type, P.penetration_modifier)

//Handles being hit by a thrown atom_movable
//	- damageoverride : if subclasses have a different damage calculation, pass the damage in this var
/obj/hitby(atom/movable/AM as mob|obj, var/speed = THROWFORCE_SPEED_DIVISOR, var/damageoverride = null)
	..()
	var/obj/O = AM
	//Handle missing
	var/miss_chance = ThrowMissChance
	if(AM.throw_source)
		var/distance = get_dist(AM.throw_source, loc)
		miss_chance = max(ThrowMissChance*(distance-2), 0)
	if(prob(miss_chance))
		visible_message(SPAN_NOTICE("\The [O] misses [src] narrowly!"))
		return 0

	//Handle damages
	var/damage_type = O? O.damtype : DAM_BLUNT
	var/ap = O? O.armor_penetration : 0
	var/throw_damage = 0
	if(damageoverride)
		throw_damage = damageoverride
	else
		throw_damage = O? O.throwforce*(speed/THROWFORCE_SPEED_DIVISOR) : (AM.throw_speed/THROWFORCE_SPEED_DIVISOR * AM.mass)

	//When damages don't go through the damage threshold, give player feedback
	if(!pass_damage_threshold(throw_damage, damage_type))
		visible_message(SPAN_WARNING("\The [src] was hit by \the [AM] with no visible effect."))
		playsound(loc, sound_hit, vol=40, vary=1, extrarange=4, falloff=2)
		return 0
	take_damage(throw_damage, damage_type, armorbypass = ap)

	src.visible_message(SPAN_WARNING("\The [src] has been hit by \the [O]."))
	playsound(loc, sound_hit, vol=50, vary=1, extrarange=8, falloff=6)

	//Handle knockback
	if(!anchored) //No knockback if we're anchored
		var/momentum = speed*mass
		if(O.throw_source && momentum >= THROWNOBJ_KNOCKBACK_SPEED)
			var/dir = get_dir(AM.throw_source, src)
			visible_message(SPAN_WARNING("\The [src] is sent flying from the impact!"))
			src.throw_at(get_edge_target_turf(src,dir), 1, momentum)
	return 1

/obj/emag_act(var/remaining_charges, var/mob/user, var/emag_source)
	return NO_EMAG_ACT

/obj/fire_act(var/datum/gas_mixture/air, var/exposed_temperature, var/exposed_volume)
	. = ..()
	if(!isdamageable() || !exposed_temperature || !air)
		return

	if(!burning && burn_point >= exposed_temperature)
		ignite()
	else if(burning && (burn_point < exposed_temperature ))
		extinguish()
	else
		fire_consume(air, exposed_temperature, exposed_volume)

/obj/proc/fire_consume(var/datum/gas_mixture/air, var/exposed_temperature, var/exposed_volume)
	var/expvol = exposed_volume
	if(!burn_point || !air)
		return
	if(expvol <= 0)
		expvol = 1
	var/fire_damage = (exposed_temperature/burn_point) * (air.volume/expvol)
	take_damage(damage = fire_damage, damtype = DAM_BURN) //might make more sense to use laser here...

/obj/proc/ignite()
	burning = TRUE

/obj/proc/extinguish()
	burning = FALSE

//This is called when the object is destroyed by fire
/obj/melt(var/user = null)
	if(!isdamageable())
		return
	. = ..()
	qdel(src)

//Drops the material worth of the object as material sheets.
/obj/proc/refund_matter()
	for(var/key in matter)
		var/material/M = SSmaterials.get_material_by_name(key)
		if(M)
			if(!M.units_per_sheet)
				log_warning("Material [M] is missing its units_per_sheet count!")
				continue
			var/sheetamt = matter[key] / M.units_per_sheet
			M.place_sheet(get_turf(loc), sheetamt)

/obj/proc/make_debris()
	for(var/key in matter)
		var/material/M = SSmaterials.get_material_by_name(key)
		if(M)
			M.place_shard(get_turf(loc))
