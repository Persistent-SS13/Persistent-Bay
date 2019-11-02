#if !defined(using_map_DATUM)

	#include "../../code/modules/lobby_music/ultra.dm"
	#include "../../code/modules/lobby_music/reloaded.dm"

	#include "sycorax.dmm"
//	#include "sycorax_empty.dmm"

	#include "_sycorax_macros.dm"
	#include "sycorax_access.dm"
	#include "sycorax_areas.dm"
	#include "sycorax_factions.dm"
	#include "sycorax_presets.dm"
	#include "sycorax_outfits.dm"
	#include "sycorax_frontier_beacons.dm"
	#include "obj/sycorax_headsets.dm"
	#include "obj/sycorax_ids.dm"
	#include "obj/sycorax_power.dm"
	#include "obj/sycorax_machines.dm"
	#include "obj/sycorax_misc.dm"
	#define using_map_DATUM /datum/map/sycorax

#elif !defined(MAP_OVERRIDE)
	#warn A map has already been included, ignoring sycorax
#endif
