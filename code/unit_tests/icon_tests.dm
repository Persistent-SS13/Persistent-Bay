/datum/unit_test/icon_test
	name = "ICON STATE template"

/datum/unit_test/icon_test/robots_shall_have_eyes_for_each_state
	name = "ICON STATE - Robot shall have eyes for each icon state"
	var/list/excepted_icon_states_ = list(
		"droid-combat-roll",
		"droid-combat-shield"
	)

/datum/unit_test/icon_test/robots_shall_have_eyes_for_each_state/start_test()
	var/missing_states = 0
	var/list/valid_states = icon_states('icons/mob/robots.dmi') + icon_states('icons/mob/robots_drones.dmi') + icon_states('icons/mob/robots_flying.dmi')

	var/list/original_valid_states = valid_states.Copy()
	for(var/icon_state in valid_states)
		if(icon_state in excepted_icon_states_)
			continue
		if(starts_with(icon_state, "eyes-"))
			continue
		if(findtext(icon_state, "openpanel"))
			continue
		var/eye_icon_state = "eyes-[icon_state]"
		if(!(eye_icon_state in valid_states))
			log_unit_test("Eye icon state [eye_icon_state] is missing.")
			missing_states++

	if(missing_states)
		fail("[missing_states] eye icon state\s [missing_states == 1 ? "is" : "are"] missing.")
		var/list/difference = uniquemergelist(original_valid_states, valid_states)
		if(difference.len)
			log_unit_test("[ascii_yellow]---  DEBUG  --- ICON STATES AT START: " + jointext(original_valid_states, ",") + "[ascii_reset]")
			log_unit_test("[ascii_yellow]---  DEBUG  --- ICON STATES AT END: "   + jointext(valid_states, ",") + "[ascii_reset]")
			log_unit_test("[ascii_yellow]---  DEBUG  --- UNIQUE TO EACH LIST: " + jointext(difference, ",") + "[ascii_reset]")
	else
		pass("All related eye icon states exists.")
	return 1

/datum/unit_test/icon_test/sprite_accessories_shall_have_existing_icon_states
	name = "ICON STATE - Sprite accessories shall have existing icon states"

/datum/unit_test/icon_test/sprite_accessories_shall_have_existing_icon_states/start_test()
	var/sprite_accessory_subtypes = list(
		/datum/sprite_accessory/hair,
		/datum/sprite_accessory/facial_hair
	)

	var/list/failed_sprite_accessories = list()
	var/icon_state_cache = list()
	var/duplicates_found = FALSE

	for(var/sprite_accessory_main_type in sprite_accessory_subtypes)
		var/sprite_accessories_by_name = list()
		for(var/sprite_accessory_type in subtypesof(sprite_accessory_main_type))
			var/failed = FALSE
			var/datum/sprite_accessory/sat = sprite_accessory_type

			var/sat_name = initial(sat.name)
			if(sat_name)
				group_by(sprite_accessories_by_name, sat_name, sat)
			else
				failed = TRUE
				log_bad("[sat] - Did not have a name set.")

			var/sat_icon = initial(sat.icon)
			if(sat_icon)
				var/sat_icon_states = icon_state_cache[sat_icon]
				if(!sat_icon_states)
					sat_icon_states = icon_states(sat_icon)
					icon_state_cache[sat_icon] = sat_icon_states

				var/sat_icon_state = initial(sat.icon_state)
				if(sat_icon_state)
					sat_icon_state = "[sat_icon_state]_s"
					if(!(sat_icon_state in sat_icon_states))
						failed = TRUE
						log_bad("[sat] - \"[sat_icon_state]\" did not exist in '[sat_icon]'.")
				else
					failed = TRUE
					log_bad("[sat] - Did not have an icon state set.")
			else
				failed = TRUE
				log_bad("[sat] - Did not have an icon set.")

			if(failed)
				failed_sprite_accessories += sat

		if(number_of_issues(sprite_accessories_by_name, "Sprite Accessory Names"))
			duplicates_found = TRUE

	if(failed_sprite_accessories.len || duplicates_found)
		fail("One or more sprite accessory issues detected.")
	else
		pass("All sprite accessories were valid.")

	return 1
