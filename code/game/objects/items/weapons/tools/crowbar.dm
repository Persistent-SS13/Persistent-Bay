/*
 * Crowbar
 */
/obj/item/weapon/tool/crowbar
	name = "crowbar"
	desc = "A heavy crowbar of solid steel, good and solid in your hand."
	description_info = "Crowbars have countless uses: click on floor tiles to pry them loose. Use alongside a screwdriver to install or remove windows. Force open emergency shutters, or depowered airlocks. Open the panel of an unlocked APC. Pry a computer's circuit board free. And much more!"
	description_fluff = "As is the case with most standard-issue tools, crowbars are a simple and timeless design, the only difference being that advanced materials like plasteel have made them uncommonly tough."
	description_antag = "Need to bypass a bolted door? You can use a crowbar to pry the electronics out of an airlock, provided that it has no power and has been welded shut."
	icon = 'icons/obj/tools.dmi'
	icon_state = "crowbar"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	force = 7
	attack_cooldown = 2*DEFAULT_WEAPON_COOLDOWN
	melee_accuracy_bonus = -10
	throwforce = 7
	throw_range = 3
	item_state = "crowbar"
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 140)
	center_of_mass = "x=16;y=20"
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked")

/obj/item/weapon/tool/crowbar/red
	icon_state = "red_crowbar"
	item_state = "crowbar_red"

/obj/item/weapon/tool/crowbar/play_tool_sound()
	playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
