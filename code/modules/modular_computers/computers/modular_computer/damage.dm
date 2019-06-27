/obj/item/modular_computer/examine(var/mob/user)
	. = ..()
	if(get_health() <= (broken_threshold * get_max_health()))
		to_chat(user, "<span class='danger'>It is heavily damaged!</span>")
	else if(isdamaged())
		to_chat(user, "It is damaged.")

/obj/item/modular_computer/destroyed()
	visible_message("\The [src] breaks apart!")
	var/turf/newloc = get_turf(src)
	new /obj/item/stack/material/steel(newloc, round(steel_sheet_cost/2))
	for(var/obj/item/weapon/computer_hardware/H in get_all_components())
		uninstall_component(null, H)
		H.forceMove(newloc)
		if(prob(25))
			H.take_damage(rand(10,30))
	qdel()

/obj/item/modular_computer/update_health(var/damagetype)
	..()
	if(get_health() <= (broken_threshold * get_max_health()))
		broken()

/obj/item/modular_computer/broken()
	shutdown_computer()

/obj/item/modular_computer/take_damage(damage, damtype, armorbypass, used_weapon, var/component_probability, var/damage_casing = 1, var/randomize = 1)
	if(randomize)
		// 75%-125%, rand() works with integers, apparently.
		damage *= (rand(75, 125) / 100.0)
	damage = round(damage)
	if(damage_casing)
		rem_health(damage)

	if(component_probability)
		for(var/obj/item/weapon/computer_hardware/H in get_all_components())
			if(prob(component_probability))
				H.take_damage(round(damage / 2), damtype)
	update_health()

// Stronger explosions cause serious damage to internal components
// Minor explosions are mostly mitigitated by casing.
/obj/item/modular_computer/ex_act(var/severity)
	take_damage(rand(100,200) / severity, component_probability = 30 / severity)

// EMPs are similar to explosions, but don't cause physical damage to the casing. Instead they screw up the components
/obj/item/modular_computer/emp_act(var/severity)
	take_damage(rand(100,200) / severity, component_probability = 50 / severity, damage_casing = 0)

// "Stun" weapons can cause minor damage to components (short-circuits?)
// "Burn" damage is equally strong against internal components and exterior casing
// "Brute" damage mostly damages the casing.
/obj/item/modular_computer/bullet_act(var/obj/item/projectile/Proj)
	if(IsDamageTypeBrute(Proj.damtype))
		take_damage(Proj.force, Proj.damtype, component_probability = Proj.force / 2)
	else if(IsDamageTypeBurn(Proj.damtype))
		take_damage(Proj.force, Proj.damtype, component_probability = Proj.force / 1.5)
	else if(ISDAMTYPE(Proj.damtype, DAM_PAIN))
		take_damage(Proj.force, Proj.damtype, component_probability = Proj.force / 3)
