/obj/item/weapon
	name = "weapon"
	icon = 'icons/obj/weapons.dmi'
	mass = 1
	damtype = DAM_BLUNT
	armor_penetration = 0
	throwforce = 1
	force = 1
	attack_cooldown = DEFAULT_ATTACK_COOLDOWN
	var/miss_chance  = 2 //% Chance for the hit with this weapon to miss
	var/sound_attack = "swing_hit"
	var/sound_miss   = "swing_miss"


/obj/item/weapon/attack(atom/movable/AM, mob/living/user as mob, var/target_zone)
	if(!..())
		return 0

	user.setClickCooldown(attack_cooldown)
	if (!ishuman(user))
		to_chat(user, SPAN_DANGER("You don't have the dexterity to do this!"))
		return 0

	user.do_attack_animation(AM)
	if ((MUTATION_CLUMSY in user.mutations) && prob(50))
		to_chat(user, SPAN_DANGER("\The [src] slips out of your hand and hits your head."))
		user.apply_damage(10, DAM_BLUNT)
		user.Paralyse(20)
		return 0

	if(prob(miss_chance))
		playsound(loc, sound_miss, vol=50, vary=1, falloff=1)
		visible_message(SPAN_WARNING("\The [user] misses [AM] narrowly!"), SPAN_WARNING("You miss narrowly hitting [AM]!"))
		return 0

	if(ismob(AM))
		admin_attack_log(user, AM, "Attacked using \a [src]", "Was attacked with \a [src]", "used \a [src] to attack")
	var/hit_zone = null
	if(isliving(AM))
		var/mob/living/L = AM
		hit_zone = L.resolve_item_attack(src, user, target_zone)
	src.apply_hit_effect(AM, user, hit_zone)
	return TRUE

//Called when a weapon is used to make a successful melee attack on a mob. Returns the blocked result
/obj/item/weapon/apply_hit_effect(atom/movable/target, mob/living/user, var/hit_zone)
	if(src.sound_attack)
		playsound(src.loc, src.sound_attack, vol=75, vary=1, extrarange=8, falloff=4)

	var/power = src.force
	if(MUTATION_HULK in user.mutations)
		power *= 2
	return target.hit_with_weapon(src, user, power, hit_zone)

/obj/item/weapon/Bump(mob/M as mob)
	spawn(0)
		..()
	return
