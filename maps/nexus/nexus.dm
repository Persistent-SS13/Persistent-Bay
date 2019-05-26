#if !defined(using_map_DATUM)

	#include "../../code/modules/lobby_music/chasing_time.dm"
	#include "../../code/modules/lobby_music/human.dm"
	#include "../../code/modules/lobby_music/marhaba.dm"
	#include "../../code/modules/lobby_music/treacherous_voyage.dm"
	#include "../../code/modules/lobby_music/comet_haley.dm"
	#include "../../code/modules/lobby_music/lysendraa.dm"

	#include "nexus.dmm"

	#include "nexus_areas.dm"
	#include "nexus_elevator.dm"
	#include "nexus_factions.dm"
	#include "nexus_presets.dm"
	#include "nexus_outfits.dm"
	#include "obj/nexus_headsets.dm"
	#define using_map_DATUM /datum/map/nexus

#elif !defined(MAP_OVERRIDE)
	#warn A map has already been included, ignoring Nexus
#endif
