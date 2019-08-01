#define FOR_DVIEW(type, range, center, invis_flags) \
	if(!GLOB.dview_mob) GLOB.dview_mob = new;\
	GLOB.dview_mob.loc = center; \
	GLOB.dview_mob.see_invisible = invis_flags; \
	for(type in view(range, GLOB.dview_mob))

#define END_FOR_DVIEW dview_mob.loc = null

#define LIGHTING_ICON 'icons/effects/lighting_overlay.dmi' // icon used for lighting shading effects
#define LIGHTING_ICON_STATE_DARK "dark" // Change between "soft_dark" and "dark" to swap soft darkvision

#define LIGHTING_ROUND_VALUE (1 / 64) // Value used to round lumcounts, values smaller than 1/69 don't matter (if they do, thanks sinking points), greater values will make lighting less precise, but in turn increase performance, VERY SLIGHTLY.

#define LIGHTING_SOFT_THRESHOLD 0 // If the max of the lighting lumcounts of each spectrum drops below this, disable luminosity on the lighting overlays.  This also should be the transparancy of the "soft_dark" icon state.

#define LIGHTING_MULT_FACTOR 0.9

// If I were you I'd leave this alone.
#define LIGHTING_BASE_MATRIX \
	list                     \
	(                        \
		LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, 0, \
		LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, 0, \
		LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, 0, \
		LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, 0, \
		0, 0, 0, 1           \
	)

// Lighting temperatures.
#define COLOUR_LTEMP_CANDLE        rgb(255, 147, 41)
#define COLOUR_LTEMP_40W_TUNGSTEN  rgb(255, 197, 143)
#define COLOUR_LTEMP_100W_TUNGSTEN rgb(255, 214, 170)
#define COLOUR_LTEMP_HALOGEN       rgb(255, 241, 224)
#define COLOUR_LTEMP_CARBON_ARC    rgb(255, 250, 244)
#define COLOUR_LTEMP_HIGHNOON      rgb(255, 255, 251)
#define COLOUR_LTEMP_SUNLIGHT      rgb(255, 255, 255)
#define COLOUR_LTEMP_SKY_OVERCAST  rgb(201, 226, 255)
#define COLOUR_LTEMP_SKY_CLEAR     rgb(64, 156, 255)
#define COLOUR_LTEMP_FLURO_WARM    rgb(255, 244, 229)
#define COLOUR_LTEMP_FLURO         rgb(244, 255, 250)
#define COLOUR_LTEMP_FLURO_COOL    rgb(212, 235, 255)
#define COLOUR_LTEMP_FLURO_FULL    rgb(255, 244, 242)
#define COLOUR_LTEMP_FLURO_GROW    rgb(255, 239, 247)
#define COLOUR_LTEMP_BLACKLIGHT    rgb(167, 0, 255)
