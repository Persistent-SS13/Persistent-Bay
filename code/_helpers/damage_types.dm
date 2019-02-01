//This proc returns whether a damage type is considered "Brute" damage. Mainly for organ handling.
/proc/IsDamageTypeBrute(var/damtype)
	return ISDAMTYPE(damtype, DAM_BLUNT) || ISDAMTYPE(damtype, DAM_CUT) || ISDAMTYPE(damtype, DAM_PIERCE) || ISDAMTYPE(damtype, DAM_BULLET)

//This proc returns whether a damage type is considered "Burn" damage. Mainly for organ handling.
/proc/IsDamageTypeBurn(var/damtype)
	return ISDAMTYPE(damtype, DAM_BURN) || ISDAMTYPE(damtype, DAM_LASER) || ISDAMTYPE(damtype, DAM_ENERGY) || ISDAMTYPE(damtype, DAM_BOMB)

//Whether the damage type has effect on a physical object (AKA things that would hurt say a chair)
/proc/IsDamageTypePhysical(var/damtype)
	return IsDamageTypeBrute(damtype) || IsDamageTypeBurn(damtype)

//Whether the damage type has more of a non-physical/internal effect.. (AKA things that wouldn't hurt say a chair)
/proc/IsDamageTypeNonPhysical(var/damtype)
	return ISDAMTYPE(damtype, DAM_EMP) || ISDAMTYPE(damtype, DAM_BIO) || ISDAMTYPE(damtype, DAM_RADS) || ISDAMTYPE(damtype, DAM_STUN) ||\
		ISDAMTYPE(damtype, DAM_PAIN) || ISDAMTYPE(damtype, DAM_CLONE)

//Whether the damage type flag can be considered a potential edged weapon (AKA, if it could be used to de-limb)
/proc/IsDamageTypeEdged(var/damtype)
	return ISDAMTYPE(damtype, DAM_CUT)

//Whether the damage type flag can be considered a potential edged weapon (AKA, if it could be used to de-limb)
/proc/IsDamageTypeSharp(var/damtype)
	return ISDAMTYPE(damtype, DAM_CUT) || ISDAMTYPE(damtype, DAM_PIERCE)

//Whether or not the given item counts as sharp in terms of dealing damage
/proc/is_sharp(obj/O as obj)
	return O? ISDAMTYPE(O.damtype, DAM_CUT) || O.sharpness : 0

//Whether or not the given item counts as cutting with an edge in terms of removing limbs
/proc/has_edge(obj/O as obj)
	return O? O.mass >= DT_EDGE_MASS_THRESHOLD && ISDAMTYPE(O.damtype, DAM_CUT) : 0

//
// Puncture stuff
//
/obj/item/weapon/tool/screwdriver/can_puncture()
	return 1

/obj/item/weapon/pen/can_puncture()
	return 1

/obj/item/weapon/tool/weldingtool/can_puncture()
	return 1

/obj/item/weapon/tool/screwdriver/can_puncture()
	return 1

/obj/item/weapon/shovel/can_puncture() //includes spades
	return 1

/obj/item/weapon/flame/can_puncture()
	return src.lit

/obj/item/clothing/mask/smokable/cigarette/can_puncture()
	return src.lit
