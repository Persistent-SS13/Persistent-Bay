//	Observer Pattern Implementation: Density Set
//		Registration type: /atom
//
//		Raised when: An /atom changes density using the set_density() proc.
//
//		Arguments that the called proc should expect:
//			/atom/density_changer: The instance that changed density.
//			/old_density: The density before the change.
//			/new_density: The density after the change.

GLOBAL_DATUM_INIT(density_set_event, /decl/observ/density_set, new)

/decl/observ/density_set
	name = "Density Set"
	expected_type = /atom

/*******************
* Density Handling *
*******************/
/atom/proc/set_density(new_density)
	var/old_density = density
	if(density != new_density)
		density = !!new_density
	if(density != old_density)
		GLOB.density_set_event.raise_event(src, old_density, density)

//Moved this directly in the turf's ChangeTurf definition instead of overriding here and having things complain about it. 
// /turf/ChangeTurf()
// 	var/old_density = density
// 	. = ..()
// 	if(density != old_density)
// 		GLOB.density_set_event.raise_event(src, old_density, density)
