
/obj/item/weapon/material/twohanded/baseballbat
	name = "bat"
	desc = "HOME RUN!"
	icon_state = "metalbat0"
	base_icon = "metalbat"
	item_state = "metalbat"
	w_class = ITEM_SIZE_LARGE
	throwforce = 7
	attack_verb = list("smashed", "beaten", "slammed", "smacked", "struck", "battered", "bonked")
	sound_hit = 'sound/weapons/genhit3.ogg'
	default_material = MATERIAL_MAPLE
	force_divisor = 0.45          // 9 when wielded with weight 20 (steel)
	unwielded_force_divisor = 0.35 // 7 when unwielded based on above.
	attack_cooldown_modifier = 1
	melee_accuracy_bonus = -10

//Predefined materials go here.
/obj/item/weapon/material/twohanded/baseballbat/metal/New(var/newloc)
	..(newloc,MATERIAL_ALUMINIUM)

/obj/item/weapon/material/twohanded/baseballbat/uranium/New(var/newloc)
	..(newloc,MATERIAL_URANIUM)

/obj/item/weapon/material/twohanded/baseballbat/gold/New(var/newloc)
	..(newloc,MATERIAL_GOLD)

/obj/item/weapon/material/twohanded/baseballbat/platinum/New(var/newloc)
	..(newloc,MATERIAL_PLATINUM)

/obj/item/weapon/material/twohanded/baseballbat/diamond/New(var/newloc)
	..(newloc,MATERIAL_DIAMOND)
