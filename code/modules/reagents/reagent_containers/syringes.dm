////////////////////////////////////////////////////////////////////////////////
/// Syringes.
////////////////////////////////////////////////////////////////////////////////
#define SYRINGE_DRAW 0
#define SYRINGE_INJECT 1
#define SYRINGE_BROKEN 2

/obj/item/weapon/reagent_containers/syringe
	name = "syringe"
	desc = "A syringe."
	icon = 'icons/obj/syringe.dmi'
	item_state = "rg0"
	icon_state = "rg"
	matter = list(MATERIAL_GLASS = 150)
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = "1;2;5"
	volume = 15
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	sharpness = 1
	unacidable = 1 //glass
	damtype = DAM_PIERCE
	force = 0
	var/mode = SYRINGE_DRAW
	var/image/filling //holds a reference to the current filling overlay
	var/visible_name = "a syringe"
	var/time = 30

/obj/item/weapon/reagent_containers/syringe/Initialize(var/mapload)
	. = ..()
	queue_icon_update()

/obj/item/weapon/reagent_containers/syringe/on_reagent_change()
	update_icon()

/obj/item/weapon/reagent_containers/syringe/pickup(mob/user)
	. = ..()
	update_icon()

/obj/item/weapon/reagent_containers/syringe/dropped(mob/user)
	. = ..()
	update_icon()

/obj/item/weapon/reagent_containers/syringe/attack_self(mob/user as mob)
	switch(mode)
		if(SYRINGE_DRAW)
			mode = SYRINGE_INJECT
		if(SYRINGE_INJECT)
			mode = SYRINGE_DRAW
		if(SYRINGE_BROKEN)
			return
	update_icon()

/obj/item/weapon/reagent_containers/syringe/attack_hand()
	. = ..()
	update_icon()

/obj/item/weapon/reagent_containers/syringe/attackby(obj/item/I as obj, mob/user as mob)
	return

/obj/item/weapon/reagent_containers/syringe/afterattack(obj/target, mob/user, proximity)
	if(!proximity)
		return

	if(mode == SYRINGE_BROKEN)
		to_chat(user, SPAN_WARNING("This syringe is broken."))
		return

	if(istype(target, /obj/structure/closet/body_bag))
		handleBodyBag(target, user)
		return

	if(!target.reagents)
		return

	if((user.a_intent == I_HURT) && ismob(target))
		syringestab(target, user)
		return

	handleTarget(target, user)

/obj/item/weapon/reagent_containers/syringe/on_update_icon()
	overlays.Cut()
	underlays.Cut()

	if(mode == SYRINGE_BROKEN)
		icon_state = "broken"
		return
	if(!reagents)
		return
	var/rounded_vol = Clamp(round((reagents.total_volume / volume * 15),5), 5, 15)
	if (reagents.total_volume == 0)
		rounded_vol = 0
	if(ismob(loc))
		var/injoverlay
		switch(mode)
			if (SYRINGE_DRAW)
				injoverlay = "draw"
			if (SYRINGE_INJECT)
				injoverlay = "inject"
		overlays += injoverlay
	icon_state = "[initial(icon_state)][rounded_vol]"
	item_state = "syringe_[rounded_vol]"

	if(reagents.total_volume)
		filling = image('icons/obj/reagentfillings.dmi', src, "syringe10")

		filling.icon_state = "syringe[rounded_vol]"

		filling.color = reagents.get_color()
		underlays += filling

/obj/item/weapon/reagent_containers/syringe/proc/handleTarget(var/atom/target, var/mob/user)
	switch(mode)
		if(SYRINGE_DRAW)
			drawReagents(target, user)

		if(SYRINGE_INJECT)
			injectReagents(target, user)

/obj/item/weapon/reagent_containers/syringe/proc/drawReagents(var/atom/target, var/mob/user)
	if(!reagents.get_free_space())
		to_chat(user, SPAN_WARNING("The syringe is full."))
		mode = SYRINGE_INJECT
		return

	if(ismob(target))//Blood!
		if(reagents.has_reagent(/datum/reagent/blood))
			to_chat(user, SPAN_NOTICE("There is already a blood sample in this syringe."))
			return
		if(istype(target, /mob/living/carbon))
			if(istype(target, /mob/living/carbon/slime))
				to_chat(user, SPAN_WARNING("You are unable to locate any blood."))
				return
			var/amount = reagents.get_free_space()
			var/mob/living/carbon/T = target
			if(!T.dna)
				to_chat(user, SPAN_WARNING("You are unable to locate any blood."))
				if(istype(target, /mob/living/carbon/human))
					CRASH("[T] \[[T.type]\] was missing their dna datum!")
				return
			if(MUTATION_NOCLONE in T.mutations) //target done been et, no more blood in him
				to_chat(user, SPAN_WARNING("You are unable to locate any blood."))
				return

			var/injtime = time //Taking a blood sample through a hardsuit takes longer due to needing to find a port.
			var/allow = T.can_inject(user, check_zone(user.zone_sel.selecting))
			if(!allow)
				return
			if(allow == INJECTION_PORT)
				injtime *= 2
				user.visible_message(SPAN_WARNING("\The [user] begins hunting for an injection port on [target]'s suit!"))
			else
				user.visible_message(SPAN_WARNING("\The [user] is trying to take a blood sample from [target]."))

			if(prob(user.skill_fail_chance(SKILL_MEDICAL, 60, SKILL_BASIC)))
				to_chat(user, "<span class='warning'>You miss the vein!</span>")
				var/target_zone = check_zone(user.zone_sel.selecting)
				T.apply_damage(3, DAM_PIERCE, target_zone, damage_flags=0)
				return

			injtime *= user.skill_delay_mult(SKILL_MEDICAL)
			user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
			user.do_attack_animation(target)

			if(!do_mob(user, target, injtime))
				return

			T.take_blood(src, amount)
			to_chat(user, SPAN_NOTICE("You take a blood sample from [target]."))
			for(var/mob/O in viewers(4, user))
				O.show_message(SPAN_NOTICE("[user] takes a blood sample from [target]."), 1)

	else //if not mob
		if(!target.reagents.total_volume)
			to_chat(user, SPAN_NOTICE("[target] is empty."))
			return

		if(!target.is_open_container() && !istype(target, /obj/structure/reagent_dispensers) && !istype(target, /obj/item/slime_extract))
			to_chat(user, SPAN_NOTICE("You cannot directly remove reagents from this object."))
			return

		var/trans = target.reagents.trans_to_obj(src, amount_per_transfer_from_this)
		to_chat(user, SPAN_NOTICE("You fill the syringe with [trans] units of the solution."))
		update_icon()

	if(!reagents.get_free_space())
		mode = SYRINGE_INJECT
		update_icon()

/obj/item/weapon/reagent_containers/syringe/proc/injectReagents(var/atom/target, var/mob/user)
	if(ismob(target) && !user.skill_check(SKILL_MEDICAL, SKILL_BASIC))
		syringestab(target, user)

	if(!reagents.total_volume)
		to_chat(user, SPAN_NOTICE("The syringe is empty."))
		mode = SYRINGE_DRAW
		return
	if(istype(target, /obj/item/weapon/implantcase/chem))
		return

	if(!target.is_open_container() && !ismob(target) && !istype(target, /obj/item/weapon/reagent_containers/food) && !istype(target, /obj/item/slime_extract) && !istype(target, /obj/item/clothing/mask/smokable/cigarette) && !istype(target, /obj/item/weapon/storage/fancy/cigarettes))
		to_chat(user, SPAN_NOTICE("You cannot directly fill this object."))
		return
	if(!target.reagents.get_free_space())
		to_chat(user, SPAN_NOTICE("[target] is full."))
		return

	if(isliving(target))
		injectMob(target, user)
		return

	var/trans = reagents.trans_to(target, amount_per_transfer_from_this)
	to_chat(user, SPAN_NOTICE("You inject \the [target] with [trans] units of the solution. \The [src] now contains [src.reagents.total_volume] units."))
	if(reagents.total_volume <= 0 && mode == SYRINGE_INJECT)
		mode = SYRINGE_DRAW
		update_icon()

/obj/item/weapon/reagent_containers/syringe/proc/handleBodyBag(var/obj/structure/closet/body_bag/bag, var/mob/living/carbon/user)
	if(bag.opened || !bag.contains_body)
		return

	var/mob/living/L = locate() in bag
	if(L)
		injectMob(L, user, bag)

/obj/item/weapon/reagent_containers/syringe/proc/injectMob(var/mob/living/carbon/target, var/mob/living/carbon/user, var/atom/trackTarget)
	if(!trackTarget)
		trackTarget = target

	if(target != user)
		var/injtime = time //Injecting through a hardsuit takes longer due to needing to find a port.
		var/allow = target.can_inject(user, check_zone(user.zone_sel.selecting))
		if(!allow)
			return
		if(allow == INJECTION_PORT)
			injtime *= 2
			user.visible_message(SPAN_WARNING("\The [user] begins hunting for an injection port on [target]'s suit!"))
		else
			user.visible_message(SPAN_WARNING("\The [user] is trying to inject [target] with [visible_name]!"))

		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
		user.do_attack_animation(trackTarget)

		if(!user.do_skilled(injtime, SKILL_MEDICAL, trackTarget))
			return

		if(target != trackTarget && target.loc != trackTarget)
			return

	var/trans = reagents.trans_to_mob(target, amount_per_transfer_from_this, CHEM_BLOOD)

	if(target != user)
		var/contained = reagentlist()
		admin_inject_log(user, target, src, contained, trans)
		user.visible_message(SPAN_WARNING("\the [user] injects \the [target] with [visible_name]!"), SPAN_NOTICE("You inject \the [target] with [trans] units of the solution. \The [src] now contains [src.reagents.total_volume] units."))
	else
		to_chat(user, SPAN_NOTICE("You inject yourself with [trans] units of the solution. \The [src] now contains [src.reagents.total_volume] units."))

	if(reagents.total_volume <= 0 && mode == SYRINGE_INJECT)
		mode = SYRINGE_DRAW
		update_icon()

/obj/item/weapon/reagent_containers/syringe/proc/syringestab(var/mob/living/carbon/target, var/mob/living/carbon/user)

	if(istype(target, /mob/living/carbon/human))

		var/mob/living/carbon/human/H = target

		var/target_zone = check_zone(user.zone_sel.selecting)
		var/obj/item/organ/external/affecting = H.get_organ(target_zone)

		if (!affecting || affecting.is_stump())
			to_chat(user, SPAN_DANGER("They are missing that limb!"))
			return

		var/hit_area = affecting.name

		if((user != target) && H.check_shields(7, src, user, "\the [src]"))
			return

		if (target != user && H.get_blocked_ratio(target_zone, DAM_PIERCE) > 0.05 && prob(50))
			for(var/mob/O in viewers(world.view, user))
				O.show_message(text(SPAN_DANGER("[user] tries to stab [target] in \the [hit_area] with [src.name], but the attack is deflected by armor!")), 1)
			user.remove_from_mob(src)
			qdel(src)

			admin_attack_log(user, target, "Attacked using \a [src]", "Was attacked with \a [src]", "used \a [src] to attack")
			return

		user.visible_message(SPAN_DANGER("[user] stabs [target] in \the [hit_area] with [src.name]!"))
		target.apply_damage(3, DAM_PIERCE, target_zone)

	else
		user.visible_message(SPAN_DANGER("[user] stabs [target] with [src.name]!"))
		target.apply_damage(3, DAM_PIERCE)

	var/syringestab_amount_transferred = rand(0, (reagents.total_volume - 5)) //nerfed by popular demand
	var/contained_reagents = reagents.get_reagents()
	var/trans = reagents.trans_to_mob(target, syringestab_amount_transferred, CHEM_BLOOD)
	if(isnull(trans)) trans = 0
	admin_inject_log(user, target, src, contained_reagents, trans, violent=1)
	break_syringe(target, user)

/obj/item/weapon/reagent_containers/syringe/proc/break_syringe(mob/living/carbon/target, mob/living/carbon/user)
	desc += " It is broken."
	mode = SYRINGE_BROKEN
	if(target)
		add_blood(target)
	if(user)
		add_fingerprint(user)
	update_icon()

/obj/item/weapon/reagent_containers/syringe/ld50_syringe
	name = "Lethal Injection Syringe"
	desc = "A syringe used for lethal injections."
	amount_per_transfer_from_this = 60
	volume = 60
	visible_name = "a giant syringe"
	time = 300

/obj/item/weapon/reagent_containers/syringe/ld50_syringe/syringestab(var/mob/living/carbon/target, var/mob/living/carbon/user)
	to_chat(user, SPAN_NOTICE("This syringe is too big to stab someone with it."))
	return // No instant injecting

/obj/item/weapon/reagent_containers/syringe/ld50_syringe/drawReagents(var/target, var/mob/user)
	if(ismob(target)) // No drawing 60 units of blood at once
		to_chat(user, SPAN_NOTICE("This needle isn't designed for drawing blood."))
		return
	..()

////////////////////////////////////////////////////////////////////////////////
/// Syringes. END
////////////////////////////////////////////////////////////////////////////////

/obj/item/weapon/reagent_containers/syringe/inaprovaline
	name = "Syringe (inaprovaline)"
	desc = "Contains inaprovaline - used to stabilize patients."
	mode = SYRINGE_INJECT
	starts_with = list(/datum/reagent/inaprovaline = 15)

/obj/item/weapon/reagent_containers/syringe/antitoxin
	name = "Syringe (anti-toxin)"
	desc = "Contains anti-toxins."
	mode = SYRINGE_INJECT
	starts_with = list(/datum/reagent/dylovene = 15)

/obj/item/weapon/reagent_containers/syringe/antiviral
	name = "Syringe (spaceacillin)"
	desc = "Contains antiviral agents."
	mode = SYRINGE_INJECT
	starts_with = list(/datum/reagent/spaceacillin = 15)

/obj/item/weapon/reagent_containers/syringe/drugs
	name = "Syringe (drugs)"
	desc = "Contains aggressive drugs meant for torture."
	mode = SYRINGE_INJECT
	starts_with = list(/datum/reagent/spaceacillin = 15,
			/datum/reagent/space_drugs = 5,
			/datum/reagent/mindbreaker = 5,
			/datum/reagent/cryptobiolin = 5,
		)

/obj/item/weapon/reagent_containers/syringe/ld50_syringe/choral
	mode = SYRINGE_INJECT
	starts_with = list(/datum/reagent/chloralhydrate = 60)

/obj/item/weapon/reagent_containers/syringe/steroid
	name = "Syringe (anabolic steroids)"
	desc = "Contains drugs for muscle growth."
	starts_with = list(/datum/reagent/adrenaline = 5,
		/datum/reagent/hyperzine = 10,
	)


// TG ports

/obj/item/weapon/reagent_containers/syringe/bluespace
	name = "bluespace syringe"
	desc = "An advanced syringe that can hold 60 units of chemicals."
	amount_per_transfer_from_this = 20
	volume = 60
	icon_state = "bs"

/obj/item/weapon/reagent_containers/syringe/noreact
	name = "cryostasis syringe"
	desc = "An advanced syringe that stops reagents inside from reacting. It can hold up to 20 units."
	volume = 20
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_REACT
	icon_state = "cs"

