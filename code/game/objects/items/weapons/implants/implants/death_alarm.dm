/obj/item/weapon/implant/death_alarm
	name = "death alarm implant"
	desc = "An alarm which monitors host vital signs and transmits a radio message upon death."
	known = 1
	var/mobname = "Will Robinson"

/obj/item/weapon/implant/death_alarm/get_data()
	return {"
	<b>Implant Specifications:</b><BR>
	<b>Name:</b> [GLOB.using_map.company_name] \"Profit Margin\" Class Employee Lifesign Sensor<BR>
	<b>Life:</b> Activates upon death.<BR>
	<b>Important Notes:</b> Alerts crew to crewmember death.<BR>
	<HR>
	<b>Implant Details:</b><BR>
	<b>Function:</b> Contains a compact radio signaler that triggers when the host's lifesigns cease.<BR>
	<b>Special Features:</b> Alerts crew to crewmember death.<BR>
	<b>Integrity:</b> Implant will occasionally be degraded by the body's immune system and thus will occasionally malfunction."}

/obj/item/weapon/implant/death_alarm/islegal()
	return TRUE

/obj/item/weapon/implant/death_alarm/Process()
	if (!implanted) return
	var/mob/M = imp_in

	if(isnull(M)) // If the mob got gibbed
		activate()
	else if(M.stat == DEAD)
		activate("death")

/obj/item/weapon/implant/death_alarm/activate(var/cause)
	var/mob/M = imp_in
	var/area/t = get_area(M)
	var/location = t.name
	if (cause == "emp" && prob(50))
		location =  pick(teleportlocs)
	if(!t.requires_power) // We assume areas that don't use power are some sort of special zones
		var/area/default = world.area
		location = initial(default.name)
	var/death_message = "[mobname] has died in [location]!"
	if(!cause)
		death_message = "[mobname] has died-zzzzt in-in-in..."
	STOP_PROCESSING(SSobj, src)

	for(var/channel in list("Security", "Medical", "Command"))
		GLOB.global_headset.autosay(death_message, "[mobname]'s Death Alarm", channel)

/obj/item/weapon/implant/death_alarm/emp_act(severity)			//for some reason alarms stop going off in case they are emp'd, even without this
	if (malfunction)		//so I'm just going to add a meltdown chance here
		return
	malfunction = MALFUNCTION_TEMPORARY

	if(prob(20))
		activate("emp")	//let's shout that this dude is dead
	if(severity == 1)
		if(prob(40))	//small chance of obvious meltdown
			meltdown()
		else if (prob(60))	//but more likely it will just quietly die
			malfunction = MALFUNCTION_PERMANENT
		STOP_PROCESSING(SSobj, src)

	spawn(20)
		malfunction = 0

/obj/item/weapon/implant/death_alarm/implanted(mob/source as mob)
	mobname = source.real_name
	START_PROCESSING(SSobj, src)
	return TRUE

/obj/item/weapon/implant/death_alarm/removed()
	..()
	STOP_PROCESSING(SSobj, src)

/obj/item/weapon/implantcase/death_alarm
	name = "glass case - 'death alarm'"
	imp = /obj/item/weapon/implant/death_alarm

/obj/item/weapon/implant/death_alarm/trauma
	name = "biomonitor implant"
	desc = "An alarm which monitors host vital signs and transmits a radio message upon critical condition."
	known = 1
	mobname = "Medical Response Client"

/obj/item/weapon/implantcase/trauma_alarm
	name = "glass case - 'trauma alarm'"
	imp = /obj/item/weapon/implant/death_alarm

/obj/item/weapon/implant/death_alarm/trauma/get_data()
	return {"
	<b>Implant Specifications:</b><BR>
	<b>Name:</b> [GLOB.using_map.company_name] \"Executive\" Class Client Lifesign Sensor<BR>
	<b>Life:</b> Activates upon death.<BR>
	<b>Important Notes:</b> Alerts trauma responders to client in critical condition.<BR>
	<HR>
	<b>Implant Details:</b><BR>
	<b>Function:</b> Contains a compact radio signaler that triggers when the host's lifesigns enter a critical range.<BR>
	<b>Special Features:</b> Alerts trauma responders to client in critical condition.<BR>
	<b>Integrity:</b> Once tripped, the implant must be removed and reimplanted to reset it."}


/obj/item/weapon/implant/death_alarm/trauma/Process()
	if (!implanted) return
	var/mob/living/carbon/human/M = imp_in
	var/blood_oxygenation = M.get_blood_oxygenation()
	var/oxygen_damage = M.getOxyLoss()
	var/toxin_damage = M.getToxLoss()
	var/should_crit_alert = 0

	if(blood_oxygenation < 60)
		should_crit_alert = 1
	if(oxygen_damage > 35)
		should_crit_alert = 1
	if(toxin_damage > 35)
		should_crit_alert = 1


	if(M.stat == DEAD)
		activate("death")
	else if(isnull(M)) // If the mob got gibbed
		activate()
	else if(should_crit_alert)
		activate("crit")

/obj/item/weapon/implant/death_alarm/trauma/activate(var/cause)
	var/mob/M = imp_in
	var/area/t = get_area(M)
	var/location = t.name
	var/turf/T = get_turf(M)
	var/x = T.x
	var/y = T.y
	var/z = T.z

	if(!t.requires_power) // We assume areas that don't use power are some sort of special zones
		var/area/default = world.area
		location = initial(default.name)
	var/crit_message = "%$%!"
	if(cause == "emp")
		crit_message = "[mobname] is in cri-zzzzt in-in-in..."
	if(cause == "crit")
		crit_message = "[mobname] is in acute condition in [location] ([x], [y], [z])."
	if(cause == "death")
		crit_message = "[mobname] has died in [location] ([x], [y], [z])."
	if(!cause)
		crit_message = "[mobname] has die-zzzzt in-in-in..."

	STOP_PROCESSING(SSobj, src)

	for(var/channel in list("Security", "Medical", "Command", "Trauma Response"))
		GLOB.global_headset.autosay(crit_message, "[mobname]'s Medical Implant", channel)