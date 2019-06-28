//Outfits datum in use on the nexus map
/decl/hierarchy/outfit/nexus
	hierarchy_type = /decl/hierarchy/outfit/nexus
	flags = OUTFIT_EXTENDED_SURVIVAL | OUTFIT_HAS_BACKPACK
	backpack_contents = list( /obj/item/weapon/book/multipage/nexus_guide = 1 )

/decl/hierarchy/outfit/nexus/starter
	name = "Resident Gear"
	uniform = /obj/item/clothing/under/color/grey
	l_ear = /obj/item/device/radio/headset/nexus/starter
	shoes = /obj/item/clothing/shoes/black
	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/civilian/residents
	pda_type = null

/decl/hierarchy/outfit/nexus/citizen
	name = "Citizen Gear"
	uniform = /obj/item/clothing/under/color/grey
	l_ear = /obj/item/device/radio/headset/nexus/citizen
	shoes = /obj/item/clothing/shoes/black
	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/civilian/citizens
	pda_type = null

/decl/hierarchy/outfit/phorosian
	l_ear = /obj/item/device/radio/headset/nexus/citizen
	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/civilian/citizens
