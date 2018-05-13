/obj/item/girderpart
	name = "girder parts"
	desc = "Parts to quickly build a girder"
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	item_state = "cell"
	w_class = ITEM_SIZE_LARGE
	
	var/material
	var/r_material

/obj/item/girderpart/New(var/newloc, var/mat, var/r_mat)
	material = mat
	r_material = r_mat

/obj/item/girderpart/attack_self(var/user)
	new /obj/structure/girder(get_turf(src), material, r_material)
	qdel(src)