/obj/structure/closet/secure_closet/scientist
	name = "scientist's locker"
	req_one_access = list(core_access_science_programs)
	closet_appearance = /decl/closet_appearance/secure_closet/expedition/science

/obj/structure/closet/secure_closet/scientist/filled/WillContain()
	return list(
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/messenger/tox, /obj/item/weapon/storage/backpack/satchel_tox)),
		/obj/item/clothing/under/rank/scientist,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/shoes/white,
		/obj/item/device/radio/headset/headset_sci,
		/obj/item/clothing/mask/gas,
		/obj/item/weapon/clipboard
	)

/obj/structure/closet/secure_closet/xenobio
	name = "xenobiologist's locker"
	req_access = list(core_access_science_programs)
	closet_appearance = /decl/closet_appearance/secure_closet/expedition/science


/obj/structure/closet/secure_closet/xenobio/filled/WillContain()
	return list(
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/messenger/tox, /obj/item/weapon/storage/backpack/satchel_tox)),
		/obj/item/clothing/under/rank/scientist,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/shoes/white,
		/obj/item/device/radio/headset/headset_sci,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/gloves/latex,
		/obj/item/weapon/clipboard
	)

/obj/structure/closet/secure_closet/RD
	name = "research director's locker"
	req_access = list(core_access_science_programs)
	closet_appearance = /decl/closet_appearance/secure_closet/rd

/obj/structure/closet/secure_closet/RD/filled/WillContain()
	return list(
		/obj/item/clothing/suit/bio_suit/scientist = 2,
		/obj/item/clothing/under/rank/research_director,
		/obj/item/clothing/under/rank/research_director/rdalt,
		/obj/item/clothing/under/rank/research_director/dress_rd,
		/obj/item/clothing/under/rank/scientist/executive,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/weapon/cartridge/rd,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/shoes/leather,
		/obj/item/clothing/gloves/latex,
		/obj/item/device/radio/headset/heads/rd,
		/obj/item/clothing/mask/gas,
		/obj/item/device/flash,
		/obj/item/weapon/clipboard,
		/obj/item/clothing/suit/storage/toggle/labcoat/rd
	)

/obj/structure/closet/secure_closet/animal
	name = "animal control closet"
	req_access = list(core_access_science_programs)

/obj/structure/closet/secure_closet/animal/filled/WillContain()
	return list(
		/obj/item/device/assembly/signaler,
		/obj/item/device/radio/electropack = 3,
		/obj/item/weapon/gun/launcher/syringe/rapid,
		/obj/item/weapon/storage/box/syringegun,
		/obj/item/weapon/storage/box/syringes,
		/obj/item/weapon/reagent_containers/glass/bottle/chloralhydrate,
		/obj/item/weapon/reagent_containers/glass/bottle/stoxin
	)
