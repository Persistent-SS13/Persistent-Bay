/obj/item/weapon/basketball
	icon = 'icons/obj/basketball.dmi'
	icon_state = "basketball"
	name = "basketball"
	item_state = "basketball"
	density = 0
	anchored = 0
	w_class = ITEM_SIZE_HUGE
	force = 0.0
	throwforce = 0.0
	throw_speed = 1
	throw_range = 20
	obj_flags = OBJ_FLAG_CONDUCTIBLE

// Enables auto-throwing on click, doesn't work with a_intent dunking.
//	afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
//		user.drop_item()
//		src.throw_at(target, throw_range, throw_speed, user)

/obj/item/weapon/basketball/attackby(obj/item/W as obj, mob/user as mob)
	if(isWelder(W))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.remove_fuel(1,user))
			playsound(loc, 'sound/items/Welder.ogg', 50, 1)
			to_chat(user, "<span class='notice'>You begin to melt \the [src]...</span>")
			if (do_after(user, 10, src))
				playsound(loc, 'sound/items/Welder2.ogg', 50, 1)
				user.visible_message( \
					"<span class='notice'>\The [user] melts \the [src].</span>", \
					"<span class='notice'>You have melted \the [src].</span>")
				new /obj/item/stack/material/plastic( user.loc, 2 )
				qdel(src)
				return
	else
		..()


/obj/structure/basketballhoop
	name = "folded basketball hoop"
	desc = "A basketball goal thats been folded up for storage."
	icon = 'icons/obj/basketball.dmi'
	icon_state = "hoop_folded"
	anchored = 0
	density = 1
	throwpass = 1

/obj/structure/basketballhoop/attackby(obj/item/W as obj, mob/user as mob)
	if(!anchored)
		if(isWrench(W))
			for(var/obj/structure/basketballhoop/deployed/H in orange(2, src)) // Prevents deploying hoops too closely togather.
				to_chat(user, "<span class='notice'>There's already a basketball goal nearby, spread them further apart.</span>")
				return

			playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
			if(do_after(user, 20, src))
				to_chat(user, "<span class='notice'>[user] sets up the basketball hoop.</span>")
				new /obj/structure/basketballhoop/deployed(loc)
				qdel(src)
				return

		if(isWelder(W))
			var/obj/item/weapon/weldingtool/WT = W

			if(WT.remove_fuel(5,user))
				playsound(loc, 'sound/items/Welder.ogg', 50, 1)
				to_chat(user, "<span class='notice'>You begin to unweld \the [src]...</span>")
				if (do_after(user, 40, src))
					playsound(loc, 'sound/items/Welder2.ogg', 50, 1)
					user.visible_message( \
						"<span class='notice'>\The [user] unwelds \the [src].</span>", \
						"<span class='notice'>You have unwelded \the [src].</span>", \
						"You hear a ratchet.")
					new /obj/item/stack/material/steel(loc, 10)
					qdel(src)
					return
		else
			..()


/obj/structure/basketballhoop/deployed
	name = "basketball hoop"
	desc = "A hoop for playing the ancient sport of basketball."
	icon = 'icons/obj/basketball.dmi'
	icon_state = "hoop"
	anchored = 1
	density = 1
	throwpass = 1

/obj/structure/basketballhoop/deployed/proc/roller(var/obj/item/weapon/basketball/Q) //Could be edited to make the ball move further or roll realistically, but this is fine for now.
	if(istype(Q))
		sleep(5)
		step_away(Q,src,2)
		return


/obj/structure/basketballhoop/deployed/attackby(obj/item/W as obj, mob/user as mob)

	if(isWrench(W))
		playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, 20, src))
			to_chat(user, "<span class='notice'>[user] uses [W] to carefully fold up [src].</span>")
			new /obj/structure/basketballhoop(loc)
			qdel(src)
			return

	else if(isCrowbar(W))
		playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
		to_chat(user, "<span class='notice'>[user] uses [W] to rotate [src].</span>")
		src.set_dir(turn(src.dir,90))
		return

	else
		if (istype(W) && (get_dist(src,user)<2) && (user.a_intent == I_HURT)) // If the user is nearby and on harm intent they'll attempt to dunk.

			if(prob(20))
				user.do_attack_animation(src)
				user.drop_item()
				playsound(loc, 'sound/weapons/towelwhip.ogg', 90, 1)
				visible_message("<span class='notice'>[user] attempts to dunk the [W] into [src] but loses their grip!</span>")
				roller(W)
				return

			else if(prob(5))
				var/mob/living/carbon/human/H = user
				user.do_attack_animation(src)
				user.drop_item()
				user.Weaken(3)
				H.apply_damage(rand(10,20),BRUTE)
				new /obj/effect/decal/cleanable/blood/drip(user.loc)
				playsound(loc, 'sound/weapons/punch4.ogg', 30, 1)
				visible_message("<span class='bad'>[user] attempts to dunk [W] into [src], but flounders mid-air!</span>")
				visible_message("<span class='bad'>[user] hits the ground hard!</span>")
				roller(W)
				return

			else
				user.do_attack_animation(src)
				user.drop_item()
				W.loc = src.loc
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 100, 1)
				visible_message("<span class='good'>[user] dunks [W] into [src]!</span>")
				sleep(3)
				roller(W)
				return


/obj/structure/basketballhoop/deployed/CanPass(atom/movable/mover, turf/target, mob/user as mob, height=0, air_group=0)
	var/obj/item/I = mover
	if (istype(I) && (get_dist(src,user)>=2))

		if(istype(I, /obj/item/projectile))
			return

		else if(prob(60))
			I.loc = src.loc
			playsound(loc, 'sound/weapons/thudswoosh.ogg', 100, 1)
			visible_message("<span class='good'>Swish! \The [I] lands in \the [src]!</span>", 3)
			sleep(3)
			roller(I)
			return

		else
			playsound(loc, 'sound/effects/bang.ogg', 50, 1)
			visible_message("<span class='notice'>\The [I] bounces off \the [src]'s rim!</span>", 3)
			roller(I)
			return 0

	else
		return ..(mover, target, height, air_group)
