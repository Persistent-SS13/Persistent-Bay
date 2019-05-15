//Base class for wall-mounted dispensers
/obj/machinery/vending/wall/
	anchored = TRUE
	density = FALSE //It is wall-mounted, and thus, not dense. --Superxpdude

/obj/machinery/vending/wall/Initialize(mapload, d)
	. = ..()
	queue_icon_update()

/obj/machinery/vending/wall/update_icon()
	. = ..()
	switch(dir)
		if(NORTH)
			src.pixel_x = 0
			src.pixel_y = -30
		if(SOUTH)
			src.pixel_x = 0
			src.pixel_y = 30
		if(EAST)
			src.pixel_x = -30
			src.pixel_y = 0
		if(WEST)
			src.pixel_x = 30
			src.pixel_y = 0

/obj/machinery/vending/wall/med1
	name = "NanoMed"
	desc = "A wall-mounted version of the NanoMed."
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?"
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	icon_vend = "wallmed-vend"
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	products = list(
		/obj/item/stack/medical/bruise_pack = 3,
		/obj/item/stack/medical/ointment = 3,
		/obj/item/weapon/reagent_containers/pill/paracetamol = 4,
		/obj/item/weapon/storage/med_pouch/trauma,
		/obj/item/weapon/storage/med_pouch/burn,
		/obj/item/weapon/storage/med_pouch/oxyloss,
		/obj/item/weapon/storage/med_pouch/toxin
		)
	contraband = list(/obj/item/weapon/reagent_containers/syringe/antitoxin = 4,/obj/item/weapon/reagent_containers/syringe/antiviral = 4,/obj/item/weapon/reagent_containers/pill/tox = 1)

/obj/machinery/vending/wall/med2
	name = "NanoMed Mini"
	desc = "A wall-mounted version of the NanoMed, containing only vital first aid equipment."
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?"
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	icon_vend = "wallmed-vend"
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	products = list(
		/obj/item/weapon/reagent_containers/hypospray/autoinjector = 5,
		/obj/item/stack/medical/bruise_pack = 4,
		/obj/item/stack/medical/ointment = 4,
		/obj/item/weapon/storage/med_pouch/trauma,
		/obj/item/weapon/storage/med_pouch/burn,
		/obj/item/weapon/storage/med_pouch/oxyloss,
		/obj/item/weapon/storage/med_pouch/toxin,
		/obj/item/weapon/storage/med_pouch/radiation
		)
	contraband = list(/obj/item/weapon/reagent_containers/pill/tox = 3, /obj/item/weapon/reagent_containers/hypospray/autoinjector/pain = 2)
