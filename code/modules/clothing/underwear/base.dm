/obj/item/underwear
	icon = 'icons/mob/human.dmi' //Default icon file
	w_class = ITEM_SIZE_TINY
	var/required_slot_flags
	var/required_free_body_parts

/obj/item/underwear/New()
	. = ..()
	//Because the underwears are by default all a single item, we gotta save these
	ADD_SAVED_VAR(name)
	ADD_SAVED_VAR(gender)
	ADD_SAVED_VAR(color)
	ADD_SAVED_VAR(icon)
	ADD_SAVED_VAR(icon_state)

/obj/item/underwear/Initialize()
	. = ..()
	if(!icon_state)
		log_debug("[src](\ref[src])([x],[y],[z]) was deleted, because it had no sprite.")
		return INITIALIZE_HINT_QDEL //Lets avoid having bugged out underwears everywhere

/obj/item/underwear/afterattack(var/atom/target, var/mob/user, var/proximity)
	if(!proximity)
		return // Might as well check
	DelayedEquipUnderwear(user, target)

/obj/item/underwear/MouseDrop(var/atom/target)
	DelayedEquipUnderwear(usr, target)

/obj/item/underwear/proc/CanEquipUnderwear(var/mob/user, var/mob/living/carbon/human/H)
	if(!CanAdjustUnderwear(user, H, "put on"))
		return FALSE
	if(!(H.species && (H.species.appearance_flags & HAS_UNDERWEAR)))
		to_chat(user, "<span class='warning'>\The [H]'s species cannot wear underwear of this nature.</span>")
		return FALSE
	if(is_path_in_list(type, H.worn_underwear))
		to_chat(user, "<span class='warning'>\The [H] is already wearing underwear of this nature.</span>")
		return FALSE
	return TRUE

/obj/item/underwear/proc/CanRemoveUnderwear(var/mob/user, var/mob/living/carbon/human/H)
	if(!CanAdjustUnderwear(user, H, "remove"))
		return FALSE
	if(!(src in H.worn_underwear))
		to_chat(user, "<span class='warning'>\The [H] isn't wearing \the [src].</span>")
		return FALSE
	return TRUE

/obj/item/underwear/proc/CanAdjustUnderwear(var/mob/user, var/mob/living/carbon/human/H, var/adjustment_verb)
	if(!istype(H))
		return FALSE
	if(user != H && !CanPhysicallyInteractWith(user, H))
		return FALSE

	var/list/covering_items = H.get_covering_equipped_items(required_free_body_parts)
	if(covering_items.len)
		var/obj/item/I = covering_items[1]
		var/datum/gender/G = gender_datums[I.gender]
		if(adjustment_verb)
			to_chat(user, "<span class='warning'>Cannot [adjustment_verb] \the [src]. [english_list(covering_items)] [covering_items.len == 1 ? G.is : "are"] in the way.</span>")
		return FALSE

	return TRUE

/obj/item/underwear/proc/DelayedRemoveUnderwear(var/mob/user, var/mob/living/carbon/human/H)
	if(!CanRemoveUnderwear(user, H))
		return
	if(user != H)
		visible_message("<span class='danger'>\The [user] is trying to remove \the [H]'s [name]!</span>")
		if(!do_after(user, HUMAN_STRIP_DELAY, H, progress = 0))
			return FALSE
	. = RemoveUnderwear(user, H)
	if(. && user != H)
		user.visible_message("<span class='warning'>\The [user] has removed \the [src] from \the [H].</span>", "<span class='notice'>You have removed \the [src] from \the [H].</span>")
		admin_attack_log(user, H, "Removed \a [src]", "Had \a [src] removed.", "removed \a [src] from")

/obj/item/underwear/proc/DelayedEquipUnderwear(var/mob/user, var/mob/living/carbon/human/H)
	if(!CanEquipUnderwear(user, H))
		return
	if(user != H)
		user.visible_message("<span class='warning'>\The [user] has begun putting on \a [src] on \the [H].</span>", "<span class='notice'>You begin putting on \the [src] on \the [H].</span>")
		if(!do_after(user, HUMAN_STRIP_DELAY, H, progress = FALSE))
			return FALSE
	. = EquipUnderwear(user, H)
	if(. && user != H)
		user.visible_message("<span class='warning'>\The [user] has put \the [src] on \the [H].</span>", "<span class='notice'>You have put \the [src] on \the [H].</span>")
		admin_attack_log(user, H, "Put on \a [src]", "Had \a [src] put on.", "put on \a [src] on")

/obj/item/underwear/proc/EquipUnderwear(var/mob/user, var/mob/living/carbon/human/H)
	if(!CanEquipUnderwear(user, H))
		return FALSE
	if(!user.unEquip(src))
		return FALSE
	return ForceEquipUnderwear(H)

/obj/item/underwear/proc/ForceEquipUnderwear(var/mob/living/carbon/human/H, var/update_icons = TRUE)
	// No matter how forceful, we still don't allow multiples of the same underwear type
	if(is_path_in_list(type, H.worn_underwear))
		return FALSE

	H.worn_underwear += src
	forceMove(H)
	if(update_icons)
		H.update_underwear()

	return TRUE

/obj/item/underwear/proc/RemoveUnderwear(var/mob/user, var/mob/living/carbon/human/H)
	if(!CanRemoveUnderwear(user, H))
		return FALSE

	H.worn_underwear -= src
	dropInto(H.loc)
	user.put_in_hands(src)
	H.update_underwear()

	return TRUE

/obj/item/underwear/verb/RemoveSocks()
	set name = "Remove Underwear"
	set category = "Object"
	set src in usr

	RemoveUnderwear(usr, usr)

//
//	Socks
//
/obj/item/underwear/socks
	name = "socks"
	icon_state = "socks_norm"
	required_free_body_parts = FEET
/obj/item/underwear/socks/short
	name = "short socks"
	icon_state = "socks_short"
/obj/item/underwear/socks/thigh
	name = "thigh highs"
	icon_state = "socks_thigh"
/obj/item/underwear/socks/knee
	name = "knee highs"
	icon_state = "socks_knee"
/obj/item/underwear/socks/striped_knee
	name = "striped knee highs"
	icon_state = "striped_knee"
/obj/item/underwear/socks/striped_thigh
	name = "striped thigh highs"
	icon_state = "striped_thigh"
/obj/item/underwear/socks/pantyhose
	name = "pantyhose"
	icon_state = "pantyhose"
/obj/item/underwear/socks/thin_thigh
	name = "thin thigh highs"
	icon_state = "thin_thigh"
/obj/item/underwear/socks/thin_knee
	name = "knee knee highs"
	icon_state = "thin_knee"
/obj/item/underwear/socks/rainbow_thigh
	name = "rainbow thigh highs"
	icon_state = "rainbow_thigh"
/obj/item/underwear/socks/rainbow_knee
	name = "rainbow knee highs"
	icon_state = "rainbow_knee"
/obj/item/underwear/socks/fishnet
	name = "fishnet"
	icon_state = "fishnet"

//
//	Tops
//
/obj/item/underwear/top
	icon_state = "bra"
	required_free_body_parts = UPPER_TORSO

/obj/item/underwear/top/bra
	name = "Bra"
	icon_state = "bra"
/obj/item/underwear/top/bra/lacy
	name = "Lacy bra"
	icon_state = "lacy_bra"
/obj/item/underwear/top/bra/lacy/alt
	name = "Lacy bra, alt"
	icon_state = "lacy_bra_alt"
/obj/item/underwear/top/bra/sport
	name = "Sports bra"
	icon_state = "sports_bra"
/obj/item/underwear/top/bra/sport/alt
	name = "Sports bra, alt"
	icon_state = "sports_bra_alt"
/obj/item/underwear/top/bra/halterneck
	name = "Halterneck bra"
	icon_state = "halterneck_bra"
/obj/item/underwear/top/bra/tubetop
	name = "Tube Top"
	icon_state = "tubetop"

//
// Bottoms
//
/obj/item/underwear/bottom
	icon_state = "briefs"
	required_free_body_parts = FEET|LEGS|LOWER_TORSO

/obj/item/underwear/bottom/briefs
	name = "briefs"
	icon_state = "briefs"

/obj/item/underwear/bottom/panties
	name = "panties"
	icon_state = "panties"
/obj/item/underwear/bottom/panties/alt
	name = "panties, alt"
	icon_state = "panties_alt"
/obj/item/underwear/bottom/panties/noback
	name = "panties"
	icon_state = "panties_noback"

/obj/item/underwear/bottom/boxers
	name = "boxers"
	icon_state = "boxers"
/obj/item/underwear/bottom/boxers/loveheart
	name = "boxers, loveheart"
	icon_state = "boxers_loveheart"
/obj/item/underwear/bottom/boxers/green_and_blue
	name = "boxers, green & blue striped"
	icon_state = "boxers_green_and_blue"

/obj/item/underwear/bottom/thong
	name = "thong"
	icon_state = "thong"
/obj/item/underwear/bottom/thong/lacy
	name = "lacy thong"
	icon_state = "lacy_thong"
/obj/item/underwear/bottom/thong/lacy_alt
	name = "lacy thong, alt"
	icon_state = "lacy_thong_alt"

/obj/item/underwear/bottom/shorts/compression
	name = "compression shorts"
	icon_state = "compression_shorts"
/obj/item/underwear/bottom/shorts/expedition_pt
	name = "PT shorts, Expeditionary Corps"
	icon_state = "expedition_shorts"
/obj/item/underwear/bottom/shorts/fleet_pt
	name = "PT shorts, Fleet"
	icon_state = "fleet_shorts"
/obj/item/underwear/bottom/shorts/army_pt
	name = "PT shorts, Army"
	icon_state = "army_shorts"

/obj/item/underwear/bottom/longjon
	name = "long john bottoms"
	icon_state = "ljonb"


//
//	Undershirts
//
/obj/item/underwear/undershirt
	name = "undershirt"
	icon_state = "undershirt"
	required_free_body_parts = UPPER_TORSO
/obj/item/underwear/undershirt/female
	name = "undershirt, female"
	icon_state = "undershirt_female"

/obj/item/underwear/undershirt/blouse/female
	name = "women's dress shirt"
	icon_state = "blouse_female"

/obj/item/underwear/undershirt/shirt
	name = "shirt"
	icon_state = "undershirt"
/obj/item/underwear/undershirt/shirt/long
	name = "long Shirt"
	icon_state = "undershirt_long"
/obj/item/underwear/undershirt/shirt/long/female
	name = "longsleeve shirt, female"
	icon_state = "undershirt_long_female"
/obj/item/underwear/undershirt/shirt/long/stripe/black
	name = "longsleeve striped shirt, black"
	icon_state = "longstripe"
/obj/item/underwear/undershirt/shirt/long/stripe/blue
	name = "longsleeve striped shirt, blue"
	icon_state = "longstripe_blue"
/obj/item/underwear/undershirt/shirt/button
	name = "shirt, button down"
	icon_state = "shirt_long"
/obj/item/underwear/undershirt/shirt/button/female
	name = "button down shirt, female"
	icon_state = "shirt_long_female"
/obj/item/underwear/undershirt/shirt/expedition
	name = "shirt, expeditionary corps"
	icon_state = "expedition"
/obj/item/underwear/undershirt/shirt/expedition/female
	name = "shirt, expeditionary corps, female"
	icon_state = "expedition_female"
/obj/item/underwear/undershirt/shirt/heart
	name = "shirt, heart"
	icon_state = "lover"
/obj/item/underwear/undershirt/shirt/love_nt
	name = "shirt, I<3NT"
	icon_state = "ilovent"
/obj/item/underwear/undershirt/shirt/fleet
	name = "shirt, fleet"
	icon_state = "fleet"
/obj/item/underwear/undershirt/shirt/fleet/female
	name = "shirt, fleet, female"
	icon_state = "fleet_female"
/obj/item/underwear/undershirt/shirt/army
	name = "shirt, army"
	icon_state = "army"
/obj/item/underwear/undershirt/shirt/army/female
	name = "shirt, army, female"
	icon_state = "army_female"
/obj/item/underwear/undershirt/shirt/nt
	name = "shirt, NT"
	icon_state = "shirt_nano"
/obj/item/underwear/undershirt/shirt/shortsleeve
	name = "shortsleeve shirt"
	icon_state = "shortsleeve"
/obj/item/underwear/undershirt/shirt/shortsleeve/female
	name = "shortsleeve shirt, female"
	icon_state = "shortsleeve_female"
/obj/item/underwear/undershirt/shirt/tiedye
	name = "shirt, tiedye"
	icon_state = "shirt_tiedye"
/obj/item/underwear/undershirt/shirt/blue_striped
	name = "shirt, blue stripes"
	icon_state = "shirt_stripes"

/obj/item/underwear/undershirt/shirt/polo
	name = "polo shirt"
	icon_state = "polo"
/obj/item/underwear/undershirt/shirt/polo/female
	name = "polo, female"
	icon_state = "polo_female"
/obj/item/underwear/undershirt/shirt/polo/corp
	name = "polo, corporate"
	icon_state = "corp_polo"
/obj/item/underwear/undershirt/shirt/polo/nt
	name = "polo, NanoTrasen"
	icon_state = "ntpolo"
/obj/item/underwear/undershirt/shirt/polo/dais
	name = "polo, deimos advanced information systems"
	icon_state = "dais_polo"

/obj/item/underwear/undershirt/shirt/sport/green
	name = "sport shirt, green"
	icon_state = "greenshirtsport"
/obj/item/underwear/undershirt/shirt/sport/red
	name = "sport shirt, red"
	icon_state = "redshirtsport"
/obj/item/underwear/undershirt/shirt/sport/blue
	name = "sport shirt, blue"
	icon_state = "blueshirtsport"

/obj/item/underwear/undershirt/tank_top
	name = "tank top"
	icon_state = "tanktop"
/obj/item/underwear/undershirt/tank_top/female
	name = "tank top, female"
	icon_state = "tanktop_female"
/obj/item/underwear/undershirt/tank_top/alt
	name = "tank top, alt"
	icon_state = "tanktop_alt"
/obj/item/underwear/undershirt/tank_top/alt/female
	name = "tank top alt, female"
	icon_state = "tanktop_alt_female"
/obj/item/underwear/undershirt/tank_top/fleet
	name = "tTank top, fleet"
	icon_state = "tank_fleet"
/obj/item/underwear/undershirt/tank_top/fleet/female
	name = "tank top, fleet, female"
	icon_state = "tank_fleet_female"
/obj/item/underwear/undershirt/tank_top/expedition
	name = "tank top, expeditionary corps"
	icon_state = "tank_expedition"
/obj/item/underwear/undershirt/tank_top/expedition/female
	name = "tank top, expeditionary corps, female"
	icon_state = "tank_expedition_female"
/obj/item/underwear/undershirt/tank_top/fire
	name = "tank top, fire"
	icon_state = "tank_fire"
/obj/item/underwear/undershirt/tank_top/rainbow
	name = "tank top, rainbow"
	icon_state = "tank_rainbow"
/obj/item/underwear/undershirt/tank_top/stripes
	name = "tank top, striped"
	icon_state = "tank_stripes"
/obj/item/underwear/undershirt/tank_top/sun
	name = "tank top, sun"
	icon_state = "tank_sun"

/obj/item/underwear/undershirt/longjon
	name = "long john shirt"
	icon_state = "ljont"

/obj/item/underwear/undershirt/turtleneck
	name = "turtleneck sweater"
	icon_state = "turtleneck"

