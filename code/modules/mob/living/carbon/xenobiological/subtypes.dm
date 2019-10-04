/mob/living/carbon/slime/proc/GetMutations()
	switch(src.colour)
		if("grey")
			return list("orange", "blue", "purple", "grey")
		if("purple")
			return list("dark blue", "silver", "purple")
		if("orange")
			return list("yellow", "red", "sepia", "orange")
		if("blue")
			return list("dark blue", "silver", "pink", "blue")
		//Tier 3
		if("dark blue")
			return list("purple", "cerulean", "blue", "dark blue")
		if("yellow")
			return list("orange", "yellow")
		if("silver")
			return list("gold", "pyrite", "blue", "silver")
		//Tier 4
		if("pink")
			return list("pink", "light pink")
		if("red")
			return list("red", "orange")
		if("gold")
			return list("gold", "silver")
		//if("green")
			//return list("green", "grey")
		// Tier 5
		else
			return list("grey")

/mob/living/carbon/slime/proc/GetCoreType()
	switch(src.colour)
		// Tier 1
		if("grey")
			return /obj/item/slime_extract/grey
		// Tier 2
		if("purple")
			return /obj/item/slime_extract/purple
		if("metal")
			return /obj/item/slime_extract/metal
		if("orange")
			return /obj/item/slime_extract/orange
		if("blue")
			return /obj/item/slime_extract/blue
		// Tier 3
		if("dark blue")
			return /obj/item/slime_extract/darkblue
		if("dark purple")
			return /obj/item/slime_extract/darkpurple
		if("yellow")
			return /obj/item/slime_extract/yellow
		if("silver")
			return /obj/item/slime_extract/silver
		// Tier 4
		if("pink")
			return /obj/item/slime_extract/pink
		if("red")
			return /obj/item/slime_extract/red
		if("gold")
			return /obj/item/slime_extract/gold
		//if("green")
			//return /obj/item/slime_extract/green
		if("sepia")
			return /obj/item/slime_extract/sepia
		if("bluespace")
			return /obj/item/slime_extract/bluespace
		if("cerulean")
			return /obj/item/slime_extract/cerulean
		if("pyrite")
			return /obj/item/slime_extract/pyrite
		//Tier 5
		if("light pink")
			return /obj/item/slime_extract/lightpink
		//if("oil")
			//return /obj/item/slime_extract/oil
		if("adamantine")
			return /obj/item/slime_extract/adamantine
		//if("black")
			//return /obj/item/slime_extract/black
	return /obj/item/slime_extract/grey
