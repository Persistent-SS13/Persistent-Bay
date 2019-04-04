#define DAM_BLUNT       BRUISE			//Blunt impact damage
#define DAM_CUT         CUT				//Generic cutting damage
#define DAM_PIERCE      PIERCE			//Low energy piercing damage
#define DAM_BULLET      "bullet"		//High energy missile pierce damage
#define DAM_LASER       LASER			//Focused high energy damage
#define DAM_ENERGY      "energy"		//Generic energy exposure damage
#define DAM_EMP         "emp"			//Electro magnetic damage
#define DAM_BURN        BURN			//Generic heat exposure damage
#define DAM_BOMB        "bomb"			//Explosion exposure damage
#define DAM_RADS        "rad"			//Ionizing radiation exposure damage
#define DAM_SHATTER		"shatter"		//

//Damage affecting biological entities
#define DAM_BIO         TOX				//Acid and toxin exposure damage
#define DAM_STUN        STUN			//Stun damage, generic stun inducing damage
#define DAM_PAIN        PAIN			//Pain damage
#define DAM_CLONE       CLONE			//Genetic damage
#define DAM_OXY         OXY				//Oxygen deprivation damage
#define DAM_ELECTRIC    ELECTROCUTE		//Electrocution damage

#define DT_EDGE_MASS_THRESHOLD 1.0 //An object with a DAM_CUT damage type has to weight at least this much to be considered an edged weapon
#define DT_EDGE_DMG_THRESHOLD  20  //An object with a DAM_CUT damage type has to do at least this much damage to be considered an edged weapon

//Made this because I kept changing between strings and bitflags for damage types. Thought it might help make things 
// future proof when comparing damage types
#define ISDAMTYPE(X,Y) (X == Y)	//Used to conpare damage types, without caring what the constants are, or if they're bundled together as a bitflag.

//Check if the damage can affect only mobs
#define IS_MOBONLY_DAMAGE(X) (X == DAM_BIO || X == DAM_STUN || X == DAM_PAIN || X == DAM_CLONE || X == DAM_OXY || X == DAM_ELECTRIC)
#define DAMAGE_AFFECT_OBJ(X) !IS_MOBONLY_DAMAGE(X)
#define DAMAGE_AFFECT_MOB(X) X != DAM_EMP
