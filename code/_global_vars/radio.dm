// These globals are the worst

GLOBAL_LIST_INIT(default_medbay_channels, list(
	num2text(PUB_FREQ) = list(),
	num2text(MED_FREQ) = list(access_medical_equip),
	num2text(MED_I_FREQ) = list(access_medical_equip)
))

GLOBAL_LIST_INIT(default_sec_channels, list(
	num2text(PUB_FREQ) = list(),
	num2text(SEC_FREQ) = list(access_security),
	num2text(SEC_I_FREQ) = list(access_security)
))