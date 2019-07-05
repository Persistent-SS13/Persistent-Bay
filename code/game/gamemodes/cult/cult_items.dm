/obj/item/weapon/melee/cultblade
	name = "cult blade"
	desc = "An arcane weapon wielded by the followers of Nar-Sie."
	icon_state = "cultblade"
	item_state = "cultblade"
	sharpness = 1
	w_class = ITEM_SIZE_LARGE
	force = 30
	throwforce = 10
	sound_hit = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	damtype = DAM_CUT
	mass = 1.2

/obj/item/weapon/melee/cultblade/attack(mob/living/M, mob/living/user, var/target_zone)
	if(iscultist(user) || (user.mind in GLOB.godcult.current_antagonists))
		return ..()

	var/zone = (user.hand ? BP_L_ARM : BP_R_ARM)

	var/obj/item/organ/external/affecting = null
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		affecting = H.get_organ(zone)

	if(affecting)
		to_chat(user, "<span class='danger'>An unexplicable force rips through your [affecting.name], tearing the sword from your grasp!</span>")
	else
		to_chat(user, "<span class='danger'>An unexplicable force rips through you, tearing the sword from your grasp!</span>")

	//random amount of damage between half of the blade's force and the full force of the blade.
	user.apply_damage(rand(force/2, force), damtype, zone, 0, armor_pen = 100, used_weapon = src)
	user.Weaken(5)

	if(user.unEquip(src))
		throw_at(get_edge_target_turf(src, pick(GLOB.alldirs)), rand(1,3), throw_speed)

	var/spooky = pick('sound/hallucinations/growl1.ogg', 'sound/hallucinations/growl2.ogg', 'sound/hallucinations/growl3.ogg', 'sound/hallucinations/wail.ogg')
	playsound(loc, spooky, 50, 1)

	return 1

/obj/item/weapon/melee/cultblade/pickup(mob/living/user as mob)
	if(!iscultist(user))
		to_chat(user, "<span class='warning'>An overwhelming feeling of dread comes over you as you pick up the cultist's sword. It would be wise to be rid of this blade quickly.</span>")
		user.make_dizzy(120)


/obj/item/clothing/head/culthood
	name = "cult hood"
	icon_state = "culthood"
	desc = "A hood worn by the followers of Nar-Sie."
	flags_inv = HIDEFACE
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.8 //That's a pretty cool opening in the hood. Also: Cloth making physical contact to the skull.
	armor = list(DAM_BLUNT = 30, DAM_PIERCE = 10, DAM_CUT = 20, DAM_BULLET = 10, DAM_LASER = 5, DAM_ENERGY = 5, DAM_BURN = 5,
		DAM_BOMB = 0, DAM_EMP = 0, DAM_BIO = 0, DAM_RADS = 0, DAM_STUN = 0)

/obj/item/clothing/head/culthood/costume
	siemens_coefficient = 1.0
	armor  = list(DAM_BLUNT = 0, DAM_PIERCE = 0, DAM_CUT = 0, DAM_BULLET = 0, DAM_LASER = 0, DAM_ENERGY = 0, DAM_BURN = 0,
		DAM_BOMB = 0, DAM_EMP = 0, DAM_BIO = 0, DAM_RADS = 0, DAM_STUN = 0)

/obj/item/clothing/head/culthood/magus
	name = "magus helm"
	icon_state = "magus"
	desc = "A helm worn by the followers of Nar-Sie."
	flags_inv = HIDEFACE | BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	armor  = list(DAM_BLUNT = 50, DAM_PIERCE = 40, DAM_CUT = 50, DAM_BULLET = 40, DAM_LASER = 30, DAM_ENERGY = 20, DAM_BURN = 30,
		DAM_BOMB = 15, DAM_EMP = 0, DAM_BIO = 0, DAM_RADS = 0, DAM_STUN = 0)

/obj/item/clothing/head/culthood/magus/costume
	siemens_coefficient = 1.0
	armor  = list(DAM_BLUNT = 0, DAM_PIERCE = 0, DAM_CUT = 0, DAM_BULLET = 0, DAM_LASER = 0, DAM_ENERGY = 0, DAM_BURN = 0,
		DAM_BOMB = 0, DAM_EMP = 0, DAM_BIO = 0, DAM_RADS = 0, DAM_STUN = 0)

/obj/item/clothing/head/culthood/alt
	icon_state = "cult_hoodalt"

/obj/item/clothing/head/culthood/alt/costume
	siemens_coefficient = 1.0
	armor  = list(DAM_BLUNT = 0, DAM_PIERCE = 0, DAM_CUT = 0, DAM_BULLET = 0, DAM_LASER = 0, DAM_ENERGY = 0, DAM_BURN = 0,
		DAM_BOMB = 0, DAM_EMP = 0, DAM_BIO = 0, DAM_RADS = 0, DAM_STUN = 0)

/obj/item/clothing/suit/cultrobes
	name = "cult robes"
	desc = "A set of durable robes worn by the followers of Nar-Sie."
	icon_state = "cultrobes"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list(/obj/item/weapon/book/tome,/obj/item/weapon/melee/cultblade)
	flags_inv = HIDEJUMPSUIT
	siemens_coefficient = 0.6
	armor  = list(DAM_BLUNT = 35, DAM_PIERCE = 25, DAM_CUT = 25, DAM_BULLET = 30, DAM_LASER = 25, DAM_ENERGY = 20, DAM_BURN = 25,
		DAM_BOMB = 25, DAM_EMP = 0, DAM_BIO = 10, DAM_RADS = 0, DAM_STUN = 0)

/obj/item/clothing/suit/cultrobes/costume
	siemens_coefficient = 1.0
	armor  = list(DAM_BLUNT = 0, DAM_PIERCE = 0, DAM_CUT = 0, DAM_BULLET = 0, DAM_LASER = 0, DAM_ENERGY = 0, DAM_BURN = 0,
		DAM_BOMB = 0, DAM_EMP = 0, DAM_BIO = 0, DAM_RADS = 0, DAM_STUN = 0)

/obj/item/clothing/suit/cultrobes/alt
	icon_state = "cultrobesalt"

/obj/item/clothing/suit/cultrobes/alt/costume
	siemens_coefficient = 1.0
	armor  = list(DAM_BLUNT = 0, DAM_PIERCE = 0, DAM_CUT = 0, DAM_BULLET = 0, DAM_LASER = 0, DAM_ENERGY = 0, DAM_BURN = 0,
		DAM_BOMB = 0, DAM_EMP = 0, DAM_BIO = 0, DAM_RADS = 0, DAM_STUN = 0)

/obj/item/clothing/suit/cultrobes/magusred
	name = "magus robes"
	desc = "A set of plated robes worn by the followers of Nar-Sie."
	icon_state = "magusred"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	armor  = list(DAM_BLUNT = 75, DAM_PIERCE = 65, DAM_CUT = 75, DAM_BULLET = 50, DAM_LASER = 55, DAM_ENERGY = 40, DAM_BURN = 55,
		DAM_BOMB = 50, DAM_EMP = 0, DAM_BIO = 10, DAM_RADS = 0, DAM_STUN = 0)

/obj/item/clothing/suit/cultrobes/magusred/costume
	armor  = list(DAM_BLUNT = 0, DAM_PIERCE = 0, DAM_CUT = 0, DAM_BULLET = 0, DAM_LASER = 0, DAM_ENERGY = 0, DAM_BURN = 0,
		DAM_BOMB = 0, DAM_EMP = 0, DAM_BIO = 0, DAM_RADS = 0, DAM_STUN = 0)

/obj/item/clothing/suit/cultrobes/magusred/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 1

/obj/item/clothing/head/helmet/space/cult
	name = "cult helmet"
	desc = "A space worthy helmet used by the followers of Nar-Sie."
	icon_state = "cult_helmet"
	siemens_coefficient = 0.3 //Bone is not very conducive to electricity.
	armor  = list(DAM_BLUNT = 60, DAM_PIERCE = 50, DAM_CUT = 60, DAM_BULLET = 60, DAM_LASER = 60, DAM_ENERGY = 15, DAM_BURN = 60,
		DAM_BOMB = 30, DAM_EMP = 0, DAM_BIO = 100, DAM_RADS = 30, DAM_STUN = 0)

/obj/item/clothing/suit/space/cult
	name = "cult armour"
	icon_state = "cult_armour"
	desc = "A bulky suit of armour, bristling with spikes. It looks space proof."
	allowed = list(/obj/item/weapon/book/tome,/obj/item/weapon/melee/cultblade,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit)
	siemens_coefficient = 0.2
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS
	armor  = list(DAM_BLUNT = 60, DAM_PIERCE = 50, DAM_CUT = 60, DAM_BULLET = 50, DAM_LASER = 60, DAM_ENERGY = 15, DAM_BURN = 60,
		DAM_BOMB = 30, DAM_EMP = 0, DAM_BIO = 100, DAM_RADS = 30, DAM_STUN = 0)

/obj/item/clothing/suit/space/cult/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 1
