/obj/item/clothing/proc/describe_armor(var/armor_type, var/descriptive_attack_type)
	if(armor && armor.len && armor[armor_type])
		switch(armor[armor_type])
			if(1 to 20)
				return "It barely protects against [descriptive_attack_type]."
			if(21 to 30)
				return "It provides a very small defense against [descriptive_attack_type]."
			if(31 to 40)
				return "It offers a small amount of protection against [descriptive_attack_type]."
			if(41 to 50)
				return "It offers a moderate defense against [descriptive_attack_type]."
			if(51 to 60)
				return "It provides a strong defense against [descriptive_attack_type]."
			if(61 to 70)
				return "It is very strong against [descriptive_attack_type]."
			if(71 to 80)
				return "This gives a very robust defense against [descriptive_attack_type]."
			if(81 to 99)
				return "Wearing this would make you nigh-invulerable against [descriptive_attack_type]."
			if(100)
				return "You would be immune to [descriptive_attack_type] if you wore this."



/obj/item/clothing/get_description_info()
	. = list()
	. += description_info + "\
		<br>"
	if(armor && armor.len)
		if(armor[DAM_BLUNT])
			. += "[describe_armor(DAM_BLUNT,"blunt force")] \n"
		if(armor[DAM_CUT])
			. += "[describe_armor(DAM_CUT,"sharp objects")] \n"
		if(armor[DAM_PIERCE])
			. += "[describe_armor(DAM_PIERCE,"piercing damage")] \n"
		if(armor[DAM_BULLET])
			. += "[describe_armor(DAM_BULLET,"ballistics")] \n"
		if(armor[DAM_LASER])
			. += "[describe_armor(DAM_LASER,"lasers")] \n"
		if(armor[DAM_ENERGY])
			. += "[describe_armor(DAM_ENERGY,"energy")] \n"
		if(armor[DAM_EMP])
			. += "[describe_armor(DAM_EMP,"emps")] \n"
		if(armor[DAM_BURN])
			. += "[describe_armor(DAM_BURN,"burns")] \n"
		if(armor[DAM_BOMB])
			. += "[describe_armor(DAM_BOMB,"explosions")] \n"
		if(armor[DAM_BIO])
			. += "[describe_armor(DAM_BIO,"biohazards")] \n"
		if(armor[DAM_RADS])
			. += "[describe_armor(DAM_RADS,"radiation")] \n"
		. += "\n"

	if(item_flags & ITEM_FLAG_AIRTIGHT)
		. += "It is airtight. \n"

	if(item_flags & ITEM_FLAG_STOPPRESSUREDAMAGE)
		. += "Wearing this will protect you from the vacuum of space. \n"

	if(item_flags & ITEM_FLAG_THICKMATERIAL)
		. += "The material is exceptionally thick. \n"

	if(max_heat_protection_temperature == FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE)
		. += "It provides very good protection against fire and heat. \n"

	if(min_cold_protection_temperature == SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE)
		. += "It provides very good protection against very cold temperatures. \n"

	var/list/covers = list()
	var/list/slots = list()

	for(var/name in string_part_flags)
		if(body_parts_covered & string_part_flags[name])
			covers += name

	for(var/name in string_slot_flags)
		if(slot_flags & string_slot_flags[name])
			slots += name

	if(covers.len)
		. += "It covers the [english_list(covers)]. \n"

	if(slots.len)
		. += "It can be worn on your [english_list(slots)]. \n"

	return jointext(., null)
