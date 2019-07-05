#define CALIBER_556MM            "5.56mm"
#define CALIBER_762MM            "7.62mm"
#define CALIBER_9MM              "9mm"
#define CALIBER_10MM             "10mm"
#define CALIBER_145MM            "14.5mm"
#define CALIBER_20MM             "20mm"
#define CALIBER_22LR             ".22lr"
#define CALIBER_223              ".223"
#define CALIBER_357              ".357"
#define CALIBER_38               ".38"
#define CALIBER_44               ".44"
#define CALIBER_45               ".45"
#define CALIBER_50               ".50"
#define CALIBER_12G              "12g"

#define CALIBER_PISTOL           CALIBER_45
#define CALIBER_PISTOL_SMALL     CALIBER_9MM
#define CALIBER_PISTOL_MAGNUM    CALIBER_357
#define CALIBER_PISTOL_FLECHETTE "4mm"
#define CALIBER_PISTOL_ANTIQUE   "~10mm"
#define CALIBER_RIFLE            CALIBER_762MM
#define CALIBER_RIFLE_MILITARY   CALIBER_556MM
#define CALIBER_ANTIMATERIAL     CALIBER_145MM

#define CALIBER_SHOTGUN          CALIBER_12G //Typically 12G
#define CALIBER_GYROJET          "gyrojet"
#define CALIBER_CAPS             "caps"
#define CALIBER_DART             "darts"
#define CALIBER_40MM_ROCKET      "40mm_rocket"

#define HOLD_CASINGS	0 //do not do anything after firing. Manual action, like pump shotguns, or guns that want to define custom behaviour
#define CLEAR_CASINGS	1 //clear chambered so that the next round will be automatically loaded and fired, but don't drop anything on the floor
#define EJECT_CASINGS	2 //drop spent casings on the ground after firing
#define CYCLE_CASINGS	3 //cycle casings, like a revolver. Also works for multibarrelled guns

//Gun loading types
#define SINGLE_CASING 	1	//The gun only accepts ammo_casings. ammo_magazines should never have this as their mag_type.
#define SPEEDLOADER 	2	//Transfers casings from the mag to the gun when used.
#define MAGAZINE 		4	//The magazine item itself goes inside the gun


#define GUN_BULK_RIFLE  5