/obj/machinery/fabricator/engineering_fabricator
	// Things that must be adjusted for each fabricator
	name = "Engineering Equipment Fabricator" // Self-explanatory
	desc = "A machine used for the production of engineering equipment." // Self-explanatory
	circuit = /obj/item/weapon/circuitboard/fabricator/engfab // Circuit for the machine. These, as well as their designs, should be defined in fabricator_circuits.dm
	build_type = ENGFAB // The identifer for what gets built in what fabricator. A new one *MUST* be defined in _defines/research.dm for each fabricator.
						  // More than one can be assigned per design, however, if you want something to be able to be built in more than one fabricator eg. Power Cells
	metal_load_anim = TRUE				// Determines if a sheet loading animation will be applied when loading metals. If you're using a non-standard icon and don't
										// want to sprite a new loading animation as well, set this to FALSE.

	has_reagents = FALSE				// Defaults to FALSE, but added here for explanation. If this is set to true, than you require designs to use reagents
										// in addition to any material costs.

