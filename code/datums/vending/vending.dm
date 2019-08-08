/**
 *  Datum used to hold information about a product in a vending machine
 */

/datum/stored_items/vending_products
	item_name = "generic" // Display name for the product
	var/price = 0              // Price to buy one
	var/display_color = null   // Display color for vending machine listing
	var/category = VENDINGM_CAT_NORMAL  // VENDINGM_CAT_HIDDEN for contraband, VENDINGM_CAT_COIN for premium
	var/initial_name = "generic"	//When products are stored by name, instead of by type, this name will be what's compared

/datum/stored_items/vending_products/New(var/atom/storing_object, var/path, var/name = null, var/amount = 0, var/price = 0, var/color = null, var/category = VENDINGM_CAT_NORMAL)
	..()
	src.price = price
	src.display_color = color
	src.category = category
	src.initial_name = name
	ADD_SAVED_VAR(price)
	ADD_SAVED_VAR(display_color)
	ADD_SAVED_VAR(category)
	ADD_SAVED_VAR(initial_name)
