#define DAM_BLUNT   BRUISE			//Blunt impact damage
#define DAM_CUT     CUT					//Generic cutting damage
#define DAM_PIERCE  PIERCE			//Low energy piercing damage
#define DAM_BULLET  "bullet"		//High energy missile pierce damage
#define DAM_LASER   LASER				//Focused high energy damage
#define DAM_ENERGY  "energy"		//Generic energy exposure damage
#define DAM_EMP     "emp"				//Electro magnetic damage
#define DAM_BURN    BURN				//Generic heat exposure damage
#define DAM_BOMB    "bomb"			//Explosion exposure damage
#define DAM_BIO	    "bio"				//Acid and pathogen exposure damage
#define DAM_RADS    "rad"				//Ionizing radiation exposure damage
#define DAM_STUN    STUN				//Stun damage, generic stun inducing damage
#define DAM_PAIN    PAIN				//Pain damage
#define DAM_CLONE   CLONE				//Genetic damage

// #define DAM_BLUNT   0x0001				//Blunt impact damage
// #define DAM_CUT     0x0002				//Generic cutting damage
// #define DAM_PIERCE  0x0004				//Low energy piercing damage
// #define DAM_BULLET  0x0008				//High energy missile pierce damage
// #define DAM_LASER   0x0010				//Focused high energy damage
// #define DAM_ENERGY  0x0020				//Generic energy exposure damage
// #define DAM_EMP     0x0040				//Electro magnetic damage
// #define DAM_BURN    0x0080				//Generic heat exposure damage
// #define DAM_BOMB    0x0100				//Explosion exposure damage
// #define DAM_BIO     0x0200				//Acid and pathogen exposure damage
// #define DAM_RADS    0x0400				//Ionizing radiation exposure damage
// #define DAM_STUN    0x0800				//Stun damage, generic stun inducing damage
// #define DAM_PAIN    0x1000				//Pain damage
// #define DAM_CLONE   0x2000				//Genetic damage

#define RESIST_NONE         0		//Use this to represent no resistance or damage threshold for a damage type
#define RESIST_INVULNERABLE 1.#INF	//Use this to represent invulnerability to a damage type

#define DT_EDGE_MASS_THRESHOLD 1.0 //An object with a DAM_CUT damage type has to weight at least this much to be considered an edged weapon
#define DT_EDGE_DMG_THRESHOLD  20  //An object with a DAM_CUT damage type has to do at least this much damage to be considered an edged weapon

//Made this because I kept changing between strings and bitflags for damage types. Thought it might help make things 
// future proof when comparing damage types
#define ISDAMTYPE(X,Y) (X == Y)	//Used to conpare damage types, without caring what the constants are, or if they're bundled together as a bitflag.