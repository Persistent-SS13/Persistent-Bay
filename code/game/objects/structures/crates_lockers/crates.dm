/obj/structure/closet/crate
	name = "crate"
	desc = "A rectangular steel crate."
	atom_flags = ATOM_FLAG_CLIMBABLE
	closet_appearance = /decl/closet_appearance/crate
	setup = 0
	storage_types = CLOSET_STORAGE_ITEMS
	mass = 12
	max_health = 200
	damthreshold_brute 	= 10
	armor = list(
		DAM_BLUNT  	= 80,
		DAM_PIERCE 	= 90,
		DAM_CUT 	= 90,
		DAM_BULLET 	= 50,
		DAM_ENERGY 	= 50,
		DAM_BURN 	= 30,
		DAM_BOMB 	= 15,
		DAM_EMP 	= 0,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)

	var/points_per_crate = 5
	var/rigged = 0

/obj/structure/closet/crate/open()
	if((atom_flags & ATOM_FLAG_OPEN_CONTAINER) && !opened && can_open())
		object_shaken()
	. = ..()
	if(.)
		if(rigged)
			visible_message("<span class='danger'>There are wires attached to the lid of [src]...</span>")
			for(var/obj/item/device/assembly_holder/H in src)
				H.process_activation(usr)
			for(var/obj/item/device/assembly/A in src)
				A.activate()

/obj/structure/closet/crate/examine(mob/user)
	..()
	if(rigged && opened)
		var/list/devices = list()
		for(var/obj/item/device/assembly_holder/H in src)
			devices += H
		for(var/obj/item/device/assembly/A in src)
			devices += A
		to_chat(user,"There are some wires attached to the lid, connected to [english_list(devices)].")

/obj/structure/closet/crate/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(opened)
		return ..()
	else if(istype(W, /obj/item/weapon/packageWrap))
		return
	else if(istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = W
		if(rigged)
			to_chat(user, "<span class='notice'>[src] is already rigged!</span>")
			return
		if (C.use(1))
			to_chat(user, "<span class='notice'>You rig [src].</span>")
			rigged = 1
			return
	else if(istype(W, /obj/item/device/assembly_holder) || istype(W, /obj/item/device/assembly))
		if(rigged)
			to_chat(user, "<span class='notice'>You attach [W] to [src].</span>")
			user.drop_item()
			W.forceMove(src)
			return
	else if(isWirecutter(W))
		if(rigged)
			to_chat(user, "<span class='notice'>You cut away the wiring.</span>")
			playsound(loc, 'sound/items/Wirecutter.ogg', 100, 1)
			rigged = 0
			return
	else
		return ..()

/obj/structure/closet/crate/secure
	desc = "A secure crate."
	name = "Secure crate"
	closet_appearance = /decl/closet_appearance/crate/secure
	mass = 17
	max_health = 400
	damthreshold_brute 	= 10
	armor = list(
		DAM_BLUNT  	= MaxArmorValue,
		DAM_PIERCE 	= MaxArmorValue,
		DAM_CUT 	= MaxArmorValue,
		DAM_BULLET 	= 90,
		DAM_ENERGY 	= 90,
		DAM_BURN 	= 90,
		DAM_BOMB 	= 80,
		DAM_EMP 	= 80,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)

	setup = CLOSET_HAS_LOCK
	locked = TRUE

/obj/structure/closet/crate/secure/Initialize()
	. = ..()
	update_icon()

/obj/structure/closet/crate/plastic
	name = "plastic crate"
	desc = "A rectangular plastic crate."
	points_per_crate = 1
	closet_appearance = /decl/closet_appearance/crate/plastic
	mass = 8
	max_health = 120
	damthreshold_brute 	= 5
	armor = list(
		DAM_BLUNT  	= 20,
		DAM_PIERCE 	= 10,
		DAM_CUT 	= 20,
		DAM_BULLET 	= 0,
		DAM_ENERGY 	= 0,
		DAM_BURN 	= 0,
		DAM_BOMB 	= 0,
		DAM_EMP 	= MaxArmorValue,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)

/obj/structure/closet/crate/internals
	name = "internals crate"
	desc = "A internals crate."

/obj/structure/closet/crate/trashcart
	name = "trash cart"
	desc = "A heavy, metal trashcart with wheels."
	closet_appearance = /decl/closet_appearance/cart/trash
	mass = 25
	max_health = 450
	damthreshold_brute 	= 5
	armor = list(
		DAM_BLUNT  	= 30,
		DAM_PIERCE 	= 20,
		DAM_CUT 	= 30,
		DAM_BULLET 	= 0,
		DAM_ENERGY 	= 0,
		DAM_BURN 	= 0,
		DAM_BOMB 	= 0,
		DAM_EMP 	= MaxArmorValue,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)

/obj/structure/closet/crate/medical
	name = "medical crate"
	desc = "A medical crate."
	closet_appearance = /decl/closet_appearance/crate/medical

/obj/structure/closet/crate/rcd
	name = "\improper RCD crate"
	desc = "A crate with rapid construction device."

/obj/structure/closet/crate/rcd/WillContain()
	return list(
		/obj/item/weapon/rcd_ammo = 3,
		/obj/item/weapon/rcd
	)

/obj/structure/closet/crate/solar
	name = "solar pack crate"

/obj/structure/closet/crate/solar/WillContain()
	return list(
		/obj/item/solar_assembly = 14,
		/obj/item/weapon/circuitboard/solar_control,
		/obj/item/weapon/tracker_electronics,
		/obj/item/weapon/paper/solar
	)

/obj/structure/closet/crate/solar_assembly
	name = "solar assembly crate"

/obj/structure/closet/crate/solar_assembly/WillContain()
	return list(/obj/item/solar_assembly = 16)

/obj/structure/closet/crate/freezer
	name = "freezer"
	desc = "A freezer."
	closet_appearance = /decl/closet_appearance/crate/freezer

/obj/structure/closet/crate/freezer/rations //Fpr use in the escape shuttle
	name = "emergency rations"
	desc = "A crate of emergency rations."

/obj/structure/closet/crate/freezer/rations/WillContain()
	return list(/obj/item/weapon/reagent_containers/food/snacks/liquidfood = 4)

/obj/structure/closet/crate/bin
	name = "large bin"
	desc = "A large bin."
	icon_state = "largebin"
	icon_opened = "largebinopen"
	icon_closed = "largebin"
	mass = 8
	max_health = 120
	damthreshold_brute 	= 5
	armor = list(
		DAM_BLUNT  	= 20,
		DAM_PIERCE 	= 10,
		DAM_CUT 	= 20,
		DAM_BULLET 	= 0,
		DAM_ENERGY 	= 0,
		DAM_BURN 	= 0,
		DAM_BOMB 	= 0,
		DAM_EMP 	= MaxArmorValue,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)

/obj/structure/closet/crate/radiation
	name = "radioactive crate"
	desc = "A leadlined crate with a radiation sign on it."
	closet_appearance = /decl/closet_appearance/crate/radiation
	mass = 25
	max_health = 250
	damthreshold_brute 	= 10
	armor = list(
		DAM_BLUNT  	= 50,
		DAM_PIERCE 	= 50,
		DAM_CUT 	= 60,
		DAM_BULLET 	= 30,
		DAM_ENERGY 	= 30,
		DAM_BURN 	= 20,
		DAM_BOMB 	= 30,
		DAM_EMP 	= MaxArmorValue,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)

/obj/structure/closet/crate/radiation_gear
	name = "radioactive gear crate"
	desc = "A crate with a radiation sign on it."
	closet_appearance = /decl/closet_appearance/crate/radiation

/obj/structure/closet/crate/radiation_gear/WillContain()
	return list(/obj/item/clothing/suit/radiation = 8)

/obj/structure/closet/crate/secure/weapon
	name = "weapons crate"
	desc = "A secure weapons crate."
	closet_appearance = /decl/closet_appearance/crate/secure/weapon

/obj/structure/closet/crate/secure/phoron
	name = "phoron crate"
	desc = "A secure phoron crate."
	closet_appearance = /decl/closet_appearance/crate/secure/hazard

/obj/structure/closet/crate/secure/gear
	name = "gear crate"
	desc = "A secure gear crate."
	closet_appearance = /decl/closet_appearance/crate/secure/weapon

/obj/structure/closet/crate/secure/hydrosec
	name = "secure hydroponics crate"
	desc = "A crate with a lock on it, painted in the scheme of botany and botanists."
	closet_appearance = /decl/closet_appearance/crate/secure/hydroponics

/obj/structure/closet/crate/secure/bin
	name = "secure bin"
	desc = "A secure bin."
	icon_state = "largebins"
	icon_opened = "largebinsopen"
	icon_closed = "largebins"
	redlight = "largebinr"
	greenlight = "largebing"
	sparks = "largebinsparks"
	emag = "largebinemag"
	mass = 10
	max_health = 200
	damthreshold_brute 	= 10
	armor = list(
		DAM_BLUNT  	= 50,
		DAM_PIERCE 	= 50,
		DAM_CUT 	= 60,
		DAM_BULLET 	= 30,
		DAM_ENERGY 	= 30,
		DAM_BURN 	= 20,
		DAM_BOMB 	= 30,
		DAM_EMP 	= MaxArmorValue,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)

/obj/structure/closet/crate/large
	name = "large crate"
	desc = "A hefty metal crate."
	storage_capacity = 2 * MOB_LARGE
	storage_types = CLOSET_STORAGE_ITEMS|CLOSET_STORAGE_STRUCTURES
	closet_appearance = /decl/closet_appearance/large_crate
	mass = 20
	max_health = 300
	damthreshold_brute 	= 5
	armor = list(
		DAM_BLUNT  	= 20,
		DAM_PIERCE 	= 20,
		DAM_CUT 	= 30,
		DAM_BULLET 	= 5,
		DAM_ENERGY 	= 5,
		DAM_BURN 	= 5,
		DAM_BOMB 	= 0,
		DAM_EMP 	= MaxArmorValue,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)

/obj/structure/closet/crate/large/hydroponics
	closet_appearance = /decl/closet_appearance/large_crate/hydroponics

/obj/structure/closet/crate/secure/large
	name = "large crate"
	desc = "A hefty metal crate with an electronic locking system."
	closet_appearance = /decl/closet_appearance/large_crate/secure

	storage_capacity = 2 * MOB_LARGE
	storage_types = CLOSET_STORAGE_ITEMS|CLOSET_STORAGE_STRUCTURES
	mass = 30
	max_health = 500
	damthreshold_brute 	= 10
	armor = list(
		DAM_BLUNT  	= 60,
		DAM_PIERCE 	= 60,
		DAM_CUT 	= 70,
		DAM_BULLET 	= 50,
		DAM_ENERGY 	= 40,
		DAM_BURN 	= 30,
		DAM_BOMB 	= 40,
		DAM_EMP 	= MaxArmorValue,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)

/obj/structure/closet/crate/secure/large/phoron
	closet_appearance = /decl/closet_appearance/large_crate/secure/hazard

//fluff variant
/obj/structure/closet/crate/secure/large/reinforced
	desc = "A hefty, reinforced metal crate with an electronic locking system."
	icon_state = "largermetal"
	icon_opened = "largermetalopen"
	icon_closed = "largermetal"
	mass = 40
	max_health = 700
	damthreshold_brute 	= 15
	armor = list(
		DAM_BLUNT  	= MaxArmorValue,
		DAM_PIERCE 	= MaxArmorValue,
		DAM_CUT 	= MaxArmorValue,
		DAM_BULLET 	= MaxArmorValue,
		DAM_ENERGY 	= 90,
		DAM_BURN 	= 90,
		DAM_BOMB 	= 80,
		DAM_EMP 	= MaxArmorValue,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)

/obj/structure/closet/crate/secure/large/reinforced/slice_into_parts(obj/item/weapon/weldingtool/WT, mob/user)
	if(!WT.remove_fuel(0,user))
		to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
		return
	new /obj/item/stack/material/plasteel(src.loc)	//Made of plasteel, will return only 1 sheet
	user.visible_message("<span class='notice'>\The [src] has been cut apart by [user] with \the [WT].</span>", \
						 "<span class='notice'>You have cut \the [src] apart with \the [WT].</span>", \
						 "You hear welding.")
	qdel(src)

/obj/structure/closet/crate/hydroponics
	name = "hydroponics crate"
	desc = "All you need to destroy those pesky weeds and pests."
	closet_appearance = /decl/closet_appearance/crate/hydroponics

/obj/structure/closet/crate/hydroponics/prespawned/WillContain()
	return list(
		/obj/item/weapon/reagent_containers/spray/plantbgone = 2,
		/obj/item/weapon/material/minihoe = 2,
		/obj/item/weapon/storage/plants = 2,
		/obj/item/weapon/material/hatchet = 2,
		/obj/item/weapon/wirecutters/clippers = 2,
		/obj/item/device/analyzer/plant_analyzer = 2
	)

/obj/structure/closet/crate/secure/biohazard
	name = "biohazard cart"
	desc = "A heavy cart with extensive sealing. You shouldn't eat things you find in it."
	open_sound = 'sound/items/Deconstruct.ogg'
	close_sound = 'sound/items/Deconstruct.ogg'
	req_access = list(core_access_science_programs)
	closet_appearance = /decl/closet_appearance/cart/biohazard
	storage_capacity = 2 * MOB_LARGE
	storage_types = CLOSET_STORAGE_ITEMS|CLOSET_STORAGE_MOBS|CLOSET_STORAGE_STRUCTURES

/obj/structure/closet/crate/secure/biohazard/blanks/WillContain()
	return list(/mob/living/carbon/human/blank, /obj/item/usedcryobag)

/obj/structure/closet/crate/paper_refill
	name = "paper refill crate"
	desc = "A rectangular plastic crate, filled up with blank papers for refilling bins and printers. A bureaucrat's favorite."

/obj/structure/closet/crate/paper_refill/WillContain()
	return list(/obj/item/weapon/paper = 30)

/obj/structure/closet/crate/uranium
	name = "fissibles crate"
	desc = "A crate with a radiation sign on it."
	closet_appearance = /decl/closet_appearance/crate/radiation

/obj/structure/closet/crate/uranium/WillContain()
	return list(/obj/item/stack/material/uranium/ten = 5)
