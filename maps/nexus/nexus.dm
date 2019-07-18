#if !defined(using_map_DATUM)

	#include "../../code/modules/lobby_music/chasing_time.dm"
	#include "../../code/modules/lobby_music/human.dm"
	#include "../../code/modules/lobby_music/marhaba.dm"
	#include "../../code/modules/lobby_music/treacherous_voyage.dm"
	#include "../../code/modules/lobby_music/comet_haley.dm"
	#include "../../code/modules/lobby_music/lysendraa.dm"

	#include "nexus.dmm"
//	#include "nexus_empty.dmm"

	#include "_nexus_macros.dm"
	#include "nexus_access.dm"
	#include "nexus_areas.dm"
	#include "nexus_elevator.dm"
	#include "nexus_factions.dm"
	#include "nexus_presets.dm"
	#include "nexus_outfits.dm"
	#include "nexus_frontier_beacons.dm"
	#include "obj/nexus_headsets.dm"
	#include "obj/nexus_ids.dm"
	#include "obj/nexus_power.dm"
	#include "obj/nexus_machines.dm"
	#include "obj/nexus_misc.dm"
	#define using_map_DATUM /datum/map/nexus

#elif !defined(MAP_OVERRIDE)
	#warn A map has already been included, ignoring Nexus
#endif
