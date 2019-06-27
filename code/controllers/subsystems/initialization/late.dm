//Initializes relatively late in subsystem init order.

SUBSYSTEM_DEF(late)
	name = "Late Initialization"
	init_order = SS_INIT_LATE_INIT
	flags = SS_NO_FIRE

/datum/controller/subsystem/late/Initialize()
	GLOB.using_map.build_exoplanets()

	var/decl/asset_cache/asset_cache = decls_repository.get_decl(/decl/asset_cache)
	asset_cache.load()
	populate_lathe_recipes() // This creates and deletes objects; could use improvement.
	. = ..()
