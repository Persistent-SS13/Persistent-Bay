//Outfits datum in use on the sycorax map
/decl/hierarchy/outfit/sycorax
	hierarchy_type = /decl/hierarchy/outfit/sycorax
	flags = OUTFIT_EXTENDED_SURVIVAL | OUTFIT_HAS_BACKPACK
	backpack_contents = list( /obj/item/weapon/book/multipage/sycorax_guide = 1 )

/decl/hierarchy/outfit/sycorax/starter
	name = "Resident Gear"
	uniform = /obj/item/clothing/under/color/grey
	l_ear = /obj/item/device/radio/headset/sycorax/starter
	shoes = /obj/item/clothing/shoes/black
	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/civilian/residents
	pda_type = null

/decl/hierarchy/outfit/sycorax/citizen
	name = "Citizen Gear"
	uniform = /obj/item/clothing/under/color/grey
	l_ear = /obj/item/device/radio/headset/sycorax/citizen
	shoes = /obj/item/clothing/shoes/black
	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/civilian/citizens
	pda_type = null

/decl/hierarchy/outfit/phorosian
	l_ear = /obj/item/device/radio/headset/sycorax/citizen
	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/civilian/citizens
