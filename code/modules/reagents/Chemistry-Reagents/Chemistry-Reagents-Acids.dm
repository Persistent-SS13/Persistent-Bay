//--------------------------------
//	Sulfuric Acid
//--------------------------------
/datum/reagent/acid
	name = "Sulphuric acid"
	description = "A very corrosive mineral acid with the molecular formula H2SO4."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#db5008"
	metabolism = REM * 2
	touch_met = 50 // It's acid!
	var/power = 5
	var/meltdose = 10 // How much is needed to melt

/datum/reagent/acid/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.take_organ_damage(0, removed * power * 2)

/datum/reagent/acid/affect_touch(var/mob/living/carbon/M, var/alien, var/removed) // This is the most interesting
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.head)
			if(H.head.unacidable)
				to_chat(H, "<span class='danger'>Your [H.head] protects you from the acid.</span>")
				remove_self(volume)
				return
			else if(removed > meltdose)
				to_chat(H, "<span class='danger'>Your [H.head] melts away!</span>")
				qdel(H.head)
				H.update_inv_head(1)
				H.update_hair(1)
				removed -= meltdose
		if(removed <= 0)
			return

		if(H.wear_mask)
			if(H.wear_mask.unacidable)
				to_chat(H, "<span class='danger'>Your [H.wear_mask] protects you from the acid.</span>")
				remove_self(volume)
				return
			else if(removed > meltdose)
				to_chat(H, "<span class='danger'>Your [H.wear_mask] melts away!</span>")
				qdel(H.wear_mask)
				H.update_inv_wear_mask(1)
				H.update_hair(1)
				removed -= meltdose
		if(removed <= 0)
			return

		if(H.glasses)
			if(H.glasses.unacidable)
				to_chat(H, "<span class='danger'>Your [H.glasses] partially protect you from the acid!</span>")
				removed /= 2
			else if(removed > meltdose)
				to_chat(H, "<span class='danger'>Your [H.glasses] melt away!</span>")
				qdel(H.glasses)
				H.update_inv_glasses(1)
				removed -= meltdose / 2
		if(removed <= 0)
			return

	if(M.unacidable)
		return

	if(volume < meltdose) // Not enough to melt anything
		M.take_organ_damage(0, removed * power * 0.1) //burn damage, since it causes chemical burns. Acid doesn't make bones shatter, like brute trauma would.
	else
		M.take_organ_damage(0, removed * power * 0.2)
		if(removed && ishuman(M) && prob(100 * removed / meltdose)) // Applies disfigurement
			var/mob/living/carbon/human/H = M
			var/screamed
			for(var/obj/item/organ/external/affecting in H.organs)
				if(!screamed && affecting.can_feel_pain())
					screamed = 1
					H.emote("scream")
				affecting.disfigured = 1

/datum/reagent/acid/touch_obj(var/obj/O)
	if(O.unacidable)
		return
	if((istype(O, /obj/item) || istype(O, /obj/effect/vine)) && (volume > meltdose))
		var/obj/effect/decal/cleanable/molten_item/I = new/obj/effect/decal/cleanable/molten_item(O.loc)
		I.desc = "Looks like this was \an [O] some time ago."
		for(var/mob/M in viewers(5, O))
			to_chat(M, "<span class='warning'>\The [O] melts.</span>")
		qdel(O)
		remove_self(meltdose) // 10 units of acid will not melt EVERYTHING on the tile

/datum/reagent/acid/touch_target(var/mob/living/M, var/amount, var/bodypart, var/blocked)
	M.apply_damage(power*amount*0.05, BURN, bodypart, blocked) //for reference, a puddle of 120(using 30% on touch) pure acid (power 5) volume using normal shoes (perm 0.5) will deal 4,5 BURN damage every half a second. the last multiplier is for balancing purposes

//--------------------------------
//	Hydrochloric Acid
//--------------------------------
/datum/reagent/acid/hydrochloric //Like sulfuric, but less toxic and more acidic.
	name = "Hydrochloric Acid"
	description = "A very corrosive mineral acid with the molecular formula HCl."
	taste_description = "stomach acid"
	reagent_state = LIQUID
	color = "#808080"
	power = 3
	meltdose = 8

//--------------------------------
//	Nitric Acid
//--------------------------------
/datum/reagent/acid/nitric	//Less acid than sulfuric or hydrocloric
	name = "Nitric Acid"
	description = "A highly corrosive mineral acid, nitration agent, and a strong oxidizing agent."
	taste_description = "melted tongue"
	reagent_state = LIQUID
	color = "#808080"
	power = 8	//Reacts with skin fat and protein decompose skin
	meltdose = 12

//--------------------------------
//	Polytrinic Acid
//--------------------------------
/datum/reagent/acid/polyacid
	name = "Polytrinic acid"
	description = "Polytrinic acid is a an extremely corrosive chemical substance."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#8e18a9"
	power = 10
	meltdose = 4