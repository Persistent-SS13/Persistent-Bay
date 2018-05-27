#ifdef UNIT_TEST

/*This set of unit tests ensures that MAP_STORAGE works properly*/

/datum/unit_test/should_save_test
	name = "MAP_STORAGE: should_save test"

/datum/unit_test/should_save_test/start_test()
	var/bad_tests = 0

	var/datum/map_storage_test/test_datum = new

	if(test_datum.should_save())
		bad_tests++
		log_bad("should_save = 0 returns should_save TRUE, should return should_save FALSE")

	test_datum.should_save = 1

	if(!test_datum.should_save())
		bad_tests++
		log_bad("should_save = 1 returns should_save FALSE, should return should_save TRUE")

	qdel(test_datum)

	if(bad_tests)
		fail("[bad_tests] datums returned incorrect should_save results.")
	else
		pass("All datums returned correct should_save results.")

	return 1

/datum/unit_test/map_storage_debugger
	name = "MAP_STORAGE: debugger functions properly"

/datum/unit_test/map_storage_debugger/start_test()
	var/obj/item/map_storage_debugger/test_debugger = new /obj/item/map_storage_debugger(get_safe_turf())

	if(!test_debugger)
		fail("DEBUG ITEM - does not exist.")
		return 1
	if(!istype(test_debugger))
		fail("DEBUG ITEM - is not type /obj/item/map_storage_debugger.")
		return 1

	var/datum/map_storage_test/test_datum = test_debugger.spawn_debug(null,/datum/map_storage_test)

	if(!test_datum)
		fail("TEST DATUM - does not exist.")
		return 1
	if(!istype(test_datum))
		fail("TEST DATUM - is not type /datum/map_storage_test.")
		return 1

	pass("Debug item properly spawns test datum.")
	return 1

#endif