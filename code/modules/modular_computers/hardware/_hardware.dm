/obj/item/weapon/computer_hardware/
	name = "Hardware"
	desc = "Unknown Hardware."
	icon = 'icons/obj/modular_components.dmi'
	obj_flags = OBJ_FLAG_DAMAGEABLE
	var/obj/item/modular_computer/holder2 = null
	var/power_usage = 0 			// If the hardware uses extra power, change this.
	var/enabled = 1					// If the hardware is turned off set this to 0.
	var/critical = 1				// Prevent disabling for important component, like the HDD.
	var/hardware_size = 1			// Limits which devices can contain this component. 1: Tablets/Laptops/Consoles, 2: Laptops/Consoles, 3: Consoles only
	max_health = 100			// Maximal damage level.
	var/malfunction_threshold = 0.8		// "Malfunction" threshold. When damage exceeds this value the hardware piece will semi-randomly fail and do !!FUN!! things
	broken_threshold = 0.5			// "Failure" threshold. When damage exceeds this value the hardware piece will not work at all.
	var/malfunction_probability = 10// Chance of malfunction when the component is damaged
	var/usage_flags = PROGRAM_ALL

/obj/item/weapon/computer_hardware/New()
	..()
	ADD_SAVED_VAR(holder2)
	ADD_SAVED_VAR(enabled)

	ADD_SKIP_EMPTY(holder2)

/obj/item/weapon/computer_hardware/attackby(var/obj/item/W as obj, var/mob/living/user as mob)
	// Multitool. Runs diagnostics
	if(isMultitool(W))
		to_chat(user, "***** DIAGNOSTICS REPORT *****")
		diagnostics(user)
		to_chat(user, "******************************")
		return 1
	// Nanopaste. Repair all damage if present for a single unit.
	var/obj/item/stack/S = W
	if(istype(S, /obj/item/stack/nanopaste))
		if(health == max_health)
			to_chat(user, "\The [src] doesn't seem to require repairs.")
			return 1
		if(S.use(1))
			to_chat(user, "You apply a bit of \the [W] to \the [src]. It immediately repairs all damage.")
			health = max_health
		return 1
	// Cable coil. Works as repair method, but will probably require multiple applications and more cable.
	if(isCoil(S))
		if(health == max_health)
			to_chat(user, "\The [src] doesn't seem to require repairs.")
			return 1
		if(S.use(1))
			to_chat(user, "You patch up \the [src] with a bit of \the [W].")
			add_health(10)
		return 1
	return ..()


// Called on multitool click, prints diagnostic information to the user.
/obj/item/weapon/computer_hardware/proc/diagnostics(var/mob/user)
	to_chat(user, "Hardware Integrity Test... (Integrity: [health]/[max_health]) [isfailing() ? "FAIL" : ismalfunctioning() ? "WARN" : "PASS"]")

/obj/item/weapon/computer_hardware/Initialize()
	. = ..()
	w_class = hardware_size
	if(istype(loc, /obj/item/modular_computer))
		holder2 = loc

/obj/item/weapon/computer_hardware/Destroy()
	holder2 = null
	return ..()

/obj/item/weapon/computer_hardware/proc/isfailing()
	return health < (broken_threshold * max_health)

/obj/item/weapon/computer_hardware/proc/ismalfunctioning()
	return health < (malfunction_threshold * max_health)

// Handles damage checks
/obj/item/weapon/computer_hardware/proc/check_functionality()
	// Turned off
	if(!enabled)
		return FALSE
	// Too damaged to work at all.
	if(isfailing())
		return FALSE
	// Still working. Well, sometimes...
	if(ismalfunctioning())
		if(prob(malfunction_probability))
			return FALSE
	// Good to go.
	return TRUE

/obj/item/weapon/computer_hardware/examine(var/mob/user)
	. = ..()
	if(isfailing())
		to_chat(user, "<span class='danger'>It seems to be severely damaged!</span>")
	else if(ismalfunctioning())
		to_chat(user, "<span class='notice'>It seems to be damaged!</span>")
	else if(health < max_health)
		to_chat(user, "It seems to be slightly damaged.")

