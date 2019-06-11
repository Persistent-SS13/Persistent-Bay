/obj/item/weapon/material/butterfly
	name = "butterfly knife"
	desc = "A basic metal blade concealed in a lightweight plasteel grip. Small enough when folded to fit in a pocket."
	icon_state = "butterflyknife"
	item_state = null
	sound_hit = null
	var/active = 0
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("patted", "tapped")
	force_divisor = 0.1 // 6 when wieldness with hardness 60 (steel)
	thrown_force_divisor = 0.2 // 4 when thrown with weight 20 (steel)
	damtype = DAM_CUT
	mass = 0.8

/obj/item/weapon/material/butterfly/update_force()
	if(active)
		sharpness = 1
		..() //Updates force.
		throwforce = max(3,force-3)
		sound_hit = 'sound/weapons/bladeslice.ogg'
		icon_state += "_open"
		w_class = ITEM_SIZE_NORMAL
		attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	else
		force = 3
		sharpness = 0
		sound_hit = initial(sound_hit)
		icon_state = initial(icon_state)
		w_class = initial(w_class)
		attack_verb = initial(attack_verb)

/obj/item/weapon/material/butterfly/switchblade
	name = "switchblade"
	desc = "A classic switchblade with gold engraving. Just holding it makes you feel like a gangster."
	icon_state = "switchblade"
	unbreakable = 1
	damtype = DAM_CUT
	mass = 0.5

/obj/item/weapon/material/butterfly/attack_self(mob/user)
	active = !active
	if(active)
		to_chat(user, "<span class='notice'>You flip out \the [src].</span>")
		playsound(user, 'sound/weapons/flipblade.ogg', 15, 1)
	else
		to_chat(user, "<span class='notice'>\The [src] can now be concealed.</span>")
	update_force()
	add_fingerprint(user)

//knives for stabbing and slashing and so on and so forth
/obj/item/weapon/material/knife //master obj
	name = "the concept of a knife"
	desc = "You call that a knife? This is a master item!"
	icon = 'icons/obj/knife.dmi'
	icon_state = "knife"
	item_state = "knife"
	force_divisor = 0.15 // 9 when wielded with hardness 60 (steel)
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	matter = list(MATERIAL_STEEL = 12000)
	origin_tech = list(TECH_MATERIAL = 1)
	unbreakable = TRUE
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	sharpness = 2
	damtype = DAM_CUT
	mass = 0.6

/obj/item/weapon/material/knife/attack(mob/living/carbon/M, mob/living/carbon/user, target_zone)
	if(!istype(M))
		return ..()

	if(user.a_intent != I_HELP)
		if(user.zone_sel.selecting == BP_EYES)
			if((MUTATION_CLUMSY in user.mutations) && prob(50))
				M = user
			return eyestab(M, user)

	return ..()

//table knives
/obj/item/weapon/material/knife/table
	name = "table knife"
	desc = "A simple table knife, used to cut up individual portions of food."
	icon_state = "table"
	default_material = MATERIAL_ALUMINIUM
	force_divisor = 0.1
	sharpness = 1
	attack_verb = list("prodded")
	applies_material_name = FALSE
	w_class = ITEM_SIZE_SMALL

/obj/item/weapon/material/knife/table/unathi
	name = "dueling knife"
	desc = "A length of leather-bound wood studded with razor-sharp teeth. How crude."
	icon_state = "unathiknife"
	default_material = MATERIAL_WOOD
	applies_material_colour = FALSE
	w_class = ITEM_SIZE_NORMAL

//kitchen knives
/obj/item/weapon/material/knife/kitchen
	name = "kitchen knife"
	icon = 'icons/obj/knife.dmi'
	icon_state = "kitchenknife"
	desc = "A general purpose chef's knife made by SpaceCook Incorporated. Guaranteed to stay sharp for years to come."
	applies_material_name = FALSE
	damtype = DAM_CUT
	mass = 0.6
	sharpness = 1
	force_divisor = 0.15 // 9 when wielded with hardness 60 (steel)

/obj/item/weapon/material/knife/kitchen/cleaver
	name = "butcher's cleaver"
	desc = "A heavy blade used to process food, especially animal carcasses."
	icon_state = "butch"
	force_divisor = 0.18
	attack_verb = list("cleaved", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/weapon/material/knife/kitchen/cleaver/bronze
	name = "master chef's cleaver"
	desc = "A heavy blade used to process food. This one is so fancy, it must be for a truly exceptional chef. There aren't any here, so what it's doing here is anyone's guess."
	default_material = MATERIAL_BRONZE
	force_divisor = 1 //25 with material bronze

//fighting knives
/obj/item/weapon/material/knife/combat
	name = "combat knife"
	desc = "A blade with a saw-like pattern on the reverse edge and a heavy handle."
	icon_state = "tacknife"
	force_divisor = 0.2

//random stuff
/obj/item/weapon/material/knife/hook
	name = "meat hook"
	desc = "A sharp, metal hook what sticks into things."
	icon_state = "hook_knife"
	item_state = "hook_knife"
	sharpness = 0

/obj/item/weapon/material/knife/ritual
	name = "ritual knife"
	desc = "A decorated ritual dagger."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "render"
	applies_material_colour = FALSE
	applies_material_name = FALSE
