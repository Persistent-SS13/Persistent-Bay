//TORCH Nanotrasen Uniforms - DO NOT ADD NEW UNIFORMS TO UNIFORM.DMI - TORCH NANOTRASEN UNIFORMS GO IN NANOTRASEN.DMI

/obj/item/clothing/under/rank/guard
	desc = "A durable uniform worn by Nanotrasen corporate security."
	name = "\improper Nanotrasen security uniform"
	icon_state = "ntguard"
	item_state = "r_suit"
	worn_state = "ntguard"
	armor  = list(
		DAM_BLUNT 	= 10,
		DAM_PIERCE 	= 5,
		DAM_CUT 	= 10,
		DAM_BULLET 	= 0,
		DAM_LASER 	= 0,
		DAM_ENERGY 	= 2,
		DAM_BURN 	= 2,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)
	siemens_coefficient = 0.9
	item_icons = list(slot_w_uniform_str = 'icons/mob/nanotrasen.dmi')

/obj/item/clothing/under/rank/scientist
	name = "\improper Nanotrasen polo and pants"
	desc = "A fashionable polo and pair of trousers made from patented biohazard-resistant synthetic fabrics. The colors denote the wearer as a member of NanoTrasen."
	icon_state = "ntsmock"
	item_state = "w_suit"
	worn_state = "ntsmock"
	permeability_coefficient = 0.50
	armor  = list(
		DAM_BLUNT 	= 1,
		DAM_PIERCE 	= 1,
		DAM_CUT 	= 5,
		DAM_BULLET 	= 0,
		DAM_LASER 	= 0,
		DAM_ENERGY 	= 2,
		DAM_BURN 	= 2,
		DAM_BOMB 	= 10,
		DAM_EMP 	= 0,
		DAM_BIO 	= 10,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)
	item_icons = list(slot_w_uniform_str = 'icons/mob/nanotrasen.dmi')

/obj/item/clothing/under/rank/scientist/executive
	name = "\improper Nanotrasen executive polo and pants"
	desc = "A fashionable polo and pair of trousers made from expensive biohazard-resistant fabrics. The colors denote the wearer as a member of Nanotrasen's higher-ups."
	icon_state = "ntsmockexec"
	worn_state = "ntsmockexec"

/obj/item/clothing/under/rank/ntwork
	name = "\improper Nanotrasen coveralls"
	desc = "A pair of beige coveralls made out of a strong, canvas-like material. The coloring on the fringes denotes it as a Nanotrasen-branded suit, typically given to their more blue-collared employees."
	icon_state = "ntwork"
	item_state = "lb_suit"
	worn_state = "ntwork"
	armor  = list(
		DAM_BLUNT 	= 5,
		DAM_PIERCE 	= 5,
		DAM_CUT 	= 10,
		DAM_BULLET 	= 0,
		DAM_LASER 	= 0,
		DAM_ENERGY 	= 2,
		DAM_BURN 	= 2,
		DAM_BOMB 	= 0,
		DAM_EMP 	= 0,
		DAM_BIO 	= 0,
		DAM_RADS 	= 0,
		DAM_STUN 	= 0)
	item_icons = list(slot_w_uniform_str = 'icons/mob/nanotrasen.dmi')

/obj/item/clothing/under/rank/ntpilot
	name = "\improper Nanotrasen flightsuit"
	desc = "A sleek dark red Nanotrasen flightsuit. It proudly sports three different patches with the Nanotrasen logo on it, as well as several unnecessary looking flaps and pockets for effect."
	icon_state = "ntpilot"
	item_state = "r_suit"
	worn_state = "ntpilot"
	item_icons = list(slot_w_uniform_str = 'icons/mob/nanotrasen.dmi')

/obj/item/clothing/under/suit_jacket/nt
	name = "\improper Nanotrasen executive suit"
	desc = "A suit that Nanotrasen gives to its executives."
	icon_state = "ntsuit"
	item_state = "bl_suit"
	worn_state = "ntsuit"
	item_icons = list(slot_w_uniform_str = 'icons/mob/nanotrasen.dmi')
