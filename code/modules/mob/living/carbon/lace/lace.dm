//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/mob/living/carbon/lace
	name = "stack"
	use_me = 1 //Can't use the me verb, it's a freaking immobile brain
	icon = 'icons/obj/surgery.dmi'
	icon_state = "cortical-stack"
	default_language = LANGUAGE_GALCOM
	var/obj/item/organ/internal/stack/container = null // should be the lace.. Except when in a LMI, it gets stored in the LMI itself
	var/mob/container2 = null
	var/timeofhostdeath = 0
	var/emp_damage = 0//Handles a type of MMI damage
	var/alert = null
	var/teleport_time = 0 // time when you can teleport back to nexus
	var/datum/action/lace_storage/tmp_storage_action
	var/datum/action/lace/laceaction //Need to keep the reference, otherwise removing it is really a pain in the ass

/mob/living/carbon/lace/get_stack()
	return container

/mob/living/carbon/lace/New(loc)
	container = loc //Keep in mind this might not be a organ/internal/stack
	laceaction = new(container)
	laceaction.Grant(src)
	default_language = all_languages[LANGUAGE_GALCOM]
	add_language(LANGUAGE_GALCOM)
	..()
	ADD_SAVED_VAR(timeofhostdeath)
	ADD_SAVED_VAR(emp_damage)

/mob/living/carbon/lace/after_load()
	. = ..()
	//When a lace + lacemob is put in a lmi, the lacemob is moved into the lmi itself from the lace.
	// So we don't want to try to access the container as if it was a lace, because its not.
	if(istype(loc, /obj/item/device/lmi))
		var/obj/item/device/lmi/C = loc
		C.brainmob = src
		//Then make sure the container is set to the actual stack organ
		var/obj/item/organ/internal/stack/ST = locate() in loc
		if(ST)
			container = ST
			container.lacemob = src
	else if(istype(container, /obj/item/organ/internal/stack))
		container.lacemob = src
	for(var/datum/action/action in actions)
		action.SetTarget(container)

/mob/living/carbon/lace/Initialize()
	. = ..()
	update_action_buttons()
	queue_icon_update()

/mob/living/carbon/lace/Destroy()
	if(laceaction)
		laceaction.Remove(src) //Make sure the lace action is cleared of any references
	if(key)				//If there is a mob connected to this thing. Have to check key twice to avoid false death reporting.
		if(stat!=DEAD)	//If not dead.
			death(1)	//Brains can die again. AND THEY SHOULD AHA HA HA HA HA HA
		message_admins("DEAD LACE DETECTED!! [key] [src]")
		if(tmp_storage_action)
			tmp_storage_action.Remove(src) //remove the old actions references plzthx
		ghostize()		//Ghostize checks for key so nothing else is necessary.
	container = null
	container2 = null
	QDEL_NULL(tmp_storage_action)
	QDEL_NULL(laceaction)
	. = ..()

/mob/living/carbon/brain/say_understands(var/other)//Goddamn is this hackish, but this say code is so odd
	if (istype(other, /mob/living/silicon/ai))
		if(!(container && istype(container, /obj/item/device/lmi)))
			return 0
		else
			return 1
	if (istype(other, /mob/living/silicon/pai))
		if(!(container && istype(container, /obj/item/device/lmi)))
			return 0
		else
			return 1
	if (istype(other, /mob/living/silicon/robot))
		if(!(container && istype(container, /obj/item/device/lmi)))
			return 0
		else
			return 1
	if (istype(other, /mob/living/carbon/human))
		return 1
	if (istype(other, /mob/living/carbon/slime))
		return 1
	return ..()

/mob/living/carbon/lace/UpdateLyingBuckledAndVerbStatus()
	if(in_contents_of(/obj/mecha) || istype(loc, /obj/item/device/lmi))
		use_me = 1

/mob/living/carbon/lace/isSynthetic()
	return 0

/mob/living/carbon/lace/binarycheck()
	return isSynthetic()

/mob/living/carbon/lace/check_has_mouth()
	return 0

// /mob/living/carbon/lace/Life()
// 	. = ..()
// 	update_action_buttons()
