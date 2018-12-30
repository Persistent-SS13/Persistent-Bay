//This proc returns whether a damage type is considered "Brute" damage. Mainly for organ handling.
/proc/IsDamageTypeBrute(var/damtype)
	return cmpdamtype(damtype, DAM_BLUNT) || cmpdamtype(damtype, DAM_CUT) || cmpdamtype(damtype, DAM_PIERCE) || cmpdamtype(damtype, DAM_BULLET)

//This proc returns whether a damage type is considered "Burn" damage. Mainly for organ handling.
/proc/IsDamageTypeHeat(var/damtype)
	return cmpdamtype(damtype, DAM_BURN) || cmpdamtype(damtype, DAM_LASER) || cmpdamtype(damtype, DAM_ENERGY) || cmpdamtype(damtype, DAM_BOMB)

//Whether the damage type has effect on a physical object (AKA things that would hurt say a chair)
/proc/IsDamageTypePhysical(var/damtype)
	return IsDamageTypeBrute(damtype) || IsDamageTypeHeat(damtype)

//Whether the damage type has more of a non-physical/internal effect.. (AKA things that wouldn't hurt say a chair)
/proc/IsDamageTypeNonPhysical(var/damtype)
	return cmpdamtype(damtype, DAM_EMP) || cmpdamtype(damtype, DAM_BIO) || cmpdamtype(damtype, DAM_RADS) || cmpdamtype(damtype, DAM_STUN) ||\
		cmpdamtype(damtype, DAM_PAIN) || cmpdamtype(damtype == DAM_CLONE)

//Convert damage type to organ effects. Should be removed once organs are made to use the new damage type properly
/proc/DamageTypeToOrganEffect(var/damtype)
	switch(damtype)
		if(DAM_BLUNT)
			. = BRUISE
		if(DAM_BULLET)
			. = PIERCE
		if(DAM_BOMB, DAM_ENERGY)
			. = BURN
		if(DAM_CUT, DAM_PIERCE, DAM_LASER, DAM_BURN)
			. = damtype //Those are already known organ effects
		else
			. = null //The rest are ignored, or handled differently
	return .

//Used to abstract comparison between damage types.. So changing what the constants contains isn't such a pain in the ass..
/proc/cmpdamtype(var/dtype1, var/dtype2)
	return dtype1 & dtype2

//Whether the damage type flag can be considered a potential edged weapon (AKA, if it could be used to de-limb)
/proc/IsDamageTypeEdged(var/damtype)
	return cmpdamtype(damtype, DAM_CUT)

//Whether the damage type flag can be considered a potential edged weapon (AKA, if it could be used to de-limb)
/proc/IsDamageTypeSharp(var/damtype)
	return cmpdamtype(damtype, DAM_CUT) || cmpdamtype(damtype, DAM_PIERCE)

//Whether or not the given item counts as sharp in terms of dealing damage
/proc/is_sharp(obj/O as obj)
	return O? cmpdamtype(O.damtype, DAM_CUT) || O.sharpness : 0

//Whether or not the given item counts as cutting with an edge in terms of removing limbs
/proc/has_edge(obj/O as obj)
	return O? O.mass >= DT_EDGE_MASS_THRESHOLD && cmpdamtype(O.damtype, DAM_CUT) : 0



/obj/item/weapon/screwdriver/can_puncture()
	return 1

/obj/item/weapon/pen/can_puncture()
	return 1

/obj/item/weapon/weldingtool/can_puncture()
	return 1

/obj/item/weapon/screwdriver/can_puncture()
	return 1

/obj/item/weapon/shovel/can_puncture() //includes spades
	return 1

/obj/item/weapon/flame/can_puncture()
	return src.lit

/obj/item/clothing/mask/smokable/cigarette/can_puncture()
	return src.lit
