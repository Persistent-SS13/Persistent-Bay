//Phorosian suits
/obj/item/clothing/suit/space/void/phorosian
	name = "Phorosian containment suit"
	icon = 'icons/obj/clothing/species/phorosian/suits.dmi'
	icon_state = "phorosiansuit"
	item_state = "phorosian_suit"
	w_class = ITEM_SIZE_HUGE//bulky item
	desc = "A special containment suit designed to protect a phorosians volatile body from outside exposure."
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 100, rad = 20)
	species_restricted = list(SPECIES_PHOROSIAN)
	sprite_sheets = list(
		"Phorosian" = 'icons/mob/species/phorosian/suit.dmi'
		)
	breach_threshold = 18
	can_breach = 1
	
	
/obj/item/clothing/head/helmet/space/void/phorosian
	name = "Phorosian helmet"
	desc = "A helmet made to connect with a Phorosian containment suit. Has a plasma-glass visor."
	icon = 'icons/obj/clothing/species/phorosian/hats.dmi'
	icon_state = "phorosian_helmet0"
	item_state = "phorosian_helmet0"
	heat_protection = HEAD
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 100, rad = 20)
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.4

	species_restricted = list(SPECIES_PHOROSIAN)
	light_overlay = "helmet_light"