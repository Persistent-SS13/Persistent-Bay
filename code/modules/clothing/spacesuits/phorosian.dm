//Phorosian suits
/obj/item/clothing/suit/space/void/phorosian
	name = "Phorosian containment suit"
	icon_state = "phorosian_suit"
	item_state = "phorosian_suit"
	w_class = ITEM_SIZE_HUGE//bulky item
	desc = "A special containment suit designed to protect a phorosian's volatile body from outside exposure."
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 100, rad = 20)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit)
	heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.4

	species_restricted = list(SPECIES_PHOROSIAN)
	breach_threshold = 18
	can_breach = 1
	
	var/obj/item/clothing/shoes/magboots/boots = null // Deployable boots, if any.
	var/obj/item/clothing/head/helmet/helmet = null   // Deployable helmet, if any.
	var/obj/item/weapon/tank/tank = /obj/item/weapon/tank/phoron/phorosian  // Deployable tank, if any.
	
	