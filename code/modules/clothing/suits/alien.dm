//Unathi clothing.

/obj/item/clothing/suit/unathi/robe
	name = "roughspun robes"
	desc = "A traditional Unathi garment."
	icon_state = "robe-unathi"
	item_state = "robe-unathi"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/clothing/suit/unathi/mantle
	name = "hide mantle"
	desc = "A rather grisly selection of cured hides and skin, sewn together to form a ragged mantle."
	icon_state = "mantle-unathi"
	item_state = "mantle-unathi"
	body_parts_covered = UPPER_TORSO

//Voxclothing

/obj/item/clothing/suit/armor/vox_scrap
	name = "rusted metal armor"
	desc = "A hodgepodge of various pieces of metal scrapped together into a rudimentary vox-shaped piece of armor."
	allowed = list(/obj/item/weapon/gun, /obj/item/weapon/tank)
	armor = list(melee = 70, bullet = 30, laser = 20,energy = 5, bomb = 40, bio = 0, rad = 0) //Higher melee armor versus lower everything else.
	icon_state = "vox-scrap"
	icon_state = "vox-scrap"
	body_parts_covered = UPPER_TORSO|ARMS|LOWER_TORSO|LEGS
	species_restricted = list(SPECIES_VOX)
	siemens_coefficient = 1 //Its literally metal
