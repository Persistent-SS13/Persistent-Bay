/obj/structure/bed/chair/e_chair
	name = "electric chair"
	desc = "Looks absolutely SHOCKING!"
	icon = 'icons/obj/structures/echair.dmi'
	icon_state = "echair0"
	base_icon = "echair0"
	max_health = 150
	var/on = 0
	var/obj/item/assembly/shock_kit/part = null
	var/last_time = 1.0

/obj/structure/bed/chair/e_chair/New()
	..()
	ADD_SAVED_VAR(on)
	ADD_SAVED_VAR(part)

/obj/structure/bed/chair/e_chair/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(isWrench(W))
		var/obj/structure/bed/chair/C = new /obj/structure/bed/chair(loc)
		playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
		C.set_dir(dir)
		part.dropInto(loc)
		part.master = null
		part = null
		qdel(src)
		return
	return ..()

/obj/structure/bed/chair/e_chair/verb/toggle()
	set name = "Toggle Electric Chair"
	set category = "Object"
	set src in oview(1)

	if(on)
		on = 0
	else
		on = 1
	to_chat(usr, "<span class='notice'>You switch [on ? "on" : "off"] [src].</span>")
	update_icon()
	return

/obj/structure/bed/chair/e_chair/rotate()
	..()
	update_icon()

/obj/structure/bed/chair/e_chair/on_update_icon()
	..()
	if(on)	icon_state = "echair0"
	else	icon_state = "echair1"
	icon_state = "echair0"
	overlays.Cut()
	overlays += image(icon, src, "echair_over", MOB_LAYER + 1, dir)	//there's probably a better way of handling this, but eh. -Pete

/obj/structure/bed/chair/e_chair/proc/shock()
	if(!on)
		return
	if(last_time + 50 > world.time)
		return
	last_time = world.time

	// special power handling
	var/area/A = get_area(src)
	if(!isarea(A))
		return
	if(!A.powered(EQUIP))
		return
	A.use_power_oneoff(5000, EQUIP)
	var/light = A.power_light
	A.update_icon()

	flick("echair1", src)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(12, 1, src)
	s.start()
	if(buckled_mob)
		buckled_mob.burn_skin(85)
		to_chat(buckled_mob, "<span class='danger'>You feel a deep shock course through your body!</span>")
		sleep(1)
		buckled_mob.burn_skin(85)
		buckled_mob.Stun(600)
	visible_message("<span class='danger'>The electric chair went off!</span>", "<span class='danger'>You hear a deep sharp shock!</span>")

	A.power_light = light
	A.update_icon()
	update_icon()
	return
