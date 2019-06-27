/obj/item/weapon/tool


//Whether the tool can be used right now to perform a task
/obj/item/weapon/tool/proc/operable()
	return TRUE

//Handles returning the duration the tool takes to execute a task depending on the default duration provided
// Basically this is used to apply modifiers on the duration a tool class takes to do a job. So better tool classes can make work shorter and etc..
/obj/item/weapon/tool/proc/apply_duration_efficiency(var/defduration)
	return defduration

//Make the tool perform a task for a given duration. Returns true if/when the tool finishes successfully, or false if its interrupted
// time: default duration the task should last. (is affected by tool quality/skill)
/obj/item/weapon/tool/proc/use_tool(var/mob/living/user, var/obj/target, var/time = 0, var/output_message = null, var/required_skill = null)
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	if(!operable())
		return FALSE
	play_tool_sound()
	var/done = (required_skill)? user.do_skilled(apply_duration_efficiency(time), required_skill, target) : do_after(user, apply_duration_efficiency(time), target)

	//If the target got deleted while we're working, abort!
	if(!target)
		return FALSE

	if(required_skill && prob(user.skill_fail_chance(required_skill, 1)))
		to_chat(user, SPAN_DANGER("You're not very good at this and fail the task.."))
		return FALSE  //There's a chance to screw up if not skilled enough
	if(done)
		if(output_message)
			to_chat(user, SPAN_NOTICE("[output_message]"))
		return TRUE
	else
		//The user moved and cancelled
		return FALSE

//Use this proc to have the tool do its tool noise
/obj/item/weapon/tool/proc/play_tool_sound()
	return