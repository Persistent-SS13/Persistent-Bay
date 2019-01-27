/*
One design at time
upload to machine via card
research points specific (physics, biology, etc)
use research points to create upload card
no research copying.

So we unlock one design at a time via target specific research points (physics, biology, etc). These can then be spent to create a design card that can be uploaded to one lathe. Research can't be copied.
*/
#define RESEARCH_CATEGORY_PART "Machine Part"

/datum/researchDesign
	var/name = null
	var/desc = null
	var/category = null
	var/buildPath = null
	var/buildTime = 10
	var/sortString = "ZZZZZ"

	var/list/materials = list()
	var/list/chemicals = list()
	var/list/techPoints = list()
