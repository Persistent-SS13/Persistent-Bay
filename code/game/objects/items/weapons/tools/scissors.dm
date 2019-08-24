//
// Scissors from UristMcStation code
// Modified a bit to fit in with PS13
//

//All of the scissor stuff <-- TGameCo
/obj/item/weapon/tool/scissors
	name = "Scissors"
	desc = "Those are scissors. Don't run with them!"
	icon = 'icons/obj/scissors.dmi'
	icon_state = "scissors"
	item_state = "scissors"
	force = 5
	matter = list(MATERIAL_STEEL = 35)
	sharpness = 2
	w_class = 2
	item_icons = list(slot_l_hand_str = 'icons/mob/items/lefthand_tools.dmi', slot_r_hand_str = 'icons/mob/items/righthand_tools.dmi')
	attack_verb = list("slices", "cuts", "stabs", "jabs")
	damtype = DAM_CUT
	mass = 0.200
	var/childpart = /obj/item/weapon/improvised/scissorknife //This is so any thing made is specified. It's helpful for things

/obj/item/weapon/tool/scissors/attackby(var/obj/item/I, mob/user as mob) //Seperation of the scissors
	if(isScrewdriver(I))
		var/obj/item/weapon/improvised/scissorknife/left_part = new childpart
		var/obj/item/weapon/improvised/scissorknife/right_part = new childpart

		// Craft scissors have unique left/right colors. To maintain this with the knives, I set the right part to have the icon of the right part
		if(istype(src, /obj/item/weapon/tool/scissors/craft))
			left_part.icon_state = "scissors_knife_craft_left"
			right_part.item_state = "scissors_knife_craft_right"
		else
			right_part.icon_state = "[right_part.icon_state]_right"

		user.remove_from_mob(src)
		user.drop_from_inventory(src)

		user.put_in_hands(left_part)
		user.put_in_hands(right_part)
		to_chat(user, SPAN_NOTICE("You seperate the parts of the [src]"))
		qdel(src)
		return 1
	else
		return ..()

/obj/item/weapon/tool/scissors/can_graffiti()
	return TRUE

// Barber scissors, used especially for cutting of hair
/obj/item/weapon/tool/scissors/barber
	name = "Barber's Scissors"
	desc = "A pair of scissors used by the barber."
	icon_state = "scissors_barber"
	item_state = "scissors_barber"
	attack_verb = list("beautifully slices", "artistically cuts", "smoothly stabs", "quickly jabs")
	childpart = /obj/item/weapon/improvised/scissorknife/barber
	var/list/ui_users = list()

/obj/item/weapon/tool/scissors/barber/attack_self(mob/user as mob)
	if(ishuman(user))
		cut_hair(user, user)

/obj/item/weapon/tool/scissors/barber/proc/cut_hair(var/mob/living/carbon/human/target, var/mob/user)
	if(!istype(target))
		return
	var/datum/nano_module/appearance_changer/AC = ui_users[user]
	if(!AC)
		AC = new(src, user)
		AC.name = "SalonPro AuthentiBarber;"
		AC.flags = APPEARANCE_HAIR
		ui_users[user] = AC
	AC.ui_interact(user)
	return TRUE

/obj/item/weapon/tool/scissors/barber/Destroy()
	for(var/user in ui_users)
		var/datum/nano_module/appearance_changer/AC = ui_users[user]
		qdel(AC)
	ui_users.Cut()
	..()

//Makes scissors cut hair, special thanks to Miauw and Xerux -Nien
/obj/item/weapon/tool/scissors/barber/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(user.a_intent != I_HELP || !ishuman(M) || !Adjacent(M))
		return ..()
	return cut_hair(M, user)


// This used to be standard office scissors, but I moved those down to the root scissors/
// Plastic Craft scissors, like those used by schoolchildren.
/obj/item/weapon/tool/scissors/craft 
	name = "Craft Scissors"
	desc = "A pair of scissors used for arts and crafts. It's probably safe to run with"
	icon_state = "scissors_craft"
	item_state = "scissors_craft"
	attack_verb = list("prods", "pokes", "nudges", "annoys")
	force = 1 // Use the scissors of a child, recieve the strength of a child
	matter = list(MATERIAL_PLASTIC = 100, MATERIAL_STEEL = 5)
	sharpness = 0 // It's a child's scissors, it's more likely to tear the paper than cut it
	childpart = /obj/item/weapon/improvised/scissorknife/craft

//
// ASSEMBLIES
//
/obj/item/weapon/improvised/scissorsassembly //So you can put it together!
	name = "Scissor Assembly"
	desc = "Two parts of a scissor loosely combined"
	icon = 'icons/obj/scissors.dmi'
	icon_state = "scissors"
	item_state = "scissors"
	matter = list(MATERIAL_STEEL = 35)
	force = 3
	sharpness = 1
	w_class = 2
	item_icons = list(slot_l_hand_str = 'icons/mob/items/lefthand_tools.dmi', slot_r_hand_str = 'icons/mob/items/righthand_tools.dmi')
	attack_verb = list("slices", "cuts", "stabs", "jabs")
	var/parentscissor = /obj/item/weapon/tool/scissors

/obj/item/weapon/improvised/scissorsassembly/barber
	icon_state = "scissors_barber"
	item_state = "scissors_barber"
	attack_verb = list("beautifully slices", "artistically cuts", "smoothly stabs", "quickly jabs")
	parentscissor = /obj/item/weapon/tool/scissors/barber

/obj/item/weapon/improvised/scissorsassembly/craft
	icon_state = "scissors_craft"
	item_state = "scissors_craft"
	matter = list(MATERIAL_PLASTIC = 50, MATERIAL_STEEL = 2)
	force = 1
	sharpness = 0
	attack_verb = list("prods", "pokes", "nudges", "annoys")
	parentscissor = /obj/item/weapon/tool/scissors/craft

/obj/item/weapon/improvised/scissorsassembly/attackby(var/obj/item/I, mob/user as mob) //Putting it together
	if(isScrewdriver(I))
		var/obj/item/weapon/tool/scissors/N = new parentscissor
		user.remove_from_mob(src)
		user.put_in_hands(N)
		to_chat(user, SPAN_NOTICE("You tighten the screw on the screwdriver assembley"))
		qdel(src)
		return 1
	else 
		return ..()

//
//Improvised weapons
//
//Half of a scissor... Ow

/obj/item/weapon/improvised/scissorknife
	name = "Knife"
	desc = "The seperated part of a scissor. Where's the other half?"
	icon = 'icons/obj/scissors.dmi'
	icon_state = "scissors_knife"
	item_state = "scissors" // Sure, it's the same icon as the whole one, but at that scale it doesn't matter too much
	force = 11
	throwforce = 10.0
	throw_speed = 4
	throw_range = 10
	attack_verb = list("sliced", "cut", "stabbed", "jabbed")
	sharpness = 1
	w_class = 2
	item_icons = list(slot_l_hand_str = 'icons/mob/items/lefthand_tools.dmi', slot_r_hand_str = 'icons/mob/items/righthand_tools.dmi')
	damtype = DAM_CUT
	mass = 0.100
	var/parentassembly = /obj/item/weapon/improvised/scissorsassembly

/obj/item/weapon/improvised/scissorknife/attackby(var/obj/item/I, mob/user as mob)
	if((istype(I, /obj/item/weapon/improvised/scissorknife) && istype(src, I))) //If they're both scissor knives
		var/obj/item/weapon/improvised/scissorsassembly/N = new src.parentassembly
		user.remove_from_mob(I)
		user.remove_from_mob(src)
		user.drop_from_inventory(I)
		user.drop_from_inventory(src)
		user.put_in_hands(N)
		to_chat(user, SPAN_NOTICE("You slide one knife into another, forming a loose pair of scissors"))
		qdel(I)
		qdel(src)
		return 1
	else 
		return ..()

/obj/item/weapon/improvised/scissorknife/barber
	desc = "The seperated part of a scissor. Where's the other half? This one is from barber's scissors"
	icon_state = "scissors_knife_barber"
	item_state = "scissors_barber" // Same reasoning as the main knife. Looks identical
	attack_verb = list("beautifully slices", "artistically cuts", "smoothly stabs", "quickly jabs")
	parentassembly = /obj/item/weapon/improvised/scissorsassembly/barber

/obj/item/weapon/improvised/scissorknife/craft
	name = "\"Knife\""
	desc = "The seperated part of a scissor. Where's the other half? This one is from children's craft scissors"
	icon_state = "scissors_knife_craft_left" //Left/Right is determined by the attackby proc in weapon/scissors
	item_state = "scissors_knife_craft_left" //This tiny scale does matter when it comes to color. The full assembly has two colors, a knife has one
	force = 0 // Totally harmless. It's pretty much just edgeless plastic garbage
	throwforce = 0
	attack_verb = list("pokes", "prods", "nudges", "annoys")
	sharpness = 0
	parentassembly = /obj/item/weapon/improvised/scissorsassembly/craft
