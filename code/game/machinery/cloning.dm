//Cloning revival method.
//The pod handles the actual cloning while the computer manages the clone profiles

//Potential replacement for genetics revives or something I dunno (?)

#define CLONE_BIOMASS 150
#define BIOMASS_MEAT_AMOUNT 50

/obj/machinery/clonepod
	anchored = 1
	name = "cloning pod"
	desc = "An electronically-lockable pod for growing organic tissue."
	density = 1
	icon = 'icons/obj/cloning.dmi'
	icon_state = "pod_0"
	req_access = list(core_access_medical_programs) //For premature unlocking.
	circuit_type = /obj/item/weapon/circuitboard/clonepod
	var/mob/living/occupant
	var/heal_level = 90 //The clone is released once its health reaches this level.
	var/locked = 0
	var/obj/item/modular_computer/connected = null //So we remember the connected clone machine.
	var/mess = 0 //Need to clean out it if it's full of exploded clone.
	var/attempting = 0 //One clone attempt at a time thanks
	var/eject_wait = 0 //Don't eject them as soon as they are created fuckkk
	var/biomass = 0
	var/speed_coeff
	var/efficiency
	var/obj/item/device/mmi/held_brain
	var/obj/item/organ/internal/brain/occupant_brain
	light_color = COLOR_LIME
	power_change()
		..()
		if(!(stat & (BROKEN|NOPOWER)))
			set_light(0.8, 2, 8, 2, light_color)
		else
			set_light(0)

/obj/machinery/clonepod/biomass
	biomass = CLONE_BIOMASS

/obj/machinery/clonepod/New()
	..()
	ADD_SAVED_VAR(occupant)
	ADD_SAVED_VAR(locked)
	ADD_SAVED_VAR(mess)
	ADD_SAVED_VAR(attempting)
	ADD_SAVED_VAR(biomass)
	ADD_SAVED_VAR(held_brain)

/obj/machinery/clonepod/after_load()
	. = ..()
	if(ishuman(occupant))
		var/mob/living/carbon/human/H = occupant
		var/obj/item/organ/internal/brain/B = H.internal_organs_by_name[BP_BRAIN]
		if(istype(B))
			occupant_brain = B

/obj/machinery/clonepod/Initialize()
	. = ..()
	if(. == INITIALIZE_HINT_QDEL)
		return .
	queue_icon_update()

/obj/machinery/clonepod/Destroy()
//	if(connected)
	//	connected.pods -= src
	connected = null
	held_brain = null
	occupant_brain = null
	occupant = null
	return ..()

/obj/machinery/clonepod/RefreshParts()
	speed_coeff = 0
	efficiency = 0
	for(var/obj/item/weapon/stock_parts/scanning_module/S in component_parts)
		efficiency += S.rating
	for(var/obj/item/weapon/stock_parts/manipulator/P in component_parts)
		speed_coeff += P.rating
	heal_level = min((efficiency * 15) + 10, 100)

/obj/machinery/clonepod/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/clonepod/attack_hand(mob/user as mob)
	if((isnull(occupant)) || (stat & NOPOWER))
		if(mess)
			go_out()
		return
	if((!isnull(occupant)) && (occupant.stat != 2))
		var/completion = (100 * ((occupant.health + 100) / (heal_level + 100)))
		to_chat(user, "Current clone cycle is [round(completion)]% complete.")
	return

//Clonepod

//Start growing a human clone in the pod!
/obj/machinery/clonepod/proc/growclone(var/datum/dna/R, var/function = 1)
	if(biomass < CLONE_BIOMASS || mess || attempting || panel_open || stat & (NOPOWER|BROKEN))
		return 0

	attempting = 1 //One at a time!!
	locked = 1

	eject_wait = 1
	spawn(100)
		eject_wait = 0

	var/mob/living/carbon/human/H = new /mob/living/carbon/human(src, R.species)
	occupant = H
	occupant.reagents.add_reagent(/datum/reagent/synaptizine, 30)
	if(!R.real_name)	//to prevent null names
		if(held_brain && held_brain.brainmob)
			R.real_name = held_brain.brainmob.mind.name
		else
			R.real_name = "CLONE"
	H.real_name = R.real_name
	biomass -= CLONE_BIOMASS
	//Get the clone body ready
	if(function == 1)
		H.adjustCloneLoss(190) //new damage var so you can't eject a clone early then stab them to abuse the current damage system --NeoFite
		H.adjustBrainLoss(rand(10, 30)) // The rand(10, 30) will come out as extra brain damage
		H.Paralyse(4)
	else
		H.adjustBrainLoss(5) // The rand(10, 30) will come out as extra brain damage
		H.Paralyse(4)
	//Here let's calculate their health so the pod doesn't immediately eject them!!!
	H.updatehealth()
	// -- Mode/mind specific stuff goes here
	callHook("clone", list(H))
	// -- End mode specific stuff

	if(!R)
		H.dna = new /datum/dna()
		H.dna.real_name = H.real_name
		H.dna.ready_dna(H)
	else
		H.dna = R.Clone()
	if(function == 1)
		randmutb(H)
	if(function == 1 && prob(50))
		randmutb(H)
	if(function == 1 && prob(50))
		randmutb(H)
	if(function == 1 && prob(50))
		randmutb(H)
	H.dna.UpdateSE()
	H.dna.UpdateUI()

	H.set_species(R.species)
	H.sync_organ_dna(1) // It's literally a fresh body as you can get, so all organs properly belong to it
	H.UpdateAppearance()
	/**
	if(function == 1)
		var/obj/item/organ/external/head/head = H.get_organ("head")
		if(H.gender == "female")
			head.h_style = pick("Long Hair", "Unkempt", "Very Long Hair", "Longer Fringe", "Bowl")
		else
			head.h_style = pick("Balding Hair", "Unkempt", "Very Long Hair", "Bald", "Bowl")
			head.f_style = pick("Neckbeard", "Very Long Beard", "Abraham Lincoln Beard", "Dwarf Beard", "Shaven", "Unshaven")
	**/
	H.update_body()
	queue_icon_update()
	attempting = 0
	return 1

//Grow clones to maturity then kick them out.  FREELOADERS
/obj/machinery/clonepod/Process()
	. = ..()
	var/show_message = 0
	for(var/obj/item/weapon/reagent_containers/food/snacks/meat/meat in range(1, src))
		qdel(meat)
		biomass += BIOMASS_MEAT_AMOUNT
		show_message = 1
	if(show_message)
		visible_message("\The [src] sucks in and processes the nearby biomass.")

	if(stat & NOPOWER) //Autoeject if power is lost
		if(occupant)
			locked = 0
			go_out()
		return

	if((occupant) && (occupant.loc == src))
		if((occupant.stat == DEAD))  //	 || !occupant.key		Autoeject corpses and suiciding dudes.
			locked = 0
			go_out()
			connected_message("Clone Rejected: Deceased.")
			return

		else if(occupant.getCloneLoss() > (100 - heal_level))
			occupant.Paralyse(4)

			 //Slowly get that clone healed and finished.
			occupant.adjustCloneLoss(-((speed_coeff/2)))

			//Premature clones may have brain damage.
			occupant.adjustBrainLoss(-((speed_coeff/20)*efficiency))

			//So clones don't die of oxyloss in a running pod.
			if(occupant.reagents.get_reagent_amount("salbutamol") < 5)
				occupant.reagents.add_reagent("salbutamol", 5)

			//Also heal some oxyloss ourselves just in case!!
			occupant.adjustOxyLoss(-4)

			use_power_oneoff(7500) //This might need tweaking.
			return

		else if((occupant.getCloneLoss() <= (100 - heal_level)) && (!eject_wait))
			connected_message("Cloning Process Complete.")
			locked = 0
			go_out()
			return

	else if((!occupant) || (occupant.loc != src))
		occupant = null
		if(locked)
			locked = 0
		use_power_oneoff(200)
		return

	return

//Let's unlock this early I guess.  Might be too early, needs tweaking.
/obj/machinery/clonepod/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	if( !(occupant || mess || locked) && default_deconstruction_screwdriver(user, W))
		return 1
	else
		to_chat(user, "<span class='notice'>The maintenance panel is locked.</span>")
		return 1

	if(panel_open && default_deconstruction_crowbar(user, W))
		return 1

	if(istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/modular_computer/pda))
		if(!check_access(W))
			to_chat(user, "\red Access Denied.")
			return
		if((!locked) || (isnull(occupant)))
			return
		if((occupant.health < -20) && (occupant.stat != DEAD))
			to_chat(user, SPAN_WARNING("Access Refused."))
			return
		else
			locked = 0
			to_chat(user, SPAN_WARNING("System unlocked."))

//Removing cloning pod biomass
	else if(istype(W, /obj/item/weapon/reagent_containers/food/snacks/meat))
		to_chat(user, "\blue \The [src] processes \the [W].")
		biomass += BIOMASS_MEAT_AMOUNT
		user.drop_item()
		qdel(W)
		return
	else if(isWrench(W))
		if(locked && (anchored || occupant))
			to_chat(user, "\red Can not do that while [src] is in use.")
		else if(default_wrench_floor_bolts(user, W, 2 SECONDS))
			if(anchored)
				anchored = 0
		//		connected.pods -= src  COME BACK TO THIS
				connected = null
			else
				anchored = 1
			playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
			if(anchored)
				user.visible_message("[user] secures [src] to the floor.", "You secure [src] to the floor.")
			else
				user.visible_message("[user] unsecures [src] from the floor.", "You unsecure [src] from the floor.")
	else if(istype(W, /obj/item/device/multitool))
		return
	else
		return ..()

/obj/machinery/clonepod/emag_act(user as mob)
	if(isnull(occupant))
		return
	to_chat(user, "You force an emergency ejection.")
	locked = 0
	go_out()
	return

//Put messages in the connected computer's temp var for display.
/obj/machinery/clonepod/proc/connected_message(var/message)
	if(!message)
		return 0

//	connected.temp = "[name] : [message]"
	connected.updateUsrDialog()
	return 1

/obj/machinery/clonepod/verb/eject()
	set name = "Eject Cloner"
	set category = "Object"
	set src in oview(1)

	if(!usr)
		return
	if(usr.stat != 0)
		return
	go_out(usr)
	add_fingerprint(usr)
	return

/obj/machinery/clonepod/proc/go_out(user)
	if(mess) //Clean that mess and dump those gibs!
		if(occupant)
			return
		mess = 0
		gibs(loc)
		playsound(loc, 'sound/effects/splat.ogg', 50, 1)
		update_icon()
		return

	if(!(occupant) && !(held_brain.brainmob))
		to_chat(user, "<span class=\"warning\">The cloning pod is empty!</span>")
		return

	if(locked)
		to_chat(user, "<span class=\"warning\">The cloning pod is locked!</span>")
		return
	if(occupant)
		if(occupant.client)
			occupant.client.eye = occupant.client.mob
			occupant.client.perspective = MOB_PERSPECTIVE
		occupant.forceMove(get_turf(src))
		eject_wait = 0 //If it's still set somehow.
		domutcheck(occupant) //Waiting until they're out before possible notransform.
		occupant = null
		update_icon()
		return
/obj/machinery/clonepod/proc/malfunction()
	if(occupant)
		connected_message("Critical Error!")
		mess = 1
		occupant.forceMove(get_turf(src))
		domutcheck(occupant)
		occupant = null
		update_icon()
	return

/obj/machinery/clonepod/on_update_icon()
	..()
	icon_state = "pod_0"
	if(occupant && !(stat & NOPOWER))
		icon_state = "pod_1"
	else if(mess && !panel_open)
		icon_state = "pod_g"

/obj/machinery/clonepod/relaymove(mob/user as mob)
	if(user.stat)
		return
	go_out()
	return

/obj/machinery/clonepod/emp_act(severity)
	if(prob(100/(severity*efficiency))) malfunction()
	..()

/obj/machinery/clonepod/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.forceMove(src.loc)
				A.ex_act(severity)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(src.loc)
					A.ex_act(severity)
				qdel(src)
				return
		if(3.0)
			if(prob(25))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(src.loc)
					A.ex_act(severity)
				qdel(src)
				return
		else
	return

/obj/item/weapon/paper/Cloning
	name = "paper - 'H-87 Cloning Apparatus Manual"
	info = {"<h4>Getting Started</h4>
	Congratulations, your station has purchased the H-87 industrial cloning device!<br>
	Using the H-87 is almost as simple as brain surgery! Simply insert the target humanoid into the scanning chamber and select the scan option to create a new profile!<br>
	<b>That's all there is to it!</b><br>
	<i>Notice, cloning system cannot scan inorganic life or small primates.  Scan may fail if subject has suffered extreme brain damage.</i><br>
	<p>Clone profiles may be viewed through the profiles menu. Scanning implants a complementary HEALTH MONITOR IMPLANT into the subject, which may be viewed from each profile.
	Profile Deletion has been restricted to \[Station Head\] level access.</p>
	<h4>Cloning from a profile</h4>
	Cloning is as simple as pressing the CLONE option at the bottom of the desired profile.<br>
	Per your company's EMPLOYEE PRIVACY RIGHTS agreement, the H-87 has been blocked from cloning crewmembers while they are still alive.<br>
	<br>
	<p>The provided CLONEPOD SYSTEM will produce the desired clone.  Standard clone maturation times (With SPEEDCLONE technology) are roughly 90 seconds.
	The cloning pod may be unlocked early with any \[Medical Researcher\] ID after initial maturation is complete.</p><br>
	<i>Please note that resulting clones may have a small DEVELOPMENTAL DEFECT as a result of genetic drift.</i><br>
	<h4>Profile Management</h4>
	<p>The H-87 (as well as your station's standard genetics machine) can accept STANDARD DATA DISKETTES.
	These diskettes are used to transfer genetic information between machines and profiles.
	A load/save dialog will become available in each profile if a disk is inserted.</p><br>
	<i>A good diskette is a great way to counter aforementioned genetic drift!</i><br>
	<br>
	<font size=1>This technology produced under license from Thinktronic Systems, LTD.</font>"}