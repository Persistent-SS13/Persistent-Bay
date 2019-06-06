


/* Not to be used yet
/atom/proc/do_after_skill(var/mob/user, var/delay, var/chance)
	var/atom/targetLoc = get_turf(src)
	var/atom/userLoc = user.loc
	var/userHolding = user.get_active_hand()
	var/datum/progressbar/progress = new(user, delay, src)
	var/endtime = world.time + delay
	var/starttime = world.time
	. = 1
	while (world.time < endtime)
		sleep(1)
		progress.update(world.time - starttime)

		if(!user || user.incapacitated(INCAPACITATION_DEFAULT) || user.loc != userLoc)
			. = 0
			break

		if(QDELETED(src) || targetLoc != target.loc))
			. = 0
			break

		if(user.get_active_hand() != userHolding)
			. = 0
			break

	qdel(progress)
*/

/atom/proc/Weld(var/obj/item/weapon/tool/weldingtool/W, var/mob/user, var/time = 25, var/outputMessage, var/skill = 5, var/minSkill = 0)
	if(!isWelder(W))
		return 0
	if(!W.isOn())
		to_chat(user, "<span class='notice'>The welding tool must be on to complete this task.</span>")
		return 0
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	add_fingerprint(user)
	playsound(get_turf(src), 'sound/items/Welder.ogg', 50, 1)
	if(outputMessage)
		to_chat(user, "<span class='notice'>[outputMessage]</span>")
	if(do_after(user, time, src))
		if(W.remove_fuel(0, user))
			return 1

/atom/proc/Screwdriver(var/obj/item/W, var/mob/user, var/time = 5, var/outputMessage, var/skill = 5, var/minSkill = 0)
	if(!isScrewdriver(W))
		return 0
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	add_fingerprint(user)
	playsound(get_turf(src), 'sound/items/Screwdriver.ogg', 50, 1)
	if(outputMessage)
		to_chat(user, "<span class='notice'>[outputMessage]</span>")
	if(do_after(user, time, src))
		return 1

/atom/proc/Wrench(var/obj/item/W, var/mob/user, var/time = 5, var/outputMessage, var/skill = 5, var/minSkill = 0)
	if(!isWrench(W))
		return 0
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	add_fingerprint(user)
	playsound(get_turf(src), 'sound/items/Ratchet.ogg', 50, 1)
	if(outputMessage)
		to_chat(user, "<span class='notice'>[outputMessage]</span>")
	if(do_after(user, time, src))
		return 1

/atom/proc/Wirecutter(var/obj/item/W, var/mob/user, var/time = 5, var/outputMessage, var/skill = 5, var/minSkill = 0)
	if(!isWirecutter(W))
		return 0
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	add_fingerprint(user)
	playsound(get_turf(src), 'sound/items/Wirecutter.ogg', 50, 1)
	if(outputMessage)
		to_chat(user, "<span class='notice'>[outputMessage]</span>")
	if(do_after(user, time, src))
		return 1

/atom/proc/Crowbar(var/obj/item/weapon/tool/T, var/mob/user, var/time = 5, var/outputMessage, var/skill = 5, var/minSkill = 0)
	if(!isCrowbar(T))
		return 0
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	add_fingerprint(user)
	if(T.use_tool(user, src, time))
		to_chat(user, "<span class='notice'>[outputMessage]</span>")
		return 1

/atom/proc/UseMaterial(var/obj/item/stack/material/W, var/mob/user, var/time = 10, var/outputMessage, var/skill = 1, var/minSkill = 0, var/amount)
	if(!isstack(W))
		return 0
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	add_fingerprint(user)

	if(!W.can_use(amount))
		to_chat(user, "<span class='notice'>You need more [W.name]</span>")
		return 0
	if(outputMessage)
		to_chat(user, "<span class='notice'>[outputMessage]</span>")
	if(do_after(user, time, src))
		if(W.use(amount))
			return 1