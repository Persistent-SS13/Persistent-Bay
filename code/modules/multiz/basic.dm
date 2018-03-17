GLOBAL_VAR_CONST(HIGHEST_CONNECTABLE_ZLEVEL_INDEX, 27)

var/list/z_level_connections
/obj/effect/landmark/map_data/New()
	..()
	if(height == 1) return
	if(!z_level_connections)
		z_level_connections = list()
	ASSERT(height <= z)
	ASSERT(height + z - 1 <= world.maxz)
	for(var/i = z - height + 2, i <= z, i++)
		ConnectLowerZ(i)

/proc/ConnectLowerZ(var/z)
	if(!z_level_connections)
		z_level_connections = list()
	z_level_connections["[z]"] |= DOWN
	z_level_connections["[z - 1]"] |= UP

/proc/DisconnectLowerZ(var/z)
	if(!z_level_connections) return
	z_level_connections["[z]"] &= DOWN
	z_level_connections["[z - 1]"] &= UP

/proc/HasAbove(var/z)
	if(!z_level_connections) return 0
	return z_level_connections["[z]"] & UP

/proc/HasBelow(var/z)
	if(!z_level_connections) return 0
	return z_level_connections["[z]"] & DOWN

// Thankfully, no bitwise magic is needed here.
/proc/GetAbove(var/atom/atom)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return null
	return HasAbove(turf.z) ? get_step(turf, UP) : null

/proc/GetBelow(var/atom/atom)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return null
	return HasBelow(turf.z) ? get_step(turf, DOWN) : null

/proc/GetConnectedZlevels(var/z)
	. = list(z)
	for(var/level = z, HasBelow(level), level--)
		. |= level-1
	for(var/level = z, HasAbove(level), level++)
		. |= level+1

/proc/AreConnectedZLevels(var/zA, var/zB)
	return zA == zB || (zB in GetConnectedZlevels(zA))

/proc/get_zstep(ref, dir)
	if(dir == UP)
		. = GetAbove(ref)
	else if (dir == DOWN)
		. = GetBelow(ref)
	else
		. = get_step(ref, dir)

