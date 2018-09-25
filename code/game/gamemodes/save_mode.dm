/datum/universal_state/save
	name = "Save"
	var/obj/screen/cinematic

/datum/universal_state/save/New()

	//create the cinematic screen obj
	cinematic = new
	cinematic.icon = 'icons/effects/gateway_intro.dmi'
	cinematic.icon_state = "savescreen"
	cinematic.plane = HUD_PLANE
	cinematic.layer = HUD_ABOVE_ITEM_LAYER
	cinematic.mouse_opacity = 2
	cinematic.screen_loc = "WEST,SOUTH"

/datum/universal_state/save/OnEnter()
	for(var/mob/M in GLOB.player_list)
		apply_savescreen(M)
		start_cinematic_intro()
	SSmachines.disable()
	SSmobs.disable()
	SSair.disable()
	SSairflow.disable()
	SSopen_space.disable()
	SScircuit.disable()
	SSlighting.disable()
	SSchemistry.disable()
	SSatoms.disable()
	SSprocessing.disable()
	SSgarbage.disable()

/datum/universal_state/save/OnPlayerLatejoin()
	for(var/mob/M)
		apply_savescreen(M)

/datum/universal_state/save/OnExit()
	for(var/mob/M in GLOB.player_list)
		clear_savescreen(M)
		remove_cinematic_to_players()
	SSmachines.enable()
	SSmobs.enable()
	SSair.enable()
	SSairflow.enable()
	SSopen_space.enable()
	SScircuit.enable()
	SSlighting.enable()
	SSchemistry.enable()
	SSatoms.enable()
	SSprocessing.enable()
	SSgarbage.enable()

/datum/universal_state/save/proc/apply_savescreen(var/mob/living/M)
	if(M.client)
		M.canmove = 0
		to_chat(M,"<span class='notice'>You feel frozen, and somewhat disoriented as everything around you goes black.</span>")
		show_cinematic_to_players()


/datum/universal_state/save/proc/clear_savescreen(var/mob/living/M)
	if(M.client)
		M.canmove = 1
		to_chat(M,"<span class='notice'>You feel rooted in material world again.</span>")
		remove_cinematic_to_players()


/obj/screen/fullscreen/savescreen
	//create the cinematic screen obj
	icon = 'icons/effects/gateway_intro.dmi'
	icon_state = "savescreen"
	plane = HUD_PLANE
	layer = HUD_ABOVE_ITEM_LAYER
	mouse_opacity = 2
	screen_loc = "WEST,SOUTH"

/datum/universal_state/save/proc/start_cinematic_intro()
	for(var/mob/M in GLOB.player_list) //I guess so that people in the lobby only hear the explosion
	show_cinematic_to_players()
	flick("savescreen",cinematic)

/datum/universal_state/save/proc/show_cinematic_to_players()
	for(var/mob/M in GLOB.player_list)
		if(M.client)
			M.client.screen += cinematic

/datum/universal_state/save/proc/remove_cinematic_to_players()
	for(var/mob/M in GLOB.player_list)
		if(M.client)
			M.client.screen -= cinematic

