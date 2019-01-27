/obj/structure/closet/secure_closet/freezer/kitchen
	name = "kitchen cabinet"
	req_access = list()

/obj/structure/closet/secure_closet/freezer/kitchen/mining
	req_access = list()

/obj/structure/closet/secure_closet/freezer/meat
	name = "meat fridge"
	closet_appearance = null

/obj/structure/closet/secure_closet/freezer/fridge
	name = "refrigerator"
	icon = 'icons/obj/closets/fridge.dmi'
	closet_appearance = null

/obj/structure/closet/secure_closet/freezer/money
	name = "secure locker"
	req_access = list()
	icon = 'icons/obj/closets/fridge.dmi'
	closet_appearance = null

/obj/structure/closet/secure_closet/freezer/money/Initialize()
	. = ..()
	//let's make hold a substantial amount.
	if(!map_storage_loaded)
		var/created_size = 0
		for(var/i = 1 to 200) //sanity loop limit
			var/obj/item/cash_type = pick(3; /obj/item/weapon/spacecash/bundle/c1000, 4; /obj/item/weapon/spacecash/bundle/c500, 5; /obj/item/weapon/spacecash/bundle/c200)
			var/bundle_size = initial(cash_type.w_class) / 2
			if(created_size + bundle_size <= storage_capacity)
				created_size += bundle_size
				new cash_type(src)
			else
				break
