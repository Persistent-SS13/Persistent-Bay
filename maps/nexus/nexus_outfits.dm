//Outfits datum in use on the nexus map
/decl/hierarchy/outfit/nexus
	hierarchy_type = /decl/hierarchy/outfit/nexus
	flags = OUTFIT_EXTENDED_SURVIVAL | OUTFIT_HAS_BACKPACK

/decl/hierarchy/outfit/nexus/starter
	name = "Starter Gear"
	uniform = /obj/item/clothing/under/color/orange
	l_ear = /obj/item/device/radio/headset/nexus/starter
	shoes = /obj/item/clothing/shoes/black
	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/guest
	backpack_contents = list()

/decl/hierarchy/outfit/nexus/citizen
	name = "Citizen Gear"
	uniform = /obj/item/clothing/under/color/green
	l_ear = /obj/item/device/radio/headset/nexus/citizen
	shoes = /obj/item/clothing/shoes/black
	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/civilian
	backpack_contents = list()