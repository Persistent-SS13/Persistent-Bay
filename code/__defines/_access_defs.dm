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

#define core_access_leader 101
#define core_access_reassignment 102
#define core_access_engineering_programs 103
#define core_access_medical_programs 104
#define core_access_security_programs 105
#define core_access_science_programs 106
#define core_access_shuttle_programs 107
#define core_access_machine_linking 108
#define core_access_network_linking 109
#define core_access_budget_view 110

#define RESIDENT 1
#define CITIZEN 2
#define PRISONER 3


// DEPRECIATED
#define core_access_employee_records 105
#define core_access_invoicing 114
#define core_access_termination 107
#define core_access_door_configuration 112
#define core_access_order_approval 113
#define core_access_command_programs 102
#define core_access_expenses 104
#define core_access_promotion 102

// DEPRECIATED END