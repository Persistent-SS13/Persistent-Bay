#if !defined(using_map_DATUM)

	#include "../../code/modules/lobby_music/chasing_time.dm"
	#include "../../code/modules/lobby_music/human.dm"
	#include "../../code/modules/lobby_music/marhaba.dm"
	#include "../../code/modules/lobby_music/treacherous_voyage.dm"
	#include "../../code/modules/lobby_music/comet_haley.dm"
	#include "../../code/modules/lobby_music/lysendraa.dm"

	#include "contour.dmm"

	#include "contour_areas.dm"
	#include "contour_elevator.dm"
	#include "contour_presets.dm"
	#define using_map_DATUM /datum/map/contour

#elif !defined(MAP_OVERRIDE)
	#warn A map has already been included, ignoring Contour

#endif
