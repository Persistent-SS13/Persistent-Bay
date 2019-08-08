/obj/item/organ/internal/kidneys
	name = "kidneys"
	icon_state = "kidneys"
	gender = PLURAL
	organ_tag = BP_KIDNEYS
	parent_organ = BP_GROIN
	min_bruised_damage = 50
	min_broken_damage = 80
	max_health = 95


/obj/item/organ/internal/kidneys/Process()
	..()

	if(!owner)
		return

	// Coffee is really bad for you with busted kidneys.
	// This should probably be expanded in some way, but fucked if I know
	// what else kidneys can process in our reagent list.
	var/datum/reagent/coffee = locate(/datum/reagent/drink/coffee) in owner.reagents.reagent_list
	if(coffee)
		if(is_bruised())
			owner.adjustToxLoss(0.1)
		else if(is_broken())
			owner.adjustToxLoss(0.3)

	if(is_bruised())
		if(prob(5) && reagents.get_reagent_amount(/datum/reagent/potassium) < 5)
			reagents.add_reagent(/datum/reagent/potassium, REM*5)
	if(is_broken())
		if(owner.reagents.get_reagent_amount(/datum/reagent/potassium) < 15)
			owner.reagents.add_reagent(/datum/reagent/potassium, REM*2)

	//If your kidneys aren't working, your body's going to have a hard time cleaning your blood.
	if(!owner.chem_effects[CE_ANTITOX])
		if(prob(33))
			if(is_broken())
				owner.adjustToxLoss(0.5)
			if(status & ORGAN_DEAD)
				owner.adjustToxLoss(1)

/obj/item/organ/internal/kidneys/on_update_icon()
	. = ..()
	if(BP_IS_ROBOTIC(src))
		icon_state = "[initial(icon_state)]-prosthetic"
	else
		icon_state = initial(icon_state)
