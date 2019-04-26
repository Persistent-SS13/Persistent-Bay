#define isWrench(A)      (A && A.iswrench())
#define isWelder(A)      (A && A.iswelder())
#define isCoil(A)        (A && A.iscoil())
#define isWirecutter(A)  (A && A.iswirecutter())
#define isScrewdriver(A) (A && A.isscrewdriver())
#define isMultitool(A)   (A && A.ismultitool())
#define isCrowbar(A)     (A && A.iscrowbar())
#define isScissors(A)    (A && A.isscissors())

/atom/proc/iswrench()
	return FALSE

/atom/proc/iswelder()
	return FALSE

/atom/proc/iscoil()
	return FALSE

/atom/proc/iswirecutter()
	return FALSE

/atom/proc/isscrewdriver()
	return FALSE

/atom/proc/ismultitool()
	return FALSE

/atom/proc/iscrowbar()
	return FALSE

/atom/proc/isscissors()
	return FALSE


/obj/item/weapon/tool/wrench/iswrench()
	return TRUE

/obj/item/weapon/tool/weldingtool/iswelder()
	return TRUE

/obj/item/stack/cable_coil/iscoil()
	return TRUE

/obj/item/weapon/tool/wirecutters/iswirecutter()
	return TRUE

/obj/item/weapon/tool/screwdriver/isscrewdriver()
	return TRUE

/obj/item/device/multitool/ismultitool()
	return TRUE

/obj/item/weapon/tool/crowbar/iscrowbar()
	return TRUE

/obj/item/weapon/tool/scissors/isscissors()
	return TRUE
