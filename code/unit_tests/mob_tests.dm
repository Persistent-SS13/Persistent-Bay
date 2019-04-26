
/*
 *
 *  Mob Unit Tests.
 *
 *  Human suffocation in Space.
 *  Mob damage Template
 *
 */

#define SUCCESS 1
#define FAILURE 0

//
// Tests Life() and mob breathing in space.
//

datum/unit_test/human_breath
	name = "MOB: Breathing Species Suffocate in Space"
	var/list/test_subjects = list()
	async = 1

datum/unit_test/human_breath/start_test()
	var/turf/T = get_space_turf()

	if(!istype(T, /turf/space))	//If the above isn't a space turf then we force it to find one will most likely pick 1,1,1
		T = locate(/turf/space)
	for(var/species_name in all_species)
		var/datum/species/S = all_species[species_name]
		var/mob/living/carbon/human/H = new(T, S.name)
		if(H.need_breathe())
			var/species_organ = H.species.breathing_organ
			var/obj/item/organ/internal/lungs/L
			H.apply_effect(20, STUN, 0)
			L = H.internal_organs_by_name[species_organ]
			L.last_successful_breath = -INFINITY
			test_subjects[S.name] = list(H, damage_check(H, DAM_OXY))
	return 1

datum/unit_test/human_breath/check_result()
	for(var/i in test_subjects)
		var/mob/living/carbon/human/H = test_subjects[i][1]
		if(H.life_tick < 10) 	// Finish Condition
			return 0	// Return 0 to try again later.

	var/failcount = 0
	for(var/i in test_subjects)
		var/mob/living/carbon/human/H = test_subjects[i][1]
		var/ending_oxyloss = damage_check(H, DAM_OXY)
		var/starting_oxyloss = test_subjects[i][2]
		if(starting_oxyloss >= ending_oxyloss)
			failcount++
			log_debug("[H.species.name] is not taking oxygen damage, started with [starting_oxyloss] and ended with [ending_oxyloss] at place [log_info_line(H.loc)].")

	if(failcount)
		fail("[failcount] breathing species mobs didn't suffocate in space.")
	else
		pass("All breathing species mobs suffocated in space.")

	return 1	// return 1 to show we're done and don't want to recheck the result.

// ============================================================================

/var/default_mobloc = null

proc/create_test_mob_with_mind(var/turf/mobloc = null, var/mobtype = /mob/living/carbon/human)
	var/list/test_result = list("result" = FAILURE, "msg"    = "", "mobref" = null)

	if(isnull(mobloc))
		if(!default_mobloc)
			for(var/turf/simulated/floor/tiled/T in world)
				T.update_air_properties()
				var/pressure = T.zone.air.return_pressure()
				if(90 < pressure && pressure < 120) // Find a turf between 90 and 120
					default_mobloc = T
					break
		mobloc = default_mobloc
	if(!mobloc)
		test_result["msg"] = "Unable to find a location to create test mob"
		return test_result

	var/mob/living/carbon/human/H = new mobtype(mobloc)

	H.mind_initialize("TestKey[rand(0,10000)]")

	test_result["result"] = SUCCESS
	test_result["msg"] = "Mob created"
	test_result["mobref"] = "\ref[H]"

	return test_result

//Generic Check
// TODO: Need to make sure I didn't just recreate the wheel here.

proc/damage_check(var/mob/living/M, var/damage_type)
	var/loss = null

	if(IsDamageTypeBrute(damage_type))
		loss = M.getBruteLoss()
	else if(IsDamageTypeBurn(damage_type))
		loss = M.getFireLoss()
	else 
		switch(damage_type)
			if(DAM_BIO)
				loss = M.getToxLoss()
			if(DAM_OXY)
				loss = M.getOxyLoss()
				if(istype(M,/mob/living/carbon/human))
					var/mob/living/carbon/human/H = M
					var/obj/item/organ/internal/lungs/L = H.internal_organs_by_name["lungs"]
					if(L)
						loss = L.oxygen_deprivation
			if(DAM_CLONE)
				loss = M.getCloneLoss()
			if(DAM_PAIN)
				loss = M.getHalLoss()

	if(!loss && istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M            // Synthetics have robot limbs which don't report damage to getXXXLoss()
		if(H.isSynthetic())                          // So we have to hard code this check or create a different one for them.
			return H.species.total_health - H.health
	return loss

// ==============================================================================================================

//
//DAMAGE EXPECTATIONS
// used with expectected_vunerability

#define STANDARD 0            // Will take standard damage (damage_ratio of 1)
#define ARMORED 1             // Will take less damage than applied
#define EXTRA_VULNERABLE 2    // Will take more dmage than applied
#define IMMUNE 3              // Will take no damage

//==============================================================================================================


datum/unit_test/mob_damage
	name = "MOB: Template for mob damage"
	var/mob/living/carbon/human/testmob = null
	var/damagetype = DAM_BLUNT
	var/mob_type = /mob/living/carbon/human
	var/expected_vulnerability = STANDARD
	var/check_health = 0
	var/damage_location = BP_CHEST

datum/unit_test/mob_damage/start_test()
	var/list/test = create_test_mob_with_mind(null, mob_type)
	var/damage_amount = 4	// Do not raise, if damage >= 5 there is a % chance to reduce damage by half in /obj/item/organ/external/take_damage()
							// Which makes checks impossible.

	if(isnull(test))
		fail("Check Runtimed in Mob creation")

	if(test["result"] == FAILURE)
		fail(test["msg"])
		return 0

	var/mob/living/carbon/human/H = locate(test["mobref"])

	if(isnull(H))
		fail("Test unable to set test mob from reference")
		return 0

	if(H.stat)

		fail("Test needs to be re-written, mob has a stat = [H.stat]")
		return 0

	if(H.sleeping)
		fail("Test needs to be re-written, mob is sleeping for some unknown reason")
		return 0

	// Damage the mob

	var/initial_health = H.health

	if(damagetype == DAM_OXY && H.need_breathe())
		var/species_organ = H.species.breathing_organ
		var/obj/item/organ/internal/lungs/L
		if(species_organ)
			L = H.internal_organs_by_name[species_organ]
		if(L)
			L.last_successful_breath = -INFINITY

	H.apply_damage(damage_amount, damagetype, damage_location)

	var/ending_damage = damage_check(H, damagetype)

	var/ending_health = H.health

	// Now test this stuff.

	var/failure = 0

	var/damage_ratio = STANDARD

	if (ending_damage == 0)
		damage_ratio = IMMUNE

	else if (ending_damage < damage_amount)
		damage_ratio = ARMORED

	else if (ending_damage > damage_amount)
		damage_ratio = EXTRA_VULNERABLE

	if(damage_ratio != expected_vulnerability)
		failure = 1

	// Now generate the message for this test.

	var/expected_msg = null

	switch(expected_vulnerability)
		if(STANDARD)
			expected_msg = "to take standard damage"
		if(ARMORED)
			expected_msg = "To take less damage"
		if(EXTRA_VULNERABLE)
			expected_msg = "To take extra damage"
		if(IMMUNE)
			expected_msg = "To take no damage"


	var/msg = "Damage taken: [ending_damage] out of [damage_amount] || expected: [expected_msg] \[Overall Health:[ending_health] (Initial: [initial_health]\]"

	if(failure)
		fail(msg)
	else
		pass(msg)

	return 1

// =================================================================
// Human damage check.
// =================================================================

datum/unit_test/mob_damage/brute
	name = "MOB: Human Brute damage check"
	damagetype = DAM_BLUNT

datum/unit_test/mob_damage/cut
	name = "MOB: Human Cut damage check"
	damagetype = DAM_CUT

datum/unit_test/mob_damage/pierce
	name = "MOB: Human Pierce damage check"
	damagetype = DAM_PIERCE

datum/unit_test/mob_damage/fire
	name = "MOB: Human Fire damage check"
	damagetype = DAM_BURN

datum/unit_test/mob_damage/laser
	name = "MOB: Human Laser damage check"
	damagetype = DAM_LASER

datum/unit_test/mob_damage/energy
	name = "MOB: Human Energy damage check"
	damagetype = DAM_ENERGY

datum/unit_test/mob_damage/tox
	name = "MOB: Human Toxin damage check"
	damagetype = DAM_BIO

datum/unit_test/mob_damage/oxy
	name = "MOB: Human Oxygen damage check"
	damagetype = DAM_OXY

datum/unit_test/mob_damage/clone
	name = "MOB: Human Clone damage check"
	damagetype = DAM_CLONE

datum/unit_test/mob_damage/halloss
	name = "MOB: Human Halloss damage check"
	damagetype = DAM_PAIN

// =================================================================
// Unathi
// =================================================================

datum/unit_test/mob_damage/unathi
	name = "MOB: Unathi damage check template"
	mob_type = /mob/living/carbon/human/unathi

datum/unit_test/mob_damage/unathi/brute
	name = "MOB: Unathi Brute Damage Check"
	damagetype = DAM_BLUNT
	expected_vulnerability = ARMORED

datum/unit_test/mob_damage/unathi/cut
	name = "MOB: Unathi Cut damage check"
	damagetype = DAM_CUT
	expected_vulnerability = ARMORED

datum/unit_test/mob_damage/unathi/pierce
	name = "MOB: Unathi Pierce damage check"
	damagetype = DAM_PIERCE
	expected_vulnerability = ARMORED

datum/unit_test/mob_damage/unathi/fire
	name = "MOB: Unathi Fire Damage Check"
	damagetype = DAM_BURN

datum/unit_test/mob_damage/unathi/laser
	name = "MOB: Unathi Laser damage check"
	damagetype = DAM_LASER

datum/unit_test/mob_damage/unathi/energy
	name = "MOB: Unathi Energy damage check"
	damagetype = DAM_ENERGY

datum/unit_test/mob_damage/unathi/tox
	name = "MOB: Unathi Toxins Damage Check"
	damagetype = DAM_BIO

datum/unit_test/mob_damage/unathi/oxy
	name = "MOB: Unathi Oxygen Damage Check"
	damagetype = DAM_OXY

datum/unit_test/mob_damage/unathi/clone
	name = "MOB: Unathi Clone Damage Check"
	damagetype = DAM_CLONE

datum/unit_test/mob_damage/unathi/halloss
	name = "MOB: Unathi Halloss Damage Check"
	damagetype = DAM_PAIN

// =================================================================
// Skrell
// =================================================================

datum/unit_test/mob_damage/skrell
	name = "MOB: Skrell damage check template"
	mob_type = /mob/living/carbon/human/skrell

datum/unit_test/mob_damage/skrell/brute
	name = "MOB: Skrell Brute Damage Check"
	damagetype = DAM_BLUNT

datum/unit_test/mob_damage/skrell/cut
	name = "MOB: Skrell Cut damage check"
	damagetype = DAM_CUT

datum/unit_test/mob_damage/skrell/pierce
	name = "MOB: Skrell Pierce damage check"
	damagetype = DAM_PIERCE

datum/unit_test/mob_damage/skrell/fire
	name = "MOB: Skrell Fire Damage Check"
	damagetype = DAM_BURN

datum/unit_test/mob_damage/skrell/laser
	name = "MOB: Skrell Laser damage check"
	damagetype = DAM_LASER

datum/unit_test/mob_damage/skrell/energy
	name = "MOB: Skrell Energy damage check"
	damagetype = DAM_ENERGY

datum/unit_test/mob_damage/skrell/tox
	name = "MOB: Skrell Toxins Damage Check"
	damagetype = DAM_BIO

datum/unit_test/mob_damage/skrell/oxy
	name = "MOB: Skrell Oxygen Damage Check"
	damagetype = DAM_OXY

datum/unit_test/mob_damage/skrell/clone
	name = "MOB: Skrell Clone Damage Check"
	damagetype = DAM_CLONE

datum/unit_test/mob_damage/skrell/halloss
	name = "MOB: Skrell Halloss Damage Check"
	damagetype = DAM_PAIN

// =================================================================
// Vox
// =================================================================

datum/unit_test/mob_damage/vox
	name = "MOB: Vox damage check template"
	mob_type = /mob/living/carbon/human/vox

datum/unit_test/mob_damage/vox/brute
	name = "MOB: Vox Brute Damage Check"
	damagetype = DAM_BLUNT

datum/unit_test/mob_damage/vox/cut
	name = "MOB: Vox Cut damage check"
	damagetype = DAM_CUT

datum/unit_test/mob_damage/vox/pierce
	name = "MOB: Vox Pierce damage check"
	damagetype = DAM_PIERCE

datum/unit_test/mob_damage/vox/fire
	name = "MOB: Vox Fire Damage Check"
	damagetype = DAM_BURN

datum/unit_test/mob_damage/vox/laser
	name = "MOB: Vox Laser damage check"
	damagetype = DAM_LASER

datum/unit_test/mob_damage/vox/energy
	name = "MOB: Vox Energy damage check"
	damagetype = DAM_ENERGY

datum/unit_test/mob_damage/vox/tox
	name = "MOB: Vox Toxins Damage Check"
	damagetype = DAM_BIO

datum/unit_test/mob_damage/vox/oxy
	name = "MOB: Vox Oxygen Damage Check"
	damagetype = DAM_OXY

datum/unit_test/mob_damage/vox/clone
	name = "MOB: Vox Clone Damage Check"
	damagetype = DAM_CLONE
	expected_vulnerability = IMMUNE

datum/unit_test/mob_damage/vox/halloss
	name = "MOB: Vox Halloss Damage Check"
	damagetype = DAM_PAIN

// =================================================================
// Diona
// =================================================================
/*
datum/unit_test/mob_damage/diona
	name = "MOB: Diona damage check template"
	mob_type = /mob/living/carbon/human/diona

datum/unit_test/mob_damage/diona/brute
	name = "MOB: Diona Brute Damage Check"
	damagetype = DAM_BLUNT

datum/unit_test/mob_damage/diona/fire
	name = "MOB: Diona Fire Damage Check"
	damagetype = DAM_BURN

datum/unit_test/mob_damage/diona/tox
	name = "MOB: Diona Toxins Damage Check"
	damagetype = DAM_BIO

datum/unit_test/mob_damage/diona/oxy
	name = "MOB: Diona Oxygen Damage Check"
	damagetype = DAM_OXY
	expected_vulnerability = IMMUNE

datum/unit_test/mob_damage/diona/clone
	name = "MOB: Diona Clone Damage Check"
	damagetype = DAM_CLONE
	expected_vulnerability = IMMUNE

datum/unit_test/mob_damage/diona/halloss
	name = "MOB: Diona Halloss Damage Check"
	damagetype = DAM_PAIN
	expected_vulnerability = IMMUNE
*/

// =================================================================
// Nabbers
// =================================================================

datum/unit_test/mob_damage/nabber
	name = "MOB: GAS damage check template"
	mob_type = /mob/living/carbon/human/nabber

datum/unit_test/mob_damage/nabber/brute
	name = "MOB: GAS Brute Damage Check"
	damagetype = DAM_BLUNT
	expected_vulnerability = ARMORED

datum/unit_test/mob_damage/nabber/cut
	name = "MOB: GAS cut Damage Check"
	damagetype = DAM_CUT
	expected_vulnerability = ARMORED

datum/unit_test/mob_damage/nabber/pierce
	name = "MOB: GAS pierce Damage Check"
	damagetype = DAM_PIERCE
	expected_vulnerability = ARMORED

datum/unit_test/mob_damage/nabber/fire
	name = "MOB: GAS Fire Damage Check"
	damagetype = DAM_BURN
	expected_vulnerability = EXTRA_VULNERABLE

datum/unit_test/mob_damage/nabber/laser
	name = "MOB: GAS Laser Damage Check"
	damagetype = DAM_LASER
	expected_vulnerability = EXTRA_VULNERABLE

datum/unit_test/mob_damage/nabber/energy
	name = "MOB: GAS Energy Damage Check"
	damagetype = DAM_ENERGY
	expected_vulnerability = EXTRA_VULNERABLE

datum/unit_test/mob_damage/nabber/tox
	name = "MOB: GAS Toxins Damage Check"
	damagetype = DAM_BIO

datum/unit_test/mob_damage/nabber/oxy
	name = "MOB: GAS Oxygen Damage Check"
	damagetype = DAM_OXY
	expected_vulnerability = ARMORED

datum/unit_test/mob_damage/nabber/clone
	name = "MOB: GAS Clone Damage Check"
	damagetype = DAM_CLONE

datum/unit_test/mob_damage/nabber/halloss
	name = "MOB: GAS Halloss Damage Check"
	damagetype = DAM_PAIN

// =================================================================
// SPECIAL WHITTLE SNOWFLAKES aka IPC
// =================================================================

datum/unit_test/mob_damage/machine
	name = "MOB: IPC damage check template"
	mob_type = /mob/living/carbon/human/machine

datum/unit_test/mob_damage/machine/brute
	name = "MOB: IPC Brute Damage Check"
	damagetype = DAM_BLUNT

datum/unit_test/mob_damage/machine/cut
	name = "MOB: IPC Cut damage check"
	damagetype = DAM_CUT

datum/unit_test/mob_damage/machine/pierce
	name = "MOB: IPC Pierce damage check"
	damagetype = DAM_PIERCE

datum/unit_test/mob_damage/machine/fire
	name = "MOB: IPC Fire Damage Check"
	damagetype = DAM_BURN

datum/unit_test/mob_damage/machine/laser
	name = "MOB: IPC Laser damage check"
	damagetype = DAM_LASER

datum/unit_test/mob_damage/machine/energy
	name = "MOB: IPC Energy damage check"
	damagetype = DAM_ENERGY

datum/unit_test/mob_damage/machine/tox
	name = "MOB: IPC Toxins Damage Check"
	damagetype = DAM_BIO
	expected_vulnerability = IMMUNE

datum/unit_test/mob_damage/machine/oxy
	name = "MOB: IPC Oxygen Damage Check"
	damagetype = DAM_OXY
	expected_vulnerability = IMMUNE

datum/unit_test/mob_damage/machine/clone
	name = "MOB: IPC Clone Damage Check"
	damagetype = DAM_CLONE
	expected_vulnerability = IMMUNE

datum/unit_test/mob_damage/machine/halloss
	name = "MOB: IPC Halloss Damage Check"
	damagetype = DAM_PAIN
	expected_vulnerability = IMMUNE

// =================================================================
// Phorosians
// =================================================================

datum/unit_test/mob_damage/phorosian
	name = "MOB: Phorosian damage check template"
	mob_type = /mob/living/carbon/human/machine

datum/unit_test/mob_damage/phorosian/brute
	name = "MOB: Phorosian Brute Damage Check"
	damagetype = DAM_BLUNT

datum/unit_test/mob_damage/phorosian/cut
	name = "MOB: Phorosian Cut damage check"
	damagetype = DAM_CUT

datum/unit_test/mob_damage/phorosian/pierce
	name = "MOB: Phorosian Pierce damage check"
	damagetype = DAM_PIERCE

datum/unit_test/mob_damage/phorosian/fire
	name = "MOB: Phorosian Fire Damage Check"
	damagetype = DAM_BURN

datum/unit_test/mob_damage/phorosian/laser
	name = "MOB: Phorosian Laser damage check"
	damagetype = DAM_LASER

datum/unit_test/mob_damage/phorosian/energy
	name = "MOB: Phorosian Energy damage check"
	damagetype = DAM_ENERGY

datum/unit_test/mob_damage/phorosian/tox
	name = "MOB: Phorosian Toxins Damage Check"
	damagetype = DAM_BIO
	expected_vulnerability = IMMUNE

datum/unit_test/mob_damage/phorosian/oxy
	name = "MOB: Phorosian Oxygen Damage Check"
	damagetype = DAM_OXY
	expected_vulnerability = IMMUNE

datum/unit_test/mob_damage/phorosian/clone
	name = "MOB: Phorosian Clone Damage Check"
	damagetype = DAM_CLONE
	expected_vulnerability = IMMUNE

datum/unit_test/mob_damage/phorosian/halloss
	name = "MOB: Phorosian Halloss Damage Check"
	damagetype = DAM_PAIN
	expected_vulnerability = IMMUNE


// ==============================================================================


datum/unit_test/robot_module_icons
	name = "MOB: Robot module icon check"
	var/icon_file = 'icons/mob/screen1_robot.dmi'

datum/unit_test/robot_module_icons/start_test()
	var/failed = 0
	if(!isicon(icon_file))
		fail("[icon_file] is not a valid icon file.")
		return 1

	var/list/valid_states = icon_states(icon_file)

	if(!valid_states.len)
		return 1

	for(var/i=1, i<=SSrobots.all_module_names.len, i++)
		var/modname = lowertext(SSrobots.all_module_names[i])
		var/bad_msg = "[ascii_red]--------------- [modname]"
		if(!(modname in valid_states))
			log_unit_test("[bad_msg] does not contain a valid icon state in [icon_file][ascii_reset]")
			failed=1

	if(failed)
		fail("Some icon states did not exist")
	else
		pass("All modules had valid icon states")

	return 1

#undef IMMUNE
#undef SUCCESS
#undef FAILURE

datum/unit_test/species_base_skin
	name = "MOB: Species base skin presence"
//	async = 1
	var/failcount = 0

datum/unit_test/species_base_skin/start_test()
	for(var/species_name in all_species)
		var/datum/species/S = all_species[species_name]
		if(S.base_skin_colours)
			if(!(S.appearance_flags & HAS_BASE_SKIN_COLOURS))
				log_unit_test("[S.name] has a skin colour list but no HAS_BASE_SKIN_COLOURS flag.")
				failcount++
				continue
			if(!(S.base_skin_colours.len >= 2))
				log_unit_test("[S.name] needs at least two items in the base_skin_colour list.")
				failcount++
				continue
			var/to_fail = FALSE
			for(var/tag in S.has_limbs)
				var/list/paths = S.has_limbs[tag]
				var/obj/item/organ/external/E = paths["path"]
				var/list/gender_test = list("")
				if(initial(E.limb_flags) & ORGAN_FLAG_GENDERED_ICON)
					gender_test = list("_m", "_f")
				var/icon_name = initial(E.icon_name)

				for(var/base in S.base_skin_colours)
					for(var/gen in gender_test)
						if(!("[icon_name][gen][S.base_skin_colours[base]]" in icon_states(S.icobase)))
							to_fail = TRUE
							log_debug("[S.name] has missing icon: [icon_name][gen][S.base_skin_colours[base]] for base [base] and limb tag [tag].")
			if(to_fail)
				log_unit_test("[S.name] is missing one or more base icons.")
				failcount++
				continue

		else if(S.appearance_flags & HAS_BASE_SKIN_COLOURS)
			log_unit_test("[S.name] has a HAS_BASE_SKIN_COLOURS flag but no skin colour list.")
			failcount++
			continue

	if(failcount)
		fail("[failcount] species had bad base skin colour.")
	else
		pass("All species had correct skin colour setups.")

	return 1	// return 1 to show we're done and don't want to recheck the result.


/datum/unit_test/mob_nullspace
	name = "MOB: Mob in nullspace shall not cause runtimes"
	var/list/test_subjects = list()
	async = 1

/datum/unit_test/mob_nullspace/start_test()
	// Simply create one of each species type in nullspace
	for(var/species_name in all_species)
		var/test_subject = new/mob/living/carbon/human(null, species_name)
		test_subjects += test_subject
	return TRUE

/datum/unit_test/mob_nullspace/check_result()
	for(var/ts in test_subjects)
		var/mob/living/carbon/human/H = ts
		if(H.life_tick < 10)
			return FALSE

	QDEL_NULL_LIST(test_subjects)

	// No failure state, we just rely on the general runtime check to fail the entire build for us
	pass("Mob nullspace test concluded.")
	return TRUE
/datum/unit_test/mob_organ_size
	name = "MOB: Internal organs fit inside external organs."

/datum/unit_test/mob_organ_size/start_test()
	var/failed = FALSE
	for(var/species_name in all_species)
		var/mob/living/carbon/human/H = new(null, species_name)
		for(var/obj/item/organ/external/E in H.organs)
			for(var/obj/item/organ/internal/I in E.internal_organs)
				if(I.w_class > E.cavity_max_w_class)
					failed = TRUE
					log_bad("Internal organ [I] inside external organ [E] on species [species_name] was too large to fit.")
	if(failed)
		fail("A mob had an internal organ too large for its external organ.")
	else
		pass("All mob organs fit.")
	return TRUE
