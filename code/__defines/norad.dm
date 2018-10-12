// Defines for the no radio embedded solution for airlock cyclers. Made with the embedded_controller's (some) logic and template
#define NORAD_MAX_RANGE              5  //Max range for No radio airlock controllers' effectiveness

#define NORAD_STATE_IDLE			 0
#define NORAD_STATE_PREPARE          1
#define NORAD_STATE_DEPRESSURIZE     2
#define NORAD_STATE_PRESSURIZE       3

#define NORAD_TARGET_NONE            0
#define NORAD_TARGET_INOPEN         -1
#define NORAD_TARGET_OUTOPEN        -2
