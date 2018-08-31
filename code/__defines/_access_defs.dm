#define ACCESS_REGION_NONE -1
#define ACCESS_REGION_ALL 0
#define ACCESS_REGION_SECURITY 1
#define ACCESS_REGION_MEDBAY 2
#define ACCESS_REGION_RESEARCH 3
#define ACCESS_REGION_ENGINEERING 4
#define ACCESS_REGION_COMMAND 5
#define ACCESS_REGION_GENERAL 6
#define ACCESS_REGION_SUPPLY 7

#define ACCESS_TYPE_NONE 1
#define ACCESS_TYPE_CENTCOM 2
#define ACCESS_TYPE_STATION 4
#define ACCESS_TYPE_SYNDICATE 8
#define ACCESS_TYPE_ALL (ACCESS_TYPE_NONE|ACCESS_TYPE_CENTCOM|ACCESS_TYPE_STATION|ACCESS_TYPE_SYNDICATE)

#define core_access_leader 1
#define core_access_command_programs 2
#define core_access_engineering_programs 3
#define core_access_medical_programs 4
#define core_access_security_programs 5
#define core_access_wireless_programs 6
#define core_access_door_configuration 7
#define core_access_order_approval 8
#define core_access_science_programs 9
#define core_access_shuttle_programs 10
