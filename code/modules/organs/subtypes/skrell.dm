/obj/item/organ/internal/skrell/nervecluser
	name = "nerve cluster"
	parent_organ = BP_HEAD
	organ_tag = BP_NERVECLUSTER

/obj/item/organ/internal/skrell/nervecluser/removed(var/mob/living/user)
	if(user && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mind && H.species.get_bodytype(H) != "Skrell")
			to_chat(H, "You feel a deep sense of comfort as the strange alien presence fades.")
			H.remove_language(LANGUAGE_SKRELLIAN)
		else
			to_chat(H, "You feel your cluster's guidance fade away, throwing your emotions into confusion.")
			H.hallucination(120, 30)
	..(user)

/obj/item/organ/internal/skrell/nervecluser/replaced(var/mob/living/carbon/human/target, var/obj/item/organ/external/affected)
	if(!..()) return 0

	if(target && ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.mind && H.species.get_bodytype(H) != "Skrell")
			to_chat(H, "You feel an alien presence begin to regulate your thoughts.")
			H.hallucination(120, 30)
			H.add_language(LANGUAGE_SKRELLIAN)
		else
			to_chat(H, "You feel a deep sense of relief as your cluster's guidance returns.")
	return 1