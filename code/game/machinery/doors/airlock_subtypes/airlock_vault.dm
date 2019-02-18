/obj/machinery/door/airlock/highsecurity
	airlock_type = "secure"
	name = "Secure Airlock"
	icon = 'icons/obj/doors/secure/door.dmi'
	fill_file = 'icons/obj/doors/secure/fill_steel.dmi'
	explosion_resistance = 20
	secured_wires = TRUE
	assembly_type = /obj/structure/door_assembly/door_assembly_highsecurity
	paintable = FALSE
	armor = list(
		DAM_BLUNT  	= MaxArmorValue,
		DAM_PIERCE 	= MaxArmorValue,
		DAM_CUT 	= MaxArmorValue,
		DAM_BULLET 	= 95,
		DAM_ENERGY 	= 95,
		DAM_BURN 	= MaxArmorValue,
		DAM_BOMB 	= 95,
		DAM_EMP 	= 95,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)

/obj/machinery/door/airlock/highsecurity/bolted
	locked = TRUE


/obj/machinery/door/airlock/vault
	airlock_type = "vault"
	name = "Vault"
	icon = 'icons/obj/doors/vault/door.dmi'
	fill_file = 'icons/obj/doors/vault/fill_steel.dmi'
	explosion_resistance = 20
	opacity = TRUE
	secured_wires = TRUE
	assembly_type = /obj/structure/door_assembly/door_assembly_highsecurity //Until somebody makes better sprites.
	paintable = AIRLOCK_PAINTABLE|AIRLOCK_STRIPABLE
	armor = list(
		DAM_BLUNT  	= MaxArmorValue,
		DAM_PIERCE 	= MaxArmorValue,
		DAM_CUT 	= MaxArmorValue,
		DAM_BULLET 	= 95,
		DAM_ENERGY 	= 95,
		DAM_BURN 	= MaxArmorValue,
		DAM_BOMB 	= 95,
		DAM_EMP 	= 95,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)

/obj/machinery/door/airlock/vault/bolted
	locked = TRUE
