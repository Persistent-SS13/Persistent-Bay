/* Utility Closets
 * Contains:
 *		Emergency Closet
 *		Fire Closet
 *		Tool Closet
 *		Radiation Closet
 *		Bombsuit Closet
 *		Hydrant
 *		First Aid
 *		Excavation Closet
 *		Shipping Supplies Closet
 */

/*
 * Emergency Closet
 */
/obj/structure/closet/emcloset
	name = "emergency closet"
	desc = "It's a storage unit for emergency breathmasks and o2 tanks."
	closet_appearance = /decl/closet_appearance/oxygen

/obj/structure/closet/emcloset/filled/New()
	..()

	switch (pickweight(list("small" = 50, "aid" = 25, "tank" = 10, "large" = 5, "both" = 10)))
		if ("small")
			new /obj/item/weapon/tank/emergency/oxygen(src)
			new /obj/item/weapon/tank/emergency/oxygen(src)
			new /obj/item/clothing/mask/breath(src)
			new /obj/item/clothing/mask/breath(src)
			new /obj/item/clothing/suit/space/emergency(src)
			new /obj/item/clothing/head/helmet/space/emergency(src)
		if ("aid")
			new /obj/item/weapon/tank/emergency/oxygen(src)
			new /obj/item/weapon/storage/toolbox/emergency(src)
			new /obj/item/clothing/mask/breath(src)
			new /obj/item/weapon/storage/firstaid/o2(src)
			new /obj/item/clothing/suit/space/emergency(src)
			new /obj/item/clothing/head/helmet/space/emergency(src)
		if ("tank")
			new /obj/item/weapon/tank/emergency/oxygen/engi(src)
			new /obj/item/weapon/tank/emergency/oxygen/engi(src)
			new /obj/item/clothing/mask/gas/half(src)
			new /obj/item/clothing/mask/gas/half(src)

		if ("large")
			new /obj/item/weapon/tank/emergency/oxygen/double(src)
			new /obj/item/weapon/tank/emergency/oxygen/double(src)
			new /obj/item/clothing/mask/gas(src)
			new /obj/item/clothing/mask/gas(src)
			new /obj/item/device/oxycandle(src)

		if ("both")
			new /obj/item/weapon/storage/toolbox/emergency(src)
			new /obj/item/weapon/tank/emergency/oxygen/engi(src)
			new /obj/item/weapon/tank/emergency/oxygen/engi(src)
			new /obj/item/clothing/mask/gas/half(src)
			new /obj/item/clothing/mask/gas/half(src)
			new /obj/item/weapon/storage/firstaid/o2(src)
			new /obj/item/clothing/suit/space/emergency(src)
			new /obj/item/clothing/suit/space/emergency(src)
			new /obj/item/clothing/head/helmet/space/emergency(src)
			new /obj/item/clothing/head/helmet/space/emergency(src)
			new /obj/item/device/oxycandle(src)

/obj/structure/closet/emcloset/legacy/New()
	..()
	new /obj/item/weapon/tank/oxygen(src)
	new /obj/item/clothing/mask/gas(src)

/*
 * Fire Closet
 */
/obj/structure/closet/firecloset
	name = "fire-safety closet"
	desc = "It's a storage unit for fire-fighting supplies."
	closet_appearance = /decl/closet_appearance/oxygen/fire


/obj/structure/closet/firecloset/filled/WillContain()
	return list(
		/obj/item/weapon/storage/med_pouch/burn,
		/obj/item/clothing/suit/fire/firefighter,
		/obj/item/clothing/mask/gas,
		/obj/item/device/flashlight,
		/obj/item/weapon/tank/oxygen/red,
		/obj/item/weapon/extinguisher,
		/obj/item/clothing/head/hardhat/red)

/*
 * Tool Closet
 */
/obj/structure/closet/toolcloset
	name = "tool closet"
	desc = "It's a storage unit for tools."
	closet_appearance = /decl/closet_appearance/secure_closet/engineering/tools

/obj/structure/closet/toolcloset/filled/New()
	..()
	if(prob(40))
		new /obj/item/clothing/suit/storage/hazardvest(src)
	if(prob(70))
		new /obj/item/device/flashlight(src)
	if(prob(70))
		new /obj/item/weapon/tool/screwdriver(src)
	if(prob(70))
		new /obj/item/weapon/tool/wrench(src)
	if(prob(70))
		new /obj/item/weapon/tool/weldingtool(src)
	if(prob(70))
		new /obj/item/weapon/tool/crowbar(src)
	if(prob(70))
		new /obj/item/weapon/tool/wirecutters(src)
	if(prob(70))
		new /obj/item/device/t_scanner(src)
	if(prob(20))
		new /obj/item/weapon/storage/belt/utility(src)
	if(prob(30))
		new /obj/item/stack/cable_coil/random(src)
	if(prob(30))
		new /obj/item/stack/cable_coil/random(src)
	if(prob(30))
		new /obj/item/stack/cable_coil/random(src)
	if(prob(20))
		new /obj/item/device/multitool(src)
	if(prob(5))
		new /obj/item/clothing/gloves/insulated(src)
	if(prob(40))
		new /obj/item/clothing/head/hardhat(src)


/*
 * Radiation Closet
 */
/obj/structure/closet/radiation
	name = "radiation suit closet"
	desc = "It's a storage unit for rad-protective suits."
	closet_appearance = /decl/closet_appearance/secure_closet/engineering/tools/radiation

/obj/structure/closet/radiation/filled/WillContain()
	return list(
		/obj/item/weapon/storage/med_pouch/toxin = 2,
		/obj/item/clothing/suit/radiation,
		/obj/item/clothing/head/radiation,
		/obj/item/clothing/suit/radiation,
		/obj/item/clothing/head/radiation,
		/obj/item/device/geiger = 2)

/*
 * Bombsuit closet
 */
/obj/structure/closet/bombcloset
	name = "\improper EOD closet"
	desc = "It's a storage unit for explosion-protective suits."
	closet_appearance = /decl/closet_appearance/bomb

/obj/structure/closet/bombcloset/filled/WillContain()
	return list(
		/obj/item/clothing/suit/bomb_suit,
		/obj/item/clothing/under/color/black,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/head/bomb_hood)


/obj/structure/closet/bombclosetsecurity
	name = "\improper EOD closet"
	desc = "It's a storage unit for explosion-protective suits."
	closet_appearance = /decl/closet_appearance/bomb/security

/obj/structure/closet/bombclosetsecurity/filled/WillContain()
	return list(
		/obj/item/clothing/suit/bomb_suit/security,
		/obj/item/clothing/under/rank/security,
		/obj/item/clothing/shoes/brown,
		/obj/item/clothing/head/bomb_hood/security)

/*
 * General purpose
 */
/obj/structure/closet/wall
	name = "wall closet"
	desc = "It's a wall-mounted storage unit."
	anchored = TRUE
	density = FALSE
	wall_mounted = TRUE
	storage_types = CLOSET_STORAGE_ITEMS
	closet_appearance = /decl/closet_appearance/wall

/obj/structure/closet/wall/New()
	..()
	pixel_x = (dir & 3)? 0 : (dir == 4 ? -30 : 30)
	pixel_y = (dir & 3)? (dir ==1 ? -30 : 30) : 0

/*
 * Hydrant
 */
/obj/structure/closet/wall/hydrant //wall mounted fire closet
	name = "fire-safety closet"
	desc = "It's a storage unit for fire-fighting supplies."
	closet_appearance = /decl/closet_appearance/wall/hydrant

/obj/structure/closet/wall/hydrant/filled/WillContain()
	return list(
		/obj/item/inflatable/door = 2,
		/obj/item/weapon/storage/med_pouch/burn = 2,
		/obj/item/clothing/suit/fire/firefighter,
		/obj/item/clothing/mask/gas/half,
		/obj/item/device/flashlight,
		/obj/item/weapon/tank/oxygen/red,
		/obj/item/weapon/extinguisher,
		/obj/item/clothing/head/hardhat/red)

/*
 * First Aid
 */
/obj/structure/closet/wall/medical //wall mounted medical closet
	name = "first-aid closet"
	desc = "It's a wall-mounted storage unit for first aid supplies."
	closet_appearance = /decl/closet_appearance/wall/medical

/obj/structure/closet/wall/medical/filled/WillContain()
	return list(
		/obj/random/firstaid,
		/obj/random/medical/lite = 12)

/*
 * Shipping
 */
/obj/structure/closet/wall/shipping
	name = "shipping supplies closet"
	desc = "It's a wall-mounted storage unit containing supplies for preparing shipments."
	closet_appearance = /decl/closet_appearance/wall/shipping

/obj/structure/closet/wall/shipping/filled/WillContain()
	return list(
		/obj/item/stack/material/cardboard/ten,
		/obj/item/device/destTagger,
		/obj/item/stack/package_wrap/twenty_five)
