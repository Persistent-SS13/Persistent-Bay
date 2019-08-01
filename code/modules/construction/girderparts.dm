/obj/item/girderpart
	name = "girder parts"
	desc = "Parts to quickly build a girder"
	icon = 'icons/obj/structures.dmi'
	icon_state = "girder_p"
	item_state = "girder_p"
	w_class = ITEM_SIZE_LARGE
	var/material/material

/obj/item/girderpart/New(var/newLoc, var/material_name)
	..()
	if(!material_name)
		material_name = DEFAULT_WALL_MATERIAL
	material = SSmaterials.get_material_by_name(material_name)
	
/obj/item/girderpart/Initialize()
	if(!material)
		material = DEFAULT_WALL_MATERIAL
	if(istext(material))
		material = SSmaterials.get_material_by_name(material)
	. = ..()
	queue_icon_update()
	
/obj/item/girderpart/on_update_icon()
	if(material)
		SetName("[material.display_name] [initial(name)]")
		color = material.icon_colour
	. = ..()

/obj/item/girderpart/Write(savefile/f)
	// Save the material name instead. Initialize will load it.
	if(material)
		to_file(f["material"], material.name)
	. = ..()

/obj/item/girderpart/Read(savefile/f)
	var/material/mat
	from_file(f["material"], mat)
	if(istype(mat, /material))
		material = mat.name
	else if(istext(mat))
		material = mat

	//backward compat, remove after server save is updated!
	var/smat
	from_file(f["saved_material"], smat)
	if(istext(smat))
		material = smat

	. = ..()	

/obj/item/girderpart/attack_self(var/user)
	new /obj/structure/girder(get_turf(src), material)
	qdel(src)