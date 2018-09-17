PROCESSING_SUBSYSTEM_DEF(mobs)
	name = "Mobs"
	priority = SS_PRIORITY_MOB
	flags = SS_KEEP_TIMING|SS_NO_INIT
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	wait = 20

	process_proc = /mob/proc/Life

	var/list/mob_list

/datum/controller/subsystem/processing/mobs/PreInit()
	mob_list = processing // Simply setups a more recognizable var name than "processing"

/*// Currently only in use by the hostile mobs.
PROCESSING_SUBSYSTEM_DEF(mobslow)
	name = "Mobs (Low Priority)"
	priority = SS_PRIORITY_MOB - 30
	flags = SS_KEEP_TIMING|SS_NO_INIT
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	wait = 20

	process_proc = /mob/proc/Life

	var/list/mob_list

/datum/controller/subsystem/processing/mobslow/PreInit()
	mob_list = processing
*/
