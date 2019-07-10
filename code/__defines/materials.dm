#define MATERIAL_PLASTIC                 "plastic"
#define MATERIAL_PLASTEEL                "plasteel"
#define MATERIAL_STEEL                   "steel"
#define MATERIAL_GLASS                   "glass"
#define MATERIAL_GOLD                    "gold"
#define MATERIAL_SILVER                  "silver"
#define MATERIAL_DIAMOND                 "diamond"
#define MATERIAL_PHORON                  "phoron"
#define MATERIAL_URANIUM                 "uranium"
#define MATERIAL_COTTON                  "cotton"
#define MATERIAL_CRYSTAL                 "crystal"
#define MATERIAL_SANDSTONE               "sandstone"
#define MATERIAL_LEATHER                 "leather"
#define MATERIAL_IRON                    "iron"
#define MATERIAL_PLATINUM                "platinum"
#define MATERIAL_BRONZE                  "bronze"
#define MATERIAL_REINFORCED_GLASS        "rglass"
#define MATERIAL_PHORON_GLASS            "phglass"
#define MATERIAL_REINFORCED_PHORON_GLASS "rphglass"
#define MATERIAL_MARBLE                  "marble"
#define MATERIAL_RESIN                   "resin"
#define MATERIAL_CULT                    "cult"
#define MATERIAL_REINFORCED_CULT         "cult2"
#define MATERIAL_VOX                     "voxalloy"
#define MATERIAL_TITANIUM                "titanium"
#define MATERIAL_RUTILE					 "rutile"
#define MATERIAL_OSMIUM_CARBIDE_PLASTEEL "osmium-carbide plasteel"
#define MATERIAL_OSMIUM                  "osmium"
#define MATERIAL_HYDROGEN                "hydrogen"
#define MATERIAL_WASTE                   "waste"
#define MATERIAL_SLAG                    "slag" //Waste product of smelting
#define MATERIAL_ELEVATORIUM             "elevatorium"
#define MATERIAL_ALIENALLOY              "aliumium"
#define MATERIAL_SAND                    "sand"
#define MATERIAL_GRAPHITE                "graphite"
#define MATERIAL_DEUTERIUM               "deuterium"
#define MATERIAL_TRITIUM                 "tritium"
#define MATERIAL_SUPERMATTER             "supermatter"
#define MATERIAL_QUARTZ                  "quartz"
#define MATERIAL_PYRITE                  "pyrite"
#define MATERIAL_SPODUMENE               "spodumene"
#define MATERIAL_CINNABAR                "cinnabar"
#define MATERIAL_PHOSPHORITE             "phosphorite"
#define MATERIAL_ROCK_SALT               "rock salt"
#define MATERIAL_COPPER                  "copper"
#define MATERIAL_CARDBOARD               "cardboard"
#define MATERIAL_CLOTH                   "cloth"
#define MATERIAL_CARPET                  "carpet"
#define MATERIAL_ALUMINIUM               "aluminium"
#define MATERIAL_NULLGLASS               "nullglass"
#define MATERIAL_TUNGSTEN                "tungsten"
#define MATERIAL_TIN                     "tin"
#define MATERIAL_ZINC                    "zinc"
#define MATERIAL_BRASS                   "brass"
#define MATERIAL_LEAD                    "lead"
#define MATERIAL_SULFUR                  "sulfur"
#define MATERIAL_BSPACE_CRYSTAL          "bluespace crystal"
#define MATERIAL_FIBERGLASS              "fiberglass"
#define MATERIAL_GRAPHENE                "graphene"
#define MATERIAL_BORON                   "boron"
#define MATERIAL_BEESWAX                 "beeswax"
#define MATERIAL_PINK_GOO                "pink goo"

//ORES
#define MATERIAL_TETRAHEDRITE            "tetrahedrite"
#define MATERIAL_BOHMEITE                "bohmeite"
#define MATERIAL_FREIBERGITE             "freibergite"
#define MATERIAL_ILMENITE                "ilmenite"
#define MATERIAL_GALENA                  "galena"
#define MATERIAL_CASSITERITE             "cassiterite"
#define MATERIAL_SPHALERITE              "sphalerite"
#define MATERIAL_POTASH                  "potash"
#define MATERIAL_BAUXITE                 "bauxite"
#define MATERIAL_PITCHBLENDE             "pitchblende"
#define MATERIAL_HEMATITE                "hematite"

//ICES
#define MATERIAL_ICES_WATER              "water ice"
#define MATERIAL_ICES_NITROGEN           "nitrogen ice"
#define MATERIAL_ICES_AMONIA             "amonia ice"
#define MATERIAL_ICES_HYDROGEN           "hydrogen ice"
#define MATERIAL_ICES_SULFUR_DIOXIDE     "sulfur dioxide ice"
#define MATERIAL_ICES_CARBON_DIOXIDE     "carbon dioxide ice"
#define MATERIAL_ICES_METHANE            "methane ice"
#define MATERIAL_ICES_ACETONE            "acetone ice"

//woods
#define MATERIAL_WOOD                    "wood"
#define MATERIAL_MAHOGANY                "mahogany"
#define MATERIAL_MAPLE                   "maple"
#define MATERIAL_EBONY                   "ebony"
#define MATERIAL_WALNUT                  "walnut"
#define MATERIAL_BAMBOO                  "bamboo"


#define DEFAULT_TABLE_MATERIAL MATERIAL_PLASTIC
#define DEFAULT_WALL_MATERIAL  MATERIAL_STEEL
#define DEFAULT_FURNITURE_MATERIAL MATERIAL_ALUMINIUM
#define SHEET_MATERIAL_AMOUNT 4000

#define MATERIAL_ALTERATION_NONE 0
#define MATERIAL_ALTERATION_NAME 1
#define MATERIAL_ALTERATION_DESC 2
#define MATERIAL_ALTERATION_COLOR 4
#define MATERIAL_ALTERATION_ALL (~MATERIAL_ALTERATION_NONE)

#define SHARD_SHARD "shard"
#define SHARD_SHRAPNEL "shrapnel"
#define SHARD_STONE_PIECE "piece"
#define SHARD_SPLINTER "splinters"
#define SHARD_NONE ""

#define MATERIAL_UNMELTABLE 0x1
#define MATERIAL_BRITTLE    0x2
#define MATERIAL_PADDING    0x4

#define TABLE_BRITTLE_MATERIAL_MULTIPLIER 4 // Amount table damage is multiplied by if it is made of a brittle material (e.g. glass)

//Stack flags
#define USE_MATERIAL_COLOR 				0x1
#define USE_MATERIAL_SINGULAR_NAME    	0x2
#define USE_MATERIAL_PLURAL_NAME    	0x4

//Material dust defines
#define DUST_MATERIAL_AMOUNT 100 //Each pile of dust is 100 units of matter

