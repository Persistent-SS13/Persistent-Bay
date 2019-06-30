/datum/stored_items
	var/item_name = "name"	//Name of the item(s) displayed
	var/item_path = null	// The original amount held
	var/amount = 0
	var/list/instances		//What items are actually stored
	var/atom/storing_object

/datum/stored_items/New(var/atom/storing_object, var/path, var/name = null, var/amount = 0)
	//Don't do this check, because on save load it breaks loaded things
	// if(!istype(storing_object))
	// 	CRASH("Unexpected storing object. [storing_object]\ref[storing_object] of type [storing_object ? storing_object.type : "null"]. path: [path], name: [name], amount: [amount]")
	src.storing_object = storing_object
	src.item_path = path
	src.amount = amount

	if(!name)
		var/atom/tmp = path
		src.item_name = initial(tmp.name)
	else
		src.item_name = name
	..()
	ADD_SAVED_VAR(item_name)
	ADD_SAVED_VAR(item_path)
	ADD_SAVED_VAR(amount)
	ADD_SAVED_VAR(instances)
	ADD_SAVED_VAR(storing_object)

/datum/stored_items/Destroy()
	storing_object = null
	if(instances)
		for(var/instance in instances)
			qdel(instance)
		instances = null
	. = ..()

/datum/stored_items/dd_SortValue()
	return item_name

/datum/stored_items/proc/get_amount()
	return instances ? instances.len : amount

/datum/stored_items/proc/add_product(var/atom/movable/product)
	if(product.type != item_path)
		return 0
	init_products()
	if(product in instances)
		return 0
	if(!storing_object)
		log_error("stored_items/add_product(): [src]\ref[src]'s Storing object is null!")
		return 0
	product.forceMove(storing_object)
	instances += product
	return 1

/datum/stored_items/proc/get_product(var/product_location)
	if(!get_amount() || !product_location)
		return
	init_products()

	var/atom/movable/product = instances[instances.len]	// Remove the last added product
	instances -= product
	product.forceMove(product_location)
	return product

/datum/stored_items/proc/get_specific_product(var/product_location, var/atom/movable/product)
	if(!get_amount() || !instances || !product_location || !product)
		return FALSE

	. = instances.Remove(product)
	if(.)
		product.forceMove(product_location)

/datum/stored_items/proc/init_products()
	if(instances)
		return
	instances = list()
	if(!storing_object)
		log_error("stored_items/add_product(): [src]\ref[src]'s Storing object is null!")
		return 0
	for(var/i = 1 to amount)
		var/new_product = new item_path(storing_object)
		instances += new_product
