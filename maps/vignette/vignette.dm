#if !defined(using_map_DATUM)

	#include "../../code/modules/lobby_music/chasing_time.dm"
	#include "../../code/modules/lobby_music/human.dm"
	#include "../../code/modules/lobby_music/marhaba.dm"
	#include "../../code/modules/lobby_music/treacherous_voyage.dm"
	#include "../../code/modules/lobby_music/comet_haley.dm"
	#include "../../code/modules/lobby_music/lysendraa.dm"

	#include "vignette.dmm"

	#include "vignette_areas.dm"
	#include "vignette_elevator.dm"
	#define using_map_DATUM /datum/map/vignette

#elif !defined(MAP_OVERRIDE)
say
	#warn A map has already been included, ignoring Vignette

#endif
