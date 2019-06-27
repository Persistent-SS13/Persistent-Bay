/obj/item/weapon/storage/toolbox
	name = "toolbox"
	desc = "Bright red toolboxes like these are one of the most common sights in maintenance corridors on virtually every ship in the galaxy."
	icon = 'icons/obj/items/storage/toolboxes.dmi'
	icon_state = "red"
	item_state = "toolbox_red"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 5
	attack_cooldown = 21
	melee_accuracy_bonus = -15
	throwforce = 10
	throw_speed = 1
	throw_range = 7
	matter = list(MATERIAL_STEEL = 200)
	w_class = ITEM_SIZE_LARGE
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_LARGEBOX_STORAGE //enough to hold all starting contents
	origin_tech = list(TECH_COMBAT = 1)
	attack_verb = list("robusted")
	use_sound = 'sound/effects/storage/toolbox.ogg'

/obj/item/weapon/storage/toolbox/emergency
	name = "emergency toolbox"
	startswith = null

/obj/item/weapon/storage/toolbox/emergency/filled
	startswith = list(/obj/item/weapon/tool/crowbar/red, /obj/item/weapon/extinguisher/mini, /obj/item/device/radio)

/obj/item/weapon/storage/toolbox/emergency/filled/Initialize()
	. = ..()
	if(!map_storage_loaded)
		var/item = pick(list(/obj/item/device/flashlight, /obj/item/device/flashlight/flare,  /obj/item/device/flashlight/flare/glowstick/red))
		new item(src)

/obj/item/weapon/storage/toolbox/mechanical
	name = "mechanical toolbox"
	desc = "Bright blue toolboxes like these are one of the most common sights in maintenance corridors on virtually every ship in the galaxy."
	icon_state = "blue"
	item_state = "toolbox_blue"
	startswith = null

/obj/item/weapon/storage/toolbox/mechanical/filled
	startswith = list(/obj/item/weapon/tool/screwdriver, /obj/item/weapon/tool/wrench, /obj/item/weapon/tool/weldingtool, /obj/item/weapon/tool/crowbar, /obj/item/device/scanner/gas, /obj/item/weapon/tool/wirecutters)

/obj/item/weapon/storage/toolbox/electrical
	name = "electrical toolbox"
	desc = "Bright yellow toolboxes like these are one of the most common sights in maintenance corridors on virtually every ship in the galaxy."
	icon_state = "yellow"
	item_state = "toolbox_yellow"
	startswith = null

/obj/item/weapon/storage/toolbox/electrical/filled
	startswith = list(/obj/item/weapon/tool/screwdriver, /obj/item/weapon/tool/wirecutters, /obj/item/device/t_scanner, /obj/item/weapon/tool/crowbar)
/obj/item/weapon/storage/toolbox/electrical/filled/Initialize()
	. = ..()
	if(!map_storage_loaded)
		new /obj/item/stack/cable_coil/random(src,30)
		new /obj/item/stack/cable_coil/random(src,30)
		if(prob(5))
			new /obj/item/clothing/gloves/insulated(src)
		else
			new /obj/item/stack/cable_coil/random(src,30)

/obj/item/weapon/storage/toolbox/syndicate
	name = "black and red toolbox"
	desc = "A toolbox in black, with stylish red trim. This one feels particularly heavy, yet balanced."
	icon_state = "syndicate"
	item_state = "toolbox_syndi"
	origin_tech = list(TECH_COMBAT = 1, TECH_ILLEGAL = 1)
	attack_cooldown = 10
	startswith = null

/obj/item/weapon/storage/toolbox/syndicate/filled
	startswith = list(/obj/item/clothing/gloves/insulated, /obj/item/weapon/tool/screwdriver, /obj/item/weapon/tool/wrench, /obj/item/weapon/tool/weldingtool, /obj/item/weapon/tool/crowbar, /obj/item/weapon/tool/wirecutters, /obj/item/device/multitool)
