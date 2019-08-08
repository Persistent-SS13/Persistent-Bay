/obj
	layer 			 = OBJ_LAYER //Determine over what the object's sprite will be drawn
	animate_movement = 2	//
	mass 			 = 0.05	//Kg Used for calculating throw force, inertia, and possibly more things..
	//Properties
	var/obj_flags		//Flags changing the behavior of the object.
	var/list/matter		//Used to store information about the contents of the object.
	var/w_class 		// Size of the object.
	var/sharpness	= 0	// A measure of how much this item cuts, mainly used for tools. 0 = Doesn't cut, 1 = Cuts, 2 = Cuts things that sharpness 1 wouldn't, and so on

	//Damage effects
	var/throwforce 			= 1			//Damage power this object has on impact when thrown
	var/damtype 			= DAM_BLUNT //Type of damage done by this item on hit
	var/armor_penetration 	= 0			//How much armor units this item nullifies on hit
	var/unacidable 			= FALSE		//universal "unacidabliness" var, here so you can use it in any obj.

	//Damage handling
	var/health 					= null	//Current health
	var/max_health 				= 0		//Maximum health
	var/min_health 				= 0 	//Minimum health. If you want negative health numbers, change this to a negative number! Used to determine at what health something "dies"
	var/broken_threshold		= 0 	//Percentage {0.0 to 1.0} of the object's max health at which the broken() proc is called! 
	var/const/MaxArmorValue 	= 100	//Maximum armor resistance possible for objects (Was hardcoded to 100 for mobs..)
	var/list/armor						//Associative list of resistances to damage types. Format for entries is damagetype = damageresistance
	var/damthreshold_brute 		= 0		//Minimum amount of brute damages required to damage the object. Damages of that type below this value have no effect.
	var/damthreshold_burn		= 0		//Minimum amount of burn damages required to damage the object. Damages of that type below this value have no effect.
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
	var/tmp/in_use	= FALSE // If we have a user using us, this will be set on. We will check if the user has stopped using us, and thus stop updating and LAGGING EVERYTHING!
	var/anchor_fall = FALSE
	var/holographic = FALSE //if the obj is a holographic object spawned by the holodeck

/obj/New()
	..()
	if(obj_flags & OBJ_FLAG_DAMAGEABLE && max_health) //save health only when its relevant
		ADD_SAVED_VAR(health)
		ADD_SKIP_EMPTY(health) //Skip null health
	ADD_SAVED_VAR(burning)

/obj/Initialize()
	if(!map_storage_loaded)
		health = max_health
	. = ..()

/obj/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()
#ifdef TESTING
	return QDEL_HINT_IFFAIL_FINDREFERENCE
#endif

/obj/item/proc/is_used_on(obj/O, mob/user)
	return

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

/obj/examine(var/mob/user)
	. = ..()
	if(isdamageable())
		to_chat(user, damage_description(user))

/obj/proc/damage_description(var/mob/user)
	if(!isdamaged())
		return SPAN_NOTICE("It looks fully intact.")
	else
		var/perc = health_percentage()
		if(perc > 75)
			return SPAN_NOTICE("It has a few scratches.")
		else if(perc > 50)
			return SPAN_WARNING("It looks slightly damaged.")
		else if(perc > 25)
			return SPAN_NOTICE("It looks moderately damaged.")
		else
			return SPAN_DANGER("It looks heavily damaged.")
	if(isbroken())
		return SPAN_WARNING("It seems broken.")

//The minimum health is not included in this.
/obj/proc/health_percentage()
	if(!isdamageable())
		return 100
	if(max_health != 0)
		return health * 100 / max_health
	else
		return 0

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

/obj/proc/damage_flags()
	return 0

/obj/proc/set_anchored(var/new_anchored)
	anchored = new_anchored
	update_icon()

/obj/proc/isanchored()
	return anchored

//Whether object can be damaged/destroyed
/obj/proc/isdamageable()
	return obj_flags & OBJ_FLAG_DAMAGEABLE

//Returns true if the damage is over the brute or burn damage threshold
/obj/proc/pass_damage_threshold(var/damage, var/damtype)
	return (IsDamageTypeBrute(damtype)   && damage > damthreshold_brute) || \
		   (IsDamageTypeBurn(damtype)    && damage > damthreshold_burn)

//Return whether the entity is vulenrable to the specified damage type
// override to change what damage will be rejected on take_damage
/obj/proc/vulnerable_to_damtype(var/damtype)
	return DAMAGE_AFFECT_OBJ(damtype)

/obj/proc/get_armor_value(var/damagetype)
	if(!armor)
		return 0
	ASSERT(damagetype)
	. = armor[damagetype]
	if(!.)
		. = 0 //Don't return null!

//Used to calculate armor damage reduction. Returns the integer percentage of the damage absorbed
/obj/proc/armor_absorb(var/damage, var/ap, var/damagetype)
	if(!damagetype)
		log_warning("Null damage type was passed to armor_absorb for \the [src] \ref[src] object! With damage = [damage], and ap = [ap]!")
		return 0
	if(ap >= MaxArmorValue || !armor)
		return 0 //bypass armor

	//If the damage is below our minimum thresholds, reject it all
	if( !pass_damage_threshold(damage, damagetype) )
		log_debug("[damagetype] damage of [damage](ap [ap]) blocked by damage threshold!")
		return MaxArmorValue

	for(var/dmgkey in src.armor)
		if(ISDAMTYPE(damagetype, dmgkey) && src.armor[dmgkey])
			var/resist = src.armor[dmgkey]
			if(ap >= resist)
				return 0 //bypass armor
			var/effective_armor = (resist - ap)/MaxArmorValue
			var/fullblock = (effective_armor*effective_armor)

			if(fullblock >= 1 || prob(fullblock * MaxArmorValue))
				. = MaxArmorValue
			else
				. = round(((effective_armor - fullblock)/(1 - fullblock) * MaxArmorValue), 1)
			log_debug("[dmgkey] armor ([resist]/[effective_armor]), blocked [.]% out of [damage]([ap] ap) damages! Fullblock [fullblock], with probability [fullblock*MaxArmorValue]%")
			return .

	return 0 //no resistance found

//Called whenever the object is receiving damages
// returns the amount of damages that was applied to the object
// - armorbypass: how much armor is bypassed for the damage specified. Usually a number from 0 to 100
// - used_weapon: A string or object reference to what caused the damage.
/obj/proc/take_damage(var/damage = 0 as num, var/damtype = DAM_BLUNT, var/armorbypass = 0, var/used_weapon = null, var/damflags = null)
	if(!isnum(damage))
		log_warning(" obj.proc.take_damage(): damage is not a number! [damage]")
		return 0
	if(!istext(damtype))
		log_warning(" obj.proc.take_damage(): damtype is not a string! [damtype]")
		return 0
	if(!isnum(armorbypass))
		log_warning(" obj.proc.take_damage(): armorbypass is not a number! [armorbypass]")
		return 0
	if(!isdamageable() || !vulnerable_to_damtype(damtype))
		return 0
	var/resultingdmg = max(0, damage * blocked_mult(armor_absorb(damage, armorbypass, damtype)))
	//var/name_ref = "\The \"[src]\" (\ref[src])([x], [y], [z])"

	//Dispersed affect contents
	if(damflags & DAM_DISPERSED && resultingdmg)
		for(var/atom/movable/A as mob|obj in src)
			if(isobj(A))
				var/obj/O = A
				O.take_damage(resultingdmg, damtype, armorbypass, used_weapon)
			if(isliving(A))
				var/mob/living/M = A
				M.apply_damage(resultingdmg, damtype, null, damflags, used_weapon, armorbypass)

	rem_health(resultingdmg, damtype)
	. = resultingdmg
	//testing("[name_ref] took [resultingdmg] \"[damtype]\" damages from \"[used_weapon]\"! Before armor: [damage] damages.")
	return .

//Like take damage, but meant to instantly destroy the object from an external source.
// Call this if you want to instantly destroy something and have its damage effects, debris and etc to trigger as it would from take_damage.
/obj/proc/kill(var/damagetype = DAM_BLUNT)
	if(!isdamageable())
		return
	set_health(min_health, damagetype)

/obj/proc/isbroken()
	return health <= (broken_threshold * get_max_health())

//Called when the health of the object goes below the broken_threshold, and while the health is higher than min_health
/obj/proc/broken(var/damagetype, var/user)
	//do stuff

//Called when the health gets back above the broken health threshold
/obj/proc/unbroken()
	//do stuff

//Handles checking if the object is destroyed and etc..
// - damagetype : is the damage type that triggered the health update.
// - user : is the attacker
/obj/proc/update_health(var/damagetype, var/user = null)
	if(!isdamageable())
		return //Assume we don't care about damages
	if(health <= min_health)
		if(ISDAMTYPE(damagetype, DAM_BURN))
			melt(user)
		else
			destroyed(damagetype,user)
	else if(health <= (broken_threshold * get_max_health()))
		broken(damagetype, user)
	update_icon()

//Called when the object's health reaches 0, with the last damage type that hit it
//Differs from Destroy in that Destroy has been mostly used as a destructor more than a damage effect proc. 
//And since we don't always want to create debris and stuff when destroying an object, its better to separate them.
// - damagetype : is the damage type that dealt the killing blow.
// - user : is the attacker
/obj/proc/destroyed(var/damagetype, var/user = null)
	health = min_health
	playsound(loc, sound_destroyed, vol=70, vary=1, extrarange=10, falloff=5)
	visible_message(SPAN_WARNING("\The [src] breaks appart!"))
	make_debris()
	qdel(src)

//Directly sets health, without updating object state
/obj/proc/set_health(var/newhealth, var/dtype = DAM_BLUNT)
	health = between(min_health, round(newhealth, 0.1), get_max_health()) //round(max(0, min(newhealth, max_health)), 0.1)
	update_health(dtype, usr)

//Convenience proc to handle adding health to the object
/obj/proc/add_health(var/addhealth, var/dtype = DAM_BLUNT)
	set_health(addhealth + get_health(), dtype)

//Convenience proc to handle removing health from the object
/obj/proc/rem_health(var/remhealth, var/dtype = DAM_BLUNT)
	set_health(get_health() - remhealth, dtype)

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
	if((obj_flags & OBJ_FLAG_ANCHORABLE) && default_wrench_floor_bolts(user, O))
		update_icon()
		return 1
	if(isdamageable() && user.a_intent == I_HURT && O.force > 0 && !(O.item_flags & ITEM_FLAG_NO_BLUDGEON))
		attack_melee(user, O)
		return 1
	return 0 //The code in atom/movable/attackby is causing more trouble than it solves.. AKA, prints messages to chat, when there's no actual damage being done

//Handle generic hits
/obj/attack_generic(var/mob/user, var/damage, var/attack_verb, var/wallbreaker, var/damtype = DAM_BLUNT)
	if(!isdamageable())
		return 0
	add_hiddenprint(user)
	add_fingerprint(user)

	//Ideally unarmed attacks should be handled by the mobs.. But for now I guess We'll make do.
	var/hitsoundoverride = sound_hit? sound_hit : "swing_hit" //So we can override the sound for special cases
	var/damoverride = damtype
	var/mob/living/carbon/human/H = user
	if(MUTATION_HULK in user.mutations)
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

	take_damage(damage, damoverride, 0, user)
	playsound(loc, hitsoundoverride, vol=60, vary=1, extrarange=8, falloff=6)
	return 1

//Handle weapon attacks
/obj/proc/attack_melee(var/mob/user, var/obj/item/W)
	if(!isdamageable() || !istype(W))
		return

	if(!istype(W, /obj/item/weapon)) // Some objects don't have click cooldowns/attack anims
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(W.sound_hit)
			playsound(loc, W.sound_hit, vol=60, vary=1, extrarange=8, falloff=6)
		attack_animation(user)
		take_damage(W.force, W.damtype, W.armor_penetration, W)
	else
		W.attack(src, user)

//Called by a weapon's "afterattack" proc when an attack has succeeded. Returns blocked damage
/obj/hit_with_weapon(obj/item/W, mob/living/user, var/effective_force)
	if(!pass_damage_threshold(W.force, W.damtype))
		hit_deflected_by_armor(W, user)
		return 0
	take_damage(W.force, W.damtype, armorbypass = W.armor_penetration, used_weapon = W)
	playsound(loc, sound_hit, vol=40, vary=1, extrarange=4, falloff=1)
	return ..()

//Called when the damage of an attack is resisted completely by the damage threshold
/obj/proc/hit_deflected_by_armor(obj/item/W, mob/living/user)
	log_debug("damage deflected by damage threshold of [src]")
	visible_message(SPAN_WARNING("[user]'s hit wasn't enough to pierce [src]'s armor!"))
	playsound(loc, sound_hit, vol=30, vary=1, extrarange=2, falloff=1) //ricochet sound I guess

//Placed a "force" argument, so whenever we fix explosions so they do damages, it'll be ready
/obj/ex_act(var/severity, var/force = 0)
	. = ..()
	if(!isdamageable())
		return
	if(!force)
		force = (explosion_base_damage ** (4 - severity)) //Severity is a value from 1 to 3, with 1 being the strongest. So each severity level is
	take_damage(force, DAM_BOMB, 0, "Explosion", DAM_DISPERSED)

//Called when under effect of a emp weapon
/obj/emp_act(var/severity, var/force = 0)
	. = ..()
	if(!isdamageable())
		return
	if(!force)
		force = (emp_base_damage ** (4 - severity))
	take_damage(force, DAM_EMP)

//Called when shot with a projectile
/obj/bullet_act(obj/item/projectile/P, def_zone)
	. = ..()
	if(!isdamageable())
		return
	//var/list/bdam = P.get_structure_damage()
	//When damages don't go through the damage threshold, give player feedback
	if(!pass_damage_threshold(P.force, P.damtype))
		visible_message(SPAN_WARNING("\The [src] was hit by \the [P]'s [P.damtype] with no visible effect."))
		playsound(loc, sound_hit, vol=40, vary=1, extrarange=4, falloff=2)
		return 0
	take_damage(P.force, P.damtype, P.penetration_modifier, P)

//Handles being hit by a thrown atom_movable
//	- damageoverride : if subclasses have a different damage calculation, pass the damage in this var
/obj/hitby(atom/movable/AM as mob|obj, var/speed = THROWFORCE_SPEED_DIVISOR, var/damageoverride = null)
	..()
	var/obj/O = AM
	var/isobject = istype(O)
	//Handle missing
	var/miss_chance = ThrowMissChance
	if(AM.throw_source)
		var/distance = get_dist(AM.throw_source, loc)
		miss_chance = max(ThrowMissChance*(distance-2), 0)
	if(prob(miss_chance))
		visible_message(SPAN_NOTICE("\The [O] misses [src] narrowly!"))
		return 0

	//Handle damages
	var/damtype = isobject? O.damtype : DAM_BLUNT
	var/ap = isobject? O.armor_penetration : 0
	var/throw_damage = 0
	if(damageoverride)
		throw_damage = damageoverride
	else
		throw_damage = isobject? O.throwforce*(speed/THROWFORCE_SPEED_DIVISOR) : (AM.throw_speed/THROWFORCE_SPEED_DIVISOR * AM.mass)

	//When damages don't go through the damage threshold, give player feedback
	if(!pass_damage_threshold(throw_damage, damtype))
		visible_message(SPAN_WARNING("\The [src] was hit by \the [AM] with no visible effect."))
		playsound(loc, sound_hit, vol=40, vary=1, extrarange=4, falloff=2)
		return 0
	take_damage(throw_damage, damtype, ap, AM)

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

//Called when an emag is used on it
/obj/emag_act(var/remaining_charges, var/mob/user, var/emag_source)
	return NO_EMAG_ACT

//Called when the entity is touched by fire or burning
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

//Implementation of the object burning from being in contact with fire
/obj/proc/fire_consume(var/datum/gas_mixture/air, var/exposed_temperature, var/exposed_volume)
	var/expvol = exposed_volume
	if(!burn_point || !air)
		return
	if(expvol <= 0)
		expvol = 1
	var/fire_damage = (exposed_temperature/burn_point) * (air.volume/expvol)
	take_damage(fire_damage, DAM_BURN) //might make more sense to use laser here...

//Called when set on fire
/obj/proc/ignite()
	burning = TRUE

//Called when fire is put out
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

//Called when the object is destroyed in-game and should release debris
/obj/proc/make_debris()
	for(var/key in matter)
		var/material/M = SSmaterials.get_material_by_name(key)
		if(M)
			M.place_shard(get_turf(loc))

//callback used by objects to react to incoming radio signals
/obj/proc/receive_signal(var/datum/signal/signal, var/receive_method = TRANSMISSION_RADIO, var/receive_param = null)
	return null

/obj/is_fluid_pushable(var/amt)
	return ..() && w_class <= round(amt/20)

/obj/proc/can_embed()
	return is_sharp(src)

//Handles anchoring and un-anchoring the obj to the floor with a wrench
/obj/proc/default_wrench_floor_bolts(mob/user, obj/item/weapon/tool/wrench/W, delay=2 SECONDS)
	if(!istype(W))
		return FALSE
	if(anchored)
		user.visible_message("\The [user] begins unsecuring \the [src] from the floor.", "You start unsecuring \the [src] from the floor.")
	else
		user.visible_message("\The [user] begins securing \the [src] to the floor.", "You start securing \the [src] to the floor.")
	if(W.use_tool(user, src, delay))
		if(!src) return
		to_chat(user, SPAN_NOTICE("You [anchored? "un" : ""]secured \the [src]!"))
		set_anchored(!anchored)
	return TRUE

//Simple quick proc for repairing things with a welder.
/obj/proc/default_welder_repair(var/mob/user, var/obj/item/weapon/tool/weldingtool/W, var/delay=5 SECONDS, var/repairedhealth = max_health)
	if(!istype(W))
		return FALSE
	if(!isdamaged())
		to_chat(user, SPAN_WARNING("\The [src] does not need repairs!"))
		return FALSE
	user.visible_message("[user] begins repairing \the [src].", "You begin repairing \the [src].")
	if(W.use_tool(user, src, delay))
		if(!src) return
		to_chat(user, SPAN_NOTICE("You repaired some damage!"))
		add_health(repairedhealth)
	return TRUE

/obj/proc/rotate()
	set name = "Rotate"
	set category = "Object"
	set src in oview(1)

	if(!usr || !Adjacent(usr))
		return
	if(src.anchored)
		to_chat(usr, SPAN_WARNING("\The [src] is bolted to the floor!"))
		return FALSE

	if(usr.stat == DEAD)
		if(!round_is_spooky())
			to_chat(src, "<span class='warning'>The veil is not thin enough for you to do that.</span>")
			return
	else if(usr.incapacitated())
		return

	src.set_dir(turn(src.dir, 90))
	update_icon()